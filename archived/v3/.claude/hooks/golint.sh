#!/bin/bash

# Set up logging
LOG_FILE="$HOME/.claude/hooks/golangci-lint.log"
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

# Check if file path is not empty and is a Go file
if [[ -n "$file_path" && "$file_path" != "null" && "$file_path" != "empty" ]]; then
    log "File path is not empty: $file_path"

    # Check if it's a Go file
    if [[ "$file_path" == *.go ]]; then
        log "File is a Go file: $file_path"

        # Check if the file actually exists
        if [[ -f "$file_path" ]]; then
            log "Running golangci-lint on $file_path..."

            # Get the directory containing the Go file
            dir=$(dirname "$file_path")
            log "Changing to directory: $dir"

            # Check if golangci-lint is available
            if command -v golangci-lint &> /dev/null; then
                log "golangci-lint command found"

                # Change to the directory and run golangci-lint
                cd "$dir" && {
                    log "Running: golangci-lint run --fix --allow-parallel-runners"

                    # Capture golangci-lint output and exit code
                    lint_output=$(golangci-lint run --fix --allow-parallel-runners 2>&1)
                    exit_code=$?

                    # Log the output
                    if [[ -n "$lint_output" ]]; then
                        log "golangci-lint output: $lint_output"
                    fi

                    log "golangci-lint exit code: $exit_code"

                                         if [[ $exit_code -eq 0 ]]; then
                         log "golangci-lint completed successfully - no issues found"
                         # Return success JSON (no blocking)
                         decision='{"suppressOutput": false}'
                         log "Hook decision: $decision"
                         echo "$decision"
                    else
                        # Lint errors found - block the operation with JSON response
                        log "golangci-lint found issues - blocking operation"

                        # Create detailed reason message
                        reason="golangci-lint found issues in $file_path"
                        if [[ -n "$lint_output" ]]; then
                            reason="$reason:\n\n$lint_output\n\nPlease fix these issues before proceeding."
                        else
                            reason="$reason. Please fix these issues before proceeding."
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
                 log "golangci-lint command not found"
                 decision=$(jq -n '{
                     "decision": "block",
                     "reason": "golangci-lint command not found in PATH. Please install golangci-lint."
                 }')
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
         log "Not a Go file, skipping: $file_path"
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
