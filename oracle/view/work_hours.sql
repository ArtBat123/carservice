create or replace view work_hours as
    select
        web_utils.get_setting('workTimeStart') + trunc((level - 1) / 2) as hour,
        decode(mod(level - 1, 2), 0, 0, 30) as minute,
        case
            when mod(level - 1, 2) = 0 then
                web_utils.get_setting('workTimeStart') + trunc((level - 1) / 2) || ':00'
            else
                web_utils.get_setting('workTimeStart') + trunc((level - 1) / 2) || ':30'
        end as time_string
    from
        dual t
    connect by
        level - 1 < (web_utils.get_setting('workTimeEnd') - web_utils.get_setting('workTimeStart')) * 2;
