1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.0;
4 
5 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies in extcodesize, which returns 0 for contracts in
107         // construction, since the code is only stored at the end of the
108         // constructor execution.
109 
110         uint256 size;
111         // solhint-disable-next-line no-inline-assembly
112         assembly { size := extcodesize(account) }
113         return size > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
136         (bool success, ) = recipient.call{ value: amount }("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain`call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159       return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
169         return _functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
184         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
189      * with `errorMessage` as a fallback revert reason when `target` reverts.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
194         require(address(this).balance >= value, "Address: insufficient balance for call");
195         return _functionCallWithValue(target, data, value, errorMessage);
196     }
197 
198     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
199         require(isContract(target), "Address: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 // solhint-disable-next-line no-inline-assembly
211                 assembly {
212                     let returndata_size := mload(returndata)
213                     revert(add(32, returndata), returndata_size)
214                 }
215             } else {
216                 revert(errorMessage);
217             }
218         }
219     }
220 }
221 
222 
223 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
224 
225 /**
226  * @title SafeERC20
227  * @dev Wrappers around ERC20 operations that throw on failure (when the token
228  * contract returns false). Tokens that return no value (and instead revert or
229  * throw on failure) are also supported, non-reverting calls are assumed to be
230  * successful.
231  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
232  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
233  */
234 library SafeERC20 {
235     using SafeMath for uint256;
236     using Address for address;
237 
238     function safeTransfer(IERC20 token, address to, uint256 value) internal {
239         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
240     }
241 
242     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
243         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
244     }
245 
246     /**
247      * @dev Deprecated. This function has issues similar to the ones found in
248      * {IERC20-approve}, and its usage is discouraged.
249      *
250      * Whenever possible, use {safeIncreaseAllowance} and
251      * {safeDecreaseAllowance} instead.
252      */
253     function safeApprove(IERC20 token, address spender, uint256 value) internal {
254         // safeApprove should only be called when setting an initial allowance,
255         // or when resetting it to zero. To increase and decrease it, use
256         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
257         // solhint-disable-next-line max-line-length
258         require((value == 0) || (token.allowance(address(this), spender) == 0),
259             "SafeERC20: approve from non-zero to non-zero allowance"
260         );
261         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
262     }
263 
264     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
265         uint256 newAllowance = token.allowance(address(this), spender).add(value);
266         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
267     }
268 
269     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
270         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
271         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
272     }
273 
274     /**
275      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
276      * on the return value: the return value is optional (but if data is returned, it must not be false).
277      * @param token The token targeted by the call.
278      * @param data The call data (encoded using abi.encode or one of its variants).
279      */
280     function _callOptionalReturn(IERC20 token, bytes memory data) private {
281         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
282         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
283         // the target address contains contract code and also asserts for success in the low-level call.
284 
285         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
286         if (returndata.length > 0) { // Return data is optional
287             // solhint-disable-next-line max-line-length
288             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
289         }
290     }
291 }
292 
293 
294 // File: @openzeppelin\contracts\math\SafeMath.sol
295 
296 /**
297  * @dev Wrappers over Solidity's arithmetic operations with added overflow
298  * checks.
299  *
300  * Arithmetic operations in Solidity wrap on overflow. This can easily result
301  * in bugs, because programmers usually assume that an overflow raises an
302  * error, which is the standard behavior in high level programming languages.
303  * `SafeMath` restores this intuition by reverting the transaction when an
304  * operation overflows.
305  *
306  * Using this library instead of the unchecked operations eliminates an entire
307  * class of bugs, so it's recommended to use it always.
308  */
309 library SafeMath {
310     /**
311      * @dev Returns the addition of two unsigned integers, reverting on
312      * overflow.
313      *
314      * Counterpart to Solidity's `+` operator.
315      *
316      * Requirements:
317      *
318      * - Addition cannot overflow.
319      */
320     function add(uint256 a, uint256 b) internal pure returns (uint256) {
321         uint256 c = a + b;
322         require(c >= a, "SafeMath: addition overflow");
323 
324         return c;
325     }
326 
327     /**
328      * @dev Returns the subtraction of two unsigned integers, reverting on
329      * overflow (when the result is negative).
330      *
331      * Counterpart to Solidity's `-` operator.
332      *
333      * Requirements:
334      *
335      * - Subtraction cannot overflow.
336      */
337     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
338         return sub(a, b, "SafeMath: subtraction overflow");
339     }
340 
341     /**
342      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
343      * overflow (when the result is negative).
344      *
345      * Counterpart to Solidity's `-` operator.
346      *
347      * Requirements:
348      *
349      * - Subtraction cannot overflow.
350      */
351     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b <= a, errorMessage);
353         uint256 c = a - b;
354 
355         return c;
356     }
357 
358     /**
359      * @dev Returns the multiplication of two unsigned integers, reverting on
360      * overflow.
361      *
362      * Counterpart to Solidity's `*` operator.
363      *
364      * Requirements:
365      *
366      * - Multiplication cannot overflow.
367      */
368     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
369         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
370         // benefit is lost if 'b' is also tested.
371         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
372         if (a == 0) {
373             return 0;
374         }
375 
376         uint256 c = a * b;
377         require(c / a == b, "SafeMath: multiplication overflow");
378 
379         return c;
380     }
381 
382     /**
383      * @dev Returns the integer division of two unsigned integers. Reverts on
384      * division by zero. The result is rounded towards zero.
385      *
386      * Counterpart to Solidity's `/` operator. Note: this function uses a
387      * `revert` opcode (which leaves remaining gas untouched) while Solidity
388      * uses an invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function div(uint256 a, uint256 b) internal pure returns (uint256) {
395         return div(a, b, "SafeMath: division by zero");
396     }
397 
398     /**
399      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
400      * division by zero. The result is rounded towards zero.
401      *
402      * Counterpart to Solidity's `/` operator. Note: this function uses a
403      * `revert` opcode (which leaves remaining gas untouched) while Solidity
404      * uses an invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
411         require(b > 0, errorMessage);
412         uint256 c = a / b;
413         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
414 
415         return c;
416     }
417 
418     /**
419      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
420      * Reverts when dividing by zero.
421      *
422      * Counterpart to Solidity's `%` operator. This function uses a `revert`
423      * opcode (which leaves remaining gas untouched) while Solidity uses an
424      * invalid opcode to revert (consuming all remaining gas).
425      *
426      * Requirements:
427      *
428      * - The divisor cannot be zero.
429      */
430     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
431         return mod(a, b, "SafeMath: modulo by zero");
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
436      * Reverts with custom message when dividing by zero.
437      *
438      * Counterpart to Solidity's `%` operator. This function uses a `revert`
439      * opcode (which leaves remaining gas untouched) while Solidity uses an
440      * invalid opcode to revert (consuming all remaining gas).
441      *
442      * Requirements:
443      *
444      * - The divisor cannot be zero.
445      */
446     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
447         require(b != 0, errorMessage);
448         return a % b;
449     }
450 }
451 
452 
453 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
454 
455 /*
456  * @dev Provides information about the current execution context, including the
457  * sender of the transaction and its data. While these are generally available
458  * via msg.sender and msg.data, they should not be accessed in such a direct
459  * manner, since when dealing with GSN meta-transactions the account sending and
460  * paying for execution may not be the actual sender (as far as an application
461  * is concerned).
462  *
463  * This contract is only required for intermediate, library-like contracts.
464  */
465 abstract contract Context {
466     function _msgSender() internal view virtual returns (address payable) {
467         return msg.sender;
468     }
469 
470     function _msgData() internal view virtual returns (bytes memory) {
471         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
472         return msg.data;
473     }
474 }
475 
476 
477 // File: @openzeppelin\contracts\access\Ownable.sol
478 
479 /**
480  * @dev Contract module which provides a basic access control mechanism, where
481  * there is an account (an owner) that can be granted exclusive access to
482  * specific functions.
483  *
484  * By default, the owner account will be the one that deploys the contract. This
485  * can later be changed with {transferOwnership}.
486  *
487  * This module is used through inheritance. It will make available the modifier
488  * `onlyOwner`, which can be applied to your functions to restrict their use to
489  * the owner.
490  */
491 contract Ownable is Context {
492     address private _owner;
493 
494     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
495 
496     /**
497      * @dev Initializes the contract setting the deployer as the initial owner.
498      */
499     constructor () {
500         address msgSender = _msgSender();
501         _owner = msgSender;
502         emit OwnershipTransferred(address(0), msgSender);
503     }
504 
505     /**
506      * @dev Returns the address of the current owner.
507      */
508     function owner() public view returns (address) {
509         return _owner;
510     }
511 
512     /**
513      * @dev Throws if called by any account other than the owner.
514      */
515     modifier onlyOwner() {
516         require(_owner == _msgSender(), "Ownable: caller is not the owner");
517         _;
518     }
519 
520     /**
521      * @dev Leaves the contract without owner. It will not be possible to call
522      * `onlyOwner` functions anymore. Can only be called by the current owner.
523      *
524      * NOTE: Renouncing ownership will leave the contract without an owner,
525      * thereby removing any functionality that is only available to the owner.
526      */
527     function renounceOwnership() public virtual onlyOwner {
528         emit OwnershipTransferred(_owner, address(0));
529         _owner = address(0);
530     }
531 
532     /**
533      * @dev Transfers ownership of the contract to a new account (`newOwner`).
534      * Can only be called by the current owner.
535      */
536     function transferOwnership(address newOwner) public virtual onlyOwner {
537         require(newOwner != address(0), "Ownable: new owner is the zero address");
538         emit OwnershipTransferred(_owner, newOwner);
539         _owner = newOwner;
540     }
541 }
542 
543 
544 // File: contracts\interfaces\IUniswapV2Pair.sol
545 
546 interface IUniswapV2Pair {
547     event Approval(address indexed owner, address indexed spender, uint value);
548     event Transfer(address indexed from, address indexed to, uint value);
549 
550     function name() external pure returns (string memory);
551     function symbol() external pure returns (string memory);
552     function decimals() external pure returns (uint8);
553     function totalSupply() external view returns (uint);
554     function balanceOf(address owner) external view returns (uint);
555     function allowance(address owner, address spender) external view returns (uint);
556 
557     function approve(address spender, uint value) external returns (bool);
558     function transfer(address to, uint value) external returns (bool);
559     function transferFrom(address from, address to, uint value) external returns (bool);
560 
561     function DOMAIN_SEPARATOR() external view returns (bytes32);
562     function PERMIT_TYPEHASH() external pure returns (bytes32);
563     function nonces(address owner) external view returns (uint);
564 
565     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
566 
567     event Mint(address indexed sender, uint amount0, uint amount1);
568     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
569     event Swap(
570         address indexed sender,
571         uint amount0In,
572         uint amount1In,
573         uint amount0Out,
574         uint amount1Out,
575         address indexed to
576     );
577     event Sync(uint112 reserve0, uint112 reserve1);
578 
579     function MINIMUM_LIQUIDITY() external pure returns (uint);
580     function factory() external view returns (address);
581     function token0() external view returns (address);
582     function token1() external view returns (address);
583     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
584     function price0CumulativeLast() external view returns (uint);
585     function price1CumulativeLast() external view returns (uint);
586     function kLast() external view returns (uint);
587 
588     function mint(address to) external returns (uint liquidity);
589     function burn(address to) external returns (uint amount0, uint amount1);
590     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
591     function skim(address to) external;
592     function sync() external;
593 
594     function initialize(address, address) external;
595 }
596 
597 
598 // File: contracts\interfaces\IUniswapV2Factory.sol
599 
600 interface IUniswapV2Factory {
601     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
602 
603     function feeTo() external view returns (address);
604     function feeToSetter() external view returns (address);
605     function migrator() external view returns (address);
606 
607     function getPair(address tokenA, address tokenB) external view returns (address pair);
608     function allPairs(uint) external view returns (address pair);
609     function allPairsLength() external view returns (uint);
610 
611     function createPair(address tokenA, address tokenB) external returns (address pair);
612 
613     function setFeeTo(address) external;
614     function setFeeToSetter(address) external;
615     function setMigrator(address) external;
616 }
617 
618 
619 // File: contracts\libraries\SafeMath.sol
620 
621 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
622 
623 library SafeMathUniswap {
624     function add(uint x, uint y) internal pure returns (uint z) {
625         require((z = x + y) >= x, 'ds-math-add-overflow');
626     }
627 
628     function sub(uint x, uint y) internal pure returns (uint z) {
629         require((z = x - y) <= x, 'ds-math-sub-underflow');
630     }
631 
632     function mul(uint x, uint y) internal pure returns (uint z) {
633         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
634     }
635 }
636 
637 
638 // File: contracts\libraries\UniswapV2Library.sol
639 
640 library UniswapV2Library {
641     using SafeMathUniswap for uint;
642 
643     // returns sorted token addresses, used to handle return values from pairs sorted in this order
644     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
645         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
646         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
647         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
648     }
649 
650     // calculates the CREATE2 address for a pair without making any external calls
651     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
652         (address token0, address token1) = sortTokens(tokenA, tokenB);
653         pair = address(uint(keccak256(abi.encodePacked(
654                 hex'ff',
655                 factory,
656                 keccak256(abi.encodePacked(token0, token1)),
657                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
658             ))));
659     }
660 
661     // fetches and sorts the reserves for a pair
662     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
663         (address token0,) = sortTokens(tokenA, tokenB);
664         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
665         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
666     }
667 
668     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
669     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
670         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
671         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
672         amountB = amountA.mul(reserveB) / reserveA;
673     }
674 
675     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
676     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
677         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
678         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
679         uint amountInWithFee = amountIn.mul(997);
680         uint numerator = amountInWithFee.mul(reserveOut);
681         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
682         amountOut = numerator / denominator;
683     }
684 
685     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
686     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
687         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
688         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
689         uint numerator = reserveIn.mul(amountOut).mul(1000);
690         uint denominator = reserveOut.sub(amountOut).mul(997);
691         amountIn = (numerator / denominator).add(1);
692     }
693 
694     // performs chained getAmountOut calculations on any number of pairs
695     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
696         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
697         amounts = new uint[](path.length);
698         amounts[0] = amountIn;
699         for (uint i; i < path.length - 1; i++) {
700             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
701             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
702         }
703     }
704 
705     // performs chained getAmountIn calculations on any number of pairs
706     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
707         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
708         amounts = new uint[](path.length);
709         amounts[amounts.length - 1] = amountOut;
710         for (uint i = path.length - 1; i > 0; i--) {
711             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
712             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
713         }
714     }
715 }
716 
717 
718 // File: contracts\Timelock.sol
719 
720 contract Timelock {
721     using SafeMath for uint;
722 
723     event NewAdmin(address indexed newAdmin);
724     event NewPendingAdmin(address indexed newPendingAdmin);
725     event NewDelay(uint indexed newDelay);
726     event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
727     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
728     event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);
729 
730     uint public constant GRACE_PERIOD = 14 days;
731     uint public constant MINIMUM_DELAY = 24 hours;
732     uint public constant MAXIMUM_DELAY = 30 days;
733 
734     address public admin;
735     address public pendingAdmin;
736     uint public delay;
737     bool public admin_initialized;
738 
739     mapping (bytes32 => bool) public queuedTransactions;
740 
741 
742     constructor(address admin_, uint delay_) {
743         require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");
744         require(delay_ <= MAXIMUM_DELAY, "Timelock::constructor: Delay must not exceed maximum delay.");
745 
746         admin = admin_;
747         delay = delay_;
748         admin_initialized = false;
749     }
750 
751     receive() external payable { }
752 
753     function setDelay(uint delay_) public {
754         require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
755         require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");
756         require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");
757         delay = delay_;
758 
759         emit NewDelay(delay);
760     }
761 
762     function acceptAdmin() public {
763         require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");
764         admin = msg.sender;
765         pendingAdmin = address(0);
766 
767         emit NewAdmin(admin);
768     }
769 
770     function setPendingAdmin(address pendingAdmin_) public {
771         // allows one time setting of admin for deployment purposes
772         if (admin_initialized) {
773             require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");
774         } else {
775             require(msg.sender == admin, "Timelock::setPendingAdmin: First call must come from admin.");
776             admin_initialized = true;
777         }
778         pendingAdmin = pendingAdmin_;
779 
780         emit NewPendingAdmin(pendingAdmin);
781     }
782 
783     function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {
784         require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");
785         require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
786 
787         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
788         queuedTransactions[txHash] = true;
789 
790         emit QueueTransaction(txHash, target, value, signature, data, eta);
791         return txHash;
792     }
793 
794     function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {
795         require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");
796 
797         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
798         queuedTransactions[txHash] = false;
799 
800         emit CancelTransaction(txHash, target, value, signature, data, eta);
801     }
802 
803     function executeTransaction(address target, uint _value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {
804         require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");
805 
806         bytes32 txHash = keccak256(abi.encode(target, _value, signature, data, eta));
807         require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
808         require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
809         require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");
810 
811         queuedTransactions[txHash] = false;
812 
813         bytes memory callData;
814 
815         if (bytes(signature).length == 0) {
816             callData = data;
817         } else {
818             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
819         }
820 
821         // solium-disable-next-line security/no-call-value
822         (bool success, bytes memory returnData) = target.call{value:_value}(callData);
823         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
824 
825         emit ExecuteTransaction(txHash, target, _value, signature, data, eta);
826 
827         return returnData;
828     }
829 
830     function getBlockTimestamp() internal view returns (uint) {
831         // solium-disable-next-line security/no-block-members
832         return block.timestamp;
833     }
834 }
835 
836 
837 // File: contracts\VampireAdapter.sol
838 
839 contract Victim{}
840 
841 library VampireAdapter {
842     // Victim info
843     function rewardToken(Victim victim) external view returns (IERC20) {
844         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("rewardToken()"));
845         require(success, "rewardToken() staticcall failed.");
846         return abi.decode(result, (IERC20));
847     }
848 
849     function poolCount(Victim victim) external view returns (uint256) {
850         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("poolCount()"));
851         require(success, "poolCount() staticcall failed.");
852         return abi.decode(result, (uint256));
853     }
854 
855     function sellableRewardAmount(Victim victim) external view returns (uint256) {
856         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("sellableRewardAmount()"));
857         require(success, "sellableRewardAmount() staticcall failed.");
858         return abi.decode(result, (uint256));
859     }
860 
861     // Victim actions
862     function sellRewardForWeth(Victim victim, uint256 rewardAmount, address to) external returns(uint256) {
863         (bool success, bytes memory result) = address(victim).delegatecall(abi.encodeWithSignature("sellRewardForWeth(address,uint256,address)", address(victim), rewardAmount, to));
864         require(success, "sellRewardForWeth(uint256 rewardAmount, address to) delegatecall failed.");
865         return abi.decode(result, (uint256));
866     }
867 
868     // Pool info
869     function lockableToken(Victim victim, uint256 poolId) external view returns (IERC20) {
870         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("lockableToken(uint256)", poolId));
871         require(success, "lockableToken(uint256 poolId) staticcall failed.");
872         return abi.decode(result, (IERC20));
873     }
874 
875     function lockedAmount(Victim victim, uint256 poolId) external view returns (uint256) {
876         // note the impersonation
877         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("lockedAmount(address,uint256)", address(this), poolId));
878         require(success, "lockedAmount(uint256 poolId) staticcall failed.");
879         return abi.decode(result, (uint256));
880     }
881 
882     // Pool actions
883     function deposit(Victim victim, uint256 poolId, uint256 amount) external {
884         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("deposit(address,uint256,uint256)", address(victim), poolId, amount));
885         require(success, "deposit(uint256 poolId, uint256 amount) delegatecall failed.");
886     }
887 
888     function withdraw(Victim victim, uint256 poolId, uint256 amount) external {
889         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("withdraw(address,uint256,uint256)", address(victim), poolId, amount));
890         require(success, "withdraw(uint256 poolId, uint256 amount) delegatecall failed.");
891     }
892     
893     function claimReward(Victim victim, uint256 poolId) external {
894         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("claimReward(address,uint256)", address(victim), poolId));
895         require(success, "claimReward(uint256 poolId) delegatecall failed.");
896     }
897     
898     function emergencyWithdraw(Victim victim, uint256 poolId) external {
899         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("emergencyWithdraw(address,uint256)", address(victim), poolId));
900         require(success, "emergencyWithdraw(uint256 poolId) delegatecall failed.");
901     }
902     
903     // Service methods
904     function poolAddress(Victim victim, uint256 poolId) external view returns (address) {
905         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("poolAddress(uint256)", poolId));
906         require(success, "poolAddress(uint256 poolId) staticcall failed.");
907         return abi.decode(result, (address));
908     }
909 
910     function rewardToWethPool(Victim victim) external view returns (address) {
911         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("rewardToWethPool()"));
912         require(success, "rewardToWethPool() staticcall failed.");
913         return abi.decode(result, (address));
914     }
915 }
916 
917 
918 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
919 
920 /**
921  * @dev Implementation of the {IERC20} interface.
922  *
923  * This implementation is agnostic to the way tokens are created. This means
924  * that a supply mechanism has to be added in a derived contract using {_mint}.
925  * For a generic mechanism see {ERC20PresetMinterPauser}.
926  *
927  * TIP: For a detailed writeup see our guide
928  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
929  * to implement supply mechanisms].
930  *
931  * We have followed general OpenZeppelin guidelines: functions revert instead
932  * of returning `false` on failure. This behavior is nonetheless conventional
933  * and does not conflict with the expectations of ERC20 applications.
934  *
935  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
936  * This allows applications to reconstruct the allowance for all accounts just
937  * by listening to said events. Other implementations of the EIP may not emit
938  * these events, as it isn't required by the specification.
939  *
940  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
941  * functions have been added to mitigate the well-known issues around setting
942  * allowances. See {IERC20-approve}.
943  */
944 contract ERC20 is Context, IERC20 {
945     using SafeMath for uint256;
946     using Address for address;
947 
948     mapping (address => uint256) private _balances;
949 
950     mapping (address => mapping (address => uint256)) private _allowances;
951 
952     uint256 private _totalSupply;
953 
954     string private _name;
955     string private _symbol;
956     uint8 private _decimals;
957 
958     /**
959      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
960      * a default value of 18.
961      *
962      * To select a different value for {decimals}, use {_setupDecimals}.
963      *
964      * All three of these values are immutable: they can only be set once during
965      * construction.
966      */
967     constructor (string memory name, string memory symbol) {
968         _name = name;
969         _symbol = symbol;
970         _decimals = 18;
971     }
972 
973     /**
974      * @dev Returns the name of the token.
975      */
976     function name() public view returns (string memory) {
977         return _name;
978     }
979 
980     /**
981      * @dev Returns the symbol of the token, usually a shorter version of the
982      * name.
983      */
984     function symbol() public view returns (string memory) {
985         return _symbol;
986     }
987 
988     /**
989      * @dev Returns the number of decimals used to get its user representation.
990      * For example, if `decimals` equals `2`, a balance of `505` tokens should
991      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
992      *
993      * Tokens usually opt for a value of 18, imitating the relationship between
994      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
995      * called.
996      *
997      * NOTE: This information is only used for _display_ purposes: it in
998      * no way affects any of the arithmetic of the contract, including
999      * {IERC20-balanceOf} and {IERC20-transfer}.
1000      */
1001     function decimals() public view returns (uint8) {
1002         return _decimals;
1003     }
1004 
1005     /**
1006      * @dev See {IERC20-totalSupply}.
1007      */
1008     function totalSupply() public view override returns (uint256) {
1009         return _totalSupply;
1010     }
1011 
1012     /**
1013      * @dev See {IERC20-balanceOf}.
1014      */
1015     function balanceOf(address account) public view override returns (uint256) {
1016         return _balances[account];
1017     }
1018 
1019     /**
1020      * @dev See {IERC20-transfer}.
1021      *
1022      * Requirements:
1023      *
1024      * - `recipient` cannot be the zero address.
1025      * - the caller must have a balance of at least `amount`.
1026      */
1027     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1028         _transfer(_msgSender(), recipient, amount);
1029         return true;
1030     }
1031 
1032     /**
1033      * @dev See {IERC20-allowance}.
1034      */
1035     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1036         return _allowances[owner][spender];
1037     }
1038 
1039     /**
1040      * @dev See {IERC20-approve}.
1041      *
1042      * Requirements:
1043      *
1044      * - `spender` cannot be the zero address.
1045      */
1046     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1047         _approve(_msgSender(), spender, amount);
1048         return true;
1049     }
1050 
1051     /**
1052      * @dev See {IERC20-transferFrom}.
1053      *
1054      * Emits an {Approval} event indicating the updated allowance. This is not
1055      * required by the EIP. See the note at the beginning of {ERC20};
1056      *
1057      * Requirements:
1058      * - `sender` and `recipient` cannot be the zero address.
1059      * - `sender` must have a balance of at least `amount`.
1060      * - the caller must have allowance for ``sender``'s tokens of at least
1061      * `amount`.
1062      */
1063     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1064         _transfer(sender, recipient, amount);
1065         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1066         return true;
1067     }
1068 
1069     /**
1070      * @dev Atomically increases the allowance granted to `spender` by the caller.
1071      *
1072      * This is an alternative to {approve} that can be used as a mitigation for
1073      * problems described in {IERC20-approve}.
1074      *
1075      * Emits an {Approval} event indicating the updated allowance.
1076      *
1077      * Requirements:
1078      *
1079      * - `spender` cannot be the zero address.
1080      */
1081     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1082         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1083         return true;
1084     }
1085 
1086     /**
1087      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1088      *
1089      * This is an alternative to {approve} that can be used as a mitigation for
1090      * problems described in {IERC20-approve}.
1091      *
1092      * Emits an {Approval} event indicating the updated allowance.
1093      *
1094      * Requirements:
1095      *
1096      * - `spender` cannot be the zero address.
1097      * - `spender` must have allowance for the caller of at least
1098      * `subtractedValue`.
1099      */
1100     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1101         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1102         return true;
1103     }
1104 
1105     /**
1106      * @dev Moves tokens `amount` from `sender` to `recipient`.
1107      *
1108      * This is internal function is equivalent to {transfer}, and can be used to
1109      * e.g. implement automatic token fees, slashing mechanisms, etc.
1110      *
1111      * Emits a {Transfer} event.
1112      *
1113      * Requirements:
1114      *
1115      * - `sender` cannot be the zero address.
1116      * - `recipient` cannot be the zero address.
1117      * - `sender` must have a balance of at least `amount`.
1118      */
1119     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1120         require(sender != address(0), "ERC20: transfer from the zero address");
1121         require(recipient != address(0), "ERC20: transfer to the zero address");
1122 
1123         _beforeTokenTransfer(sender, recipient, amount);
1124 
1125         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1126         _balances[recipient] = _balances[recipient].add(amount);
1127         emit Transfer(sender, recipient, amount);
1128     }
1129 
1130     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1131      * the total supply.
1132      *
1133      * Emits a {Transfer} event with `from` set to the zero address.
1134      *
1135      * Requirements
1136      *
1137      * - `to` cannot be the zero address.
1138      */
1139     function _mint(address account, uint256 amount) internal virtual {
1140         require(account != address(0), "ERC20: mint to the zero address");
1141 
1142         _beforeTokenTransfer(address(0), account, amount);
1143 
1144         _totalSupply = _totalSupply.add(amount);
1145         _balances[account] = _balances[account].add(amount);
1146         emit Transfer(address(0), account, amount);
1147     }
1148 
1149     /**
1150      * @dev Destroys `amount` tokens from `account`, reducing the
1151      * total supply.
1152      *
1153      * Emits a {Transfer} event with `to` set to the zero address.
1154      *
1155      * Requirements
1156      *
1157      * - `account` cannot be the zero address.
1158      * - `account` must have at least `amount` tokens.
1159      */
1160     function _burn(address account, uint256 amount) internal virtual {
1161         require(account != address(0), "ERC20: burn from the zero address");
1162 
1163         _beforeTokenTransfer(account, address(0), amount);
1164 
1165         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1166         _totalSupply = _totalSupply.sub(amount);
1167         emit Transfer(account, address(0), amount);
1168     }
1169 
1170     /**
1171      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1172      *
1173      * This internal function is equivalent to `approve`, and can be used to
1174      * e.g. set automatic allowances for certain subsystems, etc.
1175      *
1176      * Emits an {Approval} event.
1177      *
1178      * Requirements:
1179      *
1180      * - `owner` cannot be the zero address.
1181      * - `spender` cannot be the zero address.
1182      */
1183     function _approve(address owner, address spender, uint256 amount) internal virtual {
1184         require(owner != address(0), "ERC20: approve from the zero address");
1185         require(spender != address(0), "ERC20: approve to the zero address");
1186 
1187         _allowances[owner][spender] = amount;
1188         emit Approval(owner, spender, amount);
1189     }
1190 
1191     /**
1192      * @dev Sets {decimals} to a value other than the default one of 18.
1193      *
1194      * WARNING: This function should only be called from the constructor. Most
1195      * applications that interact with token contracts will not expect
1196      * {decimals} to ever change, and may work incorrectly if it does.
1197      */
1198     function _setupDecimals(uint8 decimals_) internal {
1199         _decimals = decimals_;
1200     }
1201 
1202     /**
1203      * @dev Hook that is called before any transfer of tokens. This includes
1204      * minting and burning.
1205      *
1206      * Calling conditions:
1207      *
1208      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1209      * will be to transferred to `to`.
1210      * - when `from` is zero, `amount` tokens will be minted for `to`.
1211      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1212      * - `from` and `to` are never both zero.
1213      *
1214      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1215      */
1216     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1217 }
1218 
1219 
1220 // File: contracts\NerdlingToken.sol
1221 
1222 contract NerdlingToken is ERC20("Nerdling Token", "NERDLING"), Ownable {
1223     using SafeMath for uint256;
1224 
1225     event Minted(address indexed minter, address indexed receiver, uint mintAmount);
1226     event Burned(address indexed burner, uint burnAmount);
1227 
1228     function mint(address _to, uint256 _amount) public onlyOwner {
1229         _mint(_to, _amount);
1230         emit Minted(owner(), _to, _amount);
1231     }
1232 
1233     function burn(uint256 _amount) public {
1234         _burn(msg.sender, _amount);
1235         emit Burned(msg.sender, _amount);
1236     }
1237 
1238     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override virtual { 
1239         _moveDelegates(_delegates[from], _delegates[to], amount);
1240     }
1241 
1242     /// @dev A record of each accounts delegate
1243     mapping (address => address) internal _delegates;
1244 
1245     /// @notice A checkpoint for marking number of votes from a given block
1246     struct Checkpoint {
1247         uint32 fromBlock;
1248         uint256 votes;
1249     }
1250 
1251     /// @notice A record of votes checkpoints for each account, by index
1252     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1253 
1254     /// @notice The number of checkpoints for each account
1255     mapping (address => uint32) public numCheckpoints;
1256 
1257     /// @notice The EIP-712 typehash for the contract's domain
1258     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1259 
1260     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1261     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1262 
1263     /// @notice A record of states for signing / validating signatures
1264     mapping (address => uint) public nonces;
1265 
1266       /// @notice An event thats emitted when an account changes its delegate
1267     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1268 
1269     /// @notice An event thats emitted when a delegate account's vote balance changes
1270     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1271 
1272     /**
1273      * @notice Delegate votes from `msg.sender` to `delegatee`
1274      * @param delegator The address to get delegatee for
1275      */
1276     function delegates(address delegator)
1277         external
1278         view
1279         returns (address)
1280     {
1281         return _delegates[delegator];
1282     }
1283 
1284    /**
1285     * @notice Delegate votes from `msg.sender` to `delegatee`
1286     * @param delegatee The address to delegate votes to
1287     */
1288     function delegate(address delegatee) external {
1289         return _delegate(msg.sender, delegatee);
1290     }
1291 
1292     /**
1293      * @notice Delegates votes from signatory to `delegatee`
1294      * @param delegatee The address to delegate votes to
1295      * @param nonce The contract state required to match the signature
1296      * @param expiry The time at which to expire the signature
1297      * @param v The recovery byte of the signature
1298      * @param r Half of the ECDSA signature pair
1299      * @param s Half of the ECDSA signature pair
1300      */
1301     function delegateBySig(
1302         address delegatee,
1303         uint nonce,
1304         uint expiry,
1305         uint8 v,
1306         bytes32 r,
1307         bytes32 s
1308     )
1309         external
1310     {
1311         bytes32 domainSeparator = keccak256(
1312             abi.encode(
1313                 DOMAIN_TYPEHASH,
1314                 keccak256(bytes(name())),
1315                 getChainId(),
1316                 address(this)
1317             )
1318         );
1319 
1320         bytes32 structHash = keccak256(
1321             abi.encode(
1322                 DELEGATION_TYPEHASH,
1323                 delegatee,
1324                 nonce,
1325                 expiry
1326             )
1327         );
1328 
1329         bytes32 digest = keccak256(
1330             abi.encodePacked(
1331                 "\x19\x01",
1332                 domainSeparator,
1333                 structHash
1334             )
1335         );
1336 
1337         address signatory = ecrecover(digest, v, r, s);
1338         require(signatory != address(0), "NERDLING::delegateBySig: invalid signature");
1339         require(nonce == nonces[signatory]++, "NERDLING::delegateBySig: invalid nonce");
1340         require(block.timestamp <= expiry, "NERDLING::delegateBySig: signature expired");
1341         return _delegate(signatory, delegatee);
1342     }
1343 
1344     /**
1345      * @notice Gets the current votes balance for `account`
1346      * @param account The address to get votes balance
1347      * @return The number of current votes for `account`
1348      */
1349     function getCurrentVotes(address account)
1350         external
1351         view
1352         returns (uint256)
1353     {
1354         uint32 nCheckpoints = numCheckpoints[account];
1355         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1356     }
1357 
1358     /**
1359      * @notice Determine the prior number of votes for an account as of a block number
1360      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1361      * @param account The address of the account to check
1362      * @param blockNumber The block number to get the vote balance at
1363      * @return The number of votes the account had as of the given block
1364      */
1365     function getPriorVotes(address account, uint blockNumber)
1366         external
1367         view
1368         returns (uint256)
1369     {
1370         require(blockNumber < block.number, "NERDLING::getPriorVotes: not yet determined");
1371 
1372         uint32 nCheckpoints = numCheckpoints[account];
1373         if (nCheckpoints == 0) {
1374             return 0;
1375         }
1376 
1377         // First check most recent balance
1378         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1379             return checkpoints[account][nCheckpoints - 1].votes;
1380         }
1381 
1382         // Next check implicit zero balance
1383         if (checkpoints[account][0].fromBlock > blockNumber) {
1384             return 0;
1385         }
1386 
1387         uint32 lower = 0;
1388         uint32 upper = nCheckpoints - 1;
1389         while (upper > lower) {
1390             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1391             Checkpoint memory cp = checkpoints[account][center];
1392             if (cp.fromBlock == blockNumber) {
1393                 return cp.votes;
1394             } else if (cp.fromBlock < blockNumber) {
1395                 lower = center;
1396             } else {
1397                 upper = center - 1;
1398             }
1399         }
1400         return checkpoints[account][lower].votes;
1401     }
1402 
1403     function _delegate(address delegator, address delegatee)
1404         internal
1405     {
1406         address currentDelegate = _delegates[delegator];
1407         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying NERDLINGs (not scaled);
1408         _delegates[delegator] = delegatee;
1409 
1410         emit DelegateChanged(delegator, currentDelegate, delegatee);
1411 
1412         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1413     }
1414 
1415     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1416         if (srcRep != dstRep && amount > 0) {
1417             if (srcRep != address(0)) {
1418                 // decrease old representative
1419                 uint32 srcRepNum = numCheckpoints[srcRep];
1420                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1421                 uint256 srcRepNew = srcRepOld.sub(amount);
1422                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1423             }
1424 
1425             if (dstRep != address(0)) {
1426                 // increase new representative
1427                 uint32 dstRepNum = numCheckpoints[dstRep];
1428                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1429                 uint256 dstRepNew = dstRepOld.add(amount);
1430                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1431             }
1432         }
1433     }
1434 
1435     function _writeCheckpoint(
1436         address delegatee,
1437         uint32 nCheckpoints,
1438         uint256 oldVotes,
1439         uint256 newVotes
1440     )
1441         internal
1442     {
1443         uint32 blockNumber = safe32(block.number, "NERDLING::_writeCheckpoint: block number exceeds 32 bits");
1444 
1445         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1446             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1447         } else {
1448             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1449             numCheckpoints[delegatee] = nCheckpoints + 1;
1450         }
1451 
1452         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1453     }
1454 
1455     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1456         require(n < 2**32, errorMessage);
1457         return uint32(n);
1458     }
1459 
1460     function getChainId() internal pure returns (uint) {
1461         uint256 chainId;
1462         assembly { chainId := chainid() }
1463         return chainId;
1464     }
1465 }
1466 
1467 
1468 // File: contracts\MasterVampire.sol
1469 
1470 contract MasterVampire is Ownable, Timelock {
1471     using SafeMath for uint256;
1472     using SafeERC20 for IERC20;
1473     using VampireAdapter for Victim;
1474 
1475     struct UserInfo {
1476         uint256 amount;
1477         uint256 rewardDebt;
1478     }
1479 
1480     struct PoolInfo {
1481         Victim victim;
1482         uint256 victimPoolId;
1483         uint256 rewardPerBlock;
1484         uint256 lastRewardBlock;
1485         uint256 accNerdlingPerShare;
1486         uint256 rewardDrainModifier;
1487         uint256 wethDrainModifier;
1488     }
1489 
1490     NerdlingToken public nerdling;
1491     IERC20 weth;
1492     IUniswapV2Pair nerdlingWethPair;
1493 
1494     address public drainAddress;
1495     address public fundAddress = address(0x289026a9018D5AA8CB05f228dd9460C1229aaf81);
1496     address public poolRewardUpdater;
1497     address public devAddress;
1498     uint256 public constant DEV_FEE = 1;
1499     uint256 public constant REWARD_START_BLOCK = 11180000; // Mon Nov 02 2020 09:30:00 PM UTC
1500     uint256 public constant DURATION_BLOCK = 174545; // Blocks for 30 days
1501     uint256 public constant DAILY_BLOCK = 5818; // 24 * 3600 / 14.85(seconds per block)
1502     mapping(uint256 => uint256) private _drainQueue;
1503 
1504     uint256 poolRewardLimiter;
1505 
1506     PoolInfo[] public poolInfo;
1507 
1508     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1509 
1510     uint256 private _randomSeed;
1511 
1512     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1513     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1514     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1515 
1516     modifier onlyDev() {
1517         require(devAddress == _msgSender(), "not dev");
1518         _;
1519     }
1520 
1521     modifier onlyRewardUpdater() {
1522         require(poolRewardUpdater == _msgSender(), "not reward updater");
1523         _;
1524     }
1525 
1526     constructor(
1527         NerdlingToken _nerdling,
1528         address _drainAddress
1529     ) Timelock(msg.sender, 24 hours) {
1530         poolRewardLimiter = 300 ether;
1531         nerdling = _nerdling;
1532         drainAddress = _drainAddress;
1533         devAddress = msg.sender;
1534         weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
1535         IUniswapV2Factory uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1536         nerdlingWethPair = IUniswapV2Pair(uniswapFactory.getPair(address(weth), address(nerdling)));
1537     }
1538 
1539     function poolLength() external view returns (uint256) {
1540         return poolInfo.length;
1541     }
1542 
1543     function add(Victim _victim, uint256 _victimPoolId, uint256 _rewardPerBlock, uint256 _rewardDrainModifier, uint256 _wethDrainModifier) public onlyOwner {
1544         require(_rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1545         poolInfo.push(PoolInfo({
1546             victim: _victim,
1547             victimPoolId: _victimPoolId,
1548             rewardPerBlock: _rewardPerBlock,
1549             rewardDrainModifier: _rewardDrainModifier,
1550             wethDrainModifier: _wethDrainModifier,
1551             lastRewardBlock: block.number < REWARD_START_BLOCK ? REWARD_START_BLOCK : block.number,
1552             accNerdlingPerShare: 0
1553         }));
1554     }
1555 
1556     function updatePoolRewardLimiter(uint256 _poolRewardLimiter) public onlyOwner {
1557         poolRewardLimiter = _poolRewardLimiter;
1558     }
1559 
1560     function updateRewardPerBlock(uint256 _pid, uint256 _rewardPerBlock) public onlyRewardUpdater {
1561         require(_rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1562         updatePool(_pid);
1563         poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
1564     }
1565 
1566     function updateRewardPerBlockMassive(uint256[] memory pids, uint256[] memory rewards) public onlyRewardUpdater {
1567         require(pids.length == rewards.length, "-__-");
1568         for (uint i = 0; i < pids.length; i++) {
1569             uint256 pid = pids[i];
1570             uint256 rewardPerBlock = rewards[i];
1571             require(rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1572             updatePool(pid);
1573             poolInfo[pid].rewardPerBlock = rewardPerBlock;
1574         }
1575     }
1576 
1577     function updateVictimInfo(uint256 _pid, address _victim, uint256 _victimPoolId) public onlyOwner {
1578         poolInfo[_pid].victim = Victim(_victim);
1579         poolInfo[_pid].victimPoolId = _victimPoolId;
1580     }
1581 
1582     function updatePoolDrain(uint256 _pid, uint256 _rewardDrainModifier, uint256 _wethDrainModifier) public onlyOwner {
1583         PoolInfo storage pool = poolInfo[_pid];
1584         pool.rewardDrainModifier = _rewardDrainModifier;
1585         pool.wethDrainModifier = _wethDrainModifier;
1586     }
1587 
1588     function updateDevAddress(address _devAddress) public onlyDev {
1589         devAddress = _devAddress;
1590     }
1591 
1592     function updateDrainAddress(address _drainAddress) public onlyOwner {
1593         drainAddress = _drainAddress;
1594     }
1595 
1596     function updateRewardUpdaterAddress(address _poolRewardUpdater) public onlyOwner {
1597         poolRewardUpdater = _poolRewardUpdater;
1598     }
1599 
1600     function pendingNerdling(uint256 _pid, address _user) external view returns (uint256) {
1601         PoolInfo storage pool = poolInfo[_pid];
1602         UserInfo storage user = userInfo[_pid][_user];
1603         uint256 accNerdlingPerShare = pool.accNerdlingPerShare;
1604         uint256 lpSupply = _pid == 0 ? nerdlingWethPair.balanceOf(address(this)) : pool.victim.lockedAmount(pool.victimPoolId);
1605         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1606             uint256 blocksToReward = block.number.sub(pool.lastRewardBlock);
1607             uint256 nerdlingReward = blocksToReward.mul(pool.rewardPerBlock);
1608             accNerdlingPerShare = accNerdlingPerShare.add(nerdlingReward.mul(1e12).div(lpSupply));
1609         }
1610 
1611         return user.amount.mul(accNerdlingPerShare).div(1e12).sub(user.rewardDebt);
1612     }
1613 
1614     function massUpdatePools() public {
1615         uint256 length = poolInfo.length;
1616         for (uint256 pid = 0; pid < length; ++pid) {
1617             updatePool(pid);
1618         }
1619     }
1620 
1621     function updatePool(uint256 _pid) public {
1622         PoolInfo storage pool = poolInfo[_pid];
1623         if (block.number <= pool.lastRewardBlock) {
1624             return;
1625         }
1626 
1627         uint256 lpSupply = _pid == 0 ? nerdlingWethPair.balanceOf(address(this)) : pool.victim.lockedAmount(pool.victimPoolId);
1628         if (lpSupply == 0) {
1629             pool.lastRewardBlock = block.number;
1630             return;
1631         }
1632 
1633         uint256 blocksToReward = block.number.sub(pool.lastRewardBlock);
1634         uint256 rewardPerBlock = pool.rewardPerBlock;
1635         uint256 passedBlock = block.number.sub(REWARD_START_BLOCK);
1636         uint256 decreasedRewardPerBlock = rewardPerBlock.mul(DURATION_BLOCK).mul(DURATION_BLOCK).div(DURATION_BLOCK.mul(DURATION_BLOCK).add(passedBlock.mul(passedBlock)));
1637         uint256 nerdlingReward = blocksToReward.mul(decreasedRewardPerBlock);
1638         nerdling.mint(devAddress, nerdlingReward.mul(DEV_FEE).div(100));
1639         nerdling.mint(address(this), nerdlingReward);
1640         pool.accNerdlingPerShare = pool.accNerdlingPerShare.add(nerdlingReward.mul(1e12).div(lpSupply));
1641         pool.lastRewardBlock = block.number;
1642     }
1643 
1644     function deposit(uint256 _pid, uint256 _amount) public {
1645         PoolInfo storage pool = poolInfo[_pid];
1646         UserInfo storage user = userInfo[_pid][msg.sender];
1647         updatePool(_pid);
1648         if (user.amount > 0) {
1649             uint256 pending = user.amount.mul(pool.accNerdlingPerShare).div(1e12).sub(user.rewardDebt);
1650             if(pending > 0) {
1651                 safeNerdlingTransfer(msg.sender, pending);
1652             }
1653         }
1654 
1655         if(_amount > 0) {
1656             if(_pid == 0) {
1657                 IERC20(address(nerdlingWethPair)).safeTransferFrom(address(msg.sender), address(this), _amount);
1658             } else {
1659                 pool.victim.lockableToken(pool.victimPoolId).safeTransferFrom(address(msg.sender), address(this), _amount);
1660                 pool.victim.deposit(pool.victimPoolId, _amount);
1661             }
1662 
1663             user.amount = user.amount.add(_amount);
1664         }
1665 
1666         user.rewardDebt = user.amount.mul(pool.accNerdlingPerShare).div(1e12);
1667         emit Deposit(msg.sender, _pid, _amount);
1668     }
1669     
1670     function withdraw(uint256 _pid, uint256 _amount) public {
1671         PoolInfo storage pool = poolInfo[_pid];
1672         UserInfo storage user = userInfo[_pid][msg.sender];
1673         require(user.amount >= _amount, "withdraw: not good");
1674         updatePool(_pid);
1675         uint256 pending = user.amount.mul(pool.accNerdlingPerShare).div(1e12).sub(user.rewardDebt);
1676         if(pending > 0) {
1677             safeNerdlingTransfer(msg.sender, pending);
1678         }
1679 
1680         if(_amount > 0) {
1681             user.amount = user.amount.sub(_amount);
1682             if(_pid == 0) {
1683                 IERC20(address(nerdlingWethPair)).safeTransfer(address(msg.sender), _amount);
1684             } else {
1685                 pool.victim.withdraw(pool.victimPoolId, _amount);
1686                 pool.victim.lockableToken(pool.victimPoolId).safeTransfer(address(msg.sender), _amount);
1687             }
1688         }
1689 
1690         user.rewardDebt = user.amount.mul(pool.accNerdlingPerShare).div(1e12);
1691         emit Withdraw(msg.sender, _pid, _amount);
1692     }
1693 
1694     function emergencyWithdraw(uint256 _pid) public {
1695         PoolInfo storage pool = poolInfo[_pid];
1696         UserInfo storage user = userInfo[_pid][msg.sender];
1697         if(_pid == 0) {
1698             IERC20(address(nerdlingWethPair)).safeTransfer(address(msg.sender), user.amount);
1699         } else {
1700             pool.victim.withdraw(pool.victimPoolId, user.amount);
1701             pool.victim.lockableToken(pool.victimPoolId).safeTransfer(address(msg.sender), user.amount);
1702         }
1703         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1704         user.amount = 0;
1705         user.rewardDebt = 0;
1706     }
1707 
1708     function safeNerdlingTransfer(address _to, uint256 _amount) internal {
1709         uint256 balance = nerdling.balanceOf(address(this));
1710         if (_amount > balance) {
1711             nerdling.transfer(_to, balance);
1712         } else {
1713             nerdling.transfer(_to, _amount);
1714         }
1715     }
1716 
1717     function drain(uint256 _pid) public {
1718         require(_pid != 0, "Can't drain from myself");
1719         if (_drainQueue[_pid] == 0) {
1720             _drainQueue[_pid] = block.number;
1721         } else {
1722             if (_drainQueue[_pid] + random(DAILY_BLOCK) < block.number) {
1723                 _drainQueue[_pid] = block.number;
1724                 _drain(_pid);
1725             }
1726         }
1727     }
1728 
1729     function random(uint256 _range) private returns (uint256) {
1730         _randomSeed++;
1731         return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, _randomSeed))) % _range;
1732     }
1733     
1734     function _drain(uint256 _pid) private {
1735         PoolInfo storage pool = poolInfo[_pid];
1736         Victim victim = pool.victim;
1737         uint256 victimPoolId = pool.victimPoolId;
1738         uint256 rewardDrainModifier = pool.rewardDrainModifier;
1739         victim.claimReward(victimPoolId);
1740         IERC20 rewardToken = victim.rewardToken();
1741         uint256 claimedReward = rewardToken.balanceOf(address(this));
1742         uint256 rewardDrainAmount = claimedReward.mul(rewardDrainModifier).div(1000);
1743         if(rewardDrainAmount > 0) {
1744             rewardToken.transfer(drainAddress, rewardDrainAmount);
1745             claimedReward = claimedReward.sub(rewardDrainAmount);
1746         }
1747 
1748         uint256 sellableAmount = victim.sellableRewardAmount();
1749         if(sellableAmount < claimedReward) { // victim is drained empty
1750             claimedReward = sellableAmount;
1751         }
1752 
1753         if(claimedReward == 0) {
1754             return;
1755         }
1756 
1757         uint256 wethDrainModifier = pool.wethDrainModifier;
1758         uint256 wethReward = victim.sellRewardForWeth(claimedReward, address(this));
1759         uint256 wethDrainAmount = wethReward.mul(wethDrainModifier).div(1000);
1760         if(wethDrainAmount > 0) {
1761             weth.transfer(drainAddress, wethDrainAmount);
1762             wethReward = wethReward.sub(wethDrainAmount);
1763         }
1764 
1765         address token0 = nerdlingWethPair.token0();
1766         (uint reserve0, uint reserve1,) = nerdlingWethPair.getReserves();
1767         (uint reserveInput, uint reserveOutput) = address(weth) == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1768         uint amountOutput = UniswapV2Library.getAmountOut(wethReward, reserveInput, reserveOutput);
1769         (uint amount0Out, uint amount1Out) = address(weth) == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
1770 
1771         weth.transfer(address(nerdlingWethPair), wethReward);
1772         nerdlingWethPair.swap(amount0Out, amount1Out, address(this), new bytes(0));
1773 
1774         amountOutput = amountOutput.div(2);
1775         nerdling.transfer(fundAddress, amountOutput);
1776         nerdling.burn(amountOutput);
1777     }
1778 }