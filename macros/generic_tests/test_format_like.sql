/* -------------------------------------------------------------------------- *
Author:        F. Paul Spitzner
Email:         paul.spitzner@linkfish.eu
Created:       2025-01-21
Last Modified: 2025-01-21
* --------------------------------------------------------------------------- *
* --------------------------------------------------------------------------- */

{% test format_like(
    model,
    column_name,
    pattern
) %}

select
    *
from
    {{ model }}
where
    {{ column_name }} not like {{ pattern }}

{% endtest %}
