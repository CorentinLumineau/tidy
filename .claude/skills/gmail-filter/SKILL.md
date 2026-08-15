---
name: gmail-filter
description: Create and manage Gmail filters to automatically label, archive, or forward emails. Use when setting up email automation rules. Creates native Gmail filters that work 24/7 without needing Claude.
license: Apache-2.0
compatibility: Requires gog CLI (brew install steipete/tap/gogcli) authenticated with personal Gmail
metadata:
  author: clumineau
  version: "0.1.0"
allowed-tools: Bash(gog:*)
---

# Gmail Filter Manager

Create and manage native Gmail filters for automatic email organization.

## Commands

### Create Filter

**Syntax**: `/gmail-filter create <from-pattern> <label> [--archive]`

**Examples**:
```
/gmail-filter create @newsletter.com Newsletters
/gmail-filter create @github.com Notifications --archive
/gmail-filter create "orders@amazon" Shopping
```

### List Filters

**Syntax**: `/gmail-filter list`

Shows all existing filters with their criteria and actions.

### Delete Filter

**Syntax**: `/gmail-filter delete <filter-id>`

## Create Filter Workflow

### Step 1: Parse Arguments

Extract from `$ARGUMENTS`:
- `from_pattern` - Email pattern (domain or address)
- `label_name` - Label to apply
- `archive` - Whether to remove from inbox

### Step 2: Ensure Label Exists

Check if label exists, create if needed:

```bash
# List existing labels
gog gmail labels list --json

# Create if not found
gog gmail labels create "LabelName"
```

### Step 3: Create the Filter

```bash
gog gmail filters create \
  --from "pattern@domain.com" \
  --add-label "LABEL_ID" \
  [--remove-label "INBOX"]
```

Note: Use label ID, not name, for the filter command.

### Step 4: Verify Creation

```bash
gog gmail filters list --json
```

Confirm the filter appears in the list.

### Step 5: Report Success

```
## Filter Created Successfully

**Criteria**: Emails from `@newsletter.com`
**Action**: Apply label "Newsletters"
**Archive**: Yes (removes from inbox)

This filter is now active and will automatically process matching emails.

**Note**: Existing emails are not affected. Use `/gmail-label apply` to label past emails.
```

## List Filters Workflow

```bash
gog gmail filters list --json
```

Format output as table:

| ID | From | To | Subject | Labels Added | Labels Removed |
|----|------|-----|---------|--------------|----------------|
| abc123 | @github.com | - | - | Notifications | INBOX |

## Delete Filter Workflow

```bash
gog gmail filters delete <filter-id>
```

Confirm deletion:
```
Filter `abc123` deleted successfully.
```

## Filter Criteria Options

Available criteria (combine as needed):
- `--from` - Sender address or domain
- `--to` - Recipient address
- `--subject` - Subject contains
- `--query` - Full Gmail search query
- `--has-attachment` - Has attachments

## Filter Actions

Available actions:
- `--add-label` - Apply a label (use label ID)
- `--remove-label` - Remove a label (use "INBOX" to archive)
- `--forward` - Forward to verified address
- `--mark-read` - Mark as read

## Common Filter Recipes

### Newsletter Filter (archive)
```bash
gog gmail filters create --from "@substack.com" --add-label "Newsletters" --remove-label "INBOX"
```

### GitHub Notifications
```bash
gog gmail filters create --from "@github.com" --add-label "GitHub"
```

### Shopping Orders
```bash
gog gmail filters create --from "orders@amazon" --add-label "Shopping/Orders"
```

## Error Handling

- **Label not found**: Create it automatically
- **Invalid filter criteria**: Show supported options
- **Duplicate filter**: Warn user, don't create duplicate
- **Permission error**: Check OAuth scopes
