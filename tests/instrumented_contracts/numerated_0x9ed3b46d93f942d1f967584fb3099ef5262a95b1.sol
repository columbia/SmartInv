1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address internal owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   constructor() public {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public returns (bool) {
33     require(newOwner != address(0x0));
34     emit OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36 
37     return true;
38   }
39 }
40 
41 contract BitNauticWhitelist is Ownable {
42     using SafeMath for uint256;
43 
44     uint256 public usdPerEth;
45 
46     constructor(uint256 _usdPerEth) public {
47         usdPerEth = _usdPerEth;
48     }
49 
50     mapping(address => bool) public AMLWhitelisted;
51     mapping(address => uint256) public contributionCap;
52 
53     /**
54      * @dev add an address to the whitelist
55      * @param addr address
56      * @return true if the address was added to the whitelist, false if the address was already in the whitelist
57      */
58     function setKYCLevel(address addr, uint8 level) onlyOwner public returns (bool) {
59         if (level >= 3) {
60             contributionCap[addr] = 50000 ether; // crowdsale hard cap
61         } else if (level == 2) {
62             contributionCap[addr] = SafeMath.div(500000 * 10 ** 18, usdPerEth); // KYC Tier 2 - 500k USD
63         } else if (level == 1) {
64             contributionCap[addr] = SafeMath.div(3000 * 10 ** 18, usdPerEth); // KYC Tier 1 - 3k USD
65         } else {
66             contributionCap[addr] = 0;
67         }
68 
69         return true;
70     }
71 
72     /**
73      * @dev add addresses to the whitelist
74      * @param addrs addresses
75      * @return true if at least one address was added to the whitelist,
76      * false if all addresses were already in the whitelist
77      */
78     function setKYCLevelsBulk(address[] addrs, uint8[] levels) onlyOwner external returns (bool success) {
79         require(addrs.length == levels.length);
80 
81         for (uint256 i = 0; i < addrs.length; i++) {
82             assert(setKYCLevel(addrs[i], levels[i]));
83         }
84 
85         return true;
86     }
87 
88     function setAMLWhitelisted(address addr, bool whitelisted) onlyOwner public returns (bool) {
89         AMLWhitelisted[addr] = whitelisted;
90 
91         return true;
92     }
93 
94     function setAMLWhitelistedBulk(address[] addrs, bool[] whitelisted) onlyOwner external returns (bool) {
95         require(addrs.length == whitelisted.length);
96 
97         for (uint256 i = 0; i < addrs.length; i++) {
98             assert(setAMLWhitelisted(addrs[i], whitelisted[i]));
99         }
100 
101         return true;
102     }
103 }
104 
105 contract Pausable is Ownable {
106   event Pause();
107   event Unpause();
108 
109   bool public paused = false;
110 
111 
112   /**
113    * @dev Modifier to make a function callable only when the contract is not paused.
114    */
115   modifier whenNotPaused() {
116     require(!paused);
117     _;
118   }
119 
120   /**
121    * @dev Modifier to make a function callable only when the contract is paused.
122    */
123   modifier whenPaused() {
124     require(paused);
125     _;
126   }
127 
128   /**
129    * @dev called by the owner to pause, triggers stopped state
130    */
131   function pause() onlyOwner whenNotPaused public {
132     paused = true;
133     emit Pause();
134   }
135 
136   /**
137    * @dev called by the owner to unpause, returns to normal state
138    */
139   function unpause() onlyOwner whenPaused public {
140     paused = false;
141     emit Unpause();
142   }
143 }
144 
145 library SafeMath {
146     /**
147     * @dev Multiplies two numbers, throws on overflow.
148     */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
150         if (a == 0) {
151             return 0;
152         }
153         c = a * b;
154         assert(c / a == b);
155         return c;
156     }
157 
158     /**
159     * @dev Integer division of two numbers, truncating the quotient.
160     */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // assert(b > 0); // Solidity automatically throws when dividing by 0
163         // uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165         return a / b;
166     }
167 
168     /**
169     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
170     */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         assert(b <= a);
173         return a - b;
174     }
175 
176     /**
177     * @dev Adds two numbers, throws on overflow.
178     */
179     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
180         c = a + b;
181         assert(c >= a);
182         return c;
183     }
184 }
185 
186 contract Crowdsale is Ownable, Pausable {
187     using SafeMath for uint256;
188 
189     // The token being sold
190     MintableToken public token;
191 
192     // start and end timestamps where investments are allowed (both inclusive)
193     uint256 public ICOStartTime;
194     uint256 public ICOEndTime;
195 
196     // wallet address where funds will be saved
197     address internal wallet;
198 
199     // amount of raised money in wei
200     uint256 public weiRaised; // internal
201 
202     // Public Supply
203     uint256 public publicSupply;
204 
205     /**
206      * event for token purchase logging
207      * @param purchaser who paid for the tokens
208      * @param beneficiary who got the tokens
209      * @param value weis paid for purchase
210      * @param amount amount of tokens purchased
211      */
212     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
213 
214     // BitNautic Crowdsale constructor
215     constructor(MintableToken _token, uint256 _publicSupply, uint256 _startTime, uint256 _endTime, address _wallet) public {
216         require(_endTime >= _startTime);
217         require(_wallet != 0x0);
218 
219         // BitNautic token creation
220         token = _token;
221 
222         // total supply of token for the crowdsale
223         publicSupply = _publicSupply;
224 
225         // Pre-ICO start Time
226         ICOStartTime = _startTime;
227 
228         // ICO end Time
229         ICOEndTime = _endTime;
230 
231         // wallet where funds will be saved
232         wallet = _wallet;
233     }
234 
235     // fallback function can be used to buy tokens
236     function() public payable {
237         buyTokens(msg.sender);
238     }
239 
240     // High level token purchase function
241     function buyTokens(address beneficiary) whenNotPaused public payable {
242         require(beneficiary != 0x0);
243         require(validPurchase());
244 
245         // minimum investment should be 0.05 ETH
246         uint256 lowerPurchaseLimit = 0.05 ether;
247         require(msg.value >= lowerPurchaseLimit);
248 
249         assert(_tokenPurchased(msg.sender, beneficiary, msg.value));
250 
251         // update state
252         weiRaised = weiRaised.add(msg.value);
253 
254         forwardFunds();
255     }
256 
257     function _tokenPurchased(address /* buyer */, address /* beneficiary */, uint256 /* weiAmount */) internal returns (bool) {
258         // TO BE OVERLOADED IN SUBCLASSES
259         return true;
260     }
261 
262     // send ether to the fund collection wallet
263     // override to create custom fund forwarding mechanisms
264     function forwardFunds() internal {
265         wallet.transfer(msg.value);
266     }
267 
268     // @return true if the transaction can buy tokens
269     function validPurchase() internal constant returns (bool) {
270         bool withinPeriod = ICOStartTime <= now && now <= ICOEndTime;
271         bool nonZeroPurchase = msg.value != 0;
272 
273         return withinPeriod && nonZeroPurchase;
274     }
275 
276     // @return true if crowdsale event has ended
277     function hasEnded() public constant returns (bool) {
278         return now > ICOEndTime;
279     }
280 
281     bool public checkBurnTokens = false;
282 
283     function burnTokens() onlyOwner public returns (bool) {
284         require(hasEnded());
285         require(!checkBurnTokens);
286 
287         token.mint(0x0, publicSupply);
288         token.burnTokens(publicSupply);
289         publicSupply = 0;
290         checkBurnTokens = true;
291 
292         return true;
293     }
294 
295     function getTokenAddress() onlyOwner public view returns (address) {
296         return address(token);
297     }
298 }
299 
300 contract CappedCrowdsale is Crowdsale {
301   using SafeMath for uint256;
302 
303   uint256 internal cap;
304 
305   constructor(uint256 _cap) public {
306     require(_cap > 0);
307     cap = _cap;
308   }
309 
310   // overriding Crowdsale#validPurchase to add extra cap logic
311   // @return true if investors can buy at the moment
312   function validPurchase() internal constant returns (bool) {
313     bool withinCap = weiRaised.add(msg.value) <= cap;
314     return super.validPurchase() && withinCap;
315   }
316 
317   // overriding Crowdsale#hasEnded to add cap logic
318   // @return true if crowdsale event has ended
319   function hasEnded() public constant returns (bool) {
320     bool capReached = weiRaised >= cap;
321     return super.hasEnded() || capReached;
322   }
323 
324 }
325 
326 contract FinalizableCrowdsale is Crowdsale {
327     using SafeMath for uint256;
328 
329     bool isFinalized = false;
330 
331     event Finalized();
332 
333     /**
334      * @dev Must be called after crowdsale ends, to do some extra finalization
335      * work. Calls the contract's finalization function.
336      */
337     function finalizeCrowdsale() onlyOwner public {
338         require(!isFinalized);
339         require(hasEnded());
340 
341         finalization();
342         emit Finalized();
343 
344         isFinalized = true;
345     }
346 
347 
348     /**
349      * @dev Can be overridden to add finalization logic. The overriding function
350      * should call super.finalization() to ensure the chain of finalization is
351      * executed entirely.
352      */
353     function finalization() internal {
354     }
355 }
356 
357 contract RefundVault is Ownable {
358   using SafeMath for uint256;
359 
360   enum State { Active, Refunding, Closed }
361 
362   mapping (address => uint256) public deposited;
363   address public wallet;
364   State public state;
365 
366   event Closed();
367   event RefundsEnabled();
368   event Refunded(address indexed beneficiary, uint256 weiAmount);
369 
370   constructor(address _wallet) public {
371     require(_wallet != 0x0);
372     wallet = _wallet;
373     state = State.Active;
374   }
375 
376   function deposit(address investor) onlyOwner public payable {
377     require(state == State.Active);
378     deposited[investor] = deposited[investor].add(msg.value);
379   }
380 
381   function close() onlyOwner public {
382     require(state == State.Active);
383     state = State.Closed;
384     emit Closed();
385     wallet.transfer(address(this).balance);
386   }
387 
388   function enableRefunds() onlyOwner public {
389     require(state == State.Active);
390     state = State.Refunding;
391     emit RefundsEnabled();
392   }
393 
394   function refund(address investor) public {
395     require(state == State.Refunding);
396     uint256 depositedValue = deposited[investor];
397     deposited[investor] = 0;
398     investor.transfer(depositedValue);
399     emit Refunded(investor, depositedValue);
400   }
401 }
402 
403 contract RefundableCrowdsale is FinalizableCrowdsale {
404     using SafeMath for uint256;
405 
406     // minimum amount of funds to be raised in weis
407     uint256 internal goal;
408     bool internal _goalReached = false;
409     // refund vault used to hold funds while crowdsale is running
410     RefundVault private vault;
411 
412     constructor(uint256 _goal) public {
413         require(_goal > 0);
414         vault = new RefundVault(wallet);
415         goal = _goal;
416     }
417 
418     // We're overriding the fund forwarding from Crowdsale.
419     // In addition to sending the funds, we want to call
420     // the RefundVault deposit function
421     function forwardFunds() internal {
422         vault.deposit.value(msg.value)(msg.sender);
423     }
424 
425     // if crowdsale is unsuccessful, investors can claim refunds here
426     function claimRefund() public {
427         require(isFinalized);
428         require(!goalReached());
429 
430         vault.refund(msg.sender);
431     }
432 
433     // vault finalization task, called when owner calls finalize()
434     function finalization() internal {
435         if (goalReached()) {
436             vault.close();
437         } else {
438             vault.enableRefunds();
439         }
440         super.finalization();
441     }
442 
443     function goalReached() public returns (bool) {
444         if (weiRaised >= goal) {
445             _goalReached = true;
446         }
447 
448         return _goalReached;
449     }
450 
451     //  function updateGoalCheck() onlyOwner public {
452     //    _goalReached = true;
453     //  }
454 
455     function getVaultAddress() onlyOwner public view returns (address) {
456         return vault;
457     }
458 }
459 
460 contract BitNauticCrowdsale is CappedCrowdsale, RefundableCrowdsale {
461     uint256 constant public crowdsaleInitialSupply = 35000000 * 10 ** 18; // 70% of token cap
462 //    uint256 constant public crowdsaleSoftCap = 2 ether;
463 //    uint256 constant public crowdsaleHardCap = 10 ether;
464     uint256 constant public crowdsaleSoftCap = 5000 ether;
465     uint256 constant public crowdsaleHardCap = 50000 ether;
466 
467     uint256 constant public preICOStartTime = 1525132800;          // 2018-05-01 00:00 GMT+0
468     uint256 constant public mainICOStartTime = 1527811200;         // 2018-06-01 00:00 GMT+0
469     uint256 constant public mainICOFirstWeekEndTime = 1528416000;  // 2018-06-08 00:00 GMT+0
470     uint256 constant public mainICOSecondWeekEndTime = 1529020800; // 2018-06-15 00:00 GMT+0
471     uint256 constant public mainICOThirdWeekEndTime = 1529625600;  // 2018-06-22 00:00 GMT+0
472     uint256 constant public mainICOFourthWeekEndTime = 1530403200; // 2018-07-01 00:00 GMT+0
473     uint256 constant public mainICOEndTime = 1532995200;           // 2018-07-31 00:00 GMT+0
474 
475 //    uint256 public preICOStartTime = now;          // 2018-05-01 00:00 GMT+0
476 //    uint256 constant public mainICOStartTime = preICOStartTime;         // 2018-06-01 00:00 GMT+0
477 //    uint256 constant public mainICOFirstWeekEndTime = mainICOStartTime;  // 2018-06-08 00:00 GMT+0
478 //    uint256 constant public mainICOSecondWeekEndTime = mainICOFirstWeekEndTime; // 2018-06-15 00:00 GMT+0
479 //    uint256 constant public mainICOThirdWeekEndTime = mainICOSecondWeekEndTime;  // 2018-06-22 00:00 GMT+0
480 //    uint256 constant public mainICOFourthWeekEndTime = mainICOThirdWeekEndTime; // 2018-07-01 00:00 GMT+0
481 //    uint256 constant public mainICOEndTime = mainICOFourthWeekEndTime + 5 minutes;           // 2018-07-30 00:00 GMT+0
482 
483     uint256 constant public tokenBaseRate = 500; // 1 ETH = 500 BTNT
484 
485     // bonuses in percentage
486     uint256 constant public preICOBonus = 30;
487     uint256 constant public firstWeekBonus = 20;
488     uint256 constant public secondWeekBonus = 15;
489     uint256 constant public thirdWeekBonus = 10;
490     uint256 constant public fourthWeekBonus = 5;
491 
492     uint256 public teamSupply =     3000000 * 10 ** 18; // 6% of token cap
493     uint256 public bountySupply =   2500000 * 10 ** 18; // 5% of token cap
494     uint256 public reserveSupply =  5000000 * 10 ** 18; // 10% of token cap
495     uint256 public advisorSupply =  2500000 * 10 ** 18; // 5% of token cap
496     uint256 public founderSupply =  2000000 * 10 ** 18; // 4% of token cap
497 
498     // amount of tokens each address will receive at the end of the crowdsale
499     mapping (address => uint256) public creditOf;
500 
501     mapping (address => uint256) public weiInvestedBy;
502 
503     BitNauticWhitelist public whitelist;
504 
505     /** Constructor BitNauticICO */
506     constructor(BitNauticToken _token, BitNauticWhitelist _whitelist, address _wallet)
507     CappedCrowdsale(crowdsaleHardCap)
508     FinalizableCrowdsale()
509     RefundableCrowdsale(crowdsaleSoftCap)
510     Crowdsale(_token, crowdsaleInitialSupply, preICOStartTime, mainICOEndTime, _wallet) public
511     {
512         whitelist = _whitelist;
513     }
514 
515     function _tokenPurchased(address buyer, address beneficiary, uint256 weiAmount) internal returns (bool) {
516         require(SafeMath.add(weiInvestedBy[buyer], weiAmount) <= whitelist.contributionCap(buyer));
517 
518         uint256 tokens = SafeMath.mul(weiAmount, tokenBaseRate);
519 
520         tokens = tokens.add(SafeMath.mul(tokens, getCurrentBonus()).div(100));
521 
522         require(publicSupply >= tokens);
523 
524         publicSupply = publicSupply.sub(tokens);
525 
526         creditOf[beneficiary] = creditOf[beneficiary].add(tokens);
527         weiInvestedBy[buyer] = SafeMath.add(weiInvestedBy[buyer], weiAmount);
528 
529         emit TokenPurchase(buyer, beneficiary, weiAmount, tokens);
530 
531         return true;
532     }
533 
534     address constant public privateSaleWallet = 0x5A01D561AE864006c6B733f21f8D4311d1E1B42a;
535 
536     function goalReached() public returns (bool) {
537         if (weiRaised + privateSaleWallet.balance >= goal) {
538             _goalReached = true;
539         }
540 
541         return _goalReached;
542     }
543 
544     function getCurrentBonus() public view returns (uint256) {
545         if (now < mainICOStartTime) {
546             return preICOBonus;
547         } else if (now < mainICOFirstWeekEndTime) {
548             return firstWeekBonus;
549         } else if (now < mainICOSecondWeekEndTime) {
550             return secondWeekBonus;
551         } else if (now < mainICOThirdWeekEndTime) {
552             return thirdWeekBonus;
553         } else if (now < mainICOFourthWeekEndTime) {
554             return fourthWeekBonus;
555         } else {
556             return 0;
557         }
558     }
559 
560     function claimBitNauticTokens() public returns (bool) {
561         return grantInvestorTokens(msg.sender);
562     }
563 
564     function grantInvestorTokens(address investor) public returns (bool) {
565         require(creditOf[investor] > 0);
566         require(now > mainICOEndTime && whitelist.AMLWhitelisted(investor));
567         require(goalReached());
568 
569         assert(token.mint(investor, creditOf[investor]));
570         creditOf[investor] = 0;
571 
572         return true;
573     }
574 
575     function grantInvestorsTokens(address[] investors) public returns (bool) {
576         require(now > mainICOEndTime);
577         require(goalReached());
578 
579         for (uint256 i = 0; i < investors.length; i++) {
580             if (creditOf[investors[i]] > 0 && whitelist.AMLWhitelisted(investors[i])) {
581                 token.mint(investors[i], creditOf[investors[i]]);
582                 creditOf[investors[i]] = 0;
583             }
584         }
585 
586         return true;
587     }
588 
589     function bountyDrop(address[] recipients, uint256[] values) onlyOwner public returns (bool) {
590         require(now > mainICOEndTime);
591         require(goalReached());
592         require(recipients.length == values.length);
593 
594         for (uint256 i = 0; i < recipients.length; i++) {
595             values[i] = SafeMath.mul(values[i], 1 ether);
596             if (bountySupply >= values[i]) {
597                 return false;
598             }
599             bountySupply = SafeMath.sub(bountySupply, values[i]);
600             token.mint(recipients[i], values[i]);
601         }
602 
603         return true;
604     }
605 
606     uint256 public teamTimeLock = mainICOEndTime;
607     uint256 public founderTimeLock = mainICOEndTime + 365 days;
608     uint256 public advisorTimeLock = mainICOEndTime + 180 days;
609     uint256 public reserveTimeLock = mainICOEndTime;
610 
611     function grantAdvisorTokens(address advisorAddress) onlyOwner public {
612         require((advisorSupply > 0) && (advisorTimeLock < now));
613         require(goalReached());
614 
615         token.mint(advisorAddress, advisorSupply);
616         advisorSupply = 0;
617     }
618 
619     uint256 public teamVestingCounter = 0; // months of vesting
620 
621     function grantTeamTokens(address teamAddress) onlyOwner public {
622         require((teamVestingCounter < 12) && (teamTimeLock < now));
623         require(goalReached());
624 
625         teamTimeLock = SafeMath.add(teamTimeLock, 4 weeks);
626         token.mint(teamAddress, SafeMath.div(teamSupply, 12));
627         teamVestingCounter = SafeMath.add(teamVestingCounter, 1);
628     }
629 
630     function grantFounderTokens(address founderAddress) onlyOwner public {
631         require((founderSupply > 0) && (founderTimeLock < now));
632         require(goalReached());
633 
634         token.mint(founderAddress, founderSupply);
635         founderSupply = 0;
636     }
637 
638     function grantReserveTokens(address beneficiary) onlyOwner public {
639         require((reserveSupply > 0) && (now > reserveTimeLock));
640         require(goalReached());
641 
642         token.mint(beneficiary, reserveSupply);
643         reserveSupply = 0;
644     }
645 
646     function transferTokenOwnership(address newTokenOwner) onlyOwner public returns (bool) {
647         return token.transferOwnership(newTokenOwner);
648     }
649 }
650 
651 contract ERC20Basic {
652   uint256 public totalSupply;
653   function balanceOf(address who) public constant returns (uint256);
654   function transfer(address to, uint256 value) public returns (bool);
655   event Transfer(address indexed from, address indexed to, uint256 value);
656 }
657 
658 contract BasicToken is ERC20Basic {
659   using SafeMath for uint256;
660 
661   mapping(address => uint256) balances;
662 
663   /**
664   * @dev transfer token for a specified address
665   * @param _to The address to transfer to.
666   * @param _value The amount to be transferred.
667   */
668   function transfer(address _to, uint256 _value) public returns (bool) {
669     require(_to != address(0));
670 
671     // SafeMath.sub will throw if there is not enough balance.
672     balances[msg.sender] = balances[msg.sender].sub(_value);
673     balances[_to] = balances[_to].add(_value);
674     emit Transfer(msg.sender, _to, _value);
675     return true;
676   }
677 
678   /**
679   * @dev Gets the balance of the specified address.
680   * @param _owner The address to query the the balance of.
681   * @return An uint256 representing the amount owned by the passed address.
682   */
683   function balanceOf(address _owner) public constant returns (uint256 balance) {
684     return balances[_owner];
685   }
686 
687 }
688 
689 contract ERC20 is ERC20Basic {
690   function allowance(address owner, address spender) public constant returns (uint256);
691   function transferFrom(address from, address to, uint256 value) public returns (bool);
692   function approve(address spender, uint256 value) public returns (bool);
693   event Approval(address indexed owner, address indexed spender, uint256 value);
694 }
695 
696 contract StandardToken is ERC20, BasicToken {
697   mapping (address => mapping (address => uint256)) allowed;
698 
699   /**
700    * @dev Transfer tokens from one address to another
701    * @param _from address The address which you want to send tokens from
702    * @param _to address The address which you want to transfer to
703    * @param _value uint256 the amount of tokens to be transferred
704    */
705   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
706     require(_to != address(0));
707 
708     uint256 _allowance = allowed[_from][msg.sender];
709 
710     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
711     // require (_value <= _allowance);
712 
713     balances[_from] = balances[_from].sub(_value);
714     balances[_to] = balances[_to].add(_value);
715     allowed[_from][msg.sender] = _allowance.sub(_value);
716     emit Transfer(_from, _to, _value);
717     return true;
718   }
719 
720   /**
721    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
722    *
723    * Beware that changing an allowance with this method brings the risk that someone may use both the old
724    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
725    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
726    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
727    * @param _spender The address which will spend the funds.
728    * @param _value The amount of tokens to be spent.
729    */
730   function approve(address _spender, uint256 _value) public returns (bool) {
731     allowed[msg.sender][_spender] = _value;
732     emit Approval(msg.sender, _spender, _value);
733     return true;
734   }
735 
736   /**
737    * @dev Function to check the amount of tokens that an owner allowed to a spender.
738    * @param _owner address The address which owns the funds.
739    * @param _spender address The address which will spend the funds.
740    * @return A uint256 specifying the amount of tokens still available for the spender.
741    */
742   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
743     return allowed[_owner][_spender];
744   }
745 
746   /**
747    * approve should be called when allowed[_spender] == 0. To increment
748    * allowed value is better to use this function to avoid 2 calls (and wait until
749    * the first transaction is mined)
750    * From MonolithDAO Token.sol
751    */
752   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
753     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
754     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
755     return true;
756   }
757 
758   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
759     uint oldValue = allowed[msg.sender][_spender];
760     if (_subtractedValue > oldValue) {
761       allowed[msg.sender][_spender] = 0;
762     } else {
763       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
764     }
765     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
766     return true;
767   }
768 }
769 
770 contract MintableToken is StandardToken, Ownable {
771   event Mint(address indexed to, uint256 amount);
772   event MintFinished();
773 
774   bool public mintingFinished = false;
775 
776   modifier canMint() {
777     require(!mintingFinished);
778     _;
779   }
780 
781   /**
782    * @dev Function to mint tokens
783    * @param _to The address that will receive the minted tokens.
784    * @param _amount The amount of tokens to mint.
785    * @return A boolean that indicates if the operation was successful.
786    */
787 
788   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
789     totalSupply = SafeMath.add(totalSupply, _amount);
790     balances[_to] = balances[_to].add(_amount);
791     emit Mint(_to, _amount);
792     emit Transfer(0x0, _to, _amount);
793     return true;
794   }
795 
796   /**
797    * @dev Function to stop minting new tokens.
798    * @return True if the operation was successful.
799    */
800 //  function finishMinting() onlyOwner public returns (bool) {
801 //    mintingFinished = true;
802 //    emit MintFinished();
803 //    return true;
804 //  }
805 
806   function burnTokens(uint256 _unsoldTokens) onlyOwner canMint public returns (bool) {
807     totalSupply = SafeMath.sub(totalSupply, _unsoldTokens);
808   }
809 }
810 
811 contract CappedToken is MintableToken {
812   uint256 public cap;
813 
814   constructor(uint256 _cap) public {
815     require(_cap > 0);
816     cap = _cap;
817   }
818 
819   /**
820    * @dev Function to mint tokens
821    * @param _to The address that will receive the minted tokens.
822    * @param _amount The amount of tokens to mint.
823    * @return A boolean that indicates if the operation was successful.
824    */
825   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
826     require(totalSupply.add(_amount) <= cap);
827 
828     return super.mint(_to, _amount);
829   }
830 }
831 
832 contract BitNauticToken is CappedToken {
833   string public constant name = "BitNautic Token";
834   string public constant symbol = "BTNT";
835   uint8 public constant decimals = 18;
836 
837   uint256 public totalSupply = 0;
838 
839   constructor()
840   CappedToken(50000000 * 10 ** uint256(decimals)) public
841   {
842 
843   }
844 }