extends Area2D

@export var whichcutscene: int

#code for triggering cutscenes. this will send a signal to the autoloaded cutscene manager script, see that script for more details

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.is_in_group("Player"):
		CutsceneManager.checkscene(whichcutscene)
