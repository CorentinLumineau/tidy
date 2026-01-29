#!/bin/bash
# Gmail Label Migration Script
# Migrates emails from old labels to new hierarchical structure
# Safety: Adds new label BEFORE removing old label

LOG_FILE="migration_log.txt"
DRY_RUN=${DRY_RUN:-false}

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

migrate_label() {
    local old_label="$1"
    local new_label="$2"

    log "Migrating: '$old_label' -> '$new_label'"

    # Get thread IDs with old label
    local threads
    threads=$(gog gmail search "label:$old_label" --max=500 --plain 2>/dev/null | awk '{print $1}')

    if [ -z "$threads" ]; then
        log "  No threads found with label '$old_label'"
        return 0
    fi

    local count=0
    for tid in $threads; do
        if [ "$DRY_RUN" = "true" ]; then
            log "  [DRY-RUN] Would migrate thread $tid"
        else
            # Add new label first, then remove old (safe order)
            gog gmail labels modify "$tid" --add="$new_label" --remove="$old_label" 2>/dev/null
            if [ $? -eq 0 ]; then
                ((count++))
            else
                log "  ERROR: Failed to migrate thread $tid"
            fi
        fi
    done

    log "  Migrated $count threads from '$old_label' to '$new_label'"
}

# Start migration
log "=========================================="
log "Starting Gmail Label Migration"
log "DRY_RUN: $DRY_RUN"
log "=========================================="

# ============================================
# Example migrations - customize for your inbox:
# ============================================

# Finance/Investments migrations
migrate_label "Old Investment Label" "Finance/Investments"
migrate_label "Dividend Alerts" "Finance/Investments"

# Finance/Taxes migrations
migrate_label "Taxes" "Finance/Taxes"

# Finance/Insurance migrations
migrate_label "Insurance" "Finance/Insurance"

# Finance/Payments migrations
migrate_label "Payment Records" "Finance/Payments"

# Services/Automotive migrations
migrate_label "Car" "Services/Automotive"

# Services/Gaming migrations
migrate_label "Steam" "Services/Gaming"
migrate_label "Games" "Services/Gaming"

# Services/Tech migrations
migrate_label "Development" "Services/Tech"
migrate_label "Newsletters" "Services/Tech"

# Projects/Travel migrations
migrate_label "Travel" "Projects/Travel"
migrate_label "Vacation" "Projects/Travel"

# Projects/Purchases migrations
migrate_label "Purchases" "Projects/Purchases"

# Projects/Legal migrations
migrate_label "Legal" "Projects/Legal"

# Admin/Security migrations
migrate_label "Account Security" "Admin/Security"

# Admin/Jobs migrations
migrate_label "Job Alerts" "Admin/Jobs"

# Status migrations
migrate_label "Waiting" "Status/Pending"
migrate_label "Important" "Status/Important"
migrate_label "Archive" "Status/Archive"

log "=========================================="
log "Migration Complete"
log "=========================================="
