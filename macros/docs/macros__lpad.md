{% docs macros__lpad %}
Pad a string-column on the left with a specified character to a given length.

# Arguments
- text : column specifier or text
    The column holding the text to be padded
- len : integer or integer column
    The target length of the padded string. Cannot be negative.
- padding : string
    The character to pad with.

# Note
For compatibility across adapters, the input text column is
converted to `varchar(255)` before padding.

# Example
{% raw %}
```sql
-- Assume `col_name` holds "foo"
-- Pad to length 5 with zeros
{{ lf_utils.lpad('col_name', 5, "0") }} --> '00foo'

-- If length is smaller than text, we truncate from the right
{{ lf_utils.lpad("col_name", 2, '*') }} --> 'fo'

-- Pad static text but with possibly changing length column
-- e.g. if it holds an 8 for this row
{{ lf_utils.lpad("'static'", "col_with_lens", '*') }}--> '**static'
```
{% endraw %}

{% enddocs %}