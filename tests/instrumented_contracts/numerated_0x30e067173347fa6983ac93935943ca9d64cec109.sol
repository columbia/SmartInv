1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that revert on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, reverts on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (a == 0) {
19       return 0;
20     }
21 
22     uint256 c = a * b;
23     require(c / a == b);
24 
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     require(b > 0); // Solidity only automatically asserts when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36     return c;
37   }
38 
39   /**
40   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41   */
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     require(b <= a);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50   * @dev Adds two numbers, reverts on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     require(c >= a);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
61   * reverts when dividing by zero.
62   */
63   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64     require(b != 0);
65     return a % b;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
70 
71 /**
72  * @title ERC20 interface
73  * @dev see https://github.com/ethereum/EIPs/issues/20
74  */
75 interface IERC20 {
76   function totalSupply() external view returns (uint256);
77 
78   function balanceOf(address who) external view returns (uint256);
79 
80   function allowance(address owner, address spender)
81     external view returns (uint256);
82 
83   function transfer(address to, uint256 value) external returns (bool);
84 
85   function approve(address spender, uint256 value)
86     external returns (bool);
87 
88   function transferFrom(address from, address to, uint256 value)
89     external returns (bool);
90 
91   event Transfer(
92     address indexed from,
93     address indexed to,
94     uint256 value
95   );
96 
97   event Approval(
98     address indexed owner,
99     address indexed spender,
100     uint256 value
101   );
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
105 
106 /**
107  * @title SafeERC20
108  * @dev Wrappers around ERC20 operations that throw on failure.
109  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
110  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
111  */
112 library SafeERC20 {
113 
114   using SafeMath for uint256;
115 
116   function safeTransfer(
117     IERC20 token,
118     address to,
119     uint256 value
120   )
121     internal
122   {
123     require(token.transfer(to, value));
124   }
125 
126   function safeTransferFrom(
127     IERC20 token,
128     address from,
129     address to,
130     uint256 value
131   )
132     internal
133   {
134     require(token.transferFrom(from, to, value));
135   }
136 
137   function safeApprove(
138     IERC20 token,
139     address spender,
140     uint256 value
141   )
142     internal
143   {
144     // safeApprove should only be called when setting an initial allowance, 
145     // or when resetting it to zero. To increase and decrease it, use 
146     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
147     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
148     require(token.approve(spender, value));
149   }
150 
151   function safeIncreaseAllowance(
152     IERC20 token,
153     address spender,
154     uint256 value
155   )
156     internal
157   {
158     uint256 newAllowance = token.allowance(address(this), spender).add(value);
159     require(token.approve(spender, newAllowance));
160   }
161 
162   function safeDecreaseAllowance(
163     IERC20 token,
164     address spender,
165     uint256 value
166   )
167     internal
168   {
169     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
170     require(token.approve(spender, newAllowance));
171   }
172 }
173 
174 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
175 
176 /**
177  * @title Helps contracts guard against reentrancy attacks.
178  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
179  * @dev If you mark a function `nonReentrant`, you should also
180  * mark it `external`.
181  */
182 contract ReentrancyGuard {
183 
184   /// @dev counter to allow mutex lock with only one SSTORE operation
185   uint256 private _guardCounter;
186 
187   constructor() internal {
188     // The counter starts at one to prevent changing it from zero to a non-zero
189     // value, which is a more expensive operation.
190     _guardCounter = 1;
191   }
192 
193   /**
194    * @dev Prevents a contract from calling itself, directly or indirectly.
195    * Calling a `nonReentrant` function from another `nonReentrant`
196    * function is not supported. It is possible to prevent this from happening
197    * by making the `nonReentrant` function external, and make it call a
198    * `private` function that does the actual work.
199    */
200   modifier nonReentrant() {
201     _guardCounter += 1;
202     uint256 localCounter = _guardCounter;
203     _;
204     require(localCounter == _guardCounter);
205   }
206 
207 }
208 
209 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
210 
211 /**
212  * @title Crowdsale
213  * @dev Crowdsale is a base contract for managing a token crowdsale,
214  * allowing investors to purchase tokens with ether. This contract implements
215  * such functionality in its most fundamental form and can be extended to provide additional
216  * functionality and/or custom behavior.
217  * The external interface represents the basic interface for purchasing tokens, and conform
218  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
219  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
220  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
221  * behavior.
222  */
223 contract Crowdsale is ReentrancyGuard {
224   using SafeMath for uint256;
225   using SafeERC20 for IERC20;
226 
227   // The token being sold
228   IERC20 private _token;
229 
230   // Address where funds are collected
231   address private _wallet;
232 
233   // How many token units a buyer gets per wei.
234   // The rate is the conversion between wei and the smallest and indivisible token unit.
235   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
236   // 1 wei will give you 1 unit, or 0.001 TOK.
237   uint256 private _rate;
238 
239   // Amount of wei raised
240   uint256 private _weiRaised;
241 
242   /**
243    * Event for token purchase logging
244    * @param purchaser who paid for the tokens
245    * @param beneficiary who got the tokens
246    * @param value weis paid for purchase
247    * @param amount amount of tokens purchased
248    */
249   event TokensPurchased(
250     address indexed purchaser,
251     address indexed beneficiary,
252     uint256 value,
253     uint256 amount
254   );
255 
256   /**
257    * @param rate Number of token units a buyer gets per wei
258    * @dev The rate is the conversion between wei and the smallest and indivisible
259    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
260    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
261    * @param wallet Address where collected funds will be forwarded to
262    * @param token Address of the token being sold
263    */
264   constructor(uint256 rate, address wallet, IERC20 token) internal {
265     require(rate > 0);
266     require(wallet != address(0));
267     require(token != address(0));
268 
269     _rate = rate;
270     _wallet = wallet;
271     _token = token;
272   }
273 
274   // -----------------------------------------
275   // Crowdsale external interface
276   // -----------------------------------------
277 
278   /**
279    * @dev fallback function ***DO NOT OVERRIDE***
280    * Note that other contracts will transfer fund with a base gas stipend
281    * of 2300, which is not enough to call buyTokens. Consider calling
282    * buyTokens directly when purchasing tokens from a contract.
283    */
284   function () external payable {
285     buyTokens(msg.sender);
286   }
287 
288   /**
289    * @return the token being sold.
290    */
291   function token() public view returns(IERC20) {
292     return _token;
293   }
294 
295   /**
296    * @return the address where funds are collected.
297    */
298   function wallet() public view returns(address) {
299     return _wallet;
300   }
301 
302   /**
303    * @return the number of token units a buyer gets per wei.
304    */
305   function rate() public view returns(uint256) {
306     return _rate;
307   }
308 
309   /**
310    * @return the amount of wei raised.
311    */
312   function weiRaised() public view returns (uint256) {
313     return _weiRaised;
314   }
315 
316   /**
317    * @dev low level token purchase ***DO NOT OVERRIDE***
318    * This function has a non-reentrancy guard, so it shouldn't be called by
319    * another `nonReentrant` function.
320    * @param beneficiary Recipient of the token purchase
321    */
322   function buyTokens(address beneficiary) public nonReentrant payable {
323 
324     uint256 weiAmount = msg.value;
325     _preValidatePurchase(beneficiary, weiAmount);
326 
327     // calculate token amount to be created
328     uint256 tokens = _getTokenAmount(weiAmount);
329 
330     // update state
331     _weiRaised = _weiRaised.add(weiAmount);
332 
333     _processPurchase(beneficiary, tokens);
334     emit TokensPurchased(
335       msg.sender,
336       beneficiary,
337       weiAmount,
338       tokens
339     );
340 
341     _updatePurchasingState(beneficiary, weiAmount);
342 
343     _forwardFunds();
344     _postValidatePurchase(beneficiary, weiAmount);
345   }
346 
347   // -----------------------------------------
348   // Internal interface (extensible)
349   // -----------------------------------------
350 
351   /**
352    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
353    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
354    *   super._preValidatePurchase(beneficiary, weiAmount);
355    *   require(weiRaised().add(weiAmount) <= cap);
356    * @param beneficiary Address performing the token purchase
357    * @param weiAmount Value in wei involved in the purchase
358    */
359   function _preValidatePurchase(
360     address beneficiary,
361     uint256 weiAmount
362   )
363     internal
364     view
365   {
366     require(beneficiary != address(0));
367     require(weiAmount != 0);
368   }
369 
370   /**
371    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
372    * @param beneficiary Address performing the token purchase
373    * @param weiAmount Value in wei involved in the purchase
374    */
375   function _postValidatePurchase(
376     address beneficiary,
377     uint256 weiAmount
378   )
379     internal
380     view
381   {
382     // optional override
383   }
384 
385   /**
386    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
387    * @param beneficiary Address performing the token purchase
388    * @param tokenAmount Number of tokens to be emitted
389    */
390   function _deliverTokens(
391     address beneficiary,
392     uint256 tokenAmount
393   )
394     internal
395   {
396     _token.safeTransfer(beneficiary, tokenAmount);
397   }
398 
399   /**
400    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
401    * @param beneficiary Address receiving the tokens
402    * @param tokenAmount Number of tokens to be purchased
403    */
404   function _processPurchase(
405     address beneficiary,
406     uint256 tokenAmount
407   )
408     internal
409   {
410     _deliverTokens(beneficiary, tokenAmount);
411   }
412 
413   /**
414    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
415    * @param beneficiary Address receiving the tokens
416    * @param weiAmount Value in wei involved in the purchase
417    */
418   function _updatePurchasingState(
419     address beneficiary,
420     uint256 weiAmount
421   )
422     internal
423   {
424     // optional override
425   }
426 
427   /**
428    * @dev Override to extend the way in which ether is converted to tokens.
429    * @param weiAmount Value in wei to be converted into tokens
430    * @return Number of tokens that can be purchased with the specified _weiAmount
431    */
432   function _getTokenAmount(uint256 weiAmount)
433     internal view returns (uint256)
434   {
435     return weiAmount.mul(_rate);
436   }
437 
438   /**
439    * @dev Determines how ETH is stored/forwarded on purchases.
440    */
441   function _forwardFunds() internal {
442     _wallet.transfer(msg.value);
443   }
444 }
445 
446 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
447 
448 /**
449  * @title TimedCrowdsale
450  * @dev Crowdsale accepting contributions only within a time frame.
451  */
452 contract TimedCrowdsale is Crowdsale {
453   using SafeMath for uint256;
454 
455   uint256 private _openingTime;
456   uint256 private _closingTime;
457 
458   /**
459    * @dev Reverts if not in crowdsale time range.
460    */
461   modifier onlyWhileOpen {
462     require(isOpen());
463     _;
464   }
465 
466   /**
467    * @dev Constructor, takes crowdsale opening and closing times.
468    * @param openingTime Crowdsale opening time
469    * @param closingTime Crowdsale closing time
470    */
471   constructor(uint256 openingTime, uint256 closingTime) internal {
472     // solium-disable-next-line security/no-block-members
473     require(openingTime >= block.timestamp);
474     require(closingTime > openingTime);
475 
476     _openingTime = openingTime;
477     _closingTime = closingTime;
478   }
479 
480   /**
481    * @return the crowdsale opening time.
482    */
483   function openingTime() public view returns(uint256) {
484     return _openingTime;
485   }
486 
487   /**
488    * @return the crowdsale closing time.
489    */
490   function closingTime() public view returns(uint256) {
491     return _closingTime;
492   }
493 
494   /**
495    * @return true if the crowdsale is open, false otherwise.
496    */
497   function isOpen() public view returns (bool) {
498     // solium-disable-next-line security/no-block-members
499     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
500   }
501 
502   /**
503    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
504    * @return Whether crowdsale period has elapsed
505    */
506   function hasClosed() public view returns (bool) {
507     // solium-disable-next-line security/no-block-members
508     return block.timestamp > _closingTime;
509   }
510 
511   /**
512    * @dev Extend parent behavior requiring to be within contributing period
513    * @param beneficiary Token purchaser
514    * @param weiAmount Amount of wei contributed
515    */
516   function _preValidatePurchase(
517     address beneficiary,
518     uint256 weiAmount
519   )
520     internal
521     onlyWhileOpen
522     view
523   {
524     super._preValidatePurchase(beneficiary, weiAmount);
525   }
526 
527 }
528 
529 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
530 
531 /**
532  * @title PostDeliveryCrowdsale
533  * @dev Crowdsale that locks tokens from withdrawal until it ends.
534  */
535 contract PostDeliveryCrowdsale is TimedCrowdsale {
536   using SafeMath for uint256;
537 
538   mapping(address => uint256) private _balances;
539 
540   constructor() internal {}
541 
542   /**
543    * @dev Withdraw tokens only after crowdsale ends.
544    * @param beneficiary Whose tokens will be withdrawn.
545    */
546   function withdrawTokens(address beneficiary) public {
547     require(hasClosed());
548     uint256 amount = _balances[beneficiary];
549     require(amount > 0);
550     _balances[beneficiary] = 0;
551     _deliverTokens(beneficiary, amount);
552   }
553 
554   /**
555    * @return the balance of an account.
556    */
557   function balanceOf(address account) public view returns(uint256) {
558     return _balances[account];
559   }
560 
561   /**
562    * @dev Overrides parent by storing balances instead of issuing tokens right away.
563    * @param beneficiary Token purchaser
564    * @param tokenAmount Amount of tokens purchased
565    */
566   function _processPurchase(
567     address beneficiary,
568     uint256 tokenAmount
569   )
570     internal
571   {
572     _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
573   }
574 
575 }
576 
577 // File: openzeppelin-solidity/contracts/crowdsale/price/IncreasingPriceCrowdsale.sol
578 
579 /**
580  * @title IncreasingPriceCrowdsale
581  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
582  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
583  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
584  */
585 contract IncreasingPriceCrowdsale is TimedCrowdsale {
586   using SafeMath for uint256;
587 
588   uint256 private _initialRate;
589   uint256 private _finalRate;
590 
591   /**
592    * @dev Constructor, takes initial and final rates of tokens received per wei contributed.
593    * @param initialRate Number of tokens a buyer gets per wei at the start of the crowdsale
594    * @param finalRate Number of tokens a buyer gets per wei at the end of the crowdsale
595    */
596   constructor(uint256 initialRate, uint256 finalRate) internal {
597     require(finalRate > 0);
598     require(initialRate > finalRate);
599     _initialRate = initialRate;
600     _finalRate = finalRate;
601   }
602 
603   /**
604    * The base rate function is overridden to revert, since this crowdsale doens't use it, and
605    * all calls to it are a mistake.
606    */
607   function rate() public view returns(uint256) {
608     revert();
609   }
610 
611   /**
612    * @return the initial rate of the crowdsale.
613    */
614   function initialRate() public view returns(uint256) {
615     return _initialRate;
616   }
617 
618   /**
619    * @return the final rate of the crowdsale.
620    */
621   function finalRate() public view returns (uint256) {
622     return _finalRate;
623   }
624 
625   /**
626    * @dev Returns the rate of tokens per wei at the present time.
627    * Note that, as price _increases_ with time, the rate _decreases_.
628    * @return The number of tokens a buyer gets per wei at a given time
629    */
630   function getCurrentRate() public view returns (uint256) {
631     if (!isOpen()) {
632       return 0;
633     }
634 
635     // solium-disable-next-line security/no-block-members
636     uint256 elapsedTime = block.timestamp.sub(openingTime());
637     uint256 timeRange = closingTime().sub(openingTime());
638     uint256 rateRange = _initialRate.sub(_finalRate);
639     return _initialRate.sub(elapsedTime.mul(rateRange).div(timeRange));
640   }
641 
642   /**
643    * @dev Overrides parent method taking into account variable rate.
644    * @param weiAmount The value in wei to be converted into tokens
645    * @return The number of tokens _weiAmount wei will buy at present time
646    */
647   function _getTokenAmount(uint256 weiAmount)
648     internal view returns (uint256)
649   {
650     uint256 currentRate = getCurrentRate();
651     return currentRate.mul(weiAmount);
652   }
653 
654 }
655 
656 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
657 
658 /**
659  * @title Ownable
660  * @dev The Ownable contract has an owner address, and provides basic authorization control
661  * functions, this simplifies the implementation of "user permissions".
662  */
663 contract Ownable {
664   address private _owner;
665 
666   event OwnershipTransferred(
667     address indexed previousOwner,
668     address indexed newOwner
669   );
670 
671   /**
672    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
673    * account.
674    */
675   constructor() internal {
676     _owner = msg.sender;
677     emit OwnershipTransferred(address(0), _owner);
678   }
679 
680   /**
681    * @return the address of the owner.
682    */
683   function owner() public view returns(address) {
684     return _owner;
685   }
686 
687   /**
688    * @dev Throws if called by any account other than the owner.
689    */
690   modifier onlyOwner() {
691     require(isOwner());
692     _;
693   }
694 
695   /**
696    * @return true if `msg.sender` is the owner of the contract.
697    */
698   function isOwner() public view returns(bool) {
699     return msg.sender == _owner;
700   }
701 
702   /**
703    * @dev Allows the current owner to relinquish control of the contract.
704    * @notice Renouncing to ownership will leave the contract without an owner.
705    * It will not be possible to call the functions with the `onlyOwner`
706    * modifier anymore.
707    */
708   function renounceOwnership() public onlyOwner {
709     emit OwnershipTransferred(_owner, address(0));
710     _owner = address(0);
711   }
712 
713   /**
714    * @dev Allows the current owner to transfer control of the contract to a newOwner.
715    * @param newOwner The address to transfer ownership to.
716    */
717   function transferOwnership(address newOwner) public onlyOwner {
718     _transferOwnership(newOwner);
719   }
720 
721   /**
722    * @dev Transfers control of the contract to a newOwner.
723    * @param newOwner The address to transfer ownership to.
724    */
725   function _transferOwnership(address newOwner) internal {
726     require(newOwner != address(0));
727     emit OwnershipTransferred(_owner, newOwner);
728     _owner = newOwner;
729   }
730 }
731 
732 // File: contracts/ICO1.sol
733 
734 /**
735  * @title IncreasingPriceCrowdsale
736  * @dev Extension of Crowdsale contract that increases the price of tokens linearly in time.
737  * Note that what should be provided to the constructor is the initial and final _rates_, that is,
738  * the amount of tokens per wei contributed. Thus, the initial rate must be greater than the final rate.
739  */
740 contract ICO1 is IncreasingPriceCrowdsale, PostDeliveryCrowdsale, Ownable  {
741   IERC20 private _token;
742   uint256 private _weiRaised;
743   uint256 private _tokenSold;
744 
745   constructor(address wallet, IERC20 token, uint8 daysAfter, uint256 openingRate, uint256 closingRate)
746   Crowdsale(openingRate, wallet, token)
747   TimedCrowdsale(now, now + daysAfter * 1 days)
748   IncreasingPriceCrowdsale(openingRate, closingRate)
749   public {
750     _token = IERC20(token);
751   }
752 
753   function buyTokens(address beneficiary) public nonReentrant payable {
754     uint256 weiAmount = msg.value;
755     uint256 maxWeiAmount = _getMaxWeiAmount();
756     require(maxWeiAmount > 0);
757     if (weiAmount >= maxWeiAmount) {
758       weiAmount = maxWeiAmount;
759     }
760     _preValidatePurchase(beneficiary, weiAmount);
761 
762     // calculate token amount to be created
763     uint256 tokens = _getTokenAmount(weiAmount);
764 
765     // update state
766     _weiRaised = _weiRaised.add(weiAmount);
767     _tokenSold = _tokenSold.add(tokens);
768 
769     _processPurchase(beneficiary, tokens);
770     emit TokensPurchased(
771       msg.sender,
772       beneficiary,
773       weiAmount,
774       tokens
775     );
776 
777     _updatePurchasingState(beneficiary, weiAmount);
778 
779     _forwardFunds();
780     _postValidatePurchase(beneficiary, weiAmount);
781   }
782 
783   function _getTokenAmount(uint256 weiAmount)
784     internal view returns (uint256)
785   {
786     uint256 currentRate = getCurrentRate();
787     return currentRate.mul(weiAmount).div(10**13);
788   }
789 
790   function _getMaxWeiAmount()
791     internal view returns (uint256)
792   {
793     uint256 currentRate = getCurrentRate();
794     uint256 icoBalance = _token.balanceOf(address(this));
795     uint256 availableBalance = icoBalance - _tokenSold;
796     return availableBalance.mul(10**13).div(currentRate);
797   }
798 
799   function recoverToken(address _tokenAddress) public onlyOwner {
800     IERC20 token = IERC20(_tokenAddress);
801     uint balance = token.balanceOf(this);
802     token.transfer(msg.sender, balance);
803   }
804 
805   function tokenSold()
806     public view returns (uint256)
807   {
808     return _tokenSold;
809   }
810 }