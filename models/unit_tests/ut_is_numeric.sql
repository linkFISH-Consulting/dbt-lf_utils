select {{ lf_utils.is_numeric('text') }} as output
from {{ ref('_dummy_source') }}
