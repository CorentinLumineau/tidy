# Email Classification Categories

## Category Definitions

### 1. Newsletters

**Description**: Regular content publications, digests, and subscribed updates.

**Signals**:
- Sender domains: substack.com, mailchimp.com, beehiiv.com, convertkit.com
- Sender addresses: newsletter@, digest@, weekly@, daily@
- Subject patterns: "Weekly", "Digest", "Newsletter", "Issue #"
- Content: "Unsubscribe", "View in browser", "Update preferences"
- Format: HTML-heavy, consistent template

**Subcategories**:
- Tech newsletters
- News digests
- Industry updates
- Personal blogs

**Confidence Boosters**:
- Known newsletter service domain (+30%)
- "Unsubscribe" in footer (+20%)
- Regular sending pattern (+10%)

---

### 2. Shopping

**Description**: E-commerce orders, shipping notifications, and purchase-related emails.

**Signals**:
- Subject patterns: "Order #", "Shipped", "Delivered", "Tracking"
- Sender addresses: orders@, shipping@, support@
- Content: Tracking numbers, order details, shipping addresses
- Domains: amazon.com, ebay.com, shopify stores

**Subcategories**:
- Order confirmations
- Shipping updates
- Delivery notifications
- Returns/refunds

**Confidence Boosters**:
- Order number in subject (+30%)
- Known retailer domain (+25%)
- Tracking number present (+20%)

---

### 3. Work

**Description**: Professional communications related to employment or business.

**Signals**:
- Sender domain matches user's work domain
- CC/BCC includes company addresses
- Subject: Project names, meeting topics
- Content: Professional tone, business terminology
- Timing: Business hours

**Subcategories**:
- Internal communications
- Client correspondence
- Project updates
- Meeting invites

**Confidence Boosters**:
- Same company domain (+40%)
- Project name mentioned (+20%)
- Multiple company recipients (+15%)

---

### 4. Personal

**Description**: Communications from personal contacts, friends, and family.

**Signals**:
- Sender in user's contacts
- Casual/personal tone
- No marketing footers
- Personal email domains (gmail, yahoo, etc.)
- Informal subject lines

**Subcategories**:
- Family
- Friends
- Personal services

**Confidence Boosters**:
- In contacts list (+40%)
- Previous reply thread (+25%)
- Casual greeting (+10%)

---

### 5. Notifications

**Description**: Automated alerts from services and applications.

**Signals**:
- Sender: notifications@, alerts@, noreply@
- Subject patterns: "[Service]", brackets notation
- Services: GitHub, GitLab, Slack, Jira, Notion
- Content: Action buttons, status updates, activity summaries

**Subcategories**:
- Development (GitHub, GitLab)
- Productivity (Slack, Notion)
- Calendar alerts
- Social notifications

**Confidence Boosters**:
- Known notification service (+35%)
- Brackets in subject (+20%)
- noreply sender (+15%)

---

### 6. Receipts/Finance

**Description**: Transaction records, invoices, and financial statements.

**Signals**:
- Subject: "Receipt", "Invoice", "Payment", "Statement"
- Content: Dollar amounts, transaction IDs
- Sender: billing@, receipts@, accounting@
- Attachments: PDF invoices

**Subcategories**:
- Purchase receipts
- Invoices
- Bank statements
- Payment confirmations

**Confidence Boosters**:
- Currency amount in content (+25%)
- "Invoice" or "Receipt" in subject (+30%)
- PDF attachment named "receipt" (+20%)

---

### 7. Promotions

**Description**: Marketing emails, advertisements, and promotional offers.

**Signals**:
- Subject: "Sale", "Discount", "%", "Limited time"
- Content: Promotional language, CTAs, images
- Sender: marketing@, promo@, offers@
- Tracking pixels, multiple links

**Subcategories**:
- Sales/discounts
- Product announcements
- Event invitations
- Marketing updates

**Confidence Boosters**:
- Discount percentage in subject (+25%)
- Marketing sender pattern (+20%)
- Heavy HTML/images (+10%)

---

## Classification Priority

When signals overlap, use this priority order:

1. **Work** - Business communications take priority
2. **Personal** - Known contacts
3. **Receipts** - Financial records
4. **Shopping** - Purchase-related
5. **Notifications** - Service alerts
6. **Newsletters** - Subscribed content
7. **Promotions** - Marketing (lowest priority)

## Handling Edge Cases

### Multiple Categories
Email fits multiple categories:
- Use highest-priority match
- If same priority, use strongest confidence
- Can apply multiple labels if user prefers

### Unknown Sender
- Check content signals heavily
- Default to conservative classification
- Flag for review if uncertain

### Foreign Language
- Focus on structural signals (domains, formats)
- Use known service patterns
- May require language-specific rules
