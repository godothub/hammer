extends CharacterBody3D
class_name Character
## 专门用于游戏内角色的节点。

@export var head_node:Node3D



signal health_updated_signal ## 健康状态更新

@export_group("health", "health_")
## 当前健康值。
@export var health_value:float = 100:
    set(_health_value):
        _health_value = clamp(_health_value, health_range.x, health_range.y)
        if health_value != _health_value:
            health_value = _health_value
            update_health()
## 健康值范围。
@export var health_range:Vector2 = Vector2(0, 100):
    set(_health_range):
        if health_range != _health_range and _health_range.x < _health_range.y:
            health_range = _health_range
            update_health()
## 用于展示血量的控件。
@export_node_path("Range") var health_range_control:NodePath:
    set(_health_range_control):
        if health_range_control != _health_range_control:
            health_range_control = _health_range_control
            update_health()
        if not ready.is_connected(update_health):
            ready.connect(update_health)     
## 用于更新血量的内部函数。
func update_health() -> void:
    if has_node(health_range_control):
        var range:Range = get_node(health_range_control)
        range.min_value = health_range.x
        range.max_value = health_range.y
        range.value = health_value


signal tool_current_updated_signal ## 当前工具更新。
## 当前使用工具的索引。当值为-1时，将停用所有工具。
@export var tool_current:int = -1:
    set(_tool_current):
        _tool_current = clamp(_tool_current, -1, tool_list.size() - 1)
        if tool_current != _tool_current:
            if _tool_current != -1:
                tool_list[_tool_current].enable = false
            if tool_current != -1:
                tool_list[tool_current].enable = true
            tool_current = _tool_current
            tool_current_updated_signal.emit()
@export_group("tool", "tool_")
## 工具列表。
@export var tool_list:Array[Tool]:
    set(_tool_list):
        if tool_list != _tool_list:
            tool_list = _tool_list
            tool_current = clamp(tool_current, -1, tool_list.size() - 1)
## 工具检测射线。
@export var tool_ray_cast:RayCast3D
## 添加工具。
func append_tool(_tool:Tool) -> void:
    if not tool_list.has(_tool):
        tool_list.append(_tool)
## 移除工具。
func remove_tool(_index:int) -> void:
    tool_list.pop_at(_index)


@export_group("action", "action_")
## 当前动作。当动作变更时，会播放 action_player 中与 action_current 字符相同的动画，并使用 action_property_table 为当前Character 的属性赋值。
@export var action_current:StringName:
    set(_action_current):
        if action_current != _action_current:
            action_current = _action_current
            update_action()
## 动作动画。
@export_node_path("AnimationPlayer") var action_animation_player:NodePath:
    set(_action_animation_player):
        if action_animation_player != action_animation_player:
            action_animation_player = _action_animation_player
            update_action()
        if ready.is_connected(update_action):
            ready.connect(update_action)
 ## 动作属性表。
@export var action_property_table:Dictionary[StringName, Dictionary]:
    set(_action_property_table):
        if action_property_table != _action_property_table:
            action_property_table = _action_property_table
            update_action()
## 更新动作。
func update_action() -> void:
    if has_node(action_animation_player):
        get_node(action_animation_player).play(action_current)
    if action_property_table.has(action_current):
        var property_table:Dictionary = action_property_table[action_current]
        for property:StringName in property_table:
            set(property, property_table[property])