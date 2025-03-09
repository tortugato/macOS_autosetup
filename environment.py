# environment.py

import os

from config import ENV_VARS


def set_environment_variables(section_title):
    """Set environment variables based on the section title."""
    if section_title in ENV_VARS:
        os.environ[ENV_VARS[section_title]] = 'true'
