1 pragma solidity ^0.4.25;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 contract DateTimeEnabled {
38         /*
39          *  Date and Time utilities for ethereum contracts
40          *
41          */
42         struct DateTime {
43                 uint16 year;
44                 uint8 month;
45                 uint8 day;
46                 uint8 hour;
47                 uint8 minute;
48                 uint8 second;
49                 uint8 weekday;
50         }
51 
52         uint constant DAY_IN_SECONDS = 86400;
53         uint constant YEAR_IN_SECONDS = 31536000;
54         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
55 
56         uint constant HOUR_IN_SECONDS = 3600;
57         uint constant MINUTE_IN_SECONDS = 60;
58 
59         uint16 constant ORIGIN_YEAR = 1970;
60 
61         function isLeapYear(uint16 year) internal constant returns (bool) {
62                 if (year % 4 != 0) {
63                         return false;
64                 }
65                 if (year % 100 != 0) {
66                         return true;
67                 }
68                 if (year % 400 != 0) {
69                         return false;
70                 }
71                 return true;
72         }
73 
74         function leapYearsBefore(uint year) internal constant returns (uint) {
75                 year -= 1;
76                 return year / 4 - year / 100 + year / 400;
77         }
78 
79         function getDaysInMonth(uint8 month, uint16 year) internal constant returns (uint8) {
80                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
81                         return 31;
82                 }
83                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
84                         return 30;
85                 }
86                 else if (isLeapYear(year)) {
87                         return 29;
88                 }
89                 else {
90                         return 28;
91                 }
92         }
93 
94         function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
95                 uint secondsAccountedFor = 0;
96                 uint buf;
97                 uint8 i;
98 
99                 // Year
100                 dt.year = getYear(timestamp);
101                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
102 
103                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
104                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
105 
106                 // Month
107                 uint secondsInMonth;
108                 for (i = 1; i <= 12; i++) {
109                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
110                         if (secondsInMonth + secondsAccountedFor > timestamp) {
111                                 dt.month = i;
112                                 break;
113                         }
114                         secondsAccountedFor += secondsInMonth;
115                 }
116 
117                 // Day
118                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
119                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
120                                 dt.day = i;
121                                 break;
122                         }
123                         secondsAccountedFor += DAY_IN_SECONDS;
124                 }
125 
126                 // Hour
127                 dt.hour = getHour(timestamp);
128 
129                 // Minute
130                 dt.minute = getMinute(timestamp);
131 
132                 // Second
133                 dt.second = getSecond(timestamp);
134 
135                 // Day of week.
136                 dt.weekday = getWeekday(timestamp);
137         }
138 
139         function getYear(uint timestamp) internal constant returns (uint16) {
140                 uint secondsAccountedFor = 0;
141                 uint16 year;
142                 uint numLeapYears;
143 
144                 // Year
145                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
146                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
147 
148                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
149                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
150 
151                 while (secondsAccountedFor > timestamp) {
152                         if (isLeapYear(uint16(year - 1))) {
153                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
154                         }
155                         else {
156                                 secondsAccountedFor -= YEAR_IN_SECONDS;
157                         }
158                         year -= 1;
159                 }
160                 return year;
161         }
162 
163         function getMonth(uint timestamp) internal constant returns (uint8) {
164                 return parseTimestamp(timestamp).month;
165         }
166 
167         function getDay(uint timestamp) internal constant returns (uint8) {
168                 return parseTimestamp(timestamp).day;
169         }
170 
171         function getHour(uint timestamp) internal constant returns (uint8) {
172                 return uint8((timestamp / 60 / 60) % 24);
173         }
174 
175         function getMinute(uint timestamp) internal constant returns (uint8) {
176                 return uint8((timestamp / 60) % 60);
177         }
178 
179         function getSecond(uint timestamp) internal constant returns (uint8) {
180                 return uint8(timestamp % 60);
181         }
182 
183         function getWeekday(uint timestamp) internal constant returns (uint8) {
184                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
185         }
186 
187         function toTimestamp(uint16 year, uint8 month, uint8 day) internal constant returns (uint timestamp) {
188                 return toTimestamp(year, month, day, 0, 0, 0);
189         }
190 
191         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) internal constant returns (uint timestamp) {
192                 return toTimestamp(year, month, day, hour, 0, 0);
193         }
194 
195         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) internal constant returns (uint timestamp) {
196                 return toTimestamp(year, month, day, hour, minute, 0);
197         }
198 
199         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) internal constant returns (uint timestamp) {
200                 uint16 i;
201 
202                 // Year
203                 for (i = ORIGIN_YEAR; i < year; i++) {
204                         if (isLeapYear(i)) {
205                                 timestamp += LEAP_YEAR_IN_SECONDS;
206                         }
207                         else {
208                                 timestamp += YEAR_IN_SECONDS;
209                         }
210                 }
211 
212                 // Month
213                 uint8[12] memory monthDayCounts;
214                 monthDayCounts[0] = 31;
215                 if (isLeapYear(year)) {
216                         monthDayCounts[1] = 29;
217                 }
218                 else {
219                         monthDayCounts[1] = 28;
220                 }
221                 monthDayCounts[2] = 31;
222                 monthDayCounts[3] = 30;
223                 monthDayCounts[4] = 31;
224                 monthDayCounts[5] = 30;
225                 monthDayCounts[6] = 31;
226                 monthDayCounts[7] = 31;
227                 monthDayCounts[8] = 30;
228                 monthDayCounts[9] = 31;
229                 monthDayCounts[10] = 30;
230                 monthDayCounts[11] = 31;
231 
232                 for (i = 1; i < month; i++) {
233                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
234                 }
235 
236                 // Day
237                 timestamp += DAY_IN_SECONDS * (day - 1);
238 
239                 // Hour
240                 timestamp += HOUR_IN_SECONDS * (hour);
241 
242                 // Minute
243                 timestamp += MINUTE_IN_SECONDS * (minute);
244 
245                 // Second
246                 timestamp += second;
247 
248                 return timestamp;
249         }
250         
251         function addDaystoTimeStamp(uint16 _daysToBeAdded) internal  returns(uint){
252             return now + DAY_IN_SECONDS*_daysToBeAdded;
253         }
254 
255         function addMinutestoTimeStamp(uint8 _minutesToBeAdded) internal  returns(uint){
256             return now + MINUTE_IN_SECONDS*_minutesToBeAdded;
257         }
258 
259 
260         function printDatestamp(uint timestamp) internal returns (uint16,uint8,uint8,uint8,uint8,uint8) {
261             DateTime memory dt;
262             dt = parseTimestamp(timestamp);
263             return (dt.year,dt.month,dt.day,dt.hour,dt.minute,dt.second);
264         }
265         
266         function currentTimeStamp() internal returns (uint) {
267             return now;
268         }
269 }
270 
271 
272 contract ERC20 {
273     function totalSupply() view public returns (uint _totalSupply);
274     function balanceOf(address _owner) view public returns (uint balance);
275     function transfer(address _to, uint _value) public returns (bool success);
276     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
277     function approve(address _spender, uint _value) public returns (bool success);
278     function allowance(address _owner, address _spender) view public returns (uint remaining);
279     event Transfer(address indexed _from, address indexed _to, uint _value);
280     event Approval(address indexed _owner, address indexed _spender, uint _value);
281 }
282 
283 
284 contract BaseToken is ERC20 {
285     
286     address public owner;
287     using SafeMath for uint256;
288     
289     bool public tokenStatus = false;
290     
291     modifier ownerOnly(){
292         require(msg.sender == owner);
293         _;
294     }
295 
296     
297     modifier onlyWhenTokenIsOn(){
298         require(tokenStatus == true);
299         _;
300     }
301 
302 
303     function onOff () ownerOnly external{
304         tokenStatus = !tokenStatus;    
305     }
306 
307 
308     /**
309        * @dev Fix for the ERC20 short address attack.
310     */
311     modifier onlyPayloadSize(uint size) {
312         require(msg.data.length >= size + 4);
313         _;
314     }    
315     mapping (address => uint256) public balances;
316     mapping(address => mapping(address => uint256)) allowed;
317 
318     //Token Details
319     string public symbol = "BASE";
320     string public name = "Base Token";
321     uint8 public decimals = 18;
322 
323     uint256 public totalSupply; //will be instantiated in the derived Contracts
324     
325     function totalSupply() view public returns (uint256 ){
326         return totalSupply;
327     }
328 
329 
330     function balanceOf(address _owner) view public returns (uint balance){
331         return balances[_owner];
332     }
333     
334     function transfer(address _to, uint _value) onlyWhenTokenIsOn onlyPayloadSize(2 * 32) public returns (bool success){
335         //_value = _value.mul(1e18);
336         require(
337             balances[msg.sender]>=_value 
338             && _value > 0);
339             balances[msg.sender] = balances[msg.sender].sub(_value);
340             balances[_to] = balances[_to].add(_value);
341             emit Transfer(msg.sender,_to,_value);
342             return true;
343     }
344     
345     function transferFrom(address _from, address _to, uint _value) onlyWhenTokenIsOn onlyPayloadSize(3 * 32) public returns (bool success){
346         //_value = _value.mul(10**decimals);
347         require(
348             allowed[_from][msg.sender]>= _value
349             && balances[_from] >= _value
350             && _value >0 
351             );
352         balances[_from] = balances[_from].sub(_value);
353         balances[_to] = balances[_to].add(_value);
354         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
355         emit Transfer(_from, _to, _value);
356         return true;
357             
358     }
359     
360     function approve(address _spender, uint _value) onlyWhenTokenIsOn public returns (bool success){
361         //_value = _value.mul(10**decimals);
362         allowed[msg.sender][_spender] = _value;
363         emit Approval(msg.sender, _spender, _value);
364         return true;
365     }
366     
367     function allowance(address _owner, address _spender) view public returns (uint remaining){
368         return allowed[_owner][_spender];
369     }
370 
371     
372     event Transfer(address indexed _from, address indexed _to, uint256 _value);
373     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
374     
375 
376 }
377 
378 
379 
380 
381 contract ICO is BaseToken,DateTimeEnabled{
382 
383     uint256 base = 10;
384     uint256 multiplier;
385 
386     address ownerMultisig;
387 
388     struct ICOPhase {
389         string phaseName;
390         uint256 tokensStaged;
391         uint256 tokensAllocated;
392         uint256 iRate;
393         uint256 fRate;
394         uint256 intialTime;
395         uint256 closingTime;
396        // uint256 RATE;
397         bool saleOn;
398         uint deadline;
399     }
400 
401     uint8 public currentICOPhase;
402     
403     mapping(address=>uint256) public ethContributedBy;
404     uint256 public totalEthRaised;
405     uint256 public totalTokensSoldTillNow;
406 
407     mapping(uint8=>ICOPhase) public icoPhases;
408     uint8 icoPhasesIndex=1;
409     
410     function getEthContributedBy(address _address) view public returns(uint256){
411         return ethContributedBy[_address];
412     }
413 
414     function getTotalEthRaised() view public returns(uint256){
415         return totalEthRaised;
416     }
417 
418     function getTotalTokensSoldTillNow() view public returns(uint256){
419         return totalTokensSoldTillNow;
420     }
421 
422     
423     function addICOPhase(string _phaseName,uint256 _tokensStaged,uint256 _iRate, uint256 _fRate,uint256 _intialTime,uint256 _closingTime) ownerOnly public{
424         icoPhases[icoPhasesIndex].phaseName = _phaseName;
425         icoPhases[icoPhasesIndex].tokensStaged = _tokensStaged;
426         icoPhases[icoPhasesIndex].iRate = _iRate;
427         icoPhases[icoPhasesIndex].fRate = _fRate;
428         icoPhases[icoPhasesIndex].intialTime = _intialTime;
429         icoPhases[icoPhasesIndex].closingTime = _closingTime;
430         icoPhases[icoPhasesIndex].tokensAllocated = 0;
431         icoPhases[icoPhasesIndex].saleOn = false;
432         //icoPhases[icoPhasesIndex].deadline = _deadline;
433         icoPhasesIndex++;
434     }
435 
436     function toggleSaleStatus() ownerOnly external{
437         icoPhases[currentICOPhase].saleOn = !icoPhases[currentICOPhase].saleOn;
438     }
439     function changefRate(uint256 _fRate) ownerOnly external{
440         icoPhases[currentICOPhase].fRate = _fRate;
441     }
442     function changeCurrentICOPhase(uint8 _newPhase) ownerOnly external{ //Only provided for exception handling in case some faulty phase has been added by the owner using addICOPhase
443         currentICOPhase = _newPhase;
444     }
445 
446     function changeCurrentPhaseDeadline(uint8 _numdays) ownerOnly external{
447         icoPhases[currentICOPhase].closingTime= addDaystoTimeStamp(_numdays); //adds number of days to now and that becomes the new deadline
448     }
449     
450     function transferOwnership(address newOwner) ownerOnly external{
451         if (newOwner != address(0)) {
452           owner = newOwner;
453         }
454     }
455     
456 }
457 contract MultiRound is ICO{
458     function newICORound(uint256 _newSupply) ownerOnly public{//This is different from Stages which means multiple parts of one round
459         _newSupply = _newSupply.mul(multiplier);
460         balances[owner] = balances[owner].add(_newSupply);
461         totalSupply = totalSupply.add(_newSupply);
462     }
463 
464     function destroyUnsoldTokens(uint256 _tokens) ownerOnly public{
465         _tokens = _tokens.mul(multiplier);
466         totalSupply = totalSupply.sub(_tokens);
467         balances[owner] = balances[owner].sub(_tokens);
468     }
469 
470     
471 }
472 
473 contract ReferralEnabledToken is BaseToken{
474 
475     
476     struct referral {
477         address referrer;
478         uint8 referrerPerc;// this is the percentage referrer will get in ETH. 
479         uint8 refereePerc; // this is the discount Refereee will get 
480     }
481 
482     struct redeemedReferral {
483         address referee;
484         uint timestamp;
485         uint ethContributed;
486         uint rewardGained;
487     }
488     mapping(address=>referral) public referrals;
489     
490     uint8 public currentReferralRewardPercentage=10;
491     uint8 public currentReferralDiscountPercentage=10;
492     
493     mapping(address=>uint256) public totalEthRewards;
494     mapping(address=>mapping(uint16=>redeemedReferral)) referrerRewards;
495     mapping(address=>uint16) referrerRewardIndex;
496     
497     function totalEthRewards(address _address) view public returns(uint256){
498         totalEthRewards[_address];
499     }
500     
501     function createReferral(address _referrer, address _referree) public returns (bool) {
502         require(_referrer != _referree);
503         require (referrals[_referree].referrer == address(0) || referrals[_referree].referrer==msg.sender);
504         referrals[_referree].referrer = _referrer;
505         referrals[_referree].referrerPerc = currentReferralRewardPercentage;
506         referrals[_referree].refereePerc = currentReferralDiscountPercentage;
507         return true;
508     }
509     
510     function getReferrerRewards(address _referrer, uint16 _index) view public returns(address,uint,uint,uint){
511         redeemedReferral r = referrerRewards[_referrer][_index];
512         return(r.referee,r.timestamp,r.ethContributed,r.rewardGained);
513     }
514     
515     function getReferrerIndex(address _referrer) view public returns(uint16) {
516         return(referrerRewardIndex[_referrer]);
517     }
518     
519     
520     function getReferrerTotalRewards(address _referrer) view public returns(uint){
521         return (totalEthRewards[_referrer]);
522     }
523     
524     function getReferral(address _refereeId) constant public returns(address,uint8,uint8) {
525         referral memory r = referrals[_refereeId];
526         return(r.referrer,r.referrerPerc,r.refereePerc);
527     } 
528 
529     function changeReferralPerc(uint8 _newPerc) ownerOnly external{
530         currentReferralRewardPercentage = _newPerc;
531     }
532 
533     function changeRefereePerc(uint8 _newPerc) ownerOnly external{
534         currentReferralDiscountPercentage = _newPerc;
535     }
536 }
537 contract killable is ICO {
538     
539     function killContract() ownerOnly external{
540         selfdestruct(ownerMultisig);
541     }
542 }
543 //TODO - ADD Total ETH raised and Record token wise contribution    
544 contract RefineMediumToken is ICO,killable,MultiRound,ReferralEnabledToken  {
545  //   uint256 intialTime = 1542043381;
546  //   uint256 closingTime = 1557681781;
547     uint256 constant alloc1perc=50; //TEAM ALLOCATION
548     address constant alloc1Acc = 0xF0B50870e5d01FbfE783F6e76994A0BA94d34fe9; //CORETEAM Address (test-TestRPC4)
549 
550     uint256 constant alloc2perc=50;//in percent -- ADVISORS ALLOCATION
551     address constant alloc2Acc = 0x3c3daEd0733cDBB26c298443Cec93c48426CC4Bd; //TestRPC5
552 
553     uint256 constant alloc3perc=50;//in percent -- Bounty Allocation
554     address constant alloc3Acc = 0xAc5c102B4063615053C29f9B4DC8001D529037Cd; //TestRPC6
555 
556     uint256 constant alloc4perc=50;//in percent -- Reserved LEAVE IT TO ZERO IF NO MORE ALLOCATIONS ARE THERE
557     address constant alloc4Acc = 0xf080966E970AC351A9D576846915bBE049Fe98dB; //TestRPC7
558 
559     address constant ownerMultisig = 0xc4010efafaf53be13498efcffa04df931dc1592a; //Test4
560     mapping(address=>uint) blockedTill;    
561 
562     constructor() public{
563         symbol = "XRM";
564         name = "Refine Medium Token";
565         decimals = 18;
566         multiplier=base**decimals;
567 
568         totalSupply = 300000000*multiplier;//300 mn-- extra 18 zeroes are for the wallets which use decimal variable to show the balance 
569         owner = msg.sender;
570 
571         balances[owner]=totalSupply;
572         currentICOPhase = 1;
573         addICOPhase("Private Sale",15000000*multiplier,1550,1550,1558742400,1560556800);
574         runAllocations();
575     }
576 
577     function runAllocations() ownerOnly public{
578         balances[owner]=((1000-(alloc1perc+alloc2perc+alloc3perc+alloc4perc))*totalSupply)/1000;
579         
580         balances[alloc1Acc]=(alloc1perc*totalSupply)/1000;
581         blockedTill[alloc1Acc] = addDaystoTimeStamp(2);
582         
583         balances[alloc2Acc]=(alloc2perc*totalSupply)/1000;
584         blockedTill[alloc2Acc] = addDaystoTimeStamp(2);
585         
586         balances[alloc3Acc]=(alloc3perc*totalSupply)/1000;
587         blockedTill[alloc3Acc] = addDaystoTimeStamp(2);
588         
589         balances[alloc4Acc]=(alloc4perc*totalSupply)/1000;
590         blockedTill[alloc4Acc] = addDaystoTimeStamp(2);
591         
592     }
593 
594     function showRate(uint256 _epoch) public view returns (uint256){
595          ICOPhase storage i = icoPhases[currentICOPhase];
596          uint256 epoch = _epoch.sub(i.intialTime);
597          uint256 timeRange = i.closingTime.sub(i.intialTime);
598          uint256 rateRange = i.iRate.sub(i.fRate);
599          return (i.iRate*100000000000).sub((epoch.mul(rateRange)*100000000000).div(timeRange));
600     }
601     function currentRate() public view returns (uint256){
602          ICOPhase storage i = icoPhases[currentICOPhase];
603          uint256 epoch = now.sub(i.intialTime);
604          uint256 timeRange = i.closingTime.sub(i.intialTime);
605          uint256 rateRange = i.iRate.sub(i.fRate);
606          return ((i.iRate*100000000000).sub((epoch.mul(rateRange)*100000000000).div(timeRange)))/100000000000;
607     }
608     function () payable public{
609         createTokens();
610     }   
611 
612     
613     function createTokens() payable public{
614         ICOPhase storage i = icoPhases[currentICOPhase]; 
615         require(msg.value > 0
616             && i.saleOn == true);
617         
618         uint256 totalreferrerPerc = 0;
619         
620        // uint256 tokens = msg.value.mul((i.RATE*(100+r.refereePerc))/100);
621        uint256 tokens =   msg.value.mul((currentRate()*(100+r.refereePerc))/100);
622         balances[owner] = balances[owner].sub(tokens);
623         balances[msg.sender] = balances[msg.sender].add(tokens);
624         i.tokensAllocated = i.tokensAllocated.add(tokens);
625         totalTokensSoldTillNow = totalTokensSoldTillNow.add(tokens); 
626         
627         ethContributedBy[msg.sender] = ethContributedBy[msg.sender].add(msg.value);
628         totalEthRaised = totalEthRaised.add(msg.value);
629         referral storage r = referrals[msg.sender];
630         uint8 counter = 1;
631         while(r.referrer != 0 && counter <= 2){
632                        
633             counter = counter + 1;            
634             
635             uint16 currIndex = referrerRewardIndex[r.referrer] + 1;
636             uint rewardGained = (r.referrerPerc*msg.value)/100;
637             referrerRewardIndex[r.referrer] = currIndex;
638             referrerRewards[r.referrer][currIndex].referee = msg.sender;
639             referrerRewards[r.referrer][currIndex].timestamp = now;
640             referrerRewards[r.referrer][currIndex].ethContributed = msg.value;
641             referrerRewards[r.referrer][currIndex].rewardGained = rewardGained ;
642             totalEthRewards[r.referrer] = totalEthRewards[r.referrer].add(rewardGained);
643             r.referrer.transfer(rewardGained);
644                 
645             totalreferrerPerc = totalreferrerPerc + r.referrerPerc;
646             r = referrals[r.referrer];
647             
648         }
649         ownerMultisig.transfer(((100-totalreferrerPerc)*msg.value)/100);
650 
651         //Token Disbursement
652 
653         
654         if(i.tokensAllocated>=i.tokensStaged){
655             i.saleOn = !i.saleOn; 
656             currentICOPhase++;
657         }
658         
659     }
660     
661     
662     
663     function transfer(address _to, uint _value) onlyWhenTokenIsOn onlyPayloadSize(2 * 32) public returns (bool success){
664         //_value = _value.mul(1e18);
665         require(
666             balances[msg.sender]>=_value 
667             && _value > 0
668             && now > blockedTill[msg.sender]
669         );
670         balances[msg.sender] = balances[msg.sender].sub(_value);
671         balances[_to] = balances[_to].add(_value);
672         emit Transfer(msg.sender,_to,_value);
673         return true;
674     }
675     
676     function transferFrom(address _from, address _to, uint _value) onlyWhenTokenIsOn onlyPayloadSize(3 * 32) public returns (bool success){
677         //_value = _value.mul(10**decimals);
678         require(
679             allowed[_from][msg.sender]>= _value
680             && balances[_from] >= _value
681             && _value >0 
682             && now > blockedTill[_from]            
683         );
684 
685         balances[_from] = balances[_from].sub(_value);
686         balances[_to] = balances[_to].add(_value);
687         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
688         emit Transfer(_from, _to, _value);
689         return true;
690             
691     }
692     event Burn(address indexed _burner, uint _value);
693     function burn(uint _value) ownerOnly returns (bool)
694     {
695         balances[msg.sender] = balances[msg.sender].sub(_value);
696         totalSupply = totalSupply.sub(_value);
697         emit Burn(msg.sender, _value);
698         emit Transfer(msg.sender, address(0x0), _value);
699         return true;
700     }
701      event Mint(address indexed to, uint256 amount);
702     event MintFinished();
703 
704      bool public mintingFinished = false;
705 
706 
707      modifier canMint() {
708      require(!mintingFinished);
709      _;
710    }
711     function mint(address _to, uint256 _amount) ownerOnly canMint public returns (bool) {
712     totalSupply = totalSupply.add(_amount);
713     balances[_to] = balances[_to].add(_amount);
714     emit Mint(_to, _amount);
715     emit Transfer(address(0), _to, _amount);
716     return true;
717   }
718 
719   /**
720    * @dev Function to stop minting new tokens.
721    * @return True if the operation was successful.
722    */
723   function finishMinting() ownerOnly canMint public returns (bool) {
724     mintingFinished = true;
725     emit MintFinished();
726     return true;
727   }
728     
729 }