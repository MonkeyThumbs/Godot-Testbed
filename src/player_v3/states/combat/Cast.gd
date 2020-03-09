extends "../state.gd"

# Initialize the state. E.g. change the animation
func enter():
	owner.change_animation("cast")
	owner.is_jumping = false
	owner.velocity.x = 0.0

func handle_input(event : InputEvent):
	if event.is_action_released("cast"):
		emit_signal("finished", "idle")


func _on_animation_finished(_anim_name):
	var spell_name = Spells.Names[owner.current_spell]
	var spell_file = Spells.Files[spell_name]
	var spell = load(spell_file)
	var spell_instance = spell.instance()
	spell_instance.look_direction = owner.look_direction
	#spell_instance.position = owner.position
	# change state 
	if spell_instance.spell_type == spell_instance.Spell_Types.PERSISTANT:
		var node = owner.get_node("./Spells/Persistant/")
		node.add_child(spell_instance)
		emit_signal("finished", "cast_loop")
	else:
		var node = owner.get_node("./Spells/Projectile")
		node.add_child(spell_instance)
		emit_signal("finished", "idle")
