1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15   /**
16    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17    * account.
18    */
19   function Ownable() public {
20     owner = msg.sender;
21   }
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) public onlyOwner {
36     require(newOwner != address(0));
37     OwnershipTransferred(owner, newOwner);
38     owner = newOwner;
39   }
40 
41 }
42 
43 /**
44  * @title SafeMath
45  * @dev Math operations with safety checks that throw on error
46  */
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 }
88 
89 /**
90  * @title ERC20Basic
91  * @dev Simpler version of ERC20 interface
92  * @dev see https://github.com/ethereum/EIPs/issues/179
93  */
94 contract ERC20Basic {
95   function totalSupply() public view returns (uint256);
96   function balanceOf(address who) public view returns (uint256);
97   function transfer(address to, uint256 value) public returns (bool);
98   event Transfer(address indexed from, address indexed to, uint256 value);
99 }
100 
101 
102 
103 /**
104  * @title Basic token
105  * @dev Basic version of StandardToken, with no allowances.
106  */
107 contract BasicToken is ERC20Basic {
108   using SafeMath for uint256;
109 
110   mapping(address => uint256) balances;
111 
112   uint256 totalSupply_;
113 
114   /**
115   * @dev total number of tokens in existence
116   */
117   function totalSupply() public view returns (uint256) {
118     return totalSupply_;
119   }
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public view returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * @dev https://github.com/ethereum/EIPs/issues/20
166  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(address _owner, address _spender) public view returns (uint256) {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    *
220    * approve should be called when allowed[_spender] == 0. To increment
221    * allowed value is better to use this function to avoid 2 calls (and wait until
222    * the first transaction is mined)
223    * From MonolithDAO Token.sol
224    * @param _spender The address which will spend the funds.
225    * @param _addedValue The amount of tokens to increase the allowance by.
226    */
227   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
228     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
229     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
230     return true;
231   }
232 
233   /**
234    * @dev Decrease the amount of tokens that an owner allowed to a spender.
235    *
236    * approve should be called when allowed[_spender] == 0. To decrement
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _subtractedValue The amount of tokens to decrease the allowance by.
242    */
243   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
244     uint oldValue = allowed[msg.sender][_spender];
245     if (_subtractedValue > oldValue) {
246       allowed[msg.sender][_spender] = 0;
247     } else {
248       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
249     }
250     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
251     return true;
252   }
253 
254 }
255 
256 
257 /**
258  * @title Mintable token
259  * @dev Simple ERC20 Token example, with mintable token creation
260  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
261  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
262  */
263 contract MintableToken is StandardToken, Ownable {
264   event Mint(address indexed to, uint256 amount);
265   event MintFinished();
266 
267   bool public mintingFinished = false;
268 
269 
270   modifier canMint() {
271     require(!mintingFinished);
272     _;
273   }
274 
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will receive the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
282     totalSupply_ = totalSupply_.add(_amount);
283     balances[_to] = balances[_to].add(_amount);
284     Mint(_to, _amount);
285     Transfer(address(0), _to, _amount);
286     return true;
287   }
288 
289   /**
290    * @dev Function to stop minting new tokens.
291    * @return True if the operation was successful.
292    */
293   function finishMinting() onlyOwner canMint public returns (bool) {
294     mintingFinished = true;
295     MintFinished();
296     return true;
297   }
298 }
299 
300 
301 /**
302  * @title Crowdsale
303  * @dev Crowdsale is a base contract for managing a token crowdsale.
304  * Crowdsales have a start and end timestamps, where investors can make
305  * token purchases and the crowdsale will assign them tokens based
306  * on a token per ETH rate. Funds collected are forwarded to a wallet
307  * as they arrive.
308  */
309 contract Crowdsale {
310   using SafeMath for uint256;
311 
312   // The token being sold
313   MintableToken public token;
314 
315   // start and end timestamps where investments are allowed (both inclusive)
316   uint256 public startTime;
317   uint256 public endTime;
318 
319   // address where funds are collected
320   address public wallet;
321 
322   // how many token units a buyer gets per wei
323   uint256 public rate;
324 
325   // amount of raised money in wei
326   uint256 public weiRaised;
327 
328   /**
329    * event for token purchase logging
330    * @param purchaser who paid for the tokens
331    * @param beneficiary who got the tokens
332    * @param value weis paid for purchase
333    * @param amount amount of tokens purchased
334    */
335   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
336 
337 
338   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
339    // require(_startTime >= now);
340     require(_endTime >= _startTime);
341     require(_rate > 0);
342     require(_wallet != address(0));
343 
344     token = createTokenContract();
345     startTime = _startTime;
346     endTime = _endTime;
347     rate = _rate;
348     wallet = _wallet;
349   }
350 
351   // fallback function can be used to buy tokens
352   function () external payable {
353     buyTokens(msg.sender);
354   }
355 
356   // low level token purchase function
357   function buyTokens(address beneficiary) public payable {
358     require(beneficiary != address(0));
359     require(validPurchase());
360 
361     uint256 weiAmount = msg.value;
362 
363     // calculate token amount to be created
364     uint256 tokens = getTokenAmount(weiAmount);
365 
366     // update state
367     weiRaised = weiRaised.add(weiAmount);
368 
369     token.mint(beneficiary, tokens);
370     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
371 
372     forwardFunds();
373   }
374 
375   // @return true if crowdsale event has ended
376   function hasEnded() public view returns (bool) {
377     return now > endTime;
378   }
379 
380   // creates the token to be sold.
381   // override this method to have crowdsale of a specific mintable token.
382   function createTokenContract() internal returns (MintableToken) {
383     return new MintableToken();
384   }
385 
386   // Override this method to have a way to add business logic to your crowdsale when buying
387   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
388     return weiAmount.mul(rate);
389   }
390 
391   // send ether to the fund collection wallet
392   // override to create custom fund forwarding mechanisms
393   function forwardFunds() internal {
394     wallet.transfer(msg.value);
395   }
396 
397   // @return true if the transaction can buy tokens
398   function validPurchase() internal view returns (bool) {
399     bool withinPeriod = now >= startTime && now <= endTime;
400     bool nonZeroPurchase = msg.value != 0;
401     return withinPeriod && nonZeroPurchase;
402   }
403 
404 }
405 
406 
407 /**
408  * @title FinalizableCrowdsale
409  * @dev Extension of Crowdsale where an owner can do extra work
410  * after finishing.
411  */
412 contract FinalizableCrowdsale is Crowdsale, Ownable {
413   using SafeMath for uint256;
414 
415   bool public isFinalized = false;
416 
417   event Finalized();
418 
419   /**
420    * @dev Must be called after crowdsale ends, to do some extra finalization
421    * work. Calls the contract's finalization function.
422    */
423   function finalize() onlyOwner public {
424     require(!isFinalized);
425     require(hasEnded());
426 
427     finalization();
428     Finalized();
429 
430     isFinalized = true;
431   }
432 
433   /**
434    * @dev Can be overridden to add finalization logic. The overriding function
435    * should call super.finalization() to ensure the chain of finalization is
436    * executed entirely.
437    */
438   function finalization() internal {
439   }
440 }
441 
442 
443 /**
444 * @dev Parent crowdsale contract is extended with support for cap in tokens
445 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
446 * 
447 */
448 contract TokensCappedCrowdsale is Crowdsale {
449 
450     uint256 public tokensCap;
451 
452     function TokensCappedCrowdsale(uint256 _tokensCap) public {
453         tokensCap = _tokensCap;
454     }
455 
456     // overriding Crowdsale#validPurchase to add extra tokens cap logic
457     // @return true if investors can buy at the moment
458     function validPurchase() internal constant returns(bool) {
459         uint256 tokens = token.totalSupply().add(msg.value.mul(rate));
460         bool withinCap = tokens <= tokensCap;
461         return super.validPurchase() && withinCap;
462     }
463 
464     // overriding Crowdsale#hasEnded to add tokens cap logic
465     // @return true if crowdsale event has ended
466     function hasEnded() public constant returns(bool) {
467         bool capReached = token.totalSupply() >= tokensCap;
468         return super.hasEnded() || capReached;
469     }
470 
471 }
472 
473 /**
474  * @title Pausable
475  * @dev Base contract which allows children to implement an emergency stop mechanism.
476  */
477 contract Pausable is Ownable {
478   event Pause();
479   event Unpause();
480 
481   bool public paused = false;
482 
483 
484   /**
485    * @dev Modifier to make a function callable only when the contract is not paused.
486    */
487   modifier whenNotPaused() {
488     require(!paused);
489     _;
490   }
491 
492   /**
493    * @dev Modifier to make a function callable only when the contract is paused.
494    */
495   modifier whenPaused() {
496     require(paused);
497     _;
498   }
499 
500   /**
501    * @dev called by the owner to pause, triggers stopped state
502    */
503   function pause() onlyOwner whenNotPaused public {
504     paused = true;
505     Pause();
506   }
507 
508   /**
509    * @dev called by the owner to unpause, returns to normal state
510    */
511   function unpause() onlyOwner whenPaused public {
512     paused = false;
513     Unpause();
514   }
515 }
516 
517 
518 /**
519 * @dev Parent crowdsale contract extended with support for pausable crowdsale, meaning crowdsale can be paused by owner at any time
520 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
521 * 
522 * While the contract is in paused state, the contributions will be rejected
523 * 
524 */
525 contract PausableCrowdsale is Crowdsale, Pausable {
526 
527     function PausableCrowdsale(bool _paused) public {
528         if (_paused) {
529             pause();
530         }
531     }
532 
533     // overriding Crowdsale#validPurchase to add extra paused logic
534     // @return true if investors can buy at the moment
535     function validPurchase() internal constant returns(bool) {
536         return super.validPurchase() && !paused;
537     }
538 
539 }
540 
541 
542 /**
543 * @dev Parent crowdsale contract with support for time-based and amount based bonuses 
544 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
545 * 
546 */
547 contract BonusCrowdsale is Crowdsale, Ownable {
548 
549     // Constants
550     // The following will be populated by main crowdsale contract
551     uint32[] public BONUS_TIMES;
552     uint32[] public BONUS_TIMES_VALUES;
553     uint32[] public BONUS_AMOUNTS;
554     uint32[] public BONUS_AMOUNTS_VALUES;
555     uint public constant BONUS_COEFF = 1000; // Values should be 10x percents, value 1000 = 100%
556     
557     // Members
558     uint public tokenPriceInCents;
559 
560     /**
561     * @dev Contructor
562     * @param _tokenPriceInCents token price in USD cents. The price is fixed
563     */
564     function BonusCrowdsale(uint256 _tokenPriceInCents) public {
565         tokenPriceInCents = _tokenPriceInCents;
566     }
567 
568     /**
569     * @dev Retrieve length of bonuses by time array
570     * @return Bonuses by time array length
571     */
572     function bonusesForTimesCount() public constant returns(uint) {
573         return BONUS_TIMES.length;
574     }
575 
576     /**
577     * @dev Sets bonuses for time
578     */
579     function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
580         require(times.length == values.length);
581         for (uint i = 0; i + 1 < times.length; i++) {
582             require(times[i] < times[i+1]);
583         }
584 
585         BONUS_TIMES = times;
586         BONUS_TIMES_VALUES = values;
587     }
588 
589     /**
590     * @dev Retrieve length of bonuses by amounts array
591     * @return Bonuses by amounts array length
592     */
593     function bonusesForAmountsCount() public constant returns(uint) {
594         return BONUS_AMOUNTS.length;
595     }
596 
597     /**
598     * @dev Sets bonuses for USD amounts
599     */
600     function setBonusesForAmounts(uint32[] amounts, uint32[] values) public onlyOwner {
601         require(amounts.length == values.length);
602         for (uint i = 0; i + 1 < amounts.length; i++) {
603             require(amounts[i] > amounts[i+1]);
604         }
605 
606         BONUS_AMOUNTS = amounts;
607         BONUS_AMOUNTS_VALUES = values;
608     }
609 
610     /**
611     * @dev Overrided buyTokens method of parent Crowdsale contract  to provide bonus by changing and restoring rate variable
612     * @param beneficiary walelt of investor to receive tokens
613     */
614     function buyTokens(address beneficiary) public payable {
615         // Compute usd amount = wei * catsInEth * usdcentsInCat / usdcentsPerUsd / weisPerEth
616         uint256 usdValue = msg.value.mul(rate).mul(tokenPriceInCents).div(100).div(1 ether); 
617         
618         // Compute time and amount bonus
619         uint256 bonus = computeBonus(usdValue);
620 
621         // Apply bonus by adjusting and restoring rate member
622         uint256 oldRate = rate;
623         rate = rate.mul(BONUS_COEFF.add(bonus)).div(BONUS_COEFF);
624         super.buyTokens(beneficiary);
625         rate = oldRate;
626     }
627 
628     /**
629     * @dev Computes overall bonus based on time of contribution and amount of contribution. 
630     * The total bonus is the sum of bonus by time and bonus by amount
631     * @return bonus percentage scaled by 10
632     */
633     function computeBonus(uint256 usdValue) public constant returns(uint256) {
634         return computeAmountBonus(usdValue).add(computeTimeBonus());
635     }
636 
637     /**
638     * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
639     * @return bonus percentage scaled by 10
640     */
641     function computeTimeBonus() public constant returns(uint256) {
642         require(now >= startTime);
643 
644         for (uint i = 0; i < BONUS_TIMES.length; i++) {
645             if (now.sub(startTime) <= BONUS_TIMES[i]) {
646                 return BONUS_TIMES_VALUES[i];
647             }
648         }
649 
650         return 0;
651     }
652 
653     /**
654     * @dev Computes bonus based on amount of contribution
655     * @return bonus percentage scaled by 10
656     */
657     function computeAmountBonus(uint256 usdValue) public constant returns(uint256) {
658         for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
659             if (usdValue >= BONUS_AMOUNTS[i]) {
660                 return BONUS_AMOUNTS_VALUES[i];
661             }
662         }
663 
664         return 0;
665     }
666 
667 }
668 
669 /**
670  * @title Destructible
671  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
672  */
673 contract Destructible is Ownable {
674 
675   function Destructible() public payable { }
676 
677   /**
678    * @dev Transfers the current balance to the owner and terminates the contract.
679    */
680   function destroy() onlyOwner public {
681     selfdestruct(owner);
682   }
683 
684   function destroyAndSend(address _recipient) onlyOwner public {
685     selfdestruct(_recipient);
686   }
687 }
688 
689 
690 /**
691  * @title MintableMasterToken token
692  * @dev Simple ERC20 Token example, with mintable token creation
693  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
694  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
695  */
696 
697 contract MintableMasterToken is MintableToken {
698     event MintMasterTransferred(address indexed previousMaster, address indexed newMaster);
699     address public mintMaster;
700 
701     modifier onlyMintMasterOrOwner() {
702         require(msg.sender == mintMaster || msg.sender == owner);
703         _;
704     }
705     function MintableMasterToken() {
706         mintMaster = msg.sender;
707     }
708 
709     function transferMintMaster(address newMaster) onlyOwner public {
710         require(newMaster != address(0));
711         MintMasterTransferred(mintMaster, newMaster);
712         mintMaster = newMaster;
713     }
714 
715     /**
716      * @dev Function to mint tokens
717      * @param _to The address that will receive the minted tokens.
718      * @param _amount The amount of tokens to mint.
719      * @return A boolean that indicates if the operation was successful.
720      */
721     function mint(address _to, uint256 _amount) onlyMintMasterOrOwner canMint public returns (bool) {
722         address oldOwner = owner;
723         owner = msg.sender;
724 
725         bool result = super.mint(_to, _amount);
726 
727         owner = oldOwner;
728 
729         return result;
730     }
731 
732 }
733 
734 /**
735  * @title Pausable token
736  * @dev StandardToken modified with pausable transfers.
737  **/
738 contract PausableToken is StandardToken, Pausable {
739 
740   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
741     return super.transfer(_to, _value);
742   }
743 
744   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
745     return super.transferFrom(_from, _to, _value);
746   }
747 
748   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
749     return super.approve(_spender, _value);
750   }
751 
752   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
753     return super.increaseApproval(_spender, _addedValue);
754   }
755 
756   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
757     return super.decreaseApproval(_spender, _subtractedValue);
758   }
759 }
760 
761 
762 
763 /**
764 * @dev Pre main BoutsPro token ERC20 contract
765 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
766 */
767 contract BTSPToken is MintableMasterToken, PausableToken {
768     
769     // Metadata
770     string public constant symbol = "BOUTS";
771     string public constant name = "BoutsPro";
772     uint8 public constant decimals = 18;
773     string public constant version = "1.0";
774 
775     function mintToAddresses(address[] addresses, uint256 amount) public onlyMintMasterOrOwner canMint {
776         for (uint i = 0; i < addresses.length; i++) {
777             require(mint(addresses[i], amount));
778         }
779     }
780 
781     function mintToAddressesAndAmounts(address[] addresses, uint256[] amounts) public onlyMintMasterOrOwner canMint {
782         require(addresses.length == amounts.length);
783         for (uint i = 0; i < addresses.length; i++) {
784             require(mint(addresses[i], amounts[i]));
785         }
786     }
787 
788     /**
789     * @dev Override MintableTokenn.finishMinting() to add canMint modifier
790     */
791     function finishMinting() onlyOwner canMint public returns(bool) {
792         return super.finishMinting();
793     }
794 
795 }
796 /**
797 * @dev Main BoutsPro PreBOU token ERC20 contract
798 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
799 */
800 contract PreBOUToken is BTSPToken, Destructible {
801 
802     // Metadata
803     string public constant symbol = "BOUTS";
804     string public constant name = "BoutsPro";
805     uint8 public constant decimals = 18;
806     string public constant version = "1.0";
807 
808     // Overrided destructor
809     function destroy() public onlyOwner {
810         require(mintingFinished);
811         super.destroy();
812     }
813 
814     // Overrided destructor companion
815     function destroyAndSend(address _recipient) public onlyOwner {
816         require(mintingFinished);
817         super.destroyAndSend(_recipient);
818     }
819 
820 }
821 
822   /**
823    * @dev Main BoutsPro Crowdsale contract. 
824    * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
825    * 
826    */
827 contract BoutsCrowdsale is MintableToken,FinalizableCrowdsale, TokensCappedCrowdsale(BoutsCrowdsale.CAP), PausableCrowdsale(true), BonusCrowdsale(BoutsCrowdsale.TOKEN_USDCENT_PRICE) {
828 
829     // Constants
830     uint256 public constant DECIMALS = 18;
831     uint256 public constant CAP = 2 * (10**9) * (10**DECIMALS);              // 2B BOUT
832     uint256 public constant BOUTSPRO_AMOUNT = 1 * (10**9) * (10**DECIMALS);  // 1B BOUT
833     uint256 public constant TOKEN_USDCENT_PRICE = 10;                        // $0.10
834 
835     // Variables
836     address public remainingTokensWallet;
837     address public presaleWallet;
838 
839     /**
840     * @dev Sets BOUT to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
841     * since BOUT cost is fixed in USD, but USD/ETH rate is changing
842     * @param _rate defines BOUT/ETH rate: 1 ETH = _rate BOUTs
843     */
844     function setRate(uint256 _rate) external onlyOwner {
845         require(_rate != 0x0);
846         rate = _rate;
847         RateChange(_rate);
848     }
849 
850     /**
851     * @dev Allows to adjust the crowdsale end time
852     */
853     function setEndTime(uint256 _endTime) external onlyOwner {
854         require(!isFinalized);
855         require(_endTime >= startTime);
856         require(_endTime >= now);
857         endTime = _endTime;
858     }
859 
860     /**
861     * @dev Sets the wallet to forward ETH collected funds
862     */
863     function setWallet(address _wallet) external onlyOwner {
864         require(_wallet != 0x0);
865         wallet = _wallet;
866     }
867 
868     /**
869     * @dev Sets the wallet to hold unsold tokens at the end of ICO
870     */
871     function setRemainingTokensWallet(address _remainingTokensWallet) external onlyOwner {
872         require(_remainingTokensWallet != 0x0);
873         remainingTokensWallet = _remainingTokensWallet;
874     }
875 
876     // Events
877     event RateChange(uint256 rate);
878 
879     /**
880     * @dev Contructor
881     * @param _startTime startTime of crowdsale
882     * @param _endTime endTime of crowdsale
883     * @param _rate BOUT / ETH rate
884     * @param _wallet wallet to forward the collected funds
885     * @param _remainingTokensWallet wallet to hold the unsold tokens
886     * @param _boutsProWallet wallet to hold the initial 1B tokens of BoutsPro
887     */
888     function BoutsCrowdsale(
889         uint256 _startTime,
890         uint256 _endTime,
891         uint256 _rate,
892         address _wallet,
893         address _remainingTokensWallet,
894         address _boutsProWallet
895     ) public
896         Crowdsale(_startTime, _endTime, _rate, _wallet)
897     {
898         remainingTokensWallet = _remainingTokensWallet;
899         presaleWallet = this;
900 
901         // allocate tokens to BoutsPro
902         mintTokens(_boutsProWallet, BOUTSPRO_AMOUNT);
903     }
904 
905     // Overrided methods
906 
907     /**
908     * @dev Creates token contract for ICO
909     * @return ERC20 contract associated with the crowdsale
910     */
911     function createTokenContract() internal returns(MintableToken) {
912         PreBOUToken token = new PreBOUToken();
913         token.pause();
914         return token;
915     }
916 
917     /**
918     * @dev Finalizes the crowdsale
919     */
920     function finalization() internal {
921         super.finalization();
922 
923         // Mint tokens up to CAP
924         if (token.totalSupply() < tokensCap) {
925             uint tokens = tokensCap.sub(token.totalSupply());
926             token.mint(remainingTokensWallet, tokens);
927         }
928 
929         // disable minting of BOUTs
930         token.finishMinting();
931 
932         // take onwership over BOUToken contract
933         token.transferOwnership(owner);
934     }
935 
936     // Owner methods
937 
938     /**
939     * @dev Helper to Pause BOUToken
940     */
941     function pauseTokens() public onlyOwner {
942         PreBOUToken(token).pause();
943     }
944 
945     /**
946     * @dev Helper to UnPause BOUToken
947     */
948     function unpauseTokens() public onlyOwner {
949         PreBOUToken(token).unpause();
950     }
951 
952     /**
953     * @dev Allocates tokens from preSale to a special wallet. Called once as part of crowdsale setup
954     */
955     function mintPresaleTokens(uint256 tokens) public onlyOwner {
956         mintTokens(presaleWallet, tokens);
957         presaleWallet = 0;
958     }
959 
960     /**
961     * @dev Transfer presaled tokens even on paused token contract
962     */
963     function transferPresaleTokens(address destination, uint256 amount) public onlyOwner {
964         unpauseTokens();
965         token.transfer(destination, amount);
966         pauseTokens();
967     }
968 
969     // 
970     /**
971     * @dev Allocates tokens for investors that contributed from website. These include
972     * white listed investors and investors paying with BTC/QTUM/LTC
973     */
974     function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
975         require(beneficiary != 0x0);
976         require(tokens > 0);
977         require(now <= endTime);                               // Crowdsale (without startTime check)
978         require(!isFinalized);                                 // FinalizableCrowdsale
979         require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale
980         
981         token.mint(beneficiary, tokens);
982     }
983 
984 }