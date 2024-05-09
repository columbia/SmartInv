1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/utils/ReentrancyGuard.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  *
21  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
22  * metering changes introduced in the Istanbul hardfork.
23  */
24 contract ReentrancyGuard {
25     bool private _notEntered;
26 
27     constructor () internal {
28         // Storing an initial non-zero value makes deployment a bit more
29         // expensive, but in exchange the refund on every call to nonReentrant
30         // will be lower in amount. Since refunds are capped to a percetange of
31         // the total transaction's gas, it is best to keep them low in cases
32         // like this one, to increase the likelihood of the full refund coming
33         // into effect.
34         _notEntered = true;
35     }
36 
37     /**
38      * @dev Prevents a contract from calling itself, directly or indirectly.
39      * Calling a `nonReentrant` function from another `nonReentrant`
40      * function is not supported. It is possible to prevent this from happening
41      * by making the `nonReentrant` function external, and make it call a
42      * `private` function that does the actual work.
43      */
44     modifier nonReentrant() {
45         // On the first call to nonReentrant, _notEntered will be true
46         require(_notEntered, "ReentrancyGuard: reentrant call");
47 
48         // Any calls to nonReentrant after this point will fail
49         _notEntered = false;
50 
51         _;
52 
53         // By storing the original value once again, a refund is triggered (see
54         // https://eips.ethereum.org/EIPS/eip-2200)
55         _notEntered = true;
56     }
57 }
58 
59 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/GSN/Context.sol
60 
61 pragma solidity ^0.5.0;
62 
63 /*
64  * @dev Provides information about the current execution context, including the
65  * sender of the transaction and its data. While these are generally available
66  * via msg.sender and msg.data, they should not be accessed in such a direct
67  * manner, since when dealing with GSN meta-transactions the account sending and
68  * paying for execution may not be the actual sender (as far as an application
69  * is concerned).
70  *
71  * This contract is only required for intermediate, library-like contracts.
72  */
73 contract Context {
74     // Empty internal constructor, to prevent people from mistakenly deploying
75     // an instance of this contract, which should be used via inheritance.
76     constructor () internal { }
77     // solhint-disable-previous-line no-empty-blocks
78 
79     function _msgSender() internal view returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87 }
88 
89 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol
90 
91 pragma solidity ^0.5.0;
92 
93 /**
94  * @title Crowdsale
95  * @dev Crowdsale is a base contract for managing a token crowdsale,
96  * allowing investors to purchase tokens with ether. This contract implements
97  * such functionality in its most fundamental form and can be extended to provide additional
98  * functionality and/or custom behavior.
99  * The external interface represents the basic interface for purchasing tokens, and conforms
100  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
101  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
102  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
103  * behavior.
104  */
105 contract Crowdsale is Context, ReentrancyGuard {
106     using SafeMath for uint256;
107     using SafeERC20 for IERC20;
108 
109     // The token being sold
110     IERC20 private _token;
111 
112     // Address where funds are collected
113     address payable private _wallet;
114 
115     // How many token units a buyer gets per wei.
116     // The rate is the conversion between wei and the smallest and indivisible token unit.
117     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
118     // 1 wei will give you 1 unit, or 0.001 TOK.
119     uint256 private _rate;
120 
121     // Amount of wei raised
122     uint256 private _weiRaised;
123 
124     /**
125      * Event for token purchase logging
126      * @param purchaser who paid for the tokens
127      * @param beneficiary who got the tokens
128      * @param value weis paid for purchase
129      * @param amount amount of tokens purchased
130      */
131     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
132 
133     /**
134      * @param rate Number of token units a buyer gets per wei
135      * @dev The rate is the conversion between wei and the smallest and indivisible
136      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
137      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
138      * @param wallet Address where collected funds will be forwarded to
139      * @param token Address of the token being sold
140      */
141     constructor (uint256 rate, address payable wallet, IERC20 token) public {
142         require(rate > 0, "Crowdsale: rate is 0");
143         require(wallet != address(0), "Crowdsale: wallet is the zero address");
144         require(address(token) != address(0), "Crowdsale: token is the zero address");
145 
146         _rate = rate;
147         _wallet = wallet;
148         _token = token;
149     }
150 
151     /**
152      * @dev fallback function ***DO NOT OVERRIDE***
153      * Note that other contracts will transfer funds with a base gas stipend
154      * of 2300, which is not enough to call buyTokens. Consider calling
155      * buyTokens directly when purchasing tokens from a contract.
156      */
157     function () external payable {
158         buyTokens(_msgSender());
159     }
160 
161     /**
162      * @return the token being sold.
163      */
164     function token() public view returns (IERC20) {
165         return _token;
166     }
167 
168     /**
169      * @return the address where funds are collected.
170      */
171     function wallet() public view returns (address payable) {
172         return _wallet;
173     }
174 
175     /**
176      * @return the number of token units a buyer gets per wei.
177      */
178     function rate() public view returns (uint256) {
179         return _rate;
180     }
181 
182     /**
183      * @return the amount of wei raised.
184      */
185     function weiRaised() public view returns (uint256) {
186         return _weiRaised;
187     }
188 
189     /**
190      * @dev low level token purchase ***DO NOT OVERRIDE***
191      * This function has a non-reentrancy guard, so it shouldn't be called by
192      * another `nonReentrant` function.
193      * @param beneficiary Recipient of the token purchase
194      */
195     function buyTokens(address beneficiary) public nonReentrant payable {
196         uint256 weiAmount = msg.value;
197         _preValidatePurchase(beneficiary, weiAmount);
198 
199         // calculate token amount to be created
200         uint256 tokens = _getTokenAmount(weiAmount);
201 
202         // update state
203         _weiRaised = _weiRaised.add(weiAmount);
204 
205         _processPurchase(beneficiary, tokens);
206         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
207 
208         _updatePurchasingState(beneficiary, weiAmount);
209 
210         _forwardFunds();
211         _postValidatePurchase(beneficiary, weiAmount);
212     }
213 
214     /**
215      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
216      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
217      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
218      *     super._preValidatePurchase(beneficiary, weiAmount);
219      *     require(weiRaised().add(weiAmount) <= cap);
220      * @param beneficiary Address performing the token purchase
221      * @param weiAmount Value in wei involved in the purchase
222      */
223     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
224         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
225         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
226         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
227     }
228 
229     /**
230      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
231      * conditions are not met.
232      * @param beneficiary Address performing the token purchase
233      * @param weiAmount Value in wei involved in the purchase
234      */
235     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
236         // solhint-disable-previous-line no-empty-blocks
237     }
238 
239     /**
240      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
241      * its tokens.
242      * @param beneficiary Address performing the token purchase
243      * @param tokenAmount Number of tokens to be emitted
244      */
245     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
246         _token.safeTransfer(beneficiary, tokenAmount);
247     }
248 
249     /**
250      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
251      * tokens.
252      * @param beneficiary Address receiving the tokens
253      * @param tokenAmount Number of tokens to be purchased
254      */
255     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
256         _deliverTokens(beneficiary, tokenAmount);
257     }
258 
259     /**
260      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
261      * etc.)
262      * @param beneficiary Address receiving the tokens
263      * @param weiAmount Value in wei involved in the purchase
264      */
265     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
266         // solhint-disable-previous-line no-empty-blocks
267     }
268 
269     /**
270      * @dev Override to extend the way in which ether is converted to tokens.
271      * @param weiAmount Value in wei to be converted into tokens
272      * @return Number of tokens that can be purchased with the specified _weiAmount
273      */
274     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
275         return weiAmount.mul(_rate);
276     }
277 
278     /**
279      * @dev Determines how ETH is stored/forwarded on purchases.
280      */
281     function _forwardFunds() internal {
282         _wallet.transfer(msg.value);
283     }
284 }
285 
286 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/Math.sol
287 
288 pragma solidity ^0.5.0;
289 
290 /**
291  * @dev Standard math utilities missing in the Solidity language.
292  */
293 library Math {
294     /**
295      * @dev Returns the largest of two numbers.
296      */
297     function max(uint256 a, uint256 b) internal pure returns (uint256) {
298         return a >= b ? a : b;
299     }
300 
301     /**
302      * @dev Returns the smallest of two numbers.
303      */
304     function min(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a < b ? a : b;
306     }
307 
308     /**
309      * @dev Returns the average of two numbers. The result is rounded towards
310      * zero.
311      */
312     function average(uint256 a, uint256 b) internal pure returns (uint256) {
313         // (a + b) / 2 can overflow, so we distribute
314         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
315     }
316 }
317 
318 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/AllowanceCrowdsale.sol
319 
320 pragma solidity ^0.5.0;
321 
322 /**
323  * @title AllowanceCrowdsale
324  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
325  */
326 contract AllowanceCrowdsale is Crowdsale {
327     using SafeMath for uint256;
328     using SafeERC20 for IERC20;
329 
330     address private _tokenWallet;
331 
332     /**
333      * @dev Constructor, takes token wallet address.
334      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
335      */
336     constructor (address tokenWallet) public {
337         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
338         _tokenWallet = tokenWallet;
339     }
340 
341     /**
342      * @return the address of the wallet that will hold the tokens.
343      */
344     function tokenWallet() public view returns (address) {
345         return _tokenWallet;
346     }
347 
348     /**
349      * @dev Checks the amount of tokens left in the allowance.
350      * @return Amount of tokens left in the allowance
351      */
352     function remainingTokens() public view returns (uint256) {
353         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
354     }
355 
356     /**
357      * @dev Overrides parent behavior by transferring tokens from wallet.
358      * @param beneficiary Token purchaser
359      * @param tokenAmount Amount of tokens purchased
360      */
361     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
362         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
363     }
364 }
365 
366 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/utils/Address.sol
367 
368 pragma solidity ^0.5.5;
369 
370 /**
371  * @dev Collection of functions related to the address type
372  */
373 library Address {
374     /**
375      * @dev Returns true if `account` is a contract.
376      *
377      * [IMPORTANT]
378      * ====
379      * It is unsafe to assume that an address for which this function returns
380      * false is an externally-owned account (EOA) and not a contract.
381      *
382      * Among others, `isContract` will return false for the following
383      * types of addresses:
384      *
385      *  - an externally-owned account
386      *  - a contract in construction
387      *  - an address where a contract will be created
388      *  - an address where a contract lived, but was destroyed
389      * ====
390      */
391     function isContract(address account) internal view returns (bool) {
392         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
393         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
394         // for accounts without code, i.e. `keccak256('')`
395         bytes32 codehash;
396         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
397         // solhint-disable-next-line no-inline-assembly
398         assembly { codehash := extcodehash(account) }
399         return (codehash != accountHash && codehash != 0x0);
400     }
401 
402     /**
403      * @dev Converts an `address` into `address payable`. Note that this is
404      * simply a type cast: the actual underlying value is not changed.
405      *
406      * _Available since v2.4.0._
407      */
408     function toPayable(address account) internal pure returns (address payable) {
409         return address(uint160(account));
410     }
411 
412     /**
413      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
414      * `recipient`, forwarding all available gas and reverting on errors.
415      *
416      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
417      * of certain opcodes, possibly making contracts go over the 2300 gas limit
418      * imposed by `transfer`, making them unable to receive funds via
419      * `transfer`. {sendValue} removes this limitation.
420      *
421      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
422      *
423      * IMPORTANT: because control is transferred to `recipient`, care must be
424      * taken to not create reentrancy vulnerabilities. Consider using
425      * {ReentrancyGuard} or the
426      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
427      *
428      * _Available since v2.4.0._
429      */
430     function sendValue(address payable recipient, uint256 amount) internal {
431         require(address(this).balance >= amount, "Address: insufficient balance");
432 
433         // solhint-disable-next-line avoid-call-value
434         (bool success, ) = recipient.call.value(amount)("");
435         require(success, "Address: unable to send value, recipient may have reverted");
436     }
437 }
438 
439 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/SafeERC20.sol
440 
441 pragma solidity ^0.5.0;
442 
443 /**
444  * @title SafeERC20
445  * @dev Wrappers around ERC20 operations that throw on failure (when the token
446  * contract returns false). Tokens that return no value (and instead revert or
447  * throw on failure) are also supported, non-reverting calls are assumed to be
448  * successful.
449  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
450  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
451  */
452 library SafeERC20 {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     function safeTransfer(IERC20 token, address to, uint256 value) internal {
457         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
458     }
459 
460     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
461         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
462     }
463 
464     function safeApprove(IERC20 token, address spender, uint256 value) internal {
465         // safeApprove should only be called when setting an initial allowance,
466         // or when resetting it to zero. To increase and decrease it, use
467         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
468         // solhint-disable-next-line max-line-length
469         require((value == 0) || (token.allowance(address(this), spender) == 0),
470             "SafeERC20: approve from non-zero to non-zero allowance"
471         );
472         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
473     }
474 
475     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
476         uint256 newAllowance = token.allowance(address(this), spender).add(value);
477         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
478     }
479 
480     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
481         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
482         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
483     }
484 
485     /**
486      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
487      * on the return value: the return value is optional (but if data is returned, it must not be false).
488      * @param token The token targeted by the call.
489      * @param data The call data (encoded using abi.encode or one of its variants).
490      */
491     function callOptionalReturn(IERC20 token, bytes memory data) private {
492         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
493         // we're implementing it ourselves.
494 
495         // A Solidity high level call has three parts:
496         //  1. The target address is checked to verify it contains contract code
497         //  2. The call itself is made, and success asserted
498         //  3. The return value is decoded, which in turn checks the size of the returned data.
499         // solhint-disable-next-line max-line-length
500         require(address(token).isContract(), "SafeERC20: call to non-contract");
501 
502         // solhint-disable-next-line avoid-low-level-calls
503         (bool success, bytes memory returndata) = address(token).call(data);
504         require(success, "SafeERC20: low-level call failed");
505 
506         if (returndata.length > 0) { // Return data is optional
507             // solhint-disable-next-line max-line-length
508             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
509         }
510     }
511 }
512 
513 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/math/SafeMath.sol
514 
515 pragma solidity ^0.5.0;
516 
517 /**
518  * @dev Wrappers over Solidity's arithmetic operations with added overflow
519  * checks.
520  *
521  * Arithmetic operations in Solidity wrap on overflow. This can easily result
522  * in bugs, because programmers usually assume that an overflow raises an
523  * error, which is the standard behavior in high level programming languages.
524  * `SafeMath` restores this intuition by reverting the transaction when an
525  * operation overflows.
526  *
527  * Using this library instead of the unchecked operations eliminates an entire
528  * class of bugs, so it's recommended to use it always.
529  */
530 library SafeMath {
531     /**
532      * @dev Returns the addition of two unsigned integers, reverting on
533      * overflow.
534      *
535      * Counterpart to Solidity's `+` operator.
536      *
537      * Requirements:
538      * - Addition cannot overflow.
539      */
540     function add(uint256 a, uint256 b) internal pure returns (uint256) {
541         uint256 c = a + b;
542         require(c >= a, "SafeMath: addition overflow");
543 
544         return c;
545     }
546 
547     /**
548      * @dev Returns the subtraction of two unsigned integers, reverting on
549      * overflow (when the result is negative).
550      *
551      * Counterpart to Solidity's `-` operator.
552      *
553      * Requirements:
554      * - Subtraction cannot overflow.
555      */
556     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
557         return sub(a, b, "SafeMath: subtraction overflow");
558     }
559 
560     /**
561      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
562      * overflow (when the result is negative).
563      *
564      * Counterpart to Solidity's `-` operator.
565      *
566      * Requirements:
567      * - Subtraction cannot overflow.
568      *
569      * _Available since v2.4.0._
570      */
571     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b <= a, errorMessage);
573         uint256 c = a - b;
574 
575         return c;
576     }
577 
578     /**
579      * @dev Returns the multiplication of two unsigned integers, reverting on
580      * overflow.
581      *
582      * Counterpart to Solidity's `*` operator.
583      *
584      * Requirements:
585      * - Multiplication cannot overflow.
586      */
587     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
588         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
589         // benefit is lost if 'b' is also tested.
590         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
591         if (a == 0) {
592             return 0;
593         }
594 
595         uint256 c = a * b;
596         require(c / a == b, "SafeMath: multiplication overflow");
597 
598         return c;
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers. Reverts on
603      * division by zero. The result is rounded towards zero.
604      *
605      * Counterpart to Solidity's `/` operator. Note: this function uses a
606      * `revert` opcode (which leaves remaining gas untouched) while Solidity
607      * uses an invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      * - The divisor cannot be zero.
611      */
612     function div(uint256 a, uint256 b) internal pure returns (uint256) {
613         return div(a, b, "SafeMath: division by zero");
614     }
615 
616     /**
617      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
618      * division by zero. The result is rounded towards zero.
619      *
620      * Counterpart to Solidity's `/` operator. Note: this function uses a
621      * `revert` opcode (which leaves remaining gas untouched) while Solidity
622      * uses an invalid opcode to revert (consuming all remaining gas).
623      *
624      * Requirements:
625      * - The divisor cannot be zero.
626      *
627      * _Available since v2.4.0._
628      */
629     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
630         // Solidity only automatically asserts when dividing by 0
631         require(b > 0, errorMessage);
632         uint256 c = a / b;
633         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
634 
635         return c;
636     }
637 
638     /**
639      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
640      * Reverts when dividing by zero.
641      *
642      * Counterpart to Solidity's `%` operator. This function uses a `revert`
643      * opcode (which leaves remaining gas untouched) while Solidity uses an
644      * invalid opcode to revert (consuming all remaining gas).
645      *
646      * Requirements:
647      * - The divisor cannot be zero.
648      */
649     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
650         return mod(a, b, "SafeMath: modulo by zero");
651     }
652 
653     /**
654      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
655      * Reverts with custom message when dividing by zero.
656      *
657      * Counterpart to Solidity's `%` operator. This function uses a `revert`
658      * opcode (which leaves remaining gas untouched) while Solidity uses an
659      * invalid opcode to revert (consuming all remaining gas).
660      *
661      * Requirements:
662      * - The divisor cannot be zero.
663      *
664      * _Available since v2.4.0._
665      */
666     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
667         require(b != 0, errorMessage);
668         return a % b;
669     }
670 }
671 
672 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/IERC20.sol
673 
674 pragma solidity ^0.5.0;
675 
676 /**
677  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
678  * the optional functions; to access them see {ERC20Detailed}.
679  */
680 interface IERC20 {
681     /**
682      * @dev Returns the amount of tokens in existence.
683      */
684     function totalSupply() external view returns (uint256);
685 
686     /**
687      * @dev Returns the amount of tokens owned by `account`.
688      */
689     function balanceOf(address account) external view returns (uint256);
690 
691     /**
692      * @dev Moves `amount` tokens from the caller's account to `recipient`.
693      *
694      * Returns a boolean value indicating whether the operation succeeded.
695      *
696      * Emits a {Transfer} event.
697      */
698     function transfer(address recipient, uint256 amount) external returns (bool);
699 
700     /**
701      * @dev Returns the remaining number of tokens that `spender` will be
702      * allowed to spend on behalf of `owner` through {transferFrom}. This is
703      * zero by default.
704      *
705      * This value changes when {approve} or {transferFrom} are called.
706      */
707     function allowance(address owner, address spender) external view returns (uint256);
708 
709     /**
710      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
711      *
712      * Returns a boolean value indicating whether the operation succeeded.
713      *
714      * IMPORTANT: Beware that changing an allowance with this method brings the risk
715      * that someone may use both the old and the new allowance by unfortunate
716      * transaction ordering. One possible solution to mitigate this race
717      * condition is to first reduce the spender's allowance to 0 and set the
718      * desired value afterwards:
719      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
720      *
721      * Emits an {Approval} event.
722      */
723     function approve(address spender, uint256 amount) external returns (bool);
724 
725     /**
726      * @dev Moves `amount` tokens from `sender` to `recipient` using the
727      * allowance mechanism. `amount` is then deducted from the caller's
728      * allowance.
729      *
730      * Returns a boolean value indicating whether the operation succeeded.
731      *
732      * Emits a {Transfer} event.
733      */
734     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
735 
736     /**
737      * @dev Emitted when `value` tokens are moved from one account (`from`) to
738      * another (`to`).
739      *
740      * Note that `value` may be zero.
741      */
742     event Transfer(address indexed from, address indexed to, uint256 value);
743 
744     /**
745      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
746      * a call to {approve}. `value` is the new allowance.
747      */
748     event Approval(address indexed owner, address indexed spender, uint256 value);
749 }
750 
751 pragma solidity ^0.5.0;
752 
753 contract DEFCrowdsale is Crowdsale, AllowanceCrowdsale {
754     /**
755      * constructor
756      *
757      * Requirements:
758      *
759      * - `rate` rate
760      * - `wallet` wallet address
761      * - `token` token address
762      * - `tokenWallet` tokenWallet address
763      */
764     constructor (
765         uint256 rate,
766         address payable wallet,
767         IERC20 token, address tokenWallet
768     )
769     Crowdsale(rate, wallet, token)
770     AllowanceCrowdsale(tokenWallet)
771     public
772     {
773 
774     }
775 }