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
610     address public lockedTokenAddress;
611     address public refundManager;
612 
613     uint256 public tap;
614     uint256 public lastWithdrawTime = 0;
615     uint256 public firstWithdrawAmount = 0;
616 
617     address public crowdsaleAddress;
618     mapping(address => uint256) public contributions;
619 
620     event RefundContributor(address tokenHolder, uint256 amountWei, uint256 timestamp);
621     event RefundHolder(address tokenHolder, uint256 amountWei, uint256 tokenAmount, uint256 timestamp);
622     event Withdraw(uint256 amountWei, uint256 timestamp);
623     event RefundEnabled(address initiatorAddress);
624 
625     /**
626      * @dev Fund constructor
627      * @param _teamWallet Withdraw functions transfers ether to this address
628      * @param _referralTokenWallet Referral wallet address
629      * @param _companyTokenWallet Company wallet address
630      * @param _reserveTokenWallet Reserve wallet address
631      * @param _bountyTokenWallet Bounty wallet address
632      * @param _advisorTokenWallet Advisor wallet address
633      * @param _owners Contract owners
634      */
635     function Fund(
636         address _teamWallet,
637         address _referralTokenWallet,
638         address _foundationTokenWallet,
639         address _companyTokenWallet,
640         address _reserveTokenWallet,
641         address _bountyTokenWallet,
642         address _advisorTokenWallet,
643         address _refundManager,
644         address[] _owners
645     ) public
646     {
647         teamWallet = _teamWallet;
648         referralTokenWallet = _referralTokenWallet;
649         foundationTokenWallet = _foundationTokenWallet;
650         companyTokenWallet = _companyTokenWallet;
651         reserveTokenWallet = _reserveTokenWallet;
652         bountyTokenWallet = _bountyTokenWallet;
653         advisorTokenWallet = _advisorTokenWallet;
654         refundManager = _refundManager;
655         _setOwners(_owners);
656     }
657 
658     modifier withdrawEnabled() {
659         require(canWithdraw());
660         _;
661     }
662 
663     modifier onlyCrowdsale() {
664         require(msg.sender == crowdsaleAddress);
665         _;
666     }
667 
668     function canWithdraw() public returns(bool);
669 
670     function setCrowdsaleAddress(address _crowdsaleAddress) public onlyOwner {
671         require(crowdsaleAddress == address(0));
672         crowdsaleAddress = _crowdsaleAddress;
673     }
674 
675     function setTokenAddress(address _tokenAddress) public onlyOwner {
676         require(address(token) == address(0));
677         token = ManagedToken(_tokenAddress);
678     }
679 
680     function setLockedTokenAddress(address _lockedTokenAddress) public onlyOwner {
681         require(address(lockedTokenAddress) == address(0));
682         lockedTokenAddress = _lockedTokenAddress;
683     }
684 
685     /**
686      * @dev Process crowdsale contribution
687      */
688     function processContribution(address contributor) external payable onlyCrowdsale {
689         require(state == FundState.Crowdsale);
690         uint256 totalContribution = safeAdd(contributions[contributor], msg.value);
691         contributions[contributor] = totalContribution;
692     }
693 
694     /**
695      * @dev Callback is called after crowdsale finalization if soft cap is reached
696      */
697     function onCrowdsaleEnd() external onlyCrowdsale {
698         state = FundState.TeamWithdraw;
699         ISimpleCrowdsale crowdsale = ISimpleCrowdsale(crowdsaleAddress);
700         firstWithdrawAmount = safeDiv(crowdsale.getSoftCap(), 2);
701         lastWithdrawTime = now;
702         tap = INITIAL_TAP;
703         crowdsaleEndDate = now;
704     }
705 
706     /**
707      * @dev Callback is called after crowdsale finalization if soft cap is not reached
708      */
709     function enableCrowdsaleRefund() external onlyCrowdsale {
710         require(state == FundState.Crowdsale);
711         state = FundState.CrowdsaleRefund;
712     }
713 
714     /**
715     * @dev Function is called by contributor to refund payments if crowdsale failed to reach soft cap
716     */
717     function refundCrowdsaleContributor() external {
718         require(state == FundState.CrowdsaleRefund);
719         require(contributions[msg.sender] > 0);
720 
721         uint256 refundAmount = contributions[msg.sender];
722         contributions[msg.sender] = 0;
723         token.destroy(msg.sender, token.balanceOf(msg.sender));
724         msg.sender.transfer(refundAmount);
725         RefundContributor(msg.sender, refundAmount, now);
726     }
727 
728     /**
729     * @dev Function is called by owner to refund payments if crowdsale failed to reach soft cap
730     */
731     function autoRefundCrowdsaleContributor(address contributorAddress) external {
732         require(ownerByAddress[msg.sender] == true || msg.sender == refundManager);
733         require(state == FundState.CrowdsaleRefund);
734         require(contributions[contributorAddress] > 0);
735 
736         uint256 refundAmount = contributions[contributorAddress];
737         contributions[contributorAddress] = 0;
738         token.destroy(contributorAddress, token.balanceOf(contributorAddress));
739         contributorAddress.transfer(refundAmount);
740         RefundContributor(contributorAddress, refundAmount, now);
741     }
742 
743     /**
744      * @dev Decrease tap amount
745      * @param _tap New tap value
746      */
747     function decTap(uint256 _tap) external onlyOwner {
748         require(state == FundState.TeamWithdraw);
749         require(_tap < tap);
750         tap = _tap;
751     }
752 
753     function getCurrentTapAmount() public constant returns(uint256) {
754         if(state != FundState.TeamWithdraw) {
755             return 0;
756         }
757         return calcTapAmount();
758     }
759 
760     function calcTapAmount() internal view returns(uint256) {
761         uint256 amount = safeMul(safeSub(now, lastWithdrawTime), tap);
762         if(address(this).balance < amount) {
763             amount = address(this).balance;
764         }
765         return amount;
766     }
767 
768     function firstWithdraw() public onlyOwner withdrawEnabled {
769         require(firstWithdrawAmount > 0);
770         uint256 amount = firstWithdrawAmount;
771         firstWithdrawAmount = 0;
772         teamWallet.transfer(amount);
773         Withdraw(amount, now);
774     }
775 
776     /**
777      * @dev Withdraw tap amount
778      */
779     function withdraw() public onlyOwner withdrawEnabled {
780         require(state == FundState.TeamWithdraw);
781         uint256 amount = calcTapAmount();
782         lastWithdrawTime = now;
783         teamWallet.transfer(amount);
784         Withdraw(amount, now);
785     }
786 
787     // Refund
788     /**
789      * @dev Called to start refunding
790      */
791     function enableRefund() internal {
792         require(state == FundState.TeamWithdraw);
793         state = FundState.Refund;
794         token.destroy(lockedTokenAddress, token.balanceOf(lockedTokenAddress));
795         token.destroy(companyTokenWallet, token.balanceOf(companyTokenWallet));
796         token.destroy(reserveTokenWallet, token.balanceOf(reserveTokenWallet));
797         token.destroy(foundationTokenWallet, token.balanceOf(foundationTokenWallet));
798         token.destroy(bountyTokenWallet, token.balanceOf(bountyTokenWallet));
799         token.destroy(referralTokenWallet, token.balanceOf(referralTokenWallet));
800         token.destroy(advisorTokenWallet, token.balanceOf(advisorTokenWallet));
801         RefundEnabled(msg.sender);
802     }
803 
804     /**
805     * @dev Function is called by contributor to refund
806     * Buy user tokens for refundTokenPrice and destroy them
807     */
808     function refundTokenHolder() public {
809         require(state == FundState.Refund);
810 
811         uint256 tokenBalance = token.balanceOf(msg.sender);
812         require(tokenBalance > 0);
813         uint256 refundAmount = safeDiv(safeMul(tokenBalance, address(this).balance), token.totalSupply());
814         require(refundAmount > 0);
815 
816         token.destroy(msg.sender, tokenBalance);
817         msg.sender.transfer(refundAmount);
818 
819         RefundHolder(msg.sender, refundAmount, tokenBalance, now);
820     }
821 }
822 
823 // File: contracts/fund/IPollManagedFund.sol
824 
825 /**
826  * @title IPollManagedFund
827  * @dev Fund callbacks used by polling contracts
828  */
829 interface IPollManagedFund {
830     /**
831      * @dev TapPoll callback
832      * @param agree True if new tap value is accepted by majority of contributors
833      * @param _tap New tap value
834      */
835     function onTapPollFinish(bool agree, uint256 _tap) external;
836 
837     /**
838      * @dev RefundPoll callback
839      * @param agree True if contributors decided to allow refunding
840      */
841     function onRefundPollFinish(bool agree) external;
842 }
843 
844 // File: contracts/poll/BasePoll.sol
845 
846 /**
847  * @title BasePoll
848  * @dev Abstract base class for polling contracts
849  */
850 contract BasePoll is SafeMath {
851     struct Vote {
852         uint256 time;
853         uint256 weight;
854         bool agree;
855     }
856 
857     uint256 public constant MAX_TOKENS_WEIGHT_DENOM = 1000;
858 
859     IERC20Token public token;
860     address public fundAddress;
861 
862     uint256 public startTime;
863     uint256 public endTime;
864     bool checkTransfersAfterEnd;
865 
866     uint256 public yesCounter = 0;
867     uint256 public noCounter = 0;
868     uint256 public totalVoted = 0;
869 
870     bool public finalized;
871     mapping(address => Vote) public votesByAddress;
872 
873     modifier checkTime() {
874         require(now >= startTime && now <= endTime);
875         _;
876     }
877 
878     modifier notFinalized() {
879         require(!finalized);
880         _;
881     }
882 
883     /**
884      * @dev BasePoll constructor
885      * @param _tokenAddress ERC20 compatible token contract address
886      * @param _fundAddress Fund contract address
887      * @param _startTime Poll start time
888      * @param _endTime Poll end time
889      */
890     function BasePoll(address _tokenAddress, address _fundAddress, uint256 _startTime, uint256 _endTime, bool _checkTransfersAfterEnd) public {
891         require(_tokenAddress != address(0));
892         require(_startTime >= now && _endTime > _startTime);
893 
894         token = IERC20Token(_tokenAddress);
895         fundAddress = _fundAddress;
896         startTime = _startTime;
897         endTime = _endTime;
898         finalized = false;
899         checkTransfersAfterEnd = _checkTransfersAfterEnd;
900     }
901 
902     /**
903      * @dev Process user`s vote
904      * @param agree True if user endorses the proposal else False
905      */
906     function vote(bool agree) public checkTime {
907         require(votesByAddress[msg.sender].time == 0);
908 
909         uint256 voiceWeight = token.balanceOf(msg.sender);
910         uint256 maxVoiceWeight = safeDiv(token.totalSupply(), MAX_TOKENS_WEIGHT_DENOM);
911         voiceWeight =  voiceWeight <= maxVoiceWeight ? voiceWeight : maxVoiceWeight;
912 
913         if(agree) {
914             yesCounter = safeAdd(yesCounter, voiceWeight);
915         } else {
916             noCounter = safeAdd(noCounter, voiceWeight);
917 
918         }
919 
920         votesByAddress[msg.sender].time = now;
921         votesByAddress[msg.sender].weight = voiceWeight;
922         votesByAddress[msg.sender].agree = agree;
923 
924         totalVoted = safeAdd(totalVoted, 1);
925     }
926 
927     /**
928      * @dev Revoke user`s vote
929      */
930     function revokeVote() public checkTime {
931         require(votesByAddress[msg.sender].time > 0);
932 
933         uint256 voiceWeight = votesByAddress[msg.sender].weight;
934         bool agree = votesByAddress[msg.sender].agree;
935 
936         votesByAddress[msg.sender].time = 0;
937         votesByAddress[msg.sender].weight = 0;
938         votesByAddress[msg.sender].agree = false;
939 
940         totalVoted = safeSub(totalVoted, 1);
941         if(agree) {
942             yesCounter = safeSub(yesCounter, voiceWeight);
943         } else {
944             noCounter = safeSub(noCounter, voiceWeight);
945         }
946     }
947 
948     /**
949      * @dev Function is called after token transfer from user`s wallet to check and correct user`s vote
950      *
951      */
952     function onTokenTransfer(address tokenHolder, uint256 amount) public {
953         require(msg.sender == fundAddress);
954         if(votesByAddress[tokenHolder].time == 0) {
955             return;
956         }
957         if(!checkTransfersAfterEnd) {
958              if(finalized || (now < startTime || now > endTime)) {
959                  return;
960              }
961         }
962 
963         if(token.balanceOf(tokenHolder) >= votesByAddress[tokenHolder].weight) {
964             return;
965         }
966         uint256 voiceWeight = amount;
967         if(amount > votesByAddress[tokenHolder].weight) {
968             voiceWeight = votesByAddress[tokenHolder].weight;
969         }
970 
971         if(votesByAddress[tokenHolder].agree) {
972             yesCounter = safeSub(yesCounter, voiceWeight);
973         } else {
974             noCounter = safeSub(noCounter, voiceWeight);
975         }
976         votesByAddress[tokenHolder].weight = safeSub(votesByAddress[tokenHolder].weight, voiceWeight);
977     }
978 
979     /**
980      * Finalize poll and call onPollFinish callback with result
981      */
982     function tryToFinalize() public notFinalized returns(bool) {
983         if(now < endTime) {
984             return false;
985         }
986         finalized = true;
987         onPollFinish(isSubjectApproved());
988         return true;
989     }
990 
991     function isNowApproved() public view returns(bool) {
992         return isSubjectApproved();
993     }
994 
995     function isSubjectApproved() internal view returns(bool) {
996         return yesCounter > noCounter;
997     }
998 
999     /**
1000      * @dev callback called after poll finalization
1001      */
1002     function onPollFinish(bool agree) internal;
1003 }
1004 
1005 // File: contracts/RefundPoll.sol
1006 
1007 /**
1008  * @title RefundPoll
1009  * @dev Enables fund refund mode
1010  */
1011 contract RefundPoll is BasePoll {
1012     uint256 public holdEndTime = 0;
1013 
1014     /**
1015      * RefundPoll constructor
1016      * @param _tokenAddress ERC20 compatible token contract address
1017      * @param _fundAddress Fund contract address
1018      * @param _startTime Poll start time
1019      * @param _endTime Poll end time
1020      */
1021     function RefundPoll(
1022         address _tokenAddress,
1023         address _fundAddress,
1024         uint256 _startTime,
1025         uint256 _endTime,
1026         uint256 _holdEndTime,
1027         bool _checkTransfersAfterEnd
1028     ) public
1029         BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, _checkTransfersAfterEnd)
1030     {
1031         holdEndTime = _holdEndTime;
1032     }
1033 
1034     function tryToFinalize() public returns(bool) {
1035         if(holdEndTime > 0 && holdEndTime > endTime) {
1036             require(now >= holdEndTime);
1037         } else {
1038             require(now >= endTime);
1039         }
1040 
1041         finalized = true;
1042         onPollFinish(isSubjectApproved());
1043         return true;
1044     }
1045 
1046     function isSubjectApproved() internal view returns(bool) {
1047         return yesCounter > noCounter && yesCounter >= safeDiv(token.totalSupply(), 3);
1048     }
1049 
1050     function onPollFinish(bool agree) internal {
1051         IPollManagedFund fund = IPollManagedFund(fundAddress);
1052         fund.onRefundPollFinish(agree);
1053     }
1054 
1055 }
1056 
1057 // File: contracts/TapPoll.sol
1058 
1059 /**
1060  * @title TapPoll
1061  * @dev Poll to increase tap amount
1062  */
1063 contract TapPoll is BasePoll {
1064     uint256 public tap;
1065     uint256 public minTokensPerc = 0;
1066 
1067     /**
1068      * TapPoll constructor
1069      * @param _tap New tap value
1070      * @param _tokenAddress ERC20 compatible token contract address
1071      * @param _fundAddress Fund contract address
1072      * @param _startTime Poll start time
1073      * @param _endTime Poll end time
1074      * @param _minTokensPerc - Min percent of tokens from totalSupply where poll is considered to be fulfilled
1075      */
1076     function TapPoll(
1077         uint256 _tap,
1078         address _tokenAddress,
1079         address _fundAddress,
1080         uint256 _startTime,
1081         uint256 _endTime,
1082         uint256 _minTokensPerc
1083     ) public
1084         BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, false)
1085     {
1086         tap = _tap;
1087         minTokensPerc = _minTokensPerc;
1088     }
1089 
1090     function onPollFinish(bool agree) internal {
1091         IPollManagedFund fund = IPollManagedFund(fundAddress);
1092         fund.onTapPollFinish(agree, tap);
1093     }
1094 
1095     function getVotedTokensPerc() public view returns(uint256) {
1096         return safeDiv(safeMul(safeAdd(yesCounter, noCounter), 100), token.totalSupply());
1097     }
1098 
1099     function isSubjectApproved() internal view returns(bool) {
1100         return yesCounter > noCounter && getVotedTokensPerc() >= minTokensPerc;
1101     }
1102 }
1103 
1104 // File: contracts/PollManagedFund.sol
1105 
1106 /**
1107  * @title PollManagedFund
1108  * @dev Fund controlled by users
1109  */
1110 contract PollManagedFund is Fund, DateTime, ITokenEventListener {
1111     uint256 public constant TAP_POLL_DURATION = 3 days;
1112     uint256 public constant REFUND_POLL_DURATION = 7 days;
1113     uint256 public constant MAX_VOTED_TOKEN_PERC = 10;
1114 
1115     TapPoll public tapPoll;
1116     RefundPoll public refundPoll;
1117 
1118     uint256 public minVotedTokensPerc = 0;
1119     uint256 public secondRefundPollDate = 0;
1120     bool public isWithdrawEnabled = true;
1121 
1122     uint256[] public refundPollDates = [
1123         1530403200, // 01.07.2018
1124         1538352000, // 01.10.2018
1125         1546300800, // 01.01.2019
1126         1554076800, // 01.04.2019
1127         1561939200, // 01.07.2019
1128         1569888000, // 01.10.2019
1129         1577836800, // 01.01.2020
1130         1585699200  // 01.04.2020
1131     ];
1132 
1133     modifier onlyTokenHolder() {
1134         require(token.balanceOf(msg.sender) > 0);
1135         _;
1136     }
1137 
1138     event TapPollCreated();
1139     event TapPollFinished(bool approved, uint256 _tap);
1140     event RefundPollCreated();
1141     event RefundPollFinished(bool approved);
1142 
1143     /**
1144      * @dev PollManagedFund constructor
1145      * params - see Fund constructor
1146      */
1147     function PollManagedFund(
1148         address _teamWallet,
1149         address _referralTokenWallet,
1150         address _foundationTokenWallet,
1151         address _companyTokenWallet,
1152         address _reserveTokenWallet,
1153         address _bountyTokenWallet,
1154         address _advisorTokenWallet,
1155         address _refundManager,
1156         address[] _owners
1157         ) public
1158     Fund(_teamWallet, _referralTokenWallet, _foundationTokenWallet, _companyTokenWallet, _reserveTokenWallet, _bountyTokenWallet, _advisorTokenWallet, _refundManager, _owners)
1159     {
1160     }
1161 
1162     function canWithdraw() public returns(bool) {
1163         if(
1164             address(refundPoll) != address(0) &&
1165             !refundPoll.finalized() &&
1166             refundPoll.holdEndTime() > 0 &&
1167             now >= refundPoll.holdEndTime() &&
1168             refundPoll.isNowApproved()
1169         ) {
1170             return false;
1171         }
1172         return isWithdrawEnabled;
1173     }
1174 
1175     /**
1176      * @dev ITokenEventListener implementation. Notify active poll contracts about token transfers
1177      */
1178     function onTokenTransfer(address _from, address /*_to*/, uint256 _value) external {
1179         require(msg.sender == address(token));
1180         if(address(tapPoll) != address(0) && !tapPoll.finalized()) {
1181             tapPoll.onTokenTransfer(_from, _value);
1182         }
1183          if(address(refundPoll) != address(0) && !refundPoll.finalized()) {
1184             refundPoll.onTokenTransfer(_from, _value);
1185         }
1186     }
1187 
1188     /**
1189      * @dev Update minVotedTokensPerc value after tap poll.
1190      * Set new value == 50% from current voted tokens amount
1191      */
1192     function updateMinVotedTokens(uint256 _minVotedTokensPerc) internal {
1193         uint256 newPerc = safeDiv(_minVotedTokensPerc, 2);
1194         if(newPerc > MAX_VOTED_TOKEN_PERC) {
1195             minVotedTokensPerc = MAX_VOTED_TOKEN_PERC;
1196             return;
1197         }
1198         minVotedTokensPerc = newPerc;
1199     }
1200 
1201     // Tap poll
1202     function createTapPoll(uint8 tapIncPerc) public onlyOwner {
1203         require(state == FundState.TeamWithdraw);
1204         require(tapPoll == address(0));
1205         require(getDay(now) == 10);
1206         require(tapIncPerc <= 50);
1207         uint256 _tap = safeAdd(tap, safeDiv(safeMul(tap, tapIncPerc), 100));
1208         uint256 startTime = now;
1209         uint256 endTime = startTime + TAP_POLL_DURATION;
1210         tapPoll = new TapPoll(_tap, token, this, startTime, endTime, minVotedTokensPerc);
1211         TapPollCreated();
1212     }
1213 
1214     function onTapPollFinish(bool agree, uint256 _tap) external {
1215         require(msg.sender == address(tapPoll) && tapPoll.finalized());
1216         if(agree) {
1217             tap = _tap;
1218         }
1219         updateMinVotedTokens(tapPoll.getVotedTokensPerc());
1220         TapPollFinished(agree, _tap);
1221         delete tapPoll;
1222     }
1223 
1224     // Refund poll
1225     function checkRefundPollDate() internal view returns(bool) {
1226         if(secondRefundPollDate > 0 && now >= secondRefundPollDate && now <= safeAdd(secondRefundPollDate, 1 days)) {
1227             return true;
1228         }
1229 
1230         for(uint i; i < refundPollDates.length; i++) {
1231             if(now >= refundPollDates[i] && now <= safeAdd(refundPollDates[i], 1 days)) {
1232                 return true;
1233             }
1234         }
1235         return false;
1236     }
1237 
1238     function createRefundPoll() public onlyTokenHolder {
1239         require(state == FundState.TeamWithdraw);
1240         require(address(refundPoll) == address(0));
1241         require(checkRefundPollDate());
1242 
1243         if(secondRefundPollDate > 0 && now > safeAdd(secondRefundPollDate, 1 days)) {
1244             secondRefundPollDate = 0;
1245         }
1246 
1247         uint256 startTime = now;
1248         uint256 endTime = startTime + REFUND_POLL_DURATION;
1249         bool isFirstRefund = secondRefundPollDate == 0;
1250         uint256 holdEndTime = 0;
1251 
1252         if(isFirstRefund) {
1253             holdEndTime = toTimestamp(
1254                 getYear(startTime),
1255                 getMonth(startTime) + 1,
1256                 1
1257             );
1258         }
1259         refundPoll = new RefundPoll(token, this, startTime, endTime, holdEndTime, isFirstRefund);
1260         RefundPollCreated();
1261     }
1262 
1263     function onRefundPollFinish(bool agree) external {
1264         require(msg.sender == address(refundPoll) && refundPoll.finalized());
1265         if(agree) {
1266             if(secondRefundPollDate > 0) {
1267                 enableRefund();
1268             } else {
1269                 uint256 startTime = refundPoll.startTime();
1270                 secondRefundPollDate = toTimestamp(
1271                     getYear(startTime),
1272                     getMonth(startTime) + 2,
1273                     1
1274                 );
1275                 isWithdrawEnabled = false;
1276             }
1277         } else {
1278             secondRefundPollDate = 0;
1279             isWithdrawEnabled = true;
1280         }
1281         RefundPollFinished(agree);
1282 
1283         delete refundPoll;
1284     }
1285 
1286     function forceRefund() public {
1287         require(msg.sender == refundManager);
1288         enableRefund();
1289     }
1290 }