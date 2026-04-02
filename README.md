# 📚 uscore — Archival Library Standardizer

A PowerShell tool for **standardizing filenames of digital books and scanned documents** using structured parsing rules.

---

## ✨ Features

- 📖 **Book Mode (default)**
  - Extracts author, title, and year from filenames
  - Produces clean, machine-parsable naming format:
    ```
    Surname·First~CoAuthor·First_(Year)_Title–Subtitle.ext
    ```

- 🖼️ **Scan Mode**
  - Renames JPG scans into sequential order:
    ```
    Base_Title_001.jpg
    Base_Title_002.jpg
    ```

- 🔍 Handles messy real-world filenames:
  - Calibre exports
  - Library dumps
  - Mixed delimiters
  - Inconsistent metadata

---

## 🚀 Getting Started

### Requirements
- Windows PowerShell 5.1+ or PowerShell Core

---

### Usage

#### Preview changes (safe mode)
```powershell
.\uscore.ps1 -WhatIf
````

#### Apply changes

```powershell
.\uscore.ps1
```

---

### Scan Mode

```powershell
.\uscore.ps1 -Scans -Base "My_Project"
```

Optional anchor alignment:

```powershell
.\uscore.ps1 -Scans -Base "My_Project" -AnchorFile "filename" -AnchorIndex 10
```

---

## 📁 Output Format

### Book Mode

```
AuthorSurname·First~SecondAuthor_(Year)_Title–Subtitle.ext
```

### Scan Mode

```
Base_Title_XXX.jpg
```

---

## 🔐 Security & Privacy

This project:

* Does **not** store or transmit data
* Performs all operations **locally**
* Contains **no hardcoded credentials or external dependencies**

---

## ⚙️ Customization

You can modify:

* Author parsing rules
* Title formatting logic
* Year extraction behavior

All logic is contained within a single script for easy editing.

---

## 🧪 Recommended Workflow

1. Place files in a working directory
2. Run with `-WhatIf` to preview
3. Verify output
4. Run without `-WhatIf` to apply

---

## 📄 License

[INSERT LICENSE TYPE HERE]

---

## ⚠️ Disclaimer

This tool performs bulk file renaming. Always test on a small sample before running on large collections.

```

---

## ✅ Summary of Sanitization

- Removed:
  - Source GitHub URLs
  - Any identifying metadata
- Ensured:
  - No credentials or secrets present
  - No environment leakage
  - Safe PowerShell usage (`-LiteralPath`)
- Improved:
  - Documentation clarity
  - Security posture
  - GitHub readiness

---

If you want next-level polish, the **next step** would be:

👉 adding a `-LogFile` + `-Rollback` system so you can undo renames deterministically

That would make this *enterprise-grade archival tooling*.
