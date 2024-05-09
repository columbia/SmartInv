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
73 	//uint[] public mans;
74 	uint[] public mms;
75 	uint[] public pers;
76 	uint[] public prizeper;
77 	uint[] public prizelevelsuns;
78 	uint[] public prizelevelmans;
79 	uint[] public prizelevelsunsday;
80 	uint[] public prizelevelmoneyday;
81 	uint[] public prizeactivetime;
82 	
83 	address[] public mansdata;
84 	uint[] public moneydata;
85 	uint[] public timedata;
86 	uint public pubper;
87 	uint public subper;
88 	uint public luckyper;
89 	uint public lastmoney;
90 	uint public lastper;
91 	uint public lasttime;
92 	uint public sellkeyper;
93 	
94 	//bool public isend;
95 	uint public tags;
96 	//uint public opentime;
97 	
98 	uint public runper;
99 	uint public sellper;
100 	uint public sellupper;
101 	uint public sysday;
102 	uint public cksysday;
103 	//uint public nulldayeth;
104     mapping(uint => mapping(uint => uint)) allprize;
105 	//uint public allprizeused;
106 	mapping(address => uint) balances;
107 	
108 	mapping(address => mapping(address => uint)) allowed;
109 	mapping(address => bool) public frozenAccount;
110 	struct usercan{
111 	    uint eths;
112 	    uint used;
113 	    uint len;
114 	    uint[] times;
115 	    uint[] moneys;
116 	    uint[] amounts;
117 	}
118 	mapping(address => usercan) mycan;
119 	mapping(address => usercan) myrun;
120 	struct userdata{
121 	    uint systemtag;
122 	    uint tzs;
123 	    uint usereths;
124 	    uint userethsused;
125 	    uint mylevelid;
126 	    uint mykeysid;
127 	    uint mykeyeths;
128 	    uint prizecount;
129 	    address fromaddr;
130 	    uint sun1;
131 	    uint sun2;
132 	    uint sun3;
133 	    //uint mysunmoney;
134 	    mapping(uint => uint) mysunsdaynum;
135 	    mapping(uint => uint) myprizedayget;
136 	    mapping(uint => uint) daysusereths;
137 	    mapping(uint => uint) daysuserdraws;
138 	    mapping(uint => uint) daysuserlucky;
139 	    mapping(uint => uint) levelget;
140 	    mapping(uint => bool) hascountprice;
141 	}
142 	mapping(address => userdata) my;
143 	mapping(address => uint) mysunmoney;
144 	uint[] public leveldata;
145 	mapping(uint => mapping(uint => uint)) public userlevelsnum;
146 
147 	//与用户钥匙id对应
148 	mapping(uint => address) public myidkeys;
149 	//all once day get all
150 	mapping(uint => uint) public daysgeteths;
151 	mapping(uint => uint) public dayseths;
152 	//user once day pay
153 	mapping(uint => uint) public daysysdraws;
154 	struct tagsdata{
155 	    uint ethnum;//用户总资产
156 	    uint sysethnum;//系统总eth
157 	    uint userethnum;//用户总eth
158 	    uint userethnumused;//用户总eth
159 	    uint syskeynum;//系统总key
160 	}
161 	mapping(uint => tagsdata) tg;
162 	mapping(address => bool) mangeruser;
163 	mapping(address => uint) mangerallowed;
164 	string private version;
165 	string private downurl;
166 	string private notices;
167 	uint public hasusednum;
168 	/* 通知 */
169 	event Transfer(address indexed from, address indexed to, uint tokens);
170 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
171 	event FrozenFunds(address target, bool frozen);
172 	event ethchange(address indexed from, address indexed to, uint tokens);
173 	modifier onlySystemStart() {
174         require(actived == true);
175 	    require(tags == my[msg.sender].systemtag);
176 	    require(!frozenAccount[msg.sender]);
177         _;
178     }
179 
180 	constructor() public {
181 		symbol = "OASIS";
182 		name = "Oasis";
183 		decimals = 18;
184 		_totalSupply = 100000000 ether;
185 	
186 		actived = true;
187 		tags = 0;
188 		tg[0] = tagsdata(0,0,0,0,0);
189 		
190         keyconfig.currentkeyid = 0;
191         keyconfig.keyidarr = [10055555,20055555,30055555,40055555,50055555,60055555,70055555,80055555,90055555];
192         worksdata = [0,0,0,0,0,0,0,0,0];   
193         runper = 10;
194 		//mans = [2,4,6];
195 		mms = [2 ether, 10 ether, 30 ether];
196 		pers = [50,30,20];
197 		prizeper = [2,2,2];
198 		prizeactivetime = [0,0,0];
199 		pubper = 1;
200 		subper = 120;
201 		luckyper = 5;
202 		lastmoney = 0;
203 		lastper = 1;
204 		sellkeyper = 70;
205 		sellper = 5;
206 		sellupper = 50;
207 		leveldata = [0,0,0];
208 
209         onceOuttime = 24 hours;
210         //onceOuttime = 10 seconds;
211         keyconfig.basekeynum = 4500 ether;//4500
212 	    keyconfig.basekeysub = 5000 ether;//500
213 	    keyconfig.usedkeynum = 0;//0
214         keyconfig.startprice = 100 szabo;//
215         keyconfig.keyprice   = 100 szabo;//
216         keyconfig.startbasekeynum = 4500 ether;//4500
217         per = 10;  
218         prizelevelsuns = [20,30,50];
219 		prizelevelmans = [100,300,800];
220 		prizelevelsunsday = [1,3,5];
221 		prizelevelmoneyday = [9 ether,29 ether,49 ether];
222 		lasttime = 8 hours;
223 		sysday = 1 days;
224 		cksysday = 8 hours;
225         version = '1.01';
226 		balances[this] = _totalSupply;
227 		emit Transfer(address(0), this, _totalSupply);
228 	}
229 
230 	function balanceOf(address tokenOwner) public view returns(uint balance) {
231 		return balances[tokenOwner];
232 	}
233 	
234 	function showlvzhou(address user) public view returns(
235 	    uint total,
236 	    uint mykeyid,
237 	    uint mytzs,
238 	    uint daysget,
239 	    uint prizeget,
240 	    uint mycans,
241 	    uint mykeynum,
242 	    uint keyprices,
243 	    uint ltkeynum,
244 	    uint tagss,
245 	    uint mytags
246 	    
247 	){
248 	    total = tg[tags].ethnum;//0
249 	    mykeyid = my[user].mykeysid;//1
250 	    mytzs = my[user].tzs;//2
251 	    daysget = my[user].usereths*per/1000;//3
252 	    prizeget = my[user].prizecount;//4
253 	    mycans = getcanuse(user);//5
254 	    mykeynum = balanceOf(user);//6
255 	    keyprices = getbuyprice();//7
256 	    ltkeynum = leftnum();//8
257 	    tagss = tags;//9
258 	    mytags = my[user].systemtag;//10
259 	}
260 	function showteam(address user) public view returns(
261 	    uint daysnum,//0
262 	    uint dayseth,//1
263 	    uint daysnum1,//2
264 	    uint dayseth1,//3
265 	    uint man1,//4
266 	    uint man2,//5
267 	    uint man3,//6
268 	    uint myruns,//7
269 	    uint canruns,//8
270 	    uint levelid,//9
271 	    uint mym
272 	){
273 	    uint d = gettoday();
274 	    uint t = getyestoday();
275 	    daysnum = my[user].mysunsdaynum[d];//5
276 	    dayseth = my[user].myprizedayget[d];//6
277 	    daysnum1 = my[user].mysunsdaynum[t];//5
278 	    dayseth1 = my[user].myprizedayget[t];//6
279 	    man1 = my[user].sun1;//2
280 	    man2 = my[user].sun2;//3
281 	    man3 = my[user].sun3;//4
282 	    myruns = myrun[user].eths;//6
283 	    canruns = getcanuserun(user);//7
284 	    levelid = my[user].mylevelid;//8
285 	    mym = mysunmoney[user];
286 	}
287 	function showlevel(address user) public view returns(
288 	    uint myget,//0
289 	    uint levelid,//1
290 	    uint len1,//2
291 	    uint len2,//3
292 	    uint len3,//4
293 	    uint m1,//5
294 	    uint m2,//6
295 	    uint m3,//7
296 	    uint t1,//8
297 	    uint t2,//9
298 	    uint t3,//10
299 	    uint levelget//11
300 	){
301 	    (levelid, myget) = getprizemoney(user);
302 	    //len2 = leveldata[1];
303 	    //len3 = leveldata[2];
304 	    m1 = allprize[0][0] - allprize[0][1];//5
305 	    m2 = allprize[1][0] - allprize[1][1];//6
306 	    m3 = allprize[2][0] - allprize[2][1];//7
307 	    t1 = prizeactivetime[0];//8
308 	    uint d = getyestoday();
309 	    if(t1 > 0) {
310 	        if(t1 + sysday > now){
311     	        len1 = leveldata[0];
312     	    }else{
313     	        len1 = userlevelsnum[1][d];
314 	        }
315 	    }
316 	    
317 	    t2 = prizeactivetime[1];//9
318 	    if(t2 > 0) {
319 	        if(t2 + sysday > now){
320     	        len2 = leveldata[1];
321     	    }else{
322     	        len2 = userlevelsnum[2][d];
323     	    }
324 	    }
325 	    
326 	    t3 = prizeactivetime[2];//10
327 	    if(t3 > 0) {
328 	        if(t3 + sysday > now){
329     	        len3 = leveldata[2];
330     	    }else{
331     	        len3 = userlevelsnum[3][d];
332     	    }
333 	    }
334 	    
335 	    levelget = my[user].levelget[d];//11
336 	}
337 	
338 	
339 	function showethconf(address user) public view returns(
340 	    uint todaymyeth,
341 	    uint todaymydraw,
342 	    uint todaysyseth,
343 	    uint todaysysdraw,
344 	    uint yestodaymyeth,
345 	    uint yestodaymydraw,
346 	    uint yestodaysyseth,
347 	    uint yestodaysysdraw
348 	){
349 	    uint d = gettoday();
350 		uint t = getyestoday();
351 		todaymyeth = my[user].daysusereths[d];
352 		todaymydraw = my[user].daysuserdraws[d];
353 		todaysyseth = dayseths[d];
354 		todaysysdraw = daysysdraws[d];
355 		yestodaymyeth = my[user].daysusereths[t];
356 		yestodaymydraw = my[user].daysuserdraws[t];
357 		yestodaysyseth = dayseths[t];
358 		yestodaysysdraw = daysysdraws[t];
359 		
360 	}
361 	function showprize(address user) public view returns(
362 	    uint lttime,//0
363 	    uint ltmoney,//1
364 	    address ltaddr,//2
365 	    uint lastmoneys,//3
366 	    address lastuser,//4
367 	    uint luckymoney,//5
368 	    address luckyuser,//6
369 	    uint luckyget//7
370 	){
371 	    if(timedata.length > 0) {
372 	       lttime = timedata[timedata.length - 1];//1 
373 	    }else{
374 	        lttime = 0;
375 	    }
376 	    if(moneydata.length > 0) {
377 	       ltmoney = moneydata[moneydata.length - 1];//2 
378 	    }else{
379 	        ltmoney = 0;
380 	    }
381 	    if(mansdata.length > 0) {
382 	        ltaddr = mansdata[mansdata.length - 1];//3
383 	    }else{
384 	        ltaddr = address(0);
385 	    }
386 	    lastmoneys = lastmoney;
387 	    lastuser = getlastuser();
388 	    uint d = getyestoday();
389 	    if(dayseths[d] > 0) {
390 	        luckymoney = dayseths[d]*luckyper/1000;
391 	        luckyuser = getluckyuser();
392 	        luckyget = my[user].daysuserlucky[d];
393 	    }
394 	    
395 	}
396 	function interuser(address user) public view returns(
397 	    uint skeyid,
398 	    uint stzs,
399 	    uint seths,
400 	    uint sethcan,
401 	    uint sruns,
402 	    uint srunscan,
403 	    uint skeynum
404 	    
405 	){
406 	    skeyid = my[user].mykeysid;
407 	    stzs = my[user].tzs;
408 	    seths = mycan[user].eths;
409 	    sethcan = getcanuse(user);
410 	    sruns = myrun[user].eths;
411 	    srunscan = getcanuserun(user);
412 	    skeynum = balances[user];
413 	}
414 	function showworker() public view returns(
415 	    uint w0,
416 	    uint w1,
417 	    uint w2,
418 	    uint w3,
419 	    uint w4,
420 	    uint w5,
421 	    uint w6,
422 	    uint w7,
423 	    uint w8
424 	){
425 	    w0 = worksdata[0];
426 	    w1 = worksdata[1];
427 	    w2 = worksdata[2];
428 	    w3 = worksdata[3];
429 	    w4 = worksdata[4];
430 	    w5 = worksdata[5];
431 	    w6 = worksdata[6];
432 	    w7 = worksdata[7];
433 	    w8 = worksdata[8];
434 	}
435 	
436 	function addmoney(address _addr, uint256 _amount, uint256 _money, uint _day) private returns(bool){
437 		mycan[_addr].eths += _money;
438 		mycan[_addr].len++;
439 		mycan[_addr].amounts.push(_amount);
440 		mycan[_addr].moneys.push(_money);
441 		if(_day > 0){
442 		    mycan[_addr].times.push(0);
443 		}else{
444 		    mycan[_addr].times.push(now);
445 		}
446 		
447 	}
448 	function reducemoney(address _addr, uint256 _money) private returns(bool){
449 	    if(mycan[_addr].eths >= _money && my[_addr].tzs >= _money) {
450 	        mycan[_addr].used += _money;
451     		mycan[_addr].eths -= _money;
452     		my[_addr].tzs -= _money;
453     		return(true);
454 	    }else{
455 	        return(false);
456 	    }
457 		
458 	}
459 	function addrunmoney(address _addr, uint256 _amount, uint256 _money, uint _day) private {
460 		myrun[_addr].eths += _money;
461 		myrun[_addr].len++;
462 		myrun[_addr].amounts.push(_amount);
463 		myrun[_addr].moneys.push(_money);
464 		if(_day > 0){
465 		    myrun[_addr].times.push(0);
466 		}else{
467 		    myrun[_addr].times.push(now);
468 		}
469 	}
470 	function reducerunmoney(address _addr, uint256 _money) private {
471 		myrun[_addr].eths -= _money;
472 		myrun[_addr].used += _money;
473 	}
474 
475 	function getcanuse(address user) public view returns(uint _left) {
476 		if(mycan[user].len > 0) {
477 		    for(uint i = 0; i < mycan[user].len; i++) {
478     			uint stime = mycan[user].times[i];
479     			if(stime == 0) {
480     			    _left += mycan[user].moneys[i];
481     			}else{
482     			    if(now - stime >= onceOuttime) {
483     			        uint smoney = mycan[user].amounts[i] * ((now - stime)/onceOuttime) * per/ 1000;
484     			        if(smoney <= mycan[user].moneys[i]){
485     			            _left += smoney;
486     			        }else{
487     			            _left += mycan[user].moneys[i];
488     			        }
489     			    }
490     			    
491     			}
492     		}
493 		}
494 		if(_left < mycan[user].used) {
495 			return(0);
496 		}
497 		if(_left > mycan[user].eths) {
498 			return(mycan[user].eths);
499 		}
500 		return(_left - mycan[user].used);
501 		
502 	}
503 	function getcanuserun(address user) public view returns(uint _left) {
504 		if(myrun[user].len > 0) {
505 		    for(uint i = 0; i < myrun[user].len; i++) {
506     			uint stime = myrun[user].times[i];
507     			if(stime == 0) {
508     			    _left += myrun[user].moneys[i];
509     			}else{
510     			    if(now - stime >= onceOuttime) {
511     			        uint smoney = myrun[user].amounts[i] * ((now - stime)/onceOuttime) * per/ 1000;
512     			        if(smoney <= myrun[user].moneys[i]){
513     			            _left += smoney;
514     			        }else{
515     			            _left += myrun[user].moneys[i];
516     			        }
517     			    }
518     			}
519     		}
520 		}
521 		if(_left < myrun[user].used) {
522 			return(0);
523 		}
524 		if(_left > myrun[user].eths) {
525 			return(myrun[user].eths);
526 		}
527 		return(_left - myrun[user].used);
528 	}
529 
530 	function _transfer(address from, address to, uint tokens) private{
531 		require(!frozenAccount[from]);
532 		require(!frozenAccount[to]);
533 		require(actived == true);
534 		require(from != to);
535         require(to != 0x0);
536         require(balances[from] >= tokens);
537         require(balances[to] + tokens > balances[to]);
538         uint previousBalances = balances[from] + balances[to];
539         balances[from] -= tokens;
540         balances[to] += tokens;
541         assert(balances[from] + balances[to] == previousBalances);
542         
543 		emit Transfer(from, to, tokens);
544 	}
545     function transfer(address _to, uint256 _value) public returns(bool){
546         _transfer(msg.sender, _to, _value);
547         return(true);
548     }
549     function activekey() public returns(bool) {
550         require(actived == true);
551 	    address addr = msg.sender;
552         uint keyval = 1 ether;
553         require(balances[addr] >= keyval);
554         require(my[addr].mykeysid < 1);
555         if(balances[addr] == keyval) {
556             keyval -= 1;
557         }
558         address top = my[addr].fromaddr;
559         uint topkeyids = keyconfig.currentkeyid;
560         if(top != address(0) && my[top].mykeysid > 0) {
561             topkeyids = my[top].mykeysid/10000000 - 1;
562         }else{
563             keyconfig.currentkeyid++;
564             if(keyconfig.currentkeyid > 8){
565                 keyconfig.currentkeyid = 0;
566             }
567         }
568         keyconfig.keyidarr[topkeyids]++;
569         uint kid = keyconfig.keyidarr[topkeyids];
570         require(myidkeys[kid] == address(0));
571         my[addr].mykeysid = kid;
572 	    myidkeys[kid] = addr;
573 	    balances[addr] -= keyval;
574 	    balances[owner] += keyval;
575 	    emit Transfer(addr, owner, keyval);
576 	    return(true);
577 	    
578     }
579     
580 	function getfrom(address _addr) public view returns(address) {
581 		return(my[_addr].fromaddr);
582 	}
583     function gettopid(address addr) public view returns(uint) {
584         address topaddr = my[addr].fromaddr;
585         if(topaddr == address(0)) {
586             return(0);
587         }
588         uint keyid = my[topaddr].mykeysid;
589         if(keyid > 0 && myidkeys[keyid] == topaddr) {
590             return(keyid);
591         }else{
592             return(0);
593         }
594     }
595     
596 	function approve(address spender, uint tokens) public returns(bool success) {
597 	    require(actived == true);
598 		allowed[msg.sender][spender] = tokens;
599 		emit Approval(msg.sender, spender, tokens);
600 		return true;
601 	}
602 
603 	function transferFrom(address from, address to, uint tokens) public returns(bool success) {
604 		require(actived == true);
605 		require(!frozenAccount[from]);
606 		require(!frozenAccount[to]);
607 		balances[from] -= tokens;
608 		allowed[from][msg.sender] -= tokens;
609 		balances[to] += tokens;
610 		emit Transfer(from, to, tokens);
611 		return true;
612 	}
613 
614 	function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
615 		return allowed[tokenOwner][spender];
616 	}
617 
618 	function setactive(bool t) public onlyOwner{
619 		actived = t;
620 	}
621 	
622 	function getyestoday() public view returns(uint d) {
623 	    uint today = gettoday();
624 	    d = today - sysday;
625 	}
626 	
627 	function gettoday() public view returns(uint d) {
628 	    uint n = now;
629 	    d = n - n%sysday - cksysday;
630 	}
631 	function totalSupply() public view returns(uint) {
632 		return(_totalSupply - balances[this]);
633 	}
634 
635 	function getbuyprice() public view returns(uint kp) {
636         if(keyconfig.usedkeynum == keyconfig.basekeynum) {
637             kp = keyconfig.keyprice + keyconfig.startprice;
638         }else{
639             kp = keyconfig.keyprice;
640         }
641 	    
642 	}
643 	function leftnum() public view returns(uint num) {
644 	    if(keyconfig.usedkeynum == keyconfig.basekeynum) {
645 	        num = keyconfig.basekeynum + keyconfig.basekeysub;
646 	    }else{
647 	        num = keyconfig.basekeynum - keyconfig.usedkeynum;
648 	    }
649 	}
650 	
651 	function getlevel(address addr) public view returns(uint) {
652 	    uint nums = my[addr].sun1 + my[addr].sun2 + my[addr].sun3;
653 	    if(my[addr].sun1 >= prizelevelsuns[2] && nums >= prizelevelmans[2]) {
654 	        return(3);
655 	    }
656 	    if(my[addr].sun1 >= prizelevelsuns[1] && nums >= prizelevelmans[1]) {
657 	        return(2);
658 	    }
659 	    if(my[addr].sun1 >= prizelevelsuns[0] && nums >= prizelevelmans[0]) {
660 	        return(1);
661 	    }
662 	    return(0);
663 	}
664 	
665 	function gettruelevel(address user, uint d) public view returns(uint) {
666 	    //uint d = getyestoday();
667 	    uint money = my[user].myprizedayget[d];
668 	    uint mymans = my[user].mysunsdaynum[d];
669 	    if(mymans >= prizelevelsunsday[2] && money >= prizelevelmoneyday[2]) {
670 	        if(my[user].mylevelid < 3){
671 	            return(my[user].mylevelid);
672 	        }else{
673 	           return(3); 
674 	        }
675 	        
676 	    }
677 	    if(mymans >= prizelevelsunsday[1] && money >= prizelevelmoneyday[1]) {
678 	        if(my[user].mylevelid < 2){
679 	            return(my[user].mylevelid);
680 	        }else{
681 	           return(2); 
682 	        }
683 	    }
684 	    if(mymans >= prizelevelsunsday[0] && money >= prizelevelmoneyday[0]) {
685 	        if(my[user].mylevelid < 1){
686 	            return(0);
687 	        }else{
688 	           return(1); 
689 	        }
690 	    }
691 	    return(0);
692 	    
693 	}
694 	function setlevel(address user) private returns(bool) {
695 	    uint lid = getlevel(user);
696 	    uint uid = my[user].mylevelid;
697 	    uint d = gettoday();
698 	    if(uid < lid) {
699 	        //if(uid > 0) {
700 	        //    leveldata[uid - 1]--;
701 	        //}
702 	        my[user].mylevelid = lid;
703 	        uint p = lid - 1;
704 	        //leveldata[p]++;
705 	        if(prizeactivetime[p] < 1) {
706 	            prizeactivetime[p] = d + sysday*2;
707 	        }
708 	        if(now < prizeactivetime[p]) {
709 	            leveldata[p]++;
710 	        }
711 	    }
712 	    if(lid > 0) {
713 	        uint tid = gettruelevel(user, d);
714     	    if(tid > 0 && prizeactivetime[tid - 1] > 0 && !my[user].hascountprice[d]) {
715     	         userlevelsnum[tid][d]++; 
716     	         my[user].hascountprice[d] = true;
717     	     }
718 	    }
719 	}
720 	function getprizemoney(address user) public view returns(uint lid, uint ps) {
721 	    lid = my[user].mylevelid;
722 	    if(lid > 0) {
723 	        uint p = lid - 1;
724 	        uint activedtime = prizeactivetime[p];
725 	        if(activedtime > 0 && activedtime < now) {
726 	            if(now  > activedtime  + sysday){
727 	                uint d = getyestoday();
728 	                uint ld = gettruelevel(user, d);
729 	                if(ld > 0) {
730 	                   uint pp = ld - 1;
731 	                   if(allprize[pp][0] > allprize[pp][1] && userlevelsnum[ld][d] > 0) {
732 	                       ps = (allprize[pp][0] - allprize[pp][1])/userlevelsnum[ld][d];
733 	                   }
734 	                }
735 	                return(ld, ps);
736 	            }else{
737 	                //uint d = activedtime - sysday;
738 	                
739 	                if(allprize[p][0] > allprize[p][1]){
740 	                    uint dd = gettoday();
741 	                    if(!my[user].hascountprice[dd]){
742 	                        ps = (allprize[p][0] - allprize[p][1])/leveldata[p];
743 	                    }
744 	                    
745 	                }
746 	            }
747 	            
748 	        }
749 	    }
750 	    return(lid, ps);
751 	}
752 	function getprize() onlySystemStart() public returns(bool) {
753 	    address user = msg.sender;
754 	    if(my[user].mylevelid > 0) {
755 	        (uint lid, uint ps) = getprizemoney(user);
756 	        if(lid > 0 && ps > 0) {
757 	            uint d = getyestoday();
758 	            require(my[user].levelget[d] == 0);
759         	    my[user].levelget[d] += ps;
760         	    allprize[lid - 1][1] += ps;
761         	    addrunmoney(user, ps, ps, 100);
762         	    
763 	        }
764 	    }
765 	}
766 	
767 	
768 	function getfromsun(address addr, uint money, uint amount) private returns(bool){
769 	    address f1 = my[addr].fromaddr;
770 	    uint d = gettoday();
771 	    if(f1 != address(0) && f1 != addr) {
772 	        if(mysunmoney[f1] >= mms[0]){
773 	            addrunmoney(f1, (amount*pers[0])/100, (money*pers[0])/100, 0);
774 	        }
775 	    	my[f1].myprizedayget[d] += amount;
776 	    	if(my[f1].mykeysid > 10000000) {
777 	    	    worksdata[((my[f1].mykeysid/10000000) - 1)] += amount;
778 	    	}
779 	    	setlevel(f1);
780 	    	address f2 = my[f1].fromaddr;
781 	    	if(f2 != address(0) && f2 != addr) {
782     	        if(mysunmoney[f2] >= mms[1]){
783     	           addrunmoney(f2, (amount*pers[1])/100, (money*pers[1])/100, 0);
784     	        }
785     	    	my[f2].myprizedayget[d] += amount;
786     	    	setlevel(f2);
787     	    	address f3 = my[f2].fromaddr;
788     	    	if(f3 != address(0) && f3 != addr) {
789         	        if(mysunmoney[f3] >= mms[2]){
790         	            addrunmoney(f3, (amount*pers[2])/100, (money*pers[2])/100, 0);
791         	        }
792         	    	my[f3].myprizedayget[d] += amount;
793         	    	setlevel(f3);
794         	    }
795     	    }	
796 	    }
797 	    
798 	}
799 	function setpubprize(uint sendmoney) private returns(bool) {
800 	    uint len = moneydata.length;
801 	    if(len > 0) {
802 	        uint all = 0;
803 	        uint start = 0;
804 	        uint m = 0;
805 	        if(len > 10) {
806 	            start = len - 10;
807 	        }
808 	        for(uint i = start; i < len; i++) {
809 	            all += moneydata[i];
810 	        }
811 	        //uint sendmoney = amount*pubper/100;
812 	        for(; start < len; start++) {
813 	            m = (sendmoney*moneydata[start])/all;
814 	            addmoney(mansdata[start],m, m, 100);
815 	            my[mansdata[start]].prizecount += m;
816 	        }
817 	    }
818 	    return(true);
819 	}
820 	function getluckyuser() public view returns(address addr) {
821 	    if(moneydata.length > 0){
822 	        uint d = gettoday();
823     	    uint t = getyestoday();
824     	    uint maxmoney = 1 ether;
825     	    for(uint i = 0; i < moneydata.length; i++) {
826     	        if(timedata[i] > t && timedata[i] < d && moneydata[i] >= maxmoney) {
827     	            maxmoney = moneydata[i];
828     	            addr = mansdata[i];
829     	        }
830     	    }
831 	    }
832 	    
833 	}
834 	function getluckyprize() onlySystemStart() public returns(bool) {
835 	    address user = msg.sender;
836 	    require(user != address(0));
837 	    require(user == getluckyuser());
838 	    uint d = getyestoday();
839 	    require(my[user].daysusereths[d] > 0);
840 	    require(my[user].daysuserlucky[d] == 0);
841 	    uint money = dayseths[d]*luckyper/1000;
842 	    addmoney(user, money,money, 100);
843 	    my[user].daysuserlucky[d] += money;
844 	    my[user].prizecount += money;
845 	    uint t = getyestoday() - sysday;
846 	    for(uint i = 0; i < moneydata.length; i++) {
847     	    if(timedata[i] < t) {
848     	        delete moneydata[i];
849     	        delete timedata[i];
850     	        delete mansdata[i];
851     	    }
852     	}
853 	}
854 	
855 	function runtoeth(uint amount) onlySystemStart() public returns(bool) {
856 	    address user = msg.sender;
857 	    uint usekey = (amount*runper*1 ether)/(100*keyconfig.keyprice);
858 	    require(usekey < balances[user]);
859 	    require(getcanuserun(user) >= amount);
860 	    //require(transfer(owner, usekey) == true);
861 	    balances[user] -= usekey;
862 		balances[owner] += usekey;
863 		emit Transfer(user, owner, usekey);
864 		
865 	    reducerunmoney(user, amount);
866 	    addmoney(user, amount, amount, 100);
867 	    
868 	    
869 	}
870 	function getlastuser() public view returns(address user) {
871 	    if(timedata.length > 0) {
872     	    if(lastmoney > 0 && now - timedata[timedata.length - 1] > lasttime) {
873     	        user = mansdata[mansdata.length - 1];
874     	    }
875 	    } 
876 	}
877 	function getlastmoney() public returns(bool) {
878 	    require(actived == true);
879 	    address user = getlastuser();
880 	    require(user != address(0));
881 	    require(user == msg.sender);
882 	    require(lastmoney > 0);
883 	    require(lastmoney <= address(this).balance/2);
884 	    user.transfer(lastmoney);
885 	    lastmoney = 0;
886 	}
887 	
888 	function buy(uint keyid) onlySystemStart() public payable returns(bool) {
889 		address user = msg.sender;
890 		require(msg.value > 0);
891         uint amount = msg.value;
892         if(my[user].tzs < 1) {
893             require(amount >= 1 ether);
894         }else{
895             require(amount >= 10 finney);
896         }
897 		
898 		//require(amount%(1 ether) == 0);
899 		require(my[user].usereths <= 100 ether);
900 		uint money = amount*3;
901 		uint d = gettoday();
902 		uint t = getyestoday();
903 		bool ifadd = false;
904 		//if has no top
905 		if(my[user].fromaddr == address(0)) {
906 		    address topaddr = myidkeys[keyid];
907 		    if(keyid > 0 && topaddr != address(0) && topaddr != user) {
908 		        my[user].fromaddr = topaddr;
909     		    my[topaddr].sun1++;
910     		    my[topaddr].mysunsdaynum[d]++;
911     		    mysunmoney[topaddr] += amount;
912     		    address top2 = my[topaddr].fromaddr;
913     		    if(top2 != address(0) && top2 != user){
914     		        my[top2].sun2++;
915     		        //my[top2].mysunsdaynum[d]++;
916     		    }
917     		    address top3 = my[top2].fromaddr;
918     		    if(top3 != address(0) && top3 != user){
919     		        my[top3].sun3++;
920     		        //my[top3].mysunsdaynum[d]++;
921     		    }
922     		    ifadd = true;
923 		    }
924 		}else{
925 		    ifadd = true;
926 		    mysunmoney[my[user].fromaddr] += amount;
927 		}
928 		if(ifadd == true) {
929 		    money = amount*4;
930 		}
931 		
932 		if(daysgeteths[t] > 0 && daysgeteths[d] > (daysgeteths[t]*subper)/100) {
933 		    if(ifadd == true) {
934     		    money = amount*3;
935     		}else{
936     		    money = amount*2;
937     		}
938 		}
939 		if(ifadd == true) {
940 		    getfromsun(user, money, amount);
941 		}
942 		setpubprize(amount*pubper/100);
943 		mansdata.push(user);
944 		moneydata.push(amount);
945 		timedata.push(now);
946 		
947 	    daysgeteths[d] += money;
948 	    dayseths[d] += amount;
949 	    tg[tags].sysethnum += amount;
950 		tg[tags].userethnum += amount;
951 		my[user].daysusereths[d] += amount;
952 		
953 		my[user].tzs += money;
954 		lastmoney += amount*lastper/100;
955 		tg[tags].ethnum += money;
956 		my[user].usereths += amount;
957 		allprize[0][0] += amount*prizeper[0]/100;
958 		allprize[1][0] += amount*prizeper[1]/100;
959 		allprize[2][0] += amount*prizeper[2]/100;
960 		addmoney(user, amount, money, 0);
961 		return(true);
962 	}
963 	
964 	function buykey(uint buynum) onlySystemStart() public payable returns(bool){
965 	    uint money = msg.value;
966 	    address user = msg.sender;
967 	    require(buynum >= 1 ether);
968 	    require(buynum%(1 ether) == 0);
969 	    require(keyconfig.usedkeynum + buynum <= keyconfig.basekeynum);
970 	    require(money >= keyconfig.keyprice);
971 	    require(user.balance >= money);
972 	    require(mycan[user].eths > 0);
973 	    require(((keyconfig.keyprice*buynum)/1 ether) == money);
974 	    
975 	    my[user].mykeyeths += money;
976 	    tg[tags].sysethnum += money;
977 	    tg[tags].syskeynum += buynum;
978 		if(keyconfig.usedkeynum + buynum == keyconfig.basekeynum) {
979 		    keyconfig.basekeynum = keyconfig.basekeynum + keyconfig.basekeysub;
980 	        keyconfig.usedkeynum = 0;
981 	        keyconfig.keyprice = keyconfig.keyprice + keyconfig.startprice;
982 	    }else{
983 	        keyconfig.usedkeynum += buynum;
984 	    }
985 	    _transfer(this, user, buynum);
986 	}
987 	function keybuy(uint m) onlySystemStart() public returns(bool) {
988 	    address user = msg.sender;
989 	    require(m >= 1 ether);
990 	    require(balances[user] >= m);
991 	    uint amount = (m*keyconfig.keyprice)/(1 ether);
992 	    //require(amount >= 1 ether);
993 	    //require(amount%(1 ether) == 0);
994 	    if(my[user].tzs < 1) {
995             require(amount >= 1 ether);
996         }else{
997             require(amount >= 10 finney);
998         }
999 	    uint money = amount*3;
1000 	    
1001 		uint d = gettoday();
1002 		uint t = getyestoday();
1003 		if(my[user].fromaddr != address(0)) {
1004 		    money = amount*4;
1005 		}
1006 		
1007 		if(daysgeteths[t] > 0 && daysgeteths[d] > daysgeteths[t]*subper/100) {
1008 		    if(my[user].fromaddr == address(0)) {
1009     		    money = amount*2;
1010     		}else{
1011     		    money = amount*3;
1012     		}
1013 		}
1014 		tg[tags].ethnum += money;
1015 		my[user].tzs += money;
1016 		addmoney(user, amount, money, 0);
1017 		balances[user] -= m;
1018 	    balances[owner] += m;
1019 		emit Transfer(user, owner, m);
1020 	    return(true);
1021 	}
1022 	function ethbuy(uint amount) onlySystemStart() public returns(bool) {
1023 	    address user = msg.sender;
1024 	    uint canmoney = getcanuse(user);
1025 	    require(canmoney >= amount);
1026 	    //require(amount >= 1 ether);
1027 	    //require(amount%(1 ether) == 0);
1028 	    require(amount >= 10 finney);
1029 	    
1030 	    require(mycan[user].eths >= amount);
1031 	    require(my[user].tzs >= amount);
1032 	    uint money = amount*3;
1033 		uint d = gettoday();
1034 		uint t = getyestoday();
1035 		if(my[user].fromaddr == address(0)) {
1036 		    money = amount*2;
1037 		}
1038 		
1039 		if(daysgeteths[t] > 0 && daysgeteths[d] > daysgeteths[t]*subper/100) {
1040 		    if(my[user].fromaddr == address(0)) {
1041     		    money = amount;
1042     		}else{
1043     		    money = amount*2;
1044     		}
1045 		}
1046 		addmoney(user, amount, money, 0);
1047 		my[user].tzs += money;
1048 		mycan[user].used += money;
1049 	    tg[tags].ethnum += money;
1050 	    
1051 	    return(true);
1052 	}
1053 	
1054 	function charge() public payable returns(bool) {
1055 		return(true);
1056 	}
1057 	
1058 	function() payable public {
1059 		buy(0);
1060 	}
1061 	
1062 	function sell(uint256 amount) onlySystemStart() public returns(bool success) {
1063 		address user = msg.sender;
1064 		uint d = gettoday();
1065 		uint t = getyestoday();
1066 		uint256 canuse = getcanuse(user);
1067 		require(canuse >= amount);
1068 		require(address(this).balance > amount);
1069 		uint p = sellper;
1070 		if((daysysdraws[d] + amount) > ((dayseths[d] + dayseths[t])*subper/100)){
1071 		    p = sellupper;
1072 		}
1073 		uint useper = (amount*p*(1 ether))/(keyconfig.keyprice*100);
1074 		
1075 		require(balances[user] >= useper);
1076 		require(reducemoney(user, amount) == true);
1077 		
1078 		my[user].userethsused += amount;
1079 		tg[tags].userethnumused += amount;
1080 		my[user].daysuserdraws[d] += amount;
1081 		daysysdraws[d] += amount;
1082 		//_transfer(user, owner, useper);
1083 		balances[user] -= useper;
1084 	    balances[owner] += useper;
1085 		emit Transfer(user, owner, useper);
1086 		user.transfer(amount);
1087 		
1088 		setend();
1089 		return(true);
1090 	}
1091 	
1092 	function sellkey(uint256 amount) onlySystemStart() public returns(bool) {
1093 	    address user = msg.sender;
1094 		require(balances[user] >= amount);
1095 		
1096 		uint d = gettoday();
1097 		uint t = getyestoday();
1098 		
1099 		uint money = (keyconfig.keyprice*amount*sellkeyper)/(100 ether);
1100 		if((daysysdraws[d] + money) > dayseths[t]*2){
1101 		    money = (keyconfig.keyprice*amount)/(2 ether);
1102 		}
1103 		require(address(this).balance > money);
1104 		//require(tg[tags].userethnumused + money <= tg[tags].userethnum/2);
1105 		my[user].userethsused += money;
1106         tg[tags].userethnumused += money;
1107         daysysdraws[d] += money;
1108     	balances[user] -= amount;
1109 	    balances[owner] += amount;
1110 		emit Transfer(user, owner, amount);
1111 		
1112     	user.transfer(money);
1113     	setend();
1114 	}
1115 
1116 	
1117 	
1118 	function setend() private returns(bool) {
1119 	    if(tg[tags].userethnum > 0 && tg[tags].userethnumused > tg[tags].userethnum/2) {
1120 	        tags++;
1121 	        keyconfig.keyprice = keyconfig.startprice;
1122 	        keyconfig.basekeynum = keyconfig.startbasekeynum;
1123 	        keyconfig.usedkeynum = 0;
1124 	        
1125 	        prizeactivetime = [0,0,0];
1126 	        leveldata = [0,0,0];
1127 	        return(true);
1128 	    }
1129 	}
1130 	function ended(bool ifget) public returns(bool) {
1131 	    require(actived == true);
1132 	    address user = msg.sender;
1133 	    require(my[user].systemtag < tags);
1134 	    require(!frozenAccount[user]);
1135 	    if(ifget == true) {
1136     	    my[user].prizecount = 0;
1137     	    my[user].tzs = 0;
1138     	    my[user].prizecount = 0;
1139     		mycan[user].eths = 0;
1140     	    mycan[user].used = 0;
1141     	    if(mycan[user].len > 0) {
1142     	        delete mycan[user].times;
1143     	        delete mycan[user].amounts;
1144     	        delete mycan[user].moneys;
1145     	    }
1146     	    mycan[user].len = 0;
1147     	    
1148     		myrun[user].eths = 0;
1149     	    myrun[user].used = 0;
1150     	    if(myrun[user].len > 0) {
1151     	        delete myrun[user].times;
1152     	        delete myrun[user].amounts;
1153     	        delete myrun[user].moneys;
1154     	    }
1155     	    myrun[user].len = 0;
1156     	    if(my[user].usereths/2 > my[user].userethsused) {
1157     	        uint money = my[user].usereths/2 - my[user].userethsused;
1158 	            require(address(this).balance > money);
1159     	        user.transfer(money);
1160     	    }
1161     	    my[user].usereths = 0;
1162     	    my[user].userethsused = 0;
1163     	    
1164 	    }else{
1165 	        uint amount = my[user].usereths - my[user].userethsused;
1166 	        tg[tags].ethnum += my[user].tzs;
1167 	        tg[tags].sysethnum += amount;
1168 		    tg[tags].userethnum += amount;
1169 	    }
1170 	    my[user].systemtag = tags;
1171 	}
1172 	
1173 	function setmangeruser(address user, bool t) public onlyOwner{
1174 	    mangeruser[user] = t;
1175 	}
1176 	function freezeAccount(address target, bool freeze) public{
1177 	    require(actived == true);
1178 	    require(mangeruser[msg.sender] == true);
1179 		frozenAccount[target] = freeze;
1180 		emit FrozenFunds(target, freeze);
1181 	}
1182 	function setmangerallow(address user, uint m) public {
1183 	    require(actived == true);
1184 	    require(mangeruser[msg.sender] == true);
1185 	    require(mangeruser[user] == true);
1186 	    require(user != address(0));
1187 	    require(user != msg.sender);
1188 	    //require(mangerallowed[user] == 0);
1189 	    mangerallowed[user] = m;
1190 	}
1191 	
1192 	function transto(address _to, uint money) public {
1193 	    require(actived == true);
1194 	    require(_to != 0x0);
1195 	    address user = msg.sender;
1196 	    require(mangeruser[user] == true);
1197     	require(mangerallowed[user] == money);
1198     	require(money > 1);
1199     	balances[_to] += money;
1200 	    hasusednum += money;
1201 	    mangerallowed[user] -= money - 1;
1202 		emit Transfer(user, _to, money);
1203 	}
1204     function setper(uint onceOuttimes,uint8 perss,uint runpers,uint pubpers,uint subpers,uint luckypers,uint lastpers,uint sellkeypers,uint sellpers,uint selluppers,uint lasttimes,uint sysdays,uint sellupperss) public onlyOwner{
1205 	    onceOuttime = onceOuttimes;
1206 	    per = perss;
1207 	    runper = runpers;
1208 	    pubper = pubpers;
1209 	    subper = subpers;
1210 	    luckyper = luckypers;
1211 	    lastper = lastpers;
1212 	    sellkeyper = sellkeypers;
1213 	    sellper = sellpers;
1214 	    sellupper = selluppers;
1215 	    lasttime = lasttimes;//9
1216 	    sysday = sysdays;
1217 	    sellupper = sellupperss;
1218 	}
1219 	function setnotice(
1220 	    string versions,
1221 	    string downurls,
1222 	    string noticess
1223 	) public returns(bool){
1224 	    require(actived == true);
1225 	    require(mangeruser[msg.sender] == true);
1226 	    version = versions;
1227 	    downurl = downurls;
1228 	    notices = noticess;
1229 	}
1230 	function getnotice() public view returns(
1231 	    string versions,
1232 	    string downurls,
1233 	    string noticess,
1234 	    bool isadm
1235 	){
1236 	    versions = version;
1237 	    downurls = downurl;
1238 	    noticess = notices;
1239 	    isadm = mangeruser[msg.sender];
1240 	}
1241 	
1242 }