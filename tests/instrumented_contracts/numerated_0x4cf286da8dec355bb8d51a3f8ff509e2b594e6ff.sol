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
50 
51 interface btycInterface {
52     function balanceOf(address _addr) external view returns (uint256);
53     function getcanuse(address tokenOwner) external view returns(uint);
54 }
55 // ----------------------------------------------------------------------------
56 // 核心类
57 // ----------------------------------------------------------------------------
58 contract BTYCEC is ERC20Interface {
59 	using SafeMath
60 	for uint;
61 
62 	string public symbol;
63 	string public name;
64 	uint8 public decimals;
65 	uint _totalSupply;//总发行
66 	uint public sysusermoney;//流通 
67 	uint public sysoutmoney;//矿池 
68 
69 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
70 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
71 	uint public btycbuyPrice; //购买价格 多少btyc可购买1枚代币 /1000
72 	uint public btycsellPrice; 
73 	uint public sysPer; //挖矿的增量百分比 /2%
74 	uint public sysPrice1; //挖矿的衡量值300
75 	uint public sysPer1; //挖矿的增量百分比 /3.2%
76 	uint public systime1;//120
77 	uint public sysPrice2; //挖矿的衡量值900
78 	uint public sysPer2; //挖矿的增量百分比 /4%
79 	uint public systime2;//200
80 	uint public transper; //转账手续费 /3%
81 	
82 	bool public actived;
83 	uint public onceAddTime; //挖矿的时间 10 days
84 	uint public upper1;//团队奖% 
85 	uint public upper2;//团队奖% 
86 	uint public teamper1;//团队奖% 
87 	uint public teamper2;//团队奖% 
88 	uint public outper1;//退出锁仓
89 	uint public outper2;//退出锁仓
90 	uint public sellper;//
91 	uint public sysday;
92 	//bool public openout;
93     uint public sysminteth;
94     uint public hasoutmony;
95     uint public hasbuymoney;
96     uint public hassellmoney;
97     uint public hasbuyeth;
98     uint public hasselleth;
99     uint public hasbtycbuymoney;
100     uint public hasbtycsellmoney;
101 	mapping(address => uint) balances;//总计
102 	mapping(address => uint) myeth;//本金
103 	mapping(address => uint) froeth;//冻结
104 	//mapping(address => uint) used;
105 	mapping(address => mapping(address => uint)) allowed;
106 
107 	/* 冻结账户 */
108 	mapping(address => bool) public frozenAccount;
109 
110 	//上家地址
111 	mapping(address => address) public fromaddr;
112 
113 	// 记录各个账户的增量时间
114 	mapping(address => uint) public crontime;
115 	// 挖矿次数
116 	mapping(address => uint) public mintnum;
117 	uint[] public permans;
118 	mapping(address => uint) public teamget;
119 	struct sunsdata{
120 	    uint n1;
121 	    uint n2;
122 	    uint getmoney;
123 	}
124     mapping(address => sunsdata) public suns;
125     btycInterface public btycBase = btycInterface(0x25FDf7f507D6124377e48409713292022D9fB69e);
126 	/* 通知 */
127 	event FrozenFunds(address target, bool frozen);
128 	address public owner;
129     modifier onlyOwner {
130 		require(msg.sender == owner);
131 		_;
132 	}
133 	// ------------------------------------------------------------------------
134 	// Constructor
135 	// ------------------------------------------------------------------------
136 	constructor() public {
137 
138 		symbol = "BTYCEC";
139 		name = "BTYCEC Coin";
140 		decimals = 18;
141 		_totalSupply = 43200000 ether;//总发行
142 		sysusermoney = 21000000 ether;//流通
143 		sysoutmoney  = 22200000 ether;//矿池
144 
145 		sellPrice = 19.545 ether; //出售价格 1btyc can buy how much eth
146 		buyPrice = 19.545 ether; //购买价格 1eth can buy how much btyc
147 		btycbuyPrice = 0.00001 ether;
148 		btycsellPrice = 1 ether;
149 		sysPrice1 = 300 ether; //挖矿的衡量值
150 		//sysPrice1 = 3 ether;//test
151 		sysPer  = 20; //挖矿的增量百分比 /1000
152 		sysPer1 = 32; //挖矿的增量百分比 /1000
153 		sysPrice2 = 900 ether; //挖矿的衡量值
154 		//sysPrice2 = 9 ether; //test
155 		sysPer2 = 40; //挖矿的增量百分比 /1000
156 		transper = 3;//转账手续费 /100
157 		upper1 = 20;//第1代挖矿分润
158 		upper2 = 10;//第2代挖矿分润
159 		teamper1 = 10;//团队奖% /100
160 		teamper2 = 20;//团队奖% /100
161 		outper1 = 80;//退出锁仓 /100
162 		outper2 = 70;//退出锁仓 /100
163 		sellper = 85;// /100
164 		actived = true;
165 		onceAddTime = 10 days; //挖矿的时间 正式
166 		//onceAddTime = 300 seconds;//test
167 		sysday = 1 days; 
168 		//sysday = 30 seconds;//test
169         systime1 = 13;
170         systime2 = 21;
171         permans = [40,20,12,6];
172         //permans = [8,6,4,2];//test
173 		balances[this] = _totalSupply;
174 		owner = msg.sender;
175 		emit Transfer(address(0), owner, _totalSupply);
176 
177 	}
178 
179 	/* 获取用户金额 */
180 	function balanceOf(address user) public view returns(uint balance) {
181 		return balances[user];
182 	}
183 	function ethbalance(address user) public view returns(uint balance) {
184 		return user.balance;
185 	}
186 	
187 	function btycbalanceOf(address user) public view returns(uint balance) {
188 		return btycBase.balanceOf(user);
189 	}
190     function addcrontime(address addr) private{
191         if(crontime[addr] < now) {
192             crontime[addr] = now + onceAddTime;
193         }
194         
195     }
196     function addusertime(address addr) private{
197         if(balances[addr] < 2) {
198             addcrontime(addr);
199         }
200     }
201 	/*
202 	 * 获取用户的挖矿时间
203 	 * @param {Object} address
204 	 */
205 	function getaddtime(address _addr) public view returns(uint) {
206 		if(crontime[_addr] < 2) {
207 			return(0);
208 		}else{
209 		    return(crontime[_addr]);
210 		}
211 		
212 	}
213 	function getmy(address user) public view returns(
214 	    uint myblance,
215 	    uint mybtyc,
216 	    uint meth,
217 	    uint myeths,
218 	    uint mypro,
219 	    uint mytime,
220 	    uint bprice,
221 	    uint sprice,
222 	    uint cprice,
223 	    uint tmoney,
224 	    uint myall
225 	){
226 	    myblance = balances[user];//0
227 	    mybtyc = btycbalanceOf(user);//1
228 	    meth = address(user).balance;//2
229 	    myeths = myeth[user];//3
230 	    mypro = froeth[user];//4
231 	    mytime = crontime[user];//5
232 	    bprice = buyPrice;//6
233 	    sprice = sellPrice;//7
234 	    cprice = btycbuyPrice;//8
235 	    tmoney = balances[this];//9
236 	    myall = myblance.add(mypro);//10
237 	}
238 	function geteam(address user) public view returns(
239 	    uint nn1,//0
240 	    uint nn2,//1
241 	    uint ms,//2
242 	    uint tm,//3
243 	    uint mintmoneys,//4
244 	    uint usermoneys,//5
245 	    uint fromoneys,//6
246 	    uint lid,//7
247 	    uint tmoney
248 	){
249 	    nn1 = suns[user].n1;
250 	    nn2 = suns[user].n2;
251 	    ms = teamget[user];
252 	    tm = getaddtime(user);
253 	    mintmoneys = sysoutmoney;
254 	    usermoneys = sysusermoney;
255 	    fromoneys = sysminteth;
256 	    if(suns[user].n2 > permans[2] && suns[user].n1 > permans[3]){
257 	        lid = 1;
258 	    }
259 	    if(suns[user].n2 > permans[0] && suns[user].n1 > permans[1]){
260 	        lid = 2;
261 	    }
262 	    tmoney = _totalSupply.sub(balances[this]);//9
263 	}
264 	function getsys() public view returns(
265 	    uint tmoney,//0
266 	    uint outm,//1
267 	    uint um,//2
268 	    uint from,//3
269 	    uint hasout,//4
270 	    uint hasbuy,//5
271 	    uint hassell,//6
272 	    uint hasbtycbuy,//7
273 	    uint hasbtycsell,//8
274 	    uint hasbuyeths,//9
275 	    uint hasselleths//10
276 	){
277 	    tmoney = _totalSupply.sub(balances[this]);
278 	    outm = sysoutmoney;
279 	    um = sysusermoney;
280 	    from = sysminteth;
281 	    hasout = hasoutmony;
282 	    hasbuy = hasbuymoney;
283 	    hassell = hassellmoney;
284 	    hasbtycbuy = hasbtycbuymoney;
285 	    hasbtycsell = hasbtycsellmoney;
286 	    hasbuyeths = hasbuyeth;
287 	    hasselleths = hasselleth;
288 	}
289 
290 	/*
291 	 * 用户转账
292 	 * @param {Object} address
293 	 */
294 	function transfer(address to, uint tokens) public returns(bool success) {
295 	    address from = msg.sender;
296 		require(!frozenAccount[from]);
297 		require(!frozenAccount[to]);
298 		require(tokens > 1 && tokens < _totalSupply);
299 		require(actived == true);
300 		uint addper = tokens*transper/100;
301 		uint allmoney = tokens + addper;
302 		require(balances[from] >= allmoney);
303 		require(addper < balances[from] && addper > 0);
304 		// 防止转移到0x0， 用burn代替这个功能
305         require(to != 0x0);
306 		require(from != to);
307 		// 将此保存为将来的断言， 函数最后会有一个检验103 - 3 + 10
308         uint previousBalances = balances[from] - addper + balances[to];
309 		//如果用户没有上家
310 		if(fromaddr[to] == address(0) && fromaddr[from] != to) {
311 			//指定上家地址
312 			fromaddr[to] = from;
313 			suns[from].n1++;
314 			if(fromaddr[from] != address(0)) {
315 			    suns[fromaddr[from]].n2++;
316 			}
317 		} 
318 		
319 		balances[from] = balances[from].sub(allmoney);
320 		if(balances[from] < myeth[from]) {
321 		    myeth[from] = balances[from];
322 		}
323 		balances[this] = balances[this].add(addper);
324 		balances[to] = balances[to].add(tokens);
325 		myeth[to] = myeth[to].add(tokens);
326 		addcrontime(to);
327 		emit Transfer(from, this, addper);
328 		emit Transfer(from, to, tokens);
329 		// 断言检测， 不应该为错
330         assert(balances[from] + balances[to] == previousBalances);//90 10
331 		return true;
332 	}
333 
334 	function getfrom(address _addr) public view returns(address) {
335 		return(fromaddr[_addr]);
336 	}
337 
338 	function approve(address spender, uint tokens) public returns(bool success) {
339 	    require(balances[msg.sender] >= tokens);
340 		allowed[msg.sender][spender] = tokens;
341 		emit Approval(msg.sender, spender, tokens);
342 		return true;
343 	}
344 	/*
345 	 * 授权转账
346 	 * @param {Object} address
347 	 */
348 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
349 		require(actived == true);
350 		require(!frozenAccount[from]);
351 		require(!frozenAccount[to]);
352 		require(balances[from] >= tokens);
353 		require(tokens > 1 && tokens < _totalSupply);
354 		balances[from] = balances[from].sub(tokens);
355 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
356 		balances[to] = balances[to].add(tokens);
357 		emit Transfer(from, to, tokens);
358 		return true;
359 	}
360 
361 	/*
362 	 * 获取授权信息
363 	 * @param {Object} address
364 	 */
365 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
366 		return allowed[tokenOwner][spender];
367 	}
368 
369 	/*
370 	 * 授权
371 	 * @param {Object} address
372 	 */
373 	function approveAndCall(address spender, uint tokens) public returns(bool success) {
374 	    require(!frozenAccount[spender]);
375 	    require(balances[msg.sender] >= tokens);
376 	    require(tokens > 1 && tokens < _totalSupply);
377 		allowed[msg.sender][spender] = tokens;
378 		emit Approval(msg.sender, spender, tokens);
379 		//ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
380 		return true;
381 	}
382 
383 	/// 冻结 or 解冻账户
384 	function freezeAccount(address target, bool freeze) onlyOwner public {
385 		frozenAccount[target] = freeze;
386 		emit FrozenFunds(target, freeze);
387 	}
388 
389 	/*
390 	 * 系统设置
391 	 * @param {Object} uint
392 	 	
393 	 */
394 	function setconf(
395     	uint newonceaddtime, 
396     	uint newBuyPrice, 
397     	uint newSellPrice, 
398     	uint sysPermit,
399     	uint systyPrice1, 
400     	uint sysPermit1, 
401     	uint systyPrice2, 
402     	uint sysPermit2,
403     	uint systime1s,
404     	uint systime2s,
405     	uint transpers,
406     	uint sellpers,
407     	uint outper1s,
408     	uint outper2s
409     ) onlyOwner public{
410 		onceAddTime = newonceaddtime;
411 		buyPrice = newBuyPrice;
412 		sellPrice = newSellPrice;
413 		sysPer = sysPermit;
414 		sysPrice2 = systyPrice2;
415 		sysPer2 = sysPermit2;
416 		sysPrice1 = systyPrice1;
417 		sysPer1 = sysPermit1;
418 		systime1 = systime1s + 1;
419 		systime2 = systime2s + 1;
420 		transper = transpers;
421 		sellper = sellpers;
422 		outper1 = outper1s;
423 		outper2 = outper2s;
424 		
425 	}
426 	/*
427 	 * 获取系统设置
428 	 */
429 	function getconf() public view returns(
430 	    uint newonceaddtime, 
431     	uint newBuyPrice, 
432     	uint newSellPrice, 
433     	uint sysPermit,
434     	uint systyPrice1, 
435     	uint sysPermit1, 
436     	uint systyPrice2, 
437     	uint sysPermit2,
438     	uint systime1s,
439     	uint systime2s,
440     	uint transpers,
441     	uint sellpers,
442     	uint outper1s,
443     	uint outper2s
444 	) {
445 		newonceaddtime = onceAddTime;//0
446 		newBuyPrice = buyPrice;//1
447 	    newSellPrice = 	sellPrice;//2
448 		sysPermit = sysPer;//3
449 		systyPrice1 = sysPrice1;//4
450 		sysPermit1 = sysPer1;//5
451 		systyPrice2 = sysPrice2;//6
452 		sysPermit2 = sysPer2;//7
453 		systime1s = systime1 - 1;//8
454 		systime2s = systime2 - 1;//9
455 		transpers = transper;//10
456 		sellpers = sellper;//11
457 		outper1s = outper1;//12
458 		outper2s = outper2;//13
459 	}
460 	function setother(
461 	    uint upper1s,
462     	uint upper2s,
463     	uint teamper1s,
464     	uint teamper2s,
465     	uint btycbuyPrices,
466     	uint btycsellPrices,
467     	uint t1,
468     	uint t2,
469     	uint t3,
470     	uint t4
471 	) public onlyOwner{
472 	    upper1 = upper1s;
473 		upper2 = upper2s;
474 		teamper1 = teamper1s;
475 		teamper2 = teamper2s;
476 		btycbuyPrice = btycbuyPrices;
477 		btycsellPrice = btycsellPrices;
478 		permans = [t1,t2,t3,t4];
479 	}
480 	function getother() public view returns(
481 	    uint upper1s,
482     	uint upper2s,
483     	uint teamper1s,
484     	uint teamper2s,
485     	uint btycbuyPrices,
486     	uint btycsellPrices,
487     	uint t1,
488     	uint t2,
489     	uint t3,
490     	uint t4
491 	){
492 	    upper1s = upper1;
493 		upper2s = upper2;
494 		teamper1s = teamper1;
495 		teamper2s = teamper2;
496 		btycbuyPrices = btycbuyPrice;
497 		btycsellPrices = btycsellPrice;
498 		t1 = permans[0];
499 		t2 = permans[1];
500 		t3 = permans[2];
501 		t4 = permans[3];
502 	}
503 	/*
504 	 * 设置是否开启
505 	 * @param {Object} bool
506 	 */
507 	function setactive(bool tags) public onlyOwner {
508 		actived = tags;
509 	}
510 	/*
511 	function setbtyctoken(address token) onlyOwner public {
512 	    btyctoken = token;
513 	    //btycBase = btycInterface(token);
514 	    settoken(token, true);
515 	}*/
516 	/*
517 	 * 获取总发行
518 	 */
519 	function totalSupply() public view returns(uint) {
520 		return _totalSupply;
521 	}
522 	/*
523 	 * 向指定账户拨发资金
524 	 * @param {Object} address
525 	 */
526 	function adduser(address target, uint256 mintedAmount) public onlyOwner{
527 		require(!frozenAccount[target]);
528 		require(actived == true);
529         require(balances[this] > mintedAmount);
530 		balances[target] = balances[target].add(mintedAmount);
531 		myeth[target] = myeth[target].add(mintedAmount);
532 		balances[this] = balances[this].sub(mintedAmount);
533 		sysusermoney = sysusermoney.sub(mintedAmount);
534 		hasoutmony = hasoutmony.add(mintedAmount);
535 		addcrontime(target);
536 		emit Transfer(this, target, mintedAmount);
537 	}
538 	function subuser(address target, uint256 mintedAmount) public onlyOwner{
539 		require(!frozenAccount[target]);
540 		require(actived == true);
541         require(balances[target] > mintedAmount);
542 		balances[target] = balances[target].sub(mintedAmount);
543 		if(balances[target] < myeth[target]) {
544 		    myeth[target] = balances[target];
545 		}
546 		balances[this] = balances[this].add(mintedAmount);
547 		sysusermoney = sysusermoney.add(mintedAmount);
548 		emit Transfer( target,this, mintedAmount);
549 	}
550 
551 	function mintadd() public{
552 	    address user = msg.sender;
553 	    uint money = balances[user];
554 		require(!frozenAccount[user]);
555 		require(actived == true);
556 		require(money >= sysPrice1);
557 		froeth[user] = froeth[user].add(money);
558 		sysminteth = sysminteth.add(money);
559 		balances[user] = 1;
560 		myeth[user] = 1;
561 		if(froeth[user] >= sysPrice2) {
562 		    mintnum[user] = systime2;
563 		}else{
564 		    mintnum[user] = systime1;
565 		}
566 		crontime[user] = now + onceAddTime;
567 		emit Transfer(user, this, money);
568 		
569 	}
570 	function mintsub() public{
571 	    address user = msg.sender;
572 		require(!frozenAccount[user]);
573 		require(actived == true);
574 		require(mintnum[user] > 1);
575 		require(froeth[user] >= sysPrice1);
576 		uint getamount = froeth[user]*outper1/100;
577 		if(froeth[user] >= sysPrice2) {
578 		    getamount = froeth[user]*outper2/100;
579 		}
580 		
581 		uint addthis = froeth[user].sub(getamount);
582 		balances[this] = balances[this].add(addthis);
583 		emit Transfer(user, this, addthis);
584 		if(sysminteth == froeth[user]){
585 		    sysminteth = sysminteth.add(1);
586 		}
587 		sysminteth = sysminteth.sub(froeth[user]);
588 		froeth[user] = 1;
589 		mintnum[user] = 1;
590 		balances[user] = balances[user].add(getamount);
591 		myeth[user] = myeth[user].add(getamount);
592 		emit Transfer(this, user, getamount);
593 		
594 	}
595 	function setteam(address user, uint amount) private returns(bool) {
596 	    if(suns[user].n2 >= permans[2] && suns[user].n1 >= permans[3]){
597 	        teamget[user] = teamget[user].add(amount);
598 	        uint chkmoney = sysPrice1;
599 	        uint sendmoney = teamget[user]*teamper1/100;
600 	        if(suns[user].n2 >= permans[0] && suns[user].n1 >= permans[1]){
601 	            chkmoney = sysPrice2;
602 	            sendmoney = teamget[user]*teamper2/100;
603 	        }
604 	        if(teamget[user] >= chkmoney) {
605 	            suns[user].getmoney = suns[user].getmoney.add(sendmoney);
606 	            balances[user] = balances[user].add(sendmoney);
607 	            teamget[user] = 1;
608 	            balances[this] = balances[this].sub(sendmoney);
609 		        sysoutmoney = sysoutmoney.sub(sendmoney);
610 		        sysusermoney = sysusermoney.add(sendmoney);
611 		        emit Transfer(this, user, sendmoney);
612 	        }
613 	        return(true);
614 	    }
615 	}
616 	/*
617 	 * 用户每隔10天挖矿一次
618 	 */
619 	function mint() public {
620 	    address user = msg.sender;
621 		require(!frozenAccount[user]);
622 		require(actived == true);
623 		require(crontime[user] > 1);
624 		require(now > crontime[user]);
625 		uint amount;
626 		uint usmoney;
627 		uint mintmoney;
628 		//require(balances[user] >= sysPrice1);
629 		if(myeth[user] > 1) {
630 		    usmoney = myeth[user] * sysPer / 1000;
631 		    //amount = amount.add(myeth[user] * sysPer / 1000);
632 		}
633 		if(froeth[user] >= sysPrice1 && mintnum[user] > 1) {
634 		    mintmoney = froeth[user] * sysPer1 / 1000;
635 		    if(froeth[user] >= sysPrice2) {
636     		    mintmoney = froeth[user] * sysPer2 / 1000;
637     		}
638 		}
639 		amount = usmoney.add(mintmoney);
640 		require(balances[this] > amount);
641 		require(sysoutmoney > amount);
642 		balances[user] = balances[user].add(amount);
643 		balances[this] = balances[this].sub(amount);
644 		sysoutmoney = sysoutmoney.sub(amount);
645 		sysusermoney = sysusermoney.add(amount);
646 		crontime[user] = now + onceAddTime;
647 		
648 		if(usmoney > 0) {
649 		    emit Transfer(this, user, usmoney);
650 		}
651 		if(mintmoney > 0) {
652 		    emit Transfer(this, user, mintmoney);
653 		    mintnum[user]--;
654 		    if(mintnum[user] < 2) {
655 		        balances[user] = balances[user].add(froeth[user]);
656 		        myeth[user] = myeth[user].add(froeth[user]);
657 		        sysminteth = sysminteth.sub(froeth[user]);
658 		        emit Transfer(this, user, froeth[user]);
659 		        froeth[user] = 1; 
660 		    }
661 		}
662 		address top1 = fromaddr[user];
663 		if(top1 != address(0) && top1 != user) {
664 		    uint upmoney1 = amount*upper1/100;
665 		    balances[top1] = balances[top1].add(upmoney1);
666 		    balances[this] = balances[this].sub(upmoney1);
667 		    sysoutmoney = sysoutmoney.sub(upmoney1);
668 		    sysusermoney = sysusermoney.add(upmoney1);
669 		    emit Transfer(this, top1, upmoney1);
670 		    setteam(top1, upmoney1);
671 		    address top2 = fromaddr[top1];
672 		    if(top2 != address(0) && top2 != user) {
673     		    uint upmoney2 = amount*upper2/100;
674     		    balances[top2] = balances[top2].add(upmoney2);
675     		    balances[this] = balances[this].sub(upmoney2);
676     		    sysoutmoney = sysoutmoney.sub(upmoney2);
677     		    sysusermoney = sysusermoney.add(upmoney2);
678     		    emit Transfer(this, top2, upmoney2);
679     		    setteam(top2, upmoney2);
680     		}
681 		}
682 		//emit Transfer(this, user, amount);
683 		
684 
685 	}
686 	/*
687 	 * 获取总账目
688 	 */
689 	function getall() public view returns(uint256 money) {
690 		money = address(this).balance;
691 	}
692 	function gettoday() public view returns(uint d) {
693 	    d = now - now%sysday;
694 	}
695 	/*
696 	 * 购买
697 	 */
698 	function buy() public payable returns(uint) {
699 		require(actived == true);
700 		address user = msg.sender;
701 		require(!frozenAccount[user]);
702 		require(msg.value > 0);
703 		uint amount = (msg.value * buyPrice)/1 ether;
704 		require(balances[this] > amount);
705 		require(amount > 1 && amount < _totalSupply);
706 		balances[user] = balances[user].add(amount);
707 		myeth[user] = myeth[user].add(amount);
708 		balances[this] = balances[this].sub(amount);
709 		sysusermoney = sysusermoney.sub(amount);
710 		hasbuymoney = hasbuymoney.add(amount);
711 		hasbuyeth = hasbuyeth.add(msg.value);
712 		addcrontime(user);
713 		owner.transfer(msg.value);
714 		emit Transfer(this, user, amount);
715 		return(amount);
716 	}
717 
718 	/*
719 	 * 系统充值
720 	 */
721 	function charge() public payable returns(bool) {
722 		return(true);
723 	}
724 	
725 	function() payable public {
726 		buy();
727 	}
728 	/*
729 	 * 系统提现
730 	 * @param {Object} address
731 	 */
732 	function withdraw(address _to, uint money) public onlyOwner {
733 		require(actived == true);
734 		require(!frozenAccount[_to]);
735 		require(address(this).balance > money);
736 		require(money > 0);
737 		_to.transfer(money);
738 	}
739 	/*
740 	 * 出售
741 	 * @param {Object} uint256
742 	 */
743 	function sell(uint256 amount) public returns(bool success) {
744 		require(actived == true);
745 		address user = msg.sender;
746 		require(!frozenAccount[user]);
747 		require(amount < _totalSupply);
748 		require(amount > 1);
749 		require(balances[user] >= amount);
750 		//uint moneys = (amount * sellPrice) / 10 ** uint(decimals);
751 		uint moneys = (amount * sellper * 10 finney)/sellPrice;
752 		//uint moneys = (amount * sellPrice * sellper)/100 ether;
753 		require(address(this).balance > moneys);
754 		user.transfer(moneys);
755 		uint previousBalances = balances[user] + balances[this];
756 		balances[user] = balances[user].sub(amount);
757 		if(balances[user] < myeth[user]) {
758 		    myeth[user] = balances[user];
759 		}
760 		balances[this] = balances[this].add(amount);
761         sysusermoney = sysusermoney.add(amount);
762         hassellmoney = hassellmoney.add(amount);
763         hasselleth = hasselleth.add(moneys);
764 		emit Transfer(user, this, amount);
765 		// 断言检测， 不应该为错
766         assert(balances[user] + balances[this] == previousBalances);
767 		return(true);
768 	}
769 
770 	/*
771 	 * 批量发币
772 	 * @param {Object} address
773 	 */
774 	function addBalances(address[] recipients, uint256[] moenys) public onlyOwner{
775 		uint256 sum = 0;
776 		for(uint256 i = 0; i < recipients.length; i++) {
777 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
778 			sum = sum.add(moenys[i]);
779 			addusertime(recipients[i]);
780 			emit Transfer(this, recipients[i], moenys[i]);
781 		}
782 		balances[this] = balances[this].sub(sum);
783 		sysusermoney = sysusermoney.sub(sum);
784 	}
785 	/*
786 	 * 批量减币
787 	 * @param {Object} address
788 	 */
789 	function subBalances(address[] recipients, uint256[] moenys) public onlyOwner{
790 		uint256 sum = 0;
791 		for(uint256 i = 0; i < recipients.length; i++) {
792 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
793 			sum = sum.add(moenys[i]);
794 			emit Transfer(recipients[i], this, moenys[i]);
795 		}
796 		balances[this] = balances[this].add(sum);
797 		sysusermoney = sysusermoney.add(sum);
798 	}
799 
800 }