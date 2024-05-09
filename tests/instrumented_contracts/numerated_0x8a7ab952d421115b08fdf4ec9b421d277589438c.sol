1 pragma solidity ^0.8.9;
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
232     //function _msgSender() internal view virtual returns (address payable) {
233     function _msgSender() internal view virtual returns (address) {
234         return msg.sender;
235     }
236 
237     function _msgData() internal view virtual returns (bytes memory) {
238         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
239         return msg.data;
240     }
241 }
242 
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 contract Ownable is Context {
395     address private _owner;
396     address private _previousOwner;
397     uint256 private _lockTime;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor () {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
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
486 
487 interface IUniswapV2Pair {
488     event Approval(address indexed owner, address indexed spender, uint value);
489     event Transfer(address indexed from, address indexed to, uint value);
490 
491     function name() external pure returns (string memory);
492     function symbol() external pure returns (string memory);
493     function decimals() external pure returns (uint8);
494     function totalSupply() external view returns (uint);
495     function balanceOf(address owner) external view returns (uint);
496     function allowance(address owner, address spender) external view returns (uint);
497 
498     function approve(address spender, uint value) external returns (bool);
499     function transfer(address to, uint value) external returns (bool);
500     function transferFrom(address from, address to, uint value) external returns (bool);
501 
502     function DOMAIN_SEPARATOR() external view returns (bytes32);
503     function PERMIT_TYPEHASH() external pure returns (bytes32);
504     function nonces(address owner) external view returns (uint);
505 
506     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
507 
508     event Mint(address indexed sender, uint amount0, uint amount1);
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
529     function mint(address to) external returns (uint liquidity);
530     function burn(address to) external returns (uint amount0, uint amount1);
531     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
532     function skim(address to) external;
533     function sync() external;
534 
535     function initialize(address, address) external;
536 }
537 
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
635 
636 interface IUniswapV2Router02 is IUniswapV2Router01 {
637     function removeLiquidityETHSupportingFeeOnTransferTokens(
638         address token,
639         uint liquidity,
640         uint amountTokenMin,
641         uint amountETHMin,
642         address to,
643         uint deadline
644     ) external returns (uint amountETH);
645     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline,
652         bool approveMax, uint8 v, bytes32 r, bytes32 s
653     ) external returns (uint amountETH);
654 
655     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
656         uint amountIn,
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external;
662     function swapExactETHForTokensSupportingFeeOnTransferTokens(
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external payable;
668     function swapExactTokensForETHSupportingFeeOnTransferTokens(
669         uint amountIn,
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external;
675 }
676 
677 interface IAirdrop {
678     function airdrop(address recipient, uint256 amount) external;
679 }
680 
681 contract PUPS is Context, IERC20, Ownable {
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
693     
694     mapping (address => bool) private botWallets;
695     bool botscantrade = false;
696     
697     bool public canTrade = true;
698    
699     uint256 private constant MAX = ~uint256(0);
700     uint256 private _tTotal = 100000000 * 10**9;
701     uint256 private _rTotal = (MAX - (MAX % _tTotal));
702     uint256 private _tFeeTotal;
703     address public marketingWallet;
704 
705     string private _name = "Pups";
706     string private _symbol = "PUPS";
707     uint8 private _decimals = 9;
708     
709     uint256 public _taxFee = 0;
710     uint256 private _previousTaxFee = _taxFee;
711 
712     uint256 public marketingFeePercent = 99;
713     
714     uint256 public _liquidityFee = 0;
715     uint256 private _previousLiquidityFee = _liquidityFee;
716 
717     IUniswapV2Router02 public immutable uniswapV2Router;
718     address public immutable uniswapV2Pair;
719     
720     bool inSwapAndLiquify;
721     bool public swapAndLiquifyEnabled = true;
722     
723     uint256 public _maxTxAmount = 100000 * 10**9;
724     uint256 public numTokensSellToAddToLiquidity = 250000 * 10**9;
725     uint256 public _maxWalletSize = 3000000 * 10**9;
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
741     constructor () {
742         _rOwned[_msgSender()] = _rTotal;
743         
744         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
745          // Create a uniswap pair for this new token
746         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
747             .createPair(address(this), _uniswapV2Router.WETH());
748 
749         // set the rest of the contract variables
750         uniswapV2Router = _uniswapV2Router;
751         
752         //exclude owner and this contract from fee
753         _isExcludedFromFee[owner()] = true;
754         _isExcludedFromFee[address(this)] = true;
755         
756         emit Transfer(address(0), _msgSender(), _tTotal);
757     }
758 
759     function name() public view returns (string memory) {
760         return _name;
761     }
762 
763     function symbol() public view returns (string memory) {
764         return _symbol;
765     }
766 
767     function decimals() public view returns (uint8) {
768         return _decimals;
769     }
770 
771     function totalSupply() public view override returns (uint256) {
772         return _tTotal;
773     }
774 
775     function balanceOf(address account) public view override returns (uint256) {
776         if (_isExcluded[account]) return _tOwned[account];
777         return tokenFromReflection(_rOwned[account]);
778     }
779 
780     function transfer(address recipient, uint256 amount) public override returns (bool) {
781         _transfer(_msgSender(), recipient, amount);
782         return true;
783     }
784 
785     function allowance(address owner, address spender) public view override returns (uint256) {
786         return _allowances[owner][spender];
787     }
788 
789     function approve(address spender, uint256 amount) public override returns (bool) {
790         _approve(_msgSender(), spender, amount);
791         return true;
792     }
793 
794     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
795         _transfer(sender, recipient, amount);
796         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
797         return true;
798     }
799 
800     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
801         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
802         return true;
803     }
804 
805     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
806         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
807         return true;
808     }
809 
810     function isExcludedFromReward(address account) public view returns (bool) {
811         return _isExcluded[account];
812     }
813 
814     function totalFees() public view returns (uint256) {
815         return _tFeeTotal;
816     }
817     
818     function airdrop(address recipient, uint256 amount) external onlyOwner() {
819         removeAllFee();
820         _transfer(_msgSender(), recipient, amount * 10**9);
821         restoreAllFee();
822     }
823     
824     function airdropInternal(address recipient, uint256 amount) internal {
825         removeAllFee();
826         _transfer(_msgSender(), recipient, amount);
827         restoreAllFee();
828     }
829     
830     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
831         uint256 iterator = 0;
832         require(newholders.length == amounts.length, "must be the same length");
833         while(iterator < newholders.length){
834             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
835             iterator += 1;
836         }
837     }
838 
839     function deliver(uint256 tAmount) public {
840         address sender = _msgSender();
841         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
842         (uint256 rAmount,,,,,) = _getValues(tAmount);
843         _rOwned[sender] = _rOwned[sender].sub(rAmount);
844         _rTotal = _rTotal.sub(rAmount);
845         _tFeeTotal = _tFeeTotal.add(tAmount);
846     }
847 
848     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
849         require(tAmount <= _tTotal, "Amount must be less than supply");
850         if (!deductTransferFee) {
851             (uint256 rAmount,,,,,) = _getValues(tAmount);
852             return rAmount;
853         } else {
854             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
855             return rTransferAmount;
856         }
857     }
858 
859     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
860         require(rAmount <= _rTotal, "Amount must be less than total reflections");
861         uint256 currentRate =  _getRate();
862         return rAmount.div(currentRate);
863     }
864 
865     function excludeFromReward(address account) public onlyOwner() {
866         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
867         require(!_isExcluded[account], "Account is already excluded");
868         if(_rOwned[account] > 0) {
869             _tOwned[account] = tokenFromReflection(_rOwned[account]);
870         }
871         _isExcluded[account] = true;
872         _excluded.push(account);
873     }
874 
875     function includeInReward(address account) external onlyOwner() {
876         require(_isExcluded[account], "Account is already excluded");
877         for (uint256 i = 0; i < _excluded.length; i++) {
878             if (_excluded[i] == account) {
879                 _excluded[i] = _excluded[_excluded.length - 1];
880                 _tOwned[account] = 0;
881                 _isExcluded[account] = false;
882                 _excluded.pop();
883                 break;
884             }
885         }
886     }
887         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
888         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
889         _tOwned[sender] = _tOwned[sender].sub(tAmount);
890         _rOwned[sender] = _rOwned[sender].sub(rAmount);
891         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
892         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
893         _takeLiquidity(tLiquidity);
894         _reflectFee(rFee, tFee);
895         emit Transfer(sender, recipient, tTransferAmount);
896     }
897     
898     function excludeFromFee(address account) public onlyOwner {
899         _isExcludedFromFee[account] = true;
900     }
901     
902     function includeInFee(address account) public onlyOwner {
903         _isExcludedFromFee[account] = false;
904     }
905     function setMarketingFeePercent(uint256 fee) public onlyOwner {
906         marketingFeePercent = fee;
907     }
908 
909     function setMarketingWallet(address walletAddress) public onlyOwner {
910         marketingWallet = walletAddress;
911     }
912     
913     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
914         require(taxFee < 10, "Tax fee cannot be more than 10%");
915         _taxFee = taxFee;
916     }
917     
918     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
919         _liquidityFee = liquidityFee;
920     }
921 
922     function _setMaxWalletSizePercent(uint256 maxWalletSize)
923         external
924         onlyOwner
925     {
926         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
927     }
928    
929     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
930         require(maxTxAmount > 200000, "Max Tx Amount cannot be less than 69 Million");
931         _maxTxAmount = maxTxAmount * 10**9;
932     }
933     
934     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
935         require(SwapThresholdAmount > 200000, "Swap Threshold Amount cannot be less than 69 Million");
936         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
937     }
938     
939     function claimTokens () public onlyOwner {
940         // make sure we capture all BNB that may or may not be sent to this contract
941         payable(marketingWallet).transfer(address(this).balance);
942     }
943     
944     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
945         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
946     }
947     
948     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
949         walletaddress.transfer(address(this).balance);
950     }
951     
952     function addBotWallet(address botwallet) external onlyOwner() {
953         botWallets[botwallet] = true;
954     }
955     
956     function removeBotWallet(address botwallet) external onlyOwner() {
957         botWallets[botwallet] = false;
958     }
959     
960     function getBotWalletStatus(address botwallet) public view returns (bool) {
961         return botWallets[botwallet];
962     }
963     
964     function allowtrading()external onlyOwner() {
965         canTrade = true;
966     }
967 
968     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
969         swapAndLiquifyEnabled = _enabled;
970         emit SwapAndLiquifyEnabledUpdated(_enabled);
971     }
972     
973      //to recieve ETH from uniswapV2Router when swaping
974     receive() external payable {}
975 
976     function _reflectFee(uint256 rFee, uint256 tFee) private {
977         _rTotal = _rTotal.sub(rFee);
978         _tFeeTotal = _tFeeTotal.add(tFee);
979     }
980 
981     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
982         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
983         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
984         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
985     }
986 
987     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
988         uint256 tFee = calculateTaxFee(tAmount);
989         uint256 tLiquidity = calculateLiquidityFee(tAmount);
990         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
991         return (tTransferAmount, tFee, tLiquidity);
992     }
993 
994     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
995         uint256 rAmount = tAmount.mul(currentRate);
996         uint256 rFee = tFee.mul(currentRate);
997         uint256 rLiquidity = tLiquidity.mul(currentRate);
998         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
999         return (rAmount, rTransferAmount, rFee);
1000     }
1001 
1002     function _getRate() private view returns(uint256) {
1003         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1004         return rSupply.div(tSupply);
1005     }
1006 
1007     function _getCurrentSupply() private view returns(uint256, uint256) {
1008         uint256 rSupply = _rTotal;
1009         uint256 tSupply = _tTotal;      
1010         for (uint256 i = 0; i < _excluded.length; i++) {
1011             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1012             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1013             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1014         }
1015         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1016         return (rSupply, tSupply);
1017     }
1018     
1019     function _takeLiquidity(uint256 tLiquidity) private {
1020         uint256 currentRate =  _getRate();
1021         uint256 rLiquidity = tLiquidity.mul(currentRate);
1022         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1023         if(_isExcluded[address(this)])
1024             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1025     }
1026     
1027     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1028         return _amount.mul(_taxFee).div(
1029             10**2
1030         );
1031     }
1032 
1033     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1034         return _amount.mul(_liquidityFee).div(
1035             10**2
1036         );
1037     }
1038     
1039     function removeAllFee() private {
1040         if(_taxFee == 0 && _liquidityFee == 0) return;
1041         
1042         _previousTaxFee = _taxFee;
1043         _previousLiquidityFee = _liquidityFee;
1044         
1045         _taxFee = 0;
1046         _liquidityFee = 0;
1047     }
1048     
1049     function restoreAllFee() private {
1050         _taxFee = _previousTaxFee;
1051         _liquidityFee = _previousLiquidityFee;
1052     }
1053     
1054     function isExcludedFromFee(address account) public view returns(bool) {
1055         return _isExcludedFromFee[account];
1056     }
1057 
1058     function _approve(address owner, address spender, uint256 amount) private {
1059         require(owner != address(0), "ERC20: approve from the zero address");
1060         require(spender != address(0), "ERC20: approve to the zero address");
1061 
1062         _allowances[owner][spender] = amount;
1063         emit Approval(owner, spender, amount);
1064     }
1065 
1066     function _transfer(
1067         address from,
1068         address to,
1069         uint256 amount
1070     ) private {
1071         require(from != address(0), "ERC20: transfer from the zero address");
1072         require(to != address(0), "ERC20: transfer to the zero address");
1073         require(amount > 0, "Transfer amount must be greater than zero");
1074         if(from != owner() && to != owner())
1075             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1076 
1077         // is the token balance of this contract address over the min number of
1078         // tokens that we need to initiate a swap + liquidity lock?
1079         // also, don't get caught in a circular liquidity event.
1080         // also, don't swap & liquify if sender is uniswap pair.
1081         uint256 contractTokenBalance = balanceOf(address(this));
1082         
1083         if(contractTokenBalance >= _maxTxAmount)
1084         {
1085             contractTokenBalance = _maxTxAmount;
1086         }
1087         
1088         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1089         if (
1090             overMinTokenBalance &&
1091             !inSwapAndLiquify &&
1092             from != uniswapV2Pair &&
1093             swapAndLiquifyEnabled
1094         ) {
1095             contractTokenBalance = numTokensSellToAddToLiquidity;
1096             //add liquidity
1097             swapAndLiquify(contractTokenBalance);
1098         }
1099         
1100         //indicates if fee should be deducted from transfer
1101         bool takeFee = true;
1102         
1103         //if any account belongs to _isExcludedFromFee account then remove the fee
1104         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1105             takeFee = false;
1106         }
1107 
1108         if (takeFee) {
1109             if (to != uniswapV2Pair) {
1110                 require(
1111                     amount + balanceOf(to) <= _maxWalletSize,
1112                     "Recipient exceeds max wallet size."
1113                 );
1114             }
1115         }
1116         
1117         
1118         //transfer amount, it will take tax, burn, liquidity fee
1119         _tokenTransfer(from,to,amount,takeFee);
1120     }
1121 
1122     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1123         // split the contract balance into halves
1124         // add the marketing wallet
1125         uint256 half = contractTokenBalance.div(2);
1126         uint256 otherHalf = contractTokenBalance.sub(half);
1127 
1128         // capture the contract's current ETH balance.
1129         // this is so that we can capture exactly the amount of ETH that the
1130         // swap creates, and not make the liquidity event include any ETH that
1131         // has been manually sent to the contract
1132         uint256 initialBalance = address(this).balance;
1133 
1134         // swap tokens for ETH
1135         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1136 
1137         // how much ETH did we just swap into?
1138         uint256 newBalance = address(this).balance.sub(initialBalance);
1139         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1140         payable(marketingWallet).transfer(marketingshare);
1141         newBalance -= marketingshare;
1142         // add liquidity to uniswap
1143         addLiquidity(otherHalf, newBalance);
1144         
1145         emit SwapAndLiquify(half, newBalance, otherHalf);
1146     }
1147 
1148     function swapTokensForEth(uint256 tokenAmount) private {
1149         // generate the uniswap pair path of token -> weth
1150         address[] memory path = new address[](2);
1151         path[0] = address(this);
1152         path[1] = uniswapV2Router.WETH();
1153 
1154         _approve(address(this), address(uniswapV2Router), tokenAmount);
1155 
1156         // make the swap
1157         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1158             tokenAmount,
1159             0, // accept any amount of ETH
1160             path,
1161             address(this),
1162             block.timestamp
1163         );
1164     }
1165 
1166     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1167         // approve token transfer to cover all possible scenarios
1168         _approve(address(this), address(uniswapV2Router), tokenAmount);
1169 
1170         // add the liquidity
1171         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1172             address(this),
1173             tokenAmount,
1174             0, // slippage is unavoidable
1175             0, // slippage is unavoidable
1176             owner(),
1177             block.timestamp
1178         );
1179     }
1180 
1181     //this method is responsible for taking all fee, if takeFee is true
1182     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1183         if(!canTrade){
1184             require(sender == owner()); // only owner allowed to trade or add liquidity
1185         }
1186         
1187         if(botWallets[sender] || botWallets[recipient]){
1188             require(botscantrade, "bots arent allowed to trade");
1189         }
1190         
1191         if(!takeFee)
1192             removeAllFee();
1193         
1194         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1195             _transferFromExcluded(sender, recipient, amount);
1196         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1197             _transferToExcluded(sender, recipient, amount);
1198         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1199             _transferStandard(sender, recipient, amount);
1200         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1201             _transferBothExcluded(sender, recipient, amount);
1202         } else {
1203             _transferStandard(sender, recipient, amount);
1204         }
1205         
1206         if(!takeFee)
1207             restoreAllFee();
1208     }
1209 
1210     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1211         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1212         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1213         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1214         _takeLiquidity(tLiquidity);
1215         _reflectFee(rFee, tFee);
1216         emit Transfer(sender, recipient, tTransferAmount);
1217     }
1218 
1219     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1220         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1221         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1222         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1223         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1224         _takeLiquidity(tLiquidity);
1225         _reflectFee(rFee, tFee);
1226         emit Transfer(sender, recipient, tTransferAmount);
1227     }
1228 
1229     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1230         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1231         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1232         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1233         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1234         _takeLiquidity(tLiquidity);
1235         _reflectFee(rFee, tFee);
1236         emit Transfer(sender, recipient, tTransferAmount);
1237     }
1238 
1239 }