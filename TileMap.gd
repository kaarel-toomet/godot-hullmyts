extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var persistencenoise = OpenSimplexNoise.new()
var mainnoise = OpenSimplexNoise.new()
var continentnoise = OpenSimplexNoise.new()
var tempnoise = OpenSimplexNoise.new()
var wetnoise = OpenSimplexNoise.new()
var largetempnoise = OpenSimplexNoise.new()
var largewetnoise = OpenSimplexNoise.new()
export var chunkW = 15 #when changing these, change the numbers in hullmyts's script, that are used in the changechunk signal
export var chunkH = 10
var wOffsetx = -1 # activewindow offset, top-left chunk in tiles
var wOffsety = -1
var breakto = {0:1, 1:6, 2:0, 3:0, 4:2, 5:4, 6:6, 7:2,
				8:0, 9:0, 10:9, 11:1, 12:2, 13:9, 14:1, 15:2}
#0:sand, 1:sea, 2:grass, 3:box, 4:stone, 5:snow, 6:deep sea
#7:tree, 8:cactus, 9:snowy ground, 10:spruce, 11:peat moss, 12:jungle
#13:tundra, 14:sea ice, 15:acacia

func generate(cx,cy):
	if $generated.get_cell(cx,cy) != -1:
		return
	$generated.set_cell(cx,cy,0)
	for x in range(chunkW*cx,chunkW*(cx+1)):
		for y in range(chunkH*cy,chunkH*(cy+1)):
			var gencell = -1
			persistencenoise.seed = 32
			mainnoise.octaves = 5
			mainnoise.period = 40
			mainnoise.persistence = abs(persistencenoise.get_noise_2d(x+1000,y)*1.2)+0.4
			mainnoise.lacunarity = 2
			
			tempnoise.seed = 10
			tempnoise.octaves = 5
			tempnoise.period = 100
			tempnoise.persistence = 0.5
			tempnoise.lacunarity = 2
			
			wetnoise.seed = 123
			wetnoise.octaves = 5
			wetnoise.period = 100
			wetnoise.persistence = 0.5
			wetnoise.lacunarity = 2
			
			largetempnoise.seed = 100
			largetempnoise.octaves = 5
			largetempnoise.period = 2500
			largetempnoise.persistence = 0.5
			largetempnoise.lacunarity = 2
			
			largewetnoise.seed = 1234
			largewetnoise.octaves = 5
			largewetnoise.period = 2500
			largewetnoise.persistence = 0.5
			largewetnoise.lacunarity = 2
			
			var offsetval = pow(abs(continentnoise.get_noise_2d(x,y)),0.3) * sign(continentnoise.get_noise_2d(x,y))
			var noiseval = mainnoise.get_noise_2d(x,y)+offsetval*0.6
			var heatval = tempnoise.get_noise_2d(x,y) + largetempnoise.get_noise_2d(x,y)
			var moistureval = wetnoise.get_noise_2d(x,y) + largewetnoise.get_noise_2d(x,y)
			var heatthresholdlow = rand_range(-0.35,-0.15)
			var heatthresholdhigh = rand_range(0.15,0.35)
			var moisturethresholdlow = rand_range(-0.35,-0.15)
			var moisturethresholdhigh = rand_range(0.15,0.35)
			var heat
			var moisture
			
			if heatval < heatthresholdlow:
				heat = 0
			elif heatval < heatthresholdhigh:
				heat = 1
			else:
				heat = 2
			
			if moistureval < moisturethresholdlow:
				moisture = 0
			elif moistureval < moisturethresholdhigh:
				moisture = 1
			else:
				moisture = 2
			
			#print(mainnoise.period, " ",mainnoise.persistence," ",mainnoise.lacunarity, " ", noiseval)
			if noiseval < -0.3:
				gencell = 6
			elif noiseval < 0:
				gencell = 1
				if heat == 0:
					gencell = 14
			elif noiseval < 0.1:
				gencell = 0
			elif noiseval < 0.55:
				if heat == 2:
					if moisture == 0:
						gencell = 0
						if rand_range(-1.5,moistureval) > -0.5:
							gencell = 8
					elif moisture == 1:
						gencell = 2
						if rand_range(-1,moistureval) > -0.5:
							gencell = 15
					else:
						gencell = 12
				elif heat == 1:
					gencell = 2
					if moisture == 1:
						gencell = 7
					elif moisture == 2:
						gencell = 11
						if rand_range(0,5) < 1:
							gencell = 1
				else:
					gencell = 9
					if moisture == 2:
						gencell = 10
					if moisture == 1:
						gencell = 13
			elif noiseval < 0.75:
				gencell = 4
			else:
				gencell = 5
			if get_cell(x,y) == -1:
				set_cell(x,y,gencell)
