1 /*
2 
3 Telegram : https://t.me/nfa_uniswap
4 
5 */
6 
7 
8 pragma solidity ^0.8.4;
9 // SPDX-License-Identifier: Unlicensed
10 interface IERC20 {
11 
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 
81 /**
82  * @dev Wrappers over Solidity's arithmetic operations with added overflow
83  * checks.
84  *
85  * Arithmetic operations in Solidity wrap on overflow. This can easily result
86  * in bugs, because programmers usually assume that an overflow raises an
87  * error, which is the standard behavior in high level programming languages.
88  * `SafeMath` restores this intuition by reverting the transaction when an
89  * operation overflows.
90  *
91  * Using this library instead of the unchecked operations eliminates an entire
92  * class of bugs, so it's recommended to use it always.
93  */
94  
95 library SafeMath {
96     /**
97      * @dev Returns the addition of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `+` operator.
101      *
102      * Requirements:
103      *
104      * - Addition cannot overflow.
105      */
106     function add(uint256 a, uint256 b) internal pure returns (uint256) {
107         uint256 c = a + b;
108         require(c >= a, "SafeMath: addition overflow");
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
138         require(b <= a, errorMessage);
139         uint256 c = a - b;
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, reverting on
146      * overflow.
147      *
148      * Counterpart to Solidity's `*` operator.
149      *
150      * Requirements:
151      *
152      * - Multiplication cannot overflow.
153      */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) {
159             return 0;
160         }
161 
162         uint256 c = a * b;
163         require(c / a == b, "SafeMath: multiplication overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the integer division of two unsigned integers. Reverts on
170      * division by zero. The result is rounded towards zero.
171      *
172      * Counterpart to Solidity's `/` operator. Note: this function uses a
173      * `revert` opcode (which leaves remaining gas untouched) while Solidity
174      * uses an invalid opcode to revert (consuming all remaining gas).
175      *
176      * Requirements:
177      *
178      * - The divisor cannot be zero.
179      */
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         uint256 c = a / b;
199         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * Reverts when dividing by zero.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
217         return mod(a, b, "SafeMath: modulo by zero");
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts with custom message when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b != 0, errorMessage);
234         return a % b;
235     }
236 }
237 
238 
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes memory) {
245         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
246         return msg.data;
247     }
248 }
249 
250 
251 /**
252  * @dev Collection of functions related to the address type
253  */
254 library Address {
255     /**
256      * @dev Returns true if `account` is a contract.
257      *
258      * [IMPORTANT]
259      * ====
260      * It is unsafe to assume that an address for which this function returns
261      * false is an externally-owned account (EOA) and not a contract.
262      *
263      * Among others, `isContract` will return false for the following
264      * types of addresses:
265      *
266      *  - an externally-owned account
267      *  - a contract in construction
268      *  - an address where a contract will be created
269      *  - an address where a contract lived, but was destroyed
270      * ====
271      */
272     function isContract(address account) internal view returns (bool) {
273         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
274         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
275         // for accounts without code, i.e. `keccak256('')`
276         bytes32 codehash;
277         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
278         // solhint-disable-next-line no-inline-assembly
279         assembly { codehash := extcodehash(account) }
280         return (codehash != accountHash && codehash != 0x0);
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
303         (bool success, ) = recipient.call{ value: amount }("");
304         require(success, "Address: unable to send value, recipient may have reverted");
305     }
306 
307     /**
308      * @dev Performs a Solidity function call using a low level `call`. A
309      * plain`call` is an unsafe replacement for a function call: use this
310      * function instead.
311      *
312      * If `target` reverts with a revert reason, it is bubbled up by this
313      * function (like regular Solidity function calls).
314      *
315      * Returns the raw returned data. To convert to the expected return value,
316      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
317      *
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326       return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 /**
390  * @dev Contract module which provides a basic access control mechanism, where
391  * there is an account (an owner) that can be granted exclusive access to
392  * specific functions.
393  *
394  * By default, the owner account will be the one that deploys the contract. This
395  * can later be changed with {transferOwnership}.
396  *
397  * This module is used through inheritance. It will make available the modifier
398  * `onlyOwner`, which can be applied to your functions to restrict their use to
399  * the owner.
400  */
401 contract Ownable is Context {
402     address private _owner;
403     address private _previousOwner;
404     uint256 private _lockTime;
405 
406     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
407 
408     /**
409      * @dev Initializes the contract setting the deployer as the initial owner.
410      */
411     constructor () {
412         address msgSender = _msgSender();
413         _owner = msgSender;
414         emit OwnershipTransferred(address(0), msgSender);
415     }
416 
417     /**
418      * @dev Returns the address of the current owner.
419      */
420     function owner() public view returns (address) {
421         return _owner;
422     }
423 
424     /**
425      * @dev Throws if called by any account other than the owner.
426      */
427     modifier onlyOwner() {
428         require(_owner == _msgSender(), "Ownable: caller is not the owner");
429         _;
430     }
431 
432      /**
433      * @dev Leaves the contract without owner. It will not be possible to call
434      * `onlyOwner` functions anymore. Can only be called by the current owner.
435      *
436      * NOTE: Renouncing ownership will leave the contract without an owner,
437      * thereby removing any functionality that is only available to the owner.
438      */
439     function renounceOwnership() public virtual onlyOwner {
440         emit OwnershipTransferred(_owner, address(0));
441         _owner = address(0);
442     }
443 
444     /**
445      * @dev Transfers ownership of the contract to a new account (`newOwner`).
446      * Can only be called by the current owner.
447      */
448     function transferOwnership(address newOwner) public virtual onlyOwner {
449         require(newOwner != address(0), "Ownable: new owner is the zero address");
450         emit OwnershipTransferred(_owner, newOwner);
451         _owner = newOwner;
452     }
453 
454 }
455 
456 // pragma solidity >=0.5.0;
457 
458 interface IUniswapV2Factory {
459     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
460 
461     function feeTo() external view returns (address);
462     function feeToSetter() external view returns (address);
463 
464     function getPair(address tokenA, address tokenB) external view returns (address pair);
465     function allPairs(uint) external view returns (address pair);
466     function allPairsLength() external view returns (uint);
467 
468     function createPair(address tokenA, address tokenB) external returns (address pair);
469 
470     function setFeeTo(address) external;
471     function setFeeToSetter(address) external;
472 }
473 
474 
475 // pragma solidity >=0.5.0;
476 
477 interface IUniswapV2Pair {
478     event Approval(address indexed owner, address indexed spender, uint value);
479     event Transfer(address indexed from, address indexed to, uint value);
480 
481     function name() external pure returns (string memory);
482     function symbol() external pure returns (string memory);
483     function decimals() external pure returns (uint8);
484     function totalSupply() external view returns (uint);
485     function balanceOf(address owner) external view returns (uint);
486     function allowance(address owner, address spender) external view returns (uint);
487 
488     function approve(address spender, uint value) external returns (bool);
489     function transfer(address to, uint value) external returns (bool);
490     function transferFrom(address from, address to, uint value) external returns (bool);
491 
492     function DOMAIN_SEPARATOR() external view returns (bytes32);
493     function PERMIT_TYPEHASH() external pure returns (bytes32);
494     function nonces(address owner) external view returns (uint);
495 
496     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
497 
498     event Mint(address indexed sender, uint amount0, uint amount1);
499     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
500     event Swap(
501         address indexed sender,
502         uint amount0In,
503         uint amount1In,
504         uint amount0Out,
505         uint amount1Out,
506         address indexed to
507     );
508     event Sync(uint112 reserve0, uint112 reserve1);
509 
510     function MINIMUM_LIQUIDITY() external pure returns (uint);
511     function factory() external view returns (address);
512     function token0() external view returns (address);
513     function token1() external view returns (address);
514     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
515     function price0CumulativeLast() external view returns (uint);
516     function price1CumulativeLast() external view returns (uint);
517     function kLast() external view returns (uint);
518 
519     function mint(address to) external returns (uint liquidity);
520     function burn(address to) external returns (uint amount0, uint amount1);
521     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
522     function skim(address to) external;
523     function sync() external;
524 
525     function initialize(address, address) external;
526 }
527 
528 // pragma solidity >=0.6.2;
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
626 // pragma solidity >=0.6.2;
627 
628 interface IUniswapV2Router02 is IUniswapV2Router01 {
629     function removeLiquidityETHSupportingFeeOnTransferTokens(
630         address token,
631         uint liquidity,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline
636     ) external returns (uint amountETH);
637     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
638         address token,
639         uint liquidity,
640         uint amountTokenMin,
641         uint amountETHMin,
642         address to,
643         uint deadline,
644         bool approveMax, uint8 v, bytes32 r, bytes32 s
645     ) external returns (uint amountETH);
646 
647     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
648         uint amountIn,
649         uint amountOutMin,
650         address[] calldata path,
651         address to,
652         uint deadline
653     ) external;
654     function swapExactETHForTokensSupportingFeeOnTransferTokens(
655         uint amountOutMin,
656         address[] calldata path,
657         address to,
658         uint deadline
659     ) external payable;
660     function swapExactTokensForETHSupportingFeeOnTransferTokens(
661         uint amountIn,
662         uint amountOutMin,
663         address[] calldata path,
664         address to,
665         uint deadline
666     ) external;
667 }
668 
669 
670 contract NFA is Context, IERC20, Ownable {
671     using SafeMath for uint256;
672     using Address for address;
673 
674     mapping (address => uint256) private _rOwned;
675     mapping (address => uint256) private _tOwned;
676     mapping (address => mapping (address => uint256)) private _allowances;
677 
678     mapping (address => bool) private _isExcludedFromFee;
679 
680     mapping (address => bool) private _isExcluded;
681     address[] private _excluded;
682     
683     mapping (address => bool) private _isBlackListedBot;
684     address[] private _blackListedBots;
685     
686    
687     uint256 private constant MAX = ~uint256(0);
688 
689     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
690     uint256 private _rTotal = (MAX - (MAX % _tTotal));
691     uint256 private _tFeeTotal;
692 
693     string private _name = "Not Financial Advice";
694     string private _symbol = "NFA";
695     uint8 private _decimals = 9;
696     
697     uint256 public _taxFee;
698     uint256 private _previousTaxFee = _taxFee;
699 
700     uint256 public _devFee;
701     uint256 private _previousDevFee = _devFee;
702 
703     address payable public _devWalletAddress;
704 
705     IUniswapV2Router02 public immutable uniswapV2Router;
706     address public immutable uniswapV2Pair;
707     
708     bool inSwapAndSend;
709     bool public swapAndSendEnabled = true;
710     
711     bool private tradingEnabled = false;
712     
713     uint256 public _maxTxAmount = 10000 * 10**6 * 10**9;
714     uint256 private numTokensSellToAddToLiquidity = 500 * 10**6 * 10**9;
715     
716     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
717     address private _admin;
718     event SwapAndSendEnabledUpdated(bool enabled);
719     event SwapAndSend(
720         uint256 tokensSwapped,
721         uint256 ethReceived
722     );
723     
724     modifier lockTheSwap {
725         inSwapAndSend = true;
726         _;
727         inSwapAndSend = false;
728     }
729     
730     constructor (address payable devWalletAddress) {
731         _devWalletAddress = devWalletAddress;
732         _admin = _msgSender();
733         _rOwned[_msgSender()] = _rTotal;
734 
735         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
750     function name() public view returns (string memory) {
751         return _name;
752     }
753 
754     function symbol() public view returns (string memory) {
755         return _symbol;
756     }
757 
758     function decimals() public view returns (uint8) {
759         return _decimals;
760     }
761     
762     function setDevFeeDisabled(bool _devFeeEnabled ) public returns (bool){
763         require(msg.sender == _admin, "OnlyAdmin can disable dev fee");
764         swapAndSendEnabled = _devFeeEnabled;
765         return(swapAndSendEnabled);
766     }
767     
768     
769     /*depl address can always change fees to lower than 10 to allow the project to scale*/
770     function setTaxFee(uint256 taxFee, uint256 devFee ) public {
771         require(msg.sender == _admin, "OnlyAdmin can disable dev fee");
772         require(taxFee<12, "Reflection tax can not be greater than 10");
773         require(devFee<12, "Dev tax can not be greater than 10");
774         require(devFee.add(taxFee)<16, "Total Fees cannot be greater than 15");
775         _taxFee = devFee;
776         _devFee = devFee;
777     }
778 
779     function totalSupply() public view override returns (uint256) {
780         return _tTotal;
781     }
782 
783     function balanceOf(address account) public view override returns (uint256) {
784         if (_isExcluded[account]) return _tOwned[account];
785         return tokenFromReflection(_rOwned[account]);
786     }
787 
788     function transfer(address recipient, uint256 amount) public override returns (bool) {
789         _transfer(_msgSender(), recipient, amount);
790         return true;
791     }
792 
793     function allowance(address owner, address spender) public view override returns (uint256) {
794         return _allowances[owner][spender];
795     }
796 
797     function approve(address spender, uint256 amount) public override returns (bool) {
798         _approve(_msgSender(), spender, amount);
799         return true;
800     }
801 
802     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
803         _transfer(sender, recipient, amount);
804         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
805         return true;
806     }
807 
808     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
809         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
810         return true;
811     }
812 
813     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
815         return true;
816     }
817 
818     function isExcludedFromReward(address account) public view returns (bool) {
819         return _isExcluded[account];
820     }
821 
822     function totalFees() public view returns (uint256) {
823         return _tFeeTotal;
824     }
825 
826     function deliver(uint256 tAmount) public {
827         address sender = _msgSender();
828         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
829         (uint256 rAmount,,,,,) = _getValues(tAmount);
830         _rOwned[sender] = _rOwned[sender].sub(rAmount);
831         _rTotal = _rTotal.sub(rAmount);
832         _tFeeTotal = _tFeeTotal.add(tAmount);
833     }
834 
835     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
836         require(tAmount <= _tTotal, "Amount must be less than supply");
837         if (!deductTransferFee) {
838             (uint256 rAmount,,,,,) = _getValues(tAmount);
839             return rAmount;
840         } else {
841             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
842             return rTransferAmount;
843         }
844     }
845 
846     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
847         require(rAmount <= _rTotal, "Amount must be less than total reflections");
848         uint256 currentRate =  _getRate();
849         return rAmount.div(currentRate);
850     }
851 
852     function excludeFromReward(address account) public onlyOwner() {
853         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
854         require(!_isExcluded[account], "Account is already excluded");
855         if(_rOwned[account] > 0) {
856             _tOwned[account] = tokenFromReflection(_rOwned[account]);
857         }
858         _isExcluded[account] = true;
859         _excluded.push(account);
860     }
861 
862     function includeInReward(address account) external onlyOwner() {
863         require(_isExcluded[account], "Account is already excluded");
864         for (uint256 i = 0; i < _excluded.length; i++) {
865             if (_excluded[i] == account) {
866                 _excluded[i] = _excluded[_excluded.length - 1];
867                 _tOwned[account] = 0;
868                 _isExcluded[account] = false;
869                 _excluded.pop();
870                 break;
871             }
872         }
873     }
874     
875     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
876         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
877         _tOwned[sender] = _tOwned[sender].sub(tAmount);
878         _rOwned[sender] = _rOwned[sender].sub(rAmount);
879         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
880         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
881         _takeLiquidity(tLiquidity);
882         _reflectFee(rFee, tFee);
883         emit Transfer(sender, recipient, tTransferAmount);
884     }
885     
886     function excludeFromFee(address account) public onlyOwner {
887         _isExcludedFromFee[account] = true;
888     }
889     
890     function includeInFee(address account) public onlyOwner {
891         _isExcludedFromFee[account] = false;
892     }
893     
894     function _setdevWallet(address payable devWalletAddress) external onlyOwner() {
895         _devWalletAddress = devWalletAddress;
896     }
897     
898     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
899         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
900             10**2
901         );
902     }
903 
904     function setSwapAndSendEnabled(bool _enabled) public onlyOwner {
905         swapAndSendEnabled = _enabled;
906         emit SwapAndSendEnabledUpdated(_enabled);
907     }
908     
909         
910     function manualswap() external {
911         require(_msgSender() == _admin);
912         uint256 contractBalance = balanceOf(address(this));
913         swapTokensForEth(contractBalance);
914     }
915     
916     function manualsend() external {
917         require(_msgSender() == _admin);
918         uint256 contractETHBalance = address(this).balance;
919         sendETHTodev(contractETHBalance);
920     }
921     
922      //to recieve ETH from uniswapV2Router when swaping
923     receive() external payable {}
924 
925     function _reflectFee(uint256 rFee, uint256 tFee) private {
926         _rTotal = _rTotal.sub(rFee);
927         _tFeeTotal = _tFeeTotal.add(tFee);
928     }
929 
930     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
931         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
932         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
933         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
934     }
935 
936     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
937         uint256 tFee = calculateTaxFee(tAmount);
938         uint256 tLiquidity = calculateDevFee(tAmount);
939         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
940         return (tTransferAmount, tFee, tLiquidity);
941     }
942 
943     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
944         uint256 rAmount = tAmount.mul(currentRate);
945         uint256 rFee = tFee.mul(currentRate);
946         uint256 rLiquidity = tLiquidity.mul(currentRate);
947         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
948         return (rAmount, rTransferAmount, rFee);
949     }
950 
951     function _getRate() private view returns(uint256) {
952         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
953         return rSupply.div(tSupply);
954     }
955 
956     function _getCurrentSupply() private view returns(uint256, uint256) {
957         uint256 rSupply = _rTotal;
958         uint256 tSupply = _tTotal;      
959         for (uint256 i = 0; i < _excluded.length; i++) {
960             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
961             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
962             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
963         }
964         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
965         return (rSupply, tSupply);
966     }
967     
968     function _takeLiquidity(uint256 tLiquidity) private {
969         uint256 currentRate =  _getRate();
970         uint256 rLiquidity = tLiquidity.mul(currentRate);
971         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
972         if(_isExcluded[address(this)])
973             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
974     }
975     
976     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
977         return _amount.mul(_taxFee).div(
978             10**2
979         );
980     }
981 
982     function calculateDevFee(uint256 _amount) private view returns (uint256) {
983         return _amount.mul(_devFee).div(
984             10**2
985         );
986     }
987     
988     function addBotToBlackList(address account) external onlyOwner() {
989         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
990         require(!_isBlackListedBot[account], "Account is already blacklisted");
991         _isBlackListedBot[account] = true;
992         _blackListedBots.push(account);
993     }
994 
995     function removeBotFromBlackList(address account) external onlyOwner() {
996         require(_isBlackListedBot[account], "Account is not blacklisted");
997         for (uint256 i = 0; i < _blackListedBots.length; i++) {
998             if (_blackListedBots[i] == account) {
999                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
1000                 _isBlackListedBot[account] = false;
1001                 _blackListedBots.pop();
1002                 break;
1003             }
1004         }
1005     }
1006     
1007     function openTrading() external onlyOwner() {
1008         require(!tradingEnabled, "Trading has already Been enabled");
1009         _taxFee = 2;
1010         _devFee = 10;
1011         tradingEnabled = true;
1012         swapAndSendEnabled = true;
1013     }
1014     
1015     
1016     function removeAllFee() private {
1017         if(_taxFee == 0 && _devFee == 0) return;
1018         
1019         _previousTaxFee = _taxFee;
1020         _previousDevFee = _devFee;
1021         
1022         _taxFee = 0;
1023         _devFee = 0;
1024     }
1025     
1026     function restoreAllFee() private {
1027         _taxFee = _previousTaxFee;
1028         _devFee = _previousDevFee;
1029     }
1030     
1031     function isExcludedFromFee(address account) public view returns(bool) {
1032         return _isExcludedFromFee[account];
1033     }
1034     
1035     function getDevFee() public view returns(uint256) {
1036         return _devFee;
1037     }
1038 
1039     function _approve(address owner, address spender, uint256 amount) private {
1040         require(owner != address(0), "ERC20: approve from the zero address");
1041         require(spender != address(0), "ERC20: approve to the zero address");
1042 
1043         _allowances[owner][spender] = amount;
1044         emit Approval(owner, spender, amount);
1045     }
1046 
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 amount
1051     ) private {
1052         require(from != address(0), "ERC20: transfer from the zero address");
1053         require(to != address(0), "ERC20: transfer to the zero address");
1054         require(amount > 0, "Transfer amount must be greater than zero");
1055         
1056         require(!_isBlackListedBot[to], "You have no power here!");
1057         require(!_isBlackListedBot[msg.sender], "You have no power here!");
1058         require(!_isBlackListedBot[from], "You have no power here!");
1059         
1060         
1061         if(from != owner() && to != owner()) {
1062             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1063             require(tradingEnabled, "Trading has not been enabled");
1064         }
1065         // is the token balance of this contract address over the min number of
1066         // tokens that we need to initiate a swap + liquidity lock?
1067         // also, don't get caught in a circular liquidity event.
1068         // also, don't swap & liquify if sender is uniswap pair.
1069         uint256 contractTokenBalance = balanceOf(address(this));
1070         
1071         if(contractTokenBalance >= _maxTxAmount)
1072         {
1073             contractTokenBalance = _maxTxAmount;
1074         }
1075         
1076         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1077         if (
1078             overMinTokenBalance &&
1079             !inSwapAndSend &&
1080             from != uniswapV2Pair &&
1081             swapAndSendEnabled
1082         ) {
1083             //add liquidity
1084             swapAndSend(contractTokenBalance);
1085         }
1086         
1087         //indicates if fee should be deducted from transfer
1088         bool takeFee = true;
1089         
1090         //if any account belongs to _isExcludedFromFee account then remove the fee
1091         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1092             takeFee = false;
1093         }
1094         
1095         //transfer amount, it will take tax, burn, liquidity fee
1096         _tokenTransfer(from,to,amount,takeFee);
1097     }
1098 
1099     function swapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1100         // split the contract balance into halves
1101         uint256 tokenBalance = contractTokenBalance;
1102 
1103         // capture the contract's current ETH balance.
1104         // this is so that we can capture exactly the amount of ETH that the
1105         // swap creates, and not make the liquidity event include any ETH that
1106         // has been manually sent to the contract
1107         uint256 initialBalance = address(this).balance;
1108 
1109         // swap tokens for ETH
1110         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1111 
1112         // how much ETH did we just swap into?
1113         uint256 newBalance = address(this).balance.sub(initialBalance);
1114 
1115         sendETHTodev(newBalance);
1116         // add liquidity to uniswap
1117         
1118         emit SwapAndSend(tokenBalance, newBalance);
1119     }
1120 
1121     function sendETHTodev(uint256 amount) private {
1122       _devWalletAddress.transfer(amount);
1123     }
1124 
1125     function swapTokensForEth(uint256 tokenAmount) private {
1126         // generate the uniswap pair path of token -> weth
1127         address[] memory path = new address[](2);
1128         path[0] = address(this);
1129         path[1] = uniswapV2Router.WETH();
1130 
1131         _approve(address(this), address(uniswapV2Router), tokenAmount);
1132 
1133         // make the swap
1134         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1135             tokenAmount,
1136             0, // accept any amount of ETH
1137             path,
1138             address(this),
1139             block.timestamp
1140         );
1141     }
1142 
1143     //this method is responsible for taking all fee, if takeFee is true
1144     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1145         if(!takeFee)
1146             removeAllFee();
1147         
1148         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1149             _transferFromExcluded(sender, recipient, amount);
1150         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1151             _transferToExcluded(sender, recipient, amount);
1152         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1153             _transferStandard(sender, recipient, amount);
1154         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1155             _transferBothExcluded(sender, recipient, amount);
1156         } else {
1157             _transferStandard(sender, recipient, amount);
1158         }
1159         
1160         if(!takeFee)
1161             restoreAllFee();
1162     }
1163 
1164     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1165         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1166         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1167         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1168         _takeLiquidity(tLiquidity);
1169         _reflectFee(rFee, tFee);
1170         emit Transfer(sender, recipient, tTransferAmount);
1171     }
1172 
1173     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1174         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1175         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1176         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1177         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1178         _takeLiquidity(tLiquidity);
1179         _reflectFee(rFee, tFee);
1180         emit Transfer(sender, recipient, tTransferAmount);
1181     }
1182 
1183     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1185         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1186         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1187         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1188         _takeLiquidity(tLiquidity);
1189         _reflectFee(rFee, tFee);
1190         emit Transfer(sender, recipient, tTransferAmount);
1191     }
1192 }