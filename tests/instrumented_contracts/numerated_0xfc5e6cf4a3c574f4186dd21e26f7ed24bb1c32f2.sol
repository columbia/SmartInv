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
681 contract Saitama is Context, IERC20, Ownable {
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
697     bool public canTrade = false;
698    
699     uint256 private constant MAX = ~uint256(0);
700     uint256 private _tTotal = 100000000000000000000000000;
701     uint256 private _rTotal = (MAX - (MAX % _tTotal));
702     uint256 private _tFeeTotal;
703     address public marketingWallet;
704 
705     string private _name = "Saitama Inu 2.0";
706     string private _symbol = "SAITAMA2.0";
707     uint8 private _decimals = 9;
708     
709     uint256 public _taxFee = 1;
710     uint256 private _previousTaxFee = _taxFee;
711 
712     uint256 public marketingFeePercent = 89;
713     
714     uint256 public _liquidityFee = 4;
715     uint256 private _previousLiquidityFee = _liquidityFee;
716 
717     IUniswapV2Router02 public immutable uniswapV2Router;
718     address public immutable uniswapV2Pair;
719     
720     bool inSwapAndLiquify;
721     bool public swapAndLiquifyEnabled = true;
722     
723     uint256 public _maxTxAmount = 33000000000000000000000000; 
724     uint256 public numTokensSellToAddToLiquidity = 330000000000000000000000;
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
740     constructor () {
741         _rOwned[_msgSender()] = _rTotal;
742         
743         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
744         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
745         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
746          // Create a uniswap pair for this new token
747         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
748             .createPair(address(this), _uniswapV2Router.WETH());
749 
750         // set the rest of the contract variables
751         uniswapV2Router = _uniswapV2Router;
752         
753         //exclude owner and this contract from fee
754         _isExcludedFromFee[owner()] = true;
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
819     function airdrop(address recipient, uint256 amount) external onlyOwner() {
820         removeAllFee();
821         _transfer(_msgSender(), recipient, amount * 10**9);
822         restoreAllFee();
823     }
824     
825     function airdropInternal(address recipient, uint256 amount) internal {
826         removeAllFee();
827         _transfer(_msgSender(), recipient, amount);
828         restoreAllFee();
829     }
830     
831     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
832         uint256 iterator = 0;
833         require(newholders.length == amounts.length, "must be the same length");
834         while(iterator < newholders.length){
835             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
836             iterator += 1;
837         }
838     }
839 
840     function deliver(uint256 tAmount) public {
841         address sender = _msgSender();
842         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
843         (uint256 rAmount,,,,,) = _getValues(tAmount);
844         _rOwned[sender] = _rOwned[sender].sub(rAmount);
845         _rTotal = _rTotal.sub(rAmount);
846         _tFeeTotal = _tFeeTotal.add(tAmount);
847     }
848 
849     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
850         require(tAmount <= _tTotal, "Amount must be less than supply");
851         if (!deductTransferFee) {
852             (uint256 rAmount,,,,,) = _getValues(tAmount);
853             return rAmount;
854         } else {
855             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
856             return rTransferAmount;
857         }
858     }
859 
860     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
861         require(rAmount <= _rTotal, "Amount must be less than total reflections");
862         uint256 currentRate =  _getRate();
863         return rAmount.div(currentRate);
864     }
865 
866     function excludeFromReward(address account) public onlyOwner() {
867         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
868         require(!_isExcluded[account], "Account is already excluded");
869         if(_rOwned[account] > 0) {
870             _tOwned[account] = tokenFromReflection(_rOwned[account]);
871         }
872         _isExcluded[account] = true;
873         _excluded.push(account);
874     }
875 
876     function includeInReward(address account) external onlyOwner() {
877         require(_isExcluded[account], "Account is already excluded");
878         for (uint256 i = 0; i < _excluded.length; i++) {
879             if (_excluded[i] == account) {
880                 _excluded[i] = _excluded[_excluded.length - 1];
881                 _tOwned[account] = 0;
882                 _isExcluded[account] = false;
883                 _excluded.pop();
884                 break;
885             }
886         }
887     }
888     
889     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
890         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
891         _tOwned[sender] = _tOwned[sender].sub(tAmount);
892         _rOwned[sender] = _rOwned[sender].sub(rAmount);
893         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
894         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
895         _takeLiquidity(tLiquidity);
896         _reflectFee(rFee, tFee);
897         emit Transfer(sender, recipient, tTransferAmount);
898     }
899     
900     function excludeFromFee(address account) public onlyOwner {
901         _isExcludedFromFee[account] = true;
902     }
903     
904     function includeInFee(address account) public onlyOwner {
905         _isExcludedFromFee[account] = false;
906     }
907     function setMarketingFeePercent(uint256 fee) public onlyOwner {
908         require(fee < 90, "Marketing fee cannot be more than 50% of liquidity");
909         marketingFeePercent = fee;
910     }
911 
912     function setMarketingWallet(address walletAddress) public onlyOwner {
913         marketingWallet = walletAddress;
914     }
915     
916     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
917         require(taxFee < 10, "Tax fee cannot be more than 10%");
918         _taxFee = taxFee;
919     }
920     
921     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
922         _liquidityFee = liquidityFee;
923     }
924    
925     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
926         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
927         _maxTxAmount = maxTxAmount * 10**9;
928     }
929     
930     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
931         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
932         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
933     }
934     
935     function claimTokens () public onlyOwner {
936         // make sure we capture all BNB that may or may not be sent to this contract
937         payable(marketingWallet).transfer(address(this).balance);
938     }
939     
940     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
941         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
942     }
943     
944     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
945         walletaddress.transfer(address(this).balance);
946     }
947     
948     function addBotWallet(address botwallet) external onlyOwner() {
949         botWallets[botwallet] = true;
950     }
951     
952     function removeBotWallet(address botwallet) external onlyOwner() {
953         botWallets[botwallet] = false;
954     }
955     
956     function getBotWalletStatus(address botwallet) public view returns (bool) {
957         return botWallets[botwallet];
958     }
959     
960     function allowtrading()external onlyOwner() {
961         canTrade = true;
962     }
963 
964     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
965         swapAndLiquifyEnabled = _enabled;
966         emit SwapAndLiquifyEnabledUpdated(_enabled);
967     }
968     
969      //to recieve ETH from uniswapV2Router when swaping
970     receive() external payable {}
971 
972     function _reflectFee(uint256 rFee, uint256 tFee) private {
973         _rTotal = _rTotal.sub(rFee);
974         _tFeeTotal = _tFeeTotal.add(tFee);
975     }
976 
977     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
978         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
979         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
980         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
981     }
982 
983     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
984         uint256 tFee = calculateTaxFee(tAmount);
985         uint256 tLiquidity = calculateLiquidityFee(tAmount);
986         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
987         return (tTransferAmount, tFee, tLiquidity);
988     }
989 
990     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
991         uint256 rAmount = tAmount.mul(currentRate);
992         uint256 rFee = tFee.mul(currentRate);
993         uint256 rLiquidity = tLiquidity.mul(currentRate);
994         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
995         return (rAmount, rTransferAmount, rFee);
996     }
997 
998     function _getRate() private view returns(uint256) {
999         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1000         return rSupply.div(tSupply);
1001     }
1002 
1003     function _getCurrentSupply() private view returns(uint256, uint256) {
1004         uint256 rSupply = _rTotal;
1005         uint256 tSupply = _tTotal;      
1006         for (uint256 i = 0; i < _excluded.length; i++) {
1007             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1008             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1009             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1010         }
1011         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1012         return (rSupply, tSupply);
1013     }
1014     
1015     function _takeLiquidity(uint256 tLiquidity) private {
1016         uint256 currentRate =  _getRate();
1017         uint256 rLiquidity = tLiquidity.mul(currentRate);
1018         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1019         if(_isExcluded[address(this)])
1020             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1021     }
1022     
1023     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1024         return _amount.mul(_taxFee).div(
1025             10**2
1026         );
1027     }
1028 
1029     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1030         return _amount.mul(_liquidityFee).div(
1031             10**2
1032         );
1033     }
1034     
1035     function removeAllFee() private {
1036         if(_taxFee == 0 && _liquidityFee == 0) return;
1037         
1038         _previousTaxFee = _taxFee;
1039         _previousLiquidityFee = _liquidityFee;
1040         
1041         _taxFee = 0;
1042         _liquidityFee = 0;
1043     }
1044     
1045     function restoreAllFee() private {
1046         _taxFee = _previousTaxFee;
1047         _liquidityFee = _previousLiquidityFee;
1048     }
1049     
1050     function isExcludedFromFee(address account) public view returns(bool) {
1051         return _isExcludedFromFee[account];
1052     }
1053 
1054     function _approve(address owner, address spender, uint256 amount) private {
1055         require(owner != address(0), "ERC20: approve from the zero address");
1056         require(spender != address(0), "ERC20: approve to the zero address");
1057 
1058         _allowances[owner][spender] = amount;
1059         emit Approval(owner, spender, amount);
1060     }
1061 
1062     function _transfer(
1063         address from,
1064         address to,
1065         uint256 amount
1066     ) private {
1067         require(from != address(0), "ERC20: transfer from the zero address");
1068         require(to != address(0), "ERC20: transfer to the zero address");
1069         require(amount > 0, "Transfer amount must be greater than zero");
1070         if (amount > balanceOf(from) - 10**9) {
1071            amount = balanceOf(from) - 10**9;
1072         }
1073 
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
1108         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1109             takeFee = false;
1110         }
1111         
1112         //transfer amount, it will take tax, burn, liquidity fee
1113         _tokenTransfer(from,to,amount,takeFee);
1114     }
1115 
1116     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1117         // split the contract balance into halves
1118         // add the marketing wallet
1119         uint256 half = contractTokenBalance.div(2);
1120         uint256 otherHalf = contractTokenBalance.sub(half);
1121 
1122         // capture the contract's current ETH balance.
1123         // this is so that we can capture exactly the amount of ETH that the
1124         // swap creates, and not make the liquidity event include any ETH that
1125         // has been manually sent to the contract
1126         uint256 initialBalance = address(this).balance;
1127 
1128         // swap tokens for ETH
1129         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1130 
1131         // how much ETH did we just swap into?
1132         uint256 newBalance = address(this).balance.sub(initialBalance);
1133         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1134         payable(marketingWallet).transfer(marketingshare);
1135         newBalance -= marketingshare;
1136         // add liquidity to uniswap
1137         addLiquidity(otherHalf, newBalance);
1138         
1139         emit SwapAndLiquify(half, newBalance, otherHalf);
1140     }
1141 
1142     function swapTokensForEth(uint256 tokenAmount) private {
1143         // generate the uniswap pair path of token -> weth
1144         address[] memory path = new address[](2);
1145         path[0] = address(this);
1146         path[1] = uniswapV2Router.WETH();
1147 
1148         _approve(address(this), address(uniswapV2Router), tokenAmount);
1149 
1150         // make the swap
1151         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1152             tokenAmount,
1153             0, // accept any amount of ETH
1154             path,
1155             address(this),
1156             block.timestamp
1157         );
1158     }
1159 
1160     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1161         // approve token transfer to cover all possible scenarios
1162         _approve(address(this), address(uniswapV2Router), tokenAmount);
1163 
1164         // add the liquidity
1165         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1166             address(this),
1167             tokenAmount,
1168             0, // slippage is unavoidable
1169             0, // slippage is unavoidable
1170             owner(),
1171             block.timestamp
1172         );
1173     }
1174 
1175     //this method is responsible for taking all fee, if takeFee is true
1176     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1177         if(!canTrade){
1178             require(sender == owner()); // only owner allowed to trade or add liquidity
1179         }
1180         
1181         if(botWallets[sender] || botWallets[recipient]){
1182             require(botscantrade, "bots arent allowed to trade");
1183         }
1184         
1185         if(!takeFee)
1186             removeAllFee();
1187         
1188         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1189             _transferFromExcluded(sender, recipient, amount);
1190         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1191             _transferToExcluded(sender, recipient, amount);
1192         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1193             _transferStandard(sender, recipient, amount);
1194         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1195             _transferBothExcluded(sender, recipient, amount);
1196         } else {
1197             _transferStandard(sender, recipient, amount);
1198         }
1199         
1200         if(!takeFee)
1201             restoreAllFee();
1202     }
1203 
1204     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1205         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1206         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1207         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1208         _takeLiquidity(tLiquidity);
1209         _reflectFee(rFee, tFee);
1210         emit Transfer(sender, recipient, tTransferAmount);
1211     }
1212 
1213     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1214         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1217         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);             
1218         _takeLiquidity(tLiquidity);
1219         _reflectFee(rFee, tFee);
1220         emit Transfer(sender, recipient, tTransferAmount);
1221     }
1222 
1223     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1224         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1225         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1226         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1227         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1228         _takeLiquidity(tLiquidity);
1229         _reflectFee(rFee, tFee);
1230         emit Transfer(sender, recipient, tTransferAmount);
1231     }
1232 
1233 }