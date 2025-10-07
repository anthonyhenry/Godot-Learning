extends ProgressBar

@onready var unit : Unit = get_parent()

func _ready():
	max_value = unit.max_hp
	value = max_value
	visible = false

	unit.OnTakeDamage.connect(_update_value)

func _update_value(health: int):
	value = health
	# Only show health bar if health is less than 100%
	visible = value < max_value
