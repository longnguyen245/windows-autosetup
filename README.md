# Project Setup and Usage Guide

This document provides instructions for setting up and using the project on Windows, including configuration overrides, generating new configurations, and updating the source code.

## Windows

### Setup

To set up the project on Windows, follow these steps:

1. **Prepare Configuration**:
   - If you have not yet set up a PC-specific configuration, generate the necessary configuration files by double-clicking the following scripts:
     - **Generate a New PC Directory**: Double-click `generateNewPC.cmd` to create a new `pc/<myPC>/` directory with default configurations based on `localConfigs.sh`.
     - **Generate a Configuration File**: Double-click `generateConfigs.cmd` to create a `configs.sh` file and a `packages.sh` file in the `pc/<myPC>/` directory.
   - **Note**: If the `pc/<myPC>/` directory, `configs.sh` file, and `packages.sh` file already exist with your desired settings, you can skip the above steps.

2. **Run the Setup Script**:
   - Double-click the `windows.cmd` script to automatically set up the project environment using the configurations in `pc/<myPC>/configs.sh` and install applications listed in `pc/<myPC>/packages.sh`.

3. **Directory Structure**:
   - The project uses a specific directory structure for configurations and assets:
     - `assets/default/configs.sh`: Contains the default configuration settings.
     - `pc/<myPC>/configs.sh`: Overrides the default configuration for a specific PC (replace `<myPC>` with your PC's name, e.g., `as7`).
     - `pc/<myPC>/packages.sh`: Specifies applications to be automatically installed during setup.
     - `pc/<myPC>/assets/*`: Any files in this directory will override corresponding files in the `assets/` directory.
     - `localConfigs.sh`: Contains local configuration settings used when generating a new PC directory.

4. **Configuration Override**:
   - To customize settings for your PC, create or edit a `configs.sh` file in the `pc/<myPC>/` directory. This file will override settings defined in `assets/default/configs.sh`.
   - To specify applications for automatic installation, create or edit a `packages.sh` file in the `pc/<myPC>/` directory.
   - Example structure of `pc/<myPC>/configs.sh`:
     ```bash
     ENABLE_SHOW_HIDDEN_FILES=1
     ```
   - **Usage Instructions for configs.sh**:
     - By default, all settings in `configs.sh` are **enabled** when listed without a `#` prefix.
     - To **disable** a setting, add a `#` at the beginning of the line. For example:
       ```bash
       #ENABLE_SHOW_HIDDEN_FILES=1  # Disabled
       ENABLE_SHOW_HIDDEN_FILES=1  # Enabled
       ```
     - **Available settings** (in `configs.sh`):
       - `SCOOP_ARIA2`: Enables aria2 for Scoop package manager to speed up downloads.
       - `TYPING_VIETNAMESE_LINK`: Specifies the URL to download the EVKey Vietnamese typing tool.
       - `AUTOSTART_WITH_WINDOWS`: Enables the application to start automatically with Windows.
       - `ENABLE_UTC_TIME`: Sets the system time to UTC.
       - `TIME_ZONE`: Sets the system time zone (e.g., "SE Asia Standard Time").
       - `FORMAT_TIME`: Defines the time display format (e.g., "HH:mm").
       - `FORMAT_DATE`: Defines the date display format (e.g., "dd/MM/yyyy").
       - `ENABLE_SHOW_HIDDEN_FILES`: Shows hidden files in File Explorer.
       - `ENABLE_SHOW_HIDDEN_EXTENSIONS`: Shows file extensions in File Explorer.
       - `DISABLE_SHOW_HIDDEN_SHOW_RECENTLY_FILES`: Disables the display of recently used files in File Explorer.
       - `DISABLE_SHOW_HIDDEN_SHOW_FREQUENTLY_FILES`: Disables the display of frequently used files in File Explorer.
       - `OPEN_EXPLORER_DEFAULT_WITH_THIS_PC`: Sets File Explorer to open to "This PC" by default.
       - `COMBINE_TASKBAR_BUTTONS_IS_FULL`: Combines taskbar buttons when the taskbar is full.
       - `SET_DEFAULT_WSL2`: Sets WSL2 as the default Windows Subsystem for Linux version.
       - `ENABLE_HYPER_V`: Enables Hyper-V for virtualization.
       - `ENABLE_WSL`: Enables Windows Subsystem for Linux.
       - `ENABLE_VIRTUAL_MACHINE`: Enables virtual machine platform support.
       - `ENABLE_SANDBOX`: Enables Windows Sandbox.
       - `INSTALL_NODEJS`: Installs Node.js during setup.
       - `NODEJS_VERSION`: Specifies the Node.js version to install.
       - `NODEJS_GLOBAL_PACKAGES`: Lists Node.js packages to install globally, separated by spaces.
       - `CLEAR_SETUP_TMP_DIR`: Deletes the temporary setup directory after completion.
     - **Usage Instructions for packages.sh**:
       - The `packages.sh` file lists applications to be automatically installed during setup.

5. **Local Configuration**:
   - The `localConfigs.sh` file, located in the project root, contains settings used when generating a new PC directory with `generateNewPC.cmd`.
   - Example structure of `localConfigs.sh`:
     ```bash
     NAME="Name"
     EMAIL="nam@gmail.com"
     PC="as7"
     WORKSPACE_PATH="D:\\"
     ```
   - **Configuration Details**:
     - `NAME`: Your name for identification in the project.
     - `EMAIL`: Your email address for configuration or notifications.
     - `PC`: The name of your PC (e.g., `as7`).
     - `WORKSPACE_PATH`: The path to your workspace directory (e.g., `D:\\`).
   - Edit `localConfigs.sh` before running `generateNewPC.cmd` to customize the default settings for new PC directories.

6. **Asset Overrides**:
   - Place any custom asset files in the `pc/<myPC>/` directory to override the default assets in the `assets/` directory.
   - Ensure the file names match those in `assets/` for the override to take effect.

### Generating a New Configuration

To generate a new configuration for a specific PC:

1. **Run the Generate Config Script**:
   - Double-click the `generateConfigs.cmd` script to create a new `configs.sh` and `packages.sh` file in the `pc/<myPC>/` directory.
   - Example default template for `configs.sh`:
     ```bash
     INSTALL_NODEJS=1
     NODEJS_VERSION=22
     NODEJS_GLOBAL_PACKAGES="pnpm yarn"
     CLEAR_SETUP_TMP_DIR=1
     ```
   - The `packages.sh` file will be generated to specify applications for automatic installation.
   - Edit the generated `configs.sh` and `packages.sh` files in `pc/<myPC>/` to customize settings and applications.

2. **Create a New PC Directory**:
   - Double-click the `generateNewPC.cmd` script to create a new `pc/<myPC>/` directory with default configurations.
   - This script uses settings from `localConfigs.sh` to populate the new directory with a `configs.sh` file, a `packages.sh` file, and other necessary files.
   - Example of settings applied from `localConfigs.sh`:
     ```bash
     NAME="Name"
     EMAIL="nam@gmail.com"
     PC="as7"
     WORKSPACE_PATH="D:\\"
     ```
   - Customize the generated files in `pc/<myPC>/` to suit your needs.

### Updating the Source Code

To update the project source code to the latest version:

1. **Run the Update Script**:
   - Double-click the `updateSource.cmd` script to fetch and apply the latest source code updates.

### Example Directory Structure

```
project/
├── assets/
│   └── default/
│       └── configs.sh
        ...
├── pc/
│   └── as7/
        ├── assets/
            ├── ...
│       ├── configs.sh
│       ├── packages.sh
│       └── [other custom asset files]
├── localConfigs.sh
├── windows.cmd
├── generateConfigs.cmd
├── generateNewPC.cmd
├── updateSource.cmd
└── README.md
```

### Notes

- Do not edit files directly in the `assets/` directory, as it contains binary (bin) files. Instead, override assets by placing modified files in `pc/<myPC>/assets/` with matching file names.
- Ensure all paths in `localConfigs.sh`, `pc/<myPC>/configs.sh`, and `pc/<myPC>/packages.sh` (e.g., `WORKSPACE_PATH`) are valid and accessible on your system.
- Always back up custom configurations in `localConfigs.sh`, `pc/<myPC>/configs.sh`, and `pc/<myPC>/packages.sh` before running `updateSource.cmd`, as updates may overwrite files.
- Replace `<myPC>` with the actual name of your PC (e.g., `as7`).

### Credits

- **Grok**: Created by xAI, used for generating and updating this documentation.
- **Scoop**: A command-line installer for Windows, utilized for package management in this project. Visit [https://scoop.sh](https://scoop.sh) for more information.

For further assistance, refer to the scripts or contact the project maintainer.