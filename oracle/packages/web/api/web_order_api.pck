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
function save_purchase_order
(
    p_payload in varchar2
) return clob;

function get_purchase_order
(
    p_payload in varchar2
) return clob;
function get_order_status_list
(
    p_payload in varchar2
) return clob;

procedure save_telegram_char
(
    p_payload in clob
);

function get_chatid_by_phone
(
    p_payload in clob
) return clob;
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
            p_structure  => '{"client": "json_element", "car": "json_element", "carBox": "json_element", "status":"json_element"}'
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
            p_status       => v_data.get_Number('status'),
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


function get_purchase_order
(
    p_payload in varchar2
) return clob
is
    v_code number := json_object_t.parse(p_payload).get_number('code');
begin
    return web_utils.cursor_row_to_json_object_clob
        (
            p_cursor     => web_order_utils.get_purchase_order(v_code),
            p_structure  => '{"products": "json_element", "services": "json_element"}'
        );
end get_purchase_order;


function save_purchase_order
(
    p_payload in varchar2
) return clob
is
    v_data           json_object_t  := json_object_t.parse(p_payload);
    v_order_code     number         := v_data.get_Number('orderCode');
    v_products_list  json_array_t   := v_data.get_Array('products');
    v_services_list  json_array_t   := v_data.get_Array('services');
    v_purchase_order_code         number;
    v_product_purchase_order_code number;
    v_service_purchase_order_code number;
    v_product        json_object_t;
    v_service        json_object_t;
    v_result         json_object_t := json_object_t();
    --
    v_product_code   number;
    v_product_count  number;
    --
    v_service_code   number;
    v_service_count  number;
begin
    v_purchase_order_code := web_order_utils.save_purchase_order(v_order_code);
     
    for i in 0..v_products_list.get_size -1 loop
        v_product_purchase_order_code := obj_seq.nextval;
        v_product                     := json_object_t(v_products_list.get(i));
        v_product_code                := v_product.get_Number('code');
        v_product_count               := v_product.get_Number('count');
        insert into product_purchase_order(code, product_code, purchase_order_code, count)
        values
        (
            v_product_purchase_order_code,
            v_product_code,
            v_purchase_order_code,
            v_product_count
        );
        update
            product t
        set
            t.count = t.count - v_product_count
        where
            t.code = v_product_code;
    end loop;
    --
    for i in 0..v_services_list.get_size -1 loop
        v_service_purchase_order_code := obj_seq.nextval;
        v_service                     := json_object_t(v_services_list.get(i));
        v_service_code                := v_service.get_Number('code');
        v_service_count               := v_service.get_Number('count');
        insert into service_purchase_order(code,service_code, purchase_order_code, count)
        values
        (
            v_service_purchase_order_code,
            v_service_code,
            v_purchase_order_code,
            v_service_count
        );
    end loop;
    v_result.put('code', v_purchase_order_code);
    return v_result.to_clob;
end save_purchase_order;

function get_order_status_list
(
    p_payload in varchar2
) return clob
is
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_order_utils.get_order_status_list
        );
end get_order_status_list;

procedure save_telegram_char
(
    p_payload in clob
)
is
    v_phone number := json_object_t.parse(p_payload).get_number('phone');
    v_chat  number := json_object_t.parse(p_payload).get_number('chat');
    v_has_chat number;
begin
    select
        max(1)
    into
        v_has_chat
    from
        telegram_chat t
    where
        t.phone = v_phone;
    if v_has_chat is null then
        insert into telegram_chat values (obj_seq.nextval, v_phone, v_chat);
    end if;
end save_telegram_char;

function get_chatid_by_phone
(
    p_payload in clob
) return clob
is
    v_result    json_object_t := json_object_t();
    v_phone     number        := json_object_t.parse(p_payload).get_number('phone');
    v_chat      number;
begin
    select
        max(t.chat)
    into
        v_chat
    from
        telegram_chat t
    where
        t.phone = v_phone;
    v_result.put('chat', v_chat);
    return v_result.to_clob;
end get_chatid_by_phone;
end web_order_api;
/
