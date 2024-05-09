1 /**!
2 * @mainpage
3 * @brief     DDL合约文件
4 * @details  DDL合约逻辑实现文件
5 * @author     Jason
6 * @date        2020-9-20
7 * @version     V1.0
8 * @copyright    Copyright (c) 2019-2020   
9 **********************************************************************************
10 * @attention
11 * 编译工具: http://remix.ethereum.org
12 * 编译参数: Enable optimization, EVM Version: petersburg, 默认EVM版本调用address(this).balance时会 throws error invalid opcode SELFBALANCE \n
13 * 编译器版本：solidity   0.7.0 以上版本
14 * @par 修改日志:
15 * <table>
16 * <tr><th>Date        <th>Version  <th>Author    <th>Description
17 * <tr><td>2020-9-15  <td>1.0      <td>Jason  <td>创建初始版本
18 * </table>
19 *
20 **********************************************************************************
21 */
22 pragma solidity ^ 0.7.0;
23 
24 contract DDLClub {
25 	using SafeMath64 for uint64;
26 	//Wei转换
27 	uint64 constant private WEI = 1000000000000000000;
28 
29 	//Wei转换到 单位：eth*10^2 即 保留小数点后2位
30 	uint64 constant private WEI_ETH2 = 10000000000000000;
31 
32 	//Wei转换到 单位：eth*10^4 即 保留小数点后4位
33 	uint64 constant private WEI_ETH4 = 100000000000000;
34 
35 	//私网测试地址
36 	address constant private ROOT_ADDR = 0x5422d363BFBee232382eA65f6a4C0c400b99A6ed;
37 
38 	address constant private ADMIN_ADDR = 0xa04c077C326C019842fcA35B2Edb74Cd059d8755;
39 	//操作员地址，由管理员设置
40 	address private op_addr = 0xeD5830B3cbDdcecB11f8D9F5FC5bfC2DB89dd2Ae;
41 
42 	uint32 constant private TIME_BASE = 1598889600; //基准时间 2020-09-01 00:00:00
43 
44  	uint16 constant private MAX_UINT16 = 65535;
45 	//高阶人才补助，级差值
46 	uint16[16] private ADV_ALLOWANCE = [uint16(0),25, 50,75,100,125,150,175,200,225,250,275,300,325,350,375];//高阶人才补助，级差
47 
48 	// 定义事件
49     event ev_join(address indexed addr, address indexed paddr, address indexed refaddr, uint32 sidx, uint32 playid, uint32 nlayer, uint256 _value); //会员参与游戏事件
50     event ev_adv_up(address indexed addr,  uint32 playid, uint32 _oldLevel, uint32 _newLevel); //高阶人才升级事件
51     event ev_vip_up(address indexed addr,  uint32 playid, uint64 _timestamp, uint32 _ratio); //VIP升级事件
52 	event ev_set_vip18_bonus(address indexed addr,  uint32 playId, uint16 burnTimes, uint16 slideTimes, uint64 val, string comment); //设置VIP18收益事件
53 	event ev_bonus(address indexed addr,  uint32 playid,  address indexed saddr,  uint64 val, string comment); //获得收益事件
54     event ev_withdraw(address indexed addr,   uint32 playid,  uint256 _value, string comment); //提现
55  	event ev_op_setting(address indexed addr, uint32 playid, string comment); //后台操作员设置参数
56 
57 	//定义会员结构体
58 	struct Player {
59 		//在父连接点的位置（0-2）
60 		uint8 pindex;
61 		//下一个伞下成员将要存放的位置系统号（0-2）
62 		uint8 next_idx;
63 		//高阶身份级别(0:普通,1:初级人才,2:高阶人才,3:一星,4-二星,5-三星,6-四星,7-五星,8-银级,9-金级,10-铂金,11-钻石,12-金钻,13-蓝宝石,14-翡翠级,15-荣誉星钻级)
64 		uint8 adv_level; 
65 		//下属2层总会员数
66 		uint8 m2_count;
67 		//下属3层总会员数 Number of members on begin 4 floor
68 		uint8 m3_count;
69 		//会员当前在VIP级别上的奖金比例 单位：*100
70 		uint8 vip_ratio;
71  
72  		//随机认证码，用于中心化系统绑定
73 		uint16 auth_code;
74 		//总被烧伤次数
75 		uint16 burn_times;
76 		//获得滑落奖金次数
77 		uint16 slide_times;
78 
79 		//三个系统高阶人才数
80 		uint16[3] advN;
81 		//三个系统上的VIP用户数
82 		uint16[3] vipN;
83 
84 		//会员加入时间，相对于基准时间TIME_BASE
85 		uint32 join_timestamp;
86 	 	//会员vip升级时间，相对于基准时间TIME_BASE
87 		uint32 vip_up_timestamp;
88 
89 		
90 		//会员代数，从1开始
91 		uint32 gen_num;
92  		//会员伞下层数
93 		uint32 floors;
94 		//会员推荐人数
95 		uint32 ref_num; 
96 
97 		//会员连接ID，数组下标
98 		uint32 parent_id;
99 		//会员推荐人ID，数组下标
100 		uint32 ref_id;
101 
102 		//会员伞下团队人数（不包括自己）
103 		uint32 team_num;
104 
105 		//下一个伞下成员将要存放的位置
106 		uint32 next_id;
107 		//会员子代，三轨
108 		uint32[3] children;
109 
110 		//会员已实现收益(1元奖金+直接推荐费) eth*10^4 保留小数点后4位
111 		uint64 base_earnings;
112 		//高阶人才补助收益 eth*10^4 保留小数点后4位
113 		uint64 adv_earnings;
114 		//会员第18层vip收益 eth*10^4 保留小数点后4位
115 		uint64 vip18_earnings;
116 		//会员vip收益 eth*10^4 保留小数点后4位
117 		uint64 vip_earnings;
118 		//会员已提现收益 eth*10^4 保留小数点后4位
119 		uint64 withdraw_earnings;
120 	}
121  
122 	Player[] players;
123 	mapping (address => uint32) public playerIdx;
124     mapping (uint32 => address) public id2Addr;
125  
126 	/**
127 	* 获取会员排位信息
128 	*/
129   	function get_player_pos_info(address addr) external view 
130   	returns(
131   		address parent_addr, //会员连接人地址
132   		address ref_addr, //会员推荐人地址
133 		address children1, //会员子接点1地址
134 		address children2, //会员子接点2地址
135 		address children3, //会员子接点3地址
136 		uint8 adv_level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
137 		uint8 vip_ratio,//VIP的奖金比例 单位：*100
138 		uint8 pindex, //在父连接点的位置（0-2）
139 		uint8 nextidx, //下一个伞下成员将要存放的位置的系统号（0-2）
140 		uint32 gen_num, //会员代数，从1开始 
141 		uint32 nextid,//下一个伞下成员将要存放的位置
142 		uint32 playerId //会员Id
143   		){
144 	 		uint32 playId = playerIdx[addr];
145 			if(playId == 0){//如果playId为0, 说明用户不存在
146 				return(address(0), address(0), address(0), address(0), address(0), 0, 0, 0, 0, 0, 0, 0); //the address have not join the game
147 			}
148 			Player storage _p = players[playId];
149  			return(id2Addr[_p.parent_id], id2Addr[_p.ref_id], 
150  				_p.children[0] > 0 ? id2Addr[_p.children[0]]:address(0), 
151  				_p.children[1] > 0 ? id2Addr[_p.children[1]]:address(0), 
152  				_p.children[2] > 0 ? id2Addr[_p.children[2]]:address(0), 
153  				_p.adv_level,_p.vip_ratio,_p.pindex, _p.next_idx, _p.gen_num, _p.next_id, playId);
154 	}
155 
156 	/**
157 	* 获取会员排位 Id 信息
158 	*/
159   	function get_player_pos_id_info(uint32 playId) external view 
160   	returns(
161   		uint8 pindex, //在父连接点的位置（0-2）
162 		uint8 nextidx, //下一个伞下成员将要存放的位置的系统号（0-2）
163 		uint8 adv_level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
164 		uint8 vip_ratio,//VIP的奖金比例 单位：*100
165 		uint32 gen_num, //会员代数，从1开始 
166   		uint32 parentId, //会员连接人Id
167   		uint32 refId, //会员推荐人Id
168 		uint32 children1, //会员子接点1 Id
169 		uint32 children2, //会员子接点2  Id
170 		uint32 children3, //会员子接点3  Id
171 		uint32 nextid,//下一个伞下成员将要存放的位置
172 		address addr //会员地址
173   		){
174 			if(playId < 1 || playId >= players.length){//说明用户不存在
175 				return(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, address(0)); //the address have not join the game
176 			}
177 			Player storage _p = players[playId];
178 			addr = id2Addr[playId];
179  			return(_p.pindex, _p.next_idx,_p.adv_level,_p.vip_ratio, _p.gen_num, _p.parent_id, _p.ref_id, _p.children[0], _p.children[1], _p.children[2], _p.next_id, addr);
180 	}
181 
182 	/**
183 	* 获取会员总人数
184 	*/
185   	function get_player_count() external view 
186   	returns(uint32){
187   		return uint32(players.length - 1);
188   	}
189 	/**
190 	* 获取会员基本信息
191 	*/
192   	function get_player_base_info(address addr) external view 
193   	returns(
194 		uint8 adv_level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
195 		uint8 vip_ratio,//VIP的奖金比例 单位：*100
196 		uint32 ref_num,//会员推荐人数
197 		uint32 floors, //会员伞下层数
198 		uint32 playerId, //会员Id
199 		uint32 team_num,//会员伞下团队人数（不包括自己）
200 		uint64 join_timestamp //会员加入时间，相对于基准时间TIME_BASE
201   		){
202 	 		uint32 playId = playerIdx[addr];
203 			if(playId == 0){//如果playId为0, 说明用户不存在
204 				return(0, 0, 0, 0, 0, 0, 0); //the address have not join the game
205 			}
206 			Player storage _p = players[playId];
207  			return( _p.adv_level, _p.vip_ratio, _p.ref_num,  _p.floors, playId, _p.team_num, uint64(_p.join_timestamp+TIME_BASE));
208 	}
209 
210 	/**
211 	* 获取会员收益信息
212 	*/
213   	function get_player_earning_info(address addr) external view 
214   	returns(
215   		uint16 burn_times,//总被烧伤次数
216 		uint16 slide_times,//获得滑落奖金次数
217 		uint32 playerId, //会员Id
218 		uint64 base_earnings, //会员已实现收益(1元奖金+直接推荐费)
219 		uint64 adv_earnings, //高阶人才补助收益 eth*10^4 保留小数点后4位
220 		uint64 vip_earnings, //会员vip收益 eth*10^4 保留小数点后4位
221 		uint64 vip18_earnings, //会员在18层上获得的vip收益 eth*10^4 保留小数点后4位
222 		uint64 withdraw_earnings//会员已提现收益 eth*10^4 保留小数点后4位
223   		){
224 	 		playerId = playerIdx[addr];
225 			if(playerId == 0){//如果playId为0, 说明用户不存在
226 				return(0, 0, 0, 0, 0, 0, 0, 0);
227 			}
228 			Player storage _p = players[playerId];
229  			return(_p.burn_times, _p.slide_times, playerId, _p.base_earnings, _p.adv_earnings, _p.vip_earnings, _p.vip18_earnings, _p.withdraw_earnings);
230 	}
231 
232 	/**
233 	* 获取会员vip信息
234 	*/
235   	function get_player_vip_info(address addr) external view 
236   	returns(
237 		uint8 ratio,//VIP的奖金比例 单位：*100
238 		uint16 vip_num1,//第一条线VIP人数
239 		uint16 vip_num2,//第二条线VIP人数
240 		uint16 vip_num3,//第三条线VIP人数
241 		uint32 playerId, //会员Id
242 		uint64 vipearnings,//在VIP级别上获得的收益 单位：eth*10000
243 		uint64 vip18earnings,//在18层上获得的收益 单位：eth*10000
244 		uint64 vip_up_timestamp //会员vip升级时间，相对于基准时间TIME_BASE
245   		){
246 	 		playerId = playerIdx[addr];
247 			if(playerId == 0){//如果playId为0, 说明用户不存在
248 				return(0, 0, 0, 0, 0, 0, 0, 0); //the address have not join the game
249 			}
250 			Player storage _p = players[playerId];
251  			return(_p.vip_ratio, _p.vipN[0], _p.vipN[1], _p.vipN[2], playerId, _p.vip_earnings, _p.vip18_earnings, _p.vip_up_timestamp == 0 ? 0: uint64(_p.vip_up_timestamp+TIME_BASE));
252 	}
253 
254 	/**
255 	* 获取高阶会员信息
256 	*/
257   	function get_player_adv_info(address addr) external view 
258   	returns(
259 		uint8 level,//高阶身份级别(0-普通,1-高阶人才,2- 一星高阶人才,3-二星高阶人才,4-三星高阶人才,5-四星高阶人才,6-五星高阶人才)
260 		uint8 m2_count,//下属2层总会员数
261 		uint8 m3_count,//下属3层总会员数
262 		uint16 advN1,//第一条线上高阶人才数
263 		uint16 advN2,//第二条线上高阶人才数
264 		uint16 advN3,//第三条线上高阶人才数
265 		uint32 playerId //会员Id
266   		){
267 	 		playerId = playerIdx[addr];
268 			if(playerId == 0){//如果playId为0, 说明用户不存在
269 				return(0, 0, 0, 0, 0, 0, 0); //the address have not join the game
270 			}
271 			Player storage _p = players[playerId];
272  			return( _p.adv_level, _p.m2_count, _p.m3_count, _p.advN[0], _p.advN[1],  _p.advN[2], playerId);
273 	}
274  
275 	constructor() public {
276 		Player memory _player = Player({
277             parent_id: 0,
278             ref_id:0, 
279 	 		join_timestamp: uint32(block.timestamp-TIME_BASE),
280             gen_num: 1,
281          	floors: 0,
282             team_num: 0,
283             ref_num: 0,
284             burn_times: 0,
285             slide_times: 0,
286             next_id: 1,
287             next_idx: 0,
288             pindex: 0,
289             m2_count: 0,
290             m3_count: 0,
291             adv_level: 0,
292             vip_ratio:0,
293             auth_code:0,
294             advN:[uint16(0),0,0],
295 			vipN:[uint16(0),0,0],
296          	children:[uint32(0),0,0],
297 			vip_up_timestamp:0,
298 			base_earnings: 0,
299 			adv_earnings: 0,
300 			vip_earnings:0,
301 			vip18_earnings:0,
302 			withdraw_earnings: 0
303         });
304 		//加入根节点
305 		players.push(_player);
306 		players.push(_player); //多复制一次，目的是使第一个元素的数组下标为1，ID也为1，方便后面的逻辑判断
307 		uint32 playerId = uint32(players.length - 1);
308 		playerIdx[ROOT_ADDR] = playerId;
309 		id2Addr[playerId] = ROOT_ADDR;
310 		//sn2Id[_player.player_sn] = playerId;
311 	}
312 	
313  	fallback() external {
314 	}
315 	receive() payable external {
316 	   //currentBalance = address(this).balance + msg.value;
317 	}
318 	//function() payable external{ }
319 	modifier onlyAdmin() {
320 		require(msg.sender == ADMIN_ADDR);
321 		_;
322 	}
323 	modifier onlyOperator() {
324 		require(msg.sender == op_addr);
325 		_;
326 	}
327  
328  	/**
329 	* 设置操作员,由管理员操作
330 	* opAddr 操作员地址
331 	*/
332 	function setOperator(address opAddr) public onlyAdmin{
333 		op_addr = opAddr;
334 	}
335 	/**
336 	* 获取操作员地址
337 	*/
338 	function getOperator() external view onlyOperator returns(
339 		address addr
340 	){
341 		return op_addr;
342 	}
343 	/*
344 	function grand() internal view returns(uint16) {
345         uint256 random = uint256(keccak256(abi.encode(block.timestamp)));
346         return uint16(10000+random%50000);
347     }*/
348 
349 	/**
350 	* 参与游戏
351 	* refaddr：推荐人地址
352 	* paddr：接点人地址(指定为推荐人地址则自动分配)
353 	*/
354 	function join(address refaddr, address paddr) public payable 
355 	returns(
356 		uint32 playerId
357 	){
358 		require(msg.value/WEI_ETH2 == 25 , "Amount is invalid");//激活金额为0.25个ETH
359 
360 		playerId = playerIdx[msg.sender];
361  		require(playerId == 0 , "You are already registered");//激活金额为0.25个ETH
362 
363 		uint8 status;
364 		uint8 index;
365 		uint32 refId;
366 		uint32 parentId;
367         uint32 nextid;
368 
369 		(refId, parentId, index, status) = calc_player_pos_info(refaddr, paddr);
370 		if(status == 1) revert("Parent has no free connect points");
371 		if(status == 2) revert("The parent does not exist");
372 		require(players[parentId].children[index] == 0 , "parent is invalid");//确保父节点上的点位没有被占位
373 		require(players[parentId].gen_num < 4294967295 , "gen_num is too large");//确保层深不会溢出
374 		require(players.length < 4294967295 , "The number exceeds the limit");//42亿
375 		//require(parentId != 0 , "Parent is invalid!");//确保父节点上的点位没有被占位
376 		//uint16 authcode = grand();
377 
378 		playerId = uint32(players.length);
379 		//函数中声明并创建结构体需要使用memory关键字
380 		Player memory _player = Player({
381             parent_id: parentId,
382          	ref_id: refId,
383             next_id: playerId,
384             next_idx: 0,
385 	 		join_timestamp: uint32(block.timestamp-TIME_BASE),
386             gen_num: players[parentId].gen_num+1,
387             floors: 0,
388             team_num: 0,
389             ref_num: 0,
390             burn_times: 0,
391             slide_times: 0,
392             pindex: index,
393             m2_count: 0,
394             m3_count: 0,
395             adv_level: 0,
396            	vip_ratio:0,
397             auth_code:0,
398             advN:[uint16(0),0,0],
399 			vipN:[uint16(0),0,0],
400          	children:[uint32(0),0,0],
401 			vip_up_timestamp:0,
402 			base_earnings: 0,
403 			adv_earnings: 0,
404 			vip_earnings:0,
405 			vip18_earnings:0,
406 			withdraw_earnings: 0
407         });
408 		players.push(_player);
409 		//playerId = uint64(players.length - 1);
410 		playerIdx[msg.sender] = playerId;
411 		id2Addr[playerId] = msg.sender;
412 		players[parentId].children[index] = playerId;
413  		//修改推荐人数
414 		players[refId].ref_num++;
415   		
416   		//直接推荐费 0.075ETH
417 		players[refId].base_earnings = players[refId].base_earnings.add(750);
418   		
419 		join_calc(_player, parentId);
420 		emit ev_join(msg.sender, id2Addr[parentId], id2Addr[refId], index, playerId, _player.gen_num, msg.value); //触发会员参与游戏事件
421 		 
422 		return playerId;
423 	}
424 
425 
426 	function join_calc(Player memory _player, uint32 parentId) internal{
427 		uint8 tidx;
428   		uint8 advLevel;
429   		uint16 advNum;
430   		uint32 nlayers;
431  		uint32 nextid;
432   		uint64 diff;
433   		Player storage _p;
434   		Player storage _tplayer;
435   		for(uint32 i=_player.gen_num; i>1; i--){
436 			_p = players[parentId];
437 			//往上计算每个父点位的  下一个伞下成员将要存放的位置
438 			 _tplayer = players[_p.next_id];
439  
440 			if(_tplayer.gen_num > 0 && _tplayer.children[_p.next_idx] > 0){ //被占用
441 				uint8 nextidx = (_p.next_idx+1) % 3;
442 				if(_tplayer.children[nextidx] > 0){
443 					nextidx = (nextidx+1) % 3; //排位占用，继续找
444 					if(_tplayer.children[nextidx] > 0) nextidx = 3; //说明该位置的3个子节点都放满，需要另外找一个空闲位置
445 				}
446 				if(nextidx > 2){
447 					//取3个孩子伞下 下一个成员将要存放的位置 和当前节点层差最小的 做为本节点的下一个位置
448 					uint32 uNext0 = players[_p.children[0]].next_id;
449 					uint32 uNext1 = players[_p.children[1]].next_id;
450 					uint32 uNext2 = players[_p.children[2]].next_id;
451 					nextid = players[uNext0].gen_num > players[uNext1].gen_num ? uNext1 : uNext0;
452 					nextid = players[nextid].gen_num > players[uNext2].gen_num ? uNext2 : nextid;
453 					nextidx = players[nextid].next_idx;
454 					_p.next_id = nextid;
455 				}
456 				_p.next_idx = nextidx;
457 			}
458 
459 
460 			if(advNum > 0){
461 				if(MAX_UINT16 - _p.advN[tidx] > advNum) _p.advN[tidx]+=advNum; //父节点这条线上的高阶人才数增加,溢出检查
462 				else _p.advN[tidx] = MAX_UINT16;
463 
464 				if(_p.adv_level > 1){
465 					advLevel = get_adv_level(_p.advN);
466 					if(_p.adv_level != advLevel){
467 						emit ev_adv_up(id2Addr[parentId], parentId, _p.adv_level, advLevel); //高阶人才升级
468 						_p.adv_level = advLevel;	
469 					}
470 				}
471 			}
472 			//父点位团队人数加1，显示用，溢出不管
473 			_p.team_num++; 
474 
475 			//计算收益
476 			//1 元奖金 拿自己伞下 18 层
477 			if(_player.gen_num - _p.gen_num < 19){
478 				//_p.base_earnings = _p.base_earnings.add(uint64(msg.value/WEI_ETH4 / 100));
479 				_p.base_earnings = _p.base_earnings.add(uint64(msg.value/WEI_ETH2));
480 			}
481 			//高阶人才补助
482 			if(_p.adv_level > 0){
483 				if(ADV_ALLOWANCE[_p.adv_level] > diff){
484 					_p.adv_earnings = _p.adv_earnings.add(ADV_ALLOWANCE[_p.adv_level] - diff);
485 					//emit ev_bonus(id2Addr[parentId], parentId, msg.sender, ADV_ALLOWANCE[_p.adv_level] - diff, "adv allowance"); //获得收益事件
486 					diff = ADV_ALLOWANCE[_p.adv_level];
487 				}
488 			}
489 
490 			nlayers = _player.gen_num - _p.gen_num;
491 			//高阶人才前3层人数判断
492 			if(nlayers < 4){
493 				_p.m3_count++; //只记录伞下3层内的会员数，用于高阶升级判断
494 				if(nlayers < 3) _p.m2_count++;
495 				if( _p.m2_count >=12 && _p.adv_level == 0){
496 					 _p.adv_level = 1; //成为初级人才
497 					 emit ev_adv_up(id2Addr[parentId], parentId, 0, 1); //人才升级
498 				}
499 				if(_p.m3_count >=39 && _p.adv_level == 1){
500 					 _p.adv_level = 2; //成为高阶人才
501 					 emit ev_adv_up(id2Addr[parentId], parentId, 1, 2); //高阶人才升级
502 					 advNum ++;
503 					 tidx = _p.pindex;
504 				}
505 
506 				if(_p.adv_level > 1){
507 					advLevel = get_adv_level(_p.advN);
508 					if(_p.adv_level != advLevel){
509 						emit ev_adv_up(id2Addr[parentId], parentId, _p.adv_level, advLevel); //高阶人才升级
510 						_p.adv_level = advLevel;	
511 					}
512 				}
513 			}
514 			//计算会员伞下层数
515 			if(nlayers > _p.floors) {
516 				_p.floors = nlayers;
517 			}
518 			parentId = _p.parent_id;
519   		}
520 	}
521 	/**
522 	* 激活钻石vip系统
523 	* 返回值： 成功返回true
524 	*/
525 	function active_vip() public payable 
526 	returns(
527 		bool bOk
528 	){
529 		//for test comment
530 		require(msg.value/WEI_ETH2 == 10, "Amount is invalid.");
531 		
532 		uint32 playId = playerIdx[msg.sender];
533 		require(playId > 0, "You have not registered");
534  
535 		require(players[playId].vip_ratio == 0, "The vip system has been activated");
536 
537 		Player storage _p = players[playId];
538 		//_p.vip_level = 1;
539 		_p.vip_up_timestamp = uint32(block.timestamp-TIME_BASE);
540 		_p.vip_ratio=get_vip_ratio(_p.vipN);
541  		uint8 ratio;
542 		uint32 gnum = _p.gen_num;
543 		uint32 parentId = _p.parent_id;
544 		uint64 diff;
545 		uint64 val = uint64(msg.value / WEI_ETH2);
546 		while(gnum > 1){
547 
548 			//这条线VIP人数增加
549 			if(players[parentId].vipN[_p.pindex] < MAX_UINT16){
550 				players[parentId].vipN[_p.pindex] += 1;
551 			}
552  			_p = players[parentId];
553 
554  			//计算VIP 系统奖励 
555 			if(_p.vip_ratio > diff){
556 				_p.vip_earnings = _p.vip_earnings.add(val*(_p.vip_ratio-diff)); //这里不用再除100，因为前面val 已多除100， vip_earnings 的单位是 eth * 10^4
557 				diff = _p.vip_ratio;
558 				//emit ev_bonus(id2Addr[parentId], id2Addr[playId], val*(_p.vip_ratio-diff), "vip up"); //获得收益事件
559 			}
560 			if(_p.vip_ratio > 0){ //自己必须先激活VIP
561 				ratio=get_vip_ratio(_p.vipN); //根据各条线的人数，设置奖金比例
562 				if(ratio != _p.vip_ratio){
563 					_p.vip_ratio = ratio;
564 					//emit ev_vip_up(id2Addr[parentId], parentId, uint64(_p.vip_up_timestamp+TIME_BASE), _p.vip_ratio); //Vip升级事件
565 				}
566 			}
567 			parentId = _p.parent_id;
568 			gnum --;
569   		}
570   		emit ev_vip_up(id2Addr[playId], playId, uint64(players[playId].vip_up_timestamp+TIME_BASE),players[playId].vip_ratio); //Vip升级事件
571 	}
572 	/**
573 	* 根据节点VIP 人数，确定收益比例
574 	* 返回值：收益比例 单位: *100
575 	*/
576 	function get_vip_ratio(uint16[3] memory nVipN) internal pure returns (uint8){
577 		uint16 nmin = min16(nVipN[0], nVipN[1], nVipN[2]);
578 		uint16 n;
579 		if(nVipN[0] > 0) n += 1;
580 		if(nVipN[1] > 0) n += 1;
581 		if(nVipN[2] > 0) n += 1;
582 		if(n < 3){
583 			if(n == 0) return 20;
584 			if(n == 1) return 25;
585 			if(n == 2) return 30;
586 		}else{
587 			if(nmin < 20) return 35; //三个下属系统中都有会员成功升级成为⾦级VIP会员。
588 			if(nmin < 50) return 40;  //数量最少的⼀个系统达到了20个但小于50
589  			if(nmin < 100) return 45;
590 			if(nmin < 500) return 50;
591 			if(nmin < 1000) return 60;
592 			if(nmin < 10000) return 70;
593 			else return 70;
594 		}
595 	}
596 
597 	/**
598 	* 根据节点高阶人才数 ，确定高阶等级
599 	* 返回值：高阶身份级别(0:普通,1:初级人才,2:高阶人才,3:一星,4-二星,5-三星,6-四星,7-五星,8-银级,9-金级,10-铂金,11-钻石,12-金钻,13-蓝宝石,14-翡翠级,15-荣誉星钻级)
600 	*/
601 	function get_adv_level(uint16[3] memory nAdvN) internal pure returns (uint8){
602 		uint16 nmin = min16(nAdvN[0], nAdvN[1], nAdvN[2]);
603 		uint16 n;
604 		if(nAdvN[0] > 0) n += 1;
605 		if(nAdvN[1] > 0) n += 1;
606 		if(nAdvN[2] > 0) n += 1;
607 		if(n < 3){
608 			if(n == 0) return 2;
609 			if(n == 1) return 3;
610 			if(n == 2) return 4;
611 		}else{
612 			if(nmin < 10) return 5; //3星高阶人才，三条线各培养一个高阶人才及以上等级
613 			if(nmin < 30) return 6;
614 			if(nmin < 60) return 7;
615 			if(nmin < 100) return 8;
616 			if(nmin < 500) return 9;
617 			if(nmin < 1000) return 10;
618 			if(nmin < 5000) return 11;
619 			if(nmin < 10000) return 12;
620 			if(nmin < 100000) return 13;
621 			if(nmin < 1000000) return 14;
622 			else return 15;
623 		}
624 	}
625 
626 	/**
627 	* 根据确定点位, refaddr 为推荐人地址， paddr为接点人地址(可选，指定为推荐人地址则自动分配)
628 	* 返回值：refId为推荐人Id, parentId为连接人Id，index 为在连接人children的数组索引，status: 0正常，1接点人没有空位，2接点人不存在
629 	*/
630 	function calc_player_pos_info(address refaddr, address paddr) internal view
631 	returns (
632 		uint32 refId,
633         uint32 parentId,
634         uint8 index,
635         uint8 status
636     ){
637     	if(refaddr == address(0)){
638 			refId = playerIdx[ROOT_ADDR];
639 		}else{
640 			refId = playerIdx[refaddr]; //如果refaddr没参与游戏，那么refId自动为0，
641 		}
642 	 	if(paddr == refaddr){
643 			paddr = id2Addr[refId];
644 			parentId = playerIdx[paddr];
645 		}else{//指定接点人，就必须直接接到他下面
646 			parentId = playerIdx[paddr]; 
647 			if(parentId == 0){//如果paddr没参与游戏, 返回
648 				return (0, 0, 0, 2);
649 			}
650 			if(players[parentId].children[0] == 0) index = 0;
651 			else if(players[parentId].children[1] == 0) index = 1;
652 			else if(players[parentId].children[2] == 0) index = 2;
653 			else status = 1;//接点人没有空闲位
654 			return (refId, parentId, index, status);  
655 		}
656   		parentId = players[parentId].next_id;
657 		if(players[parentId].children[0] == 0) index = 0;
658 		else if(players[parentId].children[1] == 0) index = 1;
659 		else if(players[parentId].children[2] == 0) index = 2;
660 		else status = 1; //不合法的parent? 永远不会发生
661 		return (refId, parentId, index, status);
662 	}
663    
664 	/**
665 	* 提现,全部提现
666 	*/
667 	function withdraw()
668 	public {
669 		uint32 playId = playerIdx[msg.sender];
670 		require(playId > 0, "You have not registered");
671  		//uint256 wval = val*WEI_ETH2;
672 		Player storage _p = players[playId];
673 		uint256  totalEarnings = uint256(_p.base_earnings) + _p.adv_earnings + _p.vip_earnings  + _p.vip18_earnings;//总收益,   单位eth*10^4
674 		require(_p.withdraw_earnings <= totalEarnings);
675 		 
676 		uint256 undrawnEarnings = totalEarnings - _p.withdraw_earnings;//未提现余额 = 总收益-减已提现收益
677 		totalEarnings = undrawnEarnings*WEI_ETH4; //将单位eth*10^4 转换为wei
678 		require(totalEarnings / undrawnEarnings == WEI_ETH4, "undrawn earnings invalid"); //转换合法性检查
679 
680 		//require(totalEarnings >= wval, "Not enough balance."); //余额检查
681 		require(address(this).balance >= totalEarnings, "Contract is not enough balance.");//合约余额检查
682         
683         uint64 withdrawVal = uint64(undrawnEarnings);
684         
685 		_p.withdraw_earnings = _p.withdraw_earnings.add(withdrawVal); //先扣除
686 		msg.sender.transfer(totalEarnings);
687 		//触发提现事件
688 		emit ev_withdraw(msg.sender, playId, withdrawVal, "player");
689 	}
690 
691 
692 	/**
693 	* 管理员提现
694 	* val: 要提现的额度，单位eth*10^2
695 	*/
696 	function withdraw_admin(uint256 val) public payable onlyAdmin{
697 		val = val * WEI_ETH2; //将单位eth*10^2 转换为wei
698 		require(val <= address(this).balance, "Not enough balance.");
699 		address(uint160(ADMIN_ADDR)).transfer(val);
700 		//触发提现事件
701 		emit ev_withdraw(ADMIN_ADDR, 0, val,"admin");
702 	}
703 
704  	function min16(uint16 a, uint16 b, uint16 c) internal pure returns (uint16) {
705         uint16	d =  a > b ? b : a;
706 		return d > c ? c : d;
707     }
708 
709 	/**
710 	* 设置会员18层vip收益,由中心化管理员操作
711 	* playId 会员Id
712 	* val： 18层总收益，单位 ETH * 10^4
713 	* burnTimes： 被烧伤次数
714 	* slideTimes： 获得滑落奖金次数
715 	*/
716 	function op_set_vip18_earnings(uint32 playId, uint64 val, uint16 burnTimes, uint16 slideTimes) external onlyOperator{
717 		require(id2Addr[playId] != address(0), "playId have not registered");
718 		Player storage _p = players[playId];
719 		_p.vip18_earnings = val;
720 	 	_p.slide_times = slideTimes; //滑落次数
721 		_p.burn_times = burnTimes; //烧伤次数
722 		emit ev_set_vip18_bonus(id2Addr[playId], playId, burnTimes, slideTimes, val, "set vip18 earnings"); //设置VIP收益事件
723  	}
724 
725 	 /**
726 	* 设置会员排位参数, 由管理员操作
727 	* playId  会员Id
728 	* nextid 下一个伞下成员将要存放的位置
729 	* nextidx： 下一个伞下成员将要存放的位置系统号（0-2）
730 	*/
731 	function op_set_next_param(uint32 playId, uint32 nextid, uint8 nextidx) external onlyOperator{
732 		require(id2Addr[playId] != address(0), "playId have not registered");
733 		Player storage _p = players[playId];	
734 		_p.next_id=nextid;
735 		_p.next_idx=nextidx;
736 		emit ev_op_setting(msg.sender, playId, "set next param"); //后台操作员设置参数
737  	}
738 	//设置会员收益,该接口正常用不到，需以管理员身份调用
739 	function op_set_earnings_param(uint32 playId,  uint64 baseEarnings, uint64 advEarnings, uint64 vipEarnings, uint64 vip18Earnings, uint64 withdrawEarnings) external onlyAdmin{
740 		require(id2Addr[playId] != address(0), "playId have not registered");
741 		Player storage _p = players[playId];	
742 		 _p.base_earnings=baseEarnings;
743 		 _p.adv_earnings=advEarnings;
744 		 _p.vip_earnings=vipEarnings;
745 		 _p.vip18_earnings=vip18Earnings;
746 		 _p.withdraw_earnings=withdrawEarnings;
747 		 emit ev_op_setting(msg.sender, playId, "set earnings param"); //后台操作员设置参数
748  	}
749 	//设置会员在各条线上的VIP、高阶人才人数, 该接口正常用不到，需以操作员身份调用
750 	function op_set_N_param(uint32 playId,  uint16[3] memory advN, uint16[3] memory vipN) external onlyOperator{
751 		require(id2Addr[playId] != address(0), "playId have not registered");
752 		Player storage _p = players[playId];	
753 		 _p.vipN[0] = vipN[0];
754 		 _p.vipN[1] = vipN[1];
755 		 _p.vipN[2] = vipN[2];
756 
757 		 _p.advN[0] = advN[0];
758 		 _p.advN[1] = advN[1];
759 		 _p.advN[2] = advN[2];
760 		 emit ev_op_setting(msg.sender, playId, "set N param"); //后台操作员设置参数
761  	}
762 
763 	/**
764 	* 获取会员认证码
765 	*/
766 	function get_authcode(address addr) external view onlyAdmin returns (uint16) {
767 		uint32 playId = playerIdx[addr];
768 		require(playId > 0, "The address have not registered");
769 		return players[playId].auth_code;
770  	}
771 
772 	/**
773 	* 设置会员认证码
774 	*/
775 	function set_authcode(uint16 authcode) external{
776 		uint32 playId = playerIdx[msg.sender];
777 		require(playId > 0, "The address have not registered");
778 		players[playId].auth_code = authcode;
779  	}
780 	/**
781 	* 认证
782 	*/
783 	function auth(address addr, uint16 authcode) external view returns(bool){
784 		uint32 playId = playerIdx[addr];
785 		if(playId == 0) return false;
786 		if(authcode == 0) return false;
787 		return authcode == players[playId].auth_code ? true : false;
788 	}
789 }
790 
791 library SafeMath64 {
792     function mul(uint64 a, uint64 b) internal pure returns (uint64) {
793         if (a == 0) {
794             return 0;
795         }
796         uint64 c = a * b;
797         require(c / a == b);
798         return c;
799     }
800     function sub(uint64 a, uint64 b) internal pure returns (uint64) {
801         require(b <= a);
802         uint64 c = a - b;
803         return c;
804     }
805     function add(uint64 a, uint64 b) internal pure returns (uint64) {
806         uint64 c = a + b;
807         require(c >= a);
808         return c;
809     }
810 }