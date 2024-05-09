1 /*
2  
3  VOLT INU - The supercharged Inu
4  
5  https://t.me/VoltInuOfficial
6  
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 
11 pragma solidity ^0.8.9;
12 interface IERC20 {
13 
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
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96  
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 abstract contract Context {
241     //function _msgSender() internal view virtual returns (address payable) {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes memory) {
247         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
248         return msg.data;
249     }
250 }
251 
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
276         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
277         // for accounts without code, i.e. `keccak256('')`
278         bytes32 codehash;
279         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { codehash := extcodehash(account) }
282         return (codehash != accountHash && codehash != 0x0);
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 /**
392  * @dev Contract module which provides a basic access control mechanism, where
393  * there is an account (an owner) that can be granted exclusive access to
394  * specific functions.
395  *
396  * By default, the owner account will be the one that deploys the contract. This
397  * can later be changed with {transferOwnership}.
398  *
399  * This module is used through inheritance. It will make available the modifier
400  * `onlyOwner`, which can be applied to your functions to restrict their use to
401  * the owner.
402  */
403 contract Ownable is Context {
404     address private _owner;
405     address private _previousOwner;
406     uint256 private _lockTime;
407 
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409 
410     /**
411      * @dev Initializes the contract setting the deployer as the initial owner.
412      */
413     constructor () {
414         address msgSender = _msgSender();
415         _owner = msgSender;
416         emit OwnershipTransferred(address(0), msgSender);
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(_owner == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434      /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         emit OwnershipTransferred(_owner, address(0));
443         _owner = address(0);
444     }
445 
446     /**
447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
448      * Can only be called by the current owner.
449      */
450     function transferOwnership(address newOwner) public virtual onlyOwner {
451         require(newOwner != address(0), "Ownable: new owner is the zero address");
452         emit OwnershipTransferred(_owner, newOwner);
453         _owner = newOwner;
454     }
455 
456 
457 }
458 
459 
460 interface IUniswapV2Factory {
461     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
462 
463     function feeTo() external view returns (address);
464     function feeToSetter() external view returns (address);
465 
466     function getPair(address tokenA, address tokenB) external view returns (address pair);
467     function allPairs(uint) external view returns (address pair);
468     function allPairsLength() external view returns (uint);
469 
470     function createPair(address tokenA, address tokenB) external returns (address pair);
471 
472     function setFeeTo(address) external;
473     function setFeeToSetter(address) external;
474 }
475 
476 
477 
478 interface IUniswapV2Pair {
479     event Approval(address indexed owner, address indexed spender, uint value);
480     event Transfer(address indexed from, address indexed to, uint value);
481 
482     function name() external pure returns (string memory);
483     function symbol() external pure returns (string memory);
484     function decimals() external pure returns (uint8);
485     function totalSupply() external view returns (uint);
486     function balanceOf(address owner) external view returns (uint);
487     function allowance(address owner, address spender) external view returns (uint);
488 
489     function approve(address spender, uint value) external returns (bool);
490     function transfer(address to, uint value) external returns (bool);
491     function transferFrom(address from, address to, uint value) external returns (bool);
492 
493     function DOMAIN_SEPARATOR() external view returns (bytes32);
494     function PERMIT_TYPEHASH() external pure returns (bytes32);
495     function nonces(address owner) external view returns (uint);
496 
497     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
498 
499     event Mint(address indexed sender, uint amount0, uint amount1);
500     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
501     event Swap(
502         address indexed sender,
503         uint amount0In,
504         uint amount1In,
505         uint amount0Out,
506         uint amount1Out,
507         address indexed to
508     );
509     event Sync(uint112 reserve0, uint112 reserve1);
510 
511     function MINIMUM_LIQUIDITY() external pure returns (uint);
512     function factory() external view returns (address);
513     function token0() external view returns (address);
514     function token1() external view returns (address);
515     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
516     function price0CumulativeLast() external view returns (uint);
517     function price1CumulativeLast() external view returns (uint);
518     function kLast() external view returns (uint);
519 
520     function mint(address to) external returns (uint liquidity);
521     function burn(address to) external returns (uint amount0, uint amount1);
522     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
523     function skim(address to) external;
524     function sync() external;
525 
526     function initialize(address, address) external;
527 }
528 
529 
530 interface IUniswapV2Router01 {
531     function factory() external pure returns (address);
532     function WETH() external pure returns (address);
533 
534     function addLiquidity(
535         address tokenA,
536         address tokenB,
537         uint amountADesired,
538         uint amountBDesired,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline
543     ) external returns (uint amountA, uint amountB, uint liquidity);
544     function addLiquidityETH(
545         address token,
546         uint amountTokenDesired,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline
551     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
552     function removeLiquidity(
553         address tokenA,
554         address tokenB,
555         uint liquidity,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline
560     ) external returns (uint amountA, uint amountB);
561     function removeLiquidityETH(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountToken, uint amountETH);
569     function removeLiquidityWithPermit(
570         address tokenA,
571         address tokenB,
572         uint liquidity,
573         uint amountAMin,
574         uint amountBMin,
575         address to,
576         uint deadline,
577         bool approveMax, uint8 v, bytes32 r, bytes32 s
578     ) external returns (uint amountA, uint amountB);
579     function removeLiquidityETHWithPermit(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline,
586         bool approveMax, uint8 v, bytes32 r, bytes32 s
587     ) external returns (uint amountToken, uint amountETH);
588     function swapExactTokensForTokens(
589         uint amountIn,
590         uint amountOutMin,
591         address[] calldata path,
592         address to,
593         uint deadline
594     ) external returns (uint[] memory amounts);
595     function swapTokensForExactTokens(
596         uint amountOut,
597         uint amountInMax,
598         address[] calldata path,
599         address to,
600         uint deadline
601     ) external returns (uint[] memory amounts);
602     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
603         external
604         payable
605         returns (uint[] memory amounts);
606     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
607         external
608         returns (uint[] memory amounts);
609     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
610         external
611         returns (uint[] memory amounts);
612     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
613         external
614         payable
615         returns (uint[] memory amounts);
616 
617     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
618     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
619     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
620     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
621     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
622 }
623 
624 
625 
626 
627 interface IUniswapV2Router02 is IUniswapV2Router01 {
628     function removeLiquidityETHSupportingFeeOnTransferTokens(
629         address token,
630         uint liquidity,
631         uint amountTokenMin,
632         uint amountETHMin,
633         address to,
634         uint deadline
635     ) external returns (uint amountETH);
636     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
637         address token,
638         uint liquidity,
639         uint amountTokenMin,
640         uint amountETHMin,
641         address to,
642         uint deadline,
643         bool approveMax, uint8 v, bytes32 r, bytes32 s
644     ) external returns (uint amountETH);
645 
646     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
647         uint amountIn,
648         uint amountOutMin,
649         address[] calldata path,
650         address to,
651         uint deadline
652     ) external;
653     function swapExactETHForTokensSupportingFeeOnTransferTokens(
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external payable;
659     function swapExactTokensForETHSupportingFeeOnTransferTokens(
660         uint amountIn,
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external;
666 }
667 
668 interface IAirdrop {
669     function airdrop(address recipient, uint256 amount) external;
670 }
671 
672 contract VOLT is Context, IERC20, Ownable {
673     using SafeMath for uint256;
674     using Address for address;
675 
676     mapping (address => uint256) private _rOwned;
677     mapping (address => uint256) private _tOwned;
678     mapping (address => mapping (address => uint256)) private _allowances;
679 
680     mapping (address => bool) private _isExcludedFromFee;
681 
682     mapping (address => bool) private _isExcluded;
683     address[] private _excluded;
684     
685     mapping (address => bool) private botWallets;
686     bool constant botscantrade = false;
687     
688     bool public canTrade = false;
689    
690     uint256 private constant MAX = ~uint256(0);
691     uint256 private constant _tTotal = 69000000000000 * 10**9;
692     uint256 private _rTotal = (MAX - (MAX % _tTotal));
693     uint256 private _tFeeTotal;
694     address public marketingWallet;
695 	address public devWallet;
696 	address public burningAddress;	
697 	address private migrationWallet;	
698 
699     string private constant _name = "Volt Inu";
700     string private constant _symbol = "VOLT";
701     uint8 private constant _decimals = 9;
702     
703     uint256 public _taxFee = 1;
704     uint256 private _previousTaxFee = _taxFee;
705     
706     uint256 public _liquidityFee = 12;
707     uint256 private _previousLiquidityFee = _liquidityFee;
708 
709     IUniswapV2Router02 public immutable uniswapV2Router;
710     address public immutable uniswapV2Pair;
711     
712     bool inSwapAndLiquify;
713     bool public swapAndLiquifyEnabled = true;
714     
715     uint256 public _maxTxAmount = 69000000000000 * 10**9;
716     uint256 public numTokensSellToAddToLiquidity = 6900000000 * 10**9;
717     
718     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
719     event SwapAndLiquifyEnabledUpdated(bool enabled);
720     event SwapAndLiquify(
721         uint256 tokensSwapped,
722         uint256 ethReceived,
723         uint256 tokensIntoLiqudity
724     );
725     
726     modifier lockTheSwap {
727         inSwapAndLiquify = true;
728         _;
729         inSwapAndLiquify = false;
730     }
731     
732     constructor () {
733         _rOwned[_msgSender()] = _rTotal;
734         
735         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
736          // Create a uniswap pair for this new token
737         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
738             .createPair(address(this), _uniswapV2Router.WETH());
739 
740         // set the rest of the contract variables
741         uniswapV2Router = _uniswapV2Router;
742         
743         //exclude owner and this contract from fee
744         _isExcludedFromFee[owner()] = true;
745         _isExcludedFromFee[address(this)] = true;
746         
747         emit Transfer(address(0), _msgSender(), _tTotal);
748     }
749 
750     function name() external view returns (string memory) {
751         return _name;
752     }
753 
754     function symbol() external view returns (string memory) {
755         return _symbol;
756     }
757 
758     function decimals() external view returns (uint8) {
759         return _decimals;
760     }
761 
762     function totalSupply() external view override returns (uint256) {
763         return _tTotal;
764     }
765 
766     function balanceOf(address account) public view override returns (uint256) {
767         if (_isExcluded[account]) return _tOwned[account];
768         return tokenFromReflection(_rOwned[account]);
769     }
770 
771     function transfer(address recipient, uint256 amount) external override returns (bool) {
772         _transfer(_msgSender(), recipient, amount);
773         return true;
774     }
775 
776     function allowance(address owner, address spender) external view override returns (uint256) {
777         return _allowances[owner][spender];
778     }
779 
780     function approve(address spender, uint256 amount) external override returns (bool) {
781         _approve(_msgSender(), spender, amount);
782         return true;
783     }
784 
785     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
786         _transfer(sender, recipient, amount);
787         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
788         return true;
789     }
790 
791     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
792         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
793         return true;
794     }
795 
796     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
798         return true;
799     }
800 
801     function isExcludedFromReward(address account) external view returns (bool) {
802         return _isExcluded[account];
803     }
804 
805     function totalFees() external view returns (uint256) {
806         return _tFeeTotal;
807     }
808     
809     function airdrop(address recipient, uint256 amount) external onlyOwner() {
810         removeAllFee();
811         _transfer(_msgSender(), recipient, amount * 10**9);
812         restoreAllFee();
813     }
814     
815     function airdropInternal(address recipient, uint256 amount) internal {
816         removeAllFee();
817         _transfer(_msgSender(), recipient, amount);
818         restoreAllFee();
819     }
820     
821     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
822         uint256 iterator = 0;
823         require(newholders.length == amounts.length, "must be the same length");
824         while(iterator < newholders.length){
825             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
826             iterator += 1;
827         }
828     }
829 
830     function deliver(uint256 tAmount) external {
831         address sender = _msgSender();
832         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
833         (uint256 rAmount,,,,,) = _getValues(tAmount);
834         _rOwned[sender] = _rOwned[sender].sub(rAmount);
835         _rTotal = _rTotal.sub(rAmount);
836         _tFeeTotal = _tFeeTotal.add(tAmount);
837     }
838 
839     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) external view returns(uint256) {
840         require(tAmount <= _tTotal, "Amount must be less than supply");
841         if (!deductTransferFee) {
842             (uint256 rAmount,,,,,) = _getValues(tAmount);
843             return rAmount;
844         } else {
845             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
846             return rTransferAmount;
847         }
848     }
849 
850     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
851         require(rAmount <= _rTotal, "Amount must be less than total reflections");
852         uint256 currentRate =  _getRate();
853         return rAmount.div(currentRate);
854     }
855 
856     function excludeFromReward(address account) external onlyOwner() {
857         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
858         require(!_isExcluded[account], "Account is already excluded");
859         if(_rOwned[account] > 0) {
860             _tOwned[account] = tokenFromReflection(_rOwned[account]);
861         }
862         _isExcluded[account] = true;
863         _excluded.push(account);
864     }
865 
866     function includeInReward(address account) external onlyOwner() {
867         require(_isExcluded[account], "Account is already excluded");
868         for (uint256 i = 0; i < _excluded.length; i++) {
869             if (_excluded[i] == account) {
870                 _excluded[i] = _excluded[_excluded.length - 1];
871                 _tOwned[account] = 0;
872                 _isExcluded[account] = false;
873                 _excluded.pop();
874                 break;
875             }
876         }
877     }
878         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
879         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
880         _tOwned[sender] = _tOwned[sender].sub(tAmount);
881         _rOwned[sender] = _rOwned[sender].sub(rAmount);
882         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
883         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
884         _takeLiquidity(tLiquidity);
885         _reflectFee(rFee, tFee);
886         emit Transfer(sender, recipient, tTransferAmount);
887     }
888     
889     function excludeFromFee(address account) external onlyOwner {
890         _isExcludedFromFee[account] = true;
891     }
892     
893     function includeInFee(address account) external onlyOwner {
894         _isExcludedFromFee[account] = false;
895     }
896 
897     function setMarketingWallet(address walletAddress) external onlyOwner {
898         marketingWallet = walletAddress;
899     }
900 
901     function setDevWallet(address walletAddress) external onlyOwner {
902         devWallet = walletAddress;
903     }
904 
905     function setBurningAddress(address walletAddress) external onlyOwner {
906         burningAddress = walletAddress;
907     }
908 
909 
910     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
911         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
912         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
913     }
914     
915     function claimTokens () external onlyOwner {
916         // make sure we capture all BNB that may or may not be sent to this contract
917         payable(devWallet).transfer(address(this).balance);
918     }
919     
920     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
921         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
922     }
923     
924     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
925         walletaddress.transfer(address(this).balance);
926     }
927     
928     function addBotWallet(address botwallet) external onlyOwner() {
929         botWallets[botwallet] = true;
930     }
931     
932     function removeBotWallet(address botwallet) external onlyOwner() {
933         botWallets[botwallet] = false;
934     }
935     
936     function getBotWalletStatus(address botwallet) external view returns (bool) {
937         return botWallets[botwallet];
938     }
939     
940     function allowtrading()external onlyOwner() {
941         canTrade = true;
942     }
943 
944     function setMigrationWallet(address walletAddress) external onlyOwner {
945         migrationWallet = walletAddress;
946     }
947 
948     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
949         swapAndLiquifyEnabled = _enabled;
950         emit SwapAndLiquifyEnabledUpdated(_enabled);
951     }
952     
953      //to recieve ETH from uniswapV2Router when swaping
954     receive() external payable {}
955 
956     function _reflectFee(uint256 rFee, uint256 tFee) private {
957         _rTotal = _rTotal.sub(rFee);
958         _tFeeTotal = _tFeeTotal.add(tFee);
959     }
960 
961     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
962         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
963         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
964         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
965     }
966 
967     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
968         uint256 tFee = calculateTaxFee(tAmount);
969         uint256 tLiquidity = calculateLiquidityFee(tAmount);
970         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
971         return (tTransferAmount, tFee, tLiquidity);
972     }
973 
974     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
975         uint256 rAmount = tAmount.mul(currentRate);
976         uint256 rFee = tFee.mul(currentRate);
977         uint256 rLiquidity = tLiquidity.mul(currentRate);
978         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
979         return (rAmount, rTransferAmount, rFee);
980     }
981 
982     function _getRate() private view returns(uint256) {
983         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
984         return rSupply.div(tSupply);
985     }
986 
987     function _getCurrentSupply() private view returns(uint256, uint256) {
988         uint256 rSupply = _rTotal;
989         uint256 tSupply = _tTotal;      
990         for (uint256 i = 0; i < _excluded.length; i++) {
991             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
992             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
993             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
994         }
995         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
996         return (rSupply, tSupply);
997     }
998     
999     function _takeLiquidity(uint256 tLiquidity) private {
1000         uint256 currentRate =  _getRate();
1001         uint256 rLiquidity = tLiquidity.mul(currentRate);
1002         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1003         if(_isExcluded[address(this)])
1004             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1005     }
1006     
1007     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1008         return _amount.mul(_taxFee).div(
1009             10**2
1010         );
1011     }
1012 
1013     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1014         return _amount.mul(_liquidityFee).div(
1015             10**2
1016         );
1017     }
1018     
1019     function removeAllFee() private {
1020         if(_taxFee == 0 && _liquidityFee == 0) return;
1021         
1022         _previousTaxFee = _taxFee;
1023         _previousLiquidityFee = _liquidityFee;
1024         
1025         _taxFee = 0;
1026         _liquidityFee = 0;
1027     }
1028     
1029     function restoreAllFee() private {
1030         _taxFee = _previousTaxFee;
1031         _liquidityFee = _previousLiquidityFee;
1032     }
1033     
1034     function isExcludedFromFee(address account) external view returns(bool) {
1035         return _isExcludedFromFee[account];
1036     }
1037 
1038     function _approve(address owner, address spender, uint256 amount) private {
1039         require(owner != address(0), "ERC20: approve from the zero address");
1040         require(spender != address(0), "ERC20: approve to the zero address");
1041 
1042         _allowances[owner][spender] = amount;
1043         emit Approval(owner, spender, amount);
1044     }
1045 
1046     function _transfer(
1047         address from,
1048         address to,
1049         uint256 amount
1050     ) private {
1051         require(from != address(0), "ERC20: transfer from the zero address");
1052         require(to != address(0), "ERC20: transfer to the zero address");
1053         require(amount > 0, "Transfer amount must be greater than zero");
1054         if(from != owner() && to != owner())
1055             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1056 
1057         // is the token balance of this contract address over the min number of
1058         // tokens that we need to initiate a swap + liquidity lock?
1059         // also, don't get caught in a circular liquidity event.
1060         // also, don't swap & liquify if sender is uniswap pair.
1061         uint256 contractTokenBalance = balanceOf(address(this));
1062         
1063         if(contractTokenBalance >= _maxTxAmount)
1064         {
1065             contractTokenBalance = _maxTxAmount;
1066         }
1067         
1068         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1069         if (
1070             overMinTokenBalance &&
1071             !inSwapAndLiquify &&
1072             from != uniswapV2Pair &&
1073             swapAndLiquifyEnabled
1074         ) {
1075             contractTokenBalance = numTokensSellToAddToLiquidity;
1076             //add liquidity
1077             swapAndLiquify(contractTokenBalance);
1078         }
1079         
1080         //indicates if fee should be deducted from transfer
1081         bool takeFee = true;
1082         
1083         //if any account belongs to _isExcludedFromFee account then remove the fee
1084         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1085             takeFee = false;
1086         }
1087         
1088         //transfer amount, it will take tax, burn, liquidity fee
1089         _tokenTransfer(from,to,amount,takeFee);
1090     }
1091 
1092 
1093     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1094         // split the contract balance into liquidity, marketing, burn and treasury quotas
1095 		
1096         uint256 convertQuota = contractTokenBalance.mul(3).div(4);
1097 		uint256 burnQuota = contractTokenBalance.div(6);
1098         uint256 liquHalf = contractTokenBalance.sub(convertQuota).sub(burnQuota);
1099 
1100 		// burning tokens
1101         _transferStandard(address(this), burningAddress, burnQuota);
1102 
1103         		
1104         // swap tokens for ETH
1105 		
1106         swapTokensForEth(convertQuota); 
1107 
1108         // how much ETH did we just swap into?
1109         uint256 newBalance = address(this).balance;
1110         uint256 marketingshare = newBalance.mul(4).div(9);
1111         payable(marketingWallet).transfer(marketingshare);
1112 		uint256 afterMarketBalance = newBalance.sub(marketingshare);
1113 		uint256 treasshare = afterMarketBalance.mul(4).div(5);
1114 		payable(devWallet).transfer(treasshare);
1115 		uint256 afterDevBalance = afterMarketBalance.sub(treasshare);
1116 		
1117         
1118         // add liquidity to uniswap
1119         addLiquidity(liquHalf, afterDevBalance);
1120         
1121         emit SwapAndLiquify(liquHalf, afterDevBalance, liquHalf);
1122     }
1123 
1124     function swapTokensForEth(uint256 tokenAmount) private {
1125         // generate the uniswap pair path of token -> weth
1126         address[] memory path = new address[](2);
1127         path[0] = address(this);
1128         path[1] = uniswapV2Router.WETH();
1129 
1130         _approve(address(this), address(uniswapV2Router), tokenAmount);
1131 
1132         // make the swap
1133         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1134             tokenAmount,
1135             0, // accept any amount of ETH
1136             path,
1137             address(this),
1138             block.timestamp
1139         );
1140     }
1141 
1142     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1143         // approve token transfer to cover all possible scenarios
1144         _approve(address(this), address(uniswapV2Router), tokenAmount);
1145 
1146         // add the liquidity
1147         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1148             address(this),
1149             tokenAmount,
1150             0, // slippage is unavoidable
1151             0, // slippage is unavoidable
1152             owner(),
1153             block.timestamp
1154         );
1155     }
1156 
1157     //this method is responsible for taking all fee, if takeFee is true
1158     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1159         if(!canTrade){
1160             require(sender == owner() || sender == migrationWallet); // only owner allowed to trade or add liquidity
1161         }
1162         
1163         if(botWallets[sender] || botWallets[recipient]){
1164             require(botscantrade, "bots arent allowed to trade");
1165         }
1166         
1167         if(!takeFee)
1168             removeAllFee();
1169         
1170         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1171             _transferFromExcluded(sender, recipient, amount);
1172         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1173             _transferToExcluded(sender, recipient, amount);
1174         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1175             _transferStandard(sender, recipient, amount);
1176         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1177             _transferBothExcluded(sender, recipient, amount);
1178         } else {
1179             _transferStandard(sender, recipient, amount);
1180         }
1181         
1182         if(!takeFee)
1183             restoreAllFee();
1184     }
1185 
1186     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1187         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1188         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1189         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1190         _takeLiquidity(tLiquidity);
1191         _reflectFee(rFee, tFee);
1192         emit Transfer(sender, recipient, tTransferAmount);
1193     }
1194 
1195     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1196         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1197         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1198         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1199         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1200         _takeLiquidity(tLiquidity);
1201         _reflectFee(rFee, tFee);
1202         emit Transfer(sender, recipient, tTransferAmount);
1203     }
1204 
1205     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1206         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1207         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1210         _takeLiquidity(tLiquidity);
1211         _reflectFee(rFee, tFee);
1212         emit Transfer(sender, recipient, tTransferAmount);
1213     }
1214 
1215 }