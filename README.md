# Alfred the Dipping Bird
Alfred the Dipping Bird is a game being developed by UHS GDC. Please find designs [here](https://drive.google.com/drive/folders/1lnitsR1zWVWEHTpg9e8AgMcp_j1iRgpz)

The game is being developed for Windows, Mac, Linux, and Web using Godot 4.2.1

# Contributing
## Cloning and working with the repo
1. Clone the repo via the command line or GitHub Desktop
2. Import the project inside Godot
3. Start making changes
## Minigames
When working on a minigame, the root node of your minigame scene must have a script attached to it that *extends BaseMinigame*. In other words, your minigame should be a subclass of the BaseMinigame class.

Please also make separate folders for each minigame. So for the scripts and scenes you create for your minigame you would put them inside the scripts and scenes folder respectively inside another folder with the name of your minigame. Ex: All scenes for the midwest minigame will be inside scenes/midwest. The player.tscn for the midwest would be in the location scenes/midwest/player.tscn.
## Folder Structure
Please use the following folders to organize your script, scene, and other files. Files that are already outside the folders (Ex: icon.svg and README.md), should STAY outside of the folders.

- "assets" folder: for all art, sound, font, and other imported assets
- "scenes" folder: for all Godot scene files (.tscn) excluding test scenes
- "scripts" folder: for all GDScript files (.gd) excluding test scripts
- "tests" folder: for Godot scene and GDScript files that are simply for testing purposes

DO NOT reorganize or change the folder structure. Nick will do that. DO NOT rename the folders or change the capitalization. They are intended to be in all lowercase
## Style Guide
Please follow the [official GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) when working with the project whether that be files, scenes, scripts, or anything else.
