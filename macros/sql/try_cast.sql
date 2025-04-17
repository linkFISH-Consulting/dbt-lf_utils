{% macro try_cast(str, datatype) %}
    {{ return(adapter.dispatch('try_cast', 'lf_utils')(str, datatype)) }}
{% endmacro %}

{% macro default__try_cast(fieldName, datatype) %}
    TRY_CAST({{ fieldName }} AS {{datatype}})
{% endmacro %}

{% macro oracle__try_cast(fieldName, datatype) %}
    CAST({{ fieldName }} AS {{datatype}} DEFAULT NULL ON CONVERSION ERROR)
{% endmacro %}

{% macro sqlserver__try_cast(fieldName, datatype) %}
    TRY_CAST({{ fieldName }} AS {{datatype}})
{% endmacro %}