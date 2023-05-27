-- Должности
create table position
(
    code          number(30),
    name          varchar2(400 char)  not null,
    description   varchar2(2000 char),
    constraint position_pk primary key (code)
);
