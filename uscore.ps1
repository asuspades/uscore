# uscore.ps1 — Archival Library Standardizer
# [INSERT LICENSE TYPE HERE]
#
# Description:
#   Renames EPUB/PDF files using structured metadata parsing.
#   Also supports scan image sequencing for archival workflows.
#
# Modes:
#   BOOK MODE (default):
#     Output: Surname·First~CoAuthor·First_(Year)_Title–Subtitle.ext
#
#   SCAN MODE (-Scans):
#     Output: Base_Title_XXX.jpg (chronological indexing)
#
# Usage:
#   .\uscore.ps1
#   .\uscore.ps1 -WhatIf
#   .\uscore.ps1 -Scans -Base "Project_Name"

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$Scans,
    [string]$Base = '',
    [string]$AnchorFile = '',
    [int]$AnchorIndex = -1
)

# Unicode characters
$interpunct = [char]0xB7
$enDash     = [char]0x2013
$emDash     = [char]0x2014

# ─────────────────────────────────────────────────────────────────────────────
# SCAN MODE
# ─────────────────────────────────────────────────────────────────────────────
if ($Scans) {

    if (-not $Base) {
        Write-Error "Parameter -Base is required when using -Scans mode."
        return
    }

    $ScanFiles = Get-ChildItem -Path . -File -Filter '*.jpg' | Sort-Object LastWriteTime

    if ($ScanFiles.Count -eq 0) {
        Write-Warning "No JPG files found."
        return
    }

    $offset = 0
    if ($AnchorFile -and $AnchorIndex -ge 0) {
        $anchorPos = -1
        for ($i = 0; $i -lt $ScanFiles.Count; $i++) {
            if ($ScanFiles[$i].BaseName -match [regex]::Escape($AnchorFile)) {
                $anchorPos = $i
                break
            }
        }

        if ($anchorPos -ge 0) {
            $offset = $AnchorIndex - $anchorPos
        }
    }

    for ($i = 0; $i -lt $ScanFiles.Count; $i++) {
        $idx = $i + $offset
        $idxStr = '{0:D3}' -f $idx
        $NewName = "${Base}_${idxStr}.jpg"

        if ($ScanFiles[$i].Name -eq $NewName) { continue }

        if ($PSCmdlet.ShouldProcess($ScanFiles[$i].Name, "Rename to $NewName")) {
            Rename-Item -LiteralPath $ScanFiles[$i].FullName -NewName $NewName
        }
    }

    return
}

# ─────────────────────────────────────────────────────────────────────────────
# BOOK MODE HELPERS
# ─────────────────────────────────────────────────────────────────────────────

$credentialSuffixes = @('MD','PhD','JD','DO','DDS','Esq','Jr','Sr','II','III','IV')

function Format-AuthorToken {
    param([string]$Auth)

    if ([string]::IsNullOrWhiteSpace($Auth)) { return $null }

    foreach ($cred in $credentialSuffixes) {
        $Auth = $Auth -replace "\s+$cred\.?$", ''
    }

    $Auth = $Auth.Trim().TrimEnd(',')

    if ($Auth -match '^(.+?),\s+(.+)$') {
        return "$($Matches[1] -replace ' ','_')$interpunct$($Matches[2] -replace ' ','_')"
    }

    $words = $Auth -split '\s+'
    if ($words.Count -ge 2) {
        $surname = $words[-1]
        $first = ($words[0..($words.Count-2)] -join '_')
        return "$surname$interpunct$first"
    }

    return $Auth
}

function Clean-Entities {
    param([string]$s)
    $s -replace '&amp;', 'and'
}

function Format-TitleBlock {
    param([string]$t)

    $t = $t -replace '\s*&\s*', ' and '
    $t = $t -replace ',\s*', ' '
    $t = $t -replace '\s+', ' '

    $t = $t -replace '\s*:\s*', $enDash

    $t = $t -replace '\s+[-\u2013\u2014]\s+', $enDash

    $t = $t -replace '\s+', '_'
    $t = $t -replace '__+', '_'

    return $t.Trim('_')
}

function Parse-Authors {
    param([string]$AuthorRaw)

    if ([string]::IsNullOrWhiteSpace($AuthorRaw)) { return $null }

    $tokens = $AuthorRaw -split '\s*;\s*|\s*--\s*|\s*\u2014\s*'

    $out = foreach ($t in $tokens) {
        $r = Format-AuthorToken $t
        if ($r) { $r }
    }

    if ($out.Count -gt 0) {
        return ($out -join '~')
    }

    return $null
}

# ─────────────────────────────────────────────────────────────────────────────
# MAIN LOOP
# ─────────────────────────────────────────────────────────────────────────────

$Files = Get-ChildItem -File | Where-Object {
    $_.Extension -match '\.epub|\.pdf'
}

foreach ($File in $Files) {

    if ($File.Name -match '\.part$') { continue }

    $Base = [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
    $Base = Clean-Entities $Base

    $Author = $null
    $Title  = $null
    $Year   = '0000'

    if ($Base -match '^(.+?)\s+-\s+(.+?)\((\d{4})') {
        $Author = Parse-Authors $Matches[1]
        $Title  = Format-TitleBlock $Matches[2]
        $Year   = $Matches[3]
    }
    elseif ($Base -match '^(.+?)\((\d{4})') {
        $Title = Format-TitleBlock $Matches[1]
        $Year  = $Matches[2]
    }
    else {
        Write-Warning "Skipping (unmatched): $($File.Name)"
        continue
    }

    if ($Author) {
        $NewName = "${Author}_(${Year})_${Title}$($File.Extension)"
    } else {
        $NewName = "_(${Year})_${Title}$($File.Extension)"
    }

    if ($File.Name -eq $NewName) { continue }

    if ($PSCmdlet.ShouldProcess($File.Name, "Rename to $NewName")) {
        Rename-Item -LiteralPath $File.FullName -NewName $NewName
    }
}
