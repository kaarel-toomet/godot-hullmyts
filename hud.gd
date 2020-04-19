extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var inventory = [1,2,3,-1,-1,-1,-1,-1,-1,-1,
				-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, -1]
export var amounts = [5,0,8,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0]
var select = 0
var empty = 0

#block ids:
#0:sand, 1:sea, 2:grass, 3:box, 4:stone, 5:snow, 6:deep sea
#7:tree, 8:cactus, 9:snowy ground, 10:spruce, 11:peat moss, 12:jungle
#13:tundra, 14:sea ice, 15:acacia

var none = Image.new()
var liiv = Image.new()
var meri = Image.new()
var muru = Image.new()
var kast = Image.new()
var kivi = Image.new()
var lumi = Image.new()
var sygavm = Image.new()
var puu = Image.new()
var kaktus = Image.new()
var lmaa = Image.new()
var kuusk = Image.new()
var tsammal = Image.new()
var jungle = Image.new()
var tundra = Image.new()
var mjxx = Image.new()
var akaatsia = Image.new()
var blocks
var hotbar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	none.load("assets/none.png")
	liiv.load("assets/asdfblock.png")#.expand_x2_hq2x()
	meri.load("assets/sky.png")#.expand_x2_hq2x()
	muru.load("assets/ground.png")#.expand_x2_hq2x()
	kast.load("assets/kast.png")#.expand_x2_hq2x()
	kivi.load("assets/asdfback.png")#.expand_x2_hq2x()
	lumi.load("assets/☃.png")#.expand_x2_hq2x()
	sygavm.load("assets/deepw.png")#.expand_x2_hq2x()
	puu.load("assets/puu.png")#.expand_x2_hq2x()
	kaktus.load("assets/kaktus.png")#.expand_x2_hq2x()
	lmaa.load("assets/luminemaa.png")#.expand_x2_hq2x()
	kuusk.load("assets/kuusk.png")#.expand_x2_hq2x()
	tsammal.load("assets/turbasammal.png")#.expand_x2_hq2x()
	jungle.load("assets/jungle.png")#.expand_x2_hq2x()
	tundra.load("assets/tundra.png")#.expand_x2_hq2x()
	mjxx.load("assets/seaice.png")#.expand_x2_hq2x()
	akaatsia.load("assets/acacia.png")#.expand_x2_hq2x()
#	liiv.expand_x2_hq2x()
#	meri.expand_x2_hq2x()
#	muru.expand_x2_hq2x()
	#kast.expand_x2_hq2x()
#	kivi.expand_x2_hq2x()
#	lumi.expand_x2_hq2x()
#	sygavm.expand_x2_hq2x()
	#puu.expand_x2_hq2x()
	#kaktus.expand_x2_hq2x()
	#lmaa.expand_x2_hq2x()
#	kuusk.expand_x2_hq2x()
#	tsammal.expand_x2_hq2x()
#	jungle.expand_x2_hq2x()
#	tundra.expand_x2_hq2x()
	#mjxx.expand_x2_hq2x()
#	akaatsia.expand_x2_hq2x()
	blocks = [liiv,meri,muru,kast,kivi,lumi,sygavm,puu,kaktus,
				lmaa,kuusk,tsammal,jungle,tundra,mjxx,akaatsia, none]
	hotbar = Image.new()
	hotbar.load("assets/hotbar.png")
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				select -= 1
			if event.button_index == BUTTON_WHEEL_DOWN:
				select += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if select > 19:
		select = 0
	if select < 0:
		select = 19
	var hotbarnew = hotbar
	for s in range(20):
		hotbarnew.blit_rect(blocks[inventory[s]], Rect2(0,0,32,32),Vector2(1+s*18,1))
		var texture = ImageTexture.new()
		texture.create_from_image(hotbarnew)
		texture.set_flags(2)
		$hotbar.texture = texture
	$selslot.position = Vector2(select*36+18,18)
