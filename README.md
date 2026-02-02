# Tidy

Organize your Google Workspace - Gmail inbox and Google Drive - with hierarchical labels, automated filters, and AI-assisted categorization.

## Features

- Gmail: Hierarchical label system (Finance/, Services/, Projects/, Admin/, Status/)
- Gmail: Shell scripts for bulk email categorization
- Gmail: AI-powered pattern matching for uncategorized emails
- Drive: Structured folder hierarchy organization
- Drive: Find duplicates, large files, and old files
- Claude Code integration for interactive cleanup

## Prerequisites

- [gog CLI](https://github.com/steipete/gog) - Google services CLI
- Google Cloud Platform account
- Gmail account

## Installation

### 1. Install gog CLI

```bash
# macOS
brew install steipete/tap/gog

# Linux
go install github.com/steipete/gog@latest
```

### 2. Set up Google Cloud Platform

#### Create a GCP Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click **Select a project** → **New Project**
3. Name it (e.g., "Tidy") and click **Create**
4. Select your new project

#### Enable Gmail API

1. Go to **APIs & Services** → **Library**
2. Search for "Gmail API"
3. Click **Gmail API** → **Enable**

#### Create OAuth 2.0 Credentials

1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **OAuth client ID**
3. If prompted, configure the OAuth consent screen:
   - User Type: **External** (or Internal for Workspace)
   - App name: "Tidy"
   - User support email: your email
   - Developer contact: your email
   - Click **Save and Continue** through scopes and test users
4. Back in Credentials, click **Create Credentials** → **OAuth client ID**
5. Application type: **Desktop app**
6. Name: "gog CLI"
7. Click **Create**
8. Download the JSON file

#### Configure gog CLI

```bash
# Set the credentials file path
export GOG_CREDENTIALS_FILE=/path/to/downloaded-credentials.json

# Or move it to the default location
mkdir -p ~/.config/gog
mv ~/Downloads/client_secret_*.json ~/.config/gog/credentials.json
```

### 3. Authenticate

```bash
gog auth login
```

This opens a browser window. Sign in with your Google account and grant the requested permissions.

### 4. Verify Setup

```bash
# Test the connection
gog gmail labels list
```

### 5. Clone Repository

```bash
git clone https://github.com/CorentinLumineau/tidy.git
cd tidy
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
DRY_RUN=true ./scripts/categorize_emails.sh

# Execute categorization
./scripts/categorize_emails.sh

# AI-based pattern matching
DRY_RUN=true ./scripts/ai_categorize.sh
./scripts/ai_categorize.sh

# Migrate old labels to new structure
DRY_RUN=true ./scripts/migrate_labels.sh
./scripts/migrate_labels.sh
```

### Claude Code Integration

The project includes local skills in `.claude/skills/`:
- `gog` - Google Workspace CLI commands
- `gmail-cleanup` - Inbox organization workflow

Use commands: `/inbox` or `/gmail-cleanup`

## Customization

The shell scripts contain example sender patterns. Edit them to match your inbox:

```bash
# In scripts/categorize_emails.sh
categorize_by_sender "your-domain.com" "Category/Label"
```

## License

MIT
