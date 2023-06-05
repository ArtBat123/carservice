create table purchase_order
(
    code         number,
    order_code   number,
    constraint purchase_order_pk primary key (code),
    constraint purchase_order_fk1 foreign key (order_code) references orders(code)
);
