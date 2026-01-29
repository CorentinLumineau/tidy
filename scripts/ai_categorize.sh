#!/bin/bash
# AI-based Email Categorization Script
# Categorizes emails based on subject and sender analysis

LOG_FILE="migration_log.txt"
DRY_RUN=${DRY_RUN:-false}
CATEGORY=${CATEGORY:-"primary"}  # Options: promotions, social, updates, primary, all

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

categorize_email() {
    local thread_id="$1"
    local from="$2"
    local subject="$3"
    local label=""

    # ============================================
    # Example patterns - customize for your inbox:
    # ============================================

    # Investment/Finance related
    if echo "$from $subject" | grep -qiE "crypto|investment|dividend|portfolio|trading|broker"; then
        label="Finance/Investments"
    # Gaming
    elif echo "$from $subject" | grep -qiE "steam|gaming|game|esport|playstation|xbox"; then
        label="Services/Gaming"
    # Tech/Development
    elif echo "$from $subject" | grep -qiE "github|gitlab|kubernetes|docker|aws|cloud"; then
        label="Services/Tech"
    # Travel
    elif echo "$from $subject" | grep -qiE "travel|flight|hotel|booking|airbnb|airline"; then
        label="Projects/Travel"
    # Insurance
    elif echo "$from $subject" | grep -qiE "insurance|policy|coverage|claim"; then
        label="Finance/Insurance"
    # Taxes/Admin
    elif echo "$from $subject" | grep -qiE "tax|government|gov|official"; then
        label="Finance/Taxes"
    # Automotive
    elif echo "$from $subject" | grep -qiE "auto|car|vehicle|motor|parking"; then
        label="Services/Automotive"
    # Payments/Banking
    elif echo "$from $subject" | grep -qiE "payment|paypal|bank|invoice|receipt"; then
        label="Finance/Payments"
    fi

    if [ -n "$label" ]; then
        if [ "$DRY_RUN" = "true" ]; then
            log "  [DRY-RUN] Would label $thread_id with '$label' (From: $from)"
        else
            gog gmail labels modify "$thread_id" --add="$label" 2>/dev/null
            if [ $? -eq 0 ]; then
                log "  Labeled $thread_id with '$label'"
            else
                log "  ERROR: Failed to label $thread_id"
            fi
        fi
        return 0
    else
        log "  SKIP: No matching category for: $subject (From: $from)"
        return 1
    fi
}

# Build search query based on category
build_search_query() {
    case "$CATEGORY" in
        promotions)
            echo "in:promotions has:nouserlabels -in:spam -in:trash"
            ;;
        social)
            echo "in:social has:nouserlabels -in:spam -in:trash"
            ;;
        updates)
            echo "in:updates has:nouserlabels -in:spam -in:trash"
            ;;
        primary)
            echo "has:nouserlabels -in:promotions -in:social -in:updates -in:forums -in:spam -in:trash"
            ;;
        all)
            echo "has:nouserlabels -in:spam -in:trash"
            ;;
        *)
            log "ERROR: Unknown category '$CATEGORY'. Valid options: promotions, social, updates, primary, all"
            exit 1
            ;;
    esac
}

# Start categorization
log "=========================================="
log "Starting AI-based Email Categorization"
log "DRY_RUN: $DRY_RUN"
log "CATEGORY: $CATEGORY"
log "=========================================="

# Get search query for selected category
SEARCH_QUERY=$(build_search_query)
log "Search query: $SEARCH_QUERY"

# Get unlabeled emails
gog gmail search "$SEARCH_QUERY" --max=200 --plain 2>/dev/null | tail -n +2 | while IFS=$'\t' read -r id date from subject labels thread; do
    [ -z "$id" ] && continue
    categorize_email "$id" "$from" "$subject"
done

log "=========================================="
log "AI Categorization Complete"
log "=========================================="
