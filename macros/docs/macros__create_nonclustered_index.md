{% docs macros__create_nonclustered_index %}
Create a nonclustered index.

# Arguments
- columns : list of strings
    Columns to be indexed.
- includes : list of strings (optional)
    Additional columns to include in the index (where supported).

# Example
{% raw %}
```sql
{{ lf_utils.create_nonclustered_index(['col1', 'col2'], ['col3']) }}
```
{% endraw %}

# Notes
- [What's a Non-Clustered Index](https://www.geeksforgeeks.org/sql/clustered-and-non-clustered-indexing/)
- [SO on non-clustered includes](https://stackoverflow.com/questions/1307990/why-use-the-include-clause-when-creating-an-index)

{% enddocs %}