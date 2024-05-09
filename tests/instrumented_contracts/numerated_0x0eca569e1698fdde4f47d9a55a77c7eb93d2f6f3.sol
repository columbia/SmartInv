1 // Website: https://antiseal.finance/
2 // Telegram: https://t.me/ANTI_SEAL
3 
4 /*
5 **     █████╗ ███╗   ██╗████████╗██╗███████╗███████╗ █████╗ ██╗     
6 **    ██╔══██╗████╗  ██║╚══██╔══╝██║██╔════╝██╔════╝██╔══██╗██║     
7 **    ███████║██╔██╗ ██║   ██║   ██║███████╗█████╗  ███████║██║     
8 **    ██╔══██║██║╚██╗██║   ██║   ██║╚════██║██╔══╝  ██╔══██║██║     
9 **    ██║  ██║██║ ╚████║   ██║   ██║███████║███████╗██║  ██║███████╗
10 **    ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝
11 **
12 */
13 
14 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.6.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
95 
96 
97 pragma solidity ^0.6.2;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      */
120     function isContract(address account) internal view returns (bool) {
121         // This method relies in extcodesize, which returns 0 for contracts in
122         // construction, since the code is only stored at the end of the
123         // constructor execution.
124 
125         uint256 size;
126         // solhint-disable-next-line no-inline-assembly
127         assembly { size := extcodesize(account) }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
151         (bool success, ) = recipient.call{ value: amount }("");
152         require(success, "Address: unable to send value, recipient may have reverted");
153     }
154 
155     /**
156      * @dev Performs a Solidity function call using a low level `call`. A
157      * plain`call` is an unsafe replacement for a function call: use this
158      * function instead.
159      *
160      * If `target` reverts with a revert reason, it is bubbled up by this
161      * function (like regular Solidity function calls).
162      *
163      * Returns the raw returned data. To convert to the expected return value,
164      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
165      *
166      * Requirements:
167      *
168      * - `target` must be a contract.
169      * - calling `target` with `data` must not revert.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
174       return functionCall(target, data, "Address: low-level call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
179      * `errorMessage` as a fallback revert reason when `target` reverts.
180      *
181      * _Available since v3.1._
182      */
183     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
184         return _functionCallWithValue(target, data, 0, errorMessage);
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
189      * but also transferring `value` wei to `target`.
190      *
191      * Requirements:
192      *
193      * - the calling contract must have an ETH balance of at least `value`.
194      * - the called Solidity function must be `payable`.
195      *
196      * _Available since v3.1._
197      */
198     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
209         require(address(this).balance >= value, "Address: insufficient balance for call");
210         return _functionCallWithValue(target, data, value, errorMessage);
211     }
212 
213     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
214         require(isContract(target), "Address: call to non-contract");
215 
216         // solhint-disable-next-line avoid-low-level-calls
217         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
218         if (success) {
219             return returndata;
220         } else {
221             // Look for revert reason and bubble it up if present
222             if (returndata.length > 0) {
223                 // The easiest way to bubble the revert reason is using memory via assembly
224 
225                 // solhint-disable-next-line no-inline-assembly
226                 assembly {
227                     let returndata_size := mload(returndata)
228                     revert(add(32, returndata), returndata_size)
229                 }
230             } else {
231                 revert(errorMessage);
232             }
233         }
234     }
235 }
236 
237 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
238 
239 
240 pragma solidity ^0.6.0;
241 
242 
243 
244 
245 /**
246  * @title SafeERC20
247  * @dev Wrappers around ERC20 operations that throw on failure (when the token
248  * contract returns false). Tokens that return no value (and instead revert or
249  * throw on failure) are also supported, non-reverting calls are assumed to be
250  * successful.
251  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
252  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
253  */
254 library SafeERC20 {
255     using SafeMath for uint256;
256     using Address for address;
257 
258     function safeTransfer(IERC20 token, address to, uint256 value) internal {
259         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
260     }
261 
262     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
263         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
264     }
265 
266     /**
267      * @dev Deprecated. This function has issues similar to the ones found in
268      * {IERC20-approve}, and its usage is discouraged.
269      *
270      * Whenever possible, use {safeIncreaseAllowance} and
271      * {safeDecreaseAllowance} instead.
272      */
273     function safeApprove(IERC20 token, address spender, uint256 value) internal {
274         // safeApprove should only be called when setting an initial allowance,
275         // or when resetting it to zero. To increase and decrease it, use
276         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
277         // solhint-disable-next-line max-line-length
278         require((value == 0) || (token.allowance(address(this), spender) == 0),
279             "SafeERC20: approve from non-zero to non-zero allowance"
280         );
281         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
282     }
283 
284     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
285         uint256 newAllowance = token.allowance(address(this), spender).add(value);
286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
287     }
288 
289     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
290         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
291         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
292     }
293 
294     /**
295      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
296      * on the return value: the return value is optional (but if data is returned, it must not be false).
297      * @param token The token targeted by the call.
298      * @param data The call data (encoded using abi.encode or one of its variants).
299      */
300     function _callOptionalReturn(IERC20 token, bytes memory data) private {
301         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
302         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
303         // the target address contains contract code and also asserts for success in the low-level call.
304 
305         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
306         if (returndata.length > 0) { // Return data is optional
307             // solhint-disable-next-line max-line-length
308             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
309         }
310     }
311 }
312 
313 // File: @openzeppelin\contracts\math\SafeMath.sol
314 
315 
316 pragma solidity ^0.6.0;
317 
318 /**
319  * @dev Wrappers over Solidity's arithmetic operations with added overflow
320  * checks.
321  *
322  * Arithmetic operations in Solidity wrap on overflow. This can easily result
323  * in bugs, because programmers usually assume that an overflow raises an
324  * error, which is the standard behavior in high level programming languages.
325  * `SafeMath` restores this intuition by reverting the transaction when an
326  * operation overflows.
327  *
328  * Using this library instead of the unchecked operations eliminates an entire
329  * class of bugs, so it's recommended to use it always.
330  */
331 library SafeMath {
332     /**
333      * @dev Returns the addition of two unsigned integers, reverting on
334      * overflow.
335      *
336      * Counterpart to Solidity's `+` operator.
337      *
338      * Requirements:
339      *
340      * - Addition cannot overflow.
341      */
342     function add(uint256 a, uint256 b) internal pure returns (uint256) {
343         uint256 c = a + b;
344         require(c >= a, "SafeMath: addition overflow");
345 
346         return c;
347     }
348 
349     /**
350      * @dev Returns the subtraction of two unsigned integers, reverting on
351      * overflow (when the result is negative).
352      *
353      * Counterpart to Solidity's `-` operator.
354      *
355      * Requirements:
356      *
357      * - Subtraction cannot overflow.
358      */
359     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
360         return sub(a, b, "SafeMath: subtraction overflow");
361     }
362 
363     /**
364      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
365      * overflow (when the result is negative).
366      *
367      * Counterpart to Solidity's `-` operator.
368      *
369      * Requirements:
370      *
371      * - Subtraction cannot overflow.
372      */
373     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b <= a, errorMessage);
375         uint256 c = a - b;
376 
377         return c;
378     }
379 
380     /**
381      * @dev Returns the multiplication of two unsigned integers, reverting on
382      * overflow.
383      *
384      * Counterpart to Solidity's `*` operator.
385      *
386      * Requirements:
387      *
388      * - Multiplication cannot overflow.
389      */
390     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
391         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
392         // benefit is lost if 'b' is also tested.
393         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
394         if (a == 0) {
395             return 0;
396         }
397 
398         uint256 c = a * b;
399         require(c / a == b, "SafeMath: multiplication overflow");
400 
401         return c;
402     }
403 
404     /**
405      * @dev Returns the integer division of two unsigned integers. Reverts on
406      * division by zero. The result is rounded towards zero.
407      *
408      * Counterpart to Solidity's `/` operator. Note: this function uses a
409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
410      * uses an invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function div(uint256 a, uint256 b) internal pure returns (uint256) {
417         return div(a, b, "SafeMath: division by zero");
418     }
419 
420     /**
421      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
422      * division by zero. The result is rounded towards zero.
423      *
424      * Counterpart to Solidity's `/` operator. Note: this function uses a
425      * `revert` opcode (which leaves remaining gas untouched) while Solidity
426      * uses an invalid opcode to revert (consuming all remaining gas).
427      *
428      * Requirements:
429      *
430      * - The divisor cannot be zero.
431      */
432     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
433         require(b > 0, errorMessage);
434         uint256 c = a / b;
435         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
436 
437         return c;
438     }
439 
440     /**
441      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
442      * Reverts when dividing by zero.
443      *
444      * Counterpart to Solidity's `%` operator. This function uses a `revert`
445      * opcode (which leaves remaining gas untouched) while Solidity uses an
446      * invalid opcode to revert (consuming all remaining gas).
447      *
448      * Requirements:
449      *
450      * - The divisor cannot be zero.
451      */
452     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
453         return mod(a, b, "SafeMath: modulo by zero");
454     }
455 
456     /**
457      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
458      * Reverts with custom message when dividing by zero.
459      *
460      * Counterpart to Solidity's `%` operator. This function uses a `revert`
461      * opcode (which leaves remaining gas untouched) while Solidity uses an
462      * invalid opcode to revert (consuming all remaining gas).
463      *
464      * Requirements:
465      *
466      * - The divisor cannot be zero.
467      */
468     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
469         require(b != 0, errorMessage);
470         return a % b;
471     }
472 }
473 
474 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
475 
476 
477 pragma solidity ^0.6.0;
478 
479 /*
480  * @dev Provides information about the current execution context, including the
481  * sender of the transaction and its data. While these are generally available
482  * via msg.sender and msg.data, they should not be accessed in such a direct
483  * manner, since when dealing with GSN meta-transactions the account sending and
484  * paying for execution may not be the actual sender (as far as an application
485  * is concerned).
486  *
487  * This contract is only required for intermediate, library-like contracts.
488  */
489 abstract contract Context {
490     function _msgSender() internal view virtual returns (address payable) {
491         return msg.sender;
492     }
493 
494     function _msgData() internal view virtual returns (bytes memory) {
495         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
496         return msg.data;
497     }
498 }
499 
500 // File: @openzeppelin\contracts\access\Ownable.sol
501 
502 
503 pragma solidity ^0.6.0;
504 
505 /**
506  * @dev Contract module which provides a basic access control mechanism, where
507  * there is an account (an owner) that can be granted exclusive access to
508  * specific functions.
509  *
510  * By default, the owner account will be the one that deploys the contract. This
511  * can later be changed with {transferOwnership}.
512  *
513  * This module is used through inheritance. It will make available the modifier
514  * `onlyOwner`, which can be applied to your functions to restrict their use to
515  * the owner.
516  */
517 contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     /**
523      * @dev Initializes the contract setting the deployer as the initial owner.
524      */
525     constructor () internal {
526         address msgSender = _msgSender();
527         _owner = msgSender;
528         emit OwnershipTransferred(address(0), msgSender);
529     }
530 
531     /**
532      * @dev Returns the address of the current owner.
533      */
534     function owner() public view returns (address) {
535         return _owner;
536     }
537 
538     /**
539      * @dev Throws if called by any account other than the owner.
540      */
541     modifier onlyOwner() {
542         require(_owner == _msgSender(), "Ownable: caller is not the owner");
543         _;
544     }
545 
546     /**
547      * @dev Leaves the contract without owner. It will not be possible to call
548      * `onlyOwner` functions anymore. Can only be called by the current owner.
549      *
550      * NOTE: Renouncing ownership will leave the contract without an owner,
551      * thereby removing any functionality that is only available to the owner.
552      */
553     function renounceOwnership() public virtual onlyOwner {
554         emit OwnershipTransferred(_owner, address(0));
555         _owner = address(0);
556     }
557 
558     /**
559      * @dev Transfers ownership of the contract to a new account (`newOwner`).
560      * Can only be called by the current owner.
561      */
562     function transferOwnership(address newOwner) public virtual onlyOwner {
563         require(newOwner != address(0), "Ownable: new owner is the zero address");
564         emit OwnershipTransferred(_owner, newOwner);
565         _owner = newOwner;
566     }
567 }
568 
569 // File: contracts\interfaces\IUniswapV2Pair.sol
570 
571 pragma solidity >=0.5.0;
572 
573 interface IUniswapV2Pair {
574     event Approval(address indexed owner, address indexed spender, uint value);
575     event Transfer(address indexed from, address indexed to, uint value);
576 
577     function name() external pure returns (string memory);
578     function symbol() external pure returns (string memory);
579     function decimals() external pure returns (uint8);
580     function totalSupply() external view returns (uint);
581     function balanceOf(address owner) external view returns (uint);
582     function allowance(address owner, address spender) external view returns (uint);
583 
584     function approve(address spender, uint value) external returns (bool);
585     function transfer(address to, uint value) external returns (bool);
586     function transferFrom(address from, address to, uint value) external returns (bool);
587 
588     function DOMAIN_SEPARATOR() external view returns (bytes32);
589     function PERMIT_TYPEHASH() external pure returns (bytes32);
590     function nonces(address owner) external view returns (uint);
591 
592     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
593 
594     event Mint(address indexed sender, uint amount0, uint amount1);
595     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
596     event Swap(
597         address indexed sender,
598         uint amount0In,
599         uint amount1In,
600         uint amount0Out,
601         uint amount1Out,
602         address indexed to
603     );
604     event Sync(uint112 reserve0, uint112 reserve1);
605 
606     function MINIMUM_LIQUIDITY() external pure returns (uint);
607     function factory() external view returns (address);
608     function token0() external view returns (address);
609     function token1() external view returns (address);
610     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
611     function price0CumulativeLast() external view returns (uint);
612     function price1CumulativeLast() external view returns (uint);
613     function kLast() external view returns (uint);
614 
615     function mint(address to) external returns (uint liquidity);
616     function burn(address to) external returns (uint amount0, uint amount1);
617     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
618     function skim(address to) external;
619     function sync() external;
620 
621     function initialize(address, address) external;
622 }
623 
624 // File: contracts\interfaces\IUniswapV2Factory.sol
625 
626 pragma solidity >=0.5.0;
627 
628 interface IUniswapV2Factory {
629     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
630 
631     function feeTo() external view returns (address);
632     function feeToSetter() external view returns (address);
633     function migrator() external view returns (address);
634 
635     function getPair(address tokenA, address tokenB) external view returns (address pair);
636     function allPairs(uint) external view returns (address pair);
637     function allPairsLength() external view returns (uint);
638 
639     function createPair(address tokenA, address tokenB) external returns (address pair);
640 
641     function setFeeTo(address) external;
642     function setFeeToSetter(address) external;
643     function setMigrator(address) external;
644 }
645 
646 // File: contracts\libraries\SafeMath.sol
647 
648 pragma solidity =0.6.12;
649 
650 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
651 
652 library SafeMathUniswap {
653     function add(uint x, uint y) internal pure returns (uint z) {
654         require((z = x + y) >= x, 'ds-math-add-overflow');
655     }
656 
657     function sub(uint x, uint y) internal pure returns (uint z) {
658         require((z = x - y) <= x, 'ds-math-sub-underflow');
659     }
660 
661     function mul(uint x, uint y) internal pure returns (uint z) {
662         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
663     }
664 }
665 
666 // File: contracts\libraries\UniswapV2Library.sol
667 
668 pragma solidity >=0.5.0;
669 
670 
671 
672 library UniswapV2Library {
673     using SafeMathUniswap for uint;
674 
675     // returns sorted token addresses, used to handle return values from pairs sorted in this order
676     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
677         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
678         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
679         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
680     }
681 
682     // calculates the CREATE2 address for a pair without making any external calls
683     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
684         (address token0, address token1) = sortTokens(tokenA, tokenB);
685         pair = address(uint(keccak256(abi.encodePacked(
686                 hex'ff',
687                 factory,
688                 keccak256(abi.encodePacked(token0, token1)),
689                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
690             ))));
691     }
692 
693     // fetches and sorts the reserves for a pair
694     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
695         (address token0,) = sortTokens(tokenA, tokenB);
696         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
697         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
698     }
699 
700     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
701     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
702         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
703         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
704         amountB = amountA.mul(reserveB) / reserveA;
705     }
706 
707     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
708     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
709         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
710         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
711         uint amountInWithFee = amountIn.mul(997);
712         uint numerator = amountInWithFee.mul(reserveOut);
713         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
714         amountOut = numerator / denominator;
715     }
716 
717     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
718     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
719         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
720         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
721         uint numerator = reserveIn.mul(amountOut).mul(1000);
722         uint denominator = reserveOut.sub(amountOut).mul(997);
723         amountIn = (numerator / denominator).add(1);
724     }
725 
726     // performs chained getAmountOut calculations on any number of pairs
727     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
728         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
729         amounts = new uint[](path.length);
730         amounts[0] = amountIn;
731         for (uint i; i < path.length - 1; i++) {
732             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
733             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
734         }
735     }
736 
737     // performs chained getAmountIn calculations on any number of pairs
738     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
739         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
740         amounts = new uint[](path.length);
741         amounts[amounts.length - 1] = amountOut;
742         for (uint i = path.length - 1; i > 0; i--) {
743             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
744             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
745         }
746     }
747 }
748 
749 // File: contracts\Timelock.sol
750 
751 
752 pragma solidity 0.6.12;
753 
754 
755 contract Timelock {
756     using SafeMath for uint;
757 
758     event NewAdmin(address indexed newAdmin);
759     event NewPendingAdmin(address indexed newPendingAdmin);
760     event NewDelay(uint indexed newDelay);
761     event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
762     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
763     event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);
764 
765     uint public constant GRACE_PERIOD = 14 days;
766     uint public constant MINIMUM_DELAY = 24 hours;
767     uint public constant MAXIMUM_DELAY = 30 days;
768 
769     address public admin;
770     address public pendingAdmin;
771     uint public delay;
772     bool public admin_initialized;
773 
774     mapping (bytes32 => bool) public queuedTransactions;
775 
776 
777     constructor(address admin_, uint delay_) public {
778         require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");
779         require(delay_ <= MAXIMUM_DELAY, "Timelock::constructor: Delay must not exceed maximum delay.");
780 
781         admin = admin_;
782         delay = delay_;
783         admin_initialized = false;
784     }
785 
786     receive() external payable { }
787 
788     function setDelay(uint delay_) public {
789         require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
790         require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");
791         require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");
792         delay = delay_;
793 
794         emit NewDelay(delay);
795     }
796 
797     function acceptAdmin() public {
798         require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");
799         admin = msg.sender;
800         pendingAdmin = address(0);
801 
802         emit NewAdmin(admin);
803     }
804 
805     function setPendingAdmin(address pendingAdmin_) public {
806         // allows one time setting of admin for deployment purposes
807         if (admin_initialized) {
808             require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");
809         } else {
810             require(msg.sender == admin, "Timelock::setPendingAdmin: First call must come from admin.");
811             admin_initialized = true;
812         }
813         pendingAdmin = pendingAdmin_;
814 
815         emit NewPendingAdmin(pendingAdmin);
816     }
817 
818     function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {
819         require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");
820         require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
821 
822         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
823         queuedTransactions[txHash] = true;
824 
825         emit QueueTransaction(txHash, target, value, signature, data, eta);
826         return txHash;
827     }
828 
829     function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {
830         require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");
831 
832         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
833         queuedTransactions[txHash] = false;
834 
835         emit CancelTransaction(txHash, target, value, signature, data, eta);
836     }
837 
838     function executeTransaction(address target, uint _value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {
839         require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");
840 
841         bytes32 txHash = keccak256(abi.encode(target, _value, signature, data, eta));
842         require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
843         require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
844         require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");
845 
846         queuedTransactions[txHash] = false;
847 
848         bytes memory callData;
849 
850         if (bytes(signature).length == 0) {
851             callData = data;
852         } else {
853             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
854         }
855 
856         // solium-disable-next-line security/no-call-value
857         (bool success, bytes memory returnData) = target.call{value:_value}(callData);
858         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
859 
860         emit ExecuteTransaction(txHash, target, _value, signature, data, eta);
861 
862         return returnData;
863     }
864 
865     function getBlockTimestamp() internal view returns (uint) {
866         // solium-disable-next-line security/no-block-members
867         return block.timestamp;
868     }
869 }
870 
871 // File: contracts\SealAdapter.sol
872 
873 
874 pragma solidity 0.6.12;
875 
876 
877 contract Seal{}
878 
879 library SealAdapter {
880     // Seal info
881     function rewardToken(Seal seal) external view returns (IERC20) {
882         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("rewardToken()"));
883         require(success, "rewardToken() staticcall failed.");
884         return abi.decode(result, (IERC20));
885     }
886 
887     function poolCount(Seal seal) external view returns (uint256) {
888         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("poolCount()"));
889         require(success, "poolCount() staticcall failed.");
890         return abi.decode(result, (uint256));
891     }
892 
893     function sellableRewardAmount(Seal seal) external view returns (uint256) {
894         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("sellableRewardAmount()"));
895         require(success, "sellableRewardAmount() staticcall failed.");
896         return abi.decode(result, (uint256));
897     }
898 
899     // Seal actions
900     function sellRewardForWeth(Seal seal, uint256 rewardAmount, address to) external returns(uint256) {
901         (bool success, bytes memory result) = address(seal).delegatecall(abi.encodeWithSignature("sellRewardForWeth(address,uint256,address)", address(seal), rewardAmount, to));
902         require(success, "sellRewardForWeth(uint256 rewardAmount, address to) delegatecall failed.");
903         return abi.decode(result, (uint256));
904     }
905 
906     // Pool info
907     function lockableToken(Seal seal, uint256 poolId) external view returns (IERC20) {
908         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("lockableToken(uint256)", poolId));
909         require(success, "lockableToken(uint256 poolId) staticcall failed.");
910         return abi.decode(result, (IERC20));
911     }
912 
913     function lockedAmount(Seal seal, uint256 poolId) external view returns (uint256) {
914         // note the impersonation
915         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("lockedAmount(address,uint256)", address(this), poolId));
916         require(success, "lockedAmount(uint256 poolId) staticcall failed.");
917         return abi.decode(result, (uint256));
918     }
919 
920     // Pool actions
921     function deposit(Seal seal, uint256 poolId, uint256 amount) external {
922         (bool success,) = address(seal).delegatecall(abi.encodeWithSignature("deposit(address,uint256,uint256)", address(seal), poolId, amount));
923         require(success, "deposit(uint256 poolId, uint256 amount) delegatecall failed.");
924     }
925 
926     function withdraw(Seal seal, uint256 poolId, uint256 amount) external {
927         (bool success,) = address(seal).delegatecall(abi.encodeWithSignature("withdraw(address,uint256,uint256)", address(seal), poolId, amount));
928         require(success, "withdraw(uint256 poolId, uint256 amount) delegatecall failed.");
929     }
930     
931     function claimReward(Seal seal, uint256 poolId) external {
932         (bool success,) = address(seal).delegatecall(abi.encodeWithSignature("claimReward(address,uint256)", address(seal), poolId));
933         require(success, "claimReward(uint256 poolId) delegatecall failed.");
934     }
935     
936     function emergencyWithdraw(Seal seal, uint256 poolId) external {
937         (bool success,) = address(seal).delegatecall(abi.encodeWithSignature("emergencyWithdraw(address,uint256)", address(seal), poolId));
938         require(success, "emergencyWithdraw(uint256 poolId) delegatecall failed.");
939     }
940     
941     // Service methods
942     function poolAddress(Seal seal, uint256 poolId) external view returns (address) {
943         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("poolAddress(uint256)", poolId));
944         require(success, "poolAddress(uint256 poolId) staticcall failed.");
945         return abi.decode(result, (address));
946     }
947 
948     function rewardToWethPool(Seal seal) external view returns (address) {
949         (bool success, bytes memory result) = address(seal).staticcall(abi.encodeWithSignature("rewardToWethPool()"));
950         require(success, "rewardToWethPool() staticcall failed.");
951         return abi.decode(result, (address));
952     }
953 }
954 
955 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
956 
957 
958 pragma solidity ^0.6.0;
959 
960 
961 
962 
963 
964 /**
965  * @dev Implementation of the {IERC20} interface.
966  *
967  * This implementation is agnostic to the way tokens are created. This means
968  * that a supply mechanism has to be added in a derived contract using {_mint}.
969  * For a generic mechanism see {ERC20PresetMinterPauser}.
970  *
971  * TIP: For a detailed writeup see our guide
972  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
973  * to implement supply mechanisms].
974  *
975  * We have followed general OpenZeppelin guidelines: functions revert instead
976  * of returning `false` on failure. This behavior is nonetheless conventional
977  * and does not conflict with the expectations of ERC20 applications.
978  *
979  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
980  * This allows applications to reconstruct the allowance for all accounts just
981  * by listening to said events. Other implementations of the EIP may not emit
982  * these events, as it isn't required by the specification.
983  *
984  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
985  * functions have been added to mitigate the well-known issues around setting
986  * allowances. See {IERC20-approve}.
987  */
988 contract ERC20 is Context, IERC20 {
989     using SafeMath for uint256;
990     using Address for address;
991 
992     mapping (address => uint256) private _balances;
993 
994     mapping (address => mapping (address => uint256)) private _allowances;
995 
996     uint256 private _totalSupply;
997 
998     string private _name;
999     string private _symbol;
1000     uint8 private _decimals;
1001 
1002     /**
1003      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
1004      * a default value of 18.
1005      *
1006      * To select a different value for {decimals}, use {_setupDecimals}.
1007      *
1008      * All three of these values are immutable: they can only be set once during
1009      * construction.
1010      */
1011     constructor (string memory name, string memory symbol) public {
1012         _name = name;
1013         _symbol = symbol;
1014         _decimals = 18;
1015     }
1016 
1017     /**
1018      * @dev Returns the name of the token.
1019      */
1020     function name() public view returns (string memory) {
1021         return _name;
1022     }
1023 
1024     /**
1025      * @dev Returns the symbol of the token, usually a shorter version of the
1026      * name.
1027      */
1028     function symbol() public view returns (string memory) {
1029         return _symbol;
1030     }
1031 
1032     /**
1033      * @dev Returns the number of decimals used to get its user representation.
1034      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1035      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1036      *
1037      * Tokens usually opt for a value of 18, imitating the relationship between
1038      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1039      * called.
1040      *
1041      * NOTE: This information is only used for _display_ purposes: it in
1042      * no way affects any of the arithmetic of the contract, including
1043      * {IERC20-balanceOf} and {IERC20-transfer}.
1044      */
1045     function decimals() public view returns (uint8) {
1046         return _decimals;
1047     }
1048 
1049     /**
1050      * @dev See {IERC20-totalSupply}.
1051      */
1052     function totalSupply() public view override returns (uint256) {
1053         return _totalSupply;
1054     }
1055 
1056     /**
1057      * @dev See {IERC20-balanceOf}.
1058      */
1059     function balanceOf(address account) public view override returns (uint256) {
1060         return _balances[account];
1061     }
1062 
1063     /**
1064      * @dev See {IERC20-transfer}.
1065      *
1066      * Requirements:
1067      *
1068      * - `recipient` cannot be the zero address.
1069      * - the caller must have a balance of at least `amount`.
1070      */
1071     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1072         _transfer(_msgSender(), recipient, amount);
1073         return true;
1074     }
1075 
1076     /**
1077      * @dev See {IERC20-allowance}.
1078      */
1079     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1080         return _allowances[owner][spender];
1081     }
1082 
1083     /**
1084      * @dev See {IERC20-approve}.
1085      *
1086      * Requirements:
1087      *
1088      * - `spender` cannot be the zero address.
1089      */
1090     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1091         _approve(_msgSender(), spender, amount);
1092         return true;
1093     }
1094 
1095     /**
1096      * @dev See {IERC20-transferFrom}.
1097      *
1098      * Emits an {Approval} event indicating the updated allowance. This is not
1099      * required by the EIP. See the note at the beginning of {ERC20};
1100      *
1101      * Requirements:
1102      * - `sender` and `recipient` cannot be the zero address.
1103      * - `sender` must have a balance of at least `amount`.
1104      * - the caller must have allowance for ``sender``'s tokens of at least
1105      * `amount`.
1106      */
1107     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1108         _transfer(sender, recipient, amount);
1109         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1110         return true;
1111     }
1112 
1113     /**
1114      * @dev Atomically increases the allowance granted to `spender` by the caller.
1115      *
1116      * This is an alternative to {approve} that can be used as a mitigation for
1117      * problems described in {IERC20-approve}.
1118      *
1119      * Emits an {Approval} event indicating the updated allowance.
1120      *
1121      * Requirements:
1122      *
1123      * - `spender` cannot be the zero address.
1124      */
1125     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1126         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1127         return true;
1128     }
1129 
1130     /**
1131      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1132      *
1133      * This is an alternative to {approve} that can be used as a mitigation for
1134      * problems described in {IERC20-approve}.
1135      *
1136      * Emits an {Approval} event indicating the updated allowance.
1137      *
1138      * Requirements:
1139      *
1140      * - `spender` cannot be the zero address.
1141      * - `spender` must have allowance for the caller of at least
1142      * `subtractedValue`.
1143      */
1144     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1145         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1146         return true;
1147     }
1148 
1149     /**
1150      * @dev Moves tokens `amount` from `sender` to `recipient`.
1151      *
1152      * This is internal function is equivalent to {transfer}, and can be used to
1153      * e.g. implement automatic token fees, slashing mechanisms, etc.
1154      *
1155      * Emits a {Transfer} event.
1156      *
1157      * Requirements:
1158      *
1159      * - `sender` cannot be the zero address.
1160      * - `recipient` cannot be the zero address.
1161      * - `sender` must have a balance of at least `amount`.
1162      */
1163     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1164         require(sender != address(0), "ERC20: transfer from the zero address");
1165         require(recipient != address(0), "ERC20: transfer to the zero address");
1166 
1167         _beforeTokenTransfer(sender, recipient, amount);
1168 
1169         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1170         _balances[recipient] = _balances[recipient].add(amount);
1171         emit Transfer(sender, recipient, amount);
1172     }
1173 
1174     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1175      * the total supply.
1176      *
1177      * Emits a {Transfer} event with `from` set to the zero address.
1178      *
1179      * Requirements
1180      *
1181      * - `to` cannot be the zero address.
1182      */
1183     function _mint(address account, uint256 amount) internal virtual {
1184         require(account != address(0), "ERC20: mint to the zero address");
1185 
1186         _beforeTokenTransfer(address(0), account, amount);
1187 
1188         _totalSupply = _totalSupply.add(amount);
1189         _balances[account] = _balances[account].add(amount);
1190         emit Transfer(address(0), account, amount);
1191     }
1192 
1193     /**
1194      * @dev Destroys `amount` tokens from `account`, reducing the
1195      * total supply.
1196      *
1197      * Emits a {Transfer} event with `to` set to the zero address.
1198      *
1199      * Requirements
1200      *
1201      * - `account` cannot be the zero address.
1202      * - `account` must have at least `amount` tokens.
1203      */
1204     function _burn(address account, uint256 amount) internal virtual {
1205         require(account != address(0), "ERC20: burn from the zero address");
1206 
1207         _beforeTokenTransfer(account, address(0), amount);
1208 
1209         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1210         _totalSupply = _totalSupply.sub(amount);
1211         emit Transfer(account, address(0), amount);
1212     }
1213 
1214     /**
1215      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1216      *
1217      * This internal function is equivalent to `approve`, and can be used to
1218      * e.g. set automatic allowances for certain subsystems, etc.
1219      *
1220      * Emits an {Approval} event.
1221      *
1222      * Requirements:
1223      *
1224      * - `owner` cannot be the zero address.
1225      * - `spender` cannot be the zero address.
1226      */
1227     function _approve(address owner, address spender, uint256 amount) internal virtual {
1228         require(owner != address(0), "ERC20: approve from the zero address");
1229         require(spender != address(0), "ERC20: approve to the zero address");
1230 
1231         _allowances[owner][spender] = amount;
1232         emit Approval(owner, spender, amount);
1233     }
1234 
1235     /**
1236      * @dev Sets {decimals} to a value other than the default one of 18.
1237      *
1238      * WARNING: This function should only be called from the constructor. Most
1239      * applications that interact with token contracts will not expect
1240      * {decimals} to ever change, and may work incorrectly if it does.
1241      */
1242     function _setupDecimals(uint8 decimals_) internal {
1243         _decimals = decimals_;
1244     }
1245 
1246     /**
1247      * @dev Hook that is called before any transfer of tokens. This includes
1248      * minting and burning.
1249      *
1250      * Calling conditions:
1251      *
1252      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1253      * will be to transferred to `to`.
1254      * - when `from` is zero, `amount` tokens will be minted for `to`.
1255      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1256      * - `from` and `to` are never both zero.
1257      *
1258      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1259      */
1260     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1261 }
1262 
1263 // File: contracts\xANTI.sol
1264 
1265 pragma solidity 0.6.12;
1266 
1267 contract xANTI is ERC20("xANTI", "xANTI"), Ownable {
1268     using SafeMath for uint256;
1269 
1270     event Minted(address indexed minter, address indexed receiver, uint mintAmount);
1271     event Burned(address indexed burner, uint burnAmount);
1272 
1273     function mint(address _to, uint256 _amount) public onlyOwner {
1274         _mint(_to, _amount);
1275         emit Minted(owner(), _to, _amount);
1276     }
1277 
1278     function burn(uint256 _amount) public {
1279         _burn(msg.sender, _amount);
1280         emit Burned(msg.sender, _amount);
1281     }
1282 }
1283 
1284 // File: contracts\MasterSeal.sol
1285 
1286 pragma solidity 0.6.12;
1287 
1288 contract MasterSeal is Ownable, Timelock {
1289     using SafeMath for uint256;
1290     using SafeERC20 for IERC20;
1291     using SealAdapter for Seal;
1292 
1293     struct UserInfo {
1294         uint256 amount;
1295         uint256 rewardDebt;
1296     }
1297 
1298     struct PoolInfo {
1299         Seal seal;
1300         uint256 victimPoolId;
1301         uint256 rewardPerBlock;
1302         uint256 lastRewardBlock;
1303         uint256 accAntiSealPerShare;
1304         uint256 rewardDrainModifier;
1305         uint256 wethDrainModifier;
1306     }
1307 
1308     xANTI public antiSeal;
1309     IERC20 weth;
1310     IERC20 antiSealV1;
1311     IUniswapV2Pair antiSealWethPair;
1312 
1313     address public drainAddress;
1314     address public poolRewardUpdater;
1315     address public devAddress;
1316     uint256 public constant DEV_FEE = 8;
1317     uint256 public constant REWARD_START_BLOCK = 9014486;  // Wed Nov 07 2020 13:28:00 UTC
1318     uint256 public constant BURN_TOKEN_IN_PERCENTAGE = 20;
1319 
1320     uint256 poolRewardLimiter;
1321 
1322     PoolInfo[] public poolInfo;
1323 
1324     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1325 
1326     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1327     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1328     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1329 
1330     modifier onlyDev() {
1331         require(devAddress == _msgSender(), "not dev");
1332         _;
1333     }
1334 
1335     modifier onlyRewardUpdater() {
1336         require(poolRewardUpdater == _msgSender(), "not reward updater");
1337         _;
1338     }
1339 
1340     constructor(
1341         xANTI _antiSeal,
1342         address _drainAddress
1343     ) public Timelock(msg.sender, 24 hours) {
1344         poolRewardLimiter = 300 ether;
1345         antiSeal = _antiSeal;
1346         drainAddress = _drainAddress;
1347         devAddress = msg.sender;
1348 
1349         // Ropsten
1350         // antiSealV1 = IERC20(0x21CCD4ce0cb8c67f99746a8B43EAe5577EBCA2aa);                                    // AntiSeal Token (Original)
1351         // weth = IERC20(0xc778417E063141139Fce010982780140Aa0cD5Ab);                                          // WETH 
1352         // IUniswapV2Factory uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);   // UniswapFactory
1353 
1354         // MainNetwork
1355         antiSealV1 = IERC20(0xE95e4440493E5b96e79D63E8Dc43AB676Dd44E4C);                                        // AntiSeal Token (Original)
1356         weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);                                              // WETH 
1357         IUniswapV2Factory uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);       // UniswapFactory
1358         
1359         antiSealWethPair = IUniswapV2Pair(uniswapFactory.getPair(address(weth), address(antiSealV1)));
1360     }
1361 
1362     function poolLength() external view returns (uint256) {
1363         return poolInfo.length;
1364     }
1365 
1366     function add(Seal _victim, uint256 _victimPoolId, uint256 _rewardPerBlock, uint256 _rewardDrainModifier, uint256 _wethDrainModifier) public onlyOwner {
1367         require(_rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1368         poolInfo.push(PoolInfo({
1369             seal: _victim,
1370             victimPoolId: _victimPoolId,
1371             rewardPerBlock: _rewardPerBlock,
1372             rewardDrainModifier: _rewardDrainModifier,
1373             wethDrainModifier: _wethDrainModifier,
1374             lastRewardBlock: block.number < REWARD_START_BLOCK ? REWARD_START_BLOCK : block.number,
1375             accAntiSealPerShare: 0
1376         }));
1377     }
1378 
1379     function updatePoolRewardLimiter(uint256 _poolRewardLimiter) public onlyOwner {
1380         poolRewardLimiter = _poolRewardLimiter;
1381     }
1382 
1383     function updateRewardPerBlock(uint256 _pid, uint256 _rewardPerBlock) public onlyRewardUpdater {
1384         require(_rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1385         updatePool(_pid);
1386         poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
1387     }
1388 
1389     function updateRewardPerBlockMassive(uint256[] memory pids, uint256[] memory rewards) public onlyRewardUpdater {
1390         require(pids.length == rewards.length, "-__-");
1391         for (uint i = 0; i < pids.length; i++) {
1392             uint256 pid = pids[i];
1393             uint256 rewardPerBlock = rewards[i];
1394             require(rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1395             updatePool(pid);
1396             poolInfo[pid].rewardPerBlock = rewardPerBlock;
1397         }
1398     }
1399 
1400     function updateVictimInfo(uint256 _pid, address _victim, uint256 _victimPoolId) public onlyOwner {
1401         poolInfo[_pid].seal = Seal(_victim);
1402         poolInfo[_pid].victimPoolId = _victimPoolId;
1403     }
1404 
1405     function updatePoolDrain(uint256 _pid, uint256 _rewardDrainModifier, uint256 _wethDrainModifier) public onlyOwner {
1406         PoolInfo storage pool = poolInfo[_pid];
1407         pool.rewardDrainModifier = _rewardDrainModifier;
1408         pool.wethDrainModifier = _wethDrainModifier;
1409     }
1410 
1411     function updateDevAddress(address _devAddress) public onlyDev {
1412         devAddress = _devAddress;
1413     }
1414 
1415     function updateDrainAddress(address _drainAddress) public onlyOwner {
1416         drainAddress = _drainAddress;
1417     }
1418 
1419     function updateRewardUpdaterAddress(address _poolRewardUpdater) public onlyOwner {
1420         poolRewardUpdater = _poolRewardUpdater;
1421     }
1422 
1423     function pendingXAntiSeal(uint256 _pid, address _user) external view returns (uint256) {
1424         PoolInfo storage pool = poolInfo[_pid];
1425         UserInfo storage user = userInfo[_pid][_user];
1426         uint256 accAntiSealPerShare = pool.accAntiSealPerShare;
1427         uint256 lpSupply = _pid == 0 ? antiSealWethPair.balanceOf(address(this)) : pool.seal.lockedAmount(pool.victimPoolId);
1428         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1429             uint256 blocksToReward = block.number.sub(pool.lastRewardBlock);
1430             uint256 xAntiSealReward = blocksToReward.mul(pool.rewardPerBlock);
1431             accAntiSealPerShare = accAntiSealPerShare.add(xAntiSealReward.mul(1e12).div(lpSupply));
1432         }
1433 
1434         uint256 pending = user.amount.mul(accAntiSealPerShare).div(1e12).sub(user.rewardDebt);
1435         if(pending > 0) {
1436             uint256 burnRewards = pending.mul(BURN_TOKEN_IN_PERCENTAGE).div(100);  
1437             return pending.sub(burnRewards);
1438         }
1439 
1440         return pending;
1441     }
1442 
1443     function massUpdatePools() public {
1444         uint256 length = poolInfo.length;
1445         for (uint256 pid = 0; pid < length; ++pid) {
1446             updatePool(pid);
1447         }
1448     }
1449 
1450     function updatePool(uint256 _pid) public {
1451         PoolInfo storage pool = poolInfo[_pid];
1452         if (block.number <= pool.lastRewardBlock) {
1453             return;
1454         }
1455 
1456         uint256 lpSupply = _pid == 0 ? antiSealWethPair.balanceOf(address(this)) : pool.seal.lockedAmount(pool.victimPoolId);
1457         if (lpSupply == 0) {
1458             pool.lastRewardBlock = block.number;
1459             return;
1460         }
1461 
1462         uint256 blocksToReward = block.number.sub(pool.lastRewardBlock);
1463         uint256 xAntiSealReward = blocksToReward.mul(pool.rewardPerBlock);
1464         antiSeal.mint(devAddress, xAntiSealReward.mul(DEV_FEE).div(100));
1465         antiSeal.mint(address(this), xAntiSealReward);
1466         pool.accAntiSealPerShare = pool.accAntiSealPerShare.add(xAntiSealReward.mul(1e12).div(lpSupply));
1467         pool.lastRewardBlock = block.number;
1468     }
1469 
1470     function deposit(uint256 _pid, uint256 _amount) public {
1471         PoolInfo storage pool = poolInfo[_pid];
1472         UserInfo storage user = userInfo[_pid][msg.sender];
1473         updatePool(_pid);
1474         if (user.amount > 0) {
1475             uint256 pending = user.amount.mul(pool.accAntiSealPerShare).div(1e12).sub(user.rewardDebt);
1476             if(pending > 0) {
1477                 uint256 burnRewards = pending.mul(BURN_TOKEN_IN_PERCENTAGE).div(100);
1478                 uint256 actualPending = pending.sub(burnRewards);
1479                 antiSeal.burn(burnRewards);                             // burn 20% of total earned rewards
1480                 safeXAntiSealTransfer(msg.sender, actualPending);
1481             }
1482         }
1483 
1484         if(_amount > 0) {
1485             if(_pid == 0) {
1486                 IERC20(address(antiSealWethPair)).safeTransferFrom(address(msg.sender), address(this), _amount);
1487             } else {
1488                 pool.seal.lockableToken(pool.victimPoolId).safeTransferFrom(address(msg.sender), address(this), _amount);
1489                 pool.seal.deposit(pool.victimPoolId, _amount);
1490             }
1491 
1492             user.amount = user.amount.add(_amount);
1493         }
1494 
1495         user.rewardDebt = user.amount.mul(pool.accAntiSealPerShare).div(1e12);
1496         emit Deposit(msg.sender, _pid, _amount);
1497     }
1498     
1499     function withdraw(uint256 _pid, uint256 _amount) public {
1500         PoolInfo storage pool = poolInfo[_pid];
1501         UserInfo storage user = userInfo[_pid][msg.sender];
1502         require(user.amount >= _amount, "withdraw: not good");
1503         updatePool(_pid);
1504         uint256 pending = user.amount.mul(pool.accAntiSealPerShare).div(1e12).sub(user.rewardDebt);
1505         if(pending > 0) {
1506             uint256 burnRewards = pending.mul(BURN_TOKEN_IN_PERCENTAGE).div(100);
1507             uint256 actualPending = pending.sub(burnRewards);
1508             antiSeal.burn(burnRewards);
1509             safeXAntiSealTransfer(msg.sender, actualPending);
1510         }
1511 
1512         if(_amount > 0) {
1513             user.amount = user.amount.sub(_amount);
1514             if(_pid == 0) {
1515                 IERC20(address(antiSealWethPair)).safeTransfer(address(msg.sender), _amount);
1516             } else {
1517                 pool.seal.withdraw(pool.victimPoolId, _amount);
1518                 pool.seal.lockableToken(pool.victimPoolId).safeTransfer(address(msg.sender), _amount);
1519             }
1520         }
1521 
1522         user.rewardDebt = user.amount.mul(pool.accAntiSealPerShare).div(1e12);
1523         emit Withdraw(msg.sender, _pid, _amount);
1524     }
1525 
1526     function emergencyWithdraw(uint256 _pid) public {
1527         PoolInfo storage pool = poolInfo[_pid];
1528         UserInfo storage user = userInfo[_pid][msg.sender];
1529         if(_pid == 0) {
1530             IERC20(address(antiSealWethPair)).safeTransfer(address(msg.sender), user.amount);
1531         } else {
1532             pool.seal.withdraw(pool.victimPoolId, user.amount);
1533             pool.seal.lockableToken(pool.victimPoolId).safeTransfer(address(msg.sender), user.amount);
1534         }
1535         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1536         user.amount = 0;
1537         user.rewardDebt = 0;
1538     }
1539 
1540     function safeXAntiSealTransfer(address _to, uint256 _amount) internal {
1541         uint256 balance = antiSeal.balanceOf(address(this));
1542         if (_amount > balance) {
1543             antiSeal.transfer(_to, balance);
1544         } else {
1545             antiSeal.transfer(_to, _amount);
1546         }
1547     }
1548     
1549     function drain(uint256 _pid) public {
1550         require(_pid != 0, "Can't drain from myself");
1551         PoolInfo storage pool = poolInfo[_pid];
1552         Seal seal = pool.seal;
1553         uint256 victimPoolId = pool.victimPoolId;
1554         uint256 rewardDrainModifier = pool.rewardDrainModifier;
1555         seal.claimReward(victimPoolId);
1556         IERC20 rewardToken = seal.rewardToken();
1557         uint256 claimedReward = rewardToken.balanceOf(address(this));
1558         uint256 rewardDrainAmount = claimedReward.mul(rewardDrainModifier).div(1000);
1559         if(rewardDrainAmount > 0) {
1560             rewardToken.transfer(drainAddress, rewardDrainAmount);
1561             claimedReward = claimedReward.sub(rewardDrainAmount);
1562         }
1563 
1564         uint256 sellableAmount = seal.sellableRewardAmount();
1565         if(sellableAmount < claimedReward) { // seal is drained empty
1566             claimedReward = sellableAmount;
1567         }
1568 
1569         if(claimedReward == 0) {
1570             return;
1571         }
1572 
1573         uint256 wethDrainModifier = pool.wethDrainModifier;
1574         uint256 wethReward = seal.sellRewardForWeth(claimedReward, address(this));
1575         uint256 wethDrainAmount = wethReward.mul(wethDrainModifier).div(1000);
1576         if(wethDrainAmount > 0) {
1577             weth.transfer(drainAddress, wethDrainAmount);
1578             wethReward = wethReward.sub(wethDrainAmount);
1579         }
1580 
1581         address token0 = antiSealWethPair.token0();
1582         (uint reserve0, uint reserve1,) = antiSealWethPair.getReserves();
1583         (uint reserveInput, uint reserveOutput) = address(weth) == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1584         uint amountOutput = UniswapV2Library.getAmountOut(wethReward, reserveInput, reserveOutput);
1585         (uint amount0Out, uint amount1Out) = address(weth) == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
1586 
1587         weth.transfer(address(antiSealWethPair), wethReward);
1588         antiSealWethPair.swap(amount0Out, amount1Out, address(this), new bytes(0));
1589 
1590         antiSeal.burn(amountOutput);
1591     }
1592 }