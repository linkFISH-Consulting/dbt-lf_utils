{% for format in [
    "%Y%m%d",
    "%Y-%m-%d",
    "%Y/%m/%d",
    "%B %Y",
] %}
    select {{ lf_utils.date_strftime("date_col", format) }} as output
    from {{ ref("_dummy_source") }}

    union all

    select {{ lf_utils.date_strftime("datetime_col", format) }} as output
    from {{ ref("_dummy_source") }}

    {% if not loop.last %}
        union all
    {% endif %}

{% endfor %}
