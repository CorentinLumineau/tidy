# Tidy - Agent Instructions

## Prerequisites

Verify gog CLI is installed and authenticated:

```bash
gog gmail labels list
```

## Commands

### Gmail
- `/inbox` - Quick status (uncategorized count)
- `/gmail-cleanup` - Full workflow (analyze → propose → execute)

### Google Drive
- `/drive` - Quick status (storage, recent files, files in root)
- `/drive-cleanup` - Full workflow (analyze → organize → cleanup)

## Label Hierarchy

```
Finance/     Investments, Taxes, Insurance, Payments
Services/    Tech, Gaming, Automotive, Shopping
Projects/    Travel, Purchases, Legal
Admin/       Security, Jobs, Notifications
Status/      Pending, Important, Archive
```

## Common gog Commands

```bash
# List all labels
gog gmail labels list

# Create new label
gog gmail labels create "Category/Sub"

# Add label to thread
gog gmail labels modify THREAD_ID --add "Label"

# Search unlabeled emails
gog gmail search "has:nouserlabels" --max 100 --plain

# Create filter
gog gmail settings filters create --from "domain.com" --add-label "Label"

# Search by Gmail category (unlabeled only)
gog gmail search "in:promotions has:nouserlabels -in:spam -in:trash" --max 100 --plain
gog gmail search "in:social has:nouserlabels -in:spam -in:trash" --max 100 --plain
gog gmail search "in:updates has:nouserlabels -in:spam -in:trash" --max 100 --plain

# Primary only (exclude all categories)
gog gmail search "has:nouserlabels -in:promotions -in:social -in:updates -in:forums -in:spam -in:trash" --max 100 --plain
```

## Common gog Drive Commands

```bash
# Storage info
gog drive about --plain

# List files
gog drive ls --plain                              # Root folder
gog drive ls --parent=FOLDER_ID --plain           # Specific folder
gog drive ls --query="mimeType='application/vnd.google-apps.folder'" --plain  # Folders only

# Search and filter
gog drive search "filename" --max=100 --plain
gog drive ls --query="modifiedTime<'2023-01-01'" --max=100 --plain  # Old files
gog drive ls --query="quotaBytesUsed>104857600" --max=50 --plain    # Large files (>100MB)
gog drive ls --query="'root' in parents" --plain                     # Files in root

# File operations
gog drive get FILE_ID --json                      # Metadata
gog drive mkdir "Name" --parent=PARENT_ID         # Create folder
gog drive move FILE_ID --parent=DEST_ID           # Move file
gog drive delete FILE_ID                          # To trash
gog drive rename FILE_ID "NewName"                # Rename

# Permissions
gog drive permissions FILE_ID --plain             # Check sharing
```

## Scripts

All scripts in `scripts/` support `DRY_RUN=true` for preview mode.

| Script | Purpose |
|--------|---------|
| `scripts/categorize_emails.sh` | Label emails by sender domain (supports `CATEGORY` env var) |
| `scripts/ai_categorize.sh` | Pattern-match subjects and senders (supports `CATEGORY` env var) |
| `scripts/migrate_labels.sh` | Migrate old label structure |
| `scripts/drive_organize.sh` | Create standard Drive folder hierarchy |

## Best Practices

1. Always dry-run first: `DRY_RUN=true ./scripts/script.sh`
2. Use category filter: `CATEGORY=promotions DRY_RUN=true ./scripts/ai_categorize.sh`
   - Options: `promotions`, `social`, `updates`, `primary`, `all`
3. Ask user before executing bulk operations
4. Keep emails in inbox (don't archive unless asked)
5. Report results summary after operations

## Workflow

1. Check uncategorized count: `gog gmail search "has:nouserlabels" --max 1 --plain`
2. Analyze patterns in unlabeled emails
3. Propose label assignments to user
4. Execute with user approval
5. Report summary
