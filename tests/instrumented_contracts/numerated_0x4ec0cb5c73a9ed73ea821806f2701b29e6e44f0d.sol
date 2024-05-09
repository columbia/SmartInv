1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     _transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     require(value <= _allowed[from][msg.sender]);
197 
198     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199     _transfer(from, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseAllowance(
213     address spender,
214     uint256 addedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].add(addedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246       _allowed[msg.sender][spender].sub(subtractedValue));
247     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(value <= _balances[from]);
259     require(to != address(0));
260 
261     _balances[from] = _balances[from].sub(value);
262     _balances[to] = _balances[to].add(value);
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != 0);
275     _totalSupply = _totalSupply.add(value);
276     _balances[account] = _balances[account].add(value);
277     emit Transfer(address(0), account, value);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account.
283    * @param account The account whose tokens will be burnt.
284    * @param value The amount that will be burnt.
285    */
286   function _burn(address account, uint256 value) internal {
287     require(account != 0);
288     require(value <= _balances[account]);
289 
290     _totalSupply = _totalSupply.sub(value);
291     _balances[account] = _balances[account].sub(value);
292     emit Transfer(account, address(0), value);
293   }
294 
295   /**
296    * @dev Internal function that burns an amount of the token of a given
297    * account, deducting from the sender's allowance for said account. Uses the
298    * internal burn function.
299    * @param account The account whose tokens will be burnt.
300    * @param value The amount that will be burnt.
301    */
302   function _burnFrom(address account, uint256 value) internal {
303     require(value <= _allowed[account][msg.sender]);
304 
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
314 
315 /**
316  * @title SafeERC20
317  * @dev Wrappers around ERC20 operations that throw on failure.
318  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
319  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
320  */
321 library SafeERC20 {
322 
323   using SafeMath for uint256;
324 
325   function safeTransfer(
326     IERC20 token,
327     address to,
328     uint256 value
329   )
330     internal
331   {
332     require(token.transfer(to, value));
333   }
334 
335   function safeTransferFrom(
336     IERC20 token,
337     address from,
338     address to,
339     uint256 value
340   )
341     internal
342   {
343     require(token.transferFrom(from, to, value));
344   }
345 
346   function safeApprove(
347     IERC20 token,
348     address spender,
349     uint256 value
350   )
351     internal
352   {
353     // safeApprove should only be called when setting an initial allowance, 
354     // or when resetting it to zero. To increase and decrease it, use 
355     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356     require((value == 0) || (token.allowance(address(this), spender) == 0));
357     require(token.approve(spender, value));
358   }
359 
360   function safeIncreaseAllowance(
361     IERC20 token,
362     address spender,
363     uint256 value
364   )
365     internal
366   {
367     uint256 newAllowance = token.allowance(address(this), spender).add(value);
368     require(token.approve(spender, newAllowance));
369   }
370 
371   function safeDecreaseAllowance(
372     IERC20 token,
373     address spender,
374     uint256 value
375   )
376     internal
377   {
378     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
379     require(token.approve(spender, newAllowance));
380   }
381 }
382 
383 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
384 
385 /**
386  * @title Helps contracts guard against reentrancy attacks.
387  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
388  * @dev If you mark a function `nonReentrant`, you should also
389  * mark it `external`.
390  */
391 contract ReentrancyGuard {
392 
393   /// @dev counter to allow mutex lock with only one SSTORE operation
394   uint256 private _guardCounter;
395 
396   constructor() internal {
397     // The counter starts at one to prevent changing it from zero to a non-zero
398     // value, which is a more expensive operation.
399     _guardCounter = 1;
400   }
401 
402   /**
403    * @dev Prevents a contract from calling itself, directly or indirectly.
404    * Calling a `nonReentrant` function from another `nonReentrant`
405    * function is not supported. It is possible to prevent this from happening
406    * by making the `nonReentrant` function external, and make it call a
407    * `private` function that does the actual work.
408    */
409   modifier nonReentrant() {
410     _guardCounter += 1;
411     uint256 localCounter = _guardCounter;
412     _;
413     require(localCounter == _guardCounter);
414   }
415 
416 }
417 
418 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
419 
420 /**
421  * @title Crowdsale
422  * @dev Crowdsale is a base contract for managing a token crowdsale,
423  * allowing investors to purchase tokens with ether. This contract implements
424  * such functionality in its most fundamental form and can be extended to provide additional
425  * functionality and/or custom behavior.
426  * The external interface represents the basic interface for purchasing tokens, and conform
427  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
428  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
429  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
430  * behavior.
431  */
432 contract Crowdsale is ReentrancyGuard {
433   using SafeMath for uint256;
434   using SafeERC20 for IERC20;
435 
436   // The token being sold
437   IERC20 private _token;
438 
439   // Address where funds are collected
440   address private _wallet;
441 
442   // How many token units a buyer gets per wei.
443   // The rate is the conversion between wei and the smallest and indivisible token unit.
444   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
445   // 1 wei will give you 1 unit, or 0.001 TOK.
446   uint256 private _rate;
447 
448   // Amount of wei raised
449   uint256 private _weiRaised;
450 
451   /**
452    * Event for token purchase logging
453    * @param purchaser who paid for the tokens
454    * @param beneficiary who got the tokens
455    * @param value weis paid for purchase
456    * @param amount amount of tokens purchased
457    */
458   event TokensPurchased(
459     address indexed purchaser,
460     address indexed beneficiary,
461     uint256 value,
462     uint256 amount
463   );
464 
465   /**
466    * @param rate Number of token units a buyer gets per wei
467    * @dev The rate is the conversion between wei and the smallest and indivisible
468    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
469    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
470    * @param wallet Address where collected funds will be forwarded to
471    * @param token Address of the token being sold
472    */
473   constructor(uint256 rate, address wallet, IERC20 token) internal {
474     require(rate > 0);
475     require(wallet != address(0));
476     require(token != address(0));
477 
478     _rate = rate;
479     _wallet = wallet;
480     _token = token;
481   }
482 
483   // -----------------------------------------
484   // Crowdsale external interface
485   // -----------------------------------------
486 
487   /**
488    * @dev fallback function ***DO NOT OVERRIDE***
489    * Note that other contracts will transfer fund with a base gas stipend
490    * of 2300, which is not enough to call buyTokens. Consider calling
491    * buyTokens directly when purchasing tokens from a contract.
492    */
493   function () external payable {
494     buyTokens(msg.sender);
495   }
496 
497   /**
498    * @return the token being sold.
499    */
500   function token() public view returns(IERC20) {
501     return _token;
502   }
503 
504   /**
505    * @return the address where funds are collected.
506    */
507   function wallet() public view returns(address) {
508     return _wallet;
509   }
510 
511   /**
512    * @return the number of token units a buyer gets per wei.
513    */
514   function rate() public view returns(uint256) {
515     return _rate;
516   }
517 
518   /**
519    * @return the amount of wei raised.
520    */
521   function weiRaised() public view returns (uint256) {
522     return _weiRaised;
523   }
524 
525   /**
526    * @dev low level token purchase ***DO NOT OVERRIDE***
527    * This function has a non-reentrancy guard, so it shouldn't be called by
528    * another `nonReentrant` function.
529    * @param beneficiary Recipient of the token purchase
530    */
531   function buyTokens(address beneficiary) public nonReentrant payable {
532 
533     uint256 weiAmount = msg.value;
534     _preValidatePurchase(beneficiary, weiAmount);
535 
536     // calculate token amount to be created
537     uint256 tokens = _getTokenAmount(weiAmount);
538 
539     // update state
540     _weiRaised = _weiRaised.add(weiAmount);
541 
542     _processPurchase(beneficiary, tokens);
543     emit TokensPurchased(
544       msg.sender,
545       beneficiary,
546       weiAmount,
547       tokens
548     );
549 
550     _updatePurchasingState(beneficiary, weiAmount);
551 
552     _forwardFunds();
553     _postValidatePurchase(beneficiary, weiAmount);
554   }
555 
556   // -----------------------------------------
557   // Internal interface (extensible)
558   // -----------------------------------------
559 
560   /**
561    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
562    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
563    *   super._preValidatePurchase(beneficiary, weiAmount);
564    *   require(weiRaised().add(weiAmount) <= cap);
565    * @param beneficiary Address performing the token purchase
566    * @param weiAmount Value in wei involved in the purchase
567    */
568   function _preValidatePurchase(
569     address beneficiary,
570     uint256 weiAmount
571   )
572     internal
573     view
574   {
575     require(beneficiary != address(0));
576     require(weiAmount != 0);
577   }
578 
579   /**
580    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
581    * @param beneficiary Address performing the token purchase
582    * @param weiAmount Value in wei involved in the purchase
583    */
584   function _postValidatePurchase(
585     address beneficiary,
586     uint256 weiAmount
587   )
588     internal
589     view
590   {
591     // optional override
592   }
593 
594   /**
595    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
596    * @param beneficiary Address performing the token purchase
597    * @param tokenAmount Number of tokens to be emitted
598    */
599   function _deliverTokens(
600     address beneficiary,
601     uint256 tokenAmount
602   )
603     internal
604   {
605     _token.safeTransfer(beneficiary, tokenAmount);
606   }
607 
608   /**
609    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
610    * @param beneficiary Address receiving the tokens
611    * @param tokenAmount Number of tokens to be purchased
612    */
613   function _processPurchase(
614     address beneficiary,
615     uint256 tokenAmount
616   )
617     internal
618   {
619     _deliverTokens(beneficiary, tokenAmount);
620   }
621 
622   /**
623    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
624    * @param beneficiary Address receiving the tokens
625    * @param weiAmount Value in wei involved in the purchase
626    */
627   function _updatePurchasingState(
628     address beneficiary,
629     uint256 weiAmount
630   )
631     internal
632   {
633     // optional override
634   }
635 
636   /**
637    * @dev Override to extend the way in which ether is converted to tokens.
638    * @param weiAmount Value in wei to be converted into tokens
639    * @return Number of tokens that can be purchased with the specified _weiAmount
640    */
641   function _getTokenAmount(uint256 weiAmount)
642     internal view returns (uint256)
643   {
644     return weiAmount.mul(_rate);
645   }
646 
647   /**
648    * @dev Determines how ETH is stored/forwarded on purchases.
649    */
650   function _forwardFunds() internal {
651     _wallet.transfer(msg.value);
652   }
653 }
654 
655 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
656 
657 /**
658  * @title TimedCrowdsale
659  * @dev Crowdsale accepting contributions only within a time frame.
660  */
661 contract TimedCrowdsale is Crowdsale {
662   using SafeMath for uint256;
663 
664   uint256 private _openingTime;
665   uint256 private _closingTime;
666 
667   /**
668    * @dev Reverts if not in crowdsale time range.
669    */
670   modifier onlyWhileOpen {
671     require(isOpen());
672     _;
673   }
674 
675   /**
676    * @dev Constructor, takes crowdsale opening and closing times.
677    * @param openingTime Crowdsale opening time
678    * @param closingTime Crowdsale closing time
679    */
680   constructor(uint256 openingTime, uint256 closingTime) internal {
681     // solium-disable-next-line security/no-block-members
682     require(openingTime >= block.timestamp);
683     require(closingTime > openingTime);
684 
685     _openingTime = openingTime;
686     _closingTime = closingTime;
687   }
688 
689   /**
690    * @return the crowdsale opening time.
691    */
692   function openingTime() public view returns(uint256) {
693     return _openingTime;
694   }
695 
696   /**
697    * @return the crowdsale closing time.
698    */
699   function closingTime() public view returns(uint256) {
700     return _closingTime;
701   }
702 
703   /**
704    * @return true if the crowdsale is open, false otherwise.
705    */
706   function isOpen() public view returns (bool) {
707     // solium-disable-next-line security/no-block-members
708     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
709   }
710 
711   /**
712    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
713    * @return Whether crowdsale period has elapsed
714    */
715   function hasClosed() public view returns (bool) {
716     // solium-disable-next-line security/no-block-members
717     return block.timestamp > _closingTime;
718   }
719 
720   /**
721    * @dev Extend parent behavior requiring to be within contributing period
722    * @param beneficiary Token purchaser
723    * @param weiAmount Amount of wei contributed
724    */
725   function _preValidatePurchase(
726     address beneficiary,
727     uint256 weiAmount
728   )
729     internal
730     onlyWhileOpen
731     view
732   {
733     super._preValidatePurchase(beneficiary, weiAmount);
734   }
735 
736 }
737 
738 // File: openzeppelin-solidity/contracts/crowdsale/validation/CappedCrowdsale.sol
739 
740 /**
741  * @title CappedCrowdsale
742  * @dev Crowdsale with a limit for total contributions.
743  */
744 contract CappedCrowdsale is Crowdsale {
745   using SafeMath for uint256;
746 
747   uint256 private _cap;
748 
749   /**
750    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
751    * @param cap Max amount of wei to be contributed
752    */
753   constructor(uint256 cap) internal {
754     require(cap > 0);
755     _cap = cap;
756   }
757 
758   /**
759    * @return the cap of the crowdsale.
760    */
761   function cap() public view returns(uint256) {
762     return _cap;
763   }
764 
765   /**
766    * @dev Checks whether the cap has been reached.
767    * @return Whether the cap was reached
768    */
769   function capReached() public view returns (bool) {
770     return weiRaised() >= _cap;
771   }
772 
773   /**
774    * @dev Extend parent behavior requiring purchase to respect the funding cap.
775    * @param beneficiary Token purchaser
776    * @param weiAmount Amount of wei contributed
777    */
778   function _preValidatePurchase(
779     address beneficiary,
780     uint256 weiAmount
781   )
782     internal
783     view
784   {
785     super._preValidatePurchase(beneficiary, weiAmount);
786     require(weiRaised().add(weiAmount) <= _cap);
787   }
788 
789 }
790 
791 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
792 
793 /**
794  * @title Ownable
795  * @dev The Ownable contract has an owner address, and provides basic authorization control
796  * functions, this simplifies the implementation of "user permissions".
797  */
798 contract Ownable {
799   address private _owner;
800 
801   event OwnershipTransferred(
802     address indexed previousOwner,
803     address indexed newOwner
804   );
805 
806   /**
807    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
808    * account.
809    */
810   constructor() internal {
811     _owner = msg.sender;
812     emit OwnershipTransferred(address(0), _owner);
813   }
814 
815   /**
816    * @return the address of the owner.
817    */
818   function owner() public view returns(address) {
819     return _owner;
820   }
821 
822   /**
823    * @dev Throws if called by any account other than the owner.
824    */
825   modifier onlyOwner() {
826     require(isOwner());
827     _;
828   }
829 
830   /**
831    * @return true if `msg.sender` is the owner of the contract.
832    */
833   function isOwner() public view returns(bool) {
834     return msg.sender == _owner;
835   }
836 
837   /**
838    * @dev Allows the current owner to relinquish control of the contract.
839    * @notice Renouncing to ownership will leave the contract without an owner.
840    * It will not be possible to call the functions with the `onlyOwner`
841    * modifier anymore.
842    */
843   function renounceOwnership() public onlyOwner {
844     emit OwnershipTransferred(_owner, address(0));
845     _owner = address(0);
846   }
847 
848   /**
849    * @dev Allows the current owner to transfer control of the contract to a newOwner.
850    * @param newOwner The address to transfer ownership to.
851    */
852   function transferOwnership(address newOwner) public onlyOwner {
853     _transferOwnership(newOwner);
854   }
855 
856   /**
857    * @dev Transfers control of the contract to a newOwner.
858    * @param newOwner The address to transfer ownership to.
859    */
860   function _transferOwnership(address newOwner) internal {
861     require(newOwner != address(0));
862     emit OwnershipTransferred(_owner, newOwner);
863     _owner = newOwner;
864   }
865 }
866 
867 // File: eth-token-recover/contracts/TokenRecover.sol
868 
869 /**
870  * @title TokenRecover
871  * @author Vittorio Minacori (https://github.com/vittominacori)
872  * @dev Allow to recover any ERC20 sent into the contract for error
873  */
874 contract TokenRecover is Ownable {
875 
876   /**
877    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
878    * @param tokenAddress The token contract address
879    * @param tokenAmount Number of tokens to be sent
880    */
881   function recoverERC20(
882     address tokenAddress,
883     uint256 tokenAmount
884   )
885     public
886     onlyOwner
887   {
888     IERC20(tokenAddress).transfer(owner(), tokenAmount);
889   }
890 }
891 
892 // File: openzeppelin-solidity/contracts/access/Roles.sol
893 
894 /**
895  * @title Roles
896  * @dev Library for managing addresses assigned to a Role.
897  */
898 library Roles {
899   struct Role {
900     mapping (address => bool) bearer;
901   }
902 
903   /**
904    * @dev give an account access to this role
905    */
906   function add(Role storage role, address account) internal {
907     require(account != address(0));
908     require(!has(role, account));
909 
910     role.bearer[account] = true;
911   }
912 
913   /**
914    * @dev remove an account's access to this role
915    */
916   function remove(Role storage role, address account) internal {
917     require(account != address(0));
918     require(has(role, account));
919 
920     role.bearer[account] = false;
921   }
922 
923   /**
924    * @dev check if an account has this role
925    * @return bool
926    */
927   function has(Role storage role, address account)
928     internal
929     view
930     returns (bool)
931   {
932     require(account != address(0));
933     return role.bearer[account];
934   }
935 }
936 
937 // File: ico-maker/contracts/access/roles/OperatorRole.sol
938 
939 contract OperatorRole {
940   using Roles for Roles.Role;
941 
942   event OperatorAdded(address indexed account);
943   event OperatorRemoved(address indexed account);
944 
945   Roles.Role private _operators;
946 
947   constructor() internal {
948     _addOperator(msg.sender);
949   }
950 
951   modifier onlyOperator() {
952     require(isOperator(msg.sender));
953     _;
954   }
955 
956   function isOperator(address account) public view returns (bool) {
957     return _operators.has(account);
958   }
959 
960   function addOperator(address account) public onlyOperator {
961     _addOperator(account);
962   }
963 
964   function renounceOperator() public {
965     _removeOperator(msg.sender);
966   }
967 
968   function _addOperator(address account) internal {
969     _operators.add(account);
970     emit OperatorAdded(account);
971   }
972 
973   function _removeOperator(address account) internal {
974     _operators.remove(account);
975     emit OperatorRemoved(account);
976   }
977 }
978 
979 // File: ico-maker/contracts/crowdsale/utils/Contributions.sol
980 
981 /**
982  * @title Contributions
983  * @author Vittorio Minacori (https://github.com/vittominacori)
984  * @dev Utility contract where to save any information about Crowdsale contributions
985  */
986 contract Contributions is OperatorRole, TokenRecover {
987 
988   using SafeMath for uint256;
989 
990   struct Contributor {
991     uint256 weiAmount;
992     uint256 tokenAmount;
993     bool exists;
994   }
995 
996   // the number of sold tokens
997   uint256 private _totalSoldTokens;
998 
999   // the number of wei raised
1000   uint256 private _totalWeiRaised;
1001 
1002   // list of addresses who contributed in crowdsales
1003   address[] private _addresses;
1004 
1005   // map of contributors
1006   mapping(address => Contributor) private _contributors;
1007 
1008   constructor() public {}
1009 
1010   /**
1011    * @return the number of sold tokens
1012    */
1013   function totalSoldTokens() public view returns(uint256) {
1014     return _totalSoldTokens;
1015   }
1016 
1017   /**
1018    * @return the number of wei raised
1019    */
1020   function totalWeiRaised() public view returns(uint256) {
1021     return _totalWeiRaised;
1022   }
1023 
1024   /**
1025    * @return address of a contributor by list index
1026    */
1027   function getContributorAddress(uint256 index) public view returns(address) {
1028     return _addresses[index];
1029   }
1030 
1031   /**
1032    * @dev return the contributions length
1033    * @return uint
1034    */
1035   function getContributorsLength() public view returns (uint) {
1036     return _addresses.length;
1037   }
1038 
1039   /**
1040    * @dev get wei contribution for the given address
1041    * @param account Address has contributed
1042    * @return uint256
1043    */
1044   function weiContribution(address account) public view returns (uint256) {
1045     return _contributors[account].weiAmount;
1046   }
1047 
1048   /**
1049    * @dev get token balance for the given address
1050    * @param account Address has contributed
1051    * @return uint256
1052    */
1053   function tokenBalance(address account) public view returns (uint256) {
1054     return _contributors[account].tokenAmount;
1055   }
1056 
1057   /**
1058    * @dev check if a contributor exists
1059    * @param account The address to check
1060    * @return bool
1061    */
1062   function contributorExists(address account) public view returns (bool) {
1063     return _contributors[account].exists;
1064   }
1065 
1066   /**
1067    * @dev add contribution into the contributions array
1068    * @param account Address being contributing
1069    * @param weiAmount Amount of wei contributed
1070    * @param tokenAmount Amount of token received
1071    */
1072   function addBalance(
1073     address account,
1074     uint256 weiAmount,
1075     uint256 tokenAmount
1076   )
1077     public
1078     onlyOperator
1079   {
1080     if (!_contributors[account].exists) {
1081       _addresses.push(account);
1082       _contributors[account].exists = true;
1083     }
1084 
1085     _contributors[account].weiAmount = _contributors[account].weiAmount.add(weiAmount);
1086     _contributors[account].tokenAmount = _contributors[account].tokenAmount.add(tokenAmount);
1087 
1088     _totalWeiRaised = _totalWeiRaised.add(weiAmount);
1089     _totalSoldTokens = _totalSoldTokens.add(tokenAmount);
1090   }
1091 
1092   /**
1093    * @dev remove the `operator` role from address
1094    * @param account Address you want to remove role
1095    */
1096   function removeOperator(address account) public onlyOwner {
1097     _removeOperator(account);
1098   }
1099 }
1100 
1101 // File: ico-maker/contracts/crowdsale/BaseCrowdsale.sol
1102 
1103 /**
1104  * @title BaseCrowdsale
1105  * @author Vittorio Minacori (https://github.com/vittominacori)
1106  * @dev Extends from Crowdsale with more stuffs like TimedCrowdsale, CappedCrowdsale.
1107  *  Base for any other Crowdsale contract
1108  */
1109 contract BaseCrowdsale is TimedCrowdsale, CappedCrowdsale, TokenRecover {
1110 
1111   // reference to Contributions contract
1112   Contributions private _contributions;
1113 
1114   // the minimum value of contribution in wei
1115   uint256 private _minimumContribution;
1116 
1117   /**
1118    * @dev Reverts if less than minimum contribution
1119    */
1120   modifier onlyGreaterThanMinimum(uint256 weiAmount) {
1121     require(weiAmount >= _minimumContribution);
1122     _;
1123   }
1124 
1125   /**
1126    * @param openingTime Crowdsale opening time
1127    * @param closingTime Crowdsale closing time
1128    * @param rate Number of token units a buyer gets per wei
1129    * @param wallet Address where collected funds will be forwarded to
1130    * @param cap Max amount of wei to be contributed
1131    * @param minimumContribution Min amount of wei to be contributed
1132    * @param token Address of the token being sold
1133    * @param contributions Address of the contributions contract
1134    */
1135   constructor(
1136     uint256 openingTime,
1137     uint256 closingTime,
1138     uint256 rate,
1139     address wallet,
1140     uint256 cap,
1141     uint256 minimumContribution,
1142     address token,
1143     address contributions
1144   )
1145     public
1146     Crowdsale(rate, wallet, ERC20(token))
1147     TimedCrowdsale(openingTime, closingTime)
1148     CappedCrowdsale(cap)
1149   {
1150     require(contributions != address(0));
1151     _contributions = Contributions(contributions);
1152     _minimumContribution = minimumContribution;
1153   }
1154 
1155   /**
1156    * @return the crowdsale contributions contract
1157    */
1158   function contributions() public view returns(Contributions) {
1159     return _contributions;
1160   }
1161 
1162   /**
1163    * @return the minimum value of contribution in wei
1164    */
1165   function minimumContribution() public view returns(uint256) {
1166     return _minimumContribution;
1167   }
1168 
1169   /**
1170    * @dev false if the ico is not started, true if the ico is started and running, true if the ico is completed
1171    * @return bool
1172    */
1173   function started() public view returns(bool) {
1174     return block.timestamp >= openingTime(); // solhint-disable-line not-rely-on-time
1175   }
1176 
1177   /**
1178    * @dev false if the ico is not started, false if the ico is started and running, true if the ico is completed
1179    * @return bool
1180    */
1181   function ended() public view returns(bool) {
1182     return hasClosed() || capReached();
1183   }
1184 
1185   /**
1186    * @dev Extend parent behavior requiring purchase to respect the minimumContribution.
1187    * @param beneficiary Token purchaser
1188    * @param weiAmount Amount of wei contributed
1189    */
1190   function _preValidatePurchase(
1191     address beneficiary,
1192     uint256 weiAmount
1193   )
1194     internal
1195     onlyGreaterThanMinimum(weiAmount)
1196     view
1197   {
1198     super._preValidatePurchase(beneficiary, weiAmount);
1199   }
1200 
1201   /**
1202    * @dev Update the contributions contract states
1203    * @param beneficiary Address receiving the tokens
1204    * @param weiAmount Value in wei involved in the purchase
1205    */
1206   function _updatePurchasingState(
1207     address beneficiary,
1208     uint256 weiAmount
1209   )
1210     internal
1211   {
1212     super._updatePurchasingState(beneficiary, weiAmount);
1213     _contributions.addBalance(
1214       beneficiary,
1215       weiAmount,
1216       _getTokenAmount(weiAmount)
1217     );
1218   }
1219 }
1220 
1221 // File: contracts/crowdsale/ForkTokenSale.sol
1222 
1223 /**
1224  * @title ForkTokenSale
1225  * @author Vittorio Minacori (https://github.com/vittominacori)
1226  * @dev Extends from BaseCrowdsale with the ability to change rate
1227  */
1228 contract ForkTokenSale is BaseCrowdsale {
1229 
1230   uint256 private _currentRate;
1231 
1232   uint256 private _soldTokens;
1233 
1234   constructor(
1235     uint256 openingTime,
1236     uint256 closingTime,
1237     uint256 rate,
1238     address wallet,
1239     uint256 cap,
1240     uint256 minimumContribution,
1241     address token,
1242     address contributions
1243   )
1244     public
1245     BaseCrowdsale(
1246       openingTime,
1247       closingTime,
1248       rate,
1249       wallet,
1250       cap,
1251       minimumContribution,
1252       token,
1253       contributions
1254     )
1255   {
1256     _currentRate = rate;
1257   }
1258 
1259   /**
1260    * @dev Function to update rate
1261    * @param newRate The rate is the conversion between wei and the smallest and indivisible token unit
1262    */
1263   function setRate(uint256 newRate) public onlyOwner {
1264     require(newRate > 0);
1265     _currentRate = newRate;
1266   }
1267 
1268   /**
1269    * @return the number of token units a buyer gets per wei.
1270    */
1271   function rate() public view returns(uint256) {
1272     return _currentRate;
1273   }
1274 
1275   /**
1276    * @return the number of sold tokens.
1277    */
1278   function soldTokens() public view returns(uint256) {
1279     return _soldTokens;
1280   }
1281 
1282   /**
1283    * @dev Override to extend the way in which ether is converted to tokens.
1284    * @param weiAmount Value in wei to be converted into tokens
1285    * @return Number of tokens that can be purchased with the specified _weiAmount
1286    */
1287   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
1288     return weiAmount.mul(rate());
1289   }
1290 
1291   /**
1292    * @dev Update the contributions contract states
1293    * @param beneficiary Address receiving the tokens
1294    * @param weiAmount Value in wei involved in the purchase
1295    */
1296   function _updatePurchasingState(
1297     address beneficiary,
1298     uint256 weiAmount
1299   )
1300     internal
1301   {
1302     _soldTokens = _soldTokens.add(_getTokenAmount(weiAmount));
1303     super._updatePurchasingState(beneficiary, weiAmount);
1304   }
1305 }