create or replace package web_car_box_api is

  -- Author  : ARTEM
  -- Created : 16.04.2023 23:03:18
  -- Purpose : 
  
function get_car_boxes
(
    p_payload in varchar2 default null
) return clob;

end web_car_box_api;
/
create or replace package body web_car_box_api is

function get_car_boxes
(
    p_payload in varchar2 default null
) return clob
is
begin

    return web_utils.cursor_to_json_array_clob
        (
            p_cursor => web_car_box_utils.get_car_boxes()
        );
end get_car_boxes;

end web_car_box_api;
/
