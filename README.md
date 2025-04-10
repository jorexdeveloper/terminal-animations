<h1 align="center" style="color:#C9D1D9;">TERMINAL ANIMATIONS</h1>

<p align="center">
	<a href="https://github.com/jorexdeveloper/terminal-animations/stargazers" title="View Stargazers">
		<img
			src="https://img.shields.io/github/stars/jorexdeveloper/terminal-animations?colorA=0D1117&colorB=58A6FF&style=for-the-badge">
	</a>
	<a href="https://github.com/jorexdeveloper/terminal-animations/issues" title="View Issues">
		<img
			src="https://img.shields.io/github/issues/jorexdeveloper/terminal-animations?colorA=0D1117&colorB=F85149&style=for-the-badge">
	</a>
	<a href="https://github.com/jorexdeveloper/terminal-animations/contributors" title="View Contributors">
		<img
			src="https://img.shields.io/github/contributors/jorexdeveloper/terminal-animations?colorA=0D1117&colorB=2EA043&style=for-the-badge">
	</a>
    <a href="https://github.com/jorexdeveloper/terminal-animations/releases" title="View Releases">
        <img src="https://img.shields.io/github/v/release/jorexdeveloper/terminal-animations?style=for-the-badge">
    </a>
</p>

Displays animations as you wait for long running commands in your terminal.

## Demo

![Demo of animate.sh](./demo.gif)

<details>
    <summary>Table of Contents</summary>
    <ul>
        <li><a href="#overview" title="Go to Overview">Overview</a></li>
        <li><a href="#why-use-this" title="Go to Why Use This?">Why Use This?</a></li>
        <li><a href="#features" title="Go to Features">Features</a></li>
        <li><a href="#installation" title="Go to Installation">Installation</a></li>
        <li><a href="#setup" title="Go to Setup">Setup</a></li>
        <li><a href="#usage" title="Go to Usage">Usage</a>
            <ul>
                <li><a href="#options" title="Go to Options">Options</a></li>
                <li><a href="#examples" title="Go to Examples">Examples</a></li>
            </ul>
        </li>
        <li><a href="#demo" title="Go to Demo">Demo</a></li>
        <li><a href="#logs" title="Go to Logs">Logs</a></li>
        <li><a href="#error-handling" title="Go to Error Handling">Error Handling</a></li>
        <li><a href="#contributions" title="Go to Contributions">Contributions</a></li>
        <li><a href="#license" title="Go to License">License</a></li>
    </ul>
</details>

## Overview

`animate.sh` is a lightweight Bash script that adds a touch of interactivity and fun to terminal commands. It enhances the user experience in terminal environments by providing visual feedback during command execution.

## Why Use This?

-   Lightweight and easy to use.
-   No external dependencies required.
-   Fully customizable animations.
-   Works seamlessly with any terminal command.

## Features

-   Multiple animation styles and customizable frames.
-   Adjustable animation speed, prefixes, and suffixes.
-   Logs command output for debugging and auditing.
-   Graceful error handling with detailed logs.

## Installation

You can install `animate.sh` by cloning the repository or downloading the latest release:

1. **Clone the Repository**

    ```bash
    git clone https://github.com/jorexdeveloper/terminal-animations.git
    cd terminal-animations
    ```

2. **Download the Latest Release**

    Visit the [Releases](https://github.com/jorexdeveloper/terminal-animations/releases "View Releases") page, download the latest release, and extract it:

    ```bash
    tar -xzf terminal-animations-<version>.tar.gz
    cd terminal-animations-<version>
    ```

## Setup

After installation, follow these steps to set up the script:

1. **Ensure Bash is Installed**

    The script requires Bash to run. Most Linux distributions and macOS come with Bash pre-installed. To check if Bash is installed, run:

    ```bash
    bash --version
    ```

2. **Set Execute Permissions**

    Make the `animate.sh` script executable:

    ```bash
    chmod +x /path/to/animate.sh
    ```

3. **Recommended: Add Alias**

    For convenience, add an alias to your shell configuration file (e.g., `.bashrc` or `.zshrc`):

    ```bash
    alias _='/path/to/animate.sh <your-default-options>'
    ```

    Reload your shell configuration or restart your terminal to use the alias `_`.

4. **Test the Setup**

    Run a simple test to ensure everything is working:

    ```bash
    _ -p "Testing "  sleep 2
    ```

## Usage

Run the script with the desired options and the command to execute:

```bash
_ [options] <command [args]>
```

### Options

| Option         | Description                                                              |
| -------------- | ------------------------------------------------------------------------ |
| `-f <frames>`  | Comma-separated list of animation frames.                                |
| `-p <prefix>`  | Prefix text for the animation. Use `<name>` to include the command name. |
| `-s <suffix>`  | Suffix text for the animation. Use `<name>` to include the command name. |
| `-i <seconds>` | Time interval between frames (default: 0.2).                             |
| `-a <name>`    | Name of the animation to use (default: dots).                            |
| `-l`           | List all available animations.                                           |
| `-L <path>`    | Custom directory for storing log files.                                  |
| `-A <path>`    | Custom directory for animation scripts.                                  |
| `-h`           | Display the help message.                                                |

### Examples

1. **Custom Animation Frames**

    ```bash
    _ -f "⠁,⠂,⠄,⡀,⢀,⠠,⠐,⠈" -i 0.1 tar -czf archive.tar.gz /path/to/directory
    ```

2. **Customise prefix**

    ```bash
    _ -p "Downloading file with <name> " wget https://example.com/largefile.zip
    ```

3. **Use a Predefined Animation**

    ```bash
    _ -a spinner -- python3 script.py --input data.csv --output results.json
    ```

### Logs

Command output is logged to a `logs` directory in the location of the script by default, but can be customized (see [options](#options "Go to Options")). Each log file is named after the executed command, e.g., `logs/sleep.log`.

## Contributions

Contributions are welcome! Follow these steps to contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request with a clear description of your changes.

### Adding Custom Animations

To create a new animation, refer to the [Animations README](./ANIMATIONS.md "View Animations README") for detailed instructions.

## License

This project is licensed under the GNU General Public License v3.0. You are free to use, modify, and distribute this software under the terms of [the license](./LICENSE "View the license").
