{% macro try_cast(fieldName, datatype) %}
    {{ return(adapter.dispatch('try_cast', 'lf_utils')(fieldName, datatype)) }}
{% endmacro %}

{% macro default__try_cast(fieldName, datatype) %}
    TRY_CAST({{ fieldName }} AS {{datatype}})
{% endmacro %}

{% macro oracle__try_cast(fieldName, datatype) %}
    CAST({{ fieldName }} AS {{datatype}} DEFAULT NULL ON CONVERSION ERROR)
{% endmacro %}

{% macro sqlserver__try_cast(fieldName, datatype) %}
    {% set lowercaseDatatype = datatype|lower %}

    {% if lowercaseDatatype == 'date' %}
        CASE 
            WHEN {{ fieldName }} LIKE '__.__.____' THEN TRY_CONVERT(DATE, {{ fieldName }}, 104) 	
            ELSE TRY_CAST({{ fieldName }} AS DATE) 
        END
    {% else %}
        TRY_CAST({{ fieldName }} AS {{ datatype }})
    {% endif %}
{% endmacro %}