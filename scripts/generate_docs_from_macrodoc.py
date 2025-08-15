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


def extract_macrodoc_sections(content: str):
    # pattern = re.compile(r"\{# macrodocs(.*?)endmacrodocs #\}", re.DOTALL)
    # we now also ignore any content on the same line as the macrodocs keywords
    # which allows for --- delims.
    pattern = re.compile(
        r"\{# macrodocs(?:[^\n]*?)\n(.*?)\n[^\n]*?endmacrodocs #\}",
        re.DOTALL | re.MULTILINE,
    )
    return pattern.findall(content)

def find_macro_name(content: str) -> str | None:
    """
    Extract the macro name from the file path.
    The macro name is the stem of the file path, which is the file name without the extension.
    """
    pattern = re.compile(r"\{%(?:-{0,1}\s*)macro\s+(\w+)\(", re.DOTALL | re.MULTILINE)
    found = pattern.findall(content)
    if found is not None and len(found) > 0:
        # use first match so we avoid adapter specific ones (duckdb__my_macro)
        # they _usually_ are placed later.
        return found[0]

    # this might still be a test macro
    # defined with `{% test ... %}` instead of `{% macro ... %}`
    # and they need a different naming scheme for docs
    # https://docs.getdbt.com/best-practices/writing-custom-generic-tests#add-description-to-generic-data-test-logic
    pattern = re.compile(r"\{%(?:-{0,1}\s*)test\s+(\w+)\(", re.DOTALL | re.MULTILINE)
    found = pattern.findall(content)
    if found is not None and len(found) > 0:
        return "test_" + found[0]



def is_test_macro(content: str) -> bool:
    """
    Check if the macro is a test macro.
    Needed because they have a different naming pattern
    A test macro is defined with `{% test ... %}` instead of `{% macro ... %}`.
    """
    pattern = re.compile(r"\{%(?:-{0,1}\s*)test\s+(\w+)\(", re.DOTALL | re.MULTILINE)
    return bool(pattern.search(content))


def fix_code_blocks(raw_content: str) -> str:
    """
    Fix code blocks in the raw content by wrapping them in `{% raw %}` and `{% endraw %}`.
    This is necessary for dbt to correctly parse the markdown.
    """
    # Find all code blocks and wrap them
    code_block_pattern = re.compile(r"```(.*?)```", re.DOTALL)
    return code_block_pattern.sub(
        lambda m: "{% raw %}\n" + m.group(0) + "\n{% endraw %}", raw_content
    )


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
        md_sections = []
        macro_name = None
        with open(fp, "r", encoding="utf-8") as f:
            input_content = f.read()
            md_sections = extract_macrodoc_sections(input_content)
            macro_name = find_macro_name(input_content)
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
            filename = macro_name or parts[-1].replace(".sql", "")
            out_name = f"{prefix}__{filename}"
        else:
            out_name = parts[0].replace(".sql", "")

        # Markdown content needs to be wrapped in header and footer so dbt can find it
        output_content = "{% docs " + out_name + " %}\n"
        output_content += fix_code_blocks(md_sections[0])
        output_content += "\n{% enddocs %}"

        output_fp = output_dir / (out_name + ".md")
        output_fp.write_text(output_content)

        # update the dbt_yml_file with the new macrodoc
        dbt_yml_content += f"  - name: {macro_name or fp.stem}\n"
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
