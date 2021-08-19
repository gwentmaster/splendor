extends Node


# 发展卡数据, "cost"中对应颜色顺序为"white", "blue", "green", "red", "brown"


export var COST_ORDER = ["white", "blue", "green", "red", "brown"]

export var PRIMARY_CARD_DATA = [
	{"score": 0, "color": "red", "cost": [3, 0, 0, 0, 0]},                                            
	{"score": 0, "color": "red", "cost": [2, 1, 1, 0, 1]},                                            
	{"score": 0, "color": "white", "cost": [0, 0, 0, 2, 1]},                                            
	{"score": 0, "color": "white", "cost": [0, 1, 1, 1, 1]},                                            
	{"score": 0, "color": "white", "cost": [3, 1, 0, 0, 1]},                                            
	{"score": 0, "color": "green", "cost": [1, 1, 0, 1, 2]},                                            
	{"score": 0, "color": "green", "cost": [2, 1, 0, 0, 0]},                                            
	{"score": 0, "color": "blue", "cost": [1, 0, 0, 0, 2]},                                            
	{"score": 0, "color": "brown", "cost": [0, 0, 3, 0, 0]},                                            
	{"score": 0, "color": "brown", "cost": [1, 2, 1, 1, 0]},                                            
	{"score": 0, "color": "white", "cost": [0, 1, 2, 1, 1]},                                           
	{"score": 0, "color": "white", "cost": [0, 2, 0, 0, 2]},                                           
	{"score": 1, "color": "blue", "cost": [0, 0, 0, 4, 0]},                                           
	{"score": 0, "color": "blue", "cost": [0, 0, 2, 0, 2]},                                           
	{"score": 0, "color": "blue", "cost": [1, 0, 1, 1, 1]},                                           
	{"score": 0, "color": "brown", "cost": [2, 2, 0, 1, 0]},                                           
	{"score": 1, "color": "brown", "cost": [0, 4, 0, 0, 0]},                                           
	{"score": 0, "color": "brown", "cost": [0, 0, 2, 1, 0]},                                           
	{"score": 1, "color": "red", "cost": [4, 0, 0, 0, 0]},                                           
	{"score": 0, "color": "green", "cost": [0, 1, 0, 2, 2]},                                           
	{"score": 0, "color": "green", "cost": [1, 3, 1, 0, 0]},                                           
	{"score": 0, "color": "green", "cost": [0, 0, 0, 3, 0]},                                           
	{"score": 1, "color": "white", "cost": [0, 0, 4, 0, 0]},                                           
	{"score": 0, "color": "red", "cost": [1, 1, 1, 0, 1]},                                           
	{"score": 0, "color": "blue", "cost": [1, 0, 1, 2, 1]},                                           
	{"score": 0, "color": "blue", "cost": [0, 1, 3, 1, 0]},                                           
	{"score": 0, "color": "green", "cost": [1, 1, 0, 1, 1]},                                           
	{"score": 0, "color": "green", "cost": [0, 2, 0, 2, 0]},                                           
	{"score": 1, "color": "green", "cost": [0, 0, 0, 0, 4]},                                           
	{"score": 0, "color": "blue", "cost": [1, 0, 2, 2, 0]},                                           
	{"score": 0, "color": "blue", "cost": [0, 0, 0, 0, 3]},                                           
	{"score": 0, "color": "white", "cost": [0, 3, 0, 0, 0]},                                           
	{"score": 0, "color": "white", "cost": [0, 2, 2, 0, 1]},                                           
	{"score": 0, "color": "red", "cost": [1, 0, 0, 1, 3]},                                           
	{"score": 0, "color": "red", "cost": [0, 2, 1, 0, 0]},                                           
	{"score": 0, "color": "red", "cost": [2, 0, 1, 0, 2]},                                           
	{"score": 0, "color": "brown", "cost": [2, 0, 2, 0, 0]},                                           
	{"score": 0, "color": "brown", "cost": [1, 1, 1, 1, 0]},                                           
	{"score": 0, "color": "brown", "cost": [0, 0, 1, 3, 1]},                                           
	{"score": 0, "color": "red", "cost": [2, 0, 0, 2, 0]}
]

