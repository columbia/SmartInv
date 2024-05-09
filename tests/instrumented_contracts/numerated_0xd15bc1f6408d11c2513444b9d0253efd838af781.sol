1 /**
2 
3  By the Dogpeople, For the Dogpeople, Of the Dogpeople
4 
5 */
6 
7 pragma solidity ^0.8.9;
8 // SPDX-License-Identifier: Unlicensed
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
238     //function _msgSender() internal view virtual returns (address payable) {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes memory) {
244         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
245         return msg.data;
246     }
247 }
248 
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
273         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
274         // for accounts without code, i.e. `keccak256('')`
275         bytes32 codehash;
276         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { codehash := extcodehash(account) }
279         return (codehash != accountHash && codehash != 0x0);
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325       return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         return _functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         return _functionCallWithValue(target, data, value, errorMessage);
362     }
363 
364     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 // solhint-disable-next-line no-inline-assembly
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 contract Ownable is Context {
401     address private _owner;
402     address private _previousOwner;
403     uint256 private _lockTime;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor () {
411         address msgSender = _msgSender();
412         _owner = msgSender;
413         emit OwnershipTransferred(address(0), msgSender);
414     }
415 
416     /**
417      * @dev Returns the address of the current owner.
418      */
419     function owner() public view returns (address) {
420         return _owner;
421     }
422 
423     /**
424      * @dev Throws if called by any account other than the owner.
425      */
426     modifier onlyOwner() {
427         require(_owner == _msgSender(), "Ownable: caller is not the owner");
428         _;
429     }
430 
431      /**
432      * @dev Leaves the contract without owner. It will not be possible to call
433      * `onlyOwner` functions anymore. Can only be called by the current owner.
434      *
435      * NOTE: Renouncing ownership will leave the contract without an owner,
436      * thereby removing any functionality that is only available to the owner.
437      */
438     function renounceOwnership() public virtual onlyOwner {
439         emit OwnershipTransferred(_owner, address(0));
440         _owner = address(0);
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Can only be called by the current owner.
446      */
447     function transferOwnership(address newOwner) public virtual onlyOwner {
448         require(newOwner != address(0), "Ownable: new owner is the zero address");
449         emit OwnershipTransferred(_owner, newOwner);
450         _owner = newOwner;
451     }
452 
453     function geUnlockTime() public view returns (uint256) {
454         return _lockTime;
455     }
456 
457     //Locks the contract for owner for the amount of time provided
458     function lock(uint256 time) public virtual onlyOwner {
459         _previousOwner = _owner;
460         _owner = address(0);
461         _lockTime = block.timestamp + time;
462         emit OwnershipTransferred(_owner, address(0));
463     }
464     
465     //Unlocks the contract for owner when _lockTime is exceeds
466     function unlock() public virtual {
467         require(_previousOwner == msg.sender, "You don't have permission to unlock");
468         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
469         emit OwnershipTransferred(_owner, _previousOwner);
470         _owner = _previousOwner;
471     }
472 }
473 
474 
475 interface IUniswapV2Factory {
476     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
477 
478     function feeTo() external view returns (address);
479     function feeToSetter() external view returns (address);
480 
481     function getPair(address tokenA, address tokenB) external view returns (address pair);
482     function allPairs(uint) external view returns (address pair);
483     function allPairsLength() external view returns (uint);
484 
485     function createPair(address tokenA, address tokenB) external returns (address pair);
486 
487     function setFeeTo(address) external;
488     function setFeeToSetter(address) external;
489 }
490 
491 
492 
493 interface IUniswapV2Pair {
494     event Approval(address indexed owner, address indexed spender, uint value);
495     event Transfer(address indexed from, address indexed to, uint value);
496 
497     function name() external pure returns (string memory);
498     function symbol() external pure returns (string memory);
499     function decimals() external pure returns (uint8);
500     function totalSupply() external view returns (uint);
501     function balanceOf(address owner) external view returns (uint);
502     function allowance(address owner, address spender) external view returns (uint);
503 
504     function approve(address spender, uint value) external returns (bool);
505     function transfer(address to, uint value) external returns (bool);
506     function transferFrom(address from, address to, uint value) external returns (bool);
507 
508     function DOMAIN_SEPARATOR() external view returns (bytes32);
509     function PERMIT_TYPEHASH() external pure returns (bytes32);
510     function nonces(address owner) external view returns (uint);
511 
512     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
513 
514     event Mint(address indexed sender, uint amount0, uint amount1);
515     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
516     event Swap(
517         address indexed sender,
518         uint amount0In,
519         uint amount1In,
520         uint amount0Out,
521         uint amount1Out,
522         address indexed to
523     );
524     event Sync(uint112 reserve0, uint112 reserve1);
525 
526     function MINIMUM_LIQUIDITY() external pure returns (uint);
527     function factory() external view returns (address);
528     function token0() external view returns (address);
529     function token1() external view returns (address);
530     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
531     function price0CumulativeLast() external view returns (uint);
532     function price1CumulativeLast() external view returns (uint);
533     function kLast() external view returns (uint);
534 
535     function mint(address to) external returns (uint liquidity);
536     function burn(address to) external returns (uint amount0, uint amount1);
537     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
538     function skim(address to) external;
539     function sync() external;
540 
541     function initialize(address, address) external;
542 }
543 
544 
545 interface IUniswapV2Router01 {
546     function factory() external pure returns (address);
547     function WETH() external pure returns (address);
548 
549     function addLiquidity(
550         address tokenA,
551         address tokenB,
552         uint amountADesired,
553         uint amountBDesired,
554         uint amountAMin,
555         uint amountBMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountA, uint amountB, uint liquidity);
559     function addLiquidityETH(
560         address token,
561         uint amountTokenDesired,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline
566     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
567     function removeLiquidity(
568         address tokenA,
569         address tokenB,
570         uint liquidity,
571         uint amountAMin,
572         uint amountBMin,
573         address to,
574         uint deadline
575     ) external returns (uint amountA, uint amountB);
576     function removeLiquidityETH(
577         address token,
578         uint liquidity,
579         uint amountTokenMin,
580         uint amountETHMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountToken, uint amountETH);
584     function removeLiquidityWithPermit(
585         address tokenA,
586         address tokenB,
587         uint liquidity,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountA, uint amountB);
594     function removeLiquidityETHWithPermit(
595         address token,
596         uint liquidity,
597         uint amountTokenMin,
598         uint amountETHMin,
599         address to,
600         uint deadline,
601         bool approveMax, uint8 v, bytes32 r, bytes32 s
602     ) external returns (uint amountToken, uint amountETH);
603     function swapExactTokensForTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapTokensForExactTokens(
611         uint amountOut,
612         uint amountInMax,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
618         external
619         payable
620         returns (uint[] memory amounts);
621     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631 
632     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
633     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
634     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
635     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
636     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
637 }
638 
639 
640 
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
683 contract ShibaCrypt is Context, IERC20, Ownable {
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
696     mapping (address => bool) private botWallets;
697     bool botscantrade = false;
698     
699     bool public canTrade = false;
700    
701     uint256 private constant MAX = ~uint256(0);
702     uint256 private _tTotal = 100000000000 * 10**9;
703     uint256 private _rTotal = (MAX - (MAX % _tTotal));
704     uint256 private _tFeeTotal;
705     address public marketingWallet;
706 
707     string private _name = "ShibaCrypt";
708     string private _symbol = "SCX";
709     uint8 private _decimals = 9;
710     
711     uint256 public _taxFee = 0;
712     uint256 private _previousTaxFee = _taxFee;
713 
714     uint256 public marketingFeePercent = 50;
715     
716     uint256 public _liquidityFee = 4;
717     uint256 private _previousLiquidityFee = _liquidityFee;
718 
719     IUniswapV2Router02 public immutable uniswapV2Router;
720     address public immutable uniswapV2Pair;
721     
722     bool inSwapAndLiquify;
723     bool public swapAndLiquifyEnabled = true;
724     
725     uint256 public _maxTxAmount = 500000000 * 10**9;
726     uint256 public numTokensSellToAddToLiquidity = 30000000 * 10**9;
727     uint256 public _maxWalletSize = 1000000000 * 10**9;
728     
729     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
730     event SwapAndLiquifyEnabledUpdated(bool enabled);
731     event SwapAndLiquify(
732         uint256 tokensSwapped,
733         uint256 ethReceived,
734         uint256 tokensIntoLiqudity
735     );
736     
737     modifier lockTheSwap {
738         inSwapAndLiquify = true;
739         _;
740         inSwapAndLiquify = false;
741     }
742     
743     constructor () {
744         _rOwned[_msgSender()] = _rTotal;
745         
746         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
747          // Create a uniswap pair for this new token
748         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
749             .createPair(address(this), _uniswapV2Router.WETH());
750 
751         // set the rest of the contract variables
752         uniswapV2Router = _uniswapV2Router;
753         
754         //exclude owner and this contract from fee
755         _isExcludedFromFee[owner()] = true;
756         _isExcludedFromFee[address(this)] = true;
757         
758         emit Transfer(address(0), _msgSender(), _tTotal);
759     }
760 
761     function name() public view returns (string memory) {
762         return _name;
763     }
764 
765     function symbol() public view returns (string memory) {
766         return _symbol;
767     }
768 
769     function decimals() public view returns (uint8) {
770         return _decimals;
771     }
772 
773     function totalSupply() public view override returns (uint256) {
774         return _tTotal;
775     }
776 
777     function balanceOf(address account) public view override returns (uint256) {
778         if (_isExcluded[account]) return _tOwned[account];
779         return tokenFromReflection(_rOwned[account]);
780     }
781 
782     function transfer(address recipient, uint256 amount) public override returns (bool) {
783         _transfer(_msgSender(), recipient, amount);
784         return true;
785     }
786 
787     function allowance(address owner, address spender) public view override returns (uint256) {
788         return _allowances[owner][spender];
789     }
790 
791     function approve(address spender, uint256 amount) public override returns (bool) {
792         _approve(_msgSender(), spender, amount);
793         return true;
794     }
795 
796     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
797         _transfer(sender, recipient, amount);
798         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
799         return true;
800     }
801 
802     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
803         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
804         return true;
805     }
806 
807     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
808         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
809         return true;
810     }
811 
812     function isExcludedFromReward(address account) public view returns (bool) {
813         return _isExcluded[account];
814     }
815 
816     function totalFees() public view returns (uint256) {
817         return _tFeeTotal;
818     }
819 
820     function deliver(uint256 tAmount) public {
821         address sender = _msgSender();
822         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
823         (uint256 rAmount,,,,,) = _getValues(tAmount);
824         _rOwned[sender] = _rOwned[sender].sub(rAmount);
825         _rTotal = _rTotal.sub(rAmount);
826         _tFeeTotal = _tFeeTotal.add(tAmount);
827     }
828 
829     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
830         require(tAmount <= _tTotal, "Amount must be less than supply");
831         if (!deductTransferFee) {
832             (uint256 rAmount,,,,,) = _getValues(tAmount);
833             return rAmount;
834         } else {
835             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
836             return rTransferAmount;
837         }
838     }
839 
840     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
841         require(rAmount <= _rTotal, "Amount must be less than total reflections");
842         uint256 currentRate =  _getRate();
843         return rAmount.div(currentRate);
844     }
845 
846     function excludeFromReward(address account) public onlyOwner() {
847         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
848         require(!_isExcluded[account], "Account is already excluded");
849         if(_rOwned[account] > 0) {
850             _tOwned[account] = tokenFromReflection(_rOwned[account]);
851         }
852         _isExcluded[account] = true;
853         _excluded.push(account);
854     }
855 
856     function includeInReward(address account) external onlyOwner() {
857         require(_isExcluded[account], "Account is already excluded");
858         for (uint256 i = 0; i < _excluded.length; i++) {
859             if (_excluded[i] == account) {
860                 _excluded[i] = _excluded[_excluded.length - 1];
861                 _tOwned[account] = 0;
862                 _isExcluded[account] = false;
863                 _excluded.pop();
864                 break;
865             }
866         }
867     }
868         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
869         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
870         _tOwned[sender] = _tOwned[sender].sub(tAmount);
871         _rOwned[sender] = _rOwned[sender].sub(rAmount);
872         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
873         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
874         _takeLiquidity(tLiquidity);
875         _reflectFee(rFee, tFee);
876         emit Transfer(sender, recipient, tTransferAmount);
877     }
878     
879     function excludeFromFee(address account) public onlyOwner {
880         _isExcludedFromFee[account] = true;
881     }
882     
883     function includeInFee(address account) public onlyOwner {
884         _isExcludedFromFee[account] = false;
885     }
886     function setMarketingFeePercent(uint256 fee) public onlyOwner {
887         marketingFeePercent = fee;
888     }
889 
890     function setMarketingWallet(address walletAddress) public onlyOwner {
891         marketingWallet = walletAddress;
892     }
893     
894     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
895         require(taxFee < 5, "Tax fee cannot be more than 5%");
896         _taxFee = taxFee;
897     }
898     
899     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
900         require(liquidityFee < 5, "Liquidity fee cannot be more than 5%");
901         _liquidityFee = liquidityFee;
902     }
903 
904     function _setMaxWalletSizePercent(uint256 maxWalletSize)
905         external
906         onlyOwner
907     {
908         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
909     }
910    
911     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
912         require(maxTxAmount > 10000000, "Max Tx Amount cannot be less than 10 Million");
913         _maxTxAmount = maxTxAmount * 10**9;
914     }
915     
916     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
917         require(SwapThresholdAmount > 10000000, "Swap Threshold Amount cannot be less than 10 Million");
918         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
919     }
920     
921     function claimTokens () public onlyOwner {
922         // make sure we capture all ETH that may or may not be sent to this contract
923         payable(marketingWallet).transfer(address(this).balance);
924     }
925     
926     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
927         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
928     }
929     
930     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
931         walletaddress.transfer(address(this).balance);
932     }
933     
934     function addBotWallet(address botwallet) external onlyOwner() {
935         botWallets[botwallet] = true;
936     }
937 
938     function addBotWalletsInternal(address botwallet) internal {
939         botWallets[botwallet] = true;
940     }
941 
942     function addMultipleBotWallets(address[] calldata multiplebotWallets) external onlyOwner(){
943         uint256 iterator = 0;
944         while(iterator < multiplebotWallets.length){
945             addBotWalletsInternal(multiplebotWallets[iterator]);
946             iterator += 1;
947         }
948     }
949     
950     function removeBotWallet(address botwallet) external onlyOwner() {
951         botWallets[botwallet] = false;
952     }
953     
954     function getBotWalletStatus(address botwallet) public view returns (bool) {
955         return botWallets[botwallet];
956     }
957     
958     function allowtrading()external onlyOwner() {
959         canTrade = true;
960     }
961 
962     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
963         swapAndLiquifyEnabled = _enabled;
964         emit SwapAndLiquifyEnabledUpdated(_enabled);
965     }
966     
967      //to recieve ETH from uniswapV2Router when swaping
968     receive() external payable {}
969 
970     function _reflectFee(uint256 rFee, uint256 tFee) private {
971         _rTotal = _rTotal.sub(rFee);
972         _tFeeTotal = _tFeeTotal.add(tFee);
973     }
974 
975     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
976         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
977         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
978         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
979     }
980 
981     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
982         uint256 tFee = calculateTaxFee(tAmount);
983         uint256 tLiquidity = calculateLiquidityFee(tAmount);
984         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
985         return (tTransferAmount, tFee, tLiquidity);
986     }
987 
988     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
989         uint256 rAmount = tAmount.mul(currentRate);
990         uint256 rFee = tFee.mul(currentRate);
991         uint256 rLiquidity = tLiquidity.mul(currentRate);
992         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
993         return (rAmount, rTransferAmount, rFee);
994     }
995 
996     function _getRate() private view returns(uint256) {
997         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
998         return rSupply.div(tSupply);
999     }
1000 
1001     function _getCurrentSupply() private view returns(uint256, uint256) {
1002         uint256 rSupply = _rTotal;
1003         uint256 tSupply = _tTotal;      
1004         for (uint256 i = 0; i < _excluded.length; i++) {
1005             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1006             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1007             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1008         }
1009         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1010         return (rSupply, tSupply);
1011     }
1012     
1013     function _takeLiquidity(uint256 tLiquidity) private {
1014         uint256 currentRate =  _getRate();
1015         uint256 rLiquidity = tLiquidity.mul(currentRate);
1016         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1017         if(_isExcluded[address(this)])
1018             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1019     }
1020     
1021     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1022         return _amount.mul(_taxFee).div(
1023             10**2
1024         );
1025     }
1026 
1027     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1028         return _amount.mul(_liquidityFee).div(
1029             10**2
1030         );
1031     }
1032     
1033     function removeAllFee() private {
1034         if(_taxFee == 0 && _liquidityFee == 0) return;
1035         
1036         _previousTaxFee = _taxFee;
1037         _previousLiquidityFee = _liquidityFee;
1038         
1039         _taxFee = 0;
1040         _liquidityFee = 0;
1041     }
1042     
1043     function restoreAllFee() private {
1044         _taxFee = _previousTaxFee;
1045         _liquidityFee = _previousLiquidityFee;
1046     }
1047     
1048     function isExcludedFromFee(address account) public view returns(bool) {
1049         return _isExcludedFromFee[account];
1050     }
1051 
1052     function _approve(address owner, address spender, uint256 amount) private {
1053         require(owner != address(0), "ERC20: approve from the zero address");
1054         require(spender != address(0), "ERC20: approve to the zero address");
1055 
1056         _allowances[owner][spender] = amount;
1057         emit Approval(owner, spender, amount);
1058     }
1059 
1060     function _transfer(
1061         address from,
1062         address to,
1063         uint256 amount
1064     ) private {
1065         require(from != address(0), "ERC20: transfer from the zero address");
1066         require(to != address(0), "ERC20: transfer to the zero address");
1067         require(amount > 0, "Transfer amount must be greater than zero");
1068         if(from != owner() && to != owner())
1069             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1070 
1071         // is the token balance of this contract address over the min number of
1072         // tokens that we need to initiate a swap + liquidity lock?
1073         // also, don't get caught in a circular liquidity event.
1074         // also, don't swap & liquify if sender is uniswap pair.
1075         uint256 contractTokenBalance = balanceOf(address(this));
1076         
1077         if(contractTokenBalance >= _maxTxAmount)
1078         {
1079             contractTokenBalance = _maxTxAmount;
1080         }
1081         
1082         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1083         if (
1084             overMinTokenBalance &&
1085             !inSwapAndLiquify &&
1086             from != uniswapV2Pair &&
1087             swapAndLiquifyEnabled
1088         ) {
1089             contractTokenBalance = numTokensSellToAddToLiquidity;
1090             //add liquidity
1091             swapAndLiquify(contractTokenBalance);
1092         }
1093         
1094         //indicates if fee should be deducted from transfer
1095         bool takeFee = true;
1096         
1097         //if any account belongs to _isExcludedFromFee account then remove the fee
1098         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1099             takeFee = false;
1100         }
1101 
1102         if (takeFee) {
1103             if (to != uniswapV2Pair) {
1104                 require(
1105                     amount + balanceOf(to) <= _maxWalletSize,
1106                     "Recipient exceeds max wallet size."
1107                 );
1108             }
1109         }
1110         
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
1129         swapTokensForEth(half); // <- this breaks the ETH -> MOSHI swap when swap+liquify is triggered
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
1176     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
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