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
49 
50 interface oldInterface {
51     function balanceOf(address _addr) external view returns (uint256);
52     function getcanuse(address tokenOwner) external view returns(uint);
53     function getfrom(address _addr) external view returns(address);
54 }
55 
56 // ----------------------------------------------------------------------------
57 // 核心类
58 // ----------------------------------------------------------------------------
59 contract BTYCToken is ERC20Interface {
60 	using SafeMath
61 	for uint;
62 
63 	string public symbol;
64 	string public name;
65 	uint8 public decimals;
66 	uint _totalSupply;
67 
68 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
69 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
70 	uint public sysPrice; //挖矿的衡量值
71 	uint public sysPer; //挖矿的增量百分比 /100
72 	bool public actived;
73 
74 	uint public sendPer; //转账分佣百分比
75 	uint public sendPer2; //转账分佣百分比
76 	uint public sendPer3; //转账分佣百分比
77 	uint public sendfrozen; //转账冻结百分比 
78 
79 	uint public onceOuttime; //增量的时间 测试  
80 	uint public onceAddTime; //挖矿的时间 测试
81 	bool public openout;
82 
83 	mapping(address => uint) balances;
84 	mapping(address => uint) used;
85 	mapping(address => mapping(address => uint)) allowed;
86 
87 	/* 冻结账户 */
88 	mapping(address => bool) public frozenAccount;
89 
90 	//释放 
91 	mapping(address => uint[]) public mycantime; //时间
92 	mapping(address => uint[]) public mycanmoney; //金额
93 	//上家地址
94 	mapping(address => address) public fromaddr;
95 	//管理员帐号
96 	mapping(address => bool) public admins;
97 	// 记录各个账户的增量时间
98 	mapping(address => uint) public cronaddOf;
99     mapping(address => bool) public intertoken;
100     mapping(address => uint) public hasupdate;
101 	/* 通知 */
102 	event FrozenFunds(address target, bool frozen);
103     oldInterface public oldBase = oldInterface(0x56F527C3F4a24bB2BeBA449FFd766331DA840FFA);
104     address public owner;
105     bool public canupdate;
106     modifier onlyOwner {
107 		require(msg.sender == owner);
108 		_;
109 	}
110 	// ------------------------------------------------------------------------
111 	// Constructor
112 	// ------------------------------------------------------------------------
113 	constructor() public {
114 
115 		symbol = "BTYC";
116 		name = "BTYC Coin";
117 		decimals = 18;
118 		_totalSupply = 86400000 ether;
119 
120 		sellPrice = 0.000008 ether; //出售价格 1btyc can buy how much eth
121 		buyPrice = 205 ether; //购买价格 1eth can buy how much btyc
122 		//sysPrice = 766 ether; //挖矿的衡量值
123 		sysPrice = 300 ether;//test
124 		sysPer = 150; //挖矿的增量百分比 /100
125 		sendPer = 3;
126 		sendPer2 = 1;
127 		sendPer3 = 0;
128 		sendfrozen = 80;
129 		actived = true;
130 		openout = false;
131 		onceOuttime = 1 days; //增量的时间 正式 
132 		onceAddTime = 10 days; //挖矿的时间 正式
133         canupdate = true;
134 		//onceOuttime = 30 seconds; //增量的时间 测试  
135 		//onceAddTime = 60 seconds; //挖矿的时间 测试
136 		balances[this] = _totalSupply;
137 		owner = msg.sender;
138 		emit Transfer(address(0), owner, _totalSupply);
139 
140 	}
141 
142 	/* 获取用户金额 */
143 	function balanceOf(address tokenOwner) public view returns(uint balance) {
144 		return balances[tokenOwner];
145 	}
146 	/*
147 	 * 添加金额，为了统计用户的进出
148 	 */
149 	function addmoney(address _addr, uint256 _money, uint _day) private {
150 		uint256 _days = _day * (1 days);
151 		uint256 _now = now - _days;
152 		mycanmoney[_addr].push(_money);
153 		mycantime[_addr].push(_now);
154 
155 		if(balances[_addr] >= sysPrice && cronaddOf[_addr] < 2) {
156 			cronaddOf[_addr] = now + onceAddTime;
157 		}
158 	}
159 	/*
160 	 * 用户金额减少时的触发
161 	 * @param {Object} address
162 	 */
163 	function reducemoney(address _addr, uint256 _money) private {
164 		used[_addr] += _money;
165 		if(balances[_addr] < sysPrice) {
166 			cronaddOf[_addr] = 1;
167 		}
168 	}
169 	/*
170 	 * 获取用户的挖矿时间
171 	 * @param {Object} address
172 	 */
173 	function getaddtime(address _addr) public view returns(uint) {
174 		if(cronaddOf[_addr] < 2) {
175 			return(0);
176 		}else{
177 		    return(cronaddOf[_addr]);
178 		}
179 		
180 	}
181 	function getmy(address user) public view returns(
182 	    uint mybalances,//0
183 	    uint mycanuses,//1
184 	    uint myuseds,//2
185 	    uint mytimes,//3
186 	    uint uptimes,//4
187 	    uint allmoneys//5
188 	){
189 	    mybalances = balances[user];
190 	    mycanuses = getcanuse(user);
191 	    myuseds = used[user];
192 	    mytimes = cronaddOf[user];
193 	    uptimes = hasupdate[user];
194 	    allmoneys = _totalSupply.sub(balances[this]);
195 	}
196 	function updateuser() public{
197 	    address user = msg.sender;
198 	    require(canupdate == true);
199 	    uint oldbalance = oldBase.balanceOf(user);
200 	    uint oldcanuse = oldBase.getcanuse(user); 
201 	    //address oldfrom = oldBase.getfrom(user);
202 	    require(user != 0x0);
203 	    require(hasupdate[user] < 1);
204 	    require(oldcanuse <= oldbalance);
205 	    if(oldbalance > 0) {
206 	        require(oldbalance < _totalSupply);
207 	        require(balances[this] > oldbalance);
208 	        balances[user] = oldbalance;
209 	        //fromaddr[user] = oldfrom;
210 	        if(oldcanuse > 0) {
211 	            uint dd = oldcanuse*100/oldbalance;
212 	            addmoney(user, oldbalance, dd); 
213 	        }
214 	        
215 	        balances[this] = balances[this].sub(oldbalance);
216 	        emit Transfer(this, user, oldbalance);
217 	    }
218 	    hasupdate[user] = now;
219 	    
220 	}
221 	/*
222 	 * 获取用户的可用金额
223 	 * @param {Object} address
224 	 */
225 	function getcanuse(address tokenOwner) public view returns(uint balance) {
226 		uint256 _now = now;
227 		uint256 _left = 0;
228 		if(openout == true) {
229 		    return(balances[tokenOwner] - used[tokenOwner]);
230 		}
231 		for(uint256 i = 0; i < mycantime[tokenOwner].length; i++) {
232 			uint256 stime = mycantime[tokenOwner][i];
233 			uint256 smoney = mycanmoney[tokenOwner][i];
234 			uint256 lefttimes = _now - stime;
235 			if(lefttimes >= onceOuttime) {
236 				uint256 leftpers = lefttimes / onceOuttime;
237 				if(leftpers > 100) {
238 					leftpers = 100;
239 				}
240 				_left = smoney * leftpers / 100 + _left;
241 			}
242 		}
243 		_left = _left - used[tokenOwner];
244 		if(_left < 0) {
245 			return(0);
246 		}
247 		if(_left > balances[tokenOwner]) {
248 			return(balances[tokenOwner]);
249 		}
250 		return(_left);
251 	}
252     function transfer(address to, uint tokens) public returns(bool success) {
253         address from = msg.sender;
254         require(!frozenAccount[from]);
255 		require(!frozenAccount[to]);
256 		require(actived == true);
257 		uint256 canuse = getcanuse(from);
258 		require(canuse >= tokens);
259 		require(from != to);
260 		require(tokens > 1 && tokens < _totalSupply);
261 		//如果用户没有上家
262 		if(fromaddr[to] == address(0)) {
263 			//指定上家地址
264 			fromaddr[to] = from;
265 		} 
266 		require(to != 0x0);
267 		address topuser1 = fromaddr[to];
268 		if(sendPer > 0 && sendPer <= 100 && topuser1 != address(0) && topuser1 != to) {
269 			uint subthis = 0;
270 				//上家分润
271 			uint addfroms = tokens * sendPer / 100;
272 			require(addfroms < tokens);
273 			balances[topuser1] = balances[topuser1].add(addfroms);
274 			addmoney(topuser1, addfroms, 0);
275 			subthis += addfroms;
276 			emit Transfer(this, topuser1, addfroms);
277 			//如果存在第二层
278 		    if(sendPer2 > 0 && sendPer2 <= 100 && fromaddr[topuser1] != address(0) && fromaddr[topuser1] != to) {
279 				uint addfroms2 = tokens * sendPer2 / 100;
280 				subthis += addfroms2;
281 				address topuser2 = fromaddr[topuser1];
282 				require(addfroms2 < tokens);
283 				balances[topuser2] = balances[topuser2].add(addfroms2);
284 				addmoney(topuser2, addfroms2, 0);
285 				emit Transfer(this, topuser2, addfroms2);
286 			}
287 			balances[this] = balances[this].sub(subthis);
288 		}
289         // 将此保存为将来的断言， 函数最后会有一个检验
290         uint previousBalances = balances[from] + balances[to];
291 		balances[to] = balances[to].add(tokens);
292 		if(sendfrozen <= 100) {
293 			addmoney(to, tokens, 100 - sendfrozen);
294 		} else {
295 			addmoney(to, tokens, 0);
296 		}
297 		balances[from] = balances[from].sub(tokens);
298 		reducemoney(msg.sender, tokens);
299 		
300 		emit Transfer(from, to, tokens);
301 		// 断言检测， 不应该为错
302         assert(balances[from] + balances[to] == previousBalances);
303 		return true;
304     }
305 	
306 	/*
307 	 * 获取真实值
308 	 * @param {Object} uint
309 	 */
310 	function getnum(uint num) public view returns(uint) {
311 		return(num * 10 ** uint(decimals));
312 	}
313 	/*
314 	 * 获取上家地址
315 	 * @param {Object} address
316 	 */
317 	function getfrom(address _addr) public view returns(address) {
318 		return(fromaddr[_addr]);
319 	}
320 
321 	function approve(address spender, uint tokens) public returns(bool success) {
322 	    require(tokens > 1 && tokens < _totalSupply);
323 	    require(balances[msg.sender] >= tokens);
324 		allowed[msg.sender][spender] = tokens;
325 		emit Approval(msg.sender, spender, tokens);
326 		return true;
327 	}
328 	/*
329 	 * 授权转账
330 	 * @param {Object} address
331 	 */
332 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
333 		require(actived == true);
334 		require(!frozenAccount[from]);
335 		require(!frozenAccount[to]);
336 		require(tokens > 1 && tokens < _totalSupply);
337 		require(balances[from] >= tokens);
338 		balances[from] = balances[from].sub(tokens);
339 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
340 		balances[to] = balances[to].add(tokens);
341 		emit Transfer(from, to, tokens);
342 		return true;
343 	}
344 
345 	/*
346 	 * 获取授权信息
347 	 * @param {Object} address
348 	 */
349 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
350 		return allowed[tokenOwner][spender];
351 	}
352 
353 	/*
354 	 * 授权
355 	 * @param {Object} address
356 	 */
357 	function approveAndCall(address spender, uint tokens) public returns(bool success) {
358 		allowed[msg.sender][spender] = tokens;
359 		require(tokens > 1 && tokens < _totalSupply);
360 		require(balances[msg.sender] >= tokens);
361 		emit Approval(msg.sender, spender, tokens);
362 		//ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
363 		return true;
364 	}
365 
366 	/// 冻结 or 解冻账户
367 	function freezeAccount(address target, bool freeze) public onlyOwner{
368 		frozenAccount[target] = freeze;
369 		emit FrozenFunds(target, freeze);
370 	}
371 
372 	/*
373 	 * 系统设置
374 	 * @param {Object} uint
375 	 */
376 	function setPrices(uint newonceaddtime, uint newonceouttime, uint newBuyPrice, uint newSellPrice, uint systyPrice, uint sysPermit,  uint syssendfrozen, uint syssendper1, uint syssendper2, uint syssendper3) public onlyOwner{
377 		onceAddTime = newonceaddtime;
378 		onceOuttime = newonceouttime;
379 		buyPrice = newBuyPrice;
380 		sellPrice = newSellPrice;
381 		sysPrice = systyPrice;
382 		sysPer = sysPermit;
383 		sendfrozen = syssendfrozen;
384 		sendPer = syssendper1;
385 		sendPer2 = syssendper2;
386 		sendPer3 = syssendper3;
387 	}
388 	/*
389 	 * 获取系统设置
390 	 */
391 	function getprice() public view returns(uint addtimes, uint outtimes, uint bprice, uint spice, uint sprice, uint sper, uint sdfrozen, uint sdper1, uint sdper2, uint sdper3) {
392 		addtimes = onceAddTime;//0
393 		outtimes = onceOuttime;//1
394 		bprice = buyPrice;//2
395 		spice = sellPrice;//3
396 		sprice = sysPrice;//4
397 		sper = sysPer;//5
398 		sdfrozen = sendfrozen;//6
399 		sdper1 = sendPer;//7
400 		sdper2 = sendPer2;//8
401 		sdper3 = sendPer3;//9
402 	}
403 	/*
404 	 * 设置是否开启
405 	 * @param {Object} bool
406 	 */
407 	function setactive(bool tags) public onlyOwner {
408 		actived = tags;
409 	}
410     function setout(bool tags) public onlyOwner {
411 		openout = tags;
412 	}
413 	function setupdate(bool tags) public onlyOwner {
414 		canupdate = tags;
415 	}
416 	
417 	/*
418 	 * 获取总发行
419 	 */
420 	function totalSupply() public view returns(uint) {
421 		return _totalSupply;
422 	}
423 	/*
424 	 * 向指定账户拨发资金
425 	 * @param {Object} address
426 	 */
427 	function addtoken(address target, uint256 mintedAmount, uint _day) public onlyOwner{
428 		require(!frozenAccount[target]);
429 		require(actived == true);
430         require(balances[this] > mintedAmount);
431 		balances[target] = balances[target].add(mintedAmount);
432 		addmoney(target, mintedAmount, _day);
433 		balances[this] = balances[this].sub(mintedAmount);
434 		emit Transfer(this, target, mintedAmount);
435 	}
436 	function subtoken(address target, uint256 mintedAmount) public onlyOwner{
437 		require(!frozenAccount[target]);
438 		require(actived == true);
439         require(balances[target] >= mintedAmount);
440 		balances[target] = balances[target].sub(mintedAmount);
441 		reducemoney(target, mintedAmount);
442 		balances[this] = balances[this].add(mintedAmount);
443 		emit Transfer(target, this, mintedAmount);
444 	}
445 	/*
446 	 * 用户每隔10天挖矿一次
447 	 */
448 	function mint() public {
449 	    address user = msg.sender;
450 		require(!frozenAccount[user]);
451 		require(actived == true);
452 		require(cronaddOf[user] > 1);
453 		require(now > cronaddOf[user]);
454 		require(balances[user] >= sysPrice);
455 		uint256 mintAmount = balances[user] * sysPer / 10000;
456 		require(balances[this] > mintAmount);
457 		uint previousBalances = balances[user] + balances[this];
458 		balances[user] = balances[user].add(mintAmount);
459 		addmoney(user, mintAmount, 0);
460 		balances[this] = balances[this].sub(mintAmount);
461 		cronaddOf[user] = now + onceAddTime;
462 		emit Transfer(this, msg.sender, mintAmount);
463 		// 断言检测， 不应该为错
464         assert(balances[user] + balances[this] == previousBalances);
465 
466 	}
467 	/*
468 	 * 获取总账目
469 	 */
470 	function getall() public view returns(uint256 money) {
471 		money = address(this).balance;
472 	}
473 	/*
474 	 * 购买
475 	 */
476 	function buy() public payable returns(bool) {
477 	    
478 		require(actived == true);
479 		require(!frozenAccount[msg.sender]);
480 		uint money = msg.value;
481 		require(money > 0);
482 
483 		uint amount = (money * buyPrice)/1 ether;
484 		require(balances[this] > amount);
485 		balances[msg.sender] = balances[msg.sender].add(amount);
486 		balances[this] = balances[this].sub(amount);
487 
488 		addmoney(msg.sender, amount, 0);
489         owner.transfer(msg.value);
490 		emit Transfer(this, msg.sender, amount);
491 		return(true);
492 	}
493 	/*
494 	 * 系统充值
495 	 */
496 	function charge() public payable returns(bool) {
497 		return(true);
498 	}
499 	
500 	function() payable public {
501 		buy();
502 	}
503 	/*
504 	 * 系统提现
505 	 * @param {Object} address
506 	 */
507 	function withdraw(address _to, uint money) public onlyOwner {
508 		require(actived == true);
509 		require(!frozenAccount[_to]);
510 		require(address(this).balance > money);
511 		require(money > 0);
512 		_to.transfer(money);
513 	}
514 	/*
515 	 * 出售
516 	 * @param {Object} uint256
517 	 */
518 	function sell(uint256 amount) public returns(bool success) {
519 		require(actived == true);
520 		address user = msg.sender;
521 		require(!frozenAccount[user]);
522 		require(amount > 0);
523 		uint256 canuse = getcanuse(user);
524 		require(canuse >= amount);
525 		require(balances[user] >= amount);
526 		//uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
527 		uint moneys = (amount * sellPrice)/1 ether;
528 		require(address(this).balance > moneys);
529 		user.transfer(moneys);
530 		reducemoney(user, amount);
531 		uint previousBalances = balances[user] + balances[this];
532 		balances[user] = balances[user].sub(amount);
533 		balances[this] = balances[this].add(amount);
534 
535 		emit Transfer(this, user, amount);
536 		// 断言检测， 不应该为错
537         assert(balances[user] + balances[this] == previousBalances);
538 		return(true);
539 	}
540 	/*
541 	 * 批量发币
542 	 * @param {Object} address
543 	 */
544 	function addBalances(address[] recipients, uint256[] moenys) public onlyOwner{
545 		uint256 sum = 0;
546 		for(uint256 i = 0; i < recipients.length; i++) {
547 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
548 			addmoney(recipients[i], moenys[i], 0);
549 			sum = sum.add(moenys[i]);
550 			emit Transfer(this, recipients[i], moenys[i]);
551 		}
552 		balances[this] = balances[this].sub(sum);
553 	}
554 	/*
555 	 * 批量减币
556 	 * @param {Object} address
557 	 */
558 	function subBalances(address[] recipients, uint256[] moenys) public onlyOwner{
559 	
560 		uint256 sum = 0;
561 		for(uint256 i = 0; i < recipients.length; i++) {
562 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
563 			reducemoney(recipients[i], moenys[i]);
564 			sum = sum.add(moenys[i]);
565 			emit Transfer(recipients[i], this, moenys[i]);
566 		}
567 		balances[this] = balances[this].add(sum);
568 	}
569 
570 }