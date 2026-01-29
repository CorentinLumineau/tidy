#!/bin/bash
# Gmail Email Categorization Script
# Labels unlabeled emails based on sender patterns

LOG_FILE="migration_log.txt"
DRY_RUN=${DRY_RUN:-false}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

categorize_by_sender() {
    local sender_pattern="$1"
    local target_label="$2"

    log "Categorizing: from:$sender_pattern -> '$target_label'"

    # Search for emails from sender that don't already have the target label
    local threads
    threads=$(gog gmail search "from:$sender_pattern -label:$target_label" --max=500 --plain 2>/dev/null | awk '{print $1}')

    if [ -z "$threads" ]; then
        log "  No uncategorized threads found from '$sender_pattern'"
        return 0
    fi

    local count=0
    for tid in $threads; do
        if [ "$DRY_RUN" = "true" ]; then
            log "  [DRY-RUN] Would label thread $tid with '$target_label'"
        else
            gog gmail labels modify "$tid" --add="$target_label" 2>/dev/null
            if [ $? -eq 0 ]; then
                ((count++))
            else
                log "  ERROR: Failed to label thread $tid"
            fi
        fi
    done

    log "  Labeled $count threads with '$target_label'"
}

# Start categorization
log "=========================================="
log "Starting Email Categorization by Sender"
log "DRY_RUN: $DRY_RUN"
log "=========================================="

# ============================================
# Example patterns - customize for your inbox:
# ============================================

# Finance/Investments
categorize_by_sender "investment-platform.com" "Finance/Investments"
categorize_by_sender "broker.com" "Finance/Investments"

# Finance/Taxes
categorize_by_sender "tax-authority.gov" "Finance/Taxes"

# Finance/Insurance
categorize_by_sender "insurance-provider.com" "Finance/Insurance"

# Services/Gaming
categorize_by_sender "steampowered.com" "Services/Gaming"
categorize_by_sender "gaming-platform.com" "Services/Gaming"

# Services/Automotive
categorize_by_sender "car-tracker.com" "Services/Automotive"

# Services/Tech
categorize_by_sender "github.com" "Services/Tech"
categorize_by_sender "gitlab.com" "Services/Tech"

log "=========================================="
log "Categorization Complete"
log "=========================================="
