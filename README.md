# CGLF — Custom Global Light Function

A Godot Editor plugin that allows you to **define and manage a single global `light()` function** shared across all or chosen shaders in your project.

## Features
- Define a **global `light()` function** once and reuse it everywhere.
- Easily managed through the plugin dock.
- Optionally replace existing `light()` functions automatically.
- Blacklist for shader files not meant to be affected by CGLF.

## Installation

### A — Asset Library

1. Add the plugin to your project via the Asset Library.
2. In Godot, go to **Project → Project Settings → Plugins** and enable **CGLF — Custom Global Light Function**.

### B — Repository

1. Download or clone this repository.
2. Copy the `addons/custom_global_light_function` folder into your Godot project.
3. In Godot, go to **Project → Project Settings → Plugins** and enable **CGLF — Custom Global Light Function**.

## Usage
1. Find the plugin dock on Godot's right dock.
2. Usage:
   	- **Include File Path** → Path to your shared `.gdshaderinc` file containing the global `light()` function. Or leave the default .gdshaderinc file.
	- **Open File Path** → Open the `.gdshaderinc` file containing the global `light()` function to edit.
	- **Copy File Path** → Copies the `.gdshaderinc` file path to clipboard.
	- **Copy Injection Code** → Copies include boiler plate to clipboard for manually addition.
	- **Update Shaders** → Updates all shaders with CGLF's current settings.
   	- **Ignore Blacklist** → Whether shaders in the blacklist should still use the global light.
   	- **Replace Existing Light Functions** → Automatically replaces `light()` functions already present in shaders.
   	- **Blacklist** → List of shaders to exclude.