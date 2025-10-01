with
    test_data as (
        select 1 as id, 'apple' as text
        union all
        select 2, 'banana'
        union all
        select 3, 'cherry'
    )

select id from (

    {# check empty works #}
    select id, text
    from test_data
    where {{ lf_utils.filter(col="test_data.id", in_values=[]) }}

    union all

    {# check integers work #}
    select id, text
    from test_data
    where {{ lf_utils.filter(col="test_data.id", in_values=[1, 2]) }}

    union all

    {# check strings work #}
    select id, text
    from test_data
    where {{ lf_utils.filter(col="test_data.text", in_values=['banana', 'cherry']) }}

    union all

    {# check multiple combinations #}
    select id, text
    from test_data
    where {{ lf_utils.filter(col="test_data.id", in_values=[1, 2]) }}
    and {{ lf_utils.filter(col="test_data.text", in_values=['banana', 'cherry']) }}

    union all

    {# no match #}
    select id, text
    from test_data
    where {{ lf_utils.filter(col="test_data.id", in_values=[4]) }}

) as test_result
