1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * @notice Renouncing to ownership will leave the contract without an owner.
115      * It will not be possible to call the functions with the `onlyOwner`
116      * modifier anymore.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 // File: contracts/Referral.sol
143 
144 contract Referral is Ownable {
145 
146     using SafeMath for uint256;
147 
148     uint32 private managerTokenReward;
149     uint32 private managerEthReward;
150     uint32 private managerCustomerReward;
151     uint32 private referralTokenReward;
152     uint32 private referralCustomerReward;
153 
154     function setManagerReward(uint32 tokenReward, uint32 ethReward, uint32 customerReward) public onlyOwner returns(bool){
155       managerTokenReward = tokenReward;
156       managerEthReward = ethReward;
157       managerCustomerReward = customerReward;
158       return true;
159     }
160     function setReferralReward(uint32 tokenReward, uint32 customerReward) public onlyOwner returns(bool){
161       referralTokenReward = tokenReward;
162       referralCustomerReward = customerReward;
163       return true;
164     }
165     function getManagerTokenReward() public view returns (uint32){
166       return managerTokenReward;
167     }
168     function getManagerEthReward() public view returns (uint32){
169       return managerEthReward;
170     }
171     function getManagerCustomerReward() public view returns (uint32){
172       return managerCustomerReward;
173     }
174     function getReferralTokenReward() public view returns (uint32){
175       return referralTokenReward;
176     }
177     function getReferralCustomerReward() public view returns (uint32){
178       return referralCustomerReward;
179     }
180     function getCustomerReward(address referral, uint256 amount, bool isSalesManager) public view returns (uint256){
181       uint256 reward = 0;
182       if (isSalesManager){
183         reward = amount.mul(managerCustomerReward).div(1000);
184       } else {
185         reward = amount.mul(referralCustomerReward).div(1000);
186       }
187       return reward;
188     }
189     function getEthReward(uint256 amount) public view returns (uint256){
190         uint256 reward = amount.mul(managerEthReward).div(1000);
191         return reward;
192     }
193     function getTokenReward(address referral, uint256 amount, bool isSalesManager) public view returns (uint256){
194       uint256 reward = 0;
195       if (isSalesManager){
196         reward = amount.mul(managerTokenReward).div(1000);
197       } else {
198         reward = amount.mul(referralTokenReward).div(1000);
199       }
200       return reward;
201     }
202 }
203 
204 // File: contracts/Whitelisted.sol
205 
206 contract Whitelisted is Ownable {
207 
208       mapping (address => uint16) public whitelist;
209       mapping (address => bool) public provider;
210       mapping (address => bool) public salesManager;
211 
212       // Only whitelisted
213       modifier onlyWhitelisted {
214         require(isWhitelisted(msg.sender));
215         _;
216       }
217 
218       modifier onlyProvider {
219         require(isProvider(msg.sender));
220         _;
221       }
222 
223       // Check if address is KYC provider
224       function isProvider(address _provider) public view returns (bool){
225         if (owner() == _provider){
226           return true;
227         }
228         return provider[_provider] == true ? true : false;
229       }
230       // Check if address is Sales manager
231       function isSalesManager(address _manager) public view returns (bool){
232         if (owner() == _manager){
233           return true;
234         }
235         return salesManager[_manager] == true ? true : false;
236       }
237       // Set new provider
238       function setProvider(address _provider) public onlyOwner {
239          provider[_provider] = true;
240       }
241       // Deactive current provider
242       function deactivateProvider(address _provider) public onlyOwner {
243          require(provider[_provider] == true);
244          provider[_provider] = false;
245       }
246       // Set new provider
247       function setSalesManager(address _manager) public onlyOwner {
248          salesManager[_manager] = true;
249       }
250       // Deactive current provider
251       function deactivateSalesManager(address _manager) public onlyOwner {
252          require(salesManager[_manager] == true);
253          salesManager[_manager] = false;
254       }
255       // Set purchaser to whitelist with zone code
256       function setWhitelisted(address _purchaser, uint16 _zone) public onlyProvider {
257          whitelist[_purchaser] = _zone;
258       }
259       // Delete purchaser from whitelist
260       function deleteFromWhitelist(address _purchaser) public onlyProvider {
261          whitelist[_purchaser] = 0;
262       }
263       // Get purchaser zone code
264       function getWhitelistedZone(address _purchaser) public view returns(uint16) {
265         return whitelist[_purchaser] > 0 ? whitelist[_purchaser] : 0;
266       }
267       // Check if purchaser is whitelisted : return true or false
268       function isWhitelisted(address _purchaser) public view returns (bool){
269         return whitelist[_purchaser] > 0;
270       }
271 }
272 
273 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
274 
275 /**
276  * @title ERC20 interface
277  * @dev see https://github.com/ethereum/EIPs/issues/20
278  */
279 interface IERC20 {
280     function transfer(address to, uint256 value) external returns (bool);
281 
282     function approve(address spender, uint256 value) external returns (bool);
283 
284     function transferFrom(address from, address to, uint256 value) external returns (bool);
285 
286     function totalSupply() external view returns (uint256);
287 
288     function balanceOf(address who) external view returns (uint256);
289 
290     function allowance(address owner, address spender) external view returns (uint256);
291 
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 
297 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
298 
299 /**
300  * @title SafeERC20
301  * @dev Wrappers around ERC20 operations that throw on failure.
302  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
303  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
304  */
305 library SafeERC20 {
306     using SafeMath for uint256;
307 
308     function safeTransfer(IERC20 token, address to, uint256 value) internal {
309         require(token.transfer(to, value));
310     }
311 
312     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
313         require(token.transferFrom(from, to, value));
314     }
315 
316     function safeApprove(IERC20 token, address spender, uint256 value) internal {
317         // safeApprove should only be called when setting an initial allowance,
318         // or when resetting it to zero. To increase and decrease it, use
319         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
320         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
321         require(token.approve(spender, value));
322     }
323 
324     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).add(value);
326         require(token.approve(spender, newAllowance));
327     }
328 
329     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
331         require(token.approve(spender, newAllowance));
332     }
333 }
334 
335 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
336 
337 /**
338  * @title Helps contracts guard against reentrancy attacks.
339  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
340  * @dev If you mark a function `nonReentrant`, you should also
341  * mark it `external`.
342  */
343 contract ReentrancyGuard {
344     /// @dev counter to allow mutex lock with only one SSTORE operation
345     uint256 private _guardCounter;
346 
347     constructor () internal {
348         // The counter starts at one to prevent changing it from zero to a non-zero
349         // value, which is a more expensive operation.
350         _guardCounter = 1;
351     }
352 
353     /**
354      * @dev Prevents a contract from calling itself, directly or indirectly.
355      * Calling a `nonReentrant` function from another `nonReentrant`
356      * function is not supported. It is possible to prevent this from happening
357      * by making the `nonReentrant` function external, and make it call a
358      * `private` function that does the actual work.
359      */
360     modifier nonReentrant() {
361         _guardCounter += 1;
362         uint256 localCounter = _guardCounter;
363         _;
364         require(localCounter == _guardCounter);
365     }
366 }
367 
368 // File: openzeppelin-solidity/contracts/crowdsale/Crowdsale.sol
369 
370 /**
371  * @title Crowdsale
372  * @dev Crowdsale is a base contract for managing a token crowdsale,
373  * allowing investors to purchase tokens with ether. This contract implements
374  * such functionality in its most fundamental form and can be extended to provide additional
375  * functionality and/or custom behavior.
376  * The external interface represents the basic interface for purchasing tokens, and conform
377  * the base architecture for crowdsales. They are *not* intended to be modified / overridden.
378  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
379  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
380  * behavior.
381  */
382 contract Crowdsale is ReentrancyGuard {
383     using SafeMath for uint256;
384     using SafeERC20 for IERC20;
385 
386     // The token being sold
387     IERC20 private _token;
388 
389     // Address where funds are collected
390     address payable private _wallet;
391 
392     // How many token units a buyer gets per wei.
393     // The rate is the conversion between wei and the smallest and indivisible token unit.
394     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
395     // 1 wei will give you 1 unit, or 0.001 TOK.
396     uint256 private _rate;
397 
398     // Amount of wei raised
399     uint256 private _weiRaised;
400 
401     /**
402      * Event for token purchase logging
403      * @param purchaser who paid for the tokens
404      * @param beneficiary who got the tokens
405      * @param value weis paid for purchase
406      * @param amount amount of tokens purchased
407      */
408     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
409 
410     /**
411      * @param rate Number of token units a buyer gets per wei
412      * @dev The rate is the conversion between wei and the smallest and indivisible
413      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
414      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
415      * @param wallet Address where collected funds will be forwarded to
416      * @param token Address of the token being sold
417      */
418     constructor (uint256 rate, address payable wallet, IERC20 token) public {
419         require(rate > 0);
420         require(wallet != address(0));
421         require(address(token) != address(0));
422 
423         _rate = rate;
424         _wallet = wallet;
425         _token = token;
426     }
427 
428     /**
429      * @dev fallback function ***DO NOT OVERRIDE***
430      * Note that other contracts will transfer fund with a base gas stipend
431      * of 2300, which is not enough to call buyTokens. Consider calling
432      * buyTokens directly when purchasing tokens from a contract.
433      */
434     // function () external payable {
435     //     buyTokens(msg.sender);
436     // }
437 
438     /**
439      * @return the token being sold.
440      */
441     function token() public view returns (IERC20) {
442         return _token;
443     }
444 
445     /**
446      * @return the address where funds are collected.
447      */
448     function wallet() public view returns (address payable) {
449         return _wallet;
450     }
451 
452     /**
453      * @return the number of token units a buyer gets per wei.
454      */
455     function rate() public view returns (uint256) {
456         return _rate;
457     }
458 
459     /**
460      * @return the amount of wei raised.
461      */
462     function weiRaised() public view returns (uint256) {
463         return _weiRaised;
464     }
465 
466     /**
467      * @dev low level token purchase ***DO NOT OVERRIDE***
468      * This function has a non-reentrancy guard, so it shouldn't be called by
469      * another `nonReentrant` function.
470      * @param beneficiary Recipient of the token purchase
471      */
472     function buyTokens(address beneficiary, address payable referral) public nonReentrant payable {
473         uint256 weiAmount = msg.value;
474         _preValidatePurchase(beneficiary, weiAmount);
475 
476         // calculate token amount to be created
477         uint256 tokens = _getTokenAmount(weiAmount);
478 
479         // update state
480         _weiRaised = _weiRaised.add(weiAmount);
481 
482         _processPurchase(beneficiary, tokens);
483         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
484 
485         _updatePurchasingState(beneficiary, weiAmount);
486 
487         _forwardFunds();
488         _postValidatePurchase(beneficiary, weiAmount);
489     }
490 
491     /**
492      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
493      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
494      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
495      *     super._preValidatePurchase(beneficiary, weiAmount);
496      *     require(weiRaised().add(weiAmount) <= cap);
497      * @param beneficiary Address performing the token purchase
498      * @param weiAmount Value in wei involved in the purchase
499      */
500     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
501         require(beneficiary != address(0));
502         require(weiAmount != 0);
503     }
504 
505     /**
506      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
507      * conditions are not met.
508      * @param beneficiary Address performing the token purchase
509      * @param weiAmount Value in wei involved in the purchase
510      */
511     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
512         // solhint-disable-previous-line no-empty-blocks
513     }
514 
515     /**
516      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
517      * its tokens.
518      * @param beneficiary Address performing the token purchase
519      * @param tokenAmount Number of tokens to be emitted
520      */
521     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
522         _token.safeTransfer(beneficiary, tokenAmount);
523     }
524     function _changeRate(uint256 rate) internal {
525       _rate = rate;
526     }
527     /**
528      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
529      * tokens.
530      * @param beneficiary Address receiving the tokens
531      * @param tokenAmount Number of tokens to be purchased
532      */
533     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
534         _deliverTokens(beneficiary, tokenAmount);
535     }
536 
537     /**
538      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
539      * etc.)
540      * @param beneficiary Address receiving the tokens
541      * @param weiAmount Value in wei involved in the purchase
542      */
543     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
544         // solhint-disable-previous-line no-empty-blocks
545     }
546 
547     /**
548      * @dev Override to extend the way in which ether is converted to tokens.
549      * @param weiAmount Value in wei to be converted into tokens
550      * @return Number of tokens that can be purchased with the specified _weiAmount
551      */
552     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
553         return weiAmount.mul(_rate);
554     }
555 
556     /**
557      * @dev Determines how ETH is stored/forwarded on purchases.
558      */
559     function _forwardFunds() internal {
560         _wallet.transfer(msg.value);
561     }
562 }
563 
564 // File: openzeppelin-solidity/contracts/crowdsale/validation/TimedCrowdsale.sol
565 
566 /**
567  * @title TimedCrowdsale
568  * @dev Crowdsale accepting contributions only within a time frame.
569  */
570 contract TimedCrowdsale is Crowdsale {
571     using SafeMath for uint256;
572 
573     uint256 private _openingTime;
574     uint256 private _closingTime;
575 
576     /**
577      * @dev Reverts if not in crowdsale time range.
578      */
579     modifier onlyWhileOpen {
580         require(isOpen());
581         _;
582     }
583 
584     /**
585      * @dev Constructor, takes crowdsale opening and closing times.
586      * @param openingTime Crowdsale opening time
587      * @param closingTime Crowdsale closing time
588      */
589     constructor (uint256 openingTime, uint256 closingTime) public {
590         // solhint-disable-next-line not-rely-on-time
591         // require(openingTime >= block.timestamp);
592         require(closingTime > openingTime);
593 
594         _openingTime = openingTime;
595         _closingTime = closingTime;
596     }
597 
598     /**
599      * @return the crowdsale opening time.
600      */
601     function openingTime() public view returns (uint256) {
602         return _openingTime;
603     }
604 
605     /**
606      * @return the crowdsale closing time.
607      */
608     function closingTime() public view returns (uint256) {
609         return _closingTime;
610     }
611 
612     /**
613      * @return true if the crowdsale is open, false otherwise.
614      */
615     function isOpen() public view returns (bool) {
616         // solhint-disable-next-line not-rely-on-time
617         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
618     }
619 
620     /**
621      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
622      * @return Whether crowdsale period has elapsed
623      */
624     function hasClosed() public view returns (bool) {
625         // solhint-disable-next-line not-rely-on-time
626         return block.timestamp > _closingTime;
627     }
628 
629     function _changeClosingTime(uint256 closingTime) internal {
630       _closingTime = closingTime;
631     }
632 
633     /**
634      * @dev Extend parent behavior requiring to be within contributing period
635      * @param beneficiary Token purchaser
636      * @param weiAmount Amount of wei contributed
637      */
638     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
639         super._preValidatePurchase(beneficiary, weiAmount);
640     }
641 }
642 
643 // File: openzeppelin-solidity/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol
644 
645 /**
646  * @title PostDeliveryCrowdsale
647  * @dev Crowdsale that locks tokens from withdrawal until it ends.
648  */
649 contract PostDeliveryCrowdsale is TimedCrowdsale {
650     using SafeMath for uint256;
651 
652     mapping(address => uint256) private _balances;
653 
654     /**
655      * @dev Withdraw tokens only after crowdsale ends.
656      * @param beneficiary Whose tokens will be withdrawn.
657      */
658     function withdrawTokens(address beneficiary) public {
659         require(hasClosed());
660         uint256 amount = _balances[beneficiary];
661         require(amount > 0);
662         _balances[beneficiary] = 0;
663         _deliverTokens(beneficiary, amount);
664     }
665 
666     /**
667      * @return the balance of an account.
668      */
669     function balanceOf(address account) public view returns (uint256) {
670         return _balances[account];
671     }
672 
673     /**
674      * @dev Overrides parent by storing balances instead of issuing tokens right away.
675      * @param beneficiary Token purchaser
676      * @param tokenAmount Amount of tokens purchased
677      */
678     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
679         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
680     }
681 
682 }
683 
684 // File: openzeppelin-solidity/contracts/math/Math.sol
685 
686 /**
687  * @title Math
688  * @dev Assorted math operations
689  */
690 library Math {
691     /**
692     * @dev Returns the largest of two numbers.
693     */
694     function max(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a >= b ? a : b;
696     }
697 
698     /**
699     * @dev Returns the smallest of two numbers.
700     */
701     function min(uint256 a, uint256 b) internal pure returns (uint256) {
702         return a < b ? a : b;
703     }
704 
705     /**
706     * @dev Calculates the average of two numbers. Since these are integers,
707     * averages of an even and odd number cannot be represented, and will be
708     * rounded down.
709     */
710     function average(uint256 a, uint256 b) internal pure returns (uint256) {
711         // (a + b) / 2 can overflow, so we distribute
712         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
713     }
714 }
715 
716 // File: openzeppelin-solidity/contracts/crowdsale/emission/AllowanceCrowdsale.sol
717 
718 /**
719  * @title AllowanceCrowdsale
720  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
721  */
722 contract AllowanceCrowdsale is Crowdsale {
723     using SafeMath for uint256;
724     using SafeERC20 for IERC20;
725 
726     address private _tokenWallet;
727 
728     /**
729      * @dev Constructor, takes token wallet address.
730      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale
731      */
732     constructor (address tokenWallet) public {
733         require(tokenWallet != address(0));
734         _tokenWallet = tokenWallet;
735     }
736 
737     /**
738      * @return the address of the wallet that will hold the tokens.
739      */
740     function tokenWallet() public view returns (address) {
741         return _tokenWallet;
742     }
743 
744     /**
745      * @dev Checks the amount of tokens left in the allowance.
746      * @return Amount of tokens left in the allowance
747      */
748     function remainingTokens() public view returns (uint256) {
749         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
750     }
751 
752     /**
753      * @dev Overrides parent behavior by transferring tokens from wallet.
754      * @param beneficiary Token purchaser
755      * @param tokenAmount Amount of tokens purchased
756      */
757     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
758         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
759     }
760 }
761 
762 // File: contracts/MocoCrowdsale.sol
763 
764 contract MocoCrowdsale is TimedCrowdsale, AllowanceCrowdsale, Whitelisted, Referral {
765   // Amount of wei raised
766 
767   uint256 public bonusPeriod;
768 
769   uint256 public bonusAmount;
770 
771   uint256 private _weiRaised;
772   uint256 private _weiRefRaised;
773   uint256 private _totalManagerRewards;
774 
775   uint256 private _minAmount;
776   // Unlock period 1 - 6 month
777   uint256 private _unlock1;
778 
779   // Unlock period 2 - 12 month
780   uint256 private _unlock2;
781 
782 
783   // Specify locked zone for 2nd period
784   uint8 private _lockedZone;
785 
786   // Total tokens distributed
787   uint256 private _totalTokensDistributed;
788 
789 
790   // Total tokens locked
791   uint256 private _totalTokensLocked;
792 
793 
794   event TokensPurchased(
795     address indexed purchaser,
796     address indexed beneficiary,
797     address indexed referral,
798     uint256 value,
799     uint256 amount,
800     uint256 valueReward,
801     uint256 tokenReward
802   );
803 
804   event LockTokens(
805     address indexed beneficiary,
806     uint256 tokenAmount
807   );
808 
809   mapping (address => uint256) private _balances;
810 
811   constructor(
812     uint256 _openingTime,
813     uint256 _closingTime,
814     uint256 _unlockPeriod1,
815     uint256 _unlockPeriod2,
816     uint256 _bonusPeriodEnd,
817     uint256 _bonusAmount,
818     uint256 rate,
819     uint256 minAmount,
820     address payable _wallet,
821     IERC20 _token,
822     address _tokenWallet
823   ) public
824   TimedCrowdsale(_openingTime, _closingTime)
825   Crowdsale(rate, _wallet, _token)
826   AllowanceCrowdsale(_tokenWallet){
827        _unlock1 = _unlockPeriod1;
828        _unlock2 = _unlockPeriod2;
829        bonusPeriod = _bonusPeriodEnd;
830       bonusAmount  = _bonusAmount;
831       _minAmount = minAmount;
832   }
833 
834   //
835 
836   function setMinAmount(uint256 minAmount) public onlyOwner returns (bool){
837     _minAmount = minAmount;
838     return true;
839   }
840 
841   function weiRaised() public view returns (uint256) {
842     return _weiRaised;
843   }
844   function weiRefRaised() public view returns (uint256) {
845     return _weiRefRaised;
846   }
847   function totalManagerRewards() public view returns (uint256) {
848     return _totalManagerRewards;
849   }
850   function changeRate(uint256 rate) public onlyOwner returns (bool){
851     super._changeRate(rate);
852     return true;
853   }
854   function changeClosingTime(uint256 closingTime) public onlyOwner returns (bool){
855     super._changeClosingTime(closingTime);
856   }
857   function _getTokenAmount(uint256 weiAmount)
858     internal view returns (uint256)
859   {
860     return weiAmount.mul(rate());
861   }
862 
863   function minAmount() public view returns (uint256) {
864     return _minAmount;
865   }
866 
867   // Buy Tokens
868   function buyTokens(address beneficiary, address payable referral) public onlyWhitelisted payable {
869     uint256 weiAmount = msg.value;
870     _preValidatePurchase(beneficiary, weiAmount);
871     // calculate token amount to be created
872     uint256 tokens = _getTokenAmount(weiAmount);
873     // update state
874 
875     _weiRaised = _weiRaised.add(weiAmount);
876     uint256 ethReward = 0;
877     uint256 tokenReward = 0;
878     uint256 customerReward = 0;
879     uint256 initTokens = tokens;
880 
881     if (beneficiary != referral && isWhitelisted(referral)){
882       customerReward = getCustomerReward(referral, tokens, isSalesManager(referral));
883 
884       if (isSalesManager(referral)){
885          ethReward = getEthReward(weiAmount);
886          _totalManagerRewards = _totalManagerRewards.add(ethReward);
887       }
888       tokenReward = getTokenReward(referral, initTokens, isSalesManager(referral));
889       _processReward(referral, ethReward, tokenReward);
890       _weiRefRaised = _weiRefRaised.add(weiAmount);
891 
892     }
893 
894     uint256 bonusTokens = getBonusAmount(initTokens);
895     bonusTokens = bonusTokens.add(customerReward);
896 
897     tokens = tokens.add(bonusTokens);
898     _processPurchase(beneficiary, initTokens, bonusTokens);
899 
900     emit TokensPurchased(
901       msg.sender,
902       beneficiary,
903       referral,
904       weiAmount,
905       tokens,
906       ethReward,
907       tokenReward
908     );
909 
910     uint256 weiForward = weiAmount.sub(ethReward);
911     wallet().transfer(weiForward);
912   }
913   function _processReward(
914     address payable referral,
915     uint256 weiAmount,
916     uint256 tokenAmount
917   )
918     internal
919   {
920       _balances[referral] = _balances[referral].add(tokenAmount);
921       emit LockTokens(referral, tokenAmount);
922       if (isSalesManager(referral) && weiAmount > 0){
923         referral.transfer(weiAmount);
924       }
925 
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
961     uint256 weiAmount
962   )
963     internal
964     view
965   {
966     require(beneficiary != address(0));
967     require(weiAmount >= minAmount());
968 }
969   function getBonusAmount(uint256 _tokenAmount) public view returns(uint256) {
970     return block.timestamp < bonusPeriod ? _tokenAmount.mul(bonusAmount).div(1000) : 0;
971   }
972 
973   function calculateTokens(uint256 _weiAmount) public view returns(uint256) {
974     uint256 tokens  = _getTokenAmount(_weiAmount);
975     return  tokens + getBonusAmount(tokens);
976   }
977   function lockedTokens(address beneficiary, uint256 tokenAmount) public onlyOwner returns(bool) {
978     _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
979     emit LockTokens(beneficiary, tokenAmount);
980     return true;
981   }
982   function _processPurchase(
983     address beneficiary,
984     uint256 tokenAmount,
985     uint256 bonusTokens
986   )
987     internal
988   {
989     uint256 zone = super.getWhitelistedZone(beneficiary);
990     if (zone == 840){
991       uint256 totalTokens = bonusTokens.add(tokenAmount);
992       _balances[beneficiary] = _balances[beneficiary].add(totalTokens);
993       emit LockTokens(beneficiary, tokenAmount);
994     }
995     else {
996       super._deliverTokens(beneficiary, tokenAmount);
997       _balances[beneficiary] = _balances[beneficiary].add(bonusTokens);
998       emit LockTokens(beneficiary, tokenAmount);
999     }
1000 
1001   }
1002 
1003 }