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
            log "Running TypeScript check and lint on $file_path..."

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

            # Function to find bun
            find_bun() {
                # Try common locations for bun
                local bun_paths=(
                    "$(command -v bun 2>/dev/null)"
                    "$(which bun 2>/dev/null)"
                    "$HOME/.bun/bin/bun"
                    "/usr/local/bin/bun"
                    "/opt/homebrew/bin/bun"
                )

                for path in "${bun_paths[@]}"; do
                    if [[ -x "$path" && -n "$path" ]]; then
                        echo "$path"
                        return 0
                    fi
                done

                return 1
            }

            # Variables to track results
            tsc_success=true
            lint_success=true
            all_output=""

            # Try to find TypeScript compiler
            tsc_cmd=$(find_tsc)
            if [[ -n "$tsc_cmd" ]]; then
                log "Found tsc at: $tsc_cmd"

                # Change to the directory with tsconfig.json and run TypeScript check
                cd "$tsconfig_dir" && {
                    log "Running: $tsc_cmd --noEmit"

                    # Capture tsc output and exit code
                    tsc_output=$("$tsc_cmd" --noEmit 2>&1)
                    tsc_exit_code=$?

                    # Log the output
                    if [[ -n "$tsc_output" ]]; then
                        log "tsc output: $tsc_output"
                        all_output="TypeScript Check:\n$tsc_output\n\n"
                    fi

                    log "tsc exit code: $tsc_exit_code"

                    if [[ $tsc_exit_code -eq 0 ]]; then
                        log "TypeScript check completed successfully - no type errors found"
                    else
                        log "TypeScript check found type errors"
                        tsc_success=false
                    fi
                }
            else
                log "TypeScript compiler not found in any expected location"
                log "WARNING: TypeScript check skipped - proceeding without type validation"
                all_output="WARNING: TypeScript compiler not found. Install TypeScript globally or locally to enable type checking.\n\n"
            fi

            # Try to find bun and run lint
            bun_cmd=$(find_bun)
            if [[ -n "$bun_cmd" ]]; then
                log "Found bun at: $bun_cmd"

                # Change to the directory and run bun lint
                cd "$tsconfig_dir" && {
                    log "Running: $bun_cmd lint"

                    # Check if package.json has lint script
                    if [[ -f "package.json" ]] && grep -q '"lint"' package.json; then
                        # Capture bun lint output and exit code
                        lint_output=$("$bun_cmd" lint 2>&1)
                        lint_exit_code=$?

                        # Log the output
                        if [[ -n "$lint_output" ]]; then
                            log "bun lint output: $lint_output"
                            all_output="${all_output}Lint Check:\n$lint_output"
                        fi

                        log "bun lint exit code: $lint_exit_code"

                        if [[ $lint_exit_code -eq 0 ]]; then
                            log "Lint check completed successfully - no lint errors found"
                        else
                            log "Lint check found errors"
                            lint_success=false
                        fi
                    else
                        log "No lint script found in package.json, skipping lint check"
                        all_output="${all_output}INFO: No lint script found in package.json. Add a lint script to enable linting."
                    fi
                }
            else
                log "Bun not found in any expected location"
                log "WARNING: Lint check skipped - bun not available"
                all_output="${all_output}WARNING: Bun not found. Install bun to enable lint checking."
            fi

            # Determine final result
            if [[ "$tsc_success" == true && "$lint_success" == true ]]; then
                log "All checks passed successfully"
                # Return success JSON (no blocking)
                decision='{"suppressOutput": false}'
                log "Hook decision: $decision"
                echo "$decision"
            else
                # Errors found - block the operation with JSON response
                log "Checks failed - blocking operation"

                # Create detailed reason message
                reason="Code quality checks failed for $file_path"

                if [[ "$tsc_success" == false ]]; then
                    reason="$reason\n\n❌ TypeScript errors found"
                fi

                if [[ "$lint_success" == false ]]; then
                    reason="$reason\n\n❌ Lint errors found"
                fi

                if [[ -n "$all_output" ]]; then
                    reason="$reason:\n\n$all_output\n\nPlease fix these issues before proceeding."
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
