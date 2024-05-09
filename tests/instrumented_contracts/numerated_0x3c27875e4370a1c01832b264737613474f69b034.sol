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
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 /**
59  * @title Ownable
60  * @dev The Ownable contract has an owner address, and provides basic authorization control
61  * functions, this simplifies the implementation of "user permissions".
62  */
63 contract Ownable {
64   address public owner;
65 
66 
67   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69 
70   /**
71    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
72    * account.
73    */
74   function Ownable() public {
75     owner = msg.sender;
76   }
77 
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address newOwner) onlyOwner public {
93     require(newOwner != address(0));
94     OwnershipTransferred(owner, newOwner);
95     owner = newOwner;
96   }
97 
98 }
99 
100 /**
101  * @title Destructible
102  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
103  */
104 contract Destructible is Ownable {
105 
106   function Destructible() public payable { }
107 
108   /**
109    * @dev Transfers the current balance to the owner and terminates the contract.
110    */
111   function destroy() onlyOwner public {
112     selfdestruct(owner);
113   }
114 
115   function destroyAndSend(address _recipient) onlyOwner public {
116     selfdestruct(_recipient);
117   }
118 }
119 
120 /**
121  * @title Pausable
122  * @dev Base contract which allows children to implement an emergency stop mechanism.
123  */
124 contract Pausable is Ownable {
125   event Pause();
126   event Unpause();
127 
128   bool public paused = false;
129 
130 
131   /**
132    * @dev Modifier to make a function callable only when the contract is not paused.
133    */
134   modifier whenNotPaused() {
135     require(!paused);
136     _;
137   }
138 
139   /**
140    * @dev Modifier to make a function callable only when the contract is paused.
141    */
142   modifier whenPaused() {
143     require(paused);
144     _;
145   }
146 
147   /**
148    * @dev called by the owner to pause, triggers stopped state
149    */
150   function pause() onlyOwner whenNotPaused public {
151     paused = true;
152     Pause();
153   }
154 
155   /**
156    * @dev called by the owner to unpause, returns to normal state
157    */
158   function unpause() onlyOwner whenPaused public {
159     paused = false;
160     Unpause();
161   }
162 }
163 
164 /**
165  * @title ERC20Basic
166  * @dev Simpler version of ERC20 interface
167  * @dev see https://github.com/ethereum/EIPs/issues/179
168  */
169 contract ERC20Basic {
170   uint256 public totalSupply;
171   function balanceOf(address who) public constant returns (uint256);
172   function transfer(address to, uint256 value) public returns (bool);
173   event Transfer(address indexed from, address indexed to, uint256 value);
174 }
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181   function allowance(address owner, address spender) public constant returns (uint256);
182   function transferFrom(address from, address to, uint256 value) public returns (bool);
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 /**
188  * @title Basic token
189  * @dev Basic version of StandardToken, with no allowances.
190  */
191 contract BasicToken is ERC20Basic {
192   using SafeMath for uint256;
193 
194   mapping(address => uint256) balances;
195 
196   /**
197   * @dev transfer token for a specified address
198   * @param _to The address to transfer to.
199   * @param _value The amount to be transferred.
200   */
201   function transfer(address _to, uint256 _value) public returns (bool) {
202     require(_to != address(0));
203 
204     // SafeMath.sub will throw if there is not enough balance.
205     balances[msg.sender] = balances[msg.sender].sub(_value);
206     balances[_to] = balances[_to].add(_value);
207     Transfer(msg.sender, _to, _value);
208     return true;
209   }
210 
211   /**
212   * @dev Gets the balance of the specified address.
213   * @param _owner The address to query the the balance of.
214   * @return An uint256 representing the amount owned by the passed address.
215   */
216   function balanceOf(address _owner) public constant returns (uint256 balance) {
217     return balances[_owner];
218   }
219 
220 }
221 
222 /**
223  * @title Standard ERC20 token
224  *
225  * @dev Implementation of the basic standard token.
226  * @dev https://github.com/ethereum/EIPs/issues/20
227  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
228  */
229 contract StandardToken is ERC20, BasicToken {
230 
231   mapping (address => mapping (address => uint256)) allowed;
232 
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
241     require(_to != address(0));
242 
243     uint256 _allowance = allowed[_from][msg.sender];
244 
245     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
246     // require (_value <= _allowance);
247 
248     balances[_from] = balances[_from].sub(_value);
249     balances[_to] = balances[_to].add(_value);
250     allowed[_from][msg.sender] = _allowance.sub(_value);
251     Transfer(_from, _to, _value);
252     return true;
253   }
254 
255   /**
256    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
257    *
258    * Beware that changing an allowance with this method brings the risk that someone may use both the old
259    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
260    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
261    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262    * @param _spender The address which will spend the funds.
263    * @param _value The amount of tokens to be spent.
264    */
265   function approve(address _spender, uint256 _value) public returns (bool) {
266     allowed[msg.sender][_spender] = _value;
267     Approval(msg.sender, _spender, _value);
268     return true;
269   }
270 
271   /**
272    * @dev Function to check the amount of tokens that an owner allowed to a spender.
273    * @param _owner address The address which owns the funds.
274    * @param _spender address The address which will spend the funds.
275    * @return A uint256 specifying the amount of tokens still available for the spender.
276    */
277   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
278     return allowed[_owner][_spender];
279   }
280 
281   /**
282    * approve should be called when allowed[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    */
287   function increaseApproval (address _spender, uint _addedValue) public
288     returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue) public
295     returns (bool success) {
296     uint oldValue = allowed[msg.sender][_spender];
297     if (_subtractedValue > oldValue) {
298       allowed[msg.sender][_spender] = 0;
299     } else {
300       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
301     }
302     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
303     return true;
304   }
305 
306 }
307 
308 /**
309  * @title Mintable token
310  * @dev Simple ERC20 Token example, with mintable token creation
311  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
312  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
313  */
314 
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
334     totalSupply = totalSupply.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     Mint(_to, _amount);
337     Transfer(0x0, _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner public returns (bool) {
346     mintingFinished = true;
347     MintFinished();
348     return true;
349   }
350 }
351 
352 /**
353  * @title Pausable token
354  *
355  * @dev StandardToken modified with pausable transfers.
356  **/
357 
358 contract PausableToken is StandardToken, Pausable {
359 
360   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
361     return super.transfer(_to, _value);
362   }
363 
364   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
365     return super.transferFrom(_from, _to, _value);
366   }
367 
368   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
369     return super.approve(_spender, _value);
370   }
371 
372   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
373     return super.increaseApproval(_spender, _addedValue);
374   }
375 
376   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
377     return super.decreaseApproval(_spender, _subtractedValue);
378   }
379 }
380 
381 /**
382 * @dev Pre main Bitcalve CAT token ERC20 contract
383 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
384 */
385 contract CAToken is MintableToken, PausableToken {
386     
387     // Metadata
388     string public constant symbol = "CAT";
389     string public constant name = "BitClave - Consumer Activity Token";
390     uint8 public constant decimals = 18;
391     string public constant version = "2.0";
392 
393     /**
394     * @dev Override MintableTokenn.finishMinting() to add canMint modifier
395     */
396     function finishMinting() onlyOwner canMint public returns(bool) {
397         return super.finishMinting();
398     }
399 
400 }
401 
402 /**
403 * @dev Main Bitcalve PreCAT token ERC20 contract
404 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
405 */
406 contract PreCAToken is CAToken, Destructible {
407 
408     // Metadata
409     string public constant symbol = "testCAT";
410     string public constant name = "testCAT";
411     uint8 public constant decimals = 18;
412     string public constant version = "1.1";
413 
414     // Overrided destructor
415     function destroy() public onlyOwner {
416         require(mintingFinished);
417         super.destroy();
418     }
419 
420     // Overrided destructor companion
421     function destroyAndSend(address _recipient) public onlyOwner {
422         require(mintingFinished);
423         super.destroyAndSend(_recipient);
424     }
425 
426 }
427 
428 /**
429  * @title Crowdsale
430  * @dev Crowdsale is a base contract for managing a token crowdsale.
431  * Crowdsales have a start and end timestamps, where investors can make
432  * token purchases and the crowdsale will assign them tokens based
433  * on a token per ETH rate. Funds collected are forwarded to a wallet
434  * as they arrive.
435  */
436 contract Crowdsale {
437   using SafeMath for uint256;
438 
439   // The token being sold
440   MintableToken public token;
441 
442   // start and end timestamps where investments are allowed (both inclusive)
443   uint256 public startTime;
444   uint256 public endTime;
445 
446   // address where funds are collected
447   address public wallet;
448 
449   // how many token units a buyer gets per wei
450   uint256 public rate;
451 
452   // amount of raised money in wei
453   uint256 public weiRaised;
454 
455   /**
456    * event for token purchase logging
457    * @param purchaser who paid for the tokens
458    * @param beneficiary who got the tokens
459    * @param value weis paid for purchase
460    * @param amount amount of tokens purchased
461    */
462   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
463 
464 
465   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) public {
466     require(_startTime >= now);
467     require(_endTime >= _startTime);
468     require(_rate > 0);
469     require(_wallet != 0x0);
470 
471     token = createTokenContract();
472     startTime = _startTime;
473     endTime = _endTime;
474     rate = _rate;
475     wallet = _wallet;
476   }
477 
478   // creates the token to be sold.
479   // override this method to have crowdsale of a specific mintable token.
480   function createTokenContract() internal returns (MintableToken) {
481     return new MintableToken();
482   }
483 
484 
485   // fallback function can be used to buy tokens
486   function () public payable {
487     buyTokens(msg.sender);
488   }
489 
490   // low level token purchase function
491   function buyTokens(address beneficiary) public payable {
492     require(beneficiary != 0x0);
493     require(validPurchase());
494 
495     uint256 weiAmount = msg.value;
496 
497     // calculate token amount to be created
498     uint256 tokens = weiAmount.mul(rate);
499 
500     // update state
501     weiRaised = weiRaised.add(weiAmount);
502 
503     token.mint(beneficiary, tokens);
504     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
505 
506     forwardFunds();
507   }
508 
509   // send ether to the fund collection wallet
510   // override to create custom fund forwarding mechanisms
511   function forwardFunds() internal {
512     wallet.transfer(msg.value);
513   }
514 
515   // @return true if the transaction can buy tokens
516   function validPurchase() internal constant returns (bool) {
517     bool withinPeriod = now >= startTime && now <= endTime;
518     bool nonZeroPurchase = msg.value != 0;
519     return withinPeriod && nonZeroPurchase;
520   }
521 
522   // @return true if crowdsale event has ended
523   function hasEnded() public constant returns (bool) {
524     return now > endTime;
525   }
526 
527 
528 }
529 
530 /**
531 * @dev Parent crowdsale contract extended with support for pausable crowdsale, meaning crowdsale can be paused by owner at any time
532 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
533 * 
534 * While the contract is in paused state, the contributions will be rejected
535 * 
536 */
537 contract PausableCrowdsale is Crowdsale, Pausable {
538 
539     function PausableCrowdsale(bool _paused) public {
540         if (_paused) {
541             pause();
542         }
543     }
544 
545     // overriding Crowdsale#validPurchase to add extra paused logic
546     // @return true if investors can buy at the moment
547     function validPurchase() internal constant returns(bool) {
548         return super.validPurchase() && !paused;
549     }
550 
551 }
552 
553 /**
554 * @dev Parent crowdsale contract with support for time-based and amount based bonuses 
555 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
556 * 
557 */
558 contract BonusCrowdsale is Crowdsale, Ownable {
559 
560     // Constants
561     // The following will be populated by main crowdsale contract
562     uint32[] public BONUS_TIMES;
563     uint32[] public BONUS_TIMES_VALUES;
564     uint32[] public BONUS_AMOUNTS;
565     uint32[] public BONUS_AMOUNTS_VALUES;
566     uint public constant BONUS_COEFF = 1000; // Values should be 10x percents, value 1000 = 100%
567     
568     // Members
569     uint public tokenPriceInCents;
570 
571     /**
572     * @dev Contructor
573     * @param _tokenPriceInCents token price in USD cents. The price is fixed
574     */
575     function BonusCrowdsale(uint256 _tokenPriceInCents) public {
576         tokenPriceInCents = _tokenPriceInCents;
577     }
578 
579     /**
580     * @dev Retrieve length of bonuses by time array
581     * @return Bonuses by time array length
582     */
583     function bonusesForTimesCount() public constant returns(uint) {
584         return BONUS_TIMES.length;
585     }
586 
587     /**
588     * @dev Sets bonuses for time
589     */
590     function setBonusesForTimes(uint32[] times, uint32[] values) public onlyOwner {
591         require(times.length == values.length);
592         for (uint i = 0; i + 1 < times.length; i++) {
593             require(times[i] < times[i+1]);
594         }
595 
596         BONUS_TIMES = times;
597         BONUS_TIMES_VALUES = values;
598     }
599 
600     /**
601     * @dev Retrieve length of bonuses by amounts array
602     * @return Bonuses by amounts array length
603     */
604     function bonusesForAmountsCount() public constant returns(uint) {
605         return BONUS_AMOUNTS.length;
606     }
607 
608     /**
609     * @dev Sets bonuses for USD amounts
610     */
611     function setBonusesForAmounts(uint32[] amounts, uint32[] values) public onlyOwner {
612         require(amounts.length == values.length);
613         for (uint i = 0; i + 1 < amounts.length; i++) {
614             require(amounts[i] > amounts[i+1]);
615         }
616 
617         BONUS_AMOUNTS = amounts;
618         BONUS_AMOUNTS_VALUES = values;
619     }
620 
621     /**
622     * @dev Overrided buyTokens method of parent Crowdsale contract  to provide bonus by changing and restoring rate variable
623     * @param beneficiary walelt of investor to receive tokens
624     */
625     function buyTokens(address beneficiary) public payable {
626         // Compute usd amount = wei * catsInEth * usdcentsInCat / usdcentsPerUsd / weisPerEth
627         uint256 usdValue = msg.value.mul(rate).mul(tokenPriceInCents).div(100).div(1 ether); 
628         
629         // Compute time and amount bonus
630         uint256 bonus = computeBonus(usdValue);
631 
632         // Apply bonus by adjusting and restoring rate member
633         uint256 oldRate = rate;
634         rate = rate.mul(BONUS_COEFF.add(bonus)).div(BONUS_COEFF);
635         super.buyTokens(beneficiary);
636         rate = oldRate;
637     }
638 
639     /**
640     * @dev Computes overall bonus based on time of contribution and amount of contribution. 
641     * The total bonus is the sum of bonus by time and bonus by amount
642     * @return bonus percentage scaled by 10
643     */
644     function computeBonus(uint256 usdValue) public constant returns(uint256) {
645         return computeAmountBonus(usdValue).add(computeTimeBonus());
646     }
647 
648     /**
649     * @dev Computes bonus based on time of contribution relative to the beginning of crowdsale
650     * @return bonus percentage scaled by 10
651     */
652     function computeTimeBonus() public constant returns(uint256) {
653         require(now >= startTime);
654 
655         for (uint i = 0; i < BONUS_TIMES.length; i++) {
656             if (now.sub(startTime) <= BONUS_TIMES[i]) {
657                 return BONUS_TIMES_VALUES[i];
658             }
659         }
660 
661         return 0;
662     }
663 
664     /**
665     * @dev Computes bonus based on amount of contribution
666     * @return bonus percentage scaled by 10
667     */
668     function computeAmountBonus(uint256 usdValue) public constant returns(uint256) {
669         for (uint i = 0; i < BONUS_AMOUNTS.length; i++) {
670             if (usdValue >= BONUS_AMOUNTS[i]) {
671                 return BONUS_AMOUNTS_VALUES[i];
672             }
673         }
674 
675         return 0;
676     }
677 
678 }
679 
680 
681 
682 /**
683 * @dev Parent crowdsale contract is extended with support for cap in tokens
684 * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
685 * 
686 */
687 contract TokensCappedCrowdsale is Crowdsale {
688 
689     uint256 public tokensCap;
690 
691     function TokensCappedCrowdsale(uint256 _tokensCap) public {
692         tokensCap = _tokensCap;
693     }
694 
695     // overriding Crowdsale#validPurchase to add extra tokens cap logic
696     // @return true if investors can buy at the moment
697     function validPurchase() internal constant returns(bool) {
698         uint256 tokens = token.totalSupply().add(msg.value.mul(rate));
699         bool withinCap = tokens <= tokensCap;
700         return super.validPurchase() && withinCap;
701     }
702 
703     // overriding Crowdsale#hasEnded to add tokens cap logic
704     // @return true if crowdsale event has ended
705     function hasEnded() public constant returns(bool) {
706         bool capReached = token.totalSupply() >= tokensCap;
707         return super.hasEnded() || capReached;
708     }
709 
710 }
711 
712 /**
713  * @title FinalizableCrowdsale
714  * @dev Extension of Crowdsale where an owner can do extra work
715  * after finishing.
716  */
717 contract FinalizableCrowdsale is Crowdsale, Ownable {
718   using SafeMath for uint256;
719 
720   bool public isFinalized = false;
721 
722   event Finalized();
723 
724   /**
725    * @dev Must be called after crowdsale ends, to do some extra finalization
726    * work. Calls the contract's finalization function.
727    */
728   function finalize() onlyOwner public {
729     require(!isFinalized);
730     require(hasEnded());
731 
732     finalization();
733     Finalized();
734 
735     isFinalized = true;
736   }
737 
738   /**
739    * @dev Can be overridden to add finalization logic. The overriding function
740    * should call super.finalization() to ensure the chain of finalization is
741    * executed entirely.
742    */
743   function finalization() internal {
744     isFinalized = isFinalized;
745   }
746 }
747 
748 
749    /**
750    * @dev Main BitCalve Crowdsale contract. 
751    * Based on references from OpenZeppelin: https://github.com/OpenZeppelin/zeppelin-solidity
752    * 
753    */
754 contract CATCrowdsale is FinalizableCrowdsale, TokensCappedCrowdsale(CATCrowdsale.CAP), PausableCrowdsale(true), BonusCrowdsale(CATCrowdsale.TOKEN_USDCENT_PRICE) {
755 
756     // Constants
757     uint256 public constant DECIMALS = 18;
758     uint256 public constant CAP = 2 * (10**9) * (10**DECIMALS);              // 2B CAT
759     uint256 public constant BITCLAVE_AMOUNT = 1 * (10**9) * (10**DECIMALS);  // 1B CAT
760     uint256 public constant TOKEN_USDCENT_PRICE = 10;                        // $0.10
761 
762     // Variables
763     address public remainingTokensWallet;
764     address public presaleWallet;
765 
766     /**
767     * @dev Sets CAT to Ether rate. Will be called multiple times durign the crowdsale to adjsut the rate
768     * since CAT cost is fixed in USD, but USD/ETH rate is changing
769     * @param _rate defines CAT/ETH rate: 1 ETH = _rate CATs
770     */
771     function setRate(uint256 _rate) external onlyOwner {
772         require(_rate != 0x0);
773         rate = _rate;
774         RateChange(_rate);
775     }
776 
777     /**
778     * @dev Allows to adjust the crowdsale end time
779     */
780     function setEndTime(uint256 _endTime) external onlyOwner {
781         require(!isFinalized);
782         require(_endTime >= startTime);
783         require(_endTime >= now);
784         endTime = _endTime;
785     }
786 
787     /**
788     * @dev Sets the wallet to forward ETH collected funds
789     */
790     function setWallet(address _wallet) external onlyOwner {
791         require(_wallet != 0x0);
792         wallet = _wallet;
793     }
794 
795     /**
796     * @dev Sets the wallet to hold unsold tokens at the end of ICO
797     */
798     function setRemainingTokensWallet(address _remainingTokensWallet) external onlyOwner {
799         require(_remainingTokensWallet != 0x0);
800         remainingTokensWallet = _remainingTokensWallet;
801     }
802 
803     // Events
804     event RateChange(uint256 rate);
805 
806     /**
807     * @dev Contructor
808     * @param _startTime startTime of crowdsale
809     * @param _endTime endTime of crowdsale
810     * @param _rate CAT / ETH rate
811     * @param _wallet wallet to forward the collected funds
812     * @param _remainingTokensWallet wallet to hold the unsold tokens
813     * @param _bitClaveWallet wallet to hold the initial 1B tokens of BitClave
814     */
815     function CATCrowdsale(
816         uint256 _startTime,
817         uint256 _endTime,
818         uint256 _rate,
819         address _wallet,
820         address _remainingTokensWallet,
821         address _bitClaveWallet
822     ) public
823         Crowdsale(_startTime, _endTime, _rate, _wallet)
824     {
825         remainingTokensWallet = _remainingTokensWallet;
826         presaleWallet = this;
827 
828         // allocate tokens to BitClave
829         mintTokens(_bitClaveWallet, BITCLAVE_AMOUNT);
830     }
831 
832     // Overrided methods
833 
834     /**
835     * @dev Creates token contract for ICO
836     * @return ERC20 contract associated with the crowdsale
837     */
838     function createTokenContract() internal returns(MintableToken) {
839         PreCAToken token = new PreCAToken();
840         token.pause();
841         return token;
842     }
843 
844     /**
845     * @dev Finalizes the crowdsale
846     */
847     function finalization() internal {
848         super.finalization();
849 
850         // Mint tokens up to CAP
851         if (token.totalSupply() < tokensCap) {
852             uint tokens = tokensCap.sub(token.totalSupply());
853             token.mint(remainingTokensWallet, tokens);
854         }
855 
856         // disable minting of CATs
857         token.finishMinting();
858 
859         // take onwership over CAToken contract
860         token.transferOwnership(owner);
861     }
862 
863     // Owner methods
864 
865     /**
866     * @dev Helper to Pause CAToken
867     */
868     function pauseTokens() public onlyOwner {
869         PreCAToken(token).pause();
870     }
871 
872     /**
873     * @dev Helper to UnPause CAToken
874     */
875     function unpauseTokens() public onlyOwner {
876         PreCAToken(token).unpause();
877     }
878 
879     /**
880     * @dev Allocates tokens from preSale to a special wallet. Called once as part of crowdsale setup
881     */
882     function mintPresaleTokens(uint256 tokens) public onlyOwner {
883         mintTokens(presaleWallet, tokens);
884         presaleWallet = 0;
885     }
886 
887     /**
888     * @dev Transfer presaled tokens even on paused token contract
889     */
890     function transferPresaleTokens(address destination, uint256 amount) public onlyOwner {
891         unpauseTokens();
892         token.transfer(destination, amount);
893         pauseTokens();
894     }
895 
896     // 
897     /**
898     * @dev Allocates tokens for investors that contributed from website. These include
899     * whitelisted investors and investors paying with BTC/QTUM/LTC
900     */
901     function mintTokens(address beneficiary, uint256 tokens) public onlyOwner {
902         require(beneficiary != 0x0);
903         require(tokens > 0);
904         require(now <= endTime);                               // Crowdsale (without startTime check)
905         require(!isFinalized);                                 // FinalizableCrowdsale
906         require(token.totalSupply().add(tokens) <= tokensCap); // TokensCappedCrowdsale
907         
908         token.mint(beneficiary, tokens);
909     }
910 
911 }