---
name: gmail-classify
description: AI-powered email classification using intelligent content analysis. Categorizes emails into Newsletter, Shopping, Work, Personal, Notifications, Receipts, and Promotions. Use for smart inbox organization beyond simple pattern matching.
license: Apache-2.0
compatibility: Requires gog CLI (brew install steipete/tap/gogcli) authenticated with personal Gmail
metadata:
  author: clumineau
  version: "0.1.0"
allowed-tools: Bash(gog:*) Bash(python:*) Read
---

# Gmail AI Classifier

Intelligent email classification using AI reasoning for smart inbox organization.

## Overview

Unlike pattern-based filtering, AI classification analyzes email content, sender context, and user behavior to make intelligent categorization decisions.

## Usage

**Syntax**: `/gmail-classify [days]`

**Examples**:
```
/gmail-classify           # Classify last 7 days
/gmail-classify 30        # Classify last 30 days
/gmail-classify --dry-run # Preview without applying
```

## Classification Categories

| Category | Indicators | Label |
|----------|------------|-------|
| Newsletter | Substack, Mailchimp, "unsubscribe" link | Newsletters |
| Shopping | Order confirmation, shipping, tracking | Shopping |
| Work | Company domain, professional tone | Work |
| Personal | Personal contacts, casual tone | Personal |
| Notifications | GitHub, Slack, calendar alerts | Notifications |
| Receipts | Invoice, payment, receipt keywords | Finance/Receipts |
| Promotions | Discount, sale, marketing language | Promotions |

## Classification Workflow

### Step 1: Fetch Emails

```bash
gog gmail search 'newer_than:${DAYS}d -label:classified' --json
```

Exclude already-classified emails to avoid re-processing.

### Step 2: Analyze Each Email

For each email, analyze:

1. **Sender Analysis**
   - Domain reputation (newsletter service? company?)
   - Sender name format (person vs system)
   - Reply-to address

2. **Subject Analysis**
   - Keywords (order, invoice, newsletter, etc.)
   - Format (numbered list? FW:? RE:?)
   - Tone (formal, casual, marketing)

3. **Content Indicators**
   - Unsubscribe link presence
   - Tracking numbers
   - Financial amounts
   - Personal greetings

### Step 3: Classify with Confidence

Assign category with confidence level:

| Confidence | Threshold | Action |
|------------|-----------|--------|
| High (90%+) | Strong signals | Auto-apply label |
| Medium (70-89%) | Mixed signals | Apply with note |
| Low (<70%) | Unclear | Skip, flag for review |

### Step 4: Apply Labels

For high-confidence classifications:

```bash
# Ensure label exists
gog gmail labels list --json
gog gmail labels create "CategoryName"

# Apply label
gog gmail modify <message-id> --add-label <label-id>
```

### Step 5: Report Results

```
## Classification Report

**Period**: Last 7 days
**Emails Analyzed**: 142
**Classifications Made**: 128
**Skipped (low confidence)**: 14

### Summary by Category

| Category | Count | % of Total |
|----------|-------|------------|
| Newsletters | 45 | 35% |
| Notifications | 32 | 25% |
| Shopping | 18 | 14% |
| Work | 15 | 12% |
| Personal | 12 | 9% |
| Receipts | 6 | 5% |

### High-Confidence Classifications (Auto-labeled)
- 98 emails across all categories

### Low-Confidence (Manual Review Needed)
1. "Meeting notes from John" - Work or Personal?
2. "Your weekly summary" - Newsletter or Notification?
...

### Suggested Filters

Based on this analysis, create permanent filters:
1. `/gmail-filter create @substack.com Newsletters --archive`
2. `/gmail-filter create @github.com Notifications`
```

## Classification Signals

### Newsletter Signals
- Sender: `newsletter@`, `digest@`, `weekly@`
- Domains: substack.com, mailchimp.com, beehiiv.com
- Content: "unsubscribe", "view in browser"
- Subject: "Weekly", "Digest", "Newsletter"

### Shopping Signals
- Subject: "order", "shipped", "delivered", "tracking"
- Sender: orders@, shipping@, noreply@
- Content: Order numbers, tracking links

### Work Signals
- Sender: Company domain match
- Content: Project names, professional terminology
- CC: Multiple company addresses

### Personal Signals
- Sender: In contacts, personal domain
- Content: Casual language, personal topics
- No marketing footers

### Notification Signals
- Sender: notifications@, alerts@, noreply@
- Subject: [GitHub], [Slack], calendar patterns
- Content: Action buttons, status updates

### Receipt Signals
- Subject: "receipt", "invoice", "payment"
- Content: Dollar amounts, transaction IDs
- Sender: billing@, receipts@

## Dry Run Mode

Preview classifications without applying:

```
/gmail-classify --dry-run
```

Shows what would be classified without making changes.

## Error Handling

- **No emails found**: Suggest widening date range
- **Label creation fails**: Check permissions
- **API rate limit**: Pause and resume
- **Classification uncertain**: Flag for user review

## See Also

- `references/categories.md` - Detailed category definitions
- `/gmail-analyze` - Pattern analysis (faster, simpler)
- `/gmail-filter` - Create permanent rules from classifications
