with months as (
    {{ lf_utils.get_months(2023, 2025) }}
)
select jahrmonat, jahrmonat_vormonat, jahrmonat_folgemonat, jahrmonat_vorjahr, jahrmonat_folgejahr, letzter_tag from months
