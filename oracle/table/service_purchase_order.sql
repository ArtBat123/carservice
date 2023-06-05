create table service_purchase_order
(
    code                     number,
    service_code             number,
    purchase_order_code      number,
    count                    number,
    constraint service_purchase_order_pk primary key (code),
    constraint service_purchase_order_fk1 foreign key (service_code) references service(code),
    constraint service_purchase_order_fk2 foreign key (service_code) references purchase_order(code)
);
