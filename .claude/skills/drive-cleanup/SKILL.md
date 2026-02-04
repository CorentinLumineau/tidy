---
name: drive-cleanup
description: Google Drive organization and cleanup workflow
user-invocable: true
disable-model-invocation: false
allowed-tools: [Bash, Read, Edit, Write]
---

# Google Drive Cleanup Workflow

Google Drive organization and cleanup. Analyzes storage usage, finds duplicates and large files, organizes files into structured folders.

## Prerequisites

`gog` CLI installed and authenticated with Drive.

## Workflow

### 1. Analyze Current State

```bash
# Storage usage
gog drive about --plain

# List all folders
gog drive ls --query="mimeType='application/vnd.google-apps.folder'" --max=100 --plain

# Files in root (need organizing)
gog drive ls --query="'root' in parents and mimeType!='application/vnd.google-apps.folder'" --max=100 --plain
```

### 2. Find Issues

**Large Files (>100MB):**
```bash
gog drive ls --query="quotaBytesUsed>104857600" --order-by="quotaBytesUsed desc" --max=50 --plain
```

**Old Files (2+ years):**
```bash
gog drive ls --query="modifiedTime<'2024-01-01'" --order-by="modifiedTime asc" --max=100 --plain
```

**Duplicates:**
```bash
# List all files, group by name, compare sizes
gog drive ls --max=1000 --plain | sort -k2 | uniq -d -f1
```

### 3. Propose Actions (Ask Approval First)

Present proposals:

**Folders to Create:**
```
- Drive/Documents/Finance/Taxes/
- Drive/Projects/Active/
```

**Files to Move:**
```
| File | From | To |
|------|------|-----|
| tax_2023.pdf | root | Documents/Finance/Taxes/ |
```

**Wait for user confirmation before executing.**

### 4. Execute Approved Actions

```bash
# Create folder
gog drive mkdir "FolderName" --parent=PARENT_ID

# Move file
gog drive move FILE_ID --parent=FOLDER_ID

# Rename file
gog drive rename FILE_ID "NewName"

# Delete to trash
gog drive delete FILE_ID
```

### 5. Report Results

Summarize:
- Folders created
- Files moved
- Storage recovered

## Folder Hierarchy

```
Drive/
├── Documents/
│   ├── Personal/
│   │   ├── Identity/          # IDs, passports, permits
│   │   ├── Medical/           # Health records
│   │   └── Certificates/      # Diplomas, certifications
│   ├── Finance/
│   │   ├── Banking/           # Statements, contracts
│   │   ├── Taxes/             # Declarations, receipts
│   │   ├── Insurance/         # Policies, claims
│   │   └── Investments/       # Portfolios, reports
│   ├── Legal/
│   │   ├── Contracts/         # Signed agreements
│   │   └── Correspondence/    # Official letters
│   └── Work/
│       ├── CV-Portfolio/      # Resume, work samples
│       ├── Certifications/    # Professional certs
│       └── References/        # Recommendation letters
│
├── Projects/
│   ├── Active/                # Current projects (subfolders per project)
│   ├── Completed/             # Finished projects
│   └── Templates/             # Reusable templates
│
├── Media/
│   ├── Photos/
│   │   ├── Events/            # By event name
│   │   ├── Travel/            # By destination
│   │   └── Screenshots/       # Screen captures
│   ├── Videos/
│   └── Audio/
│
├── Resources/
│   ├── Ebooks/                # Books, manuals
│   ├── Courses/               # Learning materials
│   ├── Reference/             # Guides, cheatsheets
│   └── Software/              # Installers, configs
│
├── Shared/
│   ├── Incoming/              # Files shared with me
│   └── Outgoing/              # Files I share with others
│
└── Archive/
    ├── By-Year/               # Old files by year
    └── Deprecated/            # No longer needed but kept
```

## Common gog Drive Commands

```bash
# List files
gog drive ls --plain                              # Root folder
gog drive ls --parent=FOLDER_ID --plain           # Specific folder
gog drive ls --query="mimeType='application/vnd.google-apps.folder'" --plain  # Folders only

# Search
gog drive search "filename" --max=100 --plain     # By name
gog drive ls --query="modifiedTime<'2023-01-01'" --max=100 --plain  # Old files
gog drive ls --query="'root' in parents" --plain  # Files in root

# File operations
gog drive get FILE_ID --json                      # Metadata
gog drive mkdir "Name" --parent=PARENT_ID         # Create folder
gog drive move FILE_ID --parent=DEST_ID           # Move
gog drive delete FILE_ID                          # To trash
gog drive rename FILE_ID "NewName"                # Rename

# Permissions
gog drive permissions FILE_ID --plain             # Check sharing
```

## File Type Categorization

| Pattern | Suggested Folder |
|---------|------------------|
| *.pdf (tax, invoice) | Documents/Finance/ |
| *.pdf (contract) | Documents/Legal/Contracts/ |
| *.docx (resume, cv) | Documents/Work/CV-Portfolio/ |
| *.jpg, *.png (screenshot) | Media/Photos/Screenshots/ |
| *.zip, *.dmg | Resources/Software/ |
| *.pdf (book, manual) | Resources/Ebooks/ |

## Best Practices

- Always ask for confirmation before moving or deleting files
- Use dry-run first: `DRY_RUN=true ./scripts/drive_organize.sh`
