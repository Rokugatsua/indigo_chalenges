extends Control

var board = preload("res://Board/BoardRes.tres")

onready var score_label := $ScoreLabel

func _ready() -> void:
	board.connect("score_changed", self, "_on_changed_score")
	

func _on_changed_score(score) -> void:
	score_label.text = "score : " + str(score)
