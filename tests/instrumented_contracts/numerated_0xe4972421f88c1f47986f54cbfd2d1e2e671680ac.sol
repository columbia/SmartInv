1 pragma solidity ^0.4.21;
2 
3 // File: contracts/DateTime.sol
4 
5 contract DateTime {
6         /*
7          *  Date and Time utilities for ethereum contracts
8          *
9          */
10         struct _DateTime {
11                 uint16 year;
12                 uint8 month;
13                 uint8 day;
14                 uint8 hour;
15                 uint8 minute;
16                 uint8 second;
17                 uint8 weekday;
18         }
19 
20         uint constant DAY_IN_SECONDS = 86400;
21         uint constant YEAR_IN_SECONDS = 31536000;
22         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
23 
24         uint constant HOUR_IN_SECONDS = 3600;
25         uint constant MINUTE_IN_SECONDS = 60;
26 
27         uint16 constant ORIGIN_YEAR = 1970;
28 
29         function isLeapYear(uint16 year) public pure returns (bool) {
30                 if (year % 4 != 0) {
31                         return false;
32                 }
33                 if (year % 100 != 0) {
34                         return true;
35                 }
36                 if (year % 400 != 0) {
37                         return false;
38                 }
39                 return true;
40         }
41 
42         function leapYearsBefore(uint year) public pure returns (uint) {
43                 year -= 1;
44                 return year / 4 - year / 100 + year / 400;
45         }
46 
47         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
48                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
49                         return 31;
50                 }
51                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
52                         return 30;
53                 }
54                 else if (isLeapYear(year)) {
55                         return 29;
56                 }
57                 else {
58                         return 28;
59                 }
60         }
61 
62         function parseTimestamp(uint timestamp) internal pure returns (_DateTime dt) {
63                 uint secondsAccountedFor = 0;
64                 uint buf;
65                 uint8 i;
66 
67                 // Year
68                 dt.year = getYear(timestamp);
69                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
70 
71                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
72                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
73 
74                 // Month
75                 uint secondsInMonth;
76                 for (i = 1; i <= 12; i++) {
77                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
78                         if (secondsInMonth + secondsAccountedFor > timestamp) {
79                                 dt.month = i;
80                                 break;
81                         }
82                         secondsAccountedFor += secondsInMonth;
83                 }
84 
85                 // Day
86                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
87                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
88                                 dt.day = i;
89                                 break;
90                         }
91                         secondsAccountedFor += DAY_IN_SECONDS;
92                 }
93 
94                 // Hour
95                 dt.hour = getHour(timestamp);
96 
97                 // Minute
98                 dt.minute = getMinute(timestamp);
99 
100                 // Second
101                 dt.second = getSecond(timestamp);
102 
103                 // Day of week.
104                 dt.weekday = getWeekday(timestamp);
105         }
106 
107         function getYear(uint timestamp) public pure returns (uint16) {
108                 uint secondsAccountedFor = 0;
109                 uint16 year;
110                 uint numLeapYears;
111 
112                 // Year
113                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
114                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
115 
116                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
117                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
118 
119                 while (secondsAccountedFor > timestamp) {
120                         if (isLeapYear(uint16(year - 1))) {
121                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
122                         }
123                         else {
124                                 secondsAccountedFor -= YEAR_IN_SECONDS;
125                         }
126                         year -= 1;
127                 }
128                 return year;
129         }
130 
131         function getMonth(uint timestamp) public pure returns (uint8) {
132                 return parseTimestamp(timestamp).month;
133         }
134 
135         function getDay(uint timestamp) public pure returns (uint8) {
136                 return parseTimestamp(timestamp).day;
137         }
138 
139         function getHour(uint timestamp) public pure returns (uint8) {
140                 return uint8((timestamp / 60 / 60) % 24);
141         }
142 
143         function getMinute(uint timestamp) public pure returns (uint8) {
144                 return uint8((timestamp / 60) % 60);
145         }
146 
147         function getSecond(uint timestamp) public pure returns (uint8) {
148                 return uint8(timestamp % 60);
149         }
150 
151         function getWeekday(uint timestamp) public pure returns (uint8) {
152                 return uint8((timestamp / DAY_IN_SECONDS + 4) % 7);
153         }
154 
155         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
156                 return toTimestamp(year, month, day, 0, 0, 0);
157         }
158 
159         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour) public pure returns (uint timestamp) {
160                 return toTimestamp(year, month, day, hour, 0, 0);
161         }
162 
163         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute) public pure returns (uint timestamp) {
164                 return toTimestamp(year, month, day, hour, minute, 0);
165         }
166 
167         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
168                 uint16 i;
169 
170                 // Year
171                 for (i = ORIGIN_YEAR; i < year; i++) {
172                         if (isLeapYear(i)) {
173                                 timestamp += LEAP_YEAR_IN_SECONDS;
174                         }
175                         else {
176                                 timestamp += YEAR_IN_SECONDS;
177                         }
178                 }
179 
180                 // Month
181                 uint8[12] memory monthDayCounts;
182                 monthDayCounts[0] = 31;
183                 if (isLeapYear(year)) {
184                         monthDayCounts[1] = 29;
185                 }
186                 else {
187                         monthDayCounts[1] = 28;
188                 }
189                 monthDayCounts[2] = 31;
190                 monthDayCounts[3] = 30;
191                 monthDayCounts[4] = 31;
192                 monthDayCounts[5] = 30;
193                 monthDayCounts[6] = 31;
194                 monthDayCounts[7] = 31;
195                 monthDayCounts[8] = 30;
196                 monthDayCounts[9] = 31;
197                 monthDayCounts[10] = 30;
198                 monthDayCounts[11] = 31;
199 
200                 for (i = 1; i < month; i++) {
201                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
202                 }
203 
204                 // Day
205                 timestamp += DAY_IN_SECONDS * (day - 1);
206 
207                 // Hour
208                 timestamp += HOUR_IN_SECONDS * (hour);
209 
210                 // Minute
211                 timestamp += MINUTE_IN_SECONDS * (minute);
212 
213                 // Second
214                 timestamp += second;
215 
216                 return timestamp;
217         }
218 }
219 
220 // File: contracts/ISimpleCrowdsale.sol
221 
222 interface ISimpleCrowdsale {
223     function getSoftCap() external view returns(uint256);
224     function isContributorInLists(address contributorAddress) external view returns(bool);
225     function processReservationFundContribution(
226         address contributor,
227         uint256 tokenAmount,
228         uint256 tokenBonusAmount
229     ) external payable;
230 }
231 
232 // File: contracts/fund/ICrowdsaleFund.sol
233 
234 /**
235  * @title ICrowdsaleFund
236  * @dev Fund methods used by crowdsale contract
237  */
238 interface ICrowdsaleFund {
239     /**
240     * @dev Function accepts user`s contributed ether and logs contribution
241     * @param contributor Contributor wallet address.
242     */
243     function processContribution(address contributor) external payable;
244     /**
245     * @dev Function is called on the end of successful crowdsale
246     */
247     function onCrowdsaleEnd() external;
248     /**
249     * @dev Function is called if crowdsale failed to reach soft cap
250     */
251     function enableCrowdsaleRefund() external;
252 }
253 
254 // File: contracts/math/SafeMath.sol
255 
256 /**
257  * @title SafeMath
258  * @dev Math operations with safety checks that throw on error
259  */
260 contract SafeMath {
261     /**
262     * @dev constructor
263     */
264     function SafeMath() public {
265     }
266 
267     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
268         uint256 c = a * b;
269         assert(a == 0 || c / a == b);
270         return c;
271     }
272 
273     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
274         uint256 c = a / b;
275         return c;
276     }
277 
278     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
279         assert(a >= b);
280         return a - b;
281     }
282 
283     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
284         uint256 c = a + b;
285         assert(c >= a);
286         return c;
287     }
288 }
289 
290 // File: contracts/ownership/MultiOwnable.sol
291 
292 /**
293  * @title MultiOwnable
294  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
295  * functions, this simplifies the implementation of "users permissions".
296  */
297 contract MultiOwnable {
298     address public manager; // address used to set owners
299     address[] public owners;
300     mapping(address => bool) public ownerByAddress;
301 
302     event SetOwners(address[] owners);
303 
304     modifier onlyOwner() {
305         require(ownerByAddress[msg.sender] == true);
306         _;
307     }
308 
309     /**
310      * @dev MultiOwnable constructor sets the manager
311      */
312     function MultiOwnable() public {
313         manager = msg.sender;
314     }
315 
316     /**
317      * @dev Function to set owners addresses
318      */
319     function setOwners(address[] _owners) public {
320         require(msg.sender == manager);
321         _setOwners(_owners);
322 
323     }
324 
325     function _setOwners(address[] _owners) internal {
326         for(uint256 i = 0; i < owners.length; i++) {
327             ownerByAddress[owners[i]] = false;
328         }
329 
330 
331         for(uint256 j = 0; j < _owners.length; j++) {
332             ownerByAddress[_owners[j]] = true;
333         }
334         owners = _owners;
335         SetOwners(_owners);
336     }
337 
338     function getOwners() public constant returns (address[]) {
339         return owners;
340     }
341 }
342 
343 // File: contracts/token/IERC20Token.sol
344 
345 /**
346  * @title IERC20Token - ERC20 interface
347  * @dev see https://github.com/ethereum/EIPs/issues/20
348  */
349 contract IERC20Token {
350     string public name;
351     string public symbol;
352     uint8 public decimals;
353     uint256 public totalSupply;
354 
355     function balanceOf(address _owner) public constant returns (uint256 balance);
356     function transfer(address _to, uint256 _value)  public returns (bool success);
357     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
358     function approve(address _spender, uint256 _value)  public returns (bool success);
359     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
360 
361     event Transfer(address indexed _from, address indexed _to, uint256 _value);
362     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
363 }
364 
365 // File: contracts/token/ERC20Token.sol
366 
367 /**
368  * @title ERC20Token - ERC20 base implementation
369  * @dev see https://github.com/ethereum/EIPs/issues/20
370  */
371 contract ERC20Token is IERC20Token, SafeMath {
372     mapping (address => uint256) public balances;
373     mapping (address => mapping (address => uint256)) public allowed;
374 
375     function transfer(address _to, uint256 _value) public returns (bool) {
376         require(_to != address(0));
377         require(balances[msg.sender] >= _value);
378 
379         balances[msg.sender] = safeSub(balances[msg.sender], _value);
380         balances[_to] = safeAdd(balances[_to], _value);
381         Transfer(msg.sender, _to, _value);
382         return true;
383     }
384 
385     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
386         require(_to != address(0));
387         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
388 
389         balances[_to] = safeAdd(balances[_to], _value);
390         balances[_from] = safeSub(balances[_from], _value);
391         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
392         Transfer(_from, _to, _value);
393         return true;
394     }
395 
396     function balanceOf(address _owner) public constant returns (uint256) {
397         return balances[_owner];
398     }
399 
400     function approve(address _spender, uint256 _value) public returns (bool) {
401         allowed[msg.sender][_spender] = _value;
402         Approval(msg.sender, _spender, _value);
403         return true;
404     }
405 
406     function allowance(address _owner, address _spender) public constant returns (uint256) {
407       return allowed[_owner][_spender];
408     }
409 }
410 
411 // File: contracts/token/ITokenEventListener.sol
412 
413 /**
414  * @title ITokenEventListener
415  * @dev Interface which should be implemented by token listener
416  */
417 interface ITokenEventListener {
418     /**
419      * @dev Function is called after token transfer/transferFrom
420      * @param _from Sender address
421      * @param _to Receiver address
422      * @param _value Amount of tokens
423      */
424     function onTokenTransfer(address _from, address _to, uint256 _value) external;
425 }
426 
427 // File: contracts/token/ManagedToken.sol
428 
429 /**
430  * @title ManagedToken
431  * @dev ERC20 compatible token with issue and destroy facilities
432  * @dev All transfers can be monitored by token event listener
433  */
434 contract ManagedToken is ERC20Token, MultiOwnable {
435     bool public allowTransfers = false;
436     bool public issuanceFinished = false;
437 
438     ITokenEventListener public eventListener;
439 
440     event AllowTransfersChanged(bool _newState);
441     event Issue(address indexed _to, uint256 _value);
442     event Destroy(address indexed _from, uint256 _value);
443     event IssuanceFinished();
444 
445     modifier transfersAllowed() {
446         require(allowTransfers);
447         _;
448     }
449 
450     modifier canIssue() {
451         require(!issuanceFinished);
452         _;
453     }
454 
455     /**
456      * @dev ManagedToken constructor
457      * @param _listener Token listener(address can be 0x0)
458      * @param _owners Owners list
459      */
460     function ManagedToken(address _listener, address[] _owners) public {
461         if(_listener != address(0)) {
462             eventListener = ITokenEventListener(_listener);
463         }
464         _setOwners(_owners);
465     }
466 
467     /**
468      * @dev Enable/disable token transfers. Can be called only by owners
469      * @param _allowTransfers True - allow False - disable
470      */
471     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
472         allowTransfers = _allowTransfers;
473         AllowTransfersChanged(_allowTransfers);
474     }
475 
476     /**
477      * @dev Set/remove token event listener
478      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
479      */
480     function setListener(address _listener) public onlyOwner {
481         if(_listener != address(0)) {
482             eventListener = ITokenEventListener(_listener);
483         } else {
484             delete eventListener;
485         }
486     }
487 
488     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
489         bool success = super.transfer(_to, _value);
490         if(hasListener() && success) {
491             eventListener.onTokenTransfer(msg.sender, _to, _value);
492         }
493         return success;
494     }
495 
496     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
497         bool success = super.transferFrom(_from, _to, _value);
498         if(hasListener() && success) {
499             eventListener.onTokenTransfer(_from, _to, _value);
500         }
501         return success;
502     }
503 
504     function hasListener() internal view returns(bool) {
505         if(eventListener == address(0)) {
506             return false;
507         }
508         return true;
509     }
510 
511     /**
512      * @dev Issue tokens to specified wallet
513      * @param _to Wallet address
514      * @param _value Amount of tokens
515      */
516     function issue(address _to, uint256 _value) external onlyOwner canIssue {
517         totalSupply = safeAdd(totalSupply, _value);
518         balances[_to] = safeAdd(balances[_to], _value);
519         Issue(_to, _value);
520         Transfer(address(0), _to, _value);
521     }
522 
523     /**
524      * @dev Destroy tokens on specified address (Called by owner or token holder)
525      * @dev Fund contract address must be in the list of owners to burn token during refund
526      * @param _from Wallet address
527      * @param _value Amount of tokens to destroy
528      */
529     function destroy(address _from, uint256 _value) external {
530         require(ownerByAddress[msg.sender] || msg.sender == _from);
531         require(balances[_from] >= _value);
532         totalSupply = safeSub(totalSupply, _value);
533         balances[_from] = safeSub(balances[_from], _value);
534         Transfer(_from, address(0), _value);
535         Destroy(_from, _value);
536     }
537 
538     /**
539      * @dev Increase the amount of tokens that an owner allowed to a spender.
540      *
541      * approve should be called when allowed[_spender] == 0. To increment
542      * allowed value is better to use this function to avoid 2 calls (and wait until
543      * the first transaction is mined)
544      * From OpenZeppelin StandardToken.sol
545      * @param _spender The address which will spend the funds.
546      * @param _addedValue The amount of tokens to increase the allowance by.
547      */
548     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
549         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
550         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
551         return true;
552     }
553 
554     /**
555      * @dev Decrease the amount of tokens that an owner allowed to a spender.
556      *
557      * approve should be called when allowed[_spender] == 0. To decrement
558      * allowed value is better to use this function to avoid 2 calls (and wait until
559      * the first transaction is mined)
560      * From OpenZeppelin StandardToken.sol
561      * @param _spender The address which will spend the funds.
562      * @param _subtractedValue The amount of tokens to decrease the allowance by.
563      */
564     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
565         uint oldValue = allowed[msg.sender][_spender];
566         if (_subtractedValue > oldValue) {
567             allowed[msg.sender][_spender] = 0;
568         } else {
569             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
570         }
571         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
572         return true;
573     }
574 
575     /**
576      * @dev Finish token issuance
577      * @return True if success
578      */
579     function finishIssuance() public onlyOwner returns (bool) {
580         issuanceFinished = true;
581         IssuanceFinished();
582         return true;
583     }
584 }
585 
586 // File: contracts/Fund.sol
587 
588 contract Fund is ICrowdsaleFund, SafeMath, MultiOwnable {
589     enum FundState {
590         Crowdsale,
591         CrowdsaleRefund,
592         TeamWithdraw,
593         Refund
594     }
595 
596     FundState public state = FundState.Crowdsale;
597     ManagedToken public token;
598 
599     uint256 public constant INITIAL_TAP = 192901234567901; // (wei/sec) == 500 ether/month
600 
601     address public teamWallet;
602     uint256 public crowdsaleEndDate;
603 
604     address public referralTokenWallet;
605     address public foundationTokenWallet;
606     address public reserveTokenWallet;
607     address public bountyTokenWallet;
608     address public companyTokenWallet;
609     address public advisorTokenWallet;
610 
611     uint256 public tap;
612     uint256 public lastWithdrawTime = 0;
613     uint256 public firstWithdrawAmount = 0;
614 
615     address public crowdsaleAddress;
616     mapping(address => uint256) public contributions;
617 
618     event RefundContributor(address tokenHolder, uint256 amountWei, uint256 timestamp);
619     event RefundHolder(address tokenHolder, uint256 amountWei, uint256 tokenAmount, uint256 timestamp);
620     event Withdraw(uint256 amountWei, uint256 timestamp);
621     event RefundEnabled(address initiatorAddress);
622 
623     /**
624      * @dev Fund constructor
625      * @param _teamWallet Withdraw functions transfers ether to this address
626      * @param _referralTokenWallet Referral wallet address
627      * @param _companyTokenWallet Company wallet address
628      * @param _reserveTokenWallet Reserve wallet address
629      * @param _bountyTokenWallet Bounty wallet address
630      * @param _advisorTokenWallet Advisor wallet address
631      * @param _owners Contract owners
632      */
633     function Fund(
634         address _teamWallet,
635         address _referralTokenWallet,
636         address _foundationTokenWallet,
637         address _companyTokenWallet,
638         address _reserveTokenWallet,
639         address _bountyTokenWallet,
640         address _advisorTokenWallet,
641         address[] _owners
642     ) public
643     {
644         teamWallet = _teamWallet;
645         referralTokenWallet = _referralTokenWallet;
646         foundationTokenWallet = _foundationTokenWallet;
647         companyTokenWallet = _companyTokenWallet;
648         reserveTokenWallet = _reserveTokenWallet;
649         bountyTokenWallet = _bountyTokenWallet;
650         advisorTokenWallet = _advisorTokenWallet;
651         _setOwners(_owners);
652     }
653 
654     modifier withdrawEnabled() {
655         require(canWithdraw());
656         _;
657     }
658 
659     modifier onlyCrowdsale() {
660         require(msg.sender == crowdsaleAddress);
661         _;
662     }
663 
664     function canWithdraw() public returns(bool);
665 
666     function setCrowdsaleAddress(address _crowdsaleAddress) public onlyOwner {
667         require(crowdsaleAddress == address(0));
668         crowdsaleAddress = _crowdsaleAddress;
669     }
670 
671     function setTokenAddress(address _tokenAddress) public onlyOwner {
672         require(address(token) == address(0));
673         token = ManagedToken(_tokenAddress);
674     }
675 
676     /**
677      * @dev Process crowdsale contribution
678      */
679     function processContribution(address contributor) external payable onlyCrowdsale {
680         require(state == FundState.Crowdsale);
681         uint256 totalContribution = safeAdd(contributions[contributor], msg.value);
682         contributions[contributor] = totalContribution;
683     }
684 
685     /**
686      * @dev Callback is called after crowdsale finalization if soft cap is reached
687      */
688     function onCrowdsaleEnd() external onlyCrowdsale {
689         state = FundState.TeamWithdraw;
690         ISimpleCrowdsale crowdsale = ISimpleCrowdsale(crowdsaleAddress);
691         firstWithdrawAmount = safeDiv(crowdsale.getSoftCap(), 2);
692         lastWithdrawTime = now;
693         tap = INITIAL_TAP;
694         crowdsaleEndDate = now;
695     }
696 
697     /**
698      * @dev Callback is called after crowdsale finalization if soft cap is not reached
699      */
700     function enableCrowdsaleRefund() external onlyCrowdsale {
701         require(state == FundState.Crowdsale);
702         state = FundState.CrowdsaleRefund;
703     }
704 
705     /**
706     * @dev Function is called by contributor to refund payments if crowdsale failed to reach soft cap
707     */
708     function refundCrowdsaleContributor() external {
709         require(state == FundState.CrowdsaleRefund);
710         require(contributions[msg.sender] > 0);
711 
712         uint256 refundAmount = contributions[msg.sender];
713         contributions[msg.sender] = 0;
714         token.destroy(msg.sender, token.balanceOf(msg.sender));
715         msg.sender.transfer(refundAmount);
716         RefundContributor(msg.sender, refundAmount, now);
717     }
718 
719     /**
720      * @dev Decrease tap amount
721      * @param _tap New tap value
722      */
723     function decTap(uint256 _tap) external onlyOwner {
724         require(state == FundState.TeamWithdraw);
725         require(_tap < tap);
726         tap = _tap;
727     }
728 
729     function getCurrentTapAmount() public constant returns(uint256) {
730         if(state != FundState.TeamWithdraw) {
731             return 0;
732         }
733         return calcTapAmount();
734     }
735 
736     function calcTapAmount() internal view returns(uint256) {
737         uint256 amount = safeMul(safeSub(now, lastWithdrawTime), tap);
738         if(address(this).balance < amount) {
739             amount = address(this).balance;
740         }
741         return amount;
742     }
743 
744     function firstWithdraw() public onlyOwner withdrawEnabled {
745         require(firstWithdrawAmount > 0);
746         uint256 amount = firstWithdrawAmount;
747         firstWithdrawAmount = 0;
748         teamWallet.transfer(amount);
749         Withdraw(amount, now);
750     }
751 
752     /**
753      * @dev Withdraw tap amount
754      */
755     function withdraw() public onlyOwner withdrawEnabled {
756         require(state == FundState.TeamWithdraw);
757         uint256 amount = calcTapAmount();
758         lastWithdrawTime = now;
759         teamWallet.transfer(amount);
760         Withdraw(amount, now);
761     }
762 
763     // Refund
764     /**
765      * @dev Called to start refunding
766      */
767     function enableRefund() internal {
768         require(state == FundState.TeamWithdraw);
769         state = FundState.Refund;
770         token.destroy(companyTokenWallet, token.balanceOf(companyTokenWallet));
771         token.destroy(reserveTokenWallet, token.balanceOf(reserveTokenWallet));
772         token.destroy(foundationTokenWallet, token.balanceOf(foundationTokenWallet));
773         token.destroy(bountyTokenWallet, token.balanceOf(bountyTokenWallet));
774         token.destroy(referralTokenWallet, token.balanceOf(referralTokenWallet));
775         token.destroy(advisorTokenWallet, token.balanceOf(advisorTokenWallet));
776         RefundEnabled(msg.sender);
777     }
778 
779     /**
780     * @dev Function is called by contributor to refund
781     * Buy user tokens for refundTokenPrice and destroy them
782     */
783     function refundTokenHolder() public {
784         require(state == FundState.Refund);
785 
786         uint256 tokenBalance = token.balanceOf(msg.sender);
787         require(tokenBalance > 0);
788         uint256 refundAmount = safeDiv(safeMul(tokenBalance, address(this).balance), token.totalSupply());
789         require(refundAmount > 0);
790 
791         token.destroy(msg.sender, tokenBalance);
792         msg.sender.transfer(refundAmount);
793 
794         RefundHolder(msg.sender, refundAmount, tokenBalance, now);
795     }
796 }
797 
798 // File: contracts/fund/IPollManagedFund.sol
799 
800 /**
801  * @title IPollManagedFund
802  * @dev Fund callbacks used by polling contracts
803  */
804 interface IPollManagedFund {
805     /**
806      * @dev TapPoll callback
807      * @param agree True if new tap value is accepted by majority of contributors
808      * @param _tap New tap value
809      */
810     function onTapPollFinish(bool agree, uint256 _tap) external;
811 
812     /**
813      * @dev RefundPoll callback
814      * @param agree True if contributors decided to allow refunding
815      */
816     function onRefundPollFinish(bool agree) external;
817 }
818 
819 // File: contracts/poll/BasePoll.sol
820 
821 /**
822  * @title BasePoll
823  * @dev Abstract base class for polling contracts
824  */
825 contract BasePoll is SafeMath {
826     struct Vote {
827         uint256 time;
828         uint256 weight;
829         bool agree;
830     }
831 
832     uint256 public constant MAX_TOKENS_WEIGHT_DENOM = 1000;
833 
834     IERC20Token public token;
835     address public fundAddress;
836 
837     uint256 public startTime;
838     uint256 public endTime;
839     bool checkTransfersAfterEnd;
840 
841     uint256 public yesCounter = 0;
842     uint256 public noCounter = 0;
843     uint256 public totalVoted = 0;
844 
845     bool public finalized;
846     mapping(address => Vote) public votesByAddress;
847 
848     modifier checkTime() {
849         require(now >= startTime && now <= endTime);
850         _;
851     }
852 
853     modifier notFinalized() {
854         require(!finalized);
855         _;
856     }
857 
858     /**
859      * @dev BasePoll constructor
860      * @param _tokenAddress ERC20 compatible token contract address
861      * @param _fundAddress Fund contract address
862      * @param _startTime Poll start time
863      * @param _endTime Poll end time
864      */
865     function BasePoll(address _tokenAddress, address _fundAddress, uint256 _startTime, uint256 _endTime, bool _checkTransfersAfterEnd) public {
866         require(_tokenAddress != address(0));
867         require(_startTime >= now && _endTime > _startTime);
868 
869         token = IERC20Token(_tokenAddress);
870         fundAddress = _fundAddress;
871         startTime = _startTime;
872         endTime = _endTime;
873         finalized = false;
874         checkTransfersAfterEnd = _checkTransfersAfterEnd;
875     }
876 
877     /**
878      * @dev Process user`s vote
879      * @param agree True if user endorses the proposal else False
880      */
881     function vote(bool agree) public checkTime {
882         require(votesByAddress[msg.sender].time == 0);
883 
884         uint256 voiceWeight = token.balanceOf(msg.sender);
885         uint256 maxVoiceWeight = safeDiv(token.totalSupply(), MAX_TOKENS_WEIGHT_DENOM);
886         voiceWeight =  voiceWeight <= maxVoiceWeight ? voiceWeight : maxVoiceWeight;
887 
888         if(agree) {
889             yesCounter = safeAdd(yesCounter, voiceWeight);
890         } else {
891             noCounter = safeAdd(noCounter, voiceWeight);
892 
893         }
894 
895         votesByAddress[msg.sender].time = now;
896         votesByAddress[msg.sender].weight = voiceWeight;
897         votesByAddress[msg.sender].agree = agree;
898 
899         totalVoted = safeAdd(totalVoted, 1);
900     }
901 
902     /**
903      * @dev Revoke user`s vote
904      */
905     function revokeVote() public checkTime {
906         require(votesByAddress[msg.sender].time > 0);
907 
908         uint256 voiceWeight = votesByAddress[msg.sender].weight;
909         bool agree = votesByAddress[msg.sender].agree;
910 
911         votesByAddress[msg.sender].time = 0;
912         votesByAddress[msg.sender].weight = 0;
913         votesByAddress[msg.sender].agree = false;
914 
915         totalVoted = safeSub(totalVoted, 1);
916         if(agree) {
917             yesCounter = safeSub(yesCounter, voiceWeight);
918         } else {
919             noCounter = safeSub(noCounter, voiceWeight);
920         }
921     }
922 
923     /**
924      * @dev Function is called after token transfer from user`s wallet to check and correct user`s vote
925      *
926      */
927     function onTokenTransfer(address tokenHolder, uint256 amount) public {
928         require(msg.sender == fundAddress);
929         if(votesByAddress[tokenHolder].time == 0) {
930             return;
931         }
932         if(!checkTransfersAfterEnd) {
933              if(finalized || (now < startTime || now > endTime)) {
934                  return;
935              }
936         }
937 
938         if(token.balanceOf(tokenHolder) >= votesByAddress[tokenHolder].weight) {
939             return;
940         }
941         uint256 voiceWeight = amount;
942         if(amount > votesByAddress[tokenHolder].weight) {
943             voiceWeight = votesByAddress[tokenHolder].weight;
944         }
945 
946         if(votesByAddress[tokenHolder].agree) {
947             yesCounter = safeSub(yesCounter, voiceWeight);
948         } else {
949             noCounter = safeSub(noCounter, voiceWeight);
950         }
951         votesByAddress[tokenHolder].weight = safeSub(votesByAddress[tokenHolder].weight, voiceWeight);
952     }
953 
954     /**
955      * Finalize poll and call onPollFinish callback with result
956      */
957     function tryToFinalize() public notFinalized returns(bool) {
958         if(now < endTime) {
959             return false;
960         }
961         finalized = true;
962         onPollFinish(isSubjectApproved());
963         return true;
964     }
965 
966     function isNowApproved() public view returns(bool) {
967         return isSubjectApproved();
968     }
969 
970     function isSubjectApproved() internal view returns(bool) {
971         return yesCounter > noCounter;
972     }
973 
974     /**
975      * @dev callback called after poll finalization
976      */
977     function onPollFinish(bool agree) internal;
978 }
979 
980 // File: contracts/RefundPoll.sol
981 
982 /**
983  * @title RefundPoll
984  * @dev Enables fund refund mode
985  */
986 contract RefundPoll is BasePoll {
987     uint256 public holdEndTime = 0;
988 
989     /**
990      * RefundPoll constructor
991      * @param _tokenAddress ERC20 compatible token contract address
992      * @param _fundAddress Fund contract address
993      * @param _startTime Poll start time
994      * @param _endTime Poll end time
995      */
996     function RefundPoll(
997         address _tokenAddress,
998         address _fundAddress,
999         uint256 _startTime,
1000         uint256 _endTime,
1001         uint256 _holdEndTime,
1002         bool _checkTransfersAfterEnd
1003     ) public
1004         BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, _checkTransfersAfterEnd)
1005     {
1006         holdEndTime = _holdEndTime;
1007     }
1008 
1009     function tryToFinalize() public returns(bool) {
1010         if(holdEndTime > 0 && holdEndTime > endTime) {
1011             require(now >= holdEndTime);
1012         } else {
1013             require(now >= endTime);
1014         }
1015 
1016         finalized = true;
1017         onPollFinish(isSubjectApproved());
1018         return true;
1019     }
1020 
1021     function isSubjectApproved() internal view returns(bool) {
1022         return yesCounter > noCounter && yesCounter >= safeDiv(token.totalSupply(), 3);
1023     }
1024 
1025     function onPollFinish(bool agree) internal {
1026         IPollManagedFund fund = IPollManagedFund(fundAddress);
1027         fund.onRefundPollFinish(agree);
1028     }
1029 
1030 }
1031 
1032 // File: contracts/TapPoll.sol
1033 
1034 /**
1035  * @title TapPoll
1036  * @dev Poll to increase tap amount
1037  */
1038 contract TapPoll is BasePoll {
1039     uint256 public tap;
1040     uint256 public minTokensPerc = 0;
1041 
1042     /**
1043      * TapPoll constructor
1044      * @param _tap New tap value
1045      * @param _tokenAddress ERC20 compatible token contract address
1046      * @param _fundAddress Fund contract address
1047      * @param _startTime Poll start time
1048      * @param _endTime Poll end time
1049      * @param _minTokensPerc - Min percent of tokens from totalSupply where poll is considered to be fulfilled
1050      */
1051     function TapPoll(
1052         uint256 _tap,
1053         address _tokenAddress,
1054         address _fundAddress,
1055         uint256 _startTime,
1056         uint256 _endTime,
1057         uint256 _minTokensPerc
1058     ) public
1059         BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, false)
1060     {
1061         tap = _tap;
1062         minTokensPerc = _minTokensPerc;
1063     }
1064 
1065     function onPollFinish(bool agree) internal {
1066         IPollManagedFund fund = IPollManagedFund(fundAddress);
1067         fund.onTapPollFinish(agree, tap);
1068     }
1069 
1070     function getVotedTokensPerc() public view returns(uint256) {
1071         return safeDiv(safeMul(safeAdd(yesCounter, noCounter), 100), token.totalSupply());
1072     }
1073 
1074     function isSubjectApproved() internal view returns(bool) {
1075         return yesCounter > noCounter && getVotedTokensPerc() >= minTokensPerc;
1076     }
1077 }
1078 
1079 // File: contracts/PollManagedFund.sol
1080 
1081 /**
1082  * @title PollManagedFund
1083  * @dev Fund controlled by users
1084  */
1085 contract PollManagedFund is Fund, DateTime, ITokenEventListener {
1086     uint256 public constant TAP_POLL_DURATION = 3 days;
1087     uint256 public constant REFUND_POLL_DURATION = 7 days;
1088     uint256 public constant MAX_VOTED_TOKEN_PERC = 10;
1089 
1090     TapPoll public tapPoll;
1091     RefundPoll public refundPoll;
1092 
1093     uint256 public minVotedTokensPerc = 0;
1094     uint256 public secondRefundPollDate = 0;
1095     bool public isWithdrawEnabled = true;
1096 
1097     uint256[] public refundPollDates = [
1098         1530403200, // 01.07.2018
1099         1538352000, // 01.10.2018
1100         1546300800, // 01.01.2019
1101         1554076800, // 01.04.2019
1102         1561939200, // 01.07.2019
1103         1569888000, // 01.10.2019
1104         1577836800, // 01.01.2020
1105         1585699200  // 01.04.2020
1106     ];
1107 
1108     modifier onlyTokenHolder() {
1109         require(token.balanceOf(msg.sender) > 0);
1110         _;
1111     }
1112 
1113     event TapPollCreated();
1114     event TapPollFinished(bool approved, uint256 _tap);
1115     event RefundPollCreated();
1116     event RefundPollFinished(bool approved);
1117 
1118     /**
1119      * @dev PollManagedFund constructor
1120      * params - see Fund constructor
1121      */
1122     function PollManagedFund(
1123         address _teamWallet,
1124         address _referralTokenWallet,
1125         address _foundationTokenWallet,
1126         address _companyTokenWallet,
1127         address _reserveTokenWallet,
1128         address _bountyTokenWallet,
1129         address _advisorTokenWallet,
1130         address[] _owners
1131         ) public
1132     Fund(_teamWallet, _referralTokenWallet, _foundationTokenWallet, _companyTokenWallet, _reserveTokenWallet, _bountyTokenWallet, _advisorTokenWallet, _owners)
1133     {
1134     }
1135 
1136     function canWithdraw() public returns(bool) {
1137         if(
1138             address(refundPoll) != address(0) &&
1139             !refundPoll.finalized() &&
1140             refundPoll.holdEndTime() > 0 &&
1141             now >= refundPoll.holdEndTime() &&
1142             refundPoll.isNowApproved()
1143         ) {
1144             return false;
1145         }
1146         return isWithdrawEnabled;
1147     }
1148 
1149     /**
1150      * @dev ITokenEventListener implementation. Notify active poll contracts about token transfers
1151      */
1152     function onTokenTransfer(address _from, address /*_to*/, uint256 _value) external {
1153         require(msg.sender == address(token));
1154         if(address(tapPoll) != address(0) && !tapPoll.finalized()) {
1155             tapPoll.onTokenTransfer(_from, _value);
1156         }
1157          if(address(refundPoll) != address(0) && !refundPoll.finalized()) {
1158             refundPoll.onTokenTransfer(_from, _value);
1159         }
1160     }
1161 
1162     /**
1163      * @dev Update minVotedTokensPerc value after tap poll.
1164      * Set new value == 50% from current voted tokens amount
1165      */
1166     function updateMinVotedTokens(uint256 _minVotedTokensPerc) internal {
1167         uint256 newPerc = safeDiv(_minVotedTokensPerc, 2);
1168         if(newPerc > MAX_VOTED_TOKEN_PERC) {
1169             minVotedTokensPerc = MAX_VOTED_TOKEN_PERC;
1170             return;
1171         }
1172         minVotedTokensPerc = newPerc;
1173     }
1174 
1175     // Tap poll
1176     function createTapPoll(uint8 tapIncPerc) public onlyOwner {
1177         require(state == FundState.TeamWithdraw);
1178         require(tapPoll == address(0));
1179         require(getDay(now) == 10);
1180         require(tapIncPerc <= 50);
1181         uint256 _tap = safeAdd(tap, safeDiv(safeMul(tap, tapIncPerc), 100));
1182         uint256 startTime = now;
1183         uint256 endTime = startTime + TAP_POLL_DURATION;
1184         tapPoll = new TapPoll(_tap, token, this, startTime, endTime, minVotedTokensPerc);
1185         TapPollCreated();
1186     }
1187 
1188     function onTapPollFinish(bool agree, uint256 _tap) external {
1189         require(msg.sender == address(tapPoll) && tapPoll.finalized());
1190         if(agree) {
1191             tap = _tap;
1192         }
1193         updateMinVotedTokens(tapPoll.getVotedTokensPerc());
1194         TapPollFinished(agree, _tap);
1195         delete tapPoll;
1196     }
1197 
1198     // Refund poll
1199     function checkRefundPollDate() internal view returns(bool) {
1200         if(secondRefundPollDate > 0 && now >= secondRefundPollDate && now <= safeAdd(secondRefundPollDate, 1 days)) {
1201             return true;
1202         }
1203 
1204         for(uint i; i < refundPollDates.length; i++) {
1205             if(now >= refundPollDates[i] && now <= safeAdd(refundPollDates[i], 1 days)) {
1206                 return true;
1207             }
1208         }
1209         return false;
1210     }
1211 
1212     function createRefundPoll() public onlyTokenHolder {
1213         require(state == FundState.TeamWithdraw);
1214         require(address(refundPoll) == address(0));
1215         require(checkRefundPollDate());
1216 
1217         if(secondRefundPollDate > 0 && now > safeAdd(secondRefundPollDate, 1 days)) {
1218             secondRefundPollDate = 0;
1219         }
1220 
1221         uint256 startTime = now;
1222         uint256 endTime = startTime + REFUND_POLL_DURATION;
1223         bool isFirstRefund = secondRefundPollDate == 0;
1224         uint256 holdEndTime = 0;
1225 
1226         if(isFirstRefund) {
1227             holdEndTime = toTimestamp(
1228                 getYear(startTime),
1229                 getMonth(startTime) + 1,
1230                 1
1231             );
1232         }
1233         refundPoll = new RefundPoll(token, this, startTime, endTime, holdEndTime, isFirstRefund);
1234         RefundPollCreated();
1235     }
1236 
1237     function onRefundPollFinish(bool agree) external {
1238         require(msg.sender == address(refundPoll) && refundPoll.finalized());
1239         if(agree) {
1240             if(secondRefundPollDate > 0) {
1241                 enableRefund();
1242             } else {
1243                 uint256 startTime = refundPoll.startTime();
1244                 secondRefundPollDate = toTimestamp(
1245                     getYear(startTime),
1246                     getMonth(startTime) + 2,
1247                     1
1248                 );
1249                 isWithdrawEnabled = false;
1250             }
1251         } else {
1252             secondRefundPollDate = 0;
1253             isWithdrawEnabled = true;
1254         }
1255         RefundPollFinished(agree);
1256 
1257         delete refundPoll;
1258     }
1259 
1260     function forceRefund() public onlyOwner {
1261         enableRefund();
1262     }
1263 }