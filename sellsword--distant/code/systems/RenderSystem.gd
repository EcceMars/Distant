class_name RenderSystem
extends BaseSystem

func process()->void:
	for visual:VisualComponent in World.get_all_components_of(VisualComponent):
		visual.update()
