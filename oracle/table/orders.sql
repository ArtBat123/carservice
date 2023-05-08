create table orders
(
    code           number(30),
    car_code       number(30),
    create_date    date,
    status         varchar2(200 char),
    constraint order_pk primary key (code),
    constraint order_fk1 foreign key(car_code) references car(code)
);
