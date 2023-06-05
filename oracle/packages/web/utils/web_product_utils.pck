create or replace package web_product_utils is

  -- Author  : ARTEM
  -- Created : 04.06.2023 18:03:44
  -- Purpose : 
  
function get_products_by_group
(
    p_group_code in number
) return sys_refcursor;

function get_product_groups
    return sys_refcursor;

function save_group
(
    p_code         in number,
    p_name         in varchar2,
    p_parent_group in number,
    p_description  in varchar2
) return number;

function save_product
(
    p_code                in number,
    p_name                in varchar2,
    p_producer            in varchar2,
    p_product_group_code  in number,
    p_price               in number,
    p_description         in varchar2,
    p_count               in number,
    p_vendor_code         in varchar2
) return number;

function has_vendor_code
(
    p_vendor_code in varchar2
) return boolean;

procedure add_products
(
    p_vendor_code in varchar2,
    p_add_count   in number    -- прибаляемое количество
);
end web_product_utils;
/
create or replace package body web_product_utils is

function get_products_by_group
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
                product_group t
            start with
                t.code = p_group_code
            connect by prior
                t.code = t.parent_group
        )
        select
            p.code,
            p.name,
            p.product_group_code,
            p.price,
            p.description,
            p.count,
            p.producer,
            p.vendor_code
        from
            product p
        where
            p.product_group_code in (select * from parent_groups);
    return v_result;   
end get_products_by_group;

function get_product_groups
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
            product_group t;
    return v_result;
end get_product_groups;

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
        insert into product_group
        values (v_code, p_name, p_parent_group, p_description);
    else
        v_code := p_code;
        update
            product_group t
        set
            t.name           = p_name,
            t.parent_group   = p_parent_group,
            t.description    = p_description
        where
            t.code = p_code;
    end if;
    return v_code;
end save_group;

function save_product
(
    p_code                in number,
    p_name                in varchar2,
    p_producer            in varchar2,
    p_product_group_code  in number,
    p_price               in number,
    p_description         in varchar2,
    p_count               in number,
    p_vendor_code         in varchar2
) return number
is
    v_code number;
begin
    if p_code is null then
        v_code := obj_seq.nextval; 
        insert into
            product(code, name, producer, product_group_code, price, description, count, vendor_code)
        values (v_code, p_name, p_producer, p_product_group_code, p_price, p_description, p_count, p_vendor_code);
    else
        v_code := p_code;
        update
            product t
        set
            t.name                 = p_name,
            t.producer             = p_producer,
            t.product_group_code   = p_product_group_code,
            t.price                = p_price,
            t.description          = p_description,
            t.count                = p_count,
            t.vendor_code          = p_vendor_code
        where
            t.code = p_code;
    end if;
    return v_code;
end save_product;

function has_vendor_code
(
    p_vendor_code in varchar2
) return boolean
is
    v_result number;
begin
    select
        max(1)
    into
        v_result
    from
        product t
    where
        t.vendor_code = p_vendor_code;
    if v_result is null then
        return false;
    end if;
    return true;
end has_vendor_code;

procedure add_products
(
    p_vendor_code in varchar2,
    p_add_count   in number    -- прибаляемое количество
)
is
begin
    update
        product t
    set
        t.count = t.count + p_add_count
    where
        t.vendor_code = p_vendor_code;
end add_products;

end web_product_utils;
/
