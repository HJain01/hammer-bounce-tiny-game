extends CharacterBody2D

signal OnUpdateHealth(health: int)
signal OnUpdateScore(score: int)

@onready var sprite: Sprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer
@onready var hammer: Area2D = $Hammer

var take_damage_sfx: AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx: AudioStream = preload("res://Audio/coin.wav")

@export var move_speed: float = 100
@export var acceleration: float = 50
@export var braking: float = 20
@export var gravity: float = 500
@export var jump_force: float = 200
@export var bounce_force: float = 1.5

@export var health: int = 3

var move_input: float

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	handle_movement_input(delta)
	handle_bounce(delta)
	move_and_slide()

func _process(_delta):
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	manage_animation()

	if global_position.y > 200:
		game_over()

func handle_movement_input(delta):
	move_input = Input.get_axis("move_left", "move_right")

	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= jump_force

func handle_bounce(delta):
	if Input.is_action_just_pressed("strike"):
		pass

func manage_animation():
	if not is_on_floor():
		animation.play("jump")
	elif move_input != 0:
		animation.play("move")
	else:
		animation.play("idle")

func increase_score(amount: int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)
	play_sound(coin_sfx)

func take_damage(amount: int):
	health -= amount
	OnUpdateHealth.emit(health)
	damage_flash()
	play_sound(take_damage_sfx)

	if health <= 0:
		call_deferred("game_over")

func game_over():
	PlayerStats.score = 0
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func damage_flash():
	sprite.modulate = Color.RED
	await get_tree().create_timer(.5).timeout
	sprite.modulate = Color.WHITE

func play_sound(sound: AudioStream):
	audio.stream = sound
	audio.play()

func bounce():
	print("Before bounce %d" % velocity.y)
	velocity.y = -1 * (velocity.y * bounce_force)
	print("After bounce %d" % velocity.y)
