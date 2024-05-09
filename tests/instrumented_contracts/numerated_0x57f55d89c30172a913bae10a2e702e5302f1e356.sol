1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3 */
4 
5 pragma solidity ^0.6.12;
6 // SPDX-License-Identifier: Unlicensed
7 interface IERC20 {
8 
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91  
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address payable) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes memory) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 contract Ownable is Context {
398     address private _owner;
399     address private _previousOwner;
400     uint256 private _lockTime;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor () internal {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view returns (address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         require(_owner == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428      /**
429      * @dev Leaves the contract without owner. It will not be possible to call
430      * `onlyOwner` functions anymore. Can only be called by the current owner.
431      *
432      * NOTE: Renouncing ownership will leave the contract without an owner,
433      * thereby removing any functionality that is only available to the owner.
434      */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 
450 }
451 
452 // pragma solidity >=0.5.0;
453 
454 interface IUniswapV2Factory {
455     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
456 
457     function feeTo() external view returns (address);
458     function feeToSetter() external view returns (address);
459 
460     function getPair(address tokenA, address tokenB) external view returns (address pair);
461     function allPairs(uint) external view returns (address pair);
462     function allPairsLength() external view returns (uint);
463 
464     function createPair(address tokenA, address tokenB) external returns (address pair);
465 
466     function setFeeTo(address) external;
467     function setFeeToSetter(address) external;
468 }
469 
470 
471 // pragma solidity >=0.5.0;
472 
473 interface IUniswapV2Pair {
474     event Approval(address indexed owner, address indexed spender, uint value);
475     event Transfer(address indexed from, address indexed to, uint value);
476 
477     function name() external pure returns (string memory);
478     function symbol() external pure returns (string memory);
479     function decimals() external pure returns (uint8);
480     function totalSupply() external view returns (uint);
481     function balanceOf(address owner) external view returns (uint);
482     function allowance(address owner, address spender) external view returns (uint);
483 
484     function approve(address spender, uint value) external returns (bool);
485     function transfer(address to, uint value) external returns (bool);
486     function transferFrom(address from, address to, uint value) external returns (bool);
487 
488     function DOMAIN_SEPARATOR() external view returns (bytes32);
489     function PERMIT_TYPEHASH() external pure returns (bytes32);
490     function nonces(address owner) external view returns (uint);
491 
492     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
493 
494     event Mint(address indexed sender, uint amount0, uint amount1);
495     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
496     event Swap(
497         address indexed sender,
498         uint amount0In,
499         uint amount1In,
500         uint amount0Out,
501         uint amount1Out,
502         address indexed to
503     );
504     event Sync(uint112 reserve0, uint112 reserve1);
505 
506     function MINIMUM_LIQUIDITY() external pure returns (uint);
507     function factory() external view returns (address);
508     function token0() external view returns (address);
509     function token1() external view returns (address);
510     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
511     function price0CumulativeLast() external view returns (uint);
512     function price1CumulativeLast() external view returns (uint);
513     function kLast() external view returns (uint);
514 
515     function mint(address to) external returns (uint liquidity);
516     function burn(address to) external returns (uint amount0, uint amount1);
517     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
518     function skim(address to) external;
519     function sync() external;
520 
521     function initialize(address, address) external;
522 }
523 
524 // pragma solidity >=0.6.2;
525 
526 interface IUniswapV2Router01 {
527     function factory() external pure returns (address);
528     function WETH() external pure returns (address);
529 
530     function addLiquidity(
531         address tokenA,
532         address tokenB,
533         uint amountADesired,
534         uint amountBDesired,
535         uint amountAMin,
536         uint amountBMin,
537         address to,
538         uint deadline
539     ) external returns (uint amountA, uint amountB, uint liquidity);
540     function addLiquidityETH(
541         address token,
542         uint amountTokenDesired,
543         uint amountTokenMin,
544         uint amountETHMin,
545         address to,
546         uint deadline
547     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
548     function removeLiquidity(
549         address tokenA,
550         address tokenB,
551         uint liquidity,
552         uint amountAMin,
553         uint amountBMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountA, uint amountB);
557     function removeLiquidityETH(
558         address token,
559         uint liquidity,
560         uint amountTokenMin,
561         uint amountETHMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountToken, uint amountETH);
565     function removeLiquidityWithPermit(
566         address tokenA,
567         address tokenB,
568         uint liquidity,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline,
573         bool approveMax, uint8 v, bytes32 r, bytes32 s
574     ) external returns (uint amountA, uint amountB);
575     function removeLiquidityETHWithPermit(
576         address token,
577         uint liquidity,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline,
582         bool approveMax, uint8 v, bytes32 r, bytes32 s
583     ) external returns (uint amountToken, uint amountETH);
584     function swapExactTokensForTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external returns (uint[] memory amounts);
591     function swapTokensForExactTokens(
592         uint amountOut,
593         uint amountInMax,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external returns (uint[] memory amounts);
598     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
599         external
600         payable
601         returns (uint[] memory amounts);
602     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
603         external
604         returns (uint[] memory amounts);
605     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
606         external
607         returns (uint[] memory amounts);
608     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
609         external
610         payable
611         returns (uint[] memory amounts);
612 
613     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
614     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
615     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
616     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
617     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
618 }
619 
620 
621 
622 // pragma solidity >=0.6.2;
623 
624 interface IUniswapV2Router02 is IUniswapV2Router01 {
625     function removeLiquidityETHSupportingFeeOnTransferTokens(
626         address token,
627         uint liquidity,
628         uint amountTokenMin,
629         uint amountETHMin,
630         address to,
631         uint deadline
632     ) external returns (uint amountETH);
633     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
634         address token,
635         uint liquidity,
636         uint amountTokenMin,
637         uint amountETHMin,
638         address to,
639         uint deadline,
640         bool approveMax, uint8 v, bytes32 r, bytes32 s
641     ) external returns (uint amountETH);
642 
643     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650     function swapExactETHForTokensSupportingFeeOnTransferTokens(
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external payable;
656     function swapExactTokensForETHSupportingFeeOnTransferTokens(
657         uint amountIn,
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external;
663 }
664 
665 
666 contract BBW is Context, IERC20, Ownable {
667     using SafeMath for uint256;
668     using Address for address;
669 
670     mapping (address => uint256) private _rOwned;
671     mapping (address => uint256) private _tOwned;
672     mapping (address => mapping (address => uint256)) private _allowances;
673 
674     mapping (address => bool) private _isExcludedFromFee;
675 
676     mapping (address => bool) private _isExcluded;
677     address[] private _excluded;
678     
679     mapping (address => bool) private _isBlackListedBot;
680     address[] private _blackListedBots;
681     
682    
683     uint256 private constant MAX = ~uint256(0);
684 
685     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
686     uint256 private _rTotal = (MAX - (MAX % _tTotal));
687     uint256 private _tFeeTotal;
688 
689     string private _name = "Big Beautiful Women";
690     string private _symbol = "BBW";
691     uint8 private _decimals = 9;
692     
693     uint256 public _taxFee = 0;
694     uint256 private _previousTaxFee = _taxFee;
695 
696     uint256 public _liquidityFee = 10;
697     uint256 private _previousLiquidityFee = _liquidityFee;
698 
699     address payable public _devWalletAddress;
700 
701     IUniswapV2Router02 public immutable uniswapV2Router;
702     address public immutable uniswapV2Pair;
703     
704     bool inSwapAndLiquify;
705     bool public swapAndLiquifyEnabled = true;
706     
707     uint256 public _maxTxAmount = 2500000 * 10**6 * 10**9;
708     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
709     
710     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
711     event SwapAndLiquifyEnabledUpdated(bool enabled);
712     event SwapAndLiquify(
713         uint256 tokensSwapped,
714         uint256 ethReceived
715     );
716     
717     modifier lockTheSwap {
718         inSwapAndLiquify = true;
719         _;
720         inSwapAndLiquify = false;
721     }
722     
723     constructor (address payable devWalletAddress) public {
724         _devWalletAddress = devWalletAddress;
725         _rOwned[_msgSender()] = _rTotal;
726         
727         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
728          // Create a uniswap pair for this new token
729         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
730             .createPair(address(this), _uniswapV2Router.WETH());
731 
732         // set the rest of the contract variables
733         uniswapV2Router = _uniswapV2Router;
734         
735         //exclude owner and this contract from fee
736         _isExcludedFromFee[owner()] = true;
737         _isExcludedFromFee[address(this)] = true;
738         
739         emit Transfer(address(0), _msgSender(), _tTotal);
740     }
741 
742     function name() public view returns (string memory) {
743         return _name;
744     }
745 
746     function symbol() public view returns (string memory) {
747         return _symbol;
748     }
749 
750     function decimals() public view returns (uint8) {
751         return _decimals;
752     }
753     
754     function setDevFeeDisabled(bool _devFeeEnabled ) public returns (bool){
755         require(msg.sender == _devWalletAddress, "Only Dev Address can disable dev fee");
756         swapAndLiquifyEnabled = _devFeeEnabled;
757         return(swapAndLiquifyEnabled);
758     }
759 
760     function totalSupply() public view override returns (uint256) {
761         return _tTotal;
762     }
763 
764     function balanceOf(address account) public view override returns (uint256) {
765         if (_isExcluded[account]) return _tOwned[account];
766         return tokenFromReflection(_rOwned[account]);
767     }
768 
769     function transfer(address recipient, uint256 amount) public override returns (bool) {
770         _transfer(_msgSender(), recipient, amount);
771         return true;
772     }
773 
774     function allowance(address owner, address spender) public view override returns (uint256) {
775         return _allowances[owner][spender];
776     }
777 
778     function approve(address spender, uint256 amount) public override returns (bool) {
779         _approve(_msgSender(), spender, amount);
780         return true;
781     }
782 
783     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
784         _transfer(sender, recipient, amount);
785         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
786         return true;
787     }
788 
789     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
790         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
791         return true;
792     }
793 
794     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
795         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
796         return true;
797     }
798 
799     function isExcludedFromReward(address account) public view returns (bool) {
800         return _isExcluded[account];
801     }
802 
803     function totalFees() public view returns (uint256) {
804         return _tFeeTotal;
805     }
806 
807     function deliver(uint256 tAmount) public {
808         address sender = _msgSender();
809         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
810         (uint256 rAmount,,,,,) = _getValues(tAmount);
811         _rOwned[sender] = _rOwned[sender].sub(rAmount);
812         _rTotal = _rTotal.sub(rAmount);
813         _tFeeTotal = _tFeeTotal.add(tAmount);
814     }
815 
816     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
817         require(tAmount <= _tTotal, "Amount must be less than supply");
818         if (!deductTransferFee) {
819             (uint256 rAmount,,,,,) = _getValues(tAmount);
820             return rAmount;
821         } else {
822             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
823             return rTransferAmount;
824         }
825     }
826 
827     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
828         require(rAmount <= _rTotal, "Amount must be less than total reflections");
829         uint256 currentRate =  _getRate();
830         return rAmount.div(currentRate);
831     }
832 
833     function excludeFromReward(address account) public onlyOwner() {
834         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
835         require(!_isExcluded[account], "Account is already excluded");
836         if(_rOwned[account] > 0) {
837             _tOwned[account] = tokenFromReflection(_rOwned[account]);
838         }
839         _isExcluded[account] = true;
840         _excluded.push(account);
841     }
842 
843     function includeInReward(address account) external onlyOwner() {
844         require(_isExcluded[account], "Account is already excluded");
845         for (uint256 i = 0; i < _excluded.length; i++) {
846             if (_excluded[i] == account) {
847                 _excluded[i] = _excluded[_excluded.length - 1];
848                 _tOwned[account] = 0;
849                 _isExcluded[account] = false;
850                 _excluded.pop();
851                 break;
852             }
853         }
854     }
855         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
856         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
857         _tOwned[sender] = _tOwned[sender].sub(tAmount);
858         _rOwned[sender] = _rOwned[sender].sub(rAmount);
859         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
860         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
861         _takeLiquidity(tLiquidity);
862         _reflectFee(rFee, tFee);
863         emit Transfer(sender, recipient, tTransferAmount);
864     }
865     
866         function excludeFromFee(address account) public onlyOwner {
867         _isExcludedFromFee[account] = true;
868     }
869     
870     function includeInFee(address account) public onlyOwner {
871         _isExcludedFromFee[account] = false;
872     }
873     
874     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
875         _taxFee = taxFee;
876     }
877     
878     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
879         _liquidityFee = liquidityFee;
880     }
881     
882     function _setdevWallet(address payable devWalletAddress) external onlyOwner() {
883         _devWalletAddress = devWalletAddress;
884     }
885     
886     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
887         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
888             10**2
889         );
890     }
891 
892     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
893         swapAndLiquifyEnabled = _enabled;
894         emit SwapAndLiquifyEnabledUpdated(_enabled);
895     }
896     
897      //to recieve ETH from uniswapV2Router when swaping
898     receive() external payable {}
899 
900     function _reflectFee(uint256 rFee, uint256 tFee) private {
901         _rTotal = _rTotal.sub(rFee);
902         _tFeeTotal = _tFeeTotal.add(tFee);
903     }
904 
905     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
906         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
907         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
908         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
909     }
910 
911     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
912         uint256 tFee = calculateTaxFee(tAmount);
913         uint256 tLiquidity = calculateLiquidityFee(tAmount);
914         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
915         return (tTransferAmount, tFee, tLiquidity);
916     }
917 
918     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
919         uint256 rAmount = tAmount.mul(currentRate);
920         uint256 rFee = tFee.mul(currentRate);
921         uint256 rLiquidity = tLiquidity.mul(currentRate);
922         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
923         return (rAmount, rTransferAmount, rFee);
924     }
925 
926     function _getRate() private view returns(uint256) {
927         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
928         return rSupply.div(tSupply);
929     }
930 
931     function _getCurrentSupply() private view returns(uint256, uint256) {
932         uint256 rSupply = _rTotal;
933         uint256 tSupply = _tTotal;      
934         for (uint256 i = 0; i < _excluded.length; i++) {
935             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
936             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
937             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
938         }
939         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
940         return (rSupply, tSupply);
941     }
942     
943     function _takeLiquidity(uint256 tLiquidity) private {
944         uint256 currentRate =  _getRate();
945         uint256 rLiquidity = tLiquidity.mul(currentRate);
946         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
947         if(_isExcluded[address(this)])
948             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
949     }
950     
951     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
952         return _amount.mul(_taxFee).div(
953             10**2
954         );
955     }
956 
957     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
958         return _amount.mul(_liquidityFee).div(
959             10**2
960         );
961     }
962     
963     function addBotToBlackList(address account) external onlyOwner() {
964         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
965         require(!_isBlackListedBot[account], "Account is already blacklisted");
966         _isBlackListedBot[account] = true;
967         _blackListedBots.push(account);
968     }
969 
970     function removeBotFromBlackList(address account) external onlyOwner() {
971         require(_isBlackListedBot[account], "Account is not blacklisted");
972         for (uint256 i = 0; i < _blackListedBots.length; i++) {
973             if (_blackListedBots[i] == account) {
974                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
975                 _isBlackListedBot[account] = false;
976                 _blackListedBots.pop();
977                 break;
978             }
979         }
980     }
981     
982     function removeAllFee() private {
983         if(_taxFee == 0 && _liquidityFee == 0) return;
984         
985         _previousTaxFee = _taxFee;
986         _previousLiquidityFee = _liquidityFee;
987         
988         _taxFee = 0;
989         _liquidityFee = 0;
990     }
991     
992     function restoreAllFee() private {
993         _taxFee = _previousTaxFee;
994         _liquidityFee = _previousLiquidityFee;
995     }
996     
997     function isExcludedFromFee(address account) public view returns(bool) {
998         return _isExcludedFromFee[account];
999     }
1000 
1001     function _approve(address owner, address spender, uint256 amount) private {
1002         require(owner != address(0), "ERC20: approve from the zero address");
1003         require(spender != address(0), "ERC20: approve to the zero address");
1004 
1005         _allowances[owner][spender] = amount;
1006         emit Approval(owner, spender, amount);
1007     }
1008 
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 amount
1013     ) private {
1014         require(from != address(0), "ERC20: transfer from the zero address");
1015         require(to != address(0), "ERC20: transfer to the zero address");
1016         require(amount > 0, "Transfer amount must be greater than zero");
1017         
1018         require(!_isBlackListedBot[to], "You have no power here!");
1019         require(!_isBlackListedBot[msg.sender], "You have no power here!");
1020         require(!_isBlackListedBot[from], "You have no power here!");
1021         
1022         
1023         if(from != owner() && to != owner())
1024             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1025 
1026         // is the token balance of this contract address over the min number of
1027         // tokens that we need to initiate a swap + liquidity lock?
1028         // also, don't get caught in a circular liquidity event.
1029         // also, don't swap & liquify if sender is uniswap pair.
1030         uint256 contractTokenBalance = balanceOf(address(this));
1031         
1032         if(contractTokenBalance >= _maxTxAmount)
1033         {
1034             contractTokenBalance = _maxTxAmount;
1035         }
1036         
1037         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1038         if (
1039             overMinTokenBalance &&
1040             !inSwapAndLiquify &&
1041             from != uniswapV2Pair &&
1042             swapAndLiquifyEnabled
1043         ) {
1044             //add liquidity
1045             swapAndLiquify(contractTokenBalance);
1046         }
1047         
1048         //indicates if fee should be deducted from transfer
1049         bool takeFee = true;
1050         
1051         //if any account belongs to _isExcludedFromFee account then remove the fee
1052         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1053             takeFee = false;
1054         }
1055         
1056         //transfer amount, it will take tax, burn, liquidity fee
1057         _tokenTransfer(from,to,amount,takeFee);
1058     }
1059 
1060     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1061         // split the contract balance into halves
1062         uint256 tokenBalance = contractTokenBalance;
1063 
1064         // capture the contract's current ETH balance.
1065         // this is so that we can capture exactly the amount of ETH that the
1066         // swap creates, and not make the liquidity event include any ETH that
1067         // has been manually sent to the contract
1068         uint256 initialBalance = address(this).balance;
1069 
1070         // swap tokens for ETH
1071         swapTokensForEth(tokenBalance); // <-  breaks the ETH -> HATE swap when swap+liquify is triggered
1072 
1073         // how much ETH did we just swap into?
1074         uint256 newBalance = address(this).balance.sub(initialBalance);
1075 
1076         sendETHTodev(newBalance);
1077         // add liquidity to uniswap
1078         
1079         emit SwapAndLiquify(tokenBalance, newBalance);
1080     }
1081 
1082     function sendETHTodev(uint256 amount) private {
1083       _devWalletAddress.transfer(amount);
1084     }
1085 
1086     function swapTokensForEth(uint256 tokenAmount) private {
1087         // generate the uniswap pair path of token -> weth
1088         address[] memory path = new address[](2);
1089         path[0] = address(this);
1090         path[1] = uniswapV2Router.WETH();
1091 
1092         _approve(address(this), address(uniswapV2Router), tokenAmount);
1093 
1094         // make the swap
1095         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1096             tokenAmount,
1097             0, // accept any amount of ETH
1098             path,
1099             address(this),
1100             block.timestamp
1101         );
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
1120     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1121         if(!takeFee)
1122             removeAllFee();
1123         
1124         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1125             _transferFromExcluded(sender, recipient, amount);
1126         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1127             _transferToExcluded(sender, recipient, amount);
1128         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1129             _transferStandard(sender, recipient, amount);
1130         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1131             _transferBothExcluded(sender, recipient, amount);
1132         } else {
1133             _transferStandard(sender, recipient, amount);
1134         }
1135         
1136         if(!takeFee)
1137             restoreAllFee();
1138     }
1139 
1140     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1141         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1142         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1143         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1144         _takeLiquidity(tLiquidity);
1145         _reflectFee(rFee, tFee);
1146         emit Transfer(sender, recipient, tTransferAmount);
1147     }
1148 
1149     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1150         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1151         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1152         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1153         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1154         _takeLiquidity(tLiquidity);
1155         _reflectFee(rFee, tFee);
1156         emit Transfer(sender, recipient, tTransferAmount);
1157     }
1158 
1159     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1161         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1164         _takeLiquidity(tLiquidity);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 }