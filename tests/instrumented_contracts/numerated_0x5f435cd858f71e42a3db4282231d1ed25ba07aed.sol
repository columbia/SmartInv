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
446     function geUnlockTime() public view returns (uint256) {
447         return _lockTime;
448     }
449 
450     //Locks the contract for owner for the amount of time provided
451     function lock(uint256 time) public virtual onlyOwner {
452         _previousOwner = _owner;
453         _owner = address(0);
454         _lockTime = now + time;
455         emit OwnershipTransferred(_owner, address(0));
456     }
457     
458     //Unlocks the contract for owner when _lockTime is exceeds
459     function unlock() public virtual {
460         require(_previousOwner == msg.sender, "You don't have permission to unlock");
461         require(now > _lockTime , "Contract is locked until 7 days");
462         emit OwnershipTransferred(_owner, _previousOwner);
463         _owner = _previousOwner;
464     }
465 }
466 
467 // pragma solidity >=0.5.0;
468 
469 interface IUniswapV2Factory {
470     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
471 
472     function feeTo() external view returns (address);
473     function feeToSetter() external view returns (address);
474 
475     function getPair(address tokenA, address tokenB) external view returns (address pair);
476     function allPairs(uint) external view returns (address pair);
477     function allPairsLength() external view returns (uint);
478 
479     function createPair(address tokenA, address tokenB) external returns (address pair);
480 
481     function setFeeTo(address) external;
482     function setFeeToSetter(address) external;
483 }
484 
485 
486 // pragma solidity >=0.5.0;
487 
488 interface IUniswapV2Pair {
489     event Approval(address indexed owner, address indexed spender, uint value);
490     event Transfer(address indexed from, address indexed to, uint value);
491 
492     function name() external pure returns (string memory);
493     function symbol() external pure returns (string memory);
494     function decimals() external pure returns (uint8);
495     function totalSupply() external view returns (uint);
496     function balanceOf(address owner) external view returns (uint);
497     function allowance(address owner, address spender) external view returns (uint);
498 
499     function approve(address spender, uint value) external returns (bool);
500     function transfer(address to, uint value) external returns (bool);
501     function transferFrom(address from, address to, uint value) external returns (bool);
502 
503     function DOMAIN_SEPARATOR() external view returns (bytes32);
504     function PERMIT_TYPEHASH() external pure returns (bytes32);
505     function nonces(address owner) external view returns (uint);
506 
507     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
508 
509     event Mint(address indexed sender, uint amount0, uint amount1);
510     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
511     event Swap(
512         address indexed sender,
513         uint amount0In,
514         uint amount1In,
515         uint amount0Out,
516         uint amount1Out,
517         address indexed to
518     );
519     event Sync(uint112 reserve0, uint112 reserve1);
520 
521     function MINIMUM_LIQUIDITY() external pure returns (uint);
522     function factory() external view returns (address);
523     function token0() external view returns (address);
524     function token1() external view returns (address);
525     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
526     function price0CumulativeLast() external view returns (uint);
527     function price1CumulativeLast() external view returns (uint);
528     function kLast() external view returns (uint);
529 
530     function mint(address to) external returns (uint liquidity);
531     function burn(address to) external returns (uint amount0, uint amount1);
532     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
533     function skim(address to) external;
534     function sync() external;
535 
536     function initialize(address, address) external;
537 }
538 
539 // pragma solidity >=0.6.2;
540 
541 interface IUniswapV2Router01 {
542     function factory() external pure returns (address);
543     function WETH() external pure returns (address);
544 
545     function addLiquidity(
546         address tokenA,
547         address tokenB,
548         uint amountADesired,
549         uint amountBDesired,
550         uint amountAMin,
551         uint amountBMin,
552         address to,
553         uint deadline
554     ) external returns (uint amountA, uint amountB, uint liquidity);
555     function addLiquidityETH(
556         address token,
557         uint amountTokenDesired,
558         uint amountTokenMin,
559         uint amountETHMin,
560         address to,
561         uint deadline
562     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
563     function removeLiquidity(
564         address tokenA,
565         address tokenB,
566         uint liquidity,
567         uint amountAMin,
568         uint amountBMin,
569         address to,
570         uint deadline
571     ) external returns (uint amountA, uint amountB);
572     function removeLiquidityETH(
573         address token,
574         uint liquidity,
575         uint amountTokenMin,
576         uint amountETHMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountToken, uint amountETH);
580     function removeLiquidityWithPermit(
581         address tokenA,
582         address tokenB,
583         uint liquidity,
584         uint amountAMin,
585         uint amountBMin,
586         address to,
587         uint deadline,
588         bool approveMax, uint8 v, bytes32 r, bytes32 s
589     ) external returns (uint amountA, uint amountB);
590     function removeLiquidityETHWithPermit(
591         address token,
592         uint liquidity,
593         uint amountTokenMin,
594         uint amountETHMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountToken, uint amountETH);
599     function swapExactTokensForTokens(
600         uint amountIn,
601         uint amountOutMin,
602         address[] calldata path,
603         address to,
604         uint deadline
605     ) external returns (uint[] memory amounts);
606     function swapTokensForExactTokens(
607         uint amountOut,
608         uint amountInMax,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external returns (uint[] memory amounts);
613     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
614         external
615         payable
616         returns (uint[] memory amounts);
617     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
618         external
619         returns (uint[] memory amounts);
620     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
621         external
622         returns (uint[] memory amounts);
623     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
624         external
625         payable
626         returns (uint[] memory amounts);
627 
628     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
629     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
630     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
631     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
632     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
633 }
634 
635 
636 
637 // pragma solidity >=0.6.2;
638 
639 interface IUniswapV2Router02 is IUniswapV2Router01 {
640     function removeLiquidityETHSupportingFeeOnTransferTokens(
641         address token,
642         uint liquidity,
643         uint amountTokenMin,
644         uint amountETHMin,
645         address to,
646         uint deadline
647     ) external returns (uint amountETH);
648     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
649         address token,
650         uint liquidity,
651         uint amountTokenMin,
652         uint amountETHMin,
653         address to,
654         uint deadline,
655         bool approveMax, uint8 v, bytes32 r, bytes32 s
656     ) external returns (uint amountETH);
657 
658     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
659         uint amountIn,
660         uint amountOutMin,
661         address[] calldata path,
662         address to,
663         uint deadline
664     ) external;
665     function swapExactETHForTokensSupportingFeeOnTransferTokens(
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external payable;
671     function swapExactTokensForETHSupportingFeeOnTransferTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external;
678 }
679 
680 
681 contract StarShib is Context, IERC20, Ownable {
682     using SafeMath for uint256;
683     using Address for address;
684 
685     mapping (address => uint256) private _rOwned;
686     mapping (address => uint256) private _tOwned;
687     mapping (address => mapping (address => uint256)) private _allowances;
688 
689     mapping (address => bool) private _isExcludedFromFee;
690 
691     mapping (address => bool) private _isExcluded;
692     address[] private _excluded;
693   // initialSupply*(10**18
694     uint256 private constant MAX = ~uint256(0);
695     uint256 private _tTotal = 10000000000 * (10**18);
696     uint256 private _rTotal = (MAX - (MAX % _tTotal));
697     uint256 private _tFeeTotal;
698 
699     string private _name = "StarShib";
700     string private _symbol = "StarSb";
701     uint8 private _decimals = 18;
702     
703     uint256 public _taxFee = 5;
704     uint256 private _previousTaxFee = _taxFee;
705     
706     uint256 public _liquidityFee = 5;
707     uint256 private _previousLiquidityFee = _liquidityFee;
708 
709     IUniswapV2Router02 public immutable uniswapV2Router;
710     address public immutable uniswapV2Pair;
711     
712     bool inSwapAndLiquify;
713     bool public swapAndLiquifyEnabled = true;
714     
715     uint256 public _maxTxAmount = 10000000000 * (10**18);
716     uint256 private numTokensSellToAddToLiquidity = 10000000000 * (10**18);
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
732     constructor () public {
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
762     function totalSupply() public view override returns (uint256) {
763         return _tTotal;
764     }
765 
766     function balanceOf(address account) public view override returns (uint256) {
767         if (_isExcluded[account]) return _tOwned[account];
768         return tokenFromReflection(_rOwned[account]);
769     }
770 
771     function transfer(address recipient, uint256 amount) public override returns (bool) {
772         _transfer(_msgSender(), recipient, amount);
773         return true;
774     }
775 
776     function allowance(address owner, address spender) public view override returns (uint256) {
777         return _allowances[owner][spender];
778     }
779 
780     function approve(address spender, uint256 amount) public override returns (bool) {
781         _approve(_msgSender(), spender, amount);
782         return true;
783     }
784 
785     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
786         _transfer(sender, recipient, amount);
787         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
788         return true;
789     }
790 
791     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
792         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
793         return true;
794     }
795 
796     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
798         return true;
799     }
800 
801     function isExcludedFromReward(address account) public view returns (bool) {
802         return _isExcluded[account];
803     }
804 
805     function totalFees() public view returns (uint256) {
806         return _tFeeTotal;
807     }
808 
809     function deliver(uint256 tAmount) public {
810         address sender = _msgSender();
811         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
812         (uint256 rAmount,,,,,) = _getValues(tAmount);
813         _rOwned[sender] = _rOwned[sender].sub(rAmount);
814         _rTotal = _rTotal.sub(rAmount);
815         _tFeeTotal = _tFeeTotal.add(tAmount);
816     }
817 
818     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
819         require(tAmount <= _tTotal, "Amount must be less than supply");
820         if (!deductTransferFee) {
821             (uint256 rAmount,,,,,) = _getValues(tAmount);
822             return rAmount;
823         } else {
824             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
825             return rTransferAmount;
826         }
827     }
828 
829     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
830         require(rAmount <= _rTotal, "Amount must be less than total reflections");
831         uint256 currentRate =  _getRate();
832         return rAmount.div(currentRate);
833     }
834 
835     function excludeFromReward(address account) public onlyOwner() {
836         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
837         require(!_isExcluded[account], "Account is already excluded");
838         if(_rOwned[account] > 0) {
839             _tOwned[account] = tokenFromReflection(_rOwned[account]);
840         }
841         _isExcluded[account] = true;
842         _excluded.push(account);
843     }
844 
845     function includeInReward(address account) external onlyOwner() {
846         require(_isExcluded[account], "Account is already excluded");
847         for (uint256 i = 0; i < _excluded.length; i++) {
848             if (_excluded[i] == account) {
849                 _excluded[i] = _excluded[_excluded.length - 1];
850                 _tOwned[account] = 0;
851                 _isExcluded[account] = false;
852                 _excluded.pop();
853                 break;
854             }
855         }
856     }
857         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
858         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
859         _tOwned[sender] = _tOwned[sender].sub(tAmount);
860         _rOwned[sender] = _rOwned[sender].sub(rAmount);
861         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
862         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
863         _takeLiquidity(tLiquidity);
864         _reflectFee(rFee, tFee);
865         emit Transfer(sender, recipient, tTransferAmount);
866     }
867     
868         function excludeFromFee(address account) public onlyOwner {
869         _isExcludedFromFee[account] = true;
870     }
871     
872     function includeInFee(address account) public onlyOwner {
873         _isExcludedFromFee[account] = false;
874     }
875     
876     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
877         _taxFee = taxFee;
878     }
879     
880     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
881         _liquidityFee = liquidityFee;
882     }
883    
884     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
885         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
886             10**2
887         );
888     }
889 
890     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
891         swapAndLiquifyEnabled = _enabled;
892         emit SwapAndLiquifyEnabledUpdated(_enabled);
893     }
894     
895      //to recieve ETH from uniswapV2Router when swaping
896     receive() external payable {}
897 
898     function _reflectFee(uint256 rFee, uint256 tFee) private {
899         _rTotal = _rTotal.sub(rFee);
900         _tFeeTotal = _tFeeTotal.add(tFee);
901     }
902 
903     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
904         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
905         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
906         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
907     }
908 
909     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
910         uint256 tFee = calculateTaxFee(tAmount);
911         uint256 tLiquidity = calculateLiquidityFee(tAmount);
912         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
913         return (tTransferAmount, tFee, tLiquidity);
914     }
915 
916     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
917         uint256 rAmount = tAmount.mul(currentRate);
918         uint256 rFee = tFee.mul(currentRate);
919         uint256 rLiquidity = tLiquidity.mul(currentRate);
920         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
921         return (rAmount, rTransferAmount, rFee);
922     }
923 
924     function _getRate() private view returns(uint256) {
925         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
926         return rSupply.div(tSupply);
927     }
928 
929     function _getCurrentSupply() private view returns(uint256, uint256) {
930         uint256 rSupply = _rTotal;
931         uint256 tSupply = _tTotal;      
932         for (uint256 i = 0; i < _excluded.length; i++) {
933             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
934             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
935             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
936         }
937         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
938         return (rSupply, tSupply);
939     }
940     
941     function _takeLiquidity(uint256 tLiquidity) private {
942         uint256 currentRate =  _getRate();
943         uint256 rLiquidity = tLiquidity.mul(currentRate);
944         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
945         if(_isExcluded[address(this)])
946             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
947     }
948     
949     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
950         return _amount.mul(_taxFee).div(
951             10**2
952         );
953     }
954 
955     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
956         return _amount.mul(_liquidityFee).div(
957             10**2
958         );
959     }
960     
961     function removeAllFee() private {
962         if(_taxFee == 0 && _liquidityFee == 0) return;
963         
964         _previousTaxFee = _taxFee;
965         _previousLiquidityFee = _liquidityFee;
966         
967         _taxFee = 0;
968         _liquidityFee = 0;
969     }
970     
971     function restoreAllFee() private {
972         _taxFee = _previousTaxFee;
973         _liquidityFee = _previousLiquidityFee;
974     }
975     
976     function isExcludedFromFee(address account) public view returns(bool) {
977         return _isExcludedFromFee[account];
978     }
979 
980     function _approve(address owner, address spender, uint256 amount) private {
981         require(owner != address(0), "ERC20: approve from the zero address");
982         require(spender != address(0), "ERC20: approve to the zero address");
983 
984         _allowances[owner][spender] = amount;
985         emit Approval(owner, spender, amount);
986     }
987 
988     function _transfer(
989         address from,
990         address to,
991         uint256 amount
992     ) private {
993         require(from != address(0), "ERC20: transfer from the zero address");
994         require(to != address(0), "ERC20: transfer to the zero address");
995         require(amount > 0, "Transfer amount must be greater than zero");
996         if(from != owner() && to != owner())
997             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
998 
999         // is the token balance of this contract address over the min number of
1000         // tokens that we need to initiate a swap + liquidity lock?
1001         // also, don't get caught in a circular liquidity event.
1002         // also, don't swap & liquify if sender is uniswap pair.
1003         uint256 contractTokenBalance = balanceOf(address(this));
1004         
1005         if(contractTokenBalance >= _maxTxAmount)
1006         {
1007             contractTokenBalance = _maxTxAmount;
1008         }
1009         
1010         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1011         if (
1012             overMinTokenBalance &&
1013             !inSwapAndLiquify &&
1014             from != uniswapV2Pair &&
1015             swapAndLiquifyEnabled
1016         ) {
1017             contractTokenBalance = numTokensSellToAddToLiquidity;
1018             //add liquidity
1019             swapAndLiquify(contractTokenBalance);
1020         }
1021         
1022         //indicates if fee should be deducted from transfer
1023         bool takeFee = true;
1024         
1025         //if any account belongs to _isExcludedFromFee account then remove the fee
1026         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1027             takeFee = false;
1028         }
1029         
1030         //transfer amount, it will take tax, burn, liquidity fee
1031         _tokenTransfer(from,to,amount,takeFee);
1032     }
1033 
1034     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1035         // split the contract balance into halves
1036         uint256 half = contractTokenBalance.div(2);
1037         uint256 otherHalf = contractTokenBalance.sub(half);
1038 
1039         // capture the contract's current ETH balance.
1040         // this is so that we can capture exactly the amount of ETH that the
1041         // swap creates, and not make the liquidity event include any ETH that
1042         // has been manually sent to the contract
1043         uint256 initialBalance = address(this).balance;
1044 
1045         // swap tokens for ETH
1046         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1047 
1048         // how much ETH did we just swap into?
1049         uint256 newBalance = address(this).balance.sub(initialBalance);
1050 
1051         // add liquidity to uniswap
1052         addLiquidity(otherHalf, newBalance);
1053         
1054         emit SwapAndLiquify(half, newBalance, otherHalf);
1055     }
1056 
1057     function swapTokensForEth(uint256 tokenAmount) private {
1058         // generate the uniswap pair path of token -> weth
1059         address[] memory path = new address[](2);
1060         path[0] = address(this);
1061         path[1] = uniswapV2Router.WETH();
1062 
1063         _approve(address(this), address(uniswapV2Router), tokenAmount);
1064 
1065         // make the swap
1066         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1067             tokenAmount,
1068             0, // accept any amount of ETH
1069             path,
1070             address(this),
1071             block.timestamp
1072         );
1073     }
1074 
1075     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1076         // approve token transfer to cover all possible scenarios
1077         _approve(address(this), address(uniswapV2Router), tokenAmount);
1078 
1079         // add the liquidity
1080         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1081             address(this),
1082             tokenAmount,
1083             0, // slippage is unavoidable
1084             0, // slippage is unavoidable
1085             owner(),
1086             block.timestamp
1087         );
1088     }
1089 
1090     //this method is responsible for taking all fee, if takeFee is true
1091     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1092         if(!takeFee)
1093             removeAllFee();
1094         
1095         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1096             _transferFromExcluded(sender, recipient, amount);
1097         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1098             _transferToExcluded(sender, recipient, amount);
1099         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1100             _transferStandard(sender, recipient, amount);
1101         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1102             _transferBothExcluded(sender, recipient, amount);
1103         } else {
1104             _transferStandard(sender, recipient, amount);
1105         }
1106         
1107         if(!takeFee)
1108             restoreAllFee();
1109     }
1110 
1111     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1112         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1113         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1114         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1115         _takeLiquidity(tLiquidity);
1116         _reflectFee(rFee, tFee);
1117         emit Transfer(sender, recipient, tTransferAmount);
1118     }
1119 
1120     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1121         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1122         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1123         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1124         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1125         _takeLiquidity(tLiquidity);
1126         _reflectFee(rFee, tFee);
1127         emit Transfer(sender, recipient, tTransferAmount);
1128     }
1129 
1130     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1131         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1132         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1133         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1134         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1135         _takeLiquidity(tLiquidity);
1136         _reflectFee(rFee, tFee);
1137         emit Transfer(sender, recipient, tTransferAmount);
1138     }
1139 
1140 }