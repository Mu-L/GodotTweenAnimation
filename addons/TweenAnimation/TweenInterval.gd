@tool
class_name TweenInterval extends TweenAnimation
@export var time: float

func create_tweenr(root_tween: Tween, is_play_back: bool = false):
	root_tween.tween_interval(time)
	super.create_tweenr(root_tween, is_play_back)
