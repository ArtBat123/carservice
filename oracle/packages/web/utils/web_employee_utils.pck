create or replace package web_employee_utils is

  -- Author  : ARTEM
  -- Created : 27.05.2023 23:46:35
  -- Purpose : 
  
function get_employees
    return sys_refcursor;
    
function save_employee
(
    p_code              in number,
    p_first_name        in varchar2,
    p_last_name         in varchar2,
    p_middle_name       in varchar2,
    p_birthday          in date,
    p_phone             in number,
    p_employment_date   in date,
    p_dismissal_date    in date,
    p_login             in varchar2,
    p_password          in varchar2,
    p_address           in varchar2,
    p_position_code     in number
) return number;

-- Получение должностей
function get_positions
    return sys_refcursor;
end web_employee_utils;
/
create or replace package body web_employee_utils is

function get_employees
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        select
            t.code,
            t.first_name,
            t.last_name,
            t.middle_name,
            t.full_name,
            to_char(t.birthday, 'dd.mm.yyyy')         as birthday,
            t.phone,
            to_char(t.employment_date, 'dd.mm.yyyy')  as employment_date,
            to_char(t.dismissal_date, 'dd.mm.yyyy')   as dismissal_date,
            t.login,
            t.password,
            t.address,
            json_object
            (
                'code'        value tt.code,
                'name'        value tt.name,
                'description' value tt.description,
                'salary'      value tt.salary
            ) as position
        from
            employee t
            join
                position tt
                on t.position_code = tt.code;
    return v_result;
end get_employees;
-- Получение должностей
function get_positions
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        select
            t.code,
            t.name,
            t.description,
            t.salary
        from
            position t;
    return v_result;
end get_positions;

function save_employee
(
    p_code              in number,
    p_first_name        in varchar2,
    p_last_name         in varchar2,
    p_middle_name       in varchar2,
    p_birthday          in date,
    p_phone             in number,
    p_employment_date   in date,
    p_dismissal_date    in date,
    p_login             in varchar2,
    p_password          in varchar2,
    p_address           in varchar2,
    p_position_code     in number
) return number
is
    v_code     number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into
            employee(code, first_name, last_name, middle_name, phone, birthday, employment_date, dismissal_date, login, password, address, position_code)
        values (v_code, p_first_name, p_last_name, p_middle_name, p_phone, p_birthday, sysdate, null, p_login, p_password, p_address, p_position_code);
    else
        v_code := p_code;
        update
            employee t
        set
            t.first_name        = p_first_name,
            t.last_name         = p_last_name,
            t.middle_name       = p_middle_name,
            t.phone             = p_phone,
            t.birthday          = p_birthday,
            t.employment_date   = p_employment_date,
            t.dismissal_date    = p_dismissal_date,
            t.login             = p_login,
            t.password          = p_password,
            t.address           = p_address,
            t.position_code     = p_position_code
        where
            t.code = p_code;
    end if;
    return v_code;
end save_employee;
end web_employee_utils;
/
