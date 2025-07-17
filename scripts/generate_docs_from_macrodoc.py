import os
import re
from pathlib import Path
import typer
import logging
from datetime import datetime

# --------------------------------- Log Setup -------------------------------- #

log = logging.getLogger(__name__)

# Define a new log level for success (between INFO and WARNING)
SUCCESS_LEVEL_NUM = 25
logging.addLevelName(SUCCESS_LEVEL_NUM, "SUCCESS")


def success(self, message, *args, **kwargs):
    if self.isEnabledFor(SUCCESS_LEVEL_NUM):
        self._log(SUCCESS_LEVEL_NUM, message, args, **kwargs)


logging.Logger.success = success


class TyperLogHandler(logging.Handler):
    # use logging with typer
    # https://github.com/fastapi/typer/issues/203#issuecomment-840690307

    def emit(self, record: logging.LogRecord) -> None:
        fg = None
        bg = None
        bold = False
        if record.levelno == logging.DEBUG:
            fg = typer.colors.BRIGHT_BLACK
        elif record.levelno == logging.INFO:
            fg = None
        elif record.levelno == SUCCESS_LEVEL_NUM:
            fg = typer.colors.GREEN
        elif record.levelno == logging.WARNING:
            fg = typer.colors.YELLOW
        elif record.levelno == logging.CRITICAL:
            fg = typer.colors.BRIGHT_RED
        elif record.levelno == logging.ERROR:
            fg = typer.colors.RED
            bold = True
        typer.secho(self.format(record), bg=bg, fg=fg, bold=bold)


# --------------------------------- App Setup -------------------------------- #
app = typer.Typer()


def extract_macrodoc_sections(file_path: Path) -> str:
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()
        pattern = re.compile(r"\{# macrodocs(.*?)endmacrodocs #\}", re.DOTALL)
        return pattern.findall(content)


@app.command()
def entrypoint(
    directory: str = typer.Argument(..., help="Directory to search for .sql files"),
):
    input_dir = Path(directory)
    dbt_yml_file = input_dir / "_docstrings.yml"
    output_dir = input_dir / "docs"
    output_dir.mkdir(exist_ok=True)

    # insert header for dbt_yml_file
    dbt_yml_content = "# this file is auto-generated. last updated: "
    dbt_yml_content += f"{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n"
    dbt_yml_content += "version: 2\n\nmacros:\n"

    sql_files = list(input_dir.rglob("*.sql"))
    for fp in sql_files:
        md_sections = extract_macrodoc_sections(fp)
        if len(md_sections) == 0:
            continue
        elif len(md_sections) > 1:
            log.warning(
                f"Multiple macrodoc sections found in {fp}, only the first one will be used"
            )

        # We want a flat file name, where folder structure is a prefix separated
        # by double underscore. e.g. folder_foo_bar__my_model.md
        parts = fp.relative_to(input_dir.parent).parts
        if len(parts) > 1:
            prefix = "_".join(parts[:-1])
            filename = parts[-1].replace(".sql", "")
            out_name = f"{prefix}__{filename}"
        else:
            out_name = parts[0].replace(".sql", "")

        # Markdown content needs to be wrapped in header and footer so dbt can find it
        output_content = "{% docs " + out_name + " %}\n"
        output_content += md_sections[0]
        output_content += "\n{% enddocs %}"

        output_fp = output_dir / (out_name + ".md")
        output_fp.write_text(output_content)

        # update the dbt_yml_file with the new macrodoc
        dbt_yml_content += f"  - name: {fp.stem}\n"
        dbt_yml_content += "    description: '{{ doc(\"" + out_name + "\") }}'\n\n"

    dbt_yml_file.write_text(dbt_yml_content)



def main():
    typer_handler = TyperLogHandler()
    logging.basicConfig(
        level=logging.DEBUG, handlers=(typer_handler,), format="%(message)s"
    )
    app()


if __name__ == "__main__":
    main()
