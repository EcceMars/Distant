class_name BaseComponent
extends RefCounted

static var REGISTRY:Array[GDScript] = [
	MovementComponent,
	VisualComponent
	]

var movement:MovementComponent:
	get: return World.get_component(uid, MovementComponent)
var visual:VisualComponent:
	get: return World.get_component(uid, VisualComponent)

var uid:int = -1

func _init(id:int)->void: uid = id
## Should be called after the component is added.
func configure(_configuration:BaseConfiguration)->BaseComponent: return self
func update()->void: pass
func destroy()->void: pass
func _to_string()->String: return get_script().get_global_name()
