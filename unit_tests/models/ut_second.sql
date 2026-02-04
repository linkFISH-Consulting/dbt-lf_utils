-- Test extracting second from date_col
select {{ lf_utils.second("date_col") }} as output, 1 as test_id
from {{ ref("_dummy_source") }}

union all

-- Test extracting second from datetime_col
select {{ lf_utils.second("datetime_col") }} as output, 2 as test_id
from {{ ref("_dummy_source") }}

union all

-- Test that output type is an integer for all backends.
{% if target.type == "duckdb" %}
    select
        case
            when typeof({{ lf_utils.second("date_col") }}) in ('INTEGER', 'BIGINT') then 1
        end as output,
        3 as test_id
    from {{ ref("_dummy_source") }}
{% elif target.type == "postgres" %}
    select
        case
            when
                pg_typeof({{ lf_utils.second("date_col") }})::text
                in ('integer', 'smallint', 'bigint')
            then 1
        end as output,
        3 as test_id
    from {{ ref("_dummy_source") }}
{% elif target.type == "sqlserver" %}
    select
        case
            when
                sql_variant_property({{ lf_utils.second("date_col") }}, 'BaseType')
                = 'int'
            then 1
        end as output,
        3 as test_id
    from {{ ref("_dummy_source") }}
{% endif %}
