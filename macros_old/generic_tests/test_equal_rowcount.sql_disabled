{% test equal_rowcount(model, compare_model, filter_condition=None) %}
  {{ return(adapter.dispatch('equal_rowcount', 'lf_utils')(model, compare_model, filter_condition)) }}
{% endtest %}

{% test default__equal_rowcount(model, compare_model, filter_condition=None) %}
 
WITH source_count AS (
    SELECT COUNT(*) AS cnt FROM {{ model }}
    {% if filter_condition %}
      WHERE {{ filter_condition }}
    {% endif %}
),
 
target_count AS (
    SELECT COUNT(*) AS cnt FROM {{ compare_model }}
    {% if filter_condition %}
      WHERE {{ filter_condition }}
    {% endif %}
),
 
validation AS (
    SELECT 
        source_count.cnt AS source_cnt,
        target_count.cnt AS target_cnt
    FROM source_count, target_count
)
 
SELECT * FROM validation
WHERE source_cnt != target_cnt
 
{% endtest %}
