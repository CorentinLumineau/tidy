---
name: gmail-cleanup
description: Gmail inbox optimization and label management with category awareness
user-invocable: true
disable-model-invocation: false
allowed-tools: [Bash, Read, Edit, Write]
---

# Gmail Cleanup Workflow

Gmail inbox optimization and label management. Analyzes uncategorized emails, suggests new labels and filters, organizes inbox.

## Prerequisites

`gog` CLI installed and authenticated with Gmail.

## Workflow

### 1. Show Category Breakdown

Count emails per Gmail tab (Promotions, Social, Updates, Primary):

```bash
# Promotions
gog gmail search "in:promotions has:nouserlabels -in:spam -in:trash" --max=500 --plain

# Social
gog gmail search "in:social has:nouserlabels -in:spam -in:trash" --max=500 --plain

# Updates
gog gmail search "in:updates has:nouserlabels -in:spam -in:trash" --max=500 --plain

# Primary (truly uncategorized)
gog gmail search "has:nouserlabels -in:promotions -in:social -in:updates -in:forums -in:spam -in:trash" --max=500 --plain
```

Ask user which category to focus on (or "all").

### 2. Analyze Selected Category

```bash
# List labels and filters
gog gmail labels list
gog gmail settings filters list

# Get uncategorized emails (max 100)
gog gmail search "has:nouserlabels -in:spam -in:trash" --max=100 --plain
```

### 3. Identify Patterns

Analyze uncategorized emails for:
- Sender domains (group by @domain.com)
- Subject keywords
- Frequency

Category-specific suggestions:
- Promotions -> Services/Shopping, Finance/Subscriptions
- Social -> Admin/Notifications
- Updates -> Finance/Payments, Projects/Purchases
- Primary -> analyze sender/subject patterns

Present as table:

```
| Sender Pattern | Count | Suggested Label |
|----------------|-------|-----------------|
| @domain.com    | 15    | Category/Label  |
```

### 4. Propose Actions (Ask Approval First)

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

### 5. Execute Approved Actions

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

### 6. Report Results

Summarize:
- Labels created
- Filters added
- Emails categorized
- Remaining uncategorized per category

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

## Best Practices

- Keep all emails in inbox (don't archive unless asked)
- Always dry-run first with scripts: `DRY_RUN=true ./scripts/script.sh`
- Use category filter: `CATEGORY=promotions DRY_RUN=true ./scripts/ai_categorize.sh`
