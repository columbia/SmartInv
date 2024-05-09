1 pragma solidity ^0.8.0;
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
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations with added overflow
74  * checks.
75  *
76  * Arithmetic operations in Solidity wrap on overflow. This can easily result
77  * in bugs, because programmers usually assume that an overflow raises an
78  * error, which is the standard behavior in high level programming languages.
79  * `SafeMath` restores this intuition by reverting the transaction when an
80  * operation overflows.
81  *
82  * Using this library instead of the unchecked operations eliminates an entire
83  * class of bugs, so it's recommended to use it always.
84  */
85  
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      *
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      *
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b > 0, errorMessage);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts with custom message when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b != 0, errorMessage);
225         return a % b;
226     }
227 }
228 
229 abstract contract Context {
230     function _msgSender() internal view virtual returns (address ) {
231         return msg.sender;
232     }
233 
234     function _msgData() internal view virtual returns (bytes memory) {
235         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
236         return msg.data;
237     }
238 }
239 
240 /**
241  * @dev Collection of functions related to the address type
242  */
243 library Address {
244     /**
245      * @dev Returns true if `account` is a contract.
246      *
247      * [IMPORTANT]
248      * ====
249      * It is unsafe to assume that an address for which this function returns
250      * false is an externally-owned account (EOA) and not a contract.
251      *
252      * Among others, `isContract` will return false for the following
253      * types of addresses:
254      *
255      *  - an externally-owned account
256      *  - a contract in construction
257      *  - an address where a contract will be created
258      *  - an address where a contract lived, but was destroyed
259      * ====
260      */
261     function isContract(address account) internal view returns (bool) {
262         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264         // for accounts without code, i.e. `keccak256('')`
265         bytes32 codehash;
266         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
267         // solhint-disable-next-line no-inline-assembly
268         assembly { codehash := extcodehash(account) }
269         return (codehash != accountHash && codehash != 0x0);
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292         (bool success, ) = recipient.call{ value: amount }("");
293         require(success, "Address: unable to send value, recipient may have reverted");
294     }
295 
296     /**
297      * @dev Performs a Solidity function call using a low level `call`. A
298      * plain`call` is an unsafe replacement for a function call: use this
299      * function instead.
300      *
301      * If `target` reverts with a revert reason, it is bubbled up by this
302      * function (like regular Solidity function calls).
303      *
304      * Returns the raw returned data. To convert to the expected return value,
305      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306      *
307      * Requirements:
308      *
309      * - `target` must be a contract.
310      * - calling `target` with `data` must not revert.
311      *
312      * _Available since v3.1._
313      */
314     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315       return functionCall(target, data, "Address: low-level call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320      * `errorMessage` as a fallback revert reason when `target` reverts.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325         return _functionCallWithValue(target, data, 0, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but also transferring `value` wei to `target`.
331      *
332      * Requirements:
333      *
334      * - the calling contract must have an ETH balance of at least `value`.
335      * - the called Solidity function must be `payable`.
336      *
337      * _Available since v3.1._
338      */
339     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350         require(address(this).balance >= value, "Address: insufficient balance for call");
351         return _functionCallWithValue(target, data, value, errorMessage);
352     }
353 
354     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
355         require(isContract(target), "Address: call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
359         if (success) {
360             return returndata;
361         } else {
362             // Look for revert reason and bubble it up if present
363             if (returndata.length > 0) {
364                 // The easiest way to bubble the revert reason is using memory via assembly
365 
366                 // solhint-disable-next-line no-inline-assembly
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 /**
379  * @dev Contract module which provides a basic access control mechanism, where
380  * there is an account (an owner) that can be granted exclusive access to
381  * specific functions.
382  *
383  * By default, the owner account will be the one that deploys the contract. This
384  * can later be changed with {transferOwnership}.
385  *
386  * This module is used through inheritance. It will make available the modifier
387  * `onlyOwner`, which can be applied to your functions to restrict their use to
388  * the owner.
389  */
390 contract Ownable is Context {
391     address private _owner;
392     address private _previousOwner;
393     uint256 private _lockTime;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor () {
401         _owner = msg.sender;
402         emit OwnershipTransferred(address(0), msg.sender);
403     }
404 
405     /**
406      * @dev Returns the address of the current owner.
407      */
408     function owner() public view returns (address) {
409         return _owner;
410     }
411 
412     /**
413      * @dev Throws if called by any account other than the owner.
414      */
415     modifier onlyOwner() {
416         require(_owner == _msgSender(), "Ownable: caller is not the owner");
417         _;
418     }
419 
420      /**
421      * @dev Leaves the contract without owner. It will not be possible to call
422      * `onlyOwner` functions anymore. Can only be called by the current owner.
423      *
424      * NOTE: Renouncing ownership will leave the contract without an owner,
425      * thereby removing any functionality that is only available to the owner.
426      */
427     function renounceOwnership() public virtual onlyOwner {
428         emit OwnershipTransferred(_owner, address(0));
429         _owner = address(0);
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Can only be called by the current owner.
435      */
436     function transferOwnership(address newOwner) public virtual onlyOwner {
437         require(newOwner != address(0), "Ownable: new owner is the zero address");
438         emit OwnershipTransferred(_owner, newOwner);
439         _owner = newOwner;
440     }
441 
442     function geUnlockTime() public view returns (uint256) {
443         return _lockTime;
444     }
445 
446     //Locks the contract for owner for the amount of time provided
447     function lock(uint256 time) public virtual onlyOwner {
448         _previousOwner = _owner;
449         _owner = address(0);
450         _lockTime = block.timestamp + time;
451         emit OwnershipTransferred(_owner, address(0));
452     }
453     
454     //Unlocks the contract for owner when _lockTime is exceeds
455     function unlock() public virtual {
456         require(_previousOwner == msg.sender, "You don't have permission to unlock");
457         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
458         emit OwnershipTransferred(_owner, _previousOwner);
459         _owner = _previousOwner;
460     }
461 }
462 
463 interface IUniswapV2Factory {
464     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
465 
466     function feeTo() external view returns (address);
467     function feeToSetter() external view returns (address);
468 
469     function getPair(address tokenA, address tokenB) external view returns (address pair);
470     function allPairs(uint) external view returns (address pair);
471     function allPairsLength() external view returns (uint);
472 
473     function createPair(address tokenA, address tokenB) external returns (address pair);
474 
475     function setFeeTo(address) external;
476     function setFeeToSetter(address) external;
477 }
478 
479 interface IUniswapV2Pair {
480     event Approval(address indexed owner, address indexed spender, uint value);
481     event Transfer(address indexed from, address indexed to, uint value);
482 
483     function name() external pure returns (string memory);
484     function symbol() external pure returns (string memory);
485     function decimals() external pure returns (uint8);
486     function totalSupply() external view returns (uint);
487     function balanceOf(address owner) external view returns (uint);
488     function allowance(address owner, address spender) external view returns (uint);
489 
490     function approve(address spender, uint value) external returns (bool);
491     function transfer(address to, uint value) external returns (bool);
492     function transferFrom(address from, address to, uint value) external returns (bool);
493 
494     function DOMAIN_SEPARATOR() external view returns (bytes32);
495     function PERMIT_TYPEHASH() external pure returns (bytes32);
496     function nonces(address owner) external view returns (uint);
497 
498     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
499 
500     event Mint(address indexed sender, uint amount0, uint amount1);
501     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
502     event Swap(
503         address indexed sender,
504         uint amount0In,
505         uint amount1In,
506         uint amount0Out,
507         uint amount1Out,
508         address indexed to
509     );
510     event Sync(uint112 reserve0, uint112 reserve1);
511 
512     function MINIMUM_LIQUIDITY() external pure returns (uint);
513     function factory() external view returns (address);
514     function token0() external view returns (address);
515     function token1() external view returns (address);
516     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
517     function price0CumulativeLast() external view returns (uint);
518     function price1CumulativeLast() external view returns (uint);
519     function kLast() external view returns (uint);
520 
521     function mint(address to) external returns (uint liquidity);
522     function burn(address to) external returns (uint amount0, uint amount1);
523     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
524     function skim(address to) external;
525     function sync() external;
526 
527     function initialize(address, address) external;
528 }
529 
530 interface IUniswapV2Router01 {
531     function factory() external pure returns (address);
532     function WETH() external pure returns (address);
533 
534     function addLiquidity(
535         address tokenA,
536         address tokenB,
537         uint amountADesired,
538         uint amountBDesired,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline
543     ) external returns (uint amountA, uint amountB, uint liquidity);
544     function addLiquidityETH(
545         address token,
546         uint amountTokenDesired,
547         uint amountTokenMin,
548         uint amountETHMin,
549         address to,
550         uint deadline
551     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
552     function removeLiquidity(
553         address tokenA,
554         address tokenB,
555         uint liquidity,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline
560     ) external returns (uint amountA, uint amountB);
561     function removeLiquidityETH(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountToken, uint amountETH);
569     function removeLiquidityWithPermit(
570         address tokenA,
571         address tokenB,
572         uint liquidity,
573         uint amountAMin,
574         uint amountBMin,
575         address to,
576         uint deadline,
577         bool approveMax, uint8 v, bytes32 r, bytes32 s
578     ) external returns (uint amountA, uint amountB);
579     function removeLiquidityETHWithPermit(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline,
586         bool approveMax, uint8 v, bytes32 r, bytes32 s
587     ) external returns (uint amountToken, uint amountETH);
588     function swapExactTokensForTokens(
589         uint amountIn,
590         uint amountOutMin,
591         address[] calldata path,
592         address to,
593         uint deadline
594     ) external returns (uint[] memory amounts);
595     function swapTokensForExactTokens(
596         uint amountOut,
597         uint amountInMax,
598         address[] calldata path,
599         address to,
600         uint deadline
601     ) external returns (uint[] memory amounts);
602     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
603         external
604         payable
605         returns (uint[] memory amounts);
606     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
607         external
608         returns (uint[] memory amounts);
609     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
610         external
611         returns (uint[] memory amounts);
612     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
613         external
614         payable
615         returns (uint[] memory amounts);
616 
617     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
618     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
619     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
620     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
621     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
622 }
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
665 contract WHIS is Context, IERC20, Ownable {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     mapping (address => uint256) private _rOwned;
670     mapping (address => uint256) private _tOwned;
671     mapping (address => mapping (address => uint256)) private _allowances;
672 
673     mapping (address => bool) private _isExcludedFromFee;
674 
675     mapping (address => bool) private _isExcluded;
676     address[] private _excluded;
677 
678     mapping (address => bool) public _isExcludedBal; // list for Max Bal limits
679 
680     mapping (address => bool) public _isBlacklisted; 
681 
682    
683     uint256 private constant MAX = ~uint256(0);
684     uint256 private _tTotal = 1000000000 * 10**6 * 10**18; 
685     uint256 private _rTotal = (MAX - (MAX % _tTotal));
686     uint256 private _tFeeTotal;
687 
688     string private _name = "Whis Inu";
689     string private _symbol = "WHIS";
690     uint8 private _decimals = 18;
691     
692     uint256 public _burnFee = 0;
693     uint256 private _previousBurnFee = _burnFee;
694     
695     uint256 public _taxFee = 1;
696     uint256 private _previousTaxFee = _taxFee;
697     
698     uint256 private _liquidityFee = 10;
699     uint256 private _previousLiquidityFee = _liquidityFee;
700     
701     uint256 public _buyFees = 10;
702     uint256 public _sellFees = 10;
703 
704     address public marketing = 0x70959b9B69291641F4B70d0afd862e66f8E16deb;
705 
706     IUniswapV2Router02 public uniswapV2Router;
707     address public uniswapV2Pair;
708     
709     bool inSwapAndLiquify;
710     bool public swapAndLiquifyEnabled = true;
711     
712     uint256 public _maxBalAmount = _tTotal.mul(5).div(1000);
713     uint256 public numTokensSellToAddToLiquidity = 1 * 10**18;
714     
715     bool public _taxEnabled = true;
716 
717     event SetTaxEnable(bool enabled);
718     event SetSellFeePercent(uint256 sellFee);
719     event SetBuyFeePercent(uint256 buyFee);
720     event SetTaxFeePercent(uint256 taxFee);
721     event SetMarketingPercent(uint256 marketingFee);
722     event SetDevPercent(uint256 devFee);
723     event SetCommunityPercent(uint256 charityFee);
724     event SetMaxBalPercent(uint256 maxBalPercent);
725     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
726     event SwapAndLiquifyEnabledUpdated(bool enabled);
727     event TaxEnabledUpdated(bool enabled);
728     event SwapAndLiquify(
729         uint256 tokensSwapped,
730         uint256 ethReceived
731     );
732     
733     modifier lockTheSwap {
734         inSwapAndLiquify = true;
735         _;
736         inSwapAndLiquify = false;
737     }
738     
739     constructor () {
740         _rOwned[msg.sender] = _rTotal;
741         
742         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
743          // Create a uniswap pair for this new token
744         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
745             .createPair(address(this), _uniswapV2Router.WETH());
746 
747         // set the rest of the contract variables
748         uniswapV2Router = _uniswapV2Router;
749         
750         //exclude owner and this contract from fee
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753 
754         _isExcluded[uniswapV2Pair] = true; // excluded from rewards
755 
756         _isExcludedBal[uniswapV2Pair] = true; 
757         _isExcludedBal[owner()] = true;
758         _isExcludedBal[address(this)] = true; 
759         _isExcludedBal[address(0)] = true; 
760         
761         emit Transfer(address(0), msg.sender, _tTotal);
762         
763     }
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
824     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
825         require(tAmount <= _tTotal, "Amount must be less than supply");
826         if (!deductTransferFee) {
827             (uint256 rAmount,,,,,,) = _getValues(tAmount);
828             return rAmount;
829         } else {
830             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
831             return rTransferAmount;
832         }
833     }
834 
835     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
836         require(rAmount <= _rTotal, "Amount must be less than total reflections");
837         uint256 currentRate =  _getRate();
838         return rAmount.div(currentRate);
839     }
840 
841     function excludeFromReward(address account) public onlyOwner() {
842         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
843         require(!_isExcluded[account], "Account is already excluded");
844         if(_rOwned[account] > 0) {
845             _tOwned[account] = tokenFromReflection(_rOwned[account]);
846         }
847         _isExcluded[account] = true;
848         _excluded.push(account);
849     }
850 
851     function includeInReward(address account) external onlyOwner() {
852         require(_isExcluded[account], "Account is already excluded");
853         for (uint256 i = 0; i < _excluded.length; i++) {
854             if (_excluded[i] == account) {
855                 _excluded[i] = _excluded[_excluded.length - 1];
856                 _tOwned[account] = 0;
857                 _isExcluded[account] = false;
858                 _excluded.pop();
859                 break;
860             }
861         }
862     }
863 
864     function excludeFromLimit(address account) public onlyOwner() {
865         require(!_isExcludedBal[account], "Account is already excluded");
866         _isExcludedBal[account] = true;
867     }
868 
869     function includeInLimit(address account) external onlyOwner() {
870         require(_isExcludedBal[account], "Account is already excluded");
871         _isExcludedBal[account] = false;
872     }
873 
874     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
875         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
876         _tOwned[sender] = _tOwned[sender].sub(tAmount);
877         _rOwned[sender] = _rOwned[sender].sub(rAmount);
878         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
879         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
880         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
881         if(tBurn > 0) _burn(sender, tBurn);
882         _reflectFee(rFee, tFee);
883         emit Transfer(sender, recipient, tTransferAmount);
884     }
885     
886     function excludeFromFee(address account) public onlyOwner {
887         _isExcludedFromFee[account] = true;
888     }
889     
890     function includeInFee(address account) public onlyOwner {
891         _isExcludedFromFee[account] = false;
892     }
893     
894     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
895         _taxFee = taxFee;
896         emit SetTaxFeePercent(taxFee);
897     }
898     
899     function setSellFeePercent(uint256 sellFee) external onlyOwner() {
900         _sellFees = sellFee;
901         emit SetSellFeePercent(sellFee);
902     }
903 
904     function setBuyFeePercent(uint256 buyFee) external onlyOwner() {
905         _buyFees = buyFee;
906         emit SetBuyFeePercent(buyFee);
907     }
908 
909     function setMaxBalPercent(uint256 maxBalPercent) external onlyOwner() {
910         _maxBalAmount = _tTotal.mul(maxBalPercent).div(
911             10**2
912         );
913         emit SetMaxBalPercent(maxBalPercent);   
914     }
915 
916     function setSwapAmount(uint256 amount) external onlyOwner() {
917         numTokensSellToAddToLiquidity = amount;
918     }
919 
920     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
921         swapAndLiquifyEnabled = _enabled;
922         emit SwapAndLiquifyEnabledUpdated(_enabled);
923     }    
924 
925     function setTaxEnable (bool _enable) public onlyOwner {
926         _taxEnabled = _enable;
927         emit SetTaxEnable(_enable);
928     }
929 
930     function addToBlackList (address[] calldata accounts ) public onlyOwner {
931         for (uint256 i =0; i < accounts.length; ++i ) {
932             _isBlacklisted[accounts[i]] = true;
933         }
934     }
935 
936     function removeFromBlackList(address account) public onlyOwner {
937         _isBlacklisted[account] = false;
938     }
939 
940     //to recieve ETH from uniswapV2Router when swaping
941     receive() external payable {}
942 
943     function _reflectFee(uint256 rFee, uint256 tFee) private {
944         _rTotal = _rTotal.sub(rFee);
945         _tFeeTotal = _tFeeTotal.add(tFee);
946     }
947 
948     function _getValues(uint256 tAmount) private view returns ( uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
949         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn) = _getTValues(tAmount);
950         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate(), tBurn);
951         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tBurn);
952     }
953 
954     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
955         uint256 tBurn = calculateBurnFee(tAmount);
956         uint256 tFee = calculateTaxFee(tAmount);
957         uint256 tLiquidity = calculateLiquidityFee(tAmount);
958         
959         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tBurn);
960         return (tTransferAmount, tFee, tLiquidity, tBurn);
961     }
962 
963     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
964         uint256 rAmount = tAmount.mul(currentRate);
965         uint256 rFee = tFee.mul(currentRate);
966         uint256 rLiquidity = tLiquidity.mul(currentRate);
967         uint256 rBurn = tBurn.mul(currentRate);
968         
969         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rBurn);
970         return (rAmount, rTransferAmount, rFee);
971     }
972 
973     function _getRate() private view returns(uint256) {
974         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
975         return rSupply.div(tSupply);
976     }
977 
978     function _getCurrentSupply() private view returns(uint256, uint256) {
979         uint256 rSupply = _rTotal;
980         uint256 tSupply = _tTotal;      
981         for (uint256 i = 0; i < _excluded.length; i++) {
982             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
983             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
984             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
985         }
986         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
987         return (rSupply, tSupply);
988     }
989     
990     function _takeLiquidity(address sender, uint256 tLiquidity) private {
991         uint256 currentRate =  _getRate();
992         uint256 rLiquidity = tLiquidity.mul(currentRate);
993         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
994         if(_isExcluded[address(this)])
995             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
996         emit Transfer(sender, address(this), tLiquidity);
997         
998     }
999 
1000     function _burn(address sender, uint256 tBurn) private {
1001         uint256 currentRate =  _getRate();
1002         uint256 rLiquidity = tBurn.mul(currentRate);
1003         _rOwned[address(0)] = _rOwned[address(0)].add(rLiquidity);
1004         if(_isExcluded[address(0)])
1005             _tOwned[address(0)] = _tOwned[address(0)].add(tBurn);
1006         emit Transfer(sender, address(0), tBurn);
1007 
1008     }
1009     
1010     
1011     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1012         return _amount.mul(_taxFee).div(10**2);
1013 
1014     }
1015 
1016     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1017         return _amount.mul(_burnFee).div(10**2);
1018 
1019     }
1020 
1021     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1022         return _amount.mul(_liquidityFee).div(
1023             10**2
1024         );
1025     }
1026     
1027     function removeAllFee() private {
1028         if(_taxFee == 0 && _liquidityFee == 0 ) return;
1029     
1030         _previousTaxFee = _taxFee;
1031         _previousLiquidityFee = _liquidityFee;
1032         
1033         _taxFee = 0;
1034         _liquidityFee = 0;
1035     }
1036     
1037     function restoreAllFee() private {
1038         _taxFee = _previousTaxFee;
1039         _liquidityFee = _previousLiquidityFee;
1040     }
1041     
1042     function isExcludedFromFee(address account) public view returns(bool) {
1043         return _isExcludedFromFee[account];
1044     }
1045 
1046     function _approve(address owner, address spender, uint256 amount) private {
1047         require(owner != address(0), "ERC20: approve from the zero address");
1048         require(spender != address(0), "ERC20: approve to the zero address");
1049 
1050         _allowances[owner][spender] = amount;
1051         emit Approval(owner, spender, amount);
1052     }
1053 
1054     function _transfer(
1055         address from,
1056         address to,
1057         uint256 amount
1058     ) private {
1059         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1060         require(from != address(0), "ERC20: transfer from the zero address");
1061         require(amount > 0, "Transfer amount must be greater than zero");
1062         // if(from != owner() && to != owner())
1063         //     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1064 
1065         // is the token balance of this contract address over the min number of
1066         // tokens that we need to initiate a swap + liquidity lock?
1067         // also, don't get caught in a circular liquidity event.
1068         // also, don't swap & liquify if sender is uniswap pair.
1069         uint256 contractTokenBalance = balanceOf(address(this));
1070         
1071         // if(contractTokenBalance >= _maxTxAmount)
1072         // {
1073         //     contractTokenBalance = _maxTxAmount;
1074         // }
1075         
1076         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1077         if (
1078             overMinTokenBalance &&
1079             !inSwapAndLiquify &&
1080             from != uniswapV2Pair &&
1081             swapAndLiquifyEnabled
1082         ) {
1083             // contractTokenBalance = numTokensSellToAddToLiquidity;
1084             //add liquidity
1085             swapAndLiquify(contractTokenBalance);
1086         }
1087         
1088         //indicates if fee should be deducted from transfer
1089         bool takeFee = false;
1090 
1091         if(from == uniswapV2Pair || to == uniswapV2Pair) {
1092             takeFee = true;
1093         }
1094 
1095         if(!_taxEnabled || _isExcludedFromFee[from] || _isExcludedFromFee[to]){  //if any account belongs to _isExcludedFromFee account then remove the fee
1096             takeFee = false;
1097         }
1098         if(from == uniswapV2Pair) {
1099             _liquidityFee = _buyFees;
1100         }
1101 
1102         if (to == uniswapV2Pair) {
1103             _liquidityFee = _sellFees;
1104         }
1105         //transfer amount, it will take tax, burn, liquidity fee
1106         _tokenTransfer(from,to,amount,takeFee);
1107     }
1108 
1109     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {        
1110         // capture the contract's current ETH balance.
1111         // this is so that we can capture exactly the amount of ETH that the
1112         // swap creates, and not make the liquidity event include any ETH that
1113         // has been manually sent to the contract
1114         uint256 initialBalance = address(this).balance;
1115 
1116         // swap tokens for ETH
1117         swapTokensForEth(contractTokenBalance); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1118 
1119         // how much ETH did we just swap into?
1120         uint256 newBalance = address(this).balance.sub(initialBalance);
1121 
1122         (bool succ, ) = address(marketing).call{value: newBalance}("");
1123         require(succ, "marketing ETH not sent");
1124         emit SwapAndLiquify(contractTokenBalance, newBalance);
1125     }
1126 
1127     function swapTokensForEth(uint256 tokenAmount) private {
1128         // generate the uniswap pair path of token -> weth
1129         address[] memory path = new address[](2);
1130         path[0] = address(this);
1131         path[1] = uniswapV2Router.WETH();
1132 
1133         _approve(address(this), address(uniswapV2Router), tokenAmount);
1134 
1135         // make the swap
1136         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1137             tokenAmount,
1138             0, // accept any amount of ETH
1139             path,
1140             address(this),
1141             block.timestamp
1142         );
1143     }
1144 
1145 
1146     //this method is responsible for taking all fee, if takeFee is true
1147     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1148         if(!takeFee)
1149             removeAllFee();
1150         
1151         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1152             _transferFromExcluded(sender, recipient, amount);
1153         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1154             _transferToExcluded(sender, recipient, amount);
1155         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1156             _transferStandard(sender, recipient, amount);
1157         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1158             _transferBothExcluded(sender, recipient, amount);
1159         } else {
1160             _transferStandard(sender, recipient, amount);
1161         }
1162 
1163         if(!_isExcludedBal[recipient] ) {
1164             require(balanceOf(recipient)<= _maxBalAmount, "Balance limit reached");
1165         }        
1166         if(!takeFee)
1167             restoreAllFee();
1168     }
1169 
1170     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1171         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1172         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1173         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1174         if(tBurn > 0) _burn(sender, tBurn);
1175         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1176         _reflectFee(rFee, tFee);
1177         emit Transfer(sender, recipient, tTransferAmount);
1178     }
1179 
1180     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1181         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1182         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1183         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1184         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1185         if(tBurn > 0) _burn(sender, tBurn);
1186         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1187         _reflectFee(rFee, tFee);
1188         emit Transfer(sender, recipient, tTransferAmount);
1189     }
1190 
1191     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1192         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tBurn ) = _getValues(tAmount);
1193         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1194         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1195         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1196         if(tBurn > 0) _burn(sender, tBurn);
1197         if(tLiquidity > 0 ) _takeLiquidity(sender, tLiquidity);
1198         _reflectFee(rFee, tFee);
1199         emit Transfer(sender, recipient, tTransferAmount);
1200     }   
1201 }