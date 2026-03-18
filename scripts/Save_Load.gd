extends Node
#This determines how the game interacts with the save file

const save_location = "user://FromNothingSaveFile.tres"

var SaveFileData: SaveDataResource = SaveDataResource.new()

func _ready() -> void:
	_load()

func _save():
	SaveFileData.seenfirstcut = GlobalVariables.seenfirstcut
	SaveFileData.metvagabond = GlobalVariables.metvagabond
	SaveFileData.beatfirstboss = GlobalVariables.beatfirstboss
	SaveFileData.seenreader = GlobalVariables.seenreader
	SaveFileData.haspass = GlobalVariables.haspass
	SaveFileData.metzulie = GlobalVariables.metzulie
	SaveFileData.beatsecondboss = GlobalVariables.beatsecondboss
	SaveFileData.aggressive = GlobalVariables.aggressive
	SaveFileData.cont_scene = GlobalVariables.cont_scene
	ResourceSaver.save(SaveFileData, save_location)
	print("saving")

func _load():
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)
		
		GlobalVariables.seenfirstcut = SaveFileData.seenfirstcut
		GlobalVariables.metvagabond = SaveFileData.metvagabond
		GlobalVariables.beatfirstboss = SaveFileData.beatfirstboss
		GlobalVariables.seenreader = SaveFileData.seenreader
		GlobalVariables.haspass = SaveFileData.haspass
		GlobalVariables.metzulie = SaveFileData.metzulie
		GlobalVariables.beatsecondboss = SaveFileData.beatsecondboss
		GlobalVariables.aggressive = SaveFileData.aggressive
		GlobalVariables.hasmushroom = SaveFileData.hasmushroom
		GlobalVariables.hasshovel = SaveFileData.hasshovel
		GlobalVariables.openedpassage = SaveFileData.openedpassage
		GlobalVariables.haskey = SaveFileData.haskey
		GlobalVariables.metdamien = SaveFileData.metdamien
		GlobalVariables.cont_scene = SaveFileData.cont_scene

#reset save data
func clear_save() -> void:
	SaveFileData.seenfirstcut = false
	SaveFileData.metvagabond = false
	SaveFileData.beatfirstboss = false
	SaveFileData.seenreader = false
	SaveFileData.haspass = false
	SaveFileData.metzulie = false
	SaveFileData.beatsecondboss = false
	SaveFileData.aggressive = false
	SaveFileData.hasmushroom = false
	SaveFileData.hasshovel = false
	SaveFileData.openedpassage = false
	SaveFileData.haskey = false
	SaveFileData.metdamien = false
	SaveFileData.cont_scene = "null"
	GlobalVariables.seenfirstcut = false
	GlobalVariables.metvagabond = false
	GlobalVariables.beatfirstboss = false
	GlobalVariables.seenreader = false
	GlobalVariables.haspass = false
	GlobalVariables.metzulie = false
	GlobalVariables.beatsecondboss = false
	GlobalVariables.aggressive = false
	GlobalVariables.hasmushroom = false
	GlobalVariables.hasshovel = false
	GlobalVariables.openedpassage = false
	GlobalVariables.haskey = false
	GlobalVariables.metdamien = false
	GlobalVariables.cont_scene = "null"
