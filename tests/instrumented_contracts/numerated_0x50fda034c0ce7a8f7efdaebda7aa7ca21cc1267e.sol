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
189 // File: contracts/interface/IWETH.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 
195 contract IWETH is IERC20 {
196     function deposit() external payable;
197 
198     function withdraw(uint256 amount) external;
199 }
200 
201 // File: @openzeppelin/contracts/math/SafeMath.sol
202 
203 pragma solidity ^0.5.0;
204 
205 /**
206  * @dev Wrappers over Solidity's arithmetic operations with added overflow
207  * checks.
208  *
209  * Arithmetic operations in Solidity wrap on overflow. This can easily result
210  * in bugs, because programmers usually assume that an overflow raises an
211  * error, which is the standard behavior in high level programming languages.
212  * `SafeMath` restores this intuition by reverting the transaction when an
213  * operation overflows.
214  *
215  * Using this library instead of the unchecked operations eliminates an entire
216  * class of bugs, so it's recommended to use it always.
217  */
218 library SafeMath {
219     /**
220      * @dev Returns the addition of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `+` operator.
224      *
225      * Requirements:
226      * - Addition cannot overflow.
227      */
228     function add(uint256 a, uint256 b) internal pure returns (uint256) {
229         uint256 c = a + b;
230         require(c >= a, "SafeMath: addition overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      * - Subtraction cannot overflow.
243      */
244     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245         return sub(a, b, "SafeMath: subtraction overflow");
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      * - Subtraction cannot overflow.
256      *
257      * _Available since v2.4.0._
258      */
259     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b <= a, errorMessage);
261         uint256 c = a - b;
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the multiplication of two unsigned integers, reverting on
268      * overflow.
269      *
270      * Counterpart to Solidity's `*` operator.
271      *
272      * Requirements:
273      * - Multiplication cannot overflow.
274      */
275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
276         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
277         // benefit is lost if 'b' is also tested.
278         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
279         if (a == 0) {
280             return 0;
281         }
282 
283         uint256 c = a * b;
284         require(c / a == b, "SafeMath: multiplication overflow");
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers. Reverts on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         return div(a, b, "SafeMath: division by zero");
302     }
303 
304     /**
305      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
306      * division by zero. The result is rounded towards zero.
307      *
308      * Counterpart to Solidity's `/` operator. Note: this function uses a
309      * `revert` opcode (which leaves remaining gas untouched) while Solidity
310      * uses an invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      * - The divisor cannot be zero.
314      *
315      * _Available since v2.4.0._
316      */
317     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         // Solidity only automatically asserts when dividing by 0
319         require(b > 0, errorMessage);
320         uint256 c = a / b;
321         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322 
323         return c;
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328      * Reverts when dividing by zero.
329      *
330      * Counterpart to Solidity's `%` operator. This function uses a `revert`
331      * opcode (which leaves remaining gas untouched) while Solidity uses an
332      * invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
338         return mod(a, b, "SafeMath: modulo by zero");
339     }
340 
341     /**
342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
343      * Reverts with custom message when dividing by zero.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      * - The divisor cannot be zero.
351      *
352      * _Available since v2.4.0._
353      */
354     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b != 0, errorMessage);
356         return a % b;
357     }
358 }
359 
360 // File: @openzeppelin/contracts/utils/Address.sol
361 
362 pragma solidity ^0.5.5;
363 
364 /**
365  * @dev Collection of functions related to the address type
366  */
367 library Address {
368     /**
369      * @dev Returns true if `account` is a contract.
370      *
371      * [IMPORTANT]
372      * ====
373      * It is unsafe to assume that an address for which this function returns
374      * false is an externally-owned account (EOA) and not a contract.
375      *
376      * Among others, `isContract` will return false for the following 
377      * types of addresses:
378      *
379      *  - an externally-owned account
380      *  - a contract in construction
381      *  - an address where a contract will be created
382      *  - an address where a contract lived, but was destroyed
383      * ====
384      */
385     function isContract(address account) internal view returns (bool) {
386         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
387         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
388         // for accounts without code, i.e. `keccak256('')`
389         bytes32 codehash;
390         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
391         // solhint-disable-next-line no-inline-assembly
392         assembly { codehash := extcodehash(account) }
393         return (codehash != accountHash && codehash != 0x0);
394     }
395 
396     /**
397      * @dev Converts an `address` into `address payable`. Note that this is
398      * simply a type cast: the actual underlying value is not changed.
399      *
400      * _Available since v2.4.0._
401      */
402     function toPayable(address account) internal pure returns (address payable) {
403         return address(uint160(account));
404     }
405 
406     /**
407      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
408      * `recipient`, forwarding all available gas and reverting on errors.
409      *
410      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
411      * of certain opcodes, possibly making contracts go over the 2300 gas limit
412      * imposed by `transfer`, making them unable to receive funds via
413      * `transfer`. {sendValue} removes this limitation.
414      *
415      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
416      *
417      * IMPORTANT: because control is transferred to `recipient`, care must be
418      * taken to not create reentrancy vulnerabilities. Consider using
419      * {ReentrancyGuard} or the
420      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
421      *
422      * _Available since v2.4.0._
423      */
424     function sendValue(address payable recipient, uint256 amount) internal {
425         require(address(this).balance >= amount, "Address: insufficient balance");
426 
427         // solhint-disable-next-line avoid-call-value
428         (bool success, ) = recipient.call.value(amount)("");
429         require(success, "Address: unable to send value, recipient may have reverted");
430     }
431 }
432 
433 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
434 
435 pragma solidity ^0.5.0;
436 
437 
438 
439 
440 /**
441  * @title SafeERC20
442  * @dev Wrappers around ERC20 operations that throw on failure (when the token
443  * contract returns false). Tokens that return no value (and instead revert or
444  * throw on failure) are also supported, non-reverting calls are assumed to be
445  * successful.
446  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
447  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
448  */
449 library SafeERC20 {
450     using SafeMath for uint256;
451     using Address for address;
452 
453     function safeTransfer(IERC20 token, address to, uint256 value) internal {
454         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
455     }
456 
457     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
458         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
459     }
460 
461     function safeApprove(IERC20 token, address spender, uint256 value) internal {
462         // safeApprove should only be called when setting an initial allowance,
463         // or when resetting it to zero. To increase and decrease it, use
464         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
465         // solhint-disable-next-line max-line-length
466         require((value == 0) || (token.allowance(address(this), spender) == 0),
467             "SafeERC20: approve from non-zero to non-zero allowance"
468         );
469         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
470     }
471 
472     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
473         uint256 newAllowance = token.allowance(address(this), spender).add(value);
474         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
475     }
476 
477     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
478         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
479         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
480     }
481 
482     /**
483      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
484      * on the return value: the return value is optional (but if data is returned, it must not be false).
485      * @param token The token targeted by the call.
486      * @param data The call data (encoded using abi.encode or one of its variants).
487      */
488     function callOptionalReturn(IERC20 token, bytes memory data) private {
489         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
490         // we're implementing it ourselves.
491 
492         // A Solidity high level call has three parts:
493         //  1. The target address is checked to verify it contains contract code
494         //  2. The call itself is made, and success asserted
495         //  3. The return value is decoded, which in turn checks the size of the returned data.
496         // solhint-disable-next-line max-line-length
497         require(address(token).isContract(), "SafeERC20: call to non-contract");
498 
499         // solhint-disable-next-line avoid-low-level-calls
500         (bool success, bytes memory returndata) = address(token).call(data);
501         require(success, "SafeERC20: low-level call failed");
502 
503         if (returndata.length > 0) { // Return data is optional
504             // solhint-disable-next-line max-line-length
505             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
506         }
507     }
508 }
509 
510 // File: contracts/UniversalERC20.sol
511 
512 pragma solidity ^0.5.0;
513 
514 
515 
516 
517 
518 library UniversalERC20 {
519 
520     using SafeMath for uint256;
521     using SafeERC20 for IERC20;
522 
523     IERC20 private constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
524     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
525 
526     function universalTransfer(IERC20 token, address to, uint256 amount) internal returns(bool) {
527         if (amount == 0) {
528             return true;
529         }
530 
531         if (isETH(token)) {
532             address(uint160(to)).transfer(amount);
533         } else {
534             token.safeTransfer(to, amount);
535             return true;
536         }
537     }
538 
539     function universalTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
540         if (amount == 0) {
541             return;
542         }
543 
544         if (isETH(token)) {
545             require(from == msg.sender && msg.value >= amount, "Wrong useage of ETH.universalTransferFrom()");
546             if (to != address(this)) {
547                 address(uint160(to)).transfer(amount);
548             }
549             if (msg.value > amount) {
550                 msg.sender.transfer(msg.value.sub(amount));
551             }
552         } else {
553             token.safeTransferFrom(from, to, amount);
554         }
555     }
556 
557     function universalTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
558         if (amount == 0) {
559             return;
560         }
561 
562         if (isETH(token)) {
563             if (msg.value > amount) {
564                 // Return remainder if exist
565                 msg.sender.transfer(msg.value.sub(amount));
566             }
567         } else {
568             token.safeTransferFrom(msg.sender, address(this), amount);
569         }
570     }
571 
572     function universalApprove(IERC20 token, address to, uint256 amount) internal {
573         if (!isETH(token)) {
574             if (amount == 0) {
575                 token.safeApprove(to, 0);
576                 return;
577             }
578 
579             uint256 allowance = token.allowance(address(this), to);
580             if (allowance < amount) {
581                 if (allowance > 0) {
582                     token.safeApprove(to, 0);
583                 }
584                 token.safeApprove(to, amount);
585             }
586         }
587     }
588 
589     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
590         if (isETH(token)) {
591             return who.balance;
592         } else {
593             return token.balanceOf(who);
594         }
595     }
596 
597     function universalDecimals(IERC20 token) internal view returns (uint256) {
598 
599         if (isETH(token)) {
600             return 18;
601         }
602 
603         (bool success, bytes memory data) = address(token).staticcall.gas(10000)(
604             abi.encodeWithSignature("decimals()")
605         );
606         if (!success || data.length == 0) {
607             (success, data) = address(token).staticcall.gas(10000)(
608                 abi.encodeWithSignature("DECIMALS()")
609             );
610         }
611 
612         return (success && data.length > 0) ? abi.decode(data, (uint256)) : 18;
613     }
614 
615     function isETH(IERC20 token) internal pure returns(bool) {
616         return (address(token) == address(ZERO_ADDRESS) || address(token) == address(ETH_ADDRESS));
617     }
618 
619     function notExist(IERC20 token) internal pure returns(bool) {
620         return (address(token) == address(-1));
621     }
622 }
623 
624 // File: contracts/interface/IUniswapV2Exchange.sol
625 
626 pragma solidity ^0.5.0;
627 
628 
629 
630 
631 
632 interface IUniswapV2Exchange {
633     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
634 }
635 
636 
637 library UniswapV2ExchangeLib {
638     using SafeMath for uint256;
639     using UniversalERC20 for IERC20;
640 
641     function getReturn(
642         IUniswapV2Exchange exchange,
643         IERC20 fromToken,
644         IERC20 destToken,
645         uint amountIn
646     ) internal view returns (uint256) {
647         uint256 reserveIn = fromToken.universalBalanceOf(address(exchange));
648         uint256 reserveOut = destToken.universalBalanceOf(address(exchange));
649 
650         uint256 amountInWithFee = amountIn.mul(997);
651         uint256 numerator = amountInWithFee.mul(reserveOut);
652         uint256 denominator = reserveIn.mul(1000).add(amountInWithFee);
653         return (denominator == 0) ? 0 : numerator.div(denominator);
654     }
655 }
656 
657 // File: contracts/IOneSplit.sol
658 
659 pragma solidity ^0.5.0;
660 
661 
662 //
663 //  [ msg.sender ]
664 //       | |
665 //       | |
666 //       \_/
667 // +---------------+ ________________________________
668 // | OneSplitAudit | _______________________________  \
669 // +---------------+                                 \ \
670 //       | |                      ______________      | | (staticcall)
671 //       | |                    /  ____________  \    | |
672 //       | | (call)            / /              \ \   | |
673 //       | |                  / /               | |   | |
674 //       \_/                  | |               \_/   \_/
675 // +--------------+           | |           +----------------------+
676 // | OneSplitWrap |           | |           |   OneSplitViewWrap   |
677 // +--------------+           | |           +----------------------+
678 //       | |                  | |                     | |
679 //       | | (delegatecall)   | | (staticcall)        | | (staticcall)
680 //       \_/                  | |                     \_/
681 // +--------------+           | |             +------------------+
682 // |   OneSplit   |           | |             |   OneSplitView   |
683 // +--------------+           | |             +------------------+
684 //       | |                  / /
685 //        \ \________________/ /
686 //         \__________________/
687 //
688 
689 
690 contract IOneSplitConsts {
691     // flags = FLAG_DISABLE_UNISWAP + FLAG_DISABLE_BANCOR + ...
692     uint256 internal constant FLAG_DISABLE_UNISWAP = 0x01;
693     uint256 internal constant DEPRECATED_FLAG_DISABLE_KYBER = 0x02; // Deprecated
694     uint256 internal constant FLAG_DISABLE_BANCOR = 0x04;
695     uint256 internal constant FLAG_DISABLE_OASIS = 0x08;
696     uint256 internal constant FLAG_DISABLE_COMPOUND = 0x10;
697     uint256 internal constant FLAG_DISABLE_FULCRUM = 0x20;
698     uint256 internal constant FLAG_DISABLE_CHAI = 0x40;
699     uint256 internal constant FLAG_DISABLE_AAVE = 0x80;
700     uint256 internal constant FLAG_DISABLE_SMART_TOKEN = 0x100;
701     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_ETH = 0x200; // Deprecated, Turned off by default
702     uint256 internal constant FLAG_DISABLE_BDAI = 0x400;
703     uint256 internal constant FLAG_DISABLE_IEARN = 0x800;
704     uint256 internal constant FLAG_DISABLE_CURVE_COMPOUND = 0x1000;
705     uint256 internal constant FLAG_DISABLE_CURVE_USDT = 0x2000;
706     uint256 internal constant FLAG_DISABLE_CURVE_Y = 0x4000;
707     uint256 internal constant FLAG_DISABLE_CURVE_BINANCE = 0x8000;
708     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_DAI = 0x10000; // Deprecated, Turned off by default
709     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_USDC = 0x20000; // Deprecated, Turned off by default
710     uint256 internal constant FLAG_DISABLE_CURVE_SYNTHETIX = 0x40000;
711     uint256 internal constant FLAG_DISABLE_WETH = 0x80000;
712     uint256 internal constant FLAG_DISABLE_UNISWAP_COMPOUND = 0x100000; // Works only when one of assets is ETH or FLAG_ENABLE_MULTI_PATH_ETH
713     uint256 internal constant FLAG_DISABLE_UNISWAP_CHAI = 0x200000; // Works only when ETH<>DAI or FLAG_ENABLE_MULTI_PATH_ETH
714     uint256 internal constant FLAG_DISABLE_UNISWAP_AAVE = 0x400000; // Works only when one of assets is ETH or FLAG_ENABLE_MULTI_PATH_ETH
715     uint256 internal constant FLAG_DISABLE_IDLE = 0x800000;
716     uint256 internal constant FLAG_DISABLE_MOONISWAP = 0x1000000;
717     uint256 internal constant FLAG_DISABLE_UNISWAP_V2 = 0x2000000;
718     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ETH = 0x4000000;
719     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_DAI = 0x8000000;
720     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_USDC = 0x10000000;
721     uint256 internal constant FLAG_DISABLE_ALL_SPLIT_SOURCES = 0x20000000;
722     uint256 internal constant FLAG_DISABLE_ALL_WRAP_SOURCES = 0x40000000;
723     uint256 internal constant FLAG_DISABLE_CURVE_PAX = 0x80000000;
724     uint256 internal constant FLAG_DISABLE_CURVE_RENBTC = 0x100000000;
725     uint256 internal constant FLAG_DISABLE_CURVE_TBTC = 0x200000000;
726     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_USDT = 0x400000000; // Deprecated, Turned off by default
727     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_WBTC = 0x800000000; // Deprecated, Turned off by default
728     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_TBTC = 0x1000000000; // Deprecated, Turned off by default
729     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_RENBTC = 0x2000000000; // Deprecated, Turned off by default
730     uint256 internal constant FLAG_DISABLE_DFORCE_SWAP = 0x4000000000;
731     uint256 internal constant FLAG_DISABLE_SHELL = 0x8000000000;
732     uint256 internal constant FLAG_ENABLE_CHI_BURN = 0x10000000000;
733     uint256 internal constant FLAG_DISABLE_MSTABLE_MUSD = 0x20000000000;
734     uint256 internal constant FLAG_DISABLE_CURVE_SBTC = 0x40000000000;
735     uint256 internal constant FLAG_DISABLE_DMM = 0x80000000000;
736     uint256 internal constant FLAG_DISABLE_UNISWAP_ALL = 0x100000000000;
737     uint256 internal constant FLAG_DISABLE_CURVE_ALL = 0x200000000000;
738     uint256 internal constant FLAG_DISABLE_UNISWAP_V2_ALL = 0x400000000000;
739     uint256 internal constant FLAG_DISABLE_SPLIT_RECALCULATION = 0x800000000000;
740     uint256 internal constant FLAG_DISABLE_BALANCER_ALL = 0x1000000000000;
741     uint256 internal constant FLAG_DISABLE_BALANCER_1 = 0x2000000000000;
742     uint256 internal constant FLAG_DISABLE_BALANCER_2 = 0x4000000000000;
743     uint256 internal constant FLAG_DISABLE_BALANCER_3 = 0x8000000000000;
744     uint256 internal constant DEPRECATED_FLAG_ENABLE_KYBER_UNISWAP_RESERVE = 0x10000000000000; // Deprecated, Turned off by default
745     uint256 internal constant DEPRECATED_FLAG_ENABLE_KYBER_OASIS_RESERVE = 0x20000000000000; // Deprecated, Turned off by default
746     uint256 internal constant DEPRECATED_FLAG_ENABLE_KYBER_BANCOR_RESERVE = 0x40000000000000; // Deprecated, Turned off by default
747     uint256 internal constant FLAG_ENABLE_REFERRAL_GAS_SPONSORSHIP = 0x80000000000000; // Turned off by default
748     uint256 internal constant DEPRECATED_FLAG_ENABLE_MULTI_PATH_COMP = 0x100000000000000; // Deprecated, Turned off by default
749     uint256 internal constant FLAG_DISABLE_KYBER_ALL = 0x200000000000000;
750     uint256 internal constant FLAG_DISABLE_KYBER_1 = 0x400000000000000;
751     uint256 internal constant FLAG_DISABLE_KYBER_2 = 0x800000000000000;
752     uint256 internal constant FLAG_DISABLE_KYBER_3 = 0x1000000000000000;
753     uint256 internal constant FLAG_DISABLE_KYBER_4 = 0x2000000000000000;
754     uint256 internal constant FLAG_ENABLE_CHI_BURN_BY_ORIGIN = 0x4000000000000000;
755 }
756 
757 
758 contract IOneSplit is IOneSplitConsts {
759     function getExpectedReturn(
760         IERC20 fromToken,
761         IERC20 destToken,
762         uint256 amount,
763         uint256 parts,
764         uint256 flags // See constants in IOneSplit.sol
765     )
766         public
767         view
768         returns(
769             uint256 returnAmount,
770             uint256[] memory distribution
771         );
772 
773     function getExpectedReturnWithGas(
774         IERC20 fromToken,
775         IERC20 destToken,
776         uint256 amount,
777         uint256 parts,
778         uint256 flags, // See constants in IOneSplit.sol
779         uint256 destTokenEthPriceTimesGasPrice
780     )
781         public
782         view
783         returns(
784             uint256 returnAmount,
785             uint256 estimateGasAmount,
786             uint256[] memory distribution
787         );
788 
789     function swap(
790         IERC20 fromToken,
791         IERC20 destToken,
792         uint256 amount,
793         uint256 minReturn,
794         uint256[] memory distribution,
795         uint256 flags
796     )
797         public
798         payable
799         returns(uint256 returnAmount);
800 }
801 
802 
803 contract IOneSplitMulti is IOneSplit {
804     function getExpectedReturnWithGasMulti(
805         IERC20[] memory tokens,
806         uint256 amount,
807         uint256[] memory parts,
808         uint256[] memory flags,
809         uint256[] memory destTokenEthPriceTimesGasPrices
810     )
811         public
812         view
813         returns(
814             uint256[] memory returnAmounts,
815             uint256 estimateGasAmount,
816             uint256[] memory distribution
817         );
818 
819     function swapMulti(
820         IERC20[] memory tokens,
821         uint256 amount,
822         uint256 minReturn,
823         uint256[] memory distribution,
824         uint256[] memory flags
825     )
826         public
827         payable
828         returns(uint256 returnAmount);
829 }
830 
831 // File: contracts/OneSplitAudit.sol
832 
833 pragma solidity ^0.5.0;
834 
835 
836 
837 
838 
839 
840 
841 contract IFreeFromUpTo is IERC20 {
842     function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);
843 }
844 
845 interface IReferralGasSponsor {
846     function makeGasDiscount(
847         uint256 gasSpent,
848         uint256 returnAmount,
849         bytes calldata msgSenderCalldata
850     ) external;
851 }
852 
853 
854 library Array {
855     function first(IERC20[] memory arr) internal pure returns(IERC20) {
856         return arr[0];
857     }
858 
859     function last(IERC20[] memory arr) internal pure returns(IERC20) {
860         return arr[arr.length - 1];
861     }
862 }
863 
864 
865 //
866 // Security assumptions:
867 // 1. It is safe to have infinite approves of any tokens to this smart contract,
868 //    since it could only call `transferFrom()` with first argument equal to msg.sender
869 // 2. It is safe to call `swap()` with reliable `minReturn` argument,
870 //    if returning amount will not reach `minReturn` value whole swap will be reverted.
871 // 3. Additionally CHI tokens could be burned from caller in case of FLAG_ENABLE_CHI_BURN (0x10000000000)
872 //    presented in `flags` or from transaction origin in case of FLAG_ENABLE_CHI_BURN_BY_ORIGIN (0x4000000000000000)
873 //    presented in `flags`. Burned amount would refund up to 43% of gas fees.
874 //
875 contract OneSplitAudit is IOneSplit, Ownable {
876     using SafeMath for uint256;
877     using UniversalERC20 for IERC20;
878     using Array for IERC20[];
879 
880     IWETH constant internal weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
881     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
882 
883     IOneSplitMulti public oneSplitImpl;
884 
885     event ImplementationUpdated(address indexed newImpl);
886 
887     event Swapped(
888         IERC20 indexed fromToken,
889         IERC20 indexed destToken,
890         uint256 fromTokenAmount,
891         uint256 destTokenAmount,
892         uint256 minReturn,
893         uint256[] distribution,
894         uint256[] flags,
895         address referral,
896         uint256 feePercent
897     );
898 
899     constructor(IOneSplitMulti impl) public {
900         setNewImpl(impl);
901     }
902 
903     function() external payable {
904         // solium-disable-next-line security/no-tx-origin
905         require(msg.sender != tx.origin, "OneSplit: do not send ETH directly");
906     }
907 
908     function setNewImpl(IOneSplitMulti impl) public onlyOwner {
909         oneSplitImpl = impl;
910         emit ImplementationUpdated(address(impl));
911     }
912 
913     /// @notice Calculate expected returning amount of `destToken`
914     /// @param fromToken (IERC20) Address of token or `address(0)` for Ether
915     /// @param destToken (IERC20) Address of token or `address(0)` for Ether
916     /// @param amount (uint256) Amount for `fromToken`
917     /// @param parts (uint256) Number of pieces source volume could be splitted,
918     /// works like granularity, higly affects gas usage. Should be called offchain,
919     /// but could be called onchain if user swaps not his own funds, but this is still considered as not safe.
920     /// @param flags (uint256) Flags for enabling and disabling some features, default 0
921     function getExpectedReturn(
922         IERC20 fromToken,
923         IERC20 destToken,
924         uint256 amount,
925         uint256 parts,
926         uint256 flags // See contants in IOneSplit.sol
927     )
928         public
929         view
930         returns(
931             uint256 returnAmount,
932             uint256[] memory distribution
933         )
934     {
935         (returnAmount, , distribution) = getExpectedReturnWithGas(
936             fromToken,
937             destToken,
938             amount,
939             parts,
940             flags,
941             0
942         );
943     }
944 
945     /// @notice Calculate expected returning amount of `destToken`
946     /// @param fromToken (IERC20) Address of token or `address(0)` for Ether
947     /// @param destToken (IERC20) Address of token or `address(0)` for Ether
948     /// @param amount (uint256) Amount for `fromToken`
949     /// @param parts (uint256) Number of pieces source volume could be splitted,
950     /// works like granularity, higly affects gas usage. Should be called offchain,
951     /// but could be called onchain if user swaps not his own funds, but this is still considered as not safe.
952     /// @param flags (uint256) Flags for enabling and disabling some features, default 0
953     /// @param destTokenEthPriceTimesGasPrice (uint256) destToken price to ETH multiplied by gas price
954     function getExpectedReturnWithGas(
955         IERC20 fromToken,
956         IERC20 destToken,
957         uint256 amount,
958         uint256 parts,
959         uint256 flags, // See constants in IOneSplit.sol
960         uint256 destTokenEthPriceTimesGasPrice
961     )
962         public
963         view
964         returns(
965             uint256 returnAmount,
966             uint256 estimateGasAmount,
967             uint256[] memory distribution
968         )
969     {
970         return oneSplitImpl.getExpectedReturnWithGas(
971             fromToken,
972             destToken,
973             amount,
974             parts,
975             flags,
976             destTokenEthPriceTimesGasPrice
977         );
978     }
979 
980     /// @notice Calculate expected returning amount of first `tokens` element to
981     /// last `tokens` element through ann the middle tokens with corresponding
982     /// `parts`, `flags` and `destTokenEthPriceTimesGasPrices` array values of each step
983     /// @param tokens (IERC20[]) Address of token or `address(0)` for Ether
984     /// @param amount (uint256) Amount for `fromToken`
985     /// @param parts (uint256[]) Number of pieces source volume could be splitted
986     /// @param flags (uint256[]) Flags for enabling and disabling some features, default 0
987     /// @param destTokenEthPriceTimesGasPrices (uint256[]) destToken price to ETH multiplied by gas price
988     function getExpectedReturnWithGasMulti(
989         IERC20[] memory tokens,
990         uint256 amount,
991         uint256[] memory parts,
992         uint256[] memory flags,
993         uint256[] memory destTokenEthPriceTimesGasPrices
994     )
995         public
996         view
997         returns(
998             uint256[] memory returnAmounts,
999             uint256 estimateGasAmount,
1000             uint256[] memory distribution
1001         )
1002     {
1003         return oneSplitImpl.getExpectedReturnWithGasMulti(
1004             tokens,
1005             amount,
1006             parts,
1007             flags,
1008             destTokenEthPriceTimesGasPrices
1009         );
1010     }
1011 
1012     /// @notice Swap `amount` of `fromToken` to `destToken`
1013     /// @param fromToken (IERC20) Address of token or `address(0)` for Ether
1014     /// @param destToken (IERC20) Address of token or `address(0)` for Ether
1015     /// @param amount (uint256) Amount for `fromToken`
1016     /// @param minReturn (uint256) Minimum expected return, else revert
1017     /// @param distribution (uint256[]) Array of weights for volume distribution returned by `getExpectedReturn`
1018     /// @param flags (uint256) Flags for enabling and disabling some features, default 0
1019     function swap(
1020         IERC20 fromToken,
1021         IERC20 destToken,
1022         uint256 amount,
1023         uint256 minReturn,
1024         uint256[] memory distribution,
1025         uint256 flags // See contants in IOneSplit.sol
1026     ) public payable returns(uint256) {
1027         return swapWithReferral(
1028             fromToken,
1029             destToken,
1030             amount,
1031             minReturn,
1032             distribution,
1033             flags,
1034             address(0),
1035             0
1036         );
1037     }
1038 
1039     /// @notice Swap `amount` of `fromToken` to `destToken`
1040     /// param fromToken (IERC20) Address of token or `address(0)` for Ether
1041     /// param destToken (IERC20) Address of token or `address(0)` for Ether
1042     /// @param amount (uint256) Amount for `fromToken`
1043     /// @param minReturn (uint256) Minimum expected return, else revert
1044     /// @param distribution (uint256[]) Array of weights for volume distribution returned by `getExpectedReturn`
1045     /// @param flags (uint256) Flags for enabling and disabling some features, default 0
1046     /// @param referral (address) Address of referral
1047     /// @param feePercent (uint256) Fees percents normalized to 1e18, limited to 0.03e18 (3%)
1048     function swapWithReferral(
1049         IERC20 fromToken,
1050         IERC20 destToken,
1051         uint256 amount,
1052         uint256 minReturn,
1053         uint256[] memory distribution,
1054         uint256 flags, // See contants in IOneSplit.sol
1055         address referral,
1056         uint256 feePercent
1057     ) public payable returns(uint256) {
1058         IERC20[] memory tokens = new IERC20[](2);
1059         tokens[0] = fromToken;
1060         tokens[1] = destToken;
1061 
1062         uint256[] memory flagsArray = new uint256[](1);
1063         flagsArray[0] = flags;
1064 
1065         swapWithReferralMulti(
1066             tokens,
1067             amount,
1068             minReturn,
1069             distribution,
1070             flagsArray,
1071             referral,
1072             feePercent
1073         );
1074     }
1075 
1076     /// @notice Swap `amount` of first element of `tokens` to the latest element of `destToken`
1077     /// @param tokens (IERC20[]) Addresses of token or `address(0)` for Ether
1078     /// @param amount (uint256) Amount for `fromToken`
1079     /// @param minReturn (uint256) Minimum expected return, else revert
1080     /// @param distribution (uint256[]) Array of weights for volume distribution returned by `getExpectedReturn`
1081     /// @param flags (uint256[]) Flags for enabling and disabling some features, default 0
1082     function swapMulti(
1083         IERC20[] memory tokens,
1084         uint256 amount,
1085         uint256 minReturn,
1086         uint256[] memory distribution,
1087         uint256[] memory flags
1088     ) public payable returns(uint256) {
1089         swapWithReferralMulti(
1090             tokens,
1091             amount,
1092             minReturn,
1093             distribution,
1094             flags,
1095             address(0),
1096             0
1097         );
1098     }
1099 
1100     /// @notice Swap `amount` of first element of `tokens` to the latest element of `destToken`
1101     /// @param tokens (IERC20[]) Addresses of token or `address(0)` for Ether
1102     /// @param amount (uint256) Amount for `fromToken`
1103     /// @param minReturn (uint256) Minimum expected return, else revert
1104     /// @param distribution (uint256[]) Array of weights for volume distribution returned by `getExpectedReturn`
1105     /// @param flags (uint256[]) Flags for enabling and disabling some features, default 0
1106     /// @param referral (address) Address of referral
1107     /// @param feePercent (uint256) Fees percents normalized to 1e18, limited to 0.03e18 (3%)
1108     function swapWithReferralMulti(
1109         IERC20[] memory tokens,
1110         uint256 amount,
1111         uint256 minReturn,
1112         uint256[] memory distribution,
1113         uint256[] memory flags,
1114         address referral,
1115         uint256 feePercent
1116     ) public payable returns(uint256 returnAmount) {
1117         require(tokens.length >= 2 && amount > 0, "OneSplit: swap makes no sense");
1118         require(flags.length == tokens.length - 1, "OneSplit: flags array length is invalid");
1119         require((msg.value != 0) == tokens.first().isETH(), "OneSplit: msg.value should be used only for ETH swap");
1120         require(feePercent <= 0.03e18, "OneSplit: feePercent out of range");
1121 
1122         uint256 gasStart = gasleft();
1123 
1124         Balances memory beforeBalances = _getFirstAndLastBalances(tokens, true);
1125 
1126         // Transfer From
1127         tokens.first().universalTransferFromSenderToThis(amount);
1128         uint256 confirmed = tokens.first().universalBalanceOf(address(this)).sub(beforeBalances.ofFromToken);
1129 
1130         // Swap
1131         tokens.first().universalApprove(address(oneSplitImpl), confirmed);
1132         oneSplitImpl.swapMulti.value(tokens.first().isETH() ? confirmed : 0)(
1133             tokens,
1134             confirmed,
1135             minReturn,
1136             distribution,
1137             flags
1138         );
1139 
1140         Balances memory afterBalances = _getFirstAndLastBalances(tokens, false);
1141 
1142         // Return
1143         returnAmount = afterBalances.ofDestToken.sub(beforeBalances.ofDestToken);
1144         require(returnAmount >= minReturn, "OneSplit: actual return amount is less than minReturn");
1145         tokens.last().universalTransfer(referral, returnAmount.mul(feePercent).div(1e18));
1146         tokens.last().universalTransfer(msg.sender, returnAmount.sub(returnAmount.mul(feePercent).div(1e18)));
1147 
1148         emit Swapped(
1149             tokens.first(),
1150             tokens.last(),
1151             amount,
1152             returnAmount,
1153             minReturn,
1154             distribution,
1155             flags,
1156             referral,
1157             feePercent
1158         );
1159 
1160         // Return remainder
1161         if (afterBalances.ofFromToken > beforeBalances.ofFromToken) {
1162             tokens.first().universalTransfer(msg.sender, afterBalances.ofFromToken.sub(beforeBalances.ofFromToken));
1163         }
1164 
1165         if ((flags[0] & (FLAG_ENABLE_CHI_BURN | FLAG_ENABLE_CHI_BURN_BY_ORIGIN)) > 0) {
1166             uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
1167             _chiBurnOrSell(
1168                 ((flags[0] & FLAG_ENABLE_CHI_BURN_BY_ORIGIN) > 0) ? tx.origin : msg.sender,
1169                 (gasSpent + 14154) / 41947
1170             );
1171         }
1172         else if ((flags[0] & FLAG_ENABLE_REFERRAL_GAS_SPONSORSHIP) > 0) {
1173             uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
1174             IReferralGasSponsor(referral).makeGasDiscount(gasSpent, returnAmount, msg.data);
1175         }
1176     }
1177 
1178     function claimAsset(IERC20 asset, uint256 amount) public onlyOwner {
1179         asset.universalTransfer(msg.sender, amount);
1180     }
1181 
1182     function _chiBurnOrSell(address payable sponsor, uint256 amount) internal {
1183         IUniswapV2Exchange exchange = IUniswapV2Exchange(0xa6f3ef841d371a82ca757FaD08efc0DeE2F1f5e2);
1184         uint256 sellRefund = UniswapV2ExchangeLib.getReturn(exchange, chi, weth, amount);
1185         uint256 burnRefund = amount.mul(18_000).mul(tx.gasprice);
1186 
1187         if (sellRefund < burnRefund.add(tx.gasprice.mul(36_000))) {
1188             chi.freeFromUpTo(sponsor, amount);
1189         }
1190         else {
1191             chi.transferFrom(sponsor, address(exchange), amount);
1192             exchange.swap(0, sellRefund, address(this), "");
1193             weth.withdraw(weth.balanceOf(address(this)));
1194             sponsor.transfer(address(this).balance);
1195         }
1196     }
1197 
1198     struct Balances {
1199         uint256 ofFromToken;
1200         uint256 ofDestToken;
1201     }
1202 
1203     function _getFirstAndLastBalances(IERC20[] memory tokens, bool subValue) internal view returns(Balances memory) {
1204         return Balances({
1205             ofFromToken: tokens.first().universalBalanceOf(address(this)).sub(subValue ? msg.value : 0),
1206             ofDestToken: tokens.last().universalBalanceOf(address(this))
1207         });
1208     }
1209 }