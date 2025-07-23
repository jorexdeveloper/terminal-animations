<h1 align="center" style="color:#C9D1D9;">TERMINAL ANIMATIONS</h1>

## Demo

![Demo animations](./demo.gif)

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

<details>
    <summary>Table of Contents (Click to expand)</summary>
    <ul>
        <li><a href="#demo" title="Go to this section">Demo</a></li>
        <li><a href="#overview" title="Go to this section">Overview</a></li>
        <li><a href="#why-use-this" title="Go to this section">Why Use This?</a></li>
        <li><a href="#installation" title="Go to this section">Installation</a></li>
            <ul>
                <li><a href="#download-the-latest-release" title="Go to this section">Download the Latest Release</a></li>
                <li><a href="#run-the-makefile" title="Go to this section">Run the Makefile</a></li>
                <li><a href="#add-alias-optional-but-recommended" title="Go to this section">Add Alias (Optional but Recommended)</a></li>
                <li><a href="#special-for-bashzsh-users" title="Go to this section">Special for Bash Users</a></li>
                <li><a href="#advantages-of-sourcing-animatesh" title="Go to this section">Advantages of Sourcing tan</a></li>
            </ul>
        <li><a href="#usage" title="Go to this section">Usage</a></li>
            <ul>
                <li><a href="#examples" title="Go to this section">Examples</a></li>
                <li><a href="#command-output" title="Go to this section">Command Output</a></li>
            </ul>
        <li><a href="#creating-a-new-animation" title="Go to this section">Creating a New Animation</a>
            <ul>
                <li><a href="#create-a-new-script-file" title="Go to this section">Create a New Script File</a></li>
                <li><a href="#define-the-animation-frames" title="Go to this section">Define the Animation Frames</a></li>
                <li><a href="#use-the-animation" title="Go to this section">Use the Animation</a></li>
            </ul>
        </li>
        <li><a href="#license" title="Go to this section">License</a></li>
    </ul>
</details>

## Overview

**tan** is a light-weight Bash script that adds a touch of interactivity and fun to terminal commands. It enhances the user experience in terminal environments by providing visual feedback during command execution.

## Why Use This?

- Lightweight and easy to use.
- No external dependencies required.
- Works with multiple shells i.e bash, zsh, fish, etc.
- Multiple animation styles and customizable frames.
- Adjustable animation speed, prefixes, and suffixes.
- Logs command output for debugging and auditing.
- Graceful error handling with detailed logs.

## Installation

To install and setup **tan** for any shell just:

1. ### Download the Latest Release

   Visit the [Releases](https://github.com/jorexdeveloper/terminal-animations/releases "View Releases") page, download the latest release, and extract it:

   ```bash
   tar -xzf terminal-animations-v*.tar.gz
      cd terminal-animations-v*
   ```

2. ### Run the Makefile

   ```bash
   make install
   ```

3. ### Add Alias (Optional but Recommended)

   For convenience, add an alias to your shell's configuration file (e.g. .zshrc) with your default options:

   ```bash
   # You can add such a line to your shell's configuration
   alias ::='tan <your-default-options>'
   ```

4. ### Special for Bash/Zsh Users

   Bash/Zsh users can also source **tan.sh** (not tan) in their _.bashrc/.zshrc_ file. This will automatically add a command named `::` to the shell's environment.

   ```bash
   cp tan.sh $HOME/.tan.sh &&
       echo 'source ~/.tan.sh' >> ~/.bashrc
   ```

   > Restart your terminal to use the command `::`.

   #### Advantages of Sourcing tan

   - Allows use of aliased commands with the program.
   - Automatically adds the `::` command to the shell environment.

## Usage

```bash
tan [OPTION] [--] COMMAND [ARGS...]
```

See `man tan` or `tan --help` for more information.

### Examples

1. **Customise Animation**

   ```bash
   tan -a classic -p 'Sleeping ' sleep 5
   ```

2. **Customise prefix**

   ```bash
   # <name> will be replaced with the command name
   tan -a bar -p 'Downloading file with <name> ' wget https://example.com/largefile.zip
   ```

3. **Customise Animation Frames**

   ```bash
   tan -f '⠁,⠂,⠄,⡀,⢀,⠠,⠐,⠈' -i 0.1 -- tar -czf archive.tar.gz /path/to/directory
   ```

### Command Output

Command output is sent to `<logs_directory>/<command_name>.log`.

## Creating a New Animation

The `animations` directory contains predefined animations but you can also create your own animations by following these steps:

1. ### Create a New Script File

   Create a new file in the animations directory ending with `.sh`. This will be the name of the animation i.e. `classic.sh` for an animation named `classic`.

   ```bash
   touch ~/.local/share/animations/classic.sh
   ```

2. ### Define the Animation Frames

   Inside the script, define an array named `__animations__frames` containing the animation frames. i.e

   ```bash
   # Name: classic
   __animations__frames=('-' '\' '|' '/')
   ```

3. ### Use the Animation

   Use the `-a` option with the animation name (excluding the `.sh`) to use your new animation i.e

   ```bash
   # exclude the .sh in the name
   tan -a classic sleep 5
   ```

## License

```txt
    Copyright (C) 2025  Jore

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
