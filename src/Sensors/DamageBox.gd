extends Area2D

enum TYPE {
	UNKNOWN = 0,
	PIERCE = 1,
	SLASH = 2,
	BLUNT = 4,
	FIRE = 8,
	COLD = 16,
	POISON = 32
	ELECTRIC = 64
}

export(int) var damage : float = 1
export(TYPE) var type = TYPE.UNKNOWN


func _on_body_entered(body):
	if body is Player || body is Enemy:
		body.take_damage(self, damage)


func _on_area_entered(area):
	area.get_owner().take_damage(self, damage)
