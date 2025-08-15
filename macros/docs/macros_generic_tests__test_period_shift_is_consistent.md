{% docs macros_generic_tests__test_period_shift_is_consistent %}

Überprüfe Verschiebungen von Werten, z.b. Wert im Vormonat

Argumente:
- model: Model, wird von dbt automatisch gesetzt.
    Z.B. `ref('model_name')`)
- ref_col: Name der Spalte, die verschoben wird.
    Z.B. `wert`
- shift_col: Name der Spalte, mit der `ref_col` verglichen wird.
    Z.B. `wert_vormonat`
- dim_cols: Liste der Spalten, die den Index bilden.
    Z.B. `["gemeinde", "produktkonto_hist", "pos", "wert_typ"]`
- date_col: Name der Spalte, die das Datum enthält.
    Z.B. `jahrmonat`
- shift_unit: Einheit, um die verschoben wird.
    Z.B. `month` oder `year` (siehe dbt.dateadd())
- shift_amount: Anzahl der Einheiten, um die verschoben wird.
    Z.B. `-1` um zum Vormonat zu gehen

{% enddocs %}