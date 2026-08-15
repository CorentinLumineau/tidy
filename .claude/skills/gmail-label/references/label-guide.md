# Gmail Label Best Practices

## Label Organization

### Flat vs Nested

**Flat** (for simple inboxes):
- Newsletters
- Work
- Personal
- Finance

**Nested** (for complex organization):
```
Work/
├── Clients/
│   ├── ClientA
│   └── ClientB
├── Projects/
│   ├── Project1
│   └── Project2
└── Internal
```

### Recommended Top-Level Labels

| Label | Purpose |
|-------|---------|
| `Action Required` | Needs response/action |
| `Waiting For` | Pending external response |
| `Reference` | Keep for future reference |
| `Archive` | Processed, keep searchable |

### By Category

| Category | Labels |
|----------|--------|
| Work | Work, Work/Projects, Work/Clients |
| Finance | Finance/Invoices, Finance/Receipts, Finance/Statements |
| Newsletters | Newsletters/Tech, Newsletters/News |
| Notifications | Notifications/GitHub, Notifications/Calendar |

## Naming Conventions

### Do
- Use clear, descriptive names
- Use `/` for hierarchy
- Keep names short (easier to scan)
- Be consistent (all singular or all plural)

### Don't
- Use special characters except `/`
- Create too many top-level labels
- Use overly specific names
- Duplicate Gmail's built-in categories

## Color Coding

Gmail supports label colors. Suggested scheme:

| Color | Use For |
|-------|---------|
| Red | Action Required, Urgent |
| Yellow | Waiting For, Pending |
| Green | Done, Complete |
| Blue | Work, Business |
| Purple | Personal |
| Gray | Archive, Reference |

## Integration with Filters

### Pattern: Auto-label + Archive
```
Filter: from:@newsletter.com
Action: Add label "Newsletters", Remove "INBOX"
```

Result: Newsletters go directly to label, skip inbox.

### Pattern: Auto-label + Keep
```
Filter: from:boss@company.com
Action: Add label "Work/Boss"
```

Result: Boss emails stay in inbox AND get labeled.

## Gmail Search with Labels

| Query | Description |
|-------|-------------|
| `label:work` | All Work emails |
| `label:work/projects` | All Work/Projects emails |
| `-label:newsletters` | Exclude newsletters |
| `label:work is:unread` | Unread work emails |

## Cleanup Tips

### Identify Unused Labels
```bash
gog gmail labels list --json
```

Check for labels with 0 emails.

### Merge Similar Labels
1. Apply new label to old label's emails
2. Remove old label
3. Delete old label

### Archive Strategy
- Monthly: Review and archive old emails
- Yearly: Clean up unused labels
- Keep structure manageable (< 50 labels)
