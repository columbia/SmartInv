1 /*
2 
3 */
4 
5 pragma solidity ^0.6.12;
6 // SPDX-License-Identifier: Unlicensed
7 interface IERC20 {
8 
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91  
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address payable) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes memory) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 contract Ownable is Context {
398     address private _owner;
399     address private _previousOwner;
400     uint256 private _lockTime;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor () internal {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view returns (address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         require(_owner == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428      /**
429      * @dev Leaves the contract without owner. It will not be possible to call
430      * `onlyOwner` functions anymore. Can only be called by the current owner.
431      *
432      * NOTE: Renouncing ownership will leave the contract without an owner,
433      * thereby removing any functionality that is only available to the owner.
434      */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 
450 }
451 
452 // pragma solidity >=0.5.0;
453 
454 interface IUniswapV2Factory {
455     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
456 
457     function feeTo() external view returns (address);
458     function feeToSetter() external view returns (address);
459 
460     function getPair(address tokenA, address tokenB) external view returns (address pair);
461     function allPairs(uint) external view returns (address pair);
462     function allPairsLength() external view returns (uint);
463 
464     function createPair(address tokenA, address tokenB) external returns (address pair);
465 
466     function setFeeTo(address) external;
467     function setFeeToSetter(address) external;
468 }
469 
470 
471 // pragma solidity >=0.5.0;
472 
473 interface IUniswapV2Pair {
474     event Approval(address indexed owner, address indexed spender, uint value);
475     event Transfer(address indexed from, address indexed to, uint value);
476 
477     function name() external pure returns (string memory);
478     function symbol() external pure returns (string memory);
479     function decimals() external pure returns (uint8);
480     function totalSupply() external view returns (uint);
481     function balanceOf(address owner) external view returns (uint);
482     function allowance(address owner, address spender) external view returns (uint);
483 
484     function approve(address spender, uint value) external returns (bool);
485     function transfer(address to, uint value) external returns (bool);
486     function transferFrom(address from, address to, uint value) external returns (bool);
487 
488     function DOMAIN_SEPARATOR() external view returns (bytes32);
489     function PERMIT_TYPEHASH() external pure returns (bytes32);
490     function nonces(address owner) external view returns (uint);
491 
492     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
493 
494     event Mint(address indexed sender, uint amount0, uint amount1);
495     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
496     event Swap(
497         address indexed sender,
498         uint amount0In,
499         uint amount1In,
500         uint amount0Out,
501         uint amount1Out,
502         address indexed to
503     );
504     event Sync(uint112 reserve0, uint112 reserve1);
505 
506     function MINIMUM_LIQUIDITY() external pure returns (uint);
507     function factory() external view returns (address);
508     function token0() external view returns (address);
509     function token1() external view returns (address);
510     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
511     function price0CumulativeLast() external view returns (uint);
512     function price1CumulativeLast() external view returns (uint);
513     function kLast() external view returns (uint);
514 
515     function mint(address to) external returns (uint liquidity);
516     function burn(address to) external returns (uint amount0, uint amount1);
517     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
518     function skim(address to) external;
519     function sync() external;
520 
521     function initialize(address, address) external;
522 }
523 
524 // pragma solidity >=0.6.2;
525 
526 interface IUniswapV2Router01 {
527     function factory() external pure returns (address);
528     function WETH() external pure returns (address);
529 
530     function addLiquidity(
531         address tokenA,
532         address tokenB,
533         uint amountADesired,
534         uint amountBDesired,
535         uint amountAMin,
536         uint amountBMin,
537         address to,
538         uint deadline
539     ) external returns (uint amountA, uint amountB, uint liquidity);
540     function addLiquidityETH(
541         address token,
542         uint amountTokenDesired,
543         uint amountTokenMin,
544         uint amountETHMin,
545         address to,
546         uint deadline
547     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
548     function removeLiquidity(
549         address tokenA,
550         address tokenB,
551         uint liquidity,
552         uint amountAMin,
553         uint amountBMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountA, uint amountB);
557     function removeLiquidityETH(
558         address token,
559         uint liquidity,
560         uint amountTokenMin,
561         uint amountETHMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountToken, uint amountETH);
565     function removeLiquidityWithPermit(
566         address tokenA,
567         address tokenB,
568         uint liquidity,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline,
573         bool approveMax, uint8 v, bytes32 r, bytes32 s
574     ) external returns (uint amountA, uint amountB);
575     function removeLiquidityETHWithPermit(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external returns (uint amountToken, uint amountETH);
584     function swapExactTokensForTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external returns (uint[] memory amounts);
591     function swapTokensForExactTokens(
592         uint amountOut,
593         uint amountInMax,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external returns (uint[] memory amounts);
598     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
599         external
600         payable
601         returns (uint[] memory amounts);
602     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
603         external
604         returns (uint[] memory amounts);
605     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
606         external
607         returns (uint[] memory amounts);
608     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
609         external
610         payable
611         returns (uint[] memory amounts);
612 
613     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
614     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
615     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
616     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
617     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
618 }
619 
620 
621 
622 // pragma solidity >=0.6.2;
623 
624 interface IUniswapV2Router02 is IUniswapV2Router01 {
625     function removeLiquidityETHSupportingFeeOnTransferTokens(
626         address token,
627         uint liquidity,
628         uint amountTokenMin,
629         uint amountETHMin,
630         address to,
631         uint deadline
632     ) external returns (uint amountETH);
633     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
634         address token,
635         uint liquidity,
636         uint amountTokenMin,
637         uint amountETHMin,
638         address to,
639         uint deadline,
640         bool approveMax, uint8 v, bytes32 r, bytes32 s
641     ) external returns (uint amountETH);
642 
643     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650     function swapExactETHForTokensSupportingFeeOnTransferTokens(
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external payable;
656     function swapExactTokensForETHSupportingFeeOnTransferTokens(
657         uint amountIn,
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external;
663 }
664 
665 
666 contract UniApe is Context, IERC20, Ownable {
667     using SafeMath for uint256;
668     using Address for address;
669 
670     mapping (address => uint256) private _rOwned;
671     mapping (address => uint256) private _tOwned;
672     mapping (address => mapping (address => uint256)) private _allowances;
673 
674     mapping (address => bool) private _isExcludedFromFee;
675 
676     mapping (address => bool) private _isExcluded;
677     address[] private _excluded;
678     
679     mapping (address => bool) private _isBlackListedBot;
680     address[] private _blackListedBots;
681    
682     uint256 private constant MAX = ~uint256(0);
683     uint256 private _tTotal = 2000000 * 10**6 * 10**9;
684     uint256 private _rTotal = (MAX - (MAX % _tTotal));
685     uint256 private _tFeeTotal;
686 
687     string private _name = "Uni Ape";
688     string private _symbol = "uApe";
689     uint8 private _decimals = 9;
690     
691     uint256 public _taxFee = 0;
692     uint256 private _previousTaxFee = _taxFee;
693     
694     uint256 public _liquidityFee = 0;
695     uint256 private _previousLiquidityFee = _liquidityFee;
696 
697     IUniswapV2Router02 public immutable uniswapV2Router;
698     address public immutable uniswapV2Pair;
699     
700     bool inSwapAndLiquify;
701     bool public swapAndLiquifyEnabled = false;
702     
703     uint256 public _maxTxAmount = 2000000 * 10**6 * 10**9;
704     uint256 private numTokensSellToAddToLiquidity = 500 * 10**6 * 10**9;
705     
706     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
707     event SwapAndLiquifyEnabledUpdated(bool enabled);
708     event SwapAndLiquify(
709         uint256 tokensSwapped,
710         uint256 ethReceived,
711         uint256 tokensIntoLiqudity
712     );
713     
714     modifier lockTheSwap {
715         inSwapAndLiquify = true;
716         _;
717         inSwapAndLiquify = false;
718     }
719     
720     constructor () public {
721         _rOwned[_msgSender()] = _rTotal;
722         
723         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
724          // Create a uniswap pair for this new token
725         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
726             .createPair(address(this), _uniswapV2Router.WETH());
727 
728         // set the rest of the contract variables
729         uniswapV2Router = _uniswapV2Router;
730         
731         //exclude owner and this contract from fee
732         _isExcludedFromFee[owner()] = true;
733         _isExcludedFromFee[address(this)] = true;
734         
735         emit Transfer(address(0), _msgSender(), _tTotal);
736     }
737 
738     function name() public view returns (string memory) {
739         return _name;
740     }
741 
742     function symbol() public view returns (string memory) {
743         return _symbol;
744     }
745 
746     function decimals() public view returns (uint8) {
747         return _decimals;
748     }
749 
750     function totalSupply() public view override returns (uint256) {
751         return _tTotal;
752     }
753 
754     function balanceOf(address account) public view override returns (uint256) {
755         if (_isExcluded[account]) return _tOwned[account];
756         return tokenFromReflection(_rOwned[account]);
757     }
758 
759     function transfer(address recipient, uint256 amount) public override returns (bool) {
760         _transfer(_msgSender(), recipient, amount);
761         return true;
762     }
763 
764     function allowance(address owner, address spender) public view override returns (uint256) {
765         return _allowances[owner][spender];
766     }
767 
768     function approve(address spender, uint256 amount) public override returns (bool) {
769         _approve(_msgSender(), spender, amount);
770         return true;
771     }
772 
773     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
774         _transfer(sender, recipient, amount);
775         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
776         return true;
777     }
778 
779     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
780         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
781         return true;
782     }
783 
784     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
785         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
786         return true;
787     }
788 
789     function isExcludedFromReward(address account) public view returns (bool) {
790         return _isExcluded[account];
791     }
792 
793     function totalFees() public view returns (uint256) {
794         return _tFeeTotal;
795     }
796 
797     function deliver(uint256 tAmount) public {
798         address sender = _msgSender();
799         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
800         (uint256 rAmount,,,,,) = _getValues(tAmount);
801         _rOwned[sender] = _rOwned[sender].sub(rAmount);
802         _rTotal = _rTotal.sub(rAmount);
803         _tFeeTotal = _tFeeTotal.add(tAmount);
804     }
805 
806     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
807         require(tAmount <= _tTotal, "Amount must be less than supply");
808         if (!deductTransferFee) {
809             (uint256 rAmount,,,,,) = _getValues(tAmount);
810             return rAmount;
811         } else {
812             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
813             return rTransferAmount;
814         }
815     }
816 
817     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
818         require(rAmount <= _rTotal, "Amount must be less than total reflections");
819         uint256 currentRate =  _getRate();
820         return rAmount.div(currentRate);
821     }
822 
823     function excludeFromReward(address account) public onlyOwner() {
824         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
825         require(!_isExcluded[account], "Account is already excluded");
826         if(_rOwned[account] > 0) {
827             _tOwned[account] = tokenFromReflection(_rOwned[account]);
828         }
829         _isExcluded[account] = true;
830         _excluded.push(account);
831     }
832 
833     function includeInReward(address account) external onlyOwner() {
834         require(_isExcluded[account], "Account is already excluded");
835         for (uint256 i = 0; i < _excluded.length; i++) {
836             if (_excluded[i] == account) {
837                 _excluded[i] = _excluded[_excluded.length - 1];
838                 _tOwned[account] = 0;
839                 _isExcluded[account] = false;
840                 _excluded.pop();
841                 break;
842             }
843         }
844     }
845     
846     function addBotToBlackList(address account) external onlyOwner() {
847         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
848         require(!_isBlackListedBot[account], "Account is already blacklisted");
849         _isBlackListedBot[account] = true;
850         _blackListedBots.push(account);
851     }
852 
853     function removeBotFromBlackList(address account) external onlyOwner() {
854         require(_isBlackListedBot[account], "Account is not blacklisted");
855         for (uint256 i = 0; i < _blackListedBots.length; i++) {
856             if (_blackListedBots[i] == account) {
857                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
858                 _isBlackListedBot[account] = false;
859                 _blackListedBots.pop();
860                 break;
861             }
862         }
863     }
864         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
865         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
866         _tOwned[sender] = _tOwned[sender].sub(tAmount);
867         _rOwned[sender] = _rOwned[sender].sub(rAmount);
868         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
869         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
870         _takeLiquidity(tLiquidity);
871         _reflectFee(rFee, tFee);
872         emit Transfer(sender, recipient, tTransferAmount);
873     }
874     
875         function excludeFromFee(address account) public onlyOwner {
876         _isExcludedFromFee[account] = true;
877     }
878     
879     function includeInFee(address account) public onlyOwner {
880         _isExcludedFromFee[account] = false;
881     }
882     
883     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
884         _taxFee = taxFee;
885     }
886     
887     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
888         _liquidityFee = liquidityFee;
889     }
890    
891     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
892         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
893             10**2
894         );
895     }
896 
897     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
898         swapAndLiquifyEnabled = _enabled;
899         emit SwapAndLiquifyEnabledUpdated(_enabled);
900     }
901     
902      //to recieve ETH from uniswapV2Router when swaping
903     receive() external payable {}
904 
905     function _reflectFee(uint256 rFee, uint256 tFee) private {
906         _rTotal = _rTotal.sub(rFee);
907         _tFeeTotal = _tFeeTotal.add(tFee);
908     }
909 
910     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
911         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
912         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
913         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
914     }
915 
916     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
917         uint256 tFee = calculateTaxFee(tAmount);
918         uint256 tLiquidity = calculateLiquidityFee(tAmount);
919         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
920         return (tTransferAmount, tFee, tLiquidity);
921     }
922 
923     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
924         uint256 rAmount = tAmount.mul(currentRate);
925         uint256 rFee = tFee.mul(currentRate);
926         uint256 rLiquidity = tLiquidity.mul(currentRate);
927         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
928         return (rAmount, rTransferAmount, rFee);
929     }
930 
931     function _getRate() private view returns(uint256) {
932         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
933         return rSupply.div(tSupply);
934     }
935 
936     function _getCurrentSupply() private view returns(uint256, uint256) {
937         uint256 rSupply = _rTotal;
938         uint256 tSupply = _tTotal;      
939         for (uint256 i = 0; i < _excluded.length; i++) {
940             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
941             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
942             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
943         }
944         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
945         return (rSupply, tSupply);
946     }
947     
948     function _takeLiquidity(uint256 tLiquidity) private {
949         uint256 currentRate =  _getRate();
950         uint256 rLiquidity = tLiquidity.mul(currentRate);
951         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
952         if(_isExcluded[address(this)])
953             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
954     }
955     
956     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
957         return _amount.mul(_taxFee).div(
958             10**2
959         );
960     }
961 
962     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
963         return _amount.mul(_liquidityFee).div(
964             10**2
965         );
966     }
967     
968     function removeAllFee() private {
969         if(_taxFee == 0 && _liquidityFee == 0) return;
970         
971         _previousTaxFee = _taxFee;
972         _previousLiquidityFee = _liquidityFee;
973         
974         _taxFee = 0;
975         _liquidityFee = 0;
976     }
977     
978     function restoreAllFee() private {
979         _taxFee = _previousTaxFee;
980         _liquidityFee = _previousLiquidityFee;
981     }
982     
983     function isExcludedFromFee(address account) public view returns(bool) {
984         return _isExcludedFromFee[account];
985     }
986 
987     function _approve(address owner, address spender, uint256 amount) private {
988         require(owner != address(0), "ERC20: approve from the zero address");
989         require(spender != address(0), "ERC20: approve to the zero address");
990 
991         _allowances[owner][spender] = amount;
992         emit Approval(owner, spender, amount);
993     }
994 
995     function _transfer(
996         address from,
997         address to,
998         uint256 amount
999     ) private {
1000         require(from != address(0), "ERC20: transfer from the zero address");
1001         require(to != address(0), "ERC20: transfer to the zero address");
1002         require(amount > 0, "Transfer amount must be greater than zero");
1003         if(from != owner() && to != owner())
1004             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1005 
1006         // is the token balance of this contract address over the min number of
1007         // tokens that we need to initiate a swap + liquidity lock?
1008         // also, don't get caught in a circular liquidity event.
1009         // also, don't swap & liquify if sender is uniswap pair.
1010         uint256 contractTokenBalance = balanceOf(address(this));
1011         
1012         if(contractTokenBalance >= _maxTxAmount)
1013         {
1014             contractTokenBalance = _maxTxAmount;
1015         }
1016         
1017         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1018         if (
1019             overMinTokenBalance &&
1020             !inSwapAndLiquify &&
1021             from != uniswapV2Pair &&
1022             swapAndLiquifyEnabled
1023         ) {
1024             contractTokenBalance = numTokensSellToAddToLiquidity;
1025             //add liquidity
1026             swapAndLiquify(contractTokenBalance);
1027         }
1028         
1029         //indicates if fee should be deducted from transfer
1030         bool takeFee = true;
1031         
1032         //if any account belongs to _isExcludedFromFee account then remove the fee
1033         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1034             takeFee = false;
1035         }
1036         
1037         //transfer amount, it will take tax, burn, liquidity fee
1038         _tokenTransfer(from,to,amount,takeFee);
1039     }
1040 
1041     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1042         // split the contract balance into halves
1043         uint256 half = contractTokenBalance.div(2);
1044         uint256 otherHalf = contractTokenBalance.sub(half);
1045 
1046         // capture the contract's current ETH balance.
1047         // this is so that we can capture exactly the amount of ETH that the
1048         // swap creates, and not make the liquidity event include any ETH that
1049         // has been manually sent to the contract
1050         uint256 initialBalance = address(this).balance;
1051 
1052         // swap tokens for ETH
1053         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1054 
1055         // how much ETH did we just swap into?
1056         uint256 newBalance = address(this).balance.sub(initialBalance);
1057 
1058         // add liquidity to uniswap
1059         addLiquidity(otherHalf, newBalance);
1060         
1061         emit SwapAndLiquify(half, newBalance, otherHalf);
1062     }
1063 
1064     function swapTokensForEth(uint256 tokenAmount) private {
1065         // generate the uniswap pair path of token -> weth
1066         address[] memory path = new address[](2);
1067         path[0] = address(this);
1068         path[1] = uniswapV2Router.WETH();
1069 
1070         _approve(address(this), address(uniswapV2Router), tokenAmount);
1071 
1072         // make the swap
1073         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1074             tokenAmount,
1075             0, // accept any amount of ETH
1076             path,
1077             address(this),
1078             block.timestamp
1079         );
1080     }
1081 
1082     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1083         // approve token transfer to cover all possible scenarios
1084         _approve(address(this), address(uniswapV2Router), tokenAmount);
1085 
1086         // add the liquidity
1087         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1088             address(this),
1089             tokenAmount,
1090             0, // slippage is unavoidable
1091             0, // slippage is unavoidable
1092             owner(),
1093             block.timestamp
1094         );
1095     }
1096 
1097     //this method is responsible for taking all fee, if takeFee is true
1098     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1099         if(!takeFee)
1100             removeAllFee();
1101         
1102         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1103             _transferFromExcluded(sender, recipient, amount);
1104         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1105             _transferToExcluded(sender, recipient, amount);
1106         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1107             _transferStandard(sender, recipient, amount);
1108         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1109             _transferBothExcluded(sender, recipient, amount);
1110         } else {
1111             _transferStandard(sender, recipient, amount);
1112         }
1113         
1114         if(!takeFee)
1115             restoreAllFee();
1116     }
1117 
1118     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1119         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1120         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1121         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1122         _takeLiquidity(tLiquidity);
1123         _reflectFee(rFee, tFee);
1124         emit Transfer(sender, recipient, tTransferAmount);
1125     }
1126 
1127     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1128         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1129         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1130         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1131         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1132         _takeLiquidity(tLiquidity);
1133         _reflectFee(rFee, tFee);
1134         emit Transfer(sender, recipient, tTransferAmount);
1135     }
1136 
1137     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1138         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1139         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1140         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1141         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1142         _takeLiquidity(tLiquidity);
1143         _reflectFee(rFee, tFee);
1144         emit Transfer(sender, recipient, tTransferAmount);
1145     }
1146 
1147 
1148     
1149 
1150 }