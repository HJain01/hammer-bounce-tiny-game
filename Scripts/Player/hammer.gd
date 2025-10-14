extends Area2D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var bounce_force = 1.5

func _process(_delta):
    if Input.is_action_just_pressed("strike"):
        animation.play("strike")
