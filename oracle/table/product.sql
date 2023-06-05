create table product
(
    code                       number(30),
    name                       varchar2(200 char),
    producer                   varchar2(200 char),
    product_group_code         number,
    price                      number,
    description                varchar2(2000 char),
    count                      number,
    vendor_code                varchar2(2000 char), -- Артикул
    constraint product_pk primary key (code),
    constraint product_fk1 foreign key(product_group_code) references product_group(code)
);
