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

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for details.

```
MIT License

Copyright (c) 2026 asuspades

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## ⚠️ Disclaimer

This tool performs bulk file renaming. Always test on a small sample before running on large collections.
