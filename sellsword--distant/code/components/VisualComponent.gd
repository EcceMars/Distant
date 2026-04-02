class_name VisualComponent
extends BaseComponent

var _sprite_ref:WeakRef = null
var _base_offset:Vector2 = Vector2.ZERO
var _default_anim:StringName = VisualConfiguration.DEFAULT_ANIMATION

var _queue:Array[AniKey] = []

var current:AniKey:
	get:
		if not _queue: _queue = [AniKey.new()]
		return _queue.front()
var sprite:AnimatedSprite2D:
	get:
		if _sprite_ref == null: return null
		return _sprite_ref.get_ref()
var offset:Vector2:
	get:
		if not sprite: return Vector2.ZERO
		return sprite.offset
	set(value):
		if sprite: sprite.offset = value

#region Initialization
func configure(configuration:BaseConfiguration)->BaseComponent:
	if not configuration is VisualConfiguration:
		push_warning("A %s object was fed to a %s." % [str(configuration), str(self)])
		return null
	var config:VisualConfiguration = configuration as VisualConfiguration
	
	if config.sprite_frames == null:
		push_warning("A %s object was fed to a %s with no sprite frames set." % [str(configuration), str(self)])
		return null
	
	_base_offset = config.base_offset
	_default_anim = config.default_animation
	
	_build_sprite(config)
	return self
func _build_sprite(configuration:VisualConfiguration)->void:
	var _sprite:AnimatedSprite2D = AnimatedSprite2D.new()
	_sprite.name = "%03d_SPRITE" % uid
	_sprite.sprite_frames = configuration.sprite_frames
	_sprite.centered = true
	_sprite.offset = configuration.base_offset
	_sprite.z_index = configuration.z_index
	
	World.SPRITE_LAYER.add_child(_sprite)
	_sprite_ref = weakref(_sprite)
#endregion

func play(key:StringName)->void:
	var new_key:StringName = _prepare_animation(key)
	if sprite.animation == new_key: return
	
	sprite.play(new_key)
func change_animation(key:StringName = _default_anim)->void:
	var new_key:StringName = _prepare_animation(key)
	if new_key == &'NONE':
		push_warning("%s was attempted as a key at a change_animation." % key)
		return
	
	if sprite and sprite.sprite_frames.has_animation(new_key):
		if sprite.animation == new_key: return
		
		var timer:int = sprite.sprite_frames.get_frame_count(sprite.animation) - sprite.frame
		var new_animation:AniKey = AniKey.new(key, timer)
		_queue += [new_animation]
func force_animation(key:StringName, one_shot:bool = false, duration:int = 20)->void:
	var IN_SYS:InputSystem = World.get_system(InputSystem)
	duration = int(IN_SYS.input_timer * 100)
	var new_key:StringName = _prepare_animation(key)
	if new_key == &'NONE':
		push_warning("%s was attempted as a key at a force_animation." % key)
		return

	if sprite and sprite.sprite_frames.has_animation(new_key):
		if sprite.animation == new_key: return
		
		_queue.clear()
		if one_shot:
			_queue = [AniKey.new(key, duration)]
		else:
			_queue = [AniKey.new(key)]
func update()->void:
	if not sprite: return
	
	if current.timer > 0:
		current.timer -= 1
	
	if current.timer <= 0 and _queue.size() > 1:
		_queue.pop_front()
	
	var m:MovementComponent = _query_movement()
	if m:
		sprite.global_position = m.position
		if m.velocity:
			force_animation(&'move')
		else:
			change_animation(_default_anim)
	play(current.key)
func destroy()->void:
	if not sprite:
		super.destroy()
		return
	
	var key:StringName = &'death'
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(key):
		sprite.animation_finished.connect(sprite.queue_free)
		sprite.play(key)
	else:
		sprite.queue_free()
	_sprite_ref = null
	super.destroy()
func reset_offset()->void:
	offset = _base_offset

func _prepare_animation(key:StringName)->StringName:
	var _movement:MovementComponent = _query_movement()
	if not _movement: return _default_anim
	
	return key + VisualConfiguration.DIRECTION_SUFFIX[_movement.facing]
var _cached_movement:WeakRef = null
func _query_movement()->MovementComponent:
	if not _cached_movement:
		var m:MovementComponent = movement
		if not m:
			return null
		_cached_movement = weakref(m)
	return _cached_movement.get_ref()

## Simple animation data class. A [AniKey] with a negative [member timer] will loop.
class AniKey extends RefCounted:
	var key:StringName = VisualConfiguration.DEFAULT_ANIMATION
	var timer:int = -1
	func _init(_key:StringName = key, _timer:int = timer)->void:
		key = _key
		timer = _timer
	func _to_string()->String:
		return "AnimationKey: %s with a duration of %d frames." % [key, timer]
