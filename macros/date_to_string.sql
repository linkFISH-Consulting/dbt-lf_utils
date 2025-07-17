{# macrodocs
Convert a date column into a string representation, using MSSQL date format codes.

# Arguments
- date_col : date/timestamp column
    The date column to convert to string
- format : int, default 112 (cannot be a column)
    Supported codes:
    - 103 = dd/mm/yyyy
    - 104 = dd.mm.yyyy
    - 112 = yyyymmdd
    - "MMMM yyyy" = Month Year (e.g. "January 2025")
- len : int, or int-column, default 10
    Length to truncate result to. For example, format 112 with len=4 returns just the year (yyyy)

# Example

-- Convert date to yyyymmdd string
lf_utils.date_to_string('my_date', 112)

-- Get just the year from a date
lf_utils.date_to_string('my_date', 112, 4)

-- Get date in dd.mm.yyyy format
lf_utils.date_to_string('my_date', 104)

-- Get month and year in text format
lf_utils.date_to_string('my_date', 'MMMM yyyy')

endmacrodocs #}

{% macro date_to_string(date_col, format=112, len=42) %}
    {# 42 should be long enough for the supported formats #}
    {{
        return(
            adapter.dispatch("date_to_string", "lf_utils")(date_col, format, len)
        )
    }}
{% endmacro %}

{%- macro duckdb__date_to_string(date_col, format, len) %}
    {%- if format == 103 %}
        substr(strftime({{ date_col }}, '%d/%m/%Y'), 1, {{ len }})
    {%- elif format == 104 %}
        substr(strftime({{ date_col }}, '%d.%m.%Y'), 1, {{ len }})
    {%- elif format == 112 %}
        substr(strftime({{ date_col }}, '%Y%m%d'), 1, {{ len }})
    {%- elif format == "MMMM yyyy" %}
        strftime({{ date_col }}, '%B %Y')
    {% endif %}
{%- endmacro %}

{%- macro postgres__date_to_string(date_col, format, len) %}
    {%- if format == 103 %}
        substring(to_char({{ date_col }}, 'dd/mm/yyyy') from 1 for {{ len }})
    {%- elif format == 104 %}
        substring(to_char({{ date_col }}, 'dd.mm.yyyy') from 1 for {{ len }})
    {%- elif format == 112 %}
        substring(to_char({{ date_col }}, 'yyyymmdd') from 1 for {{ len }})
    {% endif %}
{%- endmacro %}

{%- macro sqlserver__date_to_string(date_col, format, len) %}
    {%- if format == "MMMM yyyy" %}
        format({{ date_col }}, n 'MMMM yyyy', 'de-DE')
    {%- else %}
        left(convert(varchar, {{ date_col }}, {{ format }}), {{ len }})
    {% endif %}
{%- endmacro %}

{%- macro oracle__date_to_string(date_col, format, len) %}
    {%- if format == 103 %}
        substr(to_char({{ date_col }}, 'DD/MM/YYYY'), 1, {{ len }})
    {%- elif format == 104 %}
        substr(to_char({{ date_col }}, 'DD.MM.YYYY'), 1, {{ len }})
    {%- elif format == 112 %}
        substr(to_char({{ date_col }}, 'YYYYMMDD'), 1, {{ len }})
    {% endif %}
{%- endmacro %}
