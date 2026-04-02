class_name MovementComponent
extends BaseComponent

## Volume/size of the entity. An entity can be big, yet light, and easy to push, or vice-and-versa.
enum Volume {
	TINY = 1,		## Insects, items etc.
	NORMAL = 2,		## Most entities.				TEST: the tested CapsuleShape2D that matches a normal sized entity (and its sprite) is radius = 4.0, height = 16.0 and position.y = 8.0
	LARGE = 3,		## Horses and biggers beasts.
	GIANT = 4		## Greate beasts, dragons etc.
	}
## Current movement layer mask an entity is occuping. It is important to remember that an entity may shift its layer through special skills (swiming, fly, landing, digging).
enum Layer {
	SURFACE = 1,		## Grounded entity (either on ground or water surface).
	FLY = 2,			## Flying entity.
	UNDER = 4,		## Underwater or ground entity (e.g. fishes or moles).
	PHASE = 8		## Phasing entities only collide with other phasers, avoiding entity stacking.
	}

var _body_ref:WeakRef = null
var _collider_ref:WeakRef = null

var body:CharacterBody2D:
	get:
		if _body_ref: return _body_ref.get_ref()
		return null
var collider:CollisionShape2D:
	get:
		return _collider_ref.get_ref()

# TASK: temporary
var strength:float = 1.0

var position:Vector2:
	set(value):
		if body: body.global_position = value
	get:
		if body: return body.global_position
		return World.NULL_POS
var velocity:Vector2:
	set(value):
		if body: body.velocity = value
	get:
		if body: return body.velocity
		return Vector2.ZERO
var facing:Vector2i = Vector2i.DOWN:
	set(value):
		facing = set_facing(value)
var volume:Volume = Volume.NORMAL
var movement_layer:Layer = Layer.SURFACE
var is_static:bool = false

func _init(id:int)->void:
	super(id)
func configure(configuration:BaseConfiguration)->BaseComponent:
	if not configuration is MovementConfiguration:
		push_warning("A %s object was fed to a %s." % [str(configuration), str(self)])
		return null
	var config:MovementConfiguration = configuration as MovementConfiguration

	volume = config.volume
	movement_layer = config.movement_layer
	is_static = config.is_static
	strength = config.strength
	
	_build_body(config)
	
	return self
func _build_body(configuration:MovementConfiguration)->void:
	var _body:CharacterBody2D = CharacterBody2D.new()
	_body.name = "%03d_BODY" % uid
	
	var _collider:CollisionShape2D = CollisionShape2D.new()
	_collider.name = "SHAPE"
	_collider.debug_color = Color.RED if is_static else Color.AQUA
	
	var shape:CapsuleShape2D = CapsuleShape2D.new()
	shape.radius = configuration.CAPSULE_DATA[volume][0]
	shape.height = configuration.CAPSULE_DATA[volume][1]
	
	_collider.shape = shape
	
	_body.add_child(_collider)
	_collider.position.y = configuration.CAPSULE_DATA[volume][2]
	
	World.BODY_LAYER.add_child(_body)
	
	_body.position = configuration.start_position
	
	_body_ref = weakref(_body)
	_collider_ref = weakref(_collider)
func set_facing(direction:Vector2)->Vector2i:
	if direction == Vector2.ZERO: return facing
	var normal_dir:Vector2 = direction.normalized()
	if abs(normal_dir.x) >= abs(normal_dir.y):
		return Vector2i(sign(normal_dir.x), 0)
	else:
		return Vector2i(0, sign(normal_dir.y))
func update()->void:
	position = position + velocity
