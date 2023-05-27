-- drop table employee
-- ����������
create table employee
(
    code               number(30),
    first_name         varchar2(100 char) not null, -- ���
    last_name          varchar2(100 char) not null, -- �������
    middle_name        varchar2(100 char) not null, -- ��������
    full_name          varchar2(302 char) generated always as (last_name || ' ' || first_name || ' ' || middle_name),
    birthday           date               not null,
    phone              number(11)         not null,
    employment_date    date               not null, -- ���� ���������� �� ������
    dismissal_date     date,                        -- ���� ����������
    login              varchar2(200 char) not null,
    password           varchar2(200 char) not null,
    address            varchar2(200 char) not null,
    position_code      number(30)         not null, -- ��� ���������
    constraint employee_pk primary key (code),
    constraint employee_fk1 foreign key (position_code) references position(code)
);
