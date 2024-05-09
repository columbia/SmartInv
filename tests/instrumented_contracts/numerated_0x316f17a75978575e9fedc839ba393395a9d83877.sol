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
681 contract EtherTerrestrial is Context, IERC20, Ownable {
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
697     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
698     uint256 private _rTotal = (MAX - (MAX % _tTotal));
699     uint256 private _tFeeTotal;
700 
701     address payable public _marketingAddress = 0xaDD25260C3F299E49891a5E096B7321f38b006d3;
702     address private _donationAddress = 0x000000000000000000000000000000000000dEaD;
703 
704     string private _name = "EtherTerrestrial";
705     string private _symbol = "$ET";
706     uint8 private _decimals = 9;
707     
708     uint256 public _taxFee = 1;
709     uint256 private _previousTaxFee = _taxFee;
710     
711     uint256 public _liquidityFee = 4;
712     uint256 private _previousLiquidityFee = _liquidityFee;
713 
714     uint256 public _marketingFee = 90;
715     uint256 private _previousMarketingFee = _marketingFee;
716 
717     uint256 public _donationFee = 0;
718     uint256 private _previousDonationFee = _donationFee;
719 
720     IUniswapV2Router02 public immutable uniswapV2Router;
721     address public immutable uniswapV2Pair;
722     
723     bool inSwapAndLiquify;
724     bool public swapAndLiquifyEnabled = true;
725     
726     uint256 public _maxTxAmount = 10000 * 10**6 * 10**9;
727     uint256 private numTokensSellToAddToLiquidity = 5000 * 10**6 * 10**9;
728     uint256 public _maxWalletSize = 1000000 * 10**6 * 10**9;
729     
730     event botAddedToBlacklist(address account);
731     event botRemovedFromBlacklist(address account);
732     
733     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
734     event SwapAndLiquifyEnabledUpdated(bool enabled);
735     event SwapAndLiquify(
736         uint256 tokensSwapped,
737         uint256 ethReceived,
738         uint256 tokensIntoLiqudity
739     );
740     
741     modifier lockTheSwap {
742         inSwapAndLiquify = true;
743         _;
744         inSwapAndLiquify = false;
745     }
746     
747     constructor () public {
748         _rOwned[_msgSender()] = _rTotal;
749         
750         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D );
751          // Create a uniswap pair for this new token
752         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
753             .createPair(address(this), _uniswapV2Router.WETH());
754 
755         // set the rest of the contract variables
756         uniswapV2Router = _uniswapV2Router;
757 
758         // exclude owner, dev wallet, and this contract from fee
759         _isExcludedFromFee[owner()] = true;
760         _isExcludedFromFee[address(this)] = true;
761         _isExcludedFromFee[_marketingAddress] = true;
762 
763         emit Transfer(address(0), _msgSender(), _tTotal);
764     }
765 
766     function name() public view returns (string memory) {
767         return _name;
768     }
769 
770     function symbol() public view returns (string memory) {
771         return _symbol;
772     }
773 
774     function decimals() public view returns (uint8) {
775         return _decimals;
776     }
777 
778     function totalSupply() public view override returns (uint256) {
779         return _tTotal;
780     }
781 
782     function balanceOf(address account) public view override returns (uint256) {
783         if (_isExcluded[account]) return _tOwned[account];
784         return tokenFromReflection(_rOwned[account]);
785     }
786 
787     function transfer(address recipient, uint256 amount) public override returns (bool) {
788         _transfer(_msgSender(), recipient, amount);
789         return true;
790     }
791 
792     function allowance(address owner, address spender) public view override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount) public override returns (bool) {
797         _approve(_msgSender(), spender, amount);
798         return true;
799     }
800 
801     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
802         _transfer(sender, recipient, amount);
803         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
804         return true;
805     }
806 
807     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
809         return true;
810     }
811 
812     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
814         return true;
815     }
816 
817     function isExcludedFromReward(address account) public view returns (bool) {
818         return _isExcluded[account];
819     }
820 
821     function totalFees() public view returns (uint256) {
822         return _tFeeTotal;
823     }
824 
825     function donationAddress() public view returns (address) {
826         return _donationAddress;
827     }
828 
829     function marketingAddress() public view returns (address) {
830         return _marketingAddress;
831     }
832 
833     function deliver(uint256 tAmount) public {
834         address sender = _msgSender();
835         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
836 
837         (,uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation) = _getTValues(tAmount);
838         (uint256 rAmount,,) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDonation, _getRate());
839         
840         _rOwned[sender] = _rOwned[sender].sub(rAmount);
841         _rTotal = _rTotal.sub(rAmount);
842         _tFeeTotal = _tFeeTotal.add(tAmount);
843     }
844 
845     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
846         require(tAmount <= _tTotal, "Amount must be less than supply");
847         
848         (,uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation) = _getTValues(tAmount);
849         (uint256 rAmount, uint256 rTransferAmount,) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDonation, _getRate());
850 
851         if (!deductTransferFee) {
852             return rAmount;
853         } else {
854             return rTransferAmount;
855         }
856     }
857 
858     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
859         require(rAmount <= _rTotal, "Amount must be less than total reflections");
860         uint256 currentRate =  _getRate();
861         return rAmount.div(currentRate);
862     }
863     
864     function addBotToBlacklist (address account) external onlyOwner() {
865            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
866            require (!_isBlackListedBot[account], 'Account is already blacklisted');
867            _isBlackListedBot[account] = true;
868            _blackListedBots.push(account);
869         }
870 
871     function removeBotFromBlacklist(address account) external onlyOwner() {
872            require (_isBlackListedBot[account], 'Account is not blacklisted');
873            for (uint256 i = 0; i < _blackListedBots.length; i++) {
874                  if (_blackListedBots[i] == account) {
875                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
876                      _isBlackListedBot[account] = false;
877                      _blackListedBots.pop();
878                      break;
879                  }
880            }
881         }       
882 
883     function excludeFromReward(address account) public onlyOwner() {
884         require(!_isExcluded[account], "Account is already excluded");
885         if(_rOwned[account] > 0) {
886             _tOwned[account] = tokenFromReflection(_rOwned[account]);
887         }
888         _isExcluded[account] = true;
889         _excluded.push(account);
890     }
891 
892     function includeInReward(address account) external onlyOwner() {
893         require(_isExcluded[account], "Account is not excluded");
894         for (uint256 i = 0; i < _excluded.length; i++) {
895             if (_excluded[i] == account) {
896                 _excluded[i] = _excluded[_excluded.length - 1];
897                 _tOwned[account] = 0;
898                 _isExcluded[account] = false;
899                 _excluded.pop();
900                 break;
901             }
902         }
903     }
904         
905     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
906         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation) = _getTValues(tAmount);
907         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDonation, _getRate());
908 
909         _tOwned[sender] = _tOwned[sender].sub(tAmount);
910         _rOwned[sender] = _rOwned[sender].sub(rAmount);
911         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
912         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
913         _takeLiquidity(tLiquidity);
914         _takeMarketingFee(tMarketing);
915         _takeDonationFee(tDonation);
916         _reflectFee(rFee, tFee);
917         emit Transfer(sender, recipient, tTransferAmount);
918     }
919         
920     function excludeFromFee(address account) public onlyOwner {
921         _isExcludedFromFee[account] = true;
922     }
923     
924     function includeInFee(address account) public onlyOwner {
925         _isExcludedFromFee[account] = false;
926     }
927     
928     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
929         _taxFee = taxFee;
930     }
931     
932     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
933         _liquidityFee = liquidityFee;
934     }
935     
936     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
937         _marketingFee = marketingFee;
938     }
939    
940     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
941         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
942             10**2
943         );
944     }
945     
946      function _setMaxWalletSizePercent (uint256 maxWalletSize) external onlyOwner() {
947           _maxWalletSize = _tTotal.mul(maxWalletSize).div(
948             10**2
949         );
950             
951     }
952 
953     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
954         swapAndLiquifyEnabled = _enabled;
955         emit SwapAndLiquifyEnabledUpdated(_enabled);
956     }
957     
958      //to recieve ETH from uniswapV2Router when swapping
959     receive() external payable {}
960 
961     function _reflectFee(uint256 rFee, uint256 tFee) private {
962         _rTotal = _rTotal.sub(rFee);
963         _tFeeTotal = _tFeeTotal.add(tFee);
964     }
965 
966     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
967         uint256 tFee = calculateTaxFee(tAmount);
968         uint256 tLiquidity = calculateLiquidityFee(tAmount);
969         uint256 tMarketing = calculateMarketingFee(tAmount);
970         uint256 tDonation = calculateDonationFee(tAmount);
971         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
972                 tTransferAmount = tTransferAmount.sub(tMarketing);
973                 tTransferAmount = tTransferAmount.sub(tDonation);
974 
975         return (tTransferAmount, tFee, tLiquidity, tMarketing, tDonation);
976     }
977 
978     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
979         uint256 rAmount = tAmount.mul(currentRate);
980         uint256 rFee = tFee.mul(currentRate);
981         uint256 rLiquidity = tLiquidity.mul(currentRate);
982         uint256 rMarketing = tMarketing.mul(currentRate);
983         uint256 rDonation = tDonation.mul(currentRate);
984         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing).sub(rDonation);
985         return (rAmount, rTransferAmount, rFee);
986     }
987 
988     function _getRate() private view returns(uint256) {
989         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
990         return rSupply.div(tSupply);
991     }
992 
993     function _getCurrentSupply() private view returns(uint256, uint256) {
994         uint256 rSupply = _rTotal;
995         uint256 tSupply = _tTotal;      
996         for (uint256 i = 0; i < _excluded.length; i++) {
997             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
998             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
999             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1000         }
1001         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1002         return (rSupply, tSupply);
1003     }
1004 
1005     function _takeLiquidity(uint256 tLiquidity) private {
1006         uint256 currentRate =  _getRate();
1007         uint256 rLiquidity = tLiquidity.mul(currentRate);
1008         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1009         if(_isExcluded[address(this)])
1010             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1011     }
1012 
1013     function _takeMarketingFee(uint256 tMarketing) private {
1014         uint256 currentRate =  _getRate();
1015         uint256 rMarketing = tMarketing.mul(currentRate);
1016         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1017         if(_isExcluded[address(this)])
1018             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1019     }
1020 
1021     function _takeDonationFee(uint256 tDonation) private {
1022         uint256 currentRate =  _getRate();
1023         uint256 rDonation = tDonation.mul(currentRate);
1024         _rOwned[_donationAddress] = _rOwned[_donationAddress].add(rDonation);
1025         if(_isExcluded[_donationAddress])
1026             _tOwned[_donationAddress] = _tOwned[_donationAddress].add(tDonation);
1027     }
1028 
1029     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1030         return _amount.mul(_taxFee).div(
1031             10**2
1032         );
1033     }
1034 
1035     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1036         return _amount.mul(_liquidityFee).div(
1037             10**2
1038         );
1039     }
1040 
1041     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1042         return _amount.mul(_marketingFee).div(
1043             10**2
1044         );
1045     }
1046 
1047     function calculateDonationFee(uint256 _amount) private view returns (uint256) {
1048         return _amount.mul(_donationFee).div(
1049             10**2
1050         );
1051     }
1052 
1053     function removeAllFee() private {
1054         if(_taxFee == 0 && _liquidityFee == 0) return;
1055         
1056         _previousTaxFee = _taxFee;
1057         _previousLiquidityFee = _liquidityFee;
1058         _previousMarketingFee = _marketingFee;
1059         _previousDonationFee = _donationFee;
1060         
1061         _taxFee = 0;
1062         _liquidityFee = 0;
1063         _marketingFee = 0;
1064         _donationFee = 0;
1065     }
1066 
1067     function restoreAllFee() private {
1068         _taxFee = _previousTaxFee;
1069         _liquidityFee = _previousLiquidityFee;
1070         _marketingFee = _previousMarketingFee;
1071         _donationFee = _previousDonationFee;
1072     }
1073 
1074     function isExcludedFromFee(address account) public view returns(bool) {
1075         return _isExcludedFromFee[account];
1076     }
1077 
1078     function _approve(address owner, address spender, uint256 amount) private {
1079         require(owner != address(0), "ERC20: approve from the zero address");
1080         require(spender != address(0), "ERC20: approve to the zero address");
1081 
1082         _allowances[owner][spender] = amount;
1083         emit Approval(owner, spender, amount);
1084     }
1085 
1086     function _transfer(
1087         address from,
1088         address to,
1089         uint256 amount
1090     ) private {
1091         require(from != address(0), "ERC20: transfer from the zero address");
1092         require(to != address(0), "ERC20: transfer to the zero address");
1093         require(amount > 0, "Transfer amount must be greater than zero");
1094         require(!_isBlackListedBot[from], "You are blacklisted");
1095         require(!_isBlackListedBot[msg.sender], "blacklisted");
1096         require(!_isBlackListedBot[tx.origin], "blacklisted");
1097         if(from != owner() && to != owner())
1098             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1099             require(amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
1100 
1101         // is the token balance of this contract address over the min number of
1102         // tokens that we need to initiate a swap + liquidity lock?
1103         // also, don't get caught in a circular liquidity event.
1104         // also, don't swap & liquify if sender is uniswap pair.
1105         uint256 contractTokenBalance = balanceOf(address(this));
1106         
1107         if(contractTokenBalance >= _maxTxAmount)
1108         {
1109             contractTokenBalance = _maxTxAmount;
1110         }
1111         
1112         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1113         if (
1114             overMinTokenBalance &&
1115             !inSwapAndLiquify &&
1116             from != uniswapV2Pair &&
1117             swapAndLiquifyEnabled
1118         ) {
1119             contractTokenBalance = numTokensSellToAddToLiquidity;
1120             //add liquidity
1121             swapAndLiquify(contractTokenBalance);
1122         }
1123         
1124         //indicates if fee should be deducted from transfer
1125         bool takeFee = true;
1126         
1127         //if any account belongs to _isExcludedFromFee account then remove the fee
1128         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1129             takeFee = false;
1130         }
1131         
1132         //transfer amount, it will take tax, burn, liquidity fee
1133         _tokenTransfer(from,to,amount,takeFee);
1134     }
1135 
1136     function swapAndLiquify(uint256 tokens) private lockTheSwap {
1137         // Split the contract balance into halves
1138         uint256 denominator= (_liquidityFee + _marketingFee) * 2;
1139         uint256 tokensToAddLiquidityWith = tokens * _liquidityFee / denominator;
1140         uint256 toSwap = tokens - tokensToAddLiquidityWith;
1141 
1142         uint256 initialBalance = address(this).balance;
1143 
1144         swapTokensForEth(toSwap);
1145 
1146         uint256 deltaBalance = address(this).balance - initialBalance;
1147         uint256 unitBalance= deltaBalance / (denominator - _liquidityFee);
1148         uint256 bnbToAddLiquidityWith = unitBalance * _liquidityFee;
1149 
1150         if(bnbToAddLiquidityWith > 0){
1151             // Add liquidity to pancake
1152             addLiquidity(tokensToAddLiquidityWith, bnbToAddLiquidityWith);
1153         }
1154 
1155         // Send ETH to marketing
1156         uint256 marketingAmt = unitBalance * 2 * _marketingFee;
1157         if(marketingAmt > 0){
1158             payable(_marketingAddress).transfer(marketingAmt);
1159         }
1160     }
1161 
1162     function swapTokensForEth(uint256 tokenAmount) private {
1163         // generate the uniswap pair path of token -> weth
1164         address[] memory path = new address[](2);
1165         path[0] = address(this);
1166         path[1] = uniswapV2Router.WETH();
1167 
1168         _approve(address(this), address(uniswapV2Router), tokenAmount);
1169 
1170         // make the swap
1171         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1172             tokenAmount,
1173             0, // accept any amount of ETH
1174             path,
1175             address(this),
1176             block.timestamp
1177         );
1178     }
1179 
1180     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1181         // approve token transfer to cover all possible scenarios
1182         _approve(address(this), address(uniswapV2Router), tokenAmount);
1183 
1184         // add the liquidity
1185         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1186             address(this),
1187             tokenAmount,
1188             0, // slippage is unavoidable
1189             0, // slippage is unavoidable
1190             address(this),
1191             block.timestamp
1192         );
1193     }
1194 
1195     //this method is responsible for taking all fee, if takeFee is true
1196     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1197         if(!takeFee)
1198             removeAllFee();
1199         
1200         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1201             _transferFromExcluded(sender, recipient, amount);
1202         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1203             _transferToExcluded(sender, recipient, amount);
1204         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1205             _transferStandard(sender, recipient, amount);
1206         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1207             _transferBothExcluded(sender, recipient, amount);
1208         } else {
1209             _transferStandard(sender, recipient, amount);
1210         }
1211         
1212         if(!takeFee)
1213             restoreAllFee();
1214     }
1215 
1216     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1217         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation) = _getTValues(tAmount);
1218         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDonation, _getRate());
1219         
1220         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1221         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1222         _takeLiquidity(tLiquidity);
1223         _takeMarketingFee(tMarketing);
1224         _takeDonationFee(tDonation);
1225         _reflectFee(rFee, tFee);
1226         emit Transfer(sender, recipient, tTransferAmount);
1227     }
1228 
1229     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1230         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation) = _getTValues(tAmount);
1231         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDonation, _getRate());
1232 
1233         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1234         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1235         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1236         _takeLiquidity(tLiquidity);
1237         _takeMarketingFee(tMarketing);
1238         _takeDonationFee(tDonation);
1239         _reflectFee(rFee, tFee);
1240         emit Transfer(sender, recipient, tTransferAmount);
1241     }
1242 
1243     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1244         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 tDonation) = _getTValues(tAmount);
1245         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, tDonation, _getRate());
1246 
1247         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1248         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1249         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1250         _takeLiquidity(tLiquidity);
1251         _takeMarketingFee(tMarketing);
1252         _takeDonationFee(tDonation);
1253         _reflectFee(rFee, tFee);
1254         emit Transfer(sender, recipient, tTransferAmount);
1255     }
1256 }