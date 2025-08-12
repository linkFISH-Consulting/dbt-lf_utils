Testing for DBT Packages is a bit unintuitive.
You need to create an _extra_ package in order to avoid projects that use your package to build your packages' modles (which are just tests).

See those guides for Details:
- https://docs.getdbt.com/guides/building-packages?step=4
- https://github.com/dbt-labs/dbt-codegen/blob/474f7a10582b74b03fa9c065847b6f0463d24c23/integration_tests/README.md

(In contrast to the guide, I called the folder `unit_tests`, cos sorry, they are not integration tests - they each just test a single functionality of a macro).
