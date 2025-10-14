extends CanvasLayer

@onready var health_container = $HealthContainer
var hearts: Array = []

@onready var score_text: Label = $ScoreText
@onready var player = get_parent()

func _ready():
	hearts = health_container.get_children()

	player.OnUpdateHealth.connect(update_hearts)
	player.OnUpdateScore.connect(update_score)

func update_hearts(health: int):
	hearts[health - 1].visible = false
	
func update_score(score: int):
	score_text.text = "Score: %d" % score
