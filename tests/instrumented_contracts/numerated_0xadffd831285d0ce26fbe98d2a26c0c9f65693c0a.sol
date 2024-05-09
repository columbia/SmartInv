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
661 contract RLDX is Context, IERC20, Ownable {
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
675     uint256 private _tTotal = 100000000 * 10**9;
676     uint256 private _rTotal = (MAX - (MAX % _tTotal));
677     uint256 private _tFeeTotal;
678 
679     string private _name = "RLDX";
680     string private _symbol = "RLDX";
681     uint8 private _decimals = 9;
682     
683     uint256 public _taxFee = 0;
684     uint256 private _previousTaxFee = _taxFee;
685 
686     uint256 public _devFee = 675;
687     uint256 private _devTax = 300;
688     uint256 private _marketingTax = 300;
689     uint256 private _platformTax = 75;
690     uint256 private _previousDevFee = _devFee;
691     
692     uint256 public _liquidityFee = 125;
693     uint256 private _previousLiquidityFee = _liquidityFee;
694 
695     uint256 public launchSellFee = 1200;
696     uint256 private _previousLaunchSellFee = launchSellFee;
697 
698     uint256 public maxTxAmount = _tTotal.mul(5).div(1000); // 0.5%
699     address payable private _devWallet = payable(0xAEe7a4584a6629460B78D0a9eF56055e47E1425b);
700     address payable private _marketingWallet = payable(0xf154F43A4E9D53bD985C0CFBA23E24A4d83E0613);
701     address payable private _platformWallet = payable(0x70Ab96387335938E6fCe606625552AD3CA41f19E);
702 
703     uint256 public launchSellFeeDeadline = 0;
704 
705     IUniswapV2Router02 public uniswapV2Router;
706     address public uniswapV2Pair;
707     
708     bool inSwapAndLiquify;
709     bool public swapAndLiquifyEnabled = true;
710     uint256 private minTokensBeforeSwap = 100000 * 10**9;
711     
712     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
713     event SwapAndLiquifyEnabledUpdated(bool enabled);
714     event SwapAndLiquify(
715         uint256 tokensSwapped,
716         uint256 liquidityEthBalance,
717         uint256 devEthBalance
718     );
719     
720     modifier lockTheSwap {
721         inSwapAndLiquify = true;
722          _;
723         inSwapAndLiquify = false;
724     }
725     
726     constructor () public {
727         _rOwned[_msgSender()] = _rTotal;
728         
729         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
730          // Create a uniswap pair for this new token
731         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
732             .createPair(address(this), _uniswapV2Router.WETH());
733 
734         // set the rest of the contract variables
735         uniswapV2Router = _uniswapV2Router;
736         
737         //exclude owner and this contract from fee
738         _isExcludedFromFee[owner()] = true;
739         _isExcludedFromFee[address(this)] = true;
740 
741         // internal exclude from max tx
742         _isExcludedFromMaxTx[owner()] = true;
743         _isExcludedFromMaxTx[address(this)] = true;
744 
745         // launch sell fee
746         launchSellFeeDeadline = now + 2 days;
747         
748         emit Transfer(address(0), _msgSender(), _tTotal);
749     }
750 
751     function setRouterAddress(address newRouter) public onlyOwner() {
752         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
753         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
754         uniswapV2Router = _newUniswapRouter;
755     }
756 
757     function name() public view returns (string memory) {
758         return _name;
759     }
760 
761     function symbol() public view returns (string memory) {
762         return _symbol;
763     }
764 
765     function decimals() public view returns (uint8) {
766         return _decimals;
767     }
768 
769     function totalSupply() public view override returns (uint256) {
770         return _tTotal;
771     }
772 
773     function balanceOf(address account) public view override returns (uint256) {
774         if (_isExcluded[account]) return _tOwned[account];
775         return tokenFromReflection(_rOwned[account]);
776     }
777 
778     function transfer(address recipient, uint256 amount) public override returns (bool) {
779         _transfer(_msgSender(), recipient, amount);
780         return true;
781     }
782 
783     function allowance(address owner, address spender) public view override returns (uint256) {
784         return _allowances[owner][spender];
785     }
786 
787     function approve(address spender, uint256 amount) public override returns (bool) {
788         _approve(_msgSender(), spender, amount);
789         return true;
790     }
791 
792     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
793         _transfer(sender, recipient, amount);
794         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
795         return true;
796     }
797 
798     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
799         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
800         return true;
801     }
802 
803     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
804         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
805         return true;
806     }
807 
808     function isExcludedFromReward(address account) public view returns (bool) {
809         return _isExcluded[account];
810     }
811 
812     function totalFees() public view returns (uint256) {
813         return _tFeeTotal;
814     }
815 
816     function deliver(uint256 tAmount) public {
817         address sender = _msgSender();
818         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
819         (uint256 rAmount,,,,,,) = _getValues(tAmount);
820         _rOwned[sender] = _rOwned[sender].sub(rAmount);
821         _rTotal = _rTotal.sub(rAmount);
822         _tFeeTotal = _tFeeTotal.add(tAmount);
823     }
824 
825     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
826         require(tAmount <= _tTotal, "Amount must be less than supply");
827         if (!deductTransferFee) {
828             (uint256 rAmount,,,,,,) = _getValues(tAmount);
829             return rAmount;
830         } else {
831             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
832             return rTransferAmount;
833         }
834     }
835 
836     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
837         require(rAmount <= _rTotal, "Amount must be less than total reflections");
838         uint256 currentRate =  _getRate();
839         return rAmount.div(currentRate);
840     }
841 
842     function excludeFromReward(address account) public onlyOwner() {
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
864     function _approve(address owner, address spender, uint256 amount) private {
865         require(owner != address(0));
866         require(spender != address(0));
867 
868         _allowances[owner][spender] = amount;
869         emit Approval(owner, spender, amount);
870     }
871     
872     function expectedRewards(address _sender) external view returns(uint256){
873         uint256 _balance = address(this).balance;
874         address sender = _sender;
875         uint256 holdersBal = balanceOf(sender);
876         uint totalExcludedBal;
877         for (uint256 i = 0; i < _excluded.length; i++){
878             totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
879         }
880         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(uniswapV2Pair)).sub(totalExcludedBal));
881         return rewards;
882     }
883     
884     function _transfer(
885         address from,
886         address to,
887         uint256 amount
888     ) private {
889         require(from != address(0), "ERC20: transfer from the zero address");
890         require(to != address(0), "ERC20: transfer to the zero address");
891         require(amount > 0, "Transfer amount must be greater than zero");
892         
893         if (
894             !_isExcludedFromMaxTx[from] &&
895             !_isExcludedFromMaxTx[to] // by default false
896         ) {
897             require(
898                 amount <= maxTxAmount,
899                 "Transfer amount exceeds the maxTxAmount."
900             );
901         }
902 
903         // initial sell fee
904         uint256 regularDevFee = _devFee;
905         uint256 regularDevTax = _devTax;
906         if (launchSellFeeDeadline >= now && to == uniswapV2Pair) {
907             _devFee = _devFee.add(launchSellFee);
908             _devTax = _devTax.add(launchSellFee);
909         }
910 
911         // is the token balance of this contract address over the min number of
912         // tokens that we need to initiate a swap + liquidity lock?
913         // also, don't get caught in a circular liquidity event.
914         // also, don't swap & liquify if sender is uniswap pair.
915         uint256 contractTokenBalance = balanceOf(address(this));
916         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
917         if (
918             overMinTokenBalance &&
919             !inSwapAndLiquify &&
920             from != uniswapV2Pair &&
921             swapAndLiquifyEnabled
922         ) {
923             // add liquidity
924             uint256 tokensToSell = maxTxAmount > contractTokenBalance ? contractTokenBalance : maxTxAmount;
925             swapAndLiquify(tokensToSell);
926         }
927         
928         // indicates if fee should be deducted from transfer
929         bool takeFee = true;
930         
931         // if any account belongs to _isExcludedFromFee account then remove the fee
932         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
933             takeFee = false;
934         }
935         
936         // transfer amount, it will take tax, dev fee, liquidity fee
937         _tokenTransfer(from, to, amount, takeFee);
938 
939         _devFee = regularDevFee;
940         _devTax = regularDevTax;
941     }
942     
943     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
944         // balance token fees based on variable percents
945         uint256 totalRedirectTokenFee = _devFee.add(_liquidityFee);
946 
947         if (totalRedirectTokenFee == 0) return;
948         uint256 liquidityTokenBalance = contractTokenBalance.mul(_liquidityFee).div(totalRedirectTokenFee);
949         uint256 devTokenBalance = contractTokenBalance.mul(_devFee).div(totalRedirectTokenFee);
950         
951         // split the liquidity balance into halves
952         uint256 halfLiquidity = liquidityTokenBalance.div(2);
953         
954         // capture the contract's current ETH balance.
955         // this is so that we can capture exactly the amount of ETH that the
956         // swap creates, and not make the fee events include any ETH that
957         // has been manually sent to the contract
958         uint256 initialBalance = address(this).balance;
959         
960         if (liquidityTokenBalance == 0 && devTokenBalance == 0) return;
961         
962         // swap tokens for ETH
963         swapTokensForEth(devTokenBalance.add(halfLiquidity));
964         
965         uint256 newBalance = address(this).balance.sub(initialBalance);
966         
967         if(newBalance > 0) {
968             // rebalance ETH fees proportionally to half the liquidity
969             uint256 totalRedirectEthFee = _devFee.add(_liquidityFee.div(2));
970             uint256 liquidityEthBalance = newBalance.mul(_liquidityFee.div(2)).div(totalRedirectEthFee);
971             uint256 devEthBalance = newBalance.mul(_devFee).div(totalRedirectEthFee);
972 
973             //
974             // for liquidity
975             // add to uniswap
976             //
977     
978             addLiquidity(halfLiquidity, liquidityEthBalance);
979             
980             //
981             // for dev fee
982             // send to the dev address
983             //
984             
985             sendEthToDevAddress(devEthBalance);
986             
987             emit SwapAndLiquify(contractTokenBalance, liquidityEthBalance, devEthBalance);
988         }
989     } 
990     
991     function sendEthToDevAddress(uint256 amount) private {
992         if (amount > 0 && _devFee > 0) {
993             uint256 ethToDev = amount.mul(_devTax).div(_devFee);
994             uint256 ethToMarketing = amount.mul(_marketingTax).div(_devFee);
995             uint256 ethToPlatform = amount.mul(_platformTax).div(_devFee);
996             if (ethToDev > 0) _devWallet.transfer(ethToDev);
997             if (ethToMarketing > 0) _marketingWallet.transfer(ethToMarketing);
998             if (ethToPlatform > 0) _platformWallet.transfer(ethToPlatform);
999         }
1000     }
1001 
1002     function swapTokensForEth(uint256 tokenAmount) private {
1003         // generate the uniswap pair path of token -> weth
1004         address[] memory path = new address[](2);
1005         path[0] = address(this);
1006         path[1] = uniswapV2Router.WETH();
1007 
1008         _approve(address(this), address(uniswapV2Router), tokenAmount);
1009 
1010         // make the swap
1011         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1012             tokenAmount,
1013             0, // accept any amount of ETH
1014             path,
1015             address(this),
1016             block.timestamp
1017         );
1018     }
1019 
1020     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1021         if (tokenAmount > 0 && ethAmount > 0) {
1022             // approve token transfer to cover all possible scenarios
1023             _approve(address(this), address(uniswapV2Router), tokenAmount);
1024 
1025             // add the liquidity
1026             uniswapV2Router.addLiquidityETH{value: ethAmount} (
1027                 address(this),
1028                 tokenAmount,
1029                 0, // slippage is unavoidable
1030                 0, // slippage is unavoidable
1031                 owner(),
1032                 block.timestamp
1033             );
1034         }
1035     }
1036 
1037     //this method is responsible for taking all fee, if takeFee is true
1038     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1039         if(!takeFee) {
1040             removeAllFee();
1041         }
1042         
1043         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1044             _transferFromExcluded(sender, recipient, amount);
1045         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1046             _transferToExcluded(sender, recipient, amount);
1047         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1048             _transferStandard(sender, recipient, amount);
1049         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1050             _transferBothExcluded(sender, recipient, amount);
1051         } else {
1052             _transferStandard(sender, recipient, amount);
1053         }
1054         
1055         if(!takeFee) {
1056             restoreAllFee();
1057         }
1058     }
1059 
1060     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1061         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1062         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1063         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1064         _takeLiquidity(tLiquidity);
1065         _takeDev(tDev);
1066         _reflectFee(rFee, tFee);
1067         emit Transfer(sender, recipient, tTransferAmount);
1068     }
1069 
1070     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1071         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1072         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1073         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1074         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1075         _takeLiquidity(tLiquidity);
1076         _takeDev(tDev);
1077         _reflectFee(rFee, tFee);
1078         emit Transfer(sender, recipient, tTransferAmount);
1079     }
1080 
1081     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1082         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1083         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1084         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1085         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1086         _takeLiquidity(tLiquidity);
1087         _takeDev(tDev);
1088         _reflectFee(rFee, tFee);
1089         emit Transfer(sender, recipient, tTransferAmount);
1090     }
1091 
1092     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1093         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1094         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1095         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1096         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1097         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1098         _takeLiquidity(tLiquidity);
1099         _takeDev(tDev);
1100         _reflectFee(rFee, tFee);
1101         emit Transfer(sender, recipient, tTransferAmount);
1102     }
1103 
1104     function _reflectFee(uint256 rFee, uint256 tFee) private {
1105         _rTotal = _rTotal.sub(rFee);
1106         _tFeeTotal = _tFeeTotal.add(tFee);
1107     }
1108 
1109     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1110         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getTValues(tAmount);
1111         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tLiquidity, _getRate());
1112         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tDev, tLiquidity);
1113     }
1114 
1115     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1116         uint256 tFee = calculateTaxFee(tAmount);
1117         uint256 tDev = calculateDevFee(tAmount);
1118         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1119         uint256 tTransferAmount = tAmount.sub(tFee).sub(tDev).sub(tLiquidity);
1120         return (tTransferAmount, tFee, tDev, tLiquidity);
1121     }
1122 
1123     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1124         uint256 rAmount = tAmount.mul(currentRate);
1125         uint256 rFee = tFee.mul(currentRate);
1126         uint256 rDev = tDev.mul(currentRate);
1127         uint256 rLiquidity = tLiquidity.mul(currentRate);
1128         uint256 rTransferAmount = rAmount.sub(rFee).sub(rDev).sub(rLiquidity);
1129         return (rAmount, rTransferAmount, rFee);
1130     }
1131 
1132     function _getRate() private view returns(uint256) {
1133         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1134         return rSupply.div(tSupply);
1135     }
1136 
1137     function _getCurrentSupply() private view returns(uint256, uint256) {
1138         uint256 rSupply = _rTotal;
1139         uint256 tSupply = _tTotal;      
1140         for (uint256 i = 0; i < _excluded.length; i++) {
1141             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1142             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1143             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1144         }
1145         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1146         return (rSupply, tSupply);
1147     }
1148     
1149     function _takeLiquidity(uint256 tLiquidity) private {
1150         uint256 currentRate =  _getRate();
1151         uint256 rLiquidity = tLiquidity.mul(currentRate);
1152         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1153         if(_isExcluded[address(this)]) {
1154             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1155         }
1156     }
1157     
1158     function _takeDev(uint256 tDev) private {
1159         uint256 currentRate =  _getRate();
1160         uint256 rDev = tDev.mul(currentRate);
1161         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1162         if(_isExcluded[address(this)]) {
1163             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1164         }
1165     }
1166     
1167     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1168         return _amount.mul(_taxFee).div(10000);
1169     }
1170 
1171     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1172         return _amount.mul(_devFee).div(10000);
1173     }
1174 
1175     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1176         return _amount.mul(_liquidityFee).div(10000);
1177     }
1178     
1179     function removeAllFee() private {
1180         if(_taxFee == 0 && _devFee == 0 && _liquidityFee == 0 && launchSellFee == 0) return;
1181         
1182         _previousTaxFee = _taxFee;
1183         _previousDevFee = _devFee;
1184         _previousLiquidityFee = _liquidityFee;
1185         _previousLaunchSellFee = launchSellFee;
1186         
1187         _taxFee = 0;
1188         _devFee = 0;
1189         _liquidityFee = 0;
1190         launchSellFee = 0;
1191     }
1192     
1193     function restoreAllFee() private {
1194         _taxFee = _previousTaxFee;
1195         _devFee = _previousDevFee;
1196         _liquidityFee = _previousLiquidityFee;
1197         launchSellFee = _previousLaunchSellFee;
1198     }
1199     
1200     function manualSwap() external onlyOwner() {
1201         uint256 contractBalance = balanceOf(address(this));
1202         swapTokensForEth(contractBalance);
1203     }
1204 
1205     function manualSend() external onlyOwner() {
1206         uint256 contractEthBalance = address(this).balance;
1207         sendEthToDevAddress(contractEthBalance);
1208     }
1209     
1210     function isExcludedFromFee(address account) external view returns(bool) {
1211         return _isExcludedFromFee[account];
1212     }
1213     
1214     function excludeFromFee(address account) external onlyOwner {
1215         _isExcludedFromFee[account] = true;
1216     }
1217     
1218     function includeInFee(address account) external onlyOwner {
1219         _isExcludedFromFee[account] = false;
1220     }
1221 
1222     // for 0.5% input 5, for 1% input 10
1223     function setMaxTxPercent(uint256 newMaxTx) external onlyOwner {
1224         require(newMaxTx >= 5, "Max TX should be above 0.5%");
1225         maxTxAmount = _tTotal.mul(newMaxTx).div(1000);
1226     }
1227     
1228     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1229          require(taxFee <= 800, "Maximum fee limit is 8 percent");
1230         _taxFee = taxFee;
1231     }
1232     
1233     function setDevFeePercent(uint256 devFee, uint256 devTax, uint256 marketingTax) external onlyOwner() {
1234          require(devFee <= 1500, "Maximum fee limit is 15 percent");
1235          require(devTax + marketingTax == devFee, "Dev + marketing must equal total fee");
1236         _devFee = devFee + _platformTax;
1237         _devTax = devTax;
1238         _marketingTax = marketingTax;
1239     }
1240     
1241     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1242         require(liquidityFee <= 800, "Maximum fee limit is 8 percent");
1243         _liquidityFee = liquidityFee;
1244     }
1245 
1246     function setLaunchSellFee(uint256 newLaunchSellFee) external onlyOwner {
1247         require(newLaunchSellFee <= 2500, "Maximum launch sell fee is 25%");
1248         launchSellFee = newLaunchSellFee;
1249     }
1250 
1251     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1252         swapAndLiquifyEnabled = _enabled;
1253         emit SwapAndLiquifyEnabledUpdated(_enabled);
1254     }
1255 
1256     function setMinTokensBeforeSwap(uint256 minTokens) external onlyOwner {
1257         minTokensBeforeSwap = minTokens * 10**9;
1258         emit MinTokensBeforeSwapUpdated(minTokens);
1259     }
1260     
1261     // to receive ETH from uniswapV2Router when swaping
1262     receive() external payable {}
1263 }