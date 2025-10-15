extends CanvasLayer

@onready var health_container = $HealthContainer
var hearts: Array = []

@onready var score_text: Label = $ScoreText

func _ready():
	hearts = health_container.get_children()


func _on_player_on_update_health(health:int):
	hearts[health - 1].visible = false


func _on_player_on_update_score(score:int):
	score_text.text = "Score: %d" % score
