-- Должности
-- drop table position
create table position
(
    code          number(30),
    name          varchar2(400 char)  not null,
    salary        number(10)          not null,
    description   varchar2(2000 char),
    constraint position_pk primary key (code)
);
