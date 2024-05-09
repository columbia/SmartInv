1 pragma solidity 0.8.7;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return payable(msg.sender);
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15 
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98  
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
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
403     constructor() {
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
454         _lockTime = block.timestamp + time;
455         emit OwnershipTransferred(_owner, address(0));
456     }
457     
458     //Unlocks the contract for owner when _lockTime is exceeds
459     function unlock() public virtual {
460         require(_previousOwner == msg.sender, "You don't have permission to unlock");
461         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
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
509     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
510     event Swap(
511         address indexed sender,
512         uint amount0In,
513         uint amount1In,
514         uint amount0Out,
515         uint amount1Out,
516         address indexed to
517     );
518     event Sync(uint112 reserve0, uint112 reserve1);
519 
520     function MINIMUM_LIQUIDITY() external pure returns (uint);
521     function factory() external view returns (address);
522     function token0() external view returns (address);
523     function token1() external view returns (address);
524     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
525     function price0CumulativeLast() external view returns (uint);
526     function price1CumulativeLast() external view returns (uint);
527     function kLast() external view returns (uint);
528 
529     function burn(address to) external returns (uint amount0, uint amount1);
530     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
531     function skim(address to) external;
532     function sync() external;
533 
534     function initialize(address, address) external;
535 }
536 
537 // pragma solidity >=0.6.2;
538 
539 interface IUniswapV2Router01 {
540     function factory() external pure returns (address);
541     function WETH() external pure returns (address);
542 
543     function addLiquidity(
544         address tokenA,
545         address tokenB,
546         uint amountADesired,
547         uint amountBDesired,
548         uint amountAMin,
549         uint amountBMin,
550         address to,
551         uint deadline
552     ) external returns (uint amountA, uint amountB, uint liquidity);
553     function addLiquidityETH(
554         address token,
555         uint amountTokenDesired,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline
560     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
561     function removeLiquidity(
562         address tokenA,
563         address tokenB,
564         uint liquidity,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline
569     ) external returns (uint amountA, uint amountB);
570     function removeLiquidityETH(
571         address token,
572         uint liquidity,
573         uint amountTokenMin,
574         uint amountETHMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountToken, uint amountETH);
578     function removeLiquidityWithPermit(
579         address tokenA,
580         address tokenB,
581         uint liquidity,
582         uint amountAMin,
583         uint amountBMin,
584         address to,
585         uint deadline,
586         bool approveMax, uint8 v, bytes32 r, bytes32 s
587     ) external returns (uint amountA, uint amountB);
588     function removeLiquidityETHWithPermit(
589         address token,
590         uint liquidity,
591         uint amountTokenMin,
592         uint amountETHMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountToken, uint amountETH);
597     function swapExactTokensForTokens(
598         uint amountIn,
599         uint amountOutMin,
600         address[] calldata path,
601         address to,
602         uint deadline
603     ) external returns (uint[] memory amounts);
604     function swapTokensForExactTokens(
605         uint amountOut,
606         uint amountInMax,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external returns (uint[] memory amounts);
611     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
612         external
613         payable
614         returns (uint[] memory amounts);
615     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
616         external
617         returns (uint[] memory amounts);
618     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
619         external
620         returns (uint[] memory amounts);
621     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
622         external
623         payable
624         returns (uint[] memory amounts);
625 
626     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
627     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
628     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
629     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
630     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
631 }
632 
633 
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
678 
679 contract KUSUNOKI is Context, IERC20, Ownable {
680     using SafeMath for uint256;
681     using Address for address;
682 
683     mapping (address => uint256) private _rOwned;
684     mapping (address => uint256) private _tOwned;
685     mapping (address => mapping (address => uint256)) private _allowances;
686 
687     mapping (address => bool) private _isExcludedFromFee;
688 
689     mapping (address => bool) private _isExcluded;
690     address[] private _excluded;
691    
692     uint256 private constant MAX = ~uint256(0);
693     uint256 private _tTotal = 80000000000000000 * 10**18;
694     
695     uint256 private _rTotal = (MAX - (MAX % _tTotal));
696     uint256 private _tFeeTotal;
697 
698     string private _name = "Kusunoki Samurai";
699     string private _symbol = "Kusunoki";
700     uint8 private _decimals = 18;
701     
702     uint256 public _taxFee = 5;
703     uint256 private _previousTaxFee = _taxFee;
704     
705     uint256 public _liquidityFee = 5;
706     uint256 private _previousLiquidityFee = _liquidityFee;
707 
708     uint256 public _burnFee = 3;
709     uint256 private _previousBurnFee = _burnFee;
710     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
711 
712     uint256 public _marketingFee = 5;
713     uint256 private _previousmarketingFee = _marketingFee;
714     address public marketingWallet = 0xaD255aD4ecC8258b436fB1FEe540F1c488C9e060; 
715     
716 
717     IUniswapV2Router02 public  uniswapV2Router;
718     address public  uniswapV2Pair;
719     
720     bool inSwapAndLiquify;
721     bool public swapAndLiquifyEnabled = true;
722 
723     uint256 public numTokensSellToAddToLiquidity = 1600000000000000 * 10**18;
724     uint256 public _maxTxAmount = 80000000000000000 * 10**18;
725     uint256 public maxWalletToken = 80000000000000000 * 10**18;
726     
727     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
728     event SwapAndLiquifyEnabledUpdated(bool enabled);
729     event SwapAndLiquify(
730         uint256 tokensSwapped,
731         uint256 ethReceived,
732         uint256 tokensIntoLiqudity
733     );
734     
735     modifier lockTheSwap {
736         inSwapAndLiquify = true;
737         _;
738         inSwapAndLiquify = false;
739     }
740     
741     constructor() {
742         _rOwned[_msgSender()] = _rTotal;
743         
744         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); 
745          // Create a uniswap pair for this new token
746         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
747             .createPair(address(this), _uniswapV2Router.WETH());
748 
749         // set the rest of the contract variables
750         uniswapV2Router = _uniswapV2Router;
751         
752         //exclude owner and this contract from fee
753         _isExcludedFromFee[owner()] = true;
754         _isExcludedFromFee[marketingWallet] = true;
755         _isExcludedFromFee[address(this)] = true;
756         
757         emit Transfer(address(0), _msgSender(), _tTotal);
758     }
759 
760     function name() public view returns (string memory) {
761         return _name;
762     }
763 
764     function symbol() public view returns (string memory) {
765         return _symbol;
766     }
767 
768     function decimals() public view returns (uint8) {
769         return _decimals;
770     }
771 
772     function totalSupply() public view override returns (uint256) {
773         return _tTotal;
774     }
775 
776     function balanceOf(address account) public view override returns (uint256) {
777         if (_isExcluded[account]) return _tOwned[account];
778         return tokenFromReflection(_rOwned[account]);
779     }
780 
781     function transfer(address recipient, uint256 amount) public override returns (bool) {
782         _transfer(_msgSender(), recipient, amount);
783         return true;
784     }
785 
786     function allowance(address owner, address spender) public view override returns (uint256) {
787         return _allowances[owner][spender];
788     }
789 
790     function approve(address spender, uint256 amount) public override returns (bool) {
791         _approve(_msgSender(), spender, amount);
792         return true;
793     }
794 
795     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
796         _transfer(sender, recipient, amount);
797         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
798         return true;
799     }
800 
801     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
802         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
803         return true;
804     }
805 
806     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
807         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
808         return true;
809     }
810 
811     function isExcludedFromReward(address account) public view returns (bool) {
812         return _isExcluded[account];
813     }
814 
815     function totalFees() public view returns (uint256) {
816         return _tFeeTotal;
817     }
818 
819     function deliver(uint256 tAmount) public {
820         address sender = _msgSender();
821         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
822         (uint256 rAmount,,,,,) = _getValues(tAmount);
823         _rOwned[sender] = _rOwned[sender].sub(rAmount);
824         _rTotal = _rTotal.sub(rAmount);
825         _tFeeTotal = _tFeeTotal.add(tAmount);
826     }
827     
828     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
829         require(rAmount <= _rTotal, "Amount must be less than total reflections");
830         uint256 currentRate =  _getRate();
831         return rAmount.div(currentRate);
832     }
833 
834     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
835         require(tAmount <= _tTotal, "Amount must be less than supply");
836         if (!deductTransferFee) {
837             (uint256 rAmount,,,,,) = _getValues(tAmount);
838             return rAmount;
839         } else {
840             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
841             return rTransferAmount;
842         }
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
857 
858     function excludeFromReward(address account) public onlyOwner() {
859         require(!_isExcluded[account], "Account is already excluded");
860         if(_rOwned[account] > 0) {
861             _tOwned[account] = tokenFromReflection(_rOwned[account]);
862         }
863         _isExcluded[account] = true;
864         _excluded.push(account);
865     }
866 
867     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
868         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
869         _tOwned[sender] = _tOwned[sender].sub(tAmount);
870         _rOwned[sender] = _rOwned[sender].sub(rAmount);
871         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
872         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
873         _takeLiquidity(tLiquidity);
874         _reflectFee(rFee, tFee);
875         emit Transfer(sender, recipient, tTransferAmount);
876     }
877     
878      //to recieve ETH from uniswapV2Router when swaping
879     receive() external payable {}
880 
881     function _reflectFee(uint256 rFee, uint256 tFee) private {
882         _rTotal = _rTotal.sub(rFee);
883         _tFeeTotal = _tFeeTotal.add(tFee);
884     }
885 
886     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
887         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
888         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
889         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
890     }
891 
892     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
893         uint256 tFee = calculateTaxFee(tAmount);
894         uint256 tLiquidity = calculateLiquidityFee(tAmount);
895         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
896         return (tTransferAmount, tFee, tLiquidity);
897     }
898 
899     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
900         uint256 rAmount = tAmount.mul(currentRate);
901         uint256 rFee = tFee.mul(currentRate);
902         uint256 rLiquidity = tLiquidity.mul(currentRate);
903         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
904         return (rAmount, rTransferAmount, rFee);
905     }
906 
907     function _getRate() private view returns(uint256) {
908         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
909         return rSupply.div(tSupply);
910     }
911 
912     function _getCurrentSupply() private view returns(uint256, uint256) {
913         uint256 rSupply = _rTotal;
914         uint256 tSupply = _tTotal;      
915         for (uint256 i = 0; i < _excluded.length; i++) {
916             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
917             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
918             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
919         }
920         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
921         return (rSupply, tSupply);
922     }
923     
924     function _takeLiquidity(uint256 tLiquidity) private {
925         uint256 currentRate =  _getRate();
926         uint256 rLiquidity = tLiquidity.mul(currentRate);
927         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
928         if(_isExcluded[address(this)])
929             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
930     }
931 
932     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
933         return _amount.mul(_taxFee).div(
934             10**2
935         );
936     }
937     
938     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
939         return _amount.mul(_liquidityFee).div(
940             10**2
941         );
942     }
943     
944     function removeAllFee() private {
945         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee==0 && _burnFee==0) return;
946         
947         _previousTaxFee = _taxFee;
948         _previousLiquidityFee = _liquidityFee;
949         _previousBurnFee = _burnFee;
950         _previousmarketingFee = _marketingFee;
951         
952         _taxFee = 0;
953         _liquidityFee = 0;
954         _marketingFee = 0;
955         _burnFee = 0;
956     }
957     
958     function restoreAllFee() private {
959        _taxFee = _previousTaxFee;
960        _liquidityFee = _previousLiquidityFee;
961        _burnFee = _previousBurnFee;
962        _marketingFee = _previousmarketingFee;
963     }
964     
965     function isExcludedFromFee(address account) public view returns(bool) {
966         return _isExcludedFromFee[account];
967     }
968 
969     function _approve(address owner, address spender, uint256 amount) private {
970         require(owner != address(0), "ERC20: approve from the zero address");
971         require(spender != address(0), "ERC20: approve to the zero address");
972 
973         _allowances[owner][spender] = amount;
974         emit Approval(owner, spender, amount);
975     }
976 
977     function _transfer(
978         address from,
979         address to,
980         uint256 amount
981     ) private {
982         require(from != address(0), "ERC20: transfer from the zero address");
983         require(amount > 0, "Transfer amount must be greater than zero");
984         
985         bool excludedAccount = _isExcludedFromFee[from] || _isExcludedFromFee[to];
986         
987         if (from==uniswapV2Pair && !excludedAccount) {
988             uint256 contractBalanceRecepient = balanceOf(to);
989             require(contractBalanceRecepient + amount <= maxWalletToken,"Exceeds maximum wallet token amount.");
990         }
991 
992         uint256 contractTokenBalance = balanceOf(address(this));        
993         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
994         if (
995             overMinTokenBalance &&
996             !inSwapAndLiquify &&
997             from != uniswapV2Pair &&
998             swapAndLiquifyEnabled
999         ) {
1000             contractTokenBalance = numTokensSellToAddToLiquidity;
1001             //add liquidity
1002             swapAndLiquify(contractTokenBalance);
1003         }
1004         
1005         _tokenTransfer(from,to,amount);
1006     }
1007 
1008     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1009         // split the Liquidity tokens balance into halves
1010         uint256 half = contractTokenBalance.div(2);
1011         uint256 otherHalf = contractTokenBalance.sub(half);
1012 
1013         // capture the contract's current ETH balance.
1014         // this is so that we can capture exactly the amount of ETH that the
1015         // swap creates, and not make the liquidity event include any ETH that
1016         // has been manually sent to the contract
1017         uint256 initialBalance = address(this).balance;
1018 
1019         // swap tokens for ETH
1020         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1021 
1022         // how much ETH did we just swap into?
1023         uint256 newBalance = address(this).balance.sub(initialBalance);
1024 
1025         // add liquidity to uniswap
1026         addLiquidity(otherHalf, newBalance);
1027         
1028         emit SwapAndLiquify(half, newBalance, otherHalf);
1029     }
1030 
1031     function swapTokensForEth(uint256 tokenAmount) private {
1032         // generate the uniswap pair path of token -> weth
1033         address[] memory path = new address[](2);
1034         path[0] = address(this);
1035         path[1] = uniswapV2Router.WETH();
1036 
1037         _approve(address(this), address(uniswapV2Router), tokenAmount);
1038 
1039         // make the swap
1040         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1041             tokenAmount,
1042             0, // accept any amount of ETH
1043             path,
1044             address(this),
1045             block.timestamp
1046         );
1047     }
1048 
1049     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1050         // approve token transfer to cover all possible scenarios
1051         _approve(address(this), address(uniswapV2Router), tokenAmount);
1052 
1053         // add the liquidity
1054         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1055             address(this),
1056             tokenAmount,
1057             0, // slippage is unavoidable
1058             0, // slippage is unavoidable
1059             owner(),
1060             block.timestamp
1061         );
1062     }
1063 
1064     //this method is responsible for taking all fee, if takeFee is true
1065     function _tokenTransfer(address sender, address recipient, uint256 amount) private 
1066     {
1067         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1068         {   
1069            removeAllFee(); 
1070         }
1071         else  
1072         {
1073             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1074         }
1075 
1076         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1077             _transferFromExcluded(sender, recipient, amount);
1078         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1079             _transferToExcluded(sender, recipient, amount);
1080         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1081             _transferStandard(sender, recipient, amount);
1082         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1083             _transferBothExcluded(sender, recipient, amount);
1084         } else {
1085             _transferStandard(sender, recipient, amount);
1086         }
1087         
1088         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1089         {
1090             restoreAllFee();
1091         }
1092     }
1093 
1094     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
1095     {
1096         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1097         (tTransferAmount, rTransferAmount) = takeBurn(sender, tTransferAmount, rTransferAmount, tAmount);
1098         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
1099         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1100         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1101         _takeLiquidity(tLiquidity);
1102         _reflectFee(rFee, tFee);
1103         emit Transfer(sender, recipient, tTransferAmount);
1104     }
1105     
1106      function takeBurn(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1107     returns (uint256, uint256)
1108     {
1109         if(_burnFee==0) {  return(tTransferAmount, rTransferAmount); }
1110         uint256 tBurn = tAmount.div(100).mul(_burnFee);
1111         uint256 rBurn = tBurn.mul(_getRate());
1112         rTransferAmount = rTransferAmount.sub(rBurn);
1113         tTransferAmount = tTransferAmount.sub(tBurn);
1114         _rOwned[deadAddress] = _rOwned[deadAddress].add(rBurn);
1115         emit Transfer(sender, deadAddress, tBurn);
1116         return(tTransferAmount, rTransferAmount);
1117     }
1118     
1119     function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1120     returns (uint256, uint256)
1121     {
1122         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
1123         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
1124         uint256 rMarketing = tMarketing.mul(_getRate());
1125         rTransferAmount = rTransferAmount.sub(rMarketing);
1126         tTransferAmount = tTransferAmount.sub(tMarketing);
1127         _rOwned[marketingWallet] = _rOwned[marketingWallet].add(rMarketing);
1128         emit Transfer(sender, marketingWallet, tMarketing);
1129         return(tTransferAmount, rTransferAmount); 
1130     }
1131   
1132     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1133         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1134         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1135         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1136         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1137         _takeLiquidity(tLiquidity);
1138         _reflectFee(rFee, tFee);
1139         emit Transfer(sender, recipient, tTransferAmount);
1140     }
1141 
1142     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1143         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1144         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1145         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1146         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1147         _takeLiquidity(tLiquidity);
1148         _reflectFee(rFee, tFee);
1149         emit Transfer(sender, recipient, tTransferAmount);
1150     }
1151    
1152     function includeInFee(address account) public onlyOwner {
1153         _isExcludedFromFee[account] = false;
1154     }
1155 
1156     function excludeFromFee(address account) public onlyOwner {
1157         _isExcludedFromFee[account] = true;
1158     }
1159     
1160     function setMaxWalletTokend(uint256 _maxToken) external onlyOwner {
1161   	    maxWalletToken = _maxToken * (10**18);
1162   	}
1163 
1164     function setNumTokensSellToAddToLiquidity(uint256 newAmt) external onlyOwner() {
1165         numTokensSellToAddToLiquidity = newAmt * (10**18);
1166     }
1167     
1168     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1169         swapAndLiquifyEnabled = _enabled;
1170         emit SwapAndLiquifyEnabledUpdated(_enabled);
1171     }
1172     
1173     function setMarketingWallet(address newWallet) external onlyOwner() {
1174         marketingWallet = newWallet;
1175     }
1176     
1177     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1178         require(maxTxAmount > 0, "transaction amount must be greater than zero");
1179         _maxTxAmount = maxTxAmount * (10**18);
1180     }
1181     
1182     function setFees(uint256 taxFee, uint256 liquidityFee, uint256 marketingFee, uint256 burnFee) external onlyOwner() {
1183         _taxFee = taxFee;
1184         _liquidityFee = liquidityFee;
1185         _marketingFee = marketingFee;
1186         _burnFee = burnFee;
1187     }
1188     
1189 }