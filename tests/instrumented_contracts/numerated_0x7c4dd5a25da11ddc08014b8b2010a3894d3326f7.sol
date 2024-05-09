1 /* 
2 * http://t.me/Cash_Portal_Entry
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
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 
447     function geUnlockTime() public view returns (uint256) {
448         return _lockTime;
449     }
450 
451     //Locks the contract for owner for the amount of time provided
452     function lock(uint256 time) public virtual onlyOwner {
453         _previousOwner = _owner;
454         _owner = address(0);
455         _lockTime = block.timestamp + time;
456         emit OwnershipTransferred(_owner, address(0));
457     }
458     
459     //Unlocks the contract for owner when _lockTime is exceeds
460     function unlock() public virtual {
461         require(_previousOwner == msg.sender, "You don't have permission to unlock");
462         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
463         emit OwnershipTransferred(_owner, _previousOwner);
464         _owner = _previousOwner;
465     }
466 }
467 
468 interface IUniswapV2Factory {
469     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
470 
471     function feeTo() external view returns (address);
472     function feeToSetter() external view returns (address);
473 
474     function getPair(address tokenA, address tokenB) external view returns (address pair);
475     function allPairs(uint) external view returns (address pair);
476     function allPairsLength() external view returns (uint);
477 
478     function createPair(address tokenA, address tokenB) external returns (address pair);
479 
480     function setFeeTo(address) external;
481     function setFeeToSetter(address) external;
482 }
483 
484 interface IUniswapV2Pair {
485     event Approval(address indexed owner, address indexed spender, uint value);
486     event Transfer(address indexed from, address indexed to, uint value);
487 
488     function name() external pure returns (string memory);
489     function symbol() external pure returns (string memory);
490     function decimals() external pure returns (uint8);
491     function totalSupply() external view returns (uint);
492     function balanceOf(address owner) external view returns (uint);
493     function allowance(address owner, address spender) external view returns (uint);
494 
495     function approve(address spender, uint value) external returns (bool);
496     function transfer(address to, uint value) external returns (bool);
497     function transferFrom(address from, address to, uint value) external returns (bool);
498 
499     function DOMAIN_SEPARATOR() external view returns (bytes32);
500     function PERMIT_TYPEHASH() external pure returns (bytes32);
501     function nonces(address owner) external view returns (uint);
502 
503     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
504 
505     event Mint(address indexed sender, uint amount0, uint amount1);
506     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
507     event Swap(
508         address indexed sender,
509         uint amount0In,
510         uint amount1In,
511         uint amount0Out,
512         uint amount1Out,
513         address indexed to
514     );
515     event Sync(uint112 reserve0, uint112 reserve1);
516 
517     function MINIMUM_LIQUIDITY() external pure returns (uint);
518     function factory() external view returns (address);
519     function token0() external view returns (address);
520     function token1() external view returns (address);
521     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
522     function price0CumulativeLast() external view returns (uint);
523     function price1CumulativeLast() external view returns (uint);
524     function kLast() external view returns (uint);
525 
526     function mint(address to) external returns (uint liquidity);
527     function burn(address to) external returns (uint amount0, uint amount1);
528     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
529     function skim(address to) external;
530     function sync() external;
531 
532     function initialize(address, address) external;
533 }
534 
535 interface IUniswapV2Router01 {
536     function factory() external pure returns (address);
537     function WETH() external pure returns (address);
538 
539     function addLiquidity(
540         address tokenA,
541         address tokenB,
542         uint amountADesired,
543         uint amountBDesired,
544         uint amountAMin,
545         uint amountBMin,
546         address to,
547         uint deadline
548     ) external returns (uint amountA, uint amountB, uint liquidity);
549     function addLiquidityETH(
550         address token,
551         uint amountTokenDesired,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline
556     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
557     function removeLiquidity(
558         address tokenA,
559         address tokenB,
560         uint liquidity,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline
565     ) external returns (uint amountA, uint amountB);
566     function removeLiquidityETH(
567         address token,
568         uint liquidity,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountToken, uint amountETH);
574     function removeLiquidityWithPermit(
575         address tokenA,
576         address tokenB,
577         uint liquidity,
578         uint amountAMin,
579         uint amountBMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external returns (uint amountA, uint amountB);
584     function removeLiquidityETHWithPermit(
585         address token,
586         uint liquidity,
587         uint amountTokenMin,
588         uint amountETHMin,
589         address to,
590         uint deadline,
591         bool approveMax, uint8 v, bytes32 r, bytes32 s
592     ) external returns (uint amountToken, uint amountETH);
593     function swapExactTokensForTokens(
594         uint amountIn,
595         uint amountOutMin,
596         address[] calldata path,
597         address to,
598         uint deadline
599     ) external returns (uint[] memory amounts);
600     function swapTokensForExactTokens(
601         uint amountOut,
602         uint amountInMax,
603         address[] calldata path,
604         address to,
605         uint deadline
606     ) external returns (uint[] memory amounts);
607     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
608         external
609         payable
610         returns (uint[] memory amounts);
611     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
612         external
613         returns (uint[] memory amounts);
614     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
615         external
616         returns (uint[] memory amounts);
617     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
618         external
619         payable
620         returns (uint[] memory amounts);
621 
622     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
623     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
624     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
625     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
626     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
627 }
628 
629 interface IUniswapV2Router02 is IUniswapV2Router01 {
630     function removeLiquidityETHSupportingFeeOnTransferTokens(
631         address token,
632         uint liquidity,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountETH);
638     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline,
645         bool approveMax, uint8 v, bytes32 r, bytes32 s
646     ) external returns (uint amountETH);
647 
648     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
649         uint amountIn,
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external;
655     function swapExactETHForTokensSupportingFeeOnTransferTokens(
656         uint amountOutMin,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external payable;
661     function swapExactTokensForETHSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668 }
669 
670 contract CASH is Context, IERC20, Ownable {
671     using SafeMath for uint256;
672     using Address for address;
673 
674     mapping (address => uint256) private _rOwned;
675     mapping (address => uint256) private _tOwned;
676     mapping (address => mapping (address => uint256)) private _allowances;
677 
678     mapping (address => bool) private _isExcludedFromFee;
679     mapping (address => bool) public _isBlacklisted; 
680 
681     mapping (address => bool) private _isExcluded;
682     address[] private _excluded;
683 
684     mapping (address => bool) public _isExcludedBal; // list for Max Bal limits
685    
686     uint256 private constant MAX = ~uint256(0);
687     uint256 private _tTotal = 500000000000000 * 10**18; 
688     uint256 private _rTotal = (MAX - (MAX % _tTotal));
689     uint256 private _tFeeTotal;
690 
691     string private _name = "Cash Token";
692     string private _symbol = "CASH";
693     uint8 private _decimals = 18;
694     
695     uint256 public _burnFee = 5;
696     uint256 private _previousBurnFee = _burnFee;
697     
698     uint256 public _taxFee = 5;
699     uint256 private _previousTaxFee = _taxFee;
700     
701     uint256 private _liquidityFee = 12;
702     uint256 private _previousLiquidityFee = _liquidityFee;
703     
704     uint256 public _buyFees = 12;
705     uint256 public _sellFees = 12;
706 
707     address public marketing = 0xFb8E1F9Cd88c1350D694B5D55c9B758539D975d6;
708 
709     IUniswapV2Router02 public uniswapV2Router;
710     address public uniswapV2Pair;
711     
712     bool inSwapAndLiquify;
713     bool public swapAndLiquifyEnabled = true;
714     
715     uint256 public _maxBalAmount = _tTotal.mul(1).div(1000);
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
762 
763         _transfer(_msgSender(), address(0), 250000000000000 * 10**18);
764         
765     }
766 
767     function name() public view returns (string memory) {
768         return _name;
769     }
770 
771     function symbol() public view returns (string memory) {
772         return _symbol;
773     }
774 
775     function decimals() public view returns (uint8) {
776         return _decimals;
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
826     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
827         require(tAmount <= _tTotal, "Amount must be less than supply");
828         if (!deductTransferFee) {
829             (uint256 rAmount,,,,,,) = _getValues(tAmount);
830             return rAmount;
831         } else {
832             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
833             return rTransferAmount;
834         }
835     }
836 
837     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
838         require(rAmount <= _rTotal, "Amount must be less than total reflections");
839         uint256 currentRate =  _getRate();
840         return rAmount.div(currentRate);
841     }
842 
843     function excludeFromReward(address account) public onlyOwner() {
844         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
845         require(!_isExcluded[account], "Account is already excluded");
846         if(_rOwned[account] > 0) {
847             _tOwned[account] = tokenFromReflection(_rOwned[account]);
848         }
849         _isExcluded[account] = true;
850         _excluded.push(account);
851     }
852 
853     function includeInReward(address account) external onlyOwner() {
854         require(_isExcluded[account], "Account is already excluded");
855         for (uint256 i = 0; i < _excluded.length; i++) {
856             if (_excluded[i] == account) {
857                 _excluded[i] = _excluded[_excluded.length - 1];
858                 _tOwned[account] = 0;
859                 _isExcluded[account] = false;
860                 _excluded.pop();
861                 break;
862             }
863         }
864     }
865 
866     function excludeFromLimit(address account) public onlyOwner() {
867         require(!_isExcludedBal[account], "Account is already excluded");
868         _isExcludedBal[account] = true;
869     }
870 
871     function includeInLimit(address account) external onlyOwner() {
872         require(_isExcludedBal[account], "Account is already excluded");
873         _isExcludedBal[account] = false;
874     }
875 
876     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
877         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
878         _tOwned[sender] = _tOwned[sender].sub(tAmount);
879         _rOwned[sender] = _rOwned[sender].sub(rAmount);
880         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
881         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
882         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
883         if(tBurn > 0) _burn(sender, tBurn);
884         _reflectFee(rFee, tFee);
885         emit Transfer(sender, recipient, tTransferAmount);
886     }
887     
888     function setFeeWallet( address _wallet) public onlyOwner {
889         marketing = _wallet;
890     }
891     function excludeFromFee(address account) public onlyOwner {
892         _isExcludedFromFee[account] = true;
893     }
894     
895     function includeInFee(address account) public onlyOwner {
896         _isExcludedFromFee[account] = false;
897     }
898     
899     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
900         _taxFee = taxFee;
901         emit SetTaxFeePercent(taxFee);
902     }
903     
904     function setSellFeePercent(uint256 sellFee) external onlyOwner() {
905         require(sellFee <=25, "fees cannot be more than 25");
906         _sellFees = sellFee;
907         emit SetSellFeePercent(sellFee);
908     }
909 
910     function setBuyFeePercent(uint256 buyFee) external onlyOwner() {
911         require(buyFee <=25, "fees cannot be more than 25");
912         _buyFees = buyFee;
913         emit SetBuyFeePercent(buyFee);
914     }
915 
916     function setMaxBalPercent(uint256 maxBalPercent) external onlyOwner() {
917         _maxBalAmount = _tTotal.mul(maxBalPercent).div(
918             10**3
919         );
920         emit SetMaxBalPercent(maxBalPercent);   
921     }
922 
923     function setSwapAmount(uint256 amount) external onlyOwner() {
924         numTokensSellToAddToLiquidity = amount;
925     }
926 
927     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
928         swapAndLiquifyEnabled = _enabled;
929         emit SwapAndLiquifyEnabledUpdated(_enabled);
930     }    
931 
932     function setTaxEnable (bool _enable) public onlyOwner {
933         _taxEnabled = _enable;
934         emit SetTaxEnable(_enable);
935     }
936 
937     //to recieve ETH from uniswapV2Router when swaping
938     receive() external payable {}
939 
940     function _reflectFee(uint256 rFee, uint256 tFee) private {
941         _rTotal = _rTotal.sub(rFee);
942         _tFeeTotal = _tFeeTotal.add(tFee);
943     }
944 
945     function _getValues(uint256 tAmount) private view returns ( uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
946         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getTValues(tAmount);
947         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate(), tBurn);
948         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBurn);
949     }
950 
951     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
952         uint256 tBurn = calculateBurnFee(tAmount);
953         uint256 tFee = calculateTaxFee(tAmount);
954         uint256 tLiquidity = calculateLiquidityFee(tAmount);
955         
956         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurn);
957         return (tTransferAmount, tFee, tLiquidity, tBurn);
958     }
959 
960     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
961         uint256 rAmount = tAmount.mul(currentRate);
962         uint256 rFee = tFee.mul(currentRate);
963         uint256 rLiquidity = tLiquidity.mul(currentRate);
964         uint256 rBurn = tBurn.mul(currentRate);
965         
966         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
967         return (rAmount, rTransferAmount, rFee);
968     }
969 
970     function _getRate() private view returns(uint256) {
971         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
972         return rSupply.div(tSupply);
973     }
974 
975     function _getCurrentSupply() private view returns(uint256, uint256) {
976         uint256 rSupply = _rTotal;
977         uint256 tSupply = _tTotal;      
978         for (uint256 i = 0; i < _excluded.length; i++) {
979             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
980             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
981             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
982         }
983         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
984         return (rSupply, tSupply);
985     }
986     
987     function _takeLiquidity(address sender, uint256 tLiquidity) private {
988         uint256 currentRate =  _getRate();
989         uint256 rLiquidity = tLiquidity.mul(currentRate);
990         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
991         if(_isExcluded[address(this)])
992             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
993         emit Transfer(sender, address(this), tLiquidity);
994         
995     }
996 
997     function _burn(address sender, uint256 tBurn) private {
998         uint256 currentRate =  _getRate();
999         uint256 rLiquidity = tBurn.mul(currentRate);
1000         _rOwned[address(0)] = _rOwned[address(0)].add(rLiquidity);
1001         if(_isExcluded[address(0)])
1002             _tOwned[address(0)] = _tOwned[address(0)].add(tBurn);
1003         emit Transfer(sender, address(0), tBurn);
1004 
1005     }
1006     
1007     
1008     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1009         return _amount.mul(_taxFee).div(10**3);
1010 
1011     }
1012 
1013     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1014         return _amount.mul(_burnFee).div(10**3);
1015 
1016     }
1017 
1018     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1019         return _amount.mul(_liquidityFee).div(
1020             10**2
1021         );
1022     }
1023     
1024     function removeAllFee() private {
1025         if(_taxFee == 0 && _liquidityFee == 0 && _burnFee == 0) return;
1026     
1027         _previousTaxFee = _taxFee;
1028         _previousLiquidityFee = _liquidityFee;
1029         _previousBurnFee = _burnFee;
1030         
1031         _taxFee = 0;
1032         _liquidityFee = 0;
1033         _burnFee = 0;
1034     }
1035     
1036     function restoreAllFee() private {
1037         _taxFee = _previousTaxFee;
1038         _liquidityFee = _previousLiquidityFee;
1039         _burnFee = _previousBurnFee;
1040     }
1041     
1042     function isExcludedFromFee(address account) public view returns(bool) {
1043         return _isExcludedFromFee[account];
1044     }
1045 
1046     function _approve(address owner, address spender, uint256 amount) private {
1047         require(owner != address(0), "ERC20: approve from the zero address");
1048         require(spender != address(0), "ERC20: approve to the zero address");
1049 
1050         _allowances[owner][spender] = amount;
1051         emit Approval(owner, spender, amount);
1052     }
1053     function addToBlackList (address[] calldata accounts ) public onlyOwner {
1054         for (uint256 i =0; i < accounts.length; ++i ) {
1055             _isBlacklisted[accounts[i]] = true;
1056         }
1057     }
1058 
1059     function removeFromBlackList(address account) public onlyOwner {
1060         _isBlacklisted[account] = false;
1061     }
1062 
1063     function _transfer(
1064         address from,
1065         address to,
1066         uint256 amount
1067     ) private {
1068         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1069         require(from != address(0), "ERC20: transfer from the zero address");
1070         require(amount > 0, "Transfer amount must be greater than zero");
1071         
1072         uint256 contractTokenBalance = balanceOf(address(this));
1073         
1074         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1075         if (
1076             overMinTokenBalance &&
1077             !inSwapAndLiquify &&
1078             from != uniswapV2Pair &&
1079             swapAndLiquifyEnabled
1080         ) {
1081             swapAndLiquify(contractTokenBalance);
1082         }
1083         
1084         //indicates if fee should be deducted from transfer
1085         bool takeFee = false;
1086 
1087         if(from == uniswapV2Pair || to == uniswapV2Pair) {
1088             takeFee = true;
1089         }
1090 
1091         if(!_taxEnabled || _isExcludedFromFee[from] || _isExcludedFromFee[to]){  //if any account belongs to _isExcludedFromFee account then remove the fee
1092             takeFee = false;
1093         }
1094         if(from == uniswapV2Pair) {
1095             _liquidityFee = _buyFees;
1096         }
1097 
1098         if (to == uniswapV2Pair) {
1099             _liquidityFee = _sellFees;
1100         }
1101         //transfer amount, it will take tax, burn, liquidity fee
1102         _tokenTransfer(from,to,amount,takeFee);
1103     }
1104 
1105     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {        
1106         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1107 
1108         // how much ETH did we just swap into?
1109         uint256 Balance = address(this).balance;
1110 
1111         (bool succ, ) = address(marketing).call{value: Balance}("");
1112         require(succ, "marketing ETH not sent");
1113         emit SwapAndLiquify(contractTokenBalance, Balance);
1114     }
1115 
1116     function swapTokensForEth(uint256 tokenAmount) private {
1117         // generate the uniswap pair path of token -> weth
1118         address[] memory path = new address[](2);
1119         path[0] = address(this);
1120         path[1] = uniswapV2Router.WETH();
1121 
1122         _approve(address(this), address(uniswapV2Router), tokenAmount);
1123 
1124         // make the swap
1125         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1126             tokenAmount,
1127             0, // accept any amount of ETH
1128             path,
1129             address(this),
1130             block.timestamp
1131         );
1132     }
1133 
1134 
1135     //this method is responsible for taking all fee, if takeFee is true
1136     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1137         if(!takeFee)
1138             removeAllFee();
1139         
1140         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1141             _transferFromExcluded(sender, recipient, amount);
1142         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1143             _transferToExcluded(sender, recipient, amount);
1144         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1145             _transferStandard(sender, recipient, amount);
1146         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1147             _transferBothExcluded(sender, recipient, amount);
1148         } else {
1149             _transferStandard(sender, recipient, amount);
1150         }
1151 
1152         if(!_isExcludedBal[recipient] ) {
1153             require(balanceOf(recipient)<= _maxBalAmount, "Balance limit reached");
1154         }        
1155         if(!takeFee)
1156             restoreAllFee();
1157     }
1158 
1159     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1161         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1162         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1163         if(tBurn > 0) _burn(sender, tBurn);
1164         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 
1169     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1170         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1171         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1172         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1173         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1174         if(tBurn > 0) _burn(sender, tBurn);
1175         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1176         _reflectFee(rFee, tFee);
1177         emit Transfer(sender, recipient, tTransferAmount);
1178     }
1179 
1180     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1181         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1182         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1183         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1184         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1185         if(tBurn > 0) _burn(sender, tBurn);
1186         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1187         _reflectFee(rFee, tFee);
1188         emit Transfer(sender, recipient, tTransferAmount);
1189     }   
1190 }