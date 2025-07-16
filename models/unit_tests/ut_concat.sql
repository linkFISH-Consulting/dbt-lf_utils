with
    {# two elements #}
    row_0 as (select 'foo' as a, 'bar' as b),
    output_0 as (select {{ lf_utils.concat(['a', 'b']) }} as output from row_0),

    {# more elements #}
    row_1 as (select 'foo' as a, 'bar' as b, 'baz' as c),
    output_1 as (select {{ lf_utils.concat(['a', 'b', 'c']) }} as output from row_1),

    {# casting and manual string overrides #}
    row_2 as (select 1 as a, 'b' as b, 'not used' as c),
    output_2 as (select {{ lf_utils.concat(['a', 'b', "' c'"]) }} as output from row_2)

select *
from output_0
union all
select *
from output_1
union all
select *
from output_2
