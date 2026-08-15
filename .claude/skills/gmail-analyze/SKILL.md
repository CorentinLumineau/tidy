---
name: gmail-analyze
description: Analyze Gmail inbox patterns to identify high-volume senders and suggest filter rules. Use when organizing email, creating automation rules, or understanding inbox composition. Works with personal Gmail accounts via gog CLI.
license: Apache-2.0
compatibility: Requires gog CLI (brew install steipete/tap/gogcli) authenticated with personal Gmail
metadata:
  author: clumineau
  version: "0.1.0"
allowed-tools: Bash(gog:*) Bash(python:*)
---

# Gmail Inbox Analyzer

Analyze inbox patterns and suggest intelligent filter rules using Pareto analysis.

## Prerequisites Check

First, verify gog CLI is authenticated:

```bash
gog auth status
```

If not authenticated, guide the user to run:
```bash
gog auth add their.email@gmail.com
```

## Analysis Workflow

### Step 1: Fetch Recent Emails

Fetch emails from the specified time period (default: 30 days):

```bash
gog gmail search 'newer_than:${DAYS}d' --json
```

Parse the JSON output to extract:
- `from` - Sender email
- `subject` - Email subject
- `date` - Received date
- `labelIds` - Applied labels

### Step 2: Pattern Analysis

Analyze the fetched emails to identify:

1. **Top Sender Domains** (Pareto: focus on top 20%)
   - Group emails by sender domain
   - Count frequency per domain
   - Identify domains with 5+ emails

2. **Sender Categories**
   - Newsletters: substack, mailchimp, newsletter, digest
   - Notifications: github, gitlab, jira, slack, notion
   - Shopping: amazon, ebay, order, shipping
   - Social: facebook, twitter, linkedin

3. **Volume Distribution**
   - Total emails analyzed
   - Emails per day average
   - Peak sending times

### Step 3: Generate Suggestions

For each high-volume pattern, suggest:

| Domain | Count | Suggested Label | Filter Criteria | Confidence |
|--------|-------|-----------------|-----------------|------------|
| substack.com | 45 | Newsletters | from:@substack.com | High |
| github.com | 32 | Notifications | from:@github.com | High |

### Step 4: Present Results

Output a formatted report:

```
## Inbox Analysis Report

**Period**: Last {days} days
**Total Emails**: {count}
**Unique Senders**: {unique}

### Top 10 Sender Domains

1. example.com - 142 emails (28%)
2. github.com - 89 emails (18%)
...

### Suggested Filters

| Priority | Pattern | Label | Est. Impact |
|----------|---------|-------|-------------|
| 1 | from:@newsletter.com | Newsletters | 45 emails/month |
| 2 | from:@github.com | Notifications | 32 emails/month |

### Recommended Actions

1. Create "Newsletters" label and filter
2. Create "Notifications" label with auto-archive
3. ...

Would you like me to create these filters? Use `/gmail-filter` to proceed.
```

## Arguments

- `$ARGUMENTS` - Number of days to analyze (default: 30)

## Example Usage

```
User: /gmail-analyze 60
```

Analyzes the last 60 days of email.

## Output Format

Always provide:
1. Summary statistics
2. Top senders table
3. Suggested filters with confidence levels
4. Clear next steps

## Error Handling

- If gog not installed: Provide installation instructions
- If not authenticated: Guide through OAuth setup
- If no emails found: Suggest widening the search period
