#!/bin/bash
# Drive organization helper script
# Usage: DRY_RUN=true ./scripts/drive_organize.sh
# Creates the standard folder hierarchy in Google Drive

set -e

DRY_RUN=${DRY_RUN:-false}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_dry() {
    echo -e "${YELLOW}[DRY-RUN]${NC} Would: $1"
}

# Folder hierarchy to create
FOLDERS=(
    "Documents"
    "Documents/Personal"
    "Documents/Personal/Identity"
    "Documents/Personal/Medical"
    "Documents/Personal/Certificates"
    "Documents/Finance"
    "Documents/Finance/Banking"
    "Documents/Finance/Taxes"
    "Documents/Finance/Insurance"
    "Documents/Finance/Investments"
    "Documents/Legal"
    "Documents/Legal/Contracts"
    "Documents/Legal/Correspondence"
    "Documents/Work"
    "Documents/Work/CV-Portfolio"
    "Documents/Work/Certifications"
    "Documents/Work/References"
    "Projects"
    "Projects/Active"
    "Projects/Completed"
    "Projects/Templates"
    "Media"
    "Media/Photos"
    "Media/Photos/Events"
    "Media/Photos/Travel"
    "Media/Photos/Screenshots"
    "Media/Videos"
    "Media/Audio"
    "Resources"
    "Resources/Ebooks"
    "Resources/Courses"
    "Resources/Reference"
    "Resources/Software"
    "Shared"
    "Shared/Incoming"
    "Shared/Outgoing"
    "Archive"
    "Archive/By-Year"
    "Archive/Deprecated"
)

# Check if gog is available
if ! command -v gog &> /dev/null; then
    echo "Error: gog CLI not found. Please install it first."
    exit 1
fi

# Check authentication
if ! gog drive about --plain &> /dev/null; then
    echo "Error: Not authenticated with Google Drive. Run 'gog auth' first."
    exit 1
fi

log_info "Google Drive Folder Structure Setup"
log_info "===================================="

if [ "$DRY_RUN" = "true" ]; then
    log_warn "DRY RUN MODE - No changes will be made"
    echo ""
fi

# Get existing folders
log_info "Checking existing folders..."
EXISTING_FOLDERS=$(gog drive ls --query="mimeType='application/vnd.google-apps.folder'" --max=500 --plain 2>/dev/null | awk '{print $2}' || echo "")

created=0
skipped=0

for folder in "${FOLDERS[@]}"; do
    # Extract just the folder name (last part of path)
    folder_name=$(basename "$folder")

    # Check if folder already exists (simple name check)
    if echo "$EXISTING_FOLDERS" | grep -q "^${folder_name}$"; then
        log_info "Exists: $folder"
        ((skipped++))
    else
        if [ "$DRY_RUN" = "true" ]; then
            log_dry "Create folder: $folder"
        else
            # For nested folders, we need to create parent first
            # This simplified version creates flat folders
            # A more sophisticated version would track parent IDs
            log_info "Creating: $folder"
            gog drive mkdir "$folder_name" 2>/dev/null || log_warn "Could not create: $folder"
        fi
        ((created++))
    fi
done

echo ""
log_info "Summary:"
log_info "  - Folders to create: $created"
log_info "  - Folders existing: $skipped"

if [ "$DRY_RUN" = "true" ]; then
    echo ""
    log_warn "Run without DRY_RUN=true to create folders"
fi
