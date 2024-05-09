1 pragma solidity ^0.4.24;
2 
3 // File: contracts/library/SafeMath.sol
4 
5 /**
6  * @title SafeMath v0.1.9
7  * @dev Math operations with safety checks that throw on error
8  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
9  * - added sqrt
10  * - added sq
11  * - added pwr 
12  * - changed asserts to requires with error log outputs
13  * - removed div, its useless
14  */
15 library SafeMath {
16     
17     /**
18     * @dev Multiplies two numbers, throws on overflow.
19     */
20     function mul(uint256 a, uint256 b) 
21         internal 
22         pure 
23         returns (uint256 c) 
24     {
25         if (a == 0) {
26             return 0;
27         }
28         c = a * b;
29         require(c / a == b, "SafeMath mul failed");
30         return c;
31     }
32 
33     /**
34     * @dev Integer division of two numbers, truncating the quotient.
35     */
36     function div(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b > 0);
38         uint256 c = a / b;
39         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40         return c;
41     }
42     
43     /**
44     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45     */
46     function sub(uint256 a, uint256 b)
47         internal
48         pure
49         returns (uint256) 
50     {
51         require(b <= a, "SafeMath sub failed");
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b)
59         internal
60         pure
61         returns (uint256 c) 
62     {
63         c = a + b;
64         require(c >= a, "SafeMath add failed");
65         return c;
66     }
67     
68     /**
69      * @dev gives square root of given x.
70      */
71     function sqrt(uint256 x)
72         internal
73         pure
74         returns (uint256 y) 
75     {
76         uint256 z = ((add(x,1)) / 2);
77         y = x;
78         while (z < y) 
79         {
80             y = z;
81             z = ((add((x / z),z)) / 2);
82         }
83     }
84     
85     /**
86      * @dev gives square. multiplies x by x
87      */
88     function sq(uint256 x)
89         internal
90         pure
91         returns (uint256)
92     {
93         return (mul(x,x));
94     }
95     
96     /**
97      * @dev x to the power of y 
98      */
99     function pwr(uint256 x, uint256 y)
100         internal 
101         pure 
102         returns (uint256)
103     {
104         if (x==0)
105             return (0);
106         else if (y==0)
107             return (1);
108         else 
109         {
110             uint256 z = x;
111             for (uint256 i=1; i < y; i++)
112                 z = mul(z,x);
113             return (z);
114         }
115     }
116 }
117 
118 // File: contracts/library/TimeUtils.sol
119 
120 library TimeUtils {
121     /*
122      *  Date and Time utilities for ethereum contracts
123      *
124      */
125     struct _DateTime {
126         uint16 year;
127         uint8 month;
128         uint8 day;
129         uint8 hour;
130         uint8 minute;
131         uint8 second;
132         uint8 weekday;
133     }
134 
135     uint constant DAY_IN_SECONDS = 86400;
136     uint constant YEAR_IN_SECONDS = 31536000;
137     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
138 
139     uint constant HOUR_IN_SECONDS = 3600;
140     uint constant MINUTE_IN_SECONDS = 60;
141 
142     uint16 constant ORIGIN_YEAR = 1970;
143 
144     function isLeapYear(uint16 year) public pure returns (bool) {
145         if (year % 4 != 0) {
146             return false;
147         }
148         if (year % 100 != 0) {
149             return true;
150         }
151         if (year % 400 != 0) {
152             return false;
153         }
154         return true;
155     }
156 
157     function leapYearsBefore(uint year) public pure returns (uint) {
158         year -= 1;
159         return year / 4 - year / 100 + year / 400;
160     }
161 
162     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
163         if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
164             return 31;
165         }
166         else if (month == 4 || month == 6 || month == 9 || month == 11) {
167             return 30;
168         }
169         else if (isLeapYear(year)) {
170             return 29;
171         }
172         else {
173             return 28;
174         }
175     }
176 
177     function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
178         uint secondsAccountedFor = 0;
179         uint buf;
180         uint8 i;
181 
182         // Year
183         dt.year = getYear(timestamp);
184         buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
185 
186         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
187         secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
188 
189         // Month
190         uint secondsInMonth;
191         for (i = 1; i <= 12; i++) {
192             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
193             if (secondsInMonth + secondsAccountedFor > timestamp) {
194                 dt.month = i;
195                 break;
196             }
197             secondsAccountedFor += secondsInMonth;
198         }
199 
200         // Day
201         for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
202             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
203                 dt.day = i;
204                 break;
205             }
206             secondsAccountedFor += DAY_IN_SECONDS;
207         }
208 
209         // Hour
210         dt.hour = getHour(timestamp);
211 
212         // Minute
213         dt.minute = getMinute(timestamp);
214 
215         // Second
216         dt.second = getSecond(timestamp);
217 
218         // Day of week.
219         dt.weekday = getWeekday(timestamp);
220     }
221 
222     function parseTimestampToYM(uint timestamp) internal pure returns (uint16, uint8) {
223         uint secondsAccountedFor = 0;
224         uint buf;
225         uint8 i;
226 
227         uint16 year;
228         uint8 month;
229 
230         // Year
231         year = getYear(timestamp);
232         buf = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
233 
234         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
235         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - buf);
236 
237         // Month
238         uint secondsInMonth;
239         for(i = 1; i <= 12; i++) {
240             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, year);
241             if(secondsInMonth + secondsAccountedFor > timestamp) {
242                 month = i;
243                 break;
244             }
245             secondsAccountedFor += secondsInMonth;
246         }
247 
248         return (year, month);
249     }
250 
251     function getYear(uint timestamp) public pure returns (uint16) {
252         uint secondsAccountedFor = 0;
253         uint16 year;
254         uint numLeapYears;
255 
256         // Year
257         year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
258         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
259 
260         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
261         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
262 
263         while (secondsAccountedFor > timestamp) {
264             if (isLeapYear(uint16(year - 1))) {
265                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
266             }
267             else {
268                 secondsAccountedFor -= YEAR_IN_SECONDS;
269             }
270             year -= 1;
271         }
272         return year;
273     }
274 
275     function getMonth(uint timestamp) public pure returns (uint8) {
276         return parseTimestamp(timestamp).month;
277     }
278 
279     function getDay(uint timestamp) public pure returns (uint8) {
280         return parseTimestamp(timestamp).day;
281     }
282 
283     function getHour(uint timestamp) public pure returns (uint8) {
284         return uint8((timestamp / 60 / 60) % 24);
285     }
286 
287     function getMinute(uint timestamp) public pure returns (uint8) {
288         return uint8((timestamp / 60) % 60);
289     }
290 
291     function getSecond(uint timestamp) public pure returns (uint8) {
292         return uint8(timestamp % 60);
293     }
294 
295     function getWeekday(uint timestamp) public pure returns (uint8) {
296         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
297     }
298 
299     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
300         return toTimestamp(year, month, day, 0, 0, 0);
301     }
302 
303     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
304         return toTimestamp(year, month, day, hour, 0, 0);
305     }
306 
307     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
308         return toTimestamp(year, month, day, hour, minute, 0);
309     }
310 
311     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
312         uint16 i;
313 
314         // Year
315         for (i = ORIGIN_YEAR; i < year; i++) {
316             if (isLeapYear(i)) {
317                 timestamp += LEAP_YEAR_IN_SECONDS;
318             }
319             else {
320                 timestamp += YEAR_IN_SECONDS;
321             }
322         }
323 
324         // Month
325         uint8[12] memory monthDayCounts;
326         monthDayCounts[0] = 31;
327         if (isLeapYear(year)) {
328             monthDayCounts[1] = 29;
329         }
330         else {
331             monthDayCounts[1] = 28;
332         }
333         monthDayCounts[2] = 31;
334         monthDayCounts[3] = 30;
335         monthDayCounts[4] = 31;
336         monthDayCounts[5] = 30;
337         monthDayCounts[6] = 31;
338         monthDayCounts[7] = 31;
339         monthDayCounts[8] = 30;
340         monthDayCounts[9] = 31;
341         monthDayCounts[10] = 30;
342         monthDayCounts[11] = 31;
343 
344         for (i = 1; i < month; i++) {
345             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
346         }
347 
348         // Day
349         timestamp += DAY_IN_SECONDS * (day - 1);
350 
351         // Hour
352         timestamp += HOUR_IN_SECONDS * (hour);
353 
354         // Minute
355         timestamp += MINUTE_IN_SECONDS * (minute);
356 
357         // Second
358         timestamp += second;
359 
360         return timestamp;
361     }
362 }
363 
364 // File: contracts/interface/DRSCoinInterface.sol
365 
366 interface DRSCoinInterface {
367     function mint(address _to, uint256 _amount) external;
368     function profitEth() external payable;
369 }
370 
371 // File: contracts/DRSCoin.sol
372 
373 contract DRSCoin {
374     using SafeMath for uint256;
375     using TimeUtils for uint;
376 
377     struct MonthInfo {
378         uint256 ethIncome;
379         uint256 totalTokenSupply;
380     }
381 
382     string constant tokenName = "DRSCoin";
383     string constant tokenSymbol = "DRS";
384     uint8 constant decimalUnits = 18;
385 
386     uint256 public constant tokenExchangeInitRate = 500; // 500 tokens per 1 ETH initial
387     uint256 public constant tokenExchangeLeastRate = 10; // 10 tokens per 1 ETH at least
388     uint256 public constant tokenReduceValue = 5000000;
389     uint256 public constant coinReduceRate = 90;
390 
391     uint256 constant private proposingPeriod = 2 days;
392     // uint256 constant private proposingPeriod = 2 seconds;
393 
394     string public name;
395     string public symbol;
396     uint8 public decimals;
397 
398     uint256 public totalSupply = 0;
399     uint256 public tokenReduceAmount;
400     uint256 public tokenExchangeRate; // DRSCoin / eth
401     uint256 public nextReduceSupply;  // next DRSCoin reduction supply
402 
403     address public owner;
404 
405     mapping(address => bool) restrictedAddresses;
406 
407     mapping(address => uint256) public balanceOf;
408 
409     mapping(address => mapping(address => uint256)) public allowance;
410 
411     mapping(address => uint32) public lastRefundMonth;
412 
413     mapping(address => uint256) public refundEth;  //record the user profit
414 
415     mapping(uint32 => MonthInfo) monthInfos;
416 
417     mapping(address => bool) allowedGameAddress;
418 
419     mapping(address => uint256) proposedGames;
420 
421     /* This generates a public event on the blockchain that will notify clients */
422     event Transfer(address indexed from, address indexed to, uint256 value);
423 
424     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
425 
426     event Mint(address indexed _to, uint256 _value);
427 
428     // event Info(uint256 _value);
429 
430     /* This notifies clients about the amount burnt */
431     event Burn(address indexed from, uint256 value);
432 
433     event Profit(address indexed from, uint256 year, uint256 month, uint256 value);
434 
435     event Withdraw(address indexed from, uint256 value);
436 
437     modifier onlyOwner {
438         assert(owner == msg.sender);
439         _;
440     }
441 
442     modifier onlyAllowedGameAddress {
443         require(allowedGameAddress[msg.sender], "only allowed games permit to call");
444         _;
445     }
446 
447     /* Initializes contract with initial supply tokens to the creator of the contract */
448     constructor() public
449     {
450         name = tokenName;                                   // Set the name for display purposes
451         symbol = tokenSymbol;                               // Set the symbol for display purposes
452         decimals = decimalUnits;                            // Amount of decimals for display purposes
453 
454         tokenReduceAmount = tokenReduceValue.mul(uint256(10) ** uint256(decimals));
455         tokenExchangeRate = tokenExchangeInitRate;          // Set initial token exchange rate
456         nextReduceSupply = tokenReduceAmount;               // Set next token reduction supply
457 
458         owner = msg.sender;
459     }
460 
461     // _startMonth included
462     // _nowMonth excluded
463     function settleEth(address _addr, uint32 _startMonth, uint32 _nowMonth) internal {
464         require(_nowMonth >= _startMonth);
465 
466         // _startMonth == 0 means new address
467         if(_startMonth == 0) {
468             lastRefundMonth[_addr] = _nowMonth;
469             return;
470         }
471 
472         if(_nowMonth == _startMonth) {
473             lastRefundMonth[_addr] = _nowMonth;
474             return;
475         }
476 
477         uint256 _balance = balanceOf[_addr];
478         if(_balance == 0) {
479             lastRefundMonth[_addr] = _nowMonth;
480             return;
481         }
482 
483         uint256 _unpaidPerfit = getUnpaidPerfit(_startMonth, _nowMonth, _balance);
484         refundEth[_addr] = refundEth[_addr].add(_unpaidPerfit);
485 
486         lastRefundMonth[_addr] = _nowMonth;
487         return;
488     }
489 
490     function getCurrentMonth() internal view returns(uint32) {
491         (uint16 _year, uint8 _month) = now.parseTimestampToYM();
492         return _year * 12 + _month - 1;
493     }
494 
495     function transfer(address _to, uint256 _value) public returns(bool success) {
496         require(_value > 0);
497         require(balanceOf[msg.sender] >= _value);              // Check if the sender has enough
498         require(balanceOf[_to] + _value >= balanceOf[_to]);    // Check for overflows
499         require(!restrictedAddresses[msg.sender]);
500         require(!restrictedAddresses[_to]);
501 
502         uint32 _nowMonth = getCurrentMonth();
503 
504         // settle msg.sender's eth
505         settleEth(msg.sender, lastRefundMonth[msg.sender], _nowMonth);
506 
507         // settle _to's eth
508         settleEth(_to, lastRefundMonth[_to], _nowMonth);
509 
510         // transfer token
511         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);   // Subtract from the sender
512         balanceOf[_to] = balanceOf[_to].add(_value);                 // Add the same to the recipient
513         emit Transfer(msg.sender, _to, _value);                      // Notify anyone listening that this transfer took place
514         return true;
515     }
516 
517     function approve(address _spender, uint256 _value) public returns(bool success) {
518         allowance[msg.sender][_spender] = _value;                 // Set allowance
519         emit Approval(msg.sender, _spender, _value);              // Raise Approval event
520         return true;
521     }
522 
523     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
524         require(balanceOf[_from] >= _value);                  // Check if the sender has enough
525         require(balanceOf[_to] + _value >= balanceOf[_to]);   // Check for overflows
526         require(_value <= allowance[_from][msg.sender]);      // Check allowance
527         require(!restrictedAddresses[_from]);
528         require(!restrictedAddresses[msg.sender]);
529         require(!restrictedAddresses[_to]);
530 
531         uint32 _nowMonth = getCurrentMonth();
532 
533         // settle _from's eth
534         settleEth(_from, lastRefundMonth[_from], _nowMonth);
535 
536         // settle _to's eth
537         settleEth(_to, lastRefundMonth[_to], _nowMonth);
538 
539         // transfer token
540         balanceOf[_from] = balanceOf[_from].sub(_value);    // Subtract from the sender
541         balanceOf[_to] = balanceOf[_to].add(_value);        // Add the same to the recipient
542         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
543         emit Transfer(_from, _to, _value);
544         return true;
545     }
546 
547     function getUnpaidPerfit(uint32 _startMonth, uint32 _endMonth, uint256 _tokenAmount) internal view returns(uint256)
548     {
549         require(_startMonth > 0);
550         require(_endMonth >= _startMonth);
551 
552         if(_startMonth == _endMonth) {
553             return 0;
554         }
555 
556         if(_tokenAmount == 0) {
557             return 0;
558         }
559 
560         uint256 _profit = 0;
561 
562         uint256 _income;
563         uint256 _totalSupply;
564         for(uint32 j = _startMonth; j < _endMonth; j++) {
565             _income = monthInfos[j].ethIncome;
566             _totalSupply = monthInfos[j].totalTokenSupply;
567             if(_income > 0 && _totalSupply > 0) {
568                 _profit = _profit.add(_income.mul(_tokenAmount).div(_totalSupply));
569             }
570         }
571 
572         return _profit;
573     }
574 
575     function totalSupply() constant public returns(uint256) {
576         return totalSupply;
577     }
578 
579     function tokenExchangeRate() constant public returns(uint256) {
580         return tokenExchangeRate;
581     }
582 
583     function nextReduceSupply() constant public returns(uint256) {
584         return nextReduceSupply;
585     }
586 
587     function balanceOf(address _owner) constant public returns(uint256) {
588         return balanceOf[_owner];
589     }
590 
591     function allowance(address _owner, address _spender) constant public returns(uint256) {
592         return allowance[_owner][_spender];
593     }
594 
595     function() public payable {
596         revert();
597     }
598 
599     /* Owner can add new restricted address or removes one */
600     function editRestrictedAddress(address _newRestrictedAddress) public onlyOwner {
601         restrictedAddresses[_newRestrictedAddress] = !restrictedAddresses[_newRestrictedAddress];
602     }
603 
604     function isRestrictedAddress(address _querryAddress) constant public returns(bool) {
605         return restrictedAddresses[_querryAddress];
606     }
607 
608     function getMintAmount(uint256 _eth) private view returns(uint256 _amount, uint256 _nextReduceSupply, uint256 _tokenExchangeRate) {
609         _nextReduceSupply = nextReduceSupply;
610         _tokenExchangeRate = tokenExchangeRate;
611 
612         _amount = 0;
613         uint256 _part = _nextReduceSupply.sub(totalSupply);  // calculate how many DRSCoin can mint in this period
614         while(_part <= _eth.mul(_tokenExchangeRate)) {
615             _eth = _eth.sub(_part.div(_tokenExchangeRate));  // sub eth amount
616             _amount = _amount.add(_part);                    // add DRSCoin mint in this small part
617 
618             _part = tokenReduceAmount;
619             _nextReduceSupply = _nextReduceSupply.add(tokenReduceAmount);
620 
621             if(_tokenExchangeRate > tokenExchangeLeastRate) {
622                 _tokenExchangeRate = _tokenExchangeRate.mul(coinReduceRate).div(100);
623                 if(_tokenExchangeRate < tokenExchangeLeastRate) {
624                     _tokenExchangeRate = tokenExchangeLeastRate;
625                 }
626             }
627         }
628 
629         _amount = _amount.add(_eth.mul(_tokenExchangeRate));
630 
631         return (_amount, _nextReduceSupply, _tokenExchangeRate);
632     }
633 
634     function mint(address _to, uint256 _eth) external onlyAllowedGameAddress {
635         require(_eth > 0);
636 
637         (uint256 _amount, uint256 _nextReduceSupply, uint256 _tokenExchangeRate) = getMintAmount(_eth);
638 
639         require(_amount > 0);
640         require(totalSupply + _amount > totalSupply);
641         require(balanceOf[_to] + _amount > balanceOf[_to]);     // Check for overflows
642 
643         uint32 _nowMonth = getCurrentMonth();
644 
645         // settle _to's eth
646         settleEth(_to, lastRefundMonth[_to], _nowMonth);
647 
648         totalSupply = _amount.add(totalSupply);                 // Update total supply
649         balanceOf[_to] = _amount.add(balanceOf[_to]);           // Set minted coins to target
650 
651         // add current month's totalTokenSupply
652         monthInfos[_nowMonth].totalTokenSupply = totalSupply;
653 
654         if(_nextReduceSupply != nextReduceSupply) {
655             nextReduceSupply = _nextReduceSupply;
656         }
657         if(_tokenExchangeRate != tokenExchangeRate) {
658             tokenExchangeRate = _tokenExchangeRate;
659         }
660 
661         emit Mint(_to, _amount);                                // Create Mint event
662         emit Transfer(0x0, _to, _amount);                       // Create Transfer event from 0x
663     }
664 
665     function burn(uint256 _value) public returns(bool success) {
666         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
667         require(_value > 0);
668 
669         uint32 _nowMonth = getCurrentMonth();
670 
671         // settle msg.sender's eth
672         settleEth(msg.sender, lastRefundMonth[msg.sender], _nowMonth);
673 
674         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
675         totalSupply = totalSupply.sub(_value);                                // Updates totalSupply
676 
677         // update current month's totalTokenSupply
678         monthInfos[_nowMonth].totalTokenSupply = totalSupply;
679 
680         emit Burn(msg.sender, _value);
681         return true;
682     }
683 
684     function addGame(address gameAddress) public onlyOwner {
685         require(!allowedGameAddress[gameAddress], "game already in allow list");
686         require(proposedGames[gameAddress] > 0, "game must be in proposed list first");
687         require(now > proposedGames[gameAddress].add(proposingPeriod), "game must be debated for 2 days");
688 
689         // add gameAddress to allowedGameAddress
690         allowedGameAddress[gameAddress] = true;
691 
692         // delete gameAddress from proposedGames
693         proposedGames[gameAddress] = 0;
694     }
695 
696     function proposeGame(address gameAddress) public onlyOwner {
697         require(!allowedGameAddress[gameAddress], "game already in allow list");
698         require(proposedGames[gameAddress] == 0, "game already in proposed list");
699 
700         // add gameAddress to proposedGames
701         proposedGames[gameAddress] = now;
702     }
703 
704     function deleteGame (address gameAddress) public onlyOwner {
705         require(allowedGameAddress[gameAddress] || proposedGames[gameAddress] > 0, "game must in allow list or proposed list");
706 
707         // delete gameAddress from allowedGameAddress
708         allowedGameAddress[gameAddress] = false;
709 
710         // delete gameAddress from proposedGames
711         proposedGames[gameAddress] = 0;
712     }
713 
714     function gameCountdown(address gameAddress) public view returns(uint256) {
715         require(proposedGames[gameAddress] > 0, "game not in proposed list");
716 
717         uint256 proposedTime = proposedGames[gameAddress];
718 
719         if(now < proposedTime.add(proposingPeriod)) {
720             return proposedTime.add(proposingPeriod).sub(now);
721         } else {
722             return 0;
723         }
724     }
725 
726     function profitEth() external payable onlyAllowedGameAddress {
727         (uint16 _year, uint8 _month) = now.parseTimestampToYM();
728         uint32 _nowMonth = _year * 12 + _month - 1;
729 
730         uint256 _ethIncome = monthInfos[_nowMonth].ethIncome.add(msg.value);
731 
732         monthInfos[_nowMonth].ethIncome = _ethIncome;
733 
734         if(monthInfos[_nowMonth].totalTokenSupply == 0) {
735             monthInfos[_nowMonth].totalTokenSupply = totalSupply;
736         }
737 
738         emit Profit(msg.sender, _year, _month, _ethIncome);
739     }
740 
741     function withdraw() public {
742         require(!restrictedAddresses[msg.sender]);  // check if msg.sender is restricted
743 
744         uint32 _nowMonth = getCurrentMonth();
745 
746         uint32 _startMonth = lastRefundMonth[msg.sender];
747         require(_startMonth > 0);
748 
749         settleEth(msg.sender, _startMonth, _nowMonth);
750 
751         uint256 _profit = refundEth[msg.sender];
752         require(_profit > 0);
753 
754         refundEth[msg.sender] = 0;
755         msg.sender.transfer(_profit);
756 
757         emit Withdraw(msg.sender, _profit);
758     }
759 
760     function getEthPerfit(address _addr) public view returns(uint256) {
761         uint32 _nowMonth = getCurrentMonth();
762 
763         uint32 _startMonth = lastRefundMonth[_addr];
764         // new user
765         if(_startMonth == 0) {
766             return 0;
767         }
768 
769         uint256 _tokenAmount = balanceOf[_addr];
770 
771         uint256 _perfit = refundEth[_addr];
772 
773         if(_startMonth < _nowMonth && _tokenAmount > 0) {
774             uint256 _unpaidPerfit = getUnpaidPerfit(_startMonth, _nowMonth, _tokenAmount);
775             _perfit = _perfit.add(_unpaidPerfit);
776         }
777 
778         return _perfit;
779     }
780 }
781 
782 // contract DRSCoinTestContract {
783 //     DRSCoinInterface public drsCoin;
784 
785 //     constructor(address _drsCoin) public {
786 //         drsCoin = DRSCoinInterface(_drsCoin);
787 //     }
788 
789 //     function mintDRSCoin(address _addr, uint256 _amount) public {
790 //         drsCoin.mint(_addr, _amount);
791 //     }
792 // }