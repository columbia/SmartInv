1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
81 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
82 
83 
84 pragma solidity ^0.6.2;
85 
86 /**
87  * @dev Collection of functions related to the address type
88  */
89 library Address {
90     /**
91      * @dev Returns true if `account` is a contract.
92      *
93      * [IMPORTANT]
94      * ====
95      * It is unsafe to assume that an address for which this function returns
96      * false is an externally-owned account (EOA) and not a contract.
97      *
98      * Among others, `isContract` will return false for the following
99      * types of addresses:
100      *
101      *  - an externally-owned account
102      *  - a contract in construction
103      *  - an address where a contract will be created
104      *  - an address where a contract lived, but was destroyed
105      * ====
106      */
107     function isContract(address account) internal view returns (bool) {
108         // This method relies in extcodesize, which returns 0 for contracts in
109         // construction, since the code is only stored at the end of the
110         // constructor execution.
111 
112         uint256 size;
113         // solhint-disable-next-line no-inline-assembly
114         assembly { size := extcodesize(account) }
115         return size > 0;
116     }
117 
118     /**
119      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
120      * `recipient`, forwarding all available gas and reverting on errors.
121      *
122      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
123      * of certain opcodes, possibly making contracts go over the 2300 gas limit
124      * imposed by `transfer`, making them unable to receive funds via
125      * `transfer`. {sendValue} removes this limitation.
126      *
127      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
128      *
129      * IMPORTANT: because control is transferred to `recipient`, care must be
130      * taken to not create reentrancy vulnerabilities. Consider using
131      * {ReentrancyGuard} or the
132      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
133      */
134     function sendValue(address payable recipient, uint256 amount) internal {
135         require(address(this).balance >= amount, "Address: insufficient balance");
136 
137         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
138         (bool success, ) = recipient.call{ value: amount }("");
139         require(success, "Address: unable to send value, recipient may have reverted");
140     }
141 
142     /**
143      * @dev Performs a Solidity function call using a low level `call`. A
144      * plain`call` is an unsafe replacement for a function call: use this
145      * function instead.
146      *
147      * If `target` reverts with a revert reason, it is bubbled up by this
148      * function (like regular Solidity function calls).
149      *
150      * Returns the raw returned data. To convert to the expected return value,
151      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
152      *
153      * Requirements:
154      *
155      * - `target` must be a contract.
156      * - calling `target` with `data` must not revert.
157      *
158      * _Available since v3.1._
159      */
160     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
161       return functionCall(target, data, "Address: low-level call failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
166      * `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
171         return _functionCallWithValue(target, data, 0, errorMessage);
172     }
173 
174     /**
175      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
176      * but also transferring `value` wei to `target`.
177      *
178      * Requirements:
179      *
180      * - the calling contract must have an ETH balance of at least `value`.
181      * - the called Solidity function must be `payable`.
182      *
183      * _Available since v3.1._
184      */
185     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
186         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
191      * with `errorMessage` as a fallback revert reason when `target` reverts.
192      *
193      * _Available since v3.1._
194      */
195     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
196         require(address(this).balance >= value, "Address: insufficient balance for call");
197         return _functionCallWithValue(target, data, value, errorMessage);
198     }
199 
200     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
201         require(isContract(target), "Address: call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
205         if (success) {
206             return returndata;
207         } else {
208             // Look for revert reason and bubble it up if present
209             if (returndata.length > 0) {
210                 // The easiest way to bubble the revert reason is using memory via assembly
211 
212                 // solhint-disable-next-line no-inline-assembly
213                 assembly {
214                     let returndata_size := mload(returndata)
215                     revert(add(32, returndata), returndata_size)
216                 }
217             } else {
218                 revert(errorMessage);
219             }
220         }
221     }
222 }
223 
224 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
225 
226 
227 pragma solidity ^0.6.0;
228 
229 
230 
231 
232 /**
233  * @title SafeERC20
234  * @dev Wrappers around ERC20 operations that throw on failure (when the token
235  * contract returns false). Tokens that return no value (and instead revert or
236  * throw on failure) are also supported, non-reverting calls are assumed to be
237  * successful.
238  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
239  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
240  */
241 library SafeERC20 {
242     using SafeMath for uint256;
243     using Address for address;
244 
245     function safeTransfer(IERC20 token, address to, uint256 value) internal {
246         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
247     }
248 
249     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
250         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
251     }
252 
253     /**
254      * @dev Deprecated. This function has issues similar to the ones found in
255      * {IERC20-approve}, and its usage is discouraged.
256      *
257      * Whenever possible, use {safeIncreaseAllowance} and
258      * {safeDecreaseAllowance} instead.
259      */
260     function safeApprove(IERC20 token, address spender, uint256 value) internal {
261         // safeApprove should only be called when setting an initial allowance,
262         // or when resetting it to zero. To increase and decrease it, use
263         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
264         // solhint-disable-next-line max-line-length
265         require((value == 0) || (token.allowance(address(this), spender) == 0),
266             "SafeERC20: approve from non-zero to non-zero allowance"
267         );
268         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
269     }
270 
271     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
272         uint256 newAllowance = token.allowance(address(this), spender).add(value);
273         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
274     }
275 
276     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
277         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
278         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
279     }
280 
281     /**
282      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
283      * on the return value: the return value is optional (but if data is returned, it must not be false).
284      * @param token The token targeted by the call.
285      * @param data The call data (encoded using abi.encode or one of its variants).
286      */
287     function _callOptionalReturn(IERC20 token, bytes memory data) private {
288         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
289         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
290         // the target address contains contract code and also asserts for success in the low-level call.
291 
292         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
293         if (returndata.length > 0) { // Return data is optional
294             // solhint-disable-next-line max-line-length
295             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
296         }
297     }
298 }
299 
300 // File: @openzeppelin\contracts\math\SafeMath.sol
301 
302 
303 pragma solidity ^0.6.0;
304 
305 /**
306  * @dev Wrappers over Solidity's arithmetic operations with added overflow
307  * checks.
308  *
309  * Arithmetic operations in Solidity wrap on overflow. This can easily result
310  * in bugs, because programmers usually assume that an overflow raises an
311  * error, which is the standard behavior in high level programming languages.
312  * `SafeMath` restores this intuition by reverting the transaction when an
313  * operation overflows.
314  *
315  * Using this library instead of the unchecked operations eliminates an entire
316  * class of bugs, so it's recommended to use it always.
317  */
318 library SafeMath {
319     /**
320      * @dev Returns the addition of two unsigned integers, reverting on
321      * overflow.
322      *
323      * Counterpart to Solidity's `+` operator.
324      *
325      * Requirements:
326      *
327      * - Addition cannot overflow.
328      */
329     function add(uint256 a, uint256 b) internal pure returns (uint256) {
330         uint256 c = a + b;
331         require(c >= a, "SafeMath: addition overflow");
332 
333         return c;
334     }
335 
336     /**
337      * @dev Returns the subtraction of two unsigned integers, reverting on
338      * overflow (when the result is negative).
339      *
340      * Counterpart to Solidity's `-` operator.
341      *
342      * Requirements:
343      *
344      * - Subtraction cannot overflow.
345      */
346     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
347         return sub(a, b, "SafeMath: subtraction overflow");
348     }
349 
350     /**
351      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
352      * overflow (when the result is negative).
353      *
354      * Counterpart to Solidity's `-` operator.
355      *
356      * Requirements:
357      *
358      * - Subtraction cannot overflow.
359      */
360     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         require(b <= a, errorMessage);
362         uint256 c = a - b;
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the multiplication of two unsigned integers, reverting on
369      * overflow.
370      *
371      * Counterpart to Solidity's `*` operator.
372      *
373      * Requirements:
374      *
375      * - Multiplication cannot overflow.
376      */
377     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
378         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
379         // benefit is lost if 'b' is also tested.
380         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
381         if (a == 0) {
382             return 0;
383         }
384 
385         uint256 c = a * b;
386         require(c / a == b, "SafeMath: multiplication overflow");
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the integer division of two unsigned integers. Reverts on
393      * division by zero. The result is rounded towards zero.
394      *
395      * Counterpart to Solidity's `/` operator. Note: this function uses a
396      * `revert` opcode (which leaves remaining gas untouched) while Solidity
397      * uses an invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function div(uint256 a, uint256 b) internal pure returns (uint256) {
404         return div(a, b, "SafeMath: division by zero");
405     }
406 
407     /**
408      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
409      * division by zero. The result is rounded towards zero.
410      *
411      * Counterpart to Solidity's `/` operator. Note: this function uses a
412      * `revert` opcode (which leaves remaining gas untouched) while Solidity
413      * uses an invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b > 0, errorMessage);
421         uint256 c = a / b;
422         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * Reverts when dividing by zero.
430      *
431      * Counterpart to Solidity's `%` operator. This function uses a `revert`
432      * opcode (which leaves remaining gas untouched) while Solidity uses an
433      * invalid opcode to revert (consuming all remaining gas).
434      *
435      * Requirements:
436      *
437      * - The divisor cannot be zero.
438      */
439     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
440         return mod(a, b, "SafeMath: modulo by zero");
441     }
442 
443     /**
444      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
445      * Reverts with custom message when dividing by zero.
446      *
447      * Counterpart to Solidity's `%` operator. This function uses a `revert`
448      * opcode (which leaves remaining gas untouched) while Solidity uses an
449      * invalid opcode to revert (consuming all remaining gas).
450      *
451      * Requirements:
452      *
453      * - The divisor cannot be zero.
454      */
455     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
456         require(b != 0, errorMessage);
457         return a % b;
458     }
459 }
460 
461 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
462 
463 
464 pragma solidity ^0.6.0;
465 
466 /*
467  * @dev Provides information about the current execution context, including the
468  * sender of the transaction and its data. While these are generally available
469  * via msg.sender and msg.data, they should not be accessed in such a direct
470  * manner, since when dealing with GSN meta-transactions the account sending and
471  * paying for execution may not be the actual sender (as far as an application
472  * is concerned).
473  *
474  * This contract is only required for intermediate, library-like contracts.
475  */
476 abstract contract Context {
477     function _msgSender() internal view virtual returns (address payable) {
478         return msg.sender;
479     }
480 
481     function _msgData() internal view virtual returns (bytes memory) {
482         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
483         return msg.data;
484     }
485 }
486 
487 // File: @openzeppelin\contracts\access\Ownable.sol
488 
489 
490 pragma solidity ^0.6.0;
491 
492 /**
493  * @dev Contract module which provides a basic access control mechanism, where
494  * there is an account (an owner) that can be granted exclusive access to
495  * specific functions.
496  *
497  * By default, the owner account will be the one that deploys the contract. This
498  * can later be changed with {transferOwnership}.
499  *
500  * This module is used through inheritance. It will make available the modifier
501  * `onlyOwner`, which can be applied to your functions to restrict their use to
502  * the owner.
503  */
504 contract Ownable is Context {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev Initializes the contract setting the deployer as the initial owner.
511      */
512     constructor () internal {
513         address msgSender = _msgSender();
514         _owner = msgSender;
515         emit OwnershipTransferred(address(0), msgSender);
516     }
517 
518     /**
519      * @dev Returns the address of the current owner.
520      */
521     function owner() public view returns (address) {
522         return _owner;
523     }
524 
525     /**
526      * @dev Throws if called by any account other than the owner.
527      */
528     modifier onlyOwner() {
529         require(_owner == _msgSender(), "Ownable: caller is not the owner");
530         _;
531     }
532 
533     /**
534      * @dev Leaves the contract without owner. It will not be possible to call
535      * `onlyOwner` functions anymore. Can only be called by the current owner.
536      *
537      * NOTE: Renouncing ownership will leave the contract without an owner,
538      * thereby removing any functionality that is only available to the owner.
539      */
540     function renounceOwnership() public virtual onlyOwner {
541         emit OwnershipTransferred(_owner, address(0));
542         _owner = address(0);
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 }
555 
556 // File: contracts\interfaces\IUniswapV2Pair.sol
557 
558 pragma solidity >=0.5.0;
559 
560 interface IUniswapV2Pair {
561     event Approval(address indexed owner, address indexed spender, uint value);
562     event Transfer(address indexed from, address indexed to, uint value);
563 
564     function name() external pure returns (string memory);
565     function symbol() external pure returns (string memory);
566     function decimals() external pure returns (uint8);
567     function totalSupply() external view returns (uint);
568     function balanceOf(address owner) external view returns (uint);
569     function allowance(address owner, address spender) external view returns (uint);
570 
571     function approve(address spender, uint value) external returns (bool);
572     function transfer(address to, uint value) external returns (bool);
573     function transferFrom(address from, address to, uint value) external returns (bool);
574 
575     function DOMAIN_SEPARATOR() external view returns (bytes32);
576     function PERMIT_TYPEHASH() external pure returns (bytes32);
577     function nonces(address owner) external view returns (uint);
578 
579     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
580 
581     event Mint(address indexed sender, uint amount0, uint amount1);
582     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
583     event Swap(
584         address indexed sender,
585         uint amount0In,
586         uint amount1In,
587         uint amount0Out,
588         uint amount1Out,
589         address indexed to
590     );
591     event Sync(uint112 reserve0, uint112 reserve1);
592 
593     function MINIMUM_LIQUIDITY() external pure returns (uint);
594     function factory() external view returns (address);
595     function token0() external view returns (address);
596     function token1() external view returns (address);
597     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
598     function price0CumulativeLast() external view returns (uint);
599     function price1CumulativeLast() external view returns (uint);
600     function kLast() external view returns (uint);
601 
602     function mint(address to) external returns (uint liquidity);
603     function burn(address to) external returns (uint amount0, uint amount1);
604     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
605     function skim(address to) external;
606     function sync() external;
607 
608     function initialize(address, address) external;
609 }
610 
611 // File: contracts\interfaces\IUniswapV2Factory.sol
612 
613 pragma solidity >=0.5.0;
614 
615 interface IUniswapV2Factory {
616     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
617 
618     function feeTo() external view returns (address);
619     function feeToSetter() external view returns (address);
620     function migrator() external view returns (address);
621 
622     function getPair(address tokenA, address tokenB) external view returns (address pair);
623     function allPairs(uint) external view returns (address pair);
624     function allPairsLength() external view returns (uint);
625 
626     function createPair(address tokenA, address tokenB) external returns (address pair);
627 
628     function setFeeTo(address) external;
629     function setFeeToSetter(address) external;
630     function setMigrator(address) external;
631 }
632 
633 // File: contracts\libraries\SafeMath.sol
634 
635 pragma solidity =0.6.12;
636 
637 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
638 
639 library SafeMathUniswap {
640     function add(uint x, uint y) internal pure returns (uint z) {
641         require((z = x + y) >= x, 'ds-math-add-overflow');
642     }
643 
644     function sub(uint x, uint y) internal pure returns (uint z) {
645         require((z = x - y) <= x, 'ds-math-sub-underflow');
646     }
647 
648     function mul(uint x, uint y) internal pure returns (uint z) {
649         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
650     }
651 }
652 
653 // File: contracts\libraries\UniswapV2Library.sol
654 
655 pragma solidity >=0.5.0;
656 
657 
658 
659 library UniswapV2Library {
660     using SafeMathUniswap for uint;
661 
662     // returns sorted token addresses, used to handle return values from pairs sorted in this order
663     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
664         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
665         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
666         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
667     }
668 
669     // calculates the CREATE2 address for a pair without making any external calls
670     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
671         (address token0, address token1) = sortTokens(tokenA, tokenB);
672         pair = address(uint(keccak256(abi.encodePacked(
673                 hex'ff',
674                 factory,
675                 keccak256(abi.encodePacked(token0, token1)),
676                 hex'e18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303' // init code hash
677             ))));
678     }
679 
680     // fetches and sorts the reserves for a pair
681     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
682         (address token0,) = sortTokens(tokenA, tokenB);
683         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
684         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
685     }
686 
687     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
688     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
689         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
690         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
691         amountB = amountA.mul(reserveB) / reserveA;
692     }
693 
694     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
695     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
696         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
697         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
698         uint amountInWithFee = amountIn.mul(997);
699         uint numerator = amountInWithFee.mul(reserveOut);
700         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
701         amountOut = numerator / denominator;
702     }
703 
704     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
705     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
706         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
707         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
708         uint numerator = reserveIn.mul(amountOut).mul(1000);
709         uint denominator = reserveOut.sub(amountOut).mul(997);
710         amountIn = (numerator / denominator).add(1);
711     }
712 
713     // performs chained getAmountOut calculations on any number of pairs
714     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
715         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
716         amounts = new uint[](path.length);
717         amounts[0] = amountIn;
718         for (uint i; i < path.length - 1; i++) {
719             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
720             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
721         }
722     }
723 
724     // performs chained getAmountIn calculations on any number of pairs
725     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
726         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
727         amounts = new uint[](path.length);
728         amounts[amounts.length - 1] = amountOut;
729         for (uint i = path.length - 1; i > 0; i--) {
730             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
731             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
732         }
733     }
734 }
735 
736 // File: contracts\Timelock.sol
737 
738 
739 pragma solidity 0.6.12;
740 
741 
742 contract Timelock {
743     using SafeMath for uint;
744 
745     event NewAdmin(address indexed newAdmin);
746     event NewPendingAdmin(address indexed newPendingAdmin);
747     event NewDelay(uint indexed newDelay);
748     event CancelTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
749     event ExecuteTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature,  bytes data, uint eta);
750     event QueueTransaction(bytes32 indexed txHash, address indexed target, uint value, string signature, bytes data, uint eta);
751 
752     uint public constant GRACE_PERIOD = 14 days;
753     uint public constant MINIMUM_DELAY = 24 hours;
754     uint public constant MAXIMUM_DELAY = 30 days;
755 
756     address public admin;
757     address public pendingAdmin;
758     uint public delay;
759     bool public admin_initialized;
760 
761     mapping (bytes32 => bool) public queuedTransactions;
762 
763 
764     constructor(address admin_, uint delay_) public {
765         require(delay_ >= MINIMUM_DELAY, "Timelock::constructor: Delay must exceed minimum delay.");
766         require(delay_ <= MAXIMUM_DELAY, "Timelock::constructor: Delay must not exceed maximum delay.");
767 
768         admin = admin_;
769         delay = delay_;
770         admin_initialized = false;
771     }
772 
773     receive() external payable { }
774 
775     function setDelay(uint delay_) public {
776         require(msg.sender == address(this), "Timelock::setDelay: Call must come from Timelock.");
777         require(delay_ >= MINIMUM_DELAY, "Timelock::setDelay: Delay must exceed minimum delay.");
778         require(delay_ <= MAXIMUM_DELAY, "Timelock::setDelay: Delay must not exceed maximum delay.");
779         delay = delay_;
780 
781         emit NewDelay(delay);
782     }
783 
784     function acceptAdmin() public {
785         require(msg.sender == pendingAdmin, "Timelock::acceptAdmin: Call must come from pendingAdmin.");
786         admin = msg.sender;
787         pendingAdmin = address(0);
788 
789         emit NewAdmin(admin);
790     }
791 
792     function setPendingAdmin(address pendingAdmin_) public {
793         // allows one time setting of admin for deployment purposes
794         if (admin_initialized) {
795             require(msg.sender == address(this), "Timelock::setPendingAdmin: Call must come from Timelock.");
796         } else {
797             require(msg.sender == admin, "Timelock::setPendingAdmin: First call must come from admin.");
798             admin_initialized = true;
799         }
800         pendingAdmin = pendingAdmin_;
801 
802         emit NewPendingAdmin(pendingAdmin);
803     }
804 
805     function queueTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public returns (bytes32) {
806         require(msg.sender == admin, "Timelock::queueTransaction: Call must come from admin.");
807         require(eta >= getBlockTimestamp().add(delay), "Timelock::queueTransaction: Estimated execution block must satisfy delay.");
808 
809         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
810         queuedTransactions[txHash] = true;
811 
812         emit QueueTransaction(txHash, target, value, signature, data, eta);
813         return txHash;
814     }
815 
816     function cancelTransaction(address target, uint value, string memory signature, bytes memory data, uint eta) public {
817         require(msg.sender == admin, "Timelock::cancelTransaction: Call must come from admin.");
818 
819         bytes32 txHash = keccak256(abi.encode(target, value, signature, data, eta));
820         queuedTransactions[txHash] = false;
821 
822         emit CancelTransaction(txHash, target, value, signature, data, eta);
823     }
824 
825     function executeTransaction(address target, uint _value, string memory signature, bytes memory data, uint eta) public payable returns (bytes memory) {
826         require(msg.sender == admin, "Timelock::executeTransaction: Call must come from admin.");
827 
828         bytes32 txHash = keccak256(abi.encode(target, _value, signature, data, eta));
829         require(queuedTransactions[txHash], "Timelock::executeTransaction: Transaction hasn't been queued.");
830         require(getBlockTimestamp() >= eta, "Timelock::executeTransaction: Transaction hasn't surpassed time lock.");
831         require(getBlockTimestamp() <= eta.add(GRACE_PERIOD), "Timelock::executeTransaction: Transaction is stale.");
832 
833         queuedTransactions[txHash] = false;
834 
835         bytes memory callData;
836 
837         if (bytes(signature).length == 0) {
838             callData = data;
839         } else {
840             callData = abi.encodePacked(bytes4(keccak256(bytes(signature))), data);
841         }
842 
843         // solium-disable-next-line security/no-call-value
844         (bool success, bytes memory returnData) = target.call{value:_value}(callData);
845         require(success, "Timelock::executeTransaction: Transaction execution reverted.");
846 
847         emit ExecuteTransaction(txHash, target, _value, signature, data, eta);
848 
849         return returnData;
850     }
851 
852     function getBlockTimestamp() internal view returns (uint) {
853         // solium-disable-next-line security/no-block-members
854         return block.timestamp;
855     }
856 }
857 
858 // File: contracts\VampireAdapter.sol
859 
860 
861 pragma solidity 0.6.12;
862 
863 
864 contract Victim{}
865 
866 library VampireAdapter {
867     // Victim info
868     function rewardToken(Victim victim) external view returns (IERC20) {
869         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("rewardToken()"));
870         require(success, "rewardToken() staticcall failed.");
871         return abi.decode(result, (IERC20));
872     }
873 
874     function poolCount(Victim victim) external view returns (uint256) {
875         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("poolCount()"));
876         require(success, "poolCount() staticcall failed.");
877         return abi.decode(result, (uint256));
878     }
879 
880     function sellableRewardAmount(Victim victim) external view returns (uint256) {
881         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("sellableRewardAmount()"));
882         require(success, "sellableRewardAmount() staticcall failed.");
883         return abi.decode(result, (uint256));
884     }
885 
886     // Victim actions
887     function sellRewardForWeth(Victim victim, uint256 rewardAmount, address to) external returns(uint256) {
888         (bool success, bytes memory result) = address(victim).delegatecall(abi.encodeWithSignature("sellRewardForWeth(address,uint256,address)", address(victim), rewardAmount, to));
889         require(success, "sellRewardForWeth(uint256 rewardAmount, address to) delegatecall failed.");
890         return abi.decode(result, (uint256));
891     }
892 
893     // Pool info
894     function lockableToken(Victim victim, uint256 poolId) external view returns (IERC20) {
895         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("lockableToken(uint256)", poolId));
896         require(success, "lockableToken(uint256 poolId) staticcall failed.");
897         return abi.decode(result, (IERC20));
898     }
899 
900     function lockedAmount(Victim victim, uint256 poolId) external view returns (uint256) {
901         // note the impersonation
902         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("lockedAmount(address,uint256)", address(this), poolId));
903         require(success, "lockedAmount(uint256 poolId) staticcall failed.");
904         return abi.decode(result, (uint256));
905     }
906 
907     // Pool actions
908     function deposit(Victim victim, uint256 poolId, uint256 amount) external {
909         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("deposit(address,uint256,uint256)", address(victim), poolId, amount));
910         require(success, "deposit(uint256 poolId, uint256 amount) delegatecall failed.");
911     }
912 
913     function withdraw(Victim victim, uint256 poolId, uint256 amount) external {
914         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("withdraw(address,uint256,uint256)", address(victim), poolId, amount));
915         require(success, "withdraw(uint256 poolId, uint256 amount) delegatecall failed.");
916     }
917     
918     function claimReward(Victim victim, uint256 poolId) external {
919         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("claimReward(address,uint256)", address(victim), poolId));
920         require(success, "claimReward(uint256 poolId) delegatecall failed.");
921     }
922     
923     function emergencyWithdraw(Victim victim, uint256 poolId) external {
924         (bool success,) = address(victim).delegatecall(abi.encodeWithSignature("emergencyWithdraw(address,uint256)", address(victim), poolId));
925         require(success, "emergencyWithdraw(uint256 poolId) delegatecall failed.");
926     }
927     
928     // Service methods
929     function poolAddress(Victim victim, uint256 poolId) external view returns (address) {
930         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("poolAddress(uint256)", poolId));
931         require(success, "poolAddress(uint256 poolId) staticcall failed.");
932         return abi.decode(result, (address));
933     }
934 
935     function rewardToWethPool(Victim victim) external view returns (address) {
936         (bool success, bytes memory result) = address(victim).staticcall(abi.encodeWithSignature("rewardToWethPool()"));
937         require(success, "rewardToWethPool() staticcall failed.");
938         return abi.decode(result, (address));
939     }
940 }
941 
942 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
943 
944 
945 pragma solidity ^0.6.0;
946 
947 
948 
949 
950 
951 /**
952  * @dev Implementation of the {IERC20} interface.
953  *
954  * This implementation is agnostic to the way tokens are created. This means
955  * that a supply mechanism has to be added in a derived contract using {_mint}.
956  * For a generic mechanism see {ERC20PresetMinterPauser}.
957  *
958  * TIP: For a detailed writeup see our guide
959  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
960  * to implement supply mechanisms].
961  *
962  * We have followed general OpenZeppelin guidelines: functions revert instead
963  * of returning `false` on failure. This behavior is nonetheless conventional
964  * and does not conflict with the expectations of ERC20 applications.
965  *
966  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
967  * This allows applications to reconstruct the allowance for all accounts just
968  * by listening to said events. Other implementations of the EIP may not emit
969  * these events, as it isn't required by the specification.
970  *
971  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
972  * functions have been added to mitigate the well-known issues around setting
973  * allowances. See {IERC20-approve}.
974  */
975 contract ERC20 is Context, IERC20 {
976     using SafeMath for uint256;
977     using Address for address;
978 
979     mapping (address => uint256) private _balances;
980 
981     mapping (address => mapping (address => uint256)) private _allowances;
982 
983     uint256 private _totalSupply;
984 
985     string private _name;
986     string private _symbol;
987     uint8 private _decimals;
988 
989     /**
990      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
991      * a default value of 18.
992      *
993      * To select a different value for {decimals}, use {_setupDecimals}.
994      *
995      * All three of these values are immutable: they can only be set once during
996      * construction.
997      */
998     constructor (string memory name, string memory symbol) public {
999         _name = name;
1000         _symbol = symbol;
1001         _decimals = 18;
1002     }
1003 
1004     /**
1005      * @dev Returns the name of the token.
1006      */
1007     function name() public view returns (string memory) {
1008         return _name;
1009     }
1010 
1011     /**
1012      * @dev Returns the symbol of the token, usually a shorter version of the
1013      * name.
1014      */
1015     function symbol() public view returns (string memory) {
1016         return _symbol;
1017     }
1018 
1019     /**
1020      * @dev Returns the number of decimals used to get its user representation.
1021      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1022      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
1023      *
1024      * Tokens usually opt for a value of 18, imitating the relationship between
1025      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
1026      * called.
1027      *
1028      * NOTE: This information is only used for _display_ purposes: it in
1029      * no way affects any of the arithmetic of the contract, including
1030      * {IERC20-balanceOf} and {IERC20-transfer}.
1031      */
1032     function decimals() public view returns (uint8) {
1033         return _decimals;
1034     }
1035 
1036     /**
1037      * @dev See {IERC20-totalSupply}.
1038      */
1039     function totalSupply() public view override returns (uint256) {
1040         return _totalSupply;
1041     }
1042 
1043     /**
1044      * @dev See {IERC20-balanceOf}.
1045      */
1046     function balanceOf(address account) public view override returns (uint256) {
1047         return _balances[account];
1048     }
1049 
1050     /**
1051      * @dev See {IERC20-transfer}.
1052      *
1053      * Requirements:
1054      *
1055      * - `recipient` cannot be the zero address.
1056      * - the caller must have a balance of at least `amount`.
1057      */
1058     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1059         _transfer(_msgSender(), recipient, amount);
1060         return true;
1061     }
1062 
1063     /**
1064      * @dev See {IERC20-allowance}.
1065      */
1066     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1067         return _allowances[owner][spender];
1068     }
1069 
1070     /**
1071      * @dev See {IERC20-approve}.
1072      *
1073      * Requirements:
1074      *
1075      * - `spender` cannot be the zero address.
1076      */
1077     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1078         _approve(_msgSender(), spender, amount);
1079         return true;
1080     }
1081 
1082     /**
1083      * @dev See {IERC20-transferFrom}.
1084      *
1085      * Emits an {Approval} event indicating the updated allowance. This is not
1086      * required by the EIP. See the note at the beginning of {ERC20};
1087      *
1088      * Requirements:
1089      * - `sender` and `recipient` cannot be the zero address.
1090      * - `sender` must have a balance of at least `amount`.
1091      * - the caller must have allowance for ``sender``'s tokens of at least
1092      * `amount`.
1093      */
1094     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1095         _transfer(sender, recipient, amount);
1096         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1097         return true;
1098     }
1099 
1100     /**
1101      * @dev Atomically increases the allowance granted to `spender` by the caller.
1102      *
1103      * This is an alternative to {approve} that can be used as a mitigation for
1104      * problems described in {IERC20-approve}.
1105      *
1106      * Emits an {Approval} event indicating the updated allowance.
1107      *
1108      * Requirements:
1109      *
1110      * - `spender` cannot be the zero address.
1111      */
1112     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1113         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1114         return true;
1115     }
1116 
1117     /**
1118      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1119      *
1120      * This is an alternative to {approve} that can be used as a mitigation for
1121      * problems described in {IERC20-approve}.
1122      *
1123      * Emits an {Approval} event indicating the updated allowance.
1124      *
1125      * Requirements:
1126      *
1127      * - `spender` cannot be the zero address.
1128      * - `spender` must have allowance for the caller of at least
1129      * `subtractedValue`.
1130      */
1131     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1132         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1133         return true;
1134     }
1135 
1136     /**
1137      * @dev Moves tokens `amount` from `sender` to `recipient`.
1138      *
1139      * This is internal function is equivalent to {transfer}, and can be used to
1140      * e.g. implement automatic token fees, slashing mechanisms, etc.
1141      *
1142      * Emits a {Transfer} event.
1143      *
1144      * Requirements:
1145      *
1146      * - `sender` cannot be the zero address.
1147      * - `recipient` cannot be the zero address.
1148      * - `sender` must have a balance of at least `amount`.
1149      */
1150     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
1151         require(sender != address(0), "ERC20: transfer from the zero address");
1152         require(recipient != address(0), "ERC20: transfer to the zero address");
1153 
1154         _beforeTokenTransfer(sender, recipient, amount);
1155 
1156         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
1157         _balances[recipient] = _balances[recipient].add(amount);
1158         emit Transfer(sender, recipient, amount);
1159     }
1160 
1161     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1162      * the total supply.
1163      *
1164      * Emits a {Transfer} event with `from` set to the zero address.
1165      *
1166      * Requirements
1167      *
1168      * - `to` cannot be the zero address.
1169      */
1170     function _mint(address account, uint256 amount) internal virtual {
1171         require(account != address(0), "ERC20: mint to the zero address");
1172 
1173         _beforeTokenTransfer(address(0), account, amount);
1174 
1175         _totalSupply = _totalSupply.add(amount);
1176         _balances[account] = _balances[account].add(amount);
1177         emit Transfer(address(0), account, amount);
1178     }
1179 
1180     /**
1181      * @dev Destroys `amount` tokens from `account`, reducing the
1182      * total supply.
1183      *
1184      * Emits a {Transfer} event with `to` set to the zero address.
1185      *
1186      * Requirements
1187      *
1188      * - `account` cannot be the zero address.
1189      * - `account` must have at least `amount` tokens.
1190      */
1191     function _burn(address account, uint256 amount) internal virtual {
1192         require(account != address(0), "ERC20: burn from the zero address");
1193 
1194         _beforeTokenTransfer(account, address(0), amount);
1195 
1196         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1197         _totalSupply = _totalSupply.sub(amount);
1198         emit Transfer(account, address(0), amount);
1199     }
1200 
1201     /**
1202      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1203      *
1204      * This internal function is equivalent to `approve`, and can be used to
1205      * e.g. set automatic allowances for certain subsystems, etc.
1206      *
1207      * Emits an {Approval} event.
1208      *
1209      * Requirements:
1210      *
1211      * - `owner` cannot be the zero address.
1212      * - `spender` cannot be the zero address.
1213      */
1214     function _approve(address owner, address spender, uint256 amount) internal virtual {
1215         require(owner != address(0), "ERC20: approve from the zero address");
1216         require(spender != address(0), "ERC20: approve to the zero address");
1217 
1218         _allowances[owner][spender] = amount;
1219         emit Approval(owner, spender, amount);
1220     }
1221 
1222     /**
1223      * @dev Sets {decimals} to a value other than the default one of 18.
1224      *
1225      * WARNING: This function should only be called from the constructor. Most
1226      * applications that interact with token contracts will not expect
1227      * {decimals} to ever change, and may work incorrectly if it does.
1228      */
1229     function _setupDecimals(uint8 decimals_) internal {
1230         _decimals = decimals_;
1231     }
1232 
1233     /**
1234      * @dev Hook that is called before any transfer of tokens. This includes
1235      * minting and burning.
1236      *
1237      * Calling conditions:
1238      *
1239      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1240      * will be to transferred to `to`.
1241      * - when `from` is zero, `amount` tokens will be minted for `to`.
1242      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1243      * - `from` and `to` are never both zero.
1244      *
1245      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1246      */
1247     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1248 }
1249 
1250 // File: contracts\DraculaToken.sol
1251 
1252 
1253 pragma solidity 0.6.12;
1254 
1255 
1256 
1257 
1258 contract DraculaToken is ERC20("Dracula Token", "DRC"), Ownable {
1259     using SafeMath for uint256;
1260 
1261     event Minted(address indexed minter, address indexed receiver, uint mintAmount);
1262     event Burned(address indexed burner, uint burnAmount);
1263 
1264     function mint(address _to, uint256 _amount) public onlyOwner {
1265         _mint(_to, _amount);
1266         emit Minted(owner(), _to, _amount);
1267     }
1268 
1269     function burn(uint256 _amount) public {
1270         _burn(msg.sender, _amount);
1271         emit Burned(msg.sender, _amount);
1272     }
1273 
1274     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override virtual { 
1275         _moveDelegates(_delegates[from], _delegates[to], amount);
1276     }
1277 
1278     /// @dev A record of each accounts delegate
1279     mapping (address => address) internal _delegates;
1280 
1281     /// @notice A checkpoint for marking number of votes from a given block
1282     struct Checkpoint {
1283         uint32 fromBlock;
1284         uint256 votes;
1285     }
1286 
1287     /// @notice A record of votes checkpoints for each account, by index
1288     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1289 
1290     /// @notice The number of checkpoints for each account
1291     mapping (address => uint32) public numCheckpoints;
1292 
1293     /// @notice The EIP-712 typehash for the contract's domain
1294     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
1295 
1296     /// @notice The EIP-712 typehash for the delegation struct used by the contract
1297     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
1298 
1299     /// @notice A record of states for signing / validating signatures
1300     mapping (address => uint) public nonces;
1301 
1302       /// @notice An event thats emitted when an account changes its delegate
1303     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1304 
1305     /// @notice An event thats emitted when a delegate account's vote balance changes
1306     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1307 
1308     /**
1309      * @notice Delegate votes from `msg.sender` to `delegatee`
1310      * @param delegator The address to get delegatee for
1311      */
1312     function delegates(address delegator)
1313         external
1314         view
1315         returns (address)
1316     {
1317         return _delegates[delegator];
1318     }
1319 
1320    /**
1321     * @notice Delegate votes from `msg.sender` to `delegatee`
1322     * @param delegatee The address to delegate votes to
1323     */
1324     function delegate(address delegatee) external {
1325         return _delegate(msg.sender, delegatee);
1326     }
1327 
1328     /**
1329      * @notice Delegates votes from signatory to `delegatee`
1330      * @param delegatee The address to delegate votes to
1331      * @param nonce The contract state required to match the signature
1332      * @param expiry The time at which to expire the signature
1333      * @param v The recovery byte of the signature
1334      * @param r Half of the ECDSA signature pair
1335      * @param s Half of the ECDSA signature pair
1336      */
1337     function delegateBySig(
1338         address delegatee,
1339         uint nonce,
1340         uint expiry,
1341         uint8 v,
1342         bytes32 r,
1343         bytes32 s
1344     )
1345         external
1346     {
1347         bytes32 domainSeparator = keccak256(
1348             abi.encode(
1349                 DOMAIN_TYPEHASH,
1350                 keccak256(bytes(name())),
1351                 getChainId(),
1352                 address(this)
1353             )
1354         );
1355 
1356         bytes32 structHash = keccak256(
1357             abi.encode(
1358                 DELEGATION_TYPEHASH,
1359                 delegatee,
1360                 nonce,
1361                 expiry
1362             )
1363         );
1364 
1365         bytes32 digest = keccak256(
1366             abi.encodePacked(
1367                 "\x19\x01",
1368                 domainSeparator,
1369                 structHash
1370             )
1371         );
1372 
1373         address signatory = ecrecover(digest, v, r, s);
1374         require(signatory != address(0), "DRC::delegateBySig: invalid signature");
1375         require(nonce == nonces[signatory]++, "DRC::delegateBySig: invalid nonce");
1376         require(now <= expiry, "DRC::delegateBySig: signature expired");
1377         return _delegate(signatory, delegatee);
1378     }
1379 
1380     /**
1381      * @notice Gets the current votes balance for `account`
1382      * @param account The address to get votes balance
1383      * @return The number of current votes for `account`
1384      */
1385     function getCurrentVotes(address account)
1386         external
1387         view
1388         returns (uint256)
1389     {
1390         uint32 nCheckpoints = numCheckpoints[account];
1391         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1392     }
1393 
1394     /**
1395      * @notice Determine the prior number of votes for an account as of a block number
1396      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1397      * @param account The address of the account to check
1398      * @param blockNumber The block number to get the vote balance at
1399      * @return The number of votes the account had as of the given block
1400      */
1401     function getPriorVotes(address account, uint blockNumber)
1402         external
1403         view
1404         returns (uint256)
1405     {
1406         require(blockNumber < block.number, "DRC::getPriorVotes: not yet determined");
1407 
1408         uint32 nCheckpoints = numCheckpoints[account];
1409         if (nCheckpoints == 0) {
1410             return 0;
1411         }
1412 
1413         // First check most recent balance
1414         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1415             return checkpoints[account][nCheckpoints - 1].votes;
1416         }
1417 
1418         // Next check implicit zero balance
1419         if (checkpoints[account][0].fromBlock > blockNumber) {
1420             return 0;
1421         }
1422 
1423         uint32 lower = 0;
1424         uint32 upper = nCheckpoints - 1;
1425         while (upper > lower) {
1426             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1427             Checkpoint memory cp = checkpoints[account][center];
1428             if (cp.fromBlock == blockNumber) {
1429                 return cp.votes;
1430             } else if (cp.fromBlock < blockNumber) {
1431                 lower = center;
1432             } else {
1433                 upper = center - 1;
1434             }
1435         }
1436         return checkpoints[account][lower].votes;
1437     }
1438 
1439     function _delegate(address delegator, address delegatee)
1440         internal
1441     {
1442         address currentDelegate = _delegates[delegator];
1443         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying DRCs (not scaled);
1444         _delegates[delegator] = delegatee;
1445 
1446         emit DelegateChanged(delegator, currentDelegate, delegatee);
1447 
1448         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1449     }
1450 
1451     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1452         if (srcRep != dstRep && amount > 0) {
1453             if (srcRep != address(0)) {
1454                 // decrease old representative
1455                 uint32 srcRepNum = numCheckpoints[srcRep];
1456                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1457                 uint256 srcRepNew = srcRepOld.sub(amount);
1458                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1459             }
1460 
1461             if (dstRep != address(0)) {
1462                 // increase new representative
1463                 uint32 dstRepNum = numCheckpoints[dstRep];
1464                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1465                 uint256 dstRepNew = dstRepOld.add(amount);
1466                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1467             }
1468         }
1469     }
1470 
1471     function _writeCheckpoint(
1472         address delegatee,
1473         uint32 nCheckpoints,
1474         uint256 oldVotes,
1475         uint256 newVotes
1476     )
1477         internal
1478     {
1479         uint32 blockNumber = safe32(block.number, "DRC::_writeCheckpoint: block number exceeds 32 bits");
1480 
1481         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1482             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1483         } else {
1484             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1485             numCheckpoints[delegatee] = nCheckpoints + 1;
1486         }
1487 
1488         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1489     }
1490 
1491     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1492         require(n < 2**32, errorMessage);
1493         return uint32(n);
1494     }
1495 
1496     function getChainId() internal pure returns (uint) {
1497         uint256 chainId;
1498         assembly { chainId := chainid() }
1499         return chainId;
1500     }
1501 }
1502 
1503 // File: contracts\MasterVampire.sol
1504 
1505 
1506 pragma solidity 0.6.12;
1507 
1508 
1509 
1510 
1511 
1512 
1513 
1514 
1515 
1516 
1517 
1518 contract MasterVampire is Ownable, Timelock {
1519     using SafeMath for uint256;
1520     using SafeERC20 for IERC20;
1521     using VampireAdapter for Victim;
1522 
1523     struct UserInfo {
1524         uint256 amount;
1525         uint256 rewardDebt;
1526     }
1527 
1528     struct PoolInfo {
1529         Victim victim;
1530         uint256 victimPoolId;
1531         uint256 rewardPerBlock;
1532         uint256 lastRewardBlock;
1533         uint256 accDrcPerShare;
1534         uint256 rewardDrainModifier;
1535         uint256 wethDrainModifier;
1536     }
1537 
1538 //     (_                   _)
1539 //      /\                 /\
1540 //     / \'._   (\_/)   _.'/ \
1541 //    /_.''._'--('.')--'_.''._\
1542 //    | \_ / `;=/ " \=;` \ _/ |
1543 //     \/ `\__|`\___/`|__/`  \/
1544 //   jgs`      \(/|\)/       `
1545 //              " ` "
1546     DraculaToken public dracula;
1547     IERC20 weth;
1548     IUniswapV2Pair drcWethPair;
1549 
1550     address public drainAddress;
1551     address public poolRewardUpdater;
1552     address public devAddress;
1553     uint256 public constant DEV_FEE = 8;
1554     uint256 public constant REWARD_START_BLOCK = 11008888; // Wed Oct 07 2020 13:28:00 UTC
1555 
1556     uint256 poolRewardLimiter;
1557 
1558     PoolInfo[] public poolInfo;
1559 
1560     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1561 
1562     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1563     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1564     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1565 
1566     modifier onlyDev() {
1567         require(devAddress == _msgSender(), "not dev");
1568         _;
1569     }
1570 
1571     modifier onlyRewardUpdater() {
1572         require(poolRewardUpdater == _msgSender(), "not reward updater");
1573         _;
1574     }
1575 
1576     constructor(
1577         DraculaToken _dracula,
1578         address _drainAddress
1579     ) public Timelock(msg.sender, 24 hours) {
1580         poolRewardLimiter = 300 ether;
1581         dracula = _dracula;
1582         drainAddress = _drainAddress;
1583         devAddress = msg.sender;
1584         weth = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
1585         IUniswapV2Factory uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
1586         drcWethPair = IUniswapV2Pair(uniswapFactory.getPair(address(weth), address(dracula)));
1587     }
1588 
1589     function poolLength() external view returns (uint256) {
1590         return poolInfo.length;
1591     }
1592 
1593     function add(Victim _victim, uint256 _victimPoolId, uint256 _rewardPerBlock, uint256 _rewardDrainModifier, uint256 _wethDrainModifier) public onlyOwner {
1594         require(_rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1595         poolInfo.push(PoolInfo({
1596             victim: _victim,
1597             victimPoolId: _victimPoolId,
1598             rewardPerBlock: _rewardPerBlock,
1599             rewardDrainModifier: _rewardDrainModifier,
1600             wethDrainModifier: _wethDrainModifier,
1601             lastRewardBlock: block.number < REWARD_START_BLOCK ? REWARD_START_BLOCK : block.number,
1602             accDrcPerShare: 0
1603         }));
1604     }
1605 
1606     function updatePoolRewardLimiter(uint256 _poolRewardLimiter) public onlyOwner {
1607         poolRewardLimiter = _poolRewardLimiter;
1608     }
1609 
1610     function updateRewardPerBlock(uint256 _pid, uint256 _rewardPerBlock) public onlyRewardUpdater {
1611         require(_rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1612         updatePool(_pid);
1613         poolInfo[_pid].rewardPerBlock = _rewardPerBlock;
1614     }
1615 
1616     function updateRewardPerBlockMassive(uint256[] memory pids, uint256[] memory rewards) public onlyRewardUpdater {
1617         require(pids.length == rewards.length, "-__-");
1618         for (uint i = 0; i < pids.length; i++) {
1619             uint256 pid = pids[i];
1620             uint256 rewardPerBlock = rewards[i];
1621             require(rewardPerBlock <= poolRewardLimiter, "Pool reward per block is too high");
1622             updatePool(pid);
1623             poolInfo[pid].rewardPerBlock = rewardPerBlock;
1624         }
1625     }
1626 
1627     function updateVictimInfo(uint256 _pid, address _victim, uint256 _victimPoolId) public onlyOwner {
1628         poolInfo[_pid].victim = Victim(_victim);
1629         poolInfo[_pid].victimPoolId = _victimPoolId;
1630     }
1631 
1632     function updatePoolDrain(uint256 _pid, uint256 _rewardDrainModifier, uint256 _wethDrainModifier) public onlyOwner {
1633         PoolInfo storage pool = poolInfo[_pid];
1634         pool.rewardDrainModifier = _rewardDrainModifier;
1635         pool.wethDrainModifier = _wethDrainModifier;
1636     }
1637 
1638     function updateDevAddress(address _devAddress) public onlyDev {
1639         devAddress = _devAddress;
1640     }
1641 
1642     function updateDrainAddress(address _drainAddress) public onlyOwner {
1643         drainAddress = _drainAddress;
1644     }
1645 
1646     function updateRewardUpdaterAddress(address _poolRewardUpdater) public onlyOwner {
1647         poolRewardUpdater = _poolRewardUpdater;
1648     }
1649 
1650     function pendingDrc(uint256 _pid, address _user) external view returns (uint256) {
1651         PoolInfo storage pool = poolInfo[_pid];
1652         UserInfo storage user = userInfo[_pid][_user];
1653         uint256 accDrcPerShare = pool.accDrcPerShare;
1654         uint256 lpSupply = _pid == 0 ? drcWethPair.balanceOf(address(this)) : pool.victim.lockedAmount(pool.victimPoolId);
1655         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1656             uint256 blocksToReward = block.number.sub(pool.lastRewardBlock);
1657             uint256 drcReward = blocksToReward.mul(pool.rewardPerBlock);
1658             accDrcPerShare = accDrcPerShare.add(drcReward.mul(1e12).div(lpSupply));
1659         }
1660 
1661         return user.amount.mul(accDrcPerShare).div(1e12).sub(user.rewardDebt);
1662     }
1663 
1664     function massUpdatePools() public {
1665         uint256 length = poolInfo.length;
1666         for (uint256 pid = 0; pid < length; ++pid) {
1667             updatePool(pid);
1668         }
1669     }
1670 
1671     function updatePool(uint256 _pid) public {
1672         PoolInfo storage pool = poolInfo[_pid];
1673         if (block.number <= pool.lastRewardBlock) {
1674             return;
1675         }
1676 
1677         uint256 lpSupply = _pid == 0 ? drcWethPair.balanceOf(address(this)) : pool.victim.lockedAmount(pool.victimPoolId);
1678         if (lpSupply == 0) {
1679             pool.lastRewardBlock = block.number;
1680             return;
1681         }
1682 
1683         uint256 blocksToReward = block.number.sub(pool.lastRewardBlock);
1684         uint256 drcReward = blocksToReward.mul(pool.rewardPerBlock);
1685         dracula.mint(devAddress, drcReward.mul(DEV_FEE).div(100));
1686         dracula.mint(address(this), drcReward);
1687         pool.accDrcPerShare = pool.accDrcPerShare.add(drcReward.mul(1e12).div(lpSupply));
1688         pool.lastRewardBlock = block.number;
1689     }
1690 
1691     function deposit(uint256 _pid, uint256 _amount) public {
1692         PoolInfo storage pool = poolInfo[_pid];
1693         UserInfo storage user = userInfo[_pid][msg.sender];
1694         updatePool(_pid);
1695         if (user.amount > 0) {
1696             uint256 pending = user.amount.mul(pool.accDrcPerShare).div(1e12).sub(user.rewardDebt);
1697             if(pending > 0) {
1698                 safeDraculaTransfer(msg.sender, pending);
1699             }
1700         }
1701 
1702         if(_amount > 0) {
1703             if(_pid == 0) {
1704                 IERC20(address(drcWethPair)).safeTransferFrom(address(msg.sender), address(this), _amount);
1705             } else {
1706                 pool.victim.lockableToken(pool.victimPoolId).safeTransferFrom(address(msg.sender), address(this), _amount);
1707                 pool.victim.deposit(pool.victimPoolId, _amount);
1708             }
1709 
1710             user.amount = user.amount.add(_amount);
1711         }
1712 
1713         user.rewardDebt = user.amount.mul(pool.accDrcPerShare).div(1e12);
1714         emit Deposit(msg.sender, _pid, _amount);
1715     }
1716     
1717     function withdraw(uint256 _pid, uint256 _amount) public {
1718         PoolInfo storage pool = poolInfo[_pid];
1719         UserInfo storage user = userInfo[_pid][msg.sender];
1720         require(user.amount >= _amount, "withdraw: not good");
1721         updatePool(_pid);
1722         uint256 pending = user.amount.mul(pool.accDrcPerShare).div(1e12).sub(user.rewardDebt);
1723         if(pending > 0) {
1724             safeDraculaTransfer(msg.sender, pending);
1725         }
1726 
1727         if(_amount > 0) {
1728             user.amount = user.amount.sub(_amount);
1729             if(_pid == 0) {
1730                 IERC20(address(drcWethPair)).safeTransfer(address(msg.sender), _amount);
1731             } else {
1732                 pool.victim.withdraw(pool.victimPoolId, _amount);
1733                 pool.victim.lockableToken(pool.victimPoolId).safeTransfer(address(msg.sender), _amount);
1734             }
1735         }
1736 
1737         user.rewardDebt = user.amount.mul(pool.accDrcPerShare).div(1e12);
1738         emit Withdraw(msg.sender, _pid, _amount);
1739     }
1740 
1741     function emergencyWithdraw(uint256 _pid) public {
1742         PoolInfo storage pool = poolInfo[_pid];
1743         UserInfo storage user = userInfo[_pid][msg.sender];
1744         if(_pid == 0) {
1745             IERC20(address(drcWethPair)).safeTransfer(address(msg.sender), user.amount);
1746         } else {
1747             pool.victim.withdraw(pool.victimPoolId, user.amount);
1748             pool.victim.lockableToken(pool.victimPoolId).safeTransfer(address(msg.sender), user.amount);
1749         }
1750         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1751         user.amount = 0;
1752         user.rewardDebt = 0;
1753     }
1754 
1755     function safeDraculaTransfer(address _to, uint256 _amount) internal {
1756         uint256 balance = dracula.balanceOf(address(this));
1757         if (_amount > balance) {
1758             dracula.transfer(_to, balance);
1759         } else {
1760             dracula.transfer(_to, _amount);
1761         }
1762     }
1763     
1764     function drain(uint256 _pid) public {
1765         require(_pid != 0, "Can't drain from myself");
1766         PoolInfo storage pool = poolInfo[_pid];
1767         Victim victim = pool.victim;
1768         uint256 victimPoolId = pool.victimPoolId;
1769         uint256 rewardDrainModifier = pool.rewardDrainModifier;
1770         victim.claimReward(victimPoolId);
1771         IERC20 rewardToken = victim.rewardToken();
1772         uint256 claimedReward = rewardToken.balanceOf(address(this));
1773         uint256 rewardDrainAmount = claimedReward.mul(rewardDrainModifier).div(1000);
1774         if(rewardDrainAmount > 0) {
1775             rewardToken.transfer(drainAddress, rewardDrainAmount);
1776             claimedReward = claimedReward.sub(rewardDrainAmount);
1777         }
1778 
1779         uint256 sellableAmount = victim.sellableRewardAmount();
1780         if(sellableAmount < claimedReward) { // victim is drained empty
1781             claimedReward = sellableAmount;
1782         }
1783 
1784         if(claimedReward == 0) {
1785             return;
1786         }
1787 
1788         uint256 wethDrainModifier = pool.wethDrainModifier;
1789         uint256 wethReward = victim.sellRewardForWeth(claimedReward, address(this));
1790         uint256 wethDrainAmount = wethReward.mul(wethDrainModifier).div(1000);
1791         if(wethDrainAmount > 0) {
1792             weth.transfer(drainAddress, wethDrainAmount);
1793             wethReward = wethReward.sub(wethDrainAmount);
1794         }
1795 
1796         address token0 = drcWethPair.token0();
1797         (uint reserve0, uint reserve1,) = drcWethPair.getReserves();
1798         (uint reserveInput, uint reserveOutput) = address(weth) == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
1799         uint amountOutput = UniswapV2Library.getAmountOut(wethReward, reserveInput, reserveOutput);
1800         (uint amount0Out, uint amount1Out) = address(weth) == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
1801 
1802         weth.transfer(address(drcWethPair), wethReward);
1803         drcWethPair.swap(amount0Out, amount1Out, address(this), new bytes(0));
1804 
1805         dracula.burn(amountOutput);
1806     }
1807 }