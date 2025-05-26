{% test future_years_exist(model, column_name) %}

WITH meet_condition AS (
  SELECT Jahr
  FROM {{ model }}
  WHERE {{ column_name }} > YEAR(CURRENT_TIMESTAMP)
),
validation_errors AS (
  -- If count(*) = 0 then return a row, else nothing
  SELECT
    CASE
      WHEN COUNT(*) = 0 THEN 1
      ELSE NULL
    END AS error
  FROM meet_condition
)

SELECT *
FROM validation_errors
WHERE error IS NOT NULL

{% endtest %}
