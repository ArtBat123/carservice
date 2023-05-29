create or replace package web_clients_utils is

  -- Author  : ARTEM
  -- Created : 02.04.2023 23:18:36
  -- Purpose : 
  
function get_clients
    return sys_refcursor;

function save_client
(
    p_code        in number default null,
    p_first_name  in varchar2,
    p_last_name   in varchar2,
    p_middle_name in varchar2,
    p_phone       in number,
    p_birthday    in date
) return number;

procedure delete_client
(
    p_code        in number
);

end web_clients_utils;
/
create or replace package body web_clients_utils is

function get_clients
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        select
            c.code,
            c.first_name,
            c.last_name,
            c.middle_name,
            c.full_name,
            c.phone,
            to_char(c.birthday, 'dd.mm.yyyy') as birthday,
            json_arrayagg
            (
                decode
                (
                    cr.code,
                    null,
                    null,
                    json_object
                    (
                        'code'              value cr.code,
                        'brand'             value cr.brand,
                        'model'             value cr.model,
                        'number'            value cr.car_number,
                        'vin'               value cr.vin
                    )
                )
                returning clob
            ) as cars
        from
            client c
            left join
                car cr
                on c.code = cr.client_code
        group by
            c.code,
            c.first_name,
            c.last_name,
            c.middle_name,
            c.full_name,
            c.phone,
            to_char(c.birthday, 'dd.mm.yyyy');
    return v_result;
end get_clients;

function save_client
(
    p_code        in number default null,
    p_first_name  in varchar2,
    p_last_name   in varchar2,
    p_middle_name in varchar2,
    p_phone       in number,
    p_birthday    in date
) return number
is
    v_code     number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into
            client(code, first_name, last_name, middle_name, phone, birthday, create_date)
        values (v_code, p_first_name, p_last_name, p_middle_name, p_phone, p_birthday, sysdate);
    else
        v_code := p_code;
        update
            client t
        set
            t.first_name    = p_first_name,
            t.last_name     = p_last_name,
            t.middle_name   = p_middle_name,
            t.phone         = p_phone,
            t.birthday      = p_birthday
        where
            t.code = p_code;
    end if;
    return v_code;
end save_client;

procedure delete_client
(
    p_code        in number
)
is
begin
    delete from client t where t.code = p_code;
end delete_client;

end web_clients_utils;
/
