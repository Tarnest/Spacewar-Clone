extends StaticBody2D


func _ready():
	var screen_size = get_viewport().size
	position = Vector2(screen_size / 2)
