extends Resource
class_name SaveDataResource

#settings values
@export var master_volume: float = 0.0
@export var music_volume: float = 0.0
@export var sfx_volume: float = 0.0

#cutscene, dialogue, and room transition flags
@export var seenfirstcut: bool = false 
@export var metvagabond: bool = false 
@export var beatfirstboss : bool = false 
@export var seenreader: bool = false
@export var haspass: bool = false 
@export var haspass2: bool = false 
@export var metfighter: bool = false
@export var metzulie: bool = false
@export var metmage: bool = false
@export var beatsecondboss: bool = false
@export var aggressive: bool = false
@export var mushroomquest: bool = false
@export var hasmushroom: bool = false
@export var hasshovel: bool = false
@export var openedpassage: bool = false
@export var metbrooke: bool = false
@export var haskey: bool = false
@export var metdamien: bool = false
@export var hasbook: bool = false
@export var town_room: String
@export var beatthirdboss: bool = false
@export var seennoblecut: bool = false
@export var nobleprefight: bool = false
@export var finishedgame: bool = false
@export var cont_scene: String

#gameplay stats
@export var playtime: String
@export var deathcount: int = 0 
@export var circlesused: int = 0 
@export var conesused: int = 0 
@export var extinguishersused: int = 0 
@export var punchesused: int = 0
@export var favattack: String
@export var secretsfound: int = 0 

#secret flags
@export var artifact1: bool = false
@export var artifact2: bool = false
@export var artifact3: bool = false
@export var artifact4: bool = false
@export var zuliejournal: bool = false
@export var brookemeeting: bool = false
