1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * @dev Allows the current owner to relinquish control of the contract.
36    * @notice Renouncing to ownership will leave the contract without an owner.
37    * It will not be possible to call the functions with the `onlyOwner`
38    * modifier anymore.
39    */
40   function renounceOwnership() public onlyOwner {
41     emit OwnershipRenounced(owner);
42     owner = address(0);
43   }
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param _newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address _newOwner) public onlyOwner {
50     _transferOwnership(_newOwner);
51   }
52 
53   /**
54    * @dev Transfers control of the contract to a newOwner.
55    * @param _newOwner The address to transfer ownership to.
56    */
57   function _transferOwnership(address _newOwner) internal {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that throw on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, throws on overflow.
73   */
74   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
75     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (a == 0) {
79       return 0;
80     }
81 
82     c = a * b;
83     assert(c / a == b);
84     return c;
85   }
86 
87   /**
88   * @dev Integer division of two numbers, truncating the quotient.
89   */
90   function div(uint256 a, uint256 b) internal pure returns (uint256) {
91     // assert(b > 0); // Solidity automatically throws when dividing by 0
92     // uint256 c = a / b;
93     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
94     return a / b;
95   }
96 
97   /**
98   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
99   */
100   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101     assert(b <= a);
102     return a - b;
103   }
104 
105   /**
106   * @dev Adds two numbers, throws on overflow.
107   */
108   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
109     c = a + b;
110     assert(c >= a);
111     return c;
112   }
113 }
114 
115 
116 /**
117  * @title ERC20Basic
118  * @dev Simpler version of ERC20 interface
119  * See https://github.com/ethereum/EIPs/issues/179
120  */
121 contract ERC20Basic {
122   function totalSupply() public view returns (uint256);
123   function balanceOf(address who) public view returns (uint256);
124   function transfer(address to, uint256 value) public returns (bool);
125   event Transfer(address indexed from, address indexed to, uint256 value);
126 }
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender)
135     public view returns (uint256);
136 
137   function transferFrom(address from, address to, uint256 value)
138     public returns (bool);
139 
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(
142     address indexed owner,
143     address indexed spender,
144     uint256 value
145   );
146 }
147 
148 
149 /**
150  * @title SafeERC20
151  * @dev Wrappers around ERC20 operations that throw on failure.
152  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
153  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
154  */
155 library SafeERC20 {
156   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
157     require(token.transfer(to, value));
158   }
159 
160   function safeTransferFrom(
161     ERC20 token,
162     address from,
163     address to,
164     uint256 value
165   )
166     internal
167   {
168     require(token.transferFrom(from, to, value));
169   }
170 
171   function safeApprove(ERC20 token, address spender, uint256 value) internal {
172     require(token.approve(spender, value));
173   }
174 }
175 
176 
177 /**
178  * @title Basic token
179  * @dev Basic version of StandardToken, with no allowances.
180  */
181 contract BasicToken is ERC20Basic {
182   using SafeMath for uint256;
183 
184   mapping(address => uint256) balances;
185 
186   uint256 totalSupply_;
187 
188   /**
189   * @dev Total number of tokens in existence
190   */
191   function totalSupply() public view returns (uint256) {
192     return totalSupply_;
193   }
194 
195   /**
196   * @dev Transfer token for a specified address
197   * @param _to The address to transfer to.
198   * @param _value The amount to be transferred.
199   */
200   function transfer(address _to, uint256 _value) public returns (bool) {
201     require(_to != address(0));
202     require(_value <= balances[msg.sender]);
203 
204     balances[msg.sender] = balances[msg.sender].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     emit Transfer(msg.sender, _to, _value);
207     return true;
208   }
209 
210   /**
211   * @dev Gets the balance of the specified address.
212   * @param _owner The address to query the the balance of.
213   * @return An uint256 representing the amount owned by the passed address.
214   */
215   function balanceOf(address _owner) public view returns (uint256) {
216     return balances[_owner];
217   }
218 }
219 
220 
221 /**
222  * @title Standard ERC20 token
223  *
224  * @dev Implementation of the basic standard token.
225  * https://github.com/ethereum/EIPs/issues/20
226  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
227  */
228 contract StandardToken is ERC20, BasicToken {
229 
230   mapping (address => mapping (address => uint256)) internal allowed;
231 
232 
233   /**
234    * @dev Transfer tokens from one address to another
235    * @param _from address The address which you want to send tokens from
236    * @param _to address The address which you want to transfer to
237    * @param _value uint256 the amount of tokens to be transferred
238    */
239   function transferFrom(
240     address _from,
241     address _to,
242     uint256 _value
243   )
244     public
245     returns (bool)
246   {
247     require(_to != address(0));
248     require(_value <= balances[_from]);
249     require(_value <= allowed[_from][msg.sender]);
250 
251     balances[_from] = balances[_from].sub(_value);
252     balances[_to] = balances[_to].add(_value);
253     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
254     emit Transfer(_from, _to, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
260    * Beware that changing an allowance with this method brings the risk that someone may use both the old
261    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
262    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
263    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
264    * @param _spender The address which will spend the funds.
265    * @param _value The amount of tokens to be spent.
266    */
267   function approve(address _spender, uint256 _value) public returns (bool) {
268     allowed[msg.sender][_spender] = _value;
269     emit Approval(msg.sender, _spender, _value);
270     return true;
271   }
272 
273   /**
274    * @dev Function to check the amount of tokens that an owner allowed to a spender.
275    * @param _owner address The address which owns the funds.
276    * @param _spender address The address which will spend the funds.
277    * @return A uint256 specifying the amount of tokens still available for the spender.
278    */
279   function allowance(
280     address _owner,
281     address _spender
282    )
283     public
284     view
285     returns (uint256)
286   {
287     return allowed[_owner][_spender];
288   }
289 
290   /**
291    * @dev Increase the amount of tokens that an owner allowed to a spender.
292    * approve should be called when allowed[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _addedValue The amount of tokens to increase the allowance by.
298    */
299   function increaseApproval(
300     address _spender,
301     uint256 _addedValue
302   )
303     public
304     returns (bool)
305   {
306     allowed[msg.sender][_spender] = (
307       allowed[msg.sender][_spender].add(_addedValue));
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312   /**
313    * @dev Decrease the amount of tokens that an owner allowed to a spender.
314    * approve should be called when allowed[_spender] == 0. To decrement
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _subtractedValue The amount of tokens to decrease the allowance by.
320    */
321   function decreaseApproval(
322     address _spender,
323     uint256 _subtractedValue
324   )
325     public
326     returns (bool)
327   {
328     uint256 oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue > oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 }
338 
339 
340 /**
341  * @title Mintable token
342  * @dev Simple ERC20 Token example, with mintable token creation
343  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
344  */
345 contract MintableToken is StandardToken, Ownable {
346   event Mint(address indexed to, uint256 amount);
347   event MintFinished();
348 
349   bool public mintingFinished = false;
350 
351 
352   modifier canMint() {
353     require(!mintingFinished);
354     _;
355   }
356 
357   modifier hasMintPermission() {
358     require(msg.sender == owner);
359     _;
360   }
361 
362   /**
363    * @dev Function to mint tokens
364    * @param _to The address that will receive the minted tokens.
365    * @param _amount The amount of tokens to mint.
366    * @return A boolean that indicates if the operation was successful.
367    */
368   function mint(
369     address _to,
370     uint256 _amount
371   )
372     hasMintPermission
373     canMint
374     public
375     returns (bool)
376   {
377     totalSupply_ = totalSupply_.add(_amount);
378     balances[_to] = balances[_to].add(_amount);
379     emit Mint(_to, _amount);
380     emit Transfer(address(0), _to, _amount);
381     return true;
382   }
383 
384   /**
385    * @dev Function to stop minting new tokens.
386    * @return True if the operation was successful.
387    */
388   function finishMinting() onlyOwner canMint public returns (bool) {
389     mintingFinished = true;
390     emit MintFinished();
391     return true;
392   }
393 }
394 
395 
396 /**
397  * @title Crowdsale
398  * @dev Crowdsale is a base contract for managing a token crowdsale,
399  * allowing investors to purchase tokens with ether. This contract implements
400  * such functionality in its most fundamental form and can be extended to provide additional
401  * functionality and/or custom behavior.
402  * The external interface represents the basic interface for purchasing tokens, and conform
403  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
404  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
405  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
406  * behavior.
407  */
408 contract Crowdsale {
409   using SafeMath for uint256;
410   using SafeERC20 for ERC20;
411 
412   // The token being sold
413   ERC20 public token;
414 
415   // Address where funds are collected
416   address public wallet;
417 
418   // How many token units a buyer gets per wei.
419   // The rate is the conversion between wei and the smallest and indivisible token unit.
420   // So, if you are using a rate of 1 with a DetailedERC20 token with 3 decimals called TOK
421   // 1 wei will give you 1 unit, or 0.001 TOK.
422   uint256 public rate;
423 
424   // Amount of wei raised
425   uint256 public weiRaised;
426 
427   /**
428    * Event for token purchase logging
429    * @param purchaser who paid for the tokens
430    * @param beneficiary who got the tokens
431    * @param value weis paid for purchase
432    * @param amount amount of tokens purchased
433    */
434   event TokenPurchase(
435     address indexed purchaser,
436     address indexed beneficiary,
437     uint256 value,
438     uint256 amount
439   );
440 
441   /**
442    * @param _wallet Address where collected funds will be forwarded to
443    */
444   constructor(address _wallet) public {
445     require(_wallet != address(0));
446     wallet = _wallet;
447   }
448 
449   // -----------------------------------------
450   // Crowdsale external interface
451   // -----------------------------------------
452 
453   /**
454    * @dev fallback function ***DO NOT OVERRIDE***
455    */
456   function () external payable {
457     buyTokens(msg.sender);
458   }
459 
460   /**
461    * @dev low level token purchase ***DO NOT OVERRIDE***
462    * @param _beneficiary Address performing the token purchase
463    */
464   function buyTokens(address _beneficiary) public payable {
465 
466     uint256 weiAmount = msg.value;
467     _preValidatePurchase(_beneficiary, weiAmount);
468 
469     // calculate token amount to be created
470     uint256 tokens = _getTokenAmount(weiAmount);
471 
472     // update state
473     weiRaised = weiRaised.add(weiAmount);
474 
475     _processPurchase(_beneficiary, tokens);
476     emit TokenPurchase(
477       msg.sender,
478       _beneficiary,
479       weiAmount,
480       tokens
481     );
482 
483     _updatePurchasingState(_beneficiary, weiAmount);
484 
485     _forwardFunds();
486     _postValidatePurchase(_beneficiary, weiAmount);
487   }
488 
489   // -----------------------------------------
490   // Internal interface (extensible)
491   // -----------------------------------------
492 
493   /**
494    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
495    * @param _beneficiary Address performing the token purchase
496    * @param _weiAmount Value in wei involved in the purchase
497    */
498   function _preValidatePurchase(
499     address _beneficiary,
500     uint256 _weiAmount
501   )
502     internal
503   {
504     require(_beneficiary != address(0));
505     require(_weiAmount != 0);
506   }
507 
508   /**
509    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
510    * @param _beneficiary Address performing the token purchase
511    * @param _weiAmount Value in wei involved in the purchase
512    */
513   function _postValidatePurchase(
514     address _beneficiary,
515     uint256 _weiAmount
516   )
517     internal
518   {
519     // optional override
520   }
521 
522   /**
523    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
524    * @param _beneficiary Address performing the token purchase
525    * @param _tokenAmount Number of tokens to be emitted
526    */
527   function _deliverTokens(
528     address _beneficiary,
529     uint256 _tokenAmount
530   )
531     internal
532   {
533     token.safeTransfer(_beneficiary, _tokenAmount);
534   }
535 
536   /**
537    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
538    * @param _beneficiary Address receiving the tokens
539    * @param _tokenAmount Number of tokens to be purchased
540    */
541   function _processPurchase(
542     address _beneficiary,
543     uint256 _tokenAmount
544   )
545     internal
546   {
547     _deliverTokens(_beneficiary, _tokenAmount);
548   }
549 
550   /**
551    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
552    * @param _beneficiary Address receiving the tokens
553    * @param _weiAmount Value in wei involved in the purchase
554    */
555   function _updatePurchasingState(
556     address _beneficiary,
557     uint256 _weiAmount
558   )
559     internal
560   {
561     // optional override
562   }
563 
564   /**
565    * @dev Override to extend the way in which ether is converted to tokens.
566    * @param _weiAmount Value in wei to be converted into tokens
567    * @return Number of tokens that can be purchased with the specified _weiAmount
568    */
569   function _getTokenAmount(uint256 _weiAmount)
570     internal view returns (uint256)
571   {
572     return _weiAmount.mul(rate);
573   }
574 
575   /**
576    * @dev Determines how ETH is stored/forwarded on purchases.
577    */
578   function _forwardFunds() internal {
579     wallet.transfer(msg.value);
580   }
581 }
582 
583 
584 /**
585  * @title TimedCrowdsale
586  * @dev Crowdsale accepting contributions only within a time frame.
587  */
588 contract TimedCrowdsale is Crowdsale {
589   using SafeMath for uint256;
590 
591   uint256 public openingTime;
592   uint256 public closingTime;
593 
594   /**
595    * @dev Reverts if not in crowdsale time range.
596    */
597   modifier onlyWhileOpen {
598     // solium-disable-next-line security/no-block-members
599     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
600     _;
601   }
602 
603   /**
604    * @dev Constructor, takes crowdsale opening and closing times.
605    * @param _openingTime Crowdsale opening time
606    * @param _closingTime Crowdsale closing time
607    */
608   constructor(uint256 _openingTime, uint256 _closingTime) public {
609     // solium-disable-next-line security/no-block-members
610     require(_openingTime >= block.timestamp);
611     require(_closingTime >= _openingTime);
612 
613     openingTime = _openingTime;
614     closingTime = _closingTime;
615   }
616 
617   /**
618    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
619    * @return Whether crowdsale period has elapsed
620    */
621   function hasClosed() public view returns (bool) {
622     // solium-disable-next-line security/no-block-members
623     return block.timestamp > closingTime;
624   }
625 
626   /**
627    * @dev Extend parent behavior requiring to be within contributing period
628    * @param _beneficiary Token purchaser
629    * @param _weiAmount Amount of wei contributed
630    */
631   function _preValidatePurchase(
632     address _beneficiary,
633     uint256 _weiAmount
634   )
635     internal
636     onlyWhileOpen
637   {
638     super._preValidatePurchase(_beneficiary, _weiAmount);
639   }
640 }
641 
642 
643 /**
644  * @title MintedCrowdsale
645  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
646  * Token ownership should be transferred to MintedCrowdsale for minting.
647  */
648 contract MintedCrowdsale is Crowdsale {
649 
650   /**
651    * @dev Overrides delivery by minting tokens upon purchase.
652    * @param _beneficiary Token purchaser
653    * @param _tokenAmount Number of tokens to be minted
654    */
655   function _deliverTokens(
656     address _beneficiary,
657     uint256 _tokenAmount
658   )
659     internal
660   {
661     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
662   }
663 }
664 
665 
666 
667 /**
668  * @title PostDeliveryCrowdsale
669  * @dev Crowdsale that locks tokens from withdrawal until it ends.
670  */
671 contract PostDeliveryCrowdsale is TimedCrowdsale {
672   using SafeMath for uint256;
673 
674   mapping(address => uint256) public balances;
675 
676   /**
677    * @dev Withdraw tokens only after crowdsale ends.
678    */
679   function withdrawTokens() public {
680     require(hasClosed());
681     uint256 amount = balances[msg.sender];
682     require(amount > 0);
683     balances[msg.sender] = 0;
684     _deliverTokens(msg.sender, amount);
685   }
686 
687   /**
688    * @dev Overrides parent by storing balances instead of issuing tokens right away.
689    * @param _beneficiary Token purchaser
690    * @param _tokenAmount Amount of tokens purchased
691    */
692   function _processPurchase(
693     address _beneficiary,
694     uint256 _tokenAmount
695   )
696     internal
697   {
698     balances[_beneficiary] = balances[_beneficiary].add(_tokenAmount);
699   }
700 }
701 
702 
703 /**
704  * @title FinalizableCrowdsale
705  * @dev Extension of Crowdsale where an owner can do extra work
706  * after finishing.
707  */
708 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
709   using SafeMath for uint256;
710 
711   bool public isFinalized = false;
712 
713   event Finalized();
714 
715   /**
716    * @dev Must be called after crowdsale ends, to do some extra finalization
717    * work. Calls the contract's finalization function.
718    */
719   function finalize() onlyOwner public {
720     require(!isFinalized);
721     require(token != address(0x0));
722     require(hasClosed());
723 
724     finalization();
725     emit Finalized();
726 
727     isFinalized = true;
728   }
729 
730   /**
731    * @dev Can be overridden to add finalization logic. The overriding function
732    * should call super.finalization() to ensure the chain of finalization is
733    * executed entirely.
734    */
735   function finalization() internal {
736   }
737 }
738 
739 
740 /**
741  * @title CappedCrowdsale
742  * @dev Crowdsale with a limit on number of tokens for sale.
743  */
744 contract CappedTokenCrowdsale is Crowdsale
745 {
746   using SafeMath for uint256;
747 
748   uint256 public tokenCap;
749   uint256 public tokensSold;
750 
751   /**
752    * @dev Constructor, takes maximum amount of tokens to be sold in the crowdsale.
753    * @param _tokenCap Max amount of tokens to be sold
754    */
755   constructor(uint256 _tokenCap) public {
756     require(_tokenCap > 0);
757     tokenCap = _tokenCap;
758   }
759 
760   /**
761    * @dev Checks whether the cap has been reached.
762    * @return Whether the cap was reached
763    */
764   function tokenCapReached() public view returns (bool) {
765       return tokensSold >= tokenCap;
766   }
767 
768   /**
769    * @dev Extend parent behavior requiring purchase to respect the token cap.
770    * @param _beneficiary Token purchaser
771    * @param _weiAmount Amount of wei contributed
772    */
773   function _preValidatePurchase(
774     address _beneficiary,
775     uint256 _weiAmount
776   )
777     internal
778   {
779       super._preValidatePurchase(_beneficiary, _weiAmount);
780       require(!tokenCapReached());
781   }
782 
783   /**
784    * @dev Overrides parent to increase the number of tokensSold.
785    * @param _beneficiary Address receiving the tokens
786    * @param _tokenAmount Number of tokens to be purchased
787    */
788   function _processPurchase(
789     address _beneficiary,
790     uint256 _tokenAmount
791   )
792     internal
793   {
794     tokensSold = tokensSold.add(_tokenAmount);
795     super._processPurchase(_beneficiary, _tokenAmount);
796   }
797 }
798 
799 
800 /**
801  * @title IncreasingTokenPriceCrowdsale
802  * @dev Extension of Crowdsale contract that increases the price of one token linearly in time.
803  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
804  * the amount of wei per one token. Thus, the initial rate must be less than the final rate.
805  */
806 contract IncreasingTokenPriceCrowdsale is TimedCrowdsale
807 {
808   using SafeMath for uint256;
809 
810   uint256 public initialRate;
811   uint256 public finalRate;
812 
813   /**
814    * @dev Constructor, takes initial and final rates of wei contributed per token.
815    * @param _initialRate Number of wei it costs for one token at the start of the crowdsale
816    * @param _finalRate Number of wei it costs for one token at the end of the crowdsale
817    */
818   constructor(uint256 _initialRate, uint256 _finalRate) public {
819     require(_finalRate >= _initialRate);
820     require(_initialRate > 0);
821     initialRate = _initialRate;
822     finalRate = _finalRate;
823   }
824 
825   /**
826    * @dev Returns the rate of wei per token at the present time.
827    * @return The number of wei it costs for one token at a given time
828    */
829   function getCurrentRate() public view returns (uint256) {
830     // solium-disable-next-line security/no-block-members
831     uint256 elapsedTime = block.timestamp.sub(openingTime);
832     uint256 timeRange = closingTime.sub(openingTime);
833     uint256 rateRange = finalRate.sub(initialRate);
834     return initialRate.add(elapsedTime.mul(rateRange).div(timeRange));
835   }
836 
837   /**
838    * @dev Overrides parent method taking into account variable rate.
839    * @param _weiAmount The value in wei to be converted into tokens
840    * @return The number of tokens _weiAmount wei will buy at present time
841    */
842   function _getTokenAmount(uint256 _weiAmount)
843     internal view returns (uint256)
844   {
845     uint256 currentRate = getCurrentRate();
846     return _weiAmount.div(currentRate);
847   }
848 }
849 
850 
851 /**
852  * @title FOIChainCrowdsale
853  * @dev The FOI crowdsale contract. It inherits from several other crowdsale contracts to provide the required functionality.
854  * The crowdsale runs from 12:00 am GMT, August 13th, to 11:59 pm GMT, October 12th.
855  * The price increases linearly from 0.05 ether per token, to 0.25 ether per token.
856  * A maximum of 200,000 tokens can be purchased.
857  * 50,000 tokens are reserved for the FOIChain organization to fund the on-going development of the web app front end.
858  * Any unsold tokens will go to the FOIChain organization.
859  */
860 contract FOIChainCrowdsale is TimedCrowdsale, MintedCrowdsale, IncreasingTokenPriceCrowdsale, PostDeliveryCrowdsale, CappedTokenCrowdsale, FinalizableCrowdsale {
861   using SafeMath for uint256;
862 
863   address constant internal walletAddress   = 0x870c6bd22325673D28d9a5da465dFef3073AB3E7;
864   uint256 constant internal startOfAugust13 = 1534118400;
865   uint256 constant internal endOfOctober12  = 1539388740;
866 
867   /**
868    * @dev Constructor, creates crowdsale contract with wallet to send funds to,
869    * an opening and closing time, an initialRate and finalRate, and a token cap.
870    */
871   constructor()
872     public
873     Crowdsale(walletAddress)
874     TimedCrowdsale(startOfAugust13, endOfOctober12)
875     IncreasingTokenPriceCrowdsale(0.05 ether, 0.25 ether)
876     PostDeliveryCrowdsale()
877     CappedTokenCrowdsale(200000)
878     FinalizableCrowdsale() {
879 
880   }
881 
882   /**
883    * @dev Allows the owner to update the address of the to-be-written FOI token contract.
884    * When the pre-sale is over, this contract will mint the tokens for people who purchased
885    * in the pre-sale.
886    * Make sure that this contract is the owner of the token contract.
887    * @param _token The address of the FOI token contract
888    */
889   function updateTokenAddress(MintableToken _token) onlyOwner public {
890     require(!isFinalized);
891     require(_token.owner() == address(this));
892     token = _token;
893   }
894 
895   /**
896   * @dev Validate that enough ether was sent to buy at least one token.
897   * @param _beneficiary Token purchaser
898   * @param _weiAmount Amount of wei sent to the contract
899   */
900   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
901     super._preValidatePurchase(_beneficiary, _weiAmount);
902 
903     uint256 currentRate = getCurrentRate();
904     uint256 tokenAmount = _weiAmount.div(currentRate);
905     require(tokenAmount > 0);
906   }
907 
908   /**
909   * @dev Public function for getting the number of tokens _weiAmount contributed would purchase.
910   * @param _weiAmount Amount of wei sent to the contract
911   * @return Number of tokens _weiAmount contributed would purchase
912   */
913   function getTokenAmount(uint256 _weiAmount) public view returns(uint256) {
914     return _getTokenAmount(_weiAmount);
915   }
916 
917   /**
918   * @dev Overrides parent method taking into account the token cap.
919   * @param _weiAmount Amount of wei sent to the contract
920   * @return Number of tokens _weiAmount contributed would purchase
921   */
922   function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256) {
923     uint256 tokenAmount = super._getTokenAmount(_weiAmount);
924 
925     uint256 unsold = unsoldTokens();
926 
927     if(tokenAmount > unsold)
928     {
929         tokenAmount = unsold;
930     }
931 
932     return tokenAmount;
933   }
934 
935   /**
936   * @dev Calculates how many tokens have not been sold in the pre-sale
937   * @return Number of tokens that have not been sold in the pre-sale.
938   */
939   function unsoldTokens() public view returns (uint256) {
940     return tokenCap.sub(tokensSold);
941   }
942 
943   /**
944   * @dev Gets the balance of the specified address.
945   * @param _user The address to query the the balance of.
946   * @return An uint256 representing the amount owned by the passed address.
947   */
948   function getBalance(address _user) public view returns(uint256) {
949     return balances[_user];
950   }
951 
952   event EtherRefund(
953     address indexed purchaser,
954     uint256 refund
955   );
956 
957   /**
958    * @dev Overrides parent to calculate how much extra wei was sent, and issues a refund.
959    * @param _beneficiary Token purchaser
960    * @param _tokenAmount Amount of tokens purchased
961    */
962   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
963     super._processPurchase(_beneficiary, _tokenAmount);
964 
965     uint256 currentRate = getCurrentRate();
966 
967     uint256 weiSpent = currentRate.mul(_tokenAmount);
968 
969     uint256 weiAmount = msg.value;
970 
971     uint256 refund = weiAmount.sub(weiSpent);
972 
973     if(refund > 0)
974     {
975         weiRaised = weiRaised.sub(refund);
976         msg.sender.transfer(refund);
977 
978         emit EtherRefund(
979             msg.sender,
980             refund
981         );
982     }
983   }
984 
985   /**
986    * @dev Overrides parent to forward the complete balance to the wallet.
987    * This contract should never contain any ether.
988    */
989   function _forwardFunds() internal {
990     wallet.transfer(address(this).balance);
991   }
992 
993   /**
994    * @dev Overrides parent to only allow withdraws after the pre-sale has been finalized.
995    */
996   function withdrawTokens() public  {
997     require(isFinalized);
998     super.withdrawTokens();
999   }
1000 
1001   /**
1002    * @dev Overrides parent to perform custom finalization logic.
1003    * After the pre-sale is over, 50,000 tokens will be allocated to the FOI organization
1004    * to support the on-going development of the FOI smart contract and web app front end.
1005    * Note that any unsold tokens will also be allocated to the FOI organization.
1006    */
1007   function finalization() internal {
1008     uint256 reserve = 50000;
1009 
1010     uint256 remaining = tokenCap.sub(tokensSold).add(reserve);
1011 
1012     balances[wallet] = balances[wallet].add(remaining);
1013 
1014     super.finalization();
1015   }
1016 }