func lammuta(x,y):
	x = floor(x)
	y = floor(y)
	if get_cell(x,y) == -1:
		return
	set_cell(x,y,breakto[get_cell(x,y)])
func ehita(x,y):
	set_cell(floor(x),floor(y),3)


func save_world():
	var chunks := File.new()
	chunks.open("res://world/chunks.gwrld",File.WRITE)
	for chunk in $generated.get_used_cells():
		chunks.store_double(chunk.x)
		chunks.store_double(chunk.y)
		for x in range(chunkW):
			for y in range(chunkH):
				chunks.store_8(get_cell(x+chunk.x*chunkW, y+chunk.y*chunkH))
	chunks.close()
	var data := File.new()
	data.open("res://world/data.gwrld",File.WRITE)
	data.store_8(get_parent().get_node("hullmyts").health)
	chunks.close()
func load_world():
	var chunks := File.new()
	chunks.open("res://world/chunks.gwrld",File.READ)
	if chunks.file_exists("res://world/chunks.gwrld"):
		while chunks.get_position() != chunks.get_len():
			var chunk := Vector2()
			chunk.x = chunks.get_double()
			chunk.y = chunks.get_double()
			for x in range(chunkW):
				for y in range(chunkH):
					set_cell(x+chunk.x*chunkW,y+chunk.y*chunkH,chunks.get_8())
		chunks.close()
	else:
		print("chunks file not found")
	var data := File.new()
	data.open("res://world/data.gwrld",File.READ)
	if data.file_exists("res://world/data.gwrld"):
		get_parent().get_node("hullmyts").health = data.get_8()
		data.close()


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	persistencenoise.seed = 434
	persistencenoise.octaves = 4
	persistencenoise.period = 500
	persistencenoise.persistence = 0.5
	persistencenoise.lacunarity = 2
	continentnoise.seed = 222
	continentnoise.octaves = 5
	continentnoise.period = 1000
	continentnoise.persistence = 0.5
	continentnoise.lacunarity = 2
	scroll(0,0)
	load_world()##################################################Rtrrrrre

func scroll(sx,sy):
	for cx in range(3):
		for cy in range(3):
			for x in range(chunkW*(cx+wOffsetx),chunkW*(cx+wOffsetx+1)):
				for y in range(chunkH*(cy+wOffsety),chunkH*(cy+wOffsety+1)):
					pass#set_cell(x,y,-1)
					#fix_invalid_tiles()
	for cx in range(3):
		for cy in range(3):
			generate(cx + wOffsetx + sx, cy + wOffsety + sy)
	wOffsetx += sx
	wOffsety += sy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("LCLICK"):
		var parent = get_parent()
		var xy = parent.get_global_mouse_position()/32
		lammuta(xy[0],xy[1])
	if Input.is_action_just_pressed("RCLICK"):
		var parent = get_parent()
		var xy = parent.get_global_mouse_position()/32
		ehita(xy[0],xy[1])

func _notification(what):
	if what == NOTIFICATION_EXIT_TREE:
		save_world()


func _on_hullmyts_changechunk(changex, changey):
	scroll(changex, changey)
