extends Node

var tween:TweenAnimation:
	get():
		return get_child(0)

func _ready():
	while true:
		await tween.play_test_button.call()
		await get_tree().create_timer(0.5).timeout