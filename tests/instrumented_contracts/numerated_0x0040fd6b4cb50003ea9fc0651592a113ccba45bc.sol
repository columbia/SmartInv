1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105  
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
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
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor () internal {
408         address msgSender = _msgSender();
409         _owner = _msgSender();
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
449 }
450 
451 // pragma solidity >=0.5.0;
452 
453 interface IUniswapV2Factory {
454     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
455 
456     function feeTo() external view returns (address);
457     function feeToSetter() external view returns (address);
458 
459     function getPair(address tokenA, address tokenB) external view returns (address pair);
460     function allPairs(uint) external view returns (address pair);
461     function allPairsLength() external view returns (uint);
462 
463     function createPair(address tokenA, address tokenB) external returns (address pair);
464 
465     function setFeeTo(address) external;
466     function setFeeToSetter(address) external;
467 }
468 
469 // pragma solidity >=0.5.0;
470 
471 interface IUniswapV2Pair {
472     event Approval(address indexed owner, address indexed spender, uint value);
473     event Transfer(address indexed from, address indexed to, uint value);
474 
475     function name() external pure returns (string memory);
476     function symbol() external pure returns (string memory);
477     function decimals() external pure returns (uint8);
478     function totalSupply() external view returns (uint);
479     function balanceOf(address owner) external view returns (uint);
480     function allowance(address owner, address spender) external view returns (uint);
481 
482     function approve(address spender, uint value) external returns (bool);
483     function transfer(address to, uint value) external returns (bool);
484     function transferFrom(address from, address to, uint value) external returns (bool);
485 
486     function DOMAIN_SEPARATOR() external view returns (bytes32);
487     function PERMIT_TYPEHASH() external pure returns (bytes32);
488     function nonces(address owner) external view returns (uint);
489 
490     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
491 
492     event Mint(address indexed sender, uint amount0, uint amount1);
493     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
494     event Swap(
495         address indexed sender,
496         uint amount0In,
497         uint amount1In,
498         uint amount0Out,
499         uint amount1Out,
500         address indexed to
501     );
502     event Sync(uint112 reserve0, uint112 reserve1);
503 
504     function MINIMUM_LIQUIDITY() external pure returns (uint);
505     function factory() external view returns (address);
506     function token0() external view returns (address);
507     function token1() external view returns (address);
508     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
509     function price0CumulativeLast() external view returns (uint);
510     function price1CumulativeLast() external view returns (uint);
511     function kLast() external view returns (uint);
512 
513     function mint(address to) external returns (uint liquidity);
514     function burn(address to) external returns (uint amount0, uint amount1);
515     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
516     function skim(address to) external;
517     function sync() external;
518 
519     function initialize(address, address) external;
520 }
521 
522 // pragma solidity >=0.6.2;
523 
524 interface IUniswapV2Router {
525     function factory() external pure returns (address);
526     function WETH() external pure returns (address);
527 
528     function addLiquidity(
529         address tokenA,
530         address tokenB,
531         uint amountADesired,
532         uint amountBDesired,
533         uint amountAMin,
534         uint amountBMin,
535         address to,
536         uint deadline
537     ) external returns (uint amountA, uint amountB, uint liquidity);
538     function addLiquidityETH(
539         address token,
540         uint amountTokenDesired,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline
545     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
546     function removeLiquidity(
547         address tokenA,
548         address tokenB,
549         uint liquidity,
550         uint amountAMin,
551         uint amountBMin,
552         address to,
553         uint deadline
554     ) external returns (uint amountA, uint amountB);
555     function removeLiquidityETH(
556         address token,
557         uint liquidity,
558         uint amountTokenMin,
559         uint amountETHMin,
560         address to,
561         uint deadline
562     ) external returns (uint amountToken, uint amountETH);
563     function removeLiquidityWithPermit(
564         address tokenA,
565         address tokenB,
566         uint liquidity,
567         uint amountAMin,
568         uint amountBMin,
569         address to,
570         uint deadline,
571         bool approveMax, uint8 v, bytes32 r, bytes32 s
572     ) external returns (uint amountA, uint amountB);
573     function removeLiquidityETHWithPermit(
574         address token,
575         uint liquidity,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline,
580         bool approveMax, uint8 v, bytes32 r, bytes32 s
581     ) external returns (uint amountToken, uint amountETH);
582     function swapExactTokensForTokens(
583         uint amountIn,
584         uint amountOutMin,
585         address[] calldata path,
586         address to,
587         uint deadline
588     ) external returns (uint[] memory amounts);
589     function swapTokensForExactTokens(
590         uint amountOut,
591         uint amountInMax,
592         address[] calldata path,
593         address to,
594         uint deadline
595     ) external returns (uint[] memory amounts);
596     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
597         external
598         payable
599         returns (uint[] memory amounts);
600     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
601         external
602         returns (uint[] memory amounts);
603     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
604         external
605         returns (uint[] memory amounts);
606     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
607         external
608         payable
609         returns (uint[] memory amounts);
610 
611     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
612     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
613     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
614     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
615     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
616 }
617 
618 // pragma solidity >=0.6.2;
619 
620 interface IUniswapV2Router02 is IUniswapV2Router {
621     function removeLiquidityETHSupportingFeeOnTransferTokens(
622         address token,
623         uint liquidity,
624         uint amountTokenMin,
625         uint amountETHMin,
626         address to,
627         uint deadline
628     ) external returns (uint amountETH);
629     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
630         address token,
631         uint liquidity,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline,
636         bool approveMax, uint8 v, bytes32 r, bytes32 s
637     ) external returns (uint amountETH);
638 
639     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
640         uint amountIn,
641         uint amountOutMin,
642         address[] calldata path,
643         address to,
644         uint deadline
645     ) external;
646     function swapExactETHForTokensSupportingFeeOnTransferTokens(
647         uint amountOutMin,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external payable;
652     function swapExactTokensForETHSupportingFeeOnTransferTokens(
653         uint amountIn,
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external;
659 }
660 
661 contract KIZO is Context, IERC20, Ownable {
662     using SafeMath for uint256;
663     using Address for address;
664 
665     // maps and constants
666     mapping (address => uint256) private _rOwned;
667     mapping (address => uint256) private _tOwned;
668     mapping (address => mapping (address => uint256)) private _allowances;
669     mapping (address => bool) private _isExcludedFromFee;
670     mapping(address => bool) private _isExcludedFromMaxTx;
671     mapping (address => uint256) private _sellPenaltyDeadline;
672 
673     mapping (address => bool) private _isExcluded;
674     address[] private _excluded;
675    
676     uint256 private constant MAX = ~uint256(0);
677     uint256 private _tTotal = 1000000 * 10**9;
678     uint256 private _rTotal = (MAX - (MAX % _tTotal));
679     uint256 private _tFeeTotal;
680 
681     // token variables
682     string private _name = "KIZO";
683     string private _symbol = "$KIZO";
684     uint8 private _decimals = 9;
685 
686     // buy fees    
687     uint256 public _taxFee = 0;
688     uint256 private _previousTaxFee = _taxFee;
689 
690     uint256 public _devFee = 0;
691     uint256 private _devTax = 0;
692     uint256 private _marketingTax = 0;
693     uint256 private _platformTax = 0;
694     uint256 private _previousDevFee = _devFee;
695     
696     uint256 public _liquidityFee = 0;
697     uint256 private _previousLiquidityFee = _liquidityFee;
698 
699     // sell fees
700     uint256 public _sellTaxFee = 0;
701     uint256 private _previousSellTaxFee = _sellTaxFee;
702 
703     uint256 public _sellDevFee = 800;
704     uint256 private _sellDevTax = 500;
705     uint256 private _sellMarketingTax = 150;
706     uint256 private _sellPlatformTax = 150;
707     uint256 private _previousSellDevFee = _sellDevFee;
708     
709     uint256 public _sellLiquidityFee = 200;
710     uint256 private _previousSellLiquidityFee = _sellLiquidityFee;
711 
712     uint256 public launchSellFee = 0;
713     uint256 private _previousLaunchSellFee = launchSellFee;
714 
715     uint256 public firstSellPenaltyFee = 2000;
716     uint256 private _firstSellLiquidityTax = 1500;
717     uint256 private _firstSellDevTax = 500;
718     uint256 private _previousFirstSellPenaltyFee = firstSellPenaltyFee;
719 
720 
721     // limits and wallets
722     uint256 public maxTxAmount = _tTotal.mul(50).div(1000); // 5%
723     address payable private _devWallet = payable(0x3a3cb7def0Fb88625Ed60f505974b1a84d95bab9);
724     address payable private _marketingWallet = payable(0x1163153132B9a6E211A5FDd3ceb19bb4dA1C3A1d);
725     address payable private _platformWallet = payable(0xA61e691Ef6d4014e8397e7b35128e24065750d48);
726 
727     uint256 public launchSellFeeDeadline = 0;
728 
729     IUniswapV2Router02 public uniswapV2Router;
730     address public uniswapV2Pair;
731     
732     // auto liquify
733     bool inSwapAndLiquify;
734     bool public swapAndLiquifyEnabled = true;
735     uint256 private minTokensBeforeSwap = 1000 * 10**9;
736     
737     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
738     event SwapAndLiquifyEnabledUpdated(bool enabled);
739     event SwapAndLiquify(
740         uint256 tokensSwapped,
741         uint256 liquidityEthBalance,
742         uint256 devEthBalance
743     );
744     
745     modifier lockTheSwap {
746         inSwapAndLiquify = true;
747          _;
748         inSwapAndLiquify = false;
749     }
750     
751     constructor () public {
752         _rOwned[_msgSender()] = _rTotal;
753         
754         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
755          // Create a uniswap pair for this new token
756         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
757             .createPair(address(this), _uniswapV2Router.WETH());
758 
759         // set the rest of the contract variables
760         uniswapV2Router = _uniswapV2Router;
761         
762         //exclude owner and this contract from fee
763         _isExcludedFromFee[owner()] = true;
764         _isExcludedFromFee[address(this)] = true;
765 
766         // internal exclude from max tx
767         _isExcludedFromMaxTx[owner()] = true;
768         _isExcludedFromMaxTx[address(this)] = true;
769 
770         // launch sell fee
771         launchSellFeeDeadline = now + 1 days;
772         
773         emit Transfer(address(0), _msgSender(), _tTotal);
774     }
775 
776     function setRouterAddress(address newRouter) public onlyOwner() {
777         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
778         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
779         uniswapV2Router = _newUniswapRouter;
780     }
781 
782     function name() public view returns (string memory) {
783         return _name;
784     }
785 
786     function symbol() public view returns (string memory) {
787         return _symbol;
788     }
789 
790     function decimals() public view returns (uint8) {
791         return _decimals;
792     }
793 
794     function totalSupply() public view override returns (uint256) {
795         return _tTotal;
796     }
797 
798     function balanceOf(address account) public view override returns (uint256) {
799         if (_isExcluded[account]) return _tOwned[account];
800         return tokenFromReflection(_rOwned[account]);
801     }
802 
803     function transfer(address recipient, uint256 amount) public override returns (bool) {
804         _transfer(_msgSender(), recipient, amount);
805         return true;
806     }
807 
808     function allowance(address owner, address spender) public view override returns (uint256) {
809         return _allowances[owner][spender];
810     }
811 
812     function approve(address spender, uint256 amount) public override returns (bool) {
813         _approve(_msgSender(), spender, amount);
814         return true;
815     }
816 
817     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
818         _transfer(sender, recipient, amount);
819         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
820         return true;
821     }
822 
823     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
824         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
825         return true;
826     }
827 
828     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
829         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
830         return true;
831     }
832 
833     function isExcludedFromReward(address account) public view returns (bool) {
834         return _isExcluded[account];
835     }
836 
837     function getSellPenaltyDeadlineForWallet(address wallet) public view returns (uint256) {
838         return _sellPenaltyDeadline[wallet];
839     }
840 
841     function totalFees() public view returns (uint256) {
842         return _tFeeTotal;
843     }
844 
845     function deliver(uint256 tAmount) public {
846         address sender = _msgSender();
847         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
848         (uint256 rAmount,,,,,,) = _getValues(tAmount);
849         _rOwned[sender] = _rOwned[sender].sub(rAmount);
850         _rTotal = _rTotal.sub(rAmount);
851         _tFeeTotal = _tFeeTotal.add(tAmount);
852     }
853 
854     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
855         require(tAmount <= _tTotal, "Amount must be less than supply");
856         if (!deductTransferFee) {
857             (uint256 rAmount,,,,,,) = _getValues(tAmount);
858             return rAmount;
859         } else {
860             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
861             return rTransferAmount;
862         }
863     }
864 
865     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
866         require(rAmount <= _rTotal, "Amount must be less than total reflections");
867         uint256 currentRate =  _getRate();
868         return rAmount.div(currentRate);
869     }
870 
871     function excludeFromReward(address account) public onlyOwner() {
872         require(!_isExcluded[account], "Account is already excluded");
873         if(_rOwned[account] > 0) {
874             _tOwned[account] = tokenFromReflection(_rOwned[account]);
875         }
876         _isExcluded[account] = true;
877         _excluded.push(account);
878     }
879 
880     function includeInReward(address account) external onlyOwner() {
881         require(_isExcluded[account], "Account is already excluded");
882         for (uint256 i = 0; i < _excluded.length; i++) {
883             if (_excluded[i] == account) {
884                 _excluded[i] = _excluded[_excluded.length - 1];
885                 _tOwned[account] = 0;
886                 _isExcluded[account] = false;
887                 _excluded.pop();
888                 break;
889             }
890         }
891     }
892     
893     function _approve(address owner, address spender, uint256 amount) private {
894         require(owner != address(0));
895         require(spender != address(0));
896 
897         _allowances[owner][spender] = amount;
898         emit Approval(owner, spender, amount);
899     }
900     
901     function expectedRewards(address _sender) external view returns(uint256){
902         uint256 _balance = address(this).balance;
903         address sender = _sender;
904         uint256 holdersBal = balanceOf(sender);
905         uint totalExcludedBal;
906         for (uint256 i = 0; i < _excluded.length; i++){
907             totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
908         }
909         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(uniswapV2Pair)).sub(totalExcludedBal));
910         return rewards;
911     }
912     
913     function _transfer(
914         address from,
915         address to,
916         uint256 amount
917     ) private {
918         require(from != address(0), "ERC20: transfer from the zero address");
919         require(to != address(0), "ERC20: transfer to the zero address");
920         require(amount > 0, "Transfer amount must be greater than zero");
921         
922         if (
923             !_isExcludedFromMaxTx[from] &&
924             !_isExcludedFromMaxTx[to] // by default false
925         ) {
926             require(
927                 amount <= maxTxAmount,
928                 "Transfer amount exceeds the maxTxAmount."
929             );
930         }
931 
932         // update fees for buy/sell
933         uint256 regularDevFee = _devFee;
934         uint256 regularDevTax = _devTax;
935         uint256 regularMarketingTax = _marketingTax;
936         uint256 regularPlatformTax = _platformTax;
937         uint256 regularLiquidityFee = _liquidityFee;
938         uint256 regularTaxFee = _taxFee;
939         bool isSell = to == uniswapV2Pair;
940         if (isSell) {
941             _devFee = _sellDevFee;
942             _devTax = _sellDevTax;
943             _marketingTax = _sellMarketingTax;
944             _platformTax = _sellPlatformTax;
945 
946             _liquidityFee = _sellLiquidityFee;
947             _taxFee = _sellTaxFee;
948 
949             if (launchSellFeeDeadline >= now) {
950                 _devFee = _devFee.add(launchSellFee);
951                 _devTax = _devTax.add(launchSellFee);
952             }
953 
954             if (_sellPenaltyDeadline[from] >= now && _sellPenaltyDeadline[from] != 1) {
955                 _liquidityFee = _liquidityFee.add(_firstSellLiquidityTax);
956                 _devFee = _devFee.add(_firstSellDevTax);
957                 _devTax = _devTax.add(_firstSellDevTax);
958 
959                 _sellPenaltyDeadline[from] = 1; // disable
960             }
961         } else if (_sellPenaltyDeadline[to] == 0) {
962             _sellPenaltyDeadline[to] = now + 24 hours;
963         }
964 
965         // is the token balance of this contract address over the min number of
966         // tokens that we need to initiate a swap + liquidity lock?
967         // also, don't get caught in a circular liquidity event.
968         // also, don't swap & liquify if sender is uniswap pair.
969         uint256 contractTokenBalance = balanceOf(address(this));
970         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
971         if (
972             overMinTokenBalance &&
973             !inSwapAndLiquify &&
974             from != uniswapV2Pair &&
975             swapAndLiquifyEnabled
976         ) {
977             // add liquidity
978             uint256 tokensToSell = maxTxAmount > contractTokenBalance ? contractTokenBalance : maxTxAmount;
979             swapAndLiquify(tokensToSell);
980         }
981         
982         // indicates if fee should be deducted from transfer
983         bool takeFee = true;
984         
985         // if any account belongs to _isExcludedFromFee account then remove the fee
986         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
987             takeFee = false;
988         }
989         
990         // transfer amount, it will take tax, dev fee, liquidity fee
991         _tokenTransfer(from, to, amount, takeFee);
992 
993         // restore fees
994         _devFee = regularDevFee;
995         _devTax = regularDevTax;
996         _marketingTax = regularMarketingTax;
997         _platformTax = regularPlatformTax;
998         _liquidityFee = regularLiquidityFee;
999         _taxFee = regularTaxFee;
1000     }
1001     
1002     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1003         // balance token fees based on variable percents
1004         uint256 totalRedirectTokenFee = _devFee.add(_liquidityFee);
1005 
1006         if (totalRedirectTokenFee == 0) return;
1007         uint256 liquidityTokenBalance = contractTokenBalance.mul(_liquidityFee).div(totalRedirectTokenFee);
1008         uint256 devTokenBalance = contractTokenBalance.mul(_devFee).div(totalRedirectTokenFee);
1009         
1010         // split the liquidity balance into halves
1011         uint256 halfLiquidity = liquidityTokenBalance.div(2);
1012         
1013         // capture the contract's current ETH balance.
1014         // this is so that we can capture exactly the amount of ETH that the
1015         // swap creates, and not make the fee events include any ETH that
1016         // has been manually sent to the contract
1017         uint256 initialBalance = address(this).balance;
1018         
1019         if (liquidityTokenBalance == 0 && devTokenBalance == 0) return;
1020         
1021         // swap tokens for ETH
1022         swapTokensForEth(devTokenBalance.add(halfLiquidity));
1023         
1024         uint256 newBalance = address(this).balance.sub(initialBalance);
1025         
1026         if(newBalance > 0) {
1027             // rebalance ETH fees proportionally to half the liquidity
1028             uint256 totalRedirectEthFee = _devFee.add(_liquidityFee.div(2));
1029             uint256 liquidityEthBalance = newBalance.mul(_liquidityFee.div(2)).div(totalRedirectEthFee);
1030             uint256 devEthBalance = newBalance.mul(_devFee).div(totalRedirectEthFee);
1031 
1032             //
1033             // for liquidity
1034             // add to uniswap
1035             //
1036     
1037             addLiquidity(halfLiquidity, liquidityEthBalance);
1038             
1039             //
1040             // for dev fee
1041             // send to the dev address
1042             //
1043             
1044             sendEthToDevAddress(devEthBalance);
1045             
1046             emit SwapAndLiquify(contractTokenBalance, liquidityEthBalance, devEthBalance);
1047         }
1048     } 
1049     
1050     function sendEthToDevAddress(uint256 amount) private {
1051         if (amount > 0 && _devFee > 0) {
1052             uint256 ethToDev = amount.mul(_devTax).div(_devFee);
1053             uint256 ethToMarketing = amount.mul(_marketingTax).div(_devFee);
1054             uint256 ethToPlatform = amount.mul(_platformTax).div(_devFee);
1055             if (ethToDev > 0) _devWallet.transfer(ethToDev);
1056             if (ethToMarketing > 0) _marketingWallet.transfer(ethToMarketing);
1057             if (ethToPlatform > 0) _platformWallet.transfer(ethToPlatform);
1058         }
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
1080         if (tokenAmount > 0 && ethAmount > 0) {
1081             // approve token transfer to cover all possible scenarios
1082             _approve(address(this), address(uniswapV2Router), tokenAmount);
1083 
1084             // add the liquidity
1085             uniswapV2Router.addLiquidityETH{value: ethAmount} (
1086                 address(this),
1087                 tokenAmount,
1088                 0, // slippage is unavoidable
1089                 0, // slippage is unavoidable
1090                 owner(),
1091                 block.timestamp
1092             );
1093         }
1094     }
1095 
1096     //this method is responsible for taking all fee, if takeFee is true
1097     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1098         if(!takeFee) {
1099             removeAllFee();
1100         }
1101         
1102         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1103             _transferFromExcluded(sender, recipient, amount);
1104         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1105             _transferToExcluded(sender, recipient, amount);
1106         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1107             _transferStandard(sender, recipient, amount);
1108         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1109             _transferBothExcluded(sender, recipient, amount);
1110         } else {
1111             _transferStandard(sender, recipient, amount);
1112         }
1113         
1114         if(!takeFee) {
1115             restoreAllFee();
1116         }
1117     }
1118 
1119     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1120         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1121         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1122         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1123         _takeLiquidity(tLiquidity);
1124         _takeDev(tDev);
1125         _reflectFee(rFee, tFee);
1126         emit Transfer(sender, recipient, tTransferAmount);
1127     }
1128 
1129     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1130         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1131         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1132         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1133         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1134         _takeLiquidity(tLiquidity);
1135         _takeDev(tDev);
1136         _reflectFee(rFee, tFee);
1137         emit Transfer(sender, recipient, tTransferAmount);
1138     }
1139 
1140     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1141         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1142         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1143         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1144         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1145         _takeLiquidity(tLiquidity);
1146         _takeDev(tDev);
1147         _reflectFee(rFee, tFee);
1148         emit Transfer(sender, recipient, tTransferAmount);
1149     }
1150 
1151     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1152         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1153         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1157         _takeLiquidity(tLiquidity);
1158         _takeDev(tDev);
1159         _reflectFee(rFee, tFee);
1160         emit Transfer(sender, recipient, tTransferAmount);
1161     }
1162 
1163     function _reflectFee(uint256 rFee, uint256 tFee) private {
1164         _rTotal = _rTotal.sub(rFee);
1165         _tFeeTotal = _tFeeTotal.add(tFee);
1166     }
1167 
1168     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1169         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getTValues(tAmount);
1170         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tLiquidity, _getRate());
1171         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tDev, tLiquidity);
1172     }
1173 
1174     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1175         uint256 tFee = calculateTaxFee(tAmount);
1176         uint256 tDev = calculateDevFee(tAmount);
1177         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1178         uint256 tTransferAmount = tAmount.sub(tFee).sub(tDev).sub(tLiquidity);
1179         return (tTransferAmount, tFee, tDev, tLiquidity);
1180     }
1181 
1182     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1183         uint256 rAmount = tAmount.mul(currentRate);
1184         uint256 rFee = tFee.mul(currentRate);
1185         uint256 rDev = tDev.mul(currentRate);
1186         uint256 rLiquidity = tLiquidity.mul(currentRate);
1187         uint256 rTransferAmount = rAmount.sub(rFee).sub(rDev).sub(rLiquidity);
1188         return (rAmount, rTransferAmount, rFee);
1189     }
1190 
1191     function _getRate() private view returns(uint256) {
1192         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1193         return rSupply.div(tSupply);
1194     }
1195 
1196     function _getCurrentSupply() private view returns(uint256, uint256) {
1197         uint256 rSupply = _rTotal;
1198         uint256 tSupply = _tTotal;      
1199         for (uint256 i = 0; i < _excluded.length; i++) {
1200             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1201             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1202             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1203         }
1204         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1205         return (rSupply, tSupply);
1206     }
1207     
1208     function _takeLiquidity(uint256 tLiquidity) private {
1209         uint256 currentRate =  _getRate();
1210         uint256 rLiquidity = tLiquidity.mul(currentRate);
1211         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1212         if(_isExcluded[address(this)]) {
1213             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1214         }
1215     }
1216     
1217     function _takeDev(uint256 tDev) private {
1218         uint256 currentRate =  _getRate();
1219         uint256 rDev = tDev.mul(currentRate);
1220         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1221         if(_isExcluded[address(this)]) {
1222             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1223         }
1224     }
1225     
1226     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1227         return _amount.mul(_taxFee).div(10000);
1228     }
1229 
1230     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1231         return _amount.mul(_devFee).div(10000);
1232     }
1233 
1234     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1235         return _amount.mul(_liquidityFee).div(10000);
1236     }
1237     
1238     function removeAllFee() private {
1239         if(_taxFee == 0 && _devFee == 0 && _liquidityFee == 0 && launchSellFee == 0 && firstSellPenaltyFee == 0) return;
1240         
1241         _previousTaxFee = _taxFee;
1242         _previousDevFee = _devFee;
1243         _previousLiquidityFee = _liquidityFee;
1244         _previousLaunchSellFee = launchSellFee;
1245         _previousFirstSellPenaltyFee = firstSellPenaltyFee;
1246         
1247         _taxFee = 0;
1248         _devFee = 0;
1249         _liquidityFee = 0;
1250         launchSellFee = 0;
1251         firstSellPenaltyFee = 0;
1252     }
1253     
1254     function restoreAllFee() private {
1255         _taxFee = _previousTaxFee;
1256         _devFee = _previousDevFee;
1257         _liquidityFee = _previousLiquidityFee;
1258         launchSellFee = _previousLaunchSellFee;
1259         firstSellPenaltyFee = _previousFirstSellPenaltyFee;
1260     }
1261     
1262     function manualSwap() external onlyOwner() {
1263         uint256 contractBalance = balanceOf(address(this));
1264         swapTokensForEth(contractBalance);
1265     }
1266 
1267     function manualSend() external onlyOwner() {
1268         uint256 contractEthBalance = address(this).balance;
1269         sendEthToDevAddress(contractEthBalance);
1270     }
1271     
1272     function isExcludedFromFee(address account) external view returns(bool) {
1273         return _isExcludedFromFee[account];
1274     }
1275     
1276     function excludeFromFee(address account) external onlyOwner {
1277         _isExcludedFromFee[account] = true;
1278     }
1279     
1280     function includeInFee(address account) external onlyOwner {
1281         _isExcludedFromFee[account] = false;
1282     }
1283 
1284     // for 0.5% input 5, for 1% input 10
1285     function setMaxTxPercent(uint256 newMaxTx) external onlyOwner {
1286         require(newMaxTx >= 5, "Max TX should be above 0.5%");
1287         maxTxAmount = _tTotal.mul(newMaxTx).div(1000);
1288     }
1289     
1290     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1291         require(taxFee <= 800, "Maximum fee limit is 8");
1292         _taxFee = taxFee;
1293     }
1294     
1295     function setSellTaxFeePercent(uint256 taxFee) external onlyOwner() {
1296         require(taxFee <= 800, "Maximum fee limit is 8%");
1297         _sellTaxFee = taxFee;
1298     }
1299     
1300     function setDevFeePercent(uint256 devFee, uint256 devTax, uint256 marketingTax) external onlyOwner() {
1301          require(devFee <= 1500, "Maximum fee limit is 15%");
1302          require(devTax + marketingTax == devFee, "Dev + marketing must equal total fee");
1303         _devFee = devFee + _platformTax;
1304         _devTax = devTax;
1305         _marketingTax = marketingTax;
1306     }
1307 
1308     function setSellDevFeePercent(uint256 devFee, uint256 devTax, uint256 marketingTax) external onlyOwner() {
1309         require(devFee <= 1500, "Maximum fee limit is 15%");
1310         require(devTax + marketingTax == devFee, "Dev + marketing must equal total fee");
1311         _sellDevFee = devFee + _sellPlatformTax;
1312         _sellDevTax = devTax;
1313         _sellMarketingTax = marketingTax;
1314     }
1315     
1316     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1317         require(liquidityFee <= 800, "Maximum fee limit is 8%");
1318         _liquidityFee = liquidityFee;
1319     }
1320 
1321     function setSellLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1322         require(liquidityFee <= 800, "Maximum fee limit is 8%");
1323         _sellLiquidityFee = liquidityFee;
1324     }
1325 
1326     function setLaunchSellFee(uint256 newLaunchSellFee) external onlyOwner {
1327         require(newLaunchSellFee <= 2500, "Maximum launch sell fee is 25%");
1328         launchSellFee = newLaunchSellFee;
1329     }
1330 
1331     function setSellPenaltyFeePercent(uint256 sellPenalty, uint256 liquidityTax, uint256 devTax) external onlyOwner() {
1332         require(sellPenalty <= 2500, "Maximum sell penalty is 25%");
1333         require(liquidityTax + devTax == sellPenalty, "Liquidity + marketing must equal sell penalty");
1334         firstSellPenaltyFee = liquidityTax + devTax;
1335         _firstSellLiquidityTax = liquidityTax;
1336         _firstSellDevTax = devTax;
1337     }
1338 
1339     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1340         swapAndLiquifyEnabled = _enabled;
1341         emit SwapAndLiquifyEnabledUpdated(_enabled);
1342     }
1343 
1344     function setMinTokensBeforeSwap(uint256 minTokens) external onlyOwner {
1345         minTokensBeforeSwap = minTokens * 10**9;
1346         emit MinTokensBeforeSwapUpdated(minTokens);
1347     }
1348     
1349     // to receive ETH from uniswapV2Router when swaping
1350     receive() external payable {}
1351 }