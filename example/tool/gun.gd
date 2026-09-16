extends Tool
class_name ToolGun
## 发射器类工具。

@export_group("shoot", "shoot_")
enum ShootMode {
    SINGLE, ## 单发模式
    AUTOMATIC, ## 全自动模式
    CHARGING ## 蓄力模式
}
@export var shoot_mode:ShootMode = ShootMode.SINGLE ## 射击模式
@export var shoot_interval_time:float = 0.1 ## 射击间隔时间。

@export_group("bullet", "bullet_")
@export var bullet_resource:PackedScene ## 子弹模型。
@export var bullet_marker:Node3D ## 子弹创建时的空间信息。
@export var bullet_property_list:Dictionary[StringName, Variant] ## 子弹参数信息传递。

@export_group("magazine", "magazine_")
@export var magazine_remaining:int = 10 ## 弹匣剩下的子弹数量。
@export var magazine_capabily:int = 20 ## 弹匣最大容量。
@export var magazine_reload_time:float = 1 ## 换弹时间。

var shoot_interval_record:float = 0 ## 间隔时间记录。
var magazine_reload_record:float = 0 ## 换弹时间记录。

## 判断是否可以射击。
func can_shoot() -> bool:
    ##　判断资源是否存在。
    if not bullet_resource or not bullet_marker:
        return false
    ## 在射击间隔时间内。
    if shoot_interval_time > 0 and shoot_interval_time > shoot_interval_record:
        return false
    ##　弹药数量检查。
    if magazine_remaining < 1:
        return false
    return true

## 实际发射函数。
func shoot() -> void:
    var bullet:Node3D = bullet_resource.instantiate()
    bullet.top_level = true
    bullet.global_transform = bullet_marker.global_transform

    for property:StringName in bullet_property_list:
        bullet.set(property, bullet_property_list[property])

    add_child(bullet)
    
        
## 扣下扳机时。
func pulled_trigger() -> void:
    match shoot_mode:
        ShootMode.SINGLE:
            if can_shoot():
                shoot()
                shoot_interval_record = 0

## 按住扳机。
func pulling_trigger(_delta:float) -> void:
    match shoot_mode:
        ShootMode.AUTOMATIC:
            if can_shoot():
                shoot()
                shoot_interval_record = 0
        ShootMode.CHARGING:
                shoot_interval_record += _delta

## 松开扳机时。
func released_trigger() -> void:
    match shoot_mode:
        ShootMode.CHARGING:
            if can_shoot():
                shoot()
    shoot_interval_record = 0

        

## 换弹。
func reload() -> void:
    if magazine_remaining != magazine_capabily:
        magazine_remaining = magazine_capabily

func _enable() -> void:
    show()
    magazine_reload_record = 0
    shoot_interval_record = shoot_interval_time

func _disable() -> void:
    hide()
    shoot_interval_record = 0

func _physics_process(_delta: float) -> void:
    if enable:
        if shoot_mode != ShootMode.CHARGING:
            shoot_interval_record += _delta
