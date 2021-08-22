extends Panel


var CARD_DATA = load("res://Card/CardData.gd").new()
var COST_ORDER = CARD_DATA.COST_ORDER


export var deck = {
	"senior": [],
	"junior": [],
	"primary": []
}

func _ready():
	reset()
	
	for level in ["senior", "junior", "primary"]:
		for slot in range(4):
			draw_card(level, slot)
	
	
func reset():
	deck = {
		"senior": range(20),
		"junior": range(30),
		"primary": range(40)
	}
	for v in deck.values():
		v.shuffle()


func draw_card(level, slot):
	
	# 无卡可补充
	if len(deck[level]) == 0:
		return null
	
	# 从牌堆取一张牌放入对应位置, 由于牌堆为乱序, 故直接调用"pop_back"方法
	get_node(level.capitalize()).get_node("Slot" + str(slot)).set_card(level, deck[level].pop_back())
	
	# 若卡已抽光, 设置对应牌堆为不可选中
	if len(deck[level]) == 0:
		get_node(level.capitalize() + "Bank").set_selectable(false)
