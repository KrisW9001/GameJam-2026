extends Node
#This determines how the game interacts with the save file

const save_location = "user://FromNothingSaveFile.tres"

var SaveFileData: SaveDataResource = SaveDataResource.new()

func _ready() -> void:
	_load()

func _save():
	#cutscene, dialogue, and room transition flags
	SaveFileData.seenfirstcut = GlobalVariables.seenfirstcut
	SaveFileData.metvagabond = GlobalVariables.metvagabond
	SaveFileData.beatfirstboss = GlobalVariables.beatfirstboss
	SaveFileData.seenreader = GlobalVariables.seenreader
	SaveFileData.haspass = GlobalVariables.haspass
	SaveFileData.haspass2 = GlobalVariables.haspass2
	SaveFileData.metfighter = GlobalVariables.metfighter
	SaveFileData.metzulie = GlobalVariables.metzulie
	SaveFileData.metmage = GlobalVariables.metmage
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
	SaveFileData.finishedgame = GlobalVariables.finishedgame
	
	#gameplay stats
	SaveFileData.playtime = GameplayStats.playtime
	SaveFileData.deathcount = GameplayStats.deathcount
	SaveFileData.circlesused = GameplayStats.circlesused
	SaveFileData.conesused = GameplayStats.conesused
	SaveFileData.extinguishersused = GameplayStats.extinguishersused
	SaveFileData.punchesused = GameplayStats.punchesused
	SaveFileData.favattack = GameplayStats.favattack
	SaveFileData.secretsfound = GameplayStats.secretsfound
	
	#secret flags
	SaveFileData.zuliejournal = GlobalVariables.zuliejournal
	SaveFileData.brookemeeting = GlobalVariables.brookemeeting
	
	ResourceSaver.save(SaveFileData, save_location)
	print("saving")

func _load():
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)
		
		#cutscene, dialogue, and room transition flags
		GlobalVariables.seenfirstcut = SaveFileData.seenfirstcut
		GlobalVariables.metvagabond = SaveFileData.metvagabond
		GlobalVariables.beatfirstboss = SaveFileData.beatfirstboss
		GlobalVariables.seenreader = SaveFileData.seenreader
		GlobalVariables.haspass = SaveFileData.haspass
		GlobalVariables.haspass2 = SaveFileData.haspass2
		GlobalVariables.metfighter = SaveFileData.metfighter
		GlobalVariables.metzulie = SaveFileData.metzulie
		GlobalVariables.metmage = SaveFileData.metmage
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
		GlobalVariables.finishedgame = SaveFileData.finishedgame
		GlobalVariables.cont_scene = SaveFileData.cont_scene
		
		#gameplay stats
		GameplayStats.playtime = SaveFileData.playtime
		GameplayStats.deathcount = SaveFileData.deathcount
		GameplayStats.circlesused = SaveFileData.circlesused
		GameplayStats.conesused = SaveFileData.conesused
		GameplayStats.extinguishersused = SaveFileData.extinguishersused
		GameplayStats.punchesused = SaveFileData.punchesused
		GameplayStats.favattack = SaveFileData.favattack
		GameplayStats.secretsfound = SaveFileData.secretsfound
		
		#secret flags
		GlobalVariables.zuliejournal = SaveFileData.zuliejournal
		GlobalVariables.brookemeeting = SaveFileData.brookemeeting

#reset save data from new game button, does not reset unlocks
func clear_save() -> void:
	#cutscene, dialogue, and room transition flags
	SaveFileData.seenfirstcut = false
	SaveFileData.metvagabond = false
	SaveFileData.beatfirstboss = false
	SaveFileData.seenreader = false
	SaveFileData.haspass = false
	SaveFileData.haspass2 = false
	SaveFileData.metfighter = false
	SaveFileData.metzulie = false
	SaveFileData.metmage = false
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
	GlobalVariables.haspass2 = false
	GlobalVariables.metfighter = false
	GlobalVariables.metzulie = false
	GlobalVariables.metmage = false
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
	
	#gameplay stats
	GameplayStats.playtime = ""
	GameplayStats.deathcount = 0
	GameplayStats.circlesused = 0
	GameplayStats.conesused = 0
	GameplayStats.extinguishersused = 0
	GameplayStats.punchesused = 0
	GameplayStats.favattack = ""
	GameplayStats.secretsfound = 0
	SaveFileData.playtime = ""
	SaveFileData.deathcount = 0
	SaveFileData.circlesused = 0
	SaveFileData.conesused = 0
	SaveFileData.extinguishersused = 0
	SaveFileData.punchesused = 0
	SaveFileData.favattack = ""
	SaveFileData.secretsfound = 0

#unique form of clearing save that also deletes data of collected secrets
func full_clear_save() -> void:
	clear_save()
	GlobalVariables.finishedgame = false
	GlobalVariables.zuliejournal = false
	GlobalVariables.brookemeeting = false
	SaveFileData.finishedgame = false
	SaveFileData.brookemeeting = false
	SaveFileData.brookemeeting = false
