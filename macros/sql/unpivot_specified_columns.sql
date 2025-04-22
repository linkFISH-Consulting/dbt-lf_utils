{#
Author: Florian Deutsch / linkFISH

Description:
Pivot values from specified columns to rows. Similar to pandas DataFrame melt() function.

Example Usage: {{ unpivot(relation=ref('users'), cast_to='varchar', include_columns = ['col_to_keep'], unpivot_columns=['col_to_unpivot_1','col_to_unpivot_2']) }}

Arguments:
    relation: Relation object, required.
    cast_to: The datatype to cast all unpivoted columns to. Default is varchar.
    include_columns: A list of columns to keep but exclude from the unpivot operation. Default is none.
    unpivot_columns: A list of columns to include in the unpivot operation. Default is none.
    field_name: Destination table column name for the source table column names.
    value_name: Destination table column name for the pivoted values
    exclude_null_values: Whether to exclude NULL values or not (default true)
    quote_identifiers: Whether to quote the columns or not (default false)
#}

{% macro unpivot_specified_columns(relation=none, cast_to='varchar', include_columns=[], unpivot_columns=[], field_name='field_name', value_name='value', exclude_null_values=True, quote_identifiers=False) -%}
    {{ return(adapter.dispatch('unpivot_specified_columns', 'lf_utils')(relation, cast_to, include_columns, unpivot_columns, field_name, value_name, exclude_null_values, quote_identifiers)) }}
{% endmacro %}

{% macro default__unpivot_specified_columns(relation=none, cast_to='varchar', include_columns=[], unpivot_columns=[], field_name='field_name', value_name='value', exclude_null_values=True, quote_identifiers=False) -%}

  {% if not relation %}
    {{ exceptions.raise_compiler_error("Error: argument `relation` is required for `unpivot` macro.") }}
  {% endif %}

  {%- set include_columns = include_columns if include_columns is not none else [] %}
  {%- set include_cols = [] %}  
  {%- set cols = adapter.get_columns_in_relation(relation) %}

  {%- for col in cols -%}
    {%- if col.column.lower() in unpivot_columns|map('lower') and col.column.lower() not in include_columns|map('lower') -%}
      {% do include_cols.append(col) %}
    {%- endif %}
  {%- endfor %}

  {%- for col in include_cols -%}
      {%- set current_col_name = adapter.quote(col.column) if quote_identifiers else col.column -%}
      SELECT

        {%- for include_col in include_columns %}
          {{ adapter.quote(include_col) if quote_identifiers else include_col }},
        {%- endfor %}

        CAST('{{ col.column }}' AS {{ dbt.type_string() }}) AS {{ adapter.quote(field_name) if quote_identifiers else field_name  }},
        CAST(  {% if col.data_type == 'boolean' %}
            {{ dbt.cast_bool_to_text(current_col_name) }}
              {% else %}
            {{ current_col_name }}
              {% endif %}
            AS {{ cast_to }}) AS {{ adapter.quote(value_name) if quote_identifiers else value_name }}

      FROM {{ relation }}
      {%- if exclude_null_values %}
        WHERE {{ adapter.quote(current_col_name) if quote_identifiers else current_col_name }} IS NOT NULL
      {%- endif %}
      {% if not loop.last -%}
        UNION ALL
      {% endif -%}
  {%- endfor -%}

{%- endmacro %}
