1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.4;
4 
5 /*
6 Tax:
7 7% Distribution to Liquidity
8 3% Distribution to holders in MSA
9 3% Distribution to Marketing Wallet
10 2% Distribution to Buyback
11 */
12 
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
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address payable) {
244         return payable(msg.sender);
245     }
246 
247     function _msgData() internal view virtual returns (bytes memory) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
277         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
278         // for accounts without code, i.e. `keccak256('')`
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { codehash := extcodehash(account) }
283         return (codehash != accountHash && codehash != 0x0);
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return _functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         return _functionCallWithValue(target, data, value, errorMessage);
366     }
367 
368     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
369         require(isContract(target), "Address: call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 /**
393  * @dev Contract module which provides a basic access control mechanism, where
394  * there is an account (an owner) that can be granted exclusive access to
395  * specific functions.
396  *
397  * By default, the owner account will be the one that deploys the contract. This
398  * can later be changed with {transferOwnership}.
399  *
400  * This module is used through inheritance. It will make available the modifier
401  * `onlyOwner`, which can be applied to your functions to restrict their use to
402  * the owner.
403  */
404 contract Ownable is Context {
405     address private _owner;
406     address private _previousOwner;
407     uint256 private _lockTime;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor() {
415         address msgSender = _msgSender();
416         _owner = msgSender;
417         emit OwnershipTransferred(address(0), msgSender);
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(_owner == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435      /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         emit OwnershipTransferred(_owner, address(0));
444         _owner = address(0);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         emit OwnershipTransferred(_owner, newOwner);
454         _owner = newOwner;
455     }
456 
457     function geUnlockTime() public view returns (uint256) {
458         return _lockTime;
459     }
460 
461     //Locks the contract for owner for the amount of time provided
462     function lock(uint256 time) public virtual onlyOwner {
463         _previousOwner = _owner;
464         _owner = address(0);
465         _lockTime = block.timestamp + time;
466         emit OwnershipTransferred(_owner, address(0));
467     }
468     
469     //Unlocks the contract for owner when _lockTime is exceeds
470     function unlock() public virtual {
471         require(_previousOwner == msg.sender, "You don't have permission to unlock");
472         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
473         emit OwnershipTransferred(_owner, _previousOwner);
474         _owner = _previousOwner;
475     }
476 }
477 
478 // pragma solidity >=0.5.0;
479 
480 interface IUniswapV2Factory {
481     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
482 
483     function feeTo() external view returns (address);
484     function feeToSetter() external view returns (address);
485 
486     function getPair(address tokenA, address tokenB) external view returns (address pair);
487     function allPairs(uint) external view returns (address pair);
488     function allPairsLength() external view returns (uint);
489 
490     function createPair(address tokenA, address tokenB) external returns (address pair);
491 
492     function setFeeTo(address) external;
493     function setFeeToSetter(address) external;
494 }
495 
496 
497 // pragma solidity >=0.5.0;
498 
499 interface IUniswapV2Pair {
500     event Approval(address indexed owner, address indexed spender, uint value);
501     event Transfer(address indexed from, address indexed to, uint value);
502 
503     function name() external pure returns (string memory);
504     function symbol() external pure returns (string memory);
505     function decimals() external pure returns (uint8);
506     function totalSupply() external view returns (uint);
507     function balanceOf(address owner) external view returns (uint);
508     function allowance(address owner, address spender) external view returns (uint);
509 
510     function approve(address spender, uint value) external returns (bool);
511     function transfer(address to, uint value) external returns (bool);
512     function transferFrom(address from, address to, uint value) external returns (bool);
513 
514     function DOMAIN_SEPARATOR() external view returns (bytes32);
515     function PERMIT_TYPEHASH() external pure returns (bytes32);
516     function nonces(address owner) external view returns (uint);
517 
518     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
519 
520     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
521     event Swap(
522         address indexed sender,
523         uint amount0In,
524         uint amount1In,
525         uint amount0Out,
526         uint amount1Out,
527         address indexed to
528     );
529     event Sync(uint112 reserve0, uint112 reserve1);
530 
531     function MINIMUM_LIQUIDITY() external pure returns (uint);
532     function factory() external view returns (address);
533     function token0() external view returns (address);
534     function token1() external view returns (address);
535     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
536     function price0CumulativeLast() external view returns (uint);
537     function price1CumulativeLast() external view returns (uint);
538     function kLast() external view returns (uint);
539 
540     function burn(address to) external returns (uint amount0, uint amount1);
541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542     function skim(address to) external;
543     function sync() external;
544 
545     function initialize(address, address) external;
546 }
547 
548 // pragma solidity >=0.6.2;
549 
550 interface IUniswapV2Router01 {
551     function factory() external pure returns (address);
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint amountADesired,
558         uint amountBDesired,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB, uint liquidity);
564     function addLiquidityETH(
565         address token,
566         uint amountTokenDesired,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572     function removeLiquidity(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountA, uint amountB);
581     function removeLiquidityETH(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountToken, uint amountETH);
589     function removeLiquidityWithPermit(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETHWithPermit(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountToken, uint amountETH);
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapTokensForExactTokens(
616         uint amountOut,
617         uint amountInMax,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636 
637     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642 }
643 
644 
645 
646 // pragma solidity >=0.6.2;
647 
648 interface IUniswapV2Router02 is IUniswapV2Router01 {
649     function removeLiquidityETHSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountETH);
657     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline,
664         bool approveMax, uint8 v, bytes32 r, bytes32 s
665     ) external returns (uint amountETH);
666 
667     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
668         uint amountIn,
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external;
674     function swapExactETHForTokensSupportingFeeOnTransferTokens(
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external payable;
680     function swapExactTokensForETHSupportingFeeOnTransferTokens(
681         uint amountIn,
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external;
687 }
688 
689 
690 contract MyShibaAcademia is Context, IERC20, Ownable {
691     using SafeMath for uint256;
692     using Address for address;
693 
694     mapping (address => uint256) private _rOwned;
695     mapping (address => uint256) private _tOwned;
696     mapping (address => mapping (address => uint256)) private _allowances;
697 
698     mapping (address => bool) private _isExcludedFromFee;
699 
700     mapping (address => bool) private _isExcluded;
701     address[] private _excluded;
702    
703     uint256 private constant MAX = ~uint256(0);
704     uint256 private _tTotal = 5000000000 * 10**9;
705     uint256 private _rTotal = (MAX - (MAX % _tTotal));
706     uint256 private _tFeeTotal;
707 
708     string private _name = "My Shiba Academia";
709     string private _symbol = "MSA";
710     uint8 private _decimals = 9;
711     
712     uint256 public _taxFee = 3;
713     uint256 private _previousTaxFee = _taxFee;
714     
715     uint256 public _liquidityFee = 9;
716     uint256 private _previousLiquidityFee = _liquidityFee;
717     
718     uint256 public LiquidityPercent = 7;
719     uint256 public BuyBackPercent = 2;
720     
721 
722     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
723     
724     uint256 private buyBackUpperLimit = 1 * 10**17;
725     uint256 private _buyBackDivisor = 100;
726     bool public buyBackEnabled = true;
727     
728     event BuyBackEnabledUpdated(bool enabled);
729 
730     uint256 public _marketingFee = 3;
731     address payable public marketingWallet = payable(0x2f52b09bD82c0DDB28D7A1c3AEA12B7FAfefA761);
732     uint256 private _previousmarketingFee = _marketingFee;
733 
734     IUniswapV2Router02 public  uniswapV2Router;
735     address public  uniswapV2Pair;
736     
737     bool inSwapAndLiquify;
738     bool public swapAndLiquifyEnabled = false;
739 
740     uint256 public minimumTokensBeforeSwap = 1000000 * 10**9;
741     uint256 public _maxTxAmount = 5000000000 * 10**9;
742     
743     mapping(address => bool) private _isExcludedFromMaxTx;
744     
745     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
746     event SwapAndLiquifyEnabledUpdated(bool enabled);
747     event SwapAndLiquify(
748         uint256 tokensSwapped,
749         uint256 ethReceived,
750         uint256 tokensIntoLiqudity
751     );
752     
753     event SwapETHForTokens(
754         uint256 amountIn,
755         address[] path
756     );
757     
758     modifier lockTheSwap {
759         inSwapAndLiquify = true;
760         _;
761         inSwapAndLiquify = false;
762     }
763     
764     constructor() {
765         _rOwned[_msgSender()] = _rTotal;
766         
767         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
768          // Create a uniswap pair for this new token
769         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
770             .createPair(address(this), _uniswapV2Router.WETH());
771 
772         // set the rest of the contract variables
773         uniswapV2Router = _uniswapV2Router;
774         
775         //exclude owner and this contract from fee
776         _isExcludedFromFee[owner()] = true;
777         _isExcludedFromFee[address(this)] = true;
778         _isExcludedFromFee[marketingWallet] = true;
779         
780         _isExcludedFromMaxTx[owner()] = true;
781         _isExcludedFromMaxTx[address(this)] = true;
782         _isExcludedFromMaxTx[marketingWallet] = true;
783         
784         emit Transfer(address(0), _msgSender(), _tTotal);
785     }
786 
787     function name() public view returns (string memory) {
788         return _name;
789     }
790 
791     function symbol() public view returns (string memory) {
792         return _symbol;
793     }
794 
795     function decimals() public view returns (uint8) {
796         return _decimals;
797     }
798 
799     function totalSupply() public view override returns (uint256) {
800         return _tTotal;
801     }
802 
803     function balanceOf(address account) public view override returns (uint256) {
804         if (_isExcluded[account]) return _tOwned[account];
805         return tokenFromReflection(_rOwned[account]);
806     }
807 
808     function transfer(address recipient, uint256 amount) public override returns (bool) {
809         _transfer(_msgSender(), recipient, amount);
810         return true;
811     }
812 
813     function allowance(address owner, address spender) public view override returns (uint256) {
814         return _allowances[owner][spender];
815     }
816 
817     function approve(address spender, uint256 amount) public override returns (bool) {
818         _approve(_msgSender(), spender, amount);
819         return true;
820     }
821 
822     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
823         _transfer(sender, recipient, amount);
824         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
825         return true;
826     }
827 
828     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
829         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
830         return true;
831     }
832 
833     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
834         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
835         return true;
836     }
837 
838     function isExcludedFromReward(address account) public view returns (bool) {
839         return _isExcluded[account];
840     }
841 
842     function totalFees() public view returns (uint256) {
843         return _tFeeTotal;
844     }
845 
846     function deliver(uint256 tAmount) public {
847         address sender = _msgSender();
848         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
849         (uint256 rAmount,,,,,) = _getValues(tAmount);
850         _rOwned[sender] = _rOwned[sender].sub(rAmount);
851         _rTotal = _rTotal.sub(rAmount);
852         _tFeeTotal = _tFeeTotal.add(tAmount);
853     }
854 
855     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
856         require(tAmount <= _tTotal, "Amount must be less than supply");
857         if (!deductTransferFee) {
858             (uint256 rAmount,,,,,) = _getValues(tAmount);
859             return rAmount;
860         } else {
861             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
862             return rTransferAmount;
863         }
864     }
865 
866     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
867         require(rAmount <= _rTotal, "Amount must be less than total reflections");
868         uint256 currentRate =  _getRate();
869         return rAmount.div(currentRate);
870     }
871 
872     function excludeFromReward(address account) public onlyOwner() {
873         require(!_isExcluded[account], "Account is already excluded");
874         if(_rOwned[account] > 0) {
875             _tOwned[account] = tokenFromReflection(_rOwned[account]);
876         }
877         _isExcluded[account] = true;
878         _excluded.push(account);
879     }
880 
881     function includeInReward(address account) external onlyOwner() {
882         require(_isExcluded[account], "Account is already excluded");
883         for (uint256 i = 0; i < _excluded.length; i++) {
884             if (_excluded[i] == account) {
885                 _excluded[i] = _excluded[_excluded.length - 1];
886                 _tOwned[account] = 0;
887                 _isExcluded[account] = false;
888                 _excluded.pop();
889                 break;
890             }
891         }
892     }
893 
894     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
895         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
896         _tOwned[sender] = _tOwned[sender].sub(tAmount);
897         _rOwned[sender] = _rOwned[sender].sub(rAmount);
898         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
899         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
900         _takeLiquidity(tLiquidity);
901         _reflectFee(rFee, tFee);
902         emit Transfer(sender, recipient, tTransferAmount);
903     }
904     
905 
906     
907      //to recieve ETH from uniswapV2Router when swaping
908     receive() external payable {}
909 
910     function _reflectFee(uint256 rFee, uint256 tFee) private {
911         _rTotal = _rTotal.sub(rFee);
912         _tFeeTotal = _tFeeTotal.add(tFee);
913     }
914 
915     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
916         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
917         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
918         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
919     }
920 
921     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
922         uint256 tFee = calculateTaxFee(tAmount);
923         uint256 tLiquidity = calculateLiquidityFee(tAmount);
924         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
925         return (tTransferAmount, tFee, tLiquidity);
926     }
927 
928     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
929         uint256 rAmount = tAmount.mul(currentRate);
930         uint256 rFee = tFee.mul(currentRate);
931         uint256 rLiquidity = tLiquidity.mul(currentRate);
932         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
933         return (rAmount, rTransferAmount, rFee);
934     }
935 
936     function _getRate() private view returns(uint256) {
937         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
938         return rSupply.div(tSupply);
939     }
940 
941     function _getCurrentSupply() private view returns(uint256, uint256) {
942         uint256 rSupply = _rTotal;
943         uint256 tSupply = _tTotal;      
944         for (uint256 i = 0; i < _excluded.length; i++) {
945             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
946             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
947             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
948         }
949         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
950         return (rSupply, tSupply);
951     }
952     
953     function _takeLiquidity(uint256 tLiquidity) private {
954         uint256 currentRate =  _getRate();
955         uint256 rLiquidity = tLiquidity.mul(currentRate);
956         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
957         if(_isExcluded[address(this)])
958             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
959     }
960     
961     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
962         return _amount.mul(_taxFee).div(
963             10**2
964         );
965     }
966 
967     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
968         return _amount.mul(_liquidityFee).div(
969             10**2
970         );
971     }
972     
973     function removeAllFee() private {
974         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee==0) return;
975         
976         _previousTaxFee = _taxFee;
977         _previousLiquidityFee = _liquidityFee;
978         _previousmarketingFee = _marketingFee;
979         
980         _taxFee = 0;
981         _liquidityFee = 0;
982         _marketingFee = 0;
983     }
984     
985     function restoreAllFee() private {
986        _taxFee = _previousTaxFee;
987        _liquidityFee = _previousLiquidityFee;
988        _marketingFee = _previousmarketingFee;
989     }
990     
991     function isExcludedFromFee(address account) public view returns(bool) {
992         return _isExcludedFromFee[account];
993     }
994     
995     function setExcludeFromMaxTx(address _address, bool value) public onlyOwner { 
996         _isExcludedFromMaxTx[_address] = value;
997     }
998 
999     function _approve(address owner, address spender, uint256 amount) private {
1000         require(owner != address(0), "ERC20: approve from the zero address");
1001         require(spender != address(0), "ERC20: approve to the zero address");
1002 
1003         _allowances[owner][spender] = amount;
1004         emit Approval(owner, spender, amount);
1005     }
1006 
1007     function _transfer(
1008         address from,
1009         address to,
1010         uint256 amount
1011     ) private {
1012         require(from != address(0), "ERC20: transfer from the zero address");
1013         require(amount > 0, "Transfer amount must be greater than zero");
1014 
1015         // is the token balance of this contract address over the min number of
1016         // tokens that we need to initiate a swap + liquidity lock?
1017         // also, don't get caught in a circular liquidity event.
1018         // also, don't swap & liquify if sender is uniswap pair.
1019         uint256 contractTokenBalance = balanceOf(address(this));        
1020         bool overMinTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1021         if (!inSwapAndLiquify && from != uniswapV2Pair && swapAndLiquifyEnabled) {
1022             if(overMinTokenBalance) {
1023                 // swap  and liquify
1024                 swapAndLiquify(contractTokenBalance);
1025             }
1026             
1027             uint256 balance = address(this).balance;
1028             if (buyBackEnabled && balance > uint256(buyBackUpperLimit)) {
1029                 
1030                 if (balance > buyBackUpperLimit)
1031                     balance = buyBackUpperLimit;
1032                 
1033                 buyBackTokens(balance.div(_buyBackDivisor));
1034             }
1035             
1036         }
1037 
1038         _tokenTransfer(from,to,amount);
1039     }
1040 
1041     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1042         uint256 totalTax = _liquidityFee.add(_marketingFee);
1043         uint256 LiquidityShare = contractTokenBalance.mul(_liquidityFee.sub(BuyBackPercent)).div(totalTax);
1044         uint256 MarketingShare = contractTokenBalance.mul(_marketingFee).div(totalTax);
1045         uint256 buybackShare = contractTokenBalance.mul(BuyBackPercent).div(totalTax);
1046         
1047         uint256 balanceBeforeMarketingSwap = address(this).balance;
1048         //Swapping Tokens for Marketing Funds
1049         swapTokensForEth(MarketingShare);
1050         uint256 MarketingEthShare = address(this).balance.sub(balanceBeforeMarketingSwap);
1051         //Send to Marketing address
1052         transferToAddressEth(marketingWallet, MarketingEthShare);
1053         //swap tokens for buyback
1054         swapTokensForEth(buybackShare);
1055         
1056         // split the Liquidity balance into halves
1057         uint256 half = LiquidityShare.div(2);
1058         uint256 otherHalf = LiquidityShare.sub(half);
1059 
1060         // capture the contract's current ETH balance.
1061         // this is so that we can capture exactly the amount of ETH that the
1062         // swap creates, and not make the liquidity event include any ETH that
1063         // has been manually sent to the contract
1064         uint256 initialBalance = address(this).balance;
1065 
1066         // swap tokens for ETH
1067         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1068 
1069         // how much ETH did we just swap into?
1070         uint256 newBalance = address(this).balance.sub(initialBalance);
1071 
1072         // add liquidity to uniswap
1073         addLiquidity(otherHalf, newBalance);
1074         
1075         emit SwapAndLiquify(half, newBalance, otherHalf);
1076     }
1077 
1078     function swapTokensForEth(uint256 tokenAmount) private {
1079         // generate the uniswap pair path of token -> weth
1080         address[] memory path = new address[](2);
1081         path[0] = address(this);
1082         path[1] = uniswapV2Router.WETH();
1083 
1084         _approve(address(this), address(uniswapV2Router), tokenAmount);
1085 
1086         // make the swap
1087         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1088             tokenAmount,
1089             0, // accept any amount of ETH
1090             path,
1091             address(this),
1092             block.timestamp
1093         );
1094     }
1095     
1096     function swapETHForTokens(uint256 amount) private {
1097         // generate the uniswap pair path of token -> weth
1098         address[] memory path = new address[](2);
1099         path[0] = uniswapV2Router.WETH();
1100         path[1] = address(this);
1101 
1102       // make the swap
1103         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1104             0, // accept any amount of Tokens
1105             path,
1106             deadAddress, // Burn address
1107             block.timestamp.add(300)
1108         );
1109         
1110         emit SwapETHForTokens(amount, path);
1111     }
1112     
1113     function buyBackTokens(uint256 amount) private lockTheSwap {
1114     	if (amount > 0) {
1115     	    swapETHForTokens(amount);
1116 	    }
1117     }
1118 
1119     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1120         // approve token transfer to cover all possible scenarios
1121         _approve(address(this), address(uniswapV2Router), tokenAmount);
1122 
1123         // add the liquidity
1124         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1125             address(this),
1126             tokenAmount,
1127             0, // slippage is unavoidable
1128             0, // slippage is unavoidable
1129             owner(),
1130             block.timestamp
1131         );
1132     }
1133 
1134     //this method is responsible for taking all fee, if takeFee is true
1135     function _tokenTransfer(address sender, address recipient, uint256 amount) private 
1136     {
1137         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1138         {   
1139            removeAllFee(); 
1140         }
1141         else  
1142         {
1143             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1144         }
1145 
1146         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1147             _transferFromExcluded(sender, recipient, amount);
1148         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1149             _transferToExcluded(sender, recipient, amount);
1150         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1151             _transferStandard(sender, recipient, amount);
1152         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1153             _transferBothExcluded(sender, recipient, amount);
1154         } else {
1155             _transferStandard(sender, recipient, amount);
1156         }
1157         
1158         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1159         {
1160             restoreAllFee();
1161         }
1162     }
1163 
1164 
1165 
1166     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
1167     {
1168         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1169         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
1170         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1171         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1172         _takeLiquidity(tLiquidity);
1173         _reflectFee(rFee, tFee);
1174         emit Transfer(sender, recipient, tTransferAmount);
1175     }
1176 
1177     function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1178     returns (uint256, uint256)
1179     {
1180         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
1181         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
1182         uint256 rMarketing = tMarketing.mul(_getRate());
1183         rTransferAmount = rTransferAmount.sub(rMarketing);
1184         tTransferAmount = tTransferAmount.sub(tMarketing);
1185         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1186         emit Transfer(sender, address(this), tMarketing);
1187         return(tTransferAmount, rTransferAmount); 
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
1210     function prepareForPresale() external onlyOwner() {
1211        _taxFee = 0;
1212        _previousTaxFee = 0;
1213        _liquidityFee = 0;
1214        _previousLiquidityFee = 0;
1215        _marketingFee = 0;
1216        _previousmarketingFee = 0;
1217        _maxTxAmount = 5000000000 * 10**9;
1218        setSwapAndLiquifyEnabled(false);
1219     }
1220     
1221     function afterPresale() external onlyOwner() {
1222        _taxFee = 3;
1223        _previousTaxFee = _taxFee;
1224        _liquidityFee = 9;
1225        _previousLiquidityFee = _liquidityFee;
1226        _marketingFee = 3;
1227        _previousmarketingFee = _marketingFee;
1228        setSwapAndLiquifyEnabled(true);
1229     }
1230 
1231     function excludeFromFee(address account) public onlyOwner {
1232         _isExcludedFromFee[account] = true;
1233     }
1234     
1235     function includeInFee(address account) public onlyOwner {
1236         _isExcludedFromFee[account] = false;
1237     }
1238     
1239     function setMarketingWallet(address payable newWallet) external onlyOwner() {
1240         marketingWallet = newWallet;
1241     }
1242     
1243     function setLiquidityAndBuyBackPercent(uint256 liquidityPercent, uint256 buybackPercent) public onlyOwner {
1244         require(buybackPercent <= 5, "Buyback max 5%" );
1245         LiquidityPercent = liquidityPercent;
1246         BuyBackPercent = buybackPercent;
1247         _liquidityFee = liquidityPercent.add(buybackPercent);
1248     }
1249     
1250     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1251         buyBackEnabled = _enabled;
1252         emit BuyBackEnabledUpdated(_enabled);
1253     }
1254     
1255     function SetBuyBackUpperLimit(uint256 _newLimit) public onlyOwner() {
1256         buyBackUpperLimit = _newLimit;
1257     }
1258     
1259     function buyBackUpperLimitAmount() public view returns (uint256) {
1260         return buyBackUpperLimit;
1261     }
1262     
1263     function buyBackDivisor() public view returns (uint256) {
1264         return _buyBackDivisor;
1265     }
1266     
1267     function SetBuyBackDivisor(uint256 Divisor) public onlyOwner() {
1268         _buyBackDivisor =  Divisor;
1269     }
1270     
1271     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1272         _taxFee = taxFee;
1273     }
1274     
1275     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
1276         _marketingFee = marketingFee;
1277     }
1278     
1279     function setMinimumTokensBeforeSwap(uint256 newAmt) external onlyOwner() {
1280         minimumTokensBeforeSwap = newAmt*10**9;
1281     }
1282     
1283     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1284         require(maxTxAmount > 0, "Cannot set transaction amount as zero");
1285         _maxTxAmount = maxTxAmount * 10**9;
1286     }
1287     
1288     function transferToAddressEth(address payable recipient, uint256 amount) private {
1289         recipient.transfer(amount);
1290     }
1291     
1292     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1293         swapAndLiquifyEnabled = _enabled;
1294         emit SwapAndLiquifyEnabledUpdated(_enabled);
1295     }
1296     
1297 }