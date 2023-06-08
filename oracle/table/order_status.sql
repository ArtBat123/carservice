create table order_status
(
    code         number,
    name         varchar2(200 char),
    color        varchar2(20 char),
    description  varchar2(2000 char),
    constraint order_status_pk primary key (code)
);
