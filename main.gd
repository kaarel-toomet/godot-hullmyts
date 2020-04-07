extends Node2D


# Declare member variables here. Examples:
# var a = 2
signal pause

export (PackedScene) var koll

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("P"):
		emit_signal("pause")
	if randi() % 100 == 0:
		print("koll should spawn")
		var spawn = koll.instance()
		add_child(spawn)
		spawn.position = Vector2(randi() % 1000, randi() % 1000)
		spawn.scale = Vector2(2,2)
