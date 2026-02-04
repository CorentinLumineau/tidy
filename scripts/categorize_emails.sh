#!/bin/bash
# Gmail Email Categorization Script
# Labels unlabeled emails based on sender patterns

LOG_FILE="migration_log.txt"
DRY_RUN=${DRY_RUN:-false}
CATEGORY=${CATEGORY:-"primary"}  # Options: promotions, social, updates, primary, all

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Build base search query based on category
build_category_filter() {
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

categorize_by_sender() {
    local sender_pattern="$1"
    local target_label="$2"

    log "Categorizing: from:$sender_pattern -> '$target_label'"

    # Build search query with category filter
    local base_filter
    base_filter=$(build_category_filter)
    local search_query="from:$sender_pattern $base_filter -label:$target_label"

    # Search for emails from sender that don't already have the target label
    local threads
    threads=$(gog gmail search "$search_query" --max=500 --plain 2>/dev/null | awk '{print $1}')

    if [ -z "$threads" ]; then
        log "  No uncategorized threads found from '$sender_pattern' in category '$CATEGORY'"
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
log "CATEGORY: $CATEGORY"
log "=========================================="

# ============================================
# Example patterns - customize for your inbox:
# ============================================

# Finance/Investments
categorize_by_sender "investment-platform.com" "Finance/Investments"
categorize_by_sender "broker.com" "Finance/Investments"
categorize_by_sender "remake.fr" "Finance/Investments"

# Finance/Taxes
categorize_by_sender "tax-authority.gov" "Finance/Taxes"
categorize_by_sender "humanisconseil.ch" "Finance/Taxes"
categorize_by_sender "mfconseil.ch" "Finance/Taxes"
categorize_by_sender "infos.ge.ch" "Finance/Taxes"

# Finance/Insurance
categorize_by_sender "insurance-provider.com" "Finance/Insurance"

# Admin/Jobs (technical assessments)
categorize_by_sender "codingame.com" "Admin/Jobs"

# Services/Gaming
categorize_by_sender "steampowered.com" "Services/Gaming"
categorize_by_sender "gaming-platform.com" "Services/Gaming"
categorize_by_sender "ankama.com" "Services/Gaming"
categorize_by_sender "dofus.com" "Services/Gaming"

# Services/Automotive
categorize_by_sender "car-tracker.com" "Services/Automotive"
categorize_by_sender "ulys.com" "Services/Automotive"

# Services/Tech
categorize_by_sender "github.com" "Services/Tech"
categorize_by_sender "gitlab.com" "Services/Tech"

# Projects/Legal (government documents, not taxes)
categorize_by_sender "e-service.admin.ch" "Projects/Legal"
categorize_by_sender "justice.gouv.fr" "Projects/Legal"
categorize_by_sender "ants.gouv.fr" "Projects/Legal"

log "=========================================="
log "Categorization Complete"
log "=========================================="
