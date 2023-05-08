create table car_box
(
    code          number(30),
    name          varchar2(200 char)   not null,
    description   varchar2(1000 char),
    constraint car_box_pk primary key (code)
);

insert into car_box values(obj_seq.nextval, '�����', '������������ �����');
insert into car_box values(obj_seq.nextval, '�������', '���� ��� ������� �������');
insert into car_box values(obj_seq.nextval, '���������', '������ ����������');
insert into car_box values(obj_seq.nextval, '���', '������ ������� �������');

