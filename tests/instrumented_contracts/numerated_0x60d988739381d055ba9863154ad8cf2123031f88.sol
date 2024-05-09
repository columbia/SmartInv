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
49 contract EttToken{
50     function tokenAdd(address user,uint tokens) public returns(bool success);
51     function tokenSub(address user,uint tokens) public returns(bool success);
52     function balanceOf(address tokenOwner) public constant returns(uint balance);
53 }
54 
55 // ----------------------------------------------------------------------------
56 // 核心类
57 // ----------------------------------------------------------------------------
58 
59 contract USDT is ERC20Interface{
60 	using SafeMath for uint;
61 
62 	string public symbol;
63 	string public name;
64 	uint8 public decimals;
65 	uint _totalSupply;//总发行
66 
67 
68 //	uint public sellPrice; //出售价格 1枚代币换多少以太 /1000
69 	uint public buyPrice; //购买价格 多少以太可购买1枚代币 /1000
70 
71 	
72 	uint public transper; //转账手续费 /3%
73 	
74 	bool public actived;
75 
76 	uint public teamper1;//团队奖% 
77 	uint public teamper2;//团队奖% 
78 	
79 	//uint public sellper;//15
80     uint public sysinteth;
81 
82 	mapping(address => uint) balances;//总计
83 	//mapping(address => uint) myeth;//本金
84 //	mapping(address => uint) froeth;//冻结
85 	//mapping(address => uint) used;
86 	mapping(address => mapping(address => uint)) allowed;
87 
88 	/* 冻结账户 */
89 	mapping(address => bool) public frozenAccount;
90 
91 	//上家地址
92 	mapping(address => address) public fromaddr;
93 	//管理员帐号
94 	mapping(address => bool) public admins;
95 	// 记录各个账户的增量时间
96 	mapping(address => uint) public crontime;
97 	// 挖矿次数
98 //	mapping(address => uint) public mintnum;
99 	uint[] public permans;
100 	mapping(address => uint) public teamget;
101 
102 	struct sunsdata{
103 		mapping(uint => uint) n;	
104 		mapping(uint => uint) n_effective;
105 	}
106 	
107     mapping(address => sunsdata)  suns;
108     address public intertoken;
109     modifier onlyInterface {
110         require(intertoken != address(0));
111 		require(msg.sender == intertoken);
112 		_;
113 	}
114 	/* 通知 */
115 	event FrozenFunds(address target, bool frozen);
116 	address public owner;
117 	address public financer;
118     modifier onlyOwner {
119 		require(msg.sender == owner);
120 		_;
121 	}
122 	modifier  onlyFinancer {
123 		require(msg.sender == financer);
124 		_;
125 	}
126 	
127 	struct record{
128 			//当前可提现本金
129 			uint can_draw_capital;
130 			//当前已投资本金
131 			uint not_draw_capital;
132 			//总的应释放利润
133 			uint total_profit;
134 			//总的已释放利润
135 			uint  releasd_profit;
136 			//投资时间
137 			uint last_investdate;
138 			uint history_releasd_profit;
139 		}
140 		mapping(address=>record) public user_inverst_record;
141 		
142 		struct plan{
143 			uint account;
144 			uint times;
145 		}
146 		mapping(uint => plan) public plans;
147 		
148 		struct node_profit{
149 				uint menber_counts;
150 				uint percent;
151 		}
152 		mapping(uint => node_profit) public node_profits;
153 	//	uint public min_investment;
154 				
155 
156 		uint  public per;
157 		uint public OnceWidrawTime;
158 		mapping(address => bool) _effective_son;
159 		struct quit_conf{
160 			uint  interval;
161 			uint rate1;
162 			uint rate2;
163 		}
164 		quit_conf public quit_config;
165 		uint teamPrice1;
166 		uint teamPrice2;
167 		
168         mapping(address=>bool) public isleader;
169         mapping(address =>uint) public leader_eth;
170         
171         mapping(address=>uint) public userineth;
172 		address [] public leaders;
173 		EttToken public ett;
174 		uint public ettRate;
175 		uint generation;
176 		uint generation_team;
177 		mapping(address=>address) public ethtop;
178 	// ------------------------------------------------------------------------
179 	// Constructor
180 	// ------------------------------------------------------------------------
181 	constructor(EttToken _ettAddress,address [] _supernodes) public {
182 
183 		symbol = "USDT";
184 		name = "USDT Coin";
185 		decimals = 18;
186 		_totalSupply = 1000000000 ether;
187 		buyPrice = 138 ether; //购买价格 1eth can buy how much mt
188 		
189 
190 		transper = uint(0);//转账手续费 /100
191 
192 		teamper1 = 10;//团队奖% /100
193 		teamper2 = 20;//团队奖% /100
194 
195 		//sellper = 85;// /100
196 		actived = true;
197 
198 
199         permans = [40,10,12,6];
200         //permans = [3,3,2,2];//test
201 		balances[this] = _totalSupply;
202 		owner = msg.sender;
203 		financer = msg.sender;
204 		
205         
206 		per = 1;
207 		plans[1].account = 7000 ether;
208 		plans[1].times = 2 ;
209 		plans[2].account = 35000 ether;
210 		plans[2].times = 3 ;
211 		plans[3].account = 70000 ether;
212 		plans[3].times = 4 ;
213 		plans[4].account = 210000 ether;
214 		plans[4].times = 5 ;
215 	
216 		for(uint i=1;i<=16;i++){
217 			node_profits[i].menber_counts = i;
218 			if(i==1){
219 				node_profits[i].percent = 100;
220 			}else if(i==2){
221 				node_profits[i].percent = 20;
222 			}else if(i==3){
223 				node_profits[i].percent = 15;
224 			}else if(i == 4){
225 				node_profits[i].percent = 10;
226 			}else{
227 				node_profits[i].percent = 5;
228 			}
229 		}
230 		
231 		OnceWidrawTime = 24 hours;
232 		//OnceWidrawTime = 10 seconds;
233 		//min_investment = plans[1].account ;
234 		//quit_config.interval = 30 days
235 		//quit_config.interval = 30 seconds;
236 		quit_config.interval = 30 days;
237 		quit_config.rate1 = 5;
238 		quit_config.rate2 = 1;
239 		teamPrice1 = 100000 ether;
240 		teamPrice2 = 500000 ether;
241 		ettRate = 70 ether;
242 		generation = 16;
243 		generation_team = 8;
244 		ett = _ettAddress;
245 		for(uint m;m<_supernodes.length;m++){
246 		    addLeader(_supernodes[m]);
247 		}
248 		
249 		emit Transfer(address(0), owner, _totalSupply);
250 
251 	}
252 
253 	/* 获取用户金额 */
254 	function balanceOf(address user) public view returns(uint balance) {
255 		return balances[user];
256 	}
257 	function ethbalance(address user) public view returns(uint _balance) {
258 	    
259 		_balance = address(user).balance;
260 	}
261 
262 	/*
263 	 * 获取用户的挖矿时间
264 	 * @param {Object} address
265 	 */
266 	function getaddtime(address _addr) public view returns(uint) {
267 		if(crontime[_addr] < 2) {
268 			return(0);
269 		}else{
270 		    return(crontime[_addr]);
271 		}
272 		
273 	}
274 	function getmy(address user) public view returns(
275 	    uint myblance,
276 	    uint meth,
277 	    uint mytime,
278 	    uint bprice,
279 	    uint tmoney,
280 	    uint myineth,
281 	    bool _isleader,
282 	    uint _leader_eth,
283 	    uint [10] _inverst
284 	    /*
285 	    uint _can_draw_capital,
286 	    uint _not_draw_capital,
287 	    uint _last_investdate,
288 	    uint _total_profit,
289 	    uint _releasd_profit,
290 	    uint _history_releasd_profit
291 	    */
292 	){
293 	    address _user = user;
294 	    myblance = balances[_user];//0
295 	    meth = ethbalance(_user);//2
296 	    mytime = crontime[_user];//5
297 	    bprice = buyPrice;//6
298 	    tmoney = balances[this];//9
299 	    myineth = userineth[_user];
300 	    _isleader = isleader[_user];
301 	    _leader_eth = leader_eth[_user];
302 	    
303 	    _inverst[0]=user_inverst_record[_user].can_draw_capital;
304 	    _inverst[1]=user_inverst_record[_user].last_investdate;
305 	    _inverst[2]=user_inverst_record[_user].not_draw_capital;
306 	    _inverst[3]=user_inverst_record[_user].total_profit;
307 	    _inverst[4]=user_inverst_record[_user].releasd_profit;
308 	    _inverst[5] = user_inverst_record[_user].history_releasd_profit;
309 	    _inverst[6] = ethbalance(_user);
310 	    _inverst[7] = getquitfee(_user);
311 	    _inverst[8] = ettRate;
312 	    _inverst[9] = getettbalance(_user);
313 	    /*
314 	    _can_draw_capital=user_inverst_record[_user].can_draw_capital;
315 	    _last_investdate=user_inverst_record[_user].last_investdate;
316 	    _not_draw_capital=user_inverst_record[_user].not_draw_capital;
317 	    _total_profit=user_inverst_record[_user].total_profit;
318 	    _releasd_profit=user_inverst_record[_user].releasd_profit;
319 	    _history_releasd_profit = user_inverst_record[_user].history_releasd_profit;
320 	    */
321 	}
322 	
323 	function setRwardGeneration(uint _generation,uint _generation_team) public onlyOwner returns(bool){
324 	    if(_generation_team>1&&_generation>1&&_generation<=16){
325 	        generation = _generation;
326 	        generation_team = _generation_team;
327 	        return true;
328 	    }else{
329 	        return false;
330 	    }
331 	}
332 	
333 	function getRwardGeneration() public view onlyOwner returns(uint _generation,uint _generation_team){
334 	    _generation = generation;
335 	    _generation_team = generation_team;
336 	}
337 	
338 	function geteam(address _user) public view returns(
339 	    
340 	    uint nn1,//0
341 	    uint nn2,//1
342 	    uint n_effective1,
343 	    uint n_effective2,
344 	    
345 	    uint [16]  n,
346 	    uint [16] n_effective,
347 	    uint ms,//6
348 	    uint tm,//7
349 	    uint lid//11
350 	){
351 	    
352 	    nn1 = suns[_user].n[1];
353 	    nn2 = suns[_user].n[2];
354 	    n_effective1 = suns[_user].n_effective[1];
355 	    n_effective2 = suns[_user].n_effective[2];
356         
357         for(uint i;i<16;i++){
358             
359             n[i] = suns[_user].n[i+1];
360             n_effective[i] = suns[_user].n_effective[i+1];
361         }
362 	    ms = teamget[_user];
363 	    tm = getaddtime(_user);
364 
365 
366 	    if(suns[_user].n_effective[2] >= permans[2] && suns[_user].n_effective[1] >= permans[3]){
367 	        lid = 1;
368 	    }
369 	    if(suns[_user].n_effective[2] >= permans[0] && suns[_user].n_effective[1] >= permans[1]){
370 	        lid = 2;
371 	    }
372 	}
373 	
374 	
375 
376 	function getsys() public view returns(
377 	    uint tmoney,//0
378 	    uint _sysinteth
379 	   
380 	){
381 	    tmoney = _totalSupply.sub(balances[this]);
382 	    _sysinteth = sysinteth;
383 	    
384 	}
385     function _transfer(address from, address to, uint tokens) private returns(bool success) {
386         require(!frozenAccount[from]);
387 		require(!frozenAccount[to]);
388 		require(actived == true);
389 		
390 		uint addper = tokens*transper/100;
391 
392 		uint allmoney = tokens + addper;
393 		require(balances[from] >= allmoney);
394 		require(tokens > 0 && tokens < _totalSupply);
395 		// 防止转移到0x0， 用burn代替这个功能
396         require(to != 0x0);
397 		require(from != to);
398 		// 将此保存为将来的断言， 函数最后会有一个检验103 - 3 + 10
399         uint previousBalances = balances[from] - addper + balances[to];
400 		//如果用户没有上家
401 		if(fromaddr[to] == address(0) && fromaddr[from] != to) {
402 			//指定上家地址
403 			fromaddr[to] = from;
404 			address top = fromaddr[to];
405 			
406 			
407 			if(isleader[ethtop[top]]){
408 			    ethtop[to] = ethtop[top];
409 			}
410 			if(isleader[top] ){
411 			    ethtop[to] = top;
412 			}
413 			
414 			
415 			address _to = to;
416 			for(uint i = 1;i<=16;i++){
417 				if(top != address(0) && top !=_to){
418 					suns[top].n[i] += 1;
419 					_to = top;
420 					top = fromaddr[top];
421 					
422 					continue;
423 				}else{
424 				    break;    
425 				}
426 				
427 			}
428 			
429 		} 
430 		
431 		balances[from] = balances[from].sub(allmoney);
432 		balances[this] = balances[this].add(addper);
433 		balances[to] = balances[to].add(tokens);
434 		emit Transfer(from, this, addper);
435 		emit Transfer(from, to, tokens);
436 		// 断言检测， 不应该为错
437         assert(balances[from] + balances[to] == previousBalances);//90 10
438 		return true;
439     }
440 	/*
441 	 * 用户转账
442 	 * @param {Object} address
443 	 */
444 	function transfer(address to, uint tokens) public returns(bool success) {
445 		_transfer(msg.sender, to, tokens);
446 		success = true;
447 	}
448     function intertransfer(address from, address to, uint tokens) public onlyInterface returns(bool success) {
449 		_transfer(from, to, tokens);
450 		success = true;
451 	}
452 	/*
453 	 * 获取上家地址
454 	 * @param {Object} address
455 	 */
456 	function getfrom(address _addr) public view returns(address) {
457 		return(fromaddr[_addr]);
458 	}
459 
460 	function approve(address spender, uint tokens) public returns(bool success) {
461 	    require(tokens > 1 && tokens < _totalSupply);
462 	    require(balances[msg.sender] >= tokens);
463 		allowed[msg.sender][spender] = tokens;
464 		emit Approval(msg.sender, spender, tokens);
465 		return true;
466 	}
467 	/*
468 	 * 授权转账
469 	 * @param {Object} address
470 	 */
471 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
472 		require(actived == true);
473 		require(!frozenAccount[from]);
474 		require(!frozenAccount[to]);
475 		require(tokens > 1 && tokens < _totalSupply);
476 		require(balances[from] >= tokens);
477 		balances[from] = balances[from].sub(tokens);
478 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
479 		balances[to] = balances[to].add(tokens);
480 		emit Transfer(from, to, tokens);
481 		return true;
482 	}
483 
484 	/*
485 	 * 获取授权信息
486 	 * @param {Object} address
487 	 */
488 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
489 		return allowed[tokenOwner][spender];
490 	}
491 
492 
493 
494 	/// 冻结 or 解冻账户
495 	function freezeAccount(address target, bool freeze) public onlyOwner{
496 		frozenAccount[target] = freeze;
497 		emit FrozenFunds(target, freeze);
498 	}
499 	
500 	/*
501 	 * 系统设置
502 	 * @param {Object} uint
503 	 	
504 	 */
505 	function setconf(
506     	uint _per,
507     	uint _newOnceWidrawTime, 
508     	uint _newBuyPrice,
509     	uint _ettRate
510     ) public onlyOwner{
511         require(_per>0);
512         require(ettRate>0);
513 		per = _per;
514 		OnceWidrawTime = _newOnceWidrawTime;
515 		buyPrice = _newBuyPrice;
516 		ettRate = _ettRate;
517 	}
518 	
519 	
520 	// * 获取系统设置
521 	 
522 	function getconf() public view returns(
523 	    uint _per,
524 	    uint _newOnceWidrawTime, 
525     	uint _newBuyPrice,
526     	uint _ettRate) 
527     {
528 		 _per = per;
529 		 _newOnceWidrawTime = OnceWidrawTime;
530 		 _newBuyPrice = buyPrice;
531 		 _ettRate = ettRate;
532 	}
533 	
534 	function setother(
535     	uint _transper,
536     	uint _quit_interval,
537     	uint _quit_rate1,
538     	uint _quit_rate2
539 	) public onlyOwner{
540 	    transper = _transper;
541 		quit_config = quit_conf(_quit_interval,_quit_rate1,_quit_rate2);
542 	}
543 	
544 	function getquitfee(address _user) public view returns(uint ){
545 	    uint _fee;
546 	    //require(actived == true&&!frozenAccount[msg.sender]);
547 		if (user_inverst_record[_user].can_draw_capital > 0){
548 		    uint interval = now.sub(user_inverst_record[_user].last_investdate);
549 		    uint rate = quit_config.rate2;
550 		    if(interval<quit_config.interval){
551 			    rate = quit_config.rate1;
552 		    }
553 		    uint fee = user_inverst_record[_user].can_draw_capital*rate/100;
554 		}
555 		_fee = fee;
556 		return _fee;
557 
558 	}
559 	
560 	function getother() public view returns(
561 	    uint _onceWidrawTime, 
562     	uint newBuyPrice,
563     	uint _transper,
564     	uint _quit_interval,
565     	uint _quit_rate1,
566     	uint _quit_rate2
567 	){
568 	    _onceWidrawTime = OnceWidrawTime;//0
569 		newBuyPrice = buyPrice;//1
570 		_transper = transper;
571 		_quit_interval = quit_config.interval;
572 		_quit_rate1 = quit_config.rate1;
573 		_quit_rate2 = quit_config.rate2;
574 	}
575 	
576 	function setNodeProfit(uint _node,uint _members,uint _percert) public  onlyOwner returns(bool){
577 	    //require(_node<=16&&_node>=1);
578 	    require(_node>=1);
579 	    require(_members>0&&_percert>0&&_percert<=100);
580 	    node_profits[_node] = node_profit(_members,_percert);
581 	    return true;
582 	}
583 	function setPlan(uint _plan,uint _account,uint _times) public onlyOwner returns(bool){
584 	    require(_plan<=4&&_plan>=1);
585 	    require(_account>0&&_times>0);
586 	    plans[_plan] = plan(_account,_times);
587 	    
588 	    return true;
589 	}
590 	function getPlan(uint _plan) public view returns(uint _account,uint _times){
591 	    require(_plan>0 && _plan <=4);
592 	    _account=plans[_plan].account;
593 	    _times = plans[_plan].times;
594 	}
595 	function getNodeProfit(uint _node) public view returns(uint _members,uint _percert){
596 	    require(_node>0 && _node <=16);
597 	    _members = node_profits[_node].menber_counts;
598 	    _percert = node_profits[_node].percent;
599 	}
600 	
601 	function setsysteam(
602         uint _newteamPrice1,
603         uint _newteamPrice2,
604     	uint teamper1s,
605     	uint teamper2s,
606     	uint t1,
607     	uint t2,
608     	uint t3,
609     	uint t4
610 	) public onlyOwner{
611         teamPrice1=_newteamPrice1;
612         teamPrice2=_newteamPrice2;
613 	    teamper1 = teamper1s;
614 		teamper2 = teamper2s;
615 		permans = [t1,t2,t3,t4];
616 	}
617 	function getsysteam() public view returns(
618         uint teamprice1,
619         uint teamprice2,
620     	uint teamper1s,
621     	uint teamper2s,
622     	uint t1,
623     	uint t2,
624     	uint t3,
625     	uint t4
626 	){
627         teamprice1 = teamPrice1;
628         teamprice2 = teamPrice2;
629 		teamper1s = teamper1;//4
630 		teamper2s = teamper2;//5
631 		t1 = permans[0];//6
632 		t2 = permans[1];//7
633 		t3 = permans[2];//8
634 		t4 = permans[3];//9
635 	}
636 	/*
637 	 * 设置是否开启
638 	 * @param {Object} bool
639 	 */
640 	function setactive(bool tags) public onlyOwner {
641 		actived = tags;
642 	}
643 
644 	function setadmin(address adminaddr) onlyOwner public {
645 	    require(adminaddr != owner && adminaddr != address(0));
646 		owner = adminaddr;
647 	}
648 	function setfinancer(address financeraddr) onlyOwner public {
649 		financer = financeraddr;
650 	}
651 	/*
652 	 * 获取总发行
653 	 */
654 	function totalSupply() public view returns(uint) {
655 		return _totalSupply;
656 	}
657 	function addusermoney(address target, uint256 mintedAmount) private{
658 	    require(!frozenAccount[target]);
659 		require(actived == true);
660         require(balances[this] > mintedAmount);
661 		balances[target] = balances[target].add(mintedAmount);
662 		balances[this] = balances[this].sub(mintedAmount);
663 		emit Transfer(this, target, mintedAmount);
664 	}
665 	function subusermoney(address target, uint256 mintedAmount) private{
666 	    require(!frozenAccount[target]);
667 		require(actived == true);
668         require(balances[target] > mintedAmount);
669 		balances[target] = balances[target].sub(mintedAmount);
670 		balances[this] = balances[this].add(mintedAmount);
671 		emit Transfer( target,this, mintedAmount);
672 	}
673 	/*
674 	 * 向指定账户拨发资金
675 	 * @param {Object} address
676 	 */
677 	function adduser(address target, uint256 mintedAmount) public onlyFinancer{
678 		addusermoney(target, mintedAmount);
679 	}
680 	function subuser(address target, uint256 mintedAmount) public onlyFinancer{
681 		subusermoney(target, mintedAmount);
682 	}
683 	/*
684 	function interadduser(address target, uint256 mintedAmount) public onlyInterface{
685 		addusermoney(target, mintedAmount);
686 	}
687 	function intersubuser(address target, uint256 mintedAmount) public onlyInterface{
688 		subusermoney(target, mintedAmount);
689 	}
690 	*/
691 	
692 	function setteam(address user, uint amount) private returns(bool) {
693 		require(amount >0);
694 		teamget[user] += amount;
695 	    if(suns[user].n_effective[2] >= permans[2] && suns[user].n_effective[1] >= permans[3]){
696 	        //teamget[user] += amount;
697 	        uint chkmoney = teamPrice1;
698 	        uint sendmoney = teamget[user]*teamper1/100;
699 	        if(suns[user].n_effective[2] >= permans[0] && suns[user].n_effective[1] >= permans[1]){
700 	            chkmoney = teamPrice2;
701 	            sendmoney = teamget[user]*teamper2/100;
702 	        }
703 	        if(teamget[user] >= chkmoney) {
704 	        	_update_user_inverst(user,sendmoney);
705 	        	teamget[user] = uint(0);
706 	        	
707 	        }
708 	    }
709 	    return(true);
710 	}	
711 	
712 
713 
714 	function _reset_user_inverst(address user) private returns(bool){
715 			user_inverst_record[user].can_draw_capital = uint(0);
716 			user_inverst_record[user].not_draw_capital = uint(0);
717 			user_inverst_record[user].releasd_profit = uint(0);
718 			//user_inverst_record[user].last_investdate = uint(0);
719 			user_inverst_record[user].total_profit = uint(0);
720 			crontime[user]=uint(0);
721 			return(true);
722 	}
723 	function _update_user_inverst(address user,uint rewards) private returns(uint){
724 	    
725 		require(rewards >0);
726 		uint _mint_account;
727 		if(user_inverst_record[user].not_draw_capital==uint(0)){
728 		    return _mint_account;
729 		}
730 		/*剩余可释放*/
731 		uint releasable = user_inverst_record[user].total_profit.sub(user_inverst_record[user].releasd_profit);
732 		if(releasable<=rewards){
733 			_reset_user_inverst(user);
734 			_mint_account = releasable;
735 		}
736 		else{
737 			/*
738 				修改可提现本金
739 			*/
740 			_mint_account = rewards;
741 			if(user_inverst_record[user].can_draw_capital>0){
742 				if(user_inverst_record[user].can_draw_capital>rewards){
743 					user_inverst_record[user].can_draw_capital=user_inverst_record[user].can_draw_capital.sub(rewards);
744 				}
745 				else{
746 					user_inverst_record[user].can_draw_capital = uint(0);
747 				}
748 			}
749 			/*
750 				修改已释放利润
751 			*/
752 			user_inverst_record[user].releasd_profit += _mint_account;
753 		}
754 		require(balances[this]>= _mint_account);
755 		user_inverst_record[user].history_releasd_profit += _mint_account;
756 		balances[user] += _mint_account;
757 		balances[this] -= _mint_account;
758 		emit Transfer(this, user, _mint_account);
759 		return _mint_account;
760 	}
761 	
762 	function hasReward(address _user)public view returns(bool){
763 	    if(crontime[_user] <= now - OnceWidrawTime && crontime[_user]!=0){
764 	        return true;
765 	    }
766 	    else{
767 	        return false;
768 	    }
769 	}
770 	
771 	function reward() public returns(bool){
772 	    require(actived == true&&!frozenAccount[msg.sender]);
773 		address user = msg.sender;
774 		require(crontime[user] <= now - OnceWidrawTime && crontime[user]!=0);
775 		/*
776 		静态
777 		*/
778 		uint rewards = user_inverst_record[user].not_draw_capital*per/1000;		
779 		/*挖矿数量*/
780 		uint _mint_account = _update_user_inverst(user,rewards);
781 
782 		
783 		/*
784 			动态
785 		*/
786 		address  top = fromaddr[user];
787 		address _user = user;
788 	 	for(uint i=1;i<=generation;i++){
789 	 			if(top != address(0) && top != _user){
790 	 				if(suns[top].n_effective[1]>=node_profits[i].menber_counts){
791 	 					uint upmoney = _mint_account*node_profits[i].percent/100;
792 	 					//settop(top, upmoney);
793 	 					
794 	 					_update_user_inverst(top,upmoney);
795 	 					//setteam(top,_mint_account);
796 	 				}
797 	 				_user = top;
798 	 				top = fromaddr[top];
799 	 				
800 	 				continue;
801                 }
802                  break;
803 	 	}
804 	 	//团队业绩统计
805 	 	_user = user;
806 	 	top = fromaddr[user];
807 	 	for(uint n=1;n<=generation_team;n++){
808 	 		if(top != address(0) && top != _user){
809 	 			setteam(top,_mint_account);
810 	 			_user = top;
811 	 			top = fromaddr[top];
812 	 			continue;
813 	 		}
814 	 		break;
815 	 	}
816 	 	
817 	 			/*修改下次提现时间*/
818 
819 		if(crontime[user]>uint(0)){
820 		    crontime[user] = now + OnceWidrawTime;
821 		}
822 		return true;
823 	}
824 	
825 	/*
826 	 * 用户参与挖矿
827 	 */
828 
829 	 function mint(uint _tokens) public {
830 	 		require(actived == true&&!frozenAccount[msg.sender]);
831 	 		address user = msg.sender;
832   	 		require(_tokens>=plans[1].account && balances[user]>=_tokens);
833 	 		require(!frozenAccount[user]);
834 			
835 			/*16代以内有效用户设置，可以改成N代*/
836 			address top = fromaddr[user];
837 			address _user = user;
838 			for(uint n=1;n<=16;n++){	
839 				if(top != address(0) && top !=_user){
840 					if(!_effective_son[user] && n==1){
841 						++suns[top].n_effective[n];
842 						_effective_son[user] = true;
843 						top = fromaddr[top];
844 						continue;		
845 					}
846 					else if(n >=2){
847 						++suns[top].n_effective[n];
848 						_user = top;
849 						top = fromaddr[top];
850 						continue;
851 					}else{
852 						break;
853 					}
854 				}
855 				break;
856 			}
857 
858 	 		/*
859 	 		修改投资信息
860 	 		*/
861 	 		user_inverst_record[user].can_draw_capital += _tokens;
862 	 		user_inverst_record[user].not_draw_capital += _tokens;
863 	 		user_inverst_record[user].last_investdate = now;
864 
865 			/*
866 			增加总投资利润
867 			*/
868 			uint _profits;
869 	 		for(uint i=4;i>=1;i--){
870 	 				if(_tokens >= plans[i].account){
871 	 						_profits = plans[i].times * _tokens;
872 	 						break;
873 	 				}
874 	 		}
875 	 		
876 	 		user_inverst_record[user].total_profit += _profits;
877 
878 
879 	 		
880 	 		balances[user] -= _tokens;
881 	 		balances[this] += _tokens;
882 	 		crontime[user] = now + OnceWidrawTime;
883 	 	}
884 
885 
886 	function quitMint() public returns(bool){
887 		require(actived == true&&!frozenAccount[msg.sender]);
888 		require(user_inverst_record[msg.sender].can_draw_capital > 0);
889 		uint interval = now.sub(user_inverst_record[msg.sender].last_investdate);
890 		uint rate = quit_config.rate2;
891 		if(interval<quit_config.interval){
892 			rate = quit_config.rate1;
893 		}
894 		uint fee = user_inverst_record[msg.sender].can_draw_capital*rate/100;
895 		uint refund = user_inverst_record[msg.sender].can_draw_capital.sub(fee);
896 		_reset_user_inverst(msg.sender);
897 		require(balances[this]>=refund);
898 		balances[msg.sender] += refund;
899 		balances[this] -= refund;
900 		
901 		emit Transfer(this, msg.sender,refund);
902 		return(true);	
903 	}
904 	 
905 	function addleadereth(address _user,uint _ethvalue) private returns(bool){
906 	    address _ethtop = ethtop[_user];
907 	    if(_ethtop!=address(0) ){
908 	        leader_eth[_ethtop] += _ethvalue;
909 	    }
910 	    /*
911 	    if(isleader[_user]){
912 	        leader_eth[_user] += _ethvalue;
913 	    }
914 	    */
915 	    /*
916 	    address user = _user;
917 	    address top = fromaddr[_user];
918 	    for(uint i=1;;i++){
919 	       if(top!=address(0)&&top!= user){
920 	           if(isleader[top]){
921     	           leader_eth[top] += _ethvalue;
922     	           break;
923 	           }
924 	           (user,top)=(top,fromaddr[top]);
925 	           continue;
926 	       }
927 	       break;
928 	   }
929 	   */
930 	    return(true);
931 	}
932 	function addLeader(address _leader) public onlyOwner returns(bool){
933 	    require(_leader!=address(0) && !isleader[_leader]);
934 	    isleader[_leader] = true;
935 	    leaders.push(_leader);
936 	    return(true);
937 	}
938 	function subLeader(address _leader)public onlyOwner returns(bool){
939 	    require(_leader!=address(0) && isleader[_leader]);
940 	   isleader[_leader] = false;
941 	    return(true);
942 	}
943 	/*
944 	*
945 	*/
946 	function getleaders()public view  returns(address [] memory _leaders,uint [] memory _eths){
947         uint l;
948         for(uint i;i<leaders.length;i++){
949             if(isleader[leaders[i]]){
950                 l++;
951             }
952         }
953         address [] memory  _leaders1 = new address[](l);
954         uint [] memory _eths1 = new uint[](l);
955         for(uint n;n<leaders.length;n++){
956             if(isleader[leaders[n]]){
957                 l--;
958                 
959                 _leaders1[l] = leaders[n];
960                 _eths1[l] = leader_eth[leaders[n]];
961             }
962         }
963         _eths = _eths1;
964         _leaders = _leaders1;
965 	}
966 	function setEttTokenAddress(address _ett) public onlyOwner returns(bool){
967 	    require(_ett!=address(0) && _ett != address(this));
968 	    ett = EttToken(_ett);
969 	    return true;
970 	}
971 	/*
972 	function setEttRate(uint _rate) public onlyOwner returns(bool){
973 	    require(_rate>0);
974 	    ettRate = _rate;
975 	    return true;
976 	}
977 	*/
978 	/*
979 	* sell usdt
980 	*/
981 	
982 	function  usdt2ett(uint _tokens) public returns(bool){
983 	    require(actived);
984 	    require(_tokens>0 && balances[msg.sender] >= _tokens);
985 	    require(ett!=address(0));
986 	    uint _ettAmount = _tokens * ettRate / 1 ether;
987 	    ett.tokenAdd(msg.sender,_ettAmount);
988 	    balances[msg.sender] -= _tokens;
989 	    emit Transfer(msg.sender,this,_tokens);
990 	    return true;
991 	}
992 	
993 	/*
994 	* sell ett
995 	*/
996 	function ett2usdt(uint _tokens) public returns(bool){
997 	    require(actived);
998 	    require(_tokens>0);
999 	    require(ett!=address(0));
1000 	    if(getettbalance(msg.sender)>= _tokens){
1001 	        uint _usdts = _tokens*1 ether/ettRate;    
1002 	        ett.tokenSub(msg.sender,_tokens);
1003 	        require(balances[this]> _usdts);
1004 	        balances[msg.sender] += _usdts;
1005 	        balances[this] -= _usdts;
1006 	        emit Transfer(this,msg.sender,_tokens);
1007 	    }else{
1008 	        return false;
1009 	    }
1010 	    return true;
1011 	}
1012 	
1013 	function getettbalance(address _user) public view returns(uint256 _balance){
1014 	    require(ett!=address(0));
1015 	    _balance = ett.balanceOf(_user);
1016 	}
1017 	
1018 	/*
1019 	 * 获取总账目
1020 	 */
1021 	function getall() public view returns(uint256 money) {
1022 		money = address(this).balance;
1023 	}
1024 	/*
1025 	 * 购买
1026 	 */
1027 	function buy() public payable returns(uint) {
1028 		require(msg.value > 0 && actived);
1029 		address user = msg.sender;
1030 		require(!frozenAccount[user]);
1031 		uint amount = msg.value * buyPrice/1 ether;
1032 		require(balances[this] >= amount && amount < _totalSupply);
1033 		
1034 		balances[user] = balances[user].add(amount);
1035 		
1036 		sysinteth += msg.value;
1037 		userineth[user] += msg.value;
1038 
1039 		balances[this] = balances[this].sub(amount);
1040         
1041 		addleadereth(user,msg.value);
1042 		
1043 		owner.transfer(msg.value);
1044 		
1045 		emit Transfer(this, user, amount);
1046 		return(amount);
1047 	}
1048 	
1049 	
1050 
1051 	function() payable public {
1052 		buy();
1053 	}
1054 
1055 	
1056 	/*
1057 	 * 批量发币
1058 	 * @param {Object} address
1059 	 */
1060 	function addBalances(address[] recipients, uint256[] moenys) public onlyOwner{
1061 		uint256 sum = 0;
1062 		for(uint256 i = 0; i < recipients.length; i++) {
1063 			balances[recipients[i]] = balances[recipients[i]].add(moenys[i]);
1064 			sum = sum.add(moenys[i]);
1065 			emit Transfer(this, recipients[i], moenys[i]);
1066 		}
1067 		balances[this] = balances[this].sub(sum);
1068 
1069 	}
1070 	/*
1071 	 * 批量减币
1072 	 * @param {Object} address
1073 	 */
1074 	function subBalances(address[] recipients, uint256[] moenys) public onlyOwner{
1075 		uint256 sum = 0;
1076 		for(uint256 i = 0; i < recipients.length; i++) {
1077 			balances[recipients[i]] = balances[recipients[i]].sub(moenys[i]);
1078 			sum = sum.add(moenys[i]);
1079 			emit Transfer(recipients[i], this, moenys[i]);
1080 		}
1081 		balances[this] = balances[this].add(sum);
1082 
1083 	}
1084 
1085 }