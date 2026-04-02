class_name MovementSystem
extends BaseSystem

func process()->void:
	for movement:MovementComponent in World.get_all_components_of(MovementComponent):
		movement.facing = IN_SYS.facing
		if IN_SYS.one_shot != &'' and movement.visual:
			movement.visual.force_animation(IN_SYS.one_shot, true)
			IN_SYS.one_shot = &''
		if IN_SYS.velocity:
			movement.velocity = IN_SYS.velocity
		else:
			movement.velocity = Vector2.ZERO
		movement.update()
