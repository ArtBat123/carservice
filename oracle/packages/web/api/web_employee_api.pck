create or replace package web_employee_api is

  -- Author  : ARTEM
  -- Created : 27.05.2023 23:47:10
  -- Purpose : 
  
function get_employees
(
    p_payload in varchar2 default null
) return clob;

-- Получение должностей
function get_positions
(
    p_payload in varchar2 default null
) return clob;

function save_employee
(
    p_payload in varchar2 default null
) return clob;

procedure delete_employee
(
    p_payload in varchar2 default null
);

end web_employee_api;
/
create or replace package body web_employee_api is

function get_employees
(
    p_payload in varchar2 default null
) return clob
is
begin
    return
        web_utils.cursor_to_json_array_clob
        (
            p_cursor    => web_employee_utils.get_employees,
            p_structure => '{"position":"json_element"}'
        );
end get_employees;

-- Получение должностей
function get_positions
(
    p_payload in varchar2 default null
) return clob
is
begin
    return
        web_utils.cursor_to_json_array_clob
        (
            p_cursor    => web_employee_utils.get_positions
        );
end get_positions;

function save_employee
(
    p_payload in varchar2 default null
) return clob
is
    v_data    json_object_t := json_object_t.parse(p_payload);
    v_code    number;
    v_result  json_object_t := json_object_t();
begin
    v_code := web_employee_utils.save_employee
    (
        p_code              => v_data.get_Number('code'),
        p_first_name        => v_data.get_string('firstName'),
        p_last_name         => v_data.get_string('lastName'),
        p_middle_name       => v_data.get_string('middleName'),
        p_birthday          => to_date(v_data.get_string('birthday'), 'dd.mm.yyyy'),
        p_phone             => v_data.get_Number('phone'),
        p_employment_date   => to_date(v_data.get_string('employmentDate'), 'dd.mm.yyyy'),
        p_dismissal_date    => to_date(v_data.get_string('dismissalDate'), 'dd.mm.yyyy'),
        p_login             => v_data.get_string('login'),
        p_password          => v_data.get_string('password'),
        p_address           => v_data.get_string('address'),
        p_position_code     => v_data.get_Object('position').get_number('code')
    );
    v_result.put('code', v_code);
    return v_result.to_clob;
end save_employee;

procedure delete_employee
(
    p_payload in varchar2 default null
)
is
    v_data    json_object_t := json_object_t.parse(p_payload);
    v_code    number        := v_data.get_Number('code');
begin
    delete
    from 
        employee t
    where
        t.code = v_code;
end delete_employee;

end web_employee_api;
/
