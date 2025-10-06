extends Node

@onready var selection_visual = $"../Selection Visual"

func toggle_selection_visual(toggle: bool):
	selection_visual.visible = toggle
