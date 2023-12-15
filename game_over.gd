extends Control

func _ready():
	%animation_player.play("game_over")

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		Global.fire_show_title_screen()
