tool
extends Node2D
export(float) var height : float = 22
export(float) var gap : float = 2
export(float) var length : float = 12

func _ready():
	$Bottom.position.y = height
	$Middle.position.y = -height + gap
	$Top.position.y = -height
	for ray in self.get_children():
		ray.set_cast_to(Vector2(length,0))

func _process(delta):
	if Engine.editor_hint:
		$Bottom.position.y = height
		$Middle.position.y = -height + gap
		$Top.position.y = -height
		for ray in self.get_children():
			ray.set_cast_to(Vector2(length,0))
	if not Engine.editor_hint:
		pass

func check_is_infront_of_wall() -> bool:
	return $Middle.is_colliding()

func check_is_on_wall() -> bool:
	if $Bottom.is_colliding() && $Top.is_colliding():
		return true
	return false


func check_is_on_ledge() -> bool:
	if $Middle.is_colliding() && !$Top.is_colliding():
		return true
	return false
