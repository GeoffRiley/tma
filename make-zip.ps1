# make-zip.ps1
# ----------------
# Usage: 
#   1. Open PowerShell in this folder
#   2. Run: .\make-zip.ps1
#      (You may need to enable script execution with `Set-ExecutionPolicy RemoteSigned` or similar.)

# 1) Check if ou-tma.pdf exists; if not, compile from sources
if ( !(Test-Path ".\ou-tma.pdf") ) {
    Write-Host "No ou-tma.pdf found; compiling from .ins and .dtx..."
    pdflatex "./ou-tma.ins"
    pdflatex "./ou-tma.dtx"
    pdflatex "./ou-tma.dtx"
    makeindex -s gglo.ist -o "ou-tma.gls" "ou-tma.glo"
    makeindex -s gind.ist "ou-tma"
    pdflatex "./ou-tma.dtx"
    pdflatex "./ou-tma.dtx"
    pdflatex "./ou-tma.dtx"
}

# 2) Clean up any old 'ou-tma' subdirectory
if (Test-Path ".\ou-tma") {
    Remove-Item -Recurse -Force ".\ou-tma"
}

# 3) Create a new 'ou-tma' folder
New-Item -ItemType Directory -Name "ou-tma" | Out-Null

# 4) Copy the required files into 'ou-tma'
Copy-Item ".\ou-tma.dtx" ".\ou-tma\"
Copy-Item ".\ou-tma.ins" ".\ou-tma\"
Copy-Item ".\ou-tma.pdf" ".\ou-tma\"
Copy-Item ".\README.md"  ".\ou-tma\"
Copy-Item ".\examples\SampleTMA.tex"  ".\ou-tma\"

# 5) Convert line endings (CRLF => LF) for the three text-based files:
(Get-Content -Raw ".\ou-tma\ou-tma.dtx") -replace "`r`n", "`n" | 
    Set-Content ".\ou-tma\ou-tma.dtx"
(Get-Content -Raw ".\ou-tma\ou-tma.ins") -replace "`r`n", "`n" | 
    Set-Content ".\ou-tma\ou-tma.ins"
(Get-Content -Raw ".\ou-tma\README.md")  -replace "`r`n", "`n" | 
    Set-Content ".\ou-tma\README.md"
(Get-Content -Raw ".\ou-tma\SampleTMA.tex")  -replace "`r`n", "`n" | 
	Set-Content ".\ou-tma\SampleTMA.tex"

# 6) Compress the subdirectory into ou-tma.zip
Write-Host "Zipping files into ou-tma.zip..."
Compress-Archive -Path ".\ou-tma" -DestinationPath ".\ou-tma.zip" -Force

Write-Host "`nAll done! The file 'ou-tma.zip' is ready."
