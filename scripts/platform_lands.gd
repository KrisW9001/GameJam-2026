extends Node2D
@onready var zulie: CharacterBody2D = $Zulie
@onready var vagabond: CharacterBody2D = $Vagabond
@onready var asset_mage: CharacterBody2D = $"enemies/Asset Mage"

#the only reason this script exists is to reset has_pass on entry so that the keys and barriers can work correctly in a full playthrough
func _ready() -> void:
	GlobalVariables.haspass = false
	if zulie:
		zulie.invis()
	if vagabond:
		vagabond.invis()
	if asset_mage:
		asset_mage.invis()
	if GlobalVariables.metzulie == true:
		#zulie.respawn()
		#vagabond.respawn()
		if zulie:
			zulie.appear()
		if vagabond:
			vagabond.appear()
		GlobalVariables.zulie_goto = true
		GlobalVariables.vagabond_goto = true
		CutsceneManager.pair_togate()
