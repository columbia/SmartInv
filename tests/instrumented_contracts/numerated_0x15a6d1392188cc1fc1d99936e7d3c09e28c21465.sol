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
681 contract KakashiInuV2 is Context, IERC20, Ownable {
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
693     mapping (address => bool) private _isBlackListedBot;
694     address[] private _blackListedBots;
695    
696     uint256 private constant MAX = ~uint256(0);
697     uint256 private _tTotal = 1000000000000 * 10**9;
698     uint256 private _rTotal = (MAX - (MAX % _tTotal));
699     uint256 private _tFeeTotal;
700 
701     string private _name = "KakashiInuV2";
702     string private _symbol = "KKI";
703     uint8 private _decimals = 9;
704     
705     uint256 public _taxFee = 1;
706     uint256 private _previousTaxFee = _taxFee;
707     
708     uint256 public _liquidityFee = 4;
709     uint256 private _previousLiquidityFee = _liquidityFee;
710 
711     uint256 public _marketingFee = 5; // All taxes are divided by 100 for more accuracy.
712     uint256 private _previousMarketingFee = _marketingFee;    
713 
714     IUniswapV2Router02 public immutable uniswapV2Router;
715     address public immutable uniswapV2Pair;
716     
717     address public burnAddress = 0xB8F7E93E4755f729cFf333904fA26DBF4ef2eb7F;
718     address payable private _marketingWallet;
719 
720     bool inSwapAndLiquify;
721     bool public swapAndLiquifyEnabled = true;
722     
723     uint256 public _maxTxAmount = 10000000000 * 10**9;
724     uint256 private numTokensSellToAddToLiquidity = 1000000000 * 10**9;
725     uint256 private _maxWalletSize = 35000000000 * 10**9;
726      
727     event botAddedToBlacklist(address account);
728     event botRemovedFromBlacklist(address account);
729     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
730     event SwapAndLiquifyEnabledUpdated(bool enabled);
731     event SwapAndLiquify(
732         uint256 tokensSwapped,
733         uint256 ethReceived,
734         uint256 tokensIntoLiqudity
735     );
736     
737     modifier lockTheSwap {
738         inSwapAndLiquify = true;
739         _;
740         inSwapAndLiquify = false;
741     }
742     
743     constructor (address marketingWallet) public {
744         _rOwned[_msgSender()] = _rTotal;
745         
746         
747         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
748          // Create a uniswap pair for this new token
749         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
750             .createPair(address(this), _uniswapV2Router.WETH());
751 
752         // set the rest of the contract variables
753         uniswapV2Router = _uniswapV2Router;
754         _marketingWallet = payable(marketingWallet);
755         
756         //exclude owner and this contract from fee
757         _isExcludedFromFee[owner()] = true;
758         _isExcludedFromFee[address(this)] = true;
759         
760         emit Transfer(address(0), _msgSender(), _tTotal);
761     }
762 
763     function name() public view returns (string memory) {
764         return _name;
765     }
766 
767     function symbol() public view returns (string memory) {
768         return _symbol;
769     }
770 
771     function decimals() public view returns (uint8) {
772         return _decimals;
773     }
774 
775     function totalSupply() public view override returns (uint256) {
776         return _tTotal;
777     }
778 
779     function balanceOf(address account) public view override returns (uint256) {
780         if (_isExcluded[account]) return _tOwned[account];
781         return tokenFromReflection(_rOwned[account]);
782     }
783 
784     function transfer(address recipient, uint256 amount) public override returns (bool) {
785         _transfer(_msgSender(), recipient, amount);
786         return true;
787     }
788 
789     function allowance(address owner, address spender) public view override returns (uint256) {
790         return _allowances[owner][spender];
791     }
792 
793     function approve(address spender, uint256 amount) public override returns (bool) {
794         _approve(_msgSender(), spender, amount);
795         return true;
796     }
797 
798     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
799         _transfer(sender, recipient, amount);
800         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
801         return true;
802     }
803 
804     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
805         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
806         return true;
807     }
808 
809     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
811         return true;
812     }
813 
814     function isExcludedFromReward(address account) public view returns (bool) {
815         return _isExcluded[account];
816     }
817 
818     function totalFees() public view returns (uint256) {
819         return _tFeeTotal;
820     }
821 
822     function deliver(uint256 tAmount) public {
823         address sender = _msgSender();
824         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
825         (uint256 rAmount,,,,,) = _getValues(tAmount);
826         _rOwned[sender] = _rOwned[sender].sub(rAmount);
827         _rTotal = _rTotal.sub(rAmount);
828         _tFeeTotal = _tFeeTotal.add(tAmount);
829     }
830 
831     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
832         require(tAmount <= _tTotal, "Amount must be less than supply");
833         if (!deductTransferFee) {
834             (uint256 rAmount,,,,,) = _getValues(tAmount);
835             return rAmount;
836         } else {
837             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
838             return rTransferAmount;
839         }
840     }
841 
842     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
843         require(rAmount <= _rTotal, "Amount must be less than total reflections");
844         uint256 currentRate =  _getRate();
845         return rAmount.div(currentRate);
846     }
847     
848     function addBotToBlacklist (address account) external onlyOwner() {
849            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
850            require (!_isBlackListedBot[account], 'Account is already blacklisted');
851            _isBlackListedBot[account] = true;
852            _blackListedBots.push(account);
853         }
854 
855         function removeBotFromBlacklist(address account) external onlyOwner() {
856           require (_isBlackListedBot[account], 'Account is not blacklisted');
857           for (uint256 i = 0; i < _blackListedBots.length; i++) {
858                  if (_blackListedBots[i] == account) {
859                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
860                      _isBlackListedBot[account] = false;
861                      _blackListedBots.pop();
862                      break;
863                  }
864            }
865        }
866 
867     function excludeFromReward(address account) public onlyOwner() {
868         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
869         require(!_isExcluded[account], "Account is already excluded");
870         if(_rOwned[account] > 0) {
871             _tOwned[account] = tokenFromReflection(_rOwned[account]);
872         }
873         _isExcluded[account] = true;
874         _excluded.push(account);
875     }
876 
877     function includeInReward(address account) external onlyOwner() {
878         require(_isExcluded[account], "Account is already excluded");
879         for (uint256 i = 0; i < _excluded.length; i++) {
880             if (_excluded[i] == account) {
881                 _excluded[i] = _excluded[_excluded.length - 1];
882                 _tOwned[account] = 0;
883                 _isExcluded[account] = false;
884                 _excluded.pop();
885                 break;
886             }
887         }
888     }
889         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
890         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
891         _tOwned[sender] = _tOwned[sender].sub(tAmount);
892         _rOwned[sender] = _rOwned[sender].sub(rAmount);
893         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
894         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
895         _takeLiquidity(tLiquidity);
896         _reflectFee(rFee, tFee);
897         emit Transfer(sender, recipient, tTransferAmount);
898     }
899     
900         function excludeFromFee(address account) public onlyOwner {
901         _isExcludedFromFee[account] = true;
902     }
903     
904     function includeInFee(address account) public onlyOwner {
905         _isExcludedFromFee[account] = false;
906     }
907     
908     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
909         _taxFee = taxFee;
910     }
911     
912     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
913         _liquidityFee = liquidityFee;
914     }
915 
916     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
917         _marketingFee = marketingFee;
918     }    
919    
920   
921     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
922         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
923             10**2
924         );
925     }
926 
927     function setMarketingWallet(address payable newWallet) external onlyOwner {
928         require(_marketingWallet != newWallet, "Wallet already set!");
929         _marketingWallet = payable(newWallet);
930     } 
931        
932 
933     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
934         swapAndLiquifyEnabled = _enabled;
935         emit SwapAndLiquifyEnabledUpdated(_enabled);
936     }
937     
938      //to recieve ETH from uniswapV2Router when swaping
939     receive() external payable {}
940 
941     function _reflectFee(uint256 rFee, uint256 tFee) private {
942         _rTotal = _rTotal.sub(rFee);
943         _tFeeTotal = _tFeeTotal.add(tFee);
944     }
945 
946     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
947         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
948         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
949         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
950     }
951 
952     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
953         uint256 tFee = calculateTaxFee(tAmount);
954         uint256 tLiquidity = calculateLiquidityFee(tAmount);
955         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
956         return (tTransferAmount, tFee, tLiquidity);
957     }
958 
959     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
960         uint256 rAmount = tAmount.mul(currentRate);
961         uint256 rFee = tFee.mul(currentRate);
962         uint256 rLiquidity = tLiquidity.mul(currentRate);
963         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
964         return (rAmount, rTransferAmount, rFee);
965     }
966 
967     function _getRate() private view returns(uint256) {
968         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
969         return rSupply.div(tSupply);
970     }
971     
972     function _getMaxWalletSize() public view returns(uint256) {
973             return _maxWalletSize;
974     }
975     
976     function _getCurrentSupply() private view returns(uint256, uint256) {
977         uint256 rSupply = _rTotal;
978         uint256 tSupply = _tTotal;      
979         for (uint256 i = 0; i < _excluded.length; i++) {
980             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
981             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
982             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
983         }
984         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
985         return (rSupply, tSupply);
986     }
987     
988     function _takeLiquidity(uint256 tLiquidity) private {
989         uint256 currentRate =  _getRate();
990         uint256 rLiquidity = tLiquidity.mul(currentRate);
991         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
992         if(_isExcluded[address(this)])
993             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
994     }
995     
996     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
997         return _amount.mul(_taxFee).div(
998             10**2
999         );
1000     }
1001 
1002     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1003         return _amount.mul(_liquidityFee.add(_marketingFee)).div(
1004             10**2
1005         );
1006     }
1007     
1008     function removeAllFee() private {
1009         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
1010         
1011         _previousTaxFee = _taxFee;
1012         _previousLiquidityFee = _liquidityFee;
1013         _previousMarketingFee = _marketingFee;
1014         
1015         _taxFee = 0;
1016         _liquidityFee = 0;
1017         _marketingFee = 0;
1018         
1019     }
1020     
1021     function restoreAllFee() private {
1022         _taxFee = _previousTaxFee;
1023         _liquidityFee = _previousLiquidityFee;
1024         _marketingFee = _previousMarketingFee;
1025     }
1026     
1027     function isExcludedFromFee(address account) public view returns(bool) {
1028         return _isExcludedFromFee[account];
1029     }
1030 
1031     function _approve(address owner, address spender, uint256 amount) private {
1032         require(owner != address(0), "ERC20: approve from the zero address");
1033         require(spender != address(0), "ERC20: approve to the zero address");
1034 
1035         _allowances[owner][spender] = amount;
1036         emit Approval(owner, spender, amount);
1037     }
1038 
1039     function _transfer(
1040         address from,
1041         address to,
1042         uint256 amount
1043     ) private {
1044         require(from != address(0), "ERC20: transfer from the zero address");
1045         require(to != address(0), "ERC20: transfer to the zero address");
1046         require(amount > 0, "Transfer amount must be greater than zero");
1047         require(!_isBlackListedBot[from], "You are blacklisted");
1048         require(!_isBlackListedBot[msg.sender], "You are blacklisted");
1049         require(!_isBlackListedBot[tx.origin], "You are blacklisted");
1050         if(from != owner() && to != owner())
1051             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1052         
1053         
1054         if(from != owner() && to != owner() && to != uniswapV2Pair && to != address(0xdead)) {
1055             uint256 tokenBalanceRecipient = balanceOf(to);
1056             require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
1057         }
1058         // is the token balance of this contract address over the min number of
1059         // tokens that we need to initiate a swap + liquidity lock?
1060         // also, don't get caught in a circular liquidity event.
1061         // also, don't swap & liquify if sender is uniswap pair.
1062         uint256 contractTokenBalance = balanceOf(address(this));
1063         
1064         if(contractTokenBalance >= _maxTxAmount)
1065         {
1066             contractTokenBalance = _maxTxAmount;
1067         }
1068         
1069         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1070         if (
1071             overMinTokenBalance &&
1072             !inSwapAndLiquify &&
1073             from != uniswapV2Pair &&
1074             swapAndLiquifyEnabled
1075         ) {
1076             contractTokenBalance = numTokensSellToAddToLiquidity;
1077             //add liquidity
1078             swapAndLiquify(contractTokenBalance);
1079         }
1080         
1081         //indicates if fee should be deducted from transfer
1082         bool takeFee = true;
1083         
1084         //if any account belongs to _isExcludedFromFee account then remove the fee
1085         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1086             takeFee = false;
1087         }
1088         
1089         //transfer amount, it will take tax, burn, liquidity fee
1090         _tokenTransfer(from,to,amount,takeFee);
1091     }
1092 
1093     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1094         if (_marketingFee + _liquidityFee == 0)
1095             return;
1096         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
1097         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
1098 
1099         // split the contract balance into halves
1100         uint256 half = toLiquify.div(2);
1101         uint256 otherHalf = toLiquify.sub(half);
1102 
1103         // capture the contract's current ETH balance.
1104         // this is so that we can capture exactly the amount of ETH that the
1105         // swap creates, and not make the liquidity event include any ETH that
1106         // has been manually sent to the contract
1107         uint256 initialBalance = address(this).balance;
1108 
1109         // swap tokens for ETH
1110         uint256 toSwapForEth = half.add(toMarketing);
1111         swapTokensForEth(toSwapForEth);
1112 
1113         // how much ETH did we just swap into?
1114         uint256 fromSwap = address(this).balance.sub(initialBalance);
1115         uint256 liquidityBalance = fromSwap.mul(half).div(toSwapForEth);
1116 
1117         addLiquidity(otherHalf, liquidityBalance);
1118 
1119         emit SwapAndLiquify(half, liquidityBalance, otherHalf);
1120 
1121         _marketingWallet.transfer(fromSwap.sub(liquidityBalance));
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
1152             burnAddress,
1153             block.timestamp
1154         );
1155     }
1156 
1157     //this method is responsible for taking all fee, if takeFee is true
1158     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1159         if(!takeFee)
1160             removeAllFee();
1161         
1162         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1163             _transferFromExcluded(sender, recipient, amount);
1164         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1165             _transferToExcluded(sender, recipient, amount);
1166         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1167             _transferStandard(sender, recipient, amount);
1168         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1169             _transferBothExcluded(sender, recipient, amount);
1170         } else {
1171             _transferStandard(sender, recipient, amount);
1172         }
1173         
1174         if(!takeFee)
1175             restoreAllFee();
1176     }
1177 
1178     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1179         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1180         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1181         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1182         _takeLiquidity(tLiquidity);
1183         _reflectFee(rFee, tFee);
1184         emit Transfer(sender, recipient, tTransferAmount);
1185     }
1186 
1187     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1188         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1189         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1190         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1191         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1192         _takeLiquidity(tLiquidity);
1193         _reflectFee(rFee, tFee);
1194         emit Transfer(sender, recipient, tTransferAmount);
1195     }
1196 
1197     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1198         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1199         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1200         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1201         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1202         _takeLiquidity(tLiquidity);
1203         _reflectFee(rFee, tFee);
1204         emit Transfer(sender, recipient, tTransferAmount);
1205     }
1206     
1207     function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1208           _maxWalletSize = maxWalletSize;
1209         }
1210 
1211 
1212     
1213 
1214 }