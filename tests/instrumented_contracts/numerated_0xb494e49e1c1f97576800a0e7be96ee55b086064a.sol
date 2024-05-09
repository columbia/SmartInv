1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: Unlicensed 0x7b527bd019E9f745497F2cB51C658cb10E2C914F
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
635 // pragma solidity >=0.6.2;
636 
637 interface IUniswapV2Router02 is IUniswapV2Router01 {
638     function removeLiquidityETHSupportingFeeOnTransferTokens(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline
645     ) external returns (uint amountETH);
646     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline,
653         bool approveMax, uint8 v, bytes32 r, bytes32 s
654     ) external returns (uint amountETH);
655 
656     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
657         uint amountIn,
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external;
663     function swapExactETHForTokensSupportingFeeOnTransferTokens(
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external payable;
669     function swapExactTokensForETHSupportingFeeOnTransferTokens(
670         uint amountIn,
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external;
676 }
677 
678 /*
679 To be modified before deploying this contract for a project:
680 - Uniswap Router address if not on ETH
681 - Dev address
682 */
683 
684 contract BabyVLaunch is Context, IERC20, Ownable {
685     using SafeMath for uint256;
686     using Address for address;
687 
688     mapping (address => uint256) private _rOwned;
689     mapping (address => uint256) private _tOwned;
690     mapping (address => mapping (address => uint256)) private _allowances;
691 
692     mapping (address => bool) private _isExcludedFromFee;
693     mapping (address => bool) private _isExcludedFromMax;
694     mapping (address => bool) private _isExcluded;
695     mapping (address => bool) isBlacklisted;
696     address[] private _excluded;
697    
698     uint256 private constant MAX = ~uint256(0);
699     uint256 private _tTotal = 1 * 10**9 * 10**9;
700     uint256 private _rTotal = (MAX - (MAX % _tTotal));
701     uint256 private _tFeeTotal;
702 
703     address private _devAddress = 0x2D8D7F4C547051a0434fC44AA20e63535F09Ef79;
704     address private _burnAddress = 0x0000000000000000000000000000000000000001;
705 
706     string private _name = "Baby VLaunch";
707     string private _symbol = "BABYVPAD";
708     uint8 private _decimals = 9;
709     
710     uint256 public _taxFee = 2;
711     uint256 private _previousTaxFee = _taxFee;
712 
713     uint256 public _devFee = 10;
714     uint256 private _previousDevFee = _devFee;
715 
716     uint256 public _burnFee = 2;
717     uint256 private _previousBurnFee = _burnFee;
718 
719     uint256 private _beforeLaunchFee = 99;
720     uint256 private _previousBeforeLaunchFee = _beforeLaunchFee;
721 
722 
723     uint256 public launchedAt;
724     uint256 public launchedAtTimestamp;
725 
726     IUniswapV2Router02 public immutable uniswapV2Router;
727     address public uniswapV2Pair;
728         
729     uint256 public _maxTxAmount = _tTotal.div(200).mul(1);
730     uint256 public _maxWalletToken = _tTotal.div(100).mul(1);
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
743         // exclude owner, dev wallet, and this contract from fee
744         _isExcludedFromFee[owner()] = true;
745         _isExcludedFromFee[address(this)] = true;
746         _isExcludedFromFee[_devAddress] = true;
747 
748         _isExcludedFromMax[owner()] = true;
749         _isExcludedFromMax[address(this)] = true;
750         _isExcludedFromMax[_devAddress] = true;
751         _isExcludedFromMax[uniswapV2Pair] = true;
752 
753         emit Transfer(address(0), _msgSender(), _tTotal);
754     }
755 
756     function name() public view returns (string memory) {
757         return _name;
758     }
759 
760     function symbol() public view returns (string memory) {
761         return _symbol;
762     }
763 
764     function decimals() public view returns (uint8) {
765         return _decimals;
766     }
767 
768     function totalSupply() public view override returns (uint256) {
769         return _tTotal;
770     }
771 
772     function balanceOf(address account) public view override returns (uint256) {
773         if (_isExcluded[account]) return _tOwned[account];
774         return tokenFromReflection(_rOwned[account]);
775     }
776 
777     function transfer(address recipient, uint256 amount) public override returns (bool) {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender) public view override returns (uint256) {
783         return _allowances[owner][spender];
784     }
785 
786     function approve(address spender, uint256 amount) public override returns (bool) {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790 
791     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
792         _transfer(sender, recipient, amount);
793         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
794         return true;
795     }
796 
797     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
798         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
799         return true;
800     }
801 
802     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
803         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
804         return true;
805     }
806 
807     function isExcludedFromReward(address account) public view returns (bool) {
808         return _isExcluded[account];
809     }
810 
811     function setIsBlacklisted(address account, bool blacklisted) external onlyOwner() {
812         isBlacklisted[account] = blacklisted;
813     }
814 
815     function blacklistMultipleAccounts(address[] calldata accounts, bool blacklisted) external onlyOwner() {
816         for (uint256 i = 0; i < accounts.length; i++) {
817             isBlacklisted[accounts[i]] = blacklisted;
818         }
819     }
820 
821     function isAccountBlacklisted(address account) external view returns (bool) {
822         return isBlacklisted[account];
823     }
824 
825     function isExcludedFromMax(address holder, bool exempt) external onlyOwner() {
826         _isExcludedFromMax[holder] = exempt;
827     }
828 
829     function totalFees() public view returns (uint256) {
830         return _tFeeTotal;
831     }
832 
833     function burnAddress() public view returns (address) {
834         return _burnAddress;
835     }
836 
837     function devAddress() public view returns (address) {
838         return _devAddress;
839     }
840 
841     function launch() public onlyOwner() {
842         require(launchedAt == 0, "Already launched.");
843         launchedAt = block.number;
844         launchedAtTimestamp = block.timestamp;
845     }
846 
847     function deliver(uint256 tAmount) public {
848         address sender = _msgSender();
849         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
850 
851         (,uint256 tFee, uint256 tDev, uint256 tBurn) = _getTValues(tAmount);
852         (uint256 rAmount,,) = _getRValues(tAmount, tFee, tDev, tBurn, _getRate());
853         
854         _rOwned[sender] = _rOwned[sender].sub(rAmount);
855         _rTotal = _rTotal.sub(rAmount);
856         _tFeeTotal = _tFeeTotal.add(tAmount);
857     }
858 
859     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
860         require(tAmount <= _tTotal, "Amount must be less than supply");
861         
862         (,uint256 tFee, uint256 tDev, uint256 tBurn) = _getTValues(tAmount);
863         (uint256 rAmount, uint256 rTransferAmount,) = _getRValues(tAmount, tFee, tDev, tBurn, _getRate());
864 
865         if (!deductTransferFee) {
866             return rAmount;
867         } else {
868             return rTransferAmount;
869         }
870     }
871 
872     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
873         require(rAmount <= _rTotal, "Amount must be less than total reflections");
874         uint256 currentRate =  _getRate();
875         return rAmount.div(currentRate);
876     }
877 
878     function excludeFromReward(address account) public onlyOwner() {
879         require(!_isExcluded[account], "Account is already excluded");
880         if(_rOwned[account] > 0) {
881             _tOwned[account] = tokenFromReflection(_rOwned[account]);
882         }
883         _isExcluded[account] = true;
884         _excluded.push(account);
885     }
886 
887     function includeInReward(address account) external onlyOwner() {
888         require(_isExcluded[account], "Account is not excluded");
889         for (uint256 i = 0; i < _excluded.length; i++) {
890             if (_excluded[i] == account) {
891                 _excluded[i] = _excluded[_excluded.length - 1];
892                 _tOwned[account] = 0;
893                 _isExcluded[account] = false;
894                 _excluded.pop();
895                 break;
896             }
897         }
898     }
899         
900     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
901         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tBurn) = _getTValues(tAmount);
902         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tBurn, _getRate());
903 
904         _tOwned[sender] = _tOwned[sender].sub(tAmount);
905         _rOwned[sender] = _rOwned[sender].sub(rAmount);
906         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
907         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
908         _takeDevFee(tDev);
909         _takeBurnFee(tBurn);
910         _reflectFee(rFee, tFee);
911         emit Transfer(sender, recipient, tTransferAmount);
912     }
913         
914     function excludeFromFee(address account) public onlyOwner {
915         _isExcludedFromFee[account] = true;
916     }
917     
918     function includeInFee(address account) public onlyOwner {
919         _isExcludedFromFee[account] = false;
920     }
921     
922     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
923         _taxFee = taxFee;
924     }
925     
926     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
927         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
928             10**2
929         );
930     }
931 
932     function setMaxWalletPercent(uint256 maxWalletToken) external onlyOwner() {
933         _maxWalletToken = _tTotal.mul(maxWalletToken).div(
934             10**2
935         );
936     }
937     
938      //to recieve ETH from uniswapV2Router when swapping
939     receive() external payable {}
940 
941     function _reflectFee(uint256 rFee, uint256 tFee) private {
942         _rTotal = _rTotal.sub(rFee);
943         _tFeeTotal = _tFeeTotal.add(tFee);
944     }
945 
946     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
947         uint256 tFee = calculateTaxFee(tAmount);
948         uint256 tDev = calculateDevFee(tAmount);
949         uint256 tBurn = calculateBurnFee(tAmount);
950         uint256 tTransferAmount = tAmount.sub(tFee).sub(tDev);
951                 tTransferAmount = tTransferAmount.sub(tBurn);
952 
953         return (tTransferAmount, tFee, tDev, tBurn);
954     }
955 
956     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tDev, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
957         uint256 rAmount = tAmount.mul(currentRate);
958         uint256 rFee = tFee.mul(currentRate);
959         uint256 rDev = tDev.mul(currentRate);
960         uint256 rBurn = tBurn.mul(currentRate);
961         uint256 rTransferAmount = rAmount.sub(rFee).sub(rDev).sub(rBurn);
962         return (rAmount, rTransferAmount, rFee);
963     }
964 
965     function _getRate() private view returns(uint256) {
966         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
967         return rSupply.div(tSupply);
968     }
969 
970     function _getCurrentSupply() private view returns(uint256, uint256) {
971         uint256 rSupply = _rTotal;
972         uint256 tSupply = _tTotal;      
973         for (uint256 i = 0; i < _excluded.length; i++) {
974             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
975             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
976             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
977         }
978         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
979         return (rSupply, tSupply);
980     }
981 
982     function _takeDevFee(uint256 tDev) private {
983         uint256 currentRate =  _getRate();
984         uint256 rDev = tDev.mul(currentRate);
985         _rOwned[_devAddress] = _rOwned[_devAddress].add(rDev);
986         if(_isExcluded[_devAddress])
987             _tOwned[_devAddress] = _tOwned[_devAddress].add(tDev);
988     }
989 
990     function _takeBurnFee(uint256 tBurn) private {
991         uint256 currentRate =  _getRate();
992         uint256 rBurn = tBurn.mul(currentRate);
993         _rOwned[_burnAddress] = _rOwned[_burnAddress].add(rBurn);
994         if(_isExcluded[_burnAddress])
995             _tOwned[_burnAddress] = _tOwned[_burnAddress].add(tBurn);
996     }
997 
998     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
999         uint256 fee = launchedAt == 0 ? 0 : _taxFee;
1000         return _amount.mul(fee).div(
1001             10**2
1002         );
1003     }
1004 
1005     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1006         uint256 fee = launchedAt == 0 ? 0 : _devFee;
1007         return _amount.mul(fee).div(
1008             10**2
1009         );
1010     }
1011 
1012     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1013         uint256 fee = launchedAt == 0 ? _beforeLaunchFee : _burnFee;
1014         return _amount.mul(fee).div(
1015             10**2
1016         );
1017     }
1018 
1019     function removeAllFee() private {
1020         if(_taxFee == 0 && _devFee == 0) return;
1021         
1022         _previousTaxFee = _taxFee;
1023         _previousDevFee = _devFee;
1024         _previousBurnFee = _burnFee;
1025         _previousBeforeLaunchFee = _beforeLaunchFee;
1026         
1027         _taxFee = 0;
1028         _devFee = 0;
1029         _burnFee = 0;
1030         _beforeLaunchFee = 0;
1031     }
1032 
1033     function restoreAllFee() private {
1034         _taxFee = _previousTaxFee;
1035         _devFee = _previousDevFee;
1036         _burnFee = _previousBurnFee;
1037         _beforeLaunchFee = _previousBeforeLaunchFee;
1038     }
1039 
1040     function isExcludedFromFee(address account) public view returns(bool) {
1041         return _isExcludedFromFee[account];
1042     }
1043 
1044     function _approve(address owner, address spender, uint256 amount) private {
1045         require(owner != address(0), "ERC20: approve from the zero address");
1046         require(spender != address(0), "ERC20: approve to the zero address");
1047 
1048         _allowances[owner][spender] = amount;
1049         emit Approval(owner, spender, amount);
1050     }
1051 
1052     function _transfer(
1053         address from,
1054         address to,
1055         uint256 amount
1056     ) private {
1057         require(from != address(0), "ERC20: transfer from the zero address");
1058         require(to != address(0), "ERC20: transfer to the zero address");
1059         require(amount > 0, "Transfer amount must be greater than zero");
1060         require(!isBlacklisted[from], "Blacklisted address");
1061 
1062         if(!_isExcludedFromMax[from] || !_isExcludedFromMax[to]) {
1063             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1064             uint256 heldTokens = balanceOf(to);
1065             require((heldTokens + amount) <= _maxWalletToken, "Total Holding is currently limited, you can not buy that much.");
1066         }
1067         
1068         //indicates if fee should be deducted from transfer
1069         bool takeFee = true;
1070         
1071         //if any account belongs to _isExcludedFromFee account then remove the fee
1072         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1073             takeFee = false;
1074         }
1075         
1076         //transfer amount, it will take tax, burn fee
1077         _tokenTransfer(from,to,amount,takeFee);
1078     }
1079 
1080     function swapTokensForEth(uint256 tokenAmount) private {
1081         // generate the uniswap pair path of token -> weth
1082         address[] memory path = new address[](2);
1083         path[0] = address(this);
1084         path[1] = uniswapV2Router.WETH();
1085 
1086         _approve(address(this), address(uniswapV2Router), tokenAmount);
1087 
1088         // make the swap
1089         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1090             tokenAmount,
1091             0, // accept any amount of ETH
1092             path,
1093             address(this),
1094             block.timestamp
1095         );
1096     }
1097 
1098     //this method is responsible for taking all fee, if takeFee is true
1099     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1100         if(!takeFee)
1101             removeAllFee();
1102         
1103         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1104             _transferFromExcluded(sender, recipient, amount);
1105         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1106             _transferToExcluded(sender, recipient, amount);
1107         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1108             _transferStandard(sender, recipient, amount);
1109         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1110             _transferBothExcluded(sender, recipient, amount);
1111         } else {
1112             _transferStandard(sender, recipient, amount);
1113         }
1114         
1115         if(!takeFee)
1116             restoreAllFee();
1117     }
1118 
1119     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1120         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tBurn) = _getTValues(tAmount);
1121         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tBurn, _getRate());
1122         
1123         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1124         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1125         _takeDevFee(tDev);
1126         _takeBurnFee(tBurn);
1127         _reflectFee(rFee, tFee);
1128         emit Transfer(sender, recipient, tTransferAmount);
1129     }
1130 
1131     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1132         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tBurn) = _getTValues(tAmount);
1133         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tBurn, _getRate());
1134 
1135         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1136         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1137         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1138         _takeDevFee(tDev);
1139         _takeBurnFee(tBurn);
1140         _reflectFee(rFee, tFee);
1141         emit Transfer(sender, recipient, tTransferAmount);
1142     }
1143 
1144     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1145         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tBurn) = _getTValues(tAmount);
1146         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tBurn, _getRate());
1147 
1148         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1149         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1150         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1151         _takeDevFee(tDev);
1152         _takeBurnFee(tBurn);
1153         _reflectFee(rFee, tFee);
1154         emit Transfer(sender, recipient, tTransferAmount);
1155     }
1156 }