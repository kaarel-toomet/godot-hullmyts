extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var screen_size  # Size of the game window.
var speed = 4
var pause = false

var chunkW = 15 # change these with the chunk sizes in tilemap.gd
var chunkH = 10

var immunity = 0
var attacked = false

var oldpos = position


signal changechunk


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	position.x = 0#chunkW*48
	position.y = 0#chunkH*48
	print(floor(2.555))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var oldpos = position
	if not pause:
		if Input.is_action_pressed("ui_right"):
			move_and_collide(Vector2(speed,0))
		if Input.is_action_pressed("ui_left"):
			move_and_collide(Vector2(-speed,0))
		if Input.is_action_pressed("ui_down"):
			move_and_collide(Vector2(0,speed))
		if Input.is_action_pressed("ui_up"):
			move_and_collide(Vector2(0,-speed))
		if Input.is_action_just_pressed("R"):
			position.x = 0
			position.y = 0
		if Input.is_action_pressed("LSHIFT"):
			speed = 32
		else:
			speed = 4
		var cx = floor((position.x / 32) / chunkW)
		var cy = floor((position.y / 32) / chunkH)
		var ocx = floor((oldpos.x / 32) / chunkW)
		var ocy = floor((oldpos.y / 32) / chunkH)
		var changex = cx-ocx
		var changey = cy-ocy
		#print(cx, " ", ocx, " ", changex)
		if changex != 0 or changey != 0:
			emit_signal("changechunk",changex,changey)
		if immunity > 0:
			immunity -= delta
		else:
			immunity = 0
			if attacked:
				immunity = 0.5
				print("you took damage")


func _on_main_pause():
	if pause == true:
		pause = false
	else:
		pause = true


func _on_koll_hit():
	attacked = true



func _on_koll_unhit():
	attacked = false
