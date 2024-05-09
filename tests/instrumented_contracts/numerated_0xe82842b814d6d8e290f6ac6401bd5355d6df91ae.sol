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
661 contract IronPhoenix is Context, IERC20, Ownable {
662     using SafeMath for uint256;
663     using Address for address;
664 
665     mapping (address => uint256) private _rOwned;
666     mapping (address => uint256) private _tOwned;
667     mapping (address => mapping (address => uint256)) private _allowances;
668     mapping (address => bool) private _isExcludedFromFee;
669     mapping(address => bool) private _isExcludedFromMaxTx;
670 
671     mapping (address => bool) private _isExcluded;
672     address[] private _excluded;
673    
674     uint256 private constant MAX = ~uint256(0);
675     uint256 private _tTotal = 1200000000 * 10**9;
676     uint256 private _rTotal = (MAX - (MAX % _tTotal));
677     uint256 private _tFeeTotal;
678 
679     string private _name = "Iron Phoenix";
680     string private _symbol = "IP";
681     uint8 private _decimals = 9;
682     
683     uint256 public _taxFee = 0;
684     uint256 private _previousTaxFee = _taxFee;
685 
686     uint256 public _devFee = 20;
687     uint256 private _devTax = 10;
688     uint256 private _marketingTax = 10;
689     uint256 private _previousDevFee = _devFee;
690     
691     uint256 public _liquidityFee = 10;
692     uint256 private _previousLiquidityFee = _liquidityFee;
693 
694     uint256 public launchSellFee = 0;
695     uint256 private _previousLaunchSellFee = launchSellFee;
696 
697     uint256 public maxTxAmount = _tTotal.mul(20).div(1000); // 2%
698     address payable private _devWallet = payable(0xb8C261664EC5937539c19315DB4Dc0Cca6cfC891);
699     address payable private _marketingWallet = payable(0xaaf8dC636155CDb6291b45404B1883f82c46f3E4);
700 
701     uint256 public launchSellFeeDeadline = 0;
702 
703     IUniswapV2Router02 public uniswapV2Router;
704     address public uniswapV2Pair;
705     
706     bool inSwapAndLiquify;
707     bool public swapAndLiquifyEnabled = true;
708     uint256 private minTokensBeforeSwap = 1200000 * 10**9;
709     
710     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
711     event SwapAndLiquifyEnabledUpdated(bool enabled);
712     event SwapAndLiquify(
713         uint256 tokensSwapped,
714         uint256 liquidityEthBalance,
715         uint256 devEthBalance
716     );
717     
718     modifier lockTheSwap {
719         inSwapAndLiquify = true;
720          _;
721         inSwapAndLiquify = false;
722     }
723     
724     constructor () public {
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
739         // internal exclude from max tx
740         _isExcludedFromMaxTx[owner()] = true;
741         _isExcludedFromMaxTx[address(this)] = true;
742 
743         // launch sell fee
744         launchSellFeeDeadline = now + 1 days;
745         
746         emit Transfer(address(0), _msgSender(), _tTotal);
747     }
748 
749     function setRouterAddress(address newRouter) public onlyOwner() {
750         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
751         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
752         uniswapV2Router = _newUniswapRouter;
753     }
754 
755     function name() public view returns (string memory) {
756         return _name;
757     }
758 
759     function symbol() public view returns (string memory) {
760         return _symbol;
761     }
762 
763     function decimals() public view returns (uint8) {
764         return _decimals;
765     }
766 
767     function totalSupply() public view override returns (uint256) {
768         return _tTotal;
769     }
770 
771     function balanceOf(address account) public view override returns (uint256) {
772         if (_isExcluded[account]) return _tOwned[account];
773         return tokenFromReflection(_rOwned[account]);
774     }
775 
776     function transfer(address recipient, uint256 amount) public override returns (bool) {
777         _transfer(_msgSender(), recipient, amount);
778         return true;
779     }
780 
781     function allowance(address owner, address spender) public view override returns (uint256) {
782         return _allowances[owner][spender];
783     }
784 
785     function approve(address spender, uint256 amount) public override returns (bool) {
786         _approve(_msgSender(), spender, amount);
787         return true;
788     }
789 
790     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
791         _transfer(sender, recipient, amount);
792         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
793         return true;
794     }
795 
796     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
798         return true;
799     }
800 
801     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
802         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
803         return true;
804     }
805 
806     function isExcludedFromReward(address account) public view returns (bool) {
807         return _isExcluded[account];
808     }
809 
810     function totalFees() public view returns (uint256) {
811         return _tFeeTotal;
812     }
813 
814     function deliver(uint256 tAmount) public {
815         address sender = _msgSender();
816         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
817         (uint256 rAmount,,,,,,) = _getValues(tAmount);
818         _rOwned[sender] = _rOwned[sender].sub(rAmount);
819         _rTotal = _rTotal.sub(rAmount);
820         _tFeeTotal = _tFeeTotal.add(tAmount);
821     }
822 
823     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
824         require(tAmount <= _tTotal, "Amount must be less than supply");
825         if (!deductTransferFee) {
826             (uint256 rAmount,,,,,,) = _getValues(tAmount);
827             return rAmount;
828         } else {
829             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
830             return rTransferAmount;
831         }
832     }
833 
834     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
835         require(rAmount <= _rTotal, "Amount must be less than total reflections");
836         uint256 currentRate =  _getRate();
837         return rAmount.div(currentRate);
838     }
839 
840     function excludeFromReward(address account) public onlyOwner() {
841         require(!_isExcluded[account], "Account is already excluded");
842         if(_rOwned[account] > 0) {
843             _tOwned[account] = tokenFromReflection(_rOwned[account]);
844         }
845         _isExcluded[account] = true;
846         _excluded.push(account);
847     }
848 
849     function includeInReward(address account) external onlyOwner() {
850         require(_isExcluded[account], "Account is already excluded");
851         for (uint256 i = 0; i < _excluded.length; i++) {
852             if (_excluded[i] == account) {
853                 _excluded[i] = _excluded[_excluded.length - 1];
854                 _tOwned[account] = 0;
855                 _isExcluded[account] = false;
856                 _excluded.pop();
857                 break;
858             }
859         }
860     }
861     
862     function _approve(address owner, address spender, uint256 amount) private {
863         require(owner != address(0));
864         require(spender != address(0));
865 
866         _allowances[owner][spender] = amount;
867         emit Approval(owner, spender, amount);
868     }
869     
870     function expectedRewards(address _sender) external view returns(uint256){
871         uint256 _balance = address(this).balance;
872         address sender = _sender;
873         uint256 holdersBal = balanceOf(sender);
874         uint totalExcludedBal;
875         for (uint256 i = 0; i < _excluded.length; i++){
876             totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
877         }
878         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(uniswapV2Pair)).sub(totalExcludedBal));
879         return rewards;
880     }
881     
882     function _transfer(
883         address from,
884         address to,
885         uint256 amount
886     ) private {
887         require(from != address(0), "ERC20: transfer from the zero address");
888         require(to != address(0), "ERC20: transfer to the zero address");
889         require(amount > 0, "Transfer amount must be greater than zero");
890         
891         if (
892             !_isExcludedFromMaxTx[from] &&
893             !_isExcludedFromMaxTx[to] // by default false
894         ) {
895             require(
896                 amount <= maxTxAmount,
897                 "Transfer amount exceeds the maxTxAmount."
898             );
899         }
900 
901         // initial sell fee
902         uint256 regularDevFee = _devFee;
903         uint256 regularDevTax = _devTax;
904         if (launchSellFeeDeadline >= now && to == uniswapV2Pair) {
905             _devFee = _devFee.add(launchSellFee);
906             _devTax = _devTax.add(launchSellFee);
907         }
908 
909         // is the token balance of this contract address over the min number of
910         // tokens that we need to initiate a swap + liquidity lock?
911         // also, don't get caught in a circular liquidity event.
912         // also, don't swap & liquify if sender is uniswap pair.
913         uint256 contractTokenBalance = balanceOf(address(this));
914         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
915         if (
916             overMinTokenBalance &&
917             !inSwapAndLiquify &&
918             from != uniswapV2Pair &&
919             swapAndLiquifyEnabled
920         ) {
921             // add liquidity
922             uint256 tokensToSell = maxTxAmount > contractTokenBalance ? contractTokenBalance : maxTxAmount;
923             swapAndLiquify(tokensToSell);
924         }
925         
926         // indicates if fee should be deducted from transfer
927         bool takeFee = true;
928         
929         // if any account belongs to _isExcludedFromFee account then remove the fee
930         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
931             takeFee = false;
932         }
933         
934         // transfer amount, it will take tax, dev fee, liquidity fee
935         _tokenTransfer(from, to, amount, takeFee);
936 
937         _devFee = regularDevFee;
938         _devTax = regularDevTax;
939     }
940     
941     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
942         // balance token fees based on variable percents
943         uint256 totalRedirectTokenFee = _devFee.add(_liquidityFee);
944 
945         if (totalRedirectTokenFee == 0) return;
946         uint256 liquidityTokenBalance = contractTokenBalance.mul(_liquidityFee).div(totalRedirectTokenFee);
947         uint256 devTokenBalance = contractTokenBalance.mul(_devFee).div(totalRedirectTokenFee);
948         
949         // split the liquidity balance into halves
950         uint256 halfLiquidity = liquidityTokenBalance.div(2);
951         
952         // capture the contract's current ETH balance.
953         // this is so that we can capture exactly the amount of ETH that the
954         // swap creates, and not make the fee events include any ETH that
955         // has been manually sent to the contract
956         uint256 initialBalance = address(this).balance;
957         
958         if (liquidityTokenBalance == 0 && devTokenBalance == 0) return;
959         
960         // swap tokens for ETH
961         swapTokensForEth(devTokenBalance.add(halfLiquidity));
962         
963         uint256 newBalance = address(this).balance.sub(initialBalance);
964         
965         if(newBalance > 0) {
966             // rebalance ETH fees proportionally to half the liquidity
967             uint256 totalRedirectEthFee = _devFee.add(_liquidityFee.div(2));
968             uint256 liquidityEthBalance = newBalance.mul(_liquidityFee.div(2)).div(totalRedirectEthFee);
969             uint256 devEthBalance = newBalance.mul(_devFee).div(totalRedirectEthFee);
970 
971             //
972             // for liquidity
973             // add to uniswap
974             //
975     
976             addLiquidity(halfLiquidity, liquidityEthBalance);
977             
978             //
979             // for dev fee
980             // send to the dev address
981             //
982             
983             sendEthToDevAddress(devEthBalance);
984             
985             emit SwapAndLiquify(contractTokenBalance, liquidityEthBalance, devEthBalance);
986         }
987     } 
988     
989     function sendEthToDevAddress(uint256 amount) private {
990         if (amount > 0 && _devFee > 0) {
991             uint256 ethToDev = amount.mul(_devTax).div(_devFee);
992             uint256 ethToMarketing = amount.mul(_marketingTax).div(_devFee);
993             if (ethToDev > 0) _devWallet.transfer(ethToDev);
994             if (ethToMarketing > 0) _marketingWallet.transfer(ethToMarketing);
995         }
996     }
997 
998     function swapTokensForEth(uint256 tokenAmount) private {
999         // generate the uniswap pair path of token -> weth
1000         address[] memory path = new address[](2);
1001         path[0] = address(this);
1002         path[1] = uniswapV2Router.WETH();
1003 
1004         _approve(address(this), address(uniswapV2Router), tokenAmount);
1005 
1006         // make the swap
1007         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1008             tokenAmount,
1009             0, // accept any amount of ETH
1010             path,
1011             address(this),
1012             block.timestamp
1013         );
1014     }
1015 
1016     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1017         if (tokenAmount > 0 && ethAmount > 0) {
1018             // approve token transfer to cover all possible scenarios
1019             _approve(address(this), address(uniswapV2Router), tokenAmount);
1020 
1021             // add the liquidity
1022             uniswapV2Router.addLiquidityETH{value: ethAmount} (
1023                 address(this),
1024                 tokenAmount,
1025                 0, // slippage is unavoidable
1026                 0, // slippage is unavoidable
1027                 owner(),
1028                 block.timestamp
1029             );
1030         }
1031     }
1032 
1033     //this method is responsible for taking all fee, if takeFee is true
1034     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1035         if(!takeFee) {
1036             removeAllFee();
1037         }
1038         
1039         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1040             _transferFromExcluded(sender, recipient, amount);
1041         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1042             _transferToExcluded(sender, recipient, amount);
1043         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1044             _transferStandard(sender, recipient, amount);
1045         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1046             _transferBothExcluded(sender, recipient, amount);
1047         } else {
1048             _transferStandard(sender, recipient, amount);
1049         }
1050         
1051         if(!takeFee) {
1052             restoreAllFee();
1053         }
1054     }
1055 
1056     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1057         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1058         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1059         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1060         _takeLiquidity(tLiquidity);
1061         _takeDev(tDev);
1062         _reflectFee(rFee, tFee);
1063         emit Transfer(sender, recipient, tTransferAmount);
1064     }
1065 
1066     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1067         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1068         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1069         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1070         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1071         _takeLiquidity(tLiquidity);
1072         _takeDev(tDev);
1073         _reflectFee(rFee, tFee);
1074         emit Transfer(sender, recipient, tTransferAmount);
1075     }
1076 
1077     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1078         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1079         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1080         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1081         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1082         _takeLiquidity(tLiquidity);
1083         _takeDev(tDev);
1084         _reflectFee(rFee, tFee);
1085         emit Transfer(sender, recipient, tTransferAmount);
1086     }
1087 
1088     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1089         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1090         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1091         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1092         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1093         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1094         _takeLiquidity(tLiquidity);
1095         _takeDev(tDev);
1096         _reflectFee(rFee, tFee);
1097         emit Transfer(sender, recipient, tTransferAmount);
1098     }
1099 
1100     function _reflectFee(uint256 rFee, uint256 tFee) private {
1101         _rTotal = _rTotal.sub(rFee);
1102         _tFeeTotal = _tFeeTotal.add(tFee);
1103     }
1104 
1105     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1106         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getTValues(tAmount);
1107         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tLiquidity, _getRate());
1108         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tDev, tLiquidity);
1109     }
1110 
1111     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1112         uint256 tFee = calculateTaxFee(tAmount);
1113         uint256 tDev = calculateDevFee(tAmount);
1114         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1115         uint256 tTransferAmount = tAmount.sub(tFee).sub(tDev).sub(tLiquidity);
1116         return (tTransferAmount, tFee, tDev, tLiquidity);
1117     }
1118 
1119     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1120         uint256 rAmount = tAmount.mul(currentRate);
1121         uint256 rFee = tFee.mul(currentRate);
1122         uint256 rDev = tDev.mul(currentRate);
1123         uint256 rLiquidity = tLiquidity.mul(currentRate);
1124         uint256 rTransferAmount = rAmount.sub(rFee).sub(rDev).sub(rLiquidity);
1125         return (rAmount, rTransferAmount, rFee);
1126     }
1127 
1128     function _getRate() private view returns(uint256) {
1129         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1130         return rSupply.div(tSupply);
1131     }
1132 
1133     function _getCurrentSupply() private view returns(uint256, uint256) {
1134         uint256 rSupply = _rTotal;
1135         uint256 tSupply = _tTotal;      
1136         for (uint256 i = 0; i < _excluded.length; i++) {
1137             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1138             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1139             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1140         }
1141         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1142         return (rSupply, tSupply);
1143     }
1144     
1145     function _takeLiquidity(uint256 tLiquidity) private {
1146         uint256 currentRate =  _getRate();
1147         uint256 rLiquidity = tLiquidity.mul(currentRate);
1148         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1149         if(_isExcluded[address(this)]) {
1150             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1151         }
1152     }
1153     
1154     function _takeDev(uint256 tDev) private {
1155         uint256 currentRate =  _getRate();
1156         uint256 rDev = tDev.mul(currentRate);
1157         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1158         if(_isExcluded[address(this)]) {
1159             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1160         }
1161     }
1162     
1163     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1164         return _amount.mul(_taxFee).div(1000);
1165     }
1166 
1167     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1168         return _amount.mul(_devFee).div(1000);
1169     }
1170 
1171     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1172         return _amount.mul(_liquidityFee).div(1000);
1173     }
1174     
1175     function removeAllFee() private {
1176         if(_taxFee == 0 && _devFee == 0 && _liquidityFee == 0 && launchSellFee == 0) return;
1177         
1178         _previousTaxFee = _taxFee;
1179         _previousDevFee = _devFee;
1180         _previousLiquidityFee = _liquidityFee;
1181         _previousLaunchSellFee = launchSellFee;
1182         
1183         _taxFee = 0;
1184         _devFee = 0;
1185         _liquidityFee = 0;
1186         launchSellFee = 0;
1187     }
1188     
1189     function restoreAllFee() private {
1190         _taxFee = _previousTaxFee;
1191         _devFee = _previousDevFee;
1192         _liquidityFee = _previousLiquidityFee;
1193         launchSellFee = _previousLaunchSellFee;
1194     }
1195     
1196     function manualSwap() external onlyOwner() {
1197         uint256 contractBalance = balanceOf(address(this));
1198         swapTokensForEth(contractBalance);
1199     }
1200 
1201     function manualSend() external onlyOwner() {
1202         uint256 contractEthBalance = address(this).balance;
1203         sendEthToDevAddress(contractEthBalance);
1204     }
1205     
1206     function isExcludedFromFee(address account) external view returns(bool) {
1207         return _isExcludedFromFee[account];
1208     }
1209     
1210     function excludeFromFee(address account) external onlyOwner {
1211         _isExcludedFromFee[account] = true;
1212     }
1213     
1214     function includeInFee(address account) external onlyOwner {
1215         _isExcludedFromFee[account] = false;
1216     }
1217 
1218     // for 0.5% input 5, for 1% input 10
1219     function setMaxTxPercent(uint256 newMaxTx) external onlyOwner {
1220         require(newMaxTx >= 5, "Max TX should be above 0.5%");
1221         maxTxAmount = _tTotal.mul(newMaxTx).div(1000);
1222     }
1223     
1224     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1225          require(taxFee <= 80, "Maximum fee limit is 8 percent");
1226         _taxFee = taxFee;
1227     }
1228     
1229     function setDevFeePercent(uint256 devFee, uint256 devTax, uint256 marketingTax) external onlyOwner() {
1230          require(devFee <= 100, "Maximum fee limit is 10 percent");
1231          require(devTax + marketingTax == devFee, "Dev + marketing must equal total fee");
1232         _devFee = devFee;
1233         _devTax = devTax;
1234         _marketingTax = marketingTax;
1235     }
1236     
1237     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1238         require(liquidityFee <= 80, "Maximum fee limit is 8 percent");
1239         _liquidityFee = liquidityFee;
1240     }
1241 
1242     function setLaunchSellFee(uint256 newLaunchSellFee) external onlyOwner {
1243         require(newLaunchSellFee <= 250, "Maximum launch sell fee is 25%");
1244         launchSellFee = newLaunchSellFee;
1245     }
1246 
1247     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1248         swapAndLiquifyEnabled = _enabled;
1249         emit SwapAndLiquifyEnabledUpdated(_enabled);
1250     }
1251 
1252     function setMinTokensBeforeSwap(uint256 minTokens) external onlyOwner {
1253         minTokensBeforeSwap = minTokens * 10**9;
1254         emit MinTokensBeforeSwapUpdated(minTokens);
1255     }
1256     
1257     // to receive ETH from uniswapV2Router when swaping
1258     receive() external payable {}
1259 }