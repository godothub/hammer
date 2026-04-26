@tool
@abstract
extends Facility
class_name FacilityInteract
## 可交互设施，用于

## 交互代理物体
@export var interact_proxy:CollisionObject3D:
	set(_interact_proxy):
		interact_proxy = _interact_proxy
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var waring:PackedStringArray
	if interact_proxy:
		if interact_proxy.get_parent() != self:
			waring.append("interact_proxy 必须是当前节点的子节点")
	else:
		waring.append("interact_proxy 不应为空")
	return waring

@abstract func interact() -> void
