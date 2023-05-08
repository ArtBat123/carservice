create or replace package web_app_setting_utils is

  -- Author  : ARTEM
  -- Created : 23.04.2023 0:13:44
  -- Purpose : 
  
function get_app_settings
    return sys_refcursor;
    
function get_setting_value
(
    p_name app_setting.name%type
) return number;

end web_app_setting_utils;
/
create or replace package body web_app_setting_utils is

function get_app_settings
    return sys_refcursor
is
    v_result sys_refcursor;

begin
    open v_result for
        select
            t.code,
            t.name,
            t.value,
            t.description
        from
            app_setting t;
    return v_result;
end get_app_settings;

function get_setting_value
(
    p_name app_setting.name%type
) return number
is
    v_result number;
begin
    select
        t.value
    into
        v_result
    from
        app_setting t
    where
        t.name = p_name;
    return v_result;
end get_setting_value;
end web_app_setting_utils;
/
