tool
extends Node2D

export(float) var MAX_RANGE : float = 24
export(float) var MIN_RANGE : float = 1

func _ready():
	if not Engine.editor_hint:
		$MinDistance.set_cast_to(Vector2(MIN_RANGE,0))
		$MaxDistance.set_cast_to(Vector2(MAX_RANGE,0))
	if Engine.editor_hint:
		$MinDistance.set_cast_to(Vector2(MIN_RANGE,0))
		$MaxDistance.set_cast_to(Vector2(MAX_RANGE,0))

func check_attack_range() -> bool:
	var has_target : bool = false
	if not $MinDistance.is_colliding() && $MaxDistance.is_colliding():
		has_target = true
	return has_target
