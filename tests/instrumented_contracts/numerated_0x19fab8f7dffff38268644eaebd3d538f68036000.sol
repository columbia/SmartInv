1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-15
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.6.12;
8 
9 interface IERC20 {
10 
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93  
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address payable) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes memory) {
243         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
244         return msg.data;
245     }
246 }
247 
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 /**
388  * @dev Contract module which provides a basic access control mechanism, where
389  * there is an account (an owner) that can be granted exclusive access to
390  * specific functions.
391  *
392  * By default, the owner account will be the one that deploys the contract. This
393  * can later be changed with {transferOwnership}.
394  *
395  * This module is used through inheritance. It will make available the modifier
396  * `onlyOwner`, which can be applied to your functions to restrict their use to
397  * the owner.
398  */
399 contract Ownable is Context {
400     address private _owner;
401     address private _previousOwner;
402     uint256 private _lockTime;
403 
404     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
405 
406     /**
407      * @dev Initializes the contract setting the deployer as the initial owner.
408      */
409     constructor () internal {
410         address msgSender = _msgSender();
411         _owner = msgSender;
412         emit OwnershipTransferred(address(0), msgSender);
413     }
414 
415     /**
416      * @dev Returns the address of the current owner.
417      */
418     function owner() public view returns (address) {
419         return _owner;
420     }
421 
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         require(_owner == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429 
430      /**
431      * @dev Leaves the contract without owner. It will not be possible to call
432      * `onlyOwner` functions anymore. Can only be called by the current owner.
433      *
434      * NOTE: Renouncing ownership will leave the contract without an owner,
435      * thereby removing any functionality that is only available to the owner.
436      */
437     function renounceOwnership() public virtual onlyOwner {
438         emit OwnershipTransferred(_owner, address(0));
439         _owner = address(0);
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Can only be called by the current owner.
445      */
446     function transferOwnership(address newOwner) public virtual onlyOwner {
447         require(newOwner != address(0), "Ownable: new owner is the zero address");
448         emit OwnershipTransferred(_owner, newOwner);
449         _owner = newOwner;
450     }
451 
452     function geUnlockTime() public view returns (uint256) {
453         return _lockTime;
454     }
455 
456     //Locks the contract for owner for the amount of time provided
457     function lock(uint256 time) public virtual onlyOwner {
458         _previousOwner = _owner;
459         _owner = address(0);
460         _lockTime = now + time;
461         emit OwnershipTransferred(_owner, address(0));
462     }
463     
464     //Unlocks the contract for owner when _lockTime is exceeds
465     function unlock() public virtual {
466         require(_previousOwner == msg.sender, "You don't have permission to unlock");
467         require(now > _lockTime , "Contract is locked until 7 days");
468         emit OwnershipTransferred(_owner, _previousOwner);
469         _owner = _previousOwner;
470     }
471 }
472 
473 interface IUniswapV2Factory {
474     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
475 
476     function feeTo() external view returns (address);
477     function feeToSetter() external view returns (address);
478 
479     function getPair(address tokenA, address tokenB) external view returns (address pair);
480     function allPairs(uint) external view returns (address pair);
481     function allPairsLength() external view returns (uint);
482 
483     function createPair(address tokenA, address tokenB) external returns (address pair);
484 
485     function setFeeTo(address) external;
486     function setFeeToSetter(address) external;
487 }
488 
489 interface IUniswapV2Pair {
490     event Approval(address indexed owner, address indexed spender, uint value);
491     event Transfer(address indexed from, address indexed to, uint value);
492 
493     function name() external pure returns (string memory);
494     function symbol() external pure returns (string memory);
495     function decimals() external pure returns (uint8);
496     function totalSupply() external view returns (uint);
497     function balanceOf(address owner) external view returns (uint);
498     function allowance(address owner, address spender) external view returns (uint);
499 
500     function approve(address spender, uint value) external returns (bool);
501     function transfer(address to, uint value) external returns (bool);
502     function transferFrom(address from, address to, uint value) external returns (bool);
503 
504     function DOMAIN_SEPARATOR() external view returns (bytes32);
505     function PERMIT_TYPEHASH() external pure returns (bytes32);
506     function nonces(address owner) external view returns (uint);
507 
508     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
509 
510     event Mint(address indexed sender, uint amount0, uint amount1);
511     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
512     event Swap(
513         address indexed sender,
514         uint amount0In,
515         uint amount1In,
516         uint amount0Out,
517         uint amount1Out,
518         address indexed to
519     );
520     event Sync(uint112 reserve0, uint112 reserve1);
521 
522     function MINIMUM_LIQUIDITY() external pure returns (uint);
523     function factory() external view returns (address);
524     function token0() external view returns (address);
525     function token1() external view returns (address);
526     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
527     function price0CumulativeLast() external view returns (uint);
528     function price1CumulativeLast() external view returns (uint);
529     function kLast() external view returns (uint);
530 
531     function mint(address to) external returns (uint liquidity);
532     function burn(address to) external returns (uint amount0, uint amount1);
533     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
534     function skim(address to) external;
535     function sync() external;
536 
537     function initialize(address, address) external;
538 }
539 
540 interface IUniswapV2Router01 {
541     function factory() external pure returns (address);
542     function WETH() external pure returns (address);
543 
544     function addLiquidity(
545         address tokenA,
546         address tokenB,
547         uint amountADesired,
548         uint amountBDesired,
549         uint amountAMin,
550         uint amountBMin,
551         address to,
552         uint deadline
553     ) external returns (uint amountA, uint amountB, uint liquidity);
554     function addLiquidityETH(
555         address token,
556         uint amountTokenDesired,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
562     function removeLiquidity(
563         address tokenA,
564         address tokenB,
565         uint liquidity,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline
570     ) external returns (uint amountA, uint amountB);
571     function removeLiquidityETH(
572         address token,
573         uint liquidity,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountToken, uint amountETH);
579     function removeLiquidityWithPermit(
580         address tokenA,
581         address tokenB,
582         uint liquidity,
583         uint amountAMin,
584         uint amountBMin,
585         address to,
586         uint deadline,
587         bool approveMax, uint8 v, bytes32 r, bytes32 s
588     ) external returns (uint amountA, uint amountB);
589     function removeLiquidityETHWithPermit(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external returns (uint amountToken, uint amountETH);
598     function swapExactTokensForTokens(
599         uint amountIn,
600         uint amountOutMin,
601         address[] calldata path,
602         address to,
603         uint deadline
604     ) external returns (uint[] memory amounts);
605     function swapTokensForExactTokens(
606         uint amountOut,
607         uint amountInMax,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external returns (uint[] memory amounts);
612     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
613         external
614         payable
615         returns (uint[] memory amounts);
616     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
617         external
618         returns (uint[] memory amounts);
619     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         returns (uint[] memory amounts);
622     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626 
627     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
628     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
629     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
630     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
631     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
632 }
633 
634 interface IUniswapV2Router02 is IUniswapV2Router01 {
635     function removeLiquidityETHSupportingFeeOnTransferTokens(
636         address token,
637         uint liquidity,
638         uint amountTokenMin,
639         uint amountETHMin,
640         address to,
641         uint deadline
642     ) external returns (uint amountETH);
643     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline,
650         bool approveMax, uint8 v, bytes32 r, bytes32 s
651     ) external returns (uint amountETH);
652 
653     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
654         uint amountIn,
655         uint amountOutMin,
656         address[] calldata path,
657         address to,
658         uint deadline
659     ) external;
660     function swapExactETHForTokensSupportingFeeOnTransferTokens(
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external payable;
666     function swapExactTokensForETHSupportingFeeOnTransferTokens(
667         uint amountIn,
668         uint amountOutMin,
669         address[] calldata path,
670         address to,
671         uint deadline
672     ) external;
673 }
674 
675 contract ChronicToken is Context, IERC20, Ownable {
676     using SafeMath for uint256;
677     using Address for address;
678 
679     mapping (address => uint256) private _rOwned;
680     mapping (address => uint256) private _tOwned;
681     mapping (address => mapping (address => uint256)) private _allowances;
682 
683     mapping (address => bool) private _isExcludedFromFee;
684 
685     mapping (address => bool) private _isExcluded;
686     address[] private _excluded;
687    
688     uint256 private constant MAX = ~uint256(0);
689     uint256 private _tTotal = 4200000000 * 10**18;
690     uint256 private _rTotal = (MAX - (MAX % _tTotal));
691     uint256 private _tFeeTotal;
692 
693     string private _name = "Chronic Token";
694     string private _symbol = "CHT";
695     uint8 private _decimals = 18;
696     
697     uint256 public _taxFee = 1;
698     uint256 private _previousTaxFee = _taxFee;
699     
700     uint256 public _liquidityFee = 1;
701     uint256 private _previousLiquidityFee = _liquidityFee;
702 
703     uint256 public _burnFee = 1;
704     uint256 private _previousBurnFee = _burnFee;
705 
706     IUniswapV2Router02 public immutable uniswapV2Router;
707     address public immutable uniswapV2Pair;
708     
709     bool inSwapAndLiquify;
710     bool public swapAndLiquifyEnabled = true;
711     
712     uint256 public _maxTxAmount = 4200000000 * 10**18;
713     uint256 private numTokensSellToAddToLiquidity = 2100000000 * 10**18;
714     
715     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
716     event SwapAndLiquifyEnabledUpdated(bool enabled);
717     event SwapAndLiquify(
718         uint256 tokensSwapped,
719         uint256 ethReceived,
720         uint256 tokensIntoLiqudity
721     );
722     
723     modifier lockTheSwap {
724         inSwapAndLiquify = true;
725         _;
726         inSwapAndLiquify = false;
727     }
728     
729     constructor () public {
730         _rOwned[_msgSender()] = _rTotal;
731         
732         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);    // main net
733          // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);       // ropsten test net
734          // Create a uniswap pair for this new token
735         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
736             .createPair(address(this), _uniswapV2Router.WETH());
737 
738         // set the rest of the contract variables
739         uniswapV2Router = _uniswapV2Router;
740         
741         //exclude owner and this contract from fee
742         _isExcludedFromFee[owner()] = true;
743         _isExcludedFromFee[address(this)] = true;
744         
745         emit Transfer(address(0), _msgSender(), _tTotal);
746     }
747 
748     function name() public view returns (string memory) {
749         return _name;
750     }
751 
752     function symbol() public view returns (string memory) {
753         return _symbol;
754     }
755 
756     function decimals() public view returns (uint8) {
757         return _decimals;
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
810         (uint256 rAmount,,,,,,) = _getValues(tAmount);
811         _rOwned[sender] = _rOwned[sender].sub(rAmount);
812         _rTotal = _rTotal.sub(rAmount);
813         _tFeeTotal = _tFeeTotal.add(tAmount);
814     }
815 
816     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
817         require(tAmount <= _tTotal, "Amount must be less than supply");
818         if (!deductTransferFee) {
819             (uint256 rAmount,,,,,,) = _getValues(tAmount);
820             return rAmount;
821         } else {
822             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
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
856         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
857         _tOwned[sender] = _tOwned[sender].sub(tAmount);
858         _rOwned[sender] = _rOwned[sender].sub(rAmount);
859         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
860         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
861         _takeLiquidity(tLiquidity);
862         _takeBurn(tBurn);
863         _reflectFee(rFee, tFee);
864         emit Transfer(sender, recipient, tTransferAmount);
865     }
866     
867     function excludeFromFee(address account) public onlyOwner {
868         _isExcludedFromFee[account] = true;
869     }
870     
871     function includeInFee(address account) public onlyOwner {
872         _isExcludedFromFee[account] = false;
873     }
874     
875     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
876         _taxFee = taxFee;
877     }
878 
879     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
880         _burnFee = burnFee;
881     }
882     
883     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
884         _liquidityFee = liquidityFee;
885     }
886    
887     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
888         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
889             10**2
890         );
891     }
892     
893     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
894         _maxTxAmount = maxTxAmount;
895     }
896 
897     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
898         swapAndLiquifyEnabled = _enabled;
899         emit SwapAndLiquifyEnabledUpdated(_enabled);
900     }
901     
902      //to recieve ETH from uniswapV2Router when swaping
903     receive() external payable {}
904 
905     function _reflectFee(uint256 rFee, uint256 tFee) private {
906         _rTotal = _rTotal.sub(rFee);
907         _tFeeTotal = _tFeeTotal.add(tFee);
908     }
909 
910     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
911         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getTValues(tAmount);
912         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tBurn, _getRate());
913         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBurn);
914     }
915     
916     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
917         uint256 tFee = calculateTaxFee(tAmount);
918         uint256 tLiquidity = calculateLiquidityFee(tAmount);
919         uint256 tBurn = calculateBurnFee(tAmount);
920         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurn);
921         return (tTransferAmount, tFee, tLiquidity, tBurn);
922     }
923 
924     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
925         uint256 rAmount = tAmount.mul(currentRate);
926         uint256 rFee = tFee.mul(currentRate);
927         uint256 rLiquidity = tLiquidity.mul(currentRate);
928         uint256 rBurn = tBurn.mul(currentRate);
929         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
930         return (rAmount, rTransferAmount, rFee);
931     }
932 
933     function _getRate() private view returns(uint256) {
934         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
935         return rSupply.div(tSupply);
936     }
937 
938     function _getCurrentSupply() private view returns(uint256, uint256) {
939         uint256 rSupply = _rTotal;
940         uint256 tSupply = _tTotal;      
941         for (uint256 i = 0; i < _excluded.length; i++) {
942             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
943             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
944             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
945         }
946         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
947         return (rSupply, tSupply);
948     }
949     
950     function _takeLiquidity(uint256 tLiquidity) private {
951         uint256 currentRate =  _getRate();
952         uint256 rLiquidity = tLiquidity.mul(currentRate);
953         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
954         if(_isExcluded[address(this)])
955             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
956     }
957     
958     function _takeBurn(uint256 tBurn) private {
959         uint256 currentRate =  _getRate();
960         uint256 rBurn = tBurn.mul(currentRate);
961         _rOwned[address(0x0)] = _rOwned[address(0x0)].add(rBurn);
962         if(_isExcluded[address(0x0)])
963             _tOwned[address(0x0)] = _tOwned[address(0x0)].add(tBurn);
964     }
965     
966     function _burn(address sender, uint256 tBurn) public {
967             
968         uint256 rBurn = tBurn.mul(_getRate());
969 
970         _tTotal = _tTotal.sub(tBurn);
971         _rTotal = _rTotal.sub(rBurn);
972 
973         _rOwned[sender] = _rOwned[sender].sub(rBurn);
974         if (_isExcluded[sender])
975              _tOwned[sender] = _tOwned[sender].sub(tBurn);
976 
977         address burnAddress = address(0);
978         _rOwned[burnAddress] = _rOwned[burnAddress].add(rBurn);
979         if (_isExcluded[burnAddress])
980             _tOwned[burnAddress] = _tOwned[burnAddress].add(tBurn);    
981 
982         emit Transfer(sender, burnAddress, tBurn);
983     }
984 
985     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
986         return _amount.mul(_taxFee).div(
987             10**2
988         );
989     }
990 
991     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
992         return _amount.mul(_liquidityFee).div(
993             10**2
994         );
995     }
996 
997     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
998         return _amount.mul(_burnFee).div(
999             10**2
1000         );
1001     }
1002 
1003     
1004     function removeAllFee() private {
1005         if(_taxFee == 0 && _liquidityFee == 0) return;
1006         
1007         _previousTaxFee = _taxFee;
1008         _previousLiquidityFee = _liquidityFee;
1009         _previousBurnFee = _burnFee;
1010         
1011         _taxFee = 0;
1012         _liquidityFee = 0;
1013         _burnFee = 0;
1014     }
1015     
1016     function restoreAllFee() private {
1017         _taxFee = _previousTaxFee;
1018         _liquidityFee = _previousLiquidityFee;
1019         _burnFee = _previousBurnFee;
1020     }
1021     
1022     function isExcludedFromFee(address account) public view returns(bool) {
1023         return _isExcludedFromFee[account];
1024     }
1025 
1026     function _approve(address owner, address spender, uint256 amount) private {
1027         require(owner != address(0), "ERC20: approve from the zero address");
1028         require(spender != address(0), "ERC20: approve to the zero address");
1029 
1030         _allowances[owner][spender] = amount;
1031         emit Approval(owner, spender, amount);
1032     }
1033 
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 amount
1038     ) private {
1039         require(from != address(0), "ERC20: transfer from the zero address");
1040         require(to != address(0), "ERC20: transfer to the zero address");
1041         require(amount > 0, "Transfer amount must be greater than zero");
1042         if(from != owner() && to != owner())
1043             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1044 
1045         // is the token balance of this contract address over the min number of
1046         // tokens that we need to initiate a swap + liquidity lock?
1047         // also, don't get caught in a circular liquidity event.
1048         // also, don't swap & liquify if sender is uniswap pair.
1049         uint256 contractTokenBalance = balanceOf(address(this));
1050         
1051         if(contractTokenBalance >= _maxTxAmount)
1052         {
1053             contractTokenBalance = _maxTxAmount;
1054         }
1055         
1056         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1057         if (
1058             overMinTokenBalance &&
1059             !inSwapAndLiquify &&
1060             from != uniswapV2Pair &&
1061             swapAndLiquifyEnabled
1062         ) {
1063             contractTokenBalance = numTokensSellToAddToLiquidity;
1064             //add liquidity
1065             swapAndLiquify(contractTokenBalance);
1066         }
1067         
1068         //indicates if fee should be deducted from transfer
1069         bool takeFee = true;
1070         
1071         //if any account belongs to _isExcludedFromFee account then remove the fee
1072         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1073             takeFee = false;
1074         }
1075         
1076         //transfer amount, it will take tax, burn, liquidity fee
1077         _tokenTransfer(from,to,amount,takeFee);
1078     }
1079 
1080     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1081         // split the contract balance into halves
1082         uint256 half = contractTokenBalance.div(2);
1083         uint256 otherHalf = contractTokenBalance.sub(half);
1084 
1085         // capture the contract's current ETH balance.
1086         // this is so that we can capture exactly the amount of ETH that the
1087         // swap creates, and not make the liquidity event include any ETH that
1088         // has been manually sent to the contract
1089         uint256 initialBalance = address(this).balance;
1090 
1091         // swap tokens for ETH
1092         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1093 
1094         // how much ETH did we just swap into?
1095         uint256 newBalance = address(this).balance.sub(initialBalance);
1096 
1097         // add liquidity to uniswap
1098         addLiquidity(otherHalf, newBalance);
1099         
1100         emit SwapAndLiquify(half, newBalance, otherHalf);
1101     }
1102 
1103     function swapTokensForEth(uint256 tokenAmount) private {
1104         // generate the uniswap pair path of token -> weth
1105         address[] memory path = new address[](2);
1106         path[0] = address(this);
1107         path[1] = uniswapV2Router.WETH();
1108 
1109         _approve(address(this), address(uniswapV2Router), tokenAmount);
1110 
1111         // make the swap
1112         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1113             tokenAmount,
1114             0, // accept any amount of ETH
1115             path,
1116             address(this),
1117             block.timestamp
1118         );
1119     }
1120 
1121     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1122         // approve token transfer to cover all possible scenarios
1123         _approve(address(this), address(uniswapV2Router), tokenAmount);
1124 
1125         // add the liquidity
1126         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1127             address(this),
1128             tokenAmount,
1129             0, // slippage is unavoidable
1130             0, // slippage is unavoidable
1131             owner(),
1132             block.timestamp
1133         );
1134     }
1135 
1136     //this method is responsible for taking all fee, if takeFee is true
1137     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1138         if(!takeFee)
1139             removeAllFee();
1140         
1141         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1142             _transferFromExcluded(sender, recipient, amount);
1143         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1144             _transferToExcluded(sender, recipient, amount);
1145         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1146             _transferStandard(sender, recipient, amount);
1147         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1148             _transferBothExcluded(sender, recipient, amount);
1149         } else {
1150             _transferStandard(sender, recipient, amount);
1151         }
1152         
1153         if(!takeFee)
1154             restoreAllFee();
1155     }
1156 
1157     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1158         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1159         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1160         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1161         _takeLiquidity(tLiquidity);
1162         _takeBurn(tBurn);
1163         _reflectFee(rFee, tFee);
1164         emit Transfer(sender, recipient, tTransferAmount);
1165     }
1166 
1167     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1168         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1169         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1170         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1171         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1172         _takeLiquidity(tLiquidity);
1173         _takeBurn(tBurn);
1174         _reflectFee(rFee, tFee);
1175         emit Transfer(sender, recipient, tTransferAmount);
1176     }
1177 
1178     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1179         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getValues(tAmount);
1180         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1181         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1182         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1183         _takeLiquidity(tLiquidity);
1184         _takeBurn(tBurn);
1185         _reflectFee(rFee, tFee);
1186         emit Transfer(sender, recipient, tTransferAmount);
1187     }
1188 }