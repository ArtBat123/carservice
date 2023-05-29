create or replace package web_cars_utils is

  -- Author  : ARTEM
  -- Created : 06.04.2023 21:48:50
  -- Purpose : 
  
function get_cars
    return sys_refcursor;
    
function save_car
(
    p_code          in number,
    p_client_code   in number,
    p_brand         in varchar2,
    p_model         in varchar2,
    p_car_number    in varchar2,
    p_vin           in varchar2
) return number;

procedure delete_car
(
    p_code in number
);

end web_cars_utils;
/
create or replace package body web_cars_utils is

function get_cars
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        select
            t.code,
            t.client_code,
            t.brand,
            t.model,
            t.car_number,
            t.vin
        from
            car t;
    return v_result;
end get_cars;

function save_car
(
    p_code          in number,
    p_client_code   in number,
    p_brand         in varchar2,
    p_model         in varchar2,
    p_car_number    in varchar2,
    p_vin           in varchar2
) return number
is
    v_code     number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into car
        values (v_code, p_client_code, p_brand, p_model, p_car_number, p_vin);
    else
        v_code := p_code;
        update
            car t
        set
            t.client_code    = p_client_code,
            t.brand          = p_brand,
            t.model          = p_model,
            t.car_number     = p_car_number,
            t.vin            = p_vin
        where
            t.code = p_code;
    end if;
    return v_code;
end save_car;

procedure delete_car
(
    p_code in number
)
is
begin
    delete
    from
        car t
    where
        t.code = p_code;
end delete_car;
end web_cars_utils;
/
