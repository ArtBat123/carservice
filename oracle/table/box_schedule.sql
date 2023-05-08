create table box_schedule
(
    code           number(30),
    car_box_code   number(30),
    order_code     number(30),
    date_start     date,
    date_end       date,
    constraint box_schedule_pk primary key (code),
    constraint box_schedule_fk1 foreign key(car_box_code) references car_box(code),
    constraint box_schedule_fk2 foreign key(order_code) references orders(code)
);
