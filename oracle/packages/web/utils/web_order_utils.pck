create or replace package web_order_utils is

  -- Author  : ARTEM
  -- Created : 20.04.2023 22:47:11
  -- Purpose : 
  
-- Получаем рассписание боксов с заказами
function get_box_schedules
(
    p_date in date
) return sys_refcursor;

function save_order
(
    p_code     in number,
    p_car_code in number,
    p_status   in varchar2
) return number;

-- Сохраняем сначала заказ, а потом рассписанеи дял него
function save_box_schedule
(
    p_code         in number,
    p_car_box_code in number,
    p_date_start   date,
    p_date_end     date,
    p_car_code     number
) return json_object_t;

function get_height_order_block
(
    p_date_start date,
    p_date_end   date
) return number;
end web_order_utils;
/
create or replace package body web_order_utils is

function get_height_order_block
(
    p_date_start date,
    p_date_end   date
) return number
is
    v_day_start number := extract(day from p_date_start);
    v_day_end   number := extract(day from p_date_end);
    v_hour_start number := extract(hour from cast(p_date_start as timestamp));
    v_hour_end   number := extract(hour from cast(p_date_end as timestamp));
    v_minute_start number := extract(minute from cast(p_date_start as timestamp));
    v_minute_end   number := extract(minute from cast(p_date_end as timestamp));
    v_sum_minutes number;
    v_pixels_per_minute number := 100/30; -- Количество пикселей в одной минуте (для подсчета масштаба)
begin
    if v_day_start - v_day_end = 0 then
        v_sum_minutes := (v_hour_end - v_hour_start) * 60 + v_minute_end - v_minute_start;
        return trunc(v_sum_minutes * v_pixels_per_minute);
    end if;
    --
    v_sum_minutes := (web_app_setting_utils.get_setting_value('workTimeEnd') - v_hour_start) * 60 - v_minute_start;
    return trunc(v_sum_minutes * v_pixels_per_minute);
end get_height_order_block;

-- Получаем рассписание боксов с заказами
function get_box_schedules
(
    p_date in date
)
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        with emty_box_schedule as
        (
            select
                cb.code,
                cb.name,
                cb.description,
                wh.hour,
                wh.minute,
                wh.time_string
            from
                work_hours    wh,
                car_box       cb
        )
        select
            cb.code,
            cb.name,
            cb.description,
            json_arrayagg
            (
                decode
                (
                    bs.code,
                    null,
                    json_object('timeString' value cb.time_string),
                    json_object
                    (
                        'timeString'      value cb.time_string,
                        'hourEnd'         value extract(hour from cast(bs.date_end as timestamp)),
                        'code'            value bs.code,
                        'dateStart'       value to_char(bs.date_start, 'dd.mm.yyyy hh24:mi:ss'),
                        'dateEnd'         value to_char(bs.date_end, 'dd.mm.yyyy hh24:mi:ss'),
                        'timeStart'       value to_char(bs.date_start, 'hh24:mi'),
                        'timeEnd'         value to_char(bs.date_end, 'hh24:mi'),
                        'status'          value o.status,
                        'height'          value get_height_order_block(bs.date_start, bs.date_end),
                        'car' value
                            json_object
                            (
                                'code'     value c.code,
                                'number'   value c.car_number,
                                'brand'    value c.brand,
                                'model'    value c.model
                            ),
                        'client' value
                            json_object
                            (
                                'code'      value cl.code,
                                'fullName'  value cl.full_name
                            )
                    )
                )
                order by
                    cb.hour,
                    cb.minute
                returning clob
            ) as schedule
        from
            emty_box_schedule cb
            left join
                box_schedule bs
                on cb.code  = bs.car_box_code
                and cb.hour = extract(hour from cast(bs.date_start as timestamp))
                and (extract(minute from cast(bs.date_start as timestamp)) - cb.minute) between 0 and 29.999999
                and p_date between trunc(bs.date_start) and trunc(bs.date_end)
            left join
                orders o
                on bs.order_code = o.code
            left join
                car c
                on c.code = o.car_code
            left join
                client cl
                on cl.code = c.client_code
        group by
            cb.code,
            cb.name,
            cb.description;
    return v_result;
end get_box_schedules;

function save_order
(
    p_code     in number,
    p_car_code in number,
    p_status   in varchar2
) return number
is
    v_code number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into orders
        values (v_code, p_car_code, sysdate, p_status);
    else
        v_code := p_code;
        update
            orders t
        set
            t.status = p_status
        where
            t.code = p_code;
    end if;
    return v_code;
end save_order;

-- Сохраняем сначала заказ, а потом рассписанеи дял него
function save_box_schedule
(
    p_code         in number,
    p_car_box_code in number,
    p_date_start   date,
    p_date_end     date,
    p_car_code     number
) return json_object_t
is
    v_code       number := null;
    v_order_code number := null;
    v_result     json_object_t := json_object_t();
begin
    if p_code is null then
        v_order_code := save_order(null, p_car_code, 'В работе');
        v_code := obj_seq.nextval; 
        insert into box_schedule
        values (v_code, p_car_box_code, v_order_code, p_date_start, p_date_end);
    else
        v_code := p_code;
        update
            box_schedule t
        set
            t.date_start = p_date_start,
            t.date_end   = p_date_end
        where
            t.code = p_code;
    end if;
    v_result.put('boxScheduleCode', v_code);
    v_result.put('orderCode', v_order_code);
    return v_result;
end save_box_schedule;
end web_order_utils;
/
