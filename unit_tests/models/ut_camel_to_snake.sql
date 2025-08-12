with input as (
    select '{{ lf_utils.camel_to_snake("fooBar") }}'  as text
    union all
    select '{{ lf_utils.camel_to_snake("Foo_Bar") }}'  as text
    union all
    select '{{ lf_utils.camel_to_snake("FooBAR") }}'  as text
    union all
    select '{{ lf_utils.camel_to_snake("_fooBar") }}'  as text
    union all
    select '{{ lf_utils.camel_to_snake("FooBAR_ID") }}'  as text
)

select
    text as output
from input
