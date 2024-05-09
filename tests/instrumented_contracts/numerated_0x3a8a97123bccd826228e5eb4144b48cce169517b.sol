1 pragma solidity ^0.4.11;
2 
3 // File: zeppelin/token/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 // File: zeppelin/token/BasicToken.sol
50 
51 /**
52  * @title Basic token
53  * @dev Basic version of StandardToken, with no allowances.
54  */
55 contract BasicToken is ERC20Basic {
56   using SafeMath for uint256;
57 
58   mapping(address => uint256) balances;
59 
60   /**
61   * @dev transfer token for a specified address
62   * @param _to The address to transfer to.
63   * @param _value The amount to be transferred.
64   */
65   function transfer(address _to, uint256 _value) public returns (bool) {
66     require(_to != address(0));
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 // File: zeppelin/token/ERC20.sol
87 
88 /**
89  * @title ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/20
91  */
92 contract ERC20 is ERC20Basic {
93   function allowance(address owner, address spender) public constant returns (uint256);
94   function transferFrom(address from, address to, uint256 value) public returns (bool);
95   function approve(address spender, uint256 value) public returns (bool);
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: zeppelin/token/StandardToken.sol
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * @dev https://github.com/ethereum/EIPs/issues/20
106  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
107  */
108 contract StandardToken is ERC20, BasicToken {
109 
110   mapping (address => mapping (address => uint256)) allowed;
111 
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121 
122     uint256 _allowance = allowed[_from][msg.sender];
123 
124     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
125     // require (_value <= _allowance);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval (address _spender, uint _addedValue)
167     returns (bool success) {
168     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170     return true;
171   }
172 
173   function decreaseApproval (address _spender, uint _subtractedValue)
174     returns (bool success) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 // File: contracts/QravityTeamTimelock.sol
188 
189 contract QravityTeamTimelock {
190     using SafeMath for uint256;
191 
192     uint16 constant ORIGIN_YEAR = 1970;
193 
194     // Account that can release tokens
195     address public controller;
196 
197     uint256 public releasedAmount;
198 
199     ERC20Basic token;
200 
201     function QravityTeamTimelock(ERC20Basic _token, address _controller)
202     public
203     {
204         require(address(_token) != 0x0);
205         require(_controller != 0x0);
206         token = _token;
207         controller = _controller;
208     }
209 
210     /**
211      * @notice Transfers tokens held by timelock to beneficiary.
212      */
213     function release(address _beneficiary, uint256 _amount)
214     public
215     {
216         require(msg.sender == controller);
217         require(_amount > 0);
218         require(_amount <= availableAmount(now));
219         token.transfer(_beneficiary, _amount);
220         releasedAmount = releasedAmount.add(_amount);
221     }
222 
223     function availableAmount(uint256 timestamp)
224     public view
225     returns (uint256 amount)
226     {
227         uint256 totalWalletAmount = releasedAmount.add(token.balanceOf(this));
228         uint256 canBeReleasedAmount = totalWalletAmount.mul(availablePercent(timestamp)).div(100);
229         return canBeReleasedAmount.sub(releasedAmount);
230     }
231 
232     function availablePercent(uint256 timestamp)
233     public view
234     returns (uint256 factor)
235     {
236        uint256[10] memory releasePercent = [uint256(0), 20, 30, 40, 50, 60, 70, 80, 90, 100];
237        uint[10] memory releaseTimes = [
238            toTimestamp(2020, 4, 1),
239            toTimestamp(2020, 7, 1),
240            toTimestamp(2020, 10, 1),
241            toTimestamp(2021, 1, 1),
242            toTimestamp(2021, 4, 1),
243            toTimestamp(2021, 7, 1),
244            toTimestamp(2021, 10, 1),
245            toTimestamp(2022, 1, 1),
246            toTimestamp(2022, 4, 1),
247            0
248         ];
249 
250         // Set default to the 0% bonus.
251         uint256 timeIndex = 0;
252 
253         for (uint256 i = 0; i < releaseTimes.length; i++) {
254             if (timestamp < releaseTimes[i] || releaseTimes[i] == 0) {
255                 timeIndex = i;
256                 break;
257             }
258         }
259         return releasePercent[timeIndex];
260     }
261 
262     // Timestamp functions based on
263     // https://github.com/pipermerriam/ethereum-datetime/blob/master/contracts/DateTime.sol
264     function toTimestamp(uint16 year, uint8 month, uint8 day)
265     internal pure returns (uint timestamp) {
266         uint16 i;
267 
268         // Year
269         timestamp += (year - ORIGIN_YEAR) * 1 years;
270         timestamp += (leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR)) * 1 days;
271 
272         // Month
273         uint8[12] memory monthDayCounts;
274         monthDayCounts[0] = 31;
275         if (isLeapYear(year)) {
276                 monthDayCounts[1] = 29;
277         }
278         else {
279                 monthDayCounts[1] = 28;
280         }
281         monthDayCounts[2] = 31;
282         monthDayCounts[3] = 30;
283         monthDayCounts[4] = 31;
284         monthDayCounts[5] = 30;
285         monthDayCounts[6] = 31;
286         monthDayCounts[7] = 31;
287         monthDayCounts[8] = 30;
288         monthDayCounts[9] = 31;
289         monthDayCounts[10] = 30;
290         monthDayCounts[11] = 31;
291 
292         for (i = 1; i < month; i++) {
293             timestamp += monthDayCounts[i - 1] * 1 days;
294         }
295 
296         // Day
297         timestamp += (day - 1) * 1 days;
298 
299         // Hour, Minute, and Second are assumed as 0 (we calculate in GMT)
300 
301         return timestamp;
302     }
303 
304     function leapYearsBefore(uint year)
305     internal pure returns (uint) {
306         year -= 1;
307         return year / 4 - year / 100 + year / 400;
308     }
309 
310     function isLeapYear(uint16 year)
311     internal pure returns (bool) {
312         if (year % 4 != 0) {
313             return false;
314         }
315         if (year % 100 != 0) {
316             return true;
317         }
318         if (year % 400 != 0) {
319             return false;
320         }
321         return true;
322     }
323 }
324 
325 // File: contracts/Bonus.sol
326 
327 library Bonus {
328     uint16 constant ORIGIN_YEAR = 1970;
329     struct BonusData {
330         uint[7] factors; // aditional entry for 0% bonus
331         uint[6] cutofftimes;
332     }
333 
334     // Use storage keyword so that we write this to persistent storage.
335     function initBonus(BonusData storage data)
336     internal
337     {
338         data.factors = [uint256(300), 250, 200, 150, 100, 50, 0];
339         data.cutofftimes = [toTimestamp(2018, 9, 1),
340                             toTimestamp(2018, 9, 8),
341                             toTimestamp(2018, 9, 15),
342                             toTimestamp(2018, 9, 22),
343                             toTimestamp(2018, 9, 29),
344                             toTimestamp(2018, 10, 8)];
345     }
346 
347     function getBonusFactor(uint timestamp, BonusData storage data)
348     internal view returns (uint256 factor)
349     {
350         uint256 countcutoffs = data.cutofftimes.length;
351         // Set default to the 0% bonus.
352         uint256 timeIndex = countcutoffs;
353 
354         for (uint256 i = 0; i < countcutoffs; i++) {
355             if (timestamp < data.cutofftimes[i]) {
356                 timeIndex = i;
357                 break;
358             }
359         }
360 
361         return data.factors[timeIndex];
362     }
363 
364     function getFollowingCutoffTime(uint timestamp, BonusData storage data)
365     internal view returns (uint nextTime)
366     {
367         uint256 countcutoffs = data.cutofftimes.length;
368         // Set default to 0 meaning "no cutoff any more".
369         nextTime = 0;
370 
371         for (uint256 i = 0; i < countcutoffs; i++) {
372             if (timestamp < data.cutofftimes[i]) {
373                 nextTime = data.cutofftimes[i];
374                 break;
375             }
376         }
377 
378         return nextTime;
379     }
380 
381     // Timestamp functions based on
382     // https://github.com/pipermerriam/ethereum-datetime/blob/master/contracts/DateTime.sol
383     function toTimestamp(uint16 year, uint8 month, uint8 day)
384     internal pure returns (uint timestamp) {
385         uint16 i;
386 
387         // Year
388         timestamp += (year - ORIGIN_YEAR) * 1 years;
389         timestamp += (leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR)) * 1 days;
390 
391         // Month
392         uint8[12] memory monthDayCounts;
393         monthDayCounts[0] = 31;
394         if (isLeapYear(year)) {
395                 monthDayCounts[1] = 29;
396         }
397         else {
398                 monthDayCounts[1] = 28;
399         }
400         monthDayCounts[2] = 31;
401         monthDayCounts[3] = 30;
402         monthDayCounts[4] = 31;
403         monthDayCounts[5] = 30;
404         monthDayCounts[6] = 31;
405         monthDayCounts[7] = 31;
406         monthDayCounts[8] = 30;
407         monthDayCounts[9] = 31;
408         monthDayCounts[10] = 30;
409         monthDayCounts[11] = 31;
410 
411         for (i = 1; i < month; i++) {
412             timestamp += monthDayCounts[i - 1] * 1 days;
413         }
414 
415         // Day
416         timestamp += (day - 1) * 1 days;
417 
418         // Hour, Minute, and Second are assumed as 0 (we calculate in GMT)
419 
420         return timestamp;
421     }
422 
423     function leapYearsBefore(uint year)
424     internal pure returns (uint) {
425         year -= 1;
426         return year / 4 - year / 100 + year / 400;
427     }
428 
429     function isLeapYear(uint16 year)
430     internal pure returns (bool) {
431         if (year % 4 != 0) {
432             return false;
433         }
434         if (year % 100 != 0) {
435             return true;
436         }
437         if (year % 400 != 0) {
438             return false;
439         }
440         return true;
441     }
442 }
443 
444 // File: contracts/QCOToken.sol
445 
446 /*
447 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20.
448 */
449 pragma solidity ^0.4.11;
450 
451 
452 
453 
454 contract QCOToken is StandardToken {
455 
456     // data structures
457     enum States {
458         Initial, // deployment time
459         ValuationSet,
460         Ico, // whitelist addresses, accept funds, update balances
461         Aborted, // ICO aborted
462         Operational, // production phase
463         Paused         // for contract upgrades
464     }
465 
466     mapping(address => uint256) public ethPossibleRefunds;
467 
468     uint256 public soldTokens;
469 
470     string public constant name = "Qravity Coin Token";
471 
472     string public constant symbol = "QCO";
473 
474     uint8 public constant decimals = 18;
475 
476     mapping(address => bool) public whitelist;
477 
478     address public stateControl;
479 
480     address public whitelistControl;
481 
482     address public withdrawControl;
483 
484     address public tokenAssignmentControl;
485 
486     address public teamWallet;
487 
488     address public reserves;
489 
490     States public state;
491 
492     uint256 public endBlock;
493 
494     uint256 public ETH_QCO; //number of tokens per ETH
495 
496     uint256 constant pointMultiplier = 1e18; //100% = 1*10^18 points
497 
498     uint256 public constant maxTotalSupply = 1000000000 * pointMultiplier; //1B tokens
499 
500     uint256 public constant percentForSale = 50;
501 
502     Bonus.BonusData bonusData;
503 
504     event Mint(address indexed to, uint256 amount);
505     event MintFinished();
506 
507     bool public mintingFinished = false;
508 
509     //pausing the contract should extend the ico dates into the future.
510     uint256 public pauseOffset = 0;
511 
512     uint256 public pauseLastStart = 0;
513 
514 
515     //this creates the contract and stores the owner. it also passes in 3 addresses to be used later during the lifetime of the contract.
516     function QCOToken(
517         address _stateControl
518     , address _whitelistControl
519     , address _withdrawControl
520     , address _tokenAssignmentControl
521     , address _teamControl
522     , address _reserves)
523     public
524     {
525         stateControl = _stateControl;
526         whitelistControl = _whitelistControl;
527         withdrawControl = _withdrawControl;
528         tokenAssignmentControl = _tokenAssignmentControl;
529         moveToState(States.Initial);
530         endBlock = 0;
531         ETH_QCO = 0;
532         totalSupply = maxTotalSupply;
533         soldTokens = 0;
534         Bonus.initBonus(bonusData);
535         teamWallet = address(new QravityTeamTimelock(this, _teamControl));
536 
537         reserves = _reserves;
538         balances[reserves] = totalSupply;
539         Mint(reserves, totalSupply);
540         Transfer(0x0, reserves, totalSupply);
541     }
542 
543     event Whitelisted(address addr);
544 
545     event StateTransition(States oldState, States newState);
546 
547     modifier onlyWhitelist() {
548         require(msg.sender == whitelistControl);
549         _;
550     }
551 
552     modifier onlyStateControl() {
553         require(msg.sender == stateControl);
554         _;
555     }
556 
557     modifier onlyTokenAssignmentControl() {
558         require(msg.sender == tokenAssignmentControl);
559         _;
560     }
561 
562     modifier onlyWithdraw() {
563         require(msg.sender == withdrawControl);
564         _;
565     }
566 
567     modifier requireState(States _requiredState) {
568         require(state == _requiredState);
569         _;
570     }
571 
572     /**
573     BEGIN ICO functions
574     */
575 
576     //this is the main funding function, it updates the balances of tokens during the ICO.
577     //no particular incentive schemes have been implemented here
578     //it is only accessible during the "ICO" phase.
579     function() payable
580     public
581     requireState(States.Ico)
582     {
583         require(whitelist[msg.sender] == true);
584         require(msg.value > 0);
585         // We have reports that some wallet contracts may end up sending a single null-byte.
586         // Still reject calls of unknown functions, which are always at least 4 bytes of data.
587         require(msg.data.length < 4);
588         require(block.number < endBlock);
589 
590         uint256 soldToTuserWithBonus = calcBonus(msg.value);
591 
592         issueTokensToUser(msg.sender, soldToTuserWithBonus);
593         ethPossibleRefunds[msg.sender] = ethPossibleRefunds[msg.sender].add(msg.value);
594     }
595 
596     function issueTokensToUser(address beneficiary, uint256 amount)
597     internal
598     {
599         uint256 soldTokensAfterInvestment = soldTokens.add(amount);
600         require(soldTokensAfterInvestment <= maxTotalSupply.mul(percentForSale).div(100));
601 
602         balances[beneficiary] = balances[beneficiary].add(amount);
603         balances[reserves] = balances[reserves].sub(amount);
604         soldTokens = soldTokensAfterInvestment;
605         Transfer(reserves, beneficiary, amount);
606     }
607 
608     function getCurrentBonusFactor()
609     public view
610     returns (uint256 factor)
611     {
612         //we pass in  now-pauseOffset as the "now time" for purposes of calculating the bonus factor
613         return Bonus.getBonusFactor(now - pauseOffset, bonusData);
614     }
615 
616     function getNextCutoffTime()
617     public view returns (uint timestamp)
618     {
619         return Bonus.getFollowingCutoffTime(now - pauseOffset, bonusData);
620     }
621 
622     function calcBonus(uint256 weiAmount)
623     constant
624     public
625     returns (uint256 resultingTokens)
626     {
627         uint256 basisTokens = weiAmount.mul(ETH_QCO);
628         //percentages are integer numbers as per mill (promille) so we can accurately calculate 0.5% = 5. 100% = 1000
629         uint256 perMillBonus = getCurrentBonusFactor();
630         //100% + bonus % times original amount divided by 100%.
631         return basisTokens.mul(per_mill + perMillBonus).div(per_mill);
632     }
633 
634     uint256 constant per_mill = 1000;
635 
636 
637     function moveToState(States _newState)
638     internal
639     {
640         StateTransition(state, _newState);
641         state = _newState;
642     }
643     // ICO contract configuration function
644     // new_ETH_QCO is the new rate of ETH in QCO to use when no bonus applies
645     // newEndBlock is the absolute block number at which the ICO must stop. It must be set after now + silence period.
646     function updateEthICOVariables(uint256 _new_ETH_QCO, uint256 _newEndBlock)
647     public
648     onlyStateControl
649     {
650         require(state == States.Initial || state == States.ValuationSet);
651         require(_new_ETH_QCO > 0);
652         require(block.number < _newEndBlock);
653         endBlock = _newEndBlock;
654         // initial conversion rate of ETH_QCO set now, this is used during the Ico phase.
655         ETH_QCO = _new_ETH_QCO;
656         moveToState(States.ValuationSet);
657     }
658 
659     function startICO()
660     public
661     onlyStateControl
662     requireState(States.ValuationSet)
663     {
664         require(block.number < endBlock);
665         moveToState(States.Ico);
666     }
667 
668     function addPresaleAmount(address beneficiary, uint256 amount)
669     public
670     onlyTokenAssignmentControl
671     {
672         require(state == States.ValuationSet || state == States.Ico);
673         issueTokensToUser(beneficiary, amount);
674     }
675 
676 
677     function endICO()
678     public
679     onlyStateControl
680     requireState(States.Ico)
681     {
682         burnAndFinish();
683         moveToState(States.Operational);
684     }
685 
686     function anyoneEndICO()
687     public
688     requireState(States.Ico)
689     {
690         require(block.number > endBlock);
691         burnAndFinish();
692         moveToState(States.Operational);
693     }
694 
695     function burnAndFinish()
696     internal
697     {
698         totalSupply = soldTokens.mul(100).div(percentForSale);
699 
700         uint256 teamAmount = totalSupply.mul(22).div(100);
701         balances[teamWallet] = teamAmount;
702         Transfer(reserves, teamWallet, teamAmount);
703 
704         uint256 reservesAmount = totalSupply.sub(soldTokens).sub(teamAmount);
705         // Burn all tokens over the target amount.
706         Transfer(reserves, 0x0, balances[reserves].sub(reservesAmount).sub(teamAmount));
707         balances[reserves] = reservesAmount;
708 
709         mintingFinished = true;
710         MintFinished();
711     }
712 
713     function addToWhitelist(address _whitelisted)
714     public
715     onlyWhitelist
716         //    requireState(States.Ico)
717     {
718         whitelist[_whitelisted] = true;
719         Whitelisted(_whitelisted);
720     }
721 
722 
723     //emergency pause for the ICO
724     function pause()
725     public
726     onlyStateControl
727     requireState(States.Ico)
728     {
729         moveToState(States.Paused);
730         pauseLastStart = now;
731     }
732 
733     //in case we want to completely abort
734     function abort()
735     public
736     onlyStateControl
737     requireState(States.Paused)
738     {
739         moveToState(States.Aborted);
740     }
741 
742     //un-pause
743     function resumeICO()
744     public
745     onlyStateControl
746     requireState(States.Paused)
747     {
748         moveToState(States.Ico);
749         //increase pauseOffset by the time it was paused
750         pauseOffset = pauseOffset + (now - pauseLastStart);
751     }
752 
753     //in case of a failed/aborted ICO every investor can get back their money
754     function requestRefund()
755     public
756     requireState(States.Aborted)
757     {
758         require(ethPossibleRefunds[msg.sender] > 0);
759         //there is no need for updateAccount(msg.sender) since the token never became active.
760         uint256 payout = ethPossibleRefunds[msg.sender];
761         //reverse calculate the amount to pay out
762         ethPossibleRefunds[msg.sender] = 0;
763         msg.sender.transfer(payout);
764     }
765 
766     //after the ICO has run its course, the withdraw account can drain funds bit-by-bit as needed.
767     function requestPayout(uint _amount)
768     public
769     onlyWithdraw //very important!
770     requireState(States.Operational)
771     {
772         msg.sender.transfer(_amount);
773     }
774 
775     //if this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
776     function rescueToken(ERC20Basic _foreignToken, address _to)
777     public
778     onlyTokenAssignmentControl
779     {
780         _foreignToken.transfer(_to, _foreignToken.balanceOf(this));
781     }
782     /**
783     END ICO functions
784     */
785 
786     /**
787     BEGIN ERC20 functions
788     */
789     function transfer(address _to, uint256 _value)
790     public
791     requireState(States.Operational)
792     returns (bool success) {
793         return super.transfer(_to, _value);
794     }
795 
796     function transferFrom(address _from, address _to, uint256 _value)
797     public
798     requireState(States.Operational)
799     returns (bool success) {
800         return super.transferFrom(_from, _to, _value);
801     }
802 
803     /**
804     END ERC20 functions
805     */
806 }