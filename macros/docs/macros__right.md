{% docs macros__right %}
Take the rightmost n characters of a string-column.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example
{% raw %}
```sql
-- text column
lf_utils.right('text', 3)

-- static text
lf_utils.right("'any_static_text'", 10)
```
{% endraw %}

# Notes
- This is just a thin wrapper around `dbt.right()`, because
they chose to not implement left, but its convenient to use left and right from the same
namespace (our lf_utils)

{% enddocs %}