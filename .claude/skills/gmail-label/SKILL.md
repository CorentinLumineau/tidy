---
name: gmail-label
description: Create Gmail labels and apply them to existing emails in batch. Use when organizing past emails or setting up label taxonomy. Supports full Gmail search syntax for targeting specific emails.
license: Apache-2.0
compatibility: Requires gog CLI (brew install steipete/tap/gogcli) authenticated with personal Gmail
metadata:
  author: clumineau
  version: "0.1.0"
allowed-tools: Bash(gog:*)
---

# Gmail Label Manager

Create labels and batch-apply them to existing emails.

## Commands

### Create Label

**Syntax**: `/gmail-label create <name>`

**Examples**:
```
/gmail-label create Newsletters
/gmail-label create "Work/Projects"
/gmail-label create "Finance/Invoices"
```

### List Labels

**Syntax**: `/gmail-label list`

Shows all labels with IDs.

### Apply Labels to Existing Emails

**Syntax**: `/gmail-label apply "<search-query>" <label>`

**Examples**:
```
/gmail-label apply "from:@github.com newer_than:30d" Notifications
/gmail-label apply "from:newsletter@company.com" Newsletters
/gmail-label apply "subject:invoice" "Finance/Invoices"
```

### Delete Label

**Syntax**: `/gmail-label delete <label-name>`

## Create Label Workflow

### Step 1: Check if Label Exists

```bash
gog gmail labels list --json
```

Search for existing label with same name.

### Step 2: Create Label

```bash
gog gmail labels create "LabelName"
```

For nested labels, use forward slash:
```bash
gog gmail labels create "Parent/Child"
```

### Step 3: Confirm Creation

```
## Label Created

**Name**: Newsletters
**ID**: Label_123456789

Use this label with:
- `/gmail-filter create @domain.com Newsletters`
- `/gmail-label apply "from:@domain.com" Newsletters`
```

## List Labels Workflow

```bash
gog gmail labels list --json
```

Format as table:

| Name | ID | Type |
|------|-----|------|
| Newsletters | Label_123 | user |
| Work | Label_456 | user |
| INBOX | INBOX | system |

## Apply Labels Workflow

### Step 1: Validate Search Query

Test the query first:
```bash
gog gmail search '<query>' --json | head -5
```

Show count: "Found X emails matching query"

### Step 2: Get Label ID

```bash
gog gmail labels list --json
```

Find label ID by name.

### Step 3: Apply Labels in Batch

For each matching email:
```bash
gog gmail modify <message-id> --add-label <label-id>
```

Note: Process in batches of 50 for efficiency.

### Step 4: Report Results

```
## Labels Applied

**Query**: from:@github.com newer_than:30d
**Label**: Notifications
**Emails Modified**: 47

Sample of labeled emails:
- "[GitHub] Pull request #123..." (Jan 25)
- "[GitHub] Issue comment on..." (Jan 24)
- ...
```

## Delete Label Workflow

```bash
# Get label ID first
gog gmail labels list --json

# Delete by ID
gog gmail labels delete <label-id>
```

Warning: Deleting a label removes it from all emails.

## Label Naming Conventions

### Hierarchy
Use `/` for nested labels:
- `Work/Projects`
- `Work/Clients`
- `Finance/Invoices`
- `Finance/Receipts`

### Recommended Structure

```
Work/
├── Projects
├── Clients
└── Internal

Personal/
├── Family
└── Friends

Finance/
├── Invoices
├── Receipts
└── Statements

Newsletters/
├── Tech
├── News
└── Other

Notifications/
├── GitHub
├── Slack
└── Calendar
```

## Search Query Examples

| Description | Query |
|-------------|-------|
| From domain | `from:@github.com` |
| Last 30 days | `newer_than:30d` |
| Unread only | `is:unread` |
| With attachments | `has:attachment` |
| Subject contains | `subject:invoice` |
| Combined | `from:@amazon.com subject:order newer_than:60d` |

## Error Handling

- **Label exists**: Return existing label, don't duplicate
- **Invalid query**: Show example queries
- **No matches**: Suggest broadening search
- **Rate limit**: Pause and retry with smaller batches
