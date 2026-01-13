@tool
class_name TweenShake extends TweenAnimation

@export var node: Node:
	get():
		if not node:
			var parent = get_parent()
			while parent is TweenAnimation:
				parent = parent.get_parent()
			node = parent
		return node

@export var property: String = "scale"

@export_tool_button("Select Property") var select_property := func():
	if Engine.is_editor_hint():
		popup_property_selector.node = node
		popup_property_selector.callback = func(property_path):
			if property_path:
				property = property_path
				base_value = node.get_indexed(property)
				offset = node.get_indexed(property)
				notify_property_list_changed()
		popup_property_selector.run()

@export var base_value: Variant

@export var offset: Variant

@export var duration: float = 0.3

@export var playback_duration: float = 0.2

@export var frequency: float = 20.0

@export var curve: Curve

func _create_tweenr(tween: Tween):
	var delta := 1 / frequency
	var time := duration if not is_playback else playback_duration
	var cur_time := minf(delta, time)
	var subtween := create_tween()
	while cur_time < time:
		var scale := 1.0 if not curve else curve.sample(cur_time / time)
		if offset is float:
			subtween.tween_property(node, property, base_value + randf_range(-1, 1) * offset * scale, delta)
		if offset is Vector2:
			subtween.tween_property(node, property, base_value + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * offset * scale, delta)
		if offset is Vector3:
			subtween.tween_property(node, property, base_value + Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * offset * scale, delta)
		cur_time += delta
	subtween.tween_property(node, property, base_value, time - cur_time)
	tween.tween_subtween(subtween)
	super._create_tweenr(tween)
