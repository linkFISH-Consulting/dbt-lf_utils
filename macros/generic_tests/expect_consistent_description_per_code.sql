{# ------------------------------------------------------------------------------
@Author:        Tom Sternberg/Florian Deutsch
@Created:       2026-06-24
------------------------------------------------------------------------------ #}
{# macrodocs -------------------------------------------------------------------
Test: expect_consistent_description_per_code

Description:
Prüfung, ob die Bezeichnungen (desc_*) zu den jeweiligen Schlüsseln (code_*)
über alle Datensätze hinweg eindeutig sind.

Hintergrund (Mandantenfähigkeit):
IDs (z.B. code_massnahme) könnten über mehrere Mandanten hinweg verwendet werden.
Wenn derselbe Code bei verschiedenen Mandanten unterschiedliche Beschreibungen
(desc_massnahme) hat, deutet das auf einen Konflikt hin: Die Codes sind nicht
mandantenübergreifend eindeutig. In diesem Fall müsste die Logik im Modell
angepasst werden, sodass die ID mandantenspezifisch gebildet wird (z.B. als
zusammengesetzter Key aus Mandant + Code).

Ablauf:
1. Sucht alle Spalten, die mit 'code_' beginnen.
2. Prüft, ob es eine exakt korrespondierende 'desc_'-Spalte gibt.
3. Generiert dynamisch Queries, die Alarm schlagen, sobald ein Code > 1 Description hat.

Example:
```yaml
models:
  - name: my_awesome_model
    data_tests:
      - lf_utils.expect_consistent_description_per_code
```
------------------------------------------------------------- endmacrodocs #}
{% test expect_consistent_description_per_code(model) %}
    {%- set all_columns = dbt_utils.get_filtered_columns_in_relation(from=model) -%}
    {%- set valid_pairs = [] -%}

    {# 1. Identifiziere alle korrespondierenden code_/desc_ Paare #}
    {%- for col in all_columns -%}
        {%- set col_name = col | string | lower -%}

        {%- if col_name.startswith("code_") -%}
            {%- set expected_desc = col_name | replace("code_", "desc_", 1) -%}

            {%- for check_col in all_columns -%}
                {%- set check_col_name = check_col | string | lower -%}
                {%- if check_col_name == expected_desc -%}
                    {%- do valid_pairs.append({"code": col, "desc": check_col}) -%}
                {%- endif -%}
            {%- endfor -%}
        {%- endif -%}
    {%- endfor -%}

    {# --- 2. Generiere den Validierungs-Query per UNION ALL --- #}
    with
        validation_errors as (

            {%- if valid_pairs | length > 0 -%}

                {%- for pair in valid_pairs %}
                    /* Prüfe Inkonsistenzen für das Paar: {{ pair.code }} -> {{ pair.desc }} */
                    select
                        '{{ pair.code }}' as code_column,
                        '{{ pair.desc }}' as desc_column,
                        cast({{ pair.code }} as {{ dbt.type_string() }}) as code_value,
                        count(distinct {{ pair.desc }}) as unique_desc_count
                    from {{ model }}
                    where {{ pair.code }} is not null
                    group by {{ pair.code }}
                    having count(distinct {{ pair.desc }}) > 1

                    {% if not loop.last %}
                        union all
                    {% endif %}
                {%- endfor %}

            {%- else -%}

                /* Fallback: Keine passenden code_/desc_ Paare in diesem Modell gefunden. */
                select
                    cast(null as {{ dbt.type_string() }}) as code_column,
                    cast(null as {{ dbt.type_string() }}) as desc_column,
                    cast(null as {{ dbt.type_string() }}) as code_value,
                    0 as unique_desc_count
                where 1 = 0

            {%- endif -%}
        )

    select *
    from validation_errors

{% endtest %}
