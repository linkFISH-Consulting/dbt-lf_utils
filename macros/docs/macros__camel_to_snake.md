{% docs macros__camel_to_snake %}

Generate snake_case from inconsistently cased strings like 'bdgmPersID_Monat'

Only works on the jinja side, **do not** pass a column as the argument!

# Arguments
- text : string

# Example

{% raw %}
```sql
{{ lf_utils.camel_to_snake("bdgmPersID_Monat") }}
```
{% endraw %}


{% enddocs %}