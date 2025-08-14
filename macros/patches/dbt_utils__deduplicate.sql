{#

Provide implementation for dbt_utils.deduplicate for missing adapters (Oracle/SQL Server)

https://github.com/dbt-labs/dbt-utils?tab=readme-ov-file#deduplicate-source

#}

{# TODO: no tests yet #}

{%- macro sqlserver__deduplicate(relation, partition_by, order_by) -%}

    select top 1
    with ties *
    from {{ relation }}
    order by row_number() over (partition by {{ partition_by }} order by {{ order_by }})

{%- endmacro -%}

{%- macro oracle__deduplicate(relation, partition_by, order_by) -%}

    select distinct row_numbered.*
    from
        (
            select
                a.*,
                row_number() over (
                    partition by {{ partition_by }} order by {{ order_by }}
                ) as rn
            from {{ relation }} a
        ) row_numbered
    where rn = 1

{%- endmacro -%}
