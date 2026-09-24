{% for datetime_string, format in [
    ("text", "%Y-%m-%d %H:%M:%S"),
    ("'2021-03-04T13:01:01'", "%Y-%m-%dT%H:%M:%S"),
    ("'20210304'", "%Y%m%d"),
    ("'210304'", "%y%m%d")
] %}
    select {{ lf_utils.datetime_from_strftime(datetime_string, format) }} as output
    from {{ ref("_dummy_source") }}

    {% if not loop.last %}
        union all
    {% endif %}
{% endfor %}
