create table car_box
(
    code          number(30),
    name          varchar2(200 char)   not null,
    description   varchar2(1000 char),
    constraint car_box_pk primary key (code)
);

insert into car_box values(obj_seq.nextval, 'Мойка', 'Предработная мойка');
insert into car_box values(obj_seq.nextval, 'Ходовая', 'Бокс для ремонта ходовых');
insert into car_box values(obj_seq.nextval, 'Двигатель', 'Ремонт двигателей');
insert into car_box values(obj_seq.nextval, 'КПП', 'Ремонт коробок передач');

