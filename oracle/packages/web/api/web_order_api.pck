create or replace package web_order_api is

  -- Author  : ARTEM
  -- Created : 20.04.2023 22:47:32
  -- Purpose : 
  
-- Получаем рассписание боксов с заказами
function get_box_schedules
(
    p_payload in varchar2
) return clob;

function get_orders
(
    p_payload in varchar2
) return clob;

function save_box_schedule
(
    p_payload in varchar2
) return clob;

procedure delete_order
(
    p_payload in varchar2
);
end web_order_api;
/
create or replace package body web_order_api is

-- Получаем рассписание боксов с заказами
function get_box_schedules
(
    p_payload in varchar2
) return clob
is
    v_date date := to_date(json_object_t.parse(p_payload).get_string('date'), 'dd.mm.yyyy');
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_order_utils.get_box_schedules(v_date),
            p_structure  => '{"schedule": "json_element"}'
        );
end get_box_schedules;

function get_orders
(
    p_payload in varchar2
) return clob
is
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_order_utils.get_orders,
            p_structure  => '{"client": "json_element", "car": "json_element", "carBox": "json_element"}'
        );
end get_orders;

-- Получаем рассписание боксов с заказами
function save_box_schedule
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
begin
    return web_order_utils.save_box_schedule
        (
            p_code         => v_data.get_Number('code'),
            p_car_box_code => v_data.get_Number('carBoxCode'),
            p_date_start   => to_date(v_data.get_String('dateStart'), 'dd.mm.yyyy hh24:mi:ss'),
            p_date_end     => to_date(v_data.get_String('dateEnd'), 'dd.mm.yyyy hh24:mi:ss'),
            p_car_code     => v_data.get_Number('carCode'),
            p_status       => v_data.get_String('status'),
            p_order_code   => v_data.get_Number('orderCode')
        ).to_clob;
end save_box_schedule;

procedure delete_order
(
    p_payload in varchar2
)
is
    v_data json_object_t := json_object_t.parse(p_payload);
begin
    web_order_utils.delete_order
    (
        p_code  => v_data.get_Number('code')
    );
end delete_order;

end web_order_api;
/
