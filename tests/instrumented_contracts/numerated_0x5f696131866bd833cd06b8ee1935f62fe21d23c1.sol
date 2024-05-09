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
87 interface btycInterface {
88     function balanceOf(address _addr) external view returns (uint256);
89     function getcanuse(address tokenOwner) external view returns(uint);
90     function intertransfer(address from, address to, uint tokens) external returns(bool);
91     function interaddtoken(address target, uint256 mintedAmount, uint _day) external;
92     function intersubtoken(address target, uint256 mintedAmount) external;
93     function interaddmoney(address _addr, uint256 _money, uint _day) external;
94     function interreducemoney(address _addr, uint256 _money) external;
95 }
96 // ----------------------------------------------------------------------------
97 // 核心类
98 // ----------------------------------------------------------------------------
99 contract BTYCEC is ERC20Interface, Owned {
100 	using SafeMath
101 	for uint;
102 
103 	string public symbol;
104 	string public name;
105 	uint8 public decimals;
106 	uint _totalSupply;//总发行
107 	uint public sysusermoney;//流通 
108 	uint public sysoutmoney;//矿池 
109 
110 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
111 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
112 	uint public btycbuyPrice; //购买价格 多少btyc可购买1枚代币 /1000
113 	uint public btycsellPrice; 
114 	uint public sysPer; //挖矿的增量百分比 /2%
115 	uint public sysPrice1; //挖矿的衡量值300
116 	uint public sysPer1; //挖矿的增量百分比 /3.2%
117 	uint public systime1;//120
118 	uint public sysPrice2; //挖矿的衡量值900
119 	uint public sysPer2; //挖矿的增量百分比 /4%
120 	uint public systime2;//200
121 	uint public transper; //转账手续费 /3%
122 	
123 	bool public actived;
124 	uint public onceAddTime; //挖矿的时间 10 days
125 	uint public upper1;//团队奖% 
126 	uint public upper2;//团队奖% 
127 	uint public teamper1;//团队奖% 
128 	uint public teamper2;//团队奖% 
129 	uint public outper1;//退出锁仓
130 	uint public outper2;//退出锁仓
131 	uint public sellper;//
132 	uint public sysday;
133 	//bool public openout;
134     uint public sysminteth;
135     uint public hasoutmony;
136     uint public hasbuymoney;
137     uint public hassellmoney;
138     uint public hasbuyeth;
139     uint public hasselleth;
140     uint public hasbtycbuymoney;
141     uint public hasbtycsellmoney;
142 	mapping(address => uint) balances;//总计
143 	mapping(address => uint) myeth;//本金
144 	mapping(address => uint) froeth;//冻结
145 	//mapping(address => uint) used;
146 	mapping(address => mapping(address => uint)) allowed;
147 
148 	/* 冻结账户 */
149 	mapping(address => bool) public frozenAccount;
150 
151 	//上家地址
152 	mapping(address => address) public fromaddr;
153 	//管理员帐号
154 	mapping(address => bool) public admins;
155 	// 记录各个账户的增量时间
156 	mapping(address => uint) public crontime;
157 	// 挖矿次数
158 	mapping(address => uint) public mintnum;
159 	uint[] public permans;
160 	mapping(address => uint) public teamget;
161 	//mapping(address => uint) public teamallget;
162 	//mapping(address => mapping(uint => uint)) public teamdayget;
163 	//mapping(address => uint) public teamgettime;
164 	struct sunsdata{
165 	    uint n1;
166 	    uint n2;
167 	    uint getmoney;
168 	}
169     mapping(address => sunsdata) public suns;
170     mapping(address => bool) public intertoken;
171     address public btyctoken;
172     btycInterface public btycBase = btycInterface(btyctoken);
173 	/* 通知 */
174 	event FrozenFunds(address target, bool frozen);
175 	// ------------------------------------------------------------------------
176 	// Constructor
177 	// ------------------------------------------------------------------------
178 	constructor() public {
179 
180 		symbol = "BTYCEC";
181 		name = "BTYCEC Coin";
182 		decimals = 18;
183 		_totalSupply = 43200000 ether;//总发行
184 		sysusermoney = 21000000 ether;//流通
185 		sysoutmoney  = 22200000 ether;//矿池
186 
187 		sellPrice = 19.545 ether; //出售价格 1btyc can buy how much eth
188 		buyPrice = 19.545 ether; //购买价格 1eth can buy how much btyc
189 		btycbuyPrice = 0.00001 ether;
190 		btycsellPrice = 1 ether;
191 		sysPrice1 = 300 ether; //挖矿的衡量值
192 		//sysPrice1 = 3 ether;//test
193 		sysPer  = 20; //挖矿的增量百分比 /1000
194 		sysPer1 = 32; //挖矿的增量百分比 /1000
195 		sysPrice2 = 900 ether; //挖矿的衡量值
196 		//sysPrice2 = 9 ether; //test
197 		sysPer2 = 40; //挖矿的增量百分比 /1000
198 		transper = 3;//转账手续费 /100
199 		upper1 = 20;//第1代挖矿分润
200 		upper2 = 10;//第2代挖矿分润
201 		teamper1 = 10;//团队奖% /100
202 		teamper2 = 20;//团队奖% /100
203 		outper1 = 80;//退出锁仓 /100
204 		outper2 = 70;//退出锁仓 /100
205 		sellper = 85;// /100
206 		actived = true;
207 		onceAddTime = 10 days; //挖矿的时间 正式
208 		//onceAddTime = 300 seconds;//test
209 		sysday = 1 days; 
210 		//sysday = 30 seconds;//test
211         systime1 = 13;
212         systime2 = 21;
213         permans = [40,20,12,6];
214         //permans = [8,6,4,2];//test
215 		balances[this] = _totalSupply;
216 		emit Transfer(address(0), owner, _totalSupply);
217 
218 	}
219 
220 	/* 获取用户金额 */
221 	function balanceOf(address user) public view returns(uint balance) {
222 		return balances[user];
223 	}
224 	function ethbalance(address user) public view returns(uint balance) {
225 		return user.balance;
226 	}
227 	function btycbalanceOf(address user) public view returns(uint balance) {
228 		return btycBase.balanceOf(user);
229 	}
230     function addcrontime(address addr) private{
231         if(crontime[addr] < now) {
232             crontime[addr] = now + onceAddTime;
233         }
234         
235     }
236     function addusertime(address addr) private{
237         if(balances[addr] < 2) {
238             addcrontime(addr);
239         }
240     }
241 	/*
242 	 * 获取用户的挖矿时间
243 	 * @param {Object} address
244 	 */
245 	function getaddtime(address _addr) public view returns(uint) {
246 		if(crontime[_addr] < 2) {
247 			return(0);
248 		}else{
249 		    return(crontime[_addr]);
250 		}
251 		
252 	}
253 	function getmy(address user) public view returns(
254 	    uint myblance,
255 	    uint mybtyc,
256 	    uint meth,
257 	    uint myeths,
258 	    uint mypro,
259 	    uint mytime,
260 	    uint bprice,
261 	    uint sprice,
262 	    uint cprice,
263 	    uint tmoney,
264 	    uint myall
265 	){
266 	    myblance = balances[user];//0
267 	    mybtyc = btycbalanceOf(user);//1
268 	    meth = address(user).balance;//2
269 	    myeths = myeth[user];//3
270 	    mypro = froeth[user];//4
271 	    mytime = crontime[user];//5
272 	    bprice = buyPrice;//6
273 	    sprice = sellPrice;//7
274 	    cprice = btycbuyPrice;//8
275 	    tmoney = balances[this];//9
276 	    myall = myblance.add(mypro);//10
277 	}
278 	function geteam(address user) public view returns(
279 	    uint nn1,//0
280 	    uint nn2,//1
281 	    uint ms,//2
282 	    uint tm,//3
283 	    uint mintmoneys,//4
284 	    uint usermoneys,//5
285 	    uint fromoneys,//6
286 	    uint lid,//7
287 	    uint tmoney
288 	){
289 	    nn1 = suns[user].n1;
290 	    nn2 = suns[user].n2;
291 	    ms = teamget[user];
292 	    tm = getaddtime(user);
293 	    mintmoneys = sysoutmoney;
294 	    usermoneys = sysusermoney;
295 	    fromoneys = sysminteth;
296 	    if(suns[user].n2 > permans[2] && suns[user].n1 > permans[3]){
297 	        lid = 1;
298 	    }
299 	    if(suns[user].n2 > permans[0] && suns[user].n1 > permans[1]){
300 	        lid = 2;
301 	    }
302 	    tmoney = _totalSupply.sub(balances[this]);//9
303 	}
304 	function getsys() public view returns(
305 	    uint tmoney,//0
306 	    uint outm,//1
307 	    uint um,//2
308 	    uint from,//3
309 	    uint hasout,//4
310 	    uint hasbuy,//5
311 	    uint hassell,//6
312 	    uint hasbtycbuy,//7
313 	    uint hasbtycsell,//8
314 	    uint hasbuyeths,//9
315 	    uint hasselleths//10
316 	){
317 	    tmoney = _totalSupply.sub(balances[this]);
318 	    outm = sysoutmoney;
319 	    um = sysusermoney;
320 	    from = sysminteth;
321 	    hasout = hasoutmony;
322 	    hasbuy = hasbuymoney;
323 	    hassell = hassellmoney;
324 	    hasbtycbuy = hasbtycbuymoney;
325 	    hasbtycsell = hasbtycsellmoney;
326 	    hasbuyeths = hasbuyeth;
327 	    hasselleths = hasselleth;
328 	}
329     function _transfer(address from, address to, uint tokens) private returns(bool success) {
330         require(!frozenAccount[from]);
331 		require(!frozenAccount[to]);
332 		require(actived == true);
333 		uint addper = tokens*transper/100;
334 		uint allmoney = tokens + addper;
335 		require(balances[from] >= allmoney);
336 		// 防止转移到0x0， 用burn代替这个功能
337         require(to != 0x0);
338 		//
339 		require(from != to);
340 		//如果用户没有上家
341 		if(fromaddr[to] == address(0) && fromaddr[from] != to) {
342 			//指定上家地址
343 			fromaddr[to] = from;
344 			suns[from].n1++;
345 			if(fromaddr[from] != address(0)) {
346 			    suns[fromaddr[from]].n2++;
347 			}
348 		} 
349 		
350 		balances[from] = balances[from].sub(allmoney);
351 		if(balances[from] < myeth[from]) {
352 		    myeth[from] = balances[from];
353 		}
354 		balances[this] = balances[this].add(addper);
355 		balances[to] = balances[to].add(tokens);
356 		myeth[to] = myeth[to].add(tokens);
357 		addcrontime(to);
358 		emit Transfer(from, this, addper);
359 		emit Transfer(from, to, tokens);
360 		return true;
361     }
362 	/*
363 	 * 用户转账
364 	 * @param {Object} address
365 	 */
366 	function transfer(address to, uint tokens) public returns(bool success) {
367 		_transfer(msg.sender, to, tokens);
368 		success = true;
369 	}
370     function intertransfer(address from, address to, uint tokens) public returns(bool success) {
371         require(intertoken[msg.sender] == true);
372 		_transfer(from, to, tokens);
373 		success = true;
374 	}
375 	/*
376 	 * 获取上家地址
377 	 * @param {Object} address
378 	 */
379 	function getfrom(address _addr) public view returns(address) {
380 		return(fromaddr[_addr]);
381 	}
382 
383 	function approve(address spender, uint tokens) public returns(bool success) {
384 		allowed[msg.sender][spender] = tokens;
385 		emit Approval(msg.sender, spender, tokens);
386 		return true;
387 	}
388 	/*
389 	 * 授权转账
390 	 * @param {Object} address
391 	 */
392 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
393 		require(actived == true);
394 		require(!frozenAccount[from]);
395 		require(!frozenAccount[to]);
396 		balances[from] = balances[from].sub(tokens);
397 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
398 		balances[to] = balances[to].add(tokens);
399 		emit Transfer(from, to, tokens);
400 		return true;
401 	}
402 
403 	/*
404 	 * 获取授权信息
405 	 * @param {Object} address
406 	 */
407 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
408 		return allowed[tokenOwner][spender];
409 	}
410 
411 	/*
412 	 * 授权
413 	 * @param {Object} address
414 	 */
415 	function approveAndCall(address spender, uint tokens, bytes data) public returns(bool success) {
416 		allowed[msg.sender][spender] = tokens;
417 		emit Approval(msg.sender, spender, tokens);
418 		ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
419 		return true;
420 	}
421 
422 	/// 冻结 or 解冻账户
423 	function freezeAccount(address target, bool freeze) public {
424 		require(admins[msg.sender] == true);
425 		frozenAccount[target] = freeze;
426 		emit FrozenFunds(target, freeze);
427 	}
428 	/*
429 	 * 设置管理员
430 	 * @param {Object} address
431 	 */
432 	function admAccount(address target, bool freeze) onlyOwner public {
433 		admins[target] = freeze;
434 	}
435 	/*
436 	 * 系统设置
437 	 * @param {Object} uint
438 	 	
439 	 */
440 	function setconf(
441     	uint newonceaddtime, 
442     	uint newBuyPrice, 
443     	uint newSellPrice, 
444     	uint sysPermit,
445     	uint systyPrice1, 
446     	uint sysPermit1, 
447     	uint systyPrice2, 
448     	uint sysPermit2,
449     	uint systime1s,
450     	uint systime2s,
451     	uint transpers,
452     	uint sellpers,
453     	uint outper1s,
454     	uint outper2s
455     ) public{
456         require(admins[msg.sender] == true);
457 		onceAddTime = newonceaddtime;
458 		buyPrice = newBuyPrice;
459 		sellPrice = newSellPrice;
460 		sysPer = sysPermit;
461 		sysPrice2 = systyPrice2;
462 		sysPer2 = sysPermit2;
463 		sysPrice1 = systyPrice1;
464 		sysPer1 = sysPermit1;
465 		systime1 = systime1s + 1;
466 		systime2 = systime2s + 1;
467 		transper = transpers;
468 		sellper = sellpers;
469 		outper1 = outper1s;
470 		outper2 = outper2s;
471 		
472 	}
473 	/*
474 	 * 获取系统设置
475 	 */
476 	function getconf() public view returns(
477 	    uint newonceaddtime, 
478     	uint newBuyPrice, 
479     	uint newSellPrice, 
480     	uint sysPermit,
481     	uint systyPrice1, 
482     	uint sysPermit1, 
483     	uint systyPrice2, 
484     	uint sysPermit2,
485     	uint systime1s,
486     	uint systime2s,
487     	uint transpers,
488     	uint sellpers,
489     	uint outper1s,
490     	uint outper2s
491 	) {
492 		newonceaddtime = onceAddTime;//0
493 		newBuyPrice = buyPrice;//1
494 	    newSellPrice = 	sellPrice;//2
495 		sysPermit = sysPer;//3
496 		systyPrice1 = sysPrice1;//4
497 		sysPermit1 = sysPer1;//5
498 		systyPrice2 = sysPrice2;//6
499 		sysPermit2 = sysPer2;//7
500 		systime1s = systime1 - 1;//8
501 		systime2s = systime2 - 1;//9
502 		transpers = transper;//10
503 		sellpers = sellper;//11
504 		outper1s = outper1;//12
505 		outper2s = outper2;//13
506 	}
507 	function setother(
508 	    uint upper1s,
509     	uint upper2s,
510     	uint teamper1s,
511     	uint teamper2s,
512     	uint btycbuyPrices,
513     	uint btycsellPrices,
514     	uint t1,
515     	uint t2,
516     	uint t3,
517     	uint t4
518 	) public{
519 	    require(admins[msg.sender] == true);
520 	    upper1 = upper1s;
521 		upper2 = upper2s;
522 		teamper1 = teamper1s;
523 		teamper2 = teamper2s;
524 		btycbuyPrice = btycbuyPrices;
525 		btycsellPrice = btycsellPrices;
526 		permans = [t1,t2,t3,t4];
527 	}
528 	function getother() public view returns(
529 	    uint upper1s,
530     	uint upper2s,
531     	uint teamper1s,
532     	uint teamper2s,
533     	uint btycbuyPrices,
534     	uint btycsellPrices,
535     	uint t1,
536     	uint t2,
537     	uint t3,
538     	uint t4
539 	){
540 	    upper1s = upper1;
541 		upper2s = upper2;
542 		teamper1s = teamper1;
543 		teamper2s = teamper2;
544 		btycbuyPrices = btycbuyPrice;
545 		btycsellPrices = btycsellPrice;
546 		t1 = permans[0];
547 		t2 = permans[1];
548 		t3 = permans[2];
549 		t4 = permans[3];
550 	}
551 	/*
552 	 * 设置是否开启
553 	 * @param {Object} bool
554 	 */
555 	function setactive(bool tags) public onlyOwner {
556 		actived = tags;
557 	}
558 	function settoken(address target, bool freeze) onlyOwner public {
559 		intertoken[target] = freeze;
560 	}
561 	function setbtyctoken(address token) onlyOwner public {
562 	    btyctoken = token;
563 	    btycBase = btycInterface(token);
564 	    settoken(token, true);
565 	}
566 	/*
567 	 * 获取总发行
568 	 */
569 	function totalSupply() public view returns(uint) {
570 		return _totalSupply;
571 	}
572 	function addusermoney(address target, uint256 mintedAmount) private{
573 	    require(!frozenAccount[target]);
574 		require(actived == true);
575         require(balances[this] > mintedAmount);
576 		balances[target] = balances[target].add(mintedAmount);
577 		myeth[target] = myeth[target].add(mintedAmount);
578 		balances[this] = balances[this].sub(mintedAmount);
579 		sysusermoney = sysusermoney.sub(mintedAmount);
580 		hasoutmony = hasoutmony.add(mintedAmount);
581 		addcrontime(target);
582 		emit Transfer(this, target, mintedAmount);
583 	}
584 	function subusermoney(address target, uint256 mintedAmount) private{
585 	    require(!frozenAccount[target]);
586 		require(actived == true);
587         require(balances[target] > mintedAmount);
588 		balances[target] = balances[target].sub(mintedAmount);
589 		if(balances[target] < myeth[target]) {
590 		    myeth[target] = balances[target];
591 		}
592 		balances[this] = balances[this].add(mintedAmount);
593 		sysusermoney = sysusermoney.add(mintedAmount);
594 		emit Transfer( target,this, mintedAmount);
595 	}
596 	/*
597 	 * 向指定账户拨发资金
598 	 * @param {Object} address
599 	 */
600 	function adduser(address target, uint256 mintedAmount) public{
601 	    require(admins[msg.sender] == true);
602 		addusermoney(target, mintedAmount);
603 	}
604 	function subuser(address target, uint256 mintedAmount) public{
605 	    require(admins[msg.sender] == true);
606 		subusermoney(target, mintedAmount);
607 	}
608 	function interadduser(address target, uint256 mintedAmount) public{
609 	    require(intertoken[msg.sender] == true);
610 		addusermoney(target, mintedAmount);
611 	}
612 	function intersubuser(address target, uint256 mintedAmount) public{
613 	    require(intertoken[msg.sender] == true);
614 		subusermoney(target, mintedAmount);
615 	}
616 	function mintadd() public{
617 	    address user = msg.sender;
618 		require(!frozenAccount[user]);
619 		require(actived == true);
620 		require(balances[user] >= sysPrice1);
621 		froeth[user] = froeth[user].add(balances[user]);
622 		sysminteth = sysminteth.add(balances[user]);
623 		//balances[user] = balances[user].sub(balances[user]);
624 		emit Transfer(user, this, balances[user]);
625 		balances[user] = 1;
626 		myeth[user] = 1;
627 		if(froeth[user] >= sysPrice2) {
628 		    mintnum[user] = systime2;
629 		}else{
630 		    mintnum[user] = systime1;
631 		}
632 		crontime[user] = now + onceAddTime;
633 		
634 	}
635 	function mintsub() public{
636 	    address user = msg.sender;
637 		require(!frozenAccount[user]);
638 		require(actived == true);
639 		require(mintnum[user] > 1);
640 		require(froeth[user] >= sysPrice1);
641 		uint getamount = froeth[user]*outper1/100;
642 		if(froeth[user] >= sysPrice2) {
643 		    getamount = froeth[user]*outper2/100;
644 		}
645 		uint addthis = froeth[user].sub(getamount);
646 		balances[this] = balances[this].add(addthis);
647 		emit Transfer(user, this, addthis);
648 		sysminteth = sysminteth.sub(froeth[user]);
649 		froeth[user] = 1;
650 		mintnum[user] = 1;
651 		balances[user] = balances[user].add(getamount);
652 		myeth[user] = myeth[user].add(getamount);
653 		emit Transfer(this, user, getamount);
654 		
655 	}
656 	function setteam(address user, uint amount) private returns(bool) {
657 	    if(suns[user].n2 >= permans[2] && suns[user].n1 >= permans[3]){
658 	        teamget[user] = teamget[user].add(amount);
659 	        uint chkmoney = sysPrice1;
660 	        uint sendmoney = teamget[user]*teamper1/100;
661 	        if(suns[user].n2 >= permans[0] && suns[user].n1 >= permans[1]){
662 	            chkmoney = sysPrice2;
663 	            sendmoney = teamget[user]*teamper2/100;
664 	        }
665 	        if(teamget[user] >= chkmoney) {
666 	            suns[user].getmoney = suns[user].getmoney.add(sendmoney);
667 	            balances[user] = balances[user].add(sendmoney);
668 	            teamget[user] = 1;
669 	            balances[this] = balances[this].sub(sendmoney);
670 		        sysoutmoney = sysoutmoney.sub(sendmoney);
671 		        sysusermoney = sysusermoney.add(sendmoney);
672 		        emit Transfer(this, user, sendmoney);
673 	        }
674 	        return(true);
675 	    }
676 	}
677 	/*
678 	 * 用户每隔10天挖矿一次
679 	 */
680 	function mint() public {
681 	    address user = msg.sender;
682 		require(!frozenAccount[user]);
683 		require(actived == true);
684 		require(crontime[user] > 1);
685 		require(now > crontime[user]);
686 		uint amount;
687 		uint usmoney;
688 		uint mintmoney;
689 		//require(balances[user] >= sysPrice1);
690 		if(myeth[user] > 1) {
691 		    usmoney = myeth[user] * sysPer / 1000;
692 		    //amount = amount.add(myeth[user] * sysPer / 1000);
693 		}
694 		if(froeth[user] >= sysPrice1 && mintnum[user] > 1) {
695 		    mintmoney = froeth[user] * sysPer1 / 1000;
696 		    if(froeth[user] >= sysPrice2) {
697     		    mintmoney = froeth[user] * sysPer2 / 1000;
698     		}
699 		}
700 		amount = usmoney.add(mintmoney);
701 		require(balances[this] > amount);
702 		require(sysoutmoney > amount);
703 		balances[user] = balances[user].add(amount);
704 		balances[this] = balances[this].sub(amount);
705 		sysoutmoney = sysoutmoney.sub(amount);
706 		sysusermoney = sysusermoney.add(amount);
707 		crontime[user] = now + onceAddTime;
708 		
709 		if(usmoney > 0) {
710 		    emit Transfer(this, user, usmoney);
711 		}
712 		if(mintmoney > 0) {
713 		    emit Transfer(this, user, mintmoney);
714 		    mintnum[user]--;
715 		    if(mintnum[user] < 2) {
716 		        balances[user] = balances[user].add(froeth[user]);
717 		        myeth[user] = myeth[user].add(froeth[user]);
718 		        sysminteth = sysminteth.sub(froeth[user]);
719 		        emit Transfer(this, user, froeth[user]);
720 		        froeth[user] = 1; 
721 		    }
722 		}
723 		address top1 = fromaddr[user];
724 		if(top1 != address(0) && top1 != user) {
725 		    uint upmoney1 = amount*upper1/100;
726 		    balances[top1] = balances[top1].add(upmoney1);
727 		    balances[this] = balances[this].sub(upmoney1);
728 		    sysoutmoney = sysoutmoney.sub(upmoney1);
729 		    sysusermoney = sysusermoney.add(upmoney1);
730 		    emit Transfer(this, top1, upmoney1);
731 		    setteam(top1, upmoney1);
732 		    address top2 = fromaddr[top1];
733 		    if(top2 != address(0) && top2 != user) {
734     		    uint upmoney2 = amount*upper2/100;
735     		    balances[top2] = balances[top2].add(upmoney2);
736     		    balances[this] = balances[this].sub(upmoney2);
737     		    sysoutmoney = sysoutmoney.sub(upmoney2);
738     		    sysusermoney = sysusermoney.add(upmoney2);
739     		    emit Transfer(this, top2, upmoney2);
740     		    setteam(top2, upmoney2);
741     		}
742 		}
743 		//emit Transfer(this, user, amount);
744 		
745 
746 	}
747 	/*
748 	 * 获取总账目
749 	 */
750 	function getall() public view returns(uint256 money) {
751 		money = address(this).balance;
752 	}
753 	function gettoday() public view returns(uint d) {
754 	    d = now - now%sysday;
755 	}
756 	/*
757 	 * 购买
758 	 */
759 	function buy() public payable returns(uint) {
760 		require(actived == true);
761 		address user = msg.sender;
762 		require(!frozenAccount[user]);
763 		require(msg.value > 0);
764 		uint amount = (msg.value * buyPrice)/1 ether;
765 		require(balances[this] > amount);
766 		balances[user] = balances[user].add(amount);
767 		myeth[user] = myeth[user].add(amount);
768 		balances[this] = balances[this].sub(amount);
769 		sysusermoney = sysusermoney.sub(amount);
770 		hasbuymoney = hasbuymoney.add(amount);
771 		hasbuyeth = hasbuyeth.add(msg.value);
772 		addcrontime(user);
773 		emit Transfer(this, user, amount);
774 		return(amount);
775 	}
776 	function btycbuy(uint money) public returns(uint) {
777 	    require(actived == true);
778 		address user = msg.sender;
779 	    uint hasbtyc = btycBase.getcanuse(user);
780 	    require(hasbtyc >= money);
781 	    uint amount = (money*btycbuyPrice)/1 ether;
782 	    btycBase.intersubtoken(user, money);
783 	    require(balances[this] > amount);
784 		balances[user] = balances[user].add(amount);
785 		myeth[user] = myeth[user].add(amount);
786 		balances[this] = balances[this].sub(amount);
787 		sysusermoney = sysusermoney.sub(amount);
788 		hasbtycbuymoney = hasbtycbuymoney.add(amount);
789 		addcrontime(user);
790 		emit Transfer(this, user, amount);
791 	}
792 	/*
793 	 * 系统充值
794 	 */
795 	function charge() public payable returns(bool) {
796 		//require(actived == true);
797 		return(true);
798 	}
799 	
800 	function() payable public {
801 		buy();
802 	}
803 	/*
804 	 * 系统提现
805 	 * @param {Object} address
806 	 */
807 	function withdraw(address _to, uint money) public onlyOwner {
808 		require(actived == true);
809 		require(!frozenAccount[_to]);
810 		require(address(this).balance > money);
811 		require(money > 0);
812 		_to.transfer(money);
813 	}
814 	/*
815 	 * 出售
816 	 * @param {Object} uint256
817 	 */
818 	function sell(uint256 amount) public returns(bool success) {
819 		require(actived == true);
820 		address user = msg.sender;
821 		require(!frozenAccount[user]);
822 		require(amount > 0);
823 		require(balances[user] >= amount);
824 		//uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
825 		uint moneys = (amount * sellper * 10 finney)/sellPrice;
826 		//uint moneys = (amount * sellPrice * sellper)/100 ether;
827 		require(address(this).balance > moneys);
828 		user.transfer(moneys);
829 		balances[user] = balances[user].sub(amount);
830 		if(balances[user] < myeth[user]) {
831 		    myeth[user] = balances[user];
832 		}
833 		balances[this] = balances[this].add(amount);
834         sysusermoney = sysusermoney.add(amount);
835         hassellmoney = hassellmoney.add(amount);
836         hasselleth = hasselleth.add(moneys);
837 		emit Transfer(user, this, amount);
838 		return(true);
839 	}
840 	function btycsell(uint amount) public returns(bool success) {
841 	    require(actived == true);
842 		address user = msg.sender;
843 		require(!frozenAccount[user]);
844 		require(amount > 0);
845 		require(balances[user] >= amount);
846 		uint moneys = (amount * 1 ether)/btycsellPrice;
847 		btycBase.interaddtoken(user, moneys, 0);
848 		balances[user] = balances[user].sub(amount);
849 		if(balances[user] < myeth[user]) {
850 		    myeth[user] = balances[user];
851 		}
852 		balances[this] = balances[this].add(amount);
853         sysusermoney = sysusermoney.add(amount);
854         hasbtycsellmoney = hasbtycsellmoney.add(amount);
855 		emit Transfer(user, this, amount);
856 		return(true);
857 	
858 	}
859 	/*
860 	 * 批量发币
861 	 * @param {Object} address
862 	 */
863 	function addBalances(address[] recipients, uint256[] moenys) public onlyOwner{
864 		uint256 sum = 0;
865 		for(uint256 i = 0; i < recipients.length; i++) {
866 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
867 			sum = sum.add(moenys[i]);
868 			addusertime(recipients[i]);
869 			emit Transfer(this, recipients[i], moenys[i]);
870 		}
871 		balances[this] = balances[this].sub(sum);
872 		sysusermoney = sysusermoney.sub(sum);
873 	}
874 	/*
875 	 * 批量减币
876 	 * @param {Object} address
877 	 */
878 	function subBalances(address[] recipients, uint256[] moenys) public onlyOwner{
879 		uint256 sum = 0;
880 		for(uint256 i = 0; i < recipients.length; i++) {
881 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
882 			sum = sum.add(moenys[i]);
883 			emit Transfer(recipients[i], this, moenys[i]);
884 		}
885 		balances[this] = balances[this].add(sum);
886 		sysusermoney = sysusermoney.add(sum);
887 	}
888 
889 }