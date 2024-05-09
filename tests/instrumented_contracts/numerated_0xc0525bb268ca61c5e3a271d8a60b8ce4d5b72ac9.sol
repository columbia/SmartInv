1 /**
2  ██████   ██████  ██████ ████████ 
3 ██    ██ ██      ██         ██    
4 ██    ██ ██      ██         ██    
5 ██    ██ ██      ██         ██    
6  ██████   ██████  ██████    ██    
7 */
8 pragma solidity ^0.8.0;
9 
10 // SPDX-License-Identifier: MIT
11 
12 interface IERC20 {
13 
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 
82 
83 /**
84  * @dev Wrappers over Solidity's arithmetic operations with added overflow
85  * checks.
86  *
87  * Arithmetic operations in Solidity wrap on overflow. This can easily result
88  * in bugs, because programmers usually assume that an overflow raises an
89  * error, which is the standard behavior in high level programming languages.
90  * `SafeMath` restores this intuition by reverting the transaction when an
91  * operation overflows.
92  *
93  * Using this library instead of the unchecked operations eliminates an entire
94  * class of bugs, so it's recommended to use it always.
95  */
96  
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address payable) {
242         return payable(msg.sender);
243     }
244 
245     function _msgData() internal view virtual returns (bytes memory) {
246         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
247         return msg.data;
248     }
249 }
250 
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 contract Ownable is Context {
403     address private _owner;
404     address private _previousOwner;
405     uint256 private _lockTime;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     /**
410      * @dev Initializes the contract setting the deployer as the initial owner.
411      */
412     constructor() {
413         address msgSender = _msgSender();
414         _owner = msgSender;
415         emit OwnershipTransferred(address(0), msgSender);
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if called by any account other than the owner.
427      */
428     modifier onlyOwner() {
429         require(_owner == _msgSender(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433      /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public virtual onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 
455 
456 
457 }
458 
459 // pragma solidity >=0.5.0;
460 
461 interface IUniswapV2Factory {
462     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
463 
464     function feeTo() external view returns (address);
465     function feeToSetter() external view returns (address);
466 
467     function getPair(address tokenA, address tokenB) external view returns (address pair);
468     function allPairs(uint) external view returns (address pair);
469     function allPairsLength() external view returns (uint);
470 
471     function createPair(address tokenA, address tokenB) external returns (address pair);
472 
473     function setFeeTo(address) external;
474     function setFeeToSetter(address) external;
475 }
476 
477 
478 // pragma solidity >=0.5.0;
479 
480 interface IUniswapV2Pair {
481     event Approval(address indexed owner, address indexed spender, uint value);
482     event Transfer(address indexed from, address indexed to, uint value);
483 
484     function name() external pure returns (string memory);
485     function symbol() external pure returns (string memory);
486     function decimals() external pure returns (uint8);
487     function totalSupply() external view returns (uint);
488     function balanceOf(address owner) external view returns (uint);
489     function allowance(address owner, address spender) external view returns (uint);
490 
491     function approve(address spender, uint value) external returns (bool);
492     function transfer(address to, uint value) external returns (bool);
493     function transferFrom(address from, address to, uint value) external returns (bool);
494 
495     function DOMAIN_SEPARATOR() external view returns (bytes32);
496     function PERMIT_TYPEHASH() external pure returns (bytes32);
497     function nonces(address owner) external view returns (uint);
498 
499     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
500 
501     event Mint(address indexed sender, uint amount0, uint amount1);
502     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
503     event Swap(
504         address indexed sender,
505         uint amount0In,
506         uint amount1In,
507         uint amount0Out,
508         uint amount1Out,
509         address indexed to
510     );
511     event Sync(uint112 reserve0, uint112 reserve1);
512 
513     function MINIMUM_LIQUIDITY() external pure returns (uint);
514     function factory() external view returns (address);
515     function token0() external view returns (address);
516     function token1() external view returns (address);
517     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
518     function price0CumulativeLast() external view returns (uint);
519     function price1CumulativeLast() external view returns (uint);
520     function kLast() external view returns (uint);
521 
522     function mint(address to) external returns (uint liquidity);
523     function burn(address to) external returns (uint amount0, uint amount1);
524     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
525     function skim(address to) external;
526     function sync() external;
527 
528     function initialize(address, address) external;
529 }
530 
531 // pragma solidity >=0.6.2;
532 
533 interface IUniswapV2Router01 {
534     function factory() external pure returns (address);
535     function WETH() external pure returns (address);
536 
537     function addLiquidity(
538         address tokenA,
539         address tokenB,
540         uint amountADesired,
541         uint amountBDesired,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline
546     ) external returns (uint amountA, uint amountB, uint liquidity);
547     function addLiquidityETH(
548         address token,
549         uint amountTokenDesired,
550         uint amountTokenMin,
551         uint amountETHMin,
552         address to,
553         uint deadline
554     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
555     function removeLiquidity(
556         address tokenA,
557         address tokenB,
558         uint liquidity,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB);
564     function removeLiquidityETH(
565         address token,
566         uint liquidity,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external returns (uint amountToken, uint amountETH);
572     function removeLiquidityWithPermit(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline,
580         bool approveMax, uint8 v, bytes32 r, bytes32 s
581     ) external returns (uint amountA, uint amountB);
582     function removeLiquidityETHWithPermit(
583         address token,
584         uint liquidity,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline,
589         bool approveMax, uint8 v, bytes32 r, bytes32 s
590     ) external returns (uint amountToken, uint amountETH);
591     function swapExactTokensForTokens(
592         uint amountIn,
593         uint amountOutMin,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external returns (uint[] memory amounts);
598     function swapTokensForExactTokens(
599         uint amountOut,
600         uint amountInMax,
601         address[] calldata path,
602         address to,
603         uint deadline
604     ) external returns (uint[] memory amounts);
605     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
606         external
607         payable
608         returns (uint[] memory amounts);
609     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
610         external
611         returns (uint[] memory amounts);
612     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
613         external
614         returns (uint[] memory amounts);
615     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
616         external
617         payable
618         returns (uint[] memory amounts);
619 
620     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
621     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
622     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
623     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
624     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
625 }
626 
627 
628 
629 // pragma solidity >=0.6.2;
630 
631 interface IUniswapV2Router02 is IUniswapV2Router01 {
632     function removeLiquidityETHSupportingFeeOnTransferTokens(
633         address token,
634         uint liquidity,
635         uint amountTokenMin,
636         uint amountETHMin,
637         address to,
638         uint deadline
639     ) external returns (uint amountETH);
640     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
641         address token,
642         uint liquidity,
643         uint amountTokenMin,
644         uint amountETHMin,
645         address to,
646         uint deadline,
647         bool approveMax, uint8 v, bytes32 r, bytes32 s
648     ) external returns (uint amountETH);
649 
650     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
651         uint amountIn,
652         uint amountOutMin,
653         address[] calldata path,
654         address to,
655         uint deadline
656     ) external;
657     function swapExactETHForTokensSupportingFeeOnTransferTokens(
658         uint amountOutMin,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external payable;
663     function swapExactTokensForETHSupportingFeeOnTransferTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external;
670 }
671 
672 contract OCCT is Context, IERC20, Ownable {
673     using SafeMath for uint256;
674     using Address for address;
675 
676     mapping (address => uint256) private _rOwned;
677     mapping (address => uint256) private _tOwned;
678     mapping (address => mapping (address => uint256)) private _allowances;
679 
680     mapping (address => bool) private _isExcludedFromFee;
681 
682     mapping (address => bool) private _isExcluded;
683     address[] private _excluded;
684    
685     uint256 private constant MAX = ~uint256(0);
686     uint256 public _tTotal = 100000000000000000 * 10**18;
687     uint256 private _rTotal = (MAX - (MAX % _tTotal));
688     uint256 private _tFeeTotal;
689 
690     string public _name = "Official Crypto Cowboy Token";
691     string public _symbol = "OCCT";
692     uint8 public _decimals = 18;
693     
694     uint256 public _taxFee = 1;
695     uint256 private _previousTaxFee = _taxFee;
696     
697     uint256 public _liquidityFee = 0;
698     uint256 private _previousLiquidityFee = _liquidityFee;
699 
700     uint256 public _burnFee = 1;
701     uint256 private _previousBurnFee = _burnFee;
702 
703     uint256 public _marketingFee = 1;
704     address private marketingWallet = 0x55FC33E87064553C95085ec8719372935b56376A; 
705 
706     uint256 private _previousmarketingFee = _marketingFee;
707     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
708     
709     IUniswapV2Router02 public immutable uniswapV2Router;
710     address public immutable uniswapV2Pair;
711     
712     bool inSwapAndLiquify;
713     bool public swapAndLiquifyEnabled = true;
714 
715     uint256 public _maxTxAmount = 2000000000000000 * 10**18;
716     uint256 private numTokensSellToAddToLiquidity = 500000000 * 10**18;
717     
718     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
719     event SwapAndLiquifyEnabledUpdated(bool enabled);
720     event SwapAndLiquify(
721         uint256 tokensSwapped,
722         uint256 ethReceived,
723         uint256 tokensIntoLiqudity
724     );
725     
726     modifier lockTheSwap {
727         inSwapAndLiquify = true;
728         _;
729         inSwapAndLiquify = false;
730     }
731     
732     constructor() {
733         _rOwned[_msgSender()] = _rTotal;
734         
735         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // mainnet
736          // Create a uniswap pair for this new token
737         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
738             .createPair(address(this), _uniswapV2Router.WETH());
739 
740         // set the rest of the contract variables
741         uniswapV2Router = _uniswapV2Router;
742         
743         //exclude owner and this contract from fee
744         _isExcludedFromFee[owner()] = true;
745         _isExcludedFromFee[address(this)] = true;
746         
747         // exclude marketing and burn adress from Reward
748         _isExcluded[marketingWallet] = true;
749         _isExcluded[deadAddress] = true;               
750         emit Transfer(address(0), _msgSender(), _tTotal);
751     }
752 
753     function name() public view returns (string memory) {
754         return _name;
755     }
756 
757     function symbol() public view returns (string memory) {
758         return _symbol;
759     }
760 
761     function decimals() public view returns (uint8) {
762         return _decimals;
763     }
764 
765     function totalSupply() public view override returns (uint256) {
766         return _tTotal;
767     }
768 
769     function balanceOf(address account) public view override returns (uint256) {
770         if (_isExcluded[account]) return _tOwned[account];
771         return tokenFromReflection(_rOwned[account]);
772     }
773 
774     function transfer(address recipient, uint256 amount) public override returns (bool) {
775         _transfer(_msgSender(), recipient, amount);
776         return true;
777     }
778 
779     function allowance(address owner, address spender) public view override returns (uint256) {
780         return _allowances[owner][spender];
781     }
782 
783     function approve(address spender, uint256 amount) public override returns (bool) {
784         _approve(_msgSender(), spender, amount);
785         return true;
786     }
787 
788     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
789         _transfer(sender, recipient, amount);
790         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
791         return true;
792     }
793 
794     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
795         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
796         return true;
797     }
798 
799     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
800         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
801         return true;
802     }
803 
804     function isExcludedFromReward(address account) public view returns (bool) {
805         return _isExcluded[account];
806     }
807 
808     function totalFees() public view returns (uint256) {
809         return _tFeeTotal;
810     }
811     
812      function setMarketingFeePercent(uint256 newMarketingFee) external onlyOwner() {
813         _marketingFee = newMarketingFee;
814     }
815     
816     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
817         _taxFee = taxFee;
818     }
819     
820      function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
821         _liquidityFee = liquidityFee;
822     }
823     
824      function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
825         _burnFee = burnFee;
826     }
827     
828     function deliver(uint256 tAmount) public {
829         address sender = _msgSender();
830         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
831         (uint256 rAmount,,,,,) = _getValues(tAmount);
832         _rOwned[sender] = _rOwned[sender].sub(rAmount);
833         _rTotal = _rTotal.sub(rAmount);
834         _tFeeTotal = _tFeeTotal.add(tAmount);
835     }
836 
837     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
838         require(tAmount <= _tTotal, "Amount must be less than supply");
839         if (!deductTransferFee) {
840             (uint256 rAmount,,,,,) = _getValues(tAmount);
841             return rAmount;
842         } else {
843             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
844             return rTransferAmount;
845         }
846     }
847 
848     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
849         require(rAmount <= _rTotal, "Amount must be less than total reflections");
850         uint256 currentRate =  _getRate();
851         return rAmount.div(currentRate);
852     }
853 
854     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
855         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
856         _tOwned[sender] = _tOwned[sender].sub(tAmount);
857         _rOwned[sender] = _rOwned[sender].sub(rAmount);
858         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
859         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
860         _takeLiquidity(tLiquidity);
861         _reflectFee(rFee, tFee);
862         emit Transfer(sender, recipient, tTransferAmount);
863     }
864     
865 
866     
867      //to recieve ETH from uniswapV2Router when swaping
868     receive() external payable {}
869 
870     function _reflectFee(uint256 rFee, uint256 tFee) private {
871         _rTotal = _rTotal.sub(rFee);
872         _tFeeTotal = _tFeeTotal.add(tFee);
873     }
874 
875     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
876         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
877         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
878         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
879     }
880 
881     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
882         uint256 tFee = calculateTaxFee(tAmount);
883         uint256 tLiquidity = calculateLiquidityFee(tAmount);
884         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
885         return (tTransferAmount, tFee, tLiquidity);
886     }
887 
888     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
889         uint256 rAmount = tAmount.mul(currentRate);
890         uint256 rFee = tFee.mul(currentRate);
891         uint256 rLiquidity = tLiquidity.mul(currentRate);
892         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
893         return (rAmount, rTransferAmount, rFee);
894     }
895 
896     function _getRate() private view returns(uint256) {
897         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
898         return rSupply.div(tSupply);
899     }
900 
901     function _getCurrentSupply() private view returns(uint256, uint256) {
902         uint256 rSupply = _rTotal;
903         uint256 tSupply = _tTotal;      
904         for (uint256 i = 0; i < _excluded.length; i++) {
905             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
906             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
907             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
908         }
909         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
910         return (rSupply, tSupply);
911     }
912     
913     function _takeLiquidity(uint256 tLiquidity) private {
914         uint256 currentRate =  _getRate();
915         uint256 rLiquidity = tLiquidity.mul(currentRate);
916         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
917         if(_isExcluded[address(this)])
918             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
919     }
920     
921     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
922         return _amount.mul(_taxFee).div(
923             10**2
924         );
925     }
926 
927     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
928         return _amount.mul(_liquidityFee).div(
929             10**2
930         );
931     }
932     
933     function removeAllFee() private {
934         _taxFee = 0;
935         _liquidityFee = 0;
936         _burnFee = 0;
937         _marketingFee = 0;
938     }
939     
940     function restoreAllFee() private {
941         _taxFee = 1;
942         _liquidityFee = 0;
943         _burnFee = 1;
944         _marketingFee = 1;
945     }
946     
947     function isExcludedFromFee(address account) public view returns(bool) {
948         return _isExcludedFromFee[account];
949     }
950 
951     function _approve(address owner, address spender, uint256 amount) private {
952         require(owner != address(0), "ERC20: approve from the zero address");
953         require(spender != address(0), "ERC20: approve to the zero address");
954 
955         _allowances[owner][spender] = amount;
956         emit Approval(owner, spender, amount);
957     }
958 
959     function _transfer(
960         address from,
961         address to,
962         uint256 amount
963     ) private {
964         require(from != address(0), "ERC20: transfer from the zero address");
965         require(to != address(0), "ERC20: transfer to the zero address");
966         require(amount > 0, "Transfer amount must be greater than zero");
967 
968         // is the token balance of this contract address over the min number of
969         // tokens that we need to initiate a swap + liquidity lock?
970         // also, don't get caught in a circular liquidity event.
971         // also, don't swap & liquify if sender is uniswap pair.
972         uint256 contractTokenBalance = balanceOf(address(this));        
973         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
974         if (
975             overMinTokenBalance &&
976             !inSwapAndLiquify &&
977             from != uniswapV2Pair &&
978             swapAndLiquifyEnabled
979         ) {
980             contractTokenBalance = numTokensSellToAddToLiquidity;
981             //add liquidity
982             swapAndLiquify(contractTokenBalance);
983         }
984         
985         //transfer amount, it will take tax, burn, liquidity fee
986         _tokenTransfer(from,to,amount);
987     }
988 
989     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
990         // split the contract balance into halves
991         uint256 half = contractTokenBalance.div(2);
992         uint256 otherHalf = contractTokenBalance.sub(half);
993 
994         // capture the contract's current ETH balance.
995         // this is so that we can capture exactly the amount of ETH that the
996         // swap creates, and not make the liquidity event include any ETH that
997         // has been manually sent to the contract
998         uint256 initialBalance = address(this).balance;
999 
1000         // swap tokens for ETH
1001         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1002 
1003         // how much ETH did we just swap into?
1004         uint256 newBalance = address(this).balance.sub(initialBalance);
1005 
1006         // add liquidity to uniswap
1007         addLiquidity(otherHalf, newBalance);
1008         
1009         emit SwapAndLiquify(half, newBalance, otherHalf);
1010     }
1011 
1012     function swapTokensForEth(uint256 tokenAmount) private {
1013         // generate the uniswap pair path of token -> weth
1014         address[] memory path = new address[](2);
1015         path[0] = address(this);
1016         path[1] = uniswapV2Router.WETH();
1017 
1018         _approve(address(this), address(uniswapV2Router), tokenAmount);
1019 
1020         // make the swap
1021         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1022             tokenAmount,
1023             0, // accept any amount of ETH
1024             path,
1025             address(this),
1026             block.timestamp
1027         );
1028     }
1029 
1030     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1031         // approve token transfer to cover all possible scenarios
1032         _approve(address(this), address(uniswapV2Router), tokenAmount);
1033 
1034         // add the liquidity
1035         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1036             address(this),
1037             tokenAmount,
1038             0, // slippage is unavoidable
1039             0, // slippage is unavoidable
1040             owner(),
1041             block.timestamp
1042         );
1043     }
1044 
1045     //this method is responsible for taking all fee, if takeFee is true
1046     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
1047         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1048             removeAllFee();
1049         }
1050         else{
1051             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1052         }
1053         
1054         //Calculate burn amount and marketing amount
1055         uint256 burnAmt = amount.mul(_burnFee).div(100);
1056         uint256 marketingAmt = amount.mul(_marketingFee).div(100);
1057 
1058         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1059             _transferFromExcluded(sender, recipient, (amount.sub(burnAmt).sub(marketingAmt)));
1060         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1061             _transferToExcluded(sender, recipient, (amount.sub(burnAmt).sub(marketingAmt)));
1062         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1063             _transferStandard(sender, recipient, (amount.sub(burnAmt).sub(marketingAmt)));
1064         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1065             _transferBothExcluded(sender, recipient, (amount.sub(burnAmt).sub(marketingAmt)));
1066         } else {
1067             _transferStandard(sender, recipient, (amount.sub(burnAmt).sub(marketingAmt)));
1068         }
1069         
1070         //Temporarily remove fees to transfer to burn address and marketing wallet
1071         _taxFee = 0;
1072         _liquidityFee = 0;
1073 
1074         //Send transfers to burn and marketing wallet
1075         _transferToExcluded(sender, deadAddress, burnAmt);
1076         _transferToExcluded(sender, marketingWallet, marketingAmt);
1077 
1078         //Restore tax and liquidity fees
1079         _taxFee = _previousTaxFee;
1080         _liquidityFee = _previousLiquidityFee;
1081 
1082 
1083         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1084             restoreAllFee();
1085     }
1086 
1087     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1088         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1089         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1090         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1091         _takeLiquidity(tLiquidity);
1092         _reflectFee(rFee, tFee);
1093         emit Transfer(sender, recipient, tTransferAmount);
1094     }
1095 
1096     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1097         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1098         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1099         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1100         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1101         _takeLiquidity(tLiquidity);
1102         _reflectFee(rFee, tFee);
1103         emit Transfer(sender, recipient, tTransferAmount);
1104     }
1105 
1106     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1107         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1108         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1109         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1110         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1111         _takeLiquidity(tLiquidity);
1112         _reflectFee(rFee, tFee);
1113         emit Transfer(sender, recipient, tTransferAmount);
1114     }
1115 
1116     function excludeFromFee(address account) public onlyOwner {
1117         _isExcludedFromFee[account] = true;
1118     }
1119     
1120     function includeInFee(address account) public onlyOwner {
1121         _isExcludedFromFee[account] = false;
1122     }
1123     
1124 
1125     function setmarketingWallet(address newWallet) external onlyOwner() {
1126         marketingWallet = newWallet;
1127     }
1128     
1129     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1130         _maxTxAmount = maxTxAmount ;
1131     }
1132     
1133     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1134         require(maxTxPercent > 1, "Cannot set transaction amount less than 10 percent!");
1135         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1136             10**2
1137         );
1138     }
1139 
1140     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1141         swapAndLiquifyEnabled = _enabled;
1142         emit SwapAndLiquifyEnabledUpdated(_enabled);
1143     }
1144     
1145 }