## TODO

- [X] 宝石, 发展卡, 贵族等建模
- [X] 单玩家逻辑
- [X] 多玩家逻辑
- [X] 操作记录面板
- [ ] 与服务端交互, 断线后从服务端获取进度
- [X] 当前玩家宝石总数显示
- [X] Play/Hand界面重构
- [ ] 牌库显示剩余张数
- [X] 操作记录面板记录当前玩家操作
- [ ] 宝石数超过10个时与仓库交换
- [ ] 贵族卡拿取每位玩家每轮仅限拿取一枚


## Bug

- [X] 保留区槽位无卡时可点击
- [X] 保留区槽位未绘制购买所需宝石
- [X] 未限制玩家宝石上限为10
- [X] 玩家宝石为达10保留卡时仍能获得黄金
- [X] 玩家起始分数为3(玩家起始即获得一个贵族导致)
- [X] 服务端在玩家掉线时未将玩家移除
- [X] 从牌堆保留卡牌失败
- [X] 保留卡牌后未结束回合
- [X] 从暂存区点击取消之后未将宝石返还仓库
- [X] 宝石从0变为1之后没有重新绘制
- [X] 无法从牌堆保留卡牌
- [X] 对手面板宝石未还回仓库
- [ ] 从牌堆保留卡牌时传给服务端时信息错误`{'action': 'reserve_card', 'area': 0, 'slot': 0, 'level': 'primary', 'serial_number': -1, 'with_gold': True}`
- [X] 黄金被拿光的情况下, 从保留区不花费黄金购买卡牌会导致仓库中显示0个黄金
- [X] 获取贵族时未通知服务端
- [X] 操作记录面板放大后的卡牌被遮挡且并非从卡牌正中放大
- [X] 添加操作记录后滚动条未滚至最下
- [X] 从牌堆保留后各客户端卡牌数据不同步
- [X] 从牌堆保留后保留区卡牌可点击
- [X] `Card.check_cost` 得到错误结果(`Card/Bank.draw_card`比该方法后调用导致)
- [X] 手牌区保留卡计数未随保留卡被购买后减少
