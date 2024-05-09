1 pragma solidity ^0.4.24;    
2 ////////////////////////////////////////////////////////////////////////////////
3 library     SafeMath
4 {
5     //------------------
6     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
7     {
8         if (a == 0)     return 0;
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     //--------------------------------------------------------------------------
14     function div(uint256 a, uint256 b) internal pure returns (uint256) 
15     {
16         return a/b;
17     }
18     //--------------------------------------------------------------------------
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
20     {
21         assert(b <= a);
22         return a - b;
23     }
24     //--------------------------------------------------------------------------
25     function add(uint256 a, uint256 b) internal pure returns (uint256) 
26     {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 ////////////////////////////////////////////////////////////////////////////////
33 contract    ERC20 
34 {
35     using SafeMath  for uint256;
36 
37     //----- VARIABLES
38 
39     address public              owner;          // Owner of this contract
40     address public              admin;          // The one who is allowed to do changes 
41 
42     mapping(address => uint256)                         balances;       // Maintain balance in a mapping
43     mapping(address => mapping (address => uint256))    allowances;     // Allowances index-1 = Owner account   index-2 = spender account
44 
45     //------ TOKEN SPECIFICATION
46 
47     string  public  constant    name     = "Reger Diamond Security Token";
48     string  public  constant    symbol   = "RDST";
49 
50     uint256 public  constant    decimals = 18;
51     
52     uint256 public  constant    initSupply       = 60000000 * 10**decimals;        // 10**18 max
53     uint256 public  constant    supplyReserveVal = 37500000 * 10**decimals;          // if quantity => the ##MACRO## addrs "* 10**decimals" 
54 
55     //-----
56 
57     uint256 public              totalSupply;
58     uint256 public              icoSalesSupply   = 0;                   // Needed when burning tokens
59     uint256 public              icoReserveSupply = 0;
60     uint256 public              softCap =  5000000   * 10**decimals;
61     uint256 public              hardCap = 21500000   * 10**decimals;
62 
63     //---------------------------------------------------- smartcontract control
64 
65     uint256 public              icoDeadLine = 1533513600;     // 2018-08-06 00:00 (GMT+0)   not needed
66 
67     bool    public              isIcoPaused            = false; 
68     bool    public              isStoppingIcoOnHardCap = true;
69 
70     //--------------------------------------------------------------------------
71 
72     modifier duringIcoOnlyTheOwner()  // if not during the ico : everyone is allowed at anytime
73     { 
74         require( now>icoDeadLine || msg.sender==owner );
75         _;
76     }
77 
78     modifier icoFinished()          { require(now > icoDeadLine);           _; }
79     modifier icoNotFinished()       { require(now <= icoDeadLine);          _; }
80     modifier icoNotPaused()         { require(isIcoPaused==false);          _; }
81     modifier icoPaused()            { require(isIcoPaused==true);           _; }
82     modifier onlyOwner()            { require(msg.sender==owner);           _; }
83     modifier onlyAdmin()            { require(msg.sender==admin);           _; }
84 
85     //----- EVENTS
86 
87     event Transfer(address indexed fromAddr, address indexed toAddr,   uint256 amount);
88     event Approval(address indexed _owner,   address indexed _spender, uint256 amount);
89 
90             //---- extra EVENTS
91 
92     event onAdminUserChanged(   address oldAdmin,       address newAdmin);
93     event onOwnershipTransfered(address oldOwner,       address newOwner);
94     event onIcoDeadlineChanged( uint256 oldIcoDeadLine, uint256 newIcoDeadline);
95     event onHardcapChanged(     uint256 hardCap,        uint256 newHardCap);
96     event icoIsNowPaused(       uint8 newPauseStatus);
97     event icoHasRestarted(      uint8 newPauseStatus);
98 
99     event log(string key, string value);
100     event log(string key, uint   value);
101 
102     //--------------------------------------------------------------------------
103     //--------------------------------------------------------------------------
104     constructor()   public 
105     {
106         owner       = msg.sender;
107         admin       = owner;
108 
109         isIcoPaused = false;
110         
111         //-----
112 
113         balances[owner] = initSupply;   // send the tokens to the owner
114         totalSupply     = initSupply;
115         icoSalesSupply  = totalSupply;   
116 
117         //----- Handling if there is a special maximum amount of tokens to spend during the ICO or not
118 
119         icoSalesSupply   = totalSupply.sub(supplyReserveVal);
120         icoReserveSupply = totalSupply.sub(icoSalesSupply);
121     }
122     //--------------------------------------------------------------------------
123     //--------------------------------------------------------------------------
124     //----- ERC20 FUNCTIONS
125     //--------------------------------------------------------------------------
126     //--------------------------------------------------------------------------
127     function balanceOf(address walletAddress) public constant returns (uint256 balance) 
128     {
129         return balances[walletAddress];
130     }
131     //--------------------------------------------------------------------------
132     function transfer(address toAddr, uint256 amountInWei)  public   duringIcoOnlyTheOwner   returns (bool)     // don't icoNotPaused here. It's a logic issue. 
133     {
134         require(toAddr!=0x0 && toAddr!=msg.sender && amountInWei>0);     // Prevent transfer to 0x0 address and to self, amount must be >0
135 
136         uint256 availableTokens = balances[msg.sender];
137 
138         //----- Checking Token reserve first : if during ICO    
139 
140         if (msg.sender==owner && now <= icoDeadLine)                    // ICO Reserve Supply checking: Don't touch the RESERVE of tokens when owner is selling
141         {
142             assert(amountInWei<=availableTokens);
143 
144             uint256 balanceAfterTransfer = availableTokens.sub(amountInWei);      
145 
146             assert(balanceAfterTransfer >= icoReserveSupply);           // We try to sell more than allowed during an ICO
147         }
148 
149         //-----
150 
151         balances[msg.sender] = balances[msg.sender].sub(amountInWei);
152         balances[toAddr]     = balances[toAddr].add(amountInWei);
153 
154         emit Transfer(msg.sender, toAddr, amountInWei);
155 
156         return true;
157     }
158     //--------------------------------------------------------------------------
159     function allowance(address walletAddress, address spender) public constant returns (uint remaining)
160     {
161         return allowances[walletAddress][spender];
162     }
163     //--------------------------------------------------------------------------
164     function transferFrom(address fromAddr, address toAddr, uint256 amountInWei)  public  returns (bool) 
165     {
166         if (amountInWei <= 0)                                   return false;
167         if (allowances[fromAddr][msg.sender] < amountInWei)     return false;
168         if (balances[fromAddr] < amountInWei)                   return false;
169 
170         balances[fromAddr]               = balances[fromAddr].sub(amountInWei);
171         balances[toAddr]                 = balances[toAddr].add(amountInWei);
172         allowances[fromAddr][msg.sender] = allowances[fromAddr][msg.sender].sub(amountInWei);
173 
174         emit Transfer(fromAddr, toAddr, amountInWei);
175         return true;
176     }
177     //--------------------------------------------------------------------------
178     function approve(address spender, uint256 amountInWei) public returns (bool) 
179     {
180         require((amountInWei == 0) || (allowances[msg.sender][spender] == 0));
181         allowances[msg.sender][spender] = amountInWei;
182         emit Approval(msg.sender, spender, amountInWei);
183 
184         return true;
185     }
186     //--------------------------------------------------------------------------
187     function() public                       
188     {
189         assert(true == false);      // If Ether is sent to this address, don't handle it -> send it back.
190     }
191     //--------------------------------------------------------------------------
192     //--------------------------------------------------------------------------
193     //--------------------------------------------------------------------------
194     function transferOwnership(address newOwner) public onlyOwner               // @param newOwner The address to transfer ownership to.
195     {
196         require(newOwner != address(0));
197 
198         emit onOwnershipTransfered(owner, newOwner);
199         owner = newOwner;
200     }
201     //--------------------------------------------------------------------------
202     //--------------------------------------------------------------------------
203     //--------------------------------------------------------------------------
204     //--------------------------------------------------------------------------
205     function    changeAdminUser(address newAdminAddress) public onlyOwner
206     {
207         require(newAdminAddress!=0x0);
208 
209         emit onAdminUserChanged(admin, newAdminAddress);
210         admin = newAdminAddress;
211     }
212     //--------------------------------------------------------------------------
213     //--------------------------------------------------------------------------
214     function    changeIcoDeadLine(uint256 newIcoDeadline) public onlyAdmin
215     {
216         require(newIcoDeadline!=0);
217 
218         emit onIcoDeadlineChanged(icoDeadLine, newIcoDeadline);
219         icoDeadLine = newIcoDeadline;
220     }
221     //--------------------------------------------------------------------------
222     //--------------------------------------------------------------------------
223     //--------------------------------------------------------------------------
224     function    changeHardCap(uint256 newHardCap) public onlyAdmin
225     {
226         require(newHardCap!=0);
227 
228         emit onHardcapChanged(hardCap, newHardCap);
229         hardCap = newHardCap;
230     }
231     //--------------------------------------------------------------------------
232     function    isHardcapReached()  public view returns(bool)
233     {
234         return (isStoppingIcoOnHardCap && initSupply-balances[owner] > hardCap);
235     }
236     //--------------------------------------------------------------------------
237     //--------------------------------------------------------------------------
238     //--------------------------------------------------------------------------
239     function    pauseICO()  public onlyAdmin
240     {
241         isIcoPaused = true;
242         emit icoIsNowPaused(1);
243     }
244     //--------------------------------------------------------------------------
245     function    unpauseICO()  public onlyAdmin
246     {
247         isIcoPaused = false;
248         emit icoHasRestarted(0);
249     }
250     //--------------------------------------------------------------------------
251     function    isPausedICO() public view     returns(bool)
252     {
253         return (isIcoPaused) ? true : false;
254     }
255 }
256 ////////////////////////////////////////////////////////////////////////////////
257 contract    DateTime 
258 {
259     struct TDateTime 
260     {
261         uint16 year;    uint8 month;    uint8 day;
262         uint8 hour;     uint8 minute;   uint8 second;
263         uint8 weekday;
264     }
265     uint8[] totalDays = [ 0,   31,28,31,30,31,30,  31,31,30,31,30,31];
266     uint constant DAY_IN_SECONDS       = 86400;
267     uint constant YEAR_IN_SECONDS      = 31536000;
268     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
269     uint constant HOUR_IN_SECONDS      = 3600;
270     uint constant MINUTE_IN_SECONDS    = 60;
271     uint16 constant ORIGIN_YEAR        = 1970;
272     //-------------------------------------------------------------------------
273     function isLeapYear(uint16 year) public pure returns (bool) 
274     {
275         if ((year %   4)!=0)    return false;
276         if ( year % 100 !=0)    return true;
277         if ( year % 400 !=0)    return false;
278         return true;
279     }
280     //-------------------------------------------------------------------------
281     function leapYearsBefore(uint year) public pure returns (uint) 
282     {
283         year -= 1;
284         return year / 4 - year / 100 + year / 400;
285     }
286     //-------------------------------------------------------------------------
287     function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) 
288     {
289         uint8   nDay = 30;
290              if (month==1)          nDay++;
291         else if (month==3)          nDay++;
292         else if (month==5)          nDay++;
293         else if (month==7)          nDay++;
294         else if (month==8)          nDay++;
295         else if (month==10)         nDay++;
296         else if (month==12)         nDay++;
297         else if (month==2) 
298         {
299                                     nDay = 28;
300             if (isLeapYear(year))   nDay++;
301         }
302         return nDay;
303     }
304     //-------------------------------------------------------------------------
305     function parseTimestamp(uint timestamp) internal pure returns (TDateTime dt) 
306     {
307         uint  secondsAccountedFor = 0;
308         uint  buf;
309         uint8 i;
310         uint  secondsInMonth;
311         dt.year = getYear(timestamp);
312         buf     = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
313         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
314         secondsAccountedFor += YEAR_IN_SECONDS   * (dt.year - ORIGIN_YEAR - buf);
315         for (i = 1; i <= 12; i++) 
316         {
317             secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
318             if (secondsInMonth + secondsAccountedFor > timestamp) 
319             {
320                 dt.month = i;
321                 break;
322             }
323             secondsAccountedFor += secondsInMonth;
324         }
325         for (i=1; i<=getDaysInMonth(dt.month, dt.year); i++) 
326         {
327             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) 
328             {
329                 dt.day = i;
330                 break;
331             }
332             secondsAccountedFor += DAY_IN_SECONDS;
333         }
334         dt.hour    = getHour(timestamp);
335         dt.minute  = getMinute(timestamp);
336         dt.second  = getSecond(timestamp);
337         dt.weekday = getWeekday(timestamp);
338     }
339     //-------------------------------------------------------------------------
340     function getYear(uint timestamp) public pure returns (uint16) 
341     {
342         uint secondsAccountedFor = 0;
343         uint16 year;
344         uint numLeapYears;
345         year         = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
346         numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
347         secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
348         secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
349         while (secondsAccountedFor > timestamp) 
350         {
351             if (isLeapYear(uint16(year - 1)))   secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
352             else                                secondsAccountedFor -= YEAR_IN_SECONDS;
353             year -= 1;
354         }
355         return year;
356     }
357     //-------------------------------------------------------------------------
358     function getMonth(uint timestamp) public pure returns (uint8) 
359     {
360         return parseTimestamp(timestamp).month;
361     }
362     //-------------------------------------------------------------------------
363     function getDay(uint timestamp) public pure returns (uint8) 
364     {
365         return parseTimestamp(timestamp).day;
366     }
367     //-------------------------------------------------------------------------
368     function getHour(uint timestamp) public pure returns (uint8) 
369     {
370         return uint8(((timestamp % 86400) / 3600) % 24);
371     }
372     //-------------------------------------------------------------------------
373     function getMinute(uint timestamp) public pure returns (uint8) 
374     {
375         return uint8((timestamp % 3600) / 60);
376     }
377     //-------------------------------------------------------------------------
378     function getSecond(uint timestamp) public pure returns (uint8) 
379     {
380         return uint8(timestamp % 60);
381     }
382     //-------------------------------------------------------------------------
383     function getWeekday(uint timestamp) public pure returns (uint8) 
384     {
385         return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
386     }
387     //-------------------------------------------------------------------------
388     function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) 
389     {
390         return toTimestamp(year, month, day, 0, 0, 0);
391     }
392     //-------------------------------------------------------------------------
393     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) 
394     {
395         return toTimestamp(year, month, day, hour, 0, 0);
396     }
397     //-------------------------------------------------------------------------
398     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) 
399     {
400         return toTimestamp(year, month, day, hour, minute, 0);
401     }
402     //-------------------------------------------------------------------------
403     function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) 
404     {
405         uint16 i;
406         for (i = ORIGIN_YEAR; i < year; i++) 
407         {
408             if (isLeapYear(i))  timestamp += LEAP_YEAR_IN_SECONDS;
409             else                timestamp += YEAR_IN_SECONDS;
410         }
411         uint8[12] memory monthDayCounts;
412         monthDayCounts[0]  = 31;
413         monthDayCounts[1]  = 28;     if (isLeapYear(year))   monthDayCounts[1] = 29;
414         monthDayCounts[2]  = 31;
415         monthDayCounts[3]  = 30;
416         monthDayCounts[4]  = 31;
417         monthDayCounts[5]  = 30;
418         monthDayCounts[6]  = 31;
419         monthDayCounts[7]  = 31;
420         monthDayCounts[8]  = 30;
421         monthDayCounts[9]  = 31;
422         monthDayCounts[10] = 30;
423         monthDayCounts[11] = 31;
424         for (i=1; i<month; i++) 
425         {
426             timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
427         }
428         timestamp += DAY_IN_SECONDS    * (day - 1);
429         timestamp += HOUR_IN_SECONDS   * (hour);
430         timestamp += MINUTE_IN_SECONDS * (minute);
431         timestamp += second;
432         return timestamp;
433     }
434     //-------------------------------------------------------------------------
435     function getYearDay(uint timestamp) public pure returns (uint16)
436     {
437         TDateTime memory date = parseTimestamp(timestamp);
438         uint16 dayCount=0;
439         for (uint8 iMonth=1; iMonth<date.month; iMonth++)
440         {
441             dayCount += getDaysInMonth(iMonth, date.year);
442         }
443         dayCount += date.day;   
444         return dayCount;        // We have now the amount of days since January 1st of that year
445     }
446     //-------------------------------------------------------------------------
447     function getDaysInYear(uint16 year) public pure returns (uint16)
448     {
449         return (isLeapYear(year)) ? 366:365;
450     }
451     //-------------------------------------------------------------------------
452     function    dateToTimestamp(uint16 iYear, uint8 iMonth, uint8 iDay) public pure returns(uint)
453     {
454         uint8 monthDayCount = 30;
455         if (iMonth==2)
456         {
457                                     monthDayCount = 28;
458             if (isLeapYear(iYear))  monthDayCount++;
459         }
460         if (iMonth==4 || iMonth==6 || iMonth==9 || iMonth==11)
461         {
462             monthDayCount = 31;
463         }
464         if (iDay<1)           
465         {
466             iDay = 1;
467         }
468         else if (iDay>monthDayCount)     
469         {
470             iDay = 1;       // if day is over limit, set the date on the first day of the next month
471             iMonth++;
472             if (iMonth>12)  
473             {
474                 iMonth=1;
475                 iYear++;
476             }
477         }
478         return toTimestamp(iYear, iMonth, iDay);
479     }
480     //-------------------------------------------------------------------------
481 }
482 ////////////////////////////////////////////////////////////////////////////////
483 contract    CompoundContract  is  ERC20, DateTime
484 {
485     using SafeMath  for uint256;
486 
487         bool private    isLiveTerm = true;
488 
489     struct TCompoundItem
490     {
491         uint        id;                         // an HASH to distinguish each compound in contract
492         uint        plan;                       // 1: Sapphire   2: Emerald   3:Ruby   4: Diamond
493         address     investor;                   // wallet address of the owner of this compound contract
494         uint        tokenCapitalInWei;          // = capital
495         uint        tokenEarningsInWei;         // This contract will geneeate this amount of tokens for the investor
496         uint        earningPerTermInWei;        // Every "3 months" the investor will receive this amount of money
497         uint        currentlyEarnedInWei;       // cumulative amount of tokens already received
498         uint        tokenEarnedInWei;           // = totalEarnings
499         uint        overallTokensInWei;         // = capital + totalEarnings
500         uint        contractMonthCount;         // 12 or 24
501         uint        startTimestamp;
502         uint        endTimestamp;               // the date when the compound contract will cease
503         uint        interestRate;
504         uint        percent;
505         bool        isAllPaid;                  // if true : all compound earning has been given. Nothing more to do
506         uint8       termPaidCount;              //
507         uint8       termCount;                  //
508         bool        isContractValidated;        // Any compound contract needs to be confirmed otherwise they will be cancelled
509         bool        isCancelled;                // The compound contract was not validated and has been set to cancelled!
510     }
511 
512     mapping(address => uint256)                 lockedCapitals;     // During ICO we block some of the tokens
513     mapping(address => uint256)                 lockedEarnings;     // During ICO we block some of the tokens
514 
515     mapping(uint256 => bool)         private    activeContractStatues;      // Use when doing a payEarnings to navigate through all contracts
516     mapping(uint => TCompoundItem)   private    contracts;
517     mapping(uint256 => uint32[12])   private    compoundPayTimes;    
518     mapping(uint256 => uint8[12])    private    compoundPayStatus;          // to know if a compound has already been paid or not. So not repaying again    
519 
520     event onCompoundContractCompleted(address investor, uint256 compoundId, 
521                                                         uint256 capital, 
522                                                         uint256 earnedAmount, 
523                                                         uint256 total, 
524                                                         uint256 timestamp);
525 
526     event onCompoundEarnings(address investor,  uint256 compoundId, 
527                                                 uint256 capital, 
528                                                 uint256 earnedAmount, 
529                                                 uint256 earnedSoFarAmount, 
530                                                 uint32  timestamp,
531                                                 uint8   paidTermCount,
532                                                 uint8   totalTermCount);
533 
534     event onCompoundContractLocked(address fromAddr, address toAddr, uint256 amountToLockInWei);
535     event onPayEarningsDone(uint contractId, uint nPaid, uint paymentCount, uint paidAmountInWei);
536 
537     event onCompoundContractCancelled(uint contractId, uint lockedCapital, uint lockedEarnings);
538     event onCompoundContractValidated(uint contractId);
539 
540     //--------------------------------------------------------------------------
541     function    initCompoundContract(address buyerAddress, uint256 amountInWei, uint256 compoundContractId, uint monthCount)  internal onlyOwner  returns(bool)
542     {
543         TCompoundItem memory    item;
544         uint                    overallTokensInWei; 
545         uint                    tokenEarningsInWei;
546         uint                    earningPerTermInWei; 
547         uint                    percentToUse; 
548         uint                    interestRate;
549         uint                    i;
550 
551         if (activeContractStatues[compoundContractId])
552         {
553             return false;       // the specified contract is already in place. Don't alter already running contract!!!
554         }
555 
556         activeContractStatues[compoundContractId] = true;
557 
558         //----- Calculate the contract revenue generated for the whole monthPeriod
559 
560         (overallTokensInWei, 
561          tokenEarningsInWei,
562          earningPerTermInWei, 
563          percentToUse, 
564          interestRate,
565          i) = calculateCompoundContract(amountInWei, monthCount);
566 
567         item.plan = i;                  // Not enough stack depth. using i here
568 
569         //----- Checking if we can apply this compound contract or not
570 
571         if (percentToUse==0)        // an error occured
572         {
573             return false;
574         }
575 
576         //----- Calculate when to do payments for that contract
577 
578         generateCompoundTerms(compoundContractId);
579 
580         //-----
581 
582         item.id                   = compoundContractId;
583         item.startTimestamp       = now;
584 
585         item.contractMonthCount   = monthCount;
586         item.interestRate         = interestRate;
587         item.percent              = percentToUse;
588         item.investor             = buyerAddress;
589         item.isAllPaid            = false;
590         item.termCount            = uint8(monthCount/3);
591         item.termPaidCount        = 0;
592 
593         item.tokenCapitalInWei    = amountInWei;
594         item.currentlyEarnedInWei = 0;
595         item.overallTokensInWei   = overallTokensInWei;
596         item.tokenEarningsInWei   = tokenEarningsInWei;
597         item.earningPerTermInWei  = earningPerTermInWei;
598 
599         item.isCancelled          = false;
600         item.isContractValidated  = false;                      // any contract must be validated 35 days after its creation.
601 
602         //-----
603 
604         contracts[compoundContractId] = item;
605 
606         return true;
607     }
608     //--------------------------------------------------------------------------
609     function    generateCompoundTerms(uint256 compoundContractId)    private
610     {
611         uint16 iYear  =  getYear(now);
612         uint8  iMonth = getMonth(now);
613         uint   i;
614 
615         if (isLiveTerm)
616         {
617             for (i=0; i<8; i++)             // set every pay schedule date (every 3 months)  8 means 2 years payments every 3 months
618             {
619                 iMonth += 3;        // every 3 months
620                 if (iMonth>12)
621                 {
622                     iYear++;
623                     iMonth -= 12;
624                 }
625 
626                 compoundPayTimes[compoundContractId][i]  = uint32(dateToTimestamp(iYear, iMonth, getDay(now)));
627                 compoundPayStatus[compoundContractId][i] = 0;      
628             }
629         }
630         else
631         {
632             uint timeSum=now;
633             for (i=0; i<8; i++)             // set every pay schedule date (every 3 months)  8 means 2 years payments every 3 months
634             {
635                             uint duration = 4*60;    // set first period longer to allow confirmation of the contract
636                 if (i>0)         duration = 2*60;
637 
638                 timeSum += duration;
639 
640                 compoundPayTimes[compoundContractId][i]  = uint32(timeSum);     // DEBUGING: pay every 3 minutes
641                 compoundPayStatus[compoundContractId][i] = 0;      
642             }
643         }
644     }
645     //--------------------------------------------------------------------------
646     function    calculateCompoundContract(uint256 capitalInWei, uint contractMonthCount)   public  constant returns(uint, uint, uint, uint, uint, uint)    // DON'T Set as pure, otherwise it will make investXXMonths function unusable (too much gas) 
647     {
648         /*  12 months   Sapphire    From     100 to   1,000     12%
649                         Emerald     From   1,000 to  10,000     15%
650                         Rub         From  10,000 to 100,000     17%
651                         Diamond                     100,000+    20%
652             24 months   Sapphire    From     100 to   1,000     15%
653                         Emerald     From   1,000 to  10,000     17%
654                         Rub         From  10,000 to 100,000     20%
655                         Diamond                     100,000+    30%        */
656 
657         uint    plan          = 0;
658         uint256 interestRate  = 0;
659         uint256 percentToUse  = 0;
660 
661         if (contractMonthCount==12)
662         {
663                  if (capitalInWei<  1000 * 10**18)      { percentToUse=12;  interestRate=1125509;   plan=1; }   // SAPPHIRE
664             else if (capitalInWei< 10000 * 10**18)      { percentToUse=15;  interestRate=1158650;   plan=2; }   // EMERALD
665             else if (capitalInWei<100000 * 10**18)      { percentToUse=17;  interestRate=1181148;   plan=3; }   // RUBY
666             else                                        { percentToUse=20;  interestRate=1215506;   plan=4; }   // DIAMOND
667         }
668         else if (contractMonthCount==24)
669         {
670                  if (capitalInWei<  1000 * 10**18)      { percentToUse=15;  interestRate=1342471;   plan=1; }
671             else if (capitalInWei< 10000 * 10**18)      { percentToUse=17;  interestRate=1395110;   plan=2; }
672             else if (capitalInWei<100000 * 10**18)      { percentToUse=20;  interestRate=1477455;   plan=3; }
673             else                                        { percentToUse=30;  interestRate=1783478;   plan=4; }
674         }
675         else
676         {
677             return (0,0,0,0,0,0);                   // only 12 and 24 months are allowed here
678         }
679 
680         uint256 overallTokensInWei  = (capitalInWei *  interestRate         ) / 1000000;
681         uint256 tokenEarningsInWei  = overallTokensInWei - capitalInWei;
682         uint256 earningPerTermInWei = tokenEarningsInWei / (contractMonthCount/3);      // 3 is for => Pays a Term of earning every 3 months
683 
684         return (overallTokensInWei,tokenEarningsInWei,earningPerTermInWei, percentToUse, interestRate, plan);
685     }
686     //--------------------------------------------------------------------------
687     function    lockMoneyOnCompoundCreation(address toAddr, uint compountContractId)  internal  onlyOwner   returns (bool) 
688     {
689         require(toAddr!=0x0 && toAddr!=msg.sender);     // Prevent transfer to 0x0 address and to self, amount must be >0
690 
691         if (isHardcapReached())                                         
692         {
693             return false;       // an extra check first, who knows. 
694         }
695 
696         TCompoundItem memory item = contracts[compountContractId];
697 
698         if (item.tokenCapitalInWei==0 || item.tokenEarningsInWei==0)    
699         {
700             return false;       // don't valid such invalid contract
701         }
702 
703         //-----
704 
705         uint256 amountToLockInWei = item.tokenCapitalInWei + item.tokenEarningsInWei;
706         uint256 availableTokens   = balances[owner];
707 
708         if (amountToLockInWei <= availableTokens)
709         {
710             uint256 balanceAfterTransfer = availableTokens.sub(amountToLockInWei);      
711 
712             if (balanceAfterTransfer >= icoReserveSupply)       // don't sell more than allowed during ICO
713             {
714                 lockMoney(toAddr, item.tokenCapitalInWei, item.tokenEarningsInWei);
715                 return true;
716             }
717         }
718 
719         //emit log('Exiting lockMoneyOnCompoundCreation', 'cannot lock money');
720         return false;
721     }
722     //--------------------------------------------------------------------------
723     function    payCompoundTerm(uint contractId, uint8 termId, uint8 isCalledFromOutside)   public onlyOwner returns(int32)        // DON'T SET icoNotPaused here, since a runnnig compound needs to run anyway
724     {
725         uint                    id;
726         address                 investor;
727         uint                    paidAmount;
728         TCompoundItem   memory  item;
729 
730         if (!activeContractStatues[contractId])         
731         {
732             emit log("payCompoundTerm", "Specified contract is not actived (-1)");
733             return -1;
734         }
735 
736         item = contracts[contractId];
737 
738         //----- 
739         if (item.isCancelled)   // That contract was never validated!!!
740         {
741             emit log("payCompoundTerm", "Compound contract already cancelled (-2)");
742             return -2;
743         }
744 
745         //-----
746 
747         if (item.isAllPaid)                             
748         {
749             emit log("payCompoundTerm", "All earnings already paid for this contract (-2)");
750             return -4;   // everything was paid already
751         }
752 
753         id = item.id;
754 
755         if (compoundPayStatus[id][termId]!=0)           
756         {
757             emit log("payCompoundTerm", "Specified contract's term was already paid (-5)");
758             return -5;
759         }
760 
761         if (now < compoundPayTimes[id][termId])         
762         {
763             emit log("payCompoundTerm", "It's too early to pay this term (-6)");
764             return -6;
765         }
766 
767         investor = item.investor;                                   // address of the owner of this compound contract
768 
769         //----- It's time for the payment, but was that contract already validated
770         //----- If it was not validated, simply refund tokens to the main wallet
771 
772         if (!item.isContractValidated)                          // Compound contract self-destruction since no validation was made of it
773         {
774             uint    capital  = item.tokenCapitalInWei;
775             uint    earnings = item.tokenEarningsInWei;
776 
777             contracts[contractId].isCancelled        = true;
778             contracts[contractId].tokenCapitalInWei  = 0;       /// make sure nothing residual is left
779             contracts[contractId].tokenEarningsInWei = 0;       ///
780 
781             //-----
782 
783             lockedCapitals[investor] = lockedCapitals[investor].sub(capital);
784             lockedEarnings[investor] = lockedEarnings[investor].sub(earnings);
785 
786             balances[owner] = balances[owner].add(capital);
787             balances[owner] = balances[owner].add(earnings);
788 
789             emit onCompoundContractCancelled(contractId, capital, earnings);
790             emit log("payCompoundTerm", "Cancelling compound contract (-3)");
791             return -3;
792         }
793 
794         //---- it's PAY time!!!
795 
796         contracts[id].termPaidCount++;
797         contracts[id].currentlyEarnedInWei += item.earningPerTermInWei;  
798 
799         compoundPayStatus[id][termId] = 1;                          // PAID!!!      meaning not to repay again this revenue term 
800 
801         unlockEarnings(investor, item.earningPerTermInWei);
802 
803         paidAmount = item.earningPerTermInWei;
804 
805         if (contracts[id].termPaidCount>=item.termCount && !contracts[item.id].isAllPaid)   // This is the last payment of all payments for this contract
806         {
807             contracts[id].isAllPaid = true;
808 
809             unlockCapital(investor, item.tokenCapitalInWei);
810 
811             paidAmount += item.tokenCapitalInWei;
812         }
813 
814         //----- let's tell the blockchain now how many we've unlocked.
815 
816         if (isCalledFromOutside==0 && paidAmount>0)
817         {
818             emit Transfer(owner, investor, paidAmount);
819         }
820 
821         return 1;       // We just paid one earning!!!
822                         // 1 IS IMPORTANT FOR THE TOKEN API. don't change it
823     }
824     //--------------------------------------------------------------------------
825     function    validateCompoundContract(uint contractId) public onlyOwner   returns(uint)
826     {
827         TCompoundItem memory  item = contracts[contractId];
828 
829         if (item.isCancelled==true)
830         {
831             return 2;       // don't try to validated an already dead contract
832         }
833 
834         contracts[contractId].isCancelled         = false;
835         contracts[contractId].isContractValidated = true;
836 
837         emit onCompoundContractValidated(contractId);
838 
839         return 1;
840     }
841     //--------------------------------------------------------------------------
842     //-----
843     //----- When an investor (investor) is put money (capital) in a compound investor
844     //----- We do calculate all interests (earnings) he will receive for the whole contract duration
845     //----- Then we lock the capital and the earnings into special vaults.
846     //----- We remove from the main token balance the capital invested and the future earnings
847     //----- So there won't be wrong calculation when people wishes to buy tokens
848     //-----
849     //----- If you use the standard ERC20 balanceOf to check balance of an investor, you will see
850     //----- balance = 0, if he just invested. This is normal, since money is locked in other vaults.
851     //----- To check the exact money of the investor, use instead :
852     //----- lockedCapitalOf(address investor)  
853     //----- to see the amount of money he fully invested and which which is still not available to him
854     //----- Use also
855     //----- locakedEarningsOf(address investor)
856     //----- It will show all the remaining benefit the person will get soon. The amount shown by This
857     //----- function will decrease from time to time, while the real balanceOf(address investor)
858     //----- will increase
859     //-----
860     //--------------------------------------------------------------------------
861     function    lockMoney(address investor, uint capitalAmountInWei, uint totalEarningsToReceiveInWei) internal onlyOwner
862     {
863         uint totalAmountToLockInWei = capitalAmountInWei + totalEarningsToReceiveInWei;
864 
865         if (totalAmountToLockInWei <= balances[owner])
866         {
867             balances[owner] = balances[owner].sub(capitalAmountInWei.add(totalEarningsToReceiveInWei));     /// We remove capital & future earning from the Token's main balance, to put money in safe areas
868 
869             lockedCapitals[investor] = lockedCapitals[investor].add(capitalAmountInWei);            /// The capital invested is now locked during the whole contract
870             lockedEarnings[investor] = lockedEarnings[investor].add(totalEarningsToReceiveInWei);   /// The whole earnings is full locked also in another vault called lockedEarnings
871 
872             emit Transfer(owner, investor, capitalAmountInWei);    // No need to show all locked amounts. Because these locked ones contain capital + future earnings. 
873         }                                                            // So we just show the capital. the earnings will appear after each payment.
874     }
875     //--------------------------------------------------------------------------
876     function    unlockCapital(address investor, uint amountToUnlockInWei) internal onlyOwner
877     {
878         if (amountToUnlockInWei <= lockedCapitals[investor])
879         {
880             balances[investor]       = balances[investor].add(amountToUnlockInWei);
881             lockedCapitals[investor] = lockedCapitals[investor].sub(amountToUnlockInWei);    /// So to make all locked tokens available
882 
883             //---- No need of emit Transfer here. It is called from elsewhere
884         }
885     }
886     //--------------------------------------------------------------------------
887     function    unlockEarnings(address investor, uint amountToUnlockInWei) internal onlyOwner
888     {
889         if (amountToUnlockInWei <= lockedEarnings[investor])
890         {
891             balances[investor]       = balances[investor].add(amountToUnlockInWei);
892             lockedEarnings[investor] = lockedEarnings[investor].sub(amountToUnlockInWei);    /// So to make all locked tokens available
893 
894             //---- No need of emit Transfer here. It is called from elsewhere
895         }
896     }
897     //--------------------------------------------------------------------------
898     function    lockedCapitalOf(address investor) public  constant  returns(uint256)
899     {
900         return lockedCapitals[investor];
901     }
902     //--------------------------------------------------------------------------
903     function    lockedEarningsOf(address investor) public  constant  returns(uint256)
904     {
905         return lockedEarnings[investor];
906     }  
907     //--------------------------------------------------------------------------
908     function    lockedBalanceOf(address investor) public  constant  returns(uint256)
909     {
910         return lockedCapitals[investor] + lockedEarnings[investor];
911     }
912     //--------------------------------------------------------------------------
913     function    geCompoundTimestampsFor12Months(uint contractId) public view  returns(uint256,uint256,uint256,uint256)
914     {
915         uint32[12] memory t = compoundPayTimes[contractId];
916 
917         return(uint256(t[0]),uint256(t[1]),uint256(t[2]),uint256(t[3]));
918     }
919     //-------------------------------------------------------------------------
920     function    geCompoundTimestampsFor24Months(uint contractId) public view  returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
921     {
922         uint32[12] memory t = compoundPayTimes[contractId];
923 
924         return(uint256(t[0]),uint256(t[1]),uint256(t[2]),uint256(t[3]),uint256(t[4]),uint256(t[5]),uint256(t[6]),uint256(t[7]));
925     }
926     //-------------------------------------------------------------------------
927     function    getCompoundContract(uint contractId) public constant    returns(address investor, 
928                                                                         uint capital, 
929                                                                         uint profitToGenerate,
930                                                                         uint earnedSoFarAmount, 
931                                                                         uint percent,
932                                                                         uint interestRate,
933                                                                         uint paidTermCount,
934                                                                         uint isAllPaid,
935                                                                         uint monthCount,
936                                                                         uint earningPerTerm,
937                                                                         uint isCancelled)
938     {
939         TCompoundItem memory item;
940 
941         item = contracts[contractId];
942 
943         return
944         (
945             item.investor,
946             item.tokenCapitalInWei,
947             item.tokenEarningsInWei,
948             item.currentlyEarnedInWei,
949             item.percent,
950             item.interestRate,
951             uint(item.termPaidCount),
952             (item.isAllPaid) ? 1:0,
953             item.contractMonthCount,
954             item.earningPerTermInWei,
955             (item.isCancelled) ? 1:0
956         );
957     }
958     //-------------------------------------------------------------------------
959     function    getCompoundPlan(uint contractId) public constant  returns(uint plan)
960     {
961         return contracts[contractId].plan;
962     }
963 }
964 ////////////////////////////////////////////////////////////////////////////////
965 contract    Token  is  CompoundContract
966 {
967     using SafeMath  for uint256;
968 
969     //--------------------------------------------------------------------------
970     //----- OVERRIDDEN FUNCTION :  "transfer" function from ERC20
971     //----- For this smartcontract we don't deal with a deaLine date.
972     //----- So it's a normally transfer function with no restriction.
973     //----- Restricted tokens are inside the lockedTokens balances, not in ERC20 balances
974     //----- That means people after 3 months can start using their earned tokens
975     //--------------------------------------------------------------------------
976     function transfer(address toAddr, uint256 amountInWei)  public      returns (bool)     // TRANSFER is not restricted during ICO!!!
977     {
978         require(toAddr!=0x0 && toAddr!=msg.sender && amountInWei>0);    // Prevent transfer to 0x0 address and to self, amount must be >0
979 
980         uint256 availableTokens = balances[msg.sender];
981 
982         //----- Checking Token reserve first : if during ICO    
983 
984         if (msg.sender==owner && !isHardcapReached())              // for RegerDiamond : handle reserved supply while ICO is running
985         {
986             assert(amountInWei<=availableTokens);
987 
988             uint256 balanceAfterTransfer = availableTokens.sub(amountInWei);      
989 
990             assert(balanceAfterTransfer >= icoReserveSupply);           // We try to sell more than allowed during an ICO
991         }
992 
993         //-----
994 
995         balances[msg.sender] = balances[msg.sender].sub(amountInWei);
996         balances[toAddr]     = balances[toAddr].add(amountInWei);
997 
998         emit Transfer(msg.sender, toAddr, amountInWei);
999 
1000         return true;
1001     }
1002     //--------------------------------------------------------------------------
1003     //--------------------------------------------------------------------------
1004     //--------------------------------------------------------------------------
1005     //--------------------------------------------------------------------------
1006     //--------------------------------------------------------------------------
1007     function    investFor12Months(address buyerAddress, uint256  amountInWei,
1008                                                           uint256  compoundContractId)
1009                                                 public onlyOwner  
1010                                                 returns(int)
1011     {
1012 
1013         uint    monthCount=12;
1014 
1015         if (!isHardcapReached())
1016         {
1017             if (initCompoundContract(buyerAddress, amountInWei, compoundContractId, monthCount))
1018             {
1019                 if (!lockMoneyOnCompoundCreation(buyerAddress, compoundContractId))      // Now lock the main capital (amountInWei) until the end of the compound
1020                 {
1021                     return -1;
1022                 }
1023             }
1024             else 
1025             {
1026                 return -2; 
1027             }
1028         }
1029         else        // ICO is over.  Use the ERC20 transfer now. Compound is now forbidden. Nothing more to lock 
1030         {
1031             Token.transfer(buyerAddress, amountInWei);
1032             return 2;
1033         }
1034 
1035         return 1;       // -1: could not lock the capital
1036                         // -2: Compound contract creation error
1037                         //  2: ICO is over, coumpounds no more allowed. Standard ERC20 transfer only
1038                         //  1: Compound contract created correctly
1039     }
1040     //--------------------------------------------------------------------------
1041     function    investFor24Months(address buyerAddress, uint256  amountInWei,
1042                                                         uint256  compoundContractId)
1043                                                 public onlyOwner 
1044                                                 returns(int)
1045     {
1046 
1047         uint    monthCount=24;
1048 
1049         if (!isHardcapReached())
1050         {
1051             if (initCompoundContract(buyerAddress, amountInWei, compoundContractId, monthCount))
1052             {
1053                 if (!lockMoneyOnCompoundCreation(buyerAddress, compoundContractId))    // Now lock the main capital (amountInWei) until the end of the compound
1054                 {
1055                     return -1; 
1056                 }
1057             }
1058             else { return -2; }
1059         }
1060         else        // ICO is over.  Use the ERC20 transfer now. Compound is now forbidden. Nothing more to lock 
1061         {
1062             Token.transfer(buyerAddress, amountInWei);
1063             return 2;
1064         }
1065 
1066         return 1;       // -1: could not lock the capital
1067                         // -2: Compound contract creation error
1068                         //  2: ICO is over, coumpounds no more allowed. Standard ERC20 transfer only
1069                         //  1: Compound contract created correctly*/
1070     }
1071     //--------------------------------------------------------------------------
1072     //--------------------------------------------------------------------------
1073     //--------------------------------------------------------------------------
1074     //--------------------------------------------------------------------------
1075 }