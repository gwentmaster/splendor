## TODO

- [X] 宝石, 发展卡, 贵族等建模
- [X] 单玩家逻辑
- [ ] 多玩家逻辑
- [ ] 操作记录面板
- [ ] 与服务端交互, 断线后从服务端获取进度
- [ ] 当前玩家宝石总数显示
- [ ] Play/Hand界面重构
- [ ] 牌库显示剩余张数


## Bug

- [ ] 保留区槽位无卡时可点击
- [ ] 保留区槽位未绘制购买所需宝石
- [X] 未限制玩家宝石上限为10
- [X] 玩家宝石为达10保留卡时仍能获得黄金
- [X] 玩家起始分数为3(玩家起始即获得一个贵族导致)
- [ ] 服务端在玩家掉线时未将玩家移除
- [ ] 从牌堆保留卡牌失败
- [X] 保留卡牌后未结束回合
- [ ] 从暂存区点击取消之后未将宝石返还仓库
- [ ] 宝石从0变为1之后没有重新绘制
- [X] 无法从牌堆保留卡牌
- [ ] 对手面板宝石未还回仓库
- [ ] 从牌堆保留卡牌时传给服务端时信息错误`{'action': 'reserve_card', 'area': 0, 'slot': 0, 'level': 'primary', 'serial_number': -1, 'with_gold': True}`
