1 pragma solidity ^ 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 安全的加减乘除
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7 	function add(uint a, uint b) internal pure returns(uint c) {
8 		c = a + b;
9 		require(c >= a);
10 	}
11 
12 	function sub(uint a, uint b) internal pure returns(uint c) {
13 		require(b <= a);
14 		c = a - b;
15 	}
16 
17 	function mul(uint a, uint b) internal pure returns(uint c) {
18 		c = a * b;
19 		require(a == 0 || c / a == b);
20 	}
21 
22 	function div(uint a, uint b) internal pure returns(uint c) {
23 		require(b > 0);
24 		c = a / b;
25 	}
26 }
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 // ----------------------------------------------------------------------------
32 contract ERC20Interface {
33 	function totalSupply() public constant returns(uint);
34 
35 	function balanceOf(address tokenOwner) public constant returns(uint balance);
36 
37 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
38 
39 	function transfer(address to, uint tokens) public returns(bool success);
40 
41 	function approve(address spender, uint tokens) public returns(bool success);
42 
43 	function transferFrom(address from, address to, uint tokens) public returns(bool success);
44 
45 	event Transfer(address indexed from, address indexed to, uint tokens);
46 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
47 }
48 
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
56 }
57 
58 // ----------------------------------------------------------------------------
59 // 管理员
60 // ----------------------------------------------------------------------------
61 contract Owned {
62 	address public owner;
63 	address public newOwner;
64 
65 	event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67 	constructor() public {
68 		owner = msg.sender;
69 	}
70 
71 	modifier onlyOwner {
72 		require(msg.sender == owner);
73 		_;
74 	}
75 
76 	function transferOwnership(address _newOwner) public onlyOwner {
77 		newOwner = _newOwner;
78 	}
79 
80 	function acceptOwnership() public {
81 		require(msg.sender == newOwner);
82 		emit OwnershipTransferred(owner, newOwner);
83 		owner = newOwner;
84 		newOwner = address(0);
85 	}
86 }
87 
88 // ----------------------------------------------------------------------------
89 // 核心类
90 // ----------------------------------------------------------------------------
91 contract BTYCToken is ERC20Interface, Owned {
92 	using SafeMath
93 	for uint;
94 
95 	string public symbol;
96 	string public name;
97 	uint8 public decimals;
98 	uint _totalSupply;
99 
100 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
101 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
102 	uint public sysPrice; //挖矿的衡量值
103 	uint public sysPer; //挖矿的增量百分比 /100
104 	uint public givecandyto; //奖励新人 
105 	uint public givecandyfrom; //奖励推荐人
106 	uint public candyper; //转账多少给奖励
107 	bool public actived;
108 
109 	uint public sendPer; //转账分佣百分比
110 	uint public sendPer2; //转账分佣百分比
111 	uint public sendPer3; //转账分佣百分比
112 	uint public sendfrozen; //转账冻结百分比 
113 
114 	uint public onceOuttime; //增量的时间 测试  
115 	uint public onceAddTime; //挖矿的时间 测试
116 
117 	mapping(address => uint) balances;
118 	mapping(address => uint) used;
119 	mapping(address => mapping(address => uint)) allowed;
120 
121 	/* 冻结账户 */
122 	mapping(address => bool) public frozenAccount;
123 
124 	//释放 
125 	mapping(address => uint[]) public mycantime; //时间
126 	mapping(address => uint[]) public mycanmoney; //金额
127 	//上家地址
128 	mapping(address => address) public fromaddr;
129 	//管理员帐号
130 	mapping(address => bool) public admins;
131 	// 记录各个账户的增量时间
132 	mapping(address => uint) public cronaddOf;
133 
134 	/* 通知 */
135 	event FrozenFunds(address target, bool frozen);
136 	// ------------------------------------------------------------------------
137 	// Constructor
138 	// ------------------------------------------------------------------------
139 	constructor() public {
140 
141 		symbol = "BTYC";
142 		name = "BTYC Coin";
143 		decimals = 18;
144 		_totalSupply = 86400000 ether;
145 
146 		sellPrice = 0.000526 ether; //出售价格 1btyc can buy how much eth
147 		buyPrice = 1128 ether; //购买价格 1eth can buy how much btyc
148 		sysPrice = 766 ether; //挖矿的衡量值
149 		sysPer = 225; //挖矿的增量百分比 /100
150 		candyper = 1 ether;
151 		givecandyfrom = 10 ether;
152 		givecandyto = 40 ether;
153 		sendPer = 3;
154 		sendPer2 = 2;
155 		sendPer3 = 1;
156 		sendfrozen = 80;
157 		actived = true;
158 		onceOuttime = 1 days; //增量的时间 正式 
159 		onceAddTime = 10 days; //挖矿的时间 正式
160 
161 		//onceOuttime = 30 seconds; //增量的时间 测试  
162 		//onceAddTime = 60 seconds; //挖矿的时间 测试
163 		balances[owner] = _totalSupply;
164 		emit Transfer(address(0), owner, _totalSupply);
165 
166 	}
167 
168 	/* 获取用户金额 */
169 	function balanceOf(address tokenOwner) public view returns(uint balance) {
170 		return balances[tokenOwner];
171 	}
172 	/*
173 	 * 添加金额，为了统计用户的进出
174 	 */
175 	function addmoney(address _addr, uint256 _money, uint _day) private {
176 		uint256 _days = _day * (1 days);
177 		uint256 _now = now - _days;
178 		mycanmoney[_addr].push(_money);
179 		mycantime[_addr].push(_now);
180 
181 		if(balances[_addr] >= sysPrice && cronaddOf[_addr] < 1) {
182 			cronaddOf[_addr] = now + onceAddTime;
183 		}
184 	}
185 	/*
186 	 * 用户金额减少时的触发
187 	 * @param {Object} address
188 	 */
189 	function reducemoney(address _addr, uint256 _money) private {
190 		used[_addr] += _money;
191 		if(balances[_addr] < sysPrice) {
192 			cronaddOf[_addr] = 0;
193 		}
194 	}
195 	/*
196 	 * 获取用户的挖矿时间
197 	 * @param {Object} address
198 	 */
199 	function getaddtime(address _addr) public view returns(uint) {
200 		if(cronaddOf[_addr] < 1) {
201 			return(now + onceAddTime);
202 		}
203 		return(cronaddOf[_addr]);
204 	}
205 	/*
206 	 * 获取用户的可用金额
207 	 * @param {Object} address
208 	 */
209 	function getcanuse(address tokenOwner) public view returns(uint balance) {
210 		uint256 _now = now;
211 		uint256 _left = 0;
212 		if(tokenOwner == owner) {
213 			return(balances[owner]);
214 		}
215 		for(uint256 i = 0; i < mycantime[tokenOwner].length; i++) {
216 			uint256 stime = mycantime[tokenOwner][i];
217 			uint256 smoney = mycanmoney[tokenOwner][i];
218 			uint256 lefttimes = _now - stime;
219 			if(lefttimes >= onceOuttime) {
220 				uint256 leftpers = lefttimes / onceOuttime;
221 				if(leftpers > 100) {
222 					leftpers = 100;
223 				}
224 				_left = smoney * leftpers / 100 + _left;
225 			}
226 		}
227 		_left = _left - used[tokenOwner];
228 		if(_left < 0) {
229 			return(0);
230 		}
231 		if(_left > balances[tokenOwner]) {
232 			return(balances[tokenOwner]);
233 		}
234 		return(_left);
235 	}
236 
237 	/*
238 	 * 用户转账
239 	 * @param {Object} address
240 	 */
241 	function transfer(address to, uint tokens) public returns(bool success) {
242 		require(!frozenAccount[msg.sender]);
243 		require(!frozenAccount[to]);
244 		require(actived == true);
245 		uint256 canuse = getcanuse(msg.sender);
246 		require(canuse >= tokens);
247 		//如果用户没有上家
248 		if(fromaddr[to] == address(0)) {
249 			//指定上家地址
250 			fromaddr[to] = msg.sender;
251 			//如果转账金额大于糖果的标准值
252 			if(tokens >= candyper) {
253 				if(givecandyfrom > 0) {
254 					balances[msg.sender] = balances[msg.sender].sub(tokens).add(givecandyfrom);
255 					//balances[owner] = balances[owner].sub(givecandyfrom); //控制总额度,不空投 
256 					reducemoney(msg.sender, tokens);
257 					addmoney(msg.sender, givecandyfrom, 0);
258 				}
259 				if(givecandyto > 0) {
260 					tokens += givecandyto;
261 					//balances[owner] = balances[owner].sub(givecandyto); //控制总额度,不空投
262 				}
263 			} else {
264 				balances[msg.sender] = balances[msg.sender].sub(tokens);
265 				reducemoney(msg.sender, tokens);
266 			}
267 			balances[to] = balances[to].add(tokens);
268 			addmoney(to, tokens, 0);
269 			//tokens = candyuser(msg.sender, to, tokens);
270 		} else {
271             //先减掉转账的
272 			balances[msg.sender] = balances[msg.sender].sub(tokens);
273 			reducemoney(msg.sender, tokens);
274 			
275 			if(sendPer > 0 && sendPer <= 100) {
276 				//上家分润
277 				uint addfroms = tokens * sendPer / 100;
278 				address topuser1 = fromaddr[to];
279 				balances[topuser1] = balances[topuser1].add(addfroms);
280 				addmoney(topuser1, addfroms, 0);
281 				//balances[owner] = balances[owner].sub(addfroms); //控制总额度,空投
282 
283 				//如果存在第二层
284 				if(sendPer2 > 0 && sendPer2 <= 100 && fromaddr[topuser1] != address(0)) {
285 					uint addfroms2 = tokens * sendPer2 / 100;
286 					address topuser2 = fromaddr[topuser1];
287 					balances[topuser2] = balances[topuser2].add(addfroms2);
288 					addmoney(topuser2, addfroms2, 0);
289 					//balances[owner] = balances[owner].sub(addfroms2); //控制总额度,空投
290 					//如果存在第三层
291 					if(sendPer3 > 0 && sendPer3 <= 100 && fromaddr[topuser2] != address(0)) {
292 						uint addfroms3 = tokens * sendPer3 / 100;
293 						address topuser3 = fromaddr[topuser2];
294 						balances[topuser3] = balances[topuser3].add(addfroms3);
295 						addmoney(topuser3, addfroms3, 0);
296 						//balances[owner] = balances[owner].sub(addfroms3); //控制总额度,空投
297 
298 					}
299 				}
300 
301 				//emit Transfer(owner, msg.sender, addfroms);
302 
303 			}
304 
305 			balances[to] = balances[to].add(tokens);
306 			if(sendfrozen > 0 && sendfrozen <= 100) {
307 				addmoney(to, tokens, 100 - sendfrozen);
308 			} else {
309 				addmoney(to, tokens, 0);
310 			}
311 
312 		}
313 		emit Transfer(msg.sender, to, tokens);
314 		return true;
315 	}
316 	/*
317 	 * 获取真实值
318 	 * @param {Object} uint
319 	 */
320 	function getnum(uint num) public view returns(uint) {
321 		return(num * 10 ** uint(decimals));
322 	}
323 	/*
324 	 * 获取上家地址
325 	 * @param {Object} address
326 	 */
327 	function getfrom(address _addr) public view returns(address) {
328 		return(fromaddr[_addr]);
329 	}
330 
331 	function approve(address spender, uint tokens) public returns(bool success) {
332 		require(admins[msg.sender] == true);
333 		allowed[msg.sender][spender] = tokens;
334 		emit Approval(msg.sender, spender, tokens);
335 		return true;
336 	}
337 	/*
338 	 * 授权转账
339 	 * @param {Object} address
340 	 */
341 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
342 		require(actived == true);
343 		require(!frozenAccount[from]);
344 		require(!frozenAccount[to]);
345 		balances[from] = balances[from].sub(tokens);
346 		reducemoney(from, tokens);
347 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
348 		balances[to] = balances[to].add(tokens);
349 		addmoney(to, tokens, 0);
350 		emit Transfer(from, to, tokens);
351 		return true;
352 	}
353 
354 	/*
355 	 * 获取授权信息
356 	 * @param {Object} address
357 	 */
358 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
359 		return allowed[tokenOwner][spender];
360 	}
361 
362 	/*
363 	 * 授权
364 	 * @param {Object} address
365 	 */
366 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
367 		require(admins[msg.sender] == true);
368 		allowed[msg.sender][spender] = tokens;
369 		emit Approval(msg.sender, spender, tokens);
370 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
371 		return true;
372 	}
373 
374 	/// 冻结 or 解冻账户
375 	function freezeAccount(address target, bool freeze) public {
376 		require(admins[msg.sender] == true);
377 		frozenAccount[target] = freeze;
378 		emit FrozenFunds(target, freeze);
379 	}
380 	/*
381 	 * 设置管理员
382 	 * @param {Object} address
383 	 */
384 	function admAccount(address target, bool freeze) onlyOwner public {
385 		admins[target] = freeze;
386 	}
387 	/*
388 	 * 系统设置
389 	 * @param {Object} uint
390 	 */
391 	function setPrices(uint newonceaddtime, uint newonceouttime, uint newBuyPrice, uint newSellPrice, uint systyPrice, uint sysPermit, uint sysgivefrom, uint sysgiveto, uint sysgiveper, uint syssendfrozen, uint syssendper1, uint syssendper2, uint syssendper3) public {
392 		require(admins[msg.sender] == true);
393 		onceAddTime = newonceaddtime;
394 		onceOuttime = newonceouttime;
395 		buyPrice = newBuyPrice;
396 		sellPrice = newSellPrice;
397 		sysPrice = systyPrice;
398 		sysPer = sysPermit;
399 		givecandyfrom = sysgivefrom;
400 		givecandyto = sysgiveto;
401 		candyper = sysgiveper;
402 		sendfrozen = syssendfrozen;
403 		sendPer = syssendper1;
404 		sendPer2 = syssendper2;
405 		sendPer3 = syssendper3;
406 	}
407 	/*
408 	 * 获取系统设置
409 	 */
410 	function getprice() public view returns(uint addtime, uint outtime, uint bprice, uint spice, uint sprice, uint sper, uint givefrom, uint giveto, uint giveper, uint sdfrozen, uint sdper1, uint sdper2, uint sdper3) {
411 		addtime = onceAddTime;
412 		outtime = onceOuttime;
413 		bprice = buyPrice;
414 		spice = sellPrice;
415 		sprice = sysPrice;
416 		sper = sysPer;
417 		givefrom = givecandyfrom;
418 		giveto = givecandyto;
419 		giveper = candyper;
420 		sdfrozen = sendfrozen;
421 		sdper1 = sendPer;
422 		sdper2 = sendPer2;
423 		sdper3 = sendPer3;
424 	}
425 	/*
426 	 * 设置是否开启
427 	 * @param {Object} bool
428 	 */
429 	function setactive(bool tags) public onlyOwner {
430 		actived = tags;
431 	}
432 
433 	/*
434 	 * 获取总发行
435 	 */
436 	function totalSupply() public view returns(uint) {
437 		return _totalSupply.sub(balances[address(0)]);
438 	}
439 	/*
440 	 * 向指定账户拨发资金
441 	 * @param {Object} address
442 	 */
443 	function mintToken(address target, uint256 mintedAmount) public {
444 		require(!frozenAccount[target]);
445 		require(admins[msg.sender] == true);
446 		require(actived == true);
447 
448 		balances[target] = balances[target].add(mintedAmount);
449 		addmoney(target, mintedAmount, 0);
450 		//emit Transfer(0, this, mintedAmount);
451 		emit Transfer(owner, target, mintedAmount);
452 
453 	}
454 	/*
455 	 * 用户每隔10天挖矿一次
456 	 */
457 	function mint() public {
458 		require(!frozenAccount[msg.sender]);
459 		require(actived == true);
460 		require(cronaddOf[msg.sender] > 0);
461 		require(now > cronaddOf[msg.sender]);
462 		require(balances[msg.sender] >= sysPrice);
463 		uint256 mintAmount = balances[msg.sender] * sysPer / 10000;
464 		balances[msg.sender] = balances[msg.sender].add(mintAmount);
465 		//balances[owner] = balances[owner].sub(mintAmount);
466 		cronaddOf[msg.sender] = now + onceAddTime;
467 		emit Transfer(owner, msg.sender, mintAmount);
468 
469 	}
470 	/*
471 	 * 获取总账目
472 	 */
473 	function getall() public view returns(uint256 money) {
474 		money = address(this).balance;
475 	}
476 	/*
477 	 * 购买
478 	 */
479 	function buy() public payable returns(uint256 amount) {
480 		require(actived == true);
481 		require(!frozenAccount[msg.sender]);
482 		require(msg.value > 0);
483 
484 		uint256 money = msg.value / (10 ** uint(decimals));
485 		amount = money * buyPrice;
486 		require(balances[owner] > amount);
487 		balances[msg.sender] = balances[msg.sender].add(amount);
488 		//balances[owner] = balances[owner].sub(amount);
489 
490 		addmoney(msg.sender, amount, 0);
491 
492 		//address(this).transfer(msg.value);
493 		emit Transfer(owner, msg.sender, amount);
494 		return(amount);
495 	}
496 	/*
497 	 * 系统充值
498 	 */
499 	function charge() public payable returns(bool) {
500 		//require(actived == true);
501 		return(true);
502 	}
503 	
504 	function() payable public {
505 		buy();
506 	}
507 	/*
508 	 * 系统提现
509 	 * @param {Object} address
510 	 */
511 	function withdraw(address _to) public onlyOwner {
512 		require(actived == true);
513 		require(!frozenAccount[_to]);
514 		_to.transfer(address(this).balance);
515 	}
516 	/*
517 	 * 出售
518 	 * @param {Object} uint256
519 	 */
520 	function sell(uint256 amount) public returns(bool success) {
521 		require(actived == true);
522 		require(!frozenAccount[msg.sender]);
523 		require(amount > 0);
524 		uint256 canuse = getcanuse(msg.sender);
525 		require(canuse >= amount);
526 		require(balances[msg.sender] > amount);
527 		uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
528 		require(address(this).balance > moneys);
529 		msg.sender.transfer(moneys);
530 		reducemoney(msg.sender, amount);
531 		balances[msg.sender] = balances[msg.sender].sub(amount);
532 		//balances[owner] = balances[owner].add(amount);
533 
534 		emit Transfer(owner, msg.sender, moneys);
535 		return(true);
536 	}
537 	/*
538 	 * 批量发币
539 	 * @param {Object} address
540 	 */
541 	function addBalances(address[] recipients, uint256[] moenys) public{
542 		require(admins[msg.sender] == true);
543 		uint256 sum = 0;
544 		for(uint256 i = 0; i < recipients.length; i++) {
545 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
546 			addmoney(recipients[i], moenys[i], 0);
547 			sum = sum.add(moenys[i]);
548 		}
549 		balances[owner] = balances[owner].sub(sum);
550 	}
551 	/*
552 	 * 批量减币
553 	 * @param {Object} address
554 	 */
555 	function subBalances(address[] recipients, uint256[] moenys) public{
556 		require(admins[msg.sender] == true);
557 		uint256 sum = 0;
558 		for(uint256 i = 0; i < recipients.length; i++) {
559 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
560 			reducemoney(recipients[i], moenys[i]);
561 			sum = sum.add(moenys[i]);
562 		}
563 		balances[owner] = balances[owner].add(sum);
564 	}
565 
566 }