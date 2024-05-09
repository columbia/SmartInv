1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-02
3 */
4 
5 //SPDX-License-Identifier: MIT
6 pragma solidity ^0.6.12;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109  
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
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
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
276         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
277         // for accounts without code, i.e. `keccak256('')`
278         bytes32 codehash;
279         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { codehash := extcodehash(account) }
282         return (codehash != accountHash && codehash != 0x0);
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 /**
392  * @dev Contract module which provides a basic access control mechanism, where
393  * there is an account (an owner) that can be granted exclusive access to
394  * specific functions.
395  *
396  * By default, the owner account will be the one that deploys the contract. This
397  * can later be changed with {transferOwnership}.
398  *
399  * This module is used through inheritance. It will make available the modifier
400  * `onlyOwner`, which can be applied to your functions to restrict their use to
401  * the owner.
402  */
403 contract Ownable is Context {
404     address private _owner;
405 
406     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
407 
408     /**
409      * @dev Initializes the contract setting the deployer as the initial owner.
410      */
411     constructor () internal {
412         address msgSender = _msgSender();
413         _owner = _msgSender();
414         emit OwnershipTransferred(address(0), msgSender);
415     }
416 
417     /**
418      * @dev Returns the address of the current owner.
419      */
420     function owner() public view returns (address) {
421         return _owner;
422     }
423 
424     /**
425      * @dev Throws if called by any account other than the owner.
426      */
427     modifier onlyOwner() {
428         require(_owner == _msgSender(), "Ownable: caller is not the owner");
429         _;
430     }
431 
432      /**
433      * @dev Leaves the contract without owner. It will not be possible to call
434      * `onlyOwner` functions anymore. Can only be called by the current owner.
435      *
436      * NOTE: Renouncing ownership will leave the contract without an owner,
437      * thereby removing any functionality that is only available to the owner.
438      */
439     function renounceOwnership() public virtual onlyOwner {
440         emit OwnershipTransferred(_owner, address(0));
441         _owner = address(0);
442     }
443 
444     /**
445      * @dev Transfers ownership of the contract to a new account (`newOwner`).
446      * Can only be called by the current owner.
447      */
448     function transferOwnership(address newOwner) public virtual onlyOwner {
449         require(newOwner != address(0), "Ownable: new owner is the zero address");
450         emit OwnershipTransferred(_owner, newOwner);
451         _owner = newOwner;
452     }
453 }
454 
455 // pragma solidity >=0.5.0;
456 
457 interface IUniswapV2Factory {
458     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
459 
460     function feeTo() external view returns (address);
461     function feeToSetter() external view returns (address);
462 
463     function getPair(address tokenA, address tokenB) external view returns (address pair);
464     function allPairs(uint) external view returns (address pair);
465     function allPairsLength() external view returns (uint);
466 
467     function createPair(address tokenA, address tokenB) external returns (address pair);
468 
469     function setFeeTo(address) external;
470     function setFeeToSetter(address) external;
471 }
472 
473 // pragma solidity >=0.5.0;
474 
475 interface IUniswapV2Pair {
476     event Approval(address indexed owner, address indexed spender, uint value);
477     event Transfer(address indexed from, address indexed to, uint value);
478 
479     function name() external pure returns (string memory);
480     function symbol() external pure returns (string memory);
481     function decimals() external pure returns (uint8);
482     function totalSupply() external view returns (uint);
483     function balanceOf(address owner) external view returns (uint);
484     function allowance(address owner, address spender) external view returns (uint);
485 
486     function approve(address spender, uint value) external returns (bool);
487     function transfer(address to, uint value) external returns (bool);
488     function transferFrom(address from, address to, uint value) external returns (bool);
489 
490     function DOMAIN_SEPARATOR() external view returns (bytes32);
491     function PERMIT_TYPEHASH() external pure returns (bytes32);
492     function nonces(address owner) external view returns (uint);
493 
494     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
495 
496     event Mint(address indexed sender, uint amount0, uint amount1);
497     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
498     event Swap(
499         address indexed sender,
500         uint amount0In,
501         uint amount1In,
502         uint amount0Out,
503         uint amount1Out,
504         address indexed to
505     );
506     event Sync(uint112 reserve0, uint112 reserve1);
507 
508     function MINIMUM_LIQUIDITY() external pure returns (uint);
509     function factory() external view returns (address);
510     function token0() external view returns (address);
511     function token1() external view returns (address);
512     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
513     function price0CumulativeLast() external view returns (uint);
514     function price1CumulativeLast() external view returns (uint);
515     function kLast() external view returns (uint);
516 
517     function mint(address to) external returns (uint liquidity);
518     function burn(address to) external returns (uint amount0, uint amount1);
519     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
520     function skim(address to) external;
521     function sync() external;
522 
523     function initialize(address, address) external;
524 }
525 
526 // pragma solidity >=0.6.2;
527 
528 interface IUniswapV2Router {
529     function factory() external pure returns (address);
530     function WETH() external pure returns (address);
531 
532     function addLiquidity(
533         address tokenA,
534         address tokenB,
535         uint amountADesired,
536         uint amountBDesired,
537         uint amountAMin,
538         uint amountBMin,
539         address to,
540         uint deadline
541     ) external returns (uint amountA, uint amountB, uint liquidity);
542     function addLiquidityETH(
543         address token,
544         uint amountTokenDesired,
545         uint amountTokenMin,
546         uint amountETHMin,
547         address to,
548         uint deadline
549     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
550     function removeLiquidity(
551         address tokenA,
552         address tokenB,
553         uint liquidity,
554         uint amountAMin,
555         uint amountBMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountA, uint amountB);
559     function removeLiquidityETH(
560         address token,
561         uint liquidity,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline
566     ) external returns (uint amountToken, uint amountETH);
567     function removeLiquidityWithPermit(
568         address tokenA,
569         address tokenB,
570         uint liquidity,
571         uint amountAMin,
572         uint amountBMin,
573         address to,
574         uint deadline,
575         bool approveMax, uint8 v, bytes32 r, bytes32 s
576     ) external returns (uint amountA, uint amountB);
577     function removeLiquidityETHWithPermit(
578         address token,
579         uint liquidity,
580         uint amountTokenMin,
581         uint amountETHMin,
582         address to,
583         uint deadline,
584         bool approveMax, uint8 v, bytes32 r, bytes32 s
585     ) external returns (uint amountToken, uint amountETH);
586     function swapExactTokensForTokens(
587         uint amountIn,
588         uint amountOutMin,
589         address[] calldata path,
590         address to,
591         uint deadline
592     ) external returns (uint[] memory amounts);
593     function swapTokensForExactTokens(
594         uint amountOut,
595         uint amountInMax,
596         address[] calldata path,
597         address to,
598         uint deadline
599     ) external returns (uint[] memory amounts);
600     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
601         external
602         payable
603         returns (uint[] memory amounts);
604     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
605         external
606         returns (uint[] memory amounts);
607     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
608         external
609         returns (uint[] memory amounts);
610     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
611         external
612         payable
613         returns (uint[] memory amounts);
614 
615     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
616     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
617     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
618     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
619     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
620 }
621 
622 // pragma solidity >=0.6.2;
623 
624 interface IUniswapV2Router02 is IUniswapV2Router {
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
665 contract Connective is Context, IERC20, Ownable {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     mapping (address => uint256) private _rOwned;
670     mapping (address => uint256) private _tOwned;
671     mapping (address => mapping (address => uint256)) private _allowances;
672     mapping (address => bool) private _isExcludedFromFee;
673     mapping(address => bool) private _isExcludedFromMaxTx;
674 
675     mapping (address => bool) private _isExcluded;
676     address[] private _excluded;
677    
678     uint256 private constant MAX = ~uint256(0);
679     uint256 private _tTotal = 100000000000 * 10**9;
680     uint256 private _rTotal = (MAX - (MAX % _tTotal));
681     uint256 private _tFeeTotal;
682 
683     string private _name = "Connective";
684     string private _symbol = "Connect";
685     uint8 private _decimals = 9;
686     
687     uint256 public _taxFee = 0;
688     uint256 private _previousTaxFee = _taxFee;
689 
690     uint256 public _devFee = 475;
691     uint256 private _devTax = 200;
692     uint256 private _marketingTax = 200;
693     uint256 private _platformTax = 75;
694     uint256 private _previousDevFee = _devFee;
695     
696     uint256 public _liquidityFee = 100;
697     uint256 private _previousLiquidityFee = _liquidityFee;
698 
699     uint256 public launchSellFee = 1900;
700     uint256 private _previousLaunchSellFee = launchSellFee;
701 
702     uint256 public maxTxAmount = _tTotal.mul(5).div(1000); // 0.5%
703     address payable private _devWallet = payable(0xDEA8909f747aCD55CaE130b2684A86f3E84EdB63);
704     address payable private _marketingWallet = payable(0x613be1E5F840355016b4dc81e7C12c966c730e28);
705     address payable private _platformWallet = payable(0x89e65aa948e71eFFa2eFC732C70e6BC036073b5E);
706 
707     uint256 public launchSellFeeDeadline = 0;
708 
709     IUniswapV2Router02 public uniswapV2Router;
710     address public uniswapV2Pair;
711     
712     bool inSwapAndLiquify;
713     bool public swapAndLiquifyEnabled = true;
714     uint256 private minTokensBeforeSwap = 1000000 * 10**9;
715     
716     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
717     event SwapAndLiquifyEnabledUpdated(bool enabled);
718     event SwapAndLiquify(
719         uint256 tokensSwapped,
720         uint256 liquidityEthBalance,
721         uint256 devEthBalance
722     );
723     
724     modifier lockTheSwap {
725         inSwapAndLiquify = true;
726          _;
727         inSwapAndLiquify = false;
728     }
729     
730     constructor () public {
731         _rOwned[_msgSender()] = _rTotal;
732         
733         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
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
745         // internal exclude from max tx
746         _isExcludedFromMaxTx[owner()] = true;
747         _isExcludedFromMaxTx[address(this)] = true;
748 
749         // launch sell fee
750         launchSellFeeDeadline = now + 1 days;
751         
752         emit Transfer(address(0), _msgSender(), _tTotal);
753     }
754 
755     function setRouterAddress(address newRouter) public onlyOwner() {
756         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
757         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
758         uniswapV2Router = _newUniswapRouter;
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
823         (uint256 rAmount,,,,,,) = _getValues(tAmount);
824         _rOwned[sender] = _rOwned[sender].sub(rAmount);
825         _rTotal = _rTotal.sub(rAmount);
826         _tFeeTotal = _tFeeTotal.add(tAmount);
827     }
828 
829     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
830         require(tAmount <= _tTotal, "Amount must be less than supply");
831         if (!deductTransferFee) {
832             (uint256 rAmount,,,,,,) = _getValues(tAmount);
833             return rAmount;
834         } else {
835             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
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
847         require(!_isExcluded[account], "Account is already excluded");
848         if(_rOwned[account] > 0) {
849             _tOwned[account] = tokenFromReflection(_rOwned[account]);
850         }
851         _isExcluded[account] = true;
852         _excluded.push(account);
853     }
854 
855     function includeInReward(address account) external onlyOwner() {
856         require(_isExcluded[account], "Account is already excluded");
857         for (uint256 i = 0; i < _excluded.length; i++) {
858             if (_excluded[i] == account) {
859                 _excluded[i] = _excluded[_excluded.length - 1];
860                 _tOwned[account] = 0;
861                 _isExcluded[account] = false;
862                 _excluded.pop();
863                 break;
864             }
865         }
866     }
867     
868     function _approve(address owner, address spender, uint256 amount) private {
869         require(owner != address(0));
870         require(spender != address(0));
871 
872         _allowances[owner][spender] = amount;
873         emit Approval(owner, spender, amount);
874     }
875     
876     function expectedRewards(address _sender) external view returns(uint256){
877         uint256 _balance = address(this).balance;
878         address sender = _sender;
879         uint256 holdersBal = balanceOf(sender);
880         uint totalExcludedBal;
881         for (uint256 i = 0; i < _excluded.length; i++){
882             totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);   
883         }
884         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(uniswapV2Pair)).sub(totalExcludedBal));
885         return rewards;
886     }
887     
888     function _transfer(
889         address from,
890         address to,
891         uint256 amount
892     ) private {
893         require(from != address(0), "ERC20: transfer from the zero address");
894         require(to != address(0), "ERC20: transfer to the zero address");
895         require(amount > 0, "Transfer amount must be greater than zero");
896         
897         if (
898             !_isExcludedFromMaxTx[from] &&
899             !_isExcludedFromMaxTx[to] // by default false
900         ) {
901             require(
902                 amount <= maxTxAmount,
903                 "Transfer amount exceeds the maxTxAmount."
904             );
905         }
906 
907         // initial sell fee
908         uint256 regularDevFee = _devFee;
909         uint256 regularDevTax = _devTax;
910         if (launchSellFeeDeadline >= now && to == uniswapV2Pair) {
911             _devFee = _devFee.add(launchSellFee);
912             _devTax = _devTax.add(launchSellFee);
913         }
914 
915         // is the token balance of this contract address over the min number of
916         // tokens that we need to initiate a swap + liquidity lock?
917         // also, don't get caught in a circular liquidity event.
918         // also, don't swap & liquify if sender is uniswap pair.
919         uint256 contractTokenBalance = balanceOf(address(this));
920         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
921         if (
922             overMinTokenBalance &&
923             !inSwapAndLiquify &&
924             from != uniswapV2Pair &&
925             swapAndLiquifyEnabled
926         ) {
927             // add liquidity
928             uint256 tokensToSell = maxTxAmount > contractTokenBalance ? contractTokenBalance : maxTxAmount;
929             swapAndLiquify(tokensToSell);
930         }
931         
932         // indicates if fee should be deducted from transfer
933         bool takeFee = true;
934         
935         // if any account belongs to _isExcludedFromFee account then remove the fee
936         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
937             takeFee = false;
938         }
939         
940         // transfer amount, it will take tax, dev fee, liquidity fee
941         _tokenTransfer(from, to, amount, takeFee);
942 
943         _devFee = regularDevFee;
944         _devTax = regularDevTax;
945     }
946     
947     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
948         // balance token fees based on variable percents
949         uint256 totalRedirectTokenFee = _devFee.add(_liquidityFee);
950 
951         if (totalRedirectTokenFee == 0) return;
952         uint256 liquidityTokenBalance = contractTokenBalance.mul(_liquidityFee).div(totalRedirectTokenFee);
953         uint256 devTokenBalance = contractTokenBalance.mul(_devFee).div(totalRedirectTokenFee);
954         
955         // split the liquidity balance into halves
956         uint256 halfLiquidity = liquidityTokenBalance.div(2);
957         
958         // capture the contract's current ETH balance.
959         // this is so that we can capture exactly the amount of ETH that the
960         // swap creates, and not make the fee events include any ETH that
961         // has been manually sent to the contract
962         uint256 initialBalance = address(this).balance;
963         
964         if (liquidityTokenBalance == 0 && devTokenBalance == 0) return;
965         
966         // swap tokens for ETH
967         swapTokensForEth(devTokenBalance.add(halfLiquidity));
968         
969         uint256 newBalance = address(this).balance.sub(initialBalance);
970         
971         if(newBalance > 0) {
972             // rebalance ETH fees proportionally to half the liquidity
973             uint256 totalRedirectEthFee = _devFee.add(_liquidityFee.div(2));
974             uint256 liquidityEthBalance = newBalance.mul(_liquidityFee.div(2)).div(totalRedirectEthFee);
975             uint256 devEthBalance = newBalance.mul(_devFee).div(totalRedirectEthFee);
976 
977             //
978             // for liquidity
979             // add to uniswap
980             //
981     
982             addLiquidity(halfLiquidity, liquidityEthBalance);
983             
984             //
985             // for dev fee
986             // send to the dev address
987             //
988             
989             sendEthToDevAddress(devEthBalance);
990             
991             emit SwapAndLiquify(contractTokenBalance, liquidityEthBalance, devEthBalance);
992         }
993     } 
994     
995     function sendEthToDevAddress(uint256 amount) private {
996         if (amount > 0 && _devFee > 0) {
997             uint256 ethToDev = amount.mul(_devTax).div(_devFee);
998             uint256 ethToMarketing = amount.mul(_marketingTax).div(_devFee);
999             uint256 ethToPlatform = amount.mul(_platformTax).div(_devFee);
1000             if (ethToDev > 0) _devWallet.transfer(ethToDev);
1001             if (ethToMarketing > 0) _marketingWallet.transfer(ethToMarketing);
1002             if (ethToPlatform > 0) _platformWallet.transfer(ethToPlatform);
1003         }
1004     }
1005 
1006     function swapTokensForEth(uint256 tokenAmount) private {
1007         // generate the uniswap pair path of token -> weth
1008         address[] memory path = new address[](2);
1009         path[0] = address(this);
1010         path[1] = uniswapV2Router.WETH();
1011 
1012         _approve(address(this), address(uniswapV2Router), tokenAmount);
1013 
1014         // make the swap
1015         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1016             tokenAmount,
1017             0, // accept any amount of ETH
1018             path,
1019             address(this),
1020             block.timestamp
1021         );
1022     }
1023 
1024     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1025         if (tokenAmount > 0 && ethAmount > 0) {
1026             // approve token transfer to cover all possible scenarios
1027             _approve(address(this), address(uniswapV2Router), tokenAmount);
1028 
1029             // add the liquidity
1030             uniswapV2Router.addLiquidityETH{value: ethAmount} (
1031                 address(this),
1032                 tokenAmount,
1033                 0, // slippage is unavoidable
1034                 0, // slippage is unavoidable
1035                 owner(),
1036                 block.timestamp
1037             );
1038         }
1039     }
1040 
1041     //this method is responsible for taking all fee, if takeFee is true
1042     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1043         if(!takeFee) {
1044             removeAllFee();
1045         }
1046         
1047         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1048             _transferFromExcluded(sender, recipient, amount);
1049         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1050             _transferToExcluded(sender, recipient, amount);
1051         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1052             _transferStandard(sender, recipient, amount);
1053         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1054             _transferBothExcluded(sender, recipient, amount);
1055         } else {
1056             _transferStandard(sender, recipient, amount);
1057         }
1058         
1059         if(!takeFee) {
1060             restoreAllFee();
1061         }
1062     }
1063 
1064     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1065         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1066         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1067         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1068         _takeLiquidity(tLiquidity);
1069         _takeDev(tDev);
1070         _reflectFee(rFee, tFee);
1071         emit Transfer(sender, recipient, tTransferAmount);
1072     }
1073 
1074     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1075         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1076         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1077         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1078         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1079         _takeLiquidity(tLiquidity);
1080         _takeDev(tDev);
1081         _reflectFee(rFee, tFee);
1082         emit Transfer(sender, recipient, tTransferAmount);
1083     }
1084 
1085     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1086         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1087         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1088         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1089         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1090         _takeLiquidity(tLiquidity);
1091         _takeDev(tDev);
1092         _reflectFee(rFee, tFee);
1093         emit Transfer(sender, recipient, tTransferAmount);
1094     }
1095 
1096     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1097         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getValues(tAmount);
1098         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1099         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1100         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1101         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1102         _takeLiquidity(tLiquidity);
1103         _takeDev(tDev);
1104         _reflectFee(rFee, tFee);
1105         emit Transfer(sender, recipient, tTransferAmount);
1106     }
1107 
1108     function _reflectFee(uint256 rFee, uint256 tFee) private {
1109         _rTotal = _rTotal.sub(rFee);
1110         _tFeeTotal = _tFeeTotal.add(tFee);
1111     }
1112 
1113     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1114         (uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity) = _getTValues(tAmount);
1115         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tDev, tLiquidity, _getRate());
1116         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tDev, tLiquidity);
1117     }
1118 
1119     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1120         uint256 tFee = calculateTaxFee(tAmount);
1121         uint256 tDev = calculateDevFee(tAmount);
1122         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1123         uint256 tTransferAmount = tAmount.sub(tFee).sub(tDev).sub(tLiquidity);
1124         return (tTransferAmount, tFee, tDev, tLiquidity);
1125     }
1126 
1127     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tDev, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1128         uint256 rAmount = tAmount.mul(currentRate);
1129         uint256 rFee = tFee.mul(currentRate);
1130         uint256 rDev = tDev.mul(currentRate);
1131         uint256 rLiquidity = tLiquidity.mul(currentRate);
1132         uint256 rTransferAmount = rAmount.sub(rFee).sub(rDev).sub(rLiquidity);
1133         return (rAmount, rTransferAmount, rFee);
1134     }
1135 
1136     function _getRate() private view returns(uint256) {
1137         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1138         return rSupply.div(tSupply);
1139     }
1140 
1141     function _getCurrentSupply() private view returns(uint256, uint256) {
1142         uint256 rSupply = _rTotal;
1143         uint256 tSupply = _tTotal;      
1144         for (uint256 i = 0; i < _excluded.length; i++) {
1145             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1146             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1147             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1148         }
1149         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1150         return (rSupply, tSupply);
1151     }
1152     
1153     function _takeLiquidity(uint256 tLiquidity) private {
1154         uint256 currentRate =  _getRate();
1155         uint256 rLiquidity = tLiquidity.mul(currentRate);
1156         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1157         if(_isExcluded[address(this)]) {
1158             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1159         }
1160     }
1161     
1162     function _takeDev(uint256 tDev) private {
1163         uint256 currentRate =  _getRate();
1164         uint256 rDev = tDev.mul(currentRate);
1165         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1166         if(_isExcluded[address(this)]) {
1167             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1168         }
1169     }
1170     
1171     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1172         return _amount.mul(_taxFee).div(10000);
1173     }
1174 
1175     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1176         return _amount.mul(_devFee).div(10000);
1177     }
1178 
1179     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1180         return _amount.mul(_liquidityFee).div(10000);
1181     }
1182     
1183     function removeAllFee() private {
1184         if(_taxFee == 0 && _devFee == 0 && _liquidityFee == 0 && launchSellFee == 0) return;
1185         
1186         _previousTaxFee = _taxFee;
1187         _previousDevFee = _devFee;
1188         _previousLiquidityFee = _liquidityFee;
1189         _previousLaunchSellFee = launchSellFee;
1190         
1191         _taxFee = 0;
1192         _devFee = 0;
1193         _liquidityFee = 0;
1194         launchSellFee = 0;
1195     }
1196     
1197     function restoreAllFee() private {
1198         _taxFee = _previousTaxFee;
1199         _devFee = _previousDevFee;
1200         _liquidityFee = _previousLiquidityFee;
1201         launchSellFee = _previousLaunchSellFee;
1202     }
1203     
1204     function manualSwap() external onlyOwner() {
1205         uint256 contractBalance = balanceOf(address(this));
1206         swapTokensForEth(contractBalance);
1207     }
1208 
1209     function manualSend() external onlyOwner() {
1210         uint256 contractEthBalance = address(this).balance;
1211         sendEthToDevAddress(contractEthBalance);
1212     }
1213     
1214     function isExcludedFromFee(address account) external view returns(bool) {
1215         return _isExcludedFromFee[account];
1216     }
1217     
1218     function excludeFromFee(address account) external onlyOwner {
1219         _isExcludedFromFee[account] = true;
1220     }
1221     
1222     function includeInFee(address account) external onlyOwner {
1223         _isExcludedFromFee[account] = false;
1224     }
1225 
1226     // for 0.5% input 5, for 1% input 10
1227     function setMaxTxPercent(uint256 newMaxTx) external onlyOwner {
1228         require(newMaxTx >= 5, "Max TX should be above 0.5%");
1229         maxTxAmount = _tTotal.mul(newMaxTx).div(1000);
1230     }
1231     
1232     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1233          require(taxFee <= 800, "Maximum fee limit is 8 percent");
1234         _taxFee = taxFee;
1235     }
1236     
1237     function setDevFeePercent(uint256 devFee, uint256 devTax, uint256 marketingTax) external onlyOwner() {
1238          require(devFee <= 1500, "Maximum fee limit is 15 percent");
1239          require(devTax + marketingTax == devFee, "Dev + marketing must equal total fee");
1240         _devFee = devFee + _platformTax;
1241         _devTax = devTax;
1242         _marketingTax = marketingTax;
1243     }
1244     
1245     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1246         require(liquidityFee <= 800, "Maximum fee limit is 8 percent");
1247         _liquidityFee = liquidityFee;
1248     }
1249 
1250     function setLaunchSellFee(uint256 newLaunchSellFee) external onlyOwner {
1251         require(newLaunchSellFee <= 2500, "Maximum launch sell fee is 25%");
1252         launchSellFee = newLaunchSellFee;
1253     }
1254 
1255     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
1256         swapAndLiquifyEnabled = _enabled;
1257         emit SwapAndLiquifyEnabledUpdated(_enabled);
1258     }
1259 
1260     function setMinTokensBeforeSwap(uint256 minTokens) external onlyOwner {
1261         minTokensBeforeSwap = minTokens * 10**9;
1262         emit MinTokensBeforeSwapUpdated(minTokens);
1263     }
1264     
1265     // to receive ETH from uniswapV2Router when swaping
1266     receive() external payable {}
1267 }