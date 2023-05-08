create or replace package web_cars_api is

  -- Author  : ARTEM
  -- Created : 06.04.2023 21:48:25
  -- Purpose : 
  
function get_cars
(
    p_payload in varchar2 default null
) return clob;

end web_cars_api;
/
create or replace package body web_cars_api is

function get_cars
(
    p_payload in varchar2 default null
) return clob
is
begin
    return
        web_utils.cursor_to_json_array_clob
        (
            p_cursor => web_cars_utils.get_cars
        );
end get_cars;

end web_cars_api;
/
