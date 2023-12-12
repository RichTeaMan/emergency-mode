@tool
extends Node2D

@export_range(1, 512, 1) var size_x: float = 64

@export_range(1, 512, 1) var size_y: int = 64

# Called when the node enters the scene tree for the first time.
func _ready():
	%collision.shape.size.x = size_x
	%collision.shape.size.y = size_y
	
	%colour.set_size(Vector2(size_x, size_y))
	
	# these don't exactly line up, but seems good enough
	%colour.position.x = size_x / -2
	%colour.position.y = size_y / -2

func _process(_delta):
	if Engine.is_editor_hint():
		_ready()


func _on_area_2d_body_entered(body):
	if body.name == 'car':
		print("DESTINATION!!!")
		Global.fire_destination_hit()
