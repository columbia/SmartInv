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
224 }
225 
226 // File: contracts/fund/ICrowdsaleFund.sol
227 
228 /**
229  * @title ICrowdsaleFund
230  * @dev Fund methods used by crowdsale contract
231  */
232 interface ICrowdsaleFund {
233     /**
234     * @dev Function accepts user`s contributed ether and logs contribution
235     * @param contributor Contributor wallet address.
236     */
237     function processContribution(address contributor) external payable;
238     /**
239     * @dev Function is called on the end of successful crowdsale
240     */
241     function onCrowdsaleEnd() external;
242     /**
243     * @dev Function is called if crowdsale failed to reach soft cap
244     */
245     function enableCrowdsaleRefund() external;
246 }
247 
248 // File: contracts/math/SafeMath.sol
249 
250 /**
251  * @title SafeMath
252  * @dev Math operations with safety checks that throw on error
253  */
254 contract SafeMath {
255     /**
256     * @dev constructor
257     */
258     function SafeMath() public {
259     }
260 
261     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
262         uint256 c = a * b;
263         assert(a == 0 || c / a == b);
264         return c;
265     }
266 
267     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
268         uint256 c = a / b;
269         return c;
270     }
271 
272     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
273         assert(a >= b);
274         return a - b;
275     }
276 
277     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
278         uint256 c = a + b;
279         assert(c >= a);
280         return c;
281     }
282 }
283 
284 // File: contracts/ownership/MultiOwnable.sol
285 
286 /**
287  * @title MultiOwnable
288  * @dev The MultiOwnable contract has owners addresses and provides basic authorization control
289  * functions, this simplifies the implementation of "users permissions".
290  */
291 contract MultiOwnable {
292     address public manager; // address used to set owners
293     address[] public owners;
294     mapping(address => bool) public ownerByAddress;
295 
296     event SetOwners(address[] owners);
297 
298     modifier onlyOwner() {
299         require(ownerByAddress[msg.sender] == true);
300         _;
301     }
302 
303     /**
304      * @dev MultiOwnable constructor sets the manager
305      */
306     function MultiOwnable() public {
307         manager = msg.sender;
308     }
309 
310     /**
311      * @dev Function to set owners addresses
312      */
313     function setOwners(address[] _owners) public {
314         require(msg.sender == manager);
315         _setOwners(_owners);
316 
317     }
318 
319     function _setOwners(address[] _owners) internal {
320         for(uint256 i = 0; i < owners.length; i++) {
321             ownerByAddress[owners[i]] = false;
322         }
323 
324 
325         for(uint256 j = 0; j < _owners.length; j++) {
326             ownerByAddress[_owners[j]] = true;
327         }
328         owners = _owners;
329         SetOwners(_owners);
330     }
331 
332     function getOwners() public constant returns (address[]) {
333         return owners;
334     }
335 }
336 
337 // File: contracts/token/IERC20Token.sol
338 
339 /**
340  * @title IERC20Token - ERC20 interface
341  * @dev see https://github.com/ethereum/EIPs/issues/20
342  */
343 contract IERC20Token {
344     string public name;
345     string public symbol;
346     uint8 public decimals;
347     uint256 public totalSupply;
348 
349     function balanceOf(address _owner) public constant returns (uint256 balance);
350     function transfer(address _to, uint256 _value)  public returns (bool success);
351     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
352     function approve(address _spender, uint256 _value)  public returns (bool success);
353     function allowance(address _owner, address _spender)  public constant returns (uint256 remaining);
354 
355     event Transfer(address indexed _from, address indexed _to, uint256 _value);
356     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
357 }
358 
359 // File: contracts/token/ERC20Token.sol
360 
361 /**
362  * @title ERC20Token - ERC20 base implementation
363  * @dev see https://github.com/ethereum/EIPs/issues/20
364  */
365 contract ERC20Token is IERC20Token, SafeMath {
366     mapping (address => uint256) public balances;
367     mapping (address => mapping (address => uint256)) public allowed;
368 
369     function transfer(address _to, uint256 _value) public returns (bool) {
370         require(_to != address(0));
371         require(balances[msg.sender] >= _value);
372 
373         balances[msg.sender] = safeSub(balances[msg.sender], _value);
374         balances[_to] = safeAdd(balances[_to], _value);
375         Transfer(msg.sender, _to, _value);
376         return true;
377     }
378 
379     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
380         require(_to != address(0));
381         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
382 
383         balances[_to] = safeAdd(balances[_to], _value);
384         balances[_from] = safeSub(balances[_from], _value);
385         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
386         Transfer(_from, _to, _value);
387         return true;
388     }
389 
390     function balanceOf(address _owner) public constant returns (uint256) {
391         return balances[_owner];
392     }
393 
394     function approve(address _spender, uint256 _value) public returns (bool) {
395         allowed[msg.sender][_spender] = _value;
396         Approval(msg.sender, _spender, _value);
397         return true;
398     }
399 
400     function allowance(address _owner, address _spender) public constant returns (uint256) {
401       return allowed[_owner][_spender];
402     }
403 }
404 
405 // File: contracts/token/ITokenEventListener.sol
406 
407 /**
408  * @title ITokenEventListener
409  * @dev Interface which should be implemented by token listener
410  */
411 interface ITokenEventListener {
412     /**
413      * @dev Function is called after token transfer/transferFrom
414      * @param _from Sender address
415      * @param _to Receiver address
416      * @param _value Amount of tokens
417      */
418     function onTokenTransfer(address _from, address _to, uint256 _value) external;
419 }
420 
421 // File: contracts/token/ManagedToken.sol
422 
423 /**
424  * @title ManagedToken
425  * @dev ERC20 compatible token with issue and destroy facilities
426  * @dev All transfers can be monitored by token event listener
427  */
428 contract ManagedToken is ERC20Token, MultiOwnable {
429     bool public allowTransfers = false;
430     bool public issuanceFinished = false;
431 
432     ITokenEventListener public eventListener;
433 
434     event AllowTransfersChanged(bool _newState);
435     event Issue(address indexed _to, uint256 _value);
436     event Destroy(address indexed _from, uint256 _value);
437     event IssuanceFinished();
438 
439     modifier transfersAllowed() {
440         require(allowTransfers);
441         _;
442     }
443 
444     modifier canIssue() {
445         require(!issuanceFinished);
446         _;
447     }
448 
449     /**
450      * @dev ManagedToken constructor
451      * @param _listener Token listener(address can be 0x0)
452      * @param _owners Owners list
453      */
454     function ManagedToken(address _listener, address[] _owners) public {
455         if(_listener != address(0)) {
456             eventListener = ITokenEventListener(_listener);
457         }
458         _setOwners(_owners);
459     }
460 
461     /**
462      * @dev Enable/disable token transfers. Can be called only by owners
463      * @param _allowTransfers True - allow False - disable
464      */
465     function setAllowTransfers(bool _allowTransfers) external onlyOwner {
466         allowTransfers = _allowTransfers;
467         AllowTransfersChanged(_allowTransfers);
468     }
469 
470     /**
471      * @dev Set/remove token event listener
472      * @param _listener Listener address (Contract must implement ITokenEventListener interface)
473      */
474     function setListener(address _listener) public onlyOwner {
475         if(_listener != address(0)) {
476             eventListener = ITokenEventListener(_listener);
477         } else {
478             delete eventListener;
479         }
480     }
481 
482     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool) {
483         bool success = super.transfer(_to, _value);
484         if(hasListener() && success) {
485             eventListener.onTokenTransfer(msg.sender, _to, _value);
486         }
487         return success;
488     }
489 
490     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool) {
491         bool success = super.transferFrom(_from, _to, _value);
492         if(hasListener() && success) {
493             eventListener.onTokenTransfer(_from, _to, _value);
494         }
495         return success;
496     }
497 
498     function hasListener() internal view returns(bool) {
499         if(eventListener == address(0)) {
500             return false;
501         }
502         return true;
503     }
504 
505     /**
506      * @dev Issue tokens to specified wallet
507      * @param _to Wallet address
508      * @param _value Amount of tokens
509      */
510     function issue(address _to, uint256 _value) external onlyOwner canIssue {
511         totalSupply = safeAdd(totalSupply, _value);
512         balances[_to] = safeAdd(balances[_to], _value);
513         Issue(_to, _value);
514         Transfer(address(0), _to, _value);
515     }
516 
517     /**
518      * @dev Destroy tokens on specified address (Called by owner or token holder)
519      * @dev Fund contract address must be in the list of owners to burn token during refund
520      * @param _from Wallet address
521      * @param _value Amount of tokens to destroy
522      */
523     function destroy(address _from, uint256 _value) external {
524         require(ownerByAddress[msg.sender] || msg.sender == _from);
525         require(balances[_from] >= _value);
526         totalSupply = safeSub(totalSupply, _value);
527         balances[_from] = safeSub(balances[_from], _value);
528         Transfer(_from, address(0), _value);
529         Destroy(_from, _value);
530     }
531 
532     /**
533      * @dev Increase the amount of tokens that an owner allowed to a spender.
534      *
535      * approve should be called when allowed[_spender] == 0. To increment
536      * allowed value is better to use this function to avoid 2 calls (and wait until
537      * the first transaction is mined)
538      * From OpenZeppelin StandardToken.sol
539      * @param _spender The address which will spend the funds.
540      * @param _addedValue The amount of tokens to increase the allowance by.
541      */
542     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
543         allowed[msg.sender][_spender] = safeAdd(allowed[msg.sender][_spender], _addedValue);
544         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
545         return true;
546     }
547 
548     /**
549      * @dev Decrease the amount of tokens that an owner allowed to a spender.
550      *
551      * approve should be called when allowed[_spender] == 0. To decrement
552      * allowed value is better to use this function to avoid 2 calls (and wait until
553      * the first transaction is mined)
554      * From OpenZeppelin StandardToken.sol
555      * @param _spender The address which will spend the funds.
556      * @param _subtractedValue The amount of tokens to decrease the allowance by.
557      */
558     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
559         uint oldValue = allowed[msg.sender][_spender];
560         if (_subtractedValue > oldValue) {
561             allowed[msg.sender][_spender] = 0;
562         } else {
563             allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue);
564         }
565         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
566         return true;
567     }
568 
569     /**
570      * @dev Finish token issuance
571      * @return True if success
572      */
573     function finishIssuance() public onlyOwner returns (bool) {
574         issuanceFinished = true;
575         IssuanceFinished();
576         return true;
577     }
578 }
579 
580 // File: contracts/Fund.sol
581 
582 contract Fund is ICrowdsaleFund, SafeMath, MultiOwnable {
583     enum FundState {
584         Crowdsale,
585         CrowdsaleRefund,
586         TeamWithdraw,
587         Refund
588     }
589 
590     FundState public state = FundState.Crowdsale;
591     ManagedToken public token;
592 
593     uint256 public constant INITIAL_TAP = 192901234567901; // (wei/sec) == 500 ether/month
594 
595     address public teamWallet;
596     uint256 public crowdsaleEndDate;
597 
598     address public mainSaleTokenWallet;
599     address public foundationTokenWallet;
600     address public marketingTokenWallet;
601     address public teamTokenWallet;
602     address public advisorTokenWallet;
603     address public lockedTokenAddress;
604     address public refundManager;
605 
606     uint256 public tap;
607     uint256 public lastWithdrawTime = 0;
608     uint256 public firstWithdrawAmount = 0;
609 
610     address public crowdsaleAddress;
611     mapping(address => uint256) public contributions;
612 
613     event RefundContributor(address tokenHolder, uint256 amountWei, uint256 timestamp);
614     event RefundHolder(address tokenHolder, uint256 amountWei, uint256 tokenAmount, uint256 timestamp);
615     event Withdraw(uint256 amountWei, uint256 timestamp);
616     event RefundEnabled(address initiatorAddress);
617 
618     /**
619      * @dev Fund constructor
620      * @param _teamWallet Withdraw functions transfers ether to this address
621      * @param _mainSaleTokenWallet Main sale wallet address
622      * @param _teamTokenWallet Team wallet address
623      * @param _marketingTokenWallet Bounty wallet address
624      * @param _advisorTokenWallet Advisor wallet address
625      * @param _owners Contract owners
626      */
627     function Fund(
628         address _teamWallet,
629         address _mainSaleTokenWallet,
630         address _foundationTokenWallet,
631         address _teamTokenWallet,
632         address _marketingTokenWallet,
633         address _advisorTokenWallet,
634         address _refundManager,
635         address[] _owners
636     ) public
637     {
638         teamWallet = _teamWallet;
639         mainSaleTokenWallet = _mainSaleTokenWallet;
640         foundationTokenWallet = _foundationTokenWallet;
641         teamTokenWallet = _teamTokenWallet;
642         marketingTokenWallet = _marketingTokenWallet;
643         advisorTokenWallet = _advisorTokenWallet;
644         refundManager = _refundManager;
645         _setOwners(_owners);
646     }
647 
648     modifier withdrawEnabled() {
649         require(canWithdraw());
650         _;
651     }
652 
653     modifier onlyCrowdsale() {
654         require(msg.sender == crowdsaleAddress);
655         _;
656     }
657 
658     function canWithdraw() public returns(bool);
659 
660     function setCrowdsaleAddress(address _crowdsaleAddress) public onlyOwner {
661         require(crowdsaleAddress == address(0));
662         crowdsaleAddress = _crowdsaleAddress;
663     }
664 
665     function setTokenAddress(address _tokenAddress) public onlyOwner {
666         require(address(token) == address(0));
667         token = ManagedToken(_tokenAddress);
668     }
669 
670     function setLockedTokenAddress(address _lockedTokenAddress) public onlyOwner {
671         require(address(lockedTokenAddress) == address(0));
672         lockedTokenAddress = _lockedTokenAddress;
673     }
674 
675     /**
676      * @dev Process crowdsale contribution
677      */
678     function processContribution(address contributor) external payable onlyCrowdsale {
679         require(state == FundState.Crowdsale);
680         uint256 totalContribution = safeAdd(contributions[contributor], msg.value);
681         contributions[contributor] = totalContribution;
682     }
683 
684     /**
685      * @dev Callback is called after crowdsale finalization if soft cap is reached
686      */
687     function onCrowdsaleEnd() external onlyCrowdsale {
688         state = FundState.TeamWithdraw;
689         ISimpleCrowdsale crowdsale = ISimpleCrowdsale(crowdsaleAddress);
690         firstWithdrawAmount = crowdsale.getSoftCap();
691         lastWithdrawTime = now;
692         tap = INITIAL_TAP;
693         crowdsaleEndDate = now;
694     }
695 
696     /**
697      * @dev Callback is called after crowdsale finalization if soft cap is not reached
698      */
699     function enableCrowdsaleRefund() external onlyCrowdsale {
700         require(state == FundState.Crowdsale);
701         state = FundState.CrowdsaleRefund;
702     }
703 
704     /**
705     * @dev Function is called by contributor to refund payments if crowdsale failed to reach soft cap
706     */
707     function refundCrowdsaleContributor() external {
708         require(state == FundState.CrowdsaleRefund);
709         require(contributions[msg.sender] > 0);
710 
711         uint256 refundAmount = contributions[msg.sender];
712         contributions[msg.sender] = 0;
713         token.destroy(msg.sender, token.balanceOf(msg.sender));
714         msg.sender.transfer(refundAmount);
715         RefundContributor(msg.sender, refundAmount, now);
716     }
717 
718     /**
719     * @dev Function is called by owner to refund payments if crowdsale failed to reach soft cap
720     */
721     function autoRefundCrowdsaleContributor(address contributorAddress) external {
722         require(ownerByAddress[msg.sender] == true || msg.sender == refundManager);
723         require(state == FundState.CrowdsaleRefund);
724         require(contributions[contributorAddress] > 0);
725 
726         uint256 refundAmount = contributions[contributorAddress];
727         contributions[contributorAddress] = 0;
728         token.destroy(contributorAddress, token.balanceOf(contributorAddress));
729         contributorAddress.transfer(refundAmount);
730         RefundContributor(contributorAddress, refundAmount, now);
731     }
732 
733     /**
734      * @dev Decrease tap amount
735      * @param _tap New tap value
736      */
737     function decTap(uint256 _tap) external onlyOwner {
738         require(state == FundState.TeamWithdraw);
739         require(_tap < tap);
740         tap = _tap;
741     }
742 
743     function getCurrentTapAmount() public constant returns(uint256) {
744         if(state != FundState.TeamWithdraw) {
745             return 0;
746         }
747         return calcTapAmount();
748     }
749 
750     function calcTapAmount() internal view returns(uint256) {
751         uint256 amount = safeMul(safeSub(now, lastWithdrawTime), tap);
752         if(address(this).balance < amount) {
753             amount = address(this).balance;
754         }
755         return amount;
756     }
757 
758     function firstWithdraw() public onlyOwner withdrawEnabled {
759         require(firstWithdrawAmount > 0);
760         uint256 amount = firstWithdrawAmount;
761         firstWithdrawAmount = 0;
762         teamWallet.transfer(amount);
763         Withdraw(amount, now);
764     }
765 
766     /**
767      * @dev Withdraw tap amount
768      */
769     function withdraw() public onlyOwner withdrawEnabled {
770         require(state == FundState.TeamWithdraw);
771         uint256 amount = calcTapAmount();
772         lastWithdrawTime = now;
773         teamWallet.transfer(amount);
774         Withdraw(amount, now);
775     }
776 
777     // Refund
778     /**
779      * @dev Called to start refunding
780      */
781     function enableRefund() internal {
782         require(state == FundState.TeamWithdraw);
783         state = FundState.Refund;
784         token.destroy(lockedTokenAddress, token.balanceOf(lockedTokenAddress));
785         token.destroy(teamTokenWallet, token.balanceOf(teamTokenWallet));
786         token.destroy(foundationTokenWallet, token.balanceOf(foundationTokenWallet));
787         token.destroy(marketingTokenWallet, token.balanceOf(marketingTokenWallet));
788         token.destroy(mainSaleTokenWallet, token.balanceOf(mainSaleTokenWallet));
789         token.destroy(advisorTokenWallet, token.balanceOf(advisorTokenWallet));
790         RefundEnabled(msg.sender);
791     }
792 
793     /**
794     * @dev Function is called by contributor to refund
795     * Buy user tokens for refundTokenPrice and destroy them
796     */
797     function refundTokenHolder() public {
798         require(state == FundState.Refund);
799 
800         uint256 tokenBalance = token.balanceOf(msg.sender);
801         require(tokenBalance > 0);
802         uint256 refundAmount = safeDiv(safeMul(tokenBalance, address(this).balance), token.totalSupply());
803         require(refundAmount > 0);
804 
805         token.destroy(msg.sender, tokenBalance);
806         msg.sender.transfer(refundAmount);
807 
808         RefundHolder(msg.sender, refundAmount, tokenBalance, now);
809     }
810 }
811 
812 // File: contracts/fund/IPollManagedFund.sol
813 
814 /**
815  * @title IPollManagedFund
816  * @dev Fund callbacks used by polling contracts
817  */
818 interface IPollManagedFund {
819     /**
820      * @dev TapPoll callback
821      * @param agree True if new tap value is accepted by majority of contributors
822      * @param _tap New tap value
823      */
824     function onTapPollFinish(bool agree, uint256 _tap) external;
825 
826     /**
827      * @dev RefundPoll callback
828      * @param agree True if contributors decided to allow refunding
829      */
830     function onRefundPollFinish(bool agree) external;
831 }
832 
833 // File: contracts/poll/BasePoll.sol
834 
835 /**
836  * @title BasePoll
837  * @dev Abstract base class for polling contracts
838  */
839 contract BasePoll is SafeMath {
840     struct Vote {
841         uint256 time;
842         uint256 weight;
843         bool agree;
844     }
845 
846     uint256 public constant MAX_TOKENS_WEIGHT_DENOM = 1000;
847 
848     IERC20Token public token;
849     address public fundAddress;
850 
851     uint256 public startTime;
852     uint256 public endTime;
853     bool checkTransfersAfterEnd;
854 
855     uint256 public yesCounter = 0;
856     uint256 public noCounter = 0;
857     uint256 public totalVoted = 0;
858 
859     bool public finalized;
860     mapping(address => Vote) public votesByAddress;
861 
862     modifier checkTime() {
863         require(now >= startTime && now <= endTime);
864         _;
865     }
866 
867     modifier notFinalized() {
868         require(!finalized);
869         _;
870     }
871 
872     /**
873      * @dev BasePoll constructor
874      * @param _tokenAddress ERC20 compatible token contract address
875      * @param _fundAddress Fund contract address
876      * @param _startTime Poll start time
877      * @param _endTime Poll end time
878      */
879     function BasePoll(address _tokenAddress, address _fundAddress, uint256 _startTime, uint256 _endTime, bool _checkTransfersAfterEnd) public {
880         require(_tokenAddress != address(0));
881         require(_startTime >= now && _endTime > _startTime);
882 
883         token = IERC20Token(_tokenAddress);
884         fundAddress = _fundAddress;
885         startTime = _startTime;
886         endTime = _endTime;
887         finalized = false;
888         checkTransfersAfterEnd = _checkTransfersAfterEnd;
889     }
890 
891     /**
892      * @dev Process user`s vote
893      * @param agree True if user endorses the proposal else False
894      */
895     function vote(bool agree) public checkTime {
896         require(votesByAddress[msg.sender].time == 0);
897 
898         uint256 voiceWeight = token.balanceOf(msg.sender);
899         uint256 maxVoiceWeight = safeDiv(token.totalSupply(), MAX_TOKENS_WEIGHT_DENOM);
900         voiceWeight =  voiceWeight <= maxVoiceWeight ? voiceWeight : maxVoiceWeight;
901 
902         if(agree) {
903             yesCounter = safeAdd(yesCounter, voiceWeight);
904         } else {
905             noCounter = safeAdd(noCounter, voiceWeight);
906 
907         }
908 
909         votesByAddress[msg.sender].time = now;
910         votesByAddress[msg.sender].weight = voiceWeight;
911         votesByAddress[msg.sender].agree = agree;
912 
913         totalVoted = safeAdd(totalVoted, 1);
914     }
915 
916     /**
917      * @dev Revoke user`s vote
918      */
919     function revokeVote() public checkTime {
920         require(votesByAddress[msg.sender].time > 0);
921 
922         uint256 voiceWeight = votesByAddress[msg.sender].weight;
923         bool agree = votesByAddress[msg.sender].agree;
924 
925         votesByAddress[msg.sender].time = 0;
926         votesByAddress[msg.sender].weight = 0;
927         votesByAddress[msg.sender].agree = false;
928 
929         totalVoted = safeSub(totalVoted, 1);
930         if(agree) {
931             yesCounter = safeSub(yesCounter, voiceWeight);
932         } else {
933             noCounter = safeSub(noCounter, voiceWeight);
934         }
935     }
936 
937     /**
938      * @dev Function is called after token transfer from user`s wallet to check and correct user`s vote
939      *
940      */
941     function onTokenTransfer(address tokenHolder, uint256 amount) public {
942         require(msg.sender == fundAddress);
943         if(votesByAddress[tokenHolder].time == 0) {
944             return;
945         }
946         if(!checkTransfersAfterEnd) {
947              if(finalized || (now < startTime || now > endTime)) {
948                  return;
949              }
950         }
951 
952         if(token.balanceOf(tokenHolder) >= votesByAddress[tokenHolder].weight) {
953             return;
954         }
955         uint256 voiceWeight = amount;
956         if(amount > votesByAddress[tokenHolder].weight) {
957             voiceWeight = votesByAddress[tokenHolder].weight;
958         }
959 
960         if(votesByAddress[tokenHolder].agree) {
961             yesCounter = safeSub(yesCounter, voiceWeight);
962         } else {
963             noCounter = safeSub(noCounter, voiceWeight);
964         }
965         votesByAddress[tokenHolder].weight = safeSub(votesByAddress[tokenHolder].weight, voiceWeight);
966     }
967 
968     /**
969      * Finalize poll and call onPollFinish callback with result
970      */
971     function tryToFinalize() public notFinalized returns(bool) {
972         if(now < endTime) {
973             return false;
974         }
975         finalized = true;
976         onPollFinish(isSubjectApproved());
977         return true;
978     }
979 
980     function isNowApproved() public view returns(bool) {
981         return isSubjectApproved();
982     }
983 
984     function isSubjectApproved() internal view returns(bool) {
985         return yesCounter > noCounter;
986     }
987 
988     /**
989      * @dev callback called after poll finalization
990      */
991     function onPollFinish(bool agree) internal;
992 }
993 
994 // File: contracts/RefundPoll.sol
995 
996 /**
997  * @title RefundPoll
998  * @dev Enables fund refund mode
999  */
1000 contract RefundPoll is BasePoll {
1001     uint256 public holdEndTime = 0;
1002 
1003     /**
1004      * RefundPoll constructor
1005      * @param _tokenAddress ERC20 compatible token contract address
1006      * @param _fundAddress Fund contract address
1007      * @param _startTime Poll start time
1008      * @param _endTime Poll end time
1009      */
1010     function RefundPoll(
1011         address _tokenAddress,
1012         address _fundAddress,
1013         uint256 _startTime,
1014         uint256 _endTime,
1015         uint256 _holdEndTime,
1016         bool _checkTransfersAfterEnd
1017     ) public
1018         BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, _checkTransfersAfterEnd)
1019     {
1020         holdEndTime = _holdEndTime;
1021     }
1022 
1023     function tryToFinalize() public returns(bool) {
1024         if(holdEndTime > 0 && holdEndTime > endTime) {
1025             require(now >= holdEndTime);
1026         } else {
1027             require(now >= endTime);
1028         }
1029 
1030         finalized = true;
1031         onPollFinish(isSubjectApproved());
1032         return true;
1033     }
1034 
1035     function isSubjectApproved() internal view returns(bool) {
1036         return yesCounter > noCounter && yesCounter >= safeDiv(token.totalSupply(), 3);
1037     }
1038 
1039     function onPollFinish(bool agree) internal {
1040         IPollManagedFund fund = IPollManagedFund(fundAddress);
1041         fund.onRefundPollFinish(agree);
1042     }
1043 
1044 }
1045 
1046 // File: contracts/TapPoll.sol
1047 
1048 /**
1049  * @title TapPoll
1050  * @dev Poll to increase tap amount
1051  */
1052 contract TapPoll is BasePoll {
1053     uint256 public tap;
1054     uint256 public minTokensPerc = 0;
1055 
1056     /**
1057      * TapPoll constructor
1058      * @param _tap New tap value
1059      * @param _tokenAddress ERC20 compatible token contract address
1060      * @param _fundAddress Fund contract address
1061      * @param _startTime Poll start time
1062      * @param _endTime Poll end time
1063      * @param _minTokensPerc - Min percent of tokens from totalSupply where poll is considered to be fulfilled
1064      */
1065     function TapPoll(
1066         uint256 _tap,
1067         address _tokenAddress,
1068         address _fundAddress,
1069         uint256 _startTime,
1070         uint256 _endTime,
1071         uint256 _minTokensPerc
1072     ) public
1073         BasePoll(_tokenAddress, _fundAddress, _startTime, _endTime, false)
1074     {
1075         tap = _tap;
1076         minTokensPerc = _minTokensPerc;
1077     }
1078 
1079     function onPollFinish(bool agree) internal {
1080         IPollManagedFund fund = IPollManagedFund(fundAddress);
1081         fund.onTapPollFinish(agree, tap);
1082     }
1083 
1084     function getVotedTokensPerc() public view returns(uint256) {
1085         return safeDiv(safeMul(safeAdd(yesCounter, noCounter), 100), token.totalSupply());
1086     }
1087 
1088     function isSubjectApproved() internal view returns(bool) {
1089         return yesCounter > noCounter && getVotedTokensPerc() >= minTokensPerc;
1090     }
1091 }
1092 
1093 // File: contracts/PollManagedFund.sol
1094 
1095 /**
1096  * @title PollManagedFund
1097  * @dev Fund controlled by users
1098  */
1099 contract PollManagedFund is Fund, DateTime, ITokenEventListener {
1100     uint256 public constant TAP_POLL_DURATION = 3 days;
1101     uint256 public constant REFUND_POLL_DURATION = 7 days;
1102     uint256 public constant MAX_VOTED_TOKEN_PERC = 10;
1103 
1104     TapPoll public tapPoll;
1105     RefundPoll public refundPoll;
1106 
1107     uint256 public minVotedTokensPerc = 0;
1108     uint256 public secondRefundPollDate = 0;
1109     bool public isWithdrawEnabled = true;
1110 
1111     uint256[] public refundPollDates = [
1112         1543651200, // 01.12.2018
1113         1551427200, // 01.03.2019
1114         1559376000 // 01.06.2019
1115     ];
1116 
1117     modifier onlyTokenHolder() {
1118         require(token.balanceOf(msg.sender) > 0);
1119         _;
1120     }
1121 
1122     event TapPollCreated();
1123     event TapPollFinished(bool approved, uint256 _tap);
1124     event RefundPollCreated();
1125     event RefundPollFinished(bool approved);
1126 
1127     /**
1128      * @dev PollManagedFund constructor
1129      * params - see Fund constructor
1130      */
1131     function PollManagedFund(
1132         address _teamWallet,
1133         address _mainSaleTokenWallet,
1134         address _foundationTokenWallet,
1135         address _teamTokenWallet,
1136         address _marketingTokenWallet,
1137         address _advisorTokenWallet,
1138         address _refundManager,
1139         address[] _owners
1140         ) public
1141     Fund(_teamWallet, _mainSaleTokenWallet, _foundationTokenWallet, _teamTokenWallet, _marketingTokenWallet, _advisorTokenWallet, _refundManager, _owners)
1142     {
1143     }
1144 
1145     function canWithdraw() public returns(bool) {
1146         if(
1147             address(refundPoll) != address(0) &&
1148             !refundPoll.finalized() &&
1149             refundPoll.holdEndTime() > 0 &&
1150             now >= refundPoll.holdEndTime() &&
1151             refundPoll.isNowApproved()
1152         ) {
1153             return false;
1154         }
1155         return isWithdrawEnabled;
1156     }
1157 
1158     /**
1159      * @dev ITokenEventListener implementation. Notify active poll contracts about token transfers
1160      */
1161     function onTokenTransfer(address _from, address /*_to*/, uint256 _value) external {
1162         require(msg.sender == address(token));
1163         if(address(tapPoll) != address(0) && !tapPoll.finalized()) {
1164             tapPoll.onTokenTransfer(_from, _value);
1165         }
1166          if(address(refundPoll) != address(0) && !refundPoll.finalized()) {
1167             refundPoll.onTokenTransfer(_from, _value);
1168         }
1169     }
1170 
1171     /**
1172      * @dev Update minVotedTokensPerc value after tap poll.
1173      * Set new value == 50% from current voted tokens amount
1174      */
1175     function updateMinVotedTokens(uint256 _minVotedTokensPerc) internal {
1176         uint256 newPerc = safeDiv(_minVotedTokensPerc, 2);
1177         if(newPerc > MAX_VOTED_TOKEN_PERC) {
1178             minVotedTokensPerc = MAX_VOTED_TOKEN_PERC;
1179             return;
1180         }
1181         minVotedTokensPerc = newPerc;
1182     }
1183 
1184     // Tap poll
1185     function createTapPoll(uint8 tapIncPerc) public onlyOwner {
1186         require(state == FundState.TeamWithdraw);
1187         require(tapPoll == address(0));
1188         require(getDay(now) == 10);
1189         require(tapIncPerc <= 50);
1190         uint256 _tap = safeAdd(tap, safeDiv(safeMul(tap, tapIncPerc), 100));
1191         uint256 startTime = now;
1192         uint256 endTime = startTime + TAP_POLL_DURATION;
1193         tapPoll = new TapPoll(_tap, token, this, startTime, endTime, minVotedTokensPerc);
1194         TapPollCreated();
1195     }
1196 
1197     function onTapPollFinish(bool agree, uint256 _tap) external {
1198         require(msg.sender == address(tapPoll) && tapPoll.finalized());
1199         if(agree) {
1200             tap = _tap;
1201         }
1202         updateMinVotedTokens(tapPoll.getVotedTokensPerc());
1203         TapPollFinished(agree, _tap);
1204         delete tapPoll;
1205     }
1206 
1207     // Refund poll
1208     function checkRefundPollDate() internal view returns(bool) {
1209         if(secondRefundPollDate > 0 && now >= secondRefundPollDate && now <= safeAdd(secondRefundPollDate, 1 days)) {
1210             return true;
1211         }
1212 
1213         for(uint i; i < refundPollDates.length; i++) {
1214             if(now >= refundPollDates[i] && now <= safeAdd(refundPollDates[i], 1 days)) {
1215                 return true;
1216             }
1217         }
1218         return false;
1219     }
1220 
1221     function createRefundPoll() public onlyTokenHolder {
1222         require(state == FundState.TeamWithdraw);
1223         require(address(refundPoll) == address(0));
1224         require(checkRefundPollDate());
1225 
1226         if(secondRefundPollDate > 0 && now > safeAdd(secondRefundPollDate, 1 days)) {
1227             secondRefundPollDate = 0;
1228         }
1229 
1230         uint256 startTime = now;
1231         uint256 endTime = startTime + REFUND_POLL_DURATION;
1232         bool isFirstRefund = secondRefundPollDate == 0;
1233         uint256 holdEndTime = 0;
1234 
1235         if(isFirstRefund) {
1236             holdEndTime = toTimestamp(
1237                 getYear(startTime),
1238                 getMonth(startTime) + 1,
1239                 1
1240             );
1241         }
1242         refundPoll = new RefundPoll(token, this, startTime, endTime, holdEndTime, isFirstRefund);
1243         RefundPollCreated();
1244     }
1245 
1246     function onRefundPollFinish(bool agree) external {
1247         require(msg.sender == address(refundPoll) && refundPoll.finalized());
1248         if(agree) {
1249             if(secondRefundPollDate > 0) {
1250                 enableRefund();
1251             } else {
1252                 uint256 startTime = refundPoll.startTime();
1253                 secondRefundPollDate = toTimestamp(
1254                     getYear(startTime),
1255                     getMonth(startTime) + 2,
1256                     1
1257                 );
1258                 isWithdrawEnabled = false;
1259             }
1260         } else {
1261             secondRefundPollDate = 0;
1262             isWithdrawEnabled = true;
1263         }
1264         RefundPollFinished(agree);
1265 
1266         delete refundPoll;
1267     }
1268 
1269     function forceRefund() public {
1270         require(msg.sender == refundManager);
1271         enableRefund();
1272     }
1273 }