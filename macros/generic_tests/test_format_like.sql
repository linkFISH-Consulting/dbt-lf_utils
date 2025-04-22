/* -------------------------------------------------------------------------- *
Author:        F. Paul Spitzner
Created:       2025-01-21
Last Modified: 2025-04-22
* --------------------------------------------------------------------------- *
* --------------------------------------------------------------------------- */

{% test format_like(model, compare_model, filter_condition=None) %}
  {{ return(adapter.dispatch('format_like', 'lf_utils')(model, compare_model, filter_condition)) }}
{% endtest %}

{% test default__format_like(model, column_name, pattern) %}

select
    *
from
    {{ model }}
where
    {{ column_name }} not like {{ pattern }}

{% endtest %}
