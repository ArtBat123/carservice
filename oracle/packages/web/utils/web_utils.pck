create or replace package web_utils is

  -- Author  : ARTEM
  -- Created : 02.04.2023 19:03:02
  -- Purpose : 
  
/*****************************************/
  -- Преобразование текста_с_нижним_подчеркиванием в кэмлКейс
function string_to_camel_case
    (
        p_str in varchar2
    ) return varchar2 deterministic;
    
/*****************************************/   
/* Приводит курсор к json_array_t*/
function cursor_to_json_array
    (
        p_cursor    in      sys_refcursor,   -- Курсор с данными
        p_structure in      clob := '{}'
    ) return json_array_t;

/*****************************************/
/* Приводит курсор к json_array_t.to_clob*/
function cursor_to_json_array_clob
    (
        p_cursor    in      sys_refcursor, -- Курсор с данными
        p_structure in      clob := '{}'
    ) return clob;
/*****************************************************************************/
/* Берет первую строку из p_cursor и возращает её как json_object_t  */
function cursor_row_to_json_object
    (
        p_cursor    in sys_refcursor -- Курсор с данными
    ) return json_object_t;

/*****************************************************************************/
/* Берет первую строку из p_cursor и возращает её как json_object_t.to_clob  */
function cursor_row_to_json_object_clob
    (
        p_cursor    in sys_refcursor -- Курсор с данными
    ) return clob;

function get_setting
(
    p_setting_name varchar2
) return varchar2;
end web_utils;
/
create or replace package body web_utils is

/*********************************************************/
-- Преобразование текста_с_нижним_подчеркиванием в кэмлКейс
function string_to_camel_case
    (
        p_str in varchar2
    ) return varchar2 deterministic
is
begin
    return
        substr(lower(replace(p_str, '_', ' ')), 1, 1) ||
        substr(replace(initcap(replace(p_str, '_', ' ')), ' '), 2);
end string_to_camel_case;
/*****************************************/
/* Приводит курсор к json_array_t*/
function cursor_to_json_array
    (
        p_cursor    in      sys_refcursor,   -- Курсор с данными
        p_structure in      clob := '{}'
    ) return json_array_t
is
    v_result            json_array_t;
    v_element           json_object_t;
    v_col_name_list     json_array_t := new json_array_t;
    v_col_name          varchar2(100 char);
    v_col_cnt           pls_integer;
    v_cur_id            pls_integer;
    v_numvar            number;
    v_datevar           date;
    v_clobvar           clob;
    v_varcharvar        varchar2(32000 char);
    v_rec_tab           dbms_sql.desc_tab4;
    --
    v_structure_json_obj    json_object_t := new json_object_t;
    v_cursor            sys_refcursor;
begin
    v_result                := new json_array_t;
    -- Преобразуем structure obj
    v_structure_json_obj    := json_object_t.parse(p_structure);
    --
    v_cursor := p_cursor;
    -- Преобразуем курсорную переменную
    v_cur_id := dbms_sql.to_cursor_number(v_cursor);
    -- Получаем информацию о столбцах
    dbms_sql.describe_columns3
    (
        c       => v_cur_id,
        col_cnt => v_col_cnt,
        desc_t  => v_rec_tab
    );
    -- Определение структуры курсора
    for i in 1 .. v_col_cnt loop
        -- Формирование списка имен столбцов
        v_col_name_list.append(web_utils.string_to_camel_case(v_rec_tab(i).col_name));
        -- Строка
        if v_rec_tab(i).col_type = 1 then
            dbms_sql.define_column(v_cur_id, i, v_varcharvar, 32000);
        -- Число
        elsif v_rec_tab(i).col_type = 2 then
            dbms_sql.define_column(v_cur_id, i, v_numvar);
        -- Дата
        elsif v_rec_tab(i).col_type = 12 then
            dbms_sql.define_column(v_cur_id, i, v_datevar);
        else
            dbms_sql.define_column(v_cur_id, i, v_clobvar);
        end if;
    end loop;
    -- Цикл по строкам
    while dbms_sql.fetch_rows(v_cur_id) > 0 loop
        v_element := new json_object_t;
        -- Цикл по столбцам
        for i in 1 .. v_col_cnt loop
            -- Кладем в переменную имя столбца
            v_col_name := v_col_name_list.get_string(i - 1);
            --
            case v_rec_tab(i).col_type
                -- Строка
                when 1 then
                    dbms_sql.column_value(v_cur_id, i, v_varcharvar);
                    case
                        v_structure_json_obj.get_string(v_col_name)
                        when 'json_element' then
                            v_element.put(v_col_name, json_element_t.parse(v_varcharvar));
                        else
                            v_element.put(v_col_name, v_varcharvar);
                    end case;
                -- Число
                when 2 then
                    dbms_sql.column_value(v_cur_id, i, v_numvar);
                    v_element.put(v_col_name, v_numvar);
                -- Дата
                when 12 then
                    dbms_sql.column_value(v_cur_id, i, v_datevar);
                    v_element.put(v_col_name, v_datevar);
                else
                    dbms_sql.column_value(v_cur_id, i, v_clobvar);
                    case
                        v_structure_json_obj.get_string(v_col_name)
                        when 'json_element' then
                            v_element.put(v_col_name, json_element_t.parse(v_clobvar));
                        else
                            v_element.put(v_col_name, v_clobvar);
                    end case;
            end case;
        end loop;
        if v_element is not null then
            v_result.append(v_element);
        end if;
    end loop;
    -- Закрываем курсор
    dbms_sql.close_cursor(v_cur_id);
    return
        v_result;
end cursor_to_json_array;
/*****************************************/
/* Приводит курсор к json_array_t.to_clob*/
function cursor_to_json_array_clob
    (
        p_cursor    in      sys_refcursor, -- Курсор с данными
        p_structure in      clob := '{}'
    ) return clob
is
begin
    return
        cursor_to_json_array(p_cursor, p_structure).to_clob;
end cursor_to_json_array_clob;
/*****************************************************************************/
/* Берет первую строку из p_cursor и возращает её как json_object_t  */
function cursor_row_to_json_object
    (
        p_cursor    in sys_refcursor -- Курсор с данными
    ) return json_object_t
is
    v_json_array    json_array_t;
begin
    v_json_array := cursor_to_json_array(p_cursor);
    --
    return json_object_t.parse(v_json_array.get(0).to_clob);
end cursor_row_to_json_object;
/*****************************************************************************/
/* Берет первую строку из p_cursor и возращает её как json_object_t.to_clob  */
function cursor_row_to_json_object_clob
    (
        p_cursor    in sys_refcursor -- Курсор с данными
    ) return clob
is
    v_json_object   json_object_t;
begin
    v_json_object := cursor_row_to_json_object(p_cursor);
    return
        v_json_object.to_clob;
end cursor_row_to_json_object_clob;
/*****************************************************************************/
/* Преобразование даты в unix формат (количество секунд прошедних с 01.01.1970 год) в временой зоне utc+3  */
function date_to_unix_format_date
    (
        p_date  in date -- дата, которую переводим в unix формат
    ) return number
is
begin
    return
        round((p_date - to_date('01.01.1970 00:00:00', 'dd.mm.yyyy hh24:mi:ss')) * 24 * 60 * 60);
end date_to_unix_format_date;

function get_setting
(
    p_setting_name varchar2
) return varchar2
is
    v_result varchar2(2000 char);
begin
    select
        t.value
    into
        v_result
    from
        app_setting t
    where
        t.name = p_setting_name;
    return v_result;
end get_setting;

end web_utils;
/
