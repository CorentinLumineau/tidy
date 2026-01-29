Gmail inbox optimization with category awareness:

1. **Show Category Breakdown**:
   - Count emails per Gmail tab (Promotions, Social, Updates, Primary)
   - Use queries:
     - Promotions: `gog gmail search "in:promotions has:nouserlabels -in:spam -in:trash" --max=500 --plain`
     - Social: `gog gmail search "in:social has:nouserlabels -in:spam -in:trash" --max=500 --plain`
     - Updates: `gog gmail search "in:updates has:nouserlabels -in:spam -in:trash" --max=500 --plain`
     - Primary: `gog gmail search "has:nouserlabels -in:promotions -in:social -in:updates -in:forums -in:spam -in:trash" --max=500 --plain`
   - Ask user which category to focus on (or "all")

2. **Analyze Selected Category**:
   - List existing labels and filters
   - Find uncategorized emails in chosen category
   - Group by sender domain

3. **Identify Patterns**:
   - For Promotions → suggest Services/Shopping, Finance/Subscriptions
   - For Social → suggest Admin/Notifications
   - For Updates → suggest Finance/Payments, Projects/Purchases
   - For Primary → analyze sender/subject patterns

4. **Propose Actions** (wait for approval):
   - New labels to create
   - Filters to add
   - Batch label assignments

5. **Execute** (after confirmation only)

6. **Report**: Summary and remaining count per category

Use gog CLI for all Gmail operations. Keep all emails in inbox (don't archive).