export var JUNIOR_CARD_DATA = [
	{"score": 2, "color": "red", "cost": [3, 0, 0, 0, 5]},                                           
	{"score": 3, "color": "blue", "cost": [0, 6, 0, 0, 0]},                                           
	{"score": 3, "color": "green", "cost": [0, 0, 6, 0, 0]},                                           
	{"score": 3, "color": "white", "cost": [6, 0, 0, 0, 0]},                                           
	{"score": 1, "color": "brown", "cost": [3, 0, 3, 0, 2]},                                           
	{"score": 2, "color": "green", "cost": [0, 0, 5, 0, 0]},                                           
	{"score": 2, "color": "brown", "cost": [0, 0, 5, 3, 0]},                                           
	{"score": 1, "color": "red", "cost": [2, 0, 0, 2, 3]},                                           
	{"score": 2, "color": "brown", "cost": [0, 1, 4, 2, 0]},                                           
	{"score": 1, "color": "green", "cost": [3, 0, 2, 3, 0]},                                           
	{"score": 2, "color": "white", "cost": [0, 0, 0, 5, 0]},                                          
	{"score": 3, "color": "red", "cost": [0, 0, 0, 6, 0]},                                          
	{"score": 2, "color": "white", "cost": [0, 0, 1, 4, 2]},                                          
	{"score": 2, "color": "red", "cost": [0, 0, 0, 0, 5]},                                          
	{"score": 1, "color": "white", "cost": [0, 0, 3, 2, 2]},                                          
	{"score": 2, "color": "green", "cost": [4, 2, 0, 0, 1]},                                          
	{"score": 2, "color": "blue", "cost": [5, 3, 0, 0, 0]},                                          
	{"score": 3, "color": "brown", "cost": [0, 0, 0, 0, 6]},                                          
	{"score": 2, "color": "green", "cost": [0, 5, 3, 0, 0]},                                          
	{"score": 1, "color": "blue", "cost": [0, 2, 3, 0, 3]},                                          
	{"score": 2, "color": "brown", "cost": [5, 0, 0, 0, 0]},                                          
	{"score": 2, "color": "blue", "cost": [2, 0, 0, 1, 4]},                                          
	{"score": 1, "color": "blue", "cost": [0, 2, 2, 3, 0]},                                          
	{"score": 2, "color": "white", "cost": [0, 0, 0, 5, 3]},                                          
	{"score": 1, "color": "white", "cost": [2, 3, 0, 3, 0]},                                          
	{"score": 2, "color": "red", "cost": [1, 4, 2, 0, 0]},                                          
	{"score": 1, "color": "brown", "cost": [3, 2, 2, 0, 0]},                                          
	{"score": 1, "color": "red", "cost": [0, 3, 0, 2, 3]},                                          
	{"score": 2, "color": "blue", "cost": [0, 5, 0, 0, 0]},                                          
	{"score": 1, "color": "green", "cost": [2, 3, 0, 0, 2]}
]

export var SENIOR_CARD_DATA = [
	{"score": 4, "color": "brown", "cost": [0, 0, 0, 7, 0]},                                           
	{"score": 5, "color": "red", "cost": [0, 0, 7, 3, 0]},                                           
	{"score": 4, "color": "green", "cost": [0, 7, 0, 0, 0]},                                           
	{"score": 4, "color": "white", "cost": [3, 0, 0, 3, 6]},                                           
	{"score": 3, "color": "brown", "cost": [3, 3, 5, 3, 0]},                                           
	{"score": 4, "color": "brown", "cost": [0, 0, 3, 6, 3]},                                           
	{"score": 4, "color": "white", "cost": [0, 0, 0, 0, 7]},                                           
	{"score": 4, "color": "green", "cost": [3, 6, 3, 0, 0]},                                           
	{"score": 5, "color": "blue", "cost": [7, 3, 0, 0, 0]},                                           
	{"score": 4, "color": "red", "cost": [0, 3, 6, 3, 0]},                                           
	{"score": 4, "color": "red", "cost": [0, 0, 7, 0, 0]},                                          
	{"score": 5, "color": "brown", "cost": [0, 0, 0, 7, 3]},                                          
	{"score": 5, "color": "green", "cost": [0, 7, 3, 0, 0]},                                          
	{"score": 3, "color": "green", "cost": [5, 3, 0, 3, 3]},                                          
	{"score": 4, "color": "blue", "cost": [6, 3, 0, 0, 3]},                                          
	{"score": 5, "color": "white", "cost": [3, 0, 0, 0, 7]},                                          
	{"score": 4, "color": "blue", "cost": [7, 0, 0, 0, 0]},                                          
	{"score": 3, "color": "red", "cost": [3, 5, 3, 0, 3]},                                          
	{"score": 3, "color": "white", "cost": [0, 3, 3, 5, 3]},                                          
	{"score": 3, "color": "blue", "cost": [3, 0, 3, 3, 5]}
]
