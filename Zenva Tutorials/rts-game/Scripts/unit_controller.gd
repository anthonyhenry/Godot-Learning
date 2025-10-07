extends Node2D

var selected_unit : Unit

# Built in function that gets called whenever an input event has occurred
func _input(event):
	# Check for mouseclicks
	if event is InputEventMouseButton and event.pressed:
		# Select a unit on left clicks
		if(event.button_index == MOUSE_BUTTON_LEFT):
			_try_select_unit()
		# Move a unit on right clicks
		elif(event.button_index == MOUSE_BUTTON_RIGHT):
			_try_command_unit()

func _try_select_unit():
	var unit = _get_selected_unit()
	
	# Unslect if a friendly unit was not clicked
	if(unit == null or unit.team != Unit.Team.PLAYER):
		_unselect_unit()
	# If a friendly unit was clicked, select it
	else:
		_select_unit(unit)

func _select_unit (unit: Unit):
	# Unselect previously selected unit if there is one
	_unselect_unit()
	# Set the newly selected unit
	selected_unit = unit
	# Show selected visual
	unit.get_node("PlayerUnit").toggle_selection_visual(true)

func _unselect_unit ():
	# Turn off selected visual for previously selected unit
	if(selected_unit != null):
		selected_unit.get_node("PlayerUnit").toggle_selection_visual(false)
	
	selected_unit = null

func _try_command_unit():
	# Can only command if there is a unit selected
	if selected_unit == null:
		return
	
	# Check if a unit was clicked
	var target = _get_selected_unit()
	if target != null:
		# If an enemy unit was clicked, attack it
		if target.team != Unit.Team.PLAYER:
			selected_unit.set_attack_target(target)
	# If a unit was not clicked, move to the mouse position
	else:
		selected_unit.set_move_to_target(get_global_mouse_position())
			
	
func _get_selected_unit () -> Unit:
	# Get the collider that the mouse is currently hovering over
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true # This line is needed to allow the query to check if an area was clicked
	var intersection = space.intersect_point(query, 1) # Get only 1 result
	
	# Mouse isn't hovering over anything
	if(intersection.is_empty()):
		return null
	
	# Mouse is over something that is not a unit
	if(intersection[0].collider is not Unit):
		return null
	
	# Return the unit that is being hovered over
	return intersection[0].collider
