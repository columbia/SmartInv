1 pragma solidity ^0.6.12;
2 
3 // SPDX-License-Identifier: MIT
4 
5 interface IERC20 {
6 
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 
75 
76 /**
77  * @dev Wrappers over Solidity's arithmetic operations with added overflow
78  * checks.
79  *
80  * Arithmetic operations in Solidity wrap on overflow. This can easily result
81  * in bugs, because programmers usually assume that an overflow raises an
82  * error, which is the standard behavior in high level programming languages.
83  * `SafeMath` restores this intuition by reverting the transaction when an
84  * operation overflows.
85  *
86  * Using this library instead of the unchecked operations eliminates an entire
87  * class of bugs, so it's recommended to use it always.
88  */
89  
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      *
116      * - Subtraction cannot overflow.
117      */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the multiplication of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `*` operator.
144      *
145      * Requirements:
146      *
147      * - Multiplication cannot overflow.
148      */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts with custom message when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 abstract contract Context {
234     function _msgSender() internal view virtual returns (address payable) {
235         return msg.sender;
236     }
237 
238     function _msgData() internal view virtual returns (bytes memory) {
239         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
240         return msg.data;
241     }
242 }
243 
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
405     constructor () internal {
406         address msgSender = _msgSender();
407         _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426      /**
427      * @dev Leaves the contract without owner. It will not be possible to call
428      * `onlyOwner` functions anymore. Can only be called by the current owner.
429      *
430      * NOTE: Renouncing ownership will leave the contract without an owner,
431      * thereby removing any functionality that is only available to the owner.
432      */
433     function renounceOwnership() public virtual onlyOwner {
434         emit OwnershipTransferred(_owner, address(0));
435         _owner = address(0);
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
456         _lockTime = now + time;
457         emit OwnershipTransferred(_owner, address(0));
458     }
459     
460     //Unlocks the contract for owner when _lockTime is exceeds
461     function unlock() public virtual {
462         require(_previousOwner == msg.sender, "You don't have permission to unlock");
463         require(now > _lockTime , "Contract is locked until 7 days");
464         emit OwnershipTransferred(_owner, _previousOwner);
465         _owner = _previousOwner;
466     }
467 }
468 
469 // pragma solidity >=0.5.0;
470 
471 interface IUniswapV2Factory {
472     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
473 
474     function feeTo() external view returns (address);
475     function feeToSetter() external view returns (address);
476 
477     function getPair(address tokenA, address tokenB) external view returns (address pair);
478     function allPairs(uint) external view returns (address pair);
479     function allPairsLength() external view returns (uint);
480 
481     function createPair(address tokenA, address tokenB) external returns (address pair);
482 
483     function setFeeTo(address) external;
484     function setFeeToSetter(address) external;
485 }
486 
487 
488 // pragma solidity >=0.5.0;
489 
490 interface IUniswapV2Pair {
491     event Approval(address indexed owner, address indexed spender, uint value);
492     event Transfer(address indexed from, address indexed to, uint value);
493 
494     function name() external pure returns (string memory);
495     function symbol() external pure returns (string memory);
496     function decimals() external pure returns (uint8);
497     function totalSupply() external view returns (uint);
498     function balanceOf(address owner) external view returns (uint);
499     function allowance(address owner, address spender) external view returns (uint);
500 
501     function approve(address spender, uint value) external returns (bool);
502     function transfer(address to, uint value) external returns (bool);
503     function transferFrom(address from, address to, uint value) external returns (bool);
504 
505     function DOMAIN_SEPARATOR() external view returns (bytes32);
506     function PERMIT_TYPEHASH() external pure returns (bytes32);
507     function nonces(address owner) external view returns (uint);
508 
509     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
510 
511     event Mint(address indexed sender, uint amount0, uint amount1);
512     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
513     event Swap(
514         address indexed sender,
515         uint amount0In,
516         uint amount1In,
517         uint amount0Out,
518         uint amount1Out,
519         address indexed to
520     );
521     event Sync(uint112 reserve0, uint112 reserve1);
522 
523     function MINIMUM_LIQUIDITY() external pure returns (uint);
524     function factory() external view returns (address);
525     function token0() external view returns (address);
526     function token1() external view returns (address);
527     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
528     function price0CumulativeLast() external view returns (uint);
529     function price1CumulativeLast() external view returns (uint);
530     function kLast() external view returns (uint);
531 
532     function mint(address to) external returns (uint liquidity);
533     function burn(address to) external returns (uint amount0, uint amount1);
534     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
535     function skim(address to) external;
536     function sync() external;
537 
538     function initialize(address, address) external;
539 }
540 
541 // pragma solidity >=0.6.2;
542 
543 interface IUniswapV2Router01 {
544     function factory() external pure returns (address);
545     function WETH() external pure returns (address);
546 
547     function addLiquidity(
548         address tokenA,
549         address tokenB,
550         uint amountADesired,
551         uint amountBDesired,
552         uint amountAMin,
553         uint amountBMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountA, uint amountB, uint liquidity);
557     function addLiquidityETH(
558         address token,
559         uint amountTokenDesired,
560         uint amountTokenMin,
561         uint amountETHMin,
562         address to,
563         uint deadline
564     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
565     function removeLiquidity(
566         address tokenA,
567         address tokenB,
568         uint liquidity,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountA, uint amountB);
574     function removeLiquidityETH(
575         address token,
576         uint liquidity,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline
581     ) external returns (uint amountToken, uint amountETH);
582     function removeLiquidityWithPermit(
583         address tokenA,
584         address tokenB,
585         uint liquidity,
586         uint amountAMin,
587         uint amountBMin,
588         address to,
589         uint deadline,
590         bool approveMax, uint8 v, bytes32 r, bytes32 s
591     ) external returns (uint amountA, uint amountB);
592     function removeLiquidityETHWithPermit(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline,
599         bool approveMax, uint8 v, bytes32 r, bytes32 s
600     ) external returns (uint amountToken, uint amountETH);
601     function swapExactTokensForTokens(
602         uint amountIn,
603         uint amountOutMin,
604         address[] calldata path,
605         address to,
606         uint deadline
607     ) external returns (uint[] memory amounts);
608     function swapTokensForExactTokens(
609         uint amountOut,
610         uint amountInMax,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
616         external
617         payable
618         returns (uint[] memory amounts);
619     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
620         external
621         returns (uint[] memory amounts);
622     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         returns (uint[] memory amounts);
625     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
626         external
627         payable
628         returns (uint[] memory amounts);
629 
630     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
631     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
632     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
633     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
634     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
635 }
636 
637 
638 
639 // pragma solidity >=0.6.2;
640 
641 interface IUniswapV2Router02 is IUniswapV2Router01 {
642     function removeLiquidityETHSupportingFeeOnTransferTokens(
643         address token,
644         uint liquidity,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline
649     ) external returns (uint amountETH);
650     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
651         address token,
652         uint liquidity,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline,
657         bool approveMax, uint8 v, bytes32 r, bytes32 s
658     ) external returns (uint amountETH);
659 
660     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
661         uint amountIn,
662         uint amountOutMin,
663         address[] calldata path,
664         address to,
665         uint deadline
666     ) external;
667     function swapExactETHForTokensSupportingFeeOnTransferTokens(
668         uint amountOutMin,
669         address[] calldata path,
670         address to,
671         uint deadline
672     ) external payable;
673     function swapExactTokensForETHSupportingFeeOnTransferTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external;
680 }
681 
682 
683 contract HanzoInu is Context, IERC20, Ownable {
684     using SafeMath for uint256;
685     using Address for address;
686 
687     mapping (address => uint256) private _rOwned;
688     mapping (address => uint256) private _tOwned;
689     mapping (address => mapping (address => uint256)) private _allowances;
690 
691     mapping (address => bool) private _isExcludedFromFee;
692 
693     mapping (address => bool) private _isExcluded;
694     address[] private _excluded;
695    
696     uint256 private constant MAX = ~uint256(0);
697     uint256 private _tTotal = 100000000000000  * 10**9;
698     uint256 private _rTotal = (MAX - (MAX % _tTotal));
699     uint256 private _tFeeTotal;
700 
701     string private _name = "Hanzo Inu";
702     string private _symbol = "HNZO";
703     uint8 private _decimals = 9;
704     
705     uint256 public _taxFee = 2;
706     uint256 private _previousTaxFee = _taxFee;
707     
708     uint256 public _liquidityFee = 0;  
709     uint256 private _previousLiquidityFee = _liquidityFee;
710 
711     IUniswapV2Router02 public immutable uniswapV2Router;
712     address public immutable uniswapV2Pair;
713     
714     bool inSwapAndLiquify;
715     bool public swapAndLiquifyEnabled = true;
716      uint256 private _tBurnTotal;
717     uint256 public _maxTxAmount = 2500000000000 * 10**9;
718     uint256 private numTokensSellToAddToLiquidity = 1000000000000 * 10**9;
719     address private _BurnedWallet;
720     address private _MarketingWallet;
721     uint256 private constant _Burned_FEE = 100;
722     uint256 private constant _Marketing_FEE = 200;
723     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
724     event SwapAndLiquifyEnabledUpdated(bool enabled);
725     event SwapAndLiquify(
726         uint256 tokensSwapped,
727         uint256 ethReceived,
728         uint256 tokensIntoLiqudity
729     );
730     
731     modifier lockTheSwap {
732         inSwapAndLiquify = true;
733         _;
734         inSwapAndLiquify = false;
735     }
736     
737         constructor (address BurnedWallet ,  address MarketingWallet) public {
738         _rOwned[_msgSender()] = _rTotal;
739         
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
753 
754 
755         emit Transfer(address(0), _msgSender(), _tTotal);
756          _BurnedWallet = BurnedWallet;
757          
758         emit Transfer(address(0), _msgSender(), _tTotal);
759         _MarketingWallet = MarketingWallet;
760         
761     }
762     
763 
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
824     function totalBurnedFee() public view returns (uint256) {
825         return _tBurnTotal;
826     }
827     
828     function totalMarketingFee() public view returns (uint256) {
829         return _tBurnTotal;
830     }
831     
832     function getBurnedWallet() public view returns (address) {
833         return _BurnedWallet;
834     }
835     
836     function getMarketingWallet() public view returns (address) {
837         return _MarketingWallet;
838     }
839 
840     function setBurnedWallet(address BurnedWallet) external onlyOwner()  {
841         require(!_isExcluded[BurnedWallet], "Can't be excluded address");
842         _BurnedWallet = BurnedWallet;
843     }
844     
845     function setMarketingWallet(address MarketingWallet) external onlyOwner()  {
846         require(!_isExcluded[MarketingWallet], "Can't be excluded address");
847         _MarketingWallet = MarketingWallet;
848     }
849 
850     function deliver(uint256 tAmount) public {
851         address sender = _msgSender();
852         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
853         (uint256 rAmount,,,,,) = _getValues(tAmount);
854         _rOwned[sender] = _rOwned[sender].sub(rAmount);
855         _rTotal = _rTotal.sub(rAmount);
856         _tFeeTotal = _tFeeTotal.add(tAmount);
857     }
858 
859     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
860         require(tAmount <= _tTotal, "Amount must be less than supply");
861         if (!deductTransferFee) {
862             (uint256 rAmount,,,,,) = _getValues(tAmount);
863             return rAmount;
864         } else {
865             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
866             return rTransferAmount;
867         }
868     }
869 
870     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
871         require(rAmount <= _rTotal, "Amount must be less than total reflections");
872         uint256 currentRate =  _getRate();
873         return rAmount.div(currentRate);
874     }
875 
876     function excludeFromReward(address account) public onlyOwner() {
877         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
878         require(!_isExcluded[account], "Account is already excluded");
879         if(_rOwned[account] > 0) {
880             _tOwned[account] = tokenFromReflection(_rOwned[account]);
881         }
882         _isExcluded[account] = true;
883         _excluded.push(account);
884     }
885 
886     function includeInReward(address account) external onlyOwner() {
887         require(_isExcluded[account], "Account is already excluded");
888         for (uint256 i = 0; i < _excluded.length; i++) {
889             if (_excluded[i] == account) {
890                 _excluded[i] = _excluded[_excluded.length - 1];
891                 _tOwned[account] = 0;
892                 _isExcluded[account] = false;
893                 _excluded.pop();
894                 break;
895             }
896         }
897     }
898         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
899         uint256 currentRate =  _getRate();
900         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
901         uint256 rBurn =  tBurn.mul(currentRate);
902 
903         _tOwned[sender] = _tOwned[sender].sub(tAmount);
904         _rOwned[sender] = _rOwned[sender].sub(rAmount);
905         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
906         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
907 
908         _reflectFee(rFee, rBurn, tFee, tBurn);
909         emit Transfer(sender, recipient, tTransferAmount);
910     }
911     
912         function excludeFromFee(address account) public onlyOwner {
913         _isExcludedFromFee[account] = true;
914     }
915     
916     function includeInFee(address account) public onlyOwner {
917         _isExcludedFromFee[account] = false;
918     }
919     
920     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
921         _taxFee = taxFee;
922     }
923     
924     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
925         _liquidityFee = liquidityFee;
926     }
927    
928     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
929         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
930             10**2
931         );
932     }
933 
934     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
935         swapAndLiquifyEnabled = _enabled;
936         emit SwapAndLiquifyEnabledUpdated(_enabled);
937     }
938     
939      //to recieve ETH from uniswapV2Router when swaping
940     receive() external payable {}
941 
942      function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
943         _rTotal     = _rTotal.sub(rFee);
944         _tFeeTotal  = _tFeeTotal.add(tFee);
945         _tBurnTotal = _tBurnTotal.add(tBurn);
946         _rOwned[_BurnedWallet] = _rOwned[_BurnedWallet].add(rBurn);
947         _rOwned[_MarketingWallet] = _rOwned[_MarketingWallet].add(rBurn);
948     }
949 
950     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
951         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
952         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
953         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
954     }
955 
956     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
957         uint256 tFee = calculateTaxFee(tAmount);
958         uint256 tLiquidity = calculateLiquidityFee(tAmount);
959         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
960         return (tTransferAmount, tFee, tLiquidity);
961     }
962 
963     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
964         uint256 rAmount = tAmount.mul(currentRate);
965         uint256 rFee = tFee.mul(currentRate);
966         uint256 rLiquidity = tLiquidity.mul(currentRate);
967         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
968         return (rAmount, rTransferAmount, rFee);
969     }
970 
971     function _getRate() private view returns(uint256) {
972         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
973         return rSupply.div(tSupply);
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
1003         return _amount.mul(_liquidityFee).div(
1004             10**2
1005         );
1006     }
1007     
1008     function removeAllFee() private {
1009         if(_taxFee == 0 && _liquidityFee == 0) return;
1010         
1011         _previousTaxFee = _taxFee;
1012         _previousLiquidityFee = _liquidityFee;
1013         
1014         _taxFee = 0;
1015         _liquidityFee = 0;
1016     }
1017     
1018     function restoreAllFee() private {
1019         _taxFee = _previousTaxFee;
1020         _liquidityFee = _previousLiquidityFee;
1021     }
1022     
1023     function isExcludedFromFee(address account) public view returns(bool) {
1024         return _isExcludedFromFee[account];
1025     }
1026 
1027     function _approve(address owner, address spender, uint256 amount) private {
1028         require(owner != address(0), "ERC20: approve from the zero address");
1029         require(spender != address(0), "ERC20: approve to the zero address");
1030 
1031         _allowances[owner][spender] = amount;
1032         emit Approval(owner, spender, amount);
1033     }
1034 
1035     function _transfer(
1036         address from,
1037         address to,
1038         uint256 amount
1039     ) private {
1040         require(from != address(0), "ERC20: transfer from the zero address");
1041         require(to != address(0), "ERC20: transfer to the zero address");
1042         require(amount > 0, "Transfer amount must be greater than zero");
1043         if(from != owner() && to != owner())
1044             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1045 
1046         // is the token balance of this contract address over the min number of
1047         // tokens that we need to initiate a swap + liquidity lock?
1048         // also, don't get caught in a circular liquidity event.
1049         // also, don't swap & liquify if sender is uniswap pair.
1050         uint256 contractTokenBalance = balanceOf(address(this));
1051         
1052         if(contractTokenBalance >= _maxTxAmount)
1053         {
1054             contractTokenBalance = _maxTxAmount;
1055         }
1056         
1057         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1058         if (
1059             overMinTokenBalance &&
1060             !inSwapAndLiquify &&
1061             from != uniswapV2Pair &&
1062             swapAndLiquifyEnabled
1063         ) {
1064             contractTokenBalance = numTokensSellToAddToLiquidity;
1065             //add liquidity
1066             swapAndLiquify(contractTokenBalance);
1067         }
1068         
1069         //indicates if fee should be deducted from transfer
1070         bool takeFee = true;
1071         
1072         //if any account belongs to _isExcludedFromFee account then remove the fee
1073         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1074             takeFee = false;
1075         }
1076         
1077         //transfer amount, it will take tax, burn, liquidity fee
1078         _tokenTransfer(from,to,amount,takeFee);
1079     }
1080 
1081     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1082         // split the contract balance into halves
1083         uint256 half = contractTokenBalance.div(2);
1084         uint256 otherHalf = contractTokenBalance.sub(half);
1085 
1086         // capture the contract's current ETH balance.
1087         // this is so that we can capture exactly the amount of ETH that the
1088         // swap creates, and not make the liquidity event include any ETH that
1089         // has been manually sent to the contract
1090         uint256 initialBalance = address(this).balance;
1091 
1092         // swap tokens for ETH
1093         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1094 
1095         // how much ETH did we just swap into?
1096         uint256 newBalance = address(this).balance.sub(initialBalance);
1097 
1098         // add liquidity to uniswap
1099         addLiquidity(otherHalf, newBalance);
1100         
1101         emit SwapAndLiquify(half, newBalance, otherHalf);
1102     }
1103 
1104     function swapTokensForEth(uint256 tokenAmount) private {
1105         // generate the uniswap pair path of token -> weth
1106         address[] memory path = new address[](2);
1107         path[0] = address(this);
1108         path[1] = uniswapV2Router.WETH();
1109 
1110         _approve(address(this), address(uniswapV2Router), tokenAmount);
1111 
1112         // make the swap
1113         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1114             tokenAmount,
1115             0, // accept any amount of ETH
1116             path,
1117             address(this),
1118             block.timestamp
1119         );
1120     }
1121 
1122     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1123         // approve token transfer to cover all possible scenarios
1124         _approve(address(this), address(uniswapV2Router), tokenAmount);
1125 
1126         // add the liquidity
1127         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1128             address(this),
1129             tokenAmount,
1130             0, // slippage is unavoidable
1131             0, // slippage is unavoidable
1132             owner(),
1133             block.timestamp
1134         );
1135     }
1136 
1137     //this method is responsible for taking all fee, if takeFee is true
1138     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1139         if(!takeFee)
1140             removeAllFee();
1141         
1142         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1143             _transferFromExcluded(sender, recipient, amount);
1144         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1145             _transferToExcluded(sender, recipient, amount);
1146         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1147             _transferStandard(sender, recipient, amount);
1148         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1149             _transferBothExcluded(sender, recipient, amount);
1150         } else {
1151             _transferStandard(sender, recipient, amount);
1152         }
1153         
1154         if(!takeFee)
1155             restoreAllFee();
1156     }
1157 
1158    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1159         uint256 currentRate =  _getRate();
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
1161         uint256 rBurn =  tBurn.mul(currentRate);
1162 
1163         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1164         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1165 
1166         _reflectFee(rFee, rBurn, tFee, tBurn);
1167         emit Transfer(sender, recipient, tTransferAmount);
1168     }
1169      function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1170         uint256 currentRate =  _getRate();
1171         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
1172         uint256 rBurn =  tBurn.mul(currentRate);
1173 
1174         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1175         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1176         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1177 
1178         _reflectFee(rFee, rBurn, tFee, tBurn);
1179         emit Transfer(sender, recipient, tTransferAmount);
1180     }
1181 
1182     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1183         uint256 currentRate =  _getRate();
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
1185         uint256 rBurn =  tBurn.mul(currentRate);
1186 
1187         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1188         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1189         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1190 
1191         _reflectFee(rFee, rBurn, tFee, tBurn);
1192         emit Transfer(sender, recipient, tTransferAmount);
1193     }
1194     
1195 }