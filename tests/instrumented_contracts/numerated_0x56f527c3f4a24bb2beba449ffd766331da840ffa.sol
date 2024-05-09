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
247 		//
248 		require(msg.sender != to);
249 		//如果用户没有上家
250 		if(fromaddr[to] == address(0)) {
251 			//指定上家地址
252 			fromaddr[to] = msg.sender;
253 			//如果转账金额大于糖果的标准值
254 			if(tokens >= candyper) {
255 				if(givecandyfrom > 0) {
256 					balances[msg.sender] = balances[msg.sender].sub(tokens).add(givecandyfrom);
257 					//balances[owner] = balances[owner].sub(givecandyfrom); //控制总额度,不空投 
258 					reducemoney(msg.sender, tokens);
259 					addmoney(msg.sender, givecandyfrom, 0);
260 				}
261 				if(givecandyto > 0) {
262 					tokens += givecandyto;
263 					//balances[owner] = balances[owner].sub(givecandyto); //控制总额度,不空投
264 				}
265 			} else {
266 				balances[msg.sender] = balances[msg.sender].sub(tokens);
267 				reducemoney(msg.sender, tokens);
268 			}
269 			balances[to] = balances[to].add(tokens);
270 			addmoney(to, tokens, 0);
271 			//tokens = candyuser(msg.sender, to, tokens);
272 		} else {
273             //先减掉转账的
274 			balances[msg.sender] = balances[msg.sender].sub(tokens);
275 			reducemoney(msg.sender, tokens);
276 			
277 			if(sendPer > 0 && sendPer <= 100) {
278 				//上家分润
279 				uint addfroms = tokens * sendPer / 100;
280 				address topuser1 = fromaddr[to];
281 				balances[topuser1] = balances[topuser1].add(addfroms);
282 				addmoney(topuser1, addfroms, 0);
283 				//balances[owner] = balances[owner].sub(addfroms); //控制总额度,空投
284 
285 				//如果存在第二层
286 				if(sendPer2 > 0 && sendPer2 <= 100 && fromaddr[topuser1] != address(0)) {
287 					uint addfroms2 = tokens * sendPer2 / 100;
288 					address topuser2 = fromaddr[topuser1];
289 					balances[topuser2] = balances[topuser2].add(addfroms2);
290 					addmoney(topuser2, addfroms2, 0);
291 					//balances[owner] = balances[owner].sub(addfroms2); //控制总额度,空投
292 					//如果存在第三层
293 					if(sendPer3 > 0 && sendPer3 <= 100 && fromaddr[topuser2] != address(0)) {
294 						uint addfroms3 = tokens * sendPer3 / 100;
295 						address topuser3 = fromaddr[topuser2];
296 						balances[topuser3] = balances[topuser3].add(addfroms3);
297 						addmoney(topuser3, addfroms3, 0);
298 						//balances[owner] = balances[owner].sub(addfroms3); //控制总额度,空投
299 
300 					}
301 				}
302 
303 				//emit Transfer(owner, msg.sender, addfroms);
304 
305 			}
306 
307 			balances[to] = balances[to].add(tokens);
308 			if(sendfrozen > 0 && sendfrozen <= 100) {
309 				addmoney(to, tokens, 100 - sendfrozen);
310 			} else {
311 				addmoney(to, tokens, 0);
312 			}
313 
314 		}
315 		emit Transfer(msg.sender, to, tokens);
316 		return true;
317 	}
318 	/*
319 	 * 获取真实值
320 	 * @param {Object} uint
321 	 */
322 	function getnum(uint num) public view returns(uint) {
323 		return(num * 10 ** uint(decimals));
324 	}
325 	/*
326 	 * 获取上家地址
327 	 * @param {Object} address
328 	 */
329 	function getfrom(address _addr) public view returns(address) {
330 		return(fromaddr[_addr]);
331 	}
332 
333 	function approve(address spender, uint tokens) public returns(bool success) {
334 		require(admins[msg.sender] == true);
335 		allowed[msg.sender][spender] = tokens;
336 		emit Approval(msg.sender, spender, tokens);
337 		return true;
338 	}
339 	/*
340 	 * 授权转账
341 	 * @param {Object} address
342 	 */
343 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
344 		require(actived == true);
345 		require(!frozenAccount[from]);
346 		require(!frozenAccount[to]);
347 		balances[from] = balances[from].sub(tokens);
348 		reducemoney(from, tokens);
349 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
350 		balances[to] = balances[to].add(tokens);
351 		addmoney(to, tokens, 0);
352 		emit Transfer(from, to, tokens);
353 		return true;
354 	}
355 
356 	/*
357 	 * 获取授权信息
358 	 * @param {Object} address
359 	 */
360 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
361 		return allowed[tokenOwner][spender];
362 	}
363 
364 	/*
365 	 * 授权
366 	 * @param {Object} address
367 	 */
368 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
369 		require(admins[msg.sender] == true);
370 		allowed[msg.sender][spender] = tokens;
371 		emit Approval(msg.sender, spender, tokens);
372 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
373 		return true;
374 	}
375 
376 	/// 冻结 or 解冻账户
377 	function freezeAccount(address target, bool freeze) public {
378 		require(admins[msg.sender] == true);
379 		frozenAccount[target] = freeze;
380 		emit FrozenFunds(target, freeze);
381 	}
382 	/*
383 	 * 设置管理员
384 	 * @param {Object} address
385 	 */
386 	function admAccount(address target, bool freeze) onlyOwner public {
387 		admins[target] = freeze;
388 	}
389 	/*
390 	 * 系统设置
391 	 * @param {Object} uint
392 	 */
393 	function setPrices(uint newonceaddtime, uint newonceouttime, uint newBuyPrice, uint newSellPrice, uint systyPrice, uint sysPermit, uint sysgivefrom, uint sysgiveto, uint sysgiveper, uint syssendfrozen, uint syssendper1, uint syssendper2, uint syssendper3) public {
394 		require(admins[msg.sender] == true);
395 		onceAddTime = newonceaddtime;
396 		onceOuttime = newonceouttime;
397 		buyPrice = newBuyPrice;
398 		sellPrice = newSellPrice;
399 		sysPrice = systyPrice;
400 		sysPer = sysPermit;
401 		givecandyfrom = sysgivefrom;
402 		givecandyto = sysgiveto;
403 		candyper = sysgiveper;
404 		sendfrozen = syssendfrozen;
405 		sendPer = syssendper1;
406 		sendPer2 = syssendper2;
407 		sendPer3 = syssendper3;
408 	}
409 	/*
410 	 * 获取系统设置
411 	 */
412 	function getprice() public view returns(uint addtime, uint outtime, uint bprice, uint spice, uint sprice, uint sper, uint givefrom, uint giveto, uint giveper, uint sdfrozen, uint sdper1, uint sdper2, uint sdper3) {
413 		addtime = onceAddTime;
414 		outtime = onceOuttime;
415 		bprice = buyPrice;
416 		spice = sellPrice;
417 		sprice = sysPrice;
418 		sper = sysPer;
419 		givefrom = givecandyfrom;
420 		giveto = givecandyto;
421 		giveper = candyper;
422 		sdfrozen = sendfrozen;
423 		sdper1 = sendPer;
424 		sdper2 = sendPer2;
425 		sdper3 = sendPer3;
426 	}
427 	/*
428 	 * 设置是否开启
429 	 * @param {Object} bool
430 	 */
431 	function setactive(bool tags) public onlyOwner {
432 		actived = tags;
433 	}
434 
435 	/*
436 	 * 获取总发行
437 	 */
438 	function totalSupply() public view returns(uint) {
439 		return _totalSupply.sub(balances[address(0)]);
440 	}
441 	/*
442 	 * 向指定账户拨发资金
443 	 * @param {Object} address
444 	 */
445 	function mintToken(address target, uint256 mintedAmount) public {
446 		require(!frozenAccount[target]);
447 		require(admins[msg.sender] == true);
448 		require(actived == true);
449 
450 		balances[target] = balances[target].add(mintedAmount);
451 		addmoney(target, mintedAmount, 0);
452 		//emit Transfer(0, this, mintedAmount);
453 		emit Transfer(owner, target, mintedAmount);
454 
455 	}
456 	/*
457 	 * 用户每隔10天挖矿一次
458 	 */
459 	function mint() public {
460 		require(!frozenAccount[msg.sender]);
461 		require(actived == true);
462 		require(cronaddOf[msg.sender] > 0);
463 		require(now > cronaddOf[msg.sender]);
464 		require(balances[msg.sender] >= sysPrice);
465 		uint256 mintAmount = balances[msg.sender] * sysPer / 10000;
466 		balances[msg.sender] = balances[msg.sender].add(mintAmount);
467 		//balances[owner] = balances[owner].sub(mintAmount);
468 		cronaddOf[msg.sender] = now + onceAddTime;
469 		emit Transfer(owner, msg.sender, mintAmount);
470 
471 	}
472 	/*
473 	 * 获取总账目
474 	 */
475 	function getall() public view returns(uint256 money) {
476 		money = address(this).balance;
477 	}
478 	/*
479 	 * 购买
480 	 */
481 	function buy() public payable returns(uint) {
482 		require(actived == true);
483 		require(!frozenAccount[msg.sender]);
484 		require(msg.value > 0);
485 
486 		//uint256 money = msg.value / (10 ** uint(decimals));
487 		//amount = money * buyPrice;
488 		uint amount = msg.value * buyPrice/1000000000000000000;
489 		//require(balances[owner] > amount);
490 		balances[msg.sender] = balances[msg.sender].add(amount);
491 		//balances[owner] = balances[owner].sub(amount);
492 
493 		addmoney(msg.sender, amount, 0);
494 
495 		//address(this).transfer(msg.value);
496 		emit Transfer(owner, msg.sender, amount);
497 		return(amount);
498 	}
499 	/*
500 	 * 系统充值
501 	 */
502 	function charge() public payable returns(bool) {
503 		//require(actived == true);
504 		return(true);
505 	}
506 	
507 	function() payable public {
508 		buy();
509 	}
510 	/*
511 	 * 系统提现
512 	 * @param {Object} address
513 	 */
514 	function withdraw(address _to) public onlyOwner {
515 		require(actived == true);
516 		require(!frozenAccount[_to]);
517 		_to.transfer(address(this).balance);
518 	}
519 	/*
520 	 * 出售
521 	 * @param {Object} uint256
522 	 */
523 	function sell(uint256 amount) public returns(bool success) {
524 		require(actived == true);
525 		require(!frozenAccount[msg.sender]);
526 		require(amount > 0);
527 		uint256 canuse = getcanuse(msg.sender);
528 		require(canuse >= amount);
529 		require(balances[msg.sender] >= amount);
530 		//uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
531 		uint moneys = amount * sellPrice/1000000000000000000;
532 		require(address(this).balance > moneys);
533 		msg.sender.transfer(moneys);
534 		reducemoney(msg.sender, amount);
535 		balances[msg.sender] = balances[msg.sender].sub(amount);
536 		//balances[owner] = balances[owner].add(amount);
537 
538 		emit Transfer(owner, msg.sender, moneys);
539 		return(true);
540 	}
541 	/*
542 	 * 批量发币
543 	 * @param {Object} address
544 	 */
545 	function addBalances(address[] recipients, uint256[] moenys) public{
546 		require(admins[msg.sender] == true);
547 		uint256 sum = 0;
548 		for(uint256 i = 0; i < recipients.length; i++) {
549 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
550 			addmoney(recipients[i], moenys[i], 0);
551 			sum = sum.add(moenys[i]);
552 		}
553 		balances[owner] = balances[owner].sub(sum);
554 	}
555 	/*
556 	 * 批量减币
557 	 * @param {Object} address
558 	 */
559 	function subBalances(address[] recipients, uint256[] moenys) public{
560 		require(admins[msg.sender] == true);
561 		uint256 sum = 0;
562 		for(uint256 i = 0; i < recipients.length; i++) {
563 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
564 			reducemoney(recipients[i], moenys[i]);
565 			sum = sum.add(moenys[i]);
566 		}
567 		balances[owner] = balances[owner].add(sum);
568 	}
569 
570 }