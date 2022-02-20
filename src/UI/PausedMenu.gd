extends Control

var board = preload("res://Board/BoardRes.tres")

onready var message_label = $CenterContainer/VBoxContainer/Message

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	board.connect("game_finished", self, "_on_game_finished")
	


func _on_game_finished(message):
	visible = true
	get_tree().paused = true
	message_label.text = message
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_Button_pressed() -> void:
	board.reset_board()
	get_tree().reload_current_scene()
	get_tree().paused = false
