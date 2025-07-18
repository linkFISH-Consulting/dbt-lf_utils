select {{ lf_utils.left("text", "len") }} as output
from {{ ref("_dummy_source") }}
