{% docs macros_patches__dbt__generate_alias_name %}

**Automatically invoked by dbt**, does not need to be called.
[Check disptach search order](https://docs.getdbt.com/reference/dbt-jinja-functions/dispatch#overriding-global-macros)

Overwrite the default way dbt generates the alias from the model file name.

- The alias is the name that will occur as the table name in the database.
- We remove everything until including the double underscore `__` which we
  use as prefix for model file names to represent the folder structure.
- For example: `int_huh_sup__pos_monat_erg.sql` -> `pos_monat_erg`
- Supports model versions

{% enddocs %}