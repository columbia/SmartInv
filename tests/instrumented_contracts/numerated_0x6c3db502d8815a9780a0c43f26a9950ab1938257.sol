1 pragma solidity 0.4.24;
2 
3 // File: contracts/tokensale/DipTgeInterface.sol
4 
5 contract DipTgeInterface {
6     function tokenIsLocked(address _contributor) public constant returns (bool);
7 }
8 
9 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
10 
11 /**
12  * @title Ownable
13  * @dev The Ownable contract has an owner address, and provides basic authorization control
14  * functions, this simplifies the implementation of "user permissions".
15  */
16 contract Ownable {
17   address public owner;
18 
19 
20   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   function Ownable() {
28     owner = msg.sender;
29   }
30 
31 
32   /**
33    * @dev Throws if called by any account other than the owner.
34    */
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) onlyOwner public {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 // File: zeppelin-solidity/contracts/math/SafeMath.sol
54 
55 /**
56  * @title SafeMath
57  * @dev Math operations with safety checks that throw on error
58  */
59 library SafeMath {
60   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
61     uint256 c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function div(uint256 a, uint256 b) internal constant returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function add(uint256 a, uint256 b) internal constant returns (uint256) {
79     uint256 c = a + b;
80     assert(c >= a);
81     return c;
82   }
83 }
84 
85 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
86 
87 /**
88  * @title ERC20Basic
89  * @dev Simpler version of ERC20 interface
90  * @dev see https://github.com/ethereum/EIPs/issues/179
91  */
92 contract ERC20Basic {
93   uint256 public totalSupply;
94   function balanceOf(address who) public constant returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 // File: zeppelin-solidity/contracts/token/BasicToken.sol
100 
101 /**
102  * @title Basic token
103  * @dev Basic version of StandardToken, with no allowances.
104  */
105 contract BasicToken is ERC20Basic {
106   using SafeMath for uint256;
107 
108   mapping(address => uint256) balances;
109 
110   /**
111   * @dev transfer token for a specified address
112   * @param _to The address to transfer to.
113   * @param _value The amount to be transferred.
114   */
115   function transfer(address _to, uint256 _value) public returns (bool) {
116     require(_to != address(0));
117 
118     // SafeMath.sub will throw if there is not enough balance.
119     balances[msg.sender] = balances[msg.sender].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param _owner The address to query the the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address _owner) public constant returns (uint256 balance) {
131     return balances[_owner];
132   }
133 
134 }
135 
136 // File: zeppelin-solidity/contracts/token/ERC20.sol
137 
138 /**
139  * @title ERC20 interface
140  * @dev see https://github.com/ethereum/EIPs/issues/20
141  */
142 contract ERC20 is ERC20Basic {
143   function allowance(address owner, address spender) public constant returns (uint256);
144   function transferFrom(address from, address to, uint256 value) public returns (bool);
145   function approve(address spender, uint256 value) public returns (bool);
146   event Approval(address indexed owner, address indexed spender, uint256 value);
147 }
148 
149 // File: zeppelin-solidity/contracts/token/StandardToken.sol
150 
151 /**
152  * @title Standard ERC20 token
153  *
154  * @dev Implementation of the basic standard token.
155  * @dev https://github.com/ethereum/EIPs/issues/20
156  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
157  */
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) allowed;
161 
162 
163   /**
164    * @dev Transfer tokens from one address to another
165    * @param _from address The address which you want to send tokens from
166    * @param _to address The address which you want to transfer to
167    * @param _value uint256 the amount of tokens to be transferred
168    */
169   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
170     require(_to != address(0));
171 
172     uint256 _allowance = allowed[_from][msg.sender];
173 
174     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
175     // require (_value <= _allowance);
176 
177     balances[_from] = balances[_from].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     allowed[_from][msg.sender] = _allowance.sub(_value);
180     Transfer(_from, _to, _value);
181     return true;
182   }
183 
184   /**
185    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186    *
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211    * approve should be called when allowed[_spender] == 0. To increment
212    * allowed value is better to use this function to avoid 2 calls (and wait until
213    * the first transaction is mined)
214    * From MonolithDAO Token.sol
215    */
216   function increaseApproval (address _spender, uint _addedValue)
217     returns (bool success) {
218     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223   function decreaseApproval (address _spender, uint _subtractedValue)
224     returns (bool success) {
225     uint oldValue = allowed[msg.sender][_spender];
226     if (_subtractedValue > oldValue) {
227       allowed[msg.sender][_spender] = 0;
228     } else {
229       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
230     }
231     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235 }
236 
237 // File: zeppelin-solidity/contracts/token/MintableToken.sol
238 
239 /**
240  * @title Mintable token
241  * @dev Simple ERC20 Token example, with mintable token creation
242  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
243  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
244  */
245 
246 contract MintableToken is StandardToken, Ownable {
247   event Mint(address indexed to, uint256 amount);
248   event MintFinished();
249 
250   bool public mintingFinished = false;
251 
252 
253   modifier canMint() {
254     require(!mintingFinished);
255     _;
256   }
257 
258   /**
259    * @dev Function to mint tokens
260    * @param _to The address that will receive the minted tokens.
261    * @param _amount The amount of tokens to mint.
262    * @return A boolean that indicates if the operation was successful.
263    */
264   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
265     totalSupply = totalSupply.add(_amount);
266     balances[_to] = balances[_to].add(_amount);
267     Mint(_to, _amount);
268     Transfer(0x0, _to, _amount);
269     return true;
270   }
271 
272   /**
273    * @dev Function to stop minting new tokens.
274    * @return True if the operation was successful.
275    */
276   function finishMinting() onlyOwner public returns (bool) {
277     mintingFinished = true;
278     MintFinished();
279     return true;
280   }
281 }
282 
283 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
284 
285 /**
286  * @title Pausable
287  * @dev Base contract which allows children to implement an emergency stop mechanism.
288  */
289 contract Pausable is Ownable {
290   event Pause();
291   event Unpause();
292 
293   bool public paused = false;
294 
295 
296   /**
297    * @dev Modifier to make a function callable only when the contract is not paused.
298    */
299   modifier whenNotPaused() {
300     require(!paused);
301     _;
302   }
303 
304   /**
305    * @dev Modifier to make a function callable only when the contract is paused.
306    */
307   modifier whenPaused() {
308     require(paused);
309     _;
310   }
311 
312   /**
313    * @dev called by the owner to pause, triggers stopped state
314    */
315   function pause() onlyOwner whenNotPaused public {
316     paused = true;
317     Pause();
318   }
319 
320   /**
321    * @dev called by the owner to unpause, returns to normal state
322    */
323   function unpause() onlyOwner whenPaused public {
324     paused = false;
325     Unpause();
326   }
327 }
328 
329 // File: zeppelin-solidity/contracts/token/PausableToken.sol
330 
331 /**
332  * @title Pausable token
333  *
334  * @dev StandardToken modified with pausable transfers.
335  **/
336 
337 contract PausableToken is StandardToken, Pausable {
338 
339   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transfer(_to, _value);
341   }
342 
343   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
344     return super.transferFrom(_from, _to, _value);
345   }
346 
347   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
348     return super.approve(_spender, _value);
349   }
350 
351   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
352     return super.increaseApproval(_spender, _addedValue);
353   }
354 
355   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
356     return super.decreaseApproval(_spender, _subtractedValue);
357   }
358 }
359 
360 // File: contracts/token/DipToken.sol
361 
362 /**
363  * @title DIP Token
364  * @dev The Decentralized Insurance Platform Token.
365  * @author Christoph Mussenbrock
366  * @copyright 2017 Etherisc GmbH
367  */
368 
369 pragma solidity 0.4.24;
370 
371 
372 
373 
374 
375 contract DipToken is PausableToken, MintableToken {
376 
377   string public constant name = "Decentralized Insurance Protocol";
378   string public constant symbol = "DIP";
379   uint256 public constant decimals = 18;
380   uint256 public constant MAXIMUM_SUPPLY = 10**9 * 10**18; // 1 Billion 1'000'000'000
381 
382   DipTgeInterface public DipTokensale;
383 
384   constructor() public {
385     DipTokensale = DipTgeInterface(owner);
386   }
387 
388   modifier shouldNotBeLockedIn(address _contributor) {
389     // after LockIntTime2, we don't need to check anymore, and
390     // the DipTokensale contract is no longer required.
391     require(DipTokensale.tokenIsLocked(_contributor) == false);
392     _;
393   }
394 
395   /**
396    * @dev Function to mint tokens
397    * @param _to The address that will recieve the minted tokens.
398    * @param _amount The amount of tokens to mint.
399    * @return A boolean that indicates if the operation was successful.
400    */
401   function mint(address _to, uint256 _amount) public returns (bool) {
402     if (totalSupply.add(_amount) > MAXIMUM_SUPPLY) {
403       return false;
404     }
405 
406     return super.mint(_to, _amount);
407   }
408 
409   /**
410    * Owner can transfer back tokens which have been sent to this contract by mistake.
411    * @param  _token address of token contract of the respective tokens
412    * @param  _to where to send the tokens
413    */
414   function salvageTokens(ERC20Basic _token, address _to) onlyOwner public {
415     _token.transfer(_to, _token.balanceOf(this));
416   }
417 
418   function transferFrom(address _from, address _to, uint256 _value) shouldNotBeLockedIn(_from) public returns (bool) {
419       return super.transferFrom(_from, _to, _value);
420   }
421 
422   function transfer(address to, uint256 value) shouldNotBeLockedIn(msg.sender) public returns (bool) {
423       return super.transfer(to, value);
424   }
425 }
426 
427 // File: zeppelin-solidity/contracts/crowdsale/Crowdsale.sol
428 
429 /**
430  * @title Crowdsale
431  * @dev Crowdsale is a base contract for managing a token crowdsale.
432  * Crowdsales have a start and end timestamps, where investors can make
433  * token purchases and the crowdsale will assign them tokens based
434  * on a token per ETH rate. Funds collected are forwarded to a wallet
435  * as they arrive.
436  */
437 contract Crowdsale {
438   using SafeMath for uint256;
439 
440   // The token being sold
441   MintableToken public token;
442 
443   // start and end timestamps where investments are allowed (both inclusive)
444   uint256 public startTime;
445   uint256 public endTime;
446 
447   // address where funds are collected
448   address public wallet;
449 
450   // how many token units a buyer gets per wei
451   uint256 public rate;
452 
453   // amount of raised money in wei
454   uint256 public weiRaised;
455 
456   /**
457    * event for token purchase logging
458    * @param purchaser who paid for the tokens
459    * @param beneficiary who got the tokens
460    * @param value weis paid for purchase
461    * @param amount amount of tokens purchased
462    */
463   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
464 
465 
466   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
467     require(_startTime >= now);
468     require(_endTime >= _startTime);
469     require(_rate > 0);
470     require(_wallet != 0x0);
471 
472     token = createTokenContract();
473     startTime = _startTime;
474     endTime = _endTime;
475     rate = _rate;
476     wallet = _wallet;
477   }
478 
479   // creates the token to be sold.
480   // override this method to have crowdsale of a specific mintable token.
481   function createTokenContract() internal returns (MintableToken) {
482     return new MintableToken();
483   }
484 
485 
486   // fallback function can be used to buy tokens
487   function () payable {
488     buyTokens(msg.sender);
489   }
490 
491   // low level token purchase function
492   function buyTokens(address beneficiary) public payable {
493     require(beneficiary != 0x0);
494     require(validPurchase());
495 
496     uint256 weiAmount = msg.value;
497 
498     // calculate token amount to be created
499     uint256 tokens = weiAmount.mul(rate);
500 
501     // update state
502     weiRaised = weiRaised.add(weiAmount);
503 
504     token.mint(beneficiary, tokens);
505     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
506 
507     forwardFunds();
508   }
509 
510   // send ether to the fund collection wallet
511   // override to create custom fund forwarding mechanisms
512   function forwardFunds() internal {
513     wallet.transfer(msg.value);
514   }
515 
516   // @return true if the transaction can buy tokens
517   function validPurchase() internal constant returns (bool) {
518     bool withinPeriod = now >= startTime && now <= endTime;
519     bool nonZeroPurchase = msg.value != 0;
520     return withinPeriod && nonZeroPurchase;
521   }
522 
523   // @return true if crowdsale event has ended
524   function hasEnded() public constant returns (bool) {
525     return now > endTime;
526   }
527 
528 
529 }
530 
531 // File: contracts/tokensale/DipWhitelistedCrowdsale.sol
532 
533 /**
534  * @title DIP Token Generating Event
535  * @dev The Decentralized Insurance Platform Token.
536  * @author Christoph Mussenbrock
537  * @copyright 2017 Etherisc GmbH
538  */
539 
540 pragma solidity 0.4.24;
541 
542 
543 
544 
545 
546 contract DipWhitelistedCrowdsale is Ownable {
547   using SafeMath for uint256;
548 
549   struct ContributorData {
550     uint256 allowance;
551     uint256 contributionAmount;
552     uint256 tokensIssued;
553     bool airdrop;
554     uint256 bonus;        // 0 == 0%, 4 == 25%, 10 == 10%
555     uint256 lockupPeriod; // 0, 1 or 2 (years)
556   }
557 
558   mapping (address => ContributorData) public contributorList;
559 
560   event Whitelisted(address indexed _contributor, uint256 _allowance, bool _airdrop, uint256 _bonus, uint256 _lockupPeriod);
561 
562   /**
563    * Push contributor data to the contract before the crowdsale
564    */
565   function editContributors (
566     address[] _contributorAddresses,
567     uint256[] _contributorAllowance,
568     bool[] _airdrop,
569     uint256[] _bonus,
570     uint256[] _lockupPeriod
571   ) onlyOwner public {
572     // Check if input data is consistent
573     require(
574       _contributorAddresses.length == _contributorAllowance.length &&
575       _contributorAddresses.length == _airdrop.length &&
576       _contributorAddresses.length == _bonus.length &&
577       _contributorAddresses.length == _lockupPeriod.length
578     );
579 
580     for (uint256 cnt = 0; cnt < _contributorAddresses.length; cnt = cnt.add(1)) {
581       require(_bonus[cnt] == 0 || _bonus[cnt] == 4 || _bonus[cnt] == 10);
582       require(_lockupPeriod[cnt] <= 2);
583 
584       address contributor = _contributorAddresses[cnt];
585       contributorList[contributor].allowance = _contributorAllowance[cnt];
586       contributorList[contributor].airdrop = _airdrop[cnt];
587       contributorList[contributor].bonus = _bonus[cnt];
588       contributorList[contributor].lockupPeriod = _lockupPeriod[cnt];
589 
590       emit Whitelisted(
591         _contributorAddresses[cnt],
592         _contributorAllowance[cnt],
593         _airdrop[cnt],
594         _bonus[cnt],
595         _lockupPeriod[cnt]
596       );
597     }
598   }
599 
600 }
601 
602 // File: zeppelin-solidity/contracts/crowdsale/FinalizableCrowdsale.sol
603 
604 /**
605  * @title FinalizableCrowdsale
606  * @dev Extension of Crowdsale where an owner can do extra work
607  * after finishing.
608  */
609 contract FinalizableCrowdsale is Crowdsale, Ownable {
610   using SafeMath for uint256;
611 
612   bool public isFinalized = false;
613 
614   event Finalized();
615 
616   /**
617    * @dev Must be called after crowdsale ends, to do some extra finalization
618    * work. Calls the contract's finalization function.
619    */
620   function finalize() onlyOwner public {
621     require(!isFinalized);
622     require(hasEnded());
623 
624     finalization();
625     Finalized();
626 
627     isFinalized = true;
628   }
629 
630   /**
631    * @dev Can be overridden to add finalization logic. The overriding function
632    * should call super.finalization() to ensure the chain of finalization is
633    * executed entirely.
634    */
635   function finalization() internal {
636   }
637 }
638 
639 // File: contracts/tokensale/DipTge.sol
640 
641 /**
642  * @title DIP Token Generating Event
643  * @notice The Decentralized Insurance Platform Token.
644  * @author Christoph Mussenbrock
645  *
646  * @copyright 2017 Etherisc GmbH
647  */
648 
649 pragma solidity 0.4.24;
650 
651 
652 
653 
654 
655 
656 
657 contract DipTge is DipWhitelistedCrowdsale, FinalizableCrowdsale {
658 
659   using SafeMath for uint256;
660 
661   enum state { pendingStart, priorityPass, crowdsale, crowdsaleEnded }
662 
663   uint256 public startOpenPpTime;
664   uint256 public hardCap;
665   uint256 public lockInTime1; // token lock-in period for team, ECA, US accredited investors
666   uint256 public lockInTime2; // token lock-in period for founders
667   state public crowdsaleState = state.pendingStart;
668 
669   event DipTgeStarted(uint256 _time);
670   event CrowdsaleStarted(uint256 _time);
671   event HardCapReached(uint256 _time);
672   event DipTgeEnded(uint256 _time);
673   event TokenAllocated(address _beneficiary, uint256 _amount);
674 
675   constructor(
676     uint256 _startTime,
677     uint256 _startOpenPpTime,
678     uint256 _endTime,
679     uint256 _lockInTime1,
680     uint256 _lockInTime2,
681     uint256 _hardCap,
682     uint256 _rate,
683     address _wallet
684   )
685     Crowdsale(_startTime, _endTime, _rate, _wallet)
686     public
687   {
688     // Check arguments
689     require(_startTime >= block.timestamp);
690     require(_startOpenPpTime >= _startTime);
691     require(_endTime >= _startOpenPpTime);
692     require(_lockInTime1 >= _endTime);
693     require(_lockInTime2 > _lockInTime1);
694     require(_hardCap > 0);
695     require(_rate > 0);
696     require(_wallet != 0x0);
697 
698     // Set contract fields
699     startOpenPpTime = _startOpenPpTime;
700     hardCap = _hardCap;
701     lockInTime1 = _lockInTime1;
702     lockInTime2 = _lockInTime2;
703     DipToken(token).pause();
704   }
705 
706   function setRate(uint256 _rate) onlyOwner public {
707     require(crowdsaleState == state.pendingStart);
708 
709     rate = _rate;
710   }
711 
712   function unpauseToken() onlyOwner external {
713     DipToken(token).unpause();
714   }
715 
716   /**
717    * Calculate the maximum remaining contribution allowed for an address
718    * @param  _contributor the address of the contributor
719    * @return maxContribution maximum allowed amount in wei
720    */
721   function calculateMaxContribution(address _contributor) public constant returns (uint256 _maxContribution) {
722     uint256 maxContrib = 0;
723 
724     if (crowdsaleState == state.priorityPass) {
725       maxContrib = contributorList[_contributor].allowance.sub(contributorList[_contributor].contributionAmount);
726 
727       if (maxContrib > hardCap.sub(weiRaised)) {
728         maxContrib = hardCap.sub(weiRaised);
729       }
730     } else if (crowdsaleState == state.crowdsale) {
731       if (contributorList[_contributor].allowance > 0) {
732         maxContrib = hardCap.sub(weiRaised);
733       }
734     }
735 
736     return maxContrib;
737   }
738 
739   /**
740    * Calculate amount of tokens
741    * This is used twice:
742    * 1) For calculation of token amount plus optional bonus from wei amount contributed
743    * In this case, rate is the defined exchange rate of ETH against DIP.
744    * 2) For calculation of token amount plus optional bonus from DIP token amount
745    * In the second case, rate == 1 because we have already calculated DIP tokens from RSC amount
746    * by applying a factor of 10/32.
747    * @param _contributor the address of the contributor
748    * @param _amount contribution amount
749    * @return _tokens amount of tokens
750    */
751   function calculateTokens(address _contributor, uint256 _amount, uint256 _rate) public constant returns (uint256 _tokens) {
752     uint256 bonus = contributorList[_contributor].bonus;
753 
754     assert(bonus == 0 || bonus == 4 || bonus == 10);
755 
756     if (bonus > 0) {
757       _tokens = _amount.add(_amount.div(bonus)).mul(_rate);
758     } else {
759       _tokens = _amount.mul(_rate);
760     }
761   }
762 
763   /**
764    * Set the current state of the crowdsale.
765    */
766   function setCrowdsaleState() public {
767     if (weiRaised >= hardCap && crowdsaleState != state.crowdsaleEnded) {
768 
769       crowdsaleState = state.crowdsaleEnded;
770       emit HardCapReached(block.timestamp);
771       emit DipTgeEnded(block.timestamp);
772 
773     } else if (
774       block.timestamp >= startTime &&
775       block.timestamp < startOpenPpTime &&
776       crowdsaleState != state.priorityPass
777     ) {
778 
779       crowdsaleState = state.priorityPass;
780       emit DipTgeStarted(block.timestamp);
781 
782     } else if (
783       block.timestamp >= startOpenPpTime &&
784       block.timestamp <= endTime &&
785       crowdsaleState != state.crowdsale
786     ) {
787 
788       crowdsaleState = state.crowdsale;
789       emit CrowdsaleStarted(block.timestamp);
790 
791     } else if (
792       crowdsaleState != state.crowdsaleEnded &&
793       block.timestamp > endTime
794     ) {
795 
796       crowdsaleState = state.crowdsaleEnded;
797       emit DipTgeEnded(block.timestamp);
798     }
799   }
800 
801   /**
802    * The token buying function.
803    * @param  _beneficiary  receiver of tokens.
804    */
805   function buyTokens(address _beneficiary) public payable {
806     require(_beneficiary != 0x0);
807     require(validPurchase());
808     require(contributorList[_beneficiary].airdrop == false);
809 
810     setCrowdsaleState();
811 
812     uint256 weiAmount = msg.value;
813     uint256 maxContrib = calculateMaxContribution(_beneficiary);
814     uint256 refund;
815 
816     if (weiAmount > maxContrib) {
817       refund = weiAmount.sub(maxContrib);
818       weiAmount = maxContrib;
819     }
820 
821     // stop here if transaction does not yield tokens
822     require(weiAmount > 0);
823 
824     // calculate token amount to be created
825     uint256 tokens = calculateTokens(_beneficiary, weiAmount, rate);
826 
827     assert(tokens > 0);
828 
829     // update state
830     weiRaised = weiRaised.add(weiAmount);
831 
832     require(token.mint(_beneficiary, tokens));
833     emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
834 
835     contributorList[_beneficiary].contributionAmount = contributorList[_beneficiary].contributionAmount.add(weiAmount);
836     contributorList[_beneficiary].tokensIssued = contributorList[_beneficiary].tokensIssued.add(tokens);
837 
838     wallet.transfer(weiAmount);
839 
840     if (refund != 0) _beneficiary.transfer(refund);
841   }
842 
843   /**
844    * Check if token is locked.
845    */
846   function tokenIsLocked(address _contributor) public constant returns (bool) {
847 
848     if (block.timestamp < lockInTime1 && contributorList[_contributor].lockupPeriod == 1) {
849       return true;
850     } else if (block.timestamp < lockInTime2 && contributorList[_contributor].lockupPeriod == 2) {
851       return true;
852     }
853 
854     return false;
855 
856   }
857 
858 
859   /**
860    * Distribute tokens to selected team members & founders.
861    * Unit of Allowance is ETH and is converted in number of tokens by multiplying with Rate.
862    * This can be called by any whitelisted beneficiary.
863    */
864   function airdrop() public {
865     airdropFor(msg.sender);
866   }
867 
868 
869   /**
870    * Alternatively to airdrop(); tokens can be directly sent to beneficiaries by this function
871    * This can be called only once.
872    */
873   function airdropFor(address _beneficiary) public {
874     require(_beneficiary != 0x0);
875     require(contributorList[_beneficiary].airdrop == true);
876     require(contributorList[_beneficiary].tokensIssued == 0);
877     require(contributorList[_beneficiary].allowance > 0);
878 
879     setCrowdsaleState();
880 
881     require(crowdsaleState == state.crowdsaleEnded);
882 
883     uint256 amount = contributorList[_beneficiary].allowance.mul(rate);
884     require(token.mint(_beneficiary, amount));
885     emit TokenAllocated(_beneficiary, amount);
886 
887     contributorList[_beneficiary].tokensIssued = contributorList[_beneficiary].tokensIssued.add(amount);
888   }
889 
890   /**
891    * Creates an new ERC20 Token contract for the DIP Token.
892    * Overrides Crowdsale function
893    * @return the created token
894    */
895   function createTokenContract() internal returns (MintableToken) {
896     return new DipToken();
897   }
898 
899   /**
900    * Finalize sale and perform cleanup actions.
901    */
902   function finalization() internal {
903     uint256 maxSupply = DipToken(token).MAXIMUM_SUPPLY();
904     token.mint(wallet, maxSupply.sub(token.totalSupply())); // Alternativly, hardcode remaining token distribution.
905     token.finishMinting();
906     token.transferOwnership(owner);
907   }
908 
909   /**
910    * Owner can transfer back tokens which have been sent to this contract by mistake.
911    * @param  _token address of token contract of the respective tokens
912    * @param  _to where to send the tokens
913    */
914   function salvageTokens(ERC20Basic _token, address _to) onlyOwner external {
915     _token.transfer(_to, _token.balanceOf(this));
916   }
917 }
918 
919 // File: contracts/rscconversion/RSCConversion.sol
920 
921 /**
922  * @title RSC Conversion Contract
923  * @dev The Decentralized Insurance Platform Token.
924  * @author Christoph Mussenbrock
925  * @copyright 2017 Etherisc GmbH
926  */
927 
928 pragma solidity 0.4.24;
929 
930 
931 
932 
933 
934 
935 contract RSCConversion is Ownable {
936 
937   using SafeMath for *;
938 
939   ERC20 public DIP;
940   DipTge public DIP_TGE;
941   ERC20 public RSC;
942   address public DIP_Pool;
943 
944   uint256 public constant CONVERSION_NUMINATOR = 10;
945   uint256 public constant CONVERSION_DENOMINATOR = 32;
946   uint256 public constant CONVERSION_DECIMAL_FACTOR = 10 ** (18 - 3);
947 
948   event Conversion(uint256 _rscAmount, uint256 _dipAmount, uint256 _bonus);
949 
950   constructor (
951       address _dipToken,
952       address _dipTge,
953       address _rscToken,
954       address _dipPool) public {
955     require(_dipToken != address(0));
956     require(_dipTge != address(0));
957     require(_rscToken != address(0));
958     require(_dipPool != address(0));
959 
960     DIP = ERC20(_dipToken);
961     DIP_TGE = DipTge(_dipTge);
962     RSC = ERC20(_rscToken);
963     DIP_Pool = _dipPool;
964   }
965 
966   /* fallback function converts all RSC */
967   function () public {
968     convert(RSC.balanceOf(msg.sender));
969   }
970 
971   function convert(
972     uint256 _rscAmount
973   ) public {
974 
975     uint256 allowance;
976     uint256 bonus;
977     uint256 lockupPeriod;
978     uint256 dipAmount;
979 
980     (allowance, /* contributionAmount */, /* tokensIssued */, /* airDrop */, bonus, lockupPeriod) =
981       DIP_TGE.contributorList(msg.sender);
982 
983     require(allowance > 0);
984     require(RSC.transferFrom(msg.sender, DIP_Pool, _rscAmount));
985     dipAmount = _rscAmount.mul(CONVERSION_DECIMAL_FACTOR).mul(CONVERSION_NUMINATOR).div(CONVERSION_DENOMINATOR);
986 
987     if (bonus > 0) {
988       require(lockupPeriod == 1);
989       dipAmount = dipAmount.add(dipAmount.div(bonus));
990     }
991     require(DIP.transferFrom(DIP_Pool, msg.sender, dipAmount));
992     emit Conversion(_rscAmount, dipAmount, bonus);
993   }
994 
995   /**
996    * Owner can transfer back tokens which have been sent to this contract by mistake.
997    * @param  _token address of token contract of the respective tokens
998    * @param  _to where to send the tokens
999    */
1000   function salvageTokens(ERC20 _token, address _to) onlyOwner external {
1001     _token.transfer(_to, _token.balanceOf(this));
1002   }
1003 
1004 }