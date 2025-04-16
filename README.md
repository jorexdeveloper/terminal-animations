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

Display animations as you wait for running commands in your terminal.

## Demo

![Demo animations](./demo.gif)

<details>
    <summary>Table of Contents (Click to expand)</summary>
    <ul>
        <li><a href="#overview" title="Go to this section">Overview</a></li>
        <li><a href="#why-use-this" title="Go to this section">Why Use This?</a></li>
        <li><a href="#features" title="Go to this section">Features</a></li>
        <li><a href="#installation" title="Go to this section">Installation</a></li>
            <ul>
                <li><a href="#download-the-latest-release-recommended" title="Go to this section">Download the Latest Release (Recommended)</a></li>
                <li><a href="#clone-the-repository" title="Go to this section">Clone the Repository</a></li>
            </ul>
        <li><a href="#setup" title="Go to this section">Setup</a></li>
            <ul>
                <li><a href="#sourcing-animationssh" title="Go to this section">Sourcing animations.sh</a></li>
                <li><a href="#adding-animatesh-command-to-path" title="Go to this section">Adding animate.sh command to PATH</a></li>
                <li><a href="#key-difference-between-the-setups" title="Go to this section">Key difference between the setups</a></li>
            </ul>
        <li><a href="#usage" title="Go to this section">Usage</a>
            <ul>
                <li><a href="#basic-usage" title="Go to this section">Basic usage</a></li>
                <li><a href="#examples" title="Go to this section">Examples</a></li>
                <li><a href="#command-output" title="Go to this section">Command Output</a></li>
            </ul>
        </li>
        <li><a href="#adding-custom-animations" title="Go to this section">Adding Custom Animations</a></li>
        <li><a href="#contributing" title="Go to this section">Contributing</a></li>
        <li><a href="#license" title="Go to this section">License</a></li>
    </ul>
</details>

## Overview

**Terminal Animations** provides a lightweight Bash script that adds a touch of interactivity and fun to terminal commands. It enhances the user experience in terminal environments by providing visual feedback during command execution.

## Why Use This?

- Lightweight and easy to use.
- No external dependencies required.
- Fully customizable animations.
- Works seamlessly with any terminal command.

## Features

- Multiple animation styles and customizable frames.
- Adjustable animation speed, prefixes, and suffixes.
- Logs command output for debugging and auditing.
- Graceful error handling with detailed logs.

## Installation

You can install the animations in **one of two ways**:

1. ### Download the Latest Release (Recommended)

   Visit the [Releases](https://github.com/jorexdeveloper/terminal-animations/releases "View Releases") page, download the latest release, and extract it:

   ```bash
   tar -xzf terminal-animations-v*.tar.gz &&
      cd terminal-animations-v*
   ```

2. ### Clone the Repository

   ```bash
   git clone https://github.com/jorexdeveloper/terminal-animations.git &&
      cd terminal-animations
   ```

## Setup

The setup can be done in **one of two ways**:

1. ### Sourcing animations.sh

   You can source `animations.sh` in your shell configuration file (e.g. `.bashrc` or `.zshrc`). This will automatically add a command named `::` to your shell's environment.

   ```bash
   # You can add such a line to your .bashrc
   source /path/to/animations.sh
   ```

2. ### Adding animate.sh command to PATH

   Make sure `animate.sh` is executable then add it's directory to your `PATH`.

   ```bash
   chmod +x /path/to/animate.sh
   ```

   ```bash
   # You can add such a line to your .bashrc
   export PATH="$PATH:/directory/of/animate.sh"
   ```

   **Add Alias (Optional but Recommended)**

   For convenience, add an alias to your shell configuration file (e.g. `.bashrc` or `.zshrc`) with your default options:

   ```bash
   # You can add such a line to your .bashrc
   alias ::='/path/to/animate.sh <your-default-options>'
   ```

   > Reload your shell configuration or restart your terminal to use the alias `::`.

   ### Key difference between the setups

   **Sourcing `animations.sh`**

   - Allows use of aliased commands
   - Automatically creates `::` command in shell environment.

   **Using `animate.sh`**

   - Works well with other shells e.g. fish

## Usage

### Basic usage

```bash
:: [options] [--] <command [args]>
```

See `:: --help` for the full usage.

### Examples

1. **Customise Animation**

   ```bash
   :: -a spinner -- sleep 5
   ```

2. **Customise prefix**

   ```bash
   :: -p "Downloading file with <name> " wget https://example.com/largefile.zip
   ```

3. **Customise Animation Frames**

   ```bash
   :: -f "⠁,⠂,⠄,⡀,⢀,⠠,⠐,⠈" -i 0.1 tar -czf archive.tar.gz /path/to/directory
   ```

### Command Output

Command output is sent to `/logs/directory/command_name.log`.

## Adding Custom Animations

To add new animations, refer to the [Animations Documentation](./ANIMATIONS.md "View Animations Documentation") for detailed instructions.

## Contributing

Contributions are welcome! Just:

1. Fork the repository.
2. Make your changes and submit pull request.

## License

This project is licensed under the GNU General Public License v3.0. You are free to use, modify, and distribute this software under the terms of [the license](./LICENSE "View the license").
