1 // SPDX-License-Identifier: MIT
2 
3 /**
4 * Elon Safe Doge Moon Tokyo Inu
5 * Total Supply
6 * Supply: 1,000,000,000,000,000
7 * Mechanics
8 * 11% Total Tax: 5% fee redistributed to all existing holders. 5% fee added as a liquidity pair on Uniswap. 1% is the development fee.
9 * AntiBot Ssetting
10 * The listing bot takes away the profit of the token holders. ESDMTI burns all the tokens purchased using the listing bot to protect the investors.
11 * Fair Launch
12 * Maximum buy limit, meaning no whales. The perfect meme token on erc by the community, for the community.
13 * Join Us
14 * WebSite: https://elonsafedogemoontokyoinu.com
15 * Telegram: https://t.me/ElonSafeDogeMoon
16 **/
17 
18 pragma solidity ^0.6.12;
19 
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the token decimals.
28      */
29     function decimals() external view returns (uint8);
30 
31     /**
32      * @dev Returns the token symbol.
33      */
34     function symbol() external view returns (string memory);
35 
36     /**
37      * @dev Returns the token name.
38      */
39     function name() external view returns (string memory);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address _owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
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
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address payable) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes memory) {
255         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
256         return msg.data;
257     }
258 }
259 
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291      * `recipient`, forwarding all available gas and reverting on errors.
292      *
293      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294      * of certain opcodes, possibly making contracts go over the 2300 gas limit
295      * imposed by `transfer`, making them unable to receive funds via
296      * `transfer`. {sendValue} removes this limitation.
297      *
298      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299      *
300      * IMPORTANT: because control is transferred to `recipient`, care must be
301      * taken to not create reentrancy vulnerabilities. Consider using
302      * {ReentrancyGuard} or the
303      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304      */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain`call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but also transferring `value` wei to `target`.
348      *
349      * Requirements:
350      *
351      * - the calling contract must have an ETH balance of at least `value`.
352      * - the called Solidity function must be `payable`.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362      * with `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 contract Ownable is Context {
396     address private _owner;
397     address private _previousOwner;
398     uint256 private _lockTime;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor () internal {
406         address msgSender = _msgSender();
407         _previousOwner = _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     /**
427     * @dev Leaves the contract without owner. It will not be possible to call
428     * `onlyOwner` functions anymore. Can only be called by the current owner.
429     *
430     * NOTE: Renouncing ownership will leave the contract without an owner,
431     * thereby removing any functionality that is only available to the owner.
432     */
433     function renounceOwnership() public virtual onlyOwner {
434         emit OwnershipTransferred(_owner, address(0));
435         _owner = address(0);
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
469 interface IUniswapV2Factory {
470     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
471 
472     function feeTo() external view returns (address);
473     function feeToSetter() external view returns (address);
474 
475     function getPair(address tokenA, address tokenB) external view returns (address pair);
476     function allPairs(uint) external view returns (address pair);
477     function allPairsLength() external view returns (uint);
478 
479     function createPair(address tokenA, address tokenB) external returns (address pair);
480 
481     function setFeeTo(address) external;
482     function setFeeToSetter(address) external;
483 }
484 
485 interface IUniswapV2Pair {
486     event Approval(address indexed owner, address indexed spender, uint value);
487     event Transfer(address indexed from, address indexed to, uint value);
488 
489     function name() external pure returns (string memory);
490     function symbol() external pure returns (string memory);
491     function decimals() external pure returns (uint8);
492     function totalSupply() external view returns (uint);
493     function balanceOf(address owner) external view returns (uint);
494     function allowance(address owner, address spender) external view returns (uint);
495 
496     function approve(address spender, uint value) external returns (bool);
497     function transfer(address to, uint value) external returns (bool);
498     function transferFrom(address from, address to, uint value) external returns (bool);
499 
500     function DOMAIN_SEPARATOR() external view returns (bytes32);
501     function PERMIT_TYPEHASH() external pure returns (bytes32);
502     function nonces(address owner) external view returns (uint);
503 
504     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
505 
506     event Mint(address indexed sender, uint amount0, uint amount1);
507     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
508     event Swap(
509         address indexed sender,
510         uint amount0In,
511         uint amount1In,
512         uint amount0Out,
513         uint amount1Out,
514         address indexed to
515     );
516     event Sync(uint112 reserve0, uint112 reserve1);
517 
518     function MINIMUM_LIQUIDITY() external pure returns (uint);
519     function factory() external view returns (address);
520     function token0() external view returns (address);
521     function token1() external view returns (address);
522     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
523     function price0CumulativeLast() external view returns (uint);
524     function price1CumulativeLast() external view returns (uint);
525     function kLast() external view returns (uint);
526 
527     function mint(address to) external returns (uint liquidity);
528     function burn(address to) external returns (uint amount0, uint amount1);
529     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
530     function skim(address to) external;
531     function sync() external;
532 
533     function initialize(address, address) external;
534 }
535 
536 interface IUniswapV2Router01 {
537     function factory() external pure returns (address);
538     function WETH() external pure returns (address);
539 
540     function addLiquidity(
541         address tokenA,
542         address tokenB,
543         uint amountADesired,
544         uint amountBDesired,
545         uint amountAMin,
546         uint amountBMin,
547         address to,
548         uint deadline
549     ) external returns (uint amountA, uint amountB, uint liquidity);
550     function addLiquidityETH(
551         address token,
552         uint amountTokenDesired,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline
557     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
558     function removeLiquidity(
559         address tokenA,
560         address tokenB,
561         uint liquidity,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline
566     ) external returns (uint amountA, uint amountB);
567     function removeLiquidityETH(
568         address token,
569         uint liquidity,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountToken, uint amountETH);
575     function removeLiquidityWithPermit(
576         address tokenA,
577         address tokenB,
578         uint liquidity,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline,
583         bool approveMax, uint8 v, bytes32 r, bytes32 s
584     ) external returns (uint amountA, uint amountB);
585     function removeLiquidityETHWithPermit(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountToken, uint amountETH);
594     function swapExactTokensForTokens(
595         uint amountIn,
596         uint amountOutMin,
597         address[] calldata path,
598         address to,
599         uint deadline
600     ) external returns (uint[] memory amounts);
601     function swapTokensForExactTokens(
602         uint amountOut,
603         uint amountInMax,
604         address[] calldata path,
605         address to,
606         uint deadline
607     ) external returns (uint[] memory amounts);
608     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
609     external
610     payable
611     returns (uint[] memory amounts);
612     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
613     external
614     returns (uint[] memory amounts);
615     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
616     external
617     returns (uint[] memory amounts);
618     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
619     external
620     payable
621     returns (uint[] memory amounts);
622 
623     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
624     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
625     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
626     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
627     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
628 }
629 
630 interface IUniswapV2Router02 is IUniswapV2Router01 {
631     function removeLiquidityETHSupportingFeeOnTransferTokens(
632         address token,
633         uint liquidity,
634         uint amountTokenMin,
635         uint amountETHMin,
636         address to,
637         uint deadline
638     ) external returns (uint amountETH);
639     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
640         address token,
641         uint liquidity,
642         uint amountTokenMin,
643         uint amountETHMin,
644         address to,
645         uint deadline,
646         bool approveMax, uint8 v, bytes32 r, bytes32 s
647     ) external returns (uint amountETH);
648 
649     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external;
656     function swapExactETHForTokensSupportingFeeOnTransferTokens(
657         uint amountOutMin,
658         address[] calldata path,
659         address to,
660         uint deadline
661     ) external payable;
662     function swapExactTokensForETHSupportingFeeOnTransferTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external;
669 }
670 
671 contract ESDMTI is Context, IERC20, Ownable {
672     using SafeMath for uint256;
673     using Address for address;
674 
675     mapping (address => uint256) private _rOwned;
676     mapping (address => uint256) private _tOwned;
677     mapping (address => mapping (address => uint256)) private _allowances;
678 
679     mapping (address => bool) private _isExcludedFromFee;
680 
681     mapping (address => bool) private _isExcluded;
682     address[] private _excluded;
683 
684     uint256 private constant MAX = ~uint256(0);
685     uint256 private _tTotal =  10**15 * 10**9;
686     uint256 private _rTotal = (MAX - (MAX % _tTotal));
687     uint256 private _tFeeTotal;
688 
689     string private _name = "ElonSafeDogeMoonTokyoInu";
690     string private _symbol = "ESDMTI";
691     uint8 private _decimals = 9;
692 
693     uint256 public _taxFee = 5;
694     uint256 private _previousTaxFee = _taxFee;
695 
696     uint256 public _liquidityFee = 5;
697     uint256 private _previousLiquidityFee = _liquidityFee;
698 
699     uint256 public _devFee = 1;
700     uint256 private _previousDevFee = _devFee;
701 
702     uint256 private _startTime = 0;
703 
704     IUniswapV2Router02 public immutable uniswapV2Router;
705     address public immutable uniswapV2Pair;
706 
707     bool inSwapAndLiquify;
708     bool public swapAndLiquifyEnabled = true;
709     bool public tradingEnabled = false;
710 
711     // Dev Fee address
712     address public devFeeAddress;
713 
714     uint256 public _maxTxAmount = _tTotal / 100;
715     uint256 private numTokensSellToAddToLiquidity = _tTotal / 20;
716 
717     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
718     event SwapAndLiquifyEnabledUpdated(bool enabled);
719     event SwapAndLiquify(
720         uint256 tokensSwapped,
721         uint256 ethReceived,
722         uint256 tokensIntoLiqudity
723     );
724 
725     modifier lockTheSwap {
726         inSwapAndLiquify = true;
727         _;
728         inSwapAndLiquify = false;
729     }
730 
731     constructor () public {
732         _rOwned[_msgSender()] = _rTotal;
733         devFeeAddress = _msgSender();
734 
735         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
736         // Create a uniswap pair for this new token
737         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
738         .createPair(address(this), _uniswapV2Router.WETH());
739 
740         // set the rest of the contract variables
741         uniswapV2Router = _uniswapV2Router;
742 
743         //exclude owner and this contract from fee
744         _isExcludedFromFee[_msgSender()] = true;
745         _isExcludedFromFee[address(this)] = true;
746 
747         emit Transfer(address(0), _msgSender(), _tTotal);
748     }
749 
750     function name() public view override returns (string memory) {
751         return _name;
752     }
753 
754     function symbol() public view override returns (string memory) {
755         return _symbol;
756     }
757 
758     function decimals() public view override returns (uint8) {
759         return _decimals;
760     }
761 
762     function totalSupply() public view override returns (uint256) {
763         return _tTotal;
764     }
765 
766     function balanceOf(address account) public view override returns (uint256) {
767         if (_isExcluded[account]) return _tOwned[account];
768         return tokenFromReflection(_rOwned[account]);
769     }
770 
771     function transfer(address recipient, uint256 amount) public override returns (bool) {
772         _transfer(_msgSender(), recipient, amount);
773         return true;
774     }
775 
776     function allowance(address owner, address spender) public view override returns (uint256) {
777         return _allowances[owner][spender];
778     }
779 
780     function approve(address spender, uint256 amount) public override returns (bool) {
781         _approve(_msgSender(), spender, amount);
782         return true;
783     }
784 
785     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
786         _transfer(sender, recipient, amount);
787         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
788         return true;
789     }
790 
791     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
792         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
793         return true;
794     }
795 
796     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
798         return true;
799     }
800 
801     function isExcludedFromReward(address account) public view returns (bool) {
802         return _isExcluded[account];
803     }
804 
805     function totalFees() public view returns (uint256) {
806         return _tFeeTotal;
807     }
808 
809     function deliver(uint256 tAmount) public {
810         address sender = _msgSender();
811         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
812         (uint256 rAmount,,,,,,) = _getValues(tAmount);
813         _rOwned[sender] = _rOwned[sender].sub(rAmount);
814         _rTotal = _rTotal.sub(rAmount);
815         _tFeeTotal = _tFeeTotal.add(tAmount);
816     }
817 
818     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
819         require(tAmount <= _tTotal, "Amount must be less than supply");
820         if (!deductTransferFee) {
821             (uint256 rAmount,,,,,,) = _getValues(tAmount);
822             return rAmount;
823         } else {
824             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
825             return rTransferAmount;
826         }
827     }
828 
829     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
830         require(rAmount <= _rTotal, "Amount must be less than total reflections");
831         uint256 currentRate =  _getRate();
832         return rAmount.div(currentRate);
833     }
834 
835     function excludeFromReward(address account) public onlyOwner() {
836         require(!_isExcluded[account], "Account is already excluded");
837         if(_rOwned[account] > 0) {
838             _tOwned[account] = tokenFromReflection(_rOwned[account]);
839         }
840         _isExcluded[account] = true;
841         _excluded.push(account);
842     }
843 
844     function includeInReward(address account) external onlyOwner() {
845         require(_isExcluded[account], "Account is already excluded");
846         for (uint256 i = 0; i < _excluded.length; i++) {
847             if (_excluded[i] == account) {
848                 _excluded[i] = _excluded[_excluded.length - 1];
849                 _tOwned[account] = 0;
850                 _isExcluded[account] = false;
851                 _excluded.pop();
852                 break;
853             }
854         }
855     }
856     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
857         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
858         _tOwned[sender] = _tOwned[sender].sub(tAmount);
859         _rOwned[sender] = _rOwned[sender].sub(rAmount);
860         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
861         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
862         _takeLiquidity(tLiquidity);
863         _takeDevFee(tDev);
864         _reflectFee(rFee, tFee);
865         emit Transfer(sender, recipient, tTransferAmount);
866         emit Transfer(sender, devFeeAddress, tDev);
867         emit Transfer(sender, address(this), tLiquidity);
868     }
869 
870     function excludeFromFee(address account) public onlyOwner {
871         _isExcludedFromFee[account] = true;
872     }
873 
874     function includeInFee(address account) public onlyOwner {
875         _isExcludedFromFee[account] = false;
876     }
877 
878     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
879         _taxFee = taxFee;
880     }
881 
882     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
883         _liquidityFee = liquidityFee;
884     }
885 
886     function setDevFeePercent(uint256 devFee) external onlyOwner() {
887         _devFee = devFee;
888     }
889 
890     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
891         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
892             10**2
893         );
894     }
895 
896     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
897         swapAndLiquifyEnabled = _enabled;
898         emit SwapAndLiquifyEnabledUpdated(_enabled);
899     }
900 
901     function enableTrading(bool _tradingEnabled) external onlyOwner() {
902         _startTime = block.number;
903         tradingEnabled = _tradingEnabled;
904     }
905 
906     receive() external payable {}
907 
908     function _reflectFee(uint256 rFee, uint256 tFee) private {
909         _rTotal = _rTotal.sub(rFee);
910         _tFeeTotal = _tFeeTotal.add(tFee);
911     }
912 
913     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
914         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getTValues(tAmount);
915         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tDev, _getRate());
916         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tDev);
917     }
918 
919     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
920         uint256 tFee = calculateTaxFee(tAmount);
921         uint256 tLiquidity = calculateLiquidityFee(tAmount);
922         uint256 tDev = calculateDevFee(tAmount);
923         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tDev);
924         return (tTransferAmount, tFee, tLiquidity, tDev);
925     }
926 
927     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
928         uint256 rAmount = tAmount.mul(currentRate);
929         uint256 rFee = tFee.mul(currentRate);
930         uint256 rLiquidity = tLiquidity.mul(currentRate);
931         uint256 rDev = tDev.mul(currentRate);
932         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rDev);
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
961     function _takeDevFee(uint256 tDevFee) private {
962         uint256 currentRate =  _getRate();
963         uint256 rDevFee = tDevFee.mul(currentRate);
964         _rOwned[devFeeAddress] = _rOwned[devFeeAddress].add(rDevFee);
965         if(_isExcluded[devFeeAddress])
966             _tOwned[devFeeAddress] = _tOwned[devFeeAddress].add(tDevFee);
967     }
968 
969     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
970         return _amount.mul(_taxFee).div(
971             10**2
972         );
973     }
974 
975     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
976         return _amount.mul(_liquidityFee).div(
977             10**2
978         );
979     }
980 
981     function calculateDevFee(uint256 _amount) private view returns (uint256) {
982         return _amount.mul(_devFee).div(
983             10**2
984         );
985     }
986 
987     function removeAllFee() private {
988         if(_taxFee == 0 && _liquidityFee == 0 && _devFee == 0) return;
989 
990         _previousTaxFee = _taxFee;
991         _previousLiquidityFee = _liquidityFee;
992         _previousDevFee = _devFee;
993 
994         _taxFee = 0;
995         _liquidityFee = 0;
996         _devFee = 0;
997     }
998 
999     function restoreAllFee() private {
1000         _taxFee = _previousTaxFee;
1001         _liquidityFee = _previousLiquidityFee;
1002         _devFee = _previousDevFee;
1003     }
1004 
1005     function isExcludedFromFee(address account) public view returns(bool) {
1006         return _isExcludedFromFee[account];
1007     }
1008 
1009     function _approve(address owner, address spender, uint256 amount) private {
1010         require(owner != address(0), "ERC20: approve from the zero address");
1011         require(spender != address(0), "ERC20: approve to the zero address");
1012 
1013         _allowances[owner][spender] = amount;
1014         emit Approval(owner, spender, amount);
1015     }
1016 
1017     function _transfer(
1018         address from,
1019         address to,
1020         uint256 amount
1021     ) private {
1022         require(from != address(0), "ERC20: transfer from the zero address");
1023         require(to != address(0), "ERC20: transfer to the zero address");
1024         require(amount > 0, "Transfer amount must be greater than zero");
1025 
1026         // restricted transactions between 20 blocks only
1027         if(from != owner() && to != owner() && _startTime + 20 > block.number)
1028             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1029 
1030         if (from != owner()) {
1031             require(tradingEnabled, "Trading is not enabled yet");
1032             require(_startTime != block.number, "Trading is not enabled yet");
1033         }
1034 
1035         // is the token balance of this contract address over the min number of
1036         // tokens that we need to initiate a swap + liquidity lock?
1037         // also, don't get caught in a circular liquidity event.
1038         // also, don't swap & liquify if sender is uniswap pair.
1039         uint256 contractTokenBalance = balanceOf(address(this));
1040 
1041         if(_startTime + 20 > block.number && contractTokenBalance >= _maxTxAmount)
1042         {
1043             contractTokenBalance = _maxTxAmount;
1044         }
1045 
1046         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1047         if (
1048             overMinTokenBalance &&
1049             !inSwapAndLiquify &&
1050             from != uniswapV2Pair &&
1051             swapAndLiquifyEnabled
1052         ) {
1053             contractTokenBalance = numTokensSellToAddToLiquidity;
1054             //add liquidity
1055             swapAndLiquify(contractTokenBalance);
1056         }
1057 
1058         //indicates if fee should be deducted from transfer
1059         bool takeFee = true;
1060 
1061         //if any account belongs to _isExcludedFromFee account then remove the fee
1062         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1063             takeFee = false;
1064         }
1065 
1066         //transfer amount, it will take tax, burn, liquidity fee
1067         _tokenTransfer(from,to,amount,takeFee);
1068     }
1069 
1070     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1071         // split the contract balance into halves
1072         uint256 half = contractTokenBalance.div(2);
1073         uint256 otherHalf = contractTokenBalance.sub(half);
1074 
1075         // capture the contract's current ETH balance.
1076         // this is so that we can capture exactly the amount of ETH that the
1077         // swap creates, and not make the liquidity event include any ETH that
1078         // has been manually sent to the contract
1079         uint256 initialBalance = address(this).balance;
1080 
1081         // swap tokens for ETH
1082         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1083 
1084         // how much ETH did we just swap into?
1085         uint256 newBalance = address(this).balance.sub(initialBalance);
1086 
1087         // add liquidity to uniswap
1088         addLiquidity(otherHalf, newBalance);
1089 
1090         emit SwapAndLiquify(half, newBalance, otherHalf);
1091     }
1092 
1093     function swapTokensForEth(uint256 tokenAmount) private {
1094         // generate the uniswap pair path of token -> weth
1095         address[] memory path = new address[](2);
1096         path[0] = address(this);
1097         path[1] = uniswapV2Router.WETH();
1098 
1099         _approve(address(this), address(uniswapV2Router), tokenAmount);
1100 
1101         // make the swap
1102         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1103             tokenAmount,
1104             0, // accept any amount of ETH
1105             path,
1106             address(this),
1107             block.timestamp
1108         );
1109     }
1110 
1111     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1112         // approve token transfer to cover all possible scenarios
1113         _approve(address(this), address(uniswapV2Router), tokenAmount);
1114 
1115         // add the liquidity
1116         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1117             address(this),
1118             tokenAmount,
1119             0, // slippage is unavoidable
1120             0, // slippage is unavoidable
1121             owner(),
1122             block.timestamp
1123         );
1124     }
1125 
1126     //this method is responsible for taking all fee, if takeFee is true
1127     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1128         if(!takeFee)
1129             removeAllFee();
1130 
1131         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1132             _transferFromExcluded(sender, recipient, amount);
1133         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1134             _transferToExcluded(sender, recipient, amount);
1135         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1136             _transferStandard(sender, recipient, amount);
1137         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1138             _transferBothExcluded(sender, recipient, amount);
1139         } else {
1140             _transferStandard(sender, recipient, amount);
1141         }
1142 
1143         if(!takeFee)
1144             restoreAllFee();
1145     }
1146 
1147     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1148         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1149         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1150         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1151         _takeLiquidity(tLiquidity);
1152         _takeDevFee(tDev);
1153         _reflectFee(rFee, tFee);
1154         emit Transfer(sender, recipient, tTransferAmount);
1155         emit Transfer(sender, devFeeAddress, tDev);
1156         emit Transfer(sender, address(this), tLiquidity);
1157     }
1158 
1159     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1161         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1162         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1163         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1164         _takeLiquidity(tLiquidity);
1165         _takeDevFee(tDev);
1166         _reflectFee(rFee, tFee);
1167         emit Transfer(sender, recipient, tTransferAmount);
1168         emit Transfer(sender, devFeeAddress, tDev);
1169         emit Transfer(sender, address(this), tLiquidity);
1170     }
1171 
1172     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1173         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1174         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1175         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1176         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1177         _takeLiquidity(tLiquidity);
1178         _takeDevFee(tDev);
1179         _reflectFee(rFee, tFee);
1180         emit Transfer(sender, recipient, tTransferAmount);
1181         emit Transfer(sender, devFeeAddress, tDev);
1182         emit Transfer(sender, address(this), tLiquidity);
1183     }
1184 }