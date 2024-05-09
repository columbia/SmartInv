1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.4;
4 
5 
6 interface IERC20 {
7 
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Emitted when `value` tokens are moved from one account (`from`) to
62      * another (`to`).
63      *
64      * Note that `value` may be zero.
65      */
66     event Transfer(address indexed from, address indexed to, uint256 value);
67 
68     /**
69      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
70      * a call to {approve}. `value` is the new allowance.
71      */
72     event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
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
235     function _msgSender() internal view virtual returns (address payable) {
236         return payable(msg.sender);
237     }
238 
239     function _msgData() internal view virtual returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data;
242     }
243 }
244 
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 /**
385  * @dev Contract module which provides a basic access control mechanism, where
386  * there is an account (an owner) that can be granted exclusive access to
387  * specific functions.
388  *
389  * By default, the owner account will be the one that deploys the contract. This
390  * can later be changed with {transferOwnership}.
391  *
392  * This module is used through inheritance. It will make available the modifier
393  * `onlyOwner`, which can be applied to your functions to restrict their use to
394  * the owner.
395  */
396 contract Ownable is Context {
397     address private _owner;
398     address private _previousOwner;
399     uint256 private _lockTime;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor() {
407         address msgSender = _msgSender();
408         _owner = msgSender;
409         emit OwnershipTransferred(address(0), msgSender);
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(_owner == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427      /**
428      * @dev Leaves the contract without owner. It will not be possible to call
429      * `onlyOwner` functions anymore. Can only be called by the current owner.
430      *
431      * NOTE: Renouncing ownership will leave the contract without an owner,
432      * thereby removing any functionality that is only available to the owner.
433      */
434     function renounceOwnership() public virtual onlyOwner {
435         emit OwnershipTransferred(_owner, address(0));
436         _owner = address(0);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Can only be called by the current owner.
442      */
443     function transferOwnership(address newOwner) public virtual onlyOwner {
444         require(newOwner != address(0), "Ownable: new owner is the zero address");
445         emit OwnershipTransferred(_owner, newOwner);
446         _owner = newOwner;
447     }
448 
449     function geUnlockTime() public view returns (uint256) {
450         return _lockTime;
451     }
452 
453     //Locks the contract for owner for the amount of time provided
454     function lock(uint256 time) public virtual onlyOwner {
455         _previousOwner = _owner;
456         _owner = address(0);
457         _lockTime = block.timestamp + time;
458         emit OwnershipTransferred(_owner, address(0));
459     }
460     
461     //Unlocks the contract for owner when _lockTime is exceeds
462     function unlock() public virtual {
463         require(_previousOwner == msg.sender, "You don't have permission to unlock");
464         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
465         emit OwnershipTransferred(_owner, _previousOwner);
466         _owner = _previousOwner;
467     }
468 }
469 
470 // pragma solidity >=0.5.0;
471 
472 interface IUniswapV2Factory {
473     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
474 
475     function feeTo() external view returns (address);
476     function feeToSetter() external view returns (address);
477 
478     function getPair(address tokenA, address tokenB) external view returns (address pair);
479     function allPairs(uint) external view returns (address pair);
480     function allPairsLength() external view returns (uint);
481 
482     function createPair(address tokenA, address tokenB) external returns (address pair);
483 
484     function setFeeTo(address) external;
485     function setFeeToSetter(address) external;
486 }
487 
488 
489 // pragma solidity >=0.5.0;
490 
491 interface IUniswapV2Pair {
492     event Approval(address indexed owner, address indexed spender, uint value);
493     event Transfer(address indexed from, address indexed to, uint value);
494 
495     function name() external pure returns (string memory);
496     function symbol() external pure returns (string memory);
497     function decimals() external pure returns (uint8);
498     function totalSupply() external view returns (uint);
499     function balanceOf(address owner) external view returns (uint);
500     function allowance(address owner, address spender) external view returns (uint);
501 
502     function approve(address spender, uint value) external returns (bool);
503     function transfer(address to, uint value) external returns (bool);
504     function transferFrom(address from, address to, uint value) external returns (bool);
505 
506     function DOMAIN_SEPARATOR() external view returns (bytes32);
507     function PERMIT_TYPEHASH() external pure returns (bytes32);
508     function nonces(address owner) external view returns (uint);
509 
510     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
511 
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
532     function burn(address to) external returns (uint amount0, uint amount1);
533     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
534     function skim(address to) external;
535     function sync() external;
536 
537     function initialize(address, address) external;
538 }
539 
540 // pragma solidity >=0.6.2;
541 
542 interface IUniswapV2Router01 {
543     function factory() external pure returns (address);
544     function WETH() external pure returns (address);
545 
546     function addLiquidity(
547         address tokenA,
548         address tokenB,
549         uint amountADesired,
550         uint amountBDesired,
551         uint amountAMin,
552         uint amountBMin,
553         address to,
554         uint deadline
555     ) external returns (uint amountA, uint amountB, uint liquidity);
556     function addLiquidityETH(
557         address token,
558         uint amountTokenDesired,
559         uint amountTokenMin,
560         uint amountETHMin,
561         address to,
562         uint deadline
563     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
564     function removeLiquidity(
565         address tokenA,
566         address tokenB,
567         uint liquidity,
568         uint amountAMin,
569         uint amountBMin,
570         address to,
571         uint deadline
572     ) external returns (uint amountA, uint amountB);
573     function removeLiquidityETH(
574         address token,
575         uint liquidity,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountToken, uint amountETH);
581     function removeLiquidityWithPermit(
582         address tokenA,
583         address tokenB,
584         uint liquidity,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline,
589         bool approveMax, uint8 v, bytes32 r, bytes32 s
590     ) external returns (uint amountA, uint amountB);
591     function removeLiquidityETHWithPermit(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountToken, uint amountETH);
600     function swapExactTokensForTokens(
601         uint amountIn,
602         uint amountOutMin,
603         address[] calldata path,
604         address to,
605         uint deadline
606     ) external returns (uint[] memory amounts);
607     function swapTokensForExactTokens(
608         uint amountOut,
609         uint amountInMax,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external returns (uint[] memory amounts);
614     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
615         external
616         payable
617         returns (uint[] memory amounts);
618     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
619         external
620         returns (uint[] memory amounts);
621     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
625         external
626         payable
627         returns (uint[] memory amounts);
628 
629     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
630     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
631     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
632     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
633     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
634 }
635 
636 
637 
638 // pragma solidity >=0.6.2;
639 
640 interface IUniswapV2Router02 is IUniswapV2Router01 {
641     function removeLiquidityETHSupportingFeeOnTransferTokens(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline
648     ) external returns (uint amountETH);
649     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline,
656         bool approveMax, uint8 v, bytes32 r, bytes32 s
657     ) external returns (uint amountETH);
658 
659     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
660         uint amountIn,
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external;
666     function swapExactETHForTokensSupportingFeeOnTransferTokens(
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external payable;
672     function swapExactTokensForETHSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679 }
680 
681 
682 contract Inuyasha is Context, IERC20, Ownable {
683     using SafeMath for uint256;
684     using Address for address;
685 
686     mapping (address => uint256) private _rOwned;
687     mapping (address => uint256) private _tOwned;
688     mapping (address => mapping (address => uint256)) private _allowances;
689 
690     mapping (address => bool) private _isExcludedFromFee;
691 
692     mapping (address => bool) private _isExcluded;
693     address[] private _excluded;
694    
695     uint256 private constant MAX = ~uint256(0);
696     uint256 private _tTotal = 100000000000 * 10**18;
697     uint256 private _rTotal = (MAX - (MAX % _tTotal));
698     uint256 private _tFeeTotal;
699 
700     string private _name = "Inuyasha";
701     string private _symbol = "Inuyasha";
702     uint8 private _decimals = 18;
703     
704     uint256 public _taxFee = 2;
705     uint256 private _previousTaxFee = _taxFee;
706     
707     uint256 public _liquidityFee = 4;
708     uint256 private _previousLiquidityFee = _liquidityFee;
709     
710     uint256 public buyBackFeeDivisor = 2;
711 
712     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
713     
714     uint256 private buyBackUpperLimit = 1 * 10**17;
715     uint256 private _buyBackDivisor = 100;
716     bool public buyBackEnabled = true;
717     
718     event BuyBackEnabledUpdated(bool enabled);
719 
720     uint256 public _marketingFee = 5;
721     address public marketingWallet = 0x3a0aB80324B676d0573a41Da6374af827Dc49abE;
722     uint256 private _previousmarketingFee = _marketingFee;
723 
724     IUniswapV2Router02 public  uniswapV2Router;
725     address public  uniswapV2Pair;
726     
727     bool inSwapAndLiquify;
728     bool public swapAndLiquifyEnabled = false;
729 
730     uint256 public numTokensSellToAddToLiquidity = 1000000 * 10**18;
731     uint256 public _maxTxAmount = 10000000000 * 10**18;
732     uint256 public maxWalletToken = 10000000000 * 10**18;
733     
734     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
735     event SwapAndLiquifyEnabledUpdated(bool enabled);
736     event SwapAndLiquify(
737         uint256 tokensSwapped,
738         uint256 ethReceived,
739         uint256 tokensIntoLiqudity
740     );
741     
742     event SwapETHForTokens(
743         uint256 amountIn,
744         address[] path
745     );
746     
747     modifier lockTheSwap {
748         inSwapAndLiquify = true;
749         _;
750         inSwapAndLiquify = false;
751     }
752     
753     constructor() {
754         _rOwned[_msgSender()] = _rTotal;
755         
756         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
757          // Create a uniswap pair for this new token
758         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
759             .createPair(address(this), _uniswapV2Router.WETH());
760 
761         // set the rest of the contract variables
762         uniswapV2Router = _uniswapV2Router;
763         
764         //exclude owner and this contract from fee
765         _isExcludedFromFee[owner()] = true;
766         _isExcludedFromFee[address(this)] = true;
767         
768         emit Transfer(address(0), _msgSender(), _tTotal);
769     }
770 
771     function name() public view returns (string memory) {
772         return _name;
773     }
774 
775     function symbol() public view returns (string memory) {
776         return _symbol;
777     }
778 
779     function decimals() public view returns (uint8) {
780         return _decimals;
781     }
782 
783     function totalSupply() public view override returns (uint256) {
784         return _tTotal;
785     }
786 
787     function balanceOf(address account) public view override returns (uint256) {
788         if (_isExcluded[account]) return _tOwned[account];
789         return tokenFromReflection(_rOwned[account]);
790     }
791 
792     function transfer(address recipient, uint256 amount) public override returns (bool) {
793         _transfer(_msgSender(), recipient, amount);
794         return true;
795     }
796 
797     function allowance(address owner, address spender) public view override returns (uint256) {
798         return _allowances[owner][spender];
799     }
800 
801     function approve(address spender, uint256 amount) public override returns (bool) {
802         _approve(_msgSender(), spender, amount);
803         return true;
804     }
805 
806     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
807         _transfer(sender, recipient, amount);
808         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
809         return true;
810     }
811 
812     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
814         return true;
815     }
816 
817     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
818         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
819         return true;
820     }
821 
822     function isExcludedFromReward(address account) public view returns (bool) {
823         return _isExcluded[account];
824     }
825 
826     function totalFees() public view returns (uint256) {
827         return _tFeeTotal;
828     }
829 
830     function deliver(uint256 tAmount) public {
831         address sender = _msgSender();
832         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
833         (uint256 rAmount,,,,,) = _getValues(tAmount);
834         _rOwned[sender] = _rOwned[sender].sub(rAmount);
835         _rTotal = _rTotal.sub(rAmount);
836         _tFeeTotal = _tFeeTotal.add(tAmount);
837     }
838 
839     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
840         require(tAmount <= _tTotal, "Amount must be less than supply");
841         if (!deductTransferFee) {
842             (uint256 rAmount,,,,,) = _getValues(tAmount);
843             return rAmount;
844         } else {
845             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
846             return rTransferAmount;
847         }
848     }
849 
850     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
851         require(rAmount <= _rTotal, "Amount must be less than total reflections");
852         uint256 currentRate =  _getRate();
853         return rAmount.div(currentRate);
854     }
855 
856     function excludeFromReward(address account) public onlyOwner() {
857         require(!_isExcluded[account], "Account is already excluded");
858         if(_rOwned[account] > 0) {
859             _tOwned[account] = tokenFromReflection(_rOwned[account]);
860         }
861         _isExcluded[account] = true;
862         _excluded.push(account);
863     }
864 
865     function includeInReward(address account) external onlyOwner() {
866         require(_isExcluded[account], "Account is already excluded");
867         for (uint256 i = 0; i < _excluded.length; i++) {
868             if (_excluded[i] == account) {
869                 _excluded[i] = _excluded[_excluded.length - 1];
870                 _tOwned[account] = 0;
871                 _isExcluded[account] = false;
872                 _excluded.pop();
873                 break;
874             }
875         }
876     }
877 
878     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
879         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
880         _tOwned[sender] = _tOwned[sender].sub(tAmount);
881         _rOwned[sender] = _rOwned[sender].sub(rAmount);
882         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
883         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
884         _takeLiquidity(tLiquidity);
885         _reflectFee(rFee, tFee);
886         emit Transfer(sender, recipient, tTransferAmount);
887     }
888     
889 
890     
891      //to recieve ETH from uniswapV2Router when swaping
892     receive() external payable {}
893 
894     function _reflectFee(uint256 rFee, uint256 tFee) private {
895         _rTotal = _rTotal.sub(rFee);
896         _tFeeTotal = _tFeeTotal.add(tFee);
897     }
898 
899     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
900         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
901         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
902         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
903     }
904 
905     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
906         uint256 tFee = calculateTaxFee(tAmount);
907         uint256 tLiquidity = calculateLiquidityFee(tAmount);
908         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
909         return (tTransferAmount, tFee, tLiquidity);
910     }
911 
912     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
913         uint256 rAmount = tAmount.mul(currentRate);
914         uint256 rFee = tFee.mul(currentRate);
915 uint256 rLiquidity = tLiquidity.mul(currentRate);
916         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
917         return (rAmount, rTransferAmount, rFee);
918     }
919 
920     function _getRate() private view returns(uint256) {
921         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
922         return rSupply.div(tSupply);
923     }
924 
925     function _getCurrentSupply() private view returns(uint256, uint256) {
926         uint256 rSupply = _rTotal;
927         uint256 tSupply = _tTotal;      
928         for (uint256 i = 0; i < _excluded.length; i++) {
929             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
930             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
931             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
932         }
933         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
934         return (rSupply, tSupply);
935     }
936     
937     function _takeLiquidity(uint256 tLiquidity) private {
938         uint256 currentRate =  _getRate();
939         uint256 rLiquidity = tLiquidity.mul(currentRate);
940         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
941         if(_isExcluded[address(this)])
942             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
943     }
944     
945     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
946         return _amount.mul(_taxFee).div(
947             10**2
948         );
949     }
950 
951     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
952         return _amount.mul(_liquidityFee).div(
953             10**2
954         );
955     }
956     
957     function removeAllFee() private {
958         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee==0) return;
959         
960         _previousTaxFee = _taxFee;
961         _previousLiquidityFee = _liquidityFee;
962         _previousmarketingFee = _marketingFee;
963         
964         _taxFee = 0;
965         _liquidityFee = 0;
966         _marketingFee = 0;
967     }
968     
969     function restoreAllFee() private {
970        _taxFee = _previousTaxFee;
971        _liquidityFee = _previousLiquidityFee;
972        _marketingFee = _previousmarketingFee;
973     }
974     
975     function isExcludedFromFee(address account) public view returns(bool) {
976         return _isExcludedFromFee[account];
977     }
978 
979     function _approve(address owner, address spender, uint256 amount) private {
980         require(owner != address(0), "ERC20: approve from the zero address");
981         require(spender != address(0), "ERC20: approve to the zero address");
982 
983         _allowances[owner][spender] = amount;
984         emit Approval(owner, spender, amount);
985     }
986 
987     function _transfer(
988         address from,
989         address to,
990         uint256 amount
991     ) private {
992         require(from != address(0), "ERC20: transfer from the zero address");
993         require(amount > 0, "Transfer amount must be greater than zero");
994         
995         bool excludedAccount = _isExcludedFromFee[from] || _isExcludedFromFee[to];
996         
997         if (from == uniswapV2Pair && !excludedAccount) {
998             uint256 contractBalanceRecepient = balanceOf(to);
999             require(
1000                 contractBalanceRecepient + amount <= maxWalletToken,
1001                 "Exceeds maximum wallet token amount."
1002             );
1003             
1004         }
1005 
1006         // is the token balance of this contract address over the min number of
1007         // tokens that we need to initiate a swap + liquidity lock?
1008         // also, don't get caught in a circular liquidity event.
1009         // also, don't swap & liquify if sender is uniswap pair.
1010         uint256 contractTokenBalance = balanceOf(address(this));        
1011         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1012         if (!inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
1013             if(overMinTokenBalance) {
1014                 // swap for buyback and liquidity
1015                 swapAndLiquify(contractTokenBalance);
1016             }
1017             
1018             uint256 balance = address(this).balance;
1019             if (buyBackEnabled && balance > uint256(buyBackUpperLimit)) {
1020                 
1021                 if (balance > buyBackUpperLimit)
1022                     balance = buyBackUpperLimit;
1023                 
1024                 buyBackTokens(balance.div(_buyBackDivisor));
1025             }
1026             
1027         }
1028         
1029         //transfer amount, it will take tax, liquidity fee
1030         _tokenTransfer(from,to,amount);
1031     }
1032 
1033     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1034         uint256 buybackShare = contractTokenBalance.mul(buyBackFeeDivisor).div(_liquidityFee);
1035         uint256 LiquidityShare = contractTokenBalance.sub(buybackShare);
1036         // swap buybackShare
1037         if(buyBackFeeDivisor > 0) {
1038             swapTokensForEth(buybackShare);
1039         }
1040         
1041         // split the Liquidity balance into halves
1042         uint256 half = LiquidityShare.div(2);
1043         uint256 otherHalf = LiquidityShare.sub(half);
1044 
1045         // capture the contract's current ETH balance.
1046         // this is so that we can capture exactly the amount of ETH that the
1047         // swap creates, and not make the liquidity event include any ETH that
1048         // has been manually sent to the contract
1049         uint256 initialBalance = address(this).balance;
1050 
1051         // swap tokens for Liquidity
1052         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1053 
1054         // how much ETH did we just swap into?
1055         uint256 newBalance = address(this).balance.sub(initialBalance);
1056 
1057         // add liquidity to uniswap
1058         addLiquidity(otherHalf, newBalance);
1059         
1060         emit SwapAndLiquify(half, newBalance, otherHalf);
1061     }
1062 
1063     function swapTokensForEth(uint256 tokenAmount) private {
1064         // generate the uniswap pair path of token -> weth
1065         address[] memory path = new address[](2);
1066         path[0] = address(this);
1067         path[1] = uniswapV2Router.WETH();
1068 
1069         _approve(address(this), address(uniswapV2Router), tokenAmount);
1070 
1071         // make the swap
1072         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1073             tokenAmount,
1074             0, // accept any amount of ETH
1075             path,
1076             address(this),
1077             block.timestamp
1078         );
1079     }
1080     
1081     function swapETHForTokens(uint256 amount) private {
1082         // generate the uniswap pair path of token -> weth
1083         address[] memory path = new address[](2);
1084         path[0] = uniswapV2Router.WETH();
1085         path[1] = address(this);
1086 
1087       // make the swap
1088         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1089             0, // accept any amount of Tokens
1090             path,
1091             deadAddress, // Burn address
1092             block.timestamp.add(300)
1093         );
1094         
1095         emit SwapETHForTokens(amount, path);
1096     }
1097     
1098     function buyBackTokens(uint256 amount) private lockTheSwap {
1099     	if (amount > 0) {
1100     	    swapETHForTokens(amount);
1101 	    }
1102     }
1103 
1104     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1105         // approve token transfer to cover all possible scenarios
1106         _approve(address(this), address(uniswapV2Router), tokenAmount);
1107 
1108         // add the liquidity
1109         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1110             address(this),
1111             tokenAmount,
1112             0, // slippage is unavoidable
1113             0, // slippage is unavoidable
1114             owner(),
1115             block.timestamp
1116         );
1117     }
1118 
1119     //this method is responsible for taking all fee, if takeFee is true
1120     function _tokenTransfer(address sender, address recipient, uint256 amount) private
1121     {
1122         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1123         {   
1124            removeAllFee();
1125         }
1126         else  
1127         {
1128             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1129         }
1130 
1131         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1132             _transferFromExcluded(sender, recipient, amount);
1133         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1134             _transferToExcluded(sender, recipient, amount);
1135         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1136             _transferStandard(sender, recipient, amount);
1137         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1138             _transferBothExcluded(sender, recipient, amount);
1139         } else {
1140             _transferStandard(sender, recipient, amount);
1141         }
1142         
1143         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1144         {
1145             restoreAllFee();
1146         }
1147     }
1148 
1149 
1150 
1151     function _transferStandard(address sender, address recipient, uint256 tAmount) private
1152     {
1153         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1154         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
1155         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1157         _takeLiquidity(tLiquidity);
1158         _reflectFee(rFee, tFee);
1159         emit Transfer(sender, recipient, tTransferAmount);
1160     }
1161 
1162     function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1163     returns (uint256, uint256)
1164     {
1165         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
1166         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
1167         uint256 rMarketing = tMarketing.mul(_getRate());
1168         rTransferAmount = rTransferAmount.sub(rMarketing);
1169         tTransferAmount = tTransferAmount.sub(tMarketing);
1170         _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rMarketing);
1171         emit Transfer(sender, marketingWallet, tMarketing);
1172         return(tTransferAmount, rTransferAmount);
1173     }
1174     
1175     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1176         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1177         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1178         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1179         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1180         _takeLiquidity(tLiquidity);
1181         _reflectFee(rFee, tFee);
1182         emit Transfer(sender, recipient, tTransferAmount);
1183     }
1184 
1185     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1186         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1187         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1188         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1189         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1190         _takeLiquidity(tLiquidity);
1191         _reflectFee(rFee, tFee);
1192         emit Transfer(sender, recipient, tTransferAmount);
1193     }
1194     
1195     function prepareForPresale() external onlyOwner() {
1196        _taxFee = 0;
1197        _previousTaxFee = 0;
1198        _liquidityFee = 0;
1199        _previousLiquidityFee = 0;
1200        _marketingFee = 0;
1201        _previousmarketingFee = 0;
1202        _maxTxAmount = 100000000000 * 10**18;
1203        maxWalletToken = 100000000000 * 10**18;
1204        setSwapAndLiquifyEnabled(false);
1205     }
1206     
1207     function afterPresale() external onlyOwner() {
1208        _taxFee = 2;
1209        _previousTaxFee = _taxFee;
1210        _liquidityFee = 4;
1211        _previousLiquidityFee = _liquidityFee;
1212        _marketingFee = 5;
1213        _previousmarketingFee = _marketingFee;
1214        setSwapAndLiquifyEnabled(true);
1215     }
1216 
1217     function excludeFromFee(address account) public onlyOwner {
1218         _isExcludedFromFee[account] = true;
1219     }
1220     
1221     function includeInFee(address account) public onlyOwner {
1222         _isExcludedFromFee[account] = false;
1223     }
1224     
1225     function setMaxWalletTokend(uint256 _maxToken) external onlyOwner {
1226   	    maxWalletToken = _maxToken * (10**18);
1227   	}
1228     
1229     function setMarketingWallet(address newWallet) external onlyOwner() {
1230         marketingWallet = newWallet;
1231     }
1232     
1233     function setBuyBackDivisor(uint256 divisor) external onlyOwner() {
1234         buyBackFeeDivisor = divisor;
1235     }
1236     
1237     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1238         buyBackEnabled = _enabled;
1239         emit BuyBackEnabledUpdated(_enabled);
1240     }
1241     
1242     function SetBuyBackUpperLimitAmount(uint256 _newLimit) public {
1243         buyBackUpperLimit = _newLimit;
1244     }
1245     
1246     function buyBackUpperLimitAmount() public view returns (uint256) {
1247         return buyBackUpperLimit;
1248     }
1249     
1250     function buyBackDivisor() public view returns (uint256) {
1251         return _buyBackDivisor;
1252     }
1253     
1254     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1255         _taxFee = taxFee;
1256     }
1257     
1258     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
1259         _marketingFee = marketingFee;
1260     }
1261     
1262     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1263         _liquidityFee = liquidityFee;
1264     }
1265     
1266     function setNumTokensSellToAddToLiquidity(uint256 newAmt) external onlyOwner() {
1267         numTokensSellToAddToLiquidity = newAmt*10**_decimals;
1268     }
1269     
1270     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1271         require(maxTxAmount > 0, "Cannot set transaction amount as zero");
1272         _maxTxAmount = maxTxAmount * 10**_decimals;
1273     }
1274     
1275     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1276         swapAndLiquifyEnabled = _enabled;
1277         emit SwapAndLiquifyEnabledUpdated(_enabled);
1278     }
1279     
1280 }