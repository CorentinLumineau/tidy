# OAuth Setup Guide

This guide walks you through setting up OAuth credentials for your personal Gmail account.

## Prerequisites

- A personal Gmail account (not Google Workspace)
- [gog CLI](https://github.com/steipete/gogcli) installed

## Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Click the project dropdown at the top
3. Click **New Project**
4. Name it: `Gmail-Personal-Assistant`
5. Click **Create**

## Step 2: Enable Gmail API

1. In your new project, go to **APIs & Services > Library**
2. Search for **Gmail API**
3. Click on it and click **Enable**

## Step 3: Configure OAuth Consent Screen

1. Go to **APIs & Services > OAuth consent screen**
2. Select **External** (for personal accounts)
3. Click **Create**
4. Fill in required fields:
   - **App name**: `Gmail Assistant`
   - **User support email**: Your email
   - **Developer contact email**: Your email
5. Click **Save and Continue**
6. On Scopes page, click **Add or Remove Scopes**
7. Add these scopes:
   - `https://www.googleapis.com/auth/gmail.modify`
   - `https://www.googleapis.com/auth/gmail.labels`
8. Click **Save and Continue**
9. On Test Users page, click **Add Users**
10. Add your Gmail address
11. Click **Save and Continue**

## Step 4: Create OAuth Credentials

1. Go to **APIs & Services > Credentials**
2. Click **Create Credentials > OAuth client ID**
3. Application type: **Desktop app**
4. Name: `Gmail Assistant CLI`
5. Click **Create**
6. Click **Download JSON**
7. Save the file to `~/Downloads/`

## Step 5: Configure gog CLI

```bash
# Store your OAuth credentials
gog auth credentials ~/Downloads/client_secret_*.json

# Authorize your Gmail account (opens browser)
gog auth add your.email@gmail.com

# Set as default account
export GOG_ACCOUNT=your.email@gmail.com

# Add to your shell profile for persistence
echo 'export GOG_ACCOUNT=your.email@gmail.com' >> ~/.zshrc
```

## Step 6: Verify Setup

```bash
# List your Gmail labels
gog gmail labels list

# Search recent emails
gog gmail search 'newer_than:7d' --json | head -5
```

If you see your labels and emails, you're ready to use the Gmail Assistant plugin!

## Troubleshooting

### "Access blocked: This app's request is invalid"

Your OAuth consent screen may need to be published. For personal use with test users:
1. Go to OAuth consent screen
2. Ensure your email is in the Test Users list
3. The app can stay in "Testing" mode for personal use

### "Token has been expired or revoked"

Re-authorize with:
```bash
gog auth add your.email@gmail.com --force-consent
```

### "gog: command not found"

Install gog:
```bash
brew install steipete/tap/gogcli
```

### Permission errors

Ensure you added these scopes:
- `gmail.modify` - Required for label operations
- `gmail.labels` - Required for label management

If you added scopes after initial auth, re-run with `--force-consent`:
```bash
gog auth add your.email@gmail.com --force-consent
```

## Security Notes

- OAuth tokens are stored in your system keychain (macOS Keychain, Linux Secret Service)
- Never share your `client_secret_*.json` file
- Never commit tokens to version control
- You can revoke access anytime at [Google Account Security](https://myaccount.google.com/permissions)
