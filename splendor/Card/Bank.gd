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


func draw_card(level: String, slot: int) -> void:
	# 从牌堆补充卡牌, 此方法在仓库区的卡牌的"购买"按钮被点击后调用
	# Args:
	#     level: 卡牌所属分类, 共"senior", "junior", "primary", "reserved"四种
	#     slot: 卡牌所属槽位
	
	# level可能为"reserved", 表示保留区的卡牌被购买, 此时无需从牌堆补充
	if not (level in ["senior", "junior", "primary"]):
		return
	
	# 无卡可补充
	if len(deck[level]) == 0:
		get_node(level.capitalize() + "/Slot" + str(slot)).hide()
		return
	
	# 从牌堆取一张牌放入对应位置, 由于牌堆为乱序, 故直接调用"pop_back"方法
	get_node(level.capitalize() + "/Slot" + str(slot)).set_card(level, deck[level].pop_back())
	
	# 若卡已抽光, 隐藏对应牌堆
	if len(deck[level]) == 0:
		get_node(level.capitalize() + "Bank").hide()
