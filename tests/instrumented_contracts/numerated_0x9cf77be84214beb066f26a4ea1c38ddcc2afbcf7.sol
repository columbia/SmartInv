1 /* 
2 * https://t.me/metashiba_mshiba
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
670 contract MSHIBA is Context, IERC20, Ownable {
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
683     mapping (address => bool) public _isExcludedBal; // list for Max Bal limits
684    
685     uint256 private constant MAX = ~uint256(0);
686     uint256 private _tTotal = 2000000000 * 10**6 * 10**18; 
687     uint256 private _rTotal = (MAX - (MAX % _tTotal));
688     uint256 private _tFeeTotal;
689 
690     string private _name = "Meta Shiba";
691     string private _symbol = "MSHIBA";
692     uint8 private _decimals = 18;
693     
694     uint256 public _burnFee = 5;
695     uint256 private _previousBurnFee = _burnFee;
696     
697     uint256 public _taxFee = 5;
698     uint256 private _previousTaxFee = _taxFee;
699     
700     uint256 private _liquidityFee = 10;
701     uint256 private _previousLiquidityFee = _liquidityFee;
702     
703     uint256 public _buyFees = 9;
704     uint256 public _sellFees = 12;
705 
706     address public marketing = 0xf2D229CC832661dE2Aa56249c5B7991006868522;
707 
708     IUniswapV2Router02 public uniswapV2Router;
709     address public uniswapV2Pair;
710     
711     bool inSwapAndLiquify;
712     bool public swapAndLiquifyEnabled = true;
713     
714     uint256 public _maxBalAmount = _tTotal.mul(5).div(1000);
715     uint256 public numTokensSellToAddToLiquidity = 1 * 10**18;
716     
717     bool public _taxEnabled = true;
718 
719     event SetTaxEnable(bool enabled);
720     event SetSellFeePercent(uint256 sellFee);
721     event SetBuyFeePercent(uint256 buyFee);
722     event SetTaxFeePercent(uint256 taxFee);
723     event SetMaxBalPercent(uint256 maxBalPercent);
724     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
725     event SwapAndLiquifyEnabledUpdated(bool enabled);
726     event TaxEnabledUpdated(bool enabled);
727     event SwapAndLiquify(
728         uint256 tokensSwapped,
729         uint256 ethReceived
730     );
731     
732     modifier lockTheSwap {
733         inSwapAndLiquify = true;
734         _;
735         inSwapAndLiquify = false;
736     }
737     
738     constructor () {
739         _rOwned[msg.sender] = _rTotal;
740         
741         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
742          // Create a uniswap pair for this new token
743         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
744             .createPair(address(this), _uniswapV2Router.WETH());
745 
746         // set the rest of the contract variables
747         uniswapV2Router = _uniswapV2Router;
748         
749         //exclude owner and this contract from fee
750         _isExcludedFromFee[owner()] = true;
751         _isExcludedFromFee[address(this)] = true;
752 
753         _isExcluded[uniswapV2Pair] = true; // excluded from rewards
754 
755         _isExcludedBal[uniswapV2Pair] = true; 
756         _isExcludedBal[owner()] = true;
757         _isExcludedBal[address(this)] = true; 
758         _isExcludedBal[address(0)] = true; 
759         
760         emit Transfer(address(0), msg.sender, _tTotal);
761         _transfer(_msgSender(), address(0), _tTotal.div(2));
762         
763     }
764 
765     function name() public view returns (string memory) {
766         return _name;
767     }
768 
769     function symbol() public view returns (string memory) {
770         return _symbol;
771     }
772 
773     function decimals() public view returns (uint8) {
774         return _decimals;
775     }
776 
777     function totalSupply() public view override returns (uint256) {
778         return _tTotal;
779     }
780 
781     function balanceOf(address account) public view override returns (uint256) {
782         if (_isExcluded[account]) return _tOwned[account];
783         return tokenFromReflection(_rOwned[account]);
784     }
785 
786     function transfer(address recipient, uint256 amount) public override returns (bool) {
787         _transfer(_msgSender(), recipient, amount);
788         return true;
789     }
790 
791     function allowance(address owner, address spender) public view override returns (uint256) {
792         return _allowances[owner][spender];
793     }
794 
795     function approve(address spender, uint256 amount) public override returns (bool) {
796         _approve(_msgSender(), spender, amount);
797         return true;
798     }
799 
800     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
801         _transfer(sender, recipient, amount);
802         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
803         return true;
804     }
805 
806     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
807         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
808         return true;
809     }
810 
811     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
812         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
813         return true;
814     }
815 
816     function isExcludedFromReward(address account) public view returns (bool) {
817         return _isExcluded[account];
818     }
819 
820     function totalFees() public view returns (uint256) {
821         return _tFeeTotal;
822     }
823 
824     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
825         require(tAmount <= _tTotal, "Amount must be less than supply");
826         if (!deductTransferFee) {
827             (uint256 rAmount,,,,,,) = _getValues(tAmount);
828             return rAmount;
829         } else {
830             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
831             return rTransferAmount;
832         }
833     }
834 
835     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
836         require(rAmount <= _rTotal, "Amount must be less than total reflections");
837         uint256 currentRate =  _getRate();
838         return rAmount.div(currentRate);
839     }
840 
841     function excludeFromReward(address account) public onlyOwner() {
842         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
843         require(!_isExcluded[account], "Account is already excluded");
844         if(_rOwned[account] > 0) {
845             _tOwned[account] = tokenFromReflection(_rOwned[account]);
846         }
847         _isExcluded[account] = true;
848         _excluded.push(account);
849     }
850 
851     function includeInReward(address account) external onlyOwner() {
852         require(_isExcluded[account], "Account is already excluded");
853         for (uint256 i = 0; i < _excluded.length; i++) {
854             if (_excluded[i] == account) {
855                 _excluded[i] = _excluded[_excluded.length - 1];
856                 _tOwned[account] = 0;
857                 _isExcluded[account] = false;
858                 _excluded.pop();
859                 break;
860             }
861         }
862     }
863 
864     function excludeFromLimit(address account) public onlyOwner() {
865         require(!_isExcludedBal[account], "Account is already excluded");
866         _isExcludedBal[account] = true;
867     }
868 
869     function includeInLimit(address account) external onlyOwner() {
870         require(_isExcludedBal[account], "Account is already excluded");
871         _isExcludedBal[account] = false;
872     }
873 
874     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
875         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
876         _tOwned[sender] = _tOwned[sender].sub(tAmount);
877         _rOwned[sender] = _rOwned[sender].sub(rAmount);
878         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
879         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
880         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
881         if(tBurn > 0) _burn(sender, tBurn);
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
894     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
895         _taxFee = taxFee;
896         emit SetTaxFeePercent(taxFee);
897     }
898     
899     function setSellFeePercent(uint256 sellFee) external onlyOwner() {
900         _sellFees = sellFee;
901         emit SetSellFeePercent(sellFee);
902     }
903 
904     function setBuyFeePercent(uint256 buyFee) external onlyOwner() {
905         _buyFees = buyFee;
906         emit SetBuyFeePercent(buyFee);
907     }
908 
909     function setMaxBalPercent(uint256 maxBalPercent) external onlyOwner() {
910         _maxBalAmount = _tTotal.mul(maxBalPercent).div(
911             10**2
912         );
913         emit SetMaxBalPercent(maxBalPercent);   
914     }
915 
916     function setSwapAmount(uint256 amount) external onlyOwner() {
917         numTokensSellToAddToLiquidity = amount;
918     }
919 
920     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
921         swapAndLiquifyEnabled = _enabled;
922         emit SwapAndLiquifyEnabledUpdated(_enabled);
923     }    
924 
925     function setTaxEnable (bool _enable) public onlyOwner {
926         _taxEnabled = _enable;
927         emit SetTaxEnable(_enable);
928     }
929 
930     //to recieve ETH from uniswapV2Router when swaping
931     receive() external payable {}
932 
933     function _reflectFee(uint256 rFee, uint256 tFee) private {
934         _rTotal = _rTotal.sub(rFee);
935         _tFeeTotal = _tFeeTotal.add(tFee);
936     }
937 
938     function _getValues(uint256 tAmount) private view returns ( uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
939         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getTValues(tAmount);
940         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate(), tBurn);
941         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBurn);
942     }
943 
944     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
945         uint256 tBurn = calculateBurnFee(tAmount);
946         uint256 tFee = calculateTaxFee(tAmount);
947         uint256 tLiquidity = calculateLiquidityFee(tAmount);
948         
949         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurn);
950         return (tTransferAmount, tFee, tLiquidity, tBurn);
951     }
952 
953     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
954         uint256 rAmount = tAmount.mul(currentRate);
955         uint256 rFee = tFee.mul(currentRate);
956         uint256 rLiquidity = tLiquidity.mul(currentRate);
957         uint256 rBurn = tBurn.mul(currentRate);
958         
959         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
960         return (rAmount, rTransferAmount, rFee);
961     }
962 
963     function _getRate() private view returns(uint256) {
964         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
965         return rSupply.div(tSupply);
966     }
967 
968     function _getCurrentSupply() private view returns(uint256, uint256) {
969         uint256 rSupply = _rTotal;
970         uint256 tSupply = _tTotal;      
971         for (uint256 i = 0; i < _excluded.length; i++) {
972             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
973             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
974             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
975         }
976         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
977         return (rSupply, tSupply);
978     }
979     
980     function _takeLiquidity(address sender, uint256 tLiquidity) private {
981         uint256 currentRate =  _getRate();
982         uint256 rLiquidity = tLiquidity.mul(currentRate);
983         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
984         if(_isExcluded[address(this)])
985             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
986         emit Transfer(sender, address(this), tLiquidity);
987         
988     }
989 
990     function _burn(address sender, uint256 tBurn) private {
991         uint256 currentRate =  _getRate();
992         uint256 rLiquidity = tBurn.mul(currentRate);
993         _rOwned[address(0)] = _rOwned[address(0)].add(rLiquidity);
994         if(_isExcluded[address(0)])
995             _tOwned[address(0)] = _tOwned[address(0)].add(tBurn);
996         emit Transfer(sender, address(0), tBurn);
997 
998     }
999     
1000     
1001     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1002         return _amount.mul(_taxFee).div(10**3);
1003 
1004     }
1005 
1006     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1007         return _amount.mul(_burnFee).div(10**3);
1008 
1009     }
1010 
1011     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1012         return _amount.mul(_liquidityFee).div(
1013             10**2
1014         );
1015     }
1016     
1017     function removeAllFee() private {
1018         if(_taxFee == 0 && _liquidityFee == 0 ) return;
1019     
1020         _previousTaxFee = _taxFee;
1021         _previousLiquidityFee = _liquidityFee;
1022         
1023         _taxFee = 0;
1024         _liquidityFee = 0;
1025     }
1026     
1027     function restoreAllFee() private {
1028         _taxFee = _previousTaxFee;
1029         _liquidityFee = _previousLiquidityFee;
1030     }
1031     
1032     function isExcludedFromFee(address account) public view returns(bool) {
1033         return _isExcludedFromFee[account];
1034     }
1035 
1036     function _approve(address owner, address spender, uint256 amount) private {
1037         require(owner != address(0), "ERC20: approve from the zero address");
1038         require(spender != address(0), "ERC20: approve to the zero address");
1039 
1040         _allowances[owner][spender] = amount;
1041         emit Approval(owner, spender, amount);
1042     }
1043 
1044     function _transfer(
1045         address from,
1046         address to,
1047         uint256 amount
1048     ) private {
1049         require(from != address(0), "ERC20: transfer from the zero address");
1050         require(amount > 0, "Transfer amount must be greater than zero");
1051         
1052         uint256 contractTokenBalance = balanceOf(address(this));
1053         
1054         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1055         if (
1056             overMinTokenBalance &&
1057             !inSwapAndLiquify &&
1058             from != uniswapV2Pair &&
1059             swapAndLiquifyEnabled
1060         ) {
1061             swapAndLiquify(contractTokenBalance);
1062         }
1063         
1064         //indicates if fee should be deducted from transfer
1065         bool takeFee = false;
1066 
1067         if(from == uniswapV2Pair || to == uniswapV2Pair) {
1068             takeFee = true;
1069         }
1070 
1071         if(!_taxEnabled || _isExcludedFromFee[from] || _isExcludedFromFee[to]){  //if any account belongs to _isExcludedFromFee account then remove the fee
1072             takeFee = false;
1073         }
1074         if(from == uniswapV2Pair) {
1075             _liquidityFee = _buyFees;
1076         }
1077 
1078         if (to == uniswapV2Pair) {
1079             _liquidityFee = _sellFees;
1080         }
1081         //transfer amount, it will take tax, burn, liquidity fee
1082         _tokenTransfer(from,to,amount,takeFee);
1083     }
1084 
1085     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {        
1086         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1087 
1088         // how much ETH did we just swap into?
1089         uint256 Balance = address(this).balance;
1090 
1091         (bool succ, ) = address(marketing).call{value: Balance}("");
1092         require(succ, "marketing ETH not sent");
1093         emit SwapAndLiquify(contractTokenBalance, Balance);
1094     }
1095 
1096     function swapTokensForEth(uint256 tokenAmount) private {
1097         // generate the uniswap pair path of token -> weth
1098         address[] memory path = new address[](2);
1099         path[0] = address(this);
1100         path[1] = uniswapV2Router.WETH();
1101 
1102         _approve(address(this), address(uniswapV2Router), tokenAmount);
1103 
1104         // make the swap
1105         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1106             tokenAmount,
1107             0, // accept any amount of ETH
1108             path,
1109             address(this),
1110             block.timestamp
1111         );
1112     }
1113 
1114 
1115     //this method is responsible for taking all fee, if takeFee is true
1116     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1117         if(!takeFee)
1118             removeAllFee();
1119         
1120         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1121             _transferFromExcluded(sender, recipient, amount);
1122         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1123             _transferToExcluded(sender, recipient, amount);
1124         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1125             _transferStandard(sender, recipient, amount);
1126         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1127             _transferBothExcluded(sender, recipient, amount);
1128         } else {
1129             _transferStandard(sender, recipient, amount);
1130         }
1131 
1132         if(!_isExcludedBal[recipient] ) {
1133             require(balanceOf(recipient)<= _maxBalAmount, "Balance limit reached");
1134         }        
1135         if(!takeFee)
1136             restoreAllFee();
1137     }
1138 
1139     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1140         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1141         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1142         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1143         if(tBurn > 0) _burn(sender, tBurn);
1144         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1145         _reflectFee(rFee, tFee);
1146         emit Transfer(sender, recipient, tTransferAmount);
1147     }
1148 
1149     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1150         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1151         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1152         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1153         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1154         if(tBurn > 0) _burn(sender, tBurn);
1155         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1156         _reflectFee(rFee, tFee);
1157         emit Transfer(sender, recipient, tTransferAmount);
1158     }
1159 
1160     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1161         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1162         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1163         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1164         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1165         if(tBurn > 0) _burn(sender, tBurn);
1166         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1167         _reflectFee(rFee, tFee);
1168         emit Transfer(sender, recipient, tTransferAmount);
1169     }   
1170 }