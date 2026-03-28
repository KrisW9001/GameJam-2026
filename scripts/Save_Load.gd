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
	SaveFileData.metfighter = GlobalVariables.metfighter
	SaveFileData.metzulie = GlobalVariables.metzulie
	SaveFileData.beatsecondboss = GlobalVariables.beatsecondboss
	SaveFileData.aggressive = GlobalVariables.aggressive
	SaveFileData.mushroomquest = GlobalVariables.mushroomquest
	SaveFileData.hasmushroom = GlobalVariables.hasmushroom
	SaveFileData.hasshovel = GlobalVariables.hasshovel
	SaveFileData.openedpassage = GlobalVariables.openedpassage
	SaveFileData.metbrooke = GlobalVariables.metbrooke
	SaveFileData.haskey = GlobalVariables.haskey
	SaveFileData.metdamien = GlobalVariables.metdamien
	SaveFileData.hasbook = GlobalVariables.hasbook
	SaveFileData.cont_scene = GlobalVariables.cont_scene
	SaveFileData.town_room = GlobalVariables.town_room
	SaveFileData.beatthirdboss = GlobalVariables.beatthirdboss
	SaveFileData.seennoblecut = GlobalVariables.seennoblecut
	SaveFileData.nobleprefight = GlobalVariables.nobleprefight
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
		GlobalVariables.metfighter = SaveFileData.metfighter
		GlobalVariables.metzulie = SaveFileData.metzulie
		GlobalVariables.beatsecondboss = SaveFileData.beatsecondboss
		GlobalVariables.aggressive = SaveFileData.aggressive
		GlobalVariables.mushroomquest = SaveFileData.mushroomquest
		GlobalVariables.hasmushroom = SaveFileData.hasmushroom
		GlobalVariables.hasshovel = SaveFileData.hasshovel
		GlobalVariables.openedpassage = SaveFileData.openedpassage
		GlobalVariables.metbrooke = SaveFileData.metbrooke
		GlobalVariables.haskey = SaveFileData.haskey
		GlobalVariables.metdamien = SaveFileData.metdamien
		GlobalVariables.hasbook = SaveFileData.hasbook
		GlobalVariables.town_room = SaveFileData.town_room
		GlobalVariables.beatthirdboss = SaveFileData.beatthirdboss
		GlobalVariables.seennoblecut = SaveFileData.seennoblecut
		GlobalVariables.nobleprefight = SaveFileData.nobleprefight
		GlobalVariables.cont_scene = SaveFileData.cont_scene

#reset save data
func clear_save() -> void:
	SaveFileData.seenfirstcut = false
	SaveFileData.metvagabond = false
	SaveFileData.beatfirstboss = false
	SaveFileData.seenreader = false
	SaveFileData.haspass = false
	SaveFileData.metfighter = false
	SaveFileData.metzulie = false
	SaveFileData.beatsecondboss = false
	SaveFileData.aggressive = false
	SaveFileData.mushroomquest = false
	SaveFileData.hasmushroom = false
	SaveFileData.hasshovel = false
	SaveFileData.openedpassage = false
	SaveFileData.metbrooke = false
	SaveFileData.haskey = false
	SaveFileData.metdamien = false
	SaveFileData.hasbook = false
	SaveFileData.town_room = "null"
	SaveFileData.beatthirdboss = false
	SaveFileData.seennoblecut = false
	SaveFileData.nobleprefight = false
	SaveFileData.cont_scene = "null"
	GlobalVariables.seenfirstcut = false
	GlobalVariables.metvagabond = false
	GlobalVariables.beatfirstboss = false
	GlobalVariables.seenreader = false
	GlobalVariables.haspass = false
	GlobalVariables.metfighter = false
	GlobalVariables.metzulie = false
	GlobalVariables.beatsecondboss = false
	GlobalVariables.aggressive = false
	GlobalVariables.mushroomquest = false
	GlobalVariables.hasmushroom = false
	GlobalVariables.hasshovel = false
	GlobalVariables.openedpassage = false
	GlobalVariables.metbrooke = false
	GlobalVariables.haskey = false
	GlobalVariables.metdamien = false
	GlobalVariables.hasbook = false
	GlobalVariables.town_room = "null"
	GlobalVariables.beatthirdboss = false
	GlobalVariables.seennoblecut = false
	GlobalVariables.nobleprefight = false
	GlobalVariables.cont_scene = "null"
