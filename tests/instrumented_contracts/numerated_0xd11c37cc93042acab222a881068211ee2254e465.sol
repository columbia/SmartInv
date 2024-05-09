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
50 // 核心类
51 // ----------------------------------------------------------------------------
52 contract MT is ERC20Interface{
53 	using SafeMath for uint;
54 	string public symbol;
55 	string public name;
56 	uint8 public decimals;
57 	uint _totalSupply;//总发行
58 	uint public sysusermoney;//流通 
59 	uint public sysoutmoney;//矿池 
60 
61 	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
62 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
63 	uint public sysPer; //挖矿的增量百分比 /2%
64 	uint public sysPrice1; //挖矿的衡量值10000
65 	uint public sysPrice2; //挖矿的衡量值100000
66 	uint public sysPrice3; //挖矿的衡量值300000
67 	uint public sysPrice4; //挖矿的衡量值500000
68 	uint public sysPer1; //挖矿的增量百分比 /3%
69 	uint public sysPer2; //挖矿的增量百分比 /4%
70 	uint public sysPer3; //挖矿的增量百分比 /5%
71 	uint public sysPer4; //挖矿的增量百分比 /6%
72 	uint public systime1;//120
73 	uint public systime2;//240
74 	uint public systime3;//360
75 	uint public systime4;//720
76 	
77 	uint public outper1;//退出锁仓20
78 	uint public outper2;//退出锁仓30
79 	uint public outper3;//退出锁仓40
80 	uint public outper4;//退出锁仓50
81 	
82 	uint public transper; //转账手续费 /3%
83 	
84 	bool public actived;
85 	uint public onceAddTime; //挖矿的时间 10 days
86 	uint public upper1;//团队奖% 
87 	uint public upper2;//团队奖% 
88 	uint public upper3;//团队奖%
89 	uint public upper4;//团队奖%
90 	uint public upper5;//团队奖%
91 	uint public upper6;//团队奖%
92 	uint public teamper1;//团队奖% 
93 	uint public teamper2;//团队奖% 
94 	
95 	uint public sellper;//15
96     uint public sysminteth;
97     uint public hasoutmony;
98     uint public hasbuymoney;
99     uint public hassellmoney;
100     uint public hasbuyeth;
101     uint public hasselleth;
102 	mapping(address => uint) balances;//总计
103 	mapping(address => uint) myeth;//本金
104 	mapping(address => uint) froeth;//冻结
105 	//mapping(address => uint) used;
106 	mapping(address => mapping(address => uint)) allowed;
107 
108 	/* 冻结账户 */
109 	mapping(address => bool) public frozenAccount;
110 
111 	//上家地址
112 	mapping(address => address) public fromaddr;
113 	//管理员帐号
114 	mapping(address => bool) public admins;
115 	// 记录各个账户的增量时间
116 	mapping(address => uint) public crontime;
117 	// 挖矿次数
118 	mapping(address => uint) public mintnum;
119 	uint[] public permans;
120 	mapping(address => uint) public teamget;
121 	struct sunsdata{
122 	    uint n1;
123 	    uint n2;
124 	    uint n3;
125 	    uint n4;
126 	    uint n5;
127 	    uint n6;
128 	    uint getmoney;
129 	}
130     mapping(address => sunsdata) public suns;
131     address public intertoken;
132     modifier onlyInterface {
133         require(intertoken != address(0));
134 		require(msg.sender == intertoken);
135 		_;
136 	}
137 	/* 通知 */
138 	event FrozenFunds(address target, bool frozen);
139 	address public owner;
140 	address public financer;
141     modifier onlyOwner {
142 		require(msg.sender == owner);
143 		_;
144 	}
145 	modifier  onlyFinancer {
146 		require(msg.sender == financer);
147 		_;
148 	}
149 	// ------------------------------------------------------------------------
150 	// Constructor
151 	// ------------------------------------------------------------------------
152 	constructor() public {
153 
154 		symbol = "MToken";
155 		name = "MToken";
156 		decimals = 18;
157 		_totalSupply = 5000000000 ether;//总发行
158 		sysusermoney = 2500000000 ether;//流通
159 		sysoutmoney  = 2500000000 ether;//矿池
160 
161 		sellPrice = 7251 ether; //出售价格 1mt can buy how much eth
162 		buyPrice = 7251 ether; //购买价格 1eth can buy how much mt
163 		
164 		//sysPrice1 = 3 ether;//test
165 		sysPer  = 2; //挖矿的增量百分比 /100
166 		sysPer1 = 3; //挖矿的增量百分比 /100
167 		sysPer2 = 4; //挖矿的增量百分比 /100
168 		sysPer3 = 5; //挖矿的增量百分比 /100
169 		sysPer4 = 6; //挖矿的增量百分比 /100
170 		
171 		sysPrice1 = 10000 ether; //挖矿的衡量值
172 		sysPrice2 = 100000 ether; //挖矿的衡量值
173 		sysPrice3 = 300000 ether; //挖矿的衡量值
174 		sysPrice4 = 500000 ether; //挖矿的衡量值
175 		
176 		transper = 3;//转账手续费 /100
177 		upper1 = 10;//第1代挖矿分润
178 		upper2 = 7;//第2代挖矿分润
179 		upper3 = 6;//第2代挖矿分润
180 		upper4 = 5;//第2代挖矿分润
181 		upper5 = 4;//第2代挖矿分润
182 		upper6 = 3;//第2代挖矿分润
183 		teamper1 = 10;//团队奖% /100
184 		teamper2 = 20;//团队奖% /100
185 		outper1 = 80;//退出锁仓 /100
186 		outper2 = 70;//退出锁仓 /100
187 		outper3 = 60;//退出锁仓 /100
188 		outper4 = 60;//退出锁仓 /100
189 		sellper = 85;// /100
190 		actived = true;
191 		onceAddTime = 10 days; //挖矿的时间 正式
192 		//onceAddTime = 60 seconds;//test
193         systime1 = 13;
194         systime2 = 25;
195         systime3 = 37;
196         systime4 = 73;
197         permans = [40,20,12,6];
198         //permans = [3,3,2,2];//test
199 		balances[this] = _totalSupply;
200 		owner = msg.sender;
201 		financer = msg.sender;
202 		emit Transfer(address(0), owner, _totalSupply);
203 
204 	}
205 
206 	/* 获取用户金额 */
207 	function balanceOf(address user) public view returns(uint balance) {
208 		return balances[user];
209 	}
210 	function ethbalance(address user) public view returns(uint balance) {
211 		return user.balance;
212 	}
213     function addcrontime(address addr) private{
214         if(crontime[addr] < now) {
215             crontime[addr] = now + onceAddTime;
216         }
217         
218     }
219     function addusertime(address addr) private{
220         if(balances[addr] < 2) {
221             addcrontime(addr);
222         }
223     }
224 	/*
225 	 * 获取用户的挖矿时间
226 	 * @param {Object} address
227 	 */
228 	function getaddtime(address _addr) public view returns(uint) {
229 		if(crontime[_addr] < 2) {
230 			return(0);
231 		}else{
232 		    return(crontime[_addr]);
233 		}
234 		
235 	}
236 	function getmy(address user) public view returns(
237 	    uint myblance,
238 	    uint meth,
239 	    uint myeths,
240 	    uint mypro,
241 	    uint mytime,
242 	    uint bprice,
243 	    uint tmoney,
244 	    uint myall
245 	){
246 	    myblance = balances[user];//0
247 	    meth = address(user).balance;//2
248 	    myeths = myeth[user];//3
249 	    mypro = froeth[user];//4
250 	    mytime = crontime[user];//5
251 	    bprice = buyPrice;//6
252 	    tmoney = balances[this];//9
253 	    myall = myblance.add(mypro);//10
254 	}
255 	function geteam(address user) public view returns(
256 	    uint nn1,//0
257 	    uint nn2,//1
258 	    uint nn3,//2
259 	    uint nn4,//3
260 	    uint nn5,//4
261 	    uint nn6,//5
262 	    uint ms,//6
263 	    uint tm,//7
264 	    uint mintmoneys,//8
265 	    uint usermoneys,//9
266 	    uint fromoneys,//10
267 	    uint lid//11
268 	){
269 	    nn1 = suns[user].n1;
270 	    nn2 = suns[user].n2;
271 	    nn3 = suns[user].n3;
272 	    nn4 = suns[user].n4;
273 	    nn5 = suns[user].n5;
274 	    nn6 = suns[user].n6;
275 	    ms = teamget[user];
276 	    tm = getaddtime(user);
277 	    mintmoneys = sysoutmoney;
278 	    usermoneys = sysusermoney;
279 	    fromoneys = sysminteth;
280 	    if(suns[user].n2 >= permans[2] && suns[user].n1 >= permans[3]){
281 	        lid = 1;
282 	    }
283 	    if(suns[user].n2 >= permans[0] && suns[user].n1 >= permans[1]){
284 	        lid = 2;
285 	    }
286 	}
287 	function getsys() public view returns(
288 	    uint tmoney,//0
289 	    uint outm,//1
290 	    uint um,//2
291 	    uint from,//3
292 	    uint hasout,//4
293 	    uint hasbuy,//5
294 	    uint hassell,//6
295 	    uint hasbuyeths,//9
296 	    uint hasselleths//10
297 	){
298 	    tmoney = _totalSupply.sub(balances[this]);
299 	    outm = sysoutmoney;
300 	    um = sysusermoney;
301 	    from = sysminteth;
302 	    hasout = hasoutmony;
303 	    hasbuy = hasbuymoney;
304 	    hassell = hassellmoney;
305 	    hasbuyeths = hasbuyeth;
306 	    hasselleths = hasselleth;
307 	}
308     function _transfer(address from, address to, uint tokens) private returns(bool success) {
309         require(!frozenAccount[from]);
310 		require(!frozenAccount[to]);
311 		require(actived == true);
312 		uint addper = tokens*transper/100;
313 		uint allmoney = tokens + addper;
314 		require(balances[from] >= allmoney);
315 		require(tokens > 1 && tokens < _totalSupply);
316 		// 防止转移到0x0， 用burn代替这个功能
317         require(to != 0x0);
318 		require(from != to);
319 		// 将此保存为将来的断言， 函数最后会有一个检验103 - 3 + 10
320         uint previousBalances = balances[from] - addper + balances[to];
321 		//如果用户没有上家
322 		if(fromaddr[to] == address(0) && fromaddr[from] != to) {
323 			//指定上家地址
324 			fromaddr[to] = from;
325 			suns[from].n1++;
326 			address top = fromaddr[from];
327 			if(top != address(0)) {
328 			    suns[top].n2++;
329 			    top = fromaddr[top];
330 			    if(top != address(0)) {
331     			    suns[top].n3++;
332     			    top = fromaddr[top];
333     			    if(top != address(0)) {
334         			    suns[top].n4++;
335         			    top = fromaddr[top];
336         			    if(top != address(0)) {
337             			    suns[top].n5++;
338             			    top = fromaddr[top];
339             			    if(top != address(0)) {
340                 			    suns[top].n6++;
341                 			}
342             			}
343         			}
344     			}
345 			}
346 		} 
347 		
348 		balances[from] = balances[from].sub(allmoney);
349 		if(balances[from] < myeth[from]) {
350 		    myeth[from] = balances[from];
351 		}
352 		balances[this] = balances[this].add(addper);
353 		balances[to] = balances[to].add(tokens);
354 		myeth[to] = myeth[to].add(tokens);
355 		addcrontime(to);
356 		emit Transfer(from, this, addper);
357 		emit Transfer(from, to, tokens);
358 		// 断言检测， 不应该为错
359         assert(balances[from] + balances[to] == previousBalances);//90 10
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
370     function intertransfer(address from, address to, uint tokens) public onlyInterface returns(bool success) {
371 		_transfer(from, to, tokens);
372 		success = true;
373 	}
374 	/*
375 	 * 获取上家地址
376 	 * @param {Object} address
377 	 */
378 	function getfrom(address _addr) public view returns(address) {
379 		return(fromaddr[_addr]);
380 	}
381 
382 	function approve(address spender, uint tokens) public returns(bool success) {
383 	    require(tokens > 1 && tokens < _totalSupply);
384 	    require(balances[msg.sender] >= tokens);
385 		allowed[msg.sender][spender] = tokens;
386 		emit Approval(msg.sender, spender, tokens);
387 		return true;
388 	}
389 	/*
390 	 * 授权转账
391 	 * @param {Object} address
392 	 */
393 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
394 		require(actived == true);
395 		require(!frozenAccount[from]);
396 		require(!frozenAccount[to]);
397 		require(tokens > 1 && tokens < _totalSupply);
398 		require(balances[from] >= tokens);
399 		balances[from] = balances[from].sub(tokens);
400 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
401 		balances[to] = balances[to].add(tokens);
402 		emit Transfer(from, to, tokens);
403 		return true;
404 	}
405 
406 	/*
407 	 * 获取授权信息
408 	 * @param {Object} address
409 	 */
410 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
411 		return allowed[tokenOwner][spender];
412 	}
413 
414 
415 
416 	/// 冻结 or 解冻账户
417 	function freezeAccount(address target, bool freeze) public onlyOwner{
418 		frozenAccount[target] = freeze;
419 		emit FrozenFunds(target, freeze);
420 	}
421 	
422 	/*
423 	 * 系统设置
424 	 * @param {Object} uint
425 	 	
426 	 */
427 	function setconf(
428     	uint systyPrice1, 
429     	uint systyPrice2, 
430     	uint systyPrice3, 
431     	uint systyPrice4, 
432     	uint sysPermit1,
433     	uint sysPermit2,
434     	uint sysPermit3,
435     	uint sysPermit4,
436     	uint systime1s,
437     	uint systime2s,
438     	uint systime3s,
439     	uint systime4s
440     ) public onlyOwner{
441 		sysPrice1 = systyPrice1;
442 		sysPrice2 = systyPrice2;
443 		sysPrice3 = systyPrice3;
444 		sysPrice4 = systyPrice4;
445 		sysPer1 = sysPermit1;
446 		sysPer2 = sysPermit2;
447 		sysPer3 = sysPermit3;
448 		sysPer4 = sysPermit4;
449 		systime1 = systime1s + 1;
450 		systime2 = systime2s + 1;
451 		systime3 = systime3s + 1;
452 		systime4 = systime4s + 1;
453 		
454 	}
455 	/*
456 	 * 获取系统设置
457 	 */
458 	function getconf() public view returns(
459 	    uint systyPrice1, 
460     	uint systyPrice2, 
461     	uint systyPrice3, 
462     	uint systyPrice4, 
463     	uint sysPermit1,
464     	uint sysPermit2,
465     	uint sysPermit3,
466     	uint sysPermit4,
467     	uint systime1s,
468     	uint systime2s,
469     	uint systime3s,
470     	uint systime4s
471 	) {
472 		
473 		systyPrice1 = sysPrice1;//0
474 		systyPrice2 = sysPrice2;//1
475 		systyPrice3 = sysPrice3;//2
476 		systyPrice4 = sysPrice4;//3
477 		sysPermit1 = sysPer1;//4
478 		sysPermit2 = sysPer2;//5
479 		sysPermit3 = sysPer3;//6
480 		sysPermit4 = sysPer4;//7
481 		systime1s = systime1 - 1;//8
482 		systime2s = systime2 - 1;//9
483 		systime3s = systime3 - 1;//10
484 		systime4s = systime4 - 1;//11
485 		
486 	}
487 	
488 	function setother(
489 	    uint newonceaddtime, 
490     	uint newBuyPrice, 
491     	uint newSellPrice, 
492     	uint sysPermit,
493     	uint transpers,
494     	uint sellpers,
495 	    uint upper1s,
496     	uint upper2s,
497     	uint upper3s,
498     	uint upper4s,
499     	uint upper5s,
500     	uint upper6s
501 	) public onlyOwner{
502 	    onceAddTime = newonceaddtime;
503 		buyPrice = newBuyPrice;
504 		sellPrice = newSellPrice;
505 		sysPer = sysPermit;
506 		transper = transpers;
507 		sellper = sellpers;
508 	    upper1 = upper1s;
509 		upper2 = upper2s;
510 		upper3 = upper3s;
511 		upper4 = upper4s;
512 		upper5 = upper5s;
513 		upper6 = upper6s;	
514 	}
515 	
516 	function getother() public view returns(
517 	    uint newonceaddtime, 
518     	uint newBuyPrice, 
519     	uint newSellPrice, 
520     	uint sysPermit,
521     	uint transpers,
522     	uint sellpers,
523 	    uint upper1s,
524     	uint upper2s,
525     	uint upper3s,
526     	uint upper4s,
527     	uint upper5s,
528     	uint upper6s
529 	){
530 	    newonceaddtime = onceAddTime;//0
531 		newBuyPrice = buyPrice;//1
532 	    newSellPrice = 	sellPrice;//2
533 		sysPermit = sysPer;//3
534 		transpers = transper;//4
535 		sellpers = sellper;//5
536 	    upper1s = upper1;//6
537 		upper2s = upper2;//7
538 		upper3s = upper3;//8
539 		upper4s = upper4;//9
540 		upper5s = upper5;//10
541 		upper6s = upper6;//11
542 	}
543 	function setsysteam(
544     	uint outper1s,
545     	uint outper2s,
546     	uint outper3s,
547     	uint outper4s,
548     	uint teamper1s,
549     	uint teamper2s,
550     	uint t1,
551     	uint t2,
552     	uint t3,
553     	uint t4
554 	) public onlyOwner{
555 	    outper1 = outper1s;
556 		outper2 = outper2s;
557 		outper3 = outper3s;
558 		outper4 = outper4s;
559 	    teamper1 = teamper1s;
560 		teamper2 = teamper2s;
561 		permans = [t1,t2,t3,t4];
562 	}
563 	function getsysteam() public view returns(
564 	    uint outper1s,
565     	uint outper2s,
566     	uint outper3s,
567     	uint outper4s,
568     	uint teamper1s,
569     	uint teamper2s,
570     	uint t1,
571     	uint t2,
572     	uint t3,
573     	uint t4
574 	){
575 	    outper1s = outper1;//0
576 		outper2s = outper2;//1
577 		outper3s = outper3;//2
578 		outper4s = outper4;//3
579 		teamper1s = teamper1;//4
580 		teamper2s = teamper2;//5
581 		t1 = permans[0];//6
582 		t2 = permans[1];//7
583 		t3 = permans[2];//8
584 		t4 = permans[3];//9
585 	}
586 	/*
587 	 * 设置是否开启
588 	 * @param {Object} bool
589 	 */
590 	function setactive(bool tags) public onlyOwner {
591 		actived = tags;
592 	}
593 	function settoken(address tokensaddr) onlyOwner public {
594 		intertoken = tokensaddr;
595 	}
596 	function setadmin(address adminaddr) onlyOwner public {
597 		owner = adminaddr;
598 	}
599 	function setfinancer(address financeraddr) onlyOwner public {
600 		financer = financeraddr;
601 	}
602 	/*
603 	 * 获取总发行
604 	 */
605 	function totalSupply() public view returns(uint) {
606 		return _totalSupply;
607 	}
608 	function addusermoney(address target, uint256 mintedAmount) private{
609 	    require(!frozenAccount[target]);
610 		require(actived == true);
611         require(balances[this] > mintedAmount);
612 		balances[target] = balances[target].add(mintedAmount);
613 		myeth[target] = myeth[target].add(mintedAmount);
614 		balances[this] = balances[this].sub(mintedAmount);
615 		sysusermoney = sysusermoney.sub(mintedAmount);
616 		hasoutmony = hasoutmony.add(mintedAmount);
617 		addcrontime(target);
618 		emit Transfer(this, target, mintedAmount);
619 	}
620 	function subusermoney(address target, uint256 mintedAmount) private{
621 	    require(!frozenAccount[target]);
622 		require(actived == true);
623         require(balances[target] > mintedAmount);
624 		balances[target] = balances[target].sub(mintedAmount);
625 		if(balances[target] < myeth[target]) {
626 		    myeth[target] = balances[target];
627 		}
628 		balances[this] = balances[this].add(mintedAmount);
629 		sysusermoney = sysusermoney.add(mintedAmount);
630 		emit Transfer( target,this, mintedAmount);
631 	}
632 	/*
633 	 * 向指定账户拨发资金
634 	 * @param {Object} address
635 	 */
636 	function adduser(address target, uint256 mintedAmount) public onlyFinancer{
637 		addusermoney(target, mintedAmount);
638 	}
639 	function subuser(address target, uint256 mintedAmount) public onlyFinancer{
640 		subusermoney(target, mintedAmount);
641 	}
642 	function interadduser(address target, uint256 mintedAmount) public onlyInterface{
643 		addusermoney(target, mintedAmount);
644 	}
645 	function intersubuser(address target, uint256 mintedAmount) public onlyInterface{
646 		subusermoney(target, mintedAmount);
647 	}
648 	function mintadd() public{
649 	    address user = msg.sender;
650 		require(!frozenAccount[user]);
651 		require(actived == true);
652 		require(balances[user] >= sysPrice1);
653 		froeth[user] = froeth[user].add(balances[user]);
654 		sysminteth = sysminteth.add(balances[user]);
655 		emit Transfer(user, this, balances[user]);
656 		balances[user] = 1;
657 		myeth[user] = 1;
658 		if(froeth[user] >= sysPrice4) {
659 		    mintnum[user] = systime4;
660 		}
661 		else if(froeth[user] >= sysPrice3) {
662 		    mintnum[user] = systime3;
663 		}
664 		else if(froeth[user] >= sysPrice2) {
665 		    mintnum[user] = systime2;
666 		}else{
667 		    mintnum[user] = systime1;
668 		}
669 		crontime[user] = now + onceAddTime;
670 		
671 	}
672 	function mintsub() public{
673 	    address user = msg.sender;
674 		require(!frozenAccount[user]);
675 		require(actived == true);
676 		require(mintnum[user] > 1);
677 		require(froeth[user] >= sysPrice1);
678 		uint getamount = froeth[user]*outper1/100;
679 		if(froeth[user] >= sysPrice4) {
680 		    getamount = froeth[user]*outper4/100;
681 		}
682 		else if(froeth[user] >= sysPrice3) {
683 		    getamount = froeth[user]*outper3/100;
684 		}
685 		else if(froeth[user] >= sysPrice2) {
686 		    getamount = froeth[user]*outper2/100;
687 		}
688 		uint addthis = froeth[user].sub(getamount);
689 		balances[this] = balances[this].add(addthis);
690 		emit Transfer(user, this, addthis);
691 		sysminteth = sysminteth.add(uint(1)).sub(froeth[user]);
692 		froeth[user] = 1;
693 		mintnum[user] = 1;
694 		balances[user] = balances[user].add(getamount);
695 		myeth[user] = myeth[user].add(getamount);
696 		emit Transfer(this, user, getamount);
697 		
698 	}
699 	function setteam(address user, uint amount) private returns(bool) {
700 	    if(suns[user].n2 >= permans[2] && suns[user].n1 >= permans[3]){
701 	        teamget[user] = teamget[user].add(amount);
702 	        uint chkmoney = sysPrice2;
703 	        uint sendmoney = teamget[user]*teamper1/100;
704 	        if(suns[user].n2 >= permans[0] && suns[user].n1 >= permans[1]){
705 	            chkmoney = sysPrice4;
706 	            sendmoney = teamget[user]*teamper2/100;
707 	        }
708 	        if(teamget[user] >= chkmoney) {
709 	            require(balances[this] > sendmoney);
710 	            require(sysoutmoney > sendmoney);
711 	            suns[user].getmoney = suns[user].getmoney.add(sendmoney);
712 	            balances[user] = balances[user].add(sendmoney);
713 	            teamget[user] = 1;
714 	            balances[this] = balances[this].sub(sendmoney);
715 		        sysoutmoney = sysoutmoney.sub(sendmoney);
716 		        sysusermoney = sysusermoney.add(sendmoney);
717 		        emit Transfer(this, user, sendmoney);
718 	        }
719 	        return(true);
720 	    }
721 	}
722 	function settop(address top, uint upmoney) private{
723 	    require(balances[this] > upmoney);
724 	    require(sysoutmoney > upmoney);
725 	    balances[top] = balances[top].add(upmoney);
726         balances[this] = balances[this].sub(upmoney);
727         sysoutmoney = sysoutmoney.sub(upmoney);
728         sysusermoney = sysusermoney.add(upmoney);
729         emit Transfer(this, top, upmoney);
730         setteam(top, upmoney);
731 	}
732 	/*
733 	 * 用户每隔10天挖矿一次
734 	 */
735 	function mint() public {
736 	    address user = msg.sender;
737 		require(!frozenAccount[user]);
738 		require(actived == true);
739 		require(crontime[user] > 1);
740 		require(now > crontime[user]);
741 		uint amount;
742 		uint usmoney;
743 		uint mintmoney;
744 		if(myeth[user] > 1) {
745 		    usmoney = myeth[user] * sysPer / 100;
746 		}
747 		if(froeth[user] >= sysPrice1 && mintnum[user] > 1) {
748 		    mintmoney = froeth[user] * sysPer1 / 100;
749 		    if(froeth[user] >= sysPrice4) {
750     		    mintmoney = froeth[user] * sysPer4 / 100;
751     		}
752     		else if(froeth[user] >= sysPrice3) {
753     		    mintmoney = froeth[user] * sysPer3 / 100;
754     		}
755     		else if(froeth[user] >= sysPrice2) {
756     		    mintmoney = froeth[user] * sysPer2 / 100;
757     		}
758 		}
759 		amount = usmoney.add(mintmoney);
760 		require(balances[this] > amount);
761 		require(sysoutmoney > amount);
762 		balances[user] = balances[user].add(amount);
763 		balances[this] = balances[this].sub(amount);
764 		sysoutmoney = sysoutmoney.sub(amount);
765 		sysusermoney = sysusermoney.add(amount);
766 		crontime[user] = now + onceAddTime;
767 		
768 		if(usmoney > 0) {
769 		    emit Transfer(this, user, usmoney);
770 		}
771 		if(mintmoney > 0) {
772 		    emit Transfer(this, user, mintmoney);
773 		    mintnum[user]--;
774 		    if(mintnum[user] < 2) {
775 		        balances[user] = balances[user].add(froeth[user]);
776 		        myeth[user] = myeth[user].add(froeth[user]);
777 		        sysminteth = sysminteth.sub(froeth[user]);
778 		        emit Transfer(this, user, froeth[user]);
779 		        froeth[user] = 1; 
780 		    }
781 		}
782 		address top = fromaddr[user];
783 		
784 		if(top != address(0) && top != user) { 
785 		    uint upmoney = amount*upper1/100;
786 		    settop(top, upmoney);
787 		    top = fromaddr[top];
788 		    if(top != address(0) && top != user) {
789     		    upmoney = amount*upper2/100;
790     		    settop(top, upmoney);
791     		    top = fromaddr[top];
792     		    if(top != address(0) && top != user) {
793         		    upmoney = amount*upper3/100;
794         		    settop(top, upmoney);
795         		    top = fromaddr[top];
796         		    if(top != address(0) && top != user) {
797             		    upmoney = amount*upper4/100;
798             		    settop(top, upmoney);
799             		    top = fromaddr[top];
800             		    if(top != address(0) && top != user) {
801                 		    upmoney = amount*upper5/100;
802                 		    settop(top, upmoney);
803                 		    top = fromaddr[top];
804                 		    if(top != address(0) && top != user) {
805                     		    upmoney = amount*upper6/100;
806                     		    settop(top, upmoney);
807                     		}
808                 		}
809             		}
810         		}
811         		
812     		}
813 		}
814 		//emit Transfer(this, user, amount);
815 		
816 
817 	}
818 	/*
819 	 * 获取总账目
820 	 */
821 	function getall() public view returns(uint256 money) {
822 		money = address(this).balance;
823 	}
824 	/*
825 	 * 购买
826 	 */
827 	function buy() public payable returns(uint) {
828 		require(actived == true);
829 		address user = msg.sender;
830 		require(!frozenAccount[user]);
831 		require(msg.value > 0);
832 		uint amount = (msg.value * buyPrice)/1 ether;
833 		require(balances[this] > amount);
834 		require(amount > 1 && amount < _totalSupply);
835 		balances[user] = balances[user].add(amount);
836 		myeth[user] = myeth[user].add(amount);
837 		balances[this] = balances[this].sub(amount);
838 		sysusermoney = sysusermoney.sub(amount);
839 		hasbuymoney = hasbuymoney.add(amount);
840 		hasbuyeth = hasbuyeth.add(msg.value);
841 		addcrontime(user);
842 		owner.transfer(msg.value);
843 		emit Transfer(this, user, amount);
844 		return(amount);
845 	}
846 	
847 	/*
848 	 * 系统充值
849 	 */
850 	function charge() public payable returns(bool) {
851 		return(true);
852 	}
853 	
854 	function() payable public {
855 		buy();
856 	}
857 	/*
858 	 * 系统提现
859 	 * @param {Object} address
860 	 */
861 	function withdraw(address _to, uint money) public onlyOwner {
862 		require(actived == true);
863 		require(!frozenAccount[_to]);
864 		require(address(this).balance > money);
865 		require(money > 0);
866 		_to.transfer(money);
867 	}
868 	/*
869 	 * 出售
870 	 * @param {Object} uint256
871 	 */
872 	function sell(uint256 amount) public returns(bool success) {
873 		require(actived == true);
874 		address user = msg.sender;
875 		require(!frozenAccount[user]);
876 		require(amount < _totalSupply);
877 		require(amount > 1);
878 		require(balances[user] >= amount);
879 		uint moneys = (amount * sellper * 10 finney)/sellPrice;
880 		require(address(this).balance > moneys);
881 		user.transfer(moneys);
882 		uint previousBalances = balances[user] + balances[this];
883 		balances[user] = balances[user].sub(amount);
884 		if(balances[user] < myeth[user]) {
885 		    myeth[user] = balances[user];
886 		}
887 		balances[this] = balances[this].add(amount);
888         sysusermoney = sysusermoney.add(amount);
889         hassellmoney = hassellmoney.add(amount);
890         hasselleth = hasselleth.add(moneys);
891 		emit Transfer(user, this, amount);
892 		// 断言检测， 不应该为错
893         assert(balances[user] + balances[this] == previousBalances);
894 		return(true);
895 	}
896 	
897 		/*
898 	 * 批量发币
899 	 * @param {Object} address
900 	 */
901 	function addBalances(address[] recipients, uint256[] moenys) public onlyOwner{
902 		uint256 sum = 0;
903 		for(uint256 i = 0; i < recipients.length; i++) {
904 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
905 			sum = sum.add(moenys[i]);
906 			addusertime(recipients[i]);
907 			emit Transfer(this, recipients[i], moenys[i]);
908 		}
909 		balances[this] = balances[this].sub(sum);
910 		sysusermoney = sysusermoney.sub(sum);
911 	}
912 	/*
913 	 * 批量减币
914 	 * @param {Object} address
915 	 */
916 	function subBalances(address[] recipients, uint256[] moenys) public onlyOwner{
917 		uint256 sum = 0;
918 		for(uint256 i = 0; i < recipients.length; i++) {
919 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
920 			sum = sum.add(moenys[i]);
921 			emit Transfer(recipients[i], this, moenys[i]);
922 		}
923 		balances[this] = balances[this].add(sum);
924 		sysusermoney = sysusermoney.add(sum);
925 	}
926 
927 }