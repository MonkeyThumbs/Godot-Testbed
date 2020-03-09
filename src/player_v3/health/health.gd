extends Node

signal health_changed(health, amount)
signal health_depleted
signal status_changed

var health : int = 0 setget ,get_health
export(int) var max_health : int = 3 setget set_max_health, get_max_health

var status = null
const POISON_DAMAGE : int = 1
var poison_cycles : int = 0

func _ready():
	health = max_health
	$PoisonTimer.connect('timeout', self, '_on_PoisonTimer_timeout')

func _change_status(new_status):
	match status:
		Globals.STATUS_POISONED:
			$PoisonTimer.stop()

	match new_status:
		Globals.STATUS_POISONED:
			poison_cycles = 0
			$PoisonTimer.start()
	status = new_status
	emit_signal('status_changed', new_status)

func take_damage(amount : int, effect = null):
	if status == Globals.STATUS_INVINCIBLE:
		return
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health, amount)
	if health <= 0:
		emit_signal("health_depleted")
	
#	print("%s got hit and took %s damage. Health: %s/%s" % [owner.get_name(), amount, health, max_health])

	if !effect:
		return
	match effect[0]:
		Globals.STATUS_POISONED:
			_change_status(Globals.STATUS_POISONED)
			poison_cycles = effect[1]

func heal(amount):
	health += amount
	health = max(health, max_health)
	emit_signal("health_changed", health ,amount)
#	print("%s got healed by %s points. Health: %s/%s" % [owner.get_name(), amount, health, max_health])

func _on_PoisonTimer_timeout():
	take_damage(POISON_DAMAGE)
	poison_cycles -= 1
	if poison_cycles == 0:
		_change_status(Globals.STATUS_NONE)
		return
	$PoisonTimer.start()


func get_health() -> int:
	return health


func get_max_health() -> int:
	return max_health


func set_max_health(value : int) -> void:
	max_health = value
