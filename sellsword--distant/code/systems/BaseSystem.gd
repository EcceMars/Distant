class_name BaseSystem
extends Object

static var REGISTRY:Array[GDScript] = [
	InputSystem,
	MovementSystem,
	RenderSystem,
	]

static var IN_SYS:InputSystem:
	get: return World.get_system(InputSystem)
static var MOV_SYS:MovementSystem:
	get: return World.get_system(MovementSystem)
static var REND_SYS:RenderSystem:
	get: return World.get_system(RenderSystem)

func process()->void: pass
func _to_string()->String: return get_script().get_global_name()
