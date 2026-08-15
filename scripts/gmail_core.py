#!/usr/bin/env python3
"""
Gmail Core - Shared Gmail API abstraction using gog CLI.

This module provides a clean interface for Gmail operations,
wrapping the gog CLI tool for secure OAuth-based access.
"""

import json
import subprocess
import sys
from dataclasses import dataclass
from typing import Optional
from collections import Counter


@dataclass
class AuthStatus:
    """Authentication status."""
    authenticated: bool
    account: Optional[str]
    error: Optional[str] = None


@dataclass
class Label:
    """Gmail label."""
    id: str
    name: str
    type: str  # 'system' or 'user'


@dataclass
class Email:
    """Gmail email summary."""
    id: str
    thread_id: str
    subject: str
    sender: str
    date: str
    labels: list[str]
    snippet: str


@dataclass
class Filter:
    """Gmail filter."""
    id: str
    criteria: dict
    action: dict


class GogError(Exception):
    """Error from gog CLI."""
    pass


class GmailCore:
    """Gmail API abstraction using gog CLI."""

    def __init__(self, account: Optional[str] = None):
        """Initialize with optional account override."""
        self.account = account

    def _run_gog(self, *args, json_output: bool = True) -> dict | list | str:
        """Run gog command and return parsed output."""
        cmd = ['gog']
        if self.account:
            cmd.extend(['--account', self.account])
        cmd.extend(args)
        if json_output:
            cmd.append('--json')

        try:
            result = subprocess.run(
                cmd,
                capture_output=True,
                text=True,
                check=True
            )
            if json_output and result.stdout.strip():
                return json.loads(result.stdout)
            return result.stdout.strip()
        except subprocess.CalledProcessError as e:
            raise GogError(f"gog command failed: {e.stderr}")
        except json.JSONDecodeError as e:
            raise GogError(f"Failed to parse gog output: {e}")

    def check_auth(self) -> AuthStatus:
        """Check if gog is authenticated."""
        try:
            result = subprocess.run(
                ['gog', 'auth', 'status'],
                capture_output=True,
                text=True
            )
            if result.returncode == 0:
                # Extract account from output
                lines = result.stdout.strip().split('\n')
                account = None
                for line in lines:
                    if '@' in line:
                        account = line.strip()
                        break
                return AuthStatus(authenticated=True, account=account)
            return AuthStatus(
                authenticated=False,
                account=None,
                error=result.stderr or "Not authenticated"
            )
        except FileNotFoundError:
            return AuthStatus(
                authenticated=False,
                account=None,
                error="gog CLI not found. Install with: brew install steipete/tap/gogcli"
            )

    def get_labels(self) -> list[Label]:
        """Get all Gmail labels."""
        data = self._run_gog('gmail', 'labels', 'list')
        labels = []
        for item in data:
            labels.append(Label(
                id=item.get('id', ''),
                name=item.get('name', ''),
                type=item.get('type', 'user')
            ))
        return labels

    def create_label(self, name: str) -> Label:
        """Create a new label."""
        data = self._run_gog('gmail', 'labels', 'create', name)
        return Label(
            id=data.get('id', ''),
            name=data.get('name', name),
            type='user'
        )

    def get_or_create_label(self, name: str) -> Label:
        """Get existing label or create if not exists."""
        labels = self.get_labels()
        for label in labels:
            if label.name.lower() == name.lower():
                return label
        return self.create_label(name)

    def delete_label(self, label_id: str) -> bool:
        """Delete a label by ID."""
        try:
            self._run_gog('gmail', 'labels', 'delete', label_id, json_output=False)
            return True
        except GogError:
            return False

    def search(self, query: str, limit: int = 100) -> list[Email]:
        """Search emails using Gmail query syntax."""
        data = self._run_gog('gmail', 'search', query)
        emails = []
        for item in data[:limit]:
            emails.append(Email(
                id=item.get('id', ''),
                thread_id=item.get('threadId', ''),
                subject=item.get('subject', ''),
                sender=item.get('from', ''),
                date=item.get('date', ''),
                labels=item.get('labelIds', []),
                snippet=item.get('snippet', '')
            ))
        return emails

    def get_filters(self) -> list[Filter]:
        """Get all Gmail filters."""
        data = self._run_gog('gmail', 'filters', 'list')
        filters = []
        for item in data:
            filters.append(Filter(
                id=item.get('id', ''),
                criteria=item.get('criteria', {}),
                action=item.get('action', {})
            ))
        return filters

    def create_filter(
        self,
        criteria_from: Optional[str] = None,
        criteria_to: Optional[str] = None,
        criteria_subject: Optional[str] = None,
        criteria_query: Optional[str] = None,
        add_label_ids: Optional[list[str]] = None,
        remove_label_ids: Optional[list[str]] = None
    ) -> Filter:
        """Create a Gmail filter."""
        cmd_args = ['gmail', 'filters', 'create']

        if criteria_from:
            cmd_args.extend(['--from', criteria_from])
        if criteria_to:
            cmd_args.extend(['--to', criteria_to])
        if criteria_subject:
            cmd_args.extend(['--subject', criteria_subject])
        if criteria_query:
            cmd_args.extend(['--query', criteria_query])
        if add_label_ids:
            for label_id in add_label_ids:
                cmd_args.extend(['--add-label', label_id])
        if remove_label_ids:
            for label_id in remove_label_ids:
                cmd_args.extend(['--remove-label', label_id])

        data = self._run_gog(*cmd_args)
        return Filter(
            id=data.get('id', ''),
            criteria=data.get('criteria', {}),
            action=data.get('action', {})
        )

    def delete_filter(self, filter_id: str) -> bool:
        """Delete a filter by ID."""
        try:
            self._run_gog('gmail', 'filters', 'delete', filter_id, json_output=False)
            return True
        except GogError:
            return False

    def modify_labels(
        self,
        message_ids: list[str],
        add_labels: Optional[list[str]] = None,
        remove_labels: Optional[list[str]] = None
    ) -> int:
        """Modify labels on messages. Returns count of modified messages."""
        # gog supports batch operations
        modified = 0
        for msg_id in message_ids:
            try:
                cmd_args = ['gmail', 'modify', msg_id]
                if add_labels:
                    for label in add_labels:
                        cmd_args.extend(['--add-label', label])
                if remove_labels:
                    for label in remove_labels:
                        cmd_args.extend(['--remove-label', label])
                self._run_gog(*cmd_args, json_output=False)
                modified += 1
            except GogError:
                continue
        return modified


