create table service
(
    code                 number,
    name                 varchar2(300 char) not null,
    service_group_code   number,
    price                number,
    description          varchar2(2000 char),
    constraint service_pk primary key (code),
    constraint service_fk1 foreign key (service_group_code) references service_group(code)
);
