extends Panel


var CARD_DATA = load("res://Card/CardData.gd").new()
var COST_ORDER = CARD_DATA.COST_ORDER
var SLOT_NO_CARD = -2  # 表示此卡位无卡牌


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
	randomize()
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
	
	var card_slot: Card = get_node(level.capitalize() + "/Slot" + str(slot))
	
	# 无卡可补充
	if len(deck[level]) == 0:
		card_slot.serial_number = SLOT_NO_CARD
		card_slot.hide()
		return
	
	# 从牌堆取一张牌放入对应位置, 由于牌堆为乱序, 故直接调用"pop_back"方法
	card_slot.set_card(level, deck[level].pop_back())
	
	# 若卡已抽光, 隐藏对应牌堆
	if len(deck[level]) == 0:
		get_node(level.capitalize() + "Bank").hide()


func reserve_from_deck(level: String) -> int:
	
	return deck[level].pop_back()


func get_game_data() -> Dictionary:
	# 获取卡牌数据, 用于与服务端同步
	# Returns:
	#    格式如下的字典,
	#    {
	#         "senior": {
	#             "deck": [0, 2, ...],    # 牌堆内的卡牌序号
	#             "slot": [3, 4, 5, -2],  # 各卡槽内卡牌序号, -2表示无卡牌
	#        },
	#         ...
	#    }
	
	var data = {}
	for level in ["senior", "junior", "primary"]:
		data[level] = {"slot": []}
		data[level]["deck"] = deck[level]
		for i in range(4):
			data[level]["slot"].append(get_node(level.capitalize() + "/Slot" + str(i)).serial_number)
	
	return data
