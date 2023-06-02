create or replace package web_service_utils is

  -- Author  : ARTEM
  -- Created : 01.06.2023 1:28:33
  -- Purpose : 
  
function get_service_groups
    return sys_refcursor;
    
function get_services_by_group
(
    p_group_code in number
) return sys_refcursor;

function save_group
(
    p_code         in number,
    p_name         in varchar2,
    p_parent_group in number,
    p_description  in varchar2
) return number;

function save_service
(
    p_code                in number,
    p_name                in varchar2,
    p_service_group_code  in number,
    p_price               in number,
    p_description         in varchar2
) return number;
end web_service_utils;
/
create or replace package body web_service_utils is

function get_services_by_group
(
    p_group_code in number
) return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        with parent_groups as
        (
            select
                t.code
            from
                service_group t
            start with
                t.code = p_group_code
            connect by prior
                t.code = t.parent_group
        )
        select
            s.code,
            s.name,
            s.service_group_code,
            s.price,
            s.description
        from
            service s
        where
            s.service_group_code in (select * from parent_groups);
    return v_result;   
end get_services_by_group;

function get_service_groups
    return sys_refcursor
is
    v_result sys_refcursor;
begin
    open v_result for
        select
            t.code          as key,
            t.name          as label,
            t.parent_group,
            t.description
        from
            service_group t;
    return v_result;
end get_service_groups;

function save_group
(
    p_code         in number,
    p_name         in varchar2,
    p_parent_group in number,
    p_description  in varchar2
) return number
is
    v_code number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into service_group
        values (v_code, p_name, p_parent_group, p_description);
    else
        v_code := p_code;
        update
            service_group t
        set
            t.name           = p_name,
            t.parent_group   = p_parent_group,
            t.description    = p_description
        where
            t.code = p_code;
    end if;
    return v_code;
end save_group;

function save_service
(
    p_code                in number,
    p_name                in varchar2,
    p_service_group_code  in number,
    p_price               in number,
    p_description         in varchar2
) return number
is
    v_code number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into
            service(code, name, service_group_code, price, description)
        values (v_code, p_name, p_service_group_code, p_price, p_description);
    else
        v_code := p_code;
        update
            service t
        set
            t.name                 = p_name,
            t.service_group_code   = p_service_group_code,
            t.price                = p_price,
            t.description          = p_description
        where
            t.code = p_code;
    end if;
    return v_code;
end save_service;

end web_service_utils;
/
