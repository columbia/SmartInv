1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: Unlicensed
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     /**
8      * @dev Returns the amount of tokens owned by `account`.
9      */
10     function balanceOf(address account) external view returns (uint256);
11 
12     /**
13      * @dev Moves `amount` tokens from the caller's account to `recipient`.
14      *
15      * Returns a boolean value indicating whether the operation succeeded.
16      *
17      * Emits a {Transfer} event.
18      */
19     function transfer(address recipient, uint256 amount) external returns (bool);
20 
21     /**
22      * @dev Returns the remaining number of tokens that `spender` will be
23      * allowed to spend on behalf of `owner` through {transferFrom}. This is
24      * zero by default.
25      *
26      * This value changes when {approve} or {transferFrom} are called.
27      */
28     function allowance(address owner, address spender) external view returns (uint256);
29 
30     /**
31      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * IMPORTANT: Beware that changing an allowance with this method brings the risk
36      * that someone may use both the old and the new allowance by unfortunate
37      * transaction ordering. One possible solution to mitigate this race
38      * condition is to first reduce the spender's allowance to 0 and set the
39      * desired value afterwards:
40      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
41      *
42      * Emits an {Approval} event.
43      */
44     function approve(address spender, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Moves `amount` tokens from `sender` to `recipient` using the
48      * allowance mechanism. `amount` is then deducted from the caller's
49      * allowance.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Emitted when `value` tokens are moved from one account (`from`) to
59      * another (`to`).
60      *
61      * Note that `value` may be zero.
62      */
63     event Transfer(address indexed from, address indexed to, uint256 value);
64 
65     /**
66      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
67      * a call to {approve}. `value` is the new allowance.
68      */
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 }
71 
72 
73 
74 /**
75  * @dev Wrappers over Solidity's arithmetic operations with added overflow
76  * checks.
77  *
78  * Arithmetic operations in Solidity wrap on overflow. This can easily result
79  * in bugs, because programmers usually assume that an overflow raises an
80  * error, which is the standard behavior in high level programming languages.
81  * `SafeMath` restores this intuition by reverting the transaction when an
82  * operation overflows.
83  *
84  * Using this library instead of the unchecked operations eliminates an entire
85  * class of bugs, so it's recommended to use it always.
86  */
87  
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 abstract contract Context {
232     function _msgSender() internal view virtual returns (address payable) {
233         return msg.sender;
234     }
235 
236     function _msgData() internal view virtual returns (bytes memory) {
237         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
238         return msg.data;
239     }
240 }
241 
242 
243 /**
244  * @dev Collection of functions related to the address type
245  */
246 library Address {
247     /**
248      * @dev Returns true if `account` is a contract.
249      *
250      * [IMPORTANT]
251      * ====
252      * It is unsafe to assume that an address for which this function returns
253      * false is an externally-owned account (EOA) and not a contract.
254      *
255      * Among others, `isContract` will return false for the following
256      * types of addresses:
257      *
258      *  - an externally-owned account
259      *  - a contract in construction
260      *  - an address where a contract will be created
261      *  - an address where a contract lived, but was destroyed
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
266         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
267         // for accounts without code, i.e. `keccak256('')`
268         bytes32 codehash;
269         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
270         // solhint-disable-next-line no-inline-assembly
271         assembly { codehash := extcodehash(account) }
272         return (codehash != accountHash && codehash != 0x0);
273     }
274 
275     /**
276      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
277      * `recipient`, forwarding all available gas and reverting on errors.
278      *
279      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
280      * of certain opcodes, possibly making contracts go over the 2300 gas limit
281      * imposed by `transfer`, making them unable to receive funds via
282      * `transfer`. {sendValue} removes this limitation.
283      *
284      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
285      *
286      * IMPORTANT: because control is transferred to `recipient`, care must be
287      * taken to not create reentrancy vulnerabilities. Consider using
288      * {ReentrancyGuard} or the
289      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
290      */
291     function sendValue(address payable recipient, uint256 amount) internal {
292         require(address(this).balance >= amount, "Address: insufficient balance");
293 
294         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
295         (bool success, ) = recipient.call{ value: amount }("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain`call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318       return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
328         return _functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
343         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
348      * with `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
353         require(address(this).balance >= value, "Address: insufficient balance for call");
354         return _functionCallWithValue(target, data, value, errorMessage);
355     }
356 
357     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
358         require(isContract(target), "Address: call to non-contract");
359 
360         // solhint-disable-next-line avoid-low-level-calls
361         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
362         if (success) {
363             return returndata;
364         } else {
365             // Look for revert reason and bubble it up if present
366             if (returndata.length > 0) {
367                 // The easiest way to bubble the revert reason is using memory via assembly
368 
369                 // solhint-disable-next-line no-inline-assembly
370                 assembly {
371                     let returndata_size := mload(returndata)
372                     revert(add(32, returndata), returndata_size)
373                 }
374             } else {
375                 revert(errorMessage);
376             }
377         }
378     }
379 }
380 
381 /**
382  * @dev Contract module which provides a basic access control mechanism, where
383  * there is an account (an owner) that can be granted exclusive access to
384  * specific functions.
385  *
386  * By default, the owner account will be the one that deploys the contract. This
387  * can later be changed with {transferOwnership}.
388  *
389  * This module is used through inheritance. It will make available the modifier
390  * `onlyOwner`, which can be applied to your functions to restrict their use to
391  * the owner.
392  */
393 contract Ownable is Context {
394     address private _owner;
395     address private _previousOwner;
396     uint256 private _lockTime;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399 
400     /**
401      * @dev Initializes the contract setting the deployer as the initial owner.
402      */
403     constructor () internal {
404         address msgSender = _msgSender();
405         _owner = msgSender;
406         emit OwnershipTransferred(address(0), msgSender);
407     }
408 
409     /**
410      * @dev Returns the address of the current owner.
411      */
412     function owner() public view returns (address) {
413         return _owner;
414     }
415 
416     /**
417      * @dev Throws if called by any account other than the owner.
418      */
419     modifier onlyOwner() {
420         require(_owner == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424      /**
425      * @dev Leaves the contract without owner. It will not be possible to call
426      * `onlyOwner` functions anymore. Can only be called by the current owner.
427      *
428      * NOTE: Renouncing ownership will leave the contract without an owner,
429      * thereby removing any functionality that is only available to the owner.
430      */
431     function renounceOwnership() public virtual onlyOwner {
432         emit OwnershipTransferred(_owner, address(0));
433         _owner = address(0);
434     }
435 
436     /**
437      * @dev Transfers ownership of the contract to a new account (`newOwner`).
438      * Can only be called by the current owner.
439      */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 
446 }
447 
448 // pragma solidity >=0.5.0;
449 
450 interface IUniswapV2Factory {
451     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
452 
453     function feeTo() external view returns (address);
454     function feeToSetter() external view returns (address);
455 
456     function getPair(address tokenA, address tokenB) external view returns (address pair);
457     function allPairs(uint) external view returns (address pair);
458     function allPairsLength() external view returns (uint);
459 
460     function createPair(address tokenA, address tokenB) external returns (address pair);
461 
462     function setFeeTo(address) external;
463     function setFeeToSetter(address) external;
464 }
465 
466 
467 // pragma solidity >=0.5.0;
468 
469 interface IUniswapV2Pair {
470     event Approval(address indexed owner, address indexed spender, uint value);
471     event Transfer(address indexed from, address indexed to, uint value);
472 
473     function name() external pure returns (string memory);
474     function symbol() external pure returns (string memory);
475     function decimals() external pure returns (uint8);
476     function totalSupply() external view returns (uint);
477     function balanceOf(address owner) external view returns (uint);
478     function allowance(address owner, address spender) external view returns (uint);
479 
480     function approve(address spender, uint value) external returns (bool);
481     function transfer(address to, uint value) external returns (bool);
482     function transferFrom(address from, address to, uint value) external returns (bool);
483 
484     function DOMAIN_SEPARATOR() external view returns (bytes32);
485     function PERMIT_TYPEHASH() external pure returns (bytes32);
486     function nonces(address owner) external view returns (uint);
487 
488     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
489 
490     event Mint(address indexed sender, uint amount0, uint amount1);
491     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
492     event Swap(
493         address indexed sender,
494         uint amount0In,
495         uint amount1In,
496         uint amount0Out,
497         uint amount1Out,
498         address indexed to
499     );
500     event Sync(uint112 reserve0, uint112 reserve1);
501 
502     function MINIMUM_LIQUIDITY() external pure returns (uint);
503     function factory() external view returns (address);
504     function token0() external view returns (address);
505     function token1() external view returns (address);
506     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
507     function price0CumulativeLast() external view returns (uint);
508     function price1CumulativeLast() external view returns (uint);
509     function kLast() external view returns (uint);
510 
511     function mint(address to) external returns (uint liquidity);
512     function burn(address to) external returns (uint amount0, uint amount1);
513     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
514     function skim(address to) external;
515     function sync() external;
516 
517     function initialize(address, address) external;
518 }
519 
520 // pragma solidity >=0.6.2;
521 
522 interface IUniswapV2Router01 {
523     function factory() external pure returns (address);
524     function WETH() external pure returns (address);
525 
526     function addLiquidity(
527         address tokenA,
528         address tokenB,
529         uint amountADesired,
530         uint amountBDesired,
531         uint amountAMin,
532         uint amountBMin,
533         address to,
534         uint deadline
535     ) external returns (uint amountA, uint amountB, uint liquidity);
536     function addLiquidityETH(
537         address token,
538         uint amountTokenDesired,
539         uint amountTokenMin,
540         uint amountETHMin,
541         address to,
542         uint deadline
543     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
544     function removeLiquidity(
545         address tokenA,
546         address tokenB,
547         uint liquidity,
548         uint amountAMin,
549         uint amountBMin,
550         address to,
551         uint deadline
552     ) external returns (uint amountA, uint amountB);
553     function removeLiquidityETH(
554         address token,
555         uint liquidity,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline
560     ) external returns (uint amountToken, uint amountETH);
561     function removeLiquidityWithPermit(
562         address tokenA,
563         address tokenB,
564         uint liquidity,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline,
569         bool approveMax, uint8 v, bytes32 r, bytes32 s
570     ) external returns (uint amountA, uint amountB);
571     function removeLiquidityETHWithPermit(
572         address token,
573         uint liquidity,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline,
578         bool approveMax, uint8 v, bytes32 r, bytes32 s
579     ) external returns (uint amountToken, uint amountETH);
580     function swapExactTokensForTokens(
581         uint amountIn,
582         uint amountOutMin,
583         address[] calldata path,
584         address to,
585         uint deadline
586     ) external returns (uint[] memory amounts);
587     function swapTokensForExactTokens(
588         uint amountOut,
589         uint amountInMax,
590         address[] calldata path,
591         address to,
592         uint deadline
593     ) external returns (uint[] memory amounts);
594     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
595         external
596         payable
597         returns (uint[] memory amounts);
598     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
599         external
600         returns (uint[] memory amounts);
601     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
602         external
603         returns (uint[] memory amounts);
604     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
605         external
606         payable
607         returns (uint[] memory amounts);
608 
609     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
610     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
611     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
612     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
613     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
614 }
615 
616 
617 
618 // pragma solidity >=0.6.2;
619 
620 interface IUniswapV2Router02 is IUniswapV2Router01 {
621     function removeLiquidityETHSupportingFeeOnTransferTokens(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline
628     ) external returns (uint amountETH);
629     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
630         address token,
631         uint liquidity,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline,
636         bool approveMax, uint8 v, bytes32 r, bytes32 s
637     ) external returns (uint amountETH);
638 
639     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external;
646     function swapExactETHForTokensSupportingFeeOnTransferTokens(
647         uint amountOutMin,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external payable;
652     function swapExactTokensForETHSupportingFeeOnTransferTokens(
653         uint amountIn,
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external;
659 }
660 
661 
662 contract IRS is Context, IERC20, Ownable {
663     using SafeMath for uint256;
664     using Address for address;
665 
666     mapping (address => uint256) private _rOwned;
667     mapping (address => uint256) private _tOwned;
668     mapping (address => mapping (address => uint256)) private _allowances;
669 
670     mapping (address => bool) private _isExcludedFromFee;
671 
672     mapping (address => bool) private _isExcluded;
673     address[] private _excluded;
674     
675     mapping (address => bool) private _isBlackListedBot;
676     address[] private _blackListedBots;
677     
678    
679     uint256 private constant MAX = ~uint256(0);
680 
681     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
682     uint256 private _rTotal = (MAX - (MAX % _tTotal));
683     uint256 private _tFeeTotal;
684 
685 
686     string private _name = "Internal Retard Services";
687     string private _symbol = "IRS";
688     uint8 private _decimals = 9;
689     
690     uint256 public _taxFee = 0;
691     uint256 private _previousTaxFee = _taxFee;
692 
693     uint256 public _liquidityFee = 0;
694     uint256 private _previousLiquidityFee = _liquidityFee;
695 
696     address payable public _devWalletAddress;
697 
698     IUniswapV2Router02 public immutable uniswapV2Router;
699     address public immutable uniswapV2Pair;
700     
701     bool inSwapAndLiquify;
702     bool public swapAndLiquifyEnabled = false;
703     
704     uint256 public _maxTxAmount = 1000000 * 10**6 * 10**9;
705     uint256 private numTokensSellToAddToLiquidity = 500 * 10**6 * 10**9;
706     
707     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
708     event SwapAndLiquifyEnabledUpdated(bool enabled);
709     event SwapAndLiquify(
710         uint256 tokensSwapped,
711         uint256 ethReceived
712     );
713     
714     modifier lockTheSwap {
715         inSwapAndLiquify = true;
716         _;
717         inSwapAndLiquify = false;
718     }
719     
720     constructor (address payable devWalletAddress) public {
721         _devWalletAddress = devWalletAddress;
722         _rOwned[_msgSender()] = _rTotal;
723         
724         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
725          // Create a uniswap pair for this new token
726         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
727             .createPair(address(this), _uniswapV2Router.WETH());
728 
729         // set the rest of the contract variables
730         uniswapV2Router = _uniswapV2Router;
731         
732         //exclude owner and this contract from fee
733         _isExcludedFromFee[owner()] = true;
734         _isExcludedFromFee[address(this)] = true;
735         
736         emit Transfer(address(0), _msgSender(), _tTotal);
737     }
738 
739     function name() public view returns (string memory) {
740         return _name;
741     }
742 
743     function symbol() public view returns (string memory) {
744         return _symbol;
745     }
746 
747     function decimals() public view returns (uint8) {
748         return _decimals;
749     }
750     
751     function setDevFeeDisabled(bool _devFeeEnabled ) public returns (bool){
752         require(msg.sender == _devWalletAddress, "Only Dev Address can disable dev fee");
753         swapAndLiquifyEnabled = _devFeeEnabled;
754         return(swapAndLiquifyEnabled);
755     }
756 
757     function totalSupply() public view override returns (uint256) {
758         return _tTotal;
759     }
760 
761     function balanceOf(address account) public view override returns (uint256) {
762         if (_isExcluded[account]) return _tOwned[account];
763         return tokenFromReflection(_rOwned[account]);
764     }
765 
766     function transfer(address recipient, uint256 amount) public override returns (bool) {
767         _transfer(_msgSender(), recipient, amount);
768         return true;
769     }
770 
771     function allowance(address owner, address spender) public view override returns (uint256) {
772         return _allowances[owner][spender];
773     }
774 
775     function approve(address spender, uint256 amount) public override returns (bool) {
776         _approve(_msgSender(), spender, amount);
777         return true;
778     }
779 
780     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
781         _transfer(sender, recipient, amount);
782         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
783         return true;
784     }
785 
786     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
787         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
788         return true;
789     }
790 
791     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
792         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
793         return true;
794     }
795 
796     function isExcludedFromReward(address account) public view returns (bool) {
797         return _isExcluded[account];
798     }
799 
800     function totalFees() public view returns (uint256) {
801         return _tFeeTotal;
802     }
803 
804     function deliver(uint256 tAmount) public {
805         address sender = _msgSender();
806         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
807         (uint256 rAmount,,,,,) = _getValues(tAmount);
808         _rOwned[sender] = _rOwned[sender].sub(rAmount);
809         _rTotal = _rTotal.sub(rAmount);
810         _tFeeTotal = _tFeeTotal.add(tAmount);
811     }
812 
813     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
814         require(tAmount <= _tTotal, "Amount must be less than supply");
815         if (!deductTransferFee) {
816             (uint256 rAmount,,,,,) = _getValues(tAmount);
817             return rAmount;
818         } else {
819             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
820             return rTransferAmount;
821         }
822     }
823 
824     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
825         require(rAmount <= _rTotal, "Amount must be less than total reflections");
826         uint256 currentRate =  _getRate();
827         return rAmount.div(currentRate);
828     }
829 
830     function excludeFromReward(address account) public onlyOwner() {
831         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
832         require(!_isExcluded[account], "Account is already excluded");
833         if(_rOwned[account] > 0) {
834             _tOwned[account] = tokenFromReflection(_rOwned[account]);
835         }
836         _isExcluded[account] = true;
837         _excluded.push(account);
838     }
839 
840     function includeInReward(address account) external onlyOwner() {
841         require(_isExcluded[account], "Account is already excluded");
842         for (uint256 i = 0; i < _excluded.length; i++) {
843             if (_excluded[i] == account) {
844                 _excluded[i] = _excluded[_excluded.length - 1];
845                 _tOwned[account] = 0;
846                 _isExcluded[account] = false;
847                 _excluded.pop();
848                 break;
849             }
850         }
851     }
852         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
853         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
854         _tOwned[sender] = _tOwned[sender].sub(tAmount);
855         _rOwned[sender] = _rOwned[sender].sub(rAmount);
856         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
857         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
858         _takeLiquidity(tLiquidity);
859         _reflectFee(rFee, tFee);
860         emit Transfer(sender, recipient, tTransferAmount);
861     }
862     
863         function excludeFromFee(address account) public onlyOwner {
864         _isExcludedFromFee[account] = true;
865     }
866     
867     function includeInFee(address account) public onlyOwner {
868         _isExcludedFromFee[account] = false;
869     }
870     
871     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
872         _taxFee = taxFee;
873     }
874     
875     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
876         _liquidityFee = liquidityFee;
877     }
878     
879     function _setdevWallet(address payable devWalletAddress) external onlyOwner() {
880         _devWalletAddress = devWalletAddress;
881     }
882     
883     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
884         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
885             10**2
886         );
887     }
888 
889     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
890         swapAndLiquifyEnabled = _enabled;
891         emit SwapAndLiquifyEnabledUpdated(_enabled);
892     }
893     
894      //to recieve ETH from uniswapV2Router when swaping
895     receive() external payable {}
896 
897     function _reflectFee(uint256 rFee, uint256 tFee) private {
898         _rTotal = _rTotal.sub(rFee);
899         _tFeeTotal = _tFeeTotal.add(tFee);
900     }
901 
902     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
903         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
904         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
905         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
906     }
907 
908     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
909         uint256 tFee = calculateTaxFee(tAmount);
910         uint256 tLiquidity = calculateLiquidityFee(tAmount);
911         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
912         return (tTransferAmount, tFee, tLiquidity);
913     }
914 
915     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
916         uint256 rAmount = tAmount.mul(currentRate);
917         uint256 rFee = tFee.mul(currentRate);
918         uint256 rLiquidity = tLiquidity.mul(currentRate);
919         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
920         return (rAmount, rTransferAmount, rFee);
921     }
922 
923     function _getRate() private view returns(uint256) {
924         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
925         return rSupply.div(tSupply);
926     }
927 
928     function _getCurrentSupply() private view returns(uint256, uint256) {
929         uint256 rSupply = _rTotal;
930         uint256 tSupply = _tTotal;      
931         for (uint256 i = 0; i < _excluded.length; i++) {
932             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
933             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
934             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
935         }
936         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
937         return (rSupply, tSupply);
938     }
939     
940     function _takeLiquidity(uint256 tLiquidity) private {
941         uint256 currentRate =  _getRate();
942         uint256 rLiquidity = tLiquidity.mul(currentRate);
943         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
944         if(_isExcluded[address(this)])
945             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
946     }
947     
948     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
949         return _amount.mul(_taxFee).div(
950             10**2
951         );
952     }
953 
954     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
955         return _amount.mul(_liquidityFee).div(
956             10**2
957         );
958     }
959     
960     function addBotToBlackList(address account) external onlyOwner() {
961         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
962         require(!_isBlackListedBot[account], "Account is already blacklisted");
963         _isBlackListedBot[account] = true;
964         _blackListedBots.push(account);
965     }
966 
967     function removeBotFromBlackList(address account) external onlyOwner() {
968         require(_isBlackListedBot[account], "Account is not blacklisted");
969         for (uint256 i = 0; i < _blackListedBots.length; i++) {
970             if (_blackListedBots[i] == account) {
971                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
972                 _isBlackListedBot[account] = false;
973                 _blackListedBots.pop();
974                 break;
975             }
976         }
977     }
978     
979     function removeAllFee() private {
980         if(_taxFee == 0 && _liquidityFee == 0) return;
981         
982         _previousTaxFee = _taxFee;
983         _previousLiquidityFee = _liquidityFee;
984         
985         _taxFee = 0;
986         _liquidityFee = 0;
987     }
988     
989     function restoreAllFee() private {
990         _taxFee = _previousTaxFee;
991         _liquidityFee = _previousLiquidityFee;
992     }
993     
994     function isExcludedFromFee(address account) public view returns(bool) {
995         return _isExcludedFromFee[account];
996     }
997 
998     function _approve(address owner, address spender, uint256 amount) private {
999         require(owner != address(0), "ERC20: approve from the zero address");
1000         require(spender != address(0), "ERC20: approve to the zero address");
1001 
1002         _allowances[owner][spender] = amount;
1003         emit Approval(owner, spender, amount);
1004     }
1005 
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 amount
1010     ) private {
1011         require(from != address(0), "ERC20: transfer from the zero address");
1012         require(to != address(0), "ERC20: transfer to the zero address");
1013         require(amount > 0, "Transfer amount must be greater than zero");
1014         
1015         require(!_isBlackListedBot[to], "You have no power here!");
1016         require(!_isBlackListedBot[msg.sender], "You have no power here!");
1017         require(!_isBlackListedBot[from], "You have no power here!");
1018         
1019         
1020         if(from != owner() && to != owner())
1021             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1022 
1023         // is the token balance of this contract address over the min number of
1024         // tokens that we need to initiate a swap + liquidity lock?
1025         // also, don't get caught in a circular liquidity event.
1026         // also, don't swap & liquify if sender is uniswap pair.
1027         uint256 contractTokenBalance = balanceOf(address(this));
1028         
1029         if(contractTokenBalance >= _maxTxAmount)
1030         {
1031             contractTokenBalance = _maxTxAmount;
1032         }
1033         
1034         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1035         if (
1036             overMinTokenBalance &&
1037             !inSwapAndLiquify &&
1038             from != uniswapV2Pair &&
1039             swapAndLiquifyEnabled
1040         ) {
1041             //add liquidity
1042             swapAndLiquify(contractTokenBalance);
1043         }
1044         
1045         //indicates if fee should be deducted from transfer
1046         bool takeFee = true;
1047         
1048         //if any account belongs to _isExcludedFromFee account then remove the fee
1049         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1050             takeFee = false;
1051         }
1052         
1053         //transfer amount, it will take tax, burn, liquidity fee
1054         _tokenTransfer(from,to,amount,takeFee);
1055     }
1056 
1057     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1058         // split the contract balance into halves
1059         uint256 tokenBalance = contractTokenBalance;
1060 
1061         // capture the contract's current ETH balance.
1062         // this is so that we can capture exactly the amount of ETH that the
1063         // swap creates, and not make the liquidity event include any ETH that
1064         // has been manually sent to the contract
1065         uint256 initialBalance = address(this).balance;
1066 
1067         // swap tokens for ETH
1068         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1069 
1070         // how much ETH did we just swap into?
1071         uint256 newBalance = address(this).balance.sub(initialBalance);
1072 
1073         sendETHTodev(newBalance);
1074         // add liquidity to uniswap
1075         
1076         emit SwapAndLiquify(tokenBalance, newBalance);
1077     }
1078 
1079     function sendETHTodev(uint256 amount) private {
1080       _devWalletAddress.transfer(amount);
1081     }
1082 
1083     function swapTokensForEth(uint256 tokenAmount) private {
1084         // generate the uniswap pair path of token -> weth
1085         address[] memory path = new address[](2);
1086         path[0] = address(this);
1087         path[1] = uniswapV2Router.WETH();
1088 
1089         _approve(address(this), address(uniswapV2Router), tokenAmount);
1090 
1091         // make the swap
1092         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1093             tokenAmount,
1094             0, // accept any amount of ETH
1095             path,
1096             address(this),
1097             block.timestamp
1098         );
1099     }
1100 
1101     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1102         // approve token transfer to cover all possible scenarios
1103         _approve(address(this), address(uniswapV2Router), tokenAmount);
1104 
1105         // add the liquidity
1106         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1107             address(this),
1108             tokenAmount,
1109             0, // slippage is unavoidable
1110             0, // slippage is unavoidable
1111             owner(),
1112             block.timestamp
1113         );
1114     }
1115 
1116     //this method is responsible for taking all fee, if takeFee is true
1117     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1118         if(!takeFee)
1119             removeAllFee();
1120         
1121         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1122             _transferFromExcluded(sender, recipient, amount);
1123         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1124             _transferToExcluded(sender, recipient, amount);
1125         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1126             _transferStandard(sender, recipient, amount);
1127         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1128             _transferBothExcluded(sender, recipient, amount);
1129         } else {
1130             _transferStandard(sender, recipient, amount);
1131         }
1132         
1133         if(!takeFee)
1134             restoreAllFee();
1135     }
1136 
1137     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1138         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1139         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1140         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1141         _takeLiquidity(tLiquidity);
1142         _reflectFee(rFee, tFee);
1143         emit Transfer(sender, recipient, tTransferAmount);
1144     }
1145 
1146     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1147         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1148         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1149         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1150         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1151         _takeLiquidity(tLiquidity);
1152         _reflectFee(rFee, tFee);
1153         emit Transfer(sender, recipient, tTransferAmount);
1154     }
1155 
1156     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1157         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1158         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1159         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1160         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1161         _takeLiquidity(tLiquidity);
1162         _reflectFee(rFee, tFee);
1163         emit Transfer(sender, recipient, tTransferAmount);
1164     }
1165 }