---
name: prj-drive
description: Quick Google Drive status check
user-invocable: true
disable-model-invocation: false
allowed-tools: [Bash, Read]
---

# Drive Status

Quick Google Drive status check.

## Workflow

### 1. Storage Usage

```bash
gog drive about --plain
```

Display used/total storage with percentage.

### 2. File Counts by Type

```bash
# Documents
gog drive ls --query="mimeType contains 'document'" --max=1000 --plain | wc -l

# Spreadsheets
gog drive ls --query="mimeType contains 'spreadsheet'" --max=1000 --plain | wc -l

# Presentations
gog drive ls --query="mimeType contains 'presentation'" --max=1000 --plain | wc -l

# PDFs
gog drive ls --query="mimeType='application/pdf'" --max=1000 --plain | wc -l

# Images
gog drive ls --query="mimeType contains 'image'" --max=1000 --plain | wc -l

# Videos
gog drive ls --query="mimeType contains 'video'" --max=1000 --plain | wc -l
```

### 3. Recent Files (10 most recently modified)

```bash
gog drive ls --order-by="modifiedTime desc" --max=10 --plain
```

### 4. Largest Files (10 largest)

```bash
gog drive ls --order-by="quotaBytesUsed desc" --max=10 --plain
```

### 5. Files in Root (should be organized into folders)

```bash
gog drive ls --query="'root' in parents and mimeType!='application/vnd.google-apps.folder'" --max=50 --plain
```

### 6. Sharing Summary

```bash
# Shared with me
gog drive ls --query="sharedWithMe=true" --max=100 --plain | wc -l

# Shared by me
gog drive ls --query="'me' in owners and visibility!='limited'" --max=100 --plain | wc -l
```

### 7. Display Results

Present in table format:

```
Google Drive Status

Storage:
| Metric     | Value       |
|------------|-------------|
| Used       | X.XX GB     |
| Total      | XX GB       |
| Percentage | XX%         |

Files in Root (need organizing): XX

Top 10 Largest Files:
| Name                 | Size     | Modified     |
|----------------------|----------|--------------|
| file1.zip            | 500 MB   | 2024-01-15   |
| ...                  | ...      | ...          |
```

### 8. Next Steps

Ask if user wants to run `/prj-drive-cleanup` for organization.