def extract_domain(email_address: str) -> str:
    """Extract domain from email address."""
    if '<' in email_address:
        # Handle "Name <email@domain.com>" format
        start = email_address.find('<') + 1
        end = email_address.find('>')
        email_address = email_address[start:end]
    if '@' in email_address:
        return email_address.split('@')[1].lower()
    return email_address.lower()


def analyze_patterns(emails: list[Email]) -> dict:
    """Analyze email patterns for filter suggestions."""
    sender_domains = Counter()
    sender_full = Counter()

    for email in emails:
        domain = extract_domain(email.sender)
        sender_domains[domain] += 1
        sender_full[email.sender] += 1

    return {
        'total_emails': len(emails),
        'unique_domains': len(sender_domains),
        'unique_senders': len(sender_full),
        'top_domains': sender_domains.most_common(20),
        'top_senders': sender_full.most_common(20)
    }


def suggest_filters(patterns: dict) -> list[dict]:
    """Suggest filter rules based on patterns."""
    suggestions = []

    # Common patterns
    newsletter_patterns = ['substack', 'mailchimp', 'newsletter', 'digest', 'weekly', 'daily']
    notification_patterns = ['github', 'gitlab', 'jira', 'slack', 'notion', 'linear', 'asana']
    shopping_patterns = ['amazon', 'ebay', 'aliexpress', 'shopify', 'order', 'shipping']
    social_patterns = ['facebook', 'twitter', 'linkedin', 'instagram', 'tiktok']

    for domain, count in patterns['top_domains']:
        if count < 3:
            continue

        label = None
        domain_lower = domain.lower()

        if any(p in domain_lower for p in newsletter_patterns):
            label = 'Newsletters'
        elif any(p in domain_lower for p in notification_patterns):
            label = 'Notifications'
        elif any(p in domain_lower for p in shopping_patterns):
            label = 'Shopping'
        elif any(p in domain_lower for p in social_patterns):
            label = 'Social'
        elif 'noreply' in domain_lower or 'no-reply' in domain_lower:
            label = 'Automated'

        if label:
            suggestions.append({
                'domain': domain,
                'count': count,
                'suggested_label': label,
                'criteria': f'from:@{domain}',
                'confidence': 'high' if count >= 10 else 'medium'
            })

    return suggestions


if __name__ == '__main__':
    # Quick test
    gmail = GmailCore()
    status = gmail.check_auth()

    if status.authenticated:
        print(f"Authenticated as: {status.account}")
        labels = gmail.get_labels()
        print(f"Labels: {len(labels)}")
    else:
        print(f"Not authenticated: {status.error}")
        sys.exit(1)
