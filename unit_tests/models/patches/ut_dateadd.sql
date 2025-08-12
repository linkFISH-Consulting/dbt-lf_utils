{% for datepart in ["day", "month", "year"] %}

    select {{ dbt.dateadd(datepart, 1, "date_col") }} as output
    from {{ ref("_dummy_source") }}

    union all

    select {{ dbt.dateadd(datepart, 1, "datetime_col") }} as output
    from {{ ref("_dummy_source") }}

    {% if not loop.last %}
        union all
    {% endif %}

{% endfor %}
