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
