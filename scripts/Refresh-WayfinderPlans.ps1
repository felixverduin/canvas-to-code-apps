# Refresh every Wayfinder map's ignored viewer cache from GitHub, the source of truth.
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$')]
    [string] $Repository
)

$ErrorActionPreference = 'Stop'
$repo = $Repository
$planRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../.plan'))

function Read-GitHubJson([string] $endpoint) {
    $json = gh api --paginate --slurp $endpoint
    if ($LASTEXITCODE -ne 0) { throw "GitHub read failed: $endpoint" }
    $pages = $json | ConvertFrom-Json
    foreach ($page in $pages) { $page }
}

# Use the adapter's map title convention, including closed maps. The Destination
# section distinguishes investigation maps from unrelated planning issues/PRs.
$maps = @(Read-GitHubJson "repos/$repo/issues?state=all&per_page=100" |
    Where-Object { -not $_.pull_request -and $_.title -match '^Wayfinder:' -and $_.body -match '(?m)^## Destination\s*$' } |
    Sort-Object number)
if ($maps.Count -eq 0) {
    Write-Output "No Wayfinder maps found in $repo."
    return
}

foreach ($map in $maps) {
    # Issue numbers keep new cache paths stable when a map is renamed. Reuse an
    # existing mirror only when its source metadata matches this repository
    # and issue number. Titles alone cannot identify the source repository.
    $cache = Join-Path $planRoot "wayfinder/map-$($map.number)"
    $matches = @(Get-ChildItem -LiteralPath $planRoot -Filter map.md -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object {
            $sourcePath = Join-Path $_.DirectoryName 'github-source.json'
            if (Test-Path -LiteralPath $sourcePath) {
                $source = Get-Content -LiteralPath $sourcePath -Raw | ConvertFrom-Json
                $source.repository -eq $repo -and $source.issue -eq $map.number
            } else {
                $false
            }
        })
    if ($matches.Count -gt 1) { throw "Multiple caches match map $($map.number)." }
    if ($matches.Count -eq 1) { $cache = $matches[0].DirectoryName }

    # Fail before writing if this location is not ignored or belongs to another
    # map. This keeps the disposable mirror separate from tracked source specs.
    git -C (Join-Path $PSScriptRoot '..') check-ignore --quiet -- (Join-Path $cache 'map.md')
    if ($LASTEXITCODE -ne 0) { throw "Cache must be ignored by Git before refreshing: $cache" }
    $sourcePath = Join-Path $cache 'github-source.json'
    if (Test-Path -LiteralPath $sourcePath) {
        $source = Get-Content -LiteralPath $sourcePath -Raw | ConvertFrom-Json
        if ($source.repository -ne $repo -or $source.issue -ne $map.number) {
            throw "Cache belongs to a different GitHub map: $cache"
        }
    }

    $tickets = @(Read-GitHubJson "repos/$repo/issues/$($map.number)/sub_issues")
    $mapBody = $map.body
    $rendered = @()
    foreach ($ticket in $tickets) {
        $number = $ticket.number
        $slug = ($ticket.title.ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
        $filename = "$number-$slug.md"
        $types = @($ticket.labels.name | Where-Object { $_ -match '^wayfinder:(research|prototype|grilling|task)$' })
        $implementationTypes = @($ticket.labels.name | Where-Object { $_ -match '^type:(feature|task)$' })
        if ($types.Count -eq 1 -and $implementationTypes.Count -eq 0) {
            $type = $types[0] -replace '^wayfinder:', ''
        } elseif ($types.Count -eq 0 -and $implementationTypes.Count -eq 1) {
            # The viewer understands task tickets. Map implementation work to that
            # display type without changing its feature/task classification in GitHub.
            $type = 'task'
        } else {
            throw "Ticket $number must have one investigation type or one implementation feature/task type, not both."
        }
        $blockers = @(Read-GitHubJson "repos/$repo/issues/$number/dependencies/blocked_by")
        $blockedBy = '[' + (($blockers | ForEach-Object { $_.number }) -join ', ') + ']'
        $content = "---`ntype: $type`nblocked_by: $blockedBy`n"
        if ($ticket.state -eq 'open' -and $ticket.assignees.Count -gt 0) {
            $content += "claimed_by: $($ticket.assignees[0].login)`nclaimed_at: $($ticket.updated_at)`n"
        }
        $content += "---`n`n# $($ticket.title)`n`n$(([string] $ticket.body).TrimEnd())`n"
        if ($ticket.state -eq 'closed') {
            $comments = @(Read-GitHubJson "repos/$repo/issues/$number/comments")
            if ($comments.Count -eq 0) { throw "Closed ticket $number has no answer comments." }
            $answer = ($comments.body -join "`n`n---`n`n") -replace '(?m)^(#{1,5}) ', '#$1 '
            $heading = if ($ticket.state_reason -eq 'not_planned') { 'Ruled out' } else { 'Answer' }
            $content += "`n## $heading`n`n$answer`n"
        }
        $rendered += @{ Filename = $filename; Content = $content }
        $issueUrl = "https://github.com/$repo/issues/$number"
        $mapBody = $mapBody -replace ([regex]::Escape($issueUrl) + '(?![0-9#])'), "./tickets/$filename"
    }

    # Fetch and validate everything before replacing cache files; retain any assets.
    New-Item -ItemType Directory -Force -Path (Join-Path $cache 'tickets') | Out-Null
    foreach ($item in $rendered) {
        Set-Content -LiteralPath (Join-Path $cache "tickets/$($item.Filename)") -Value $item.Content -Encoding utf8
    }
    Set-Content -LiteralPath (Join-Path $cache 'map.md') -Value "# $($map.title)`n`n$($mapBody.TrimEnd())`n" -Encoding utf8
    @{ repository = $repo; issue = $map.number } | ConvertTo-Json |
        Set-Content -LiteralPath $sourcePath -Encoding utf8
    Write-Output "Refreshed $repo issue $($map.number): $cache ($($tickets.Count) tickets)."
}
