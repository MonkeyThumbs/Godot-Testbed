extends Control


signal health_changed(health, amout)
signal mana_changed(health, amout)
signal max_health_changed(health, amout)
signal max_mana_changed(health, amout)

onready var health_bar = $Health
onready var mana_bar = $Mana


func _on_health_changed(health, amount) -> void:
	emit_signal("health_changed", health, amount)


func _on_mana_changed(mana, amount) -> void:
	emit_signal("health_changed", mana, amount)


func _on_max_health_changed(health) -> void:
	emit_signal("max_health_changed", health)


func _on_max_mana_changed(mana) -> void:
	emit_signal("max_health_changed", mana)
