extends Area2D

# This gives the script a class name so it can be referenced by other scripts
class_name Unit

# Signal that tracks when a unit takes damage to update its health bar
signal OnTakeDamage(health : int)

# Signal for when a unit dies. Used by game manager to determine if the game is over
signal OnDie(unit: Unit)

@export var move_speed: float = 10
@export var cur_hp: int = 20
@export var max_hp: int = 20

@export var attack_range: float = 20.0 # pixels
@export var attack_rate: float = 0.5 # min amount of time allowed between attacks
var last_attack_time: float
@export var attack_damage: int = 5

# Enum to track if units belong to the player or AI
enum Team {PLAYER, AI}
@export var team: Team

# Track what unit this unit is trying to attack
var attack_target: Unit

# Reference to Nav Agent Node
@onready var agent: NavigationAgent2D = $NavigationAgent2D

#func _ready():
	#set_move_to_target(Vector2.ZERO)

# This function gets called each frame
func _process(delta):
	# Stop moving once target is reached. Need this to prevent jittering once object reaches target position
	if(not agent.is_navigation_finished()):
		_move(delta)
	
	_target_check()

func _move(delta):
	# Get next position in path from Nav Agent
	var move_pos = agent.get_next_path_position()
	# Get vector of the direction to next position
	var move_dir = global_position.direction_to(move_pos)
	# Movement per frame vector
	var movement = move_dir * move_speed * delta
	# Add vector to current position
	translate(movement)

# Check how far the unit is away from its target to determine if it can attack or not
func _target_check():
	# Do nothing if there is no target to attack
	if attack_target == null:
		return
	
	# Check if target is within range
	var dist = global_position.distance_to(attack_target.global_position)
	if dist <= attack_range:
		# Stop moving
		agent.target_position = global_position
		# Attack target
		_try_attack_target()
	else:
		agent.target_position = attack_target.global_position

func _try_attack_target():
	var time = Time.get_unix_time_from_system()
	
	# Only attack if enough time has passed since last attack
	if time - last_attack_time < attack_rate:
		return
	
	last_attack_time = time
	attack_target.take_damage(attack_damage)	
	
# Set a target to move to
func set_move_to_target(target: Vector2):
	# Calculate a path to the target position using the Nav Agent node
	agent.target_position = target
	# Don't attack if moving to a position 
	attack_target = null 

# Set target to attack
func set_attack_target (target: Unit):
	# Do not attack teammates
	if target.team == team:
		return
	
	attack_target = target

func take_damage(amount : int):
	cur_hp -= amount
	OnTakeDamage.emit(cur_hp)
	if cur_hp <= 0:
		_die()

func _die():
	OnDie.emit(self)
	queue_free()
