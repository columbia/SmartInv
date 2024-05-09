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
87 interface oldInterface {
88     function balanceOf(address _addr) external view returns (uint256);
89     function getcanuse(address tokenOwner) external view returns(uint);
90     function getfrom(address _addr) external view returns(address);
91 }
92 interface ecInterface {
93     function balanceOf(address _addr) external view returns (uint256);
94     function intertransfer(address from, address to, uint tokens) external returns(bool);
95 }
96 // ----------------------------------------------------------------------------
97 // 核心类
98 // ----------------------------------------------------------------------------
99 contract BTYCToken is ERC20Interface, Owned {
100 	using SafeMath
101 	for uint;
102 
103 	string public symbol;
104 	string public name;
105 	uint8 public decimals;
106 	uint _totalSupply;
107 
108 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
109 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
110 	uint public sysPrice; //挖矿的衡量值
111 	uint public sysPer; //挖矿的增量百分比 /100
112 	/*
113 	uint public givecandyto; //奖励新人 
114 	uint public givecandyfrom; //奖励推荐人
115 	uint public candyper; //转账多少给奖励
116 	*/
117 	bool public actived;
118 
119 	uint public sendPer; //转账分佣百分比
120 	uint public sendPer2; //转账分佣百分比
121 	uint public sendPer3; //转账分佣百分比
122 	uint public sendfrozen; //转账冻结百分比 
123 
124 	uint public onceOuttime; //增量的时间 测试  
125 	uint public onceAddTime; //挖矿的时间 测试
126 	bool public openout;
127 
128 	mapping(address => uint) balances;
129 	mapping(address => uint) used;
130 	mapping(address => mapping(address => uint)) allowed;
131 
132 	/* 冻结账户 */
133 	mapping(address => bool) public frozenAccount;
134 
135 	//释放 
136 	mapping(address => uint[]) public mycantime; //时间
137 	mapping(address => uint[]) public mycanmoney; //金额
138 	//上家地址
139 	mapping(address => address) public fromaddr;
140 	//管理员帐号
141 	mapping(address => bool) public admins;
142 	// 记录各个账户的增量时间
143 	mapping(address => uint) public cronaddOf;
144     mapping(address => bool) public intertoken;
145     mapping(address => uint) public hasupdate;
146 	/* 通知 */
147 	event FrozenFunds(address target, bool frozen);
148 	address public oldtoken;
149     address public ectoken;
150     oldInterface public oldBase = oldInterface(oldtoken);
151     ecInterface public ecBase = ecInterface(ectoken);
152 	// ------------------------------------------------------------------------
153 	// Constructor
154 	// ------------------------------------------------------------------------
155 	constructor() public {
156 
157 		symbol = "BTYC";
158 		name = "BTYC Coin";
159 		decimals = 18;
160 		_totalSupply = 86400000 ether;
161 
162 		sellPrice = 0.000008 ether; //出售价格 1btyc can buy how much eth
163 		buyPrice = 205 ether; //购买价格 1eth can buy how much btyc
164 		//sysPrice = 766 ether; //挖矿的衡量值
165 		sysPrice = 300 ether;//test
166 		sysPer = 150; //挖矿的增量百分比 /100
167 		sendPer = 3;
168 		sendPer2 = 1;
169 		sendPer3 = 0;
170 		sendfrozen = 80;
171 		actived = true;
172 		openout = false;
173 		onceOuttime = 1 days; //增量的时间 正式 
174 		onceAddTime = 10 days; //挖矿的时间 正式
175 
176 		//onceOuttime = 30 seconds; //增量的时间 测试  
177 		//onceAddTime = 60 seconds; //挖矿的时间 测试
178 		balances[this] = _totalSupply;
179 		emit Transfer(address(0), owner, _totalSupply);
180 
181 	}
182 
183 	/* 获取用户金额 */
184 	function balanceOf(address tokenOwner) public view returns(uint balance) {
185 		return balances[tokenOwner];
186 	}
187 	/*
188 	 * 添加金额，为了统计用户的进出
189 	 */
190 	function addmoney(address _addr, uint256 _money, uint _day) private {
191 		uint256 _days = _day * (1 days);
192 		uint256 _now = now - _days;
193 		mycanmoney[_addr].push(_money);
194 		mycantime[_addr].push(_now);
195 
196 		if(balances[_addr] >= sysPrice && cronaddOf[_addr] < 2) {
197 			cronaddOf[_addr] = now + onceAddTime;
198 		}
199 	}
200 	function interaddmoney(address _addr, uint256 _money, uint _day) public {
201 	    require(intertoken[msg.sender] == true);
202 	    require(actived == true);
203 	    addmoney(_addr, _money, _day);
204 	}
205 	/*
206 	 * 用户金额减少时的触发
207 	 * @param {Object} address
208 	 */
209 	function reducemoney(address _addr, uint256 _money) private {
210 		used[_addr] += _money;
211 		if(balances[_addr] < sysPrice) {
212 			cronaddOf[_addr] = 1;
213 		}
214 	}
215 	function interreducemoney(address _addr, uint256 _money) public {
216 	    require(intertoken[msg.sender] == true);
217 	    require(actived == true);
218 	    reducemoney(_addr, _money);
219 	}
220 	function interaddused(address _addr, uint256 _money) public {
221 	    require(intertoken[msg.sender] == true);
222 	    require(actived == true);
223 	    used[_addr] += _money;
224 	}
225 	function intersubused(address _addr, uint256 _money) public {
226 	    require(intertoken[msg.sender] == true);
227 	    require(actived == true);
228 	    require(used[_addr] >= _money);
229 	    used[_addr] -= _money;
230 	}
231 	/*
232 	 * 获取用户的挖矿时间
233 	 * @param {Object} address
234 	 */
235 	function getaddtime(address _addr) public view returns(uint) {
236 		if(cronaddOf[_addr] < 2) {
237 			return(0);
238 		}else{
239 		    return(cronaddOf[_addr]);
240 		}
241 		
242 	}
243 	function getmy(address user) public view returns(
244 	    uint mybalances,//0
245 	    uint mycanuses,//1
246 	    uint myuseds,//2
247 	    uint mytimes,//3
248 	    uint uptimes,//4
249 	    uint allmoneys//5
250 	){
251 	    mybalances = balances[user];
252 	    mycanuses = getcanuse(user);
253 	    myuseds = used[user];
254 	    mytimes = cronaddOf[user];
255 	    uptimes = hasupdate[user];
256 	    allmoneys = _totalSupply.sub(balances[this]);
257 	}
258 	function testuser() public view returns(uint oldbalance, uint oldcanuse, uint bthis, uint dd){
259 	    address user = msg.sender;
260 	    //require(oldtoken != address(0));
261 	    oldbalance = oldBase.balanceOf(user);
262 	    oldcanuse = oldBase.getcanuse(user); 
263 	    bthis = balances[this];
264 	    dd = oldcanuse*100/oldbalance;
265 	}
266 	function updateuser() public{
267 	    address user = msg.sender;
268 	    require(oldtoken != address(0));
269 	    uint oldbalance = oldBase.balanceOf(user);
270 	    uint oldcanuse = oldBase.getcanuse(user); 
271 	    //address oldfrom = oldBase.getfrom(user);
272 	    //require(hasupdate[user] < 1);
273 	    require(oldcanuse <= oldbalance);
274 	    if(oldbalance > 0) {
275 	        require(balances[this] > oldbalance);
276 	        //delete mycanmoney[user];
277 		    //delete mycantime[user];
278 	        balances[user] = oldbalance;
279 	        //fromaddr[user] = oldfrom;
280 	        if(oldcanuse > 0) {
281 	            uint dd = oldcanuse*100/oldbalance;
282 	            addmoney(user, oldbalance, dd); 
283 	        }
284 	        
285 	        balances[this] = balances[this].sub(oldbalance);
286 	        emit Transfer(this, user, oldbalance);
287 	    }
288 	    hasupdate[user] = now;
289 	    
290 	}
291 	/*
292 	 * 获取用户的可用金额
293 	 * @param {Object} address
294 	 */
295 	function getcanuse(address tokenOwner) public view returns(uint balance) {
296 		uint256 _now = now;
297 		uint256 _left = 0;
298 		/*
299 		if(tokenOwner == owner) {
300 			return(balances[owner]);
301 		}*/
302 		if(openout == true) {
303 		    return(balances[tokenOwner] - used[tokenOwner]);
304 		}
305 		for(uint256 i = 0; i < mycantime[tokenOwner].length; i++) {
306 			uint256 stime = mycantime[tokenOwner][i];
307 			uint256 smoney = mycanmoney[tokenOwner][i];
308 			uint256 lefttimes = _now - stime;
309 			if(lefttimes >= onceOuttime) {
310 				uint256 leftpers = lefttimes / onceOuttime;
311 				if(leftpers > 100) {
312 					leftpers = 100;
313 				}
314 				_left = smoney * leftpers / 100 + _left;
315 			}
316 		}
317 		_left = _left - used[tokenOwner];
318 		if(_left < 0) {
319 			return(0);
320 		}
321 		if(_left > balances[tokenOwner]) {
322 			return(balances[tokenOwner]);
323 		}
324 		return(_left);
325 	}
326     function transfer(address to, uint tokens) public returns(bool success) {
327         address from = msg.sender;
328         _transfer(from, to, tokens);
329         success = true;
330     }
331     function intertransfer(address from, address to, uint tokens) public returns(bool success) {
332         require(intertoken[msg.sender] == true);
333         _transfer(from, to, tokens);
334         success = true;
335     }
336 	/*
337 	 * 用户转账
338 	 * @param {Object} address
339 	 */
340 	function _transfer(address from, address to, uint tokens) private returns(bool success) {
341 		require(!frozenAccount[from]);
342 		require(!frozenAccount[to]);
343 		require(actived == true);
344 		uint256 canuse = getcanuse(from);
345 		require(canuse >= tokens);
346 		//
347 		require(from != to);
348 		//如果用户没有上家
349 		if(fromaddr[to] == address(0)) {
350 			//指定上家地址
351 			fromaddr[to] = from;
352 		} 
353 		
354 		address topuser1 = fromaddr[to];
355 		if(sendPer > 0 && sendPer <= 100 && topuser1 != address(0) && topuser1 != to) {
356 			uint subthis = 0;
357 				//上家分润
358 			uint addfroms = tokens * sendPer / 100;
359 			balances[topuser1] = balances[topuser1].add(addfroms);
360 			addmoney(topuser1, addfroms, 0);
361 			subthis += addfroms;
362 			emit Transfer(this, topuser1, addfroms);
363 			//如果存在第二层
364 		    if(sendPer2 > 0 && sendPer2 <= 100 && fromaddr[topuser1] != address(0) && fromaddr[topuser1] != to) {
365 				uint addfroms2 = tokens * sendPer2 / 100;
366 				subthis += addfroms2;
367 				address topuser2 = fromaddr[topuser1];
368 				balances[topuser2] = balances[topuser2].add(addfroms2);
369 				addmoney(topuser2, addfroms2, 0);
370 				emit Transfer(this, topuser2, addfroms2);
371 				//如果存在第三层
372 				if(sendPer3 > 0 && sendPer3 <= 100 && fromaddr[topuser2] != address(0) && fromaddr[topuser2] != to) {
373 					uint addfroms3 = tokens * sendPer3 / 100;
374 					subthis += addfroms3;
375 					address topuser3 = fromaddr[topuser2];
376 					balances[topuser3] = balances[topuser3].add(addfroms3);
377 					addmoney(topuser3, addfroms3, 0);
378 					emit Transfer(this, topuser3, addfroms3);
379 				}
380 			}
381 			balances[this] = balances[this].sub(subthis);
382 		}
383 
384 		balances[to] = balances[to].add(tokens);
385 		if(sendfrozen <= 100) {
386 			addmoney(to, tokens, 100 - sendfrozen);
387 		} else {
388 			addmoney(to, tokens, 0);
389 		}
390 		balances[from] = balances[from].sub(tokens);
391 		reducemoney(msg.sender, tokens);
392 		//balances[to] = balances[to].add(tokens);
393 		//addmoney(to, tokens, 0);
394 		
395 		emit Transfer(from, to, tokens);
396 		return true;
397 	}
398 	/*
399 	 * 获取真实值
400 	 * @param {Object} uint
401 	 */
402 	function getnum(uint num) public view returns(uint) {
403 		return(num * 10 ** uint(decimals));
404 	}
405 	/*
406 	 * 获取上家地址
407 	 * @param {Object} address
408 	 */
409 	function getfrom(address _addr) public view returns(address) {
410 		return(fromaddr[_addr]);
411 	}
412 
413 	function approve(address spender, uint tokens) public returns(bool success) {
414 		allowed[msg.sender][spender] = tokens;
415 		emit Approval(msg.sender, spender, tokens);
416 		return true;
417 	}
418 	/*
419 	 * 授权转账
420 	 * @param {Object} address
421 	 */
422 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
423 		require(actived == true);
424 		require(!frozenAccount[from]);
425 		require(!frozenAccount[to]);
426 		balances[from] = balances[from].sub(tokens);
427 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
428 		balances[to] = balances[to].add(tokens);
429 		emit Transfer(from, to, tokens);
430 		return true;
431 	}
432 
433 	/*
434 	 * 获取授权信息
435 	 * @param {Object} address
436 	 */
437 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
438 		return allowed[tokenOwner][spender];
439 	}
440 
441 	/*
442 	 * 授权
443 	 * @param {Object} address
444 	 */
445 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
446 		allowed[msg.sender][spender] = tokens;
447 		emit Approval(msg.sender, spender, tokens);
448 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
449 		return true;
450 	}
451 
452 	/// 冻结 or 解冻账户
453 	function freezeAccount(address target, bool freeze) public {
454 		require(admins[msg.sender] == true);
455 		frozenAccount[target] = freeze;
456 		emit FrozenFunds(target, freeze);
457 	}
458 	/*
459 	 * 设置管理员
460 	 * @param {Object} address
461 	 */
462 	function admAccount(address target, bool freeze) onlyOwner public {
463 		admins[target] = freeze;
464 	}
465 	/*
466 	 * 系统设置
467 	 * @param {Object} uint
468 	 */
469 	function setPrices(uint newonceaddtime, uint newonceouttime, uint newBuyPrice, uint newSellPrice, uint systyPrice, uint sysPermit,  uint syssendfrozen, uint syssendper1, uint syssendper2, uint syssendper3) public {
470 		require(admins[msg.sender] == true);
471 		onceAddTime = newonceaddtime;
472 		onceOuttime = newonceouttime;
473 		buyPrice = newBuyPrice;
474 		sellPrice = newSellPrice;
475 		sysPrice = systyPrice;
476 		sysPer = sysPermit;
477 		sendfrozen = syssendfrozen;
478 		sendPer = syssendper1;
479 		sendPer2 = syssendper2;
480 		sendPer3 = syssendper3;
481 	}
482 	/*
483 	 * 获取系统设置
484 	 */
485 	function getprice() public view returns(uint addtimes, uint outtimes, uint bprice, uint spice, uint sprice, uint sper, uint sdfrozen, uint sdper1, uint sdper2, uint sdper3) {
486 		addtimes = onceAddTime;//0
487 		outtimes = onceOuttime;//1
488 		bprice = buyPrice;//2
489 		spice = sellPrice;//3
490 		sprice = sysPrice;//4
491 		sper = sysPer;//5
492 		sdfrozen = sendfrozen;//6
493 		sdper1 = sendPer;//7
494 		sdper2 = sendPer2;//8
495 		sdper3 = sendPer3;//9
496 	}
497 	/*
498 	 * 设置是否开启
499 	 * @param {Object} bool
500 	 */
501 	function setactive(bool tags) public onlyOwner {
502 		actived = tags;
503 	}
504     function setout(bool tags) public onlyOwner {
505 		openout = tags;
506 	}
507 	function settoken(address target, bool freeze) onlyOwner public {
508 		intertoken[target] = freeze;
509 	}
510 	function setoldtoken(address token) onlyOwner public {
511 	    oldtoken = token;
512 	    oldBase = oldInterface(token);
513 	    
514 	}
515 	function setectoken(address token) onlyOwner public {
516 	    ectoken = token;
517 	    ecBase = ecInterface(token);
518 	    settoken(token, true);
519 	}
520 	/*
521 	 * 获取总发行
522 	 */
523 	function totalSupply() public view returns(uint) {
524 		return _totalSupply;
525 	}
526 	function adduser(address target, uint mintedAmount, uint _day) private {
527 	    require(!frozenAccount[target]);
528 		require(actived == true);
529         require(balances[this] > mintedAmount);
530 		balances[target] = balances[target].add(mintedAmount);
531 		addmoney(target, mintedAmount, _day);
532 		balances[this] = balances[this].sub(mintedAmount);
533 		emit Transfer(this, target, mintedAmount);
534 	}
535 	function subuser(address target, uint256 mintedAmount) private {
536 	    require(!frozenAccount[target]);
537 		require(actived == true);
538         require(balances[target] >= mintedAmount);
539 		balances[target] = balances[target].sub(mintedAmount);
540 		reducemoney(target, mintedAmount);
541 		balances[this] = balances[this].add(mintedAmount);
542 		emit Transfer(target, this, mintedAmount);
543 	}
544 	/*
545 	 * 向指定账户拨发资金
546 	 * @param {Object} address
547 	 */
548 	function addtoken(address target, uint256 mintedAmount, uint _day) public {
549 		require(admins[msg.sender] == true);
550 		adduser(target, mintedAmount, _day);
551 	}
552 	function subtoken(address target, uint256 mintedAmount) public {
553 		require(admins[msg.sender] == true);
554 		subuser(target, mintedAmount);
555 	}
556 	function interaddtoken(address target, uint256 mintedAmount, uint _day) public {
557 		require(intertoken[msg.sender] == true);
558 		adduser(target, mintedAmount, _day);
559 	}
560 	function intersubtoken(address target, uint256 mintedAmount) public {
561 		require(intertoken[msg.sender] == true);
562 		subuser(target, mintedAmount);
563 	}
564 	/*
565 	 * 用户每隔10天挖矿一次
566 	 */
567 	function mint() public {
568 	    address user = msg.sender;
569 		require(!frozenAccount[user]);
570 		require(actived == true);
571 		require(cronaddOf[user] > 1);
572 		require(now > cronaddOf[user]);
573 		require(balances[user] >= sysPrice);
574 		uint256 mintAmount = balances[user] * sysPer / 10000;
575 		require(balances[this] > mintAmount);
576 		balances[user] = balances[user].add(mintAmount);
577 		addmoney(user, mintAmount, 0);
578 		balances[this] = balances[this].sub(mintAmount);
579 		cronaddOf[user] = now + onceAddTime;
580 		emit Transfer(this, msg.sender, mintAmount);
581 
582 	}
583 	/*
584 	 * 获取总账目
585 	 */
586 	function getall() public view returns(uint256 money) {
587 		money = address(this).balance;
588 	}
589 	/*
590 	 * 购买
591 	 */
592 	function buy() public payable returns(uint) {
593 		require(actived == true);
594 		require(!frozenAccount[msg.sender]);
595 		require(msg.value > 0);
596 
597 		uint amount = (msg.value * buyPrice)/1 ether;
598 		require(balances[this] > amount);
599 		balances[msg.sender] = balances[msg.sender].add(amount);
600 		balances[this] = balances[this].sub(amount);
601 
602 		addmoney(msg.sender, amount, 0);
603 
604 		//address(this).transfer(msg.value);
605 		emit Transfer(this, msg.sender, amount);
606 		return(amount);
607 	}
608 	/*
609 	 * 系统充值
610 	 */
611 	function charge() public payable returns(bool) {
612 		//require(actived == true);
613 		return(true);
614 	}
615 	
616 	function() payable public {
617 		buy();
618 	}
619 	/*
620 	 * 系统提现
621 	 * @param {Object} address
622 	 */
623 	function withdraw(address _to, uint money) public onlyOwner {
624 		require(actived == true);
625 		require(!frozenAccount[_to]);
626 		require(address(this).balance > money);
627 		require(money > 0);
628 		_to.transfer(money);
629 	}
630 	/*
631 	 * 出售
632 	 * @param {Object} uint256
633 	 */
634 	function sell(uint256 amount) public returns(bool success) {
635 		require(actived == true);
636 		address user = msg.sender;
637 		require(!frozenAccount[user]);
638 		require(amount > 0);
639 		uint256 canuse = getcanuse(user);
640 		require(canuse >= amount);
641 		require(balances[user] >= amount);
642 		//uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
643 		uint moneys = (amount * sellPrice)/1 ether;
644 		require(address(this).balance > moneys);
645 		user.transfer(moneys);
646 		reducemoney(user, amount);
647 		balances[user] = balances[user].sub(amount);
648 		balances[this] = balances[this].add(amount);
649 
650 		emit Transfer(this, user, amount);
651 		return(true);
652 	}
653 	/*
654 	 * 批量发币
655 	 * @param {Object} address
656 	 */
657 	function addBalances(address[] recipients, uint256[] moenys) public{
658 		require(admins[msg.sender] == true);
659 		uint256 sum = 0;
660 		for(uint256 i = 0; i < recipients.length; i++) {
661 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
662 			addmoney(recipients[i], moenys[i], 0);
663 			sum = sum.add(moenys[i]);
664 			emit Transfer(this, recipients[i], moenys[i]);
665 		}
666 		balances[this] = balances[this].sub(sum);
667 	}
668 	/*
669 	 * 批量减币
670 	 * @param {Object} address
671 	 */
672 	function subBalances(address[] recipients, uint256[] moenys) public{
673 		require(admins[msg.sender] == true);
674 		uint256 sum = 0;
675 		for(uint256 i = 0; i < recipients.length; i++) {
676 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
677 			reducemoney(recipients[i], moenys[i]);
678 			sum = sum.add(moenys[i]);
679 			emit Transfer(recipients[i], this, moenys[i]);
680 		}
681 		balances[this] = balances[this].add(sum);
682 	}
683 
684 }