1 // File: @openzeppelin\contracts\math\SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin\contracts\utils\Address.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity ^0.6.2;
168 
169 /**
170  * @dev Collection of functions related to the address type
171  */
172 library Address {
173     /**
174      * @dev Returns true if `account` is a contract.
175      *
176      * [IMPORTANT]
177      * ====
178      * It is unsafe to assume that an address for which this function returns
179      * false is an externally-owned account (EOA) and not a contract.
180      *
181      * Among others, `isContract` will return false for the following
182      * types of addresses:
183      *
184      *  - an externally-owned account
185      *  - a contract in construction
186      *  - an address where a contract will be created
187      *  - an address where a contract lived, but was destroyed
188      * ====
189      */
190     function isContract(address account) internal view returns (bool) {
191         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
192         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
193         // for accounts without code, i.e. `keccak256('')`
194         bytes32 codehash;
195         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
196         // solhint-disable-next-line no-inline-assembly
197         assembly { codehash := extcodehash(account) }
198         return (codehash != accountHash && codehash != 0x0);
199     }
200 
201     /**
202      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
203      * `recipient`, forwarding all available gas and reverting on errors.
204      *
205      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
206      * of certain opcodes, possibly making contracts go over the 2300 gas limit
207      * imposed by `transfer`, making them unable to receive funds via
208      * `transfer`. {sendValue} removes this limitation.
209      *
210      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
211      *
212      * IMPORTANT: because control is transferred to `recipient`, care must be
213      * taken to not create reentrancy vulnerabilities. Consider using
214      * {ReentrancyGuard} or the
215      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
216      */
217     function sendValue(address payable recipient, uint256 amount) internal {
218         require(address(this).balance >= amount, "Address: insufficient balance");
219 
220         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
221         (bool success, ) = recipient.call{ value: amount }("");
222         require(success, "Address: unable to send value, recipient may have reverted");
223     }
224 
225     /**
226      * @dev Performs a Solidity function call using a low level `call`. A
227      * plain`call` is an unsafe replacement for a function call: use this
228      * function instead.
229      *
230      * If `target` reverts with a revert reason, it is bubbled up by this
231      * function (like regular Solidity function calls).
232      *
233      * Returns the raw returned data. To convert to the expected return value,
234      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
235      *
236      * Requirements:
237      *
238      * - `target` must be a contract.
239      * - calling `target` with `data` must not revert.
240      *
241      * _Available since v3.1._
242      */
243     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
244       return functionCall(target, data, "Address: low-level call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
249      * `errorMessage` as a fallback revert reason when `target` reverts.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
254         return _functionCallWithValue(target, data, 0, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but also transferring `value` wei to `target`.
260      *
261      * Requirements:
262      *
263      * - the calling contract must have an ETH balance of at least `value`.
264      * - the called Solidity function must be `payable`.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
269         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
274      * with `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
279         require(address(this).balance >= value, "Address: insufficient balance for call");
280         return _functionCallWithValue(target, data, value, errorMessage);
281     }
282 
283     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
284         require(isContract(target), "Address: call to non-contract");
285 
286         // solhint-disable-next-line avoid-low-level-calls
287         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 // solhint-disable-next-line no-inline-assembly
296                 assembly {
297                     let returndata_size := mload(returndata)
298                     revert(add(32, returndata), returndata_size)
299                 }
300             } else {
301                 revert(errorMessage);
302             }
303         }
304     }
305 }
306 
307 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
308 
309 // SPDX-License-Identifier: MIT
310 
311 pragma solidity ^0.6.0;
312 
313 /*
314  * @dev Provides information about the current execution context, including the
315  * sender of the transaction and its data. While these are generally available
316  * via msg.sender and msg.data, they should not be accessed in such a direct
317  * manner, since when dealing with GSN meta-transactions the account sending and
318  * paying for execution may not be the actual sender (as far as an application
319  * is concerned).
320  *
321  * This contract is only required for intermediate, library-like contracts.
322  */
323 abstract contract Context {
324     function _msgSender() internal view virtual returns (address payable) {
325         return msg.sender;
326     }
327 
328     function _msgData() internal view virtual returns (bytes memory) {
329         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
330         return msg.data;
331     }
332 }
333 
334 // File: @openzeppelin\contracts\access\Ownable.sol
335 
336 // SPDX-License-Identifier: MIT
337 
338 pragma solidity ^0.6.0;
339 
340 /**
341  * @dev Contract module which provides a basic access control mechanism, where
342  * there is an account (an owner) that can be granted exclusive access to
343  * specific functions.
344  *
345  * By default, the owner account will be the one that deploys the contract. This
346  * can later be changed with {transferOwnership}.
347  *
348  * This module is used through inheritance. It will make available the modifier
349  * `onlyOwner`, which can be applied to your functions to restrict their use to
350  * the owner.
351  */
352 contract Ownable is Context {
353     address private _owner;
354 
355     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
356 
357     /**
358      * @dev Initializes the contract setting the deployer as the initial owner.
359      */
360     constructor () internal {
361         address msgSender = _msgSender();
362         _owner = msgSender;
363         emit OwnershipTransferred(address(0), msgSender);
364     }
365 
366     /**
367      * @dev Returns the address of the current owner.
368      */
369     function owner() public view returns (address) {
370         return _owner;
371     }
372 
373     /**
374      * @dev Throws if called by any account other than the owner.
375      */
376     modifier onlyOwner() {
377         require(_owner == _msgSender(), "Ownable: caller is not the owner");
378         _;
379     }
380 
381     /**
382      * @dev Leaves the contract without owner. It will not be possible to call
383      * `onlyOwner` functions anymore. Can only be called by the current owner.
384      *
385      * NOTE: Renouncing ownership will leave the contract without an owner,
386      * thereby removing any functionality that is only available to the owner.
387      */
388     function renounceOwnership() public virtual onlyOwner {
389         emit OwnershipTransferred(_owner, address(0));
390         _owner = address(0);
391     }
392 
393     /**
394      * @dev Transfers ownership of the contract to a new account (`newOwner`).
395      * Can only be called by the current owner.
396      */
397     function transferOwnership(address newOwner) public virtual onlyOwner {
398         require(newOwner != address(0), "Ownable: new owner is the zero address");
399         emit OwnershipTransferred(_owner, newOwner);
400         _owner = newOwner;
401     }
402 }
403 
404 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
405 
406 // SPDX-License-Identifier: MIT
407 
408 pragma solidity ^0.6.0;
409 
410 /**
411  * @dev Interface of the ERC20 standard as defined in the EIP.
412  */
413 interface IERC20 {
414     /**
415      * @dev Returns the amount of tokens in existence.
416      */
417     function totalSupply() external view returns (uint256);
418 
419     /**
420      * @dev Returns the amount of tokens owned by `account`.
421      */
422     function balanceOf(address account) external view returns (uint256);
423 
424     /**
425      * @dev Moves `amount` tokens from the caller's account to `recipient`.
426      *
427      * Returns a boolean value indicating whether the operation succeeded.
428      *
429      * Emits a {Transfer} event.
430      */
431     function transfer(address recipient, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Returns the remaining number of tokens that `spender` will be
435      * allowed to spend on behalf of `owner` through {transferFrom}. This is
436      * zero by default.
437      *
438      * This value changes when {approve} or {transferFrom} are called.
439      */
440     function allowance(address owner, address spender) external view returns (uint256);
441 
442     /**
443      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
444      *
445      * Returns a boolean value indicating whether the operation succeeded.
446      *
447      * IMPORTANT: Beware that changing an allowance with this method brings the risk
448      * that someone may use both the old and the new allowance by unfortunate
449      * transaction ordering. One possible solution to mitigate this race
450      * condition is to first reduce the spender's allowance to 0 and set the
451      * desired value afterwards:
452      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
453      *
454      * Emits an {Approval} event.
455      */
456     function approve(address spender, uint256 amount) external returns (bool);
457 
458     /**
459      * @dev Moves `amount` tokens from `sender` to `recipient` using the
460      * allowance mechanism. `amount` is then deducted from the caller's
461      * allowance.
462      *
463      * Returns a boolean value indicating whether the operation succeeded.
464      *
465      * Emits a {Transfer} event.
466      */
467     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
468 
469     /**
470      * @dev Emitted when `value` tokens are moved from one account (`from`) to
471      * another (`to`).
472      *
473      * Note that `value` may be zero.
474      */
475     event Transfer(address indexed from, address indexed to, uint256 value);
476 
477     /**
478      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
479      * a call to {approve}. `value` is the new allowance.
480      */
481     event Approval(address indexed owner, address indexed spender, uint256 value);
482 }
483 
484 // File: @uniswap\v2-periphery\contracts\interfaces\IUniswapV2Router01.sol
485 
486 pragma solidity >=0.6.2;
487 
488 interface IUniswapV2Router01 {
489     function factory() external pure returns (address);
490     function WETH() external pure returns (address);
491 
492     function addLiquidity(
493         address tokenA,
494         address tokenB,
495         uint amountADesired,
496         uint amountBDesired,
497         uint amountAMin,
498         uint amountBMin,
499         address to,
500         uint deadline
501     ) external returns (uint amountA, uint amountB, uint liquidity);
502     function addLiquidityETH(
503         address token,
504         uint amountTokenDesired,
505         uint amountTokenMin,
506         uint amountETHMin,
507         address to,
508         uint deadline
509     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
510     function removeLiquidity(
511         address tokenA,
512         address tokenB,
513         uint liquidity,
514         uint amountAMin,
515         uint amountBMin,
516         address to,
517         uint deadline
518     ) external returns (uint amountA, uint amountB);
519     function removeLiquidityETH(
520         address token,
521         uint liquidity,
522         uint amountTokenMin,
523         uint amountETHMin,
524         address to,
525         uint deadline
526     ) external returns (uint amountToken, uint amountETH);
527     function removeLiquidityWithPermit(
528         address tokenA,
529         address tokenB,
530         uint liquidity,
531         uint amountAMin,
532         uint amountBMin,
533         address to,
534         uint deadline,
535         bool approveMax, uint8 v, bytes32 r, bytes32 s
536     ) external returns (uint amountA, uint amountB);
537     function removeLiquidityETHWithPermit(
538         address token,
539         uint liquidity,
540         uint amountTokenMin,
541         uint amountETHMin,
542         address to,
543         uint deadline,
544         bool approveMax, uint8 v, bytes32 r, bytes32 s
545     ) external returns (uint amountToken, uint amountETH);
546     function swapExactTokensForTokens(
547         uint amountIn,
548         uint amountOutMin,
549         address[] calldata path,
550         address to,
551         uint deadline
552     ) external returns (uint[] memory amounts);
553     function swapTokensForExactTokens(
554         uint amountOut,
555         uint amountInMax,
556         address[] calldata path,
557         address to,
558         uint deadline
559     ) external returns (uint[] memory amounts);
560     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
561         external
562         payable
563         returns (uint[] memory amounts);
564     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
565         external
566         returns (uint[] memory amounts);
567     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
568         external
569         returns (uint[] memory amounts);
570     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
571         external
572         payable
573         returns (uint[] memory amounts);
574 
575     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
576     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
577     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
578     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
579     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
580 }
581 
582 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Factory.sol
583 
584 pragma solidity >=0.5.0;
585 
586 interface IUniswapV2Factory {
587     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
588 
589     function feeTo() external view returns (address);
590     function feeToSetter() external view returns (address);
591 
592     function getPair(address tokenA, address tokenB) external view returns (address pair);
593     function allPairs(uint) external view returns (address pair);
594     function allPairsLength() external view returns (uint);
595 
596     function createPair(address tokenA, address tokenB) external returns (address pair);
597 
598     function setFeeTo(address) external;
599     function setFeeToSetter(address) external;
600 }
601 
602 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Pair.sol
603 
604 pragma solidity >=0.5.0;
605 
606 interface IUniswapV2Pair {
607     event Approval(address indexed owner, address indexed spender, uint value);
608     event Transfer(address indexed from, address indexed to, uint value);
609 
610     function name() external pure returns (string memory);
611     function symbol() external pure returns (string memory);
612     function decimals() external pure returns (uint8);
613     function totalSupply() external view returns (uint);
614     function balanceOf(address owner) external view returns (uint);
615     function allowance(address owner, address spender) external view returns (uint);
616 
617     function approve(address spender, uint value) external returns (bool);
618     function transfer(address to, uint value) external returns (bool);
619     function transferFrom(address from, address to, uint value) external returns (bool);
620 
621     function DOMAIN_SEPARATOR() external view returns (bytes32);
622     function PERMIT_TYPEHASH() external pure returns (bytes32);
623     function nonces(address owner) external view returns (uint);
624 
625     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
626 
627     event Mint(address indexed sender, uint amount0, uint amount1);
628     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
629     event Swap(
630         address indexed sender,
631         uint amount0In,
632         uint amount1In,
633         uint amount0Out,
634         uint amount1Out,
635         address indexed to
636     );
637     event Sync(uint112 reserve0, uint112 reserve1);
638 
639     function MINIMUM_LIQUIDITY() external pure returns (uint);
640     function factory() external view returns (address);
641     function token0() external view returns (address);
642     function token1() external view returns (address);
643     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
644     function price0CumulativeLast() external view returns (uint);
645     function price1CumulativeLast() external view returns (uint);
646     function kLast() external view returns (uint);
647 
648     function mint(address to) external returns (uint liquidity);
649     function burn(address to) external returns (uint amount0, uint amount1);
650     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
651     function skim(address to) external;
652     function sync() external;
653 
654     function initialize(address, address) external;
655 }
656 
657 
658 
659 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
660 
661 // SPDX-License-Identifier: MIT
662 
663 pragma solidity ^0.6.0;
664 
665 
666 
667 
668 
669 /**
670  * @dev Implementation of the {IERC20} interface.
671  *
672  * This implementation is agnostic to the way tokens are created. This means
673  * that a supply mechanism has to be added in a derived contract using {_mint}.
674  * For a generic mechanism see {ERC20PresetMinterPauser}.
675  *
676  * TIP: For a detailed writeup see our guide
677  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
678  * to implement supply mechanisms].
679  *
680  * We have followed general OpenZeppelin guidelines: functions revert instead
681  * of returning `false` on failure. This behavior is nonetheless conventional
682  * and does not conflict with the expectations of ERC20 applications.
683  *
684  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
685  * This allows applications to reconstruct the allowance for all accounts just
686  * by listening to said events. Other implementations of the EIP may not emit
687  * these events, as it isn't required by the specification.
688  *
689  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
690  * functions have been added to mitigate the well-known issues around setting
691  * allowances. See {IERC20-approve}.
692  */
693 contract ERC20 is Context, IERC20 {
694     using SafeMath for uint256;
695     using Address for address;
696 
697     mapping (address => uint256) private _balances;
698 
699     mapping (address => mapping (address => uint256)) private _allowances;
700 
701     uint256 private _totalSupply;
702 
703     string private _name;
704     string private _symbol;
705     uint8 private _decimals;
706 
707     /**
708      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
709      * a default value of 18.
710      *
711      * To select a different value for {decimals}, use {_setupDecimals}.
712      *
713      * All three of these values are immutable: they can only be set once during
714      * construction.
715      */
716     constructor (string memory name, string memory symbol) public {
717         _name = name;
718         _symbol = symbol;
719         _decimals = 18;
720     }
721 
722     /**
723      * @dev Returns the name of the token.
724      */
725     function name() public view returns (string memory) {
726         return _name;
727     }
728 
729     /**
730      * @dev Returns the symbol of the token, usually a shorter version of the
731      * name.
732      */
733     function symbol() public view returns (string memory) {
734         return _symbol;
735     }
736 
737     /**
738      * @dev Returns the number of decimals used to get its user representation.
739      * For example, if `decimals` equals `2`, a balance of `505` tokens should
740      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
741      *
742      * Tokens usually opt for a value of 18, imitating the relationship between
743      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
744      * called.
745      *
746      * NOTE: This information is only used for _display_ purposes: it in
747      * no way affects any of the arithmetic of the contract, including
748      * {IERC20-balanceOf} and {IERC20-transfer}.
749      */
750     function decimals() public view returns (uint8) {
751         return _decimals;
752     }
753 
754     /**
755      * @dev See {IERC20-totalSupply}.
756      */
757     function totalSupply() public view override returns (uint256) {
758         return _totalSupply;
759     }
760 
761     /**
762      * @dev See {IERC20-balanceOf}.
763      */
764     function balanceOf(address account) public view override returns (uint256) {
765         return _balances[account];
766     }
767 
768     /**
769      * @dev See {IERC20-transfer}.
770      *
771      * Requirements:
772      *
773      * - `recipient` cannot be the zero address.
774      * - the caller must have a balance of at least `amount`.
775      */
776     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
777         _transfer(_msgSender(), recipient, amount);
778         return true;
779     }
780 
781     /**
782      * @dev See {IERC20-allowance}.
783      */
784     function allowance(address owner, address spender) public view virtual override returns (uint256) {
785         return _allowances[owner][spender];
786     }
787 
788     /**
789      * @dev See {IERC20-approve}.
790      *
791      * Requirements:
792      *
793      * - `spender` cannot be the zero address.
794      */
795     function approve(address spender, uint256 amount) public virtual override returns (bool) {
796         _approve(_msgSender(), spender, amount);
797         return true;
798     }
799 
800     /**
801      * @dev See {IERC20-transferFrom}.
802      *
803      * Emits an {Approval} event indicating the updated allowance. This is not
804      * required by the EIP. See the note at the beginning of {ERC20};
805      *
806      * Requirements:
807      * - `sender` and `recipient` cannot be the zero address.
808      * - `sender` must have a balance of at least `amount`.
809      * - the caller must have allowance for ``sender``'s tokens of at least
810      * `amount`.
811      */
812     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
813         _transfer(sender, recipient, amount);
814         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
815         return true;
816     }
817 
818     /**
819      * @dev Atomically increases the allowance granted to `spender` by the caller.
820      *
821      * This is an alternative to {approve} that can be used as a mitigation for
822      * problems described in {IERC20-approve}.
823      *
824      * Emits an {Approval} event indicating the updated allowance.
825      *
826      * Requirements:
827      *
828      * - `spender` cannot be the zero address.
829      */
830     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
831         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
832         return true;
833     }
834 
835     /**
836      * @dev Atomically decreases the allowance granted to `spender` by the caller.
837      *
838      * This is an alternative to {approve} that can be used as a mitigation for
839      * problems described in {IERC20-approve}.
840      *
841      * Emits an {Approval} event indicating the updated allowance.
842      *
843      * Requirements:
844      *
845      * - `spender` cannot be the zero address.
846      * - `spender` must have allowance for the caller of at least
847      * `subtractedValue`.
848      */
849     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
850         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
851         return true;
852     }
853 
854     /**
855      * @dev Moves tokens `amount` from `sender` to `recipient`.
856      *
857      * This is internal function is equivalent to {transfer}, and can be used to
858      * e.g. implement automatic token fees, slashing mechanisms, etc.
859      *
860      * Emits a {Transfer} event.
861      *
862      * Requirements:
863      *
864      * - `sender` cannot be the zero address.
865      * - `recipient` cannot be the zero address.
866      * - `sender` must have a balance of at least `amount`.
867      */
868     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
869         require(sender != address(0), "ERC20: transfer from the zero address");
870         require(recipient != address(0), "ERC20: transfer to the zero address");
871 
872         _beforeTokenTransfer(sender, recipient, amount);
873 
874         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
875         _balances[recipient] = _balances[recipient].add(amount);
876         emit Transfer(sender, recipient, amount);
877     }
878 
879     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
880      * the total supply.
881      *
882      * Emits a {Transfer} event with `from` set to the zero address.
883      *
884      * Requirements
885      *
886      * - `to` cannot be the zero address.
887      */
888     function _mint(address account, uint256 amount) internal virtual {
889         require(account != address(0), "ERC20: mint to the zero address");
890 
891         _beforeTokenTransfer(address(0), account, amount);
892 
893         _totalSupply = _totalSupply.add(amount);
894         _balances[account] = _balances[account].add(amount);
895         emit Transfer(address(0), account, amount);
896     }
897 
898     /**
899      * @dev Destroys `amount` tokens from `account`, reducing the
900      * total supply.
901      *
902      * Emits a {Transfer} event with `to` set to the zero address.
903      *
904      * Requirements
905      *
906      * - `account` cannot be the zero address.
907      * - `account` must have at least `amount` tokens.
908      */
909     function _burn(address account, uint256 amount) internal virtual {
910         require(account != address(0), "ERC20: burn from the zero address");
911 
912         _beforeTokenTransfer(account, address(0), amount);
913 
914         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
915         _totalSupply = _totalSupply.sub(amount);
916         emit Transfer(account, address(0), amount);
917     }
918 
919     /**
920      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
921      *
922      * This is internal function is equivalent to `approve`, and can be used to
923      * e.g. set automatic allowances for certain subsystems, etc.
924      *
925      * Emits an {Approval} event.
926      *
927      * Requirements:
928      *
929      * - `owner` cannot be the zero address.
930      * - `spender` cannot be the zero address.
931      */
932     function _approve(address owner, address spender, uint256 amount) internal virtual {
933         require(owner != address(0), "ERC20: approve from the zero address");
934         require(spender != address(0), "ERC20: approve to the zero address");
935 
936         _allowances[owner][spender] = amount;
937         emit Approval(owner, spender, amount);
938     }
939 
940     /**
941      * @dev Sets {decimals} to a value other than the default one of 18.
942      *
943      * WARNING: This function should only be called from the constructor. Most
944      * applications that interact with token contracts will not expect
945      * {decimals} to ever change, and may work incorrectly if it does.
946      */
947     function _setupDecimals(uint8 decimals_) internal {
948         _decimals = decimals_;
949     }
950 
951     /**
952      * @dev Hook that is called before any transfer of tokens. This includes
953      * minting and burning.
954      *
955      * Calling conditions:
956      *
957      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
958      * will be to transferred to `to`.
959      * - when `from` is zero, `amount` tokens will be minted for `to`.
960      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
961      * - `from` and `to` are never both zero.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
966 }
967 
968 // File: contracts\VTPToken.sol
969 
970 pragma solidity ^0.6.0;
971 
972 
973 
974 
975 
976 contract VTPToken is ERC20,Ownable{
977 
978     using SafeMath for uint256;
979     using Address for address;
980 
981     bytes32 public DOMAIN_SEPARATOR;
982 
983     constructor()
984     ERC20("Vesta",'VTP')
985     public {
986         uint chainId;
987         assembly {
988             chainId := chainid()
989         }
990         DOMAIN_SEPARATOR = keccak256(
991             abi.encode(
992                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
993                 //keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
994                 keccak256(bytes("Vesta")),
995                 keccak256(bytes('1')),
996                 chainId,
997                 address(this)
998             )
999         );
1000     }
1001 
1002     function mint(address account, uint256 amount) public onlyOwner{
1003         return _mint(account, amount);
1004     }
1005 }
1006 
1007 
1008 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
1009 
1010 // SPDX-License-Identifier: MIT
1011 
1012 pragma solidity ^0.6.0;
1013 
1014 
1015 
1016 
1017 /**
1018  * @title SafeERC20
1019  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1020  * contract returns false). Tokens that return no value (and instead revert or
1021  * throw on failure) are also supported, non-reverting calls are assumed to be
1022  * successful.
1023  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1024  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1025  */
1026 library SafeERC20 {
1027     using SafeMath for uint256;
1028     using Address for address;
1029 
1030     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1031         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1032     }
1033 
1034     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1035         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1036     }
1037 
1038     /**
1039      * @dev Deprecated. This function has issues similar to the ones found in
1040      * {IERC20-approve}, and its usage is discouraged.
1041      *
1042      * Whenever possible, use {safeIncreaseAllowance} and
1043      * {safeDecreaseAllowance} instead.
1044      */
1045     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1046         // safeApprove should only be called when setting an initial allowance,
1047         // or when resetting it to zero. To increase and decrease it, use
1048         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1049         // solhint-disable-next-line max-line-length
1050         require((value == 0) || (token.allowance(address(this), spender) == 0),
1051             "SafeERC20: approve from non-zero to non-zero allowance"
1052         );
1053         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1054     }
1055 
1056     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1057         uint256 newAllowance = token.allowance(address(this), spender).add(value);
1058         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1059     }
1060 
1061     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1062         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
1063         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1064     }
1065 
1066     /**
1067      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1068      * on the return value: the return value is optional (but if data is returned, it must not be false).
1069      * @param token The token targeted by the call.
1070      * @param data The call data (encoded using abi.encode or one of its variants).
1071      */
1072     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1073         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1074         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1075         // the target address contains contract code and also asserts for success in the low-level call.
1076 
1077         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1078         if (returndata.length > 0) { // Return data is optional
1079             // solhint-disable-next-line max-line-length
1080             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1081         }
1082     }
1083 }
1084 
1085 // File: @openzeppelin\contracts\utils\ReentrancyGuard.sol
1086 
1087 // SPDX-License-Identifier: MIT
1088 
1089 pragma solidity ^0.6.0;
1090 
1091 /**
1092  * @dev Contract module that helps prevent reentrant calls to a function.
1093  *
1094  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1095  * available, which can be applied to functions to make sure there are no nested
1096  * (reentrant) calls to them.
1097  *
1098  * Note that because there is a single `nonReentrant` guard, functions marked as
1099  * `nonReentrant` may not call one another. This can be worked around by making
1100  * those functions `private`, and then adding `external` `nonReentrant` entry
1101  * points to them.
1102  *
1103  * TIP: If you would like to learn more about reentrancy and alternative ways
1104  * to protect against it, check out our blog post
1105  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1106  */
1107 contract ReentrancyGuard {
1108     // Booleans are more expensive than uint256 or any type that takes up a full
1109     // word because each write operation emits an extra SLOAD to first read the
1110     // slot's contents, replace the bits taken up by the boolean, and then write
1111     // back. This is the compiler's defense against contract upgrades and
1112     // pointer aliasing, and it cannot be disabled.
1113 
1114     // The values being non-zero value makes deployment a bit more expensive,
1115     // but in exchange the refund on every call to nonReentrant will be lower in
1116     // amount. Since refunds are capped to a percentage of the total
1117     // transaction's gas, it is best to keep them low in cases like this one, to
1118     // increase the likelihood of the full refund coming into effect.
1119     uint256 private constant _NOT_ENTERED = 1;
1120     uint256 private constant _ENTERED = 2;
1121 
1122     uint256 private _status;
1123 
1124     constructor () internal {
1125         _status = _NOT_ENTERED;
1126     }
1127 
1128     /**
1129      * @dev Prevents a contract from calling itself, directly or indirectly.
1130      * Calling a `nonReentrant` function from another `nonReentrant`
1131      * function is not supported. It is possible to prevent this from happening
1132      * by making the `nonReentrant` function external, and make it call a
1133      * `private` function that does the actual work.
1134      */
1135     modifier nonReentrant() {
1136         // On the first call to nonReentrant, _notEntered will be true
1137         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1138 
1139         // Any calls to nonReentrant after this point will fail
1140         _status = _ENTERED;
1141 
1142         _;
1143 
1144         // By storing the original value once again, a refund is triggered (see
1145         // https://eips.ethereum.org/EIPS/eip-2200)
1146         _status = _NOT_ENTERED;
1147     }
1148 }
1149 
1150 // File: contracts\Crowdsale.sol
1151 
1152 pragma solidity ^0.6.0;
1153 
1154 
1155 
1156 
1157 
1158 
1159 /**
1160  * @title Crowdsale
1161  * @dev Crowdsale is a base contract for managing a token crowdsale,
1162  * allowing investors to purchase tokens with ether. This contract implements
1163  * such functionality in its most fundamental form and can be extended to provide additional
1164  * functionality and/or custom behavior.
1165  * The external interface represents the basic interface for purchasing tokens, and conforms
1166  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
1167  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
1168  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
1169  * behavior.
1170  */
1171 contract Crowdsale is Context, ReentrancyGuard {
1172     using SafeMath for uint256;
1173     using SafeERC20 for IERC20;
1174 
1175     // The token being sold
1176     IERC20 private _token;
1177 
1178     // Address where funds are collected
1179     address payable private immutable _wallet;
1180 
1181     // How many token units a buyer gets per wei.
1182     // The rate is the conversion between wei and the smallest and indivisible token unit.
1183     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
1184     // 1 wei will give you 1 unit, or 0.001 TOK.
1185     uint256 private _rate;
1186 
1187     // Amount of wei raised
1188     uint256 private _weiRaised;
1189 
1190     /**
1191      * Event for token purchase logging
1192      * @param purchaser who paid for the tokens
1193      * @param beneficiary who got the tokens
1194      * @param value weis paid for purchase
1195      * @param amount amount of tokens purchased
1196      */
1197     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1198 
1199     /**
1200      * @param rate Number of token units a buyer gets per wei
1201      * @dev The rate is the conversion between wei and the smallest and indivisible
1202      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
1203      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
1204      * @param wallet Address where collected funds will be forwarded to
1205      * @param token Address of the token being sold
1206      */
1207     constructor (uint256 rate, address payable wallet, IERC20 token) public {
1208         require(rate > 0, "Crowdsale: rate is 0");
1209         require(wallet != address(0), "Crowdsale: wallet is the zero address");
1210         require(address(token) != address(0), "Crowdsale: token is the zero address");
1211 
1212         _rate = rate;
1213         _wallet = wallet;
1214         _token = token;
1215     }
1216 
1217     /**
1218      * @dev fallback function ***DO NOT OVERRIDE***
1219      * Note that other contracts will transfer funds with a base gas stipend
1220      * of 2300, which is not enough to call buyTokens. Consider calling
1221      * buyTokens directly when purchasing tokens from a contract.
1222      */
1223     receive() external payable {
1224         buyTokens(_msgSender());
1225     }
1226 
1227     /**
1228      * @return the token being sold.
1229      */
1230     function token() public view returns (IERC20) {
1231         return _token;
1232     }
1233 
1234     /**
1235      * @return the address where funds are collected.
1236      */
1237     function wallet() public view returns (address payable) {
1238         return _wallet;
1239     }
1240 
1241     /**
1242      * @return the number of token units a buyer gets per wei.
1243      */
1244     function rate() public view virtual returns (uint256) {
1245         return _rate;
1246     }
1247 
1248     /**
1249      * @return the amount of wei raised.
1250      */
1251     function weiRaised() public view returns (uint256) {
1252         return _weiRaised;
1253     }
1254 
1255     /**
1256      * @dev low level token purchase ***DO NOT OVERRIDE***
1257      * This function has a non-reentrancy guard, so it shouldn't be called by
1258      * another `nonReentrant` function.
1259      * @param beneficiary Recipient of the token purchase
1260      */
1261     function buyTokens(address beneficiary) public nonReentrant payable {
1262         uint256 weiAmount = msg.value;
1263         _preValidatePurchase(beneficiary, weiAmount);
1264 
1265         // calculate token amount to be created
1266         uint256 tokens = _getTokenAmount(weiAmount);
1267 
1268         // update state
1269         _weiRaised = _weiRaised.add(weiAmount);
1270 
1271         _processPurchase(beneficiary, tokens);
1272         emit TokensPurchased(_msgSender(), beneficiary, weiAmount, tokens);
1273 
1274         _updatePurchasingState(beneficiary, weiAmount);
1275 
1276         _forwardFunds();
1277         _postValidatePurchase(beneficiary, weiAmount);
1278     }
1279 
1280     /**
1281      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
1282      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
1283      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
1284      *     super._preValidatePurchase(beneficiary, weiAmount);
1285      *     require(weiRaised().add(weiAmount) <= cap);
1286      * @param beneficiary Address performing the token purchase
1287      * @param weiAmount Value in wei involved in the purchase
1288      */
1289     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view virtual{
1290         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
1291         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
1292         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1293     }
1294 
1295     /**
1296      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
1297      * conditions are not met.
1298      * @param beneficiary Address performing the token purchase
1299      * @param weiAmount Value in wei involved in the purchase
1300      */
1301     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view virtual {
1302         // solhint-disable-previous-line no-empty-blocks
1303     }
1304 
1305     /**
1306      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
1307      * tokens.
1308      * @param beneficiary Address receiving the tokens
1309      * @param tokenAmount Number of tokens to be purchased
1310      */
1311     function _processPurchase(address beneficiary, uint256 tokenAmount) internal virtual{
1312         // solhint-disable-previous-line no-empty-blocks
1313     }
1314 
1315     /**
1316      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
1317      * etc.)
1318      * @param beneficiary Address receiving the tokens
1319      * @param weiAmount Value in wei involved in the purchase
1320      */
1321     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal virtual{
1322         // solhint-disable-previous-line no-empty-blocks
1323     }
1324 
1325     /**
1326      * @dev Override to extend the way in which ether is converted to tokens.
1327      * @param weiAmount Value in wei to be converted into tokens
1328      * @return Number of tokens that can be purchased with the specified _weiAmount
1329      */
1330     function _getTokenAmount(uint256 weiAmount) internal view virtual returns (uint256) {
1331         return weiAmount.mul(_rate);
1332     }
1333 
1334     /**
1335      * @dev Determines how ETH is stored/forwarded on purchases.
1336      */
1337     function _forwardFunds() internal virtual {
1338         // solhint-disable-previous-line no-empty-blocks
1339     }
1340 }
1341 
1342 // File: contracts\BlockCrowdsale.sol
1343 
1344 pragma solidity ^0.6.0;
1345 
1346 
1347 
1348 contract BlockCrowdsale is Crowdsale {
1349     using SafeMath for uint256;
1350 
1351     uint private _openingBlock;
1352     uint private _closingBlock;
1353 
1354     event BlockCrowdsaleExtended(uint prevClosingBlock, uint newClosingBlock);
1355 
1356     /**
1357      * @dev Reverts if not in crowdsale block range.
1358      */
1359     modifier onlyWhileOpen {
1360         require(isOpen(), "BlockCrowdsale: not open");
1361         _;
1362     }
1363 
1364     constructor (uint256 rate, address payable wallet, IERC20 token,uint openingBlock, uint closingBlock) Crowdsale(rate,wallet,token) public {
1365         require(openingBlock >= block.number, "BlockCrowdsale: opening time is before current time");
1366         require(openingBlock < closingBlock, "BlockCrowdsale: opening time is not before closing time");
1367 
1368         _openingBlock = openingBlock;
1369         _closingBlock = closingBlock;
1370     }
1371 
1372     function openingBlock() public view returns (uint256) {
1373         return _openingBlock;
1374     }
1375 
1376     function closingBlock() public view returns (uint256) {
1377         return _closingBlock;
1378     }
1379 
1380     function isOpen() public view returns (bool) {
1381         return block.number >= _openingBlock && block.number <= _closingBlock;
1382     }
1383 
1384     function hasClosed() public view returns (bool) {
1385         return block.number > _closingBlock;
1386     }
1387 
1388     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view virtual override{
1389         super._preValidatePurchase(beneficiary, weiAmount);
1390     }
1391 
1392     function _extendBlock(uint newClosingBlock) internal {
1393         require(!hasClosed(), "BlockCrowdsale: already closed");
1394         // solhint-disable-next-line max-line-length
1395         require(newClosingBlock >= _closingBlock, "BlockCrowdsale: new closing block is before current closing block");
1396         if(newClosingBlock == _closingBlock) return;
1397 
1398         emit BlockCrowdsaleExtended(_closingBlock, newClosingBlock);
1399         _closingBlock = newClosingBlock;
1400     }
1401 }
1402 
1403 // File: contracts\VTPPresale.sol
1404 
1405 // SPDX-License-Identifier: MIT
1406 pragma solidity ^0.6.0;
1407 
1408 
1409 
1410 
1411 
1412 
1413 
1414 
1415 
1416 
1417 contract VTPPresale is BlockCrowdsale,Ownable {
1418     using SafeMath for uint256;
1419     using Address for address;
1420 
1421     struct ReleaseOneStage{
1422         bool release;
1423         uint block;
1424         uint256 valueWei;
1425     }
1426 
1427     struct ReleaseRecord{
1428         uint size;
1429         mapping (uint => ReleaseOneStage) stages;
1430         bool done;
1431     }
1432 
1433     struct ReleaseRecordArray{
1434         uint size;
1435         mapping (uint => ReleaseRecord) content;
1436     }
1437 
1438     mapping (address => ReleaseRecordArray) private _releasePool;
1439     mapping (address => uint256) public addressLimit;
1440 
1441     uint256 private _storeValue;
1442     uint256 private _storeTokenValue;
1443     uint256 private _rateVTP;
1444     VTPToken private _token;
1445     uint private _rawCloseBlock;
1446 
1447     uint private _preExtend;
1448     uint private _rateReduce;
1449     IUniswapV2Router01 private _uniswap;
1450     uint private _step;
1451 
1452     bool private _unlock;
1453     uint private _dailyRelease;
1454 
1455     constructor(uint256 rate, VTPToken token,address payable project,uint openBlock,uint closeBlock,address uniswap,uint step)
1456     BlockCrowdsale(rate,project,token,openBlock,closeBlock) public{
1457         require(openBlock<closeBlock,"VTPPresale:Time Breaking");
1458         require(step > 0,"VTPPresale:Step can not be zero");
1459         require(step <= 100,"VTPPresale:Step is too big");
1460         _rateVTP = rate;
1461         _token = token;
1462         _rawCloseBlock = closeBlock;
1463         _preExtend = 24 * step;
1464         _rateReduce = 1000;
1465         _uniswap = IUniswapV2Router01(uniswap);
1466         _unlock = false;
1467         _step = step;//on mainnet it should be 100
1468     }
1469 
1470     function storeAmount() public view returns(uint256,uint256){
1471         return (_storeValue,_storeTokenValue);
1472     }
1473 
1474     function rate() public view override returns (uint256) {
1475         return _rateVTP.sub(_storeValue.div(10 ** 18).div(500).mul(_rateReduce));
1476     }
1477 
1478     function _getTokenAmount(uint256 weiAmount) internal view override returns (uint256) {
1479         uint256 r = rate();
1480         require(r > 0,"VTPPresale:can not any token now!");
1481         return weiAmount.mul(r);
1482     }
1483 
1484     /**
1485     * save get eth total
1486     */
1487     function _forwardFunds() internal override {
1488         _storeValue = _storeValue.add(msg.value);
1489         addressLimit[msg.sender] += msg.value;
1490     }
1491 
1492     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view override {
1493         super._preValidatePurchase(beneficiary, weiAmount);
1494         require(_storeValue < 3000 * 10 ** uint256(18),"VTPPresale:Exceed maximum");
1495         require(_storeValue.add(weiAmount) < 20000 * 10 ** uint256(18),"VTPPresale:Oops");
1496         require(weiAmount > 10000000000000000,"VTPPresale:Maybe buy little more?");
1497         require(_step <= 2 || addressLimit[msg.sender] < _storeValue.div(100).add(100000000000000000000),"VTPPresale:Buy limit");
1498     }
1499 
1500     function _updatePurchasingState(address, uint256 weiAmount) internal override{
1501         //
1502         uint256 amount = _storeValue.add(weiAmount).div(10 ** 18);
1503         uint256 times = 0;//per 100 eth increase once time
1504         if(amount > 500){
1505             times = uint256(5).add(amount.sub(500).div(500));
1506         }else{
1507             times = amount.div(100);
1508         }
1509         uint256 newBlock = times.mul(_preExtend).add(_rawCloseBlock);
1510 
1511         _extendBlock(uint(newBlock));
1512     }
1513 
1514     /**
1515     * token
1516     */
1517     function _processPurchase(address beneficiary, uint256 tokenAmount) internal override{
1518         ReleaseRecordArray storage records = _releasePool[beneficiary];
1519         records.size++;
1520         ReleaseRecord storage record = records.content[records.size - 1];
1521         record.size = 3;
1522         record.stages[0] = ReleaseOneStage(false,block.number + 140 * _step,tokenAmount.mul(2).div(10));
1523         record.stages[1] = ReleaseOneStage(false,block.number + 216 * _step,tokenAmount.mul(3).div(10));
1524         record.stages[2] = ReleaseOneStage(false,block.number + 288 * _step,tokenAmount.mul(5).div(10));
1525         record.done = false;
1526 
1527         _storeTokenValue = _storeTokenValue.add(tokenAmount);
1528     }
1529 
1530     event ReleaseVTP(address beneficiary, uint256 amount,uint stage,uint id);
1531 
1532     function canRelease() public view returns(bool){
1533         return _unlock;
1534     }
1535 
1536     function release() public nonReentrant{
1537         require(_unlock == true,"VTPPresale:Locking");
1538         ReleaseRecordArray storage records = _releasePool[msg.sender];
1539         for(uint record = 0;record < records.size;record++){
1540             ReleaseRecord storage stages = records.content[record];
1541             if(stages.done == false){
1542                 uint releaseTimes = 0;
1543                 for(uint i = 0;i < 3;i++){
1544                     ReleaseOneStage storage one = stages.stages[i];
1545                     if(one.block <= block.number && one.release == false){
1546                         one.release = true;
1547                         _token.mint(msg.sender,one.valueWei);
1548 
1549                         emit ReleaseVTP(msg.sender,one.valueWei,i,record);
1550                     }
1551 
1552                     if(one.release == true){
1553                         releaseTimes = releaseTimes + 1;
1554                     }
1555                 }
1556                 if(releaseTimes == 3) stages.done = true;
1557             }
1558         }
1559     }
1560 
1561     function buyRecords() public view returns(uint256[] memory returnData){
1562         ReleaseRecordArray storage array = _releasePool[msg.sender];
1563         returnData = new uint256[](array.size*9);
1564         for(uint i = 0;i<array.size;i++){
1565             ReleaseRecord storage rawOneRecord = array.content[i];
1566             for(uint ii = 0;ii<rawOneRecord.size;ii++){//3
1567                 if(rawOneRecord.stages[ii].release){
1568                     returnData[i*9+ii*3] = 1;
1569                 }else{
1570                     returnData[i*9+ii*3] = 0;
1571                 }
1572 
1573                 returnData[i*9+ii*3+1] = uint256(rawOneRecord.stages[ii].block);//2
1574                 returnData[i*9+ii*3+2] = rawOneRecord.stages[ii].valueWei;
1575             }
1576         }
1577     }
1578 
1579     event UnlockRelease(uint block,address self);
1580 
1581     function afterClose() public onlyOwner nonReentrant{
1582         if(_step != 1){//todo:
1583             require(hasClosed(),"VTPPresale:have not close");
1584         }
1585         address payable project = Crowdsale(address (this)).wallet();
1586 
1587         uint toMaster = _storeTokenValue.mul(11).div(10);
1588         uint toSwap = _storeTokenValue.mul(4).div(10);
1589         //to master
1590         _token.mint(project,toMaster);
1591         uint256 last = _storeValue.div(2);
1592         project.transfer(last);
1593         last = _storeValue.sub(last);
1594 
1595         //to uniswap
1596         _token.mint(address(this),toSwap);
1597         _token.approve(address(_uniswap), toSwap);
1598         //lock in contract address
1599         _uniswap.addLiquidityETH{value: last}(address(_token), toSwap, toSwap, last,address(this),now);
1600 
1601         _unlock = true;
1602         _dailyRelease = block.number.add(216 * _step);
1603         emit UnlockRelease(block.number,address (this));
1604     }
1605 
1606     function getPair() public view returns(address){
1607         return pairFor(_uniswap.factory(),address (_token),_uniswap.WETH());
1608     }
1609 
1610     event DailyRelease(uint amount,uint nextBlock);
1611 
1612     //daily release
1613     function projectRelease() public onlyOwner{
1614         if(_step != 1) require(_dailyRelease <= block.number,"VTPPresale:not the block");
1615         _dailyRelease = _dailyRelease + 72 * _step;
1616         IUniswapV2Pair pair = IUniswapV2Pair(getPair());
1617 
1618         uint liq = pair.balanceOf(address (this));
1619         uint releaseAmount = liq.mul(5).div(100);
1620         require(releaseAmount > 0,"VTPPresale:have not liquidity");
1621         pair.approve(address (_uniswap), releaseAmount);
1622         _uniswap.removeLiquidityETH(address (_token),releaseAmount,0,0,address (wallet()),now);
1623         emit DailyRelease(releaseAmount,_dailyRelease);
1624     }
1625 
1626     // returns sorted token addresses, used to handle return values from pairs sorted in this order from:UniswapV2Library
1627     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
1628         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
1629         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
1630         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
1631     }
1632 
1633     // calculates the CREATE2 address for a pair without making any external calls from:UniswapV2Library
1634     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
1635         (address token0, address token1) = sortTokens(tokenA, tokenB);
1636         pair = address(uint(keccak256(abi.encodePacked(
1637                 hex'ff',
1638                 factory,
1639                 keccak256(abi.encodePacked(token0, token1)),
1640                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
1641             ))));
1642     }
1643 }