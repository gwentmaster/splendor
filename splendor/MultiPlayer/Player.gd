extends Panel


var nick_name: String = ""
var id: String = ""
var card_num: Dictionary = {"blue": 0, "brown": 0, "green": 0, "red": 0, "white": 0}
var gem_num: Dictionary = {"blue": 0, "brown": 0, "gold": 0, "green": 0, "red": 0, "white": 0}
var score: int = 0
var reserved_cards: Array = []


enum CardArea {DECK = 0, BANK = 1, RESERVED = 2}


func refresh_card_num() -> void:
	# 刷新拥有卡牌数目
	
	for color in card_num.keys():
		get_node(color.capitalize() + "Area/CardCounter").text = str(card_num[color])
		
		
func refresh_gem_num() -> void:
	# 刷新宝石数目
	
	var gem_summary = 0
	for color in gem_num.keys():
		get_node(color.capitalize() + "Area/GemCounter").text = str(gem_num[color])
		gem_summary += gem_num[color]
	$GemSummary.text = str(gem_summary) + "/10"
	
	
func set_name(name: String) -> void:
	# 设置玩家名称, 并添加至特定分组
	# Args:
	#     name: 玩家名称
	
	self.add_to_group("player_" + name)
	nick_name = name
	$Name.text = name


func purchase_card(data: Dictionary) -> void:
	# 玩家购买卡牌
	# Args:
	#     data: 含以下键的字典
	#         cost: 购买卡牌的实际开销, 形如{"blue": 1, "gold": 1}
	#         score: 卡牌分数
	#         color: 卡牌颜色
	#         area: 卡牌所在区域, 见 `CardArem`
	#         serial_number: 卡牌序号
	#         level: 卡牌所属类别
	
	for c in data["cost"].keys():
		gem_num[c] -= data["cost"][c]
	refresh_gem_num()
	
	card_num[data["color"]] += 1
	refresh_card_num()
	
	score += data["score"]
	$Score.text = str(score)

	if data["area"] == CardArea.RESERVED:
		reserved_cards.erase([data["level"], int(data["serial_number"])])
		$ReservedCardSummary.text = str(len(reserved_cards)) + "/3"


func gain_nobility(score: int) -> void:
	# 玩家获得贵族
	# Args:
	#     score: 贵族分数
	
	self.score += score
	$Score.text = str(self.score)


func reset() -> void:
	# 还原初始设置
	
	for c in card_num.keys():
		card_num[c] = 0
	for c in gem_num.keys():
		gem_num[c] = 0
	score = 0
	reserved_cards = []
	nick_name = ""
	id = ""
	
	refresh_card_num()
	refresh_gem_num()
	score = 0
	$Score.text = str(score)
	$ReservedCardSummary.text = "0/3"


func reserve_card(level: String, serial_number: int, with_gold: bool) -> void:
	# 玩家保留卡牌
	# Args:
	#     level: 卡牌所属分类
	#     serial_number: 卡牌序号
	#     with_gold: 此次保留能否获得黄金
	
	reserved_cards.append([level, serial_number])
	$ReservedCardSummary.text = str(len(reserved_cards)) + "/3"
	
	if with_gold:
		gem_num["gold"] += 1
		refresh_gem_num()


func gain_gem(gems: Dictionary) -> void:
	
	for color in gems.keys():
		gem_num[color] += gems[color]
	refresh_gem_num()
