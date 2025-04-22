{% macro epoch_to_datetime(column_name, utc_conversion=false) %}
    {{ adapter.dispatch('epoch_to_datetime', 'lf_utils')(column_name, utc_conversion) }}
{% endmacro %}

{# SQL Server implementation #}
{% macro sqlserver__epoch_to_datetime(column_name, utc_conversion) %}

    {% set utc_datetime = "
        DATEADD(
            SECOND, 
            (NULLIF(
                CASE 
                    WHEN " ~ column_name ~ " < -2208988800 THEN -2208988800 
                    ELSE " ~ column_name ~ " 
                END, 
                0
            ) - DATEDIFF(second, GETDATE(), GETUTCDATE())) % (60*60*24), 
            DATEADD(
                DAY, 
                (NULLIF(
                    CASE 
                        WHEN " ~ column_name ~ " < -2208988800 THEN -2208988800 
                        ELSE " ~ column_name ~ " 
                    END, 
                    0
                ) - DATEDIFF(second, GETDATE(), GETUTCDATE())) / (60 * 60 * 24), 
                CAST(DATEFROMPARTS(1970, 1, 1) AS datetime2)
            )
        )
    " %}
    {% if utc_conversion %}
        /* Apply CET/CEST adjustment for local time */        
        DATEADD(
        HOUR,
        CASE 
            /* Applying a 2-hour offset for CEST from last Sunday in March to last Sunday in October */
            WHEN 
                (MONTH({{ utc_datetime }}) BETWEEN 4 AND 9)
                OR (MONTH({{ utc_datetime }}) = 3 
                    AND DATEPART(WEEKDAY, {{ utc_datetime }}) >= 25)
                OR (MONTH({{ utc_datetime }}) = 10 
                    AND DATEPART(WEEKDAY, {{ utc_datetime }}) < 25)
            THEN 2  /* CEST (UTC + 2) */
            ELSE 1  /* CET (UTC + 1) */
        END,
        {{ utc_datetime }}
    )
    {% else %}
        /* Return UTC datetime without any further modification */
        {{ utc_datetime }}
    {% endif %}    
{% endmacro %}

{# Postgres implementation #}
{% macro postgres__epoch_to_datetime(column_name, utc_conversion) %}
    {% set utc_datetime = "TO_TIMESTAMP(" ~ column_name ~ ")" %}
    {% if utc_conversion %}
        /* Apply CET/CEST adjustment for local time */
        ({{ utc_datetime }} AT TIME ZONE 'UTC' AT TIME ZONE 'Europe/Berlin')
    {% else %}
        /* Return UTC datetime */
        ({{ utc_datetime }} AT TIME ZONE 'UTC')
    {% endif %}
{% endmacro %}

{# DuckDB implementation #}
{% macro duckdb__epoch_to_datetime(column_name, utc_conversion) %}
    {% set utc_datetime = "to_timestamp(" ~ column_name ~ ")" %}
    {% if utc_conversion %}
        /* Convert to Europe/Berlin time zone */
        timezone('Europe/Berlin', {{ utc_datetime }})
    {% else %}
        /* Return UTC timestamp */
        {{ utc_datetime }}
    {% endif %}
{% endmacro %}