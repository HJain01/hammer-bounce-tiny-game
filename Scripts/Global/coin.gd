extends Area2D

var rotate_speed: float = 3.0
var bob_height: float = 3.0
var bob_speed: float = 5.0

@onready var start_pos: Vector2 = global_position
@onready var sprite: Sprite2D = $Sprite

func _physics_process(_delta):
    var time = Time.get_unix_time_from_system()

    rotate_sprite(time)

    move_sprite(time)

func rotate_sprite(time: float):
    sprite.scale.x = sin(time * rotate_speed)

func move_sprite(time: float):
    var y_pos = ((1 + sin(time * bob_speed))) * bob_height
    global_position.y = start_pos.y - y_pos


func _on_body_entered(body:Node2D):
    if not body.is_in_group("Player"):
        return
    
    body.increase_score(1)
    queue_free()
