create table product_purchase_order
(
    code                  number,
    product_code          number,
    purchase_order_code   number,
    count                 number,
    constraint product_purchase_order_pk primary key(code),
    constraint product_purchase_order_fk1 foreign key(product_code) references product(code),
    constraint product_purchase_order_fk2 foreign key(purchase_order_code) references purchase_order(code)
);
