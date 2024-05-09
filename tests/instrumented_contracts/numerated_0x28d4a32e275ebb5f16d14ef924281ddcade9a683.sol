1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.12;
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through {transferFrom}. This is
25      * zero by default.
26      *
27      * This value changes when {approve} or {transferFrom} are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * IMPORTANT: Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an {Approval} event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88  
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address payable) {
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
404     constructor () internal {
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
435         _previousOwner = address(0);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447 
448     function geUnlockTime() public view returns (uint256) {
449         return _lockTime;
450     }
451 
452     //Locks the contract for owner for the amount of time provided
453     function lock(uint256 time) public virtual onlyOwner {
454         _previousOwner = _owner;
455         _owner = address(0);
456         _lockTime = now + time;
457         emit OwnershipTransferred(_owner, address(0));
458     }
459     
460     //Unlocks the contract for owner when _lockTime is exceeds
461     function unlock() public virtual {
462         require(_previousOwner == msg.sender, "You don't have permission to unlock");
463         require(now > _lockTime , "Contract is locked until 7 days");
464         emit OwnershipTransferred(_owner, _previousOwner);
465         _owner = _previousOwner;
466     }
467 }
468 
469 // pragma solidity >=0.5.0;
470 
471 interface IUniswapV2Factory {
472     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
473 
474     function feeTo() external view returns (address);
475     function feeToSetter() external view returns (address);
476 
477     function getPair(address tokenA, address tokenB) external view returns (address pair);
478     function allPairs(uint) external view returns (address pair);
479     function allPairsLength() external view returns (uint);
480 
481     function createPair(address tokenA, address tokenB) external returns (address pair);
482 
483     function setFeeTo(address) external;
484     function setFeeToSetter(address) external;
485 }
486 
487 
488 // pragma solidity >=0.5.0;
489 
490 interface IUniswapV2Pair {
491     event Approval(address indexed owner, address indexed spender, uint value);
492     event Transfer(address indexed from, address indexed to, uint value);
493 
494     function name() external pure returns (string memory);
495     function symbol() external pure returns (string memory);
496     function decimals() external pure returns (uint8);
497     function totalSupply() external view returns (uint);
498     function balanceOf(address owner) external view returns (uint);
499     function allowance(address owner, address spender) external view returns (uint);
500 
501     function approve(address spender, uint value) external returns (bool);
502     function transfer(address to, uint value) external returns (bool);
503     function transferFrom(address from, address to, uint value) external returns (bool);
504 
505     function DOMAIN_SEPARATOR() external view returns (bytes32);
506     function PERMIT_TYPEHASH() external pure returns (bytes32);
507     function nonces(address owner) external view returns (uint);
508 
509     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
510 
511     event Mint(address indexed sender, uint amount0, uint amount1);
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
532     function mint(address to) external returns (uint liquidity);
533     function burn(address to) external returns (uint amount0, uint amount1);
534     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
535     function skim(address to) external;
536     function sync() external;
537 
538     function initialize(address, address) external;
539 }
540 
541 // pragma solidity >=0.6.2;
542 
543 interface IUniswapV2Router01 {
544     function factory() external pure returns (address);
545     function WETH() external pure returns (address);
546 
547     function addLiquidity(
548         address tokenA,
549         address tokenB,
550         uint amountADesired,
551         uint amountBDesired,
552         uint amountAMin,
553         uint amountBMin,
554         address to,
555         uint deadline
556     ) external returns (uint amountA, uint amountB, uint liquidity);
557     function addLiquidityETH(
558         address token,
559         uint amountTokenDesired,
560         uint amountTokenMin,
561         uint amountETHMin,
562         address to,
563         uint deadline
564     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
565     function removeLiquidity(
566         address tokenA,
567         address tokenB,
568         uint liquidity,
569         uint amountAMin,
570         uint amountBMin,
571         address to,
572         uint deadline
573     ) external returns (uint amountA, uint amountB);
574     function removeLiquidityETH(
575         address token,
576         uint liquidity,
577         uint amountTokenMin,
578         uint amountETHMin,
579         address to,
580         uint deadline
581     ) external returns (uint amountToken, uint amountETH);
582     function removeLiquidityWithPermit(
583         address tokenA,
584         address tokenB,
585         uint liquidity,
586         uint amountAMin,
587         uint amountBMin,
588         address to,
589         uint deadline,
590         bool approveMax, uint8 v, bytes32 r, bytes32 s
591     ) external returns (uint amountA, uint amountB);
592     function removeLiquidityETHWithPermit(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline,
599         bool approveMax, uint8 v, bytes32 r, bytes32 s
600     ) external returns (uint amountToken, uint amountETH);
601     function swapExactTokensForTokens(
602         uint amountIn,
603         uint amountOutMin,
604         address[] calldata path,
605         address to,
606         uint deadline
607     ) external returns (uint[] memory amounts);
608     function swapTokensForExactTokens(
609         uint amountOut,
610         uint amountInMax,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
616         external
617         payable
618         returns (uint[] memory amounts);
619     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
620         external
621         returns (uint[] memory amounts);
622     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         returns (uint[] memory amounts);
625     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
626         external
627         payable
628         returns (uint[] memory amounts);
629 
630     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
631     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
632     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
633     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
634     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
635 }
636 
637 
638 
639 // pragma solidity >=0.6.2;
640 
641 interface IUniswapV2Router02 is IUniswapV2Router01 {
642     function removeLiquidityETHSupportingFeeOnTransferTokens(
643         address token,
644         uint liquidity,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline
649     ) external returns (uint amountETH);
650     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
651         address token,
652         uint liquidity,
653         uint amountTokenMin,
654         uint amountETHMin,
655         address to,
656         uint deadline,
657         bool approveMax, uint8 v, bytes32 r, bytes32 s
658     ) external returns (uint amountETH);
659 
660     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
661         uint amountIn,
662         uint amountOutMin,
663         address[] calldata path,
664         address to,
665         uint deadline
666     ) external;
667     function swapExactETHForTokensSupportingFeeOnTransferTokens(
668         uint amountOutMin,
669         address[] calldata path,
670         address to,
671         uint deadline
672     ) external payable;
673     function swapExactTokensForETHSupportingFeeOnTransferTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external;
680 }
681 
682 
683 contract ShibTzuInu is Context, IERC20, Ownable {
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
696     uint256 private constant MAX = ~uint256(0);
697     uint256 private _tTotal = 1000000000000 * 10**9;
698     uint256 private _rTotal = (MAX - (MAX % _tTotal));
699     uint256 private _tFeeTotal;
700 
701     string private _name = "ShibTzu Inu";
702     string private _symbol = "ShibTzu";
703     uint8 private _decimals = 9;
704     
705     uint256 public _taxFee = 2;
706     uint256 private _previousTaxFee = _taxFee;
707     
708     uint256 public _liquidityFee = 8;
709     uint256 private _previousLiquidityFee = _liquidityFee;
710 
711     IUniswapV2Router02 public immutable uniswapV2Router;
712     address public immutable uniswapV2Pair;
713     address payable public _MarketingWalletAddress;
714     
715     bool inSwapAndLiquify;
716     bool public swapAndLiquifyEnabled = true;
717     
718     uint256 public _maxTxAmount = 2500000100 * 10**9;
719     uint256 public numTokensSellToAddToLiquidity = 2000000000 * 10**9;
720 
721     uint256 public lockTimeForTaxFee = 0;
722     uint256 public lockTimeForLiquidityFee = 0;
723     uint256 public lockTimeForMaxTx = 0;
724     uint256 public lockTimeForChangeSwapAndLiquifyEnabled = 0;
725     uint256 public lockTimeForChangeSNL = 0;
726     uint256 public numberOfSecondsForLock = 14400; //14400;
727 
728     uint256 public upcomingValueForTaxFee = 0;
729     uint256 public upcomingValueForLiquidityFee = 0;
730     uint256 public upcomingValueForMaxTx = 0;
731     uint256 public upcomingValueForChangeSNL = 0;
732     
733     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
734     event SwapAndLiquifyEnabledUpdated(bool enabled);
735     event SwapAndLiquify(
736         uint256 tokensSwapped,
737         uint256 ethReceived,
738         uint256 tokensIntoLiqudity
739     );
740     event RequestToChangeTax(uint256 timeStampForUpdate, uint256 newValue);
741     event RequestToChangeLiquidity(uint256 timeStampForUpdate, uint256 newValue);
742     event RequestToChangeMaxTx(uint256 timeStampForUpdate, uint256 newValue);
743     event RequestToChangeSNL(uint256 timeStampForUpdate, uint256 newValue);
744     event RequestToChangeSwapAndLiquifyEnabled();
745     
746     modifier lockTheSwap {
747         inSwapAndLiquify = true;
748         _;
749         inSwapAndLiquify = false;
750     }
751     
752     constructor (address payable MarketingWalletAddress) public {
753         _MarketingWalletAddress = MarketingWalletAddress;
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
857         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
858         require(!_isExcluded[account], "Account is already excluded");
859         if(_rOwned[account] > 0) {
860             _tOwned[account] = tokenFromReflection(_rOwned[account]);
861         }
862         _isExcluded[account] = true;
863         _excluded.push(account);
864     }
865 
866     function includeInReward(address account) external onlyOwner() {
867         require(_isExcluded[account], "Account is not excluded");
868         for (uint256 i = 0; i < _excluded.length; i++) {
869             if (_excluded[i] == account) {
870                 _excluded[i] = _excluded[_excluded.length - 1];
871                 _tOwned[account] = 0;
872                 _isExcluded[account] = false;
873                 _excluded.pop();
874                 break;
875             }
876         }
877     }
878     
879     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
880         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
881         _tOwned[sender] = _tOwned[sender].sub(tAmount);
882         _rOwned[sender] = _rOwned[sender].sub(rAmount);
883         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
884         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
885         _takeLiquidity(tLiquidity);
886         _reflectFee(rFee, tFee);
887         emit Transfer(sender, recipient, tTransferAmount);
888     }
889     
890     function excludeFromFee(address account) public onlyOwner {
891         _isExcludedFromFee[account] = true;
892     }
893     
894     function includeInFee(address account) public onlyOwner {
895         _isExcludedFromFee[account] = false;
896     }
897 
898     function requestToChangeNumberOfTokensForSNL(uint256 newValue) external onlyOwner() {
899         //add 4 hours to current timestamp
900         lockTimeForChangeSNL = block.timestamp.add(numberOfSecondsForLock);
901         //set value 
902         upcomingValueForChangeSNL = newValue;
903         emit RequestToChangeSNL(lockTimeForChangeSNL, upcomingValueForChangeSNL);
904     }
905 
906     function setNumberOfTokensForSNL() external onlyOwner() {
907         require(block.timestamp > lockTimeForChangeSNL && lockTimeForChangeSNL != 0, "function is currently locked");
908         numTokensSellToAddToLiquidity = upcomingValueForChangeSNL.mul(10**9);
909         lockTimeForChangeSNL = 0;
910         upcomingValueForChangeSNL = 0;   
911     }
912 
913     function requestChangeToTaxFeePercentage(uint256 newValue) external onlyOwner() {
914         //add 4 hours to current timestamp
915         require(newValue < 11, "should be 10 percent or less");
916         lockTimeForTaxFee = block.timestamp.add(numberOfSecondsForLock);
917         //set value 
918         upcomingValueForTaxFee = newValue;
919         emit RequestToChangeTax(lockTimeForTaxFee, upcomingValueForTaxFee);
920     }
921     
922     function setTaxFeePercent() external onlyOwner() {
923         require(block.timestamp > lockTimeForTaxFee && lockTimeForTaxFee != 0, "function is currently locked");
924         _taxFee = upcomingValueForTaxFee;
925         lockTimeForTaxFee = 0;
926         upcomingValueForTaxFee = 0;
927     }
928 
929     function requestChangeToLiquidityFeePercentage(uint256 newValue) external onlyOwner() {
930         //add 4 hours to current timestamp
931         require(newValue < 11, "should be 10 percent or less");
932         lockTimeForLiquidityFee = block.timestamp.add(numberOfSecondsForLock);
933         //set value 
934         upcomingValueForLiquidityFee = newValue;
935         emit RequestToChangeLiquidity(lockTimeForLiquidityFee, upcomingValueForLiquidityFee);
936     }
937     
938     function setLiquidityFeePercent() external onlyOwner() {
939         require(block.timestamp > lockTimeForLiquidityFee && lockTimeForLiquidityFee != 0, "function is currently locked");
940         _liquidityFee = upcomingValueForLiquidityFee;
941         lockTimeForLiquidityFee = 0;
942         upcomingValueForLiquidityFee = 0;
943     }
944    
945     function requestChangeToMaxTxAmount(uint256 newValue) external onlyOwner() {
946         //add 4 hours to current timestamp
947         lockTimeForMaxTx = block.timestamp.add(numberOfSecondsForLock);
948         //set value 
949         upcomingValueForMaxTx = newValue;
950         emit RequestToChangeMaxTx(lockTimeForMaxTx, upcomingValueForMaxTx);
951     }
952 
953     function setMaxTxAmount() external onlyOwner() {
954         require(block.timestamp > lockTimeForMaxTx && lockTimeForMaxTx != 0, "function is currently locked");
955         _maxTxAmount = upcomingValueForMaxTx.mul(10**9);
956         lockTimeForMaxTx = 0;
957         upcomingValueForMaxTx = 0;
958     }
959 
960     function requestToChangeSwapAndLiquifyEnabled() external onlyOwner() {
961         lockTimeForChangeSwapAndLiquifyEnabled = block.timestamp.add(numberOfSecondsForLock);
962         emit RequestToChangeSwapAndLiquifyEnabled();
963     }
964 
965     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
966         require(block.timestamp > lockTimeForChangeSwapAndLiquifyEnabled && lockTimeForChangeSwapAndLiquifyEnabled != 0, "function is currently locked");
967         swapAndLiquifyEnabled = _enabled;
968         lockTimeForChangeSwapAndLiquifyEnabled = 0;
969         emit SwapAndLiquifyEnabledUpdated(_enabled);
970     }
971     
972      //to recieve ETH from uniswapV2Router when swaping
973     receive() external payable {}
974 
975     function _reflectFee(uint256 rFee, uint256 tFee) private {
976         _rTotal = _rTotal.sub(rFee);
977         _tFeeTotal = _tFeeTotal.add(tFee);
978     }
979 
980     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
981         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
982         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
983         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
984     }
985 
986     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
987         uint256 tFee = calculateTaxFee(tAmount);
988         uint256 tLiquidity = calculateLiquidityFee(tAmount);
989         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
990         return (tTransferAmount, tFee, tLiquidity);
991     }
992 
993     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
994         uint256 rAmount = tAmount.mul(currentRate);
995         uint256 rFee = tFee.mul(currentRate);
996         uint256 rLiquidity = tLiquidity.mul(currentRate);
997         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
998         return (rAmount, rTransferAmount, rFee);
999     }
1000 
1001     function _getRate() private view returns(uint256) {
1002         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1003         return rSupply.div(tSupply);
1004     }
1005 
1006     function _getCurrentSupply() private view returns(uint256, uint256) {
1007         uint256 rSupply = _rTotal;
1008         uint256 tSupply = _tTotal;      
1009         for (uint256 i = 0; i < _excluded.length; i++) {
1010             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1011             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1012             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1013         }
1014         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1015         return (rSupply, tSupply);
1016     }
1017     
1018     function _takeLiquidity(uint256 tLiquidity) private {
1019         uint256 currentRate =  _getRate();
1020         uint256 rLiquidity = tLiquidity.mul(currentRate);
1021         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1022         if(_isExcluded[address(this)])
1023             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1024     }
1025     
1026     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1027         return _amount.mul(_taxFee).div(
1028             10**2
1029         );
1030     }
1031 
1032     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1033         return _amount.mul(_liquidityFee).div(
1034             10**2
1035         );
1036     }
1037     
1038     function removeAllFee() private {
1039         if(_taxFee == 0 && _liquidityFee == 0) return;
1040         
1041         _previousTaxFee = _taxFee;
1042         _previousLiquidityFee = _liquidityFee;
1043         
1044         _taxFee = 0;
1045         _liquidityFee = 0;
1046     }
1047     
1048     function restoreAllFee() private {
1049         _taxFee = _previousTaxFee;
1050         _liquidityFee = _previousLiquidityFee;
1051     }
1052     
1053     function isExcludedFromFee(address account) public view returns(bool) {
1054         return _isExcludedFromFee[account];
1055     }
1056     
1057     function sendBNBToMarketing(uint256 amount) private { 
1058         swapTokensForEth(amount); 
1059         _MarketingWalletAddress.transfer(address(this).balance); 
1060     }
1061     
1062     function _setMarketingWallet(address payable MarketingWalletAddress) external onlyOwner() {
1063         _MarketingWalletAddress = MarketingWalletAddress;
1064     }
1065 
1066     function _approve(address owner, address spender, uint256 amount) private {
1067         require(owner != address(0), "ERC20: approve from the zero address");
1068         require(spender != address(0), "ERC20: approve to the zero address");
1069 
1070         _allowances[owner][spender] = amount;
1071         emit Approval(owner, spender, amount);
1072     }
1073 
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 amount
1078     ) private {
1079         require(from != address(0), "ERC20: transfer from the zero address");
1080         require(to != address(0), "ERC20: transfer to the zero address");
1081         require(amount > 0, "Transfer amount must be greater than zero");
1082         if(from != owner() && to != owner())
1083             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1084 
1085         // is the token balance of this contract address over the min number of
1086         // tokens that we need to initiate a swap + liquidity lock?
1087         // also, don't get caught in a circular liquidity event.
1088         // also, don't swap & liquify if sender is uniswap pair.
1089         uint256 contractTokenBalance = balanceOf(address(this));
1090         
1091         if(contractTokenBalance >= _maxTxAmount)
1092         {
1093             contractTokenBalance = _maxTxAmount;
1094         }
1095         
1096         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1097         if (
1098             overMinTokenBalance &&
1099             !inSwapAndLiquify &&
1100             from != uniswapV2Pair &&
1101             swapAndLiquifyEnabled
1102         ) {
1103             contractTokenBalance = numTokensSellToAddToLiquidity;
1104             //add liquidity
1105             swapAndLiquify(contractTokenBalance);
1106         }
1107         
1108         //indicates if fee should be deducted from transfer
1109         bool takeFee = true;
1110         
1111         //if any account belongs to _isExcludedFromFee account then remove the fee
1112         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1113             takeFee = false;
1114         }
1115         
1116         //transfer amount, it will take tax, burn, liquidity fee
1117         _tokenTransfer(from,to,amount,takeFee);
1118     }
1119 
1120     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1121         // split the contract balance into thirds
1122         uint256 halfOfLiquify = contractTokenBalance.div(4);
1123         uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
1124         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);
1125 
1126         // capture the contract's current ETH balance.
1127         // this is so that we can capture exactly the amount of ETH that the
1128         // swap creates, and not make the liquidity event include any ETH that
1129         // has been manually sent to the contract
1130         uint256 initialBalance = address(this).balance;
1131 
1132         // swap tokens for ETH
1133         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1134 
1135         // how much ETH did we just swap into?
1136         uint256 newBalance = address(this).balance.sub(initialBalance);
1137 
1138         // add liquidity to uniswap
1139         addLiquidity(otherHalfOfLiquify, newBalance);
1140         sendBNBToMarketing(portionForFees);
1141         
1142         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
1143     }
1144 
1145     function swapTokensForEth(uint256 tokenAmount) private {
1146         // generate the uniswap pair path of token -> weth
1147         address[] memory path = new address[](2);
1148         path[0] = address(this);
1149         path[1] = uniswapV2Router.WETH();
1150 
1151         _approve(address(this), address(uniswapV2Router), tokenAmount);
1152 
1153         // make the swap
1154         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1155             tokenAmount,
1156             0, // accept any amount of ETH
1157             path,
1158             address(this),
1159             block.timestamp
1160         );
1161     }
1162 
1163     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1164         // approve token transfer to cover all possible scenarios
1165         _approve(address(this), address(uniswapV2Router), tokenAmount);
1166 
1167         // add the liquidity
1168         // if this transactions fails it will try on next transactions
1169         (uint amountToken, uint amountETH, uint liquidity) = uniswapV2Router.addLiquidityETH{value: ethAmount}(
1170             address(this),
1171             tokenAmount,
1172             0, // slippage is unavoidable
1173             0, // slippage is unavoidable
1174             owner(),
1175             block.timestamp
1176         );
1177     }
1178 
1179     //this method is responsible for taking all fee, if takeFee is true
1180     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1181         if(!takeFee)
1182             removeAllFee();
1183         
1184         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1185             _transferFromExcluded(sender, recipient, amount);
1186         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1187             _transferToExcluded(sender, recipient, amount);
1188         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1189             _transferBothExcluded(sender, recipient, amount);
1190         } else {
1191             _transferStandard(sender, recipient, amount);
1192         }
1193         
1194         if(!takeFee)
1195             restoreAllFee();
1196     }
1197 
1198     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1199         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1200         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1201         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1202         _takeLiquidity(tLiquidity);
1203         _reflectFee(rFee, tFee);
1204         emit Transfer(sender, recipient, tTransferAmount);
1205     }
1206 
1207     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1208         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1209         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1210         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1211         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1212         _takeLiquidity(tLiquidity);
1213         _reflectFee(rFee, tFee);
1214         emit Transfer(sender, recipient, tTransferAmount);
1215     }
1216 
1217     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1218         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1219         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1220         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1221         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1222         _takeLiquidity(tLiquidity);
1223         _reflectFee(rFee, tFee);
1224         emit Transfer(sender, recipient, tTransferAmount);
1225     }
1226 }