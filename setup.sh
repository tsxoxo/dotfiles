#!/bin/bash
# dotfiles-setup.sh - Advanced dotfiles management script
# Handles synchronization, backup, and management of configuration files

set -e  # Exit on error
set -u  # Error on undefined variables

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Base directory for the dotfiles repository
DOTFILES_DIR="$HOME/dotfiles"
# Directory for single backup - idempotent approach
BACKUP_DIR="$HOME/dotfiles_backup"

# Config file for listing dotfiles to track
CONFIG_FILE="$DOTFILES_DIR/dotfiles.conf"
# Installation script for installing on a new machine
INSTALL_SCRIPT="$DOTFILES_DIR/install.sh"
# Readme file
README_FILE="$DOTFILES_DIR/README.md"

# Trap to handle errors and cleanup in case of failure
cleanup() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo -e "${RED}[ERROR]${NC} Script failed with exit code $exit_code"
        echo -e "${YELLOW}[INFO]${NC} Your original files are backed up in $BACKUP_DIR"
    fi
}
trap cleanup EXIT

# Log function for nice output
log() {
    echo -e "${GREEN}[DOTFILES]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

success() {
    echo -e "${CYAN}[SUCCESS]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

# Create the dotfiles directory and initialize git
setup_repo() {
    log "Setting up dotfiles repository at $DOTFILES_DIR"
    mkdir -p "$DOTFILES_DIR"
    cd "$DOTFILES_DIR" || error "Could not change to $DOTFILES_DIR"
    
    # Check if git is already initialized
    if [ -d ".git" ]; then
        info "Git repository already initialized in $DOTFILES_DIR"
    else
        log "Initializing git repository"
        git init
        create_readme
        git add "$README_FILE"
        git commit -m "Initial commit"
    fi
    
    # Create the backup directory only once
    if [ ! -d "$BACKUP_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        log "Created backup directory at $BACKUP_DIR"
    fi
    
    # Create config file if it doesn't exist
    if [ ! -f "$CONFIG_FILE" ]; then
        log "Creating configuration file at $CONFIG_FILE"
        cat > "$CONFIG_FILE" << EOF
# Dotfiles configuration
# Format: SOURCE_PATH|TARGET_DIRECTORY|DESCRIPTION
# Examples:
$HOME/.zshrc|zsh|ZSH configuration
$HOME/.config/nvim|nvim|Neovim configuration
$HOME/.gitconfig|git|Git configuration
$HOME/.config/karabiner/karabiner.json|karabiner|Karabiner keyboard customization
$HOME/.config/wezterm|wezterm|WezTerm terminal configuration
# Add new entries below
EOF
        git add "$CONFIG_FILE"
        git commit -m "Add initial dotfiles configuration"
    fi
    
    # Create install script if it doesn't exist
    if [ ! -f "$INSTALL_SCRIPT" ]; then
        log "Creating installation script at $INSTALL_SCRIPT"
        cat > "$INSTALL_SCRIPT" << 'EOF'
#!/bin/bash
# Dotfiles installation script
# This script creates symlinks from the home directory to the dotfiles repository

set -e  # Exit on error

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$DOTFILES_DIR/dotfiles.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Log functions
log() { echo -e "${GREEN}[DOTFILES]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

log "Installing dotfiles from $DOTFILES_DIR"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    error "Configuration file not found at $CONFIG_FILE"
fi

# Process each line in the config file
while IFS= read -r line || [ -n "$line" ]; do
    # Skip comments and empty lines
    if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    # Split the line by |
    IFS='|' read -r source target_dir description <<< "$line"
    
    # Clean up the paths
    source=$(eval echo "$source")
    target="$DOTFILES_DIR/$target_dir/$(basename "$source")"
    
    # Skip if target doesn't exist
    if [ ! -e "$target" ]; then
        warn "Target $target doesn't exist, skipping"
        continue
    fi
    
    # Create parent directory if it doesn't exist
    mkdir -p "$(dirname "$source")"
    
    # Backup existing file if it exists and is not a symlink to our target
    if [ -e "$source" ] && [ ! -L "$source" -o "$(readlink "$source")" != "$target" ]; then
        backup="${source}.backup.$(date +%Y%m%d%H%M%S)"
        log "Backing up $source to $backup"
        mv "$source" "$backup"
    elif [ -L "$source" ] && [ "$(readlink "$source")" != "$target" ]; then
        # If it's a symlink pointing elsewhere, remove it
        log "Removing existing symlink $source"
        rm "$source"
    fi
    
    # Create the symlink if needed
    if [ ! -e "$source" ]; then
        log "Creating symlink from $target to $source"
        ln -sf "$target" "$source"
    else
        info "$source is already linked correctly"
    fi
done < "$CONFIG_FILE"

log "Dotfiles installation complete!"
EOF
        chmod +x "$INSTALL_SCRIPT"
        git add "$INSTALL_SCRIPT"
        git commit -m "Add installation script"
    fi
}

# Create a nice README file
create_readme() {
    log "Creating README file"
    cat > "$README_FILE" << EOF
# Dotfiles

This repository contains my personal dotfiles, managed with a custom script.

## Contents

The repository includes configurations for:

- zsh: Shell configuration
- nvim: Neovim editor settings
- git: Git configuration
- karabiner: Keyboard customization
- wezterm: Terminal emulator settings

## Installation

To install these dotfiles on a new system:

\`\`\`bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
\`\`\`

## Managing Dotfiles

The repository includes a management script with these commands:

- \`./dotfiles-setup.sh\` - Sync all dotfiles
- \`./dotfiles-setup.sh add ~/.config/foo foo\` - Add new dotfile
- \`./dotfiles-setup.sh remove ~/.config/foo\` - Remove a dotfile
- \`./dotfiles-setup.sh list\` - List tracked dotfiles
- \`./dotfiles-setup.sh diff\` - Show differences between local and repo
- \`./dotfiles-setup.sh help\` - Show help information

## Customization

Edit the \`dotfiles.conf\` file to add or remove tracked files.
EOF
}

# Update the README file with the current list of dotfiles
update_readme() {
    log "Updating README file"
    
    # Get the current list of tracked files
    local tracked_files=""
    grep -v "^#" "$CONFIG_FILE" | grep -v "^$" | while IFS= read -r line || [ -n "$line" ]; do
        IFS='|' read -r source target_dir description <<< "$line"
        tracked_files="${tracked_files}- ${target_dir}: ${description:-Configuration for $(basename "$source")}\n"
    done
    
    # Update the Contents section of the README
    awk -v tracked="$tracked_files" '
    /^## Contents$/,/^## / {
        if (/^## Contents$/) {
            print;
            print "\nThe repository includes configurations for:\n";
            printf tracked;
            in_contents = 1;
        } else if (/^## / && in_contents) {
            in_contents = 0;
            print;
        } else if (!in_contents) {
            print;
        }
    }
    !in_contents { print }
    ' "$README_FILE" > "${README_FILE}.tmp"
    
    mv "${README_FILE}.tmp" "$README_FILE"
}

# Function to check if a symlink is correctly set up
is_correctly_linked() {
    local source="$1"
    local target="$2"
    
    # Check if source exists and is a symlink
    if [ -L "$source" ]; then
        # Get the target of the symlink
        local current_target=$(readlink "$source")
        
        # Normalize paths for comparison
        local normalized_target=$(cd "$(dirname "$target")" && pwd)/$(basename "$target")
        local normalized_current=$(cd "$(dirname "$current_target")" 2>/dev/null && pwd)/$(basename "$current_target") 2>/dev/null
        
        # If the symlink already points to the right place, we're good
        if [ "$normalized_current" = "$normalized_target" ]; then
            return 0  # True in bash
        fi
    fi
    
    return 1  # False in bash
}

# Function to backup existing file/dir and create a symlink
backup_and_link() {
    local source="$1"
    local target="$2"
    
    # Skip if source doesn't exist
    if [ ! -e "$source" ] && [ ! -L "$source" ]; then
        info "$source does not exist, will create symlink directly"
    else
        # If already properly symlinked, do nothing
        if is_correctly_linked "$source" "$target"; then
            info "$source is already correctly linked to $target"
            return
        fi
    fi
    
    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"
    
    # Backup if exists and not already in backup
    if [ -e "$source" ] || [ -L "$source" ]; then
        local backup_path="$BACKUP_DIR/$(basename "$source")"
        
        # Check if we've already backed this up
        if [ ! -e "$backup_path" ]; then
            log "Backing up $source to $backup_path"
            if [ -d "$source" ] && [ ! -L "$source" ]; then
                cp -R "$source" "$backup_path"
            else
                cp -P "$source" "$backup_path"  # -P preserves symlinks
            fi
        else
            info "Backup for $source already exists, skipping backup"
        fi
    fi
    
    # Copy source to repo if not already there
    if [ -e "$source" ] && [ ! -L "$source" ]; then
        # Check if we need to copy
        if [ ! -e "$target" ]; then
            log "Copying $source to $target"
            if [ -d "$source" ]; then
                cp -R "$source" "$target"
            else
                cp "$source" "$target"
            fi
        else
            # Target exists - could merge or ask, for now we'll keep as is
            info "Target $target already exists, keeping existing files"
        fi
    fi
    
    # Remove original and create symlink
    if [ -e "$source" ] || [ -L "$source" ]; then
        log "Removing original $source"
        rm -rf "$source"
    fi
    
    log "Creating symlink from $target to $source"
    ln -sf "$target" "$source"
}

# Export MacPorts package list - only if different from existing
export_macports() {
    log "Checking MacPorts package list"
    mkdir -p "$DOTFILES_DIR/macports"
    
    local temp_installed=$(mktemp)
    local temp_requested=$(mktemp)
    
    port installed > "$temp_installed"
    port installed requested > "$temp_requested"
    
    # Only update if different
    if [ ! -e "$DOTFILES_DIR/macports/installed_packages.txt" ] || ! cmp -s "$temp_installed" "$DOTFILES_DIR/macports/installed_packages.txt"; then
        log "Updating installed packages list"
        mv "$temp_installed" "$DOTFILES_DIR/macports/installed_packages.txt"
    else
        info "Installed packages list is already up to date"
        rm "$temp_installed"
    fi
    
    if [ ! -e "$DOTFILES_DIR/macports/requested_packages.txt" ] || ! cmp -s "$temp_requested" "$DOTFILES_DIR/macports/requested_packages.txt"; then
        log "Updating requested packages list"
        mv "$temp_requested" "$DOTFILES_DIR/macports/requested_packages.txt"
    else
        info "Requested packages list is already up to date"
        rm "$temp_requested"
    fi
}

# Add a new dotfile to track
add_dotfile() {
    local source="$1"
    local target_dir="$2"
    local description="${3:-Configuration for $(basename "$source")}"
    
    # Expand the source path if it contains ~
    source=$(eval echo "$source")
    
    # Check if source exists
    if [ ! -e "$source" ] && [ ! -L "$source" ]; then
        error "Source file/directory $source does not exist"
    fi
    
    # Add to config file if not already there
    if ! grep -q "^$source|$target_dir|" "$CONFIG_FILE"; then
        echo "$source|$target_dir|$description" >> "$CONFIG_FILE"
        log "Added $source to dotfiles configuration"
        
        # Create target directory
        mkdir -p "$DOTFILES_DIR/$target_dir"
        
        # Backup and link
        backup_and_link "$source" "$DOTFILES_DIR/$target_dir/$(basename "$source")"
        
        # Update README
        update_readme
        
        # Commit changes
        cd "$DOTFILES_DIR" || error "Could not change to $DOTFILES_DIR"
        git add .
        git commit -m "Add $source to dotfiles"
        
        success "Successfully added $source to dotfiles"
    else
        warn "$source is already in the configuration"
    fi
}

# Remove a dotfile from tracking
remove_dotfile() {
    local source="$1"
    
    # Expand the source path if it contains ~
    source=$(eval echo "$source")
    
    # Check if the file is tracked
    if grep -q "^$source|" "$CONFIG_FILE"; then
        # Get target directory
        local target_dir=$(grep "^$source|" "$CONFIG_FILE" | cut -d'|' -f2)
        local target="$DOTFILES_DIR/$target_dir/$(basename "$source")"
        
        # Check if there's a backup
        local backup_path="$BACKUP_DIR/$(basename "$source")"
        if [ -e "$backup_path" ]; then
            # Restore from backup
            log "Restoring $source from backup"
            if [ -L "$source" ]; then
                rm "$source"
            fi
            cp -R "$backup_path" "$source"
        elif [ -L "$source" ] && [ "$(readlink "$source")" = "$target" ]; then
            # If it's a symlink to our target, remove it
            log "Removing symlink $source"
            rm "$source"
        fi
        
        # Remove from config file
        log "Removing $source from configuration"
        grep -v "^$source|" "$CONFIG_FILE" > "${CONFIG_FILE}.tmp"
        mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
        
        # Update README
        update_readme
        
        # Commit changes
        cd "$DOTFILES_DIR" || error "Could not change to $DOTFILES_DIR"
        git add .
        git commit -m "Remove $source from dotfiles"
        
        success "Successfully removed $source from dotfiles"
    else
        error "$source is not being tracked"
    fi
}

# Show differences between local files and repository
show_diff() {
    log "Checking for differences between local files and repository"
    
    # Process each line in the config file
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
            continue
        fi
        
        # Split the line by |
        IFS='|' read -r source target_dir description <<< "$line"
        
        # Expand the source path if it contains ~
        source=$(eval echo "$source")
        local target="$DOTFILES_DIR/$target_dir/$(basename "$source")"
        
        # Check if both exist
        if [ -e "$source" ] && [ -e "$target" ]; then
            # Skip if source is already a symlink to target
            if is_correctly_linked "$source" "$target"; then
                continue
            fi
            
            # For directories, use diff -r
            if [ -d "$source" ] && [ -d "$target" ]; then
                echo -e "${MAGENTA}Differences for $source:${NC}"
                diff -r "$source" "$target" 2>/dev/null || true
                echo ""
            # For files, use regular diff
            elif [ -f "$source" ] && [ -f "$target" ]; then
                echo -e "${MAGENTA}Differences for $source:${NC}"
                diff "$source" "$target" 2>/dev/null || true
                echo ""
            fi
        elif [ -e "$source" ]; then
            echo -e "${YELLOW}$target doesn't exist, but $source does${NC}"
        elif [ -e "$target" ]; then
            echo -e "${YELLOW}$source doesn't exist, but $target does${NC}"
        fi
    done < "$CONFIG_FILE"
}

# Process all dotfiles in config
process_dotfiles() {
    # Process each line in the config file
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip comments and empty lines
        if [[ "$line" =~ ^#.*$ ]] || [[ -z "$line" ]]; then
            continue
        fi
        
        # Split the line by |
        IFS='|' read -r source target_dir description <<< "$line"
        
        # Expand the source path if it contains ~
        source=$(eval echo "$source")
        
        # Create target directory if needed
        mkdir -p "$DOTFILES_DIR/$target_dir"
        
        # Get the target path
        local target="$DOTFILES_DIR/$target_dir/$(basename "$source")"
        
        # Backup and link
        backup_and_link "$source" "$target"
    done < "$CONFIG_FILE"
}

# Commit changes if there are any
commit_changes() {
    cd "$DOTFILES_DIR" || error "Could not change to $DOTFILES_DIR"
    
    # Check if there are changes to commit
    if ! git diff --quiet || ! git diff --staged --quiet || [ -n "$(git ls-files --others --exclude-standard)" ]; then
        log "Committing changes to dotfiles repository"
        git add .
        git commit -m "Update dotfiles: $(date +%Y-%m-%d)"
        return 0
    else
        info "No changes to commit"
        return 1
    fi
}

# Print usage information
usage() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  sync                     Synchronize all dotfiles (default if no command given)"
    echo "  add SOURCE DIR [DESC]    Add a new dotfile to track (SOURCE is path, DIR is target directory name)"
    echo "  remove SOURCE            Remove a dotfile from tracking"
    echo "  list                     List all currently tracked dotfiles"
    echo "  diff                     Show differences between local files and repository"
    echo "  update-readme            Update the README file with current dotfiles"
    echo "  help                     Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                                   # Sync all dotfiles"
    echo "  $0 add ~/.tmux.conf tmux \"Tmux config\"  # Add tmux config to tracking"
    echo "  $0 remove ~/.tmux.conf               # Remove tmux config from tracking"
    echo "  $0 list                              # List tracked files"
    echo "  $0 diff                              # Show differences"
}

# List all tracked dotfiles
list_dotfiles() {
    echo -e "${CYAN}Currently tracked dotfiles:${NC}"
    echo "--------------------------"
    grep -v "^#" "$CONFIG_FILE" | grep -v "^$" | while IFS= read -r line || [ -n "$line" ]; do
        IFS='|' read -r source target_dir description <<< "$line"
        # Expand the source path if it contains ~
        source=$(eval echo "$source")
        local target="$DOTFILES_DIR/$target_dir/$(basename "$source")"
        
        echo -e "${GREEN}Source:${NC} $source"
        echo -e "${GREEN}Target:${NC} $target"
        if [ -n "$description" ]; then
            echo -e "${GREEN}Description:${NC} $description"
        fi
        
        if [ -L "$source" ]; then
            local link_target=$(readlink "$source")
            if [ "$link_target" = "$target" ]; then
                echo -e "${GREEN}Status:${NC} Correctly linked"
            else
                echo -e "${YELLOW}Status:${NC} Linked to wrong target: $link_target"
            fi
        elif [ -e "$source" ]; then
            echo -e "${YELLOW}Status:${NC} Exists but not linked"
        else
            echo -e "${RED}Status:${NC} Source file missing"
        fi
        
        echo "--------------------------"
    done
}

# Main function
main() {
    # Setup the repository (always do this first)
    setup_repo
    
    # Process command line arguments
    if [ $# -eq 0 ]; then
        # No arguments, do sync
        process_dotfiles
        export_macports
        commit_changes
    else
        case "$1" in
            sync)
                process_dotfiles
                export_macports
                commit_changes
                ;;
            add)
                if [ $# -lt 3 ]; then
                    error "The 'add' command requires a source path and target directory"
                fi
                add_dotfile "$2" "$3" "${4:-}"
                ;;
            remove)
                if [ $# -lt 2 ]; then
                    error "The 'remove' command requires a source path"
                fi
                remove_dotfile "$2"
                ;;
            list)
                list_dotfiles
                ;;
            diff)
                show_diff
                ;;
            update-readme)
                update_readme
                commit_changes
                ;;
            help)
                usage
                ;;
            *)
                error "Unknown command: $1"
                usage
                ;;
        esac
    fi
    
    log "Dotfiles operation complete!"
    log "Repository at: $DOTFILES_DIR"
    log "Backups at: $BACKUP_DIR"
    log "Don't forget to push this to a remote repository for backup if needed."
}

# Run the main function with all arguments
main "$@"
