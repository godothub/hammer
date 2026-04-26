# Hammer

Enable developers to focus on 3D game development, making Godot as simple as Hammer Editor.

[English](https://github.com/godothub/hammer)
&nbsp;&nbsp;&nbsp;&nbsp;
[中文](https://github.com/godothub/hammer/blob/master/README.ZH.md)    

> The frequency of English updates may be slightly slower than that of Chinese.

## Features

### Framework

#### Main Menu

The Main Menu is the only menu in the game and serves as the core method for players to control the game. You can find "Set as Main Menu" by right-clicking a packed scene file (*.tscn) in the file menu. This will globally autoload and call it under the name "Menu".

#### Archive

Archive is the primary method for storing game data. By accessing the Archive, you can register a property list for specified nodes and apply the archive data to the corresponding registered nodes.

### Game

#### Facility

Facility is the basic type for all detection and actions within the game. It determines its own activation (enable) by checking the active state of dependent facilities (depend_facility_list). When activated, it can also determine its own active state.

## Technical Route

Hammer is an extension plugin for Godot, dedicated to using Godot's existing features to implement a game development framework.

Therefore, most behaviors of Hammer will be attached to Godot's functionality. New concepts will only be introduced in the event of a severe lack of required features in the engine.