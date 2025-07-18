select {{ lf_utils.right("text", "len") }} as output
from {{ ref("_dummy_source") }}
