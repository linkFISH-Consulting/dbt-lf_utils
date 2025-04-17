/*
Like dbt and mssql dateadd function, but for more databases.

Arguments:
    datepart: The part of the date to add to (e.g., 'd', 'm', 'y')
    number: The amount to add (can be negative)
    from_date_or_timestamp: The date or timestamp to which the interval will be added
*/
{% macro dateadd(datepart, number, from_date_or_timestamp) %}

    {{ return(adapter.dispatch('dateadd', 'lf_utils')(datepart, number, from_date_or_timestamp)) }}

{% endmacro %}

{% macro default__dateadd(datepart, number, from_date_or_timestamp) %}

    dateadd({{ datepart }}, {{ number }}, {{ from_date_or_timestamp }})

{% endmacro %}

/* -------------------------------- bigquery -------------------------------- */

{% macro bigquery__dateadd(datepart, number, from_date_or_timestamp) %}

    date_add({{ from_date_or_timestamp }}, interval {{ number }} {{ datepart }})

{% endmacro %}

/* --------------------------------- duckdb --------------------------------- */

{% macro duckdb__dateadd(datepart, number, from_date_or_timestamp) %}
    {% if datepart == "d" %}
        {% set datepart = "day" %}
    {% elif datepart == "m" %}
        {% set datepart = "month" %}
    {% elif datepart == "y" %}
        {% set datepart = "year" %}
    {% endif %}

    {# duckdb needs () around number - otherwise negative shifts dont work! #}
    date_add({{ from_date_or_timestamp }}, interval ({{ number }}) {{ datepart }})

{% endmacro %}

/* --------------------------------- oracle --------------------------------- */

{% macro oracle__dateadd(datepart, number, from_date_or_timestamp) %}

    {% set datepart_string = datepart | string %}

    {% if datepart == "d" and datepart_string("-") %}
        {{ from_date_or_timestamp }} - {{ number }}
    {% elif datepart == "d" %}
        {{ from_date_or_timestamp }} + {{ number }}
    {% elif datepart == "m" %}
        add_months({{ from_date_or_timestamp }}, {{ number }})
    {% elif datepart == "y" %}
        add_months({{ from_date_or_timestamp }}, {{ number }} * {{ 12 }})
    {% endif %}

{% endmacro %}

/* -------------------------------- postgres -------------------------------- */

{% macro postgres__dateadd(datepart, number, from_date_or_timestamp) %}
    {{ from_date_or_timestamp }} + ((interval '1 {{ datepart }}') * ({{ number }}))
{% endmacro %}
