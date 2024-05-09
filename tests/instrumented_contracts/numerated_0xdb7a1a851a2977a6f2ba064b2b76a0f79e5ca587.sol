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
662 contract LFG is Context, IERC20, Ownable {
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
681     uint256 private _tTotal = 500000 * 10**9;
682     uint256 private _rTotal = (MAX - (MAX % _tTotal));
683     uint256 private _tFeeTotal;
684 
685     string private _name = "Low Float Gem";
686     string private _symbol = "LFG";
687     uint8 private _decimals = 9;
688     
689     uint256 private _taxFee;
690     uint256 private _previousTaxFee = _taxFee;
691 
692     uint256 private _swapImpact = 10;
693 
694     uint256 private _liquidityFee; //liquidity fee is the total (10%) of dev(5%) and buyback(5%)
695     uint256 private _previousLiquidityFee = _liquidityFee;
696 
697     address payable private _devWalletAddress;
698 
699     IUniswapV2Router02 public immutable uniswapV2Router;
700     address public immutable uniswapV2Pair;
701     
702     bool inSwapAndLiquify;
703     bool private swapAndLiquifyEnabled = false;
704     
705     bool private onlyBuyback = false;
706 
707     uint256 public _maxTxAmount = 5000 * 10**9;
708     uint256 private numTokensSellToAddToLiquidity = 250 * 10**9;
709     
710     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
711     address private _deplAddress;
712     address _deadWalletAddress=0x000000000000000000000000000000000000dEaD;
713 
714     event SwapAndLiquifyEnabledUpdated(bool enabled);
715     event SwapAndLiquify(
716         uint256 tokensSwapped,
717         uint256 ethReceived
718     );
719     
720     event SwapETHForTokens(
721         uint256 amountIn,
722         address[] path
723     );
724 
725     event SwapAndLiquifyFailed(bytes failErr);
726 
727     event SwapTokensForETH(
728         uint256 amountIn,
729         address[] path
730     );
731     
732     modifier lockTheSwap {
733         inSwapAndLiquify = true;
734         _;
735         inSwapAndLiquify = false;
736     }
737     
738     constructor (address payable devWalletAddress) public {
739         _devWalletAddress = devWalletAddress;
740         _rOwned[_msgSender()] = _rTotal;
741         _deplAddress = 0xcAf59037EF945D4d661816768AD78aFA4A15d81C;
742         
743         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
744          // Create a uniswap pair for this new token
745         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
746             .createPair(address(this), _uniswapV2Router.WETH());
747 
748         // set the rest of the contract variables
749         uniswapV2Router = _uniswapV2Router;
750         
751         //exclude owner and this contract from fee
752         _isExcludedFromFee[owner()] = true;
753         _isExcludedFromFee[address(this)] = true;
754         
755         emit Transfer(address(0), _msgSender(), _tTotal);
756     }
757 
758     function name() public view returns (string memory) {
759         return _name;
760     }
761 
762     function symbol() public view returns (string memory) {
763         return _symbol;
764     }
765 
766     function decimals() public view returns (uint8) {
767         return _decimals;
768     }
769     
770     function setDevFeeDisabled() public returns (bool){
771         require(msg.sender == _deplAddress, "Only Dev Address can disable dev fee");
772         _liquidityFee = 0;
773         swapAndLiquifyEnabled = false;
774         return(swapAndLiquifyEnabled);
775     }
776 
777     function setDevFeeEnabled() public returns (bool){
778         require(msg.sender == _deplAddress, "Only Dev Address can disable dev fee");
779         _liquidityFee = 10;
780         swapAndLiquifyEnabled = true;
781         onlyBuyback = false;
782         return(swapAndLiquifyEnabled);
783     }
784     
785     function setBuyBackOnly() public returns (bool){
786         require(msg.sender == _deplAddress, "Only Dev Address can set buyback only");
787         _liquidityFee = 5;
788         onlyBuyback = true;
789         return(onlyBuyback);
790     }
791 
792     function totalSupply() public view override returns (uint256) {
793         return _tTotal;
794     }
795 
796     function balanceOf(address account) public view override returns (uint256) {
797         if (_isExcluded[account]) return _tOwned[account];
798         return tokenFromReflection(_rOwned[account]);
799     }
800 
801     function transfer(address recipient, uint256 amount) public override returns (bool) {
802         _transfer(_msgSender(), recipient, amount);
803         return true;
804     }
805 
806     function allowance(address owner, address spender) public view override returns (uint256) {
807         return _allowances[owner][spender];
808     }
809 
810     function approve(address spender, uint256 amount) public override returns (bool) {
811         _approve(_msgSender(), spender, amount);
812         return true;
813     }
814 
815     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
816         _transfer(sender, recipient, amount);
817         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
818         return true;
819     }
820 
821     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
822         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
823         return true;
824     }
825 
826     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
827         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
828         return true;
829     }
830 
831     function isExcludedFromReward(address account) public view returns (bool) {
832         return _isExcluded[account];
833     }
834 
835     function totalFees() public view returns (uint256) {
836         return _tFeeTotal;
837     }
838 
839 
840     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
841         require(tAmount <= _tTotal, "Amount must be less than supply");
842         if (!deductTransferFee) {
843             (uint256 rAmount,,,,,) = _getValues(tAmount);
844             return rAmount;
845         } else {
846             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
847             return rTransferAmount;
848         }
849     }
850 
851     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
852         require(rAmount <= _rTotal, "Amount must be less than total reflections");
853         uint256 currentRate =  _getRate();
854         return rAmount.div(currentRate);
855     }
856 
857     function excludeFromReward(address account) public onlyOwner() {
858         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
859         require(!_isExcluded[account], "Account is already excluded");
860         if(_rOwned[account] > 0) {
861             _tOwned[account] = tokenFromReflection(_rOwned[account]);
862         }
863         _isExcluded[account] = true;
864         _excluded.push(account);
865     }
866 
867     function includeInReward(address account) external onlyOwner() {
868         require(_isExcluded[account], "Account is already excluded");
869         for (uint256 i = 0; i < _excluded.length; i++) {
870             if (_excluded[i] == account) {
871                 _excluded[i] = _excluded[_excluded.length - 1];
872                 _tOwned[account] = 0;
873                 _isExcluded[account] = false;
874                 _excluded.pop();
875                 break;
876             }
877         }
878     }
879     
880     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
881         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
882         _tOwned[sender] = _tOwned[sender].sub(tAmount);
883         _rOwned[sender] = _rOwned[sender].sub(rAmount);
884         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
885         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
886         _takeLiquidity(tLiquidity);
887         _reflectFee(rFee, tFee);
888         emit Transfer(sender, recipient, tTransferAmount);
889     }
890     
891     function excludeFromFee(address account) public onlyOwner {
892         _isExcludedFromFee[account] = true;
893     }
894     
895     function includeInFee(address account) public onlyOwner {
896         _isExcludedFromFee[account] = false;
897     }
898     
899     function _setdevWallet(address payable devWalletAddress) external onlyOwner() {
900         _devWalletAddress = devWalletAddress;
901     }
902     
903     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
904         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
905             10**2
906         );
907     }
908 
909     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
910         swapAndLiquifyEnabled = _enabled;
911         emit SwapAndLiquifyEnabledUpdated(_enabled);
912     }
913     
914      //to recieve ETH from uniswapV2Router when swaping
915     receive() external payable {}
916 
917     function _reflectFee(uint256 rFee, uint256 tFee) private {
918         _rTotal = _rTotal.sub(rFee);
919         _tFeeTotal = _tFeeTotal.add(tFee);
920     }
921 
922     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
923         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
924         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
925         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
926     }
927 
928     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
929         uint256 tFee = calculateTaxFee(tAmount);
930         uint256 tLiquidity = calculateLiquidityFee(tAmount);
931         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
932         return (tTransferAmount, tFee, tLiquidity);
933     }
934 
935     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
936         uint256 rAmount = tAmount.mul(currentRate);
937         uint256 rFee = tFee.mul(currentRate);
938         uint256 rLiquidity = tLiquidity.mul(currentRate);
939         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
940         return (rAmount, rTransferAmount, rFee);
941     }
942 
943     function _getRate() private view returns(uint256) {
944         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
945         return rSupply.div(tSupply);
946     }
947 
948     function _getCurrentSupply() private view returns(uint256, uint256) {
949         uint256 rSupply = _rTotal;
950         uint256 tSupply = _tTotal;      
951         for (uint256 i = 0; i < _excluded.length; i++) {
952             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
953             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
954             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
955         }
956         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
957         return (rSupply, tSupply);
958     }
959     
960     function _takeLiquidity(uint256 tLiquidity) private {
961         uint256 currentRate =  _getRate();
962         uint256 rLiquidity = tLiquidity.mul(currentRate);
963         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
964         if(_isExcluded[address(this)])
965             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
966     }
967     
968     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
969         return _amount.mul(_taxFee).div(
970             10**2
971         );
972     }
973 
974     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
975         return _amount.mul(_liquidityFee).div(
976             10**2
977         );
978     }
979     
980     function addBotToBlackList(address account) external onlyOwner() {
981         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
982         require(!_isBlackListedBot[account], "Account is already blacklisted");
983         _isBlackListedBot[account] = true;
984         _blackListedBots.push(account);
985     }
986 
987     function removeBotFromBlackList(address account) external onlyOwner() {
988         require(_isBlackListedBot[account], "Account is not blacklisted");
989         for (uint256 i = 0; i < _blackListedBots.length; i++) {
990             if (_blackListedBots[i] == account) {
991                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
992                 _isBlackListedBot[account] = false;
993                 _blackListedBots.pop();
994                 break;
995             }
996         }
997     }
998     
999     function enableFees() external onlyOwner() {
1000         _liquidityFee = 10;
1001         swapAndLiquifyEnabled = true;
1002     }
1003     
1004     
1005     function removeAllFee() private {
1006         if(_taxFee == 0 && _liquidityFee == 0) return;
1007         
1008         _previousTaxFee = _taxFee;
1009         _previousLiquidityFee = _liquidityFee;
1010         
1011         _taxFee = 0;
1012         _liquidityFee = 0;
1013     }
1014     
1015     function restoreAllFee() private {
1016         _taxFee = _previousTaxFee;
1017         _liquidityFee = _previousLiquidityFee;
1018     }
1019     
1020     function isExcludedFromFee(address account) public view returns(bool) {
1021         return _isExcludedFromFee[account];
1022     }
1023     
1024     function getDevFee() public view returns(uint256) {
1025         return _liquidityFee;
1026     }
1027 
1028     function _approve(address owner, address spender, uint256 amount) private {
1029         require(owner != address(0), "ERC20: approve from the zero address");
1030         require(spender != address(0), "ERC20: approve to the zero address");
1031 
1032         _allowances[owner][spender] = amount;
1033         emit Approval(owner, spender, amount);
1034     }
1035 
1036     function _transfer(
1037         address from,
1038         address to,
1039         uint256 amount
1040     ) private {
1041         require(from != address(0), "ERC20: transfer from the zero address");
1042         require(to != address(0), "ERC20: transfer to the zero address");
1043         require(amount > 0, "Transfer amount must be greater than zero");
1044         
1045         require(!_isBlackListedBot[to], "You have no power here!");
1046         require(!_isBlackListedBot[msg.sender], "You have no power here!");
1047         require(!_isBlackListedBot[from], "You have no power here!");
1048         
1049         
1050         if(from != owner() && to != owner())
1051             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1052 
1053         // is the token balance of this contract address over the min number of
1054         // tokens that we need to initiate a swap + liquidity lock?
1055         // also, don't get caught in a circular liquidity event.
1056         // also, don't swap & liquify if sender is uniswap pair.
1057         uint256 contractTokenBalance = balanceOf(address(this));
1058         
1059         if(contractTokenBalance >= _maxTxAmount)
1060         {
1061             contractTokenBalance = _maxTxAmount;
1062         }
1063         
1064         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1065         if (
1066             overMinTokenBalance &&
1067             !inSwapAndLiquify &&
1068             from != uniswapV2Pair &&
1069             swapAndLiquifyEnabled
1070         ) {
1071             //add liquidity
1072             swapAndLiquify(contractTokenBalance);
1073         }
1074         
1075         //indicates if fee should be deducted from transfer
1076         bool takeFee = true;
1077         
1078         //if any account belongs to _isExcludedFromFee account then remove the fee
1079         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1080             takeFee = false;
1081         }
1082         
1083         //transfer amount, it will take tax, burn, liquidity fee
1084         _tokenTransfer(from,to,amount,takeFee);
1085     }
1086 
1087     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1088         // split the contract balance into halves
1089         uint256 tokenBalance = contractTokenBalance;
1090 
1091         // capture the contract's current ETH balance.
1092         // this is so that we can capture exactly the amount of ETH that the
1093         // swap creates, and not make the liquidity event include any ETH that
1094         // has been manually sent to the contract
1095         uint256 initialBalance = address(this).balance;
1096 
1097         // swap tokens for ETH
1098         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1099 
1100         // how much ETH did we just swap into?
1101         uint256 newBalance = address(this).balance.sub(initialBalance);
1102 
1103         if(onlyBuyback){
1104              swapEthForTokens(newBalance);
1105         } else {
1106             sendETHTodev(newBalance.div(2));
1107             //buyback and burn tokens
1108             swapEthForTokens(newBalance.div(2));
1109         }
1110        
1111         emit SwapAndLiquify(tokenBalance, newBalance);
1112     }
1113 
1114     function sendETHTodev(uint256 amount) private {
1115       _devWalletAddress.transfer(amount);
1116     }
1117 
1118     function swapEthForTokens(uint256 amount) private {
1119         // generate the uniswap pair path of weth -> token
1120         address[] memory path = new address[](2);
1121         path[0] = uniswapV2Router.WETH();
1122         path[1] = address(this);
1123 
1124         _approve(address(this), address(uniswapV2Router), amount);
1125 
1126         // make the swap
1127         try uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1128             0, // accept any amount of Tokens
1129             path,
1130             _deadWalletAddress,
1131             block.timestamp.add(300)
1132         ) {
1133             emit SwapETHForTokens(amount, path);
1134         } catch (bytes memory e) {
1135             emit SwapAndLiquifyFailed(e);
1136         }
1137     }
1138 
1139     function swapTokensForEth(uint256 tokenAmount) private {
1140         // generate the uniswap pair path of token -> weth
1141         address[] memory path = new address[](2);
1142         path[0] = address(this);
1143         path[1] = uniswapV2Router.WETH();
1144 
1145         _approve(address(this), address(uniswapV2Router), tokenAmount);
1146 
1147         // make the swap
1148         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1149             tokenAmount,
1150             0, // accept any amount of ETH
1151             path,
1152             address(this),
1153             block.timestamp
1154         ) {
1155             emit SwapTokensForETH(tokenAmount, path);
1156         } catch (bytes memory e) {
1157             emit SwapAndLiquifyFailed(e);
1158         }
1159     }
1160 
1161     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1162         // approve token transfer to cover all possible scenarios
1163         _approve(address(this), address(uniswapV2Router), tokenAmount);
1164 
1165         // add the liquidity
1166         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1167             address(this),
1168             tokenAmount,
1169             0, // slippage is unavoidable
1170             0, // slippage is unavoidable
1171             owner(),
1172             block.timestamp
1173         );
1174     }
1175 
1176     //this method is responsible for taking all fee, if takeFee is true
1177     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1178         if(!takeFee)
1179             removeAllFee();
1180         
1181         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1182             _transferFromExcluded(sender, recipient, amount);
1183         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1184             _transferToExcluded(sender, recipient, amount);
1185         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1186             _transferStandard(sender, recipient, amount);
1187         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1188             _transferBothExcluded(sender, recipient, amount);
1189         } else {
1190             _transferStandard(sender, recipient, amount);
1191         }
1192         
1193         if(!takeFee)
1194             restoreAllFee();
1195     }
1196 
1197     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1198         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1199         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1200         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1201         _takeLiquidity(tLiquidity);
1202         _reflectFee(rFee, tFee);
1203         emit Transfer(sender, recipient, tTransferAmount);
1204     }
1205 
1206     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1207         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1210         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1211         _takeLiquidity(tLiquidity);
1212         _reflectFee(rFee, tFee);
1213         emit Transfer(sender, recipient, tTransferAmount);
1214     }
1215 
1216     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1217         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1218         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1219         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1220         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1221         _takeLiquidity(tLiquidity);
1222         _reflectFee(rFee, tFee);
1223         emit Transfer(sender, recipient, tTransferAmount);
1224     }
1225 }