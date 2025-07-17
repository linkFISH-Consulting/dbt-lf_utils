{% docs macros__concat %}

Combine a list of strings.

# Arguments
- fields : list of strings

# Example

-- text column
lf_utils.concat(['col1', 'col2', 'col3'])

-- column with static text
lf_utils.concat(['col1', "'static_text'"])


{% enddocs %}