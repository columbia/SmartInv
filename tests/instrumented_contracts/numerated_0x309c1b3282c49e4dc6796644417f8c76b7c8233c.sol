1 /* 
2 * https://t.me/FIRST_ELEVEN_F11
3 *
4 *
5 * SPDX-License-Identifier: Unlicensed
6 */
7 pragma solidity ^0.8.0;
8 interface IERC20 {
9 
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90  
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address ) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data;
242     }
243 }
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 /**
384  * @dev Contract module which provides a basic access control mechanism, where
385  * there is an account (an owner) that can be granted exclusive access to
386  * specific functions.
387  *
388  * By default, the owner account will be the one that deploys the contract. This
389  * can later be changed with {transferOwnership}.
390  *
391  * This module is used through inheritance. It will make available the modifier
392  * `onlyOwner`, which can be applied to your functions to restrict their use to
393  * the owner.
394  */
395 contract Ownable is Context {
396     address private _owner;
397     address private _previousOwner;
398     uint256 private _lockTime;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor () {
406         _owner = msg.sender;
407         emit OwnershipTransferred(address(0), msg.sender);
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425      /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435         _previousOwner = address(0);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447 
448     function geUnlockTime() public view returns (uint256) {
449         return _lockTime;
450     }
451 
452     //Locks the contract for owner for the amount of time provided
453     function lock(uint256 time) public virtual onlyOwner {
454         _previousOwner = _owner;
455         _owner = address(0);
456         _lockTime = block.timestamp + time;
457         emit OwnershipTransferred(_owner, address(0));
458     }
459     
460     //Unlocks the contract for owner when _lockTime is exceeds
461     function unlock() public virtual {
462         require(_previousOwner == msg.sender, "You don't have permission to unlock");
463         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
464         emit OwnershipTransferred(_owner, _previousOwner);
465         _owner = _previousOwner;
466     }
467 }
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
485 interface IUniswapV2Pair {
486     event Approval(address indexed owner, address indexed spender, uint value);
487     event Transfer(address indexed from, address indexed to, uint value);
488 
489     function name() external pure returns (string memory);
490     function symbol() external pure returns (string memory);
491     function decimals() external pure returns (uint8);
492     function totalSupply() external view returns (uint);
493     function balanceOf(address owner) external view returns (uint);
494     function allowance(address owner, address spender) external view returns (uint);
495 
496     function approve(address spender, uint value) external returns (bool);
497     function transfer(address to, uint value) external returns (bool);
498     function transferFrom(address from, address to, uint value) external returns (bool);
499 
500     function DOMAIN_SEPARATOR() external view returns (bytes32);
501     function PERMIT_TYPEHASH() external pure returns (bytes32);
502     function nonces(address owner) external view returns (uint);
503 
504     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
505 
506     event Mint(address indexed sender, uint amount0, uint amount1);
507     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
508     event Swap(
509         address indexed sender,
510         uint amount0In,
511         uint amount1In,
512         uint amount0Out,
513         uint amount1Out,
514         address indexed to
515     );
516     event Sync(uint112 reserve0, uint112 reserve1);
517 
518     function MINIMUM_LIQUIDITY() external pure returns (uint);
519     function factory() external view returns (address);
520     function token0() external view returns (address);
521     function token1() external view returns (address);
522     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
523     function price0CumulativeLast() external view returns (uint);
524     function price1CumulativeLast() external view returns (uint);
525     function kLast() external view returns (uint);
526 
527     function mint(address to) external returns (uint liquidity);
528     function burn(address to) external returns (uint amount0, uint amount1);
529     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
530     function skim(address to) external;
531     function sync() external;
532 
533     function initialize(address, address) external;
534 }
535 
536 interface IUniswapV2Router01 {
537     function factory() external pure returns (address);
538     function WETH() external pure returns (address);
539 
540     function addLiquidity(
541         address tokenA,
542         address tokenB,
543         uint amountADesired,
544         uint amountBDesired,
545         uint amountAMin,
546         uint amountBMin,
547         address to,
548         uint deadline
549     ) external returns (uint amountA, uint amountB, uint liquidity);
550     function addLiquidityETH(
551         address token,
552         uint amountTokenDesired,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline
557     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
558     function removeLiquidity(
559         address tokenA,
560         address tokenB,
561         uint liquidity,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline
566     ) external returns (uint amountA, uint amountB);
567     function removeLiquidityETH(
568         address token,
569         uint liquidity,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountToken, uint amountETH);
575     function removeLiquidityWithPermit(
576         address tokenA,
577         address tokenB,
578         uint liquidity,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline,
583         bool approveMax, uint8 v, bytes32 r, bytes32 s
584     ) external returns (uint amountA, uint amountB);
585     function removeLiquidityETHWithPermit(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountToken, uint amountETH);
594     function swapExactTokensForTokens(
595         uint amountIn,
596         uint amountOutMin,
597         address[] calldata path,
598         address to,
599         uint deadline
600     ) external returns (uint[] memory amounts);
601     function swapTokensForExactTokens(
602         uint amountOut,
603         uint amountInMax,
604         address[] calldata path,
605         address to,
606         uint deadline
607     ) external returns (uint[] memory amounts);
608     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
609         external
610         payable
611         returns (uint[] memory amounts);
612     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
613         external
614         returns (uint[] memory amounts);
615     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
616         external
617         returns (uint[] memory amounts);
618     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
619         external
620         payable
621         returns (uint[] memory amounts);
622 
623     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
624     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
625     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
626     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
627     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
628 }
629 
630 interface IUniswapV2Router02 is IUniswapV2Router01 {
631     function removeLiquidityETHSupportingFeeOnTransferTokens(
632         address token,
633         uint liquidity,
634         uint amountTokenMin,
635         uint amountETHMin,
636         address to,
637         uint deadline
638     ) external returns (uint amountETH);
639     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
640         address token,
641         uint liquidity,
642         uint amountTokenMin,
643         uint amountETHMin,
644         address to,
645         uint deadline,
646         bool approveMax, uint8 v, bytes32 r, bytes32 s
647     ) external returns (uint amountETH);
648 
649     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external;
656     function swapExactETHForTokensSupportingFeeOnTransferTokens(
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external payable;
662     function swapExactTokensForETHSupportingFeeOnTransferTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external;
669 }
670 
671 contract F11 is Context, IERC20, Ownable {
672     using SafeMath for uint256;
673     using Address for address;
674 
675     mapping (address => uint256) private _rOwned;
676     mapping (address => uint256) private _tOwned;
677     mapping (address => mapping (address => uint256)) private _allowances;
678 
679     mapping (address => bool) private _isExcludedFromFee;
680 
681     mapping (address => bool) private _isExcluded;
682     address[] private _excluded;
683 
684     mapping (address => bool) public _isExcludedBal; // list for Max Bal limits
685    
686     uint256 private constant MAX = ~uint256(0);
687     uint256 private _tTotal = 2000000000 * 10**6 * 10**18; 
688     uint256 private _rTotal = (MAX - (MAX % _tTotal));
689     uint256 private _tFeeTotal;
690 
691     string private _name = "First Eleven";
692     string private _symbol = "F11";
693     uint8 private _decimals = 18;
694     
695     uint256 public _burnFee = 5;
696     uint256 private _previousBurnFee = _burnFee;
697     
698     uint256 public _taxFee = 5;
699     uint256 private _previousTaxFee = _taxFee;
700     
701     uint256 private _liquidityFee = 10;
702     uint256 private _previousLiquidityFee = _liquidityFee;
703     
704     uint256 public _buyFees = 9;
705     uint256 public _sellFees = 12;
706 
707     address public marketing = 0xcae28D03f6042E57B79790840890b53AFDab825a;
708 
709     IUniswapV2Router02 public uniswapV2Router;
710     address public uniswapV2Pair;
711     
712     bool inSwapAndLiquify;
713     bool public swapAndLiquifyEnabled = true;
714     
715     uint256 public _maxBalAmount = 0;
716     uint256 public numTokensSellToAddToLiquidity = 1 * 10**18;
717     
718     bool public _taxEnabled = true;
719 
720     event SetTaxEnable(bool enabled);
721     event SetSellFeePercent(uint256 sellFee);
722     event SetBuyFeePercent(uint256 buyFee);
723     event SetTaxFeePercent(uint256 taxFee);
724     event SetMaxBalPercent(uint256 maxBalPercent);
725     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
726     event SwapAndLiquifyEnabledUpdated(bool enabled);
727     event TaxEnabledUpdated(bool enabled);
728     event SwapAndLiquify(
729         uint256 tokensSwapped,
730         uint256 ethReceived
731     );
732     
733     modifier lockTheSwap {
734         inSwapAndLiquify = true;
735         _;
736         inSwapAndLiquify = false;
737     }
738     
739     constructor () {
740         _rOwned[msg.sender] = _rTotal;
741         
742         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
743          // Create a uniswap pair for this new token
744         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
745             .createPair(address(this), _uniswapV2Router.WETH());
746 
747         // set the rest of the contract variables
748         uniswapV2Router = _uniswapV2Router;
749         
750         //exclude owner and this contract from fee
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753 
754         _isExcluded[uniswapV2Pair] = true; // excluded from rewards
755 
756         _isExcludedBal[uniswapV2Pair] = true; 
757         _isExcludedBal[owner()] = true;
758         _isExcludedBal[address(this)] = true; 
759         _isExcludedBal[address(0)] = true; 
760         
761         emit Transfer(address(0), msg.sender, _tTotal);
762         _transfer(_msgSender(), address(0), _tTotal.div(2));
763         
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
825     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
826         require(tAmount <= _tTotal, "Amount must be less than supply");
827         if (!deductTransferFee) {
828             (uint256 rAmount,,,,,,) = _getValues(tAmount);
829             return rAmount;
830         } else {
831             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
832             return rTransferAmount;
833         }
834     }
835 
836     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
837         require(rAmount <= _rTotal, "Amount must be less than total reflections");
838         uint256 currentRate =  _getRate();
839         return rAmount.div(currentRate);
840     }
841 
842     function excludeFromReward(address account) public onlyOwner() {
843         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
844         require(!_isExcluded[account], "Account is already excluded");
845         if(_rOwned[account] > 0) {
846             _tOwned[account] = tokenFromReflection(_rOwned[account]);
847         }
848         _isExcluded[account] = true;
849         _excluded.push(account);
850     }
851 
852     function includeInReward(address account) external onlyOwner() {
853         require(_isExcluded[account], "Account is already excluded");
854         for (uint256 i = 0; i < _excluded.length; i++) {
855             if (_excluded[i] == account) {
856                 _excluded[i] = _excluded[_excluded.length - 1];
857                 _tOwned[account] = 0;
858                 _isExcluded[account] = false;
859                 _excluded.pop();
860                 break;
861             }
862         }
863     }
864 
865     function excludeFromLimit(address account) public onlyOwner() {
866         require(!_isExcludedBal[account], "Account is already excluded");
867         _isExcludedBal[account] = true;
868     }
869 
870     function includeInLimit(address account) external onlyOwner() {
871         require(_isExcludedBal[account], "Account is already excluded");
872         _isExcludedBal[account] = false;
873     }
874 
875     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
876         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
877         _tOwned[sender] = _tOwned[sender].sub(tAmount);
878         _rOwned[sender] = _rOwned[sender].sub(rAmount);
879         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
880         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
881         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
882         if(tBurn > 0) _burn(sender, tBurn);
883         _reflectFee(rFee, tFee);
884         emit Transfer(sender, recipient, tTransferAmount);
885     }
886     
887     function excludeFromFee(address account) public onlyOwner {
888         _isExcludedFromFee[account] = true;
889     }
890     
891     function includeInFee(address account) public onlyOwner {
892         _isExcludedFromFee[account] = false;
893     }
894     
895     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
896         _taxFee = taxFee;
897         emit SetTaxFeePercent(taxFee);
898     }
899     
900     function setSellFeePercent(uint256 sellFee) external onlyOwner() {
901         _sellFees = sellFee;
902         emit SetSellFeePercent(sellFee);
903     }
904 
905     function setBuyFeePercent(uint256 buyFee) external onlyOwner() {
906         _buyFees = buyFee;
907         emit SetBuyFeePercent(buyFee);
908     }
909 
910     function setMaxBalPercent(uint256 maxBalPercent) external onlyOwner() {
911         _maxBalAmount = _tTotal.mul(maxBalPercent).div(
912             10**3
913         );
914         emit SetMaxBalPercent(maxBalPercent);   
915     }
916 
917     function setSwapAmount(uint256 amount) external onlyOwner() {
918         numTokensSellToAddToLiquidity = amount;
919     }
920 
921     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
922         swapAndLiquifyEnabled = _enabled;
923         emit SwapAndLiquifyEnabledUpdated(_enabled);
924     }    
925 
926     function setTaxEnable (bool _enable) public onlyOwner {
927         _taxEnabled = _enable;
928         emit SetTaxEnable(_enable);
929     }
930 
931     //to recieve ETH from uniswapV2Router when swaping
932     receive() external payable {}
933 
934     function _reflectFee(uint256 rFee, uint256 tFee) private {
935         _rTotal = _rTotal.sub(rFee);
936         _tFeeTotal = _tFeeTotal.add(tFee);
937     }
938 
939     function _getValues(uint256 tAmount) private view returns ( uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
940         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getTValues(tAmount);
941         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate(), tBurn);
942         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBurn);
943     }
944 
945     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
946         uint256 tBurn = calculateBurnFee(tAmount);
947         uint256 tFee = calculateTaxFee(tAmount);
948         uint256 tLiquidity = calculateLiquidityFee(tAmount);
949         
950         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurn);
951         return (tTransferAmount, tFee, tLiquidity, tBurn);
952     }
953 
954     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
955         uint256 rAmount = tAmount.mul(currentRate);
956         uint256 rFee = tFee.mul(currentRate);
957         uint256 rLiquidity = tLiquidity.mul(currentRate);
958         uint256 rBurn = tBurn.mul(currentRate);
959         
960         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
961         return (rAmount, rTransferAmount, rFee);
962     }
963 
964     function _getRate() private view returns(uint256) {
965         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
966         return rSupply.div(tSupply);
967     }
968 
969     function _getCurrentSupply() private view returns(uint256, uint256) {
970         uint256 rSupply = _rTotal;
971         uint256 tSupply = _tTotal;      
972         for (uint256 i = 0; i < _excluded.length; i++) {
973             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
974             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
975             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
976         }
977         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
978         return (rSupply, tSupply);
979     }
980     
981     function _takeLiquidity(address sender, uint256 tLiquidity) private {
982         uint256 currentRate =  _getRate();
983         uint256 rLiquidity = tLiquidity.mul(currentRate);
984         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
985         if(_isExcluded[address(this)])
986             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
987         emit Transfer(sender, address(this), tLiquidity);
988         
989     }
990 
991     function _burn(address sender, uint256 tBurn) private {
992         uint256 currentRate =  _getRate();
993         uint256 rLiquidity = tBurn.mul(currentRate);
994         _rOwned[address(0)] = _rOwned[address(0)].add(rLiquidity);
995         if(_isExcluded[address(0)])
996             _tOwned[address(0)] = _tOwned[address(0)].add(tBurn);
997         emit Transfer(sender, address(0), tBurn);
998 
999     }
1000     
1001     
1002     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1003         return _amount.mul(_taxFee).div(10**3);
1004 
1005     }
1006 
1007     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1008         return _amount.mul(_burnFee).div(10**3);
1009 
1010     }
1011 
1012     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1013         return _amount.mul(_liquidityFee).div(
1014             10**2
1015         );
1016     }
1017     
1018     function removeAllFee() private {
1019         if(_taxFee == 0 && _liquidityFee == 0 ) return;
1020     
1021         _previousTaxFee = _taxFee;
1022         _previousLiquidityFee = _liquidityFee;
1023         _previousBurnFee = _burnFee;
1024 
1025         _taxFee = 0;
1026         _liquidityFee = 0;
1027         _burnFee = 0;
1028     }
1029     
1030     function restoreAllFee() private {
1031         _taxFee = _previousTaxFee;
1032         _liquidityFee = _previousLiquidityFee;
1033     }
1034     
1035     function isExcludedFromFee(address account) public view returns(bool) {
1036         return _isExcludedFromFee[account];
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
1053         require(amount > 0, "Transfer amount must be greater than zero");
1054         
1055         uint256 contractTokenBalance = balanceOf(address(this));
1056         
1057         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1058         if (
1059             overMinTokenBalance &&
1060             !inSwapAndLiquify &&
1061             from != uniswapV2Pair &&
1062             swapAndLiquifyEnabled
1063         ) {
1064             swapAndLiquify(contractTokenBalance);
1065         }
1066         
1067         //indicates if fee should be deducted from transfer
1068         bool takeFee = false;
1069 
1070         if(from == uniswapV2Pair || to == uniswapV2Pair) {
1071             takeFee = true;
1072         }
1073 
1074         if(!_taxEnabled || _isExcludedFromFee[from] || _isExcludedFromFee[to]){  //if any account belongs to _isExcludedFromFee account then remove the fee
1075             takeFee = false;
1076         }
1077         if(from == uniswapV2Pair) {
1078             _liquidityFee = _buyFees;
1079         }
1080 
1081         if (to == uniswapV2Pair) {
1082             _liquidityFee = _sellFees;
1083         }
1084         //transfer amount, it will take tax, burn, liquidity fee
1085         _tokenTransfer(from,to,amount,takeFee);
1086     }
1087 
1088     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {        
1089         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1090 
1091         // how much ETH did we just swap into?
1092         uint256 Balance = address(this).balance;
1093 
1094         (bool succ, ) = address(marketing).call{value: Balance}("");
1095         require(succ, "marketing ETH not sent");
1096         emit SwapAndLiquify(contractTokenBalance, Balance);
1097     }
1098 
1099     function swapTokensForEth(uint256 tokenAmount) private {
1100         // generate the uniswap pair path of token -> weth
1101         address[] memory path = new address[](2);
1102         path[0] = address(this);
1103         path[1] = uniswapV2Router.WETH();
1104 
1105         _approve(address(this), address(uniswapV2Router), tokenAmount);
1106 
1107         // make the swap
1108         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1109             tokenAmount,
1110             0, // accept any amount of ETH
1111             path,
1112             address(this),
1113             block.timestamp
1114         );
1115     }
1116 
1117 
1118     //this method is responsible for taking all fee, if takeFee is true
1119     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1120         if(!takeFee)
1121             removeAllFee();
1122         
1123         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1124             _transferFromExcluded(sender, recipient, amount);
1125         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1126             _transferToExcluded(sender, recipient, amount);
1127         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1128             _transferStandard(sender, recipient, amount);
1129         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1130             _transferBothExcluded(sender, recipient, amount);
1131         } else {
1132             _transferStandard(sender, recipient, amount);
1133         }
1134 
1135         if(!_isExcludedBal[recipient] ) {
1136             require(balanceOf(recipient)<= _maxBalAmount, "Balance limit reached");
1137         }        
1138         if(!takeFee)
1139             restoreAllFee();
1140     }
1141 
1142     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1143         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1144         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1145         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1146         if(tBurn > 0) _burn(sender, tBurn);
1147         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1148         _reflectFee(rFee, tFee);
1149         emit Transfer(sender, recipient, tTransferAmount);
1150     }
1151 
1152     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1153         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1157         if(tBurn > 0) _burn(sender, tBurn);
1158         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1159         _reflectFee(rFee, tFee);
1160         emit Transfer(sender, recipient, tTransferAmount);
1161     }
1162 
1163     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1164         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1165         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1166         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1167         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1168         if(tBurn > 0) _burn(sender, tBurn);
1169         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1170         _reflectFee(rFee, tFee);
1171         emit Transfer(sender, recipient, tTransferAmount);
1172     }   
1173 }