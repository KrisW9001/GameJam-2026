extends Node
#This determines how the game interacts with the save file

const save_location = "user://FromNothingSaveFile.tres"

var SaveFileData: SaveDataResource = SaveDataResource.new()

func _ready() -> void:
	pass

func _save():
	SaveFileData.seenfirstcut = GlobalVariables.seenfirstcut
	SaveFileData.metvagabond = GlobalVariables.metvagabond
	SaveFileData.beatfirstboss = GlobalVariables.beatfirstboss
	SaveFileData.haspass = GlobalVariables.haspass
	SaveFileData.cont_scene = GlobalVariables.cont_scene
	ResourceSaver.save(SaveFileData, save_location)
	print("saving")

func _load():
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)
		
		GlobalVariables.seenfirstcut = SaveFileData.seenfirstcut
		GlobalVariables.metvagabond = SaveFileData.metvagabond
		GlobalVariables.beatfirstboss = SaveFileData.beatfirstboss
		GlobalVariables.haspass = SaveFileData.haspass
		GlobalVariables.cont_scene = SaveFileData.cont_scene

#reset save data
func clear_save() -> void:
	SaveFileData.seenfirstcut = false
	SaveFileData.metvagabond = false
	SaveFileData.beatfirstboss = false
	SaveFileData.haspass = false
	SaveFileData.cont_scene = "null"
