# User configuration.
#
# This file should contain the product-specific configuration.
# For example, one may overwrite default global configuration
# values such as ROOT_ONLY.
# Plus, one should define the three greeter functions 'welcome',
# 'installation_complete', and 'installation_incomplete'.

# Set to 1 to enforce root installations.
#ROOT_ONLY=1

# Overwrite to disable the initial touch-all-files.
INITIAL_TOUCH_ALL=0

# Overwrite default utils & tasks directories.
UTILS_DIR=${INSTALLER_PATH}/bash-installer-framework/utils
TASKS_DIR=${INSTALLER_PATH}/../tasks

# Overwrite default log-to-stdout config.
#LOG_STDOUT=( "ERROR" "IMPORTANT" "WARNING" "INFO" "SKIP" "START" "FINISH" )


#function welcome() {
#  echo -e "$(tput setaf 4)Welcome to the new and shiny installer framework!$(tput sgr0)"
#}

#function installation_complete() {
#  echo -e "$(tput setaf 2)Installation Complete$(tput sgr0)"
#
#  # If you want the install script to terminate automatically:
#  exit 0
#}

#function installation_incomplete() {
#  echo -e "$(tput setaf 1)Installation Incomplete$(tput sgr0)"
#}

#function main_menu_prompt() {
#  echo "$(tput setaf 2)Main Menu$(tput sgr0)"
#}

#function task_menu_prompt() {
#  echo "$(tput setaf 2)Select a Task$(tput sgr0)"
#}

#function skip_menu_prompt() {
#  echo "$(tput setaf 2)Skip?$(tput sgr0)"
#}
