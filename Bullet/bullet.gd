extends RigidBody2D

var speed = 400
var direction

func _physics_process(delta):
	direction = Vector2(cos(rotation), sin(rotation))
	var velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		collision.get_collider().queue_free()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	var screen_size = get_viewport().size
	
	if position.x > screen_size.x:
		position.x = position.x - screen_size.x
	if position.x < 0:
		position.x = position.x + screen_size.x
	if position.y > screen_size.y:
		position.y = position.y - screen_size.y
	if position.y < 0:
		position.y = position.y + screen_size.y


func start(_position, _rotation):
	position = _position
	rotation = _rotation


func _on_timer_timeout():
	queue_free()
