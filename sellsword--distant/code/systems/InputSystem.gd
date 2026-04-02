class_name InputSystem
extends BaseSystem

var one_shot:StringName = &''
var facing:Vector2i = Vector2i.DOWN
var input_dir:Vector2 = Vector2.ZERO
var input_frame:float = 0.0
var input_frame_len:float = 0.2
var velocity:Vector2 = Vector2.ZERO

var input_timer:float = 0.0

func process()->void:
	if input_timer > 0.0:
		input_timer -= World.delta
		return
	if Input.is_action_just_released("jump"):
		one_shot = &'jump'
		input_timer = 1.2
		return
	if Input.is_action_just_released("attack"):
		one_shot = &'attack0%d' % [0, 1, 2, 3, 4].pick_random()
		velocity = Vector2.ZERO
		input_timer = 0.2
		return
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_dir:
		if abs(input_dir.x) >= abs(input_dir.y):
			facing = Vector2i.LEFT if input_dir.x < 0 else Vector2i.RIGHT
		else:
			facing = Vector2i.UP if input_dir.y < 0 else Vector2i.DOWN
		input_frame += World.delta
	else:
		input_frame = 0.0
		velocity = velocity.move_toward(Vector2.ZERO, 0.5)
		if velocity.is_zero_approx():
			velocity = Vector2.ZERO
	if input_frame > input_frame_len and input_dir != Vector2.ZERO:
		velocity = input_dir
