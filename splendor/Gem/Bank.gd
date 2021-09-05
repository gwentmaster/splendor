extends Panel
class_name GemBank


export (PackedScene) var Gem

# 各类宝石数目
export var gem_num = {
	"blue": 0,
	"brown": 0,
	"gold": 0,
	"green": 0,
	"red": 0,
	"white": 0
}

var enabled_dic = {
	"blue": true,
	"brown": true,
	"green": true,
	"red": true,
	"white": true,
	"gold": false
}
var gem_banks = {}


func _ready():
	
	gem_banks = {
		"blue": $BlueBank,
		"brown": $BrownBank,
		"gold": $GoldBank,
		"green": $GreenBank,
		"red": $RedBank,
		"white": $WhiteBank
	}



func gain_gem(color: String, num: int) -> void:
	# 仓库获得宝石
	# Args:
	#     color: 宝石颜色
	#     num: 宝石数目

	if num == 0:
		return

	var gem = gem_banks[color].get_node("Gem")

	# 原本无宝石则宝石图案显现, 若为"gold"则让所有卡牌的"保留"按钮附加一黄金
	if gem_num[color] == 0:
		gem_num[color] += num
		gem_banks[color].show()
		if color == "gold":
			get_tree().call_group("cards", "show_gold", true)
	
	# 原本有宝石则宝石数增加
	else:
		gem_num[color] += num
	
	gem.set_label(str(gem_num[color]))


func offer_gem(color: String) -> void:
	# 仓库向外界提供一个宝石
	# Args:
	#     color: 宝石颜色
	
	var gem_bank = gem_banks[color]
	
	# 只有一个宝石, 数目减1且隐藏图案, 若为"gold"则隐藏卡牌"保留"按钮附加的黄金
	if gem_num[color] == 1:
		gem_num[color] = 0
		gem_bank.hide()
		if color == "gold":
			get_tree().call_group("cards", "show_gold", false)
	
	# 有多个宝石则宝石数减1
	else:
		gem_num[color] -= 1
		gem_bank.get_node("Gem").set_label(str(gem_num[color]))
		
		
func set_enable(color: String, flag: bool) -> void:
	if color == "all":
		for c in enabled_dic.keys():
			if c == "gold":
				continue
			enabled_dic[c] = flag
	else:
		enabled_dic[color] = flag


func get_game_data() -> Dictionary:
	return gem_num


func set_game_data(data: Dictionary) -> void:
	for c in gem_num.keys():
		gem_num[c] = data[c]
		gem_banks[c].get_node("Gem").set_label(str(gem_num[c]))
		if gem_num[c] == 0:
			gem_banks[c].hide()
		else:
			gem_banks[c].show()


func round_start(player_gem_num: int) -> void:
	# 回合开始时, 检查玩家宝石数是否为10, 达到10则本回合无法拿取宝石
	# Args:
	#     player_gem_num: 玩家宝石总数
	
	if player_gem_num < 10:
		set_enable("all", true)
	else:
		set_enable("all", false)


func _on_Bank_clicked(event, color: String):
	if (
		event is InputEventMouseButton
		and event.pressed
		and event.button_index == BUTTON_LEFT
		and enabled_dic[color] == true
	):
		# 个数小于4的宝石不能一次拿两个
		if gem_num[color] < 4:
			set_enable(color, false)
			
		offer_gem(color)
		get_tree().call_group("gem_stage", "add_gem", color)
