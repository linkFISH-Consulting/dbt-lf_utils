{% docs macros__is_numeric %}


Check if a string can be safely cast to a number.

# Arguments
- text : string or string column

# Example

lf_utils.is_numeric("'123'") --> True
lf_utils.is_numeric("'123a'") --> False


{% enddocs %}