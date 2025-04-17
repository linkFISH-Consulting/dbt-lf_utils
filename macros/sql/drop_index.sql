{% macro drop_index(columns) %}
    {{ return(adapter.dispatch('drop_index')(columns)) }}
{% endmacro %}

{%- macro default__drop_index(columns) %}
{%- endmacro %}

{%- macro oracle__drop_index(columns) %}

DECLARE
   index_not_exists EXCEPTION;
   PRAGMA EXCEPTION_INIT (index_not_exists, -1418);
BEGIN
   EXECUTE IMMEDIATE 'drop index {{ this.table }}__index_on_{{ columns|join("_") }}';
EXCEPTION
   WHEN index_not_exists
   THEN
      NULL;
END;

{%- endmacro %}

{%- macro sqlserver__drop_index(columns) %}
  
{%- endmacro %}