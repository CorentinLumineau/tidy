---
name: gmail-cleanup
description: |
  Gmail inbox optimization and label management. Analyzes uncategorized emails, suggests new labels and filters, organizes inbox.

  Trigger with /gmail-cleanup when:
  - Inbox has many uncategorized emails needing organization
  - Want to create or update Gmail labels
  - Need to optimize or create filter rules
  - Want to analyze email patterns for better auto-categorization
  - Need to bulk-categorize emails by sender/subject patterns
---

# Gmail Cleanup Workflow

## Prerequisites

`gog` CLI installed and authenticated with Gmail.

## Workflow

### 1. Analyze Current State

```bash
# List labels and filters
gog gmail labels list
gog gmail settings filters list

# Get uncategorized emails (max 100)
gog gmail search "has:nouserlabels -in:spam -in:trash" --max=100 --plain
```

### 2. Identify Patterns

Analyze uncategorized emails for:
- Sender domains (group by @domain.com)
- Subject keywords
- Frequency

Present as table:
```
| Sender Pattern | Count | Suggested Label |
|----------------|-------|-----------------|
| @domain.com    | 15    | Category/Label  |
```

### 3. Propose Actions (Ask Approval First)

Present proposals:

**New Labels:**
```
- Finance/Subscriptions
- Services/Shopping
```

**New Filters:**
```
| From | Label | Keep in Inbox |
|------|-------|---------------|
| rakuten.com | Services/Shopping | Yes |
```

**Emails to Categorize:**
```
Found X emails to label
```

**Wait for user confirmation before executing.**

### 4. Execute Approved Actions

```bash
# Create label
gog gmail labels create "Category/Subcategory"

# Create filter (keeps in inbox)
gog gmail settings filters create --from="domain.com" --add-label="Category/Label"

# Apply label to existing emails
THREADS=$(gog gmail search "from:domain.com -label:Target" --max=500 --plain | awk '{print $1}')
for tid in $THREADS; do
  gog gmail labels modify "$tid" --add="Target/Label"
done
```

### 5. Report Results

Summarize: labels created, filters added, emails categorized, remaining uncategorized.

## Label Hierarchy

```
Finance/     Investments, Taxes, Insurance, Payments, Subscriptions
Services/    Tech, Gaming, Automotive, Shopping
Projects/    Travel, Purchases, Legal
Admin/       Security, Jobs, Notifications
Status/      Pending, Important, Archive
```

## Common Sender Patterns

| Pattern | Label |
|---------|-------|
| *bank*, *credit* | Finance/Payments |
| *invest*, *crypto* | Finance/Investments |
| *tax*, *impots* | Finance/Taxes |
| *github*, *gitlab* | Services/Tech |
| *game*, *steam* | Services/Gaming |
| *travel*, *flight* | Projects/Travel |
| *shop*, *order* | Services/Shopping |
