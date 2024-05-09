1 // SPDX-License-Identifier: Unlicensed
2 
3 
4 pragma solidity 0.8.7;
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 
18 /**
19  * @dev Contract module which provides a basic access control mechanism, where
20  * there is an account (an owner) that can be granted exclusive access to
21  * specific functions.
22  *
23  * By default, the owner account will be the one that deploys the contract. This
24  * can later be changed with {transferOwnership}.
25  *
26  * This module is used through inheritance. It will make available the modifier
27  * `onlyOwner`, which can be applied to your functions to restrict their use to
28  * the owner.
29  */
30 contract Ownable is Context {
31     address private _owner;
32     address private _previousOwner;
33     uint256 private _lockTime;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     /**
38      * @dev Initializes the contract setting the deployer as the initial owner.
39      */
40     constructor () {
41         address msgSender = _msgSender();
42         _owner = msgSender;
43         emit OwnershipTransferred(address(0), msgSender);
44     }
45 
46     /**
47      * @dev Returns the address of the current owner.
48      */
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(_owner == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61      /**
62      * @dev Leaves the contract without owner. It will not be possible to call
63      * `onlyOwner` functions anymore. Can only be called by the current owner.
64      *
65      * NOTE: Renouncing ownership will leave the contract without an owner,
66      * thereby removing any functionality that is only available to the owner.
67      */
68     function renounceOwnership() public virtual onlyOwner {
69         emit OwnershipTransferred(_owner, address(0));
70         _owner = address(0);
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         emit OwnershipTransferred(_owner, newOwner);
80         _owner = newOwner;
81     }
82 
83     function geUnlockTime() public view returns (uint256) {
84         return _lockTime;
85     }
86 
87     //Locks the contract for owner for the amount of time provided
88     function lock(uint256 time) public virtual onlyOwner {
89         _previousOwner = _owner;
90         _owner = address(0);
91         _lockTime = block.timestamp + time;
92         emit OwnershipTransferred(_owner, address(0));
93     }
94     
95     //Unlocks the contract for owner when _lockTime is exceeds
96     function unlock() public virtual {
97         require(_previousOwner == msg.sender, "You don't have permission to unlock");
98         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
99         emit OwnershipTransferred(_owner, _previousOwner);
100         _owner = _previousOwner;
101     }
102 }
103 
104 
105 interface IERC20 {
106 
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Emitted when `value` tokens are moved from one account (`from`) to
161      * another (`to`).
162      *
163      * Note that `value` may be zero.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     /**
168      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
169      * a call to {approve}. `value` is the new allowance.
170      */
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 
175 
176 /**
177  * @dev Wrappers over Solidity's arithmetic operations with added overflow
178  * checks.
179  *
180  * Arithmetic operations in Solidity wrap on overflow. This can easily result
181  * in bugs, because programmers usually assume that an overflow raises an
182  * error, which is the standard behavior in high level programming languages.
183  * `SafeMath` restores this intuition by reverting the transaction when an
184  * operation overflows.
185  *
186  * Using this library instead of the unchecked operations eliminates an entire
187  * class of bugs, so it's recommended to use it always.
188  */
189  
190 library SafeMath {
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      *
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219         return sub(a, b, "SafeMath: subtraction overflow");
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      *
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
251         // benefit is lost if 'b' is also tested.
252         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
253         if (a == 0) {
254             return 0;
255         }
256 
257         uint256 c = a * b;
258         require(c / a == b, "SafeMath: multiplication overflow");
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         uint256 c = a / b;
294         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * Reverts when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts with custom message when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b != 0, errorMessage);
329         return a % b;
330     }
331 }
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
356         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
357         // for accounts without code, i.e. `keccak256('')`
358         bytes32 codehash;
359         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
360         // solhint-disable-next-line no-inline-assembly
361         assembly { codehash := extcodehash(account) }
362         return (codehash != accountHash && codehash != 0x0);
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
385         (bool success, ) = recipient.call{ value: amount }("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain`call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408       return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
418         return _functionCallWithValue(target, data, 0, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but also transferring `value` wei to `target`.
424      *
425      * Requirements:
426      *
427      * - the calling contract must have an ETH balance of at least `value`.
428      * - the called Solidity function must be `payable`.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         return _functionCallWithValue(target, data, value, errorMessage);
445     }
446 
447     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
448         require(isContract(target), "Address: call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
452         if (success) {
453             return returndata;
454         } else {
455             // Look for revert reason and bubble it up if present
456             if (returndata.length > 0) {
457                 // The easiest way to bubble the revert reason is using memory via assembly
458 
459                 // solhint-disable-next-line no-inline-assembly
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // pragma solidity >=0.5.0;
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
490 // pragma solidity >=0.5.0;
491 
492 interface IUniswapV2Pair {
493     event Approval(address indexed owner, address indexed spender, uint value);
494     event Transfer(address indexed from, address indexed to, uint value);
495 
496     function name() external pure returns (string memory);
497     function symbol() external pure returns (string memory);
498     function decimals() external pure returns (uint8);
499     function totalSupply() external view returns (uint);
500     function balanceOf(address owner) external view returns (uint);
501     function allowance(address owner, address spender) external view returns (uint);
502 
503     function approve(address spender, uint value) external returns (bool);
504     function transfer(address to, uint value) external returns (bool);
505     function transferFrom(address from, address to, uint value) external returns (bool);
506 
507     function DOMAIN_SEPARATOR() external view returns (bytes32);
508     function PERMIT_TYPEHASH() external pure returns (bytes32);
509     function nonces(address owner) external view returns (uint);
510 
511     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
512 
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
683 contract Moon2022 is Context, IERC20, Ownable {
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
697     uint256 private _tTotal = 500000000000000 * (10**18);
698     uint256 private _rTotal = (MAX - (MAX % _tTotal));
699     uint256 private _tFeeTotal;
700     mapping(address => bool) private _isExcludedFromAntiWhale;
701     string private _name = "2022MOON";
702     string private _symbol = "2022M";
703     uint8 private _decimals = 18;
704 
705     uint256 public _taxFee = 2;
706     uint256 private _previousTaxFee = _taxFee;
707     
708     uint256 public _liquidityFee = 2;
709     uint256 private _previousLiquidityFee = _liquidityFee;
710 
711 
712 
713     address public deadAddress = 0x000000000000000000000000000000000000dEaD;
714     bool public enableAntiwhale = true;
715 
716     address public marketingWallet = 0x55be7BEc1adF72a8c3beFD9271fA9a30c583Cbae;
717 
718     uint256 public _marketingFee = 6;
719 
720     uint256 private _previousMarketingFee = _marketingFee;
721 
722     uint256 public totalFeesTax = _taxFee.add(_liquidityFee).add(_marketingFee);
723     IUniswapV2Router02 public  uniswapV2Router;
724     address public  uniswapV2Pair;
725 
726     uint public maxTransferAmountRate = 500;
727     bool private inSwapAndLiquify;
728     bool public swapAndLiquifyEnabled = true;
729 
730     uint256 public numTokensSellToAddToLiquidity = 50000000 * 10**18;
731 
732     
733     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
734     event SwapAndLiquifyEnabledUpdated(bool enabled);
735     event SwapAndLiquify(
736         uint256 tokensSwapped,
737         uint256 ethReceived,
738         uint256 tokensIntoLiqudity
739     );
740     
741 
742     
743     constructor(address _newOwner) {
744         transferOwnership(_newOwner);
745         _rOwned[owner()] = _rTotal;
746         
747         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
748         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
749             .createPair(address(this), _uniswapV2Router.WETH());
750         uniswapV2Router = _uniswapV2Router;
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753         _isExcludedFromAntiWhale[msg.sender] = true;
754         _isExcludedFromAntiWhale[address(0)] = true;
755         _isExcludedFromAntiWhale[address(this)] = true;
756         _isExcludedFromAntiWhale[deadAddress] = true;
757         emit Transfer(address(0), owner(), _tTotal);
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
796 
797     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
798         _transfer(sender, recipient, amount);
799         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
800         return true;
801     }
802  
803 
804     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
805         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
806         return true;
807     }
808 
809     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
811         return true;
812     }
813 
814     function isExcludedFromReward(address account) public view returns (bool) {
815         return _isExcluded[account];
816     }
817 
818     function isExcludedFromAntiWhale(address account) public view returns(bool) {
819         return _isExcludedFromAntiWhale[account];
820     }
821 
822     function totalFees() public view returns (uint256) {
823         return _tFeeTotal;
824     }
825 
826     function deliver(uint256 tAmount) public {
827         address sender = _msgSender();
828         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
829         (uint256 rAmount,,,,,) = _getValues(tAmount);
830         _rOwned[sender] = _rOwned[sender].sub(rAmount);
831         _rTotal = _rTotal.sub(rAmount);
832         _tFeeTotal = _tFeeTotal.add(tAmount);
833     }
834 
835     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
836         require(tAmount <= _tTotal, "Amount must be less than supply");
837         if (!deductTransferFee) {
838             (uint256 rAmount,,,,,) = _getValues(tAmount);
839             return rAmount;
840         } else {
841             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
842             return rTransferAmount;
843         }
844     }
845 
846     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
847         require(rAmount <= _rTotal, "Amount must be less than total reflections");
848         uint256 currentRate =  _getRate();
849         return rAmount.div(currentRate);
850     }
851 
852     function excludeFromReward(address account) public onlyOwner() {
853         require(!_isExcluded[account], "Account is already excluded");
854         if(_rOwned[account] > 0) {
855             _tOwned[account] = tokenFromReflection(_rOwned[account]);
856         }
857         _isExcluded[account] = true;
858         _excluded.push(account);
859     }
860 
861     function includeInReward(address account) external onlyOwner() {
862         require(_isExcluded[account], "Account is already excluded");
863         for (uint256 i = 0; i < _excluded.length; i++) {
864             if (_excluded[i] == account) {
865                 _excluded[i] = _excluded[_excluded.length - 1];
866                 _tOwned[account] = 0;
867                 _isExcluded[account] = false;
868                 _excluded.pop();
869                 break;
870             }
871         }
872     }
873 
874     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
875         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
876         _tOwned[sender] = _tOwned[sender].sub(tAmount);
877         _rOwned[sender] = _rOwned[sender].sub(rAmount);
878         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
879         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
880         _takeLiquidity(tLiquidity);
881         _reflectFee(rFee, tFee);
882         emit Transfer(sender, recipient, tTransferAmount);
883     }
884     
885 
886     
887      //to recieve ETH from uniswapV2Router when swaping
888     receive() external payable {}
889 
890     function _reflectFee(uint256 rFee, uint256 tFee) private {
891         _rTotal = _rTotal.sub(rFee);
892         _tFeeTotal = _tFeeTotal.add(tFee);
893     }
894 
895     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
896         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
897         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
898         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
899     }
900 
901     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
902         uint256 tFee = calculateTaxFee(tAmount);
903         uint256 tLiquidity = calculateLiquidityFee(tAmount);
904         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
905         return (tTransferAmount, tFee, tLiquidity);
906     }
907 
908     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
909         uint256 rAmount = tAmount.mul(currentRate);
910         uint256 rFee = tFee.mul(currentRate);
911         uint256 rLiquidity = tLiquidity.mul(currentRate);
912         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
913         return (rAmount, rTransferAmount, rFee);
914     }
915 
916     function _getRate() private view returns(uint256) {
917         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
918         return rSupply.div(tSupply);
919     }
920 
921     function _getCurrentSupply() private view returns(uint256, uint256) {
922         uint256 rSupply = _rTotal;
923         uint256 tSupply = _tTotal;      
924         for (uint256 i = 0; i < _excluded.length; i++) {
925             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
926             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
927             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
928         }
929         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
930         return (rSupply, tSupply);
931     }
932     
933     function _takeLiquidity(uint256 tLiquidity) private {
934         uint256 currentRate =  _getRate();
935         uint256 rLiquidity = tLiquidity.mul(currentRate);
936         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
937         if(_isExcluded[address(this)])
938             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
939     }
940     
941     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
942         return _amount.mul(_taxFee).div(
943             10**2
944         );
945     }
946 
947     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
948         return _amount.mul(_liquidityFee).div(
949             10**2
950         );
951     }
952     
953     function removeAllFee() private {
954         if(_taxFee == 0 && _liquidityFee == 0 &&  _marketingFee == 0) return;
955         
956         _previousTaxFee = _taxFee;
957         _previousLiquidityFee = _liquidityFee;
958         _previousMarketingFee = _marketingFee;
959         _taxFee = 0;
960         _marketingFee = 0;
961         _liquidityFee = 0;
962 
963  
964     }
965     
966     function restoreAllFee() private {
967        _taxFee = _previousTaxFee;
968        _liquidityFee = _previousLiquidityFee;
969        _marketingFee = _previousMarketingFee;
970     }
971     
972     function isExcludedFromFee(address account) public view returns(bool) {
973         return _isExcludedFromFee[account];
974     }
975 
976     function _approve(address owner, address spender, uint256 amount) private {
977         require(owner != address(0), "ERC20: approve from the zero address");
978         require(spender != address(0), "ERC20: approve to the zero address");
979 
980         _allowances[owner][spender] = amount;
981         emit Approval(owner, spender, amount);
982     }
983 
984 
985     function _transfer(
986         address from,
987         address to,
988         uint256 amount
989     ) private {
990         require(from != address(0), "ERC20: transfer from the zero address");
991         require(amount > 0, "Transfer amount must be greater than zero");
992 
993    
994 
995  
996         // is the token balance of this contract address over the min number of
997         // tokens that we need to initiate a swap + liquidity lock?
998         // also, don't get caught in a circular liquidity event.
999         // also, don't swap & liquify if sender is uniswap pair.
1000         uint256 contractTokenBalance = balanceOf(address(this));        
1001         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1002         if (
1003             overMinTokenBalance &&
1004             !inSwapAndLiquify &&
1005             from != uniswapV2Pair &&
1006             swapAndLiquifyEnabled
1007         ) {
1008             inSwapAndLiquify = true;
1009             contractTokenBalance = numTokensSellToAddToLiquidity;
1010            
1011             uint256 totalTaxForSwap = _liquidityFee.add(_marketingFee);
1012          
1013             if (_marketingFee > 0) {
1014                 uint256 marketingTokens = contractTokenBalance.mul(_marketingFee).div(totalTaxForSwap);
1015                 swapAndSendMarketing(marketingTokens);
1016             }
1017           
1018             swapAndLiquify(contractTokenBalance.mul(_liquidityFee).div(totalTaxForSwap));
1019             inSwapAndLiquify = false;
1020         }
1021       
1022         //transfer amount, it will take tax, burn, liquidity fee
1023         _tokenTransfer(from,to,amount);
1024     }
1025 
1026     function swapAndSendMarketing(uint256 tokens) internal {
1027         uint256 initialBalance = address(this).balance;
1028         // swap tokens for ETH
1029         swapTokensForEth(tokens); 
1030         uint256 newBalance = address(this).balance.sub(initialBalance);
1031         (bool success,) =  address(marketingWallet).call{value: newBalance}("");
1032         if (success) {
1033 
1034         }
1035     }
1036 
1037  
1038     function swapAndLiquify(uint256 contractTokenBalance) private  {
1039         // split the contract balance into halves
1040         uint256 half = contractTokenBalance.div(2);
1041         uint256 otherHalf = contractTokenBalance.sub(half);
1042 
1043         // capture the contract's current ETH balance.
1044         // this is so that we can capture exactly the amount of ETH that the
1045         // swap creates, and not make the liquidity event include any ETH that
1046         // has been manually sent to the contract
1047         uint256 initialBalance = address(this).balance;
1048 
1049         // swap tokens for ETH
1050         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1051 
1052         // how much ETH did we just swap into?
1053         uint256 newBalance = address(this).balance.sub(initialBalance);
1054 
1055         // add liquidity to uniswap
1056         addLiquidity(otherHalf, newBalance);
1057         
1058         emit SwapAndLiquify(half, newBalance, otherHalf);
1059     }
1060 
1061     function swapTokensForEth(uint256 tokenAmount) private {
1062         // generate the uniswap pair path of token -> weth
1063         address[] memory path = new address[](2);
1064         path[0] = address(this);
1065         path[1] = uniswapV2Router.WETH();
1066 
1067         _approve(address(this), address(uniswapV2Router), tokenAmount);
1068 
1069         // make the swap
1070         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1071             tokenAmount,
1072             0, // accept any amount of ETH
1073             path,
1074             address(this),
1075             block.timestamp
1076         );
1077     }
1078 
1079     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1080         // approve token transfer to cover all possible scenarios
1081         _approve(address(this), address(uniswapV2Router), tokenAmount);
1082 
1083         // add the liquidity
1084         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1085             address(this),
1086             tokenAmount,
1087             0, // slippage is unavoidable
1088             0, // slippage is unavoidable
1089             deadAddress,
1090             block.timestamp
1091         );
1092     }
1093   
1094     function setExcludedFromAntiWhale(address account, bool exclude) public onlyOwner {
1095           _isExcludedFromAntiWhale[account] = exclude;
1096     }
1097 
1098     function setEnableAntiwhale(bool _val) public onlyOwner {
1099         enableAntiwhale = _val;
1100     }
1101 
1102     function maxTransferAmount() public view returns (uint256) {
1103         // we can either use a percentage of supply
1104         if(maxTransferAmountRate > 0){
1105             return totalSupply().mul(maxTransferAmountRate).div(10000);
1106         }
1107         // or we can just use default number 1%.
1108         return totalSupply().mul(100).div(10000);
1109     }
1110 
1111     function setMaxTransferAmountRate(uint256 _val) public onlyOwner {
1112         require(_val <= 500, "max 5%");
1113         maxTransferAmountRate = _val;
1114     }
1115 
1116 
1117     //this method is responsible for taking all fee, if takeFee is true
1118     function _tokenTransfer(address sender, address recipient, uint256 amount) private 
1119     {
1120 
1121         if (enableAntiwhale && maxTransferAmount() > 0) {
1122             if (
1123                 _isExcludedFromAntiWhale[sender] == false
1124                 && _isExcludedFromAntiWhale[recipient] == false
1125             ) {
1126                 require(amount <= maxTransferAmount(), "AntiWhale: Transfer amount exceeds the maxTransferAmount");
1127             }
1128         }
1129 
1130         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1131         {   
1132            removeAllFee(); 
1133         }
1134        
1135         
1136     
1137         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1138             _transferFromExcluded(sender, recipient, amount);
1139         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1140             _transferToExcluded(sender, recipient, amount);
1141         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1142             _transferStandard(sender, recipient, amount);
1143         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1144             _transferBothExcluded(sender, recipient, amount);
1145         } else {
1146             _transferStandard(sender, recipient, amount);
1147         }
1148      
1149      
1150         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1151         {
1152             restoreAllFee();
1153         }
1154     }
1155 
1156 
1157 
1158     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
1159     {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1161         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1164         _takeLiquidity(tLiquidity);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 
1169 
1170 
1171 
1172      function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1173     returns (uint256, uint256)
1174     {
1175         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
1176         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
1177         uint256 rMarketing = tMarketing.mul(_getRate());
1178         rTransferAmount = rTransferAmount.sub(rMarketing);
1179         tTransferAmount = tTransferAmount.sub(tMarketing);
1180         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1181         emit Transfer(sender, address(this), tMarketing);
1182         return(tTransferAmount, rTransferAmount); 
1183     }
1184 
1185 
1186     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1187         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1188         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1189         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1190         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1191         _takeLiquidity(tLiquidity);
1192         _reflectFee(rFee, tFee);
1193         emit Transfer(sender, recipient, tTransferAmount);
1194     }
1195 
1196     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1197         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1198         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1199         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1200         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1201         _takeLiquidity(tLiquidity);
1202         _reflectFee(rFee, tFee);
1203         emit Transfer(sender, recipient, tTransferAmount);
1204     }
1205 
1206     function excludeFromFee(address account) public onlyOwner {
1207         _isExcludedFromFee[account] = true;
1208     }
1209     
1210     function includeInFee(address account) public onlyOwner {
1211         _isExcludedFromFee[account] = false;
1212     }
1213    
1214     function setMarketingWallet(address newWallet) external onlyOwner() {
1215         marketingWallet = newWallet;
1216     }
1217 
1218  
1219     
1220     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1221         _taxFee = taxFee;
1222         totalFeesTax = _taxFee.add(_marketingFee).add(_liquidityFee);
1223         require(totalFeesTax <= 20, "max 20%");
1224     }
1225 
1226     function setMarketingFee(uint256 marketingF) external onlyOwner {
1227         _marketingFee = marketingF;
1228         totalFeesTax = _taxFee.add(_marketingFee).add(_liquidityFee);
1229         require(totalFeesTax <= 20, "max 20%");
1230     }
1231     
1232     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1233         _liquidityFee = liquidityFee;
1234         totalFeesTax = _taxFee.add(_marketingFee).add(_liquidityFee);
1235         require(totalFeesTax <= 20, "max 20%");
1236     }
1237     
1238 
1239     
1240     function setNumTokensSellToAddToLiquidity(uint256 newAmt) external onlyOwner() {
1241         numTokensSellToAddToLiquidity = newAmt*10**18;
1242     }
1243     
1244 
1245     
1246     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1247         swapAndLiquifyEnabled = _enabled;
1248         emit SwapAndLiquifyEnabledUpdated(_enabled);
1249     }
1250     
1251 
1252 }