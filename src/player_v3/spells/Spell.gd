class_name Spell
extends Node2D

export(int) var cost : int = 1 setget set_cost, get_cost

enum Spell_Types {
	UNKNOWN,
	PROJECTILE,
	PERSISTANT,
	SELF
}

var look_direction : Vector2 = Vector2.RIGHT
export(Spell_Types) var spell_type = Spell_Types.UNKNOWN


func _ready():
	self.set_scale(Vector2(look_direction.x, 1))
	self.set_position(Vector2(self.position.x * look_direction.x, self.position.y))


func set_cost(value : int) -> void:
	cost = value


func get_cost() -> int:
	return cost
