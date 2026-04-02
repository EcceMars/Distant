class_name VisualConfiguration
extends BaseConfiguration

const DEFAULT_ANIMATION:StringName = &'idle'

const DIRECTION_SUFFIX:Dictionary[Vector2i, StringName] = {
	Vector2i.RIGHT: &'_right',
	Vector2i.LEFT: &'_left',
	Vector2i.UP: &'_up',
	Vector2i.DOWN: &'_down'
	}
var sprite_frames:SpriteFrames = null
var base_offset:Vector2 = Vector2.ZERO
var default_animation:StringName = DEFAULT_ANIMATION
var z_index:int = 0

func _init(_sprite_frames:SpriteFrames, _offset:Vector2 = base_offset, _default_animation:StringName = default_animation, _z_index:int = z_index)->void:
	sprite_frames = _sprite_frames
	base_offset = _offset
	default_animation = _default_animation
	z_index = _z_index
