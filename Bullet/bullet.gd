extends RigidBody2D

var speed = 400
var direction


func _ready():
	call_deferred("set_multiplayer_authority", 1, true)


func _physics_process(delta):
	direction = Vector2(cos(rotation), sin(rotation))
	var velocity = direction * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision && collision.get_collider().is_in_group("Player"):
		var player = collision.get_collider()
		player.hit.emit()
		player.queue_free()
		queue_free()
	elif collision:
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


func start(_position, _rotation, player_type):
	position = _position
	rotation = _rotation
	
	if player_type == "player1":
		$AnimatedSprite2D.play("bullet1")
	if player_type == "player2":
		$AnimatedSprite2D.play("bullet2")


func _on_timer_timeout():
	queue_free()


func _on_game_reset():
	queue_free()
