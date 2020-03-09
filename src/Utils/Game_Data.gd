extends Node

var player_instance = preload("../player_v3/PlayerV3.tscn").instance() setget ,get_player_instance
var stage_entrance : int = 0 setget set_stage_entrance, get_stage_entrance

func get_player_instance():
	return player_instance


func set_stage_entrance(index : int) -> void:
	stage_entrance = index


func get_stage_entrance() -> int:
	return stage_entrance
