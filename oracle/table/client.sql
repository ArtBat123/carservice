-- drop table client
create table client
(
    code          number(30),
    first_name    varchar2(100 char) not null, -- Имя
    last_name     varchar2(100 char) not null, -- Фамилия
    middle_name   varchar2(100 char) not null, -- Отчество
    full_name     varchar2(302 char) generated always as (last_name || ' ' || first_name || ' ' || middle_name),
    birthday      date,
    phone         number(11)         not null,
    create_date   date               not null, -- Дата создания
    constraint client_pk primary key (code)
);
