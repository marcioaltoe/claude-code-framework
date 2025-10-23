#!/usr/bin/env python3

import json
import os
import sys
import subprocess


def get_git_branch():
    """Get current git branch."""
    timeout = float(os.getenv('GIT_TIMEOUT_SECONDS', '2'))
    try:
        result = subprocess.run(
            ['git', 'rev-parse', '--abbrev-ref', 'HEAD'],
            capture_output=True,
            text=True,
            timeout=timeout
        )
        if result.returncode == 0:
            return result.stdout.strip()
    except:
        pass
    return None


def get_git_status():
    """Get git status indicators."""
    timeout = float(os.getenv('GIT_TIMEOUT_SECONDS', '2'))
    try:
        # Check if there are uncommitted changes
        result = subprocess.run(
            ['git', 'status', '--porcelain'],
            capture_output=True,
            text=True,
            timeout=timeout
        )
        if result.returncode == 0:
            changes = result.stdout.strip()
            if changes:
                lines = changes.split('\n')
                return f"±{len(lines)}"
    except:
        pass
    return ""


def format_output_style(style_info):
    """Format output style information with colors."""
    if not style_info:
        return None

    # Try to get style name from the nested structure
    style = style_info.get('name', style_info.get('current_style', 'default'))

    # Get color scheme preference
    color_scheme = os.getenv('CLAUDE_STATUS_COLOR_SCHEME', 'auto').lower().strip()

    # Use single emoji for all styles
    emoji = "⚡"
    
    if color_scheme == 'minimal':
        return f"{emoji} {style}"
    else:
        # Use soft pink for all styles
        color = '\033[38;5;176m'  # Soft pink/mauve
        return f"{color}{emoji} {style}\033[0m"


def generate_status_line(input_data):
    """Generate enhanced status line with colors and git status."""
    
    # Get color scheme preference
    color_scheme = os.getenv('CLAUDE_STATUS_COLOR_SCHEME', 'auto').lower().strip()
    
    # Line 1: Model and Output Style
    model_info = input_data.get('model', {})
    model_name = model_info.get('display_name', 'Claude')
    base_name = model_name.split(' ')[0] if model_name else 'Claude'
    
    # Format model with brain emoji and color
    if color_scheme == 'minimal':
        model_display = f"🧠 {base_name}"
    else:
        model_display = f"\033[38;5;75m🧠 {base_name}\033[0m"  # Soft sky blue
    
    # Format output style
    output_info = input_data.get('output_style', {})
    style_display = format_output_style(output_info)
    if not style_display:
        if color_scheme == 'minimal':
            style_display = "default"
        else:
            style_display = "\033[38;5;176m⚡ default\033[0m"
    
    line1 = f"{model_display} | {style_display}"
    
    # Line 2: Directory and Git Branch with Status
    workspace = input_data.get('workspace', {})
    current_dir = workspace.get('current_dir', '')
    
    # Get last two directory levels
    if current_dir:
        path_parts = current_dir.rstrip('/').split('/')
        if len(path_parts) >= 2:
            dir_name = f"{path_parts[-2]}/{path_parts[-1]}"
        else:
            dir_name = path_parts[-1] if path_parts else 'unknown'
    else:
        dir_name = 'unknown'
    
    # Format directory with color
    if color_scheme == 'minimal':
        dir_display = f"📁 {dir_name}"
    else:
        dir_display = f"\033[38;5;110m📁 {dir_name}\033[0m"  # Soft light blue
    
    # Get git information
    git_branch = get_git_branch()
    if git_branch:
        git_status = get_git_status()
        git_info = f"🌿 {git_branch}"
        if git_status:
            git_info += f" {git_status}"
        
        if color_scheme == 'minimal':
            git_display = git_info
        else:
            git_display = f"\033[38;5;114m{git_info}\033[0m"  # Soft green
    else:
        if color_scheme == 'minimal':
            git_display = "no git"
        else:
            git_display = "\033[38;5;245mno git\033[0m"  # Medium gray
    
    line2 = f"{dir_display} | {git_display}"
    
    return f"{line1}\n{line2}"


def main():
    try:
        # Read JSON input from stdin
        input_data = json.loads(sys.stdin.read())
        
        # Generate and output status line
        status_line = generate_status_line(input_data)
        print(status_line)
        
        sys.exit(0)
    except json.JSONDecodeError:
        # Handle JSON decode errors gracefully - output basic status
        color_scheme = os.getenv('CLAUDE_STATUS_COLOR_SCHEME', 'auto').lower().strip()
        if color_scheme == 'minimal':
            print("Claude | default\n📁 unknown | no git")
        else:
            print("\033[38;5;75m🧠 Claude\033[0m | \033[38;5;176m⚡ default\033[0m\n\033[38;5;110m📁 unknown\033[0m | \033[38;5;245mno git\033[0m")
        sys.exit(0)
    except Exception as e:
        # Handle any other errors gracefully - output basic status
        color_scheme = os.getenv('CLAUDE_STATUS_COLOR_SCHEME', 'auto').lower().strip()
        if color_scheme == 'minimal':
            print("Claude | default\n📁 unknown | no git")
        else:
            print("\033[38;5;75m🧠 Claude\033[0m | \033[38;5;176m⚡ default\033[0m\n\033[38;5;110m📁 unknown\033[0m | \033[38;5;245mno git\033[0m")
        sys.exit(0)


if __name__ == '__main__':
    main()