@tool
@icon("res://addons/TweenAnimation/icon.png")
class_name TweenAnimation extends Node

@export var node: Node:
	get():
		if not node:
			var parent = get_parent()
			if parent:
				if parent is TweenAnimation:
					node = parent.node
				else: node = parent
		return node

@export_tool_button("Play Test") var play_button := func():
	await play().finished
	await get_tree().create_timer(1).timeout
	await playback()

@export_group("Child Tween")
@export var is_parallel: bool

var tween: Tween

func _process(delta):
	if Engine.is_editor_hint():
		if tween and tween.is_running():
			tween.custom_step(delta)

func play() -> Tween:
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween()
	create_tweenr(tween)
	return tween

func playback():
	if tween and tween.is_running():
		tween.stop()
	tween = create_tween()
	create_tweenr(tween, true)
	return tween

func create_tweenr(root_tween: Tween, is_play_back: bool = false):
	for index in get_child_count():
		var child: TweenAnimation = get_child(index)
		child.create_tweenr(root_tween, is_play_back)
		if index == 0:
			if is_parallel:
				root_tween = root_tween.parallel()
			else:
				root_tween = root_tween.chain()

func _to_string():
	return "TweenAnimation"
