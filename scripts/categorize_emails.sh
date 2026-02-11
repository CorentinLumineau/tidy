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
# Sender patterns for email categorization
# ============================================

# Finance/Investments
categorize_by_sender "remake.fr" "Finance/Investments"
categorize_by_sender "livestormevents.com" "Finance/Investments"
categorize_by_sender "corum.fr" "Finance/Investments"
categorize_by_sender "deblock.com" "Finance/Investments"
categorize_by_sender "solanamobile.com" "Finance/Investments"
categorize_by_sender "mintos.com" "Finance/Investments"
categorize_by_sender "lita.co" "Finance/Investments"
categorize_by_sender "nansen.ai" "Finance/Investments"
categorize_by_sender "meilleursagents.com" "Finance/Investments"

# Finance/Insurance
categorize_by_sender "votreassistance.fr" "Finance/Insurance"
categorize_by_sender "matmut" "Finance/Insurance"

# Admin/Impots (Taxes)
categorize_by_sender "humanisconseil.ch" "Admin/Impots"
categorize_by_sender "mfconseil.ch" "Admin/Impots"
categorize_by_sender "infos.ge.ch" "Admin/Impots"

# Admin/Jobs
categorize_by_sender "codingame.com" "Admin/Jobs"
categorize_by_sender "enova-consulting.ch" "Admin/Jobs"
categorize_by_sender "extia.ch" "Admin/Jobs"
categorize_by_sender "extia.es" "Admin/Jobs"
categorize_by_sender "degetel.com" "Admin/Jobs"
categorize_by_sender "michaelpage.ch" "Admin/Jobs"
categorize_by_sender "linkedin.com" "Admin/Jobs"
categorize_by_sender "groupeadequat.fr" "Admin/Jobs"

# Admin/Security
categorize_by_sender "incogni.com" "Admin/Security"
categorize_by_sender "mail.proton.me" "Admin/Security"
categorize_by_sender "accounts.google.com" "Admin/Security"
categorize_by_sender "accountprotection.microsoft.com" "Admin/Security"

# Admin/Notifications
categorize_by_sender "todoist.com" "Admin/Notifications"

# Services/Gaming
categorize_by_sender "steampowered.com" "Services/Gaming"
categorize_by_sender "ankama.com" "Services/Gaming"
categorize_by_sender "dofus.com" "Services/Gaming"
categorize_by_sender "skinbaron.de" "Services/Gaming"

# Services/Automotive
categorize_by_sender "vinci-autoroutes.com" "Services/Automotive"
categorize_by_sender "autoxperience.ch" "Services/Automotive"

# Services/Tech
categorize_by_sender "github.com" "Services/Tech"
categorize_by_sender "gitlab.com" "Services/Tech"
categorize_by_sender "chipolo.net" "Services/Tech"
categorize_by_sender "opensourceprojects.dev" "Services/Tech"
categorize_by_sender "e-mails.microsoft.com" "Services/Tech"
categorize_by_sender "melvynx" "Services/Tech"
categorize_by_sender "passmail.net" "Services/Tech"
categorize_by_sender "coder.com" "Services/Tech"
categorize_by_sender "mapbox.com" "Services/Tech"
categorize_by_sender "notice.co" "Services/Tech"
categorize_by_sender "nordvpn.com" "Services/Tech"
categorize_by_sender "nordaccount.com" "Services/Tech"
categorize_by_sender "orchids.app" "Services/Tech"
categorize_by_sender "linear.app" "Services/Tech"
categorize_by_sender "warp.dev" "Services/Tech"
categorize_by_sender "f5.com" "Services/Tech"
categorize_by_sender "vercel.com" "Services/Tech"
categorize_by_sender "firecrawl.dev" "Services/Tech"

# Services/Shopping
categorize_by_sender "columbuscafe.com" "Services/Shopping"
categorize_by_sender "digitecgalaxus.ch" "Services/Shopping"
categorize_by_sender "rakuten.com" "Services/Shopping"
categorize_by_sender "crowdexpert.org" "Services/Shopping"

# Projects/Travel
categorize_by_sender "monbillet.sncf" "Projects/Travel"
categorize_by_sender "boxtal.com" "Projects/Travel"

# Projects/Purchases (delivery & orders)
categorize_by_sender "chronopost.fr" "Projects/Purchases"
categorize_by_sender "mondialrelay.fr" "Projects/Purchases"

# Finance/Payments
categorize_by_sender "klarna.fr" "Finance/Payments"

# Projects/Legal (government, housing)
categorize_by_sender "e-service.admin.ch" "Projects/Legal"
categorize_by_sender "justice.gouv.fr" "Projects/Legal"
categorize_by_sender "ants.gouv.fr" "Projects/Legal"
categorize_by_sender "visale.fr" "Projects/Legal"
categorize_by_sender "actionlogement.fr" "Projects/Legal"

log "=========================================="
log "Categorization Complete"
log "=========================================="
