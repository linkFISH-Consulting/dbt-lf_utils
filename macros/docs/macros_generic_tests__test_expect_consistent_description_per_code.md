{% docs macros_generic_tests__test_expect_consistent_description_per_code %}
Test: expect_consistent_description_per_code

Description:
Prüfung, ob die Bezeichnungen (desc_*) zu den jeweiligen Schlüsseln (code_*)
über alle Datensätze hinweg eindeutig sind.

Hintergrund (Mandantenfähigkeit):
IDs (z.B. code_massnahme) könnten über mehrere Mandanten hinweg verwendet werden.
Wenn derselbe Code bei verschiedenen Mandanten unterschiedliche Beschreibungen
(desc_massnahme) hat, deutet das auf einen Konflikt hin: Die Codes sind nicht
mandantenübergreifend eindeutig. In diesem Fall müsste die Logik im Modell
angepasst werden, sodass die ID mandantenspezifisch gebildet wird (z.B. als
zusammengesetzter Key aus Mandant + Code).

Ablauf:
1. Sucht alle Spalten, die mit 'code_' beginnen.
2. Prüft, ob es eine exakt korrespondierende 'desc_'-Spalte gibt.
3. Generiert dynamisch Queries, die Alarm schlagen, sobald ein Code > 1 Description hat.

Example:
{% raw %}
```yaml
models:
  - name: my_awesome_model
    data_tests:
      - lf_utils.expect_consistent_description_per_code
```
{% endraw %}
{% enddocs %}