select {{ lf_utils.is_int('text') }} as output
from {{ ref('_dummy_source') }}
