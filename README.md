# Tidy

Organize your Google Workspace — Gmail inbox and Google Drive — with hierarchical labels, automated filters, and AI-assisted categorization.

Merged from `tidy` (shell scripts + Drive) + `gmail-assistant` (Python core + skills).

## Features

- **Gmail**: Hierarchical label system (Finance/, Services/, Projects/, Admin/, Status/)
- **Gmail**: Shell scripts for bulk email categorization
- **Gmail**: AI-powered pattern matching for uncategorized emails
- **Gmail**: Python core for programmatic Gmail operations (`scripts/gmail_core.py`)
- **Gmail**: 4 skills — analyze, classify, filter, label
- **Drive**: Structured folder hierarchy organization
- **Drive**: Find duplicates, large files, and old files
- **Claude Code** integration via `.claude/skills/`

## Prerequisites

- [gog CLI](https://github.com/steipete/gog) — Google services CLI
- Google Cloud Platform account with Gmail API enabled
- See [SETUP.md](SETUP.md) for detailed OAuth setup

## Installation

```bash
# Install gog CLI
brew install steipete/tap/gog

# Clone
git clone https://github.com/CorentinLumineau/tidy.git
cd tidy
```

## Skills (`.claude/skills/`)

| Skill | Purpose |
|-------|---------|
| `gog` | Google Workspace CLI command reference |
| `prj-inbox` | Quick inbox status check |
| `prj-gmail-cleanup` | Full Gmail cleanup workflow |
| `prj-drive` | Quick Drive status check |
| `prj-drive-cleanup` | Full Drive cleanup workflow |
| `gmail-analyze` | Analyze inbox patterns, suggest filter rules |
| `gmail-classify` | AI-powered email classification |
| `gmail-filter` | Create and manage Gmail filters |
| `gmail-label` | Create labels and batch-apply to emails |

## Label Hierarchy

| Category | Subcategories |
|----------|---------------|
| Finance/ | Investments, Taxes, Insurance, Payments |
| Services/ | Tech, Gaming, Automotive, Shopping |
| Projects/ | Travel, Purchases, Legal |
| Admin/ | Security, Jobs, Notifications |
| Status/ | Pending, Important, Archive |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/categorize_emails.sh` | Label emails by sender domain |
| `scripts/ai_categorize.sh` | Pattern-match subjects and senders |
| `scripts/migrate_labels.sh` | Migrate old label structure |
| `scripts/drive_organize.sh` | Create standard Drive folder hierarchy |
| `scripts/gmail_core.py` | Python Gmail operations (no external deps) |

All shell scripts support `DRY_RUN=true` for preview mode and `CATEGORY=promotions|social|updates|primary|all` for filtering.

## Usage

```bash
# Preview email categorization
DRY_RUN=true ./scripts/categorize_emails.sh

# AI-based pattern matching
DRY_RUN=true ./scripts/ai_categorize.sh

# Drive organization
DRY_RUN=true ./scripts/drive_organize.sh

# Python core
python3 scripts/gmail_core.py --help
```

## License

MIT
