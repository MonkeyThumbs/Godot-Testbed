tool
extends Node

export(float) var distance : float = 40

func _ready():
	$RayCast2D.set_cast_to(Vector2(0, distance))

func check_for_edge() -> bool:
	return !$RayCast2D.is_colliding()
