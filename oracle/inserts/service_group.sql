delete from service_group;
--
insert into service_group values(1, 'Все работы', null, null);
insert into service_group values(2, 'Двигатель', 1, null);
insert into service_group values(3, 'Двигатель', 2, null);
insert into service_group values(4, 'Система выпуска газов', 2, null);
insert into service_group values(5, 'Система охлаждения', 2, null);
insert into service_group values(6, 'Система питания', 2, null);
insert into service_group values(7, 'Электронная система управления', 2, null);
--
insert into service_group values(8, 'Подвеска', 1, null);
insert into service_group values(9, 'Колеса и ступицы', 8, null);
insert into service_group values(10, 'Подвеска', 8, null);
insert into service_group values(11, 'Ступица задних колес', 9, null);
insert into service_group values(12, 'Ступица передних колес', 9, null);
insert into service_group values(13, 'Амортизаторы задние', 10, null);
insert into service_group values(14, 'Амортизаторы передние', 10, null);
