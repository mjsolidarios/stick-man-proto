extends Node2D


func _on_Button_pressed():
	var root = get_node("/root/Globals")
	if get_node("TextEdit").text == "":
		root.player_name = "No Name"
	else:
		root.player_name = get_node("TextEdit").text
	get_tree().change_scene("res://Main.tscn")
