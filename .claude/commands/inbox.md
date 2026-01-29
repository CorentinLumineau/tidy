Quick inbox status check with category breakdown:

1. **Category Breakdown** - Count emails in each Gmail tab (no user labels):
   - Promotions: `gog gmail search "in:promotions has:nouserlabels -in:spam -in:trash" --max=500 --plain | wc -l`
   - Social: `gog gmail search "in:social has:nouserlabels -in:spam -in:trash" --max=500 --plain | wc -l`
   - Updates: `gog gmail search "in:updates has:nouserlabels -in:spam -in:trash" --max=500 --plain | wc -l`
   - Primary (truly uncategorized): `gog gmail search "has:nouserlabels -in:promotions -in:social -in:updates -in:forums -in:spam -in:trash" --max=500 --plain | wc -l`

2. **Top Senders** - Show top 10 sender domains for truly uncategorized emails only

3. **Quick Wins** - Suggest filters that would categorize the most emails

4. Display results in a table format:
```
📬 Inbox Status

Gmail Categories (unlabeled emails):
┌────────────┬───────┐
│ Category   │ Count │
├────────────┼───────┤
│ Promotions │ XXX   │
│ Social     │ XXX   │
│ Updates    │ XXX   │
│ Primary    │ XXX   │
├────────────┼───────┤
│ Total      │ XXX   │
└────────────┴───────┘
```

5. Ask which category to focus on, or offer to run `/gmail-cleanup`
