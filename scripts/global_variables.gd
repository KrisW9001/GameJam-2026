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

#event flags: used for conditional dialogue and ensuring that the same cutscene doesnt play twice
var seenfirstcut: bool = false #set after seeing the cutscene outside the subway
var metvagabond: bool = false #set after talking to the vagabond for the 1st time
var beatfirstboss : bool = false #set after defeating the first boss
var haspass: bool = false #determines whether or not the player has the pickup needed to progress
