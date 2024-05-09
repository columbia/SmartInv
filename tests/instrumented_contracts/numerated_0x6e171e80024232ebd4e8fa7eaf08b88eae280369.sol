1 pragma solidity ^ 0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
6 // ----------------------------------------------------------------------------
7 contract ERC20Interface {
8 	function totalSupply() public constant returns(uint);
9 
10 	function balanceOf(address tokenOwner) public constant returns(uint balance);
11 
12 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
13 
14 	function transfer(address to, uint tokens) public returns(bool success);
15 
16 	function approve(address spender, uint tokens) public returns(bool success);
17 
18 	function transferFrom(address from, address to, uint tokens) public returns(bool success);
19 
20 	event Transfer(address indexed from, address indexed to, uint tokens);
21 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
22 }
23 
24 // ----------------------------------------------------------------------------
25 // Contract function to receive approval and execute function in one call
26 //
27 // Borrowed from MiniMeToken
28 // ----------------------------------------------------------------------------
29 contract ApproveAndCallFallBack {
30 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
31 }
32 
33 // ----------------------------------------------------------------------------
34 // 管理员
35 // ----------------------------------------------------------------------------
36 contract Owned {
37 	address public owner;
38 	address public newOwner;
39 
40 	event OwnershipTransferred(address indexed _from, address indexed _to);
41 
42 	constructor() public {
43 		owner = msg.sender;
44 	}
45 
46 	modifier onlyOwner {
47 		require(msg.sender == owner);
48 		_;
49 	}
50 
51 	function transferOwnership(address _newOwner) public onlyOwner {
52 		newOwner = _newOwner;
53 	}
54 
55 	function acceptOwnership() public {
56 		require(msg.sender == newOwner);
57 		emit OwnershipTransferred(owner, newOwner);
58 		owner = newOwner;
59 		newOwner = address(0);
60 	}
61 }
62 
63 // ----------------------------------------------------------------------------
64 // 核心类
65 // ----------------------------------------------------------------------------
66 contract Oasis is ERC20Interface, Owned {
67 	string public symbol;
68 	string public name;
69 	uint8 public decimals;
70 	uint _totalSupply;
71 	
72 	//address public owner;
73 	bool public actived;
74 	struct keyconf{
75 	    uint basekeynum;//4500
76     	uint basekeysub;//500
77     	uint usedkeynum;//0
78         uint startprice;//0.01
79         uint keyprice;//0.01
80         uint startbasekeynum;//4500
81         uint[] keyidarr;
82     	uint currentkeyid;
83 	}
84 	keyconf private keyconfig;
85 	uint[] public worksdata;
86 	
87 	uint public onceOuttime;
88 	uint8 public per;
89 	
90 	
91 	uint[] public mans;
92 	uint[] public pers;
93 	uint[] public prizeper;
94 	uint[] public prizelevelsuns;
95 	uint[] public prizelevelmans;
96 	uint[] public prizelevelsunsday;
97 	uint[] public prizelevelmoneyday;
98 	uint[] public prizeactivetime;
99 	
100 	address[] public mansdata;
101 	uint[] public moneydata;
102 	uint[] public timedata;
103 	uint public pubper;
104 	uint public subper;
105 	uint public luckyper;
106 	uint public lastmoney;
107 	uint public lastper;
108 	uint public lasttime;
109 	uint public sellkeyper;
110 	
111 	//bool public isend;
112 	uint public tags;
113 	//uint public opentime;
114 	
115 	uint public runper;
116 	uint public sellper;
117 	uint public sellupper;
118 	uint public sysday;
119 	uint public cksysday;
120 	//uint public nulldayeth;
121     mapping(uint => mapping(uint => uint)) allprize;
122 	//uint public allprizeused;
123 	mapping(address => uint) balances;
124 	
125 	mapping(address => mapping(address => uint)) allowed;
126 	mapping(address => bool) public frozenAccount;
127 	struct usercan{
128 	    uint eths;
129 	    uint used;
130 	    uint len;
131 	    uint[] times;
132 	    uint[] moneys;
133 	    uint[] amounts;
134 	}
135 	mapping(address => usercan) mycan;
136 	mapping(address => usercan) myrun;
137 	struct userdata{
138 	    uint systemtag;
139 	    uint tzs;
140 	    uint usereths;
141 	    uint userethsused;
142 	    uint mylevelid;
143 	    uint mykeysid;
144 	    uint mykeyeths;
145 	    uint prizecount;
146 	    address fromaddr;
147 	    uint sun1;
148 	    uint sun2;
149 	    uint sun3;
150 	    mapping(uint => uint) mysunsdaynum;
151 	    mapping(uint => uint) myprizedayget;
152 	    mapping(uint => uint) daysusereths;
153 	    mapping(uint => uint) daysuserdraws;
154 	    mapping(uint => uint) daysuserlucky;
155 	    mapping(uint => uint) levelget;
156 	    mapping(uint => bool) hascountprice;
157 	}
158 	mapping(address => userdata) my;
159 	uint[] public leveldata;
160 	mapping(uint => mapping(uint => uint)) public userlevelsnum;
161 
162 	//与用户钥匙id对应
163 	mapping(uint => address) public myidkeys;
164 	//all once day get all
165 	mapping(uint => uint) public daysgeteths;
166 	mapping(uint => uint) public dayseths;
167 	//user once day pay
168 	mapping(uint => uint) public daysysdraws;
169 	struct tagsdata{
170 	    uint ethnum;//用户总资产
171 	    uint sysethnum;//系统总eth
172 	    uint userethnum;//用户总eth
173 	    uint userethnumused;//用户总eth
174 	    uint syskeynum;//系统总key
175 	}
176 	mapping(uint => tagsdata) tg;
177 	mapping(address => bool) mangeruser;
178 	mapping(address => uint) mangerallowed;
179 	string private version;
180 	string private downurl;
181 	string private notices;
182 	/* 通知 */
183 	event Transfer(address indexed from, address indexed to, uint tokens);
184 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
185 	event FrozenFunds(address target, bool frozen);
186 	event ethchange(address indexed from, address indexed to, uint tokens);
187 	modifier onlySystemStart() {
188         require(actived == true);
189 	    require(tags == my[msg.sender].systemtag);
190 	    require(!frozenAccount[msg.sender]);
191         _;
192     }
193 
194 	constructor() public {
195 		symbol = "OASIS";
196 		name = "Oasis";
197 		decimals = 18;
198 		_totalSupply = 50000000 ether;
199 	
200 		actived = true;
201 		tags = 0;
202 		tg[0] = tagsdata(0,0,0,0,0);
203 		
204         keyconfig.currentkeyid = 0;
205         keyconfig.keyidarr = [10055555,20055555,30055555,40055555,50055555,60055555,70055555,80055555,90055555];
206         worksdata = [0,0,0,0,0,0,0,0,0];   
207         runper = 10;
208 		mans = [2,4,6];
209 		pers = [50,30,20];
210 		prizeper = [2,2,2];
211 		prizeactivetime = [0,0,0];
212 		pubper = 2;
213 		subper = 120;
214 		luckyper = 5;
215 		lastmoney = 0;
216 		lastper = 2;
217 		sellkeyper = 70;
218 		sellper = 10;
219 		sellupper = 50;
220 		leveldata = [0,0,0];
221 		
222         
223         onceOuttime = 24 hours;
224         keyconfig.basekeynum = 4500 ether;//4500
225 	    keyconfig.basekeysub = 2000 ether;//500
226 	    keyconfig.usedkeynum = 0;//0
227         keyconfig.startprice = 0.01 ether;//
228         keyconfig.keyprice   = 0.01 ether;//
229         keyconfig.startbasekeynum = 4500 ether;//4500
230         per = 10;  
231         prizelevelsuns = [20,30,50];
232 		prizelevelmans = [100,300,800];
233 		prizelevelsunsday = [1,3,5];
234 		prizelevelmoneyday = [9 ether,29 ether,49 ether];
235 		lasttime = 8 hours;
236 		sysday = 1 days;
237 		cksysday = 8 hours;
238         version = '1.01';
239 		balances[this] = _totalSupply;
240 		owner = msg.sender;
241 		emit Transfer(address(0), this, _totalSupply);
242 	}
243 
244 	function balanceOf(address tokenOwner) public view returns(uint balance) {
245 		return balances[tokenOwner];
246 	}
247 	
248 	function showlvzhou(address user) public view returns(
249 	    uint total,
250 	    uint mykeyid,
251 	    uint mytzs,
252 	    uint daysget,
253 	    uint prizeget,
254 	    uint mycans,
255 	    uint mykeynum,
256 	    uint keyprices,
257 	    uint ltkeynum,
258 	    uint tagss,
259 	    uint mytags
260 	    
261 	){
262 	    total = tg[tags].userethnum;//0
263 	    mykeyid = my[user].mykeysid;//1
264 	    mytzs = my[user].tzs;//2
265 	    daysget = my[user].usereths*per/1000;//3
266 	    prizeget = my[user].prizecount;//4
267 	    mycans = getcanuse(user);//5
268 	    mykeynum = balanceOf(user);//6
269 	    keyprices = getbuyprice();//7
270 	    ltkeynum = leftnum();//8
271 	    tagss = tagss;//9
272 	    mytags = my[user].systemtag;//10
273 	}
274 	function showteam(address user) public view returns(
275 	    uint daysnum,//0
276 	    uint dayseth,//1
277 	    uint daysnum1,//2
278 	    uint dayseth1,//3
279 	    uint man1,//4
280 	    uint man2,//5
281 	    uint man3,//6
282 	    uint myruns,//7
283 	    uint canruns,//8
284 	    uint levelid//9
285 	){
286 	    uint d = gettoday();
287 	    uint t = getyestoday();
288 	    daysnum = my[user].mysunsdaynum[d];//5
289 	    dayseth = my[user].myprizedayget[d];//6
290 	    daysnum1 = my[user].mysunsdaynum[t];//5
291 	    dayseth1 = my[user].myprizedayget[t];//6
292 	    man1 = my[user].sun1;//2
293 	    man2 = my[user].sun2;//3
294 	    man3 = my[user].sun3;//4
295 	    myruns = myrun[user].eths;//6
296 	    canruns = getcanuserun(user);//7
297 	    levelid = my[user].mylevelid;//8
298 	}
299 	function showlevel(address user) public view returns(
300 	    uint myget,//0
301 	    uint levelid,//1
302 	    uint len1,//2
303 	    uint len2,//3
304 	    uint len3,//4
305 	    uint m1,//5
306 	    uint m2,//6
307 	    uint m3,//7
308 	    uint t1,//8
309 	    uint t2,//9
310 	    uint t3,//10
311 	    uint levelget//11
312 	){
313 	    (levelid, myget) = getprizemoney(user);
314 	    //len2 = leveldata[1];
315 	    //len3 = leveldata[2];
316 	    m1 = allprize[0][0] - allprize[0][1];//5
317 	    m2 = allprize[1][0] - allprize[1][1];//6
318 	    m3 = allprize[2][0] - allprize[2][1];//7
319 	    t1 = prizeactivetime[0];//8
320 	    uint d = getyestoday();
321 	    if(t1 > 0) {
322 	        if(t1 + sysday > now){
323     	        len1 = leveldata[0];
324     	    }else{
325     	        len1 = userlevelsnum[1][d];
326 	        }
327 	    }
328 	    
329 	    t2 = prizeactivetime[1];//9
330 	    if(t2 > 0) {
331 	        if(t2 + sysday > now){
332     	        len2 = leveldata[1];
333     	    }else{
334     	        len2 = userlevelsnum[2][d];
335     	    }
336 	    }
337 	    
338 	    t3 = prizeactivetime[2];//10
339 	    if(t3 > 0) {
340 	        if(t3 + sysday > now){
341     	        len3 = leveldata[2];
342     	    }else{
343     	        len3 = userlevelsnum[3][d];
344     	    }
345 	    }
346 	    
347 	    levelget = my[user].levelget[d];//11
348 	}
349 	
350 	
351 	function showethconf(address user) public view returns(
352 	    uint todaymyeth,
353 	    uint todaymydraw,
354 	    uint todaysyseth,
355 	    uint todaysysdraw,
356 	    uint yestodaymyeth,
357 	    uint yestodaymydraw,
358 	    uint yestodaysyseth,
359 	    uint yestodaysysdraw
360 	){
361 	    uint d = gettoday();
362 		uint t = getyestoday();
363 		todaymyeth = my[user].daysusereths[d];
364 		todaymydraw = my[user].daysuserdraws[d];
365 		todaysyseth = dayseths[d];
366 		todaysysdraw = daysysdraws[d];
367 		yestodaymyeth = my[user].daysusereths[t];
368 		yestodaymydraw = my[user].daysuserdraws[t];
369 		yestodaysyseth = dayseths[t];
370 		yestodaysysdraw = daysysdraws[t];
371 		
372 	}
373 	function showprize(address user) public view returns(
374 	    uint lttime,//0
375 	    uint ltmoney,//1
376 	    address ltaddr,//2
377 	    uint lastmoneys,//3
378 	    address lastuser,//4
379 	    uint luckymoney,//5
380 	    address luckyuser,//6
381 	    uint luckyget//7
382 	){
383 	    if(timedata.length > 0) {
384 	       lttime = timedata[timedata.length - 1];//1 
385 	    }else{
386 	        lttime = 0;
387 	    }
388 	    if(moneydata.length > 0) {
389 	       ltmoney = moneydata[moneydata.length - 1];//2 
390 	    }else{
391 	        ltmoney = 0;
392 	    }
393 	    if(mansdata.length > 0) {
394 	        ltaddr = mansdata[mansdata.length - 1];//3
395 	    }else{
396 	        ltaddr = address(0);
397 	    }
398 	    lastmoneys = lastmoney;
399 	    lastuser = getlastuser();
400 	    uint d = getyestoday();
401 	    if(dayseths[d] > 0) {
402 	        luckymoney = dayseths[d]*luckyper/1000;
403 	        luckyuser = getluckyuser();
404 	        luckyget = my[user].daysuserlucky[d];
405 	    }
406 	    
407 	}
408 	function interuser(address user) public view returns(
409 	    uint skeyid,
410 	    uint stzs,
411 	    uint seths,
412 	    uint sethcan,
413 	    uint sruns,
414 	    uint srunscan,
415 	    uint skeynum
416 	    
417 	){
418 	    skeyid = my[user].mykeysid;
419 	    stzs = my[user].tzs;
420 	    seths = mycan[user].eths;
421 	    sethcan = getcanuse(user);
422 	    sruns = myrun[user].eths;
423 	    srunscan = getcanuserun(user);
424 	    skeynum = balances[user];
425 	}
426 	function showworker() public view returns(
427 	    uint w0,
428 	    uint w1,
429 	    uint w2,
430 	    uint w3,
431 	    uint w4,
432 	    uint w5,
433 	    uint w6,
434 	    uint w7,
435 	    uint w8
436 	){
437 	    w0 = worksdata[0];
438 	    w1 = worksdata[1];
439 	    w2 = worksdata[2];
440 	    w3 = worksdata[3];
441 	    w4 = worksdata[4];
442 	    w5 = worksdata[5];
443 	    w6 = worksdata[6];
444 	    w7 = worksdata[7];
445 	    w8 = worksdata[8];
446 	}
447 	
448 	function addmoney(address _addr, uint256 _amount, uint256 _money, uint _day) private returns(bool){
449 		mycan[_addr].eths += _money;
450 		mycan[_addr].len++;
451 		mycan[_addr].amounts.push(_amount);
452 		mycan[_addr].moneys.push(_money);
453 		if(_day > 0){
454 		    mycan[_addr].times.push(0);
455 		}else{
456 		    mycan[_addr].times.push(now);
457 		}
458 		
459 	}
460 	function reducemoney(address _addr, uint256 _money) private returns(bool){
461 	    if(mycan[_addr].eths >= _money && my[_addr].tzs >= _money) {
462 	        mycan[_addr].used += _money;
463     		mycan[_addr].eths -= _money;
464     		my[_addr].tzs -= _money;
465     		return(true);
466 	    }else{
467 	        return(false);
468 	    }
469 		
470 	}
471 	function addrunmoney(address _addr, uint256 _amount, uint256 _money, uint _day) private {
472 		myrun[_addr].eths += _money;
473 		myrun[_addr].len++;
474 		myrun[_addr].amounts.push(_amount);
475 		myrun[_addr].moneys.push(_money);
476 		if(_day > 0){
477 		    myrun[_addr].times.push(0);
478 		}else{
479 		    myrun[_addr].times.push(now);
480 		}
481 	}
482 	function reducerunmoney(address _addr, uint256 _money) private {
483 		myrun[_addr].eths -= _money;
484 		myrun[_addr].used += _money;
485 	}
486 
487 	function getcanuse(address user) public view returns(uint _left) {
488 		if(mycan[user].len > 0) {
489 		    for(uint i = 0; i < mycan[user].len; i++) {
490     			uint stime = mycan[user].times[i];
491     			if(stime == 0) {
492     			    _left += mycan[user].moneys[i];
493     			}else{
494     			    if(now - stime >= onceOuttime) {
495     			        uint smoney = mycan[user].amounts[i] * ((now - stime)/onceOuttime) * per/ 1000;
496     			        if(smoney <= mycan[user].moneys[i]){
497     			            _left += smoney;
498     			        }else{
499     			            _left += mycan[user].moneys[i];
500     			        }
501     			    }
502     			    
503     			}
504     		}
505 		}
506 		if(_left < mycan[user].used) {
507 			return(0);
508 		}
509 		if(_left > mycan[user].eths) {
510 			return(mycan[user].eths);
511 		}
512 		return(_left - mycan[user].used);
513 		
514 	}
515 	function getcanuserun(address user) public view returns(uint _left) {
516 		if(myrun[user].len > 0) {
517 		    for(uint i = 0; i < myrun[user].len; i++) {
518     			uint stime = myrun[user].times[i];
519     			if(stime == 0) {
520     			    _left += myrun[user].moneys[i];
521     			}else{
522     			    if(now - stime >= onceOuttime) {
523     			        uint smoney = myrun[user].amounts[i] * ((now - stime)/onceOuttime) * per/ 1000;
524     			        if(smoney <= myrun[user].moneys[i]){
525     			            _left += smoney;
526     			        }else{
527     			            _left += myrun[user].moneys[i];
528     			        }
529     			    }
530     			}
531     		}
532 		}
533 		if(_left < myrun[user].used) {
534 			return(0);
535 		}
536 		if(_left > myrun[user].eths) {
537 			return(myrun[user].eths);
538 		}
539 		return(_left - myrun[user].used);
540 	}
541 
542 	function _transfer(address from, address to, uint tokens) private{
543 		require(!frozenAccount[from]);
544 		require(!frozenAccount[to]);
545 		require(actived == true);
546 		require(from != to);
547         require(to != 0x0);
548         require(balances[from] >= tokens);
549         require(balances[to] + tokens > balances[to]);
550         uint previousBalances = balances[from] + balances[to];
551         balances[from] -= tokens;
552         balances[to] += tokens;
553         assert(balances[from] + balances[to] == previousBalances);
554         
555 		emit Transfer(from, to, tokens);
556 	}
557     function transfer(address _to, uint256 _value) onlySystemStart() public returns(bool){
558         _transfer(msg.sender, _to, _value);
559         return(true);
560     }
561     function activekey() onlySystemStart() public returns(bool) {
562 	    address addr = msg.sender;
563         uint keyval = 1 ether;
564         require(balances[addr] > keyval);
565         require(my[addr].mykeysid < 1);
566         address top = my[addr].fromaddr;
567         uint topkeyids = keyconfig.currentkeyid;
568         if(top != address(0) && my[top].mykeysid > 0) {
569             topkeyids = my[top].mykeysid/10000000 - 1;
570         }else{
571             keyconfig.currentkeyid++;
572             if(keyconfig.currentkeyid > 8){
573                 keyconfig.currentkeyid = 0;
574             }
575         }
576         keyconfig.keyidarr[topkeyids]++;
577         uint kid = keyconfig.keyidarr[topkeyids];
578         require(myidkeys[kid] == address(0));
579         my[addr].mykeysid = kid;
580 	    myidkeys[kid] = addr;
581 	    balances[addr] -= keyval;
582 	    balances[owner] += keyval;
583 	    emit Transfer(addr, owner, keyval);
584 	    return(true);
585 	    
586     }
587     
588 	function getfrom(address _addr) public view returns(address) {
589 		return(my[_addr].fromaddr);
590 	}
591     function gettopid(address addr) public view returns(uint) {
592         address topaddr = my[addr].fromaddr;
593         if(topaddr == address(0)) {
594             return(0);
595         }
596         uint keyid = my[topaddr].mykeysid;
597         if(keyid > 0 && myidkeys[keyid] == topaddr) {
598             return(keyid);
599         }else{
600             return(0);
601         }
602     }
603     
604 	function approve(address spender, uint tokens) public returns(bool success) {
605 	    require(actived == true);
606 		allowed[msg.sender][spender] = tokens;
607 		emit Approval(msg.sender, spender, tokens);
608 		return true;
609 	}
610 
611 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
612 		require(actived == true);
613 		require(!frozenAccount[from]);
614 		require(!frozenAccount[to]);
615 		balances[from] -= tokens;
616 		allowed[from][msg.sender] -= tokens;
617 		balances[to] += tokens;
618 		emit Transfer(from, to, tokens);
619 		return true;
620 	}
621 
622 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
623 		return allowed[tokenOwner][spender];
624 	}
625 
626 	function freezeAccount(address target, bool freeze) public onlyOwner{
627 		frozenAccount[target] = freeze;
628 		emit FrozenFunds(target, freeze);
629 	}
630 	
631 	function setactive(bool t) public onlyOwner{
632 		actived = t;
633 	}
634     
635 	function mintToken(address target, uint256 mintedAmount) public onlyOwner{
636 		require(!frozenAccount[target]);
637 		require(actived == true);
638 		require(mintedAmount < balances[this]*20/100);
639 		balances[target] += mintedAmount;
640 		balances[this] -= mintedAmount;
641 		emit Transfer(this, target, mintedAmount);
642 	}
643 	
644 	function getyestoday() public view returns(uint d) {
645 	    uint today = gettoday();
646 	    d = today - sysday;
647 	}
648 	
649 	function gettoday() public view returns(uint d) {
650 	    uint n = now;
651 	    d = n - n%sysday - cksysday;
652 	}
653 	function totalSupply() public view returns(uint) {
654 		return(_totalSupply - balances[this]);
655 	}
656 
657 	function getbuyprice() public view returns(uint kp) {
658         if(keyconfig.usedkeynum == keyconfig.basekeynum) {
659             kp = keyconfig.keyprice + keyconfig.startprice;
660         }else{
661             kp = keyconfig.keyprice;
662         }
663 	    
664 	}
665 	function leftnum() public view returns(uint num) {
666 	    if(keyconfig.usedkeynum == keyconfig.basekeynum) {
667 	        num = keyconfig.basekeynum + keyconfig.basekeysub;
668 	    }else{
669 	        num = keyconfig.basekeynum - keyconfig.usedkeynum;
670 	    }
671 	}
672 	
673 	function getlevel(address addr) public view returns(uint) {
674 	    uint nums = my[addr].sun1 + my[addr].sun2 + my[addr].sun3;
675 	    if(my[addr].sun1 >= prizelevelsuns[2] && nums >= prizelevelmans[2]) {
676 	        return(3);
677 	    }
678 	    if(my[addr].sun1 >= prizelevelsuns[1] && nums >= prizelevelmans[1]) {
679 	        return(2);
680 	    }
681 	    if(my[addr].sun1 >= prizelevelsuns[0] && nums >= prizelevelmans[0]) {
682 	        return(1);
683 	    }
684 	    return(0);
685 	}
686 	
687 	function gettruelevel(address user, uint d) public view returns(uint) {
688 	    //uint d = getyestoday();
689 	    uint money = my[user].myprizedayget[d];
690 	    uint mymans = my[user].mysunsdaynum[d];
691 	    if(mymans >= prizelevelsunsday[2] && money >= prizelevelmoneyday[2]) {
692 	        if(my[user].mylevelid < 3){
693 	            return(my[user].mylevelid);
694 	        }else{
695 	           return(3); 
696 	        }
697 	        
698 	    }
699 	    if(mymans >= prizelevelsunsday[1] && money >= prizelevelmoneyday[1]) {
700 	        if(my[user].mylevelid < 2){
701 	            return(my[user].mylevelid);
702 	        }else{
703 	           return(2); 
704 	        }
705 	    }
706 	    if(mymans >= prizelevelsunsday[0] && money >= prizelevelmoneyday[0]) {
707 	        if(my[user].mylevelid < 1){
708 	            return(0);
709 	        }else{
710 	           return(1); 
711 	        }
712 	    }
713 	    return(0);
714 	    
715 	}
716 	function setlevel(address user) private returns(bool) {
717 	    uint lid = getlevel(user);
718 	    uint uid = my[user].mylevelid;
719 	    uint d = gettoday();
720 	    if(uid < lid) {
721 	        //if(uid > 0) {
722 	        //    leveldata[uid - 1]--;
723 	        //}
724 	        my[user].mylevelid = lid;
725 	        uint p = lid - 1;
726 	        //leveldata[p]++;
727 	        if(prizeactivetime[p] < 1) {
728 	            prizeactivetime[p] = d + sysday*2;
729 	        }
730 	        if(now < prizeactivetime[p]) {
731 	            leveldata[p]++;
732 	        }
733 	    }
734 	    if(lid > 0) {
735 	        uint tid = gettruelevel(user, d);
736     	    if(tid > 0 && prizeactivetime[tid - 1] > 0 && !my[user].hascountprice[d]) {
737     	         userlevelsnum[tid][d]++; 
738     	         my[user].hascountprice[d] = true;
739     	     }
740 	    }
741 	}
742 	function getprizemoney(address user) public view returns(uint lid, uint ps) {
743 	    lid = my[user].mylevelid;
744 	    if(lid > 0) {
745 	        uint p = lid - 1;
746 	        uint activedtime = prizeactivetime[p];
747 	        if(activedtime > 0 && activedtime < now) {
748 	            if(now  > activedtime  + sysday){
749 	                uint d = getyestoday();
750 	                uint ld = gettruelevel(user, d);
751 	                if(ld > 0) {
752 	                   uint pp = ld - 1;
753 	                   if(allprize[pp][0] > allprize[pp][1] && userlevelsnum[ld][d] > 0) {
754 	                       ps = (allprize[pp][0] - allprize[pp][1])/userlevelsnum[ld][d];
755 	                   }
756 	                }
757 	                return(ld, ps);
758 	            }else{
759 	                //uint d = activedtime - sysday;
760 	                
761 	                if(allprize[p][0] > allprize[p][1]){
762 	                    uint dd = gettoday();
763 	                    if(!my[user].hascountprice[dd]){
764 	                        ps = (allprize[p][0] - allprize[p][1])/leveldata[p];
765 	                    }
766 	                    
767 	                }
768 	            }
769 	            
770 	        }
771 	    }
772 	    return(lid, ps);
773 	}
774 	function getprize() onlySystemStart() public returns(bool) {
775 	    address user = msg.sender;
776 	    if(my[user].mylevelid > 0) {
777 	        (uint lid, uint ps) = getprizemoney(user);
778 	        if(lid > 0 && ps > 0) {
779 	            uint d = getyestoday();
780 	            require(my[user].levelget[d] == 0);
781         	    my[user].levelget[d] += ps;
782         	    allprize[lid - 1][1] += ps;
783         	    addrunmoney(user, ps, ps, 100);
784         	    
785 	        }
786 	    }
787 	}
788 	
789 	
790 	function getfromsun(address addr, uint money, uint amount) private returns(bool){
791 	    address f1 = my[addr].fromaddr;
792 	    uint d = gettoday();
793 	    if(f1 != address(0) && f1 != addr) {
794 	        if(my[f1].sun1 >= mans[0]){
795 	            addrunmoney(f1, (amount*pers[0])/100, (money*pers[0])/100, 0);
796 	        }
797 	    	my[f1].myprizedayget[d] += amount;
798 	    	if(my[f1].mykeysid > 10000000) {
799 	    	    worksdata[((my[f1].mykeysid/10000000) - 1)] += amount;
800 	    	}
801 	    	setlevel(f1);
802 	    	address f2 = my[f1].fromaddr;
803 	    	if(f2 != address(0) && f2 != addr) {
804     	        if(my[f2].sun1 >= mans[1]){
805     	           addrunmoney(f2, (amount*pers[1])/100, (money*pers[1])/100, 0); 
806     	        }
807     	    	my[f2].myprizedayget[d] += amount;
808     	    	setlevel(f2);
809     	    	address f3 = my[f2].fromaddr;
810     	    	if(f3 != address(0) && f3 != addr) {
811         	        if(my[f3].sun1 >= mans[2]){
812         	            addrunmoney(f3, (amount*pers[2])/100, (money*pers[2])/100, 0);
813         	        }
814         	    	my[f3].myprizedayget[d] += amount;
815         	    	setlevel(f3);
816         	    }
817     	    }	
818 	    }
819 	    
820 	}
821 	function setpubprize(uint sendmoney) private returns(bool) {
822 	    uint len = moneydata.length;
823 	    if(len > 0) {
824 	        uint all = 0;
825 	        uint start = 0;
826 	        uint m = 0;
827 	        if(len > 10) {
828 	            start = len - 10;
829 	        }
830 	        for(uint i = start; i < len; i++) {
831 	            all += moneydata[i];
832 	        }
833 	        //uint sendmoney = amount*pubper/100;
834 	        for(; start < len; start++) {
835 	            m = (sendmoney*moneydata[start])/all;
836 	            addmoney(mansdata[start],m, m, 100);
837 	            my[mansdata[start]].prizecount += m;
838 	        }
839 	    }
840 	    return(true);
841 	}
842 	function getluckyuser() public view returns(address addr) {
843 	    if(moneydata.length > 0){
844 	        uint d = gettoday();
845     	    uint t = getyestoday();
846     	    uint maxmoney = 1 ether;
847     	    for(uint i = 0; i < moneydata.length; i++) {
848     	        if(timedata[i] > t && timedata[i] < d && moneydata[i] >= maxmoney) {
849     	            maxmoney = moneydata[i];
850     	            addr = mansdata[i];
851     	        }
852     	    }
853 	    }
854 	    
855 	}
856 	function getluckyprize() onlySystemStart() public returns(bool) {
857 	    address user = msg.sender;
858 	    require(user != address(0));
859 	    require(user == getluckyuser());
860 	    uint d = getyestoday();
861 	    require(my[user].daysusereths[d] > 0);
862 	    require(my[user].daysuserlucky[d] == 0);
863 	    uint money = dayseths[d]*luckyper/1000;
864 	    addmoney(user, money,money, 100);
865 	    my[user].daysuserlucky[d] += money;
866 	    my[user].prizecount += money;
867 	    uint t = getyestoday() - sysday;
868 	    for(uint i = 0; i < moneydata.length; i++) {
869     	    if(timedata[i] < t) {
870     	        delete moneydata[i];
871     	        delete timedata[i];
872     	        delete mansdata[i];
873     	    }
874     	}
875 	}
876 	
877 	function runtoeth(uint amount) onlySystemStart() public returns(bool) {
878 	    address user = msg.sender;
879 	    uint usekey = (amount*runper*1 ether)/(100*keyconfig.keyprice);
880 	    require(usekey < balances[user]);
881 	    require(getcanuserun(user) >= amount);
882 	    //require(transfer(owner, usekey) == true);
883 	    balances[user] -= usekey;
884 		balances[owner] += usekey;
885 		emit Transfer(user, owner, usekey);
886 		
887 	    reducerunmoney(user, amount);
888 	    addmoney(user, amount, amount, 100);
889 	    
890 	    
891 	}
892 	function getlastuser() public view returns(address user) {
893 	    if(timedata.length > 0) {
894     	    if(lastmoney > 0 && now - timedata[timedata.length - 1] > lasttime) {
895     	        user = mansdata[mansdata.length - 1];
896     	    }
897 	    } 
898 	}
899 	function getlastmoney() public returns(bool) {
900 	    address user = getlastuser();
901 	    require(user != address(0));
902 	    require(user == msg.sender);
903 	    require(lastmoney > 0);
904 	    require(lastmoney <= address(this).balance/2);
905 	    user.transfer(lastmoney);
906 	    lastmoney = 0;
907 	}
908 	
909 	function buy(uint keyid) onlySystemStart() public payable returns(bool) {
910 		address user = msg.sender;
911 		require(msg.value > 0);
912         uint amount = msg.value;
913 		require(amount >= 1 ether);
914 		require(amount%(1 ether) == 0);
915 		require(my[user].usereths <= 100 ether);
916 		uint money = amount*3;
917 		uint d = gettoday();
918 		uint t = getyestoday();
919 		bool ifadd = false;
920 		//if has no top
921 		if(my[user].fromaddr == address(0)) {
922 		    address topaddr = myidkeys[keyid];
923 		    if(keyid > 0 && topaddr != address(0) && topaddr != user) {
924 		        my[user].fromaddr = topaddr;
925     		    my[topaddr].sun1++;
926     		    my[topaddr].mysunsdaynum[d]++;
927     		    address top2 = my[topaddr].fromaddr;
928     		    if(top2 != address(0) && top2 != user){
929     		        my[top2].sun2++;
930     		        //my[top2].mysunsdaynum[d]++;
931     		    }
932     		    address top3 = my[top2].fromaddr;
933     		    if(top3 != address(0) && top3 != user){
934     		        my[top3].sun3++;
935     		        //my[top3].mysunsdaynum[d]++;
936     		    }
937     		    ifadd = true;
938 		    }
939 		}else{
940 		    ifadd = true;
941 		}
942 		if(ifadd == true) {
943 		    money = amount*4;
944 		}
945 		
946 		if(daysgeteths[t] > 0 && daysgeteths[d] > (daysgeteths[t]*subper)/100) {
947 		    if(ifadd == true) {
948     		    money = amount*3;
949     		}else{
950     		    money = amount*2;
951     		}
952 		}
953 		if(ifadd == true) {
954 		    getfromsun(user, money, amount);
955 		}
956 		setpubprize(amount*pubper/100);
957 		mansdata.push(user);
958 		moneydata.push(amount);
959 		timedata.push(now);
960 		
961 	    daysgeteths[d] += money;
962 	    dayseths[d] += amount;
963 	    tg[tags].sysethnum += amount;
964 		tg[tags].userethnum += amount;
965 		my[user].daysusereths[d] += amount;
966 		
967 		my[user].tzs += money;
968 		lastmoney += amount*lastper/100;
969 		tg[tags].ethnum += money;
970 		my[user].usereths += amount;
971 		allprize[0][0] += amount*prizeper[0]/100;
972 		allprize[1][0] += amount*prizeper[1]/100;
973 		allprize[2][0] += amount*prizeper[2]/100;
974 		addmoney(user, amount, money, 0);
975 		return(true);
976 	}
977 	
978 	function keybuy(uint m) onlySystemStart() public returns(bool) {
979 	    address user = msg.sender;
980 	    require(m >= 1 ether);
981 	    require(balances[user] >= m);
982 	    uint amount = (m*keyconfig.keyprice)/(1 ether);
983 	    require(amount >= 1 ether);
984 	    require(amount%(1 ether) == 0);
985 	    uint money = amount*3;
986 	    
987 		uint d = gettoday();
988 		uint t = getyestoday();
989 		if(my[user].fromaddr != address(0)) {
990 		    money = amount*4;
991 		}
992 		
993 		if(daysgeteths[t] > 0 && daysgeteths[d] > daysgeteths[t]*subper/100) {
994 		    if(my[user].fromaddr == address(0)) {
995     		    money = amount*2;
996     		}else{
997     		    money = amount*3;
998     		}
999 		}
1000 		tg[tags].ethnum += money;
1001 		my[user].tzs += money;
1002 		addmoney(user, amount, money, 0);
1003 		balances[user] -= m;
1004 	    balances[owner] += m;
1005 		emit Transfer(user, owner, m);
1006 	    return(true);
1007 	}
1008 	function ethbuy(uint amount) onlySystemStart() public returns(bool) {
1009 	    address user = msg.sender;
1010 	    uint canmoney = getcanuse(user);
1011 	    require(canmoney >= amount);
1012 	    require(amount >= 1 ether);
1013 	    require(amount%(1 ether) == 0);
1014 	    require(mycan[user].eths >= amount);
1015 	    require(my[user].tzs >= amount);
1016 	    uint money = amount*3;
1017 		uint d = gettoday();
1018 		uint t = getyestoday();
1019 		if(my[user].fromaddr == address(0)) {
1020 		    money = amount*2;
1021 		}
1022 		
1023 		if(daysgeteths[t] > 0 && daysgeteths[d] > daysgeteths[t]*subper/100) {
1024 		    if(my[user].fromaddr == address(0)) {
1025     		    money = amount;
1026     		}else{
1027     		    money = amount*2;
1028     		}
1029 		}
1030 		addmoney(user, amount, money, 0);
1031 		my[user].tzs += money;
1032 		mycan[user].used += money;
1033 	    tg[tags].ethnum += money;
1034 	    
1035 	    return(true);
1036 	}
1037 	
1038 	function charge() public payable returns(bool) {
1039 		return(true);
1040 	}
1041 	
1042 	function() payable public {
1043 		buy(0);
1044 	}
1045 	
1046 	function sell(uint256 amount) onlySystemStart() public returns(bool success) {
1047 		address user = msg.sender;
1048 		require(amount > 0);
1049 		uint d = gettoday();
1050 		uint t = getyestoday();
1051 		uint256 canuse = getcanuse(user);
1052 		require(canuse >= amount);
1053 		require(address(this).balance/2 > amount);
1054 		uint p = sellper;
1055 		if(dayseths[t] > dayseths[d]){
1056 		    if((daysysdraws[d] + amount) > (dayseths[t]*subper/100)){
1057 		        p = sellupper;
1058 		    }
1059 		}else{
1060 		    if(dayseths[d] > 0 && (daysysdraws[d] + amount) > (dayseths[d]*subper/100)){
1061 		        p = sellupper;
1062 		    }
1063 		}
1064 		uint useper = (amount*p*(1 ether))/(keyconfig.keyprice*100);
1065 		
1066 		require(balances[user] >= useper);
1067 		require(reducemoney(user, amount) == true);
1068 		
1069 		my[user].userethsused += amount;
1070 		tg[tags].userethnumused += amount;
1071 		my[user].daysuserdraws[d] += amount;
1072 		daysysdraws[d] += amount;
1073 		//_transfer(user, owner, useper);
1074 		balances[user] -= useper;
1075 	    balances[owner] += useper;
1076 		emit Transfer(user, owner, useper);
1077 		user.transfer(amount);
1078 		
1079 		setend();
1080 		return(true);
1081 	}
1082 	
1083 	function sellkey(uint256 amount) onlySystemStart() public returns(bool) {
1084 	    address user = msg.sender;
1085 		require(balances[user] >= amount);
1086 		
1087 		uint d = gettoday();
1088 		uint t = getyestoday();
1089 		
1090 		require(dayseths[t] > 0);
1091 		
1092 		uint money = (keyconfig.keyprice*amount*sellkeyper)/(100 ether);
1093 		if(daysysdraws[d] > 0 && (daysysdraws[d] + money) > dayseths[t]*2){
1094 		    money = (keyconfig.keyprice*amount)/(2 ether);
1095 		}
1096 		require(address(this).balance > money);
1097 		//require(tg[tags].userethnumused + money <= tg[tags].userethnum/2);
1098 		my[user].userethsused += money;
1099         tg[tags].userethnumused += money;
1100         daysysdraws[d] += money;
1101     	//_transfer(user, owner, amount);
1102     	balances[user] -= amount;
1103 	    balances[owner] += amount;
1104 		emit Transfer(user, owner, amount);
1105 		
1106     	user.transfer(money);
1107     	setend();
1108 	}
1109 
1110 	
1111 	function buykey(uint buynum) onlySystemStart() public payable returns(bool){
1112 	    uint money = msg.value;
1113 	    address user = msg.sender;
1114 	    require(buynum >= 1 ether);
1115 	    require(buynum%(1 ether) == 0);
1116 	    require(keyconfig.usedkeynum + buynum <= keyconfig.basekeynum);
1117 	    require(money >= keyconfig.keyprice);
1118 	    require(user.balance >= money);
1119 	    require(mycan[user].eths > 0);
1120 	    require(((keyconfig.keyprice*buynum)/1 ether) == money);
1121 	    
1122 	    my[user].mykeyeths += money;
1123 	    tg[tags].sysethnum += money;
1124 	    tg[tags].syskeynum += buynum;
1125 		if(keyconfig.usedkeynum + buynum == keyconfig.basekeynum) {
1126 		    keyconfig.basekeynum = keyconfig.basekeynum + keyconfig.basekeysub;
1127 	        keyconfig.usedkeynum = 0;
1128 	        keyconfig.keyprice = keyconfig.keyprice + keyconfig.startprice;
1129 	    }else{
1130 	        keyconfig.usedkeynum += buynum;
1131 	    }
1132 	    _transfer(this, user, buynum);
1133 	}
1134 	
1135 	function setend() private returns(bool) {
1136 	    if(tg[tags].userethnum > 0 && tg[tags].userethnumused > tg[tags].userethnum/2) {
1137 	        tags++;
1138 	        keyconfig.keyprice = keyconfig.startprice;
1139 	        keyconfig.basekeynum = keyconfig.startbasekeynum;
1140 	        keyconfig.usedkeynum = 0;
1141 	        
1142 	        prizeactivetime = [0,0,0];
1143 	        leveldata = [0,0,0];
1144 	        return(true);
1145 	    }
1146 	}
1147 	function ended(bool ifget) public returns(bool) {
1148 	    address user = msg.sender;
1149 	    require(my[user].systemtag < tags);
1150 	    require(!frozenAccount[user]);
1151 	    if(ifget == true) {
1152 	        
1153     	    my[user].prizecount = 0;
1154     	    my[user].tzs = 0;
1155     	    my[user].prizecount = 0;
1156     		mycan[user].eths = 0;
1157     	    mycan[user].used = 0;
1158     	    if(mycan[user].len > 0) {
1159     	        delete mycan[user].times;
1160     	        delete mycan[user].amounts;
1161     	        delete mycan[user].moneys;
1162     	    }
1163     	    mycan[user].len = 0;
1164     	    
1165     		myrun[user].eths = 0;
1166     	    myrun[user].used = 0;
1167     	    if(myrun[user].len > 0) {
1168     	        delete myrun[user].times;
1169     	        delete myrun[user].amounts;
1170     	        delete myrun[user].moneys;
1171     	    }
1172     	    myrun[user].len = 0;
1173     	    if(my[user].usereths/2 > my[user].userethsused) {
1174     	        uint money = my[user].usereths/2 - my[user].userethsused;
1175 	            require(address(this).balance > money);
1176     	        user.transfer(money);
1177     	    }
1178     	    my[user].usereths = 0;
1179     	    my[user].userethsused = 0;
1180     	    
1181 	    }else{
1182 	        uint amount = my[user].usereths - my[user].userethsused;
1183 	        tg[tags].ethnum += my[user].tzs;
1184 	        tg[tags].sysethnum += amount;
1185 		    tg[tags].userethnum += amount;
1186 	    }
1187 	    my[user].systemtag = tags;
1188 	}
1189 	
1190 	function setmangeruser(address user, bool t) public onlyOwner{
1191 	    mangeruser[user] = t;
1192 	}
1193 	function setmangerallow(address user, uint m) public {
1194 	    require(mangeruser[msg.sender] == true);
1195 	    require(mangeruser[user] == true);
1196 	    require(user != address(0));
1197 	    require(user != msg.sender);
1198 	    require(mangerallowed[user] == 0);
1199 	    mangerallowed[user] = m;
1200 	}
1201 	function withdraw(address _to, uint money) public {
1202 	    require(money <= address(this).balance);
1203 	    require(_to != 0x0);
1204 	    address user = msg.sender;
1205 	    //if(user != owner){
1206 	    require(mangeruser[user] == true);
1207     	require(mangerallowed[user] == money);
1208     	require(tg[tags].sysethnum >= money);
1209     	//require(tg[tags].userethnumused + money <= tg[tags].sysethnum*4/10);
1210     	tg[tags].sysethnum -= money;
1211     	tg[tags].userethnumused += money;
1212     	mangerallowed[user] = 0;
1213 	    //}
1214 		_to.transfer(money);
1215 	}
1216 
1217 	function setper(uint onceOuttimes,uint8 perss,uint runpers,uint pubpers,uint subpers,uint luckypers,uint lastpers,uint sellkeypers,uint sellpers,uint selluppers,uint lasttimes,uint sysdays,uint cksysdays) public onlyOwner{
1218 	    onceOuttime = onceOuttimes;
1219 	    per = perss;
1220 	    runper = runpers;
1221 	    pubper = pubpers;
1222 	    subper = subpers;
1223 	    luckyper = luckypers;
1224 	    lastper = lastpers;
1225 	    sellkeyper = sellkeypers;
1226 	    sellper = sellpers;
1227 	    sellupper = selluppers;
1228 	    lasttime = lasttimes;//9
1229 	    sysday = sysdays;
1230 	    cksysday = cksysdays;
1231 	}
1232 	function setnotice(
1233 	    string versions,
1234 	    string downurls,
1235 	    string noticess
1236 	) public onlyOwner returns(bool){
1237 	    version = versions;
1238 	    downurl = downurls;
1239 	    notices = noticess;
1240 	}
1241 	function getnotice() public view returns(
1242 	    string versions,
1243 	    string downurls,
1244 	    string noticess
1245 	){
1246 	    versions = version;
1247 	    downurls = downurl;
1248 	    noticess = notices;
1249 	}
1250 	
1251 }