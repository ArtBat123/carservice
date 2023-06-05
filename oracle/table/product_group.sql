create table product_group
(
    code                 number,
    name                 varchar2(300 char) not null,
    parent_group         number,
    description          varchar2(2000 char),
    constraint product_group_pk primary key (code),
    constraint product_group_fk1 foreign key (parent_group) references product_group(code)
);
