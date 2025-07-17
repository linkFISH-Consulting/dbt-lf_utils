{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-06-20 10:14:41
@Last Modified: 2025-07-17 09:19:57
------------------------------------------------------------------------------ #}

{# macrodocs
Combine a list of strings.

# Arguments
- fields : list of strings

# Example
```sql
-- text column
lf_utils.concat(['col1', 'col2', 'col3'])

-- column with static text
lf_utils.concat(['col1', "'static_text'"])
```
endmacrodocs #}

{% macro concat(fields) -%}
    {{ return(adapter.dispatch('concat')(fields)) }}
{% endmacro %}

{%- macro duckdb__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}

{%- macro postgres__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}

{%- macro sqlserver__concat(fields) %}
    concat({{ fields|join(', ') }})
{%- endmacro %}

{%- macro oracle__concat(fields) %}
    {{ fields|join(' || ') }}
{%- endmacro %}
