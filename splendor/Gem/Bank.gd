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
	
# 游戏初始设置
func reset():
	
	for color in gem_num.keys():
		gem_num[color] = 4
	
	for color in gem_banks.keys():
		gem_banks[color].show()
		gem_banks[color].get_node("Gem").set_color(color).set_label("4")
	

# 仓库获得宝石
func gain_gem(color, num):
	
	var gem = gem_banks[color].get_node("Gem")

	if gem_num[color] == 0:
		gem_num[color] += num
		gem.set_label(str(num))
		gem.show()
	else:
		gem_num[color] += num
		gem.set_label(str(gem_num[color]))
		

# 仓库向外界提供一个宝石
func offer_gem(color):
	
	var gem_bank = gem_banks[color]
	
	if gem_num[color] == 1:
		gem_num[color] = 0
		gem_bank.hide()
	else:
		gem_num[color] -= 1
		gem_bank.get_node("Gem").set_label(str(gem_num[color]))


func _on_BankButton_pressed(color):

	offer_gem(color)
