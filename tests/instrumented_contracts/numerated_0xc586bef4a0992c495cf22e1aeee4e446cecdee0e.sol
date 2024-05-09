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
189 // File: contracts/IOneSplit.sol
190 
191 pragma solidity ^0.5.0;
192 
193 
194 
195 contract IOneSplitView {
196     // disableFlags = FLAG_DISABLE_UNISWAP + FLAG_DISABLE_KYBER + ...
197     uint256 public constant FLAG_DISABLE_UNISWAP = 0x01;
198     uint256 public constant FLAG_DISABLE_KYBER = 0x02;
199     uint256 public constant FLAG_ENABLE_KYBER_UNISWAP_RESERVE = 0x100000000; // Turned off by default
200     uint256 public constant FLAG_ENABLE_KYBER_OASIS_RESERVE = 0x200000000; // Turned off by default
201     uint256 public constant FLAG_ENABLE_KYBER_BANCOR_RESERVE = 0x400000000; // Turned off by default
202     uint256 public constant FLAG_DISABLE_BANCOR = 0x04;
203     uint256 public constant FLAG_DISABLE_OASIS = 0x08;
204     uint256 public constant FLAG_DISABLE_COMPOUND = 0x10;
205     uint256 public constant FLAG_DISABLE_FULCRUM = 0x20;
206     uint256 public constant FLAG_DISABLE_CHAI = 0x40;
207     uint256 public constant FLAG_DISABLE_AAVE = 0x80;
208     uint256 public constant FLAG_DISABLE_SMART_TOKEN = 0x100;
209     uint256 public constant FLAG_ENABLE_MULTI_PATH_ETH = 0x200; // Turned off by default
210     uint256 public constant FLAG_DISABLE_BDAI = 0x400;
211     uint256 public constant FLAG_DISABLE_IEARN = 0x800;
212     uint256 public constant FLAG_DISABLE_CURVE_COMPOUND = 0x1000;
213     uint256 public constant FLAG_DISABLE_CURVE_USDT = 0x2000;
214     uint256 public constant FLAG_DISABLE_CURVE_Y = 0x4000;
215     uint256 public constant FLAG_DISABLE_CURVE_BINANCE = 0x8000;
216     uint256 public constant FLAG_ENABLE_MULTI_PATH_DAI = 0x10000; // Turned off by default
217     uint256 public constant FLAG_ENABLE_MULTI_PATH_USDC = 0x20000; // Turned off by default
218     uint256 public constant FLAG_DISABLE_CURVE_SYNTHETIX = 0x40000;
219     uint256 public constant FLAG_DISABLE_WETH = 0x80000;
220     uint256 public constant FLAG_ENABLE_UNISWAP_COMPOUND = 0x100000; // Works only with FLAG_ENABLE_MULTI_PATH_ETH
221 
222     function getExpectedReturn(
223         IERC20 fromToken,
224         IERC20 toToken,
225         uint256 amount,
226         uint256 parts,
227         uint256 disableFlags
228     )
229         public
230         view
231         returns(
232             uint256 returnAmount,
233             uint256[] memory distribution
234         );
235 }
236 
237 
238 contract IOneSplit is IOneSplitView {
239     function swap(
240         IERC20 fromToken,
241         IERC20 toToken,
242         uint256 amount,
243         uint256 minReturn,
244         uint256[] memory distribution,
245         uint256 disableFlags
246     ) public payable;
247 }
248 
249 // File: @openzeppelin/contracts/math/SafeMath.sol
250 
251 pragma solidity ^0.5.0;
252 
253 /**
254  * @dev Wrappers over Solidity's arithmetic operations with added overflow
255  * checks.
256  *
257  * Arithmetic operations in Solidity wrap on overflow. This can easily result
258  * in bugs, because programmers usually assume that an overflow raises an
259  * error, which is the standard behavior in high level programming languages.
260  * `SafeMath` restores this intuition by reverting the transaction when an
261  * operation overflows.
262  *
263  * Using this library instead of the unchecked operations eliminates an entire
264  * class of bugs, so it's recommended to use it always.
265  */
266 library SafeMath {
267     /**
268      * @dev Returns the addition of two unsigned integers, reverting on
269      * overflow.
270      *
271      * Counterpart to Solidity's `+` operator.
272      *
273      * Requirements:
274      * - Addition cannot overflow.
275      */
276     function add(uint256 a, uint256 b) internal pure returns (uint256) {
277         uint256 c = a + b;
278         require(c >= a, "SafeMath: addition overflow");
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the subtraction of two unsigned integers, reverting on
285      * overflow (when the result is negative).
286      *
287      * Counterpart to Solidity's `-` operator.
288      *
289      * Requirements:
290      * - Subtraction cannot overflow.
291      */
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         return sub(a, b, "SafeMath: subtraction overflow");
294     }
295 
296     /**
297      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
298      * overflow (when the result is negative).
299      *
300      * Counterpart to Solidity's `-` operator.
301      *
302      * Requirements:
303      * - Subtraction cannot overflow.
304      *
305      * _Available since v2.4.0._
306      */
307     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         require(b <= a, errorMessage);
309         uint256 c = a - b;
310 
311         return c;
312     }
313 
314     /**
315      * @dev Returns the multiplication of two unsigned integers, reverting on
316      * overflow.
317      *
318      * Counterpart to Solidity's `*` operator.
319      *
320      * Requirements:
321      * - Multiplication cannot overflow.
322      */
323     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
324         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
325         // benefit is lost if 'b' is also tested.
326         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
327         if (a == 0) {
328             return 0;
329         }
330 
331         uint256 c = a * b;
332         require(c / a == b, "SafeMath: multiplication overflow");
333 
334         return c;
335     }
336 
337     /**
338      * @dev Returns the integer division of two unsigned integers. Reverts on
339      * division by zero. The result is rounded towards zero.
340      *
341      * Counterpart to Solidity's `/` operator. Note: this function uses a
342      * `revert` opcode (which leaves remaining gas untouched) while Solidity
343      * uses an invalid opcode to revert (consuming all remaining gas).
344      *
345      * Requirements:
346      * - The divisor cannot be zero.
347      */
348     function div(uint256 a, uint256 b) internal pure returns (uint256) {
349         return div(a, b, "SafeMath: division by zero");
350     }
351 
352     /**
353      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
354      * division by zero. The result is rounded towards zero.
355      *
356      * Counterpart to Solidity's `/` operator. Note: this function uses a
357      * `revert` opcode (which leaves remaining gas untouched) while Solidity
358      * uses an invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      * - The divisor cannot be zero.
362      *
363      * _Available since v2.4.0._
364      */
365     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
366         // Solidity only automatically asserts when dividing by 0
367         require(b > 0, errorMessage);
368         uint256 c = a / b;
369         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
370 
371         return c;
372     }
373 
374     /**
375      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
376      * Reverts when dividing by zero.
377      *
378      * Counterpart to Solidity's `%` operator. This function uses a `revert`
379      * opcode (which leaves remaining gas untouched) while Solidity uses an
380      * invalid opcode to revert (consuming all remaining gas).
381      *
382      * Requirements:
383      * - The divisor cannot be zero.
384      */
385     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
386         return mod(a, b, "SafeMath: modulo by zero");
387     }
388 
389     /**
390      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
391      * Reverts with custom message when dividing by zero.
392      *
393      * Counterpart to Solidity's `%` operator. This function uses a `revert`
394      * opcode (which leaves remaining gas untouched) while Solidity uses an
395      * invalid opcode to revert (consuming all remaining gas).
396      *
397      * Requirements:
398      * - The divisor cannot be zero.
399      *
400      * _Available since v2.4.0._
401      */
402     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
403         require(b != 0, errorMessage);
404         return a % b;
405     }
406 }
407 
408 // File: @openzeppelin/contracts/utils/Address.sol
409 
410 pragma solidity ^0.5.5;
411 
412 /**
413  * @dev Collection of functions related to the address type
414  */
415 library Address {
416     /**
417      * @dev Returns true if `account` is a contract.
418      *
419      * [IMPORTANT]
420      * ====
421      * It is unsafe to assume that an address for which this function returns
422      * false is an externally-owned account (EOA) and not a contract.
423      *
424      * Among others, `isContract` will return false for the following 
425      * types of addresses:
426      *
427      *  - an externally-owned account
428      *  - a contract in construction
429      *  - an address where a contract will be created
430      *  - an address where a contract lived, but was destroyed
431      * ====
432      */
433     function isContract(address account) internal view returns (bool) {
434         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
435         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
436         // for accounts without code, i.e. `keccak256('')`
437         bytes32 codehash;
438         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
439         // solhint-disable-next-line no-inline-assembly
440         assembly { codehash := extcodehash(account) }
441         return (codehash != accountHash && codehash != 0x0);
442     }
443 
444     /**
445      * @dev Converts an `address` into `address payable`. Note that this is
446      * simply a type cast: the actual underlying value is not changed.
447      *
448      * _Available since v2.4.0._
449      */
450     function toPayable(address account) internal pure returns (address payable) {
451         return address(uint160(account));
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      *
470      * _Available since v2.4.0._
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         // solhint-disable-next-line avoid-call-value
476         (bool success, ) = recipient.call.value(amount)("");
477         require(success, "Address: unable to send value, recipient may have reverted");
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
482 
483 pragma solidity ^0.5.0;
484 
485 
486 
487 
488 /**
489  * @title SafeERC20
490  * @dev Wrappers around ERC20 operations that throw on failure (when the token
491  * contract returns false). Tokens that return no value (and instead revert or
492  * throw on failure) are also supported, non-reverting calls are assumed to be
493  * successful.
494  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
495  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
496  */
497 library SafeERC20 {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     function safeTransfer(IERC20 token, address to, uint256 value) internal {
502         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
503     }
504 
505     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
506         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
507     }
508 
509     function safeApprove(IERC20 token, address spender, uint256 value) internal {
510         // safeApprove should only be called when setting an initial allowance,
511         // or when resetting it to zero. To increase and decrease it, use
512         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
513         // solhint-disable-next-line max-line-length
514         require((value == 0) || (token.allowance(address(this), spender) == 0),
515             "SafeERC20: approve from non-zero to non-zero allowance"
516         );
517         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
518     }
519 
520     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
521         uint256 newAllowance = token.allowance(address(this), spender).add(value);
522         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
523     }
524 
525     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
526         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
527         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
528     }
529 
530     /**
531      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
532      * on the return value: the return value is optional (but if data is returned, it must not be false).
533      * @param token The token targeted by the call.
534      * @param data The call data (encoded using abi.encode or one of its variants).
535      */
536     function callOptionalReturn(IERC20 token, bytes memory data) private {
537         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
538         // we're implementing it ourselves.
539 
540         // A Solidity high level call has three parts:
541         //  1. The target address is checked to verify it contains contract code
542         //  2. The call itself is made, and success asserted
543         //  3. The return value is decoded, which in turn checks the size of the returned data.
544         // solhint-disable-next-line max-line-length
545         require(address(token).isContract(), "SafeERC20: call to non-contract");
546 
547         // solhint-disable-next-line avoid-low-level-calls
548         (bool success, bytes memory returndata) = address(token).call(data);
549         require(success, "SafeERC20: low-level call failed");
550 
551         if (returndata.length > 0) { // Return data is optional
552             // solhint-disable-next-line max-line-length
553             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
554         }
555     }
556 }
557 
558 // File: contracts/UniversalERC20.sol
559 
560 pragma solidity ^0.5.0;
561 
562 
563 
564 
565 
566 library UniversalERC20 {
567 
568     using SafeMath for uint256;
569     using SafeERC20 for IERC20;
570 
571     IERC20 private constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
572     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
573 
574     function universalTransfer(IERC20 token, address to, uint256 amount) internal returns(bool) {
575         if (amount == 0) {
576             return true;
577         }
578 
579         if (isETH(token)) {
580             address(uint160(to)).transfer(amount);
581         } else {
582             token.safeTransfer(to, amount);
583             return true;
584         }
585     }
586 
587     function universalTransferFrom(IERC20 token, address from, address to, uint256 amount) internal {
588         if (amount == 0) {
589             return;
590         }
591 
592         if (isETH(token)) {
593             require(from == msg.sender && msg.value >= amount, "Wrong useage of ETH.universalTransferFrom()");
594             if (to != address(this)) {
595                 address(uint160(to)).transfer(amount);
596             }
597             if (msg.value > amount) {
598                 msg.sender.transfer(msg.value.sub(amount));
599             }
600         } else {
601             token.safeTransferFrom(from, to, amount);
602         }
603     }
604 
605     function universalTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
606         if (amount == 0) {
607             return;
608         }
609 
610         if (isETH(token)) {
611             if (msg.value > amount) {
612                 // Return remainder if exist
613                 msg.sender.transfer(msg.value.sub(amount));
614             }
615         } else {
616             token.safeTransferFrom(msg.sender, address(this), amount);
617         }
618     }
619 
620     function universalApprove(IERC20 token, address to, uint256 amount) internal {
621         if (!isETH(token)) {
622             if (amount > 0 && token.allowance(address(this), to) > 0) {
623                 token.safeApprove(to, 0);
624             }
625             token.safeApprove(to, amount);
626         }
627     }
628 
629     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
630         if (isETH(token)) {
631             return who.balance;
632         } else {
633             return token.balanceOf(who);
634         }
635     }
636 
637     function universalDecimals(IERC20 token) internal view returns (uint256) {
638 
639         if (isETH(token)) {
640             return 18;
641         }
642 
643         (bool success, bytes memory data) = address(token).staticcall.gas(10000)(
644             abi.encodeWithSignature("decimals()")
645         );
646         if (!success || data.length == 0) {
647             (success, data) = address(token).staticcall.gas(10000)(
648                 abi.encodeWithSignature("DECIMALS()")
649             );
650         }
651 
652         return (success && data.length > 0) ? abi.decode(data, (uint256)) : 18;
653     }
654 
655     function isETH(IERC20 token) internal pure returns(bool) {
656         return (address(token) == address(ZERO_ADDRESS) || address(token) == address(ETH_ADDRESS));
657     }
658 }
659 
660 // File: contracts/OneSplitAudit.sol
661 
662 pragma solidity ^0.5.0;
663 
664 
665 
666 
667 
668 //
669 // Security assumptions:
670 // 1. It is safe to have infinite approves of any tokens to this smart contract,
671 //    since it could only call `transferFrom()` with first argument equal to msg.sender
672 // 2. It is safe to call `swap()` with reliable `minReturn` argument,
673 //    if returning amount will not reach `minReturn` value whole swap will be reverted.
674 //
675 contract OneSplitAudit is IOneSplit, Ownable {
676 
677     using SafeMath for uint256;
678     using UniversalERC20 for IERC20;
679 
680     IOneSplit public oneSplitImpl;
681 
682     event ImplementationUpdated(address indexed newImpl);
683 
684     constructor(IOneSplit impl) public {
685         setNewImpl(impl);
686     }
687 
688     function() external payable {
689         require(msg.sender != tx.origin, "OneSplit: do not send ETH directly");
690     }
691 
692     function setNewImpl(IOneSplit impl) public onlyOwner {
693         oneSplitImpl = impl;
694         emit ImplementationUpdated(address(impl));
695     }
696 
697     /// @notice Calculate expected returning amount of `toToken`
698     /// @param fromToken (IERC20) Address of token or `address(0)` for Ether
699     /// @param toToken (IERC20) Address of token or `address(0)` for Ether
700     /// @param amount (uint256) Amount for `fromToken`
701     /// @param parts (uint256) Number of pieces source volume could be splitted,
702     /// works like granularity, higly affects gas usage. Should be called offchain,
703     /// but could be called onchain if user swaps not his own funds, but this is still considered as not safe.
704     /// @param featureFlags (uint256) Flags for enabling and disabling some features, default 0
705     function getExpectedReturn(
706         IERC20 fromToken,
707         IERC20 toToken,
708         uint256 amount,
709         uint256 parts,
710         uint256 featureFlags // See contants in IOneSplit.sol
711     )
712         public
713         view
714         returns(
715             uint256 returnAmount,
716             uint256[] memory distribution
717         )
718     {
719         return oneSplitImpl.getExpectedReturn(
720             fromToken,
721             toToken,
722             amount,
723             parts,
724             featureFlags
725         );
726     }
727 
728     /// @notice Swap `amount` of `fromToken` to `toToken`
729     /// @param fromToken (IERC20) Address of token or `address(0)` for Ether
730     /// @param toToken (IERC20) Address of token or `address(0)` for Ether
731     /// @param amount (uint256) Amount for `fromToken`
732     /// @param minReturn (uint256) Minimum expected return, else revert
733     /// @param distribution (uint256[]) Array of weights for volume distribution returned by `getExpectedReturn`
734     /// @param featureFlags (uint256) Flags for enabling and disabling some features, default 0
735     function swap(
736         IERC20 fromToken,
737         IERC20 toToken,
738         uint256 amount,
739         uint256 minReturn,
740         uint256[] memory distribution,
741         uint256 featureFlags // See contants in IOneSplit.sol
742     ) public payable {
743         require(fromToken != toToken && amount > 0, "OneSplit: swap makes no sense");
744         require((msg.value != 0) == fromToken.isETH(), "OneSplit: msg.value shoule be used only for ETH swap");
745 
746         uint256 fromTokenBalanceBefore = fromToken.universalBalanceOf(address(this)).sub(msg.value);
747         uint256 toTokenBalanceBefore = toToken.universalBalanceOf(address(this));
748 
749         fromToken.universalTransferFromSenderToThis(amount);
750         fromToken.universalApprove(address(oneSplitImpl), amount);
751 
752         oneSplitImpl.swap.value(msg.value)(
753             fromToken,
754             toToken,
755             amount,
756             minReturn,
757             distribution,
758             featureFlags
759         );
760 
761         uint256 fromTokenBalanceAfter = fromToken.universalBalanceOf(address(this));
762         uint256 toTokenBalanceAfter = toToken.universalBalanceOf(address(this));
763 
764         uint256 returnAmount = toTokenBalanceAfter.sub(toTokenBalanceBefore);
765         require(returnAmount >= minReturn, "OneSplit: actual return amount is less than minReturn");
766         toToken.universalTransfer(msg.sender, returnAmount);
767 
768         if (fromTokenBalanceAfter > fromTokenBalanceBefore) {
769             fromToken.universalTransfer(msg.sender, fromTokenBalanceAfter.sub(fromTokenBalanceBefore));
770         }
771     }
772 
773     function claimAsset(IERC20 asset, uint256 amount) public onlyOwner {
774         asset.universalTransfer(msg.sender, amount);
775     }
776 
777     //
778     // DEPRECATED: Implement in own contract if needed, but this is
779     //             still should not be considered as safe oracle.
780     //
781     // function goodSwap(
782     //     IERC20 fromToken,
783     //     IERC20 toToken,
784     //     uint256 amount,
785     //     uint256 minReturn,
786     //     uint256 parts,
787     //     uint256 featureFlags // See contants in IOneSplit.sol
788     // ) public payable {
789     //     (, uint256[] memory distribution) = getExpectedReturn(
790     //         fromToken,
791     //         toToken,
792     //         amount,
793     //         parts,
794     //         featureFlags
795     //     );
796     //     swap(
797     //         fromToken,
798     //         toToken,
799     //         amount,
800     //         minReturn,
801     //         distribution,
802     //         featureFlags
803     //     );
804     // }
805 }