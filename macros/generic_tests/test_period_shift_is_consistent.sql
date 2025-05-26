/* -------------------------------------------------------------------------- *
Author:        F. Paul Spitzner
Created:       2025-01-20
Last Modified: 2025-04-22
* --------------------------------------------------------------------------- *
Überprüfe Verschiebungen von Werten, z.b. Wert im Vormonat

Argumente:
- model: Model, wird von dbt automatisch gesetzt.
    Z.B. `ref('model_name')`)
- column_name: Name der Spalte, die verschoben wird.
    Z.B. `wert`
- column_to_compare_with: Name der Spalte, mit der `column_name` verglichen wird.
    Z.B. `wert_vormonat`
- index_columns: Liste der Spalten, die den Index bilden.
    Z.B. `["gemeinde", "produktkonto_hist", "pos", "wert_typ"]`
- date_column: Name der Spalte, die das Datum enthält.
    Z.B. `jahrmonat`
- shift_unit: Einheit, um die verschoben wird.
    Z.B. `month`
- shift_amount: Anzahl der Einheiten, um die verschoben wird.
    Z.B. `-1` um zum Vormonat zu gehen
* --------------------------------------------------------------------------- */

{% test period_shift_is_consistent(model, column_name, column_to_compare_with, index_columns, date_column, shift_amount, shift_unit) %}
  {{ return(adapter.dispatch('period_shift_is_consistent', 'lf_utils')(model, column_name, column_to_compare_with, index_columns, date_column, shift_amount, shift_unit)) }}
{% endtest %}

{% test default__period_shift_is_consistent(
    model,
    column_name,
    column_to_compare_with = "wert_vormonat",
    index_columns = ["gemeinde", "produktkonto_hist", "pos", "wert_typ"],
    date_column = "jahrmonat",
    shift_amount = -1,
    shift_unit = "month"
) %}

{# Umbennen, hat beim Denken geholfen #}
{% set col_monat = column_name %}
{% set col_vormonat = column_to_compare_with %}


with


dummy_data_1 as (
    select
        'dummy' as gemeinde,
        'dummy' as produktkonto,
        'dummy' as produktkonto_hist,
        'dummy' as pos,
        'dummy' as wert_typ_gruppe,
        'dummy' as wert_typ,
        '202501' as jahrmonat,
        1 as wert,
        2 as wert_vormonat
)

, dummy_data_2 as (
    select
        'dummy' as gemeinde,
        'dummy' as produktkonto,
        'dummy' as produktkonto_hist,
        'dummy' as pos,
        'dummy' as wert_typ_gruppe,
        'dummy' as wert_typ,
        '202502' as jahrmonat,
        5 as wert,
        1 as wert_vormonat
)

, dummy_data as (
    select * from dummy_data_1
    union all
    select * from dummy_data_2
)

, model_current as (
    select
        {{ index_columns | join(', ') }},
        {{ col_monat }},
        {{ col_vormonat }},
        {# make sure the format is usable, and avoid column name conflicts #}
        {# todo: date parsing

        old and manual for yyyymm:
        convert(date, left({{ date_column }}, 4) + '-' + right({{ date_column }}, 2) + '-01') as __date

        new code via dbt tested with yyyymm, not working with duckdb
        {{ dbt.safe_cast(date_column, api.Column.translate_type("date")) }} as __date
        #}
        {{ datefromparts(
            y=left(date_column, 4),
            m=right(date_column, 2),
            d=1
        ) }} as __date


    from {{ model }}
    {# from dummy_data #}
)

, model_shifted as (
    -- i.e. shift the date by 1 month into the past for shift_amount = -1
    select
        {{ index_columns | join(', ') }},
        {{ col_vormonat }},
        {{ dateadd(
            shift_unit,
            shift_amount,
            '__date',
        ) }} as __date
    from
        model_current
)

, models_joined as (
    select
        model_current.__date              as __date_current,
        model_shifted.__date              as __date_shifted,
        model_current.{{ col_monat }}     as __value_current,
        model_shifted.{{ col_vormonat }}  as __value_shifted
    from
        model_current
    left join
        model_shifted
        on model_shifted.__date = model_current.__date
        {% for index_column in index_columns -%}
            and model_shifted.{{ index_column }} = model_current.{{ index_column }}
        {% endfor %}
)

, final as (
    select
        *
    from
        models_joined
    where
        (
            models_joined.__value_shifted != models_joined.__value_current
            and models_joined.__value_shifted is not null
            and models_joined.__value_current is not null
        )
)

select * from final

{% endtest %}
