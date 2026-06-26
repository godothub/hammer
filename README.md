# Hammer

Enable developers to focus on 3D game development, making Godot as simple as Hammer Editor.

[English](https://github.com/godothub/hammer)
&nbsp;&nbsp;&nbsp;&nbsp;
[中文](https://github.com/godothub/hammer/blob/master/README.ZH.md)    

> The frequency of English updates may be slightly slower than that of Chinese.

Hammer is developed based on the idea of separating `service`, `data`, and `control`. Upon startup, scripts or scenes with `service` functions are loaded through the engine's automatic loading feature. These services will be initialized through `data` in project settings and custom scripts, and will be `controlled` by game scripts or the user interface during runtime.

## BasicServices

> Note: The main game scene is also classified as part of the service. Therefore, in the design of this framework, nodes within the main scene should focus on game interaction or perform simple management of the service.
### Archive Manager

The archive manager is used to manage data that needs to be stored in the game.

### Game Settings

Game settings are used to manage data that does not change with the game.

### User Interface

The user interface belongs to both the user and the control and service, and is the main way for the user to interact with the service.

## Game Features

### Facility

The activation status of a facility depends on its dependent facilities, and each facility can become a dependent facility of other facilities. When all the dependent facilities of a certain facility are in the active state, the facility will be in the enable state.
