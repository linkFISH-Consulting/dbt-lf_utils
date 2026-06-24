# Check for --setup argument
$runSetup = $args -contains "--setup"

$adapters = @("duckdb", "mssql", "postgres")

# Load all non-comment key=value pairs from a .env file into the current process environment.
# Resolves ${VAR} interpolation using variables defined earlier in the same file.
function Import-DotEnv {
    param([string]$Path)
    $dotEnvVars = @{}

    Get-Content $Path | Where-Object { $_ -notmatch '^\s*#' -and $_ -match '=' } | ForEach-Object {
        $key, $value = $_ -split '=', 2
        $key   = $key.Trim()
        $value = $value.Trim()

        # Expand ${VAR_NAME} placeholders using variables already collected from this file
        $value = [regex]::Replace($value, '\$\{(\w+)\}', {
            param($matchResult)
            $referencedKey = $matchResult.Groups[1].Value
            if ($dotEnvVars.ContainsKey($referencedKey)) { $dotEnvVars[$referencedKey] }
            else { $matchResult.Value }   # leave unexpanded if the variable is not found
        })

        $dotEnvVars[$key] = $value
        [System.Environment]::SetEnvironmentVariable($key, $value, "Process")
    }
}

# On Windows, dbt copies local packages via shutil.copytree. When the destination
# is inside the source tree (local: ../ → unit_tests/dbt_packages/lf_utils/), Python
# recurses infinitely. Fix: copy only the relevant project files to a sibling directory
# OUTSIDE the tree, point packages.yml at it for the duration of dbt deps, then restore.
function Install-DbtPackagesSafe {
    $tempSource = [IO.Path]::GetFullPath((Join-Path $PWD '..\.lf_utils_pkg_source'))

    if (Test-Path $tempSource) { Remove-Item -Recurse -Force $tempSource }
    New-Item -ItemType Directory -Force -Path $tempSource | Out-Null

    # Copy project files, deliberately excluding anything that would create a cycle
    Get-ChildItem '.' -Exclude 'unit_tests','dbt_packages','.git','data','target' |
        Copy-Item -Destination $tempSource -Recurse

    $pkgYmlPath    = 'unit_tests\packages.yml'
    $originalYaml  = Get-Content $pkgYmlPath -Raw
    $tempSourceFwd = $tempSource.Replace('\', '/')   # dbt expects forward slashes

    Set-Content $pkgYmlPath "packages:`n    - local: $tempSourceFwd"
    try {
        dbt deps
    } finally {
        # Always restore packages.yml and remove temp source, even on failure
        Set-Content $pkgYmlPath $originalYaml
        Remove-Item -Recurse -Force $tempSource -ErrorAction SilentlyContinue
    }
}

if ($runSetup) {
    Import-DotEnv -Path 'config/.env'
    docker compose --env-file config/.env -f ./docker-compose.yml up -d

    $env:DBT_PROJECT_DIR = './unit_tests'
    Install-DbtPackagesSafe

    # Setup dummy db and debug for each adapter
    foreach ($adapter in $adapters) {
        $env:DBT_PROFILE = "lf_utils_$adapter"
        dbt debug
        dbt build --select _dummy_source
    }
}

foreach ($adapter in $adapters) {
    # Reload env vars each iteration to match bash behaviour (set -a; source; set +a)
    Import-DotEnv -Path 'config/.env'
    $env:DBT_PROFILE = "lf_utils_$adapter"
    $env:DBT_PROJECT_DIR = './unit_tests'
    # Use dbt build instead of dbt test: for DuckDB :memory: each dbt invocation starts
    # a fresh DB, so models must be materialized and tested in the same command.
    dbt build
}

if ($runSetup) {
    Write-Host "--------------------------------"
    Write-Host "Docker containers left running for future runs. To stop:"
    Write-Host "docker compose -f ./docker-compose.yml down"
}
