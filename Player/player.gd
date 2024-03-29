extends CharacterBody2D


signal hit_player
signal hit


@export var player_type = "player1"
@export var bullet: PackedScene
@export var black_hole: StaticBody2D
@export var game: Node2D

var direction = Vector2.ZERO
var speed = 200
var rotation_speed = deg_to_rad(150)
var gravity_speed = 50
var accel = 2
var screen_size
var player_size = 16.0
var bullet_limit = 5
var black_hole_pos


func _ready():
	screen_size = get_viewport().size
	if black_hole != null:
		black_hole_pos = black_hole.position


func _physics_process(delta):
	if !$AnimatedSprite2D.is_playing() && player_type == "player1":
		$AnimatedSprite2D.play("idle1")
	if !$AnimatedSprite2D.is_playing() && player_type == "player2":
		$AnimatedSprite2D.play("idle2")
	
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("thrust_forward") && player_type == "player1":
		direction = Vector2(cos(rotation), sin(rotation))
		$AnimatedSprite2D.play("thrust_forward1")
	if Input.is_action_pressed("rotate_left") && player_type == "player1":
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("rotate_right") && player_type == "player1":
		rotation += rotation_speed * delta
	if Input.is_action_just_pressed("shoot") && player_type == "player1":
		shoot()
	
	if Input.is_action_pressed("thrust_forward2") && player_type == "player2":
		direction = Vector2(cos(rotation), sin(rotation))
		$AnimatedSprite2D.play("thrust_forward2")
	if Input.is_action_pressed("rotate_left2") && player_type == "player2":
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("rotate_right2") && player_type == "player2":
		rotation += rotation_speed * delta
	if Input.is_action_just_pressed("shoot2") && player_type == "player2":
		shoot()
	
	if Input.is_action_just_released("thrust_forward") || Input.is_action_just_released("thrust_forward2"):
		$AnimatedSprite2D.stop()
	
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("Player"):
			queue_free()
			hit_player.emit()
	
	if black_hole != null:
		var gravity = position.direction_to(black_hole_pos) * gravity_speed
		var gravity_collision = move_and_collide(gravity * delta)
		if gravity_collision:
			if gravity_collision.get_collider() == black_hole:
				queue_free()
				hit.emit()


func _on_visible_on_screen_notifier_2d_screen_exited():
	screen_size = get_viewport().size
	if position.x > screen_size.x:
		position.x = position.x - screen_size.x - player_size / 2
	if position.x < 0:
		position.x = position.x + screen_size.x + player_size / 2
	if position.y > screen_size.y:
		position.y = position.y - screen_size.y - player_size / 2
	if position.y < 0:
		position.y = position.y + screen_size.y + player_size / 2


func shoot():
	# TODO: create a bullet delay
	var b = bullet.instantiate()
	b.start(global_position + Vector2(30, 0).rotated(rotation), rotation, player_type)
	if game != null:
		game.add_child(b)
	else:
		get_tree().root.add_child(b)


func on_hit():
	queue_free()
