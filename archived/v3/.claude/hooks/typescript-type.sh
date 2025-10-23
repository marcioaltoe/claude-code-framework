#!/bin/bash

# Set up logging
LOG_FILE="$HOME/.claude/hooks/typescript-check.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Start logging
log "=== Hook execution started (JSON mode) ==="

# Read JSON input from stdin
input=$(cat)

# Log the raw input
log "Raw input received: $input"

# Extract file path from the JSON input
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.target_file // empty')

log "Extracted file_path: '$file_path'"

# Check if file path is not empty and is a TypeScript file
if [[ -n "$file_path" && "$file_path" != "null" && "$file_path" != "empty" ]]; then
    log "File path is not empty: $file_path"

    # Check if it's a TypeScript file
    if [[ "$file_path" == *.ts || "$file_path" == *.tsx ]]; then
        log "File is a TypeScript file: $file_path"

        # Check if the file actually exists
        if [[ -f "$file_path" ]]; then
            log "Running TypeScript check on $file_path..."

            # Get the directory containing the TypeScript file
            dir=$(dirname "$file_path")
            log "Changing to directory: $dir"

            # Look for tsconfig.json in current directory or parent directories
            tsconfig_dir="$dir"
            while [[ "$tsconfig_dir" != "/" ]]; do
                if [[ -f "$tsconfig_dir/tsconfig.json" ]]; then
                    log "Found tsconfig.json in: $tsconfig_dir"
                    break
                fi
                tsconfig_dir=$(dirname "$tsconfig_dir")
            done

            # If no tsconfig.json found, use the file's directory
            if [[ ! -f "$tsconfig_dir/tsconfig.json" ]]; then
                log "No tsconfig.json found, using file directory: $dir"
                tsconfig_dir="$dir"
            fi

            # Function to find TypeScript compiler
            find_tsc() {
                # Try common locations for tsc
                local tsc_paths=(
                    "$(command -v tsc 2>/dev/null)"
                    "$(which tsc 2>/dev/null)"
                    "$tsconfig_dir/node_modules/.bin/tsc"
                    "$(pwd)/node_modules/.bin/tsc"
                    "$HOME/.local/state/fnm_multishells/*/bin/tsc"
                    "$HOME/.nvm/versions/node/*/bin/tsc"
                    "$HOME/.volta/bin/tsc"
                    "/usr/local/bin/tsc"
                    "/opt/homebrew/bin/tsc"
                )

                for path in "${tsc_paths[@]}"; do
                    # Handle glob patterns
                    if [[ "$path" == *"*"* ]]; then
                        for expanded_path in $path; do
                            if [[ -x "$expanded_path" ]]; then
                                echo "$expanded_path"
                                return 0
                            fi
                        done
                    elif [[ -x "$path" && -n "$path" ]]; then
                        echo "$path"
                        return 0
                    fi
                done

                return 1
            }

            # Try to find TypeScript compiler
            tsc_cmd=$(find_tsc)
            if [[ -n "$tsc_cmd" ]]; then
                log "Found tsc at: $tsc_cmd"

                # Change to the directory with tsconfig.json and run TypeScript check
                cd "$tsconfig_dir" && {
                    log "Running: $tsc_cmd --noEmit"

                    # Capture tsc output and exit code
                    tsc_output=$("$tsc_cmd" --noEmit 2>&1)
                    exit_code=$?

                    # Log the output
                    if [[ -n "$tsc_output" ]]; then
                        log "tsc output: $tsc_output"
                    fi

                    log "tsc exit code: $exit_code"

                    if [[ $exit_code -eq 0 ]]; then
                        log "TypeScript check completed successfully - no type errors found"
                        # Return success JSON (no blocking)
                        decision='{"suppressOutput": false}'
                        log "Hook decision: $decision"
                        echo "$decision"
                    else
                        # Type errors found - block the operation with JSON response
                        log "TypeScript check found type errors - blocking operation"

                        # Create detailed reason message
                        reason="TypeScript compiler found type errors in $file_path"
                        if [[ -n "$tsc_output" ]]; then
                            reason="$reason:\n\n$tsc_output\n\nPlease fix these type errors before proceeding."
                        else
                            reason="$reason. Please fix these type errors before proceeding."
                        fi

                        # Return blocking JSON response
                        decision=$(jq -n --arg reason "$reason" '{
                            "decision": "block",
                            "reason": $reason
                        }')
                        log "Hook decision: $decision"
                        echo "$decision"
                    fi
                }
            else
                log "TypeScript compiler not found in any expected location"
                log "WARNING: TypeScript check skipped - proceeding without type validation"

                # Instead of blocking, warn and allow the operation to proceed
                decision='{"suppressOutput": false, "warning": "TypeScript compiler not found. Install TypeScript globally or locally to enable type checking."}'
                log "Hook decision: $decision"
                echo "$decision"
            fi
        else
            log "File does not exist: $file_path"
            decision='{}'
            log "Hook decision: $decision"
            echo "$decision"
        fi
    else
        log "Not a TypeScript file, skipping: $file_path"
        decision='{}'
        log "Hook decision: $decision"
        echo "$decision"
    fi
else
    log "File path is empty or null, skipping"
    decision='{}'
    log "Hook decision: $decision"
    echo "$decision"
fi

log "=== Hook execution completed (JSON mode) ==="
log ""
