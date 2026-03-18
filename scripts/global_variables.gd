extends Node

#variables to control the camera
@onready var camera_position: Vector2
var cameralock: bool = false
var lock_pos = Vector2()

#variables for menus/cutscenes
var cutscenemode: bool = false
var menumode: bool = false
var menutype: String
var cutscenecameracoords: Vector2

#gameplay variables
var cur_respawn: Vector2
var cont_scene: String = "null"
@onready var player_position: Vector2
#used to force characters to certain coordinates during a cutscene
var player_goto_coords: Vector2
var player_goto_active: bool = false
var vagabond_position: Vector2
var vagabond_coords: Vector2
var vagabond_goto: bool = false
var fighter_coords: Vector2
var fighter_goto: bool = false
var zulie_position: Vector2
var zulie_coords: Vector2
var zulie_goto: bool = false
var in_boss_2: bool = false #used to begin the projectiles for the second boss
var mage_position: Vector2
var mage_coords: Vector2
var mage_goto: bool = false
var healer_coords: Vector2
var healer_goto: bool = false

#event flags: used for conditional dialogue and ensuring that the same cutscene doesnt play twice
var seenfirstcut: bool = false #set after seeing the cutscene outside the subway
var metvagabond: bool = false #set after talking to the vagabond for the 1st time
var beatfirstboss : bool = false #set after defeating the first boss
var seenreader: bool = false #set after inspecting the pass reader in the subway
var haspass: bool = false #determines whether or not the player has the pickup needed to progress
var metzulie: bool = false #set after zulie's first cutscene
var beatsecondboss: bool = false #set after defeating the second boss
var methealer: bool = false #set after talking to healer in the corrupted village
var aggressive: bool = false #set after telling the healer to fight immediately
var hasmushroom: bool = false #part 1 of village sequence, getting uncorrupted mushroom
var hasshovel: bool = false #part 2 of village sequence, getting shovel
var openedpassage: bool = false #dug up the passage in the village
var haskey: bool = false #part 3 of village sequence, getting key on top of the storehouse
var metdamien: bool = false #part 4 of village sequence, meeting damien and getting scroll
