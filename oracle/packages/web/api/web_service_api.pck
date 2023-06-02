create or replace package web_service_api is

  -- Author  : ARTEM
  -- Created : 01.06.2023 2:44:16
  -- Purpose : 
  
function get_service_groups
(
    p_payload in varchar2
) return clob;

function get_services_by_group
(
    p_payload in varchar2
) return clob;

function save_group
(
    p_payload in varchar2
) return clob;

function save_service
(
    p_payload in varchar2
) return clob;

procedure delete_service
(
    p_payload in varchar2
);
end web_service_api;
/
create or replace package body web_service_api is

function get_service_groups
(
    p_payload in varchar2
) return clob
is
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_service_utils.get_service_groups
        );
end get_service_groups;

function get_services_by_group
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_group_code number  := v_data.get_Number('code');
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_service_utils.get_services_by_group(v_group_code)
        );
end get_services_by_group;

function save_group
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_code number;
    v_result json_object_t := json_object_t();
begin
    v_code := web_service_utils.save_group
    (
        p_code          => v_data.get_Number('code'),
        p_name          => v_data.get_String('name'),
        p_parent_group  => v_data.get_Number('parentGroup'),
        p_description   => v_data.get_String('description')
    );
    v_result.put('code', v_code);
    return v_result.to_clob;
end save_group;

function save_service
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_code number;
    v_result json_object_t := json_object_t();
begin
    v_code := web_service_utils.save_service
    (
        p_code                => v_data.get_Number('code'),
        p_name                => v_data.get_String('name'),
        p_service_group_code  => v_data.get_Number('serviceGroup'),
        p_price               => v_data.get_Number('price'),
        p_description         => v_data.get_String('description')
    );
    v_result.put('code', v_code);
    return v_result.to_clob;
end save_service;

procedure delete_service
(
    p_payload in varchar2
)
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_code number := v_data.get_Number('code');
begin
    delete
    from
        service t
    where
        t.code = v_code;
end delete_service;

end web_service_api;
/
