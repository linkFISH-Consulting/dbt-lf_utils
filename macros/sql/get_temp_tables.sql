{% macro get_temp_tables() -%}
    {{ return(adapter.dispatch('get_temp_tables')()) }}
{%- endmacro %}

{%- macro default__get_temp_tables() %}
SELECT *, CONCAT(REPLACE(table_type, 'BASE ',''),CONCAT(' `{{target.database}}.{{target.schema}}','.',CONCAT(table_name,'`'))) AS command
FROM {{target.database}}.{{target.schema}}.INFORMATION_SCHEMA.TABLES
WHERE 
(UPPER(table_name) LIKE 'PERSONAKT%' OR UPPER(table_name) LIKE 'PERSONHIST%' OR UPPER(table_name) LIKE 'BDGMAKT%' 
OR UPPER(table_name) LIKE 'BDGMHIST%' OR UPPER(table_name) LIKE 'BDGMPERSAKT%' OR UPPER(table_name) LIKE 'BDGMPERSHIST%'
OR UPPER(table_name) LIKE 'TMP_BDGM_HIST%' OR UPPER(table_name) LIKE 'TMP_BDGMPERS_HIST%' OR UPPER(table_name) LIKE 'TMP_PERSON_HIST%'
OR UPPER(table_name) LIKE 'TMP_BDGMDATEN%'
)
AND UPPER(table_name) NOT LIKE '%ZUORD'
AND UPPER(table_name) NOT LIKE '%AKT_ANTRAGSTELLER'
AND UPPER(table_name) NOT LIKE '%AKT_FIRMA'
{%- endmacro %}

{%- macro oracle__get_temp_tables() %}
SELECT all_tables.*, 'TABLE {{target.schema}}' || '.' || table_name AS command
FROM all_tables
WHERE UPPER(OWNER) = UPPER('{{target.schema}}') AND 
(UPPER(table_name) LIKE 'PERSONAKT%' OR UPPER(table_name) LIKE 'PERSONHIST%' OR UPPER(table_name) LIKE 'BDGMAKT%' 
OR UPPER(table_name) LIKE 'BDGMHIST%' OR UPPER(table_name) LIKE 'BDGMPERSAKT%' OR UPPER(table_name) LIKE 'BDGMPERSHIST%'
OR UPPER(table_name) LIKE 'TMP_BDGM_HIST%' OR UPPER(table_name) LIKE 'TMP_BDGMPERS_HIST%' OR UPPER(table_name) LIKE 'TMP_PERSON_HIST%'
OR UPPER(table_name) LIKE 'TMP_BDGMDATEN%'
)
AND UPPER(table_name) NOT LIKE '%ZUORD'
AND UPPER(table_name) NOT LIKE '%AKT_ANTRAGSTELLER'
AND UPPER(table_name) NOT LIKE '%AKT_FIRMA'
{%- endmacro %}