extends Node

const NULL_POS:Vector2 = -Vector2.INF

var _open_id:int = 0
var _component_store:Dictionary[GDScript, Dictionary] = {}
var _system_store:Dictionary[GDScript, BaseSystem] = {}

var BODY_LAYER:Node2D = null
var SPRITE_LAYER:Node2D = null

var delta:float = 0.0

func start(MAIN:Node)->void:
	_start_stores()
	
	BODY_LAYER = Node2D.new()
	BODY_LAYER.name = "BODY_LAYER"
	
	SPRITE_LAYER = Node2D.new()
	SPRITE_LAYER.name = "SPRITE_LAYER"
	SPRITE_LAYER.y_sort_enabled = true
	
	MAIN.add_child(BODY_LAYER)
	MAIN.add_child(SPRITE_LAYER)
func _start_stores()->void:
	for component_type:GDScript in BaseComponent.REGISTRY:
		_component_store[component_type] = {}
	for system_type:GDScript in BaseSystem.REGISTRY:
		_system_store[system_type] = system_type.new()
func end_session()->void:
	for component_type:GDScript in _component_store:
		for uid:int in _component_store[component_type]:
			_component_store[component_type][uid].destroy()
	_component_store.clear()
	_start_stores()
func process()->void:
	for system:BaseSystem in _system_store.values():
		system.process()
func spawn_entity()->int:
	_open_id += 1
	return _open_id -1
func destroy_entity(uid:int)->void:
	for component_type:GDScript in _component_store:
		var component:BaseComponent = get_component(uid, component_type)
		if component: component.destroy()
		_component_store[component_type].erase(uid)

func add_component(uid:int, component:BaseComponent)->BaseComponent:
	_component_store[component.get_script()][uid] = component
	return get_component(uid, component.get_script())
func get_component(uid:int, component_type:GDScript)->BaseComponent:
	return _component_store[component_type].get(uid)
func get_all_components_of(component_type:GDScript)->Array[BaseComponent]:
	return _component_store[component_type].values()
func get_system(system_type:GDScript)->BaseSystem:
	return _system_store.get(system_type)
