1 pragma solidity ^0.4.11;
2 
3 //
4 // SafeMath
5 //
6 // Ownable
7 // Destructible
8 // Pausable
9 //
10 // ERC20Basic
11 // ERC20 : ERC20Basic
12 // BasicToken : ERC20Basic
13 // StandardToken : ERC20, BasicToken
14 // MintableToken : StandardToken, Ownable
15 // PausableToken : StandardToken, Pausable
16 //
17 // CAToken : MintableToken, PausableToken
18 //
19 // Crowdsale
20 // PausableCrowdsale
21 // BonusCrowdsale
22 // TokensCappedCrowdsale
23 // FinalizableCrowdsale
24 //
25 // CATCrowdsale
26 //
27 
28 // Date.now()/1000+3600,  Date.now()/1000+3600*2, 4700, "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4"
29 // 1508896220, 1509899832, 4700, "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4", "0x00A617f5bE726F92B29985bB4c1850630d907db4"
30 // 1507909923, 1508514723, 4700, "0x0b8e27013dfA822bF1cc01b6Ae394B76DA230a03", "0x5F85A0e9DD5Bd2F11a54b208427b286e9B0B519F", "0x7F781d08FD165DBEE1D573Bdb79c43045442eac4", "0x98bf67b6a03DA7AcF2Ee7348FdB3F9c96425a130"
31 // 1509120669, 1519120669, 3000, "0x06E58BD5DeEC639d9a79c9cD3A653655EdBef820", "0x06E58BD5DeEC639d9a79c9cD3A653655EdBef820", "0x06E58BD5DeEC639d9a79c9cD3A653655EdBef820"
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 library SafeMath {
38   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return c;
49   }
50 
51   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) onlyOwner public {
98     require(newOwner != address(0));
99     OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 /**
106  * @title Destructible
107  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
108  */
109 contract Destructible is Ownable {
110 
111   function Destructible() public payable { }
112 
113   /**
114    * @dev Transfers the current balance to the owner and terminates the contract.
115    */
116   function destroy() onlyOwner public {
117     selfdestruct(owner);
118   }
119 
120   function destroyAndSend(address _recipient) onlyOwner public {
121     selfdestruct(_recipient);
122   }
123 }
124 
125 /**
126  * @title Pausable
127  * @dev Base contract which allows children to implement an emergency stop mechanism.
128  */
129 contract Pausable is Ownable {
130   event Pause();
131   event Unpause();
132 
133   bool public paused = false;
134 
135 
136   /**
137    * @dev Modifier to make a function callable only when the contract is not paused.
138    */
139   modifier whenNotPaused() {
140     require(!paused);
141     _;
142   }
143 
144   /**
145    * @dev Modifier to make a function callable only when the contract is paused.
146    */
147   modifier whenPaused() {
148     require(paused);
149     _;
150   }
151 
152   /**
153    * @dev called by the owner to pause, triggers stopped state
154    */
155   function pause() onlyOwner whenNotPaused public {
156     paused = true;
157     Pause();
158   }
159 
160   /**
161    * @dev called by the owner to unpause, returns to normal state
162    */
163   function unpause() onlyOwner whenPaused public {
164     paused = false;
165     Unpause();
166   }
167 }
168 
169 /**
170  * @title ERC20Basic
171  * @dev Simpler version of ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/179
173  */
174 contract ERC20Basic {
175   uint256 public totalSupply;
176   function balanceOf(address who) public constant returns (uint256);
177   function transfer(address to, uint256 value) public returns (bool);
178   event Transfer(address indexed from, address indexed to, uint256 value);
179 }
180 
181 /**
182  * @title ERC20 interface
183  * @dev see https://github.com/ethereum/EIPs/issues/20
184  */
185 contract ERC20 is ERC20Basic {
186   function allowance(address owner, address spender) public constant returns (uint256);
187   function transferFrom(address from, address to, uint256 value) public returns (bool);
188   function approve(address spender, uint256 value) public returns (bool);
189   event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191 
192 /**
193  * @title Basic token
194  * @dev Basic version of StandardToken, with no allowances.
195  */
196 contract BasicToken is ERC20Basic {
197   using SafeMath for uint256;
198 
199   mapping(address => uint256) balances;
200 
201   /**
202   * @dev transfer token for a specified address
203   * @param _to The address to transfer to.
204   * @param _value The amount to be transferred.
205   */
206   function transfer(address _to, uint256 _value) public returns (bool) {
207     require(_to != address(0));
208 
209     // SafeMath.sub will throw if there is not enough balance.
210     balances[msg.sender] = balances[msg.sender].sub(_value);
211     balances[_to] = balances[_to].add(_value);
212     Transfer(msg.sender, _to, _value);
213     return true;
214   }
215 
216   /**
217   * @dev Gets the balance of the specified address.
218   * @param _owner The address to query the the balance of.
219   * @return An uint256 representing the amount owned by the passed address.
220   */
221   function balanceOf(address _owner) public constant returns (uint256 balance) {
222     return balances[_owner];
223   }
224 
225 }
226 
227 /**
228  * @title Standard ERC20 token
229  *
230  * @dev Implementation of the basic standard token.
231  * @dev https://github.com/ethereum/EIPs/issues/20
232  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
233  */
234 contract StandardToken is ERC20, BasicToken {
235 
236   mapping (address => mapping (address => uint256)) allowed;
237 
238 
239   /**
240    * @dev Transfer tokens from one address to another
241    * @param _from address The address which you want to send tokens from
242    * @param _to address The address which you want to transfer to
243    * @param _value uint256 the amount of tokens to be transferred
244    */
245   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
246     require(_to != address(0));
247 
248     uint256 _allowance = allowed[_from][msg.sender];
249 
250     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
251     // require (_value <= _allowance);
252 
253     balances[_from] = balances[_from].sub(_value);
254     balances[_to] = balances[_to].add(_value);
255     allowed[_from][msg.sender] = _allowance.sub(_value);
256     Transfer(_from, _to, _value);
257     return true;
258   }
259 
260   /**
261    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
262    *
263    * Beware that changing an allowance with this method brings the risk that someone may use both the old
264    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
265    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
266    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267    * @param _spender The address which will spend the funds.
268    * @param _value The amount of tokens to be spent.
269    */
270   function approve(address _spender, uint256 _value) public returns (bool) {
271     allowed[msg.sender][_spender] = _value;
272     Approval(msg.sender, _spender, _value);
273     return true;
274   }
275 
276   /**
277    * @dev Function to check the amount of tokens that an owner allowed to a spender.
278    * @param _owner address The address which owns the funds.
279    * @param _spender address The address which will spend the funds.
280    * @return A uint256 specifying the amount of tokens still available for the spender.
281    */
282   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
283     return allowed[_owner][_spender];
284   }
285 
286   /**
287    * approve should be called when allowed[_spender] == 0. To increment
288    * allowed value is better to use this function to avoid 2 calls (and wait until
289    * the first transaction is mined)
290    * From MonolithDAO Token.sol
291    */
292   function increaseApproval (address _spender, uint _addedValue) public
293     returns (bool success) {
294     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
295     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299   function decreaseApproval (address _spender, uint _subtractedValue) public
300     returns (bool success) {
301     uint oldValue = allowed[msg.sender][_spender];
302     if (_subtractedValue > oldValue) {
303       allowed[msg.sender][_spender] = 0;
304     } else {
305       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
306     }
307     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
308     return true;
309   }
310 
311 }
312 
313 /**
314  * @title Mintable token
315  * @dev Simple ERC20 Token example, with mintable token creation
316  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
317  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
318  */
319 
320 contract MintableToken is StandardToken, Ownable {
321   event Mint(address indexed to, uint256 amount);
322   event MintFinished();
323 
324   bool public mintingFinished = false;
325 
326 
327   modifier canMint() {
328     require(!mintingFinished);
329     _;
330   }
331 
332   /**
333    * @dev Function to mint tokens
334    * @param _to The address that will receive the minted tokens.
335    * @param _amount The amount of tokens to mint.
336    * @return A boolean that indicates if the operation was successful.
337    */
338   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
339     totalSupply = totalSupply.add(_amount);
340     balances[_to] = balances[_to].add(_amount);
341     Mint(_to, _amount);
342     Transfer(0x0, _to, _amount);
343     return true;
344   }
345 
346   /**
347    * @dev Function to stop minting new tokens.
348    * @return True if the operation was successful.
349    */
350   function finishMinting() onlyOwner public returns (bool) {
351     mintingFinished = true;
352     MintFinished();
353     return true;
354   }
355 }
356 
357 /**
358  * @title Pausable token
359  *
360  * @dev StandardToken modified with pausable transfers.
361  **/
362 
363 contract PausableToken is StandardToken, Pausable {
364 
365   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
366     return super.transfer(_to, _value);
367   }
368 
369   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
370     return super.transferFrom(_from, _to, _value);
371   }
372 
373   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
374     return super.approve(_spender, _value);
375   }
376 
377   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
378     return super.increaseApproval(_spender, _addedValue);
379   }
380 
381   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
382     return super.decreaseApproval(_spender, _subtractedValue);
383   }
384 }
385 
386 /**
387 * @dev Pre main Bitcalve BTL token ERC20 contract
388 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
389 * 
390 */
391 contract BTLToken is MintableToken, PausableToken {
392     
393     // Metadata
394     string public constant symbol = "BTL";
395     string public constant name = "BitClave Token";
396     uint8 public constant decimals = 18;
397     string public constant version = "1.0";
398 
399     /**
400     * @dev Override MintableTokenn.finishMinting() to add canMint modifier
401     */
402     function finishMinting() onlyOwner canMint public returns(bool) {
403         return super.finishMinting();
404     }
405 
406 }
407 
408 /**
409 * @dev Main Bitcalve PreCAT token ERC20 contract
410 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
411 */
412 contract CAToken is BTLToken, Destructible {
413 
414     // Metadata
415     string public constant symbol = "testCAT";
416     string public constant name = "testCAT";
417     uint8 public constant decimals = 18;
418     string public constant version = "1.0";
419 
420     // Overrided destructor
421     function destroy() public onlyOwner {
422         require(mintingFinished);
423         super.destroy();
424     }
425 
426     // Overrided destructor companion
427     function destroyAndSend(address _recipient) public onlyOwner {
428         require(mintingFinished);
429         super.destroyAndSend(_recipient);
430     }
431 
432 }
433 
434 /**
435  * @title Crowdsale
436  * @dev Crowdsale is a base contract for managing a token crowdsale.
437  * Crowdsales have a start and end timestamps, where investors can make
438  * token purchases and the crowdsale will assign them tokens based
439  * on a token per ETH rate. Funds collected are forwarded to a wallet
440  * as they arrive.
441  */
442 contract Crowdsale {
443   using SafeMath for uint256;
444 
445   // The token being sold
446   MintableToken public token;
447 
448   // start and end timestamps where investments are allowed (both inclusive)
449   uint256 public startTime;
450   uint256 public endTime;
451 
452   // address where funds are collected
453   address public wallet;
454 
455   // how many token units a buyer gets per wei
456   uint256 public rate;
457 
458   // amount of raised money in wei
459   uint256 public weiRaised;
460 
461   /**
462    * event for token purchase logging
463    * @param purchaser who paid for the tokens
464    * @param beneficiary who got the tokens
465    * @param value weis paid for purchase
466    * @param amount amount of tokens purchased
467    */
468   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
469 
470 
471   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
472     require(_startTime >= now);
473     require(_endTime >= _startTime);
474     require(_rate > 0);
475     require(_wallet != 0x0);
476 
477     token = createTokenContract();
478     startTime = _startTime;
479     endTime = _endTime;
480     rate = _rate;
481     wallet = _wallet;
482   }
483 
484   // creates the token to be sold.
485   // override this method to have crowdsale of a specific mintable token.
486   function createTokenContract() internal returns (MintableToken) {
487     return new MintableToken();
488   }
489 
490 
491   // fallback function can be used to buy tokens
492   function () public payable {
493     buyTokens(msg.sender);
494   }
495 
496   // low level token purchase function
497   function buyTokens(address beneficiary) public payable {
498     require(beneficiary != 0x0);
499     require(validPurchase());
500 
501     uint256 weiAmount = msg.value;
502 
503     // calculate token amount to be created
504     uint256 tokens = weiAmount.mul(rate);
505 
506     // update state
507     weiRaised = weiRaised.add(weiAmount);
508 
509     token.mint(beneficiary, tokens);
510     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
511 
512     forwardFunds();
513   }
514 
515   // send ether to the fund collection wallet
516   // override to create custom fund forwarding mechanisms
517   function forwardFunds() internal {
518     wallet.transfer(msg.value);
519   }
520 
521   // @return true if the transaction can buy tokens
522   function validPurchase() internal constant returns (bool) {
523     bool withinPeriod = now >= startTime && now <= endTime;
524     bool nonZeroPurchase = msg.value != 0;
525     return withinPeriod && nonZeroPurchase;
526   }
527 
528   // @return true if crowdsale event has ended
529   function hasEnded() public constant returns (bool) {
530     return now > endTime;
531   }
532 
533 
534 }
535 
536 /**
537 * @dev Parent crowdsale contract extended with support for pausable crowdsale, meaning crowdsale can be paused by owner at any time
538 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
539 * 
540 * While the contract is in paused state, the contributions will be rejected
541 * 
542 */
543 contract PausableCrowdsale is Crowdsale, Pausable {
544 
545     function PausableCrowdsale(bool _paused) public {
546         if (_paused) {
547             pause();
548         }
549     }
550 
551     // overriding Crowdsale#validPurchase to add extra paused logic
552     // @return true if investors can buy at the moment
553     function validPurchase() internal constant returns(bool) {
554         return super.validPurchase() && !paused;
555     }
556 
557 }
558 
559 /**
560 * @dev Parent crowdsale contract with support for time-based and amount based bonuses 
561 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
562 * 
563 */
564 contract BonusCrowdsale is Crowdsale, Ownable {
565 
566     // Constants
567     // The following will be populated by main crowdsale contract
568     uint32[] public BONUS_TIMES;
569     uint32[] public BONUS_TIMES_VALUES;
570     uint32[] public BONUS_AMOUNTS;
571     uint32[] public BONUS_AMOUNTS_VALUES;
572     uint public constant BONUS_COEFF = 1000; // Values should be 10x percents, value 1000 = 100%
573     
574     // Members
575     uint public tokenPriceInCents;
576     uint public tokenDecimals;
577 
578     /**
579     * @dev Contructor
580     * @param _tokenPriceInCents token price in USD cents. The price is fixed
581     * @param _tokenDecimals number of digits after decimal point for CAT token
582     */
583     function BonusCrowdsale(uint256 _tokenPriceInCents, uint256 _tokenDecimals) public {
584         tokenPriceInCents = _tokenPriceInCents;
585         tokenDecimals = _tokenDecimals;
586     }
587 
588     /**
589     * @dev Retrieve length of bonuses by time array
590     * @return Bonuses by time array length
591     */
592     function bonusesForTimesCount() public constant returns(uint) {
593         return BONUS_TIMES.length;
594     }
595 
596     /**
597     * @dev Sets bonuses for time
598     */
599     function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
600         require(times.length == values.length);
601         for (uint i = 0; i + 1 < times.length; i++) {
602             require(times[i] < times[i+1]);
603         }
604 
605         BONUS_TIMES = times;
606         BONUS_TIMES_VALUES = values;
607     }
608 
609     /**
610     * @dev Retrieve length of bonuses by amounts array
611     * @return Bonuses by amounts array length
612     */
613     function bonusesForAmountsCount() public constant returns(uint) {
614         return BONUS_AMOUNTS.length;
615     }
616 
617     /**
618     * @dev Sets bonuses for USD amounts
619     */
620     function setBonusesForAmounts(uint32[] amounts, uint32[] values) public onlyOwner {
621         require(amounts.length == values.length);
622         for (uint i = 0; i + 1 < amounts.length; i++) {
623             require(amounts[i] > amounts[i+1]);
624         }
625 
626         BONUS_AMOUNTS = amounts;
627         BONUS_AMOUNTS_VALUES = values;
628     }
629 
630     /**
631     * @dev Overrided buyTokens method of parent Crowdsale contract  to provide bonus by changing and restoring rate variable
632     * @param beneficiary walelt of investor to receive tokens
633     */
634     function buyTokens(address beneficiary) public payable {
635         // Compute usd amount = wei * catsInEth * usdcentsInCat / usdcentsPerUsd / weisPerEth
636         uint256 usdValue = msg.value.mul(rate).mul(tokenPriceInCents).div(100).div(1 ether); 
637         
638         // Compute time and amount bonus
639         uint256 bonus = computeBonus(usdValue);
640 
641         // Apply bonus by adjusting and restoring rate member
642         uint256 oldRate = rate;
643         rate = rate.mul(BONUS_COEFF.add(bonus)).div(BONUS_COEFF);
644         super.buyTokens(beneficiary);
645         rate = oldRate;
646     }
647 
648     /**
649     * @dev Computes overall bonus based on time of contribution and amount of contribution. 
650     * The total bonus is the sum of bonus by time and bonus by amount
651     * @return bonus percentage scaled by 10
652     */
653     function computeBonus(uint256 usdValue) public constant returns(uint256) {
654         return computeAmountBonus(usdValue).add(computeTimeBonus());
655     }
656 
657     /**
658     * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
659     * @return bonus percentage scaled by 10
660     */
661     function computeTimeBonus() public constant returns(uint256) {
662         require(now >= startTime);
663 
664         for (uint i = 0; i < BONUS_TIMES.length; i++) {
665             if (now.sub(startTime) <= BONUS_TIMES[i]) {
666                 return BONUS_TIMES_VALUES[i];
667             }
668         }
669 
670         return 0;
671     }
672 
673     /**
674     * @dev Computes bonus based on amount of contribution
675     * @return bonus percentage scaled by 10
676     */
677     function computeAmountBonus(uint256 usdValue) public constant returns(uint256) {
678         for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
679             if (usdValue >= BONUS_AMOUNTS[i]) {
680                 return BONUS_AMOUNTS_VALUES[i];
681             }
682         }
683 
684         return 0;
685     }
686 
687 }
688 
689 
690 /**
691 * @dev Parent crowdsale contract is extended with support for cap in tokens
692 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
693 * 
694 */
695 contract TokensCappedCrowdsale is Crowdsale {
696 
697     uint256 public tokensCap;
698 
699     function TokensCappedCrowdsale(uint256 _tokensCap) public {
700         tokensCap = _tokensCap;
701     }
702 
703     // overriding Crowdsale#validPurchase to add extra tokens cap logic
704     // @return true if investors can buy at the moment
705     function validPurchase() internal constant returns(bool) {
706         uint256 tokens = token.totalSupply().add(msg.value.mul(rate));
707         bool withinCap = tokens <= tokensCap;
708         return super.validPurchase() && withinCap;
709     }
710 
711     // overriding Crowdsale#hasEnded to add tokens cap logic
712     // @return true if crowdsale event has ended
713     function hasEnded() public constant returns(bool) {
714         bool capReached = token.totalSupply() >= tokensCap;
715         return super.hasEnded() || capReached;
716     }
717 
718 }
719 
720 /**
721  * @title FinalizableCrowdsale
722  * @dev Extension of Crowdsale where an owner can do extra work
723  * after finishing.
724  */
725 contract FinalizableCrowdsale is Crowdsale, Ownable {
726   using SafeMath for uint256;
727 
728   bool public isFinalized = false;
729 
730   event Finalized();
731 
732   /**
733    * @dev Must be called after crowdsale ends, to do some extra finalization
734    * work. Calls the contract's finalization function.
735    */
736   function finalize() onlyOwner public {
737     require(!isFinalized);
738     require(hasEnded());
739 
740     finalization();
741     Finalized();
742 
743     isFinalized = true;
744   }
745 
746   /**
747    * @dev Can be overridden to add finalization logic. The overriding function
748    * should call super.finalization() to ensure the chain of finalization is
749    * executed entirely.
750    */
751   function finalization() internal {
752       isFinalized = isFinalized;
753   }
754 }
755 
756 
757   /**
758    * @dev Main BitCalve Crowdsale contract. 
759    * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
760    * 
761    */
762 contract CATCrowdsale is FinalizableCrowdsale, TokensCappedCrowdsale(CATCrowdsale.CAP), PausableCrowdsale(true), BonusCrowdsale(CATCrowdsale.TOKEN_USDCENT_PRICE, CATCrowdsale.DECIMALS) {
763 
764     // Constants
765     uint256 public constant DECIMALS = 18;
766     uint256 public constant CAP = 2 * (10**9) * (10**DECIMALS);              // 2B CAT
767     uint256 public constant BITCLAVE_AMOUNT = 1 * (10**9) * (10**DECIMALS);  // 1B CAT
768     uint256 public constant TOKEN_USDCENT_PRICE = 10;                        // $0.10
769 
770     // Variables
771     address public remainingTokensWallet;
772     address public presaleWallet;
773 
774     /**
775     * @dev Sets CAT to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
776     * since CAT cost is fixed in USD, but USD/ETH rate is changing
777     * @param _rate defines CAT/ETH rate: 1 ETH = _rate CATs
778     */
779     function setRate(uint256 _rate) external onlyOwner {
780         require(_rate != 0x0);
781         rate = _rate;
782         RateChange(_rate);
783     }
784 
785     /**
786     * @dev Allows to adjust the crowdsale end time
787     */
788     function setEndTime(uint256 _endTime) external onlyOwner {
789         require(!isFinalized);
790         require(_endTime >= startTime);
791         require(_endTime >= now);
792         endTime = _endTime;
793     }
794 
795     /**
796     * @dev Sets the wallet to forward ETH collected funds
797     */
798     function setWallet(address _wallet) external onlyOwner {
799         require(_wallet != 0x0);
800         wallet = _wallet;
801     }
802 
803     /**
804     * @dev Sets the wallet to hold unsold tokens at the end of ICO
805     */
806     function setRemainingTokensWallet(address _remainingTokensWallet) external onlyOwner {
807         require(_remainingTokensWallet != 0x0);
808         remainingTokensWallet = _remainingTokensWallet;
809     }
810 
811     // Events
812     event RateChange(uint256 rate);
813 
814     /**
815     * @dev Contructor
816     * @param _startTime startTime of crowdsale
817     * @param _endTime endTime of crowdsale
818     * @param _rate CAT / ETH rate
819     * @param _wallet wallet to forward the collected funds
820     * @param _remainingTokensWallet wallet to hold the unsold tokens
821     * @param _bitClaveWallet wallet to hold the initial 1B tokens of BitClave
822     */
823     function CATCrowdsale(
824         uint256 _startTime,
825         uint256 _endTime,
826         uint256 _rate,
827         address _wallet,
828         address _remainingTokensWallet,
829         address _bitClaveWallet
830     ) public
831         Crowdsale(_startTime, _endTime, _rate, _wallet)
832     {
833         remainingTokensWallet = _remainingTokensWallet;
834         presaleWallet = this;
835 
836         // allocate tokens to BitClave
837         mintTokens(_bitClaveWallet, BITCLAVE_AMOUNT);
838     }
839 
840     // Overrided methods
841 
842     /**
843     * @dev Creates token contract for ICO
844     * @return ERC20 contract associated with the crowdsale
845     */
846     function createTokenContract() internal returns(MintableToken) {
847         CAToken token = new CAToken();
848         token.pause();
849         return token;
850     }
851 
852     /**
853     * @dev Finalizes the crowdsale
854     */
855     function finalization() internal {
856         super.finalization();
857 
858         // Mint tokens up to CAP
859         if (token.totalSupply() < tokensCap) {
860             uint tokens = tokensCap.sub(token.totalSupply());
861             token.mint(remainingTokensWallet, tokens);
862         }
863 
864         // disable minting of CATs
865         token.finishMinting();
866 
867         // take onwership over CAToken contract
868         token.transferOwnership(owner);
869     }
870 
871     // Owner methods
872 
873     /**
874     * @dev Helper to Pause CAToken
875     */
876     function pauseTokens() public onlyOwner {
877         CAToken(token).pause();
878     }
879 
880     /**
881     * @dev Helper to UnPause CAToken
882     */
883     function unpauseTokens() public onlyOwner {
884         CAToken(token).unpause();
885     }
886 
887     /**
888     * @dev Allocates tokens from preSale to a special wallet. Called once as part of crowdsale setup
889     */
890     function mintPresaleTokens(uint256 tokens) public onlyOwner {
891         mintTokens(presaleWallet, tokens);
892         presaleWallet = 0;
893     }
894 
895     /**
896     * @dev Transfer presaled tokens even on paused token contract
897     */
898     function transferPresaleTokens(address destination, uint256 amount) public onlyOwner {
899         unpauseTokens();
900         token.transfer(destination, amount);
901         pauseTokens();
902     }
903 
904     // 
905     /**
906     * @dev Allocates tokens for investors that contributed from website. These include
907     * whitelisted investors and investors paying with BTC/QTUM/LTC
908     */
909     function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
910         require(beneficiary != 0x0);
911         require(tokens > 0);
912         require(now <= endTime);                               // Crowdsale (without startTime check)
913         require(!isFinalized);                                 // FinalizableCrowdsale
914         require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale
915         
916         token.mint(beneficiary, tokens);
917     }
918 
919 }