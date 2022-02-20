extends Node2D


onready var slot_sprite = $SlotSprite

func display(slot) -> void:
	if slot:
		slot_sprite.texture = slot.texture
	else:
		slot_sprite.texture = null
