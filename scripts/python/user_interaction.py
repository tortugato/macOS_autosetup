# user_interaction.py

def get_user_confirmation(prompt):
    """Get user confirmation with a prompt."""
    while True:
        choice = input(f"{prompt} (y/n): ").strip().lower()
        if choice in ['y', 'yes', '']:
            return True
        elif choice in ['n', 'no']:
            return False
        else:
            print("Invalid choice. Please enter 'y' or 'n'.")
