{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-07-17 09:28:33
@Last Modified: 2025-08-11 13:27:17
------------------------------------------------------------------------------ #}


{# macrodocs
Generate snake_case from inconsistently cased strings like 'bdgmPersID_Monat'

Only works on the jinja side, **do not** pass a column as the argument!

# Arguments
- text : string

# Example

```sql
{{ lf_utils.camel_to_snake("bdgmPersID_Monat") }}
```

endmacrodocs #}


{%- macro camel_to_snake(name) -%}
    {%- set s1 = modules.re.sub('(.)([A-Z][a-z]+)', '\\1_\\2', name) -%}
    {%- set s2 = modules.re.sub('([a-z0-9])([A-Z])', '\\1_\\2', s1) | lower -%}
    {%- set s3 = modules.re.sub('_+', '_', s2) -%}
    {{ s3 }}
{%- endmacro -%}
