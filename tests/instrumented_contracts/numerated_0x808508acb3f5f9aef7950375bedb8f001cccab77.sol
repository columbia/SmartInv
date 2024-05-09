1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title ERC20Basic
57  * @dev Simpler version of ERC20 interface
58  * See https://github.com/ethereum/EIPs/issues/179
59  */
60 contract ERC20Basic {
61   function totalSupply() public view returns (uint256);
62   function balanceOf(address who) public view returns (uint256);
63   function transfer(address to, uint256 value) public returns (bool);
64   event Transfer(address indexed from, address indexed to, uint256 value);
65 }
66 
67 
68 /**
69  * @title SafeERC20
70  * @dev Wrappers around ERC20 operations that throw on failure.
71  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
72  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
73  */
74 library SafeERC20 {
75   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
76     require(token.transfer(to, value));
77   }
78 
79   function safeTransferFrom(
80     ERC20 token,
81     address from,
82     address to,
83     uint256 value
84   )
85     internal
86   {
87     require(token.transferFrom(from, to, value));
88   }
89 
90   function safeApprove(ERC20 token, address spender, uint256 value) internal {
91     require(token.approve(spender, value));
92   }
93 }
94 
95 
96 
97 /**
98  * @title Ownable
99  * @dev The Ownable contract has an owner address, and provides basic authorization control
100  * functions, this simplifies the implementation of "user permissions".
101  */
102 contract Ownable {
103   address public owner;
104 
105 
106   event OwnershipRenounced(address indexed previousOwner);
107   event OwnershipTransferred(
108     address indexed previousOwner,
109     address indexed newOwner
110   );
111 
112 
113   /**
114    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115    * account.
116    */
117   constructor() public {
118     owner = msg.sender;
119   }
120 
121   /**
122    * @dev Throws if called by any account other than the owner.
123    */
124   modifier onlyOwner() {
125     require(msg.sender == owner);
126     _;
127   }
128 
129   /**
130    * @dev Allows the current owner to relinquish control of the contract.
131    * @notice Renouncing to ownership will leave the contract without an owner.
132    * It will not be possible to call the functions with the `onlyOwner`
133    * modifier anymore.
134    */
135   function renounceOwnership() public onlyOwner {
136     emit OwnershipRenounced(owner);
137     owner = address(0);
138   }
139 
140   /**
141    * @dev Allows the current owner to transfer control of the contract to a newOwner.
142    * @param _newOwner The address to transfer ownership to.
143    */
144   function transferOwnership(address _newOwner) public onlyOwner {
145     _transferOwnership(_newOwner);
146   }
147 
148   /**
149    * @dev Transfers control of the contract to a newOwner.
150    * @param _newOwner The address to transfer ownership to.
151    */
152   function _transferOwnership(address _newOwner) internal {
153     require(_newOwner != address(0));
154     emit OwnershipTransferred(owner, _newOwner);
155     owner = _newOwner;
156   }
157 }
158 
159 
160 /**
161  * @title Basic token
162  * @dev Basic version of StandardToken, with no allowances.
163  */
164 contract BasicToken is ERC20Basic {
165   using SafeMath for uint256;
166 
167   mapping(address => uint256) balances;
168 
169   uint256 totalSupply_;
170 
171   /**
172   * @dev Total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev Transfer token for a specified address
180   * @param _to The address to transfer to.
181   * @param _value The amount to be transferred.
182   */
183   function transfer(address _to, uint256 _value) public returns (bool) {
184     require(_to != address(0));
185     require(_value <= balances[msg.sender]);
186 
187     balances[msg.sender] = balances[msg.sender].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     emit Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256) {
199     return balances[_owner];
200   }
201 
202 }
203 
204 
205 /**
206  * @title ERC20 interface
207  * @dev see https://github.com/ethereum/EIPs/issues/20
208  */
209 contract ERC20 is ERC20Basic {
210   function allowance(address owner, address spender)
211     public view returns (uint256);
212 
213   function transferFrom(address from, address to, uint256 value)
214     public returns (bool);
215 
216   function approve(address spender, uint256 value) public returns (bool);
217   event Approval(
218     address indexed owner,
219     address indexed spender,
220     uint256 value
221   );
222 }
223 
224 
225 /**
226  * @title Standard ERC20 token
227  *
228  * @dev Implementation of the basic standard token.
229  * https://github.com/ethereum/EIPs/issues/20
230  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
231  */
232 contract StandardToken is ERC20, BasicToken {
233 
234   mapping (address => mapping (address => uint256)) internal allowed;
235 
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param _from address The address which you want to send tokens from
240    * @param _to address The address which you want to transfer to
241    * @param _value uint256 the amount of tokens to be transferred
242    */
243   function transferFrom(
244     address _from,
245     address _to,
246     uint256 _value
247   )
248     public
249     returns (bool)
250   {
251     require(_to != address(0));
252     require(_value <= balances[_from]);
253     require(_value <= allowed[_from][msg.sender]);
254 
255     balances[_from] = balances[_from].sub(_value);
256     balances[_to] = balances[_to].add(_value);
257     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
258     emit Transfer(_from, _to, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
264    * Beware that changing an allowance with this method brings the risk that someone may use both the old
265    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
266    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    * @param _spender The address which will spend the funds.
269    * @param _value The amount of tokens to be spent.
270    */
271   function approve(address _spender, uint256 _value) public returns (bool) {
272     allowed[msg.sender][_spender] = _value;
273     emit Approval(msg.sender, _spender, _value);
274     return true;
275   }
276 
277   /**
278    * @dev Function to check the amount of tokens that an owner allowed to a spender.
279    * @param _owner address The address which owns the funds.
280    * @param _spender address The address which will spend the funds.
281    * @return A uint256 specifying the amount of tokens still available for the spender.
282    */
283   function allowance(
284     address _owner,
285     address _spender
286    )
287     public
288     view
289     returns (uint256)
290   {
291     return allowed[_owner][_spender];
292   }
293 
294   /**
295    * @dev Increase the amount of tokens that an owner allowed to a spender.
296    * approve should be called when allowed[_spender] == 0. To increment
297    * allowed value is better to use this function to avoid 2 calls (and wait until
298    * the first transaction is mined)
299    * From MonolithDAO Token.sol
300    * @param _spender The address which will spend the funds.
301    * @param _addedValue The amount of tokens to increase the allowance by.
302    */
303   function increaseApproval(
304     address _spender,
305     uint256 _addedValue
306   )
307     public
308     returns (bool)
309   {
310     allowed[msg.sender][_spender] = (
311       allowed[msg.sender][_spender].add(_addedValue));
312     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
313     return true;
314   }
315 
316   /**
317    * @dev Decrease the amount of tokens that an owner allowed to a spender.
318    * approve should be called when allowed[_spender] == 0. To decrement
319    * allowed value is better to use this function to avoid 2 calls (and wait until
320    * the first transaction is mined)
321    * From MonolithDAO Token.sol
322    * @param _spender The address which will spend the funds.
323    * @param _subtractedValue The amount of tokens to decrease the allowance by.
324    */
325   function decreaseApproval(
326     address _spender,
327     uint256 _subtractedValue
328   )
329     public
330     returns (bool)
331   {
332     uint256 oldValue = allowed[msg.sender][_spender];
333     if (_subtractedValue > oldValue) {
334       allowed[msg.sender][_spender] = 0;
335     } else {
336       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
337     }
338     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
339     return true;
340   }
341 
342 }
343 
344 
345 /**
346  * @title Mintable token
347  * @dev Simple ERC20 Token example, with mintable token creation
348  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
349  */
350 contract MintableToken is StandardToken, Ownable {
351   event Mint(address indexed to, uint256 amount);
352   event MintFinished();
353 
354   bool public mintingFinished = false;
355 
356 
357   modifier canMint() {
358     require(!mintingFinished);
359     _;
360   }
361 
362   modifier hasMintPermission() {
363     require(msg.sender == owner);
364     _;
365   }
366 
367   /**
368    * @dev Function to mint tokens
369    * @param _to The address that will receive the minted tokens.
370    * @param _amount The amount of tokens to mint.
371    * @return A boolean that indicates if the operation was successful.
372    */
373   function mint(
374     address _to,
375     uint256 _amount
376   )
377     hasMintPermission
378     canMint
379     public
380     returns (bool)
381   {
382     totalSupply_ = totalSupply_.add(_amount);
383     balances[_to] = balances[_to].add(_amount);
384     emit Mint(_to, _amount);
385     emit Transfer(address(0), _to, _amount);
386     return true;
387   }
388 
389   /**
390    * @dev Function to stop minting new tokens.
391    * @return True if the operation was successful.
392    */
393   function finishMinting() onlyOwner canMint public returns (bool) {
394     mintingFinished = true;
395     emit MintFinished();
396     return true;
397   }
398 }
399 
400 
401 /**
402  * @title Pausable
403  * @dev Base contract which allows children to implement an emergency stop mechanism.
404  */
405 contract Pausable is Ownable {
406   event Pause();
407   event Unpause();
408 
409   bool public paused = false;
410 
411 
412   /**
413    * @dev Modifier to make a function callable only when the contract is not paused.
414    */
415   modifier whenNotPaused() {
416     require(!paused);
417     _;
418   }
419 
420   /**
421    * @dev Modifier to make a function callable only when the contract is paused.
422    */
423   modifier whenPaused() {
424     require(paused);
425     _;
426   }
427 
428   /**
429    * @dev called by the owner to pause, triggers stopped state
430    */
431   function pause() onlyOwner whenNotPaused public {
432     paused = true;
433     emit Pause();
434   }
435 
436   /**
437    * @dev called by the owner to unpause, returns to normal state
438    */
439   function unpause() onlyOwner whenPaused public {
440     paused = false;
441     emit Unpause();
442   }
443 }
444 
445 
446 
447 /**
448  * @title Pausable token
449  * @dev StandardToken modified with pausable transfers.
450  **/
451 contract PausableToken is StandardToken, Pausable {
452 
453   function transfer(
454     address _to,
455     uint256 _value
456   )
457     public
458     whenNotPaused
459     returns (bool)
460   {
461     return super.transfer(_to, _value);
462   }
463 
464   function transferFrom(
465     address _from,
466     address _to,
467     uint256 _value
468   )
469     public
470     whenNotPaused
471     returns (bool)
472   {
473     return super.transferFrom(_from, _to, _value);
474   }
475 
476   function approve(
477     address _spender,
478     uint256 _value
479   )
480     public
481     whenNotPaused
482     returns (bool)
483   {
484     return super.approve(_spender, _value);
485   }
486 
487   function increaseApproval(
488     address _spender,
489     uint _addedValue
490   )
491     public
492     whenNotPaused
493     returns (bool success)
494   {
495     return super.increaseApproval(_spender, _addedValue);
496   }
497 
498   function decreaseApproval(
499     address _spender,
500     uint _subtractedValue
501   )
502     public
503     whenNotPaused
504     returns (bool success)
505   {
506     return super.decreaseApproval(_spender, _subtractedValue);
507   }
508 }
509 
510 
511 contract LittlePhilCoin is MintableToken, PausableToken {
512     string public name = "Little Phil Coin";
513     string public symbol = "LPC";
514     uint8 public decimals = 18;
515 
516     constructor () public {
517         // Pause token on creation and only unpause after ICO
518         pause();
519     }
520 
521 }
522 
523 
524 /**
525  * @title Crowdsale
526  * @dev Crowdsale is a base contract for managing a token crowdsale,
527  * allowing investors to purchase tokens with ether. This contract implements
528  * such functionality in its most fundamental form and can be extended to provide additional
529  * functionality and/or custom behavior.
530  * The external interface represents the basic interface for purchasing tokens, and conform
531  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
532  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
533  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
534  * behavior.
535  */
536 contract Crowdsale {
537   using SafeMath for uint256;
538   using SafeERC20 for ERC20;
539 
540   // The token being sold
541   ERC20 public token;
542 
543   // Address where funds are collected
544   address public wallet;
545 
546   // How many token units a buyer gets per wei.
547   // The rate is the conversion between wei and the smallest and indivisible token unit.
548   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
549   // 1 wei will give you 1 unit, or 0.001 TOK.
550   uint256 public rate;
551 
552   // Amount of wei raised
553   uint256 public weiRaised;
554 
555   /**
556    * Event for token purchase logging
557    * @param purchaser who paid for the tokens
558    * @param beneficiary who got the tokens
559    * @param value weis paid for purchase
560    * @param amount amount of tokens purchased
561    */
562   event TokenPurchase(
563     address indexed purchaser,
564     address indexed beneficiary,
565     uint256 value,
566     uint256 amount
567   );
568 
569   /**
570    * @param _rate Number of token units a buyer gets per wei
571    * @param _wallet Address where collected funds will be forwarded to
572    * @param _token Address of the token being sold
573    */
574   constructor(uint256 _rate, address _wallet, ERC20 _token) public {
575     require(_rate > 0);
576     require(_wallet != address(0));
577     require(_token != address(0));
578 
579     rate = _rate;
580     wallet = _wallet;
581     token = _token;
582   }
583 
584   // -----------------------------------------
585   // Crowdsale external interface
586   // -----------------------------------------
587 
588   /**
589    * @dev fallback function ***DO NOT OVERRIDE***
590    */
591   function () external payable {
592     buyTokens(msg.sender);
593   }
594 
595   /**
596    * @dev low level token purchase ***DO NOT OVERRIDE***
597    * @param _beneficiary Address performing the token purchase
598    */
599   function buyTokens(address _beneficiary) public payable {
600 
601     uint256 weiAmount = msg.value;
602     _preValidatePurchase(_beneficiary, weiAmount);
603 
604     // calculate token amount to be created
605     uint256 tokens = _getTokenAmount(weiAmount);
606 
607     // update state
608     weiRaised = weiRaised.add(weiAmount);
609 
610     _processPurchase(_beneficiary, tokens);
611     emit TokenPurchase(
612       msg.sender,
613       _beneficiary,
614       weiAmount,
615       tokens
616     );
617 
618     _updatePurchasingState(_beneficiary, weiAmount);
619 
620     _forwardFunds();
621     _postValidatePurchase(_beneficiary, weiAmount);
622   }
623 
624   // -----------------------------------------
625   // Internal interface (extensible)
626   // -----------------------------------------
627 
628   /**
629    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
630    * @param _beneficiary Address performing the token purchase
631    * @param _weiAmount Value in wei involved in the purchase
632    */
633   function _preValidatePurchase(
634     address _beneficiary,
635     uint256 _weiAmount
636   )
637     internal
638   {
639     require(_beneficiary != address(0));
640     require(_weiAmount != 0);
641   }
642 
643   /**
644    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
645    * @param _beneficiary Address performing the token purchase
646    * @param _weiAmount Value in wei involved in the purchase
647    */
648   function _postValidatePurchase(
649     address _beneficiary,
650     uint256 _weiAmount
651   )
652     internal
653   {
654     // optional override
655   }
656 
657   /**
658    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
659    * @param _beneficiary Address performing the token purchase
660    * @param _tokenAmount Number of tokens to be emitted
661    */
662   function _deliverTokens(
663     address _beneficiary,
664     uint256 _tokenAmount
665   )
666     internal
667   {
668     token.safeTransfer(_beneficiary, _tokenAmount);
669   }
670 
671   /**
672    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
673    * @param _beneficiary Address receiving the tokens
674    * @param _tokenAmount Number of tokens to be purchased
675    */
676   function _processPurchase(
677     address _beneficiary,
678     uint256 _tokenAmount
679   )
680     internal
681   {
682     _deliverTokens(_beneficiary, _tokenAmount);
683   }
684 
685   /**
686    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
687    * @param _beneficiary Address receiving the tokens
688    * @param _weiAmount Value in wei involved in the purchase
689    */
690   function _updatePurchasingState(
691     address _beneficiary,
692     uint256 _weiAmount
693   )
694     internal
695   {
696     // optional override
697   }
698 
699   /**
700    * @dev Override to extend the way in which ether is converted to tokens.
701    * @param _weiAmount Value in wei to be converted into tokens
702    * @return Number of tokens that can be purchased with the specified _weiAmount
703    */
704   function _getTokenAmount(uint256 _weiAmount)
705     internal view returns (uint256)
706   {
707     return _weiAmount.mul(rate);
708   }
709 
710   /**
711    * @dev Determines how ETH is stored/forwarded on purchases.
712    */
713   function _forwardFunds() internal {
714     wallet.transfer(msg.value);
715   }
716 }
717 
718 
719 /**
720  * @title MintedCrowdsale
721  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
722  * Token ownership should be transferred to MintedCrowdsale for minting.
723  */
724 contract MintedCrowdsale is Crowdsale {
725 
726   /**
727    * @dev Overrides delivery by minting tokens upon purchase.
728    * @param _beneficiary Token purchaser
729    * @param _tokenAmount Number of tokens to be minted
730    */
731   function _deliverTokens(
732     address _beneficiary,
733     uint256 _tokenAmount
734   )
735     internal
736   {
737     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
738   }
739 }
740 
741 
742 /**
743  * @title CappedCrowdsale
744  * @dev Crowdsale with a limit for total contributions.
745  */
746 contract CappedCrowdsale is Crowdsale {
747   using SafeMath for uint256;
748 
749   uint256 public cap;
750 
751   /**
752    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
753    * @param _cap Max amount of wei to be contributed
754    */
755   constructor(uint256 _cap) public {
756     require(_cap > 0);
757     cap = _cap;
758   }
759 
760   /**
761    * @dev Checks whether the cap has been reached.
762    * @return Whether the cap was reached
763    */
764   function capReached() public view returns (bool) {
765     return weiRaised >= cap;
766   }
767 
768   /**
769    * @dev Extend parent behavior requiring purchase to respect the funding cap.
770    * @param _beneficiary Token purchaser
771    * @param _weiAmount Amount of wei contributed
772    */
773   function _preValidatePurchase(
774     address _beneficiary,
775     uint256 _weiAmount
776   )
777     internal
778   {
779     super._preValidatePurchase(_beneficiary, _weiAmount);
780     require(weiRaised.add(_weiAmount) <= cap);
781   }
782 
783 }
784 
785 
786 /**
787  * @title TokenCappedCrowdsale
788  * @dev Crowdsale with a limit for total minted tokens.
789  */
790 contract TokenCappedCrowdsale is Crowdsale {
791     using SafeMath for uint256;
792 
793     uint256 public tokenCap = 0;
794 
795     // Amount of LPC raised
796     uint256 public tokensRaised = 0;
797 
798     // Event for manual refund of cap overflow
799     event CapOverflow(address sender, uint256 weiAmount, uint256 receivedTokens);
800 
801     /**
802      * @notice Checks whether the tokenCap has been reached.
803      * @return Whether the tokenCap was reached
804      */
805     function capReached() public view returns (bool) {
806         return tokensRaised >= tokenCap;
807     }
808 
809     /**
810      * @notice Update the amount of tokens raised & emit cap overflow events.
811      */
812     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
813         super._updatePurchasingState(_beneficiary, _weiAmount);
814         uint256 purchasedTokens = _getTokenAmount(_weiAmount);
815         tokensRaised = tokensRaised.add(purchasedTokens);
816 
817         if (capReached()) {
818             // manual process unused eth amount to sender
819             emit CapOverflow(_beneficiary, _weiAmount, purchasedTokens);
820         }
821     }
822 
823 }
824 
825 
826 /**
827  * @title Tiered Crowdsale
828  * @dev Extension of Crowdsale contract that decreases the number of LPC tokens purchases dependent on the current number of tokens sold.
829  */
830 contract TieredCrowdsale is TokenCappedCrowdsale, Ownable {
831 
832     using SafeMath for uint256;
833 
834     /**
835     SalesState enum for use in state machine to manage sales rates
836     */
837     enum SaleState { 
838         Initial,              // All contract initialization calls
839         PrivateSale,          // Private sale for industy and closed group investors
840         FinalisedPrivateSale, // Close private sale
841         PreSale,              // Pre sale ICO (40% bonus LPC hard-capped at 180 million tokens)
842         FinalisedPreSale,     // Close presale
843         PublicSaleTier1,      // Tier 1 ICO public sale (30% bonus LPC capped at 85 million tokens)
844         PublicSaleTier2,      // Tier 2 ICO public sale (20% bonus LPC capped at 65 million tokens)
845         PublicSaleTier3,      // Tier 3 ICO public sale (10% bonus LPC capped at 45 million tokens)
846         PublicSaleTier4,      // Tier 4 ICO public sale (standard rate capped at 25 million tokens)
847         FinalisedPublicSale,  // Close public sale
848         Closed                // ICO has finished, all tokens must have been claimed
849     }
850     SaleState public state = SaleState.Initial;
851 
852     struct TierConfig {
853         string stateName;
854         uint256 tierRatePercentage;
855         uint256 hardCap;
856     }
857 
858     mapping(bytes32 => TierConfig) private tierConfigs;
859 
860     // Event for manual refund of cap overflow
861     event IncrementTieredState(string stateName);
862 
863     /**
864      * @notice Checks the state when validating a purchase
865      */
866     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
867         super._preValidatePurchase(_beneficiary, _weiAmount);
868         require(
869             state == SaleState.PrivateSale ||
870             state == SaleState.PreSale ||
871             state == SaleState.PublicSaleTier1 ||
872             state == SaleState.PublicSaleTier2 ||
873             state == SaleState.PublicSaleTier3 ||
874             state == SaleState.PublicSaleTier4
875         );
876     }
877 
878     /**
879      * @notice Constructor
880      * @dev Caveat emptor: this base contract is intended for inheritance by the Little Phil crowdsale only
881      */
882     constructor() public {
883         // setup the map of bonus-rates for each SaleState tier
884         createSalesTierConfigMap();
885     }
886 
887     /**
888      * @dev Overrides parent method taking into account variable rate (as a percentage).
889      * @param _weiAmount The value in wei to be converted into tokens
890      * @return The number of tokens _weiAmount wei will buy at present time.
891      */
892     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
893         uint256 currentTierRate = getCurrentTierRatePercentage();
894 
895         uint256 requestedTokenAmount = _weiAmount.mul(rate).mul(currentTierRate).div(100);
896 
897         uint256 remainingTokens = tokenCap.sub(tokensRaised);
898 
899         // Return number of LPC to provide
900         if (requestedTokenAmount > remainingTokens) {
901             return remainingTokens;
902         }
903 
904         return requestedTokenAmount;
905     }
906 
907     /**
908      * @dev Setup the map of bonus-rates (as a percentage) and total hardCap for each SaleState tier
909      * to be called by the constructor.
910      */
911     function createSalesTierConfigMap() private {
912 
913         tierConfigs [keccak256(SaleState.Initial)] = TierConfig({
914             stateName: "Initial",
915             tierRatePercentage: 0,
916             hardCap: 0
917         });
918         tierConfigs [keccak256(SaleState.PrivateSale)] = TierConfig({
919             stateName: "PrivateSale",
920             tierRatePercentage: 100,
921             hardCap: SafeMath.mul(400000000, (10 ** 18))
922         });
923         tierConfigs [keccak256(SaleState.FinalisedPrivateSale)] = TierConfig({
924             stateName: "FinalisedPrivateSale",
925             tierRatePercentage: 0,
926             hardCap: 0
927         });
928         tierConfigs [keccak256(SaleState.PreSale)] = TierConfig({
929             stateName: "PreSale",
930             tierRatePercentage: 140,
931             hardCap: SafeMath.mul(180000000, (10 ** 18))
932         });
933         tierConfigs [keccak256(SaleState.FinalisedPreSale)] = TierConfig({
934             stateName: "FinalisedPreSale",
935             tierRatePercentage: 0,
936             hardCap: 0
937         });
938         tierConfigs [keccak256(SaleState.PublicSaleTier1)] = TierConfig({
939             stateName: "PublicSaleTier1",
940             tierRatePercentage: 130,
941             hardCap: SafeMath.mul(265000000, (10 ** 18))
942         });
943         tierConfigs [keccak256(SaleState.PublicSaleTier2)] = TierConfig({
944             stateName: "PublicSaleTier2",
945             tierRatePercentage: 120,
946             hardCap: SafeMath.mul(330000000, (10 ** 18))
947         });
948         tierConfigs [keccak256(SaleState.PublicSaleTier3)] = TierConfig({
949             stateName: "PublicSaleTier3",
950             tierRatePercentage: 110,
951             hardCap: SafeMath.mul(375000000, (10 ** 18))
952         });
953         tierConfigs [keccak256(SaleState.PublicSaleTier4)] = TierConfig({
954             stateName: "PublicSaleTier4",
955             tierRatePercentage: 100,
956             hardCap: SafeMath.mul(400000000, (10 ** 18))
957         });
958         tierConfigs [keccak256(SaleState.FinalisedPublicSale)] = TierConfig({
959             stateName: "FinalisedPublicSale",
960             tierRatePercentage: 0,
961             hardCap: 0
962         });
963         tierConfigs [keccak256(SaleState.Closed)] = TierConfig({
964             stateName: "Closed",
965             tierRatePercentage: 0,
966             hardCap: SafeMath.mul(400000000, (10 ** 18))
967         });
968         
969 
970     }
971 
972     /**
973      * @dev get the current bonus-rate for the current SaleState
974      * @return the current rate as a percentage (e.g. 140 = 140% bonus)
975      */
976     function getCurrentTierRatePercentage() public view returns (uint256) {
977         return tierConfigs[keccak256(state)].tierRatePercentage;
978     }
979 
980     /**
981      * @dev Get the current hardCap for the current SaleState
982      * @return The current hardCap
983      */
984     function getCurrentTierHardcap() public view returns (uint256) {
985         return tierConfigs[keccak256(state)].hardCap;
986     }
987 
988     /**
989      * @dev Only allow the owner to set the state.
990      */
991     function setState(uint256 _state) onlyOwner public {
992         state = SaleState(_state);
993 
994         // Update cap when state changes
995         tokenCap = getCurrentTierHardcap();
996 
997         if (state == SaleState.Closed) {
998             crowdsaleClosed();
999         }
1000     }
1001 
1002     function getState() public view returns (string) {
1003         return tierConfigs[keccak256(state)].stateName;
1004     }
1005 
1006     /**
1007      * @dev Change the bonus tier after a purchase.
1008      */
1009     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1010         super._updatePurchasingState(_beneficiary, _weiAmount);
1011 
1012         if (capReached()) {
1013             if (state == SaleState.PrivateSale) {
1014                 state = SaleState.FinalisedPrivateSale;
1015             }
1016             else if (state == SaleState.PreSale) {
1017                 state = SaleState.FinalisedPreSale;
1018             }
1019             else if (state == SaleState.PublicSaleTier1) {
1020                 state = SaleState.PublicSaleTier2;
1021             }
1022             else if (state == SaleState.PublicSaleTier2) {
1023                 state = SaleState.PublicSaleTier3;
1024             }
1025             else if (state == SaleState.PublicSaleTier3) {
1026                 state = SaleState.PublicSaleTier4;
1027             }
1028             else if (state == SaleState.PublicSaleTier4) {
1029                 state = SaleState.FinalisedPublicSale;
1030             } else {
1031                 return;
1032             }
1033 
1034             tokenCap = getCurrentTierHardcap();
1035             emit IncrementTieredState(getState());
1036         }
1037 
1038     }
1039 
1040     /**
1041      * Override for extensions that require an internal notification when the crowdsale has closed
1042      */
1043     function crowdsaleClosed() internal {
1044         // optional override
1045     }
1046 
1047 }
1048 
1049 /**
1050  * @title TokenTimelock
1051  * @dev TokenTimelock is a token holder contract that will allow a
1052  * beneficiary to extract the tokens after a given release time
1053  */
1054 contract TokenTimelock {
1055   using SafeERC20 for ERC20Basic;
1056 
1057   // ERC20 basic token contract being held
1058   ERC20Basic public token;
1059 
1060   // beneficiary of tokens after they are released
1061   address public beneficiary;
1062 
1063   // timestamp when token release is enabled
1064   uint256 public releaseTime;
1065 
1066   constructor(
1067     ERC20Basic _token,
1068     address _beneficiary,
1069     uint256 _releaseTime
1070   )
1071     public
1072   {
1073     // solium-disable-next-line security/no-block-members
1074     require(_releaseTime > block.timestamp);
1075     token = _token;
1076     beneficiary = _beneficiary;
1077     releaseTime = _releaseTime;
1078   }
1079 
1080   /**
1081    * @notice Transfers tokens held by timelock to beneficiary.
1082    */
1083   function release() public {
1084     // solium-disable-next-line security/no-block-members
1085     require(block.timestamp >= releaseTime);
1086 
1087     uint256 amount = token.balanceOf(this);
1088     require(amount > 0);
1089 
1090     token.safeTransfer(beneficiary, amount);
1091   }
1092 }
1093 
1094 contract InitialSupplyCrowdsale is Crowdsale, Ownable {
1095 
1096     using SafeMath for uint256;
1097 
1098     uint256 public constant decimals = 18;
1099 
1100     // Wallet properties
1101     address public companyWallet;
1102     address public teamWallet;
1103     address public projectWallet;
1104     address public advisorWallet;
1105     address public bountyWallet;
1106     address public airdropWallet;
1107 
1108     // Team locked tokens
1109     TokenTimelock public teamTimeLock1;
1110     TokenTimelock public teamTimeLock2;
1111 
1112     // Reserved tokens
1113     uint256 public constant companyTokens    = SafeMath.mul(150000000, (10 ** decimals));
1114     uint256 public constant teamTokens       = SafeMath.mul(150000000, (10 ** decimals));
1115     uint256 public constant projectTokens    = SafeMath.mul(150000000, (10 ** decimals));
1116     uint256 public constant advisorTokens    = SafeMath.mul(100000000, (10 ** decimals));
1117     uint256 public constant bountyTokens     = SafeMath.mul(30000000, (10 ** decimals));
1118     uint256 public constant airdropTokens    = SafeMath.mul(20000000, (10 ** decimals));
1119 
1120     bool private isInitialised = false;
1121 
1122     constructor(
1123         address[6] _wallets
1124     ) public {
1125         address _companyWallet  = _wallets[0];
1126         address _teamWallet     = _wallets[1];
1127         address _projectWallet  = _wallets[2];
1128         address _advisorWallet  = _wallets[3];
1129         address _bountyWallet   = _wallets[4];
1130         address _airdropWallet  = _wallets[5];
1131 
1132         require(_companyWallet != address(0));
1133         require(_teamWallet != address(0));
1134         require(_projectWallet != address(0));
1135         require(_advisorWallet != address(0));
1136         require(_bountyWallet != address(0));
1137         require(_airdropWallet != address(0));
1138 
1139         // Set reserved wallets
1140         companyWallet = _companyWallet;
1141         teamWallet = _teamWallet;
1142         projectWallet = _projectWallet;
1143         advisorWallet = _advisorWallet;
1144         bountyWallet = _bountyWallet;
1145         airdropWallet = _airdropWallet;
1146 
1147         // Lock team tokens in wallet over time periods
1148         teamTimeLock1 = new TokenTimelock(token, teamWallet, uint64(now + 182 days));
1149         teamTimeLock2 = new TokenTimelock(token, teamWallet, uint64(now + 365 days));
1150     }
1151 
1152     /**
1153      * Function: Distribute initial token supply
1154      */
1155     function setupInitialSupply() internal onlyOwner {
1156         require(isInitialised == false);
1157         uint256 teamTokensSplit = teamTokens.mul(50).div(100);
1158 
1159         // Distribute tokens to reserved wallets
1160         LittlePhilCoin(token).mint(companyWallet, companyTokens);
1161         LittlePhilCoin(token).mint(projectWallet, projectTokens);
1162         LittlePhilCoin(token).mint(advisorWallet, advisorTokens);
1163         LittlePhilCoin(token).mint(bountyWallet, bountyTokens);
1164         LittlePhilCoin(token).mint(airdropWallet, airdropTokens);
1165         LittlePhilCoin(token).mint(address(teamTimeLock1), teamTokensSplit);
1166         LittlePhilCoin(token).mint(address(teamTimeLock2), teamTokensSplit);
1167 
1168         isInitialised = true;
1169     }
1170 
1171 }
1172 
1173 /**
1174  * @title TokenVesting
1175  * @dev A token holder contract that can release its token balance gradually like a
1176  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1177  * owner.
1178  */
1179 contract TokenVesting is Ownable {
1180   using SafeMath for uint256;
1181   using SafeERC20 for ERC20Basic;
1182 
1183   event Released(uint256 amount);
1184   event Revoked();
1185 
1186   // beneficiary of tokens after they are released
1187   address public beneficiary;
1188 
1189   uint256 public cliff;
1190   uint256 public start;
1191   uint256 public duration;
1192 
1193   bool public revocable;
1194 
1195   mapping (address => uint256) public released;
1196   mapping (address => bool) public revoked;
1197 
1198   /**
1199    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1200    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1201    * of the balance will have vested.
1202    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1203    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1204    * @param _start the time (as Unix time) at which point vesting starts 
1205    * @param _duration duration in seconds of the period in which the tokens will vest
1206    * @param _revocable whether the vesting is revocable or not
1207    */
1208   constructor(
1209     address _beneficiary,
1210     uint256 _start,
1211     uint256 _cliff,
1212     uint256 _duration,
1213     bool _revocable
1214   )
1215     public
1216   {
1217     require(_beneficiary != address(0));
1218     require(_cliff <= _duration);
1219 
1220     beneficiary = _beneficiary;
1221     revocable = _revocable;
1222     duration = _duration;
1223     cliff = _start.add(_cliff);
1224     start = _start;
1225   }
1226 
1227   /**
1228    * @notice Transfers vested tokens to beneficiary.
1229    * @param token ERC20 token which is being vested
1230    */
1231   function release(ERC20Basic token) public {
1232     uint256 unreleased = releasableAmount(token);
1233 
1234     require(unreleased > 0);
1235 
1236     released[token] = released[token].add(unreleased);
1237 
1238     token.safeTransfer(beneficiary, unreleased);
1239 
1240     emit Released(unreleased);
1241   }
1242 
1243   /**
1244    * @notice Allows the owner to revoke the vesting. Tokens already vested
1245    * remain in the contract, the rest are returned to the owner.
1246    * @param token ERC20 token which is being vested
1247    */
1248   function revoke(ERC20Basic token) public onlyOwner {
1249     require(revocable);
1250     require(!revoked[token]);
1251 
1252     uint256 balance = token.balanceOf(this);
1253 
1254     uint256 unreleased = releasableAmount(token);
1255     uint256 refund = balance.sub(unreleased);
1256 
1257     revoked[token] = true;
1258 
1259     token.safeTransfer(owner, refund);
1260 
1261     emit Revoked();
1262   }
1263 
1264   /**
1265    * @dev Calculates the amount that has already vested but hasn't been released yet.
1266    * @param token ERC20 token which is being vested
1267    */
1268   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1269     return vestedAmount(token).sub(released[token]);
1270   }
1271 
1272   /**
1273    * @dev Calculates the amount that has already vested.
1274    * @param token ERC20 token which is being vested
1275    */
1276   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1277     uint256 currentBalance = token.balanceOf(this);
1278     uint256 totalBalance = currentBalance.add(released[token]);
1279 
1280     if (block.timestamp < cliff) {
1281       return 0;
1282     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
1283       return totalBalance;
1284     } else {
1285       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
1286     }
1287   }
1288 }
1289 
1290 
1291 
1292 contract TokenVestingCrowdsale is Crowdsale, Ownable {
1293 
1294     function addBeneficiaryVestor(
1295             address beneficiaryWallet, 
1296             uint256 tokenAmount, 
1297             uint256 vestingEpocStart, 
1298             uint256 cliffInSeconds, 
1299             uint256 vestingEpocEnd
1300         ) external onlyOwner {
1301         TokenVesting newVault = new TokenVesting(
1302             beneficiaryWallet, 
1303             vestingEpocStart, 
1304             cliffInSeconds, 
1305             vestingEpocEnd, 
1306             false
1307         );
1308         LittlePhilCoin(token).mint(address(newVault), tokenAmount);
1309     }
1310 
1311     function releaseVestingTokens(address vaultAddress) external onlyOwner {
1312         TokenVesting(vaultAddress).release(token);
1313     }
1314 
1315 }
1316 
1317 
1318  
1319  
1320 
1321 contract WhitelistedCrowdsale is Crowdsale, Ownable {
1322 
1323     address public whitelister;
1324     mapping(address => bool) public whitelist;
1325 
1326     constructor(address _whitelister) public {
1327         require(_whitelister != address(0));
1328         whitelister = _whitelister;
1329     }
1330 
1331     modifier isWhitelisted(address _beneficiary) {
1332         require(whitelist[_beneficiary]);
1333         _;
1334     }
1335 
1336     function addToWhitelist(address _beneficiary) public onlyOwnerOrWhitelister {
1337         whitelist[_beneficiary] = true;
1338     }
1339 
1340     function addManyToWhitelist(address[] _beneficiaries) public onlyOwnerOrWhitelister {
1341         for (uint256 i = 0; i < _beneficiaries.length; i++) {
1342             whitelist[_beneficiaries[i]] = true;
1343         }
1344     }
1345 
1346     function removeFromWhitelist(address _beneficiary) public onlyOwnerOrWhitelister {
1347         whitelist[_beneficiary] = false;
1348     }
1349 
1350     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isWhitelisted(_beneficiary) {
1351         super._preValidatePurchase(_beneficiary, _weiAmount);
1352     }
1353 
1354     modifier onlyOwnerOrWhitelister() {
1355         require(msg.sender == owner || msg.sender == whitelister);
1356         _;
1357     }
1358 }
1359 
1360 /**
1361  * @title Little Phil Crowdsale
1362  */
1363 contract LittlePhilCrowdsale is MintedCrowdsale, TieredCrowdsale, InitialSupplyCrowdsale, TokenVestingCrowdsale, WhitelistedCrowdsale {
1364 
1365     /**
1366      * @notice Event for rate-change logging
1367      * @param rate the new ETH-to_LPC exchange rate
1368      */
1369     event NewRate(uint256 rate);
1370 
1371     /**
1372      * @notice Constructor
1373      */
1374     constructor(
1375         uint256 _rate,
1376         address _fundsWallet,
1377         address[6] _wallets,
1378         LittlePhilCoin _token,
1379         address _whitelister
1380     ) public
1381     Crowdsale(_rate, _fundsWallet, _token)
1382     InitialSupplyCrowdsale(_wallets) 
1383     WhitelistedCrowdsale(_whitelister){}
1384 
1385     /**
1386      * @notice Sets up the initial balances
1387      * @dev This must be called after ownership of the token is transferred to the crowdsale
1388      */
1389     function setupInitialState() external onlyOwner {
1390         setupInitialSupply();
1391     }
1392 
1393     /**
1394      * @notice Ownership management
1395      */
1396     function transferTokenOwnership(address _newOwner) external onlyOwner {
1397         require(_newOwner != address(0));
1398         // I assume the crowdsale contract holds a reference to the token contract.
1399         LittlePhilCoin(token).transferOwnership(_newOwner);
1400     }
1401 
1402     /**
1403      * @notice Crowdsale Closed
1404      * @dev Called at the end of the crowdsale when it is ended
1405      */
1406     function crowdsaleClosed() internal {
1407         uint256 remainingTokens = tokenCap.sub(tokensRaised);
1408         _deliverTokens(airdropWallet, remainingTokens);
1409         LittlePhilCoin(token).finishMinting();
1410     }
1411 
1412     /**
1413      * @notice Checks the state when validating a purchase
1414      */
1415     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1416         super._preValidatePurchase(_beneficiary, _weiAmount);
1417         require(_weiAmount >= 500000000000000000);
1418     }
1419 
1420     /**
1421      * @notice Update the ETH-to-LPC exchange rate
1422      * @param _rate The Rate that will applied to ETH to derive how many LPC to mint
1423      * does not affect, nor influenced by the bonus rates based on the current tier.
1424      */
1425     function setRate(uint256 _rate) public onlyOwner {
1426         require(_rate > 0);
1427         rate = _rate;
1428         emit NewRate(rate);
1429     }
1430 
1431      /**
1432       * @notice Mint for Private Fiat Transactions
1433       * @dev Allows for minting from owner account
1434       */
1435     function mintForPrivateFiat(address _beneficiary, uint256 _weiAmount) public onlyOwner {
1436         _preValidatePurchase(_beneficiary, _weiAmount);
1437 
1438         // calculate token amount to be created
1439         uint256 tokens = _getTokenAmount(_weiAmount);
1440 
1441         // update state
1442         weiRaised = weiRaised.add(_weiAmount);
1443 
1444         _processPurchase(_beneficiary, tokens);
1445         emit TokenPurchase(
1446             msg.sender,
1447             _beneficiary,
1448             _weiAmount,
1449             tokens
1450         );
1451 
1452         _updatePurchasingState(_beneficiary, _weiAmount);
1453 
1454         _forwardFunds();
1455         _postValidatePurchase(_beneficiary, _weiAmount);
1456     }
1457 
1458 }