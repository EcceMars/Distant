class_name MovementConfiguration
extends BaseConfiguration

const Layer = MovementComponent.Layer
const Volume = MovementComponent.Volume

## The values here are arrenged as radius, height and y_offset. Keep in mind that all sprites are designed to be 32x32 normally.
const CAPSULE_DATA:Dictionary[Volume, Array] = {
	Volume.TINY:		[2.0, 8.0, 4.0],
	Volume.NORMAL:	[4.0, 16.0, 8.0],
	Volume.LARGE:	[7.0, 28.0, 14.0],
	Volume.GIANT:	[12.0, 48.0, 24.0]
	}

var start_position:Vector2 = Vector2.ZERO
var movement_layer:Layer = Layer.SURFACE
var volume:Volume = Volume.NORMAL
var is_static:bool = false
var strength:float = 1.0

func _init(_start_position:Vector2 = start_position, _layer:Layer = movement_layer, _size:Volume = volume, _is_static:bool = is_static, _strength:float = strength)->void:
	start_position = _start_position
	movement_layer = _layer
	volume = _size
	is_static = _is_static
	strength = _strength
