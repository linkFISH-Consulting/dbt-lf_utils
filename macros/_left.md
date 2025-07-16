The plan is to have these things auto-build from a comment block of our .sql files.

{% docs macros__left %}

Take the leftmost n characters of a string-column.

# Arguments
- text : string
    The column holding the string, or "'any_static_text'"
- len : integer
    Column holding a number, or a number. Cannot be negative.

# Example

select * from foo

so, seems we cannot write examples with jinja and macro usage:
https://github.com/dbt-labs/dbt-core/issues/11837



{% enddocs %}
