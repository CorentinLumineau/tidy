# Gmail Organizer

Organize your Gmail inbox with hierarchical labels, automated filters, and AI-assisted categorization.

## Features

- Hierarchical label system (Finance/, Services/, Projects/, Admin/, Status/)
- Shell scripts for bulk email categorization
- AI-powered pattern matching for uncategorized emails
- Claude Code integration for interactive cleanup

## Prerequisites

- [gog CLI](https://github.com/steipete/gog) - Google services CLI

## Installation

### 1. Install gog CLI

```bash
# macOS
brew install steipete/tap/gog

# Linux
go install github.com/steipete/gog@latest
```

### 2. Authenticate

```bash
gog auth login
```

### 3. Clone repository

```bash
git clone https://github.com/USERNAME/gmail-organizer.git
cd gmail-organizer
```

## Label Hierarchy

| Category | Subcategories |
|----------|---------------|
| Finance/ | Investments, Taxes, Insurance, Payments |
| Services/ | Tech, Gaming, Automotive, Shopping |
| Projects/ | Travel, Purchases, Legal |
| Admin/ | Security, Jobs, Notifications |
| Status/ | Pending, Important, Archive |

## Usage

### Shell Scripts

```bash
# Preview changes (dry run)
DRY_RUN=true ./categorize_emails.sh

# Execute categorization
./categorize_emails.sh

# AI-based pattern matching
DRY_RUN=true ./ai_categorize.sh
./ai_categorize.sh

# Migrate old labels to new structure
DRY_RUN=true ./migrate_labels.sh
./migrate_labels.sh
```

### Claude Code Integration

The project includes local skills in `.claude/skills/`:
- `gog` - Google Workspace CLI commands
- `gmail-cleanup` - Inbox organization workflow

Use commands: `/inbox` or `/gmail-cleanup`

## Customization

The shell scripts contain example sender patterns. Edit them to match your inbox:

```bash
# In categorize_emails.sh
categorize_by_sender "your-domain.com" "Category/Label"
```

## License

MIT
