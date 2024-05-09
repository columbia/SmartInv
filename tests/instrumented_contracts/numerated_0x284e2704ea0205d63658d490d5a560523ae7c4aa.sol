1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
30     }
31 }
32 
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
198  * the optional functions; to access them see {ERC20Detailed}.
199  */
200 interface IERC20 {
201     /**
202      * @dev Returns the amount of tokens in existence.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns the amount of tokens owned by `account`.
208      */
209     function balanceOf(address account) external view returns (uint256);
210 
211     /**
212      * @dev Moves `amount` tokens from the caller's account to `recipient`.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transfer(address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Returns the remaining number of tokens that `spender` will be
222      * allowed to spend on behalf of `owner` through {transferFrom}. This is
223      * zero by default.
224      *
225      * This value changes when {approve} or {transferFrom} are called.
226      */
227     function allowance(address owner, address spender) external view returns (uint256);
228 
229     /**
230      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * IMPORTANT: Beware that changing an allowance with this method brings the risk
235      * that someone may use both the old and the new allowance by unfortunate
236      * transaction ordering. One possible solution to mitigate this race
237      * condition is to first reduce the spender's allowance to 0 and set the
238      * desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      *
241      * Emits an {Approval} event.
242      */
243     function approve(address spender, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Moves `amount` tokens from `sender` to `recipient` using the
247      * allowance mechanism. `amount` is then deducted from the caller's
248      * allowance.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a {Transfer} event.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to {approve}. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
272 
273 pragma solidity ^0.5.0;
274 
275 
276 /**
277  * @dev Optional functions from the ERC20 standard.
278  */
279 contract ERC20Detailed is IERC20 {
280     string private _name;
281     string private _symbol;
282     uint8 private _decimals;
283 
284     /**
285      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
286      * these values are immutable: they can only be set once during
287      * construction.
288      */
289     constructor (string memory name, string memory symbol, uint8 decimals) public {
290         _name = name;
291         _symbol = symbol;
292         _decimals = decimals;
293     }
294 
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() public view returns (string memory) {
299         return _name;
300     }
301 
302     /**
303      * @dev Returns the symbol of the token, usually a shorter version of the
304      * name.
305      */
306     function symbol() public view returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @dev Returns the number of decimals used to get its user representation.
312      * For example, if `decimals` equals `2`, a balance of `505` tokens should
313      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
314      *
315      * Tokens usually opt for a value of 18, imitating the relationship between
316      * Ether and Wei.
317      *
318      * NOTE: This information is only used for _display_ purposes: it in
319      * no way affects any of the arithmetic of the contract, including
320      * {IERC20-balanceOf} and {IERC20-transfer}.
321      */
322     function decimals() public view returns (uint8) {
323         return _decimals;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Address.sol
328 
329 pragma solidity ^0.5.5;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following 
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
354         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
355         // for accounts without code, i.e. `keccak256('')`
356         bytes32 codehash;
357         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
358         // solhint-disable-next-line no-inline-assembly
359         assembly { codehash := extcodehash(account) }
360         return (codehash != accountHash && codehash != 0x0);
361     }
362 
363     /**
364      * @dev Converts an `address` into `address payable`. Note that this is
365      * simply a type cast: the actual underlying value is not changed.
366      *
367      * _Available since v2.4.0._
368      */
369     function toPayable(address account) internal pure returns (address payable) {
370         return address(uint160(account));
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      *
389      * _Available since v2.4.0._
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         // solhint-disable-next-line avoid-call-value
395         (bool success, ) = recipient.call.value(amount)("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
401 
402 pragma solidity ^0.5.0;
403 
404 
405 
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using SafeMath for uint256;
418     using Address for address;
419 
420     function safeTransfer(IERC20 token, address to, uint256 value) internal {
421         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
422     }
423 
424     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
425         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
426     }
427 
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
446         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves.
458 
459         // A Solidity high level call has three parts:
460         //  1. The target address is checked to verify it contains contract code
461         //  2. The call itself is made, and success asserted
462         //  3. The return value is decoded, which in turn checks the size of the returned data.
463         // solhint-disable-next-line max-line-length
464         require(address(token).isContract(), "SafeERC20: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = address(token).call(data);
468         require(success, "SafeERC20: low-level call failed");
469 
470         if (returndata.length > 0) { // Return data is optional
471             // solhint-disable-next-line max-line-length
472             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
478 
479 pragma solidity ^0.5.0;
480 
481 /**
482  * @dev Contract module that helps prevent reentrant calls to a function.
483  *
484  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
485  * available, which can be applied to functions to make sure there are no nested
486  * (reentrant) calls to them.
487  *
488  * Note that because there is a single `nonReentrant` guard, functions marked as
489  * `nonReentrant` may not call one another. This can be worked around by making
490  * those functions `private`, and then adding `external` `nonReentrant` entry
491  * points to them.
492  *
493  * TIP: If you would like to learn more about reentrancy and alternative ways
494  * to protect against it, check out our blog post
495  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
496  *
497  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
498  * metering changes introduced in the Istanbul hardfork.
499  */
500 contract ReentrancyGuard {
501     bool private _notEntered;
502 
503     constructor () internal {
504         // Storing an initial non-zero value makes deployment a bit more
505         // expensive, but in exchange the refund on every call to nonReentrant
506         // will be lower in amount. Since refunds are capped to a percetange of
507         // the total transaction's gas, it is best to keep them low in cases
508         // like this one, to increase the likelihood of the full refund coming
509         // into effect.
510         _notEntered = true;
511     }
512 
513     /**
514      * @dev Prevents a contract from calling itself, directly or indirectly.
515      * Calling a `nonReentrant` function from another `nonReentrant`
516      * function is not supported. It is possible to prevent this from happening
517      * by making the `nonReentrant` function external, and make it call a
518      * `private` function that does the actual work.
519      */
520     modifier nonReentrant() {
521         // On the first call to nonReentrant, _notEntered will be true
522         require(_notEntered, "ReentrancyGuard: reentrant call");
523 
524         // Any calls to nonReentrant after this point will fail
525         _notEntered = false;
526 
527         _;
528 
529         // By storing the original value once again, a refund is triggered (see
530         // https://eips.ethereum.org/EIPS/eip-2200)
531         _notEntered = true;
532     }
533 }
534 
535 // File: @openzeppelin/contracts/GSN/Context.sol
536 
537 pragma solidity ^0.5.0;
538 
539 /*
540  * @dev Provides information about the current execution context, including the
541  * sender of the transaction and its data. While these are generally available
542  * via msg.sender and msg.data, they should not be accessed in such a direct
543  * manner, since when dealing with GSN meta-transactions the account sending and
544  * paying for execution may not be the actual sender (as far as an application
545  * is concerned).
546  *
547  * This contract is only required for intermediate, library-like contracts.
548  */
549 contract Context {
550     // Empty internal constructor, to prevent people from mistakenly deploying
551     // an instance of this contract, which should be used via inheritance.
552     constructor () internal { }
553     // solhint-disable-previous-line no-empty-blocks
554 
555     function _msgSender() internal view returns (address payable) {
556         return msg.sender;
557     }
558 
559     function _msgData() internal view returns (bytes memory) {
560         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
561         return msg.data;
562     }
563 }
564 
565 // File: @openzeppelin/contracts/ownership/Ownable.sol
566 
567 pragma solidity ^0.5.0;
568 
569 /**
570  * @dev Contract module which provides a basic access control mechanism, where
571  * there is an account (an owner) that can be granted exclusive access to
572  * specific functions.
573  *
574  * This module is used through inheritance. It will make available the modifier
575  * `onlyOwner`, which can be applied to your functions to restrict their use to
576  * the owner.
577  */
578 contract Ownable is Context {
579     address private _owner;
580 
581     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
582 
583     /**
584      * @dev Initializes the contract setting the deployer as the initial owner.
585      */
586     constructor () internal {
587         address msgSender = _msgSender();
588         _owner = msgSender;
589         emit OwnershipTransferred(address(0), msgSender);
590     }
591 
592     /**
593      * @dev Returns the address of the current owner.
594      */
595     function owner() public view returns (address) {
596         return _owner;
597     }
598 
599     /**
600      * @dev Throws if called by any account other than the owner.
601      */
602     modifier onlyOwner() {
603         require(isOwner(), "Ownable: caller is not the owner");
604         _;
605     }
606 
607     /**
608      * @dev Returns true if the caller is the current owner.
609      */
610     function isOwner() public view returns (bool) {
611         return _msgSender() == _owner;
612     }
613 
614     /**
615      * @dev Leaves the contract without owner. It will not be possible to call
616      * `onlyOwner` functions anymore. Can only be called by the current owner.
617      *
618      * NOTE: Renouncing ownership will leave the contract without an owner,
619      * thereby removing any functionality that is only available to the owner.
620      */
621     function renounceOwnership() public onlyOwner {
622         emit OwnershipTransferred(_owner, address(0));
623         _owner = address(0);
624     }
625 
626     /**
627      * @dev Transfers ownership of the contract to a new account (`newOwner`).
628      * Can only be called by the current owner.
629      */
630     function transferOwnership(address newOwner) public onlyOwner {
631         _transferOwnership(newOwner);
632     }
633 
634     /**
635      * @dev Transfers ownership of the contract to a new account (`newOwner`).
636      */
637     function _transferOwnership(address newOwner) internal {
638         require(newOwner != address(0), "Ownable: new owner is the zero address");
639         emit OwnershipTransferred(_owner, newOwner);
640         _owner = newOwner;
641     }
642 }
643 
644 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2ERC20.sol
645 
646 pragma solidity >=0.5.0;
647 
648 interface IUniswapV2ERC20 {
649     event Approval(address indexed owner, address indexed spender, uint value);
650     event Transfer(address indexed from, address indexed to, uint value);
651 
652     function name() external pure returns (string memory);
653     function symbol() external pure returns (string memory);
654     function decimals() external pure returns (uint8);
655     function totalSupply() external view returns (uint);
656     function balanceOf(address owner) external view returns (uint);
657     function allowance(address owner, address spender) external view returns (uint);
658 
659     function approve(address spender, uint value) external returns (bool);
660     function transfer(address to, uint value) external returns (bool);
661     function transferFrom(address from, address to, uint value) external returns (bool);
662 
663     function DOMAIN_SEPARATOR() external view returns (bytes32);
664     function PERMIT_TYPEHASH() external pure returns (bytes32);
665     function nonces(address owner) external view returns (uint);
666 
667     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
668 }
669 
670 // File: contracts/interfaces/IStakingRewards.sol
671 
672 pragma solidity >=0.4.24;
673 
674 
675 interface IStakingRewards {
676     // Views
677     function lastTimeRewardApplicable() external view returns (uint256);
678 
679     function rewardPerToken() external view returns (uint256);
680 
681     function earned(address account) external view returns (uint256);
682 
683     function getRewardForDuration() external view returns (uint256);
684 
685     function totalSupply() external view returns (uint256);
686 
687     function balanceOf(address account) external view returns (uint256);
688 
689     // Mutative
690 
691     function stake(uint256 amount) external;
692 
693     function withdraw(uint256 amount) external;
694 
695     function getReward() external;
696 
697     function exit() external;
698 }
699 
700 // File: contracts/StakingRewards.sol
701 
702 pragma solidity ^0.5.17;
703 
704 
705 
706 
707 
708 
709 
710 
711 // Inheritance
712 
713 
714 
715 contract StakingRewards is IStakingRewards, ReentrancyGuard, Ownable {
716     using SafeMath for uint256;
717     using SafeERC20 for IERC20;
718 
719     /* ========== STATE VARIABLES ========== */
720 
721     IERC20 public rewardsToken;
722     IERC20 public stakingToken;
723     uint256 public periodFinish = 0;
724     uint256 public rewardRate = 0;
725     uint256 public rewardsDuration = 30 days + 12 hours;
726     uint256 public lastUpdateTime;
727     uint256 public rewardPerTokenStored;
728     uint256 public launchTimestamp;
729 
730     mapping(address => uint256) public userRewardPerTokenPaid;
731     mapping(address => uint256) public rewards;
732 
733     uint256 private _totalSupply;
734     mapping(address => uint256) private _balances;
735 
736     /* ========== CONSTRUCTOR ========== */
737 
738     constructor(
739         address _rewardsToken,
740         address _stakingToken
741     ) Ownable() public {
742         rewardsToken = IERC20(_rewardsToken);
743         stakingToken = IERC20(_stakingToken);
744         launchTimestamp = now;
745     }
746 
747     /* ========== VIEWS ========== */
748 
749     function totalSupply() external view returns (uint256) {
750         return _totalSupply;
751     }
752 
753     function balanceOf(address account) external view returns (uint256) {
754         return _balances[account];
755     }
756 
757     function lastTimeRewardApplicable() public view returns (uint256) {
758         return Math.min(block.timestamp, periodFinish);
759     }
760 
761     function rewardPerToken() public view returns (uint256) {
762         if (_totalSupply == 0) {
763             return rewardPerTokenStored;
764 
765         }
766         return
767             rewardPerTokenStored.add(
768                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
769             );
770     }
771 
772     function earned(address account) public view returns (uint256) {
773         return _balances[account].mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
774     }
775 
776     function getRewardForDuration() external view returns (uint256) {
777         return rewardRate.mul(rewardsDuration);
778     }
779 
780     /* ========== MUTATIVE FUNCTIONS ========== */
781 
782     function stakeWithPermit(uint256 amount, uint deadline, uint8 v, bytes32 r, bytes32 s) external nonReentrant updateReward(msg.sender) {
783         require(amount > 0, "Cannot stake 0");
784         _totalSupply = _totalSupply.add(amount);
785         _balances[msg.sender] = _balances[msg.sender].add(amount);
786 
787         // permit
788         IUniswapV2ERC20(address(stakingToken)).permit(msg.sender, address(this), amount, deadline, v, r, s);
789 
790         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
791         emit Staked(msg.sender, amount);
792     }
793 
794     function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
795         require(amount > 0, "Cannot stake 0");
796         _totalSupply = _totalSupply.add(amount);
797         _balances[msg.sender] = _balances[msg.sender].add(amount);
798         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
799         emit Staked(msg.sender, amount);
800     }
801 
802     function withdraw(uint256 amount) public guardForPrematureWithdrawal nonReentrant updateReward(msg.sender) {
803         require(amount > 0, "Cannot withdraw 0");
804         _totalSupply = _totalSupply.sub(amount);
805         _balances[msg.sender] = _balances[msg.sender].sub(amount);
806         stakingToken.safeTransfer(msg.sender, amount);
807         emit Withdrawn(msg.sender, amount);
808     }
809 
810     function getReward() public guardForPrematureWithdrawal nonReentrant updateReward(msg.sender) {
811         uint256 reward = rewards[msg.sender];
812         if (reward > 0) {
813             rewards[msg.sender] = 0;
814             rewardsToken.safeTransfer(msg.sender, reward);
815             emit RewardPaid(msg.sender, reward);
816         }
817     }
818 
819     function exit() external guardForPrematureWithdrawal {
820         withdraw(_balances[msg.sender]);
821         getReward();
822     }
823 
824     /* ========== RESTRICTED FUNCTIONS ========== */
825 
826     function notifyRewardAmount(uint256 reward) external onlyOwner updateReward(address(0)) {
827         if (block.timestamp >= periodFinish) {
828             rewardRate = reward.div(rewardsDuration);
829         } else {
830             uint256 remaining = periodFinish.sub(block.timestamp);
831             uint256 leftover = remaining.mul(rewardRate);
832             rewardRate = reward.add(leftover).div(rewardsDuration);
833         }
834 
835         // Ensure the provided reward amount is not more than the balance in the contract.
836         // This keeps the reward rate in the right range, preventing overflows due to
837         // very high values of rewardRate in the earned and rewardsPerToken functions;
838         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
839         uint balance = rewardsToken.balanceOf(address(this));
840         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
841 
842         lastUpdateTime = block.timestamp;
843         periodFinish = block.timestamp.add(rewardsDuration);
844         emit RewardAdded(reward);
845     }
846 
847     // End rewards emission earlier
848     function updatePeriodFinish(uint timestamp) external onlyOwner updateReward(address(0)) {
849         periodFinish = timestamp;
850     }
851 
852     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
853     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
854         require(tokenAddress != address(stakingToken), "Cannot withdraw the staking token");
855         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
856         emit Recovered(tokenAddress, tokenAmount);
857     }
858 
859     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
860         require(
861             block.timestamp > periodFinish,
862             "Previous rewards period must be complete before changing the duration for the new period"
863         );
864         rewardsDuration = _rewardsDuration;
865         emit RewardsDurationUpdated(rewardsDuration);
866     }
867 
868     /* ========== MODIFIERS ========== */
869 
870     modifier updateReward(address account) {
871         rewardPerTokenStored = rewardPerToken();
872         lastUpdateTime = lastTimeRewardApplicable();
873         if (account != address(0)) {
874             rewards[account] = earned(account);
875             userRewardPerTokenPaid[account] = rewardPerTokenStored;
876         }
877         _;
878     }
879 
880     modifier guardForPrematureWithdrawal()
881     {
882         require(now >= (launchTimestamp + 8 days + 12 hours), "[Withdraw] Not enough days passed");
883         _;
884     }
885 
886     /* ========== EVENTS ========== */
887 
888     event RewardAdded(uint256 reward);
889     event Staked(address indexed user, uint256 amount);
890     event Withdrawn(address indexed user, uint256 amount);
891     event RewardPaid(address indexed user, uint256 reward);
892     event RewardsDurationUpdated(uint256 newDuration);
893     event Recovered(address token, uint256 amount);
894 }