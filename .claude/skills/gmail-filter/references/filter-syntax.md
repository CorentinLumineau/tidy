# Gmail Filter Syntax Reference

## Filter Criteria

### From Patterns
- `user@domain.com` - Exact email address
- `@domain.com` - Any email from domain
- `*@domain.com` - Wildcard (same as @domain.com)

### To Patterns
- `me@gmail.com` - Specific recipient
- `list@group.com` - Mailing list

### Subject Patterns
- `invoice` - Contains word
- `"monthly report"` - Exact phrase

### Query Syntax
Full Gmail search syntax:
- `from:sender@example.com`
- `to:recipient@example.com`
- `subject:keyword`
- `has:attachment`
- `filename:pdf`
- `larger:5M`
- `older_than:30d`
- `newer_than:7d`

## Filter Actions

### Add Labels
Add one or more labels:
```
--add-label "Label1"
--add-label "Label2"
```

Use label IDs for system labels:
- `INBOX` - Inbox
- `STARRED` - Starred
- `IMPORTANT` - Important
- `TRASH` - Trash
- `SPAM` - Spam

### Remove Labels
Archive (remove from inbox):
```
--remove-label "INBOX"
```

Unstar:
```
--remove-label "STARRED"
```

### Mark as Read
```
--mark-read
```

### Forward
Forward to verified email:
```
--forward "backup@example.com"
```

Note: Email must be verified in Gmail settings first.

## Label ID Reference

### System Labels
| Name | ID |
|------|-----|
| Inbox | INBOX |
| Starred | STARRED |
| Important | IMPORTANT |
| Sent | SENT |
| Drafts | DRAFT |
| Spam | SPAM |
| Trash | TRASH |
| Unread | UNREAD |

### Category Labels
| Name | ID |
|------|-----|
| Primary | CATEGORY_PERSONAL |
| Social | CATEGORY_SOCIAL |
| Promotions | CATEGORY_PROMOTIONS |
| Updates | CATEGORY_UPDATES |
| Forums | CATEGORY_FORUMS |

### Custom Labels
Custom labels have unique IDs like:
- `Label_123456789`

Get IDs with:
```bash
gog gmail labels list --json
```

## Examples

### Newsletter + Archive
```bash
gog gmail filters create \
  --from "@newsletter.substack.com" \
  --add-label "Label_123" \
  --remove-label "INBOX"
```

### GitHub + Keep in Inbox
```bash
gog gmail filters create \
  --from "@github.com" \
  --add-label "Label_456"
```

### Large Attachments
```bash
gog gmail filters create \
  --query "has:attachment larger:10M" \
  --add-label "Label_789"
```

## Limitations

- Filters only apply to new incoming mail
- Cannot modify sent emails
- Forward requires verified email address
- Maximum ~500 filters per account
