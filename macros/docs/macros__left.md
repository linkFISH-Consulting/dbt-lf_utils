{% docs macros__left %}

Take the leftmost n characters of a string-column.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example
{% raw %}
```sql
-- text column
lf_utils.left('text', 3)

-- static text
lf_utils.left("'any_static_text'", 3)
```
{% endraw %}

.

{% enddocs %}
