# helpers.py

import os
import subprocess
from environment import set_environment_variables
from user_interaction import get_user_confirmation


def run_command(command, user_input=None):
    """Run a shell command and handle output appropriately."""

    if user_input is not None:
        # If input is provided programmatically (non-interactive)
        process = subprocess.Popen(command, shell=True, stdin=subprocess.PIPE)
        process.communicate(input=user_input.encode())
    else:
        # For interactive commands (like sudo/fdesetup), don't redirect stdout/stderr
        process = subprocess.Popen(command, shell=True)
        process.wait()

    return process.returncode



def run_functions(prompt, command_to_run, section_title):
    """Run a command with a prompt for user confirmation."""

    if prompt:
        if get_user_confirmation(prompt):
            # User confirmed; execute interactively
            run_command(command_to_run)
            set_environment_variables(section_title)
        else:
            print("Skipping this task.\n")
    else:
        # No prompt provided; automatic execution
        run_command(command_to_run)



def print_section_heading(title):
    """Print a formatted section heading."""
    terminal_width = os.get_terminal_size().columns
    title_length = len(title) + 4  # Account for additional characters
    length_to_fill = terminal_width - title_length

    fill_characters = '─' * length_to_fill
    formatted_title = f"─ \033[1m{title}\033[0m {fill_characters}"

    print(formatted_title)  # Output section heading to standard output


def clear_terminal():
    """Clear the terminal screen."""
    os.system('clear' if os.name == 'posix' else 'cls')
