{# overwrite dbt_utils.deduplicate Oracle/SQL Server #}

{%- macro oracle__deduplicate(relation, partition_by, order_by) -%}

    select
    distinct row_numbered.*
    FROM (
        SELECT
            a.*,
            row_number() OVER (
                PARTITION BY {{ partition_by }}
                ORDER BY {{ order_by }}
            ) as rn
        from {{ relation }} a
    ) row_numbered
    where rn = 1

{%- endmacro -%}

{%- macro sqlserver__deduplicate(relation, partition_by, order_by) -%}

    SELECT TOP 1 WITH ties
        *
    FROM {{ relation }}
    ORDER BY row_number() OVER (
        PARTITION BY {{ partition_by }}
        ORDER BY {{ order_by }}
    )

{%- endmacro -%}
