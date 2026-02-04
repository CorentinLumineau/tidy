---
name: gog
description: Google Workspace CLI for Gmail, Calendar, Drive, Contacts, Sheets, and Docs
user-invocable: false
homepage: https://gogcli.sh
---

# gog

Use `gog` for Gmail/Calendar/Drive/Contacts/Sheets/Docs. Requires OAuth setup.

## Setup (once)

```bash
gog auth credentials /path/to/client_secret.json
gog auth add you@gmail.com --services gmail,calendar,drive,contacts,sheets,docs
gog auth list
```

## Common Commands

### Gmail

```bash
gog gmail search 'newer_than:7d' --max 10
gog gmail send --to a@b.com --subject "Hi" --body "Hello"
gog gmail labels list
gog gmail labels create "Category/Sub"
gog gmail labels modify THREAD_ID --add "Label"
gog gmail settings filters list
gog gmail settings filters create --from "domain.com" --add-label "Label"
```

### Calendar

```bash
gog calendar events <calendarId> --from <iso> --to <iso>
```

### Drive

```bash
gog drive search "query" --max 10
gog drive ls --plain
gog drive ls --parent=FOLDER_ID --plain
gog drive about --plain
gog drive mkdir "Name" --parent=PARENT_ID
gog drive move FILE_ID --parent=DEST_ID
gog drive delete FILE_ID
gog drive rename FILE_ID "NewName"
gog drive permissions FILE_ID --plain
```

### Contacts

```bash
gog contacts list --max 20
```

### Sheets

```bash
gog sheets get <sheetId> "Tab!A1:D10" --json
gog sheets update <sheetId> "Tab!A1:B2" --values-json '[["A","B"],["1","2"]]' --input USER_ENTERED
gog sheets append <sheetId> "Tab!A:C" --values-json '[["x","y","z"]]' --insert INSERT_ROWS
gog sheets clear <sheetId> "Tab!A2:Z"
gog sheets metadata <sheetId> --json
```

### Docs

```bash
gog docs export <docId> --format txt --out /tmp/doc.txt
gog docs cat <docId>
```

## Notes

- Set `GOG_ACCOUNT=you@gmail.com` to avoid repeating `--account`.
- For scripting, prefer `--json` plus `--no-input`.
- Sheets values can be passed via `--values-json` (recommended) or as inline rows.
- Docs supports export/cat/copy. In-place edits require a Docs API client (not in gog).
- Confirm before sending mail or creating events.
