extends Control


func _ready():
	pass


func _on_Button2_pressed():
	var err = get_tree().change_scene("res://src/Scenes/NPC_Stress_Test.tscn")
	if err:
		print(err)


func _on_Button3_pressed():
	var err = get_tree().change_scene("res://src/Scenes/Player_3_0.tscn")
	if err:
		print(err)


func _on_Button4_pressed():
	get_tree().change_scene("res://src/Scenes/Cemetery.tscn")
