create table car
(
    code          number(30),
    client_code   number(30)            not null,
    brand         varchar2(100 char)    not null,
    model         varchar2(100 char)    not null,
    car_number    varchar2(9 char),
    vin           varchar2(17 char),
    constraint car_pk primary key (code),
    constraint car_fk foreign key (client_code) references client (code),
    constraint car_uk unique (vin)
);
