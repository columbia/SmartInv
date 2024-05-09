1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * @notice Renouncing to ownership will leave the contract without an owner.
49      * It will not be possible to call the functions with the `onlyOwner`
50      * modifier anymore.
51      */
52     function renounceOwnership() public onlyOwner {
53         emit OwnershipTransferred(_owner, address(0));
54         _owner = address(0);
55     }
56 
57     /**
58      * @dev Allows the current owner to transfer control of the contract to a newOwner.
59      * @param newOwner The address to transfer ownership to.
60      */
61     function transferOwnership(address newOwner) public onlyOwner {
62         _transferOwnership(newOwner);
63     }
64 
65     /**
66      * @dev Transfers control of the contract to a newOwner.
67      * @param newOwner The address to transfer ownership to.
68      */
69     function _transferOwnership(address newOwner) internal {
70         require(newOwner != address(0));
71         emit OwnershipTransferred(_owner, newOwner);
72         _owner = newOwner;
73     }
74 }
75 
76 // File: contracts/Whitelisted.sol
77 
78 contract Whitelisted is Ownable {
79 
80     mapping (address => uint16) public whitelist;
81     mapping (address => bool) public provider;
82 
83     // Only whitelisted
84     modifier onlyWhitelisted {
85       require(isWhitelisted(msg.sender));
86       _;
87     }
88 
89       modifier onlyProvider {
90         require(isProvider(msg.sender));
91         _;
92       }
93 
94       // Check if address is KYC provider
95       function isProvider(address _provider) public view returns (bool){
96         if (owner() == _provider){
97           return true;
98         }
99         return provider[_provider] == true ? true : false;
100       }
101       // Set new provider
102       function setProvider(address _provider) public onlyOwner {
103          provider[_provider] = true;
104       }
105       // Deactive current provider
106       function deactivateProvider(address _provider) public onlyOwner {
107          require(provider[_provider] == true);
108          provider[_provider] = false;
109       }
110       // Set purchaser to whitelist with zone code
111       function setWhitelisted(address _purchaser, uint16 _zone) public onlyProvider {
112          whitelist[_purchaser] = _zone;
113       }
114       // Delete purchaser from whitelist
115       function deleteFromWhitelist(address _purchaser) public onlyProvider {
116          whitelist[_purchaser] = 0;
117       }
118       // Get purchaser zone code
119       function getWhitelistedZone(address _purchaser) public view returns(uint16) {
120         return whitelist[_purchaser] > 0 ? whitelist[_purchaser] : 0;
121       }
122       // Check if purchaser is whitelisted : return true or false
123       function isWhitelisted(address _purchaser) public view returns (bool){
124         return whitelist[_purchaser] > 0;
125       }
126 }
127 
128 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
129 
130 /**
131  * @title SafeMath
132  * @dev Unsigned math operations with safety checks that revert on error
133  */
134 library SafeMath {
135     /**
136     * @dev Multiplies two unsigned integers, reverts on overflow.
137     */
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140         // benefit is lost if 'b' is also tested.
141         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b);
148 
149         return c;
150     }
151 
152     /**
153     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
154     */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
166     */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         require(b <= a);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175     * @dev Adds two unsigned integers, reverts on overflow.
176     */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a + b;
179         require(c >= a);
180 
181         return c;
182     }
183 
184     /**
185     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
186     * reverts when dividing by zero.
187     */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0);
190         return a % b;
191     }
192 }
193 
194 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
195 
196 /**
197  * @title ERC20 interface
198  * @dev see https://github.com/ethereum/EIPs/issues/20
199  */
200 interface IERC20 {
201     function transfer(address to, uint256 value) external returns (bool);
202 
203     function approve(address spender, uint256 value) external returns (bool);
204 
205     function transferFrom(address from, address to, uint256 value) external returns (bool);
206 
207     function totalSupply() external view returns (uint256);
208 
209     function balanceOf(address who) external view returns (uint256);
210 
211     function allowance(address owner, address spender) external view returns (uint256);
212 
213     event Transfer(address indexed from, address indexed to, uint256 value);
214 
215     event Approval(address indexed owner, address indexed spender, uint256 value);
216 }
217 
218 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
219 
220 /**
221  * @title SafeERC20
222  * @dev Wrappers around ERC20 operations that throw on failure.
223  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
224  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
225  */
226 library SafeERC20 {
227     using SafeMath for uint256;
228 
229     function safeTransfer(IERC20 token, address to, uint256 value) internal {
230         require(token.transfer(to, value));
231     }
232 
233     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
234         require(token.transferFrom(from, to, value));
235     }
236 
237     function safeApprove(IERC20 token, address spender, uint256 value) internal {
238         // safeApprove should only be called when setting an initial allowance,
239         // or when resetting it to zero. To increase and decrease it, use
240         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
241         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
242         require(token.approve(spender, value));
243     }
244 
245     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
246         uint256 newAllowance = token.allowance(address(this), spender).add(value);
247         require(token.approve(spender, newAllowance));
248     }
249 
250     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
251         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
252         require(token.approve(spender, newAllowance));
253     }
254 }
255 
256 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
257 
258 /**
259  * @title Helps contracts guard against reentrancy attacks.
260  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
261  * @dev If you mark a function `nonReentrant`, you should also
262  * mark it `external`.
263  */
264 contract ReentrancyGuard {
265     /// @dev counter to allow mutex lock with only one SSTORE operation
266     uint256 private _guardCounter;
267 
268     constructor () internal {
269         // The counter starts at one to prevent changing it from zero to a non-zero
270         // value, which is a more expensive operation.
271         _guardCounter = 1;
272     }
273 
274     /**
275      * @dev Prevents a contract from calling itself, directly or indirectly.
276      * Calling a `nonReentrant` function from another `nonReentrant`
277      * function is not supported. It is possible to prevent this from happening
278      * by making the `nonReentrant` function external, and make it call a
279      * `private` function that does the actual work.
280      */
281     modifier nonReentrant() {
282         _guardCounter += 1;
283         uint256 localCounter = _guardCounter;
284         _;
285         require(localCounter == _guardCounter);
286     }
287 }
288 
289 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
290 
291 /**
292  * @title Crowdsale
293  * @dev Crowdsale is a base contract for managing a token crowdsale,
294  * allowing investors to purchase tokens with ether. This contract implements
295  * such functionality in its most fundamental form and can be extended to provide additional
296  * functionality and/or custom behavior.
297  * The external interface represents the basic interface for purchasing tokens, and conform
298  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
299  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
300  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
301  * behavior.
302  */
303 contract Crowdsale is ReentrancyGuard {
304     using SafeMath for uint256;
305     using SafeERC20 for IERC20;
306 
307     // The token being sold
308     IERC20 private _token;
309 
310     // Address where funds are collected
311     address payable private _wallet;
312 
313     // How many token units a buyer gets per wei.
314     // The rate is the conversion between wei and the smallest and indivisible token unit.
315     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
316     // 1 wei will give you 1 unit, or 0.001 TOK.
317     uint256 private _rate;
318 
319     // Amount of wei raised
320     uint256 private _weiRaised;
321 
322     /**
323      * Event for token purchase logging
324      * @param purchaser who paid for the tokens
325      * @param beneficiary who got the tokens
326      * @param value weis paid for purchase
327      * @param amount amount of tokens purchased
328      */
329     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
330 
331     /**
332      * @param rate Number of token units a buyer gets per wei
333      * @dev The rate is the conversion between wei and the smallest and indivisible
334      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
335      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
336      * @param wallet Address where collected funds will be forwarded to
337      * @param token Address of the token being sold
338      */
339     constructor (uint256 rate, address payable wallet, IERC20 token) public {
340         require(rate > 0);
341         require(wallet != address(0));
342         require(address(token) != address(0));
343 
344         _rate = rate;
345         _wallet = wallet;
346         _token = token;
347     }
348 
349     /**
350      * @dev fallback function ***DO NOT OVERRIDE***
351      * Note that other contracts will transfer fund with a base gas stipend
352      * of 2300, which is not enough to call buyTokens. Consider calling
353      * buyTokens directly when purchasing tokens from a contract.
354      */
355     function () external payable {
356         buyTokens(msg.sender);
357     }
358 
359     /**
360      * @return the token being sold.
361      */
362     function token() public view returns (IERC20) {
363         return _token;
364     }
365 
366     /**
367      * @return the address where funds are collected.
368      */
369     function wallet() public view returns (address payable) {
370         return _wallet;
371     }
372 
373     /**
374      * @return the number of token units a buyer gets per wei.
375      */
376     function rate() public view returns (uint256) {
377         return _rate;
378     }
379 
380     /**
381      * @return the amount of wei raised.
382      */
383     function weiRaised() public view returns (uint256) {
384         return _weiRaised;
385     }
386 
387     /**
388      * @dev low level token purchase ***DO NOT OVERRIDE***
389      * This function has a non-reentrancy guard, so it shouldn't be called by
390      * another `nonReentrant` function.
391      * @param beneficiary Recipient of the token purchase
392      */
393     function buyTokens(address beneficiary) public nonReentrant payable {
394         uint256 weiAmount = msg.value;
395         _preValidatePurchase(beneficiary, weiAmount);
396 
397         // calculate token amount to be created
398         uint256 tokens = _getTokenAmount(weiAmount);
399 
400         // update state
401         _weiRaised = _weiRaised.add(weiAmount);
402 
403         _processPurchase(beneficiary, tokens);
404         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
405 
406         _updatePurchasingState(beneficiary, weiAmount);
407 
408         _forwardFunds();
409         _postValidatePurchase(beneficiary, weiAmount);
410     }
411 
412     /**
413      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
414      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
415      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
416      *     super._preValidatePurchase(beneficiary, weiAmount);
417      *     require(weiRaised().add(weiAmount) <= cap);
418      * @param beneficiary Address performing the token purchase
419      * @param weiAmount Value in wei involved in the purchase
420      */
421     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
422         require(beneficiary != address(0));
423         require(weiAmount != 0);
424     }
425 
426     /**
427      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
428      * conditions are not met.
429      * @param beneficiary Address performing the token purchase
430      * @param weiAmount Value in wei involved in the purchase
431      */
432     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
433         // solhint-disable-previous-line no-empty-blocks
434     }
435 
436     /**
437      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
438      * its tokens.
439      * @param beneficiary Address performing the token purchase
440      * @param tokenAmount Number of tokens to be emitted
441      */
442     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
443         _token.safeTransfer(beneficiary, tokenAmount);
444     }
445 
446     /**
447      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
448      * tokens.
449      * @param beneficiary Address receiving the tokens
450      * @param tokenAmount Number of tokens to be purchased
451      */
452     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
453         _deliverTokens(beneficiary, tokenAmount);
454     }
455 
456     /**
457      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
458      * etc.)
459      * @param beneficiary Address receiving the tokens
460      * @param weiAmount Value in wei involved in the purchase
461      */
462     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
463         // solhint-disable-previous-line no-empty-blocks
464     }
465 
466     /**
467      * @dev Override to extend the way in which ether is converted to tokens.
468      * @param weiAmount Value in wei to be converted into tokens
469      * @return Number of tokens that can be purchased with the specified _weiAmount
470      */
471     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
472         return weiAmount.mul(_rate);
473     }
474 
475     /**
476      * @dev Determines how ETH is stored/forwarded on purchases.
477      */
478     function _forwardFunds() internal {
479         _wallet.transfer(msg.value);
480     }
481 }
482 
483 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
484 
485 /**
486  * @title TimedCrowdsale
487  * @dev Crowdsale accepting contributions only within a time frame.
488  */
489 contract TimedCrowdsale is Crowdsale {
490     using SafeMath for uint256;
491 
492     uint256 private _openingTime;
493     uint256 private _closingTime;
494 
495     /**
496      * @dev Reverts if not in crowdsale time range.
497      */
498     modifier onlyWhileOpen {
499         require(isOpen());
500         _;
501     }
502 
503     /**
504      * @dev Constructor, takes crowdsale opening and closing times.
505      * @param openingTime Crowdsale opening time
506      * @param closingTime Crowdsale closing time
507      */
508     constructor (uint256 openingTime, uint256 closingTime) public {
509         // solhint-disable-next-line not-rely-on-time
510         require(openingTime >= block.timestamp);
511         require(closingTime > openingTime);
512 
513         _openingTime = openingTime;
514         _closingTime = closingTime;
515     }
516 
517     /**
518      * @return the crowdsale opening time.
519      */
520     function openingTime() public view returns (uint256) {
521         return _openingTime;
522     }
523 
524     /**
525      * @return the crowdsale closing time.
526      */
527     function closingTime() public view returns (uint256) {
528         return _closingTime;
529     }
530 
531     /**
532      * @return true if the crowdsale is open, false otherwise.
533      */
534     function isOpen() public view returns (bool) {
535         // solhint-disable-next-line not-rely-on-time
536         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
537     }
538 
539     /**
540      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
541      * @return Whether crowdsale period has elapsed
542      */
543     function hasClosed() public view returns (bool) {
544         // solhint-disable-next-line not-rely-on-time
545         return block.timestamp > _closingTime;
546     }
547 
548     /**
549      * @dev Extend parent behavior requiring to be within contributing period
550      * @param beneficiary Token purchaser
551      * @param weiAmount Amount of wei contributed
552      */
553     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
554         super._preValidatePurchase(beneficiary, weiAmount);
555     }
556 }
557 
558 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
559 
560 /**
561  * @title PostDeliveryCrowdsale
562  * @dev Crowdsale that locks tokens from withdrawal until it ends.
563  */
564 contract PostDeliveryCrowdsale is TimedCrowdsale {
565     using SafeMath for uint256;
566 
567     mapping(address => uint256) private _balances;
568 
569     /**
570      * @dev Withdraw tokens only after crowdsale ends.
571      * @param beneficiary Whose tokens will be withdrawn.
572      */
573     function withdrawTokens(address beneficiary) public {
574         require(hasClosed());
575         uint256 amount = _balances[beneficiary];
576         require(amount > 0);
577         _balances[beneficiary] = 0;
578         _deliverTokens(beneficiary, amount);
579     }
580 
581     /**
582      * @return the balance of an account.
583      */
584     function balanceOf(address account) public view returns (uint256) {
585         return _balances[account];
586     }
587 
588     /**
589      * @dev Overrides parent by storing balances instead of issuing tokens right away.
590      * @param beneficiary Token purchaser
591      * @param tokenAmount Amount of tokens purchased
592      */
593     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
594         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
595     }
596 
597 }
598 
599 // File: openzeppelin-solidity/contracts/math/Math.sol
600 
601 /**
602  * @title Math
603  * @dev Assorted math operations
604  */
605 library Math {
606     /**
607     * @dev Returns the largest of two numbers.
608     */
609     function max(uint256 a, uint256 b) internal pure returns (uint256) {
610         return a >= b ? a : b;
611     }
612 
613     /**
614     * @dev Returns the smallest of two numbers.
615     */
616     function min(uint256 a, uint256 b) internal pure returns (uint256) {
617         return a < b ? a : b;
618     }
619 
620     /**
621     * @dev Calculates the average of two numbers. Since these are integers,
622     * averages of an even and odd number cannot be represented, and will be
623     * rounded down.
624     */
625     function average(uint256 a, uint256 b) internal pure returns (uint256) {
626         // (a + b) / 2 can overflow, so we distribute
627         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
628     }
629 }
630 
631 // File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
632 
633 /**
634  * @title AllowanceCrowdsale
635  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
636  */
637 contract AllowanceCrowdsale is Crowdsale {
638     using SafeMath for uint256;
639     using SafeERC20 for IERC20;
640 
641     address private _tokenWallet;
642 
643     /**
644      * @dev Constructor, takes token wallet address.
645      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
646      */
647     constructor (address tokenWallet) public {
648         require(tokenWallet != address(0));
649         _tokenWallet = tokenWallet;
650     }
651 
652     /**
653      * @return the address of the wallet that will hold the tokens.
654      */
655     function tokenWallet() public view returns (address) {
656         return _tokenWallet;
657     }
658 
659     /**
660      * @dev Checks the amount of tokens left in the allowance.
661      * @return Amount of tokens left in the allowance
662      */
663     function remainingTokens() public view returns (uint256) {
664         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
665     }
666 
667     /**
668      * @dev Overrides parent behavior by transferring tokens from wallet.
669      * @param beneficiary Token purchaser
670      * @param tokenAmount Amount of tokens purchased
671      */
672     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
673         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
674     }
675 }
676 
677 // File: contracts/MocoCrowdsale.sol
678 
679 contract MocoCrowdsale is TimedCrowdsale, AllowanceCrowdsale, Whitelisted {
680   // Amount of wei raised
681 
682   uint256 public bonusPeriod;
683 
684   uint256 public bonusAmount;
685   // Unlock period 1 - 6 month
686   uint256 private _unlock1;
687 
688   // Unlock period 2 - 12 month
689   uint256 private _unlock2;
690 
691   // Specify locked zone for 2nd period
692   uint8 private _lockedZone;
693 
694   // Total tokens distributed
695   uint256 private _totalTokensDistributed;
696 
697 
698   // Total tokens locked
699   uint256 private _totalTokensLocked;
700 
701 
702   event TokensPurchased(
703     address indexed purchaser,
704     address indexed beneficiary,
705     address asset,
706     uint256 value,
707     uint256 amount
708   );
709 
710   struct Asset {
711     uint256 weiRaised;
712     uint256 minAmount;
713     uint256 rate;
714     bool active;
715   }
716 
717   mapping (address => Asset) private asset;
718   mapping (address => uint256) private _balances;
719 
720 
721   constructor(
722     uint256 _openingTime,
723     uint256 _closingTime,
724     uint256 _unlockPeriod1,
725     uint256 _unlockPeriod2,
726     uint256 _bonusPeriodEnd,
727     uint256 _bonusAmount,
728     uint256 _rate,
729     address payable _wallet,
730     IERC20 _token,
731     address _tokenWallet
732   ) public
733   TimedCrowdsale(_openingTime, _closingTime)
734   Crowdsale(_rate, _wallet, _token)
735   AllowanceCrowdsale(_tokenWallet){
736        _unlock1 = _unlockPeriod1;
737        _unlock2 = _unlockPeriod2;
738        bonusPeriod = _bonusPeriodEnd;
739       bonusAmount  = _bonusAmount;
740       asset[address(0)].rate  = _rate;
741   }
742   function getAssetRaised(address _assetAddress) public view returns(uint256) {
743       return asset[_assetAddress].weiRaised;
744   }
745   function getAssetMinAmount(address _assetAddress) public view returns(uint256) {
746       return asset[_assetAddress].minAmount;
747   }
748   function getAssetRate(address _assetAddress) public view returns(uint256) {
749       return asset[_assetAddress].rate;
750   }
751   function isAssetActive(address _assetAddress) public view returns(bool) {
752       return asset[_assetAddress].active == true ? true : false;
753   }
754   // Add asset
755   function setAsset(address _assetAddress, uint256 _weiRaised, uint256 _minAmount, uint256 _rate) public onlyOwner {
756       asset[_assetAddress].weiRaised = _weiRaised;
757       asset[_assetAddress].minAmount = _minAmount;
758       asset[_assetAddress].rate = _rate;
759       asset[_assetAddress].active = true;
760   }
761 
762   //
763 
764   function weiRaised(address _asset) public view returns (uint256) {
765     return asset[_asset].weiRaised;
766   }
767   function _getTokenAmount(uint256 weiAmount, address asst)
768     internal view returns (uint256)
769   {
770     return weiAmount.mul(asset[asst].rate);
771   }
772 
773   function minAmount(address _asset) public view returns (uint256) {
774     return asset[_asset].minAmount;
775   }
776 
777   // Buy Tokens
778   function buyTokens(address beneficiary) public onlyWhitelisted payable {
779     uint256 weiAmount = msg.value;
780     _preValidatePurchase(beneficiary, weiAmount, address(0));
781 
782     // calculate token amount to be created
783     uint256 tokens = _getTokenAmount(weiAmount, address(0));
784 
785     // update state
786     asset[address(0)].weiRaised = asset[address(0)].weiRaised.add(weiAmount);
787 
788     _processPurchase(beneficiary, tokens);
789 
790     emit TokensPurchased(
791       msg.sender,
792       beneficiary,
793       address(0),
794       weiAmount,
795       tokens
796     );
797 
798     // super._updatePurchasingState(beneficiary, weiAmount);
799 
800     super._forwardFunds();
801     // super._postValidatePurchase(beneficiary, weiAmount);
802   }
803   // Buy tokens for assets
804   function buyTokensAsset(address beneficiary, address asst, uint256 amount) public onlyWhitelisted {
805      require(isAssetActive(asst));
806     _preValidatePurchase(beneficiary, amount, asst);
807 
808     // calculate token amount to be created
809     uint256 tokens = _getTokenAmount(amount, asst);
810 
811     // update state
812     asset[asst].weiRaised = asset[asst].weiRaised.add(amount);
813 
814     _processPurchase(beneficiary, tokens);
815 
816     emit TokensPurchased(
817       msg.sender,
818       beneficiary,
819       asst,
820       amount,
821       tokens
822     );
823 
824      address _wallet  = wallet();
825      IERC20(asst).safeTransferFrom(beneficiary, _wallet, amount);
826 
827     // super._postValidatePurchase(beneficiary, weiAmount);
828   }
829 
830   // Check if locked is end
831   function lockedHasEnd() public view returns (bool) {
832     return block.timestamp > _unlock1 ? true : false;
833   }
834   // Check if locked is end
835   function lockedTwoHasEnd() public view returns (bool) {
836     return block.timestamp > _unlock2 ? true : false;
837   }
838 // Withdraw tokens after locked period is finished
839   function withdrawTokens(address beneficiary) public {
840     require(lockedHasEnd());
841     uint256 amount = _balances[beneficiary];
842     require(amount > 0);
843     uint256 zone = super.getWhitelistedZone(beneficiary);
844     if (zone == 840){
845       // require(lockedTwoHasEnd());
846       if(lockedTwoHasEnd()){
847         _balances[beneficiary] = 0;
848         _deliverTokens(beneficiary, amount);
849       }
850     } else {
851     _balances[beneficiary] = 0;
852     _deliverTokens(beneficiary, amount);
853     }
854   }
855 
856   // Locked tokens balance
857   function balanceOf(address account) public view returns(uint256) {
858     return _balances[account];
859   }
860   // Pre validation token buy
861   function _preValidatePurchase(
862     address beneficiary,
863     uint256 weiAmount,
864     address asst
865   )
866     internal
867     view
868   {
869     require(beneficiary != address(0));
870     require(weiAmount != 0);
871     require(weiAmount >= minAmount(asst));
872 }
873   function getBonusAmount(uint256 _tokenAmount) public view returns(uint256) {
874     return block.timestamp < bonusPeriod ? _tokenAmount.div(bonusAmount) : 0;
875   }
876 
877   function calculateTokens(uint256 _weiAmount) public view returns(uint256) {
878     uint256 tokens  = _getTokenAmount(_weiAmount);
879     return  tokens + getBonusAmount(tokens);
880   }
881   function lockedTokens(address beneficiary, uint256 tokenAmount) public onlyOwner returns(bool) {
882     _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
883     return true;
884   }
885   function _processPurchase(
886     address beneficiary,
887     uint256 tokenAmount
888   )
889     internal
890   {
891     uint256 zone = super.getWhitelistedZone(beneficiary);
892    uint256 bonusTokens = getBonusAmount(tokenAmount);
893     if (zone == 840){
894       uint256 totalTokens = bonusTokens.add(tokenAmount);
895       _balances[beneficiary] = _balances[beneficiary].add(totalTokens);
896     }
897     else {
898       super._deliverTokens(beneficiary, tokenAmount);
899       _balances[beneficiary] = _balances[beneficiary].add(bonusTokens);
900     }
901 
902   }
903 
904 }