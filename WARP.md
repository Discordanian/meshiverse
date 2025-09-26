# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

Meshiverse is a 3D model library organizer built with Godot 4.5. It's designed to make managing 3D models easier by providing a GUI application for organizing model collections in "vaults" (directories with configuration files).

## Development Commands

### Running the Application
```bash
# Run the development version (opens Godot editor)
./dev.sh

# Alternative: Direct Godot command
"/Applications/Godot v4.5.app/Contents/MacOS/Godot" godot/project.godot
```

### Version Control
```bash
# Quick save script (commits and pushes changes)
./save.sh

# Manual git workflow
git add godot
git commit -m "Your commit message"
git push
```

## Architecture Overview

### Project Structure
- **`godot/`** - Main Godot project directory
  - **`scenes/`** - UI scene files (.tscn)
  - **`scripts/`** - GDScript files (.gd)
  - **`resources/`** - Custom resource classes
  - **`singletons/`** - Autoloaded global scripts
  - **`assets/`** - Images, textures, and other assets
  - **`themes/`** - UI themes

### Key Components

#### Configuration System
- **ConfigFileHandler** (singleton) - Manages global settings and vault configurations
- Global config stored at `user://settings.cfg`
- Vault-specific config stored as `meshiverse.cfg` in each vault directory
- Handles vault directory selection and validation

#### Data Architecture
- **DataFrame** - Custom resource class for tabular data representation
- Supports sorting, row access, and string representation
- Used for displaying model collections in table format

#### UI Architecture
- **Settings Scene** (`scenes/settings.tscn`) - Main entry point with vault selection
- **Table Component** - Dynamic table rendering system using scene instantiation
- **ModelRecord** - Individual model display component
- Uses Godot's built-in theming system

### Core Concepts

#### Vaults
A "vault" is a directory containing 3D models with a `meshiverse.cfg` configuration file. Users can create new vaults or open existing ones through the settings interface.

#### Scene Organization
- Main scene: `scenes/settings.tscn` (application entry point)
- Modular UI components using PackedScene instantiation
- TableRow/TableCell system for dynamic content display

## Development Patterns

### GDScript Conventions
- Strict typing enabled (`untyped_declaration=2`, `inferred_declaration=1`)
- Class names defined with `class_name` keyword for custom resources
- Export variables used for editor-configurable properties
- Autoload singletons for global state management

### File Organization
- Scripts mirror scene structure in naming
- Resources directory for reusable data structures
- Singletons directory for globally accessible managers

### Configuration Management
- ConfigFile class used for persistent settings
- Vault discovery through filesystem dialogs
- Version tracking in configuration files

## Technical Notes

- Built for Godot 4.5 with Forward Plus rendering
- Uses GL compatibility rendering for broader hardware support
- Native file dialogs enabled for better OS integration
- Low processor mode enabled for battery efficiency