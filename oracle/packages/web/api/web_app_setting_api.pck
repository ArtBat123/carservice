create or replace package web_app_setting_api is

  -- Author  : ARTEM
  -- Created : 23.04.2023 0:14:07
  -- Purpose : 
  
function get_settings
(
    p_payload varchar2
) return clob;

end web_app_setting_api;
/
create or replace package body web_app_setting_api is

function get_settings
(
    p_payload varchar2
) return clob
is
begin
    return web_utils.cursor_to_json_array_clob(web_app_setting_utils.get_app_settings);
end get_settings;
end web_app_setting_api;
/
