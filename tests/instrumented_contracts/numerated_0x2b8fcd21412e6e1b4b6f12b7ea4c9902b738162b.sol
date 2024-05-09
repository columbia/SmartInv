1 pragma solidity ^ 0.4.24;
2 
3 contract ERC20Interface {
4 	function totalSupply() public constant returns(uint);
5 	function balanceOf(address tokenOwner) public constant returns(uint balance);
6 	function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
7 	function transfer(address to, uint tokens) public returns(bool success);
8 	function approve(address spender, uint tokens) public returns(bool success);
9 	function transferFrom(address from, address to, uint tokens) public returns(bool success);
10 	event Transfer(address indexed from, address indexed to, uint tokens);
11 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
12 }
13 
14 contract ApproveAndCallFallBack {
15 	function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
16 }
17 
18 contract Owned {
19 	address public owner;
20 	address public newOwner;
21 
22 	event OwnershipTransferred(address indexed _from, address indexed _to);
23 
24 	constructor() public {
25 		owner = msg.sender;
26 	}
27 
28 	modifier onlyOwner {
29 		require(msg.sender == owner);
30 		_;
31 	}
32 
33 	function transferOwnership(address _newOwner) public onlyOwner {
34 		newOwner = _newOwner;
35 	}
36 
37 	function acceptOwnership() public {
38 		require(msg.sender == newOwner);
39 		emit OwnershipTransferred(owner, newOwner);
40 		owner = newOwner;
41 		newOwner = address(0);
42 	}
43 }
44 
45 // ----------------------------------------------------------------------------
46 // 核心类
47 // ----------------------------------------------------------------------------
48 contract Oasis is ERC20Interface, Owned {
49 	string public symbol;
50 	string public name;
51 	uint8 public decimals;
52 	uint _totalSupply;
53 	
54 	//address public owner;
55 	bool public actived;
56 	struct keyconf{
57 	    uint basekeynum;//4500
58     	uint basekeysub;//500
59     	uint usedkeynum;//0
60         uint startprice;//0.01
61         uint keyprice;//0.01
62         uint startbasekeynum;//4500
63         uint[] keyidarr;
64     	uint currentkeyid;
65 	}
66 	keyconf private keyconfig;
67 	uint[] public worksdata;
68 	
69 	uint public onceOuttime;
70 	uint8 public per;
71 	
72 	
73 	uint[] public mans;
74 	uint[] public pers;
75 	uint[] public prizeper;
76 	uint[] public prizelevelsuns;
77 	uint[] public prizelevelmans;
78 	uint[] public prizelevelsunsday;
79 	uint[] public prizelevelmoneyday;
80 	uint[] public prizeactivetime;
81 	
82 	address[] public mansdata;
83 	uint[] public moneydata;
84 	uint[] public timedata;
85 	uint public pubper;
86 	uint public subper;
87 	uint public luckyper;
88 	uint public lastmoney;
89 	uint public lastper;
90 	uint public lasttime;
91 	uint public sellkeyper;
92 	
93 	//bool public isend;
94 	uint public tags;
95 	//uint public opentime;
96 	
97 	uint public runper;
98 	uint public sellper;
99 	uint public sellupper;
100 	uint public sysday;
101 	uint public cksysday;
102 	//uint public nulldayeth;
103     mapping(uint => mapping(uint => uint)) allprize;
104 	//uint public allprizeused;
105 	mapping(address => uint) balances;
106 	
107 	mapping(address => mapping(address => uint)) allowed;
108 	mapping(address => bool) public frozenAccount;
109 	struct usercan{
110 	    uint eths;
111 	    uint used;
112 	    uint len;
113 	    uint[] times;
114 	    uint[] moneys;
115 	    uint[] amounts;
116 	}
117 	mapping(address => usercan) mycan;
118 	mapping(address => usercan) myrun;
119 	struct userdata{
120 	    uint systemtag;
121 	    uint tzs;
122 	    uint usereths;
123 	    uint userethsused;
124 	    uint mylevelid;
125 	    uint mykeysid;
126 	    uint mykeyeths;
127 	    uint prizecount;
128 	    address fromaddr;
129 	    uint sun1;
130 	    uint sun2;
131 	    uint sun3;
132 	    mapping(uint => uint) mysunsdaynum;
133 	    mapping(uint => uint) myprizedayget;
134 	    mapping(uint => uint) daysusereths;
135 	    mapping(uint => uint) daysuserdraws;
136 	    mapping(uint => uint) daysuserlucky;
137 	    mapping(uint => uint) levelget;
138 	    mapping(uint => bool) hascountprice;
139 	}
140 	mapping(address => userdata) my;
141 	uint[] public leveldata;
142 	mapping(uint => mapping(uint => uint)) public userlevelsnum;
143 
144 	//与用户钥匙id对应
145 	mapping(uint => address) public myidkeys;
146 	//all once day get all
147 	mapping(uint => uint) public daysgeteths;
148 	mapping(uint => uint) public dayseths;
149 	//user once day pay
150 	mapping(uint => uint) public daysysdraws;
151 	struct tagsdata{
152 	    uint ethnum;//用户总资产
153 	    uint sysethnum;//系统总eth
154 	    uint userethnum;//用户总eth
155 	    uint userethnumused;//用户总eth
156 	    uint syskeynum;//系统总key
157 	}
158 	mapping(uint => tagsdata) tg;
159 	mapping(address => bool) mangeruser;
160 	mapping(address => uint) mangerallowed;
161 	string private version;
162 	string private downurl;
163 	string private notices;
164 	uint public hasusednum;
165 	/* 通知 */
166 	event Transfer(address indexed from, address indexed to, uint tokens);
167 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
168 	event FrozenFunds(address target, bool frozen);
169 	event ethchange(address indexed from, address indexed to, uint tokens);
170 	modifier onlySystemStart() {
171         require(actived == true);
172 	    require(tags == my[msg.sender].systemtag);
173 	    require(!frozenAccount[msg.sender]);
174         _;
175     }
176 
177 	constructor() public {
178 		symbol = "OASIS";
179 		name = "Oasis";
180 		decimals = 18;
181 		_totalSupply = 50000000 ether;
182 	
183 		actived = true;
184 		tags = 0;
185 		tg[0] = tagsdata(0,0,0,0,0);
186 		
187         keyconfig.currentkeyid = 0;
188         keyconfig.keyidarr = [10055555,20055555,30055555,40055555,50055555,60055555,70055555,80055555,90055555];
189         worksdata = [0,0,0,0,0,0,0,0,0];   
190         runper = 10;
191 		mans = [2,4,6];
192 		pers = [50,30,20];
193 		prizeper = [2,2,2];
194 		prizeactivetime = [0,0,0];
195 		pubper = 2;
196 		subper = 120;
197 		luckyper = 5;
198 		lastmoney = 0;
199 		lastper = 2;
200 		sellkeyper = 70;
201 		sellper = 5;
202 		sellupper = 50;
203 		leveldata = [0,0,0];
204 
205         onceOuttime = 24 hours;
206         //onceOuttime = 10 seconds;
207         keyconfig.basekeynum = 4500 ether;//4500
208 	    keyconfig.basekeysub = 2000 ether;//500
209 	    keyconfig.usedkeynum = 0;//0
210         keyconfig.startprice = 0.01 ether;//
211         keyconfig.keyprice   = 0.01 ether;//
212         keyconfig.startbasekeynum = 4500 ether;//4500
213         per = 10;  
214         prizelevelsuns = [20,30,50];
215 		prizelevelmans = [100,300,800];
216 		prizelevelsunsday = [1,3,5];
217 		prizelevelmoneyday = [9 ether,29 ether,49 ether];
218 		lasttime = 8 hours;
219 		sysday = 1 days;
220 		cksysday = 8 hours;
221         version = '1.01';
222 		balances[this] = _totalSupply;
223 		emit Transfer(address(0), this, _totalSupply);
224 	}
225 
226 	function balanceOf(address tokenOwner) public view returns(uint balance) {
227 		return balances[tokenOwner];
228 	}
229 	
230 	function showlvzhou(address user) public view returns(
231 	    uint total,
232 	    uint mykeyid,
233 	    uint mytzs,
234 	    uint daysget,
235 	    uint prizeget,
236 	    uint mycans,
237 	    uint mykeynum,
238 	    uint keyprices,
239 	    uint ltkeynum,
240 	    uint tagss,
241 	    uint mytags
242 	    
243 	){
244 	    total = tg[tags].userethnum;//0
245 	    mykeyid = my[user].mykeysid;//1
246 	    mytzs = my[user].tzs;//2
247 	    daysget = my[user].usereths*per/1000;//3
248 	    prizeget = my[user].prizecount;//4
249 	    mycans = getcanuse(user);//5
250 	    mykeynum = balanceOf(user);//6
251 	    keyprices = getbuyprice();//7
252 	    ltkeynum = leftnum();//8
253 	    tagss = tagss;//9
254 	    mytags = my[user].systemtag;//10
255 	}
256 	function showteam(address user) public view returns(
257 	    uint daysnum,//0
258 	    uint dayseth,//1
259 	    uint daysnum1,//2
260 	    uint dayseth1,//3
261 	    uint man1,//4
262 	    uint man2,//5
263 	    uint man3,//6
264 	    uint myruns,//7
265 	    uint canruns,//8
266 	    uint levelid//9
267 	){
268 	    uint d = gettoday();
269 	    uint t = getyestoday();
270 	    daysnum = my[user].mysunsdaynum[d];//5
271 	    dayseth = my[user].myprizedayget[d];//6
272 	    daysnum1 = my[user].mysunsdaynum[t];//5
273 	    dayseth1 = my[user].myprizedayget[t];//6
274 	    man1 = my[user].sun1;//2
275 	    man2 = my[user].sun2;//3
276 	    man3 = my[user].sun3;//4
277 	    myruns = myrun[user].eths;//6
278 	    canruns = getcanuserun(user);//7
279 	    levelid = my[user].mylevelid;//8
280 	}
281 	function showlevel(address user) public view returns(
282 	    uint myget,//0
283 	    uint levelid,//1
284 	    uint len1,//2
285 	    uint len2,//3
286 	    uint len3,//4
287 	    uint m1,//5
288 	    uint m2,//6
289 	    uint m3,//7
290 	    uint t1,//8
291 	    uint t2,//9
292 	    uint t3,//10
293 	    uint levelget//11
294 	){
295 	    (levelid, myget) = getprizemoney(user);
296 	    //len2 = leveldata[1];
297 	    //len3 = leveldata[2];
298 	    m1 = allprize[0][0] - allprize[0][1];//5
299 	    m2 = allprize[1][0] - allprize[1][1];//6
300 	    m3 = allprize[2][0] - allprize[2][1];//7
301 	    t1 = prizeactivetime[0];//8
302 	    uint d = getyestoday();
303 	    if(t1 > 0) {
304 	        if(t1 + sysday > now){
305     	        len1 = leveldata[0];
306     	    }else{
307     	        len1 = userlevelsnum[1][d];
308 	        }
309 	    }
310 	    
311 	    t2 = prizeactivetime[1];//9
312 	    if(t2 > 0) {
313 	        if(t2 + sysday > now){
314     	        len2 = leveldata[1];
315     	    }else{
316     	        len2 = userlevelsnum[2][d];
317     	    }
318 	    }
319 	    
320 	    t3 = prizeactivetime[2];//10
321 	    if(t3 > 0) {
322 	        if(t3 + sysday > now){
323     	        len3 = leveldata[2];
324     	    }else{
325     	        len3 = userlevelsnum[3][d];
326     	    }
327 	    }
328 	    
329 	    levelget = my[user].levelget[d];//11
330 	}
331 	
332 	
333 	function showethconf(address user) public view returns(
334 	    uint todaymyeth,
335 	    uint todaymydraw,
336 	    uint todaysyseth,
337 	    uint todaysysdraw,
338 	    uint yestodaymyeth,
339 	    uint yestodaymydraw,
340 	    uint yestodaysyseth,
341 	    uint yestodaysysdraw
342 	){
343 	    uint d = gettoday();
344 		uint t = getyestoday();
345 		todaymyeth = my[user].daysusereths[d];
346 		todaymydraw = my[user].daysuserdraws[d];
347 		todaysyseth = dayseths[d];
348 		todaysysdraw = daysysdraws[d];
349 		yestodaymyeth = my[user].daysusereths[t];
350 		yestodaymydraw = my[user].daysuserdraws[t];
351 		yestodaysyseth = dayseths[t];
352 		yestodaysysdraw = daysysdraws[t];
353 		
354 	}
355 	function showprize(address user) public view returns(
356 	    uint lttime,//0
357 	    uint ltmoney,//1
358 	    address ltaddr,//2
359 	    uint lastmoneys,//3
360 	    address lastuser,//4
361 	    uint luckymoney,//5
362 	    address luckyuser,//6
363 	    uint luckyget//7
364 	){
365 	    if(timedata.length > 0) {
366 	       lttime = timedata[timedata.length - 1];//1 
367 	    }else{
368 	        lttime = 0;
369 	    }
370 	    if(moneydata.length > 0) {
371 	       ltmoney = moneydata[moneydata.length - 1];//2 
372 	    }else{
373 	        ltmoney = 0;
374 	    }
375 	    if(mansdata.length > 0) {
376 	        ltaddr = mansdata[mansdata.length - 1];//3
377 	    }else{
378 	        ltaddr = address(0);
379 	    }
380 	    lastmoneys = lastmoney;
381 	    lastuser = getlastuser();
382 	    uint d = getyestoday();
383 	    if(dayseths[d] > 0) {
384 	        luckymoney = dayseths[d]*luckyper/1000;
385 	        luckyuser = getluckyuser();
386 	        luckyget = my[user].daysuserlucky[d];
387 	    }
388 	    
389 	}
390 	function interuser(address user) public view returns(
391 	    uint skeyid,
392 	    uint stzs,
393 	    uint seths,
394 	    uint sethcan,
395 	    uint sruns,
396 	    uint srunscan,
397 	    uint skeynum
398 	    
399 	){
400 	    skeyid = my[user].mykeysid;
401 	    stzs = my[user].tzs;
402 	    seths = mycan[user].eths;
403 	    sethcan = getcanuse(user);
404 	    sruns = myrun[user].eths;
405 	    srunscan = getcanuserun(user);
406 	    skeynum = balances[user];
407 	}
408 	function showworker() public view returns(
409 	    uint w0,
410 	    uint w1,
411 	    uint w2,
412 	    uint w3,
413 	    uint w4,
414 	    uint w5,
415 	    uint w6,
416 	    uint w7,
417 	    uint w8
418 	){
419 	    w0 = worksdata[0];
420 	    w1 = worksdata[1];
421 	    w2 = worksdata[2];
422 	    w3 = worksdata[3];
423 	    w4 = worksdata[4];
424 	    w5 = worksdata[5];
425 	    w6 = worksdata[6];
426 	    w7 = worksdata[7];
427 	    w8 = worksdata[8];
428 	}
429 	
430 	function addmoney(address _addr, uint256 _amount, uint256 _money, uint _day) private returns(bool){
431 		mycan[_addr].eths += _money;
432 		mycan[_addr].len++;
433 		mycan[_addr].amounts.push(_amount);
434 		mycan[_addr].moneys.push(_money);
435 		if(_day > 0){
436 		    mycan[_addr].times.push(0);
437 		}else{
438 		    mycan[_addr].times.push(now);
439 		}
440 		
441 	}
442 	function reducemoney(address _addr, uint256 _money) private returns(bool){
443 	    if(mycan[_addr].eths >= _money && my[_addr].tzs >= _money) {
444 	        mycan[_addr].used += _money;
445     		mycan[_addr].eths -= _money;
446     		my[_addr].tzs -= _money;
447     		return(true);
448 	    }else{
449 	        return(false);
450 	    }
451 		
452 	}
453 	function addrunmoney(address _addr, uint256 _amount, uint256 _money, uint _day) private {
454 		myrun[_addr].eths += _money;
455 		myrun[_addr].len++;
456 		myrun[_addr].amounts.push(_amount);
457 		myrun[_addr].moneys.push(_money);
458 		if(_day > 0){
459 		    myrun[_addr].times.push(0);
460 		}else{
461 		    myrun[_addr].times.push(now);
462 		}
463 	}
464 	function reducerunmoney(address _addr, uint256 _money) private {
465 		myrun[_addr].eths -= _money;
466 		myrun[_addr].used += _money;
467 	}
468 
469 	function getcanuse(address user) public view returns(uint _left) {
470 		if(mycan[user].len > 0) {
471 		    for(uint i = 0; i < mycan[user].len; i++) {
472     			uint stime = mycan[user].times[i];
473     			if(stime == 0) {
474     			    _left += mycan[user].moneys[i];
475     			}else{
476     			    if(now - stime >= onceOuttime) {
477     			        uint smoney = mycan[user].amounts[i] * ((now - stime)/onceOuttime) * per/ 1000;
478     			        if(smoney <= mycan[user].moneys[i]){
479     			            _left += smoney;
480     			        }else{
481     			            _left += mycan[user].moneys[i];
482     			        }
483     			    }
484     			    
485     			}
486     		}
487 		}
488 		if(_left < mycan[user].used) {
489 			return(0);
490 		}
491 		if(_left > mycan[user].eths) {
492 			return(mycan[user].eths);
493 		}
494 		return(_left - mycan[user].used);
495 		
496 	}
497 	function getcanuserun(address user) public view returns(uint _left) {
498 		if(myrun[user].len > 0) {
499 		    for(uint i = 0; i < myrun[user].len; i++) {
500     			uint stime = myrun[user].times[i];
501     			if(stime == 0) {
502     			    _left += myrun[user].moneys[i];
503     			}else{
504     			    if(now - stime >= onceOuttime) {
505     			        uint smoney = myrun[user].amounts[i] * ((now - stime)/onceOuttime) * per/ 1000;
506     			        if(smoney <= myrun[user].moneys[i]){
507     			            _left += smoney;
508     			        }else{
509     			            _left += myrun[user].moneys[i];
510     			        }
511     			    }
512     			}
513     		}
514 		}
515 		if(_left < myrun[user].used) {
516 			return(0);
517 		}
518 		if(_left > myrun[user].eths) {
519 			return(myrun[user].eths);
520 		}
521 		return(_left - myrun[user].used);
522 	}
523 
524 	function _transfer(address from, address to, uint tokens) private{
525 		require(!frozenAccount[from]);
526 		require(!frozenAccount[to]);
527 		require(actived == true);
528 		require(from != to);
529         require(to != 0x0);
530         require(balances[from] >= tokens);
531         require(balances[to] + tokens > balances[to]);
532         uint previousBalances = balances[from] + balances[to];
533         balances[from] -= tokens;
534         balances[to] += tokens;
535         assert(balances[from] + balances[to] == previousBalances);
536         
537 		emit Transfer(from, to, tokens);
538 	}
539     function transfer(address _to, uint256 _value) public returns(bool){
540         _transfer(msg.sender, _to, _value);
541         return(true);
542     }
543     function activekey() public returns(bool) {
544         require(actived == true);
545 	    address addr = msg.sender;
546         uint keyval = 1 ether;
547         require(balances[addr] > keyval);
548         require(my[addr].mykeysid < 1);
549         address top = my[addr].fromaddr;
550         uint topkeyids = keyconfig.currentkeyid;
551         if(top != address(0) && my[top].mykeysid > 0) {
552             topkeyids = my[top].mykeysid/10000000 - 1;
553         }else{
554             keyconfig.currentkeyid++;
555             if(keyconfig.currentkeyid > 8){
556                 keyconfig.currentkeyid = 0;
557             }
558         }
559         keyconfig.keyidarr[topkeyids]++;
560         uint kid = keyconfig.keyidarr[topkeyids];
561         require(myidkeys[kid] == address(0));
562         my[addr].mykeysid = kid;
563 	    myidkeys[kid] = addr;
564 	    balances[addr] -= keyval;
565 	    balances[owner] += keyval;
566 	    emit Transfer(addr, owner, keyval);
567 	    return(true);
568 	    
569     }
570     
571 	function getfrom(address _addr) public view returns(address) {
572 		return(my[_addr].fromaddr);
573 	}
574     function gettopid(address addr) public view returns(uint) {
575         address topaddr = my[addr].fromaddr;
576         if(topaddr == address(0)) {
577             return(0);
578         }
579         uint keyid = my[topaddr].mykeysid;
580         if(keyid > 0 && myidkeys[keyid] == topaddr) {
581             return(keyid);
582         }else{
583             return(0);
584         }
585     }
586     
587 	function approve(address spender, uint tokens) public returns(bool success) {
588 	    require(actived == true);
589 		allowed[msg.sender][spender] = tokens;
590 		emit Approval(msg.sender, spender, tokens);
591 		return true;
592 	}
593 
594 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
595 		require(actived == true);
596 		require(!frozenAccount[from]);
597 		require(!frozenAccount[to]);
598 		balances[from] -= tokens;
599 		allowed[from][msg.sender] -= tokens;
600 		balances[to] += tokens;
601 		emit Transfer(from, to, tokens);
602 		return true;
603 	}
604 
605 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
606 		return allowed[tokenOwner][spender];
607 	}
608 
609 	function setactive(bool t) public onlyOwner{
610 		actived = t;
611 	}
612 	
613 	function getyestoday() public view returns(uint d) {
614 	    uint today = gettoday();
615 	    d = today - sysday;
616 	}
617 	
618 	function gettoday() public view returns(uint d) {
619 	    uint n = now;
620 	    d = n - n%sysday - cksysday;
621 	}
622 	function totalSupply() public view returns(uint) {
623 		return(_totalSupply - balances[this]);
624 	}
625 
626 	function getbuyprice() public view returns(uint kp) {
627         if(keyconfig.usedkeynum == keyconfig.basekeynum) {
628             kp = keyconfig.keyprice + keyconfig.startprice;
629         }else{
630             kp = keyconfig.keyprice;
631         }
632 	    
633 	}
634 	function leftnum() public view returns(uint num) {
635 	    if(keyconfig.usedkeynum == keyconfig.basekeynum) {
636 	        num = keyconfig.basekeynum + keyconfig.basekeysub;
637 	    }else{
638 	        num = keyconfig.basekeynum - keyconfig.usedkeynum;
639 	    }
640 	}
641 	
642 	function getlevel(address addr) public view returns(uint) {
643 	    uint nums = my[addr].sun1 + my[addr].sun2 + my[addr].sun3;
644 	    if(my[addr].sun1 >= prizelevelsuns[2] && nums >= prizelevelmans[2]) {
645 	        return(3);
646 	    }
647 	    if(my[addr].sun1 >= prizelevelsuns[1] && nums >= prizelevelmans[1]) {
648 	        return(2);
649 	    }
650 	    if(my[addr].sun1 >= prizelevelsuns[0] && nums >= prizelevelmans[0]) {
651 	        return(1);
652 	    }
653 	    return(0);
654 	}
655 	
656 	function gettruelevel(address user, uint d) public view returns(uint) {
657 	    //uint d = getyestoday();
658 	    uint money = my[user].myprizedayget[d];
659 	    uint mymans = my[user].mysunsdaynum[d];
660 	    if(mymans >= prizelevelsunsday[2] && money >= prizelevelmoneyday[2]) {
661 	        if(my[user].mylevelid < 3){
662 	            return(my[user].mylevelid);
663 	        }else{
664 	           return(3); 
665 	        }
666 	        
667 	    }
668 	    if(mymans >= prizelevelsunsday[1] && money >= prizelevelmoneyday[1]) {
669 	        if(my[user].mylevelid < 2){
670 	            return(my[user].mylevelid);
671 	        }else{
672 	           return(2); 
673 	        }
674 	    }
675 	    if(mymans >= prizelevelsunsday[0] && money >= prizelevelmoneyday[0]) {
676 	        if(my[user].mylevelid < 1){
677 	            return(0);
678 	        }else{
679 	           return(1); 
680 	        }
681 	    }
682 	    return(0);
683 	    
684 	}
685 	function setlevel(address user) private returns(bool) {
686 	    uint lid = getlevel(user);
687 	    uint uid = my[user].mylevelid;
688 	    uint d = gettoday();
689 	    if(uid < lid) {
690 	        //if(uid > 0) {
691 	        //    leveldata[uid - 1]--;
692 	        //}
693 	        my[user].mylevelid = lid;
694 	        uint p = lid - 1;
695 	        //leveldata[p]++;
696 	        if(prizeactivetime[p] < 1) {
697 	            prizeactivetime[p] = d + sysday*2;
698 	        }
699 	        if(now < prizeactivetime[p]) {
700 	            leveldata[p]++;
701 	        }
702 	    }
703 	    if(lid > 0) {
704 	        uint tid = gettruelevel(user, d);
705     	    if(tid > 0 && prizeactivetime[tid - 1] > 0 && !my[user].hascountprice[d]) {
706     	         userlevelsnum[tid][d]++; 
707     	         my[user].hascountprice[d] = true;
708     	     }
709 	    }
710 	}
711 	function getprizemoney(address user) public view returns(uint lid, uint ps) {
712 	    lid = my[user].mylevelid;
713 	    if(lid > 0) {
714 	        uint p = lid - 1;
715 	        uint activedtime = prizeactivetime[p];
716 	        if(activedtime > 0 && activedtime < now) {
717 	            if(now  > activedtime  + sysday){
718 	                uint d = getyestoday();
719 	                uint ld = gettruelevel(user, d);
720 	                if(ld > 0) {
721 	                   uint pp = ld - 1;
722 	                   if(allprize[pp][0] > allprize[pp][1] && userlevelsnum[ld][d] > 0) {
723 	                       ps = (allprize[pp][0] - allprize[pp][1])/userlevelsnum[ld][d];
724 	                   }
725 	                }
726 	                return(ld, ps);
727 	            }else{
728 	                //uint d = activedtime - sysday;
729 	                
730 	                if(allprize[p][0] > allprize[p][1]){
731 	                    uint dd = gettoday();
732 	                    if(!my[user].hascountprice[dd]){
733 	                        ps = (allprize[p][0] - allprize[p][1])/leveldata[p];
734 	                    }
735 	                    
736 	                }
737 	            }
738 	            
739 	        }
740 	    }
741 	    return(lid, ps);
742 	}
743 	function getprize() onlySystemStart() public returns(bool) {
744 	    address user = msg.sender;
745 	    if(my[user].mylevelid > 0) {
746 	        (uint lid, uint ps) = getprizemoney(user);
747 	        if(lid > 0 && ps > 0) {
748 	            uint d = getyestoday();
749 	            require(my[user].levelget[d] == 0);
750         	    my[user].levelget[d] += ps;
751         	    allprize[lid - 1][1] += ps;
752         	    addrunmoney(user, ps, ps, 100);
753         	    
754 	        }
755 	    }
756 	}
757 	
758 	
759 	function getfromsun(address addr, uint money, uint amount) private returns(bool){
760 	    address f1 = my[addr].fromaddr;
761 	    uint d = gettoday();
762 	    if(f1 != address(0) && f1 != addr) {
763 	        if(my[f1].sun1 >= mans[0]){
764 	            addrunmoney(f1, (amount*pers[0])/100, (money*pers[0])/100, 0);
765 	        }
766 	    	my[f1].myprizedayget[d] += amount;
767 	    	if(my[f1].mykeysid > 10000000) {
768 	    	    worksdata[((my[f1].mykeysid/10000000) - 1)] += amount;
769 	    	}
770 	    	setlevel(f1);
771 	    	address f2 = my[f1].fromaddr;
772 	    	if(f2 != address(0) && f2 != addr) {
773     	        if(my[f2].sun1 >= mans[1]){
774     	           addrunmoney(f2, (amount*pers[1])/100, (money*pers[1])/100, 0); 
775     	        }
776     	    	my[f2].myprizedayget[d] += amount;
777     	    	setlevel(f2);
778     	    	address f3 = my[f2].fromaddr;
779     	    	if(f3 != address(0) && f3 != addr) {
780         	        if(my[f3].sun1 >= mans[2]){
781         	            addrunmoney(f3, (amount*pers[2])/100, (money*pers[2])/100, 0);
782         	        }
783         	    	my[f3].myprizedayget[d] += amount;
784         	    	setlevel(f3);
785         	    }
786     	    }	
787 	    }
788 	    
789 	}
790 	function setpubprize(uint sendmoney) private returns(bool) {
791 	    uint len = moneydata.length;
792 	    if(len > 0) {
793 	        uint all = 0;
794 	        uint start = 0;
795 	        uint m = 0;
796 	        if(len > 10) {
797 	            start = len - 10;
798 	        }
799 	        for(uint i = start; i < len; i++) {
800 	            all += moneydata[i];
801 	        }
802 	        //uint sendmoney = amount*pubper/100;
803 	        for(; start < len; start++) {
804 	            m = (sendmoney*moneydata[start])/all;
805 	            addmoney(mansdata[start],m, m, 100);
806 	            my[mansdata[start]].prizecount += m;
807 	        }
808 	    }
809 	    return(true);
810 	}
811 	function getluckyuser() public view returns(address addr) {
812 	    if(moneydata.length > 0){
813 	        uint d = gettoday();
814     	    uint t = getyestoday();
815     	    uint maxmoney = 1 ether;
816     	    for(uint i = 0; i < moneydata.length; i++) {
817     	        if(timedata[i] > t && timedata[i] < d && moneydata[i] >= maxmoney) {
818     	            maxmoney = moneydata[i];
819     	            addr = mansdata[i];
820     	        }
821     	    }
822 	    }
823 	    
824 	}
825 	function getluckyprize() onlySystemStart() public returns(bool) {
826 	    address user = msg.sender;
827 	    require(user != address(0));
828 	    require(user == getluckyuser());
829 	    uint d = getyestoday();
830 	    require(my[user].daysusereths[d] > 0);
831 	    require(my[user].daysuserlucky[d] == 0);
832 	    uint money = dayseths[d]*luckyper/1000;
833 	    addmoney(user, money,money, 100);
834 	    my[user].daysuserlucky[d] += money;
835 	    my[user].prizecount += money;
836 	    uint t = getyestoday() - sysday;
837 	    for(uint i = 0; i < moneydata.length; i++) {
838     	    if(timedata[i] < t) {
839     	        delete moneydata[i];
840     	        delete timedata[i];
841     	        delete mansdata[i];
842     	    }
843     	}
844 	}
845 	
846 	function runtoeth(uint amount) onlySystemStart() public returns(bool) {
847 	    address user = msg.sender;
848 	    uint usekey = (amount*runper*1 ether)/(100*keyconfig.keyprice);
849 	    require(usekey < balances[user]);
850 	    require(getcanuserun(user) >= amount);
851 	    //require(transfer(owner, usekey) == true);
852 	    balances[user] -= usekey;
853 		balances[owner] += usekey;
854 		emit Transfer(user, owner, usekey);
855 		
856 	    reducerunmoney(user, amount);
857 	    addmoney(user, amount, amount, 100);
858 	    
859 	    
860 	}
861 	function getlastuser() public view returns(address user) {
862 	    if(timedata.length > 0) {
863     	    if(lastmoney > 0 && now - timedata[timedata.length - 1] > lasttime) {
864     	        user = mansdata[mansdata.length - 1];
865     	    }
866 	    } 
867 	}
868 	function getlastmoney() public returns(bool) {
869 	    require(actived == true);
870 	    address user = getlastuser();
871 	    require(user != address(0));
872 	    require(user == msg.sender);
873 	    require(lastmoney > 0);
874 	    require(lastmoney <= address(this).balance/2);
875 	    user.transfer(lastmoney);
876 	    lastmoney = 0;
877 	}
878 	
879 	function buy(uint keyid) onlySystemStart() public payable returns(bool) {
880 		address user = msg.sender;
881 		require(msg.value > 0);
882         uint amount = msg.value;
883 		require(amount >= 1 ether);
884 		require(amount%(1 ether) == 0);
885 		require(my[user].usereths <= 100 ether);
886 		uint money = amount*3;
887 		uint d = gettoday();
888 		uint t = getyestoday();
889 		bool ifadd = false;
890 		//if has no top
891 		if(my[user].fromaddr == address(0)) {
892 		    address topaddr = myidkeys[keyid];
893 		    if(keyid > 0 && topaddr != address(0) && topaddr != user) {
894 		        my[user].fromaddr = topaddr;
895     		    my[topaddr].sun1++;
896     		    my[topaddr].mysunsdaynum[d]++;
897     		    address top2 = my[topaddr].fromaddr;
898     		    if(top2 != address(0) && top2 != user){
899     		        my[top2].sun2++;
900     		        //my[top2].mysunsdaynum[d]++;
901     		    }
902     		    address top3 = my[top2].fromaddr;
903     		    if(top3 != address(0) && top3 != user){
904     		        my[top3].sun3++;
905     		        //my[top3].mysunsdaynum[d]++;
906     		    }
907     		    ifadd = true;
908 		    }
909 		}else{
910 		    ifadd = true;
911 		}
912 		if(ifadd == true) {
913 		    money = amount*4;
914 		}
915 		
916 		if(daysgeteths[t] > 0 && daysgeteths[d] > (daysgeteths[t]*subper)/100) {
917 		    if(ifadd == true) {
918     		    money = amount*3;
919     		}else{
920     		    money = amount*2;
921     		}
922 		}
923 		if(ifadd == true) {
924 		    getfromsun(user, money, amount);
925 		}
926 		setpubprize(amount*pubper/100);
927 		mansdata.push(user);
928 		moneydata.push(amount);
929 		timedata.push(now);
930 		
931 	    daysgeteths[d] += money;
932 	    dayseths[d] += amount;
933 	    tg[tags].sysethnum += amount;
934 		tg[tags].userethnum += amount;
935 		my[user].daysusereths[d] += amount;
936 		
937 		my[user].tzs += money;
938 		lastmoney += amount*lastper/100;
939 		tg[tags].ethnum += money;
940 		my[user].usereths += amount;
941 		allprize[0][0] += amount*prizeper[0]/100;
942 		allprize[1][0] += amount*prizeper[1]/100;
943 		allprize[2][0] += amount*prizeper[2]/100;
944 		addmoney(user, amount, money, 0);
945 		return(true);
946 	}
947 	
948 	function keybuy(uint m) onlySystemStart() public returns(bool) {
949 	    address user = msg.sender;
950 	    require(m >= 1 ether);
951 	    require(balances[user] >= m);
952 	    uint amount = (m*keyconfig.keyprice)/(1 ether);
953 	    require(amount >= 1 ether);
954 	    require(amount%(1 ether) == 0);
955 	    uint money = amount*3;
956 	    
957 		uint d = gettoday();
958 		uint t = getyestoday();
959 		if(my[user].fromaddr != address(0)) {
960 		    money = amount*4;
961 		}
962 		
963 		if(daysgeteths[t] > 0 && daysgeteths[d] > daysgeteths[t]*subper/100) {
964 		    if(my[user].fromaddr == address(0)) {
965     		    money = amount*2;
966     		}else{
967     		    money = amount*3;
968     		}
969 		}
970 		tg[tags].ethnum += money;
971 		my[user].tzs += money;
972 		addmoney(user, amount, money, 0);
973 		balances[user] -= m;
974 	    balances[owner] += m;
975 		emit Transfer(user, owner, m);
976 	    return(true);
977 	}
978 	function ethbuy(uint amount) onlySystemStart() public returns(bool) {
979 	    address user = msg.sender;
980 	    uint canmoney = getcanuse(user);
981 	    require(canmoney >= amount);
982 	    require(amount >= 1 ether);
983 	    require(amount%(1 ether) == 0);
984 	    require(mycan[user].eths >= amount);
985 	    require(my[user].tzs >= amount);
986 	    uint money = amount*3;
987 		uint d = gettoday();
988 		uint t = getyestoday();
989 		if(my[user].fromaddr == address(0)) {
990 		    money = amount*2;
991 		}
992 		
993 		if(daysgeteths[t] > 0 && daysgeteths[d] > daysgeteths[t]*subper/100) {
994 		    if(my[user].fromaddr == address(0)) {
995     		    money = amount;
996     		}else{
997     		    money = amount*2;
998     		}
999 		}
1000 		addmoney(user, amount, money, 0);
1001 		my[user].tzs += money;
1002 		mycan[user].used += money;
1003 	    tg[tags].ethnum += money;
1004 	    
1005 	    return(true);
1006 	}
1007 	
1008 	function charge() public payable returns(bool) {
1009 		return(true);
1010 	}
1011 	
1012 	function() payable public {
1013 		buy(0);
1014 	}
1015 	
1016 	function sell(uint256 amount) onlySystemStart() public returns(bool success) {
1017 		address user = msg.sender;
1018 		uint d = gettoday();
1019 		uint t = getyestoday();
1020 		uint256 canuse = getcanuse(user);
1021 		require(canuse >= amount);
1022 		require(address(this).balance > amount);
1023 		uint p = sellper;
1024 		if((daysysdraws[d] + amount) > ((dayseths[d] + dayseths[t])*subper/100)){
1025 		    p = sellupper;
1026 		}
1027 		uint useper = (amount*p*(1 ether))/(keyconfig.keyprice*100);
1028 		/*
1029 		if(dayseths[t] > dayseths[d]){
1030 		    if((daysysdraws[d] + amount) > (dayseths[t]*subper/100)){
1031 		        p = sellupper;
1032 		    }
1033 		}else{
1034 		    if(dayseths[d] > 0 && (daysysdraws[d] + amount) > (dayseths[d]*subper/100)){
1035 		        p = sellupper;
1036 		    }
1037 		}*/
1038 		
1039 		
1040 		require(balances[user] >= useper);
1041 		require(reducemoney(user, amount) == true);
1042 		
1043 		my[user].userethsused += amount;
1044 		tg[tags].userethnumused += amount;
1045 		my[user].daysuserdraws[d] += amount;
1046 		daysysdraws[d] += amount;
1047 		//_transfer(user, owner, useper);
1048 		balances[user] -= useper;
1049 	    balances[owner] += useper;
1050 		emit Transfer(user, owner, useper);
1051 		user.transfer(amount);
1052 		
1053 		setend();
1054 		return(true);
1055 	}
1056 	
1057 	function sellkey(uint256 amount) onlySystemStart() public returns(bool) {
1058 	    address user = msg.sender;
1059 		require(balances[user] >= amount);
1060 		
1061 		uint d = gettoday();
1062 		uint t = getyestoday();
1063 		
1064 		require(dayseths[t] > 0);
1065 		
1066 		uint money = (keyconfig.keyprice*amount*sellkeyper)/(100 ether);
1067 		if((daysysdraws[d] + money) > dayseths[t]*2){
1068 		    money = (keyconfig.keyprice*amount)/(2 ether);
1069 		}
1070 		require(address(this).balance > money);
1071 		//require(tg[tags].userethnumused + money <= tg[tags].userethnum/2);
1072 		my[user].userethsused += money;
1073         tg[tags].userethnumused += money;
1074         daysysdraws[d] += money;
1075     	//_transfer(user, owner, amount);
1076     	balances[user] -= amount;
1077 	    balances[owner] += amount;
1078 		emit Transfer(user, owner, amount);
1079 		
1080     	user.transfer(money);
1081     	setend();
1082 	}
1083 
1084 	
1085 	function buykey(uint buynum) onlySystemStart() public payable returns(bool){
1086 	    uint money = msg.value;
1087 	    address user = msg.sender;
1088 	    require(buynum >= 1 ether);
1089 	    require(buynum%(1 ether) == 0);
1090 	    require(keyconfig.usedkeynum + buynum <= keyconfig.basekeynum);
1091 	    require(money >= keyconfig.keyprice);
1092 	    require(user.balance >= money);
1093 	    require(mycan[user].eths > 0);
1094 	    require(((keyconfig.keyprice*buynum)/1 ether) == money);
1095 	    
1096 	    my[user].mykeyeths += money;
1097 	    tg[tags].sysethnum += money;
1098 	    tg[tags].syskeynum += buynum;
1099 		if(keyconfig.usedkeynum + buynum == keyconfig.basekeynum) {
1100 		    keyconfig.basekeynum = keyconfig.basekeynum + keyconfig.basekeysub;
1101 	        keyconfig.usedkeynum = 0;
1102 	        keyconfig.keyprice = keyconfig.keyprice + keyconfig.startprice;
1103 	    }else{
1104 	        keyconfig.usedkeynum += buynum;
1105 	    }
1106 	    _transfer(this, user, buynum);
1107 	}
1108 	
1109 	function setend() private returns(bool) {
1110 	    if(tg[tags].userethnum > 0 && tg[tags].userethnumused > tg[tags].userethnum/2) {
1111 	        tags++;
1112 	        keyconfig.keyprice = keyconfig.startprice;
1113 	        keyconfig.basekeynum = keyconfig.startbasekeynum;
1114 	        keyconfig.usedkeynum = 0;
1115 	        
1116 	        prizeactivetime = [0,0,0];
1117 	        leveldata = [0,0,0];
1118 	        return(true);
1119 	    }
1120 	}
1121 	function ended(bool ifget) public returns(bool) {
1122 	    require(actived == true);
1123 	    address user = msg.sender;
1124 	    require(my[user].systemtag < tags);
1125 	    require(!frozenAccount[user]);
1126 	    if(ifget == true) {
1127     	    my[user].prizecount = 0;
1128     	    my[user].tzs = 0;
1129     	    my[user].prizecount = 0;
1130     		mycan[user].eths = 0;
1131     	    mycan[user].used = 0;
1132     	    if(mycan[user].len > 0) {
1133     	        delete mycan[user].times;
1134     	        delete mycan[user].amounts;
1135     	        delete mycan[user].moneys;
1136     	    }
1137     	    mycan[user].len = 0;
1138     	    
1139     		myrun[user].eths = 0;
1140     	    myrun[user].used = 0;
1141     	    if(myrun[user].len > 0) {
1142     	        delete myrun[user].times;
1143     	        delete myrun[user].amounts;
1144     	        delete myrun[user].moneys;
1145     	    }
1146     	    myrun[user].len = 0;
1147     	    if(my[user].usereths/2 > my[user].userethsused) {
1148     	        uint money = my[user].usereths/2 - my[user].userethsused;
1149 	            require(address(this).balance > money);
1150     	        user.transfer(money);
1151     	    }
1152     	    my[user].usereths = 0;
1153     	    my[user].userethsused = 0;
1154     	    
1155 	    }else{
1156 	        uint amount = my[user].usereths - my[user].userethsused;
1157 	        tg[tags].ethnum += my[user].tzs;
1158 	        tg[tags].sysethnum += amount;
1159 		    tg[tags].userethnum += amount;
1160 	    }
1161 	    my[user].systemtag = tags;
1162 	}
1163 	
1164 	function setmangeruser(address user, bool t) public onlyOwner{
1165 	    mangeruser[user] = t;
1166 	}
1167 	function freezeAccount(address target, bool freeze) public{
1168 	    require(actived == true);
1169 	    require(mangeruser[msg.sender] == true);
1170 		frozenAccount[target] = freeze;
1171 		emit FrozenFunds(target, freeze);
1172 	}
1173 	function setmangerallow(address user, uint m) public {
1174 	    require(actived == true);
1175 	    require(mangeruser[msg.sender] == true);
1176 	    require(mangeruser[user] == true);
1177 	    require(user != address(0));
1178 	    require(user != msg.sender);
1179 	    //require(mangerallowed[user] == 0);
1180 	    mangerallowed[user] = m;
1181 	}
1182 	
1183 	function transto(address _to, uint money) public {
1184 	    require(actived == true);
1185 	    require(_to != 0x0);
1186 	    address user = msg.sender;
1187 	    require(mangeruser[user] == true);
1188     	require(mangerallowed[user] == money);
1189     	require(money > 1);
1190     	if(hasusednum > 0) {
1191     	    require((hasusednum + money) <= (10000000 ether));
1192     	}
1193     	balances[_to] += money;
1194 	    hasusednum += money;
1195 	    mangerallowed[user] -= money - 1;
1196 		emit Transfer(user, _to, money);
1197 	}
1198     function setper(uint onceOuttimes,uint8 perss,uint runpers,uint pubpers,uint subpers,uint luckypers,uint lastpers,uint sellkeypers,uint sellpers,uint selluppers,uint lasttimes,uint sysdays,uint sellupperss) public onlyOwner{
1199 	    onceOuttime = onceOuttimes;
1200 	    per = perss;
1201 	    runper = runpers;
1202 	    pubper = pubpers;
1203 	    subper = subpers;
1204 	    luckyper = luckypers;
1205 	    lastper = lastpers;
1206 	    sellkeyper = sellkeypers;
1207 	    sellper = sellpers;
1208 	    sellupper = selluppers;
1209 	    lasttime = lasttimes;//9
1210 	    sysday = sysdays;
1211 	    sellupper = sellupperss;
1212 	}
1213 	function setnotice(
1214 	    string versions,
1215 	    string downurls,
1216 	    string noticess
1217 	) public returns(bool){
1218 	    require(actived == true);
1219 	    require(mangeruser[msg.sender] == true);
1220 	    version = versions;
1221 	    downurl = downurls;
1222 	    notices = noticess;
1223 	}
1224 	function getnotice() public view returns(
1225 	    string versions,
1226 	    string downurls,
1227 	    string noticess,
1228 	    bool isadm
1229 	){
1230 	    versions = version;
1231 	    downurls = downurl;
1232 	    noticess = notices;
1233 	    isadm = mangeruser[msg.sender];
1234 	}
1235 	
1236 }