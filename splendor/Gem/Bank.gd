extends Panel


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
	
	reset()
	
func reset():
	# 游戏初始设置
	
	for color in gem_num.keys():
		gem_num[color] = 4
	
	for color in gem_banks.keys():
		gem_banks[color].show()
		gem_banks[color].get_node("Gem").set_color(color).set_label("4")
	

func gain_gem(color, num):
	# 仓库获得宝石
	
	var gem = gem_banks[color].get_node("Gem")

	# 原本无宝石则宝石图案显现, 若为"gold"则让所有卡牌的"保留"按钮附加一黄金
	if gem_num[color] == 0:
		gem_num[color] += num
		gem.set_label(str(num))
		gem.show()
		if color == "gold":
			get_tree().call_group("cards", "show_gold", true)
	
	# 原本有宝石则宝石数增加
	else:
		gem_num[color] += num
		gem.set_label(str(gem_num[color]))
		

func offer_gem(color):
	# 仓库向外界提供一个宝石
	
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


func _on_Bank_clicked(event, color):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		offer_gem(color)
