{% docs macros_patches__dbt__generate_schema_name %}

**Automatically invoked by dbt**, does not need to be called.
[Check disptach search order](https://docs.getdbt.com/reference/dbt-jinja-functions/dispatch#overriding-global-macros)

This macro prepends the target as a prefix for to the schema of tables and views
that will materialize in the database - for all targets except 'prod'.

In particular, the dev target gets a dev_ prefix, while the prod target is NOT prefixed

{% enddocs %}