1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
111 
112 pragma solidity ^0.5.0;
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
116  * the optional functions; to access them see {ERC20Detailed}.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: @openzeppelin/contracts/math/SafeMath.sol
190 
191 pragma solidity ^0.5.0;
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      * - Addition cannot overflow.
215      */
216     function add(uint256 a, uint256 b) internal pure returns (uint256) {
217         uint256 c = a + b;
218         require(c >= a, "SafeMath: addition overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      * - Subtraction cannot overflow.
244      *
245      * _Available since v2.4.0._
246      */
247     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b <= a, errorMessage);
249         uint256 c = a - b;
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the multiplication of two unsigned integers, reverting on
256      * overflow.
257      *
258      * Counterpart to Solidity's `*` operator.
259      *
260      * Requirements:
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      * - The divisor cannot be zero.
302      *
303      * _Available since v2.4.0._
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         // Solidity only automatically asserts when dividing by 0
307         require(b > 0, errorMessage);
308         uint256 c = a / b;
309         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
316      * Reverts when dividing by zero.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      * - The divisor cannot be zero.
339      *
340      * _Available since v2.4.0._
341      */
342     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
343         require(b != 0, errorMessage);
344         return a % b;
345     }
346 }
347 
348 // File: @openzeppelin/contracts/utils/Address.sol
349 
350 pragma solidity ^0.5.5;
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following 
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
375         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
376         // for accounts without code, i.e. `keccak256('')`
377         bytes32 codehash;
378         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
379         // solhint-disable-next-line no-inline-assembly
380         assembly { codehash := extcodehash(account) }
381         return (codehash != accountHash && codehash != 0x0);
382     }
383 
384     /**
385      * @dev Converts an `address` into `address payable`. Note that this is
386      * simply a type cast: the actual underlying value is not changed.
387      *
388      * _Available since v2.4.0._
389      */
390     function toPayable(address account) internal pure returns (address payable) {
391         return address(uint160(account));
392     }
393 
394     /**
395      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
396      * `recipient`, forwarding all available gas and reverting on errors.
397      *
398      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
399      * of certain opcodes, possibly making contracts go over the 2300 gas limit
400      * imposed by `transfer`, making them unable to receive funds via
401      * `transfer`. {sendValue} removes this limitation.
402      *
403      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
404      *
405      * IMPORTANT: because control is transferred to `recipient`, care must be
406      * taken to not create reentrancy vulnerabilities. Consider using
407      * {ReentrancyGuard} or the
408      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
409      *
410      * _Available since v2.4.0._
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         // solhint-disable-next-line avoid-call-value
416         (bool success, ) = recipient.call.value(amount)("");
417         require(success, "Address: unable to send value, recipient may have reverted");
418     }
419 }
420 
421 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
422 
423 pragma solidity ^0.5.0;
424 
425 
426 
427 
428 /**
429  * @title SafeERC20
430  * @dev Wrappers around ERC20 operations that throw on failure (when the token
431  * contract returns false). Tokens that return no value (and instead revert or
432  * throw on failure) are also supported, non-reverting calls are assumed to be
433  * successful.
434  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
435  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
436  */
437 library SafeERC20 {
438     using SafeMath for uint256;
439     using Address for address;
440 
441     function safeTransfer(IERC20 token, address to, uint256 value) internal {
442         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
443     }
444 
445     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
446         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
447     }
448 
449     function safeApprove(IERC20 token, address spender, uint256 value) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         // solhint-disable-next-line max-line-length
454         require((value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).add(value);
462         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
466         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
467         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
468     }
469 
470     /**
471      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
472      * on the return value: the return value is optional (but if data is returned, it must not be false).
473      * @param token The token targeted by the call.
474      * @param data The call data (encoded using abi.encode or one of its variants).
475      */
476     function callOptionalReturn(IERC20 token, bytes memory data) private {
477         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
478         // we're implementing it ourselves.
479 
480         // A Solidity high level call has three parts:
481         //  1. The target address is checked to verify it contains contract code
482         //  2. The call itself is made, and success asserted
483         //  3. The return value is decoded, which in turn checks the size of the returned data.
484         // solhint-disable-next-line max-line-length
485         require(address(token).isContract(), "SafeERC20: call to non-contract");
486 
487         // solhint-disable-next-line avoid-low-level-calls
488         (bool success, bytes memory returndata) = address(token).call(data);
489         require(success, "SafeERC20: low-level call failed");
490 
491         if (returndata.length > 0) { // Return data is optional
492             // solhint-disable-next-line max-line-length
493             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
494         }
495     }
496 }
497 
498 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
499 
500 pragma solidity ^0.5.0;
501 
502 /**
503  * @dev Contract module that helps prevent reentrant calls to a function.
504  *
505  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
506  * available, which can be applied to functions to make sure there are no nested
507  * (reentrant) calls to them.
508  *
509  * Note that because there is a single `nonReentrant` guard, functions marked as
510  * `nonReentrant` may not call one another. This can be worked around by making
511  * those functions `private`, and then adding `external` `nonReentrant` entry
512  * points to them.
513  *
514  * TIP: If you would like to learn more about reentrancy and alternative ways
515  * to protect against it, check out our blog post
516  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
517  *
518  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
519  * metering changes introduced in the Istanbul hardfork.
520  */
521 contract ReentrancyGuard {
522     bool private _notEntered;
523 
524     constructor () internal {
525         // Storing an initial non-zero value makes deployment a bit more
526         // expensive, but in exchange the refund on every call to nonReentrant
527         // will be lower in amount. Since refunds are capped to a percetange of
528         // the total transaction's gas, it is best to keep them low in cases
529         // like this one, to increase the likelihood of the full refund coming
530         // into effect.
531         _notEntered = true;
532     }
533 
534     /**
535      * @dev Prevents a contract from calling itself, directly or indirectly.
536      * Calling a `nonReentrant` function from another `nonReentrant`
537      * function is not supported. It is possible to prevent this from happening
538      * by making the `nonReentrant` function external, and make it call a
539      * `private` function that does the actual work.
540      */
541     modifier nonReentrant() {
542         // On the first call to nonReentrant, _notEntered will be true
543         require(_notEntered, "ReentrancyGuard: reentrant call");
544 
545         // Any calls to nonReentrant after this point will fail
546         _notEntered = false;
547 
548         _;
549 
550         // By storing the original value once again, a refund is triggered (see
551         // https://eips.ethereum.org/EIPS/eip-2200)
552         _notEntered = true;
553     }
554 }
555 
556 // File: @openzeppelin/contracts/crowdsale/Crowdsale.sol
557 
558 pragma solidity ^0.5.0;
559 
560 
561 
562 
563 
564 
565 /**
566  * @title Crowdsale
567  * @dev Crowdsale is a base contract for managing a token crowdsale,
568  * allowing investors to purchase tokens with ether. This contract implements
569  * such functionality in its most fundamental form and can be extended to provide additional
570  * functionality and/or custom behavior.
571  * The external interface represents the basic interface for purchasing tokens, and conforms
572  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
573  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
574  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
575  * behavior.
576  */
577 contract Crowdsale is Context, ReentrancyGuard {
578     using SafeMath for uint256;
579     using SafeERC20 for IERC20;
580 
581     // The token being sold
582     IERC20 private _token;
583 
584     // Address where funds are collected
585     address payable private _wallet;
586 
587     // How many token units a buyer gets per wei.
588     // The rate is the conversion between wei and the smallest and indivisible token unit.
589     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
590     // 1 wei will give you 1 unit, or 0.001 TOK.
591     uint256 private _rate;
592 
593     // Amount of wei raised
594     uint256 private _weiRaised;
595 
596     /**
597      * Event for token purchase logging
598      * @param purchaser who paid for the tokens
599      * @param beneficiary who got the tokens
600      * @param value weis paid for purchase
601      * @param amount amount of tokens purchased
602      */
603     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
604 
605     /**
606      * @param rate Number of token units a buyer gets per wei
607      * @dev The rate is the conversion between wei and the smallest and indivisible
608      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
609      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
610      * @param wallet Address where collected funds will be forwarded to
611      * @param token Address of the token being sold
612      */
613     constructor (uint256 rate, address payable wallet, IERC20 token) public {
614         require(rate > 0, "Crowdsale: rate is 0");
615         require(wallet != address(0), "Crowdsale: wallet is the zero address");
616         require(address(token) != address(0), "Crowdsale: token is the zero address");
617 
618         _rate = rate;
619         _wallet = wallet;
620         _token = token;
621     }
622 
623     /**
624      * @dev fallback function ***DO NOT OVERRIDE***
625      * Note that other contracts will transfer funds with a base gas stipend
626      * of 2300, which is not enough to call buyTokens. Consider calling
627      * buyTokens directly when purchasing tokens from a contract.
628      */
629     function () external payable {
630         buyTokens(_msgSender());
631     }
632 
633     /**
634      * @return the token being sold.
635      */
636     function token() public view returns (IERC20) {
637         return _token;
638     }
639 
640     /**
641      * @return the address where funds are collected.
642      */
643     function wallet() public view returns (address payable) {
644         return _wallet;
645     }
646 
647     /**
648      * @return the number of token units a buyer gets per wei.
649      */
650     function rate() public view returns (uint256) {
651         return _rate;
652     }
653 
654     /**
655      * @return the amount of wei raised.
656      */
657     function weiRaised() public view returns (uint256) {
658         return _weiRaised;
659     }
660 
661     /**
662      * @dev low level token purchase ***DO NOT OVERRIDE***
663      * This function has a non-reentrancy guard, so it shouldn't be called by
664      * another `nonReentrant` function.
665      * @param beneficiary Recipient of the token purchase
666      */
667     function buyTokens(address beneficiary) public nonReentrant payable {
668         uint256 weiAmount = msg.value;
669         _preValidatePurchase(beneficiary, weiAmount);
670 
671         // calculate token amount to be created
672         uint256 tokens = _getTokenAmount(weiAmount);
673 
674         // update state
675         _weiRaised = _weiRaised.add(weiAmount);
676 
677         _processPurchase(beneficiary, tokens);
678         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
679 
680         _updatePurchasingState(beneficiary, weiAmount);
681 
682         _forwardFunds();
683         _postValidatePurchase(beneficiary, weiAmount);
684     }
685 
686     /**
687      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
688      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
689      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
690      *     super._preValidatePurchase(beneficiary, weiAmount);
691      *     require(weiRaised().add(weiAmount) <= cap);
692      * @param beneficiary Address performing the token purchase
693      * @param weiAmount Value in wei involved in the purchase
694      */
695     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
696         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
697         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
698         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
699     }
700 
701     /**
702      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
703      * conditions are not met.
704      * @param beneficiary Address performing the token purchase
705      * @param weiAmount Value in wei involved in the purchase
706      */
707     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
708         // solhint-disable-previous-line no-empty-blocks
709     }
710 
711     /**
712      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
713      * its tokens.
714      * @param beneficiary Address performing the token purchase
715      * @param tokenAmount Number of tokens to be emitted
716      */
717     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
718         _token.safeTransfer(beneficiary, tokenAmount);
719     }
720 
721     /**
722      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
723      * tokens.
724      * @param beneficiary Address receiving the tokens
725      * @param tokenAmount Number of tokens to be purchased
726      */
727     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
728         _deliverTokens(beneficiary, tokenAmount);
729     }
730 
731     /**
732      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
733      * etc.)
734      * @param beneficiary Address receiving the tokens
735      * @param weiAmount Value in wei involved in the purchase
736      */
737     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
738         // solhint-disable-previous-line no-empty-blocks
739     }
740 
741     /**
742      * @dev Override to extend the way in which ether is converted to tokens.
743      * @param weiAmount Value in wei to be converted into tokens
744      * @return Number of tokens that can be purchased with the specified _weiAmount
745      */
746     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
747         return weiAmount.mul(_rate);
748     }
749 
750     /**
751      * @dev Determines how ETH is stored/forwarded on purchases.
752      */
753     function _forwardFunds() internal {
754         _wallet.transfer(msg.value);
755     }
756 }
757 
758 // File: @openzeppelin/contracts/math/Math.sol
759 
760 pragma solidity ^0.5.0;
761 
762 /**
763  * @dev Standard math utilities missing in the Solidity language.
764  */
765 library Math {
766     /**
767      * @dev Returns the largest of two numbers.
768      */
769     function max(uint256 a, uint256 b) internal pure returns (uint256) {
770         return a >= b ? a : b;
771     }
772 
773     /**
774      * @dev Returns the smallest of two numbers.
775      */
776     function min(uint256 a, uint256 b) internal pure returns (uint256) {
777         return a < b ? a : b;
778     }
779 
780     /**
781      * @dev Returns the average of two numbers. The result is rounded towards
782      * zero.
783      */
784     function average(uint256 a, uint256 b) internal pure returns (uint256) {
785         // (a + b) / 2 can overflow, so we distribute
786         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
787     }
788 }
789 
790 // File: @openzeppelin/contracts/crowdsale/emission/AllowanceCrowdsale.sol
791 
792 pragma solidity ^0.5.0;
793 
794 
795 
796 
797 
798 
799 /**
800  * @title AllowanceCrowdsale
801  * @dev Extension of Crowdsale where tokens are held by a wallet, which approves an allowance to the crowdsale.
802  */
803 contract AllowanceCrowdsale is Crowdsale {
804     using SafeMath for uint256;
805     using SafeERC20 for IERC20;
806 
807     address private _tokenWallet;
808 
809     /**
810      * @dev Constructor, takes token wallet address.
811      * @param tokenWallet Address holding the tokens, which has approved allowance to the crowdsale.
812      */
813     constructor (address tokenWallet) public {
814         require(tokenWallet != address(0), "AllowanceCrowdsale: token wallet is the zero address");
815         _tokenWallet = tokenWallet;
816     }
817 
818     /**
819      * @return the address of the wallet that will hold the tokens.
820      */
821     function tokenWallet() public view returns (address) {
822         return _tokenWallet;
823     }
824 
825     /**
826      * @dev Checks the amount of tokens left in the allowance.
827      * @return Amount of tokens left in the allowance
828      */
829     function remainingTokens() public view returns (uint256) {
830         return Math.min(token().balanceOf(_tokenWallet), token().allowance(_tokenWallet, address(this)));
831     }
832 
833     /**
834      * @dev Overrides parent behavior by transferring tokens from wallet.
835      * @param beneficiary Token purchaser
836      * @param tokenAmount Amount of tokens purchased
837      */
838     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
839         token().safeTransferFrom(_tokenWallet, beneficiary, tokenAmount);
840     }
841 }
842 
843 // File: @openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol
844 
845 pragma solidity ^0.5.0;
846 
847 
848 
849 /**
850  * @title TimedCrowdsale
851  * @dev Crowdsale accepting contributions only within a time frame.
852  */
853 contract TimedCrowdsale is Crowdsale {
854     using SafeMath for uint256;
855 
856     uint256 private _openingTime;
857     uint256 private _closingTime;
858 
859     /**
860      * Event for crowdsale extending
861      * @param newClosingTime new closing time
862      * @param prevClosingTime old closing time
863      */
864     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
865 
866     /**
867      * @dev Reverts if not in crowdsale time range.
868      */
869     modifier onlyWhileOpen {
870         require(isOpen(), "TimedCrowdsale: not open");
871         _;
872     }
873 
874     /**
875      * @dev Constructor, takes crowdsale opening and closing times.
876      * @param openingTime Crowdsale opening time
877      * @param closingTime Crowdsale closing time
878      */
879     constructor (uint256 openingTime, uint256 closingTime) public {
880         // solhint-disable-next-line not-rely-on-time
881         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
882         // solhint-disable-next-line max-line-length
883         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
884 
885         _openingTime = openingTime;
886         _closingTime = closingTime;
887     }
888 
889     /**
890      * @return the crowdsale opening time.
891      */
892     function openingTime() public view returns (uint256) {
893         return _openingTime;
894     }
895 
896     /**
897      * @return the crowdsale closing time.
898      */
899     function closingTime() public view returns (uint256) {
900         return _closingTime;
901     }
902 
903     /**
904      * @return true if the crowdsale is open, false otherwise.
905      */
906     function isOpen() public view returns (bool) {
907         // solhint-disable-next-line not-rely-on-time
908         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
909     }
910 
911     /**
912      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
913      * @return Whether crowdsale period has elapsed
914      */
915     function hasClosed() public view returns (bool) {
916         // solhint-disable-next-line not-rely-on-time
917         return block.timestamp > _closingTime;
918     }
919 
920     /**
921      * @dev Extend parent behavior requiring to be within contributing period.
922      * @param beneficiary Token purchaser
923      * @param weiAmount Amount of wei contributed
924      */
925     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
926         super._preValidatePurchase(beneficiary, weiAmount);
927     }
928 
929     /**
930      * @dev Extend crowdsale.
931      * @param newClosingTime Crowdsale closing time
932      */
933     function _extendTime(uint256 newClosingTime) internal {
934         require(!hasClosed(), "TimedCrowdsale: already closed");
935         // solhint-disable-next-line max-line-length
936         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
937 
938         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
939         _closingTime = newClosingTime;
940     }
941 }
942 
943 // File: @openzeppelin/contracts/crowdsale/distribution/FinalizableCrowdsale.sol
944 
945 pragma solidity ^0.5.0;
946 
947 
948 
949 /**
950  * @title FinalizableCrowdsale
951  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
952  * can do extra work after finishing.
953  */
954 contract FinalizableCrowdsale is TimedCrowdsale {
955     using SafeMath for uint256;
956 
957     bool private _finalized;
958 
959     event CrowdsaleFinalized();
960 
961     constructor () internal {
962         _finalized = false;
963     }
964 
965     /**
966      * @return true if the crowdsale is finalized, false otherwise.
967      */
968     function finalized() public view returns (bool) {
969         return _finalized;
970     }
971 
972     /**
973      * @dev Must be called after crowdsale ends, to do some extra finalization
974      * work. Calls the contract's finalization function.
975      */
976     function finalize() public {
977         require(!_finalized, "FinalizableCrowdsale: already finalized");
978         require(hasClosed(), "FinalizableCrowdsale: not closed");
979 
980         _finalized = true;
981 
982         _finalization();
983         emit CrowdsaleFinalized();
984     }
985 
986     /**
987      * @dev Can be overridden to add finalization logic. The overriding function
988      * should call super._finalization() to ensure the chain of finalization is
989      * executed entirely.
990      */
991     function _finalization() internal {
992         // solhint-disable-previous-line no-empty-blocks
993     }
994 }
995 
996 // File: @openzeppelin/contracts/ownership/Secondary.sol
997 
998 pragma solidity ^0.5.0;
999 
1000 /**
1001  * @dev A Secondary contract can only be used by its primary account (the one that created it).
1002  */
1003 contract Secondary is Context {
1004     address private _primary;
1005 
1006     /**
1007      * @dev Emitted when the primary contract changes.
1008      */
1009     event PrimaryTransferred(
1010         address recipient
1011     );
1012 
1013     /**
1014      * @dev Sets the primary account to the one that is creating the Secondary contract.
1015      */
1016     constructor () internal {
1017         address msgSender = _msgSender();
1018         _primary = msgSender;
1019         emit PrimaryTransferred(msgSender);
1020     }
1021 
1022     /**
1023      * @dev Reverts if called from any account other than the primary.
1024      */
1025     modifier onlyPrimary() {
1026         require(_msgSender() == _primary, "Secondary: caller is not the primary account");
1027         _;
1028     }
1029 
1030     /**
1031      * @return the address of the primary.
1032      */
1033     function primary() public view returns (address) {
1034         return _primary;
1035     }
1036 
1037     /**
1038      * @dev Transfers contract to a new primary.
1039      * @param recipient The address of new primary.
1040      */
1041     function transferPrimary(address recipient) public onlyPrimary {
1042         require(recipient != address(0), "Secondary: new primary is the zero address");
1043         _primary = recipient;
1044         emit PrimaryTransferred(recipient);
1045     }
1046 }
1047 
1048 // File: @openzeppelin/contracts/payment/escrow/Escrow.sol
1049 
1050 pragma solidity ^0.5.0;
1051 
1052 
1053 
1054 
1055  /**
1056   * @title Escrow
1057   * @dev Base escrow contract, holds funds designated for a payee until they
1058   * withdraw them.
1059   *
1060   * Intended usage: This contract (and derived escrow contracts) should be a
1061   * standalone contract, that only interacts with the contract that instantiated
1062   * it. That way, it is guaranteed that all Ether will be handled according to
1063   * the `Escrow` rules, and there is no need to check for payable functions or
1064   * transfers in the inheritance tree. The contract that uses the escrow as its
1065   * payment method should be its primary, and provide public methods redirecting
1066   * to the escrow's deposit and withdraw.
1067   */
1068 contract Escrow is Secondary {
1069     using SafeMath for uint256;
1070     using Address for address payable;
1071 
1072     event Deposited(address indexed payee, uint256 weiAmount);
1073     event Withdrawn(address indexed payee, uint256 weiAmount);
1074 
1075     mapping(address => uint256) private _deposits;
1076 
1077     function depositsOf(address payee) public view returns (uint256) {
1078         return _deposits[payee];
1079     }
1080 
1081     /**
1082      * @dev Stores the sent amount as credit to be withdrawn.
1083      * @param payee The destination address of the funds.
1084      */
1085     function deposit(address payee) public onlyPrimary payable {
1086         uint256 amount = msg.value;
1087         _deposits[payee] = _deposits[payee].add(amount);
1088 
1089         emit Deposited(payee, amount);
1090     }
1091 
1092     /**
1093      * @dev Withdraw accumulated balance for a payee, forwarding 2300 gas (a
1094      * Solidity `transfer`).
1095      *
1096      * NOTE: This function has been deprecated, use {withdrawWithGas} instead.
1097      * Calling contracts with fixed-gas limits is an anti-pattern and may break
1098      * contract interactions in network upgrades (hardforks).
1099      * https://diligence.consensys.net/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more.]
1100      *
1101      * @param payee The address whose funds will be withdrawn and transferred to.
1102      */
1103     function withdraw(address payable payee) public onlyPrimary {
1104         uint256 payment = _deposits[payee];
1105 
1106         _deposits[payee] = 0;
1107 
1108         payee.transfer(payment);
1109 
1110         emit Withdrawn(payee, payment);
1111     }
1112 
1113     /**
1114      * @dev Same as {withdraw}, but forwarding all gas to the recipient.
1115      *
1116      * WARNING: Forwarding all gas opens the door to reentrancy vulnerabilities.
1117      * Make sure you trust the recipient, or are either following the
1118      * checks-effects-interactions pattern or using {ReentrancyGuard}.
1119      *
1120      * _Available since v2.4.0._
1121      */
1122     function withdrawWithGas(address payable payee) public onlyPrimary {
1123         uint256 payment = _deposits[payee];
1124 
1125         _deposits[payee] = 0;
1126 
1127         payee.sendValue(payment);
1128 
1129         emit Withdrawn(payee, payment);
1130     }
1131 }
1132 
1133 // File: @openzeppelin/contracts/payment/escrow/ConditionalEscrow.sol
1134 
1135 pragma solidity ^0.5.0;
1136 
1137 
1138 /**
1139  * @title ConditionalEscrow
1140  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1141  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
1142  */
1143 contract ConditionalEscrow is Escrow {
1144     /**
1145      * @dev Returns whether an address is allowed to withdraw their funds. To be
1146      * implemented by derived contracts.
1147      * @param payee The destination address of the funds.
1148      */
1149     function withdrawalAllowed(address payee) public view returns (bool);
1150 
1151     function withdraw(address payable payee) public {
1152         require(withdrawalAllowed(payee), "ConditionalEscrow: payee is not allowed to withdraw");
1153         super.withdraw(payee);
1154     }
1155 }
1156 
1157 // File: @openzeppelin/contracts/payment/escrow/RefundEscrow.sol
1158 
1159 pragma solidity ^0.5.0;
1160 
1161 
1162 /**
1163  * @title RefundEscrow
1164  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1165  * parties.
1166  * @dev Intended usage: See {Escrow}. Same usage guidelines apply here.
1167  * @dev The primary account (that is, the contract that instantiates this
1168  * contract) may deposit, close the deposit period, and allow for either
1169  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1170  * with `RefundEscrow` will be made through the primary contract. See the
1171  * `RefundableCrowdsale` contract for an example of `RefundEscrow`’s use.
1172  */
1173 contract RefundEscrow is ConditionalEscrow {
1174     enum State { Active, Refunding, Closed }
1175 
1176     event RefundsClosed();
1177     event RefundsEnabled();
1178 
1179     State private _state;
1180     address payable private _beneficiary;
1181 
1182     /**
1183      * @dev Constructor.
1184      * @param beneficiary The beneficiary of the deposits.
1185      */
1186     constructor (address payable beneficiary) public {
1187         require(beneficiary != address(0), "RefundEscrow: beneficiary is the zero address");
1188         _beneficiary = beneficiary;
1189         _state = State.Active;
1190     }
1191 
1192     /**
1193      * @return The current state of the escrow.
1194      */
1195     function state() public view returns (State) {
1196         return _state;
1197     }
1198 
1199     /**
1200      * @return The beneficiary of the escrow.
1201      */
1202     function beneficiary() public view returns (address) {
1203         return _beneficiary;
1204     }
1205 
1206     /**
1207      * @dev Stores funds that may later be refunded.
1208      * @param refundee The address funds will be sent to if a refund occurs.
1209      */
1210     function deposit(address refundee) public payable {
1211         require(_state == State.Active, "RefundEscrow: can only deposit while active");
1212         super.deposit(refundee);
1213     }
1214 
1215     /**
1216      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1217      * further deposits.
1218      */
1219     function close() public onlyPrimary {
1220         require(_state == State.Active, "RefundEscrow: can only close while active");
1221         _state = State.Closed;
1222         emit RefundsClosed();
1223     }
1224 
1225     /**
1226      * @dev Allows for refunds to take place, rejecting further deposits.
1227      */
1228     function enableRefunds() public onlyPrimary {
1229         require(_state == State.Active, "RefundEscrow: can only enable refunds while active");
1230         _state = State.Refunding;
1231         emit RefundsEnabled();
1232     }
1233 
1234     /**
1235      * @dev Withdraws the beneficiary's funds.
1236      */
1237     function beneficiaryWithdraw() public {
1238         require(_state == State.Closed, "RefundEscrow: beneficiary can only withdraw while closed");
1239         _beneficiary.transfer(address(this).balance);
1240     }
1241 
1242     /**
1243      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
1244      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1245      */
1246     function withdrawalAllowed(address) public view returns (bool) {
1247         return _state == State.Refunding;
1248     }
1249 }
1250 
1251 // File: @openzeppelin/contracts/crowdsale/distribution/RefundableCrowdsale.sol
1252 
1253 pragma solidity ^0.5.0;
1254 
1255 
1256 
1257 
1258 
1259 /**
1260  * @title RefundableCrowdsale
1261  * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
1262  * getting a refund if goal is not met.
1263  *
1264  * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
1265  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1266  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1267  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1268  */
1269 contract RefundableCrowdsale is Context, FinalizableCrowdsale {
1270     using SafeMath for uint256;
1271 
1272     // minimum amount of funds to be raised in weis
1273     uint256 private _goal;
1274 
1275     // refund escrow used to hold funds while crowdsale is running
1276     RefundEscrow private _escrow;
1277 
1278     /**
1279      * @dev Constructor, creates RefundEscrow.
1280      * @param goal Funding goal
1281      */
1282     constructor (uint256 goal) public {
1283         require(goal > 0, "RefundableCrowdsale: goal is 0");
1284         _escrow = new RefundEscrow(wallet());
1285         _goal = goal;
1286     }
1287 
1288     /**
1289      * @return minimum amount of funds to be raised in wei.
1290      */
1291     function goal() public view returns (uint256) {
1292         return _goal;
1293     }
1294 
1295     /**
1296      * @dev Investors can claim refunds here if crowdsale is unsuccessful.
1297      * @param refundee Whose refund will be claimed.
1298      */
1299     function claimRefund(address payable refundee) public {
1300         require(finalized(), "RefundableCrowdsale: not finalized");
1301         require(!goalReached(), "RefundableCrowdsale: goal reached");
1302 
1303         _escrow.withdraw(refundee);
1304     }
1305 
1306     /**
1307      * @dev Checks whether funding goal was reached.
1308      * @return Whether funding goal was reached
1309      */
1310     function goalReached() public view returns (bool) {
1311         return weiRaised() >= _goal;
1312     }
1313 
1314     /**
1315      * @dev Escrow finalization task, called when finalize() is called.
1316      */
1317     function _finalization() internal {
1318         if (goalReached()) {
1319             _escrow.close();
1320             _escrow.beneficiaryWithdraw();
1321         } else {
1322             _escrow.enableRefunds();
1323         }
1324 
1325         super._finalization();
1326     }
1327 
1328     /**
1329      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1330      */
1331     function _forwardFunds() internal {
1332         _escrow.deposit.value(msg.value)(_msgSender());
1333     }
1334 }
1335 
1336 // File: contracts/lib/ds-hub.sol
1337 
1338 pragma solidity ^0.5.17;
1339 
1340 interface DSAuthority {
1341   function canCall(
1342     address src,
1343     address dst,
1344     bytes4 sig
1345   ) external view returns (bool);
1346 }
1347 
1348 contract DSAuthEvents {
1349   event LogSetAuthority(address indexed authority);
1350   event LogSetOwner(address indexed owner);
1351 }
1352 
1353 contract DSAuth is DSAuthEvents {
1354   DSAuthority public authority;
1355   address public owner;
1356 
1357   constructor() public {
1358     owner = msg.sender;
1359     emit LogSetOwner(msg.sender);
1360   }
1361 
1362   function setOwner(address owner_) public auth {
1363     owner = owner_;
1364     emit LogSetOwner(owner);
1365   }
1366 
1367   function setAuthority(DSAuthority authority_) public auth {
1368     authority = authority_;
1369     emit LogSetAuthority(address(authority));
1370   }
1371 
1372   modifier auth {
1373     require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
1374     _;
1375   }
1376 
1377   function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
1378     if (src == address(this)) {
1379       return true;
1380     } else if (src == owner) {
1381       return true;
1382     } else if (authority == DSAuthority(0)) {
1383       return false;
1384     } else {
1385       return authority.canCall(src, address(this), sig);
1386     }
1387   }
1388 }
1389 
1390 contract DSNote {
1391   event LogNote(bytes4 indexed sig, address indexed guy, bytes32 indexed foo, bytes32 indexed bar, uint256 wad, bytes fax) anonymous;
1392 
1393   modifier note {
1394     bytes32 foo;
1395     bytes32 bar;
1396     uint256 wad;
1397 
1398     assembly {
1399       foo := calldataload(4)
1400       bar := calldataload(36)
1401       wad := callvalue()
1402     }
1403 
1404     _;
1405 
1406     emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
1407   }
1408 }
1409 
1410 contract DSMath {
1411   function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1412     require((z = x + y) >= x, "ds-math-add-overflow");
1413   }
1414 
1415   function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1416     require((z = x - y) <= x, "ds-math-sub-underflow");
1417   }
1418 
1419   function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1420     require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
1421   }
1422 
1423   function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
1424     return x <= y ? x : y;
1425   }
1426 
1427   function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
1428     return x >= y ? x : y;
1429   }
1430 
1431   function imin(int256 x, int256 y) internal pure returns (int256 z) {
1432     return x <= y ? x : y;
1433   }
1434 
1435   function imax(int256 x, int256 y) internal pure returns (int256 z) {
1436     return x >= y ? x : y;
1437   }
1438 
1439   uint256 constant WAD = 10**18;
1440   uint256 constant RAY = 10**27;
1441 
1442   //rounds to zero if x*y < WAD / 2
1443   function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1444     z = add(mul(x, y), WAD / 2) / WAD;
1445   }
1446 
1447   //rounds to zero if x*y < WAD / 2
1448   function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1449     z = add(mul(x, y), RAY / 2) / RAY;
1450   }
1451 
1452   //rounds to zero if x*y < WAD / 2
1453   function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1454     z = add(mul(x, WAD), y / 2) / y;
1455   }
1456 
1457   //rounds to zero if x*y < RAY / 2
1458   function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1459     z = add(mul(x, RAY), y / 2) / y;
1460   }
1461 
1462   // This famous algorithm is called "exponentiation by squaring"
1463   // and calculates x^n with x as fixed-point and n as regular unsigned.
1464   //
1465   // It's O(log n), instead of O(n) for naive repeated multiplication.
1466   //
1467   // These facts are why it works:
1468   //
1469   //  If n is even, then x^n = (x^2)^(n/2).
1470   //  If n is odd,  then x^n = x * x^(n-1),
1471   //   and applying the equation for even x gives
1472   //    x^n = x * (x^2)^((n-1) / 2).
1473   //
1474   //  Also, EVM division is flooring and
1475   //    floor[(n-1) / 2] = floor[n / 2].
1476   //
1477   function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
1478     z = n % 2 != 0 ? x : RAY;
1479 
1480     for (n /= 2; n != 0; n /= 2) {
1481       x = rmul(x, x);
1482 
1483       if (n % 2 != 0) {
1484         z = rmul(z, x);
1485       }
1486     }
1487   }
1488 }
1489 
1490 contract DSThing is DSAuth, DSNote, DSMath {
1491   function S(string memory s) internal pure returns (bytes4) {
1492     return bytes4(keccak256(abi.encodePacked(s)));
1493   }
1494 }
1495 
1496 contract DSValue is DSThing {
1497   bool has;
1498   bytes32 val;
1499 
1500   function peek() public view returns (bytes32, bool) {
1501     return (val, has);
1502   }
1503 
1504   function read() public view returns (bytes32) {
1505     bytes32 wut;
1506     bool haz;
1507     (wut, haz) = peek();
1508     require(haz, "haz-not");
1509     return wut;
1510   }
1511 
1512   function poke(bytes32 wut) public note auth {
1513     val = wut;
1514     has = true;
1515   }
1516 
1517   function void() public note auth {
1518     // unset the value
1519     has = false;
1520   }
1521 }
1522 
1523 // File: contracts/lib/IUniswapV2Pair.sol
1524 
1525 pragma solidity >=0.5.10;
1526 
1527 interface IUniswapV2Pair {
1528   event Approval(address indexed owner, address indexed spender, uint256 value);
1529   event Transfer(address indexed from, address indexed to, uint256 value);
1530 
1531   function name() external pure returns (string memory);
1532 
1533   function symbol() external pure returns (string memory);
1534 
1535   function decimals() external pure returns (uint8);
1536 
1537   function totalSupply() external view returns (uint256);
1538 
1539   function balanceOf(address owner) external view returns (uint256);
1540 
1541   function allowance(address owner, address spender) external view returns (uint256);
1542 
1543   function approve(address spender, uint256 value) external returns (bool);
1544 
1545   function transfer(address to, uint256 value) external returns (bool);
1546 
1547   function transferFrom(
1548     address from,
1549     address to,
1550     uint256 value
1551   ) external returns (bool);
1552 
1553   function DOMAIN_SEPARATOR() external view returns (bytes32);
1554 
1555   function PERMIT_TYPEHASH() external pure returns (bytes32);
1556 
1557   function nonces(address owner) external view returns (uint256);
1558 
1559   function permit(
1560     address owner,
1561     address spender,
1562     uint256 value,
1563     uint256 deadline,
1564     uint8 v,
1565     bytes32 r,
1566     bytes32 s
1567   ) external;
1568 
1569   event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1570   event Burn(address indexed sender, uint256 amount0, uint256 amount1, address indexed to);
1571   event Swap(address indexed sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address indexed to);
1572   event Sync(uint112 reserve0, uint112 reserve1);
1573 
1574   function MINIMUM_LIQUIDITY() external pure returns (uint256);
1575 
1576   function factory() external view returns (address);
1577 
1578   function token0() external view returns (address);
1579 
1580   function token1() external view returns (address);
1581 
1582   function getReserves() external view returns (uint112 reserve0, uint112 reserve1);
1583 
1584   function price0CumulativeLast() external view returns (uint256);
1585 
1586   function price1CumulativeLast() external view returns (uint256);
1587 
1588   function kLast() external view returns (uint256);
1589 
1590   function mint(address to) external returns (uint256 liquidity);
1591 
1592   function burn(address to) external returns (uint256 amount0, uint256 amount1);
1593 
1594   function swap(
1595     uint256 amount0Out,
1596     uint256 amount1Out,
1597     address to,
1598     bytes calldata data
1599   ) external;
1600 
1601   function skim(address to) external;
1602 
1603   function sync() external;
1604 
1605   function initialize(address, address) external;
1606 }
1607 
1608 // File: contracts/sale/PricePicker.sol
1609 
1610 pragma solidity ^0.5.17;
1611 
1612 
1613 
1614 
1615 
1616 // calc eth price in usd
1617 contract PricePicker is DSMath, Ownable {
1618   function src() public pure returns (address) {
1619     return 0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11;
1620   }
1621 
1622   function getPrice() public view returns (uint256) {
1623     (uint112 reserve0, uint112 reserve1) = IUniswapV2Pair(src()).getReserves();
1624     return wdiv(uint256(reserve0), uint256(reserve1));
1625   }
1626 }
1627 
1628 // File: contracts/sale/RoundCrowdsale.sol
1629 
1630 pragma solidity ^0.5.17;
1631 
1632 
1633 
1634 
1635 contract RoundCrowdsale is DSMath, Crowdsale {
1636   using SafeMath for uint256;
1637 
1638   bool private _initialized;
1639 
1640   uint256 private _startTime;
1641 
1642   uint256 private _nRound;
1643 
1644   // array of block time stamps
1645   uint256[] private _roundEndTime;
1646 
1647   // array of rates of tokens per wei in WAD unit.
1648   uint256[] private _rates;
1649 
1650   uint256 private _roundTokenCap;
1651 
1652   mapping(uint256 => uint256) private _roundSoldToken;
1653 
1654   function initialize(
1655     uint256 roundTokenCap,
1656     uint256 startTime,
1657     uint256[] memory roundEndTime,
1658     uint256[] memory rates
1659   ) public {
1660     require(_initialized == false);
1661     require(roundEndTime.length == rates.length, "RoundCrowdsale: invalid input length");
1662     require(startTime < roundEndTime[0], "RoundCrowdsale: invalid start time");
1663 
1664     uint256 n = roundEndTime.length;
1665 
1666     for (uint256 i = 1; i < n; i++) {
1667       require(roundEndTime[i - 1] < roundEndTime[i], "RoundCrowdsale: time not sorted");
1668     }
1669     _startTime = startTime;
1670     _nRound = n;
1671 
1672     _roundEndTime = roundEndTime;
1673     _rates = rates;
1674 
1675     _roundTokenCap = roundTokenCap;
1676 
1677     _initialized = true;
1678   }
1679 
1680   function nRound() public view returns (uint256) {
1681     return _nRound;
1682   }
1683 
1684   function startTime() public view returns (uint256) {
1685     return _startTime;
1686   }
1687 
1688   function roundEndTimes(uint256 i) public view returns (uint256) {
1689     return _roundEndTime[i];
1690   }
1691 
1692   function roundSoldToken(uint256 i) public view returns (uint256) {
1693     return _roundSoldToken[i];
1694   }
1695 
1696   function roundTokenCap() public view returns (uint256) {
1697     return _roundTokenCap;
1698   }
1699 
1700   function rates(uint256 i) external view returns (uint256) {
1701     return _rates[i];
1702   }
1703 
1704   function isOpen() public view returns (bool) {
1705     // solhint-disable-next-line not-rely-on-time
1706     return block.timestamp >= _startTime && block.timestamp <= _roundEndTime[_roundEndTime.length - 1];
1707   }
1708 
1709   /**
1710    * The base rate function is overridden to revert, since this crowdsale doesn't use it, and
1711    * all calls to it are a mistake.
1712    */
1713   function rate() public view returns (uint256) {
1714     revert("RoundCrowdsale: rate() called");
1715   }
1716 
1717   function getCurrentRound() public view returns (uint256) {
1718     require(isOpen());
1719 
1720     uint256 index;
1721     for (; index < _rates.length; index++) {
1722       if (block.timestamp <= _roundEndTime[index]) break;
1723     }
1724 
1725     return index;
1726   }
1727 
1728   /**
1729    * @dev Returns the rate of tokens per wei at the present time.
1730    * Note that, as price _increases_ with time, the rate _decreases_.
1731    * @return The number of tokens a buyer gets per wei at a given time
1732    */
1733   function getCurrentRate() public view returns (uint256) {
1734     if (!isOpen()) {
1735       return 0;
1736     }
1737 
1738     return _rates[getCurrentRound()];
1739   }
1740 
1741   /**
1742    * @dev Override Crowdsale#_processPurchase
1743    * @param beneficiary Address receiving the tokens
1744    * @param tokenAmount Number of tokens to be purchased
1745    */
1746   function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1747     uint256 index = getCurrentRound();
1748 
1749     require(_roundSoldToken[index].add(tokenAmount) < _roundTokenCap, "RoundCrowdsale: over payment");
1750 
1751     _roundSoldToken[index] = _roundSoldToken[index].add(tokenAmount);
1752     super._processPurchase(beneficiary, tokenAmount);
1753   }
1754 
1755   /**
1756    * @dev Overrides parent method taking into account variable rate.
1757    * @param weiAmount The value in wei to be converted into tokens
1758    * @return The number of tokens _weiAmount wei will buy at present time
1759    */
1760   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
1761     uint256 currentRate = getCurrentRate();
1762     return wmul(currentRate, weiAmount);
1763   }
1764 
1765   /**
1766    * @dev Overrides Crowdsale._preValidatePurchase
1767    * @param beneficiary Address performing the token purchase
1768    * @param weiAmount Value in wei involved in the purchase
1769    */
1770   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1771     super._preValidatePurchase(beneficiary, weiAmount);
1772     require(isOpen(), "RoundCrowdsale: not open yet");
1773     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1774   }
1775 }
1776 
1777 // File: contracts/lib/MerkleProof.sol
1778 
1779 // https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
1780 
1781 pragma solidity >=0.4.22 <0.8.0;
1782 
1783 contract MerkleProof {
1784   function checkProof(
1785     bytes memory proof,
1786     bytes32 root,
1787     bytes32 hash
1788   ) public pure returns (bool) {
1789     bytes32 el;
1790     bytes32 h = hash;
1791 
1792     for (uint256 i = 32; i <= proof.length; i += 32) {
1793       assembly {
1794         el := mload(add(proof, i))
1795       }
1796 
1797       if (h < el) {
1798         h = keccak256(abi.encodePacked(h, el));
1799       } else {
1800         h = keccak256(abi.encodePacked(el, h));
1801       }
1802     }
1803 
1804     return h == root;
1805   }
1806 
1807   // from StorJ -- https://github.com/nginnever/storj-audit-verifier/blob/master/contracts/MerkleVerifyv3.sol
1808   function checkProofOrdered(
1809     bytes memory proof,
1810     bytes32 root,
1811     bytes32 hash,
1812     uint256 index
1813   ) public pure returns (bool) {
1814     // use the index to determine the node ordering
1815     // index ranges 1 to n
1816 
1817     bytes32 el;
1818     bytes32 h = hash;
1819     uint256 remaining;
1820 
1821     for (uint256 j = 32; j <= proof.length; j += 32) {
1822       assembly {
1823         el := mload(add(proof, j))
1824       }
1825 
1826       // calculate remaining elements in proof
1827       remaining = (proof.length - j + 32) / 32;
1828 
1829       // we don't assume that the tree is padded to a power of 2
1830       // if the index is odd then the proof will start with a hash at a higher
1831       // layer, so we have to adjust the index to be the index at that layer
1832       while (remaining > 0 && index % 2 == 1 && index > 2**remaining) {
1833         index = uint256(index) / 2 + 1;
1834       }
1835 
1836       if (index % 2 == 0) {
1837         h = keccak256(abi.encodePacked(el, h));
1838         index = index / 2;
1839       } else {
1840         h = keccak256(abi.encodePacked(h, el));
1841         index = uint256(index) / 2 + 1;
1842       }
1843     }
1844 
1845     return h == root;
1846   }
1847 }
1848 
1849 // File: contracts/lib/LeafLib.sol
1850 
1851 // SPDX-License-Identifier: MIT
1852 pragma solidity >=0.4.22 <0.8.0;
1853 
1854 
1855 contract LeafLib is MerkleProof {
1856   mapping(address => uint256) public amounts;
1857   mapping(bytes32 => bool) public isRoot;
1858   bytes32[] public roots;
1859 
1860   function addRoot(bytes32 root) public {
1861     require(!isRoot[root], "duplicate-root");
1862     isRoot[root] = true;
1863     roots.push(root);
1864   }
1865 
1866   function addLeaf(
1867     bytes32 root,
1868     address account,
1869     uint256 amount,
1870     bytes memory proof
1871   ) public {
1872     require(isRoot[root], "no-root");
1873 
1874     bytes32 h = keccak256(abi.encode(account, amount));
1875 
1876     require(checkProof(proof, root, h), "invalid-proof");
1877 
1878     amounts[account] = amount;
1879   }
1880 }
1881 
1882 // File: contracts/sale/MerkleProofCappedCrowdsale.sol
1883 
1884 // SPDX-License-Identifier: MIT
1885 pragma solidity ^0.5.17;
1886 
1887 
1888 
1889 
1890 
1891 contract MerkleProofCappedCrowdsale is Ownable, LeafLib, Crowdsale {
1892   using SafeMath for uint256;
1893 
1894   mapping(address => bool) public isRootAdder;
1895 
1896   modifier onlyRootAdder() {
1897     require(msg.sender == owner() || isRootAdder[msg.sender], "no-root-adder");
1898     _;
1899   }
1900 
1901   function addRootAdder(address account) external onlyOwner {
1902     isRootAdder[account] = true;
1903   }
1904 
1905   function addRoot(bytes32 root) public onlyRootAdder {
1906     super.addRoot(root);
1907   }
1908 
1909   mapping(address => uint256) private _contributions;
1910 
1911   /**
1912    * @dev Returns the amount contributed so far by a specific beneficiary.
1913    * @param beneficiary Address of contributor
1914    * @return Beneficiary contribution so far
1915    */
1916   function getContribution(address beneficiary) public view returns (uint256) {
1917     return _contributions[beneficiary];
1918   }
1919 
1920   /**
1921    * @param amount cap
1922    * @param root merkle root
1923    * @param proof merkle proof
1924    */
1925   function buyTokensWithProof(
1926     uint256 amount,
1927     bytes32 root,
1928     bytes calldata proof
1929   ) external payable {
1930     addLeaf(root, msg.sender, amount, proof);
1931     buyTokens(msg.sender);
1932   }
1933 
1934   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
1935     super._preValidatePurchase(beneficiary, weiAmount);
1936     require(_contributions[beneficiary].add(weiAmount) <= amounts[beneficiary], "MerkleProofCappedCrowdsale: exceeds cap");
1937   }
1938 
1939   /**
1940    * @dev Extend parent behavior to update beneficiary contributions.
1941    * @param beneficiary Token purchaser
1942    * @param weiAmount Amount of wei contributed
1943    */
1944   function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
1945     super._updatePurchasingState(beneficiary, weiAmount);
1946     _contributions[beneficiary] = _contributions[beneficiary].add(weiAmount);
1947   }
1948 }
1949 
1950 // File: contracts/sale/PublicSale.sol
1951 
1952 pragma solidity ^0.5.17;
1953 
1954 
1955 
1956 
1957 
1958 
1959 
1960 
1961 
1962 
1963 
1964 
1965 
1966 /**
1967  * @dev RefundableCrowdsale is only used to prevent `wallet` from receiving Ether
1968  *      during crowdsale.
1969  */
1970 contract PublicSale is
1971   DSMath,
1972   Ownable,
1973   Crowdsale,
1974   AllowanceCrowdsale,
1975   TimedCrowdsale,
1976   MerkleProofCappedCrowdsale,
1977   FinalizableCrowdsale,
1978   RefundableCrowdsale,
1979   RoundCrowdsale,
1980   PricePicker
1981 {
1982   constructor(
1983     IERC20 token, // The token being sold
1984     address payable wallet, // Address where funds are collected
1985     address tokenWallet, // Address where the token is stored
1986     uint256 openingTime, // Time when the sale is opened
1987     uint256 closingTime
1988   ) public Crowdsale(1, wallet, token) AllowanceCrowdsale(tokenWallet) TimedCrowdsale(openingTime, closingTime) RefundableCrowdsale(1) {}
1989 
1990   ////////////////////////
1991   // Prices
1992   ////////////////////////
1993   function DAI_CFX() public view returns (uint256) {
1994     return getCurrentRate();
1995   }
1996 
1997   function ETH_DAI() public view returns (uint256) {
1998     return getPrice();
1999   }
2000 
2001   function ETH_CFX() public view returns (uint256) {
2002     return wdiv(ETH_DAI(), DAI_CFX());
2003   }
2004 
2005   /**
2006    * @dev Override Crowdsale#_getTokenAmount
2007    * @param weiAmount Value in wei to be converted into tokens
2008    * @return Number of tokens that can be purchased with the specified _weiAmount
2009    */
2010   function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
2011     return calcTokenAmountWithEthPrice(weiAmount);
2012   }
2013 
2014   function calcTokenAmountWithEthPrice(uint256 ethAmount) public view returns (uint256) {
2015     return wmul(ethAmount, ETH_CFX());
2016   }
2017 
2018   function isOpen() public view returns (bool) {
2019     return RoundCrowdsale.isOpen() && TimedCrowdsale.isOpen();
2020   }
2021 
2022   /**
2023    * @dev Override FinalizableCrowdsale#finalize
2024    */
2025   function finalize() public onlyOwner {
2026     super.finalize();
2027   }
2028 
2029   /**
2030    * @dev Override RefundableCrowdsale#claimRefund
2031    */
2032   function claimRefund(address payable) public {
2033     revert("PublicSale: not supported");
2034   }
2035 
2036   /**
2037    * @dev Override RefundableCrowdsale#goalReached
2038    * @return Whether funding goal was reached
2039    */
2040   function goalReached() public view returns (bool) {
2041     return hasClosed();
2042   }
2043 
2044   function goal() public view returns (uint256) {
2045     revert("PublicSale: not supported");
2046   }
2047 
2048   /**
2049    * @dev Overrides Crowdsale._preValidatePurchase
2050    * @param beneficiary Address performing the token purchase
2051    * @param weiAmount Value in wei involved in the purchase
2052    */
2053   function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
2054     super._preValidatePurchase(beneficiary, weiAmount);
2055     require(msg.sender == tx.origin, "PublicSale: invalid tx origin");
2056     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
2057   }
2058 }