{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-08-13 16:08:21
@Last Modified: 2025-08-14 10:56:52
------------------------------------------------------------------------------ #}

{# TODO: needs tests! #}

{# cmd+z for the create_nonclustered_index macro #}


{% macro drop_index(columns) %}
    {{ return(adapter.dispatch("drop_index", "lf_utils")(columns)) }}
{% endmacro %}

{%- macro duckdb__drop_index(columns) %}
   drop index if exists {{ this.table }}__index_on_{{ columns|join("_") }};
{%- endmacro %}

{%- macro postgres__drop_index(columns) %}
   drop index if exists {{ this.table }}__index_on_{{ columns|join("_") }};
{%- endmacro %}

{%- macro sqlserver__drop_index(columns) %}
    if exists (
        select name
        from sys.indexes
        where name = '{{ this.table }}__index_on_{{ columns|join("_") }}'
    )
    begin
      drop index {{ this.table }}__index_on_{{ columns|join("_") }} on {{ this }};
    end
{%- endmacro %}

{%- macro oracle__drop_index(columns) %}

DECLARE
   index_not_exists EXCEPTION;
    pragma exception_init(index_not_exists, -1418)
    ;
    begin
   EXECUTE IMMEDIATE 'drop index {{ this.table }}__index_on_{{ columns|join("_") }}';
    exception
    when index_not_exists
    then null
    ;
    end
    ;

{%- endmacro %}
