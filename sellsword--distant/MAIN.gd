extends Node

@export var iphrit:SpriteFrames

func _ready()->void:
	World.start(self)
	
	var test_entity:int = World.spawn_entity()
	
	var movement_component:MovementComponent = MovementComponent.new(test_entity)
	movement_component.configure(MovementConfiguration.new(Vector2(40, 12) * 16))
	var visual_component:VisualComponent = VisualComponent.new(test_entity)
	visual_component.configure(VisualConfiguration.new(iphrit))
	
	World.add_component(test_entity, movement_component)
	World.add_component(test_entity, visual_component)

func _process(delta:float)->void:
	World.process()
	World.delta = delta
