# Hammer
使Godot像Hammer编辑器一样简单易用，让开发者专注于3D游戏内容开发。

[English](https://github.com/godothub/hammer)
&nbsp;&nbsp;&nbsp;&nbsp;
[中文](https://github.com/godothub/hammer/blob/master/README.ZH.md)  

## 特点

### 框架

#### 主菜单(MainMenu)
主菜单是游戏中的唯一菜单，是玩家对游戏进行控制的核心手段。你可以在文件菜单中，对打包场景文件(*.tscn)右键找到“设置为主菜单”，这会以Menu为名称被全局自动加载和调用。

#### 存档(Archive)
存档是存储游戏数据的主要手段，通过访问存档(Archive)可对指定节点注册属性列表(property_list)，并可以将存档数据应用到已注册的对应节点上。


### 游戏

#### 设施(Facility)
设施是游戏内所有检测和行动的基本类型，通过依赖设备(depend_facility_list)的活跃状态(active)判断自身是否被激活(enable)，在激活时也可以决定自身活跃状态。

## 技术路线
Hammer是Godot的一个扩展插件，致力于使用Godot提供的现有功能，实现一个游戏开发框架。
因此Hammer的多数行为都将依附于Godot的功能，只有在引擎存在严重的需求功能缺失的情况下才会引入新概念。
