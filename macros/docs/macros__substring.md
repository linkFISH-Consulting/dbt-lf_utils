{% docs macros__substring %}
Extract characters from a string by position.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- start : integer
    The position to start from, 1-based index. Cannot be negative.
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example
{% raw %}
```sql

select
    -- common use case: text from column, with hardcoded postion and length
    {{ lf_utils.substring("text_col", 7, 4) }} as from_col,

    -- positions defined in columns, too
    {{ lf_utils.substring("text_col", "pos_col", "len_col") }} as from_col_dynamic,

    -- from static text -> 'atic'
    {{ lf_utils.substring("'static'", 3, 4) }} as from_static
```
{% endraw %}

# Notes
- Also consider using `dbt.split_part`

{% enddocs %}