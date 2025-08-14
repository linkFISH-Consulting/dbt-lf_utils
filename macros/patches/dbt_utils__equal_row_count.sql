{# TODO: no tests yet #}

{% macro sqlserver__test_equal_rowcount(model, compare_model, group_by_columns) %}

{#-- Needs to be set at parse time, before we return '' below --#}
{{ config(fail_calc = 'sum(coalesce(diff_count, 0))') }}

{#-- Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
{%- if not execute -%}
    {{ return('') }}
{% endif %}

{% if group_by_columns|length() > 0 %}
  {% set select_gb_cols = group_by_columns|join(', ') + ', ' %}
  {% set join_gb_cols %}
    {% for c in group_by_columns %}
      and a.{{c}} = b.{{c}}
    {% endfor %}
  {% endset %}
  {% set groupby_gb_cols = 'group by ' + group_by_columns|join(',') %}
{% else %}
  {% set select_gb_cols = '' %}
  {% set join_gb_cols = '' %}
  {% set groupby_gb_cols = '' %}
{% endif %}

select
    a.id_dbtutils_test_equal_rowcount as id_dbtutils_test_equal_rowcount_a,
    b.id_dbtutils_test_equal_rowcount as id_dbtutils_test_equal_rowcount_b,
    {% for c in group_by_columns -%}
        a.{{c}} as {{c}}_a,
        b.{{c}} as {{c}}_b,
    {% endfor %}

    count_a,
    count_b,
    abs(count_a - count_b) as diff_count

from
    (
        select
            {{select_gb_cols}}
            1 as id_dbtutils_test_equal_rowcount,
            count(*) as count_a
        from {{ model }}
        {{groupby_gb_cols}}
    ) as a
full join
    (
        select
            {{select_gb_cols}}
            1 as id_dbtutils_test_equal_rowcount,
            count(*) as count_b
        from {{ compare_model }}
        {{groupby_gb_cols}}
    ) as b
on
    a.id_dbtutils_test_equal_rowcount = b.id_dbtutils_test_equal_rowcount
    {{join_gb_cols}}


{% endmacro %}
