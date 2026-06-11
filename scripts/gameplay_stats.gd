extends Node

#this script is used to track certain actions or events that the player can do during a playthrough to give a ranking at the end of the game. 

#tracked stats used for final ranking
@export var playtime: String = str(hours, minutes, seconds, msec) #tracks total playtime in the file, should be paused during scene transitions
var deathcount: int = 0 #tracks number of player deaths
var circlesused: int = 0 #tracks how many times a test object (circle) is used to defeat an enemy
var conesused: int = 0 #tracks how many times a cone was used to defeat an enemy
var extinguishersused: int = 0 #tracks how many times an extinguisher was used to defeat an enemy
var punchesused: int = 0 #tracks how many times normal punches are used to defeat an enemy
var favattack: String #string value to represent most used form of attack
var secretsfound: int = 0 #tracks how many of the secrets the player found during their playthrough. has a maximum amount.

#variables used to control the collection of ranking stats
var inmaingame: bool = false #if set to true, the player is in the "main game", and stats like playtime and deathcount will be tallied.
var time: float
var msec: int = 0
var seconds: int = 0
var minutes: int = 0
var hours: int = 0

func _process(delta: float) -> void:
	if inmaingame:
		time += delta
		update_time()
		update_fav_attack()
	else:
		pass

func update_time():
	msec = fmod(time, 1) * 100
	seconds = fmod(time, 60)
	minutes = fmod(time, 3600) / 60
	hours = time / 3600

func update_fav_attack():
	pass
	#find highest value between all "...used" ints and change string to match
