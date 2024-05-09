1 // Telegram: https://t.me/MiniCliffordInu
2 // website: https://miniclifford.com/
3 
4 // SPDX-License-Identifier: Unlicensed
5 
6 pragma solidity ^0.8.9;
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
236     //function _msgSender() internal view virtual returns (address payable) {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable is Context {
399     address private _owner;
400     address private _previousOwner;
401     uint256 private _lockTime;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429      /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 
451     function geUnlockTime() public view returns (uint256) {
452         return _lockTime;
453     }
454 
455     //Locks the contract for owner for the amount of time provided
456     function lock(uint256 time) public virtual onlyOwner {
457         _previousOwner = _owner;
458         _owner = address(0);
459         _lockTime = block.timestamp + time;
460         emit OwnershipTransferred(_owner, address(0));
461     }
462     
463     //Unlocks the contract for owner when _lockTime is exceeds
464     function unlock() public virtual {
465         require(_previousOwner == msg.sender, "You don't have permission to unlock");
466         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
467         emit OwnershipTransferred(_owner, _previousOwner);
468         _owner = _previousOwner;
469     }
470 }
471 
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
489 
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
639 
640 interface IUniswapV2Router02 is IUniswapV2Router01 {
641     function removeLiquidityETHSupportingFeeOnTransferTokens(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline
648     ) external returns (uint amountETH);
649     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline,
656         bool approveMax, uint8 v, bytes32 r, bytes32 s
657     ) external returns (uint amountETH);
658 
659     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
660         uint amountIn,
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external;
666     function swapExactETHForTokensSupportingFeeOnTransferTokens(
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external payable;
672     function swapExactTokensForETHSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679 }
680 
681 interface IAirdrop {
682     function airdrop(address recipient, uint256 amount) external;
683 }
684 
685 contract MiniCliffordInu is Context, IERC20, Ownable {
686     using SafeMath for uint256;
687     using Address for address;
688 
689     mapping (address => uint256) private _rOwned;
690     mapping (address => uint256) private _tOwned;
691     mapping (address => mapping (address => uint256)) private _allowances;
692 
693     mapping (address => bool) private _isExcludedFromFee;
694 
695     mapping (address => bool) private _isExcluded;
696     address[] private _excluded;
697     
698     mapping (address => bool) private botWallets;
699     bool botscantrade = false;
700     
701     bool public canTrade = false;
702    
703     uint256 private constant MAX = ~uint256(0);
704     uint256 private _tTotal = 69000000000000000000000 * 10**9;
705     uint256 private _rTotal = (MAX - (MAX % _tTotal));
706     uint256 private _tFeeTotal;
707     address public marketingWallet;
708 
709     string private _name = "MiniCliffordInu";
710     string private _symbol = "MiniCLIFF";
711     uint8 private _decimals = 9;
712     
713     uint256 public _taxFee = 1;
714     uint256 private _previousTaxFee = _taxFee;
715     
716     uint256 public _liquidityFee = 12;
717     uint256 private _previousLiquidityFee = _liquidityFee;
718 
719     IUniswapV2Router02 public immutable uniswapV2Router;
720     address public immutable uniswapV2Pair;
721     
722     bool inSwapAndLiquify;
723     bool public swapAndLiquifyEnabled = true;
724     
725     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
726     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
727     
728     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
729     event SwapAndLiquifyEnabledUpdated(bool enabled);
730     event SwapAndLiquify(
731         uint256 tokensSwapped,
732         uint256 ethReceived,
733         uint256 tokensIntoLiqudity
734     );
735     
736     modifier lockTheSwap {
737         inSwapAndLiquify = true;
738         _;
739         inSwapAndLiquify = false;
740     }
741     
742     constructor () {
743         _rOwned[_msgSender()] = _rTotal;
744         
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
888         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
889         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
890         _tOwned[sender] = _tOwned[sender].sub(tAmount);
891         _rOwned[sender] = _rOwned[sender].sub(rAmount);
892         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
893         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
894         _takeLiquidity(tLiquidity);
895         _reflectFee(rFee, tFee);
896         emit Transfer(sender, recipient, tTransferAmount);
897     }
898     
899     function excludeFromFee(address account) public onlyOwner {
900         _isExcludedFromFee[account] = true;
901     }
902     
903     function includeInFee(address account) public onlyOwner {
904         _isExcludedFromFee[account] = false;
905     }
906 
907     function setMarketingWallet(address walletAddress) public onlyOwner {
908         marketingWallet = walletAddress;
909     }
910 
911     function upliftTxAmount() external onlyOwner() {
912         _maxTxAmount = 69000000000000000000000 * 10**9;
913     }
914     
915     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
916         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
917         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
918     }
919     
920     function claimTokens () public onlyOwner {
921         // make sure we capture all BNB that may or may not be sent to this contract
922         payable(marketingWallet).transfer(address(this).balance);
923     }
924     
925     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
926         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
927     }
928     
929     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
930         walletaddress.transfer(address(this).balance);
931     }
932     
933     function addBotWallet(address botwallet) external onlyOwner() {
934         botWallets[botwallet] = true;
935     }
936     
937     function removeBotWallet(address botwallet) external onlyOwner() {
938         botWallets[botwallet] = false;
939     }
940     
941     function getBotWalletStatus(address botwallet) public view returns (bool) {
942         return botWallets[botwallet];
943     }
944     
945     function allowtrading()external onlyOwner() {
946         canTrade = true;
947     }
948 
949     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
950         swapAndLiquifyEnabled = _enabled;
951         emit SwapAndLiquifyEnabledUpdated(_enabled);
952     }
953     
954      //to recieve ETH from uniswapV2Router when swaping
955     receive() external payable {}
956 
957     function _reflectFee(uint256 rFee, uint256 tFee) private {
958         _rTotal = _rTotal.sub(rFee);
959         _tFeeTotal = _tFeeTotal.add(tFee);
960     }
961 
962     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
963         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
964         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
965         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
966     }
967 
968     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
969         uint256 tFee = calculateTaxFee(tAmount);
970         uint256 tLiquidity = calculateLiquidityFee(tAmount);
971         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
972         return (tTransferAmount, tFee, tLiquidity);
973     }
974 
975     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
976         uint256 rAmount = tAmount.mul(currentRate);
977         uint256 rFee = tFee.mul(currentRate);
978         uint256 rLiquidity = tLiquidity.mul(currentRate);
979         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
980         return (rAmount, rTransferAmount, rFee);
981     }
982 
983     function _getRate() private view returns(uint256) {
984         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
985         return rSupply.div(tSupply);
986     }
987 
988     function _getCurrentSupply() private view returns(uint256, uint256) {
989         uint256 rSupply = _rTotal;
990         uint256 tSupply = _tTotal;      
991         for (uint256 i = 0; i < _excluded.length; i++) {
992             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
993             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
994             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
995         }
996         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
997         return (rSupply, tSupply);
998     }
999     
1000     function _takeLiquidity(uint256 tLiquidity) private {
1001         uint256 currentRate =  _getRate();
1002         uint256 rLiquidity = tLiquidity.mul(currentRate);
1003         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1004         if(_isExcluded[address(this)])
1005             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1006     }
1007     
1008     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1009         return _amount.mul(_taxFee).div(
1010             10**2
1011         );
1012     }
1013 
1014     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1015         return _amount.mul(_liquidityFee).div(
1016             10**2
1017         );
1018     }
1019     
1020     function removeAllFee() private {
1021         if(_taxFee == 0 && _liquidityFee == 0) return;
1022         
1023         _previousTaxFee = _taxFee;
1024         _previousLiquidityFee = _liquidityFee;
1025         
1026         _taxFee = 0;
1027         _liquidityFee = 0;
1028     }
1029     
1030     function restoreAllFee() private {
1031         _taxFee = _previousTaxFee;
1032         _liquidityFee = _previousLiquidityFee;
1033     }
1034     
1035     function isExcludedFromFee(address account) public view returns(bool) {
1036         return _isExcludedFromFee[account];
1037     }
1038 
1039     function _approve(address owner, address spender, uint256 amount) private {
1040         require(owner != address(0), "ERC20: approve from the zero address");
1041         require(spender != address(0), "ERC20: approve to the zero address");
1042 
1043         _allowances[owner][spender] = amount;
1044         emit Approval(owner, spender, amount);
1045     }
1046 
1047     function _transfer(
1048         address from,
1049         address to,
1050         uint256 amount
1051     ) private {
1052         require(from != address(0), "ERC20: transfer from the zero address");
1053         require(to != address(0), "ERC20: transfer to the zero address");
1054         require(amount > 0, "Transfer amount must be greater than zero");
1055         if(from != owner() && to != owner())
1056             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1057 
1058         // is the token balance of this contract address over the min number of
1059         // tokens that we need to initiate a swap + liquidity lock?
1060         // also, don't get caught in a circular liquidity event.
1061         // also, don't swap & liquify if sender is uniswap pair.
1062         uint256 contractTokenBalance = balanceOf(address(this));
1063         
1064         if(contractTokenBalance >= _maxTxAmount)
1065         {
1066             contractTokenBalance = _maxTxAmount;
1067         }
1068         
1069         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1070         if (
1071             overMinTokenBalance &&
1072             !inSwapAndLiquify &&
1073             from != uniswapV2Pair &&
1074             swapAndLiquifyEnabled
1075         ) {
1076             contractTokenBalance = numTokensSellToAddToLiquidity;
1077             //add liquidity
1078             swapAndLiquify(contractTokenBalance);
1079         }
1080         
1081         //indicates if fee should be deducted from transfer
1082         bool takeFee = true;
1083         
1084         //if any account belongs to _isExcludedFromFee account then remove the fee
1085         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1086             takeFee = false;
1087         }
1088         
1089         //transfer amount, it will take tax, burn, liquidity fee
1090         _tokenTransfer(from,to,amount,takeFee);
1091     }
1092 
1093     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1094         // split the contract balance into halves
1095         // add the marketing wallet
1096         uint256 half = contractTokenBalance.div(2);
1097         uint256 otherHalf = contractTokenBalance.sub(half);
1098 
1099         // capture the contract's current ETH balance.
1100         // this is so that we can capture exactly the amount of ETH that the
1101         // swap creates, and not make the liquidity event include any ETH that
1102         // has been manually sent to the contract
1103         uint256 initialBalance = address(this).balance;
1104 
1105         // swap tokens for ETH
1106         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1107 
1108         // how much ETH did we just swap into?
1109         uint256 newBalance = address(this).balance.sub(initialBalance);
1110         uint256 marketingshare = newBalance.mul(80).div(100);
1111         payable(marketingWallet).transfer(marketingshare);
1112         newBalance -= marketingshare;
1113         // add liquidity to uniswap
1114         addLiquidity(otherHalf, newBalance);
1115         
1116         emit SwapAndLiquify(half, newBalance, otherHalf);
1117     }
1118 
1119     function swapTokensForEth(uint256 tokenAmount) private {
1120         // generate the uniswap pair path of token -> weth
1121         address[] memory path = new address[](2);
1122         path[0] = address(this);
1123         path[1] = uniswapV2Router.WETH();
1124 
1125         _approve(address(this), address(uniswapV2Router), tokenAmount);
1126 
1127         // make the swap
1128         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1129             tokenAmount,
1130             0, // accept any amount of ETH
1131             path,
1132             address(this),
1133             block.timestamp
1134         );
1135     }
1136 
1137     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1138         // approve token transfer to cover all possible scenarios
1139         _approve(address(this), address(uniswapV2Router), tokenAmount);
1140 
1141         // add the liquidity
1142         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1143             address(this),
1144             tokenAmount,
1145             0, // slippage is unavoidable
1146             0, // slippage is unavoidable
1147             owner(),
1148             block.timestamp
1149         );
1150     }
1151 
1152     //this method is responsible for taking all fee, if takeFee is true
1153     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1154         if(!canTrade){
1155             require(sender == owner()); // only owner allowed to trade or add liquidity
1156         }
1157         
1158         if(botWallets[sender] || botWallets[recipient]){
1159             require(botscantrade, "bots arent allowed to trade");
1160         }
1161         
1162         if(!takeFee)
1163             removeAllFee();
1164         
1165         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1166             _transferFromExcluded(sender, recipient, amount);
1167         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1168             _transferToExcluded(sender, recipient, amount);
1169         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1170             _transferStandard(sender, recipient, amount);
1171         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1172             _transferBothExcluded(sender, recipient, amount);
1173         } else {
1174             _transferStandard(sender, recipient, amount);
1175         }
1176         
1177         if(!takeFee)
1178             restoreAllFee();
1179     }
1180 
1181     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1182         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1183         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1184         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1185         _takeLiquidity(tLiquidity);
1186         _reflectFee(rFee, tFee);
1187         emit Transfer(sender, recipient, tTransferAmount);
1188     }
1189 
1190     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1191         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1192         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1193         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1194         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1195         _takeLiquidity(tLiquidity);
1196         _reflectFee(rFee, tFee);
1197         emit Transfer(sender, recipient, tTransferAmount);
1198     }
1199 
1200     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1201         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1202         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1203         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1204         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1205         _takeLiquidity(tLiquidity);
1206         _reflectFee(rFee, tFee);
1207         emit Transfer(sender, recipient, tTransferAmount);
1208     }
1209 
1210 }