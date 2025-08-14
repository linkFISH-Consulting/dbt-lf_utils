{# ------------------------------------------------------------------------------
@Author:        F. Paul Spitzner
@Created:       2025-01-20
@Last Modified: 2025-08-14 16:34:21
------------------------------------------------------------------------------ #}

{# TODO: no tests yet #}

{# macrodocs -------------------------------------------------------------------

Überprüfe Verschiebungen von Werten, z.b. Wert im Vormonat

Argumente:
- model: Model, wird von dbt automatisch gesetzt.
    Z.B. `ref('model_name')`)
- ref_col: Name der Spalte, die verschoben wird.
    Z.B. `wert`
- shift_col: Name der Spalte, mit der `ref_col` verglichen wird.
    Z.B. `wert_vormonat`
- dim_cols: Liste der Spalten, die den Index bilden.
    Z.B. `["gemeinde", "produktkonto_hist", "pos", "wert_typ"]`
- date_col: Name der Spalte, die das Datum enthält.
    Z.B. `jahrmonat`
- shift_unit: Einheit, um die verschoben wird.
    Z.B. `month` oder `year` (siehe dbt.dateadd())
- shift_amount: Anzahl der Einheiten, um die verschoben wird.
    Z.B. `-1` um zum Vormonat zu gehen

------------------------------------------------------------- endmacrodocs #}


{% test period_shift_is_consistent(
    model,
    dim_cols,
    ref_col,
    shift_col,
    shift_amount = -1,
    shift_unit = "month",
    date_col = "jahrmonat"
) %}

{# Rename, hat beim Denken geholfen #}
{% set col_monat = ref_col %}
{% set col_vormonat = shift_col %}

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
        {{ dim_cols | join(', ') }},
        {{ col_monat }},
        {{ col_vormonat }},
        {# make sure the format is usable, and avoid column name conflicts #}
        {# todo: date parsing

        old and manual for yyyymm:
        convert(date, left({{ date_col }}, 4) + '-' + right({{ date_col }}, 2) + '-01') as __date

        new code via dbt tested with yyyymm, not working with duckdb
        {{ dbt.safe_cast(date_col, api.Column.translate_type("date")) }} as __date
        #}
        {{ datefromparts(
            y=dbt.cast(left(date_col, 4), dbt.type_int()),
            m=dbt.cast(right(date_col, 2), dbt.type_int()),
            d=1
        ) }} as __date

    from {{ model }}
    {# from dummy_data #}
)

, model_shifted as (
    -- i.e. shift the date by 1 month into the past for shift_amount = -1
    select
        {{ dim_cols | join(', ') }},
        {{ col_vormonat }},
        {{ dbt.dateadd(
            datepart=shift_unit,
            interval=shift_amount,
            from_date_or_timestamp = '__date',
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
        {% for col in dim_cols -%}
            and model_shifted.{{ col }} = model_current.{{ col }}
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
