{% macro create_nonclustered_index(columns, includes) %}
    {{ return(adapter.dispatch('create_nonclustered_index')(columns, includes)) }}
{% endmacro %}

{%- macro default__create_nonclustered_index(columns, includes) %}
{%- endmacro %}

{%- macro oracle__create_nonclustered_index(columns, includes) %}

    CREATE INDEX 
    {{ this.table }}__index_on_{{ columns|join("_") }}
    on {{ this }} ({{ '"' + columns|join('","') + '"' }})

{%- endmacro %}

{%- macro sqlserver__create_nonclustered_index(columns, includes) %}
    {% if includes is undefined %}

    create nonclustered index 
    {{ this.table }}__index_on_{{ columns|join("_") }}
    on {{ this }} ({{ '[' + columns|join("], [") + ']' }})
    
    {% else %}

    create nonclustered index 
    {{ this.table }}__index_on_{{ columns|join("_") }}
    on {{ this }} ({{ '[' + columns|join("], [") + ']' }})
    include ({{ '[' + includes|join("], [") + ']' }})

    {% endif %}
{%- endmacro %}