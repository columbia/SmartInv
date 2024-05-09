1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 pragma experimental ABIEncoderV2;
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
236         return msg.sender;
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
406     constructor () internal {
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
457         _lockTime = now + time;
458         emit OwnershipTransferred(_owner, address(0));
459     }
460     
461     //Unlocks the contract for owner when _lockTime is exceeds
462     function unlock() public virtual {
463         require(_previousOwner == msg.sender, "You don't have permission to unlock the token contract");
464         require(now > _lockTime , "Contract is locked until 7 days");
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
512     event Mint(address indexed sender, uint amount0, uint amount1);
513     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
514     event Swap(
515         address indexed sender,
516         uint amount0In,
517         uint amount1In,
518         uint amount0Out,
519         uint amount1Out,
520         address indexed to
521     );
522     event Sync(uint112 reserve0, uint112 reserve1);
523 
524     function MINIMUM_LIQUIDITY() external pure returns (uint);
525     function factory() external view returns (address);
526     function token0() external view returns (address);
527     function token1() external view returns (address);
528     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
529     function price0CumulativeLast() external view returns (uint);
530     function price1CumulativeLast() external view returns (uint);
531     function kLast() external view returns (uint);
532 
533     function mint(address to) external returns (uint liquidity);
534     function burn(address to) external returns (uint amount0, uint amount1);
535     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
536     function skim(address to) external;
537     function sync() external;
538 
539     function initialize(address, address) external;
540 }
541 
542 // pragma solidity >=0.6.2;
543 
544 interface IUniswapV2Router01 {
545     function factory() external pure returns (address);
546     function WETH() external pure returns (address);
547 
548     function addLiquidity(
549         address tokenA,
550         address tokenB,
551         uint amountADesired,
552         uint amountBDesired,
553         uint amountAMin,
554         uint amountBMin,
555         address to,
556         uint deadline
557     ) external returns (uint amountA, uint amountB, uint liquidity);
558     function addLiquidityETH(
559         address token,
560         uint amountTokenDesired,
561         uint amountTokenMin,
562         uint amountETHMin,
563         address to,
564         uint deadline
565     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
566     function removeLiquidity(
567         address tokenA,
568         address tokenB,
569         uint liquidity,
570         uint amountAMin,
571         uint amountBMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountA, uint amountB);
575     function removeLiquidityETH(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline
582     ) external returns (uint amountToken, uint amountETH);
583     function removeLiquidityWithPermit(
584         address tokenA,
585         address tokenB,
586         uint liquidity,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline,
591         bool approveMax, uint8 v, bytes32 r, bytes32 s
592     ) external returns (uint amountA, uint amountB);
593     function removeLiquidityETHWithPermit(
594         address token,
595         uint liquidity,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns (uint amountToken, uint amountETH);
602     function swapExactTokensForTokens(
603         uint amountIn,
604         uint amountOutMin,
605         address[] calldata path,
606         address to,
607         uint deadline
608     ) external returns (uint[] memory amounts);
609     function swapTokensForExactTokens(
610         uint amountOut,
611         uint amountInMax,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external returns (uint[] memory amounts);
616     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
617         external
618         payable
619         returns (uint[] memory amounts);
620     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
621         external
622         returns (uint[] memory amounts);
623     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
624         external
625         returns (uint[] memory amounts);
626     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
627         external
628         payable
629         returns (uint[] memory amounts);
630 
631     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
632     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
633     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
634     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
635     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
636 }
637 
638 
639 
640 // pragma solidity >=0.6.2;
641 
642 interface IUniswapV2Router02 is IUniswapV2Router01 {
643     function removeLiquidityETHSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountETH);
651     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline,
658         bool approveMax, uint8 v, bytes32 r, bytes32 s
659     ) external returns (uint amountETH);
660 
661     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668     function swapExactETHForTokensSupportingFeeOnTransferTokens(
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external payable;
674     function swapExactTokensForETHSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681 }
682 
683 
684 contract LiquidityGeneratorToken is Context, IERC20, Ownable {
685     using SafeMath for uint256;
686     using Address for address;
687     address dead = 0x000000000000000000000000000000000000dEaD;
688     uint256 public maxLiqFee = 10;
689     uint256 public maxTaxFee = 10;
690     uint256 public minMxTxPercentage = 50;
691     uint256 public prevLiqFee;
692     uint256 public prevTaxFee;
693     mapping (address => uint256) private _rOwned;
694     mapping (address => uint256) private _tOwned;
695     mapping (address => mapping (address => uint256)) private _allowances;
696 
697     mapping (address => bool) private _isExcludedFromFee;
698 
699     mapping (address => bool) private _isExcluded;
700     address[] private _excluded;
701     address public router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ; // Uniswap Router
702     uint256 private constant MAX = ~uint256(0);
703     uint256 public _tTotal;
704     uint256 private _rTotal;
705     uint256 private _tFeeTotal;
706     bool public mintedByDxsale = true;
707     string public _name;
708     string public _symbol;
709     uint8 private _decimals;
710     
711     uint256 public _taxFee;
712     uint256 private _previousTaxFee = _taxFee;
713     
714     uint256 public _liquidityFee;
715     uint256 private _previousLiquidityFee = _liquidityFee;
716 
717     IUniswapV2Router02 public immutable uniswapV2Router;
718     address public immutable uniswapV2Pair;
719     
720     bool inSwapAndLiquify;
721     bool public swapAndLiquifyEnabled = false;
722     
723     uint256 public _maxTxAmount;
724     uint256 public numTokensSellToAddToLiquidity;
725     
726     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
727     event SwapAndLiquifyEnabledUpdated(bool enabled);
728     event SwapAndLiquify(
729         uint256 tokensSwapped,
730         uint256 ethReceived,
731         uint256 tokensIntoLiqudity
732     );
733     
734     modifier lockTheSwap {
735         inSwapAndLiquify = true;
736         _;
737         inSwapAndLiquify = false;
738     }
739     
740     constructor (address tokenOwner,string memory name, string memory symbol,uint8 decimal, uint256 amountOfTokenWei,uint8 setTaxFee, uint8 setLiqFee, uint256 _maxTaxFee, uint256 _maxLiqFee, uint256 _minMxTxPer) public {
741         _name = name;
742         _symbol = symbol;
743         _decimals = decimal;
744         _tTotal = amountOfTokenWei;
745         _rTotal = (MAX - (MAX % _tTotal));
746         
747         _rOwned[tokenOwner] = _rTotal;
748         
749         maxTaxFee = _maxTaxFee;        
750         maxLiqFee = _maxLiqFee;
751         minMxTxPercentage = _minMxTxPer;
752         prevTaxFee = setTaxFee;        
753         prevLiqFee = setLiqFee;
754 
755         _maxTxAmount = amountOfTokenWei;
756         numTokensSellToAddToLiquidity = amountOfTokenWei.mul(1).div(1000);
757         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
758          // Create a uniswap pair for this new token
759         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
760             .createPair(address(this), _uniswapV2Router.WETH());
761 
762         // set the rest of the contract variables
763         uniswapV2Router = _uniswapV2Router;
764         
765         //exclude owner and this contract from fee
766         _isExcludedFromFee[owner()] = true;
767         _isExcludedFromFee[address(this)] = true;
768         
769         emit Transfer(address(0), tokenOwner, _tTotal);
770     }
771 
772     function name() public view returns (string memory) {
773         return _name;
774     }
775 
776     function symbol() public view returns (string memory) {
777         return _symbol;
778     }
779 
780     function decimals() public view returns (uint8) {
781         return _decimals;
782     }
783 
784     function totalSupply() public view override returns (uint256) {
785         return _tTotal;
786     }
787 
788     function balanceOf(address account) public view override returns (uint256) {
789         if (_isExcluded[account]) return _tOwned[account];
790         return tokenFromReflection(_rOwned[account]);
791     }
792 
793     function transfer(address recipient, uint256 amount) public override returns (bool) {
794         _transfer(_msgSender(), recipient, amount);
795         return true;
796     }
797 
798     function allowance(address owner, address spender) public view override returns (uint256) {
799         return _allowances[owner][spender];
800     }
801 
802     function approve(address spender, uint256 amount) public override returns (bool) {
803         _approve(_msgSender(), spender, amount);
804         return true;
805     }
806 
807     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
810         return true;
811     }
812 
813     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
815         return true;
816     }
817 
818     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
820         return true;
821     }
822 
823     function isExcludedFromReward(address account) public view returns (bool) {
824         return _isExcluded[account];
825     }
826 
827     function totalFees() public view returns (uint256) {
828         return _tFeeTotal;
829     }
830 
831     function deliver(uint256 tAmount) public {
832         address sender = _msgSender();
833         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
834         (uint256 rAmount,,,,,) = _getValues(tAmount);
835         _rOwned[sender] = _rOwned[sender].sub(rAmount);
836         _rTotal = _rTotal.sub(rAmount);
837         _tFeeTotal = _tFeeTotal.add(tAmount);
838     }
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
857 
858         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
859         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
860         _tOwned[sender] = _tOwned[sender].sub(tAmount);
861         _rOwned[sender] = _rOwned[sender].sub(rAmount);
862         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
863         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
864         _takeLiquidity(tLiquidity);
865         _reflectFee(rFee, tFee);
866         emit Transfer(sender, recipient, tTransferAmount);
867     }
868     
869         function excludeFromFee(address account) public onlyOwner {
870         _isExcludedFromFee[account] = true;
871     }
872     
873     function includeInFee(address account) public onlyOwner {
874         _isExcludedFromFee[account] = false;
875     }
876     
877     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
878          require(taxFee >= 0 && taxFee <=maxTaxFee,"taxFee out of range");
879         _taxFee = taxFee;
880     }
881     
882     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
883          require(liquidityFee >= 0 && liquidityFee <=maxLiqFee,"liquidityFee out of range");
884         _liquidityFee = liquidityFee;
885     }
886    
887     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
888         require(maxTxPercent >= minMxTxPercentage && maxTxPercent <=100,"maxTxPercent out of range");
889         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
890             10**2
891         );
892     }
893 
894     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
895         swapAndLiquifyEnabled = _enabled;
896         emit SwapAndLiquifyEnabledUpdated(_enabled);
897     }
898     
899      //to recieve ETH from uniswapV2Router when swaping
900     receive() external payable {}
901 
902     function _reflectFee(uint256 rFee, uint256 tFee) private {
903         _rTotal = _rTotal.sub(rFee);
904         _tFeeTotal = _tFeeTotal.add(tFee);
905     }
906 
907     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
908         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
909         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
910         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
911     }
912 
913     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
914         uint256 tFee = calculateTaxFee(tAmount);
915         uint256 tLiquidity = calculateLiquidityFee(tAmount);
916         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
917         return (tTransferAmount, tFee, tLiquidity);
918     }
919 
920     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
921         uint256 rAmount = tAmount.mul(currentRate);
922         uint256 rFee = tFee.mul(currentRate);
923         uint256 rLiquidity = tLiquidity.mul(currentRate);
924         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
925         return (rAmount, rTransferAmount, rFee);
926     }
927 
928     function _getRate() private view returns(uint256) {
929         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
930         return rSupply.div(tSupply);
931     }
932 
933     function _getCurrentSupply() private view returns(uint256, uint256) {
934         uint256 rSupply = _rTotal;
935         uint256 tSupply = _tTotal;      
936         for (uint256 i = 0; i < _excluded.length; i++) {
937             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
938             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
939             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
940         }
941         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
942         return (rSupply, tSupply);
943     }
944     
945     function _takeLiquidity(uint256 tLiquidity) private {
946         uint256 currentRate =  _getRate();
947         uint256 rLiquidity = tLiquidity.mul(currentRate);
948         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
949         if(_isExcluded[address(this)])
950             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
951     }
952     
953     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
954         return _amount.mul(_taxFee).div(
955             10**2
956         );
957     }
958 
959     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
960         return _amount.mul(_liquidityFee).div(
961             10**2
962         );
963     }
964     
965     function removeAllFee() private {
966         if(_taxFee == 0 && _liquidityFee == 0) return;
967         
968         _previousTaxFee = _taxFee;
969         _previousLiquidityFee = _liquidityFee;
970         
971         _taxFee = 0;
972         _liquidityFee = 0;
973     }
974     
975     function restoreAllFee() private {
976         _taxFee = _previousTaxFee;
977         _liquidityFee = _previousLiquidityFee;
978     }
979     
980     function isExcludedFromFee(address account) public view returns(bool) {
981         return _isExcludedFromFee[account];
982     }
983 
984     function _approve(address owner, address spender, uint256 amount) private {
985         require(owner != address(0), "ERC20: approve from the zero address");
986         require(spender != address(0), "ERC20: approve to the zero address");
987 
988         _allowances[owner][spender] = amount;
989         emit Approval(owner, spender, amount);
990     }
991 
992     function _transfer(
993         address from,
994         address to,
995         uint256 amount
996     ) private {
997         require(from != address(0), "ERC20: transfer from the zero address");
998         require(to != address(0), "ERC20: transfer to the zero address");
999         require(amount > 0, "Transfer amount must be greater than zero");
1000         if(from != owner() && to != owner())
1001             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1002 
1003         // is the token balance of this contract address over the min number of
1004         // tokens that we need to initiate a swap + liquidity lock?
1005         // also, don't get caught in a circular liquidity event.
1006         // also, don't swap & liquify if sender is uniswap pair.
1007         uint256 contractTokenBalance = balanceOf(address(this));
1008         
1009         if(contractTokenBalance >= _maxTxAmount)
1010         {
1011             contractTokenBalance = _maxTxAmount;
1012         }
1013         
1014         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1015         if (
1016             overMinTokenBalance &&
1017             !inSwapAndLiquify &&
1018             from != uniswapV2Pair &&
1019             swapAndLiquifyEnabled
1020         ) {
1021             contractTokenBalance = numTokensSellToAddToLiquidity;
1022             //add liquidity
1023             swapAndLiquify(contractTokenBalance);
1024         }
1025         
1026         //indicates if fee should be deducted from transfer
1027         bool takeFee = true;
1028         
1029         //if any account belongs to _isExcludedFromFee account then remove the fee
1030         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1031             takeFee = false;
1032         }
1033         
1034         //transfer amount, it will take tax, burn, liquidity fee
1035         _tokenTransfer(from,to,amount,takeFee);
1036     }
1037 
1038     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1039         // split the contract balance into halves
1040         uint256 half = contractTokenBalance.div(2);
1041         uint256 otherHalf = contractTokenBalance.sub(half);
1042 
1043         // capture the contract's current ETH balance.
1044         // this is so that we can capture exactly the amount of ETH that the
1045         // swap creates, and not make the liquidity event include any ETH that
1046         // has been manually sent to the contract
1047         uint256 initialBalance = address(this).balance;
1048 
1049         // swap tokens for ETH
1050         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1051 
1052         // how much ETH did we just swap into?
1053         uint256 newBalance = address(this).balance.sub(initialBalance);
1054 
1055         // add liquidity to uniswap
1056         addLiquidity(otherHalf, newBalance);
1057         
1058         emit SwapAndLiquify(half, newBalance, otherHalf);
1059     }
1060 
1061     function swapTokensForEth(uint256 tokenAmount) private {
1062         // generate the uniswap pair path of token -> weth
1063         address[] memory path = new address[](2);
1064         path[0] = address(this);
1065         path[1] = uniswapV2Router.WETH();
1066 
1067         _approve(address(this), address(uniswapV2Router), tokenAmount);
1068 
1069         // make the swap
1070         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1071             tokenAmount,
1072             0, // accept any amount of ETH
1073             path,
1074             address(this),
1075             block.timestamp
1076         );
1077     }
1078 
1079     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1080         // approve token transfer to cover all possible scenarios
1081         _approve(address(this), address(uniswapV2Router), tokenAmount);
1082 
1083         // add the liquidity
1084         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1085             address(this),
1086             tokenAmount,
1087             0, // slippage is unavoidable
1088             0, // slippage is unavoidable
1089             dead,
1090             block.timestamp
1091         );
1092     }
1093 
1094     //this method is responsible for taking all fee, if takeFee is true
1095     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1096         if(!takeFee)
1097             removeAllFee();
1098         
1099         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1100             _transferFromExcluded(sender, recipient, amount);
1101         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1102             _transferToExcluded(sender, recipient, amount);
1103         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1104             _transferStandard(sender, recipient, amount);
1105         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1106             _transferBothExcluded(sender, recipient, amount);
1107         } else {
1108             _transferStandard(sender, recipient, amount);
1109         }
1110         
1111         if(!takeFee)
1112             restoreAllFee();
1113     }
1114 
1115     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1116         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1117         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1118         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1119         _takeLiquidity(tLiquidity);
1120         _reflectFee(rFee, tFee);
1121         emit Transfer(sender, recipient, tTransferAmount);
1122     }
1123 
1124     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1125         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1126         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1127         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1128         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1129         _takeLiquidity(tLiquidity);
1130         _reflectFee(rFee, tFee);
1131         emit Transfer(sender, recipient, tTransferAmount);
1132     }
1133 
1134     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1135         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1136         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1137         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1138         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1139         _takeLiquidity(tLiquidity);
1140         _reflectFee(rFee, tFee);
1141         emit Transfer(sender, recipient, tTransferAmount);
1142     }
1143 
1144     function disableFees() public onlyOwner {
1145         prevLiqFee = _liquidityFee;
1146         prevTaxFee = _taxFee;
1147         
1148         _maxTxAmount = _tTotal;
1149         _liquidityFee = 0;
1150         _taxFee = 0;
1151         swapAndLiquifyEnabled = false;
1152     }
1153     
1154     function enableFees() public onlyOwner {
1155         _maxTxAmount = _tTotal;
1156         _liquidityFee = prevLiqFee;
1157         _taxFee = prevTaxFee;
1158         swapAndLiquifyEnabled = true;
1159     }
1160 }