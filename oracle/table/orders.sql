create table orders
(
    code           number(30),
    car_code       number(30),
    create_date    date,
    status_code    number,
    constraint order_pk primary key (code),
    constraint order_fk1 foreign key(car_code)    references car(code),
    constraint order_fk2 foreign key(status_code) references order_status(code)
);
