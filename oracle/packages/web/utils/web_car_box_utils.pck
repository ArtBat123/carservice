create or replace package web_car_box_utils is

  -- Author  : ARTEM
  -- Created : 16.04.2023 22:56:58
  -- Purpose : 
  
function get_car_boxes
    return sys_refcursor;

end web_car_box_utils;
/
create or replace package body web_car_box_utils is

function get_car_boxes
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        select
            t.code,
            t.name,
            t.description
        from
            car_box t;
    return v_result;
end get_car_boxes;
end web_car_box_utils;
/
