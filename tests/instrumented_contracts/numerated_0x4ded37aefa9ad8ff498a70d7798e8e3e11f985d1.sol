1 /**
2  * @title Ownable
3  * @dev The Ownable contract has an owner address, and provides basic authorization control
4  * functions, this simplifies the implementation of "user permissions".
5  */
6 contract Ownable {
7   address private _owner;
8 
9   event OwnershipTransferred(
10     address indexed previousOwner,
11     address indexed newOwner
12   );
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() internal {
19     _owner = msg.sender;
20     emit OwnershipTransferred(address(0), _owner);
21   }
22 
23   /**
24    * @return the address of the owner.
25    */
26   function owner() public view returns(address) {
27     return _owner;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(isOwner());
35     _;
36   }
37 
38   /**
39    * @return true if `msg.sender` is the owner of the contract.
40    */
41   function isOwner() public view returns(bool) {
42     return msg.sender == _owner;
43   }
44 
45   /**
46    * @dev Allows the current owner to relinquish control of the contract.
47    * @notice Renouncing to ownership will leave the contract without an owner.
48    * It will not be possible to call the functions with the `onlyOwner`
49    * modifier anymore.
50    */
51   function renounceOwnership() public onlyOwner {
52     emit OwnershipTransferred(_owner, address(0));
53     _owner = address(0);
54   }
55 
56   /**
57    * @dev Allows the current owner to transfer control of the contract to a newOwner.
58    * @param newOwner The address to transfer ownership to.
59    */
60   function transferOwnership(address newOwner) public onlyOwner {
61     _transferOwnership(newOwner);
62   }
63 
64   /**
65    * @dev Transfers control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function _transferOwnership(address newOwner) internal {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(_owner, newOwner);
71     _owner = newOwner;
72   }
73 }
74 
75 
76 contract Whitelisted is Ownable {
77 
78     mapping (address => uint8) public whitelist;
79     mapping (address => bool) public provider;
80 
81     // Only whitelisted
82     modifier onlyWhitelisted {
83       require(isWhitelisted(msg.sender));
84       _;
85     }
86 
87       modifier onlyProvider {
88         require(isProvider(msg.sender));
89         _;
90       }
91 
92       // Check if address is KYC provider
93       function isProvider(address _provider) public view returns (bool){
94         if (owner() == _provider){
95           return true;
96         }
97         return provider[_provider] == true ? true : false;
98       }
99       // Set new provider
100       function setProvider(address _provider) public onlyOwner {
101          provider[_provider] = true;
102       }
103       // Deactive current provider
104       function deactivateProvider(address _provider) public onlyOwner {
105          require(provider[_provider] == true);
106          provider[_provider] = false;
107       }
108       // Set purchaser to whitelist with zone code
109       function setWhitelisted(address _purchaser, uint8 _zone) public onlyProvider {
110          whitelist[_purchaser] = _zone;
111       }
112       // Delete purchaser from whitelist
113       function deleteFromWhitelist(address _purchaser) public onlyProvider {
114          whitelist[_purchaser] = 0;
115       }
116       // Get purchaser zone code
117       function getWhitelistedZone(address _purchaser) public view returns(uint8) {
118         return whitelist[_purchaser] > 0 ? whitelist[_purchaser] : 0;
119       }
120       // Check if purchaser is whitelisted : return true or false
121       function isWhitelisted(address _purchaser) public view returns (bool){
122         return whitelist[_purchaser] > 0;
123       }
124 }
125 
126 
127 /**
128  * @title SafeMath
129  * @dev Math operations with safety checks that revert on error
130  */
131 library SafeMath {
132 
133   /**
134   * @dev Multiplies two numbers, reverts on overflow.
135   */
136   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138     // benefit is lost if 'b' is also tested.
139     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
140     if (a == 0) {
141       return 0;
142     }
143 
144     uint256 c = a * b;
145     require(c / a == b);
146 
147     return c;
148   }
149 
150   /**
151   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
152   */
153   function div(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b > 0); // Solidity only automatically asserts when dividing by 0
155     uint256 c = a / b;
156     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
157 
158     return c;
159   }
160 
161   /**
162   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater thanminuend).
163   */
164   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165     require(b <= a);
166     uint256 c = a - b;
167 
168     return c;
169   }
170 
171   /**
172   * @dev Adds two numbers, reverts on overflow.
173   */
174   function add(uint256 a, uint256 b) internal pure returns (uint256) {
175     uint256 c = a + b;
176     require(c >= a);
177 
178     return c;
179   }
180 
181   /**
182   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
183   * reverts when dividing by zero.
184   */
185   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186     require(b != 0);
187     return a % b;
188   }
189 }
190 
191 
192 /**
193  * @title ERC20 interface
194  * @dev see https://github.com/ethereum/EIPs/issues/20
195  */
196 interface IERC20 {
197   function totalSupply() external view returns (uint256);
198 
199   function balanceOf(address who) external view returns (uint256);
200 
201   function allowance(address owner, address spender)
202     external view returns (uint256);
203 
204   function transfer(address to, uint256 value) external returns (bool);
205 
206   function approve(address spender, uint256 value)
207     external returns (bool);
208 
209   function transferFrom(address from, address to, uint256 value)
210     external returns (bool);
211 
212   event Transfer(
213     address indexed from,
214     address indexed to,
215     uint256 value
216   );
217 
218   event Approval(
219     address indexed owner,
220     address indexed spender,
221     uint256 value
222   );
223 }
224 
225 /**
226  * @title SafeERC20
227  * @dev Wrappers around ERC20 operations that throw on failure.
228  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
229  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
230  */
231 library SafeERC20 {
232 
233   using SafeMath for uint256;
234 
235   function safeTransfer(
236     IERC20 token,
237     address to,
238     uint256 value
239   )
240     internal
241   {
242     require(token.transfer(to, value));
243   }
244 
245   function safeTransferFrom(
246     IERC20 token,
247     address from,
248     address to,
249     uint256 value
250   )
251     internal
252   {
253     require(token.transferFrom(from, to, value));
254   }
255 
256   function safeApprove(
257     IERC20 token,
258     address spender,
259     uint256 value
260   )
261     internal
262   {
263     // safeApprove should only be called when setting an initial allowance,
264     // or when resetting it to zero. To increase and decrease it, use
265     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
266     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
267     require(token.approve(spender, value));
268   }
269 
270   function safeIncreaseAllowance(
271     IERC20 token,
272     address spender,
273     uint256 value
274   )
275     internal
276   {
277     uint256 newAllowance = token.allowance(address(this), spender).add(value);
278     require(token.approve(spender, newAllowance));
279   }
280 
281   function safeDecreaseAllowance(
282     IERC20 token,
283     address spender,
284     uint256 value
285   )
286     internal
287   {
288     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
289     require(token.approve(spender, newAllowance));
290   }
291 }
292 
293 
294 /**
295  * @title Helps contracts guard against reentrancy attacks.
296  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
297  * @dev If you mark a function `nonReentrant`, you should also
298  * mark it `external`.
299  */
300 contract ReentrancyGuard {
301 
302   /// @dev counter to allow mutex lock with only one SSTORE operation
303   uint256 private _guardCounter;
304 
305   constructor() internal {
306     // The counter starts at one to prevent changing it from zero to a non-zero
307     // value, which is a more expensive operation.
308     _guardCounter = 1;
309   }
310 
311   /**
312    * @dev Prevents a contract from calling itself, directly or indirectly.
313    * Calling a `nonReentrant` function from another `nonReentrant`
314    * function is not supported. It is possible to prevent this from happening
315    * by making the `nonReentrant` function external, and make it call a
316    * `private` function that does the actual work.
317    */
318   modifier nonReentrant() {
319     _guardCounter += 1;
320     uint256 localCounter = _guardCounter;
321     _;
322     require(localCounter == _guardCounter);
323   }
324 
325 }
326 
327 
328 /**
329  * @title Crowdsale
330  * @dev Crowdsale is a base contract for managing a token crowdsale,
331  * allowing investors to purchase tokens with ether. This contract implements
332  * such functionality in its most fundamental form and can be extended to provide additional
333  * functionality and/or custom behavior.
334  * The external interface represents the basic interface for purchasing tokens, and conform
335  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
336  * The internal interface conforms the extensible and modifiable surface of crowdsales.Override
337  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
338  * behavior.
339  */
340 contract Crowdsale is ReentrancyGuard {
341   using SafeMath for uint256;
342   using SafeERC20 for IERC20;
343 
344   // The token being sold
345   IERC20 private _token;
346 
347   // Address where funds are collected
348   address private _wallet;
349 
350   // How many token units a buyer gets per wei.
351   // The rate is the conversion between wei and the smallest and indivisible token unit.
352   // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals calledTOK
353   // 1 wei will give you 1 unit, or 0.001 TOK.
354   uint256 private _rate;
355 
356   // Amount of wei raised
357   uint256 private _weiRaised;
358 
359   /**
360    * Event for token purchase logging
361    * @param purchaser who paid for the tokens
362    * @param beneficiary who got the tokens
363    * @param value weis paid for purchase
364    * @param amount amount of tokens purchased
365    */
366   event TokensPurchased(
367     address indexed purchaser,
368     address indexed beneficiary,
369     uint256 value,
370     uint256 amount
371   );
372 
373   /**
374    * @param rate Number of token units a buyer gets per wei
375    * @dev The rate is the conversion between wei and the smallest and indivisible
376    * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
377    * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
378    * @param wallet Address where collected funds will be forwarded to
379    * @param token Address of the token being sold
380    */
381   constructor(uint256 rate, address wallet, IERC20 token) internal {
382     require(rate > 0);
383     require(wallet != address(0));
384     require(token != address(0));
385 
386     _rate = rate;
387     _wallet = wallet;
388     _token = token;
389   }
390 
391   // -----------------------------------------
392   // Crowdsale external interface
393   // -----------------------------------------
394 
395   /**
396    * @dev fallback function ***DO NOT OVERRIDE***
397    * Note that other contracts will transfer fund with a base gas stipend
398    * of 2300, which is not enough to call buyTokens. Consider calling
399    * buyTokens directly when purchasing tokens from a contract.
400    */
401   function () external payable {
402     buyTokens(msg.sender);
403   }
404 
405   /**
406    * @return the token being sold.
407    */
408   function token() public view returns(IERC20) {
409     return _token;
410   }
411 
412   /**
413    * @return the address where funds are collected.
414    */
415   function wallet() public view returns(address) {
416     return _wallet;
417   }
418 
419   /**
420    * @return the number of token units a buyer gets per wei.
421    */
422   function rate() public view returns(uint256) {
423     return _rate;
424   }
425 
426   /**
427    * @return the amount of wei raised.
428    */
429   function weiRaised() public view returns (uint256) {
430     return _weiRaised;
431   }
432 
433   /**
434    * @dev low level token purchase ***DO NOT OVERRIDE***
435    * This function has a non-reentrancy guard, so it shouldn't be called by
436    * another `nonReentrant` function.
437    * @param beneficiary Recipient of the token purchase
438    */
439   function buyTokens(address beneficiary) public nonReentrant payable {
440 
441     uint256 weiAmount = msg.value;
442     _preValidatePurchase(beneficiary, weiAmount);
443 
444     // calculate token amount to be created
445     uint256 tokens = _getTokenAmount(weiAmount);
446 
447     // update state
448     _weiRaised = _weiRaised.add(weiAmount);
449 
450     _processPurchase(beneficiary, tokens);
451     emit TokensPurchased(
452       msg.sender,
453       beneficiary,
454       weiAmount,
455       tokens
456     );
457 
458     _updatePurchasingState(beneficiary, weiAmount);
459 
460     _forwardFunds();
461     _postValidatePurchase(beneficiary, weiAmount);
462   }
463 
464   // -----------------------------------------
465   // Internal interface (extensible)
466   // -----------------------------------------
467 
468   /**
469    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use `super` in contracts that inherit from Crowdsale to extend their validations.
470    * Example from CappedCrowdsale.sol's _preValidatePurchase method:
471    *   super._preValidatePurchase(beneficiary, weiAmount);
472    *   require(weiRaised().add(weiAmount) <= cap);
473    * @param beneficiary Address performing the token purchase
474    * @param weiAmount Value in wei involved in the purchase
475    */
476   function _preValidatePurchase(
477     address beneficiary,
478     uint256 weiAmount
479   )
480     internal
481     view
482   {
483     require(beneficiary != address(0));
484     require(weiAmount != 0);
485   }
486 
487   /**
488    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
489    * @param beneficiary Address performing the token purchase
490    * @param weiAmount Value in wei involved in the purchase
491    */
492   function _postValidatePurchase(
493     address beneficiary,
494     uint256 weiAmount
495   )
496     internal
497     view
498   {
499     // optional override
500   }
501 
502   /**
503    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
504    * @param beneficiary Address performing the token purchase
505    * @param tokenAmount Number of tokens to be emitted
506    */
507   function _deliverTokens(
508     address beneficiary,
509     uint256 tokenAmount
510   )
511     internal
512   {
513     _token.safeTransfer(beneficiary, tokenAmount);
514   }
515 
516   /**
517    * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send tokens.
518    * @param beneficiary Address receiving the tokens
519    * @param tokenAmount Number of tokens to be purchased
520    */
521   function _processPurchase(
522     address beneficiary,
523     uint256 tokenAmount
524   )
525     internal
526   {
527     _deliverTokens(beneficiary, tokenAmount);
528   }
529 
530   /**
531    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
532    * @param beneficiary Address receiving the tokens
533    * @param weiAmount Value in wei involved in the purchase
534    */
535   function _updatePurchasingState(
536     address beneficiary,
537     uint256 weiAmount
538   )
539     internal
540   {
541     // optional override
542   }
543 
544   /**
545    * @dev Override to extend the way in which ether is converted to tokens.
546    * @param weiAmount Value in wei to be converted into tokens
547    * @return Number of tokens that can be purchased with the specified _weiAmount
548    */
549   function _getTokenAmount(uint256 weiAmount)
550     internal view returns (uint256)
551   {
552     return weiAmount.mul(_rate);
553   }
554 
555   /**
556    * @dev Determines how ETH is stored/forwarded on purchases.
557    */
558   function _forwardFunds() internal {
559     _wallet.transfer(msg.value);
560   }
561 }
562 
563 
564 /**
565  * @title TimedCrowdsale
566  * @dev Crowdsale accepting contributions only within a time frame.
567  */
568 contract TimedCrowdsale is Crowdsale {
569   using SafeMath for uint256;
570 
571   uint256 private _openingTime;
572   uint256 private _closingTime;
573 
574   /**
575    * @dev Reverts if not in crowdsale time range.
576    */
577   modifier onlyWhileOpen {
578     require(isOpen());
579     _;
580   }
581 
582   /**
583    * @dev Constructor, takes crowdsale opening and closing times.
584    * @param openingTime Crowdsale opening time
585    * @param closingTime Crowdsale closing time
586    */
587   constructor(uint256 openingTime, uint256 closingTime) internal {
588     // solium-disable-next-line security/no-block-members
589     require(openingTime >= block.timestamp);
590     require(closingTime > openingTime);
591 
592     _openingTime = openingTime;
593     _closingTime = closingTime;
594   }
595 
596   /**
597    * @return the crowdsale opening time.
598    */
599   function openingTime() public view returns(uint256) {
600     return _openingTime;
601   }
602 
603   /**
604    * @return the crowdsale closing time.
605    */
606   function closingTime() public view returns(uint256) {
607     return _closingTime;
608   }
609 
610   /**
611    * @return true if the crowdsale is open, false otherwise.
612    */
613   function isOpen() public view returns (bool) {
614     // solium-disable-next-line security/no-block-members
615     return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
616   }
617 
618   /**
619    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
620    * @return Whether crowdsale period has elapsed
621    */
622   function hasClosed() public view returns (bool) {
623     // solium-disable-next-line security/no-block-members
624     return block.timestamp > _closingTime;
625   }
626 
627   /**
628    * @dev Extend parent behavior requiring to be within contributing period
629    * @param beneficiary Token purchaser
630    * @param weiAmount Amount of wei contributed
631    */
632   function _preValidatePurchase(
633     address beneficiary,
634     uint256 weiAmount
635   )
636     internal
637     onlyWhileOpen
638     view
639   {
640     super._preValidatePurchase(beneficiary, weiAmount);
641   }
642 
643 }
644 
645 
646 /**
647  * @title PostDeliveryCrowdsale
648  * @dev Crowdsale that locks tokens from withdrawal until it ends.
649  */
650 contract PostDeliveryCrowdsale is TimedCrowdsale {
651   using SafeMath for uint256;
652 
653   mapping(address => uint256) private _balances;
654 
655   constructor() internal {}
656 
657   /**
658    * @dev Withdraw tokens only after crowdsale ends.
659    * @param beneficiary Whose tokens will be withdrawn.
660    */
661   function withdrawTokens(address beneficiary) public {
662     require(hasClosed());
663     uint256 amount = _balances[beneficiary];
664     require(amount > 0);
665     _balances[beneficiary] = 0;
666     _deliverTokens(beneficiary, amount);
667   }
668 
669   /**
670    * @return the balance of an account.
671    */
672   function balanceOf(address account) public view returns(uint256) {
673     return _balances[account];
674   }
675 
676   /**
677    * @dev Overrides parent by storing balances instead of issuing tokens right away.
678    * @param beneficiary Token purchaser
679    * @param tokenAmount Amount of tokens purchased
680    */
681   function _processPurchase(
682     address beneficiary,
683     uint256 tokenAmount
684   )
685     internal
686   {
687     _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
688   }
689 
690 }
691 
692 // File: openzeppelin-solidity/contracts/math/Math.sol
693 
694 /**
695  * @title Math
696  * @dev Assorted math operations
697  */
698 library Math {
699   /**
700   * @dev Returns the largest of two numbers.
701   */
702   function max(uint256 a, uint256 b) internal pure returns (uint256) {
703     return a >= b ? a : b;
704   }
705 
706   /**
707   * @dev Returns the smallest of two numbers.
708   */
709   function min(uint256 a, uint256 b) internal pure returns (uint256) {
710     return a < b ? a : b;
711   }
712 
713   /**
714   * @dev Calculates the average of two numbers. Since these are integers,
715   * averages of an even and odd number cannot be represented, and will be
716   * rounded down.
717   */
718   function average(uint256 a, uint256 b) internal pure returns (uint256) {
719     // (a + b) / 2 can overflow, so we distribute
720     return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
721   }
722 }
723 
724 /**
725  * @title AllowanceCrowdsale
726  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
727  */
728 contract AllowanceCrowdsale is Crowdsale {
729   using SafeMath for uint256;
730   using SafeERC20 for IERC20;
731 
732   address private _tokenWallet;
733 
734   /**
735    * @dev Constructor, takes token wallet address.
736    * @param tokenWallet Address holding the tokens, which has approved allowance to thecrowdsale
737    */
738   constructor(address tokenWallet) internal {
739     require(tokenWallet != address(0));
740     _tokenWallet = tokenWallet;
741   }
742 
743   /**
744    * @return the address of the wallet that will hold the tokens.
745    */
746   function tokenWallet() public view returns(address) {
747     return _tokenWallet;
748   }
749 
750   /**
751    * @dev Checks the amount of tokens left in the allowance.
752    * @return Amount of tokens left in the allowance
753    */
754   function remainingTokens() public view returns (uint256) {
755     return Math.min(
756       token().balanceOf(_tokenWallet),
757       token().allowance(_tokenWallet, this)
758     );
759   }
760 
761   /**
762    * @dev Overrides parent behavior by transferring tokens from wallet.
763    * @param beneficiary Token purchaser
764    * @param tokenAmount Amount of tokens purchased
765    */
766   function _deliverTokens(
767     address beneficiary,
768     uint256 tokenAmount
769   )
770     internal
771   {
772     token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
773   }
774 }
775 
776 
777 contract MocoCrowdsale is TimedCrowdsale, AllowanceCrowdsale, Whitelisted {
778   // Amount of wei raised
779 
780   uint256 public bonusPeriod;
781 
782   uint256 public bonusAmount;
783   // Unlock period 1 - 6 month
784   uint256 private _unlock1;
785 
786   // Unlock period 2 - 12 month
787   uint256 private _unlock2;
788 
789   // Specify locked zone for 2nd period
790   uint8 private _lockedZone;
791 
792   // Total tokens distributed
793   uint256 private _totalTokensDistributed;
794 
795 
796   // Total tokens locked
797   uint256 private _totalTokensLocked;
798 
799 
800   event TokensPurchased(
801     address indexed purchaser,
802     address indexed beneficiary,
803     address asset,
804     uint256 value,
805     uint256 amount
806   );
807 
808   struct Asset {
809     uint256 weiRaised;
810     uint256 minAmount;
811     uint256 rate;
812     bool active;
813   }
814 
815   mapping (address => Asset) private asset;
816   mapping(address => uint256) private _balances;
817 
818 
819   constructor(
820     uint256 _openingTime,
821     uint256 _closingTime,
822     uint256 _unlockPeriod1,
823     uint256 _unlockPeriod2,
824     uint256 _bonusPeriodEnd,
825     uint256 _bonusAmount,
826     uint256 _rate,
827     address _wallet,
828     IERC20 _token,
829     address _tokenWallet
830   ) public
831   TimedCrowdsale(_openingTime, _closingTime)
832   Crowdsale(_rate, _wallet, _token)
833   AllowanceCrowdsale(_tokenWallet){
834        _unlock1 = _unlockPeriod1;
835        _unlock2 = _unlockPeriod2;
836        bonusPeriod = _bonusPeriodEnd;
837       bonusAmount  = _bonusAmount;
838       asset[0x0].rate  = _rate;
839   }
840   function getAssetRaised(address _assetAddress) public view returns(uint256) {
841       return asset[_assetAddress].weiRaised;
842   }
843   function getAssetMinAmount(address _assetAddress) public view returns(uint256) {
844       return asset[_assetAddress].minAmount;
845   }
846   function getAssetRate(address _assetAddress) public view returns(uint256) {
847       return asset[_assetAddress].rate;
848   }
849   function isAssetActive(address _assetAddress) public view returns(bool) {
850       return asset[_assetAddress].active == true ? true : false;
851   }
852   // Add asset
853   function setAsset(address _assetAddress, uint256 _weiRaised, uint256 _minAmount, uint256 _rate) public onlyOwner {
854       asset[_assetAddress].weiRaised = _weiRaised;
855       asset[_assetAddress].minAmount = _minAmount;
856       asset[_assetAddress].rate = _rate;
857       asset[_assetAddress].active = true;
858   }
859 
860   //
861 
862   function weiRaised(address _asset) public view returns (uint256) {
863     return asset[_asset].weiRaised;
864   }
865   function _getTokenAmount(uint256 weiAmount, address asst)
866     internal view returns (uint256)
867   {
868     return weiAmount.mul(asset[asst].rate);
869   }
870 
871   function minAmount(address _asset) public view returns (uint256) {
872     return asset[_asset].minAmount;
873   }
874 
875   // Buy Tokens
876   function buyTokens(address beneficiary) public onlyWhitelisted payable {
877     uint256 weiAmount = msg.value;
878     _preValidatePurchase(beneficiary, weiAmount, 0x0);
879 
880     // calculate token amount to be created
881     uint256 tokens = _getTokenAmount(weiAmount, 0x0);
882 
883     // update state
884     asset[0x0].weiRaised = asset[0x0].weiRaised.add(weiAmount);
885 
886     _processPurchase(beneficiary, tokens);
887 
888     emit TokensPurchased(
889       msg.sender,
890       beneficiary,
891       0x0,
892       weiAmount,
893       tokens
894     );
895 
896     // super._updatePurchasingState(beneficiary, weiAmount);
897 
898     super._forwardFunds();
899     // super._postValidatePurchase(beneficiary, weiAmount);
900   }
901   // Buy tokens for assets
902   function buyTokensAsset(address beneficiary, address asst, uint256 amount) public onlyWhitelisted {
903      require(isAssetActive(asst));
904     _preValidatePurchase(beneficiary, amount, asst);
905 
906     // calculate token amount to be created
907     uint256 tokens = _getTokenAmount(amount, asst);
908 
909     // update state
910     asset[asst].weiRaised = asset[asst].weiRaised.add(amount);
911 
912     _processPurchase(beneficiary, tokens);
913 
914     emit TokensPurchased(
915       msg.sender,
916       beneficiary,
917       asst,
918       amount,
919       tokens
920     );
921 
922      address _wallet  = wallet();
923      IERC20(asst).safeTransferFrom(beneficiary, _wallet, amount);
924 
925     // super._postValidatePurchase(beneficiary, weiAmount);
926   }
927 
928   // Check if locked is end
929   function lockedHasEnd() public view returns (bool) {
930     return block.timestamp > _unlock1 ? true : false;
931   }
932   // Check if locked is end
933   function lockedTwoHasEnd() public view returns (bool) {
934     return block.timestamp > _unlock2 ? true : false;
935   }
936 // Withdraw tokens after locked period is finished
937   function withdrawTokens(address beneficiary) public {
938     require(lockedHasEnd());
939     uint256 amount = _balances[beneficiary];
940     require(amount > 0);
941     uint256 zone = super.getWhitelistedZone(beneficiary);
942     if (zone == 840){
943       // require(lockedTwoHasEnd());
944       if(lockedTwoHasEnd()){
945         _balances[beneficiary] = 0;
946         _deliverTokens(beneficiary, amount);
947       }
948     } else {
949     _balances[beneficiary] = 0;
950     _deliverTokens(beneficiary, amount);
951     }
952   }
953 
954   // Locked tokens balance
955   function balanceOf(address account) public view returns(uint256) {
956     return _balances[account];
957   }
958   // Pre validation token buy
959   function _preValidatePurchase(
960     address beneficiary,
961     uint256 weiAmount,
962     address asst
963   )
964     internal
965     view
966   {
967     require(beneficiary != address(0));
968     require(weiAmount != 0);
969     require(weiAmount >= minAmount(asst));
970 }
971   function getBonusAmount(uint256 _tokenAmount) public view returns(uint256) {
972     return block.timestamp < bonusPeriod ? _tokenAmount.div(bonusAmount) : 0;
973   }
974 
975   function calculateTokens(uint256 _weiAmount) public view returns(uint256) {
976     uint256 tokens  = _getTokenAmount(_weiAmount);
977     return  tokens + getBonusAmount(tokens);
978   }
979 
980   function _processPurchase(
981     address beneficiary,
982     uint256 tokenAmount
983   )
984     internal
985   {
986     uint256 zone = super.getWhitelistedZone(beneficiary);
987    uint256 bonusTokens = getBonusAmount(tokenAmount);
988     if (zone == 840){
989       uint256 totalTokens = bonusTokens.add(tokenAmount);
990       _balances[beneficiary] = _balances[beneficiary].add(totalTokens);
991     }
992     else {
993       super._deliverTokens(beneficiary, tokenAmount);
994       _balances[beneficiary] = _balances[beneficiary].add(bonusTokens);
995     }
996 
997   }
998 
999 }