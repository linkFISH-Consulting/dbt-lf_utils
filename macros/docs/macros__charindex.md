{% docs macros__charindex %}

Find the first position of a substring in a string.

Returns 0 if the substring is not found.
If found, index starts counting at 1.

# Arguments
- substring : string
    The substring to search for.
- text : string
    The string to be searched.

# Example

-- text column
lf_utils.charindex('foo', col1)

-- column with static text
lf_utils.charindex('bar', "'foobar'")


{% enddocs %}