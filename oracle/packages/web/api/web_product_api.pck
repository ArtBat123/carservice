create or replace package web_product_api is

  -- Author  : ARTEM
  -- Created : 04.06.2023 18:13:09
  -- Purpose : 
  
function get_product_groups
(
    p_payload in varchar2
) return clob;

function get_products_by_group
(
    p_payload in varchar2
) return clob;

function save_group
(
    p_payload in varchar2
) return clob;

function save_product
(
    p_payload in varchar2
) return clob;

procedure delete_product
(
    p_payload in varchar2
);
procedure download_products
(
    p_payload in varchar2
);

end web_product_api;
/
create or replace package body web_product_api is

function get_product_groups
(
    p_payload in varchar2
) return clob
is
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_product_utils.get_product_groups
        );
end get_product_groups;

function get_products_by_group
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_group_code number  := v_data.get_Number('code');
begin
    return web_utils.cursor_to_json_array_clob
        (
            p_cursor     => web_product_utils.get_products_by_group(v_group_code)
        );
end get_products_by_group;

function save_group
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_code number;
    v_result json_object_t := json_object_t();
begin
    v_code := web_product_utils.save_group
    (
        p_code          => v_data.get_Number('code'),
        p_name          => v_data.get_String('name'),
        p_parent_group  => v_data.get_Number('parentGroup'),
        p_description   => v_data.get_String('description')
    );
    v_result.put('code', v_code);
    return v_result.to_clob;
end save_group;

function save_product
(
    p_payload in varchar2
) return clob
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_code number;
    v_result json_object_t := json_object_t();
begin
    v_code := web_product_utils.save_product
    (
        p_code                => v_data.get_Number('code'),
        p_name                => v_data.get_String('name'),
        p_producer            => v_data.get_String('producer'),
        p_product_group_code  => v_data.get_Number('productGroup'),
        p_price               => v_data.get_Number('price'),
        p_description         => v_data.get_String('description'),
        p_count               => v_data.get_Number('count'),
        p_vendor_code         => v_data.get_String('vendorCode')
    );
    v_result.put('code', v_code);
    return v_result.to_clob;
end save_product;

procedure delete_product
(
    p_payload in varchar2
)
is
    v_data json_object_t := json_object_t.parse(p_payload);
    v_code number := v_data.get_Number('code');
begin
    delete
    from
        product t
    where
        t.code = v_code;
end delete_product;

procedure download_products
(
    p_payload in varchar2
)
is
    v_products_list json_array_t := json_array_t.parse(p_payload);
    v_product       json_object_t;
    v_code          number;
begin
    for i in 0..v_products_list.get_size - 1 loop
        v_product := json_object_t(v_products_list.get(i));
        if web_product_utils.has_vendor_code(v_product.get_String('vendorCode')) = false then
            v_code := web_product_utils.save_product
            (
                p_code                => null,
                p_name                => v_product.get_String('name'),
                p_producer            => v_product.get_String('producer'),
                p_product_group_code  => 1,
                p_price               => v_product.get_Number('price'),
                p_description         => v_product.get_String('description'),
                p_count               => v_product.get_Number('count'),
                p_vendor_code         => v_product.get_String('vendorCode')
            );
        else
            web_product_utils.add_products
            (
                p_vendor_code => v_product.get_String('vendorCode'),
                p_add_count   => v_product.get_Number('count')
            );
        end if;
    end loop;
end download_products;

end web_product_api;
/
