create or replace package web_clients_api is

  -- Author  : ARTEM
  -- Created : 02.04.2023 23:34:41
  -- Purpose : 
  
function get_clients
(
    p_payload varchar2 default null
) return clob;

function save_client
(
    p_payload in varchar2 default null
) return clob;

procedure delete_client
(
    p_payload in varchar2 default null
);
end web_clients_api;
/
create or replace package body web_clients_api is

function get_clients
(
    p_payload in varchar2 default null
) return clob
is
begin
    return
        web_utils.cursor_to_json_array_clob
        (
            p_cursor    => web_clients_utils.get_clients,
            p_structure => '{"cars": "json_element"}'
            
        );
end get_clients;

function save_client
(
    p_payload in varchar2 default null
) return clob
is
    v_data       json_object_t := json_object_t.parse(p_payload);
    v_cars       json_array_t  := json_array_t(v_data.get('addedCars'));
    v_result     json_object_t := json_object_t();
    v_cars_codes json_array_t  := json_array_t();
    v_code       number;
    v_car_code   number; 
begin
    v_code := web_clients_utils.save_client
        (
            p_code          => v_data.get_Number('code'),
            p_first_name    => v_data.get_String('firstName'),
            p_last_name     => v_data.get_String('lastName'),
            p_middle_name   => v_data.get_String('middleName'),
            p_phone         => v_data.get_Number('phone'),
            p_birthday      => to_date(v_data.get_String('birthday'), 'dd.mm.yyyy')
        );
    -- Добавляем авто клиенту, если они есть
    for i in 0..v_cars.get_size - 1 loop
        v_car_code := web_cars_utils.save_car
        (
            null,
            v_code,
            json_object_t(v_cars.get(i)).get_String('brand'),
            json_object_t(v_cars.get(i)).get_String('model'),
            json_object_t(v_cars.get(i)).get_String('number'),
            json_object_t(v_cars.get(i)).get_String('vin')
        );
        v_cars_codes.append(v_car_code);
    end loop;
    v_result.put('carsCodes', v_cars_codes);
    v_result.put('code', v_code);
    return v_result.to_clob;
end save_client;

procedure delete_client
(
    p_payload in varchar2 default null
)
is
    v_data   json_object_t := json_object_t.parse(p_payload);
begin
    web_clients_utils.delete_client
    (
        p_code => v_data.get_Number('code')
    );
end delete_client;

end web_clients_api;
/
