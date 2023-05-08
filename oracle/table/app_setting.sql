create table app_setting
(
    code          number(30),
    name          varchar2(200 char),
    value         varchar2(2000 char),
    description   varchar2(2000 char),
    constraint app_setting_pk primary key (code)
);
