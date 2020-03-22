extends KinematicBody2D
class_name Actor

var safety_margin = 10.0
var velocity = Vector2(0.0, 0.0)
var is_on_floor = false
var is_on_wall = false
var is_on_ceiling = false
export(float) var gravity_scale = 1.0
export(float) var gravity_rotation = 0.0
export(float, EXP, 0, 2400, 24) var move_speed = Globals.UNIT_SIZE * 20
export(Globals.facings) var facing = Globals.facings.right

var is_moving := false setget set_is_moving, get_is_moving
var is_interacting := false

onready var body = $Body
onready var playback = $AnimationTree.get("parameters/playback")


func _ready():
	body.scale.x = facing

# warning-ignore:unused_argument

func _physics_process(delta):
	_handle_move_input()
	_apply_movement()


func _handle_move_input() -> void:
	pass


func _apply_movement() -> void:
	velocity.x = clamp(velocity.x, -Globals.max_speed.x, Globals.max_speed.x)
	velocity.y = clamp(velocity.y, -Globals.max_speed.y, Globals.max_speed.y)
	velocity = move_and_slide(velocity, Globals.UP, true)
	
	is_on_floor = is_on_floor()
	is_on_wall = is_on_wall()
	is_on_ceiling = is_on_ceiling()


func apply_gravity(delta : float) -> void:
	var relative_gravity = Globals.gravity.rotated(gravity_rotation)
	velocity += relative_gravity * gravity_scale * delta


func change_facing():
	if facing == Globals.facings.right:
		facing = Globals.facings.left
	else:
		facing = Globals.facings.right
	body.scale.x = facing


func change_animation(name : String):
	if $AnimationPlayer.has_animation(name):
			playback.travel(name)
	else:
		print("Animation not found: %s", name)


func set_is_moving(moving : bool):
	is_moving = moving


func get_is_moving() -> bool:
	return is_moving


func interact(value : bool = true) -> void:
	$Interaction.activate(value)


func _on_Interaction_interaction_start() -> void:
	is_interacting = true


func _on_Interaction_interaction_stop() -> void:
	is_interacting = false
