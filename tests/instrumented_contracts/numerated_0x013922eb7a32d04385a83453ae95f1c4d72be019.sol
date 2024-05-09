1 // SPDX-License-Identifier: MIT
2 
3 //          000000      00000000      00000000        0000000
4 //         00    00     00     00     00     00      00     00
5 //        00      00    00      00    00      00    00
6 //        00      00    00      00    00      00     00
7 //        00      00    00     00     00     00       000
8 //        00      00    00000000      00000000          0000
9 //        00      00    00 00         00     00            000 
10 //        00      00    00  00        00      00            00
11 //        00      00    00   00       00      00            00
12 //         00    00     00    00      00     00     00     00
13 //          000000      00     000    00000000       000000
14 
15 
16 pragma solidity ^0.6.0;
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { codehash := extcodehash(account) }
302         return (codehash != accountHash && codehash != 0x0);
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348       return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return _functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         return _functionCallWithValue(target, data, value, errorMessage);
385     }
386 
387     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
388         require(isContract(target), "Address: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 /**
412  * @dev Contract module which provides a basic access control mechanism, where
413  * there is an account (an owner) that can be granted exclusive access to
414  * specific functions.
415  *
416  * By default, the owner account will be the one that deploys the contract. This
417  * can later be changed with {transferOwnership}.
418  *
419  * This module is used through inheritance. It will make available the modifier
420  * `onlyOwner`, which can be applied to your functions to restrict their use to
421  * the owner.
422  */
423 contract Ownable is Context {
424     address private _owner;
425 
426     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
427 
428     /**
429      * @dev Initializes the contract setting the deployer as the initial owner.
430      */
431     constructor () internal {
432         address msgSender = _msgSender();
433         _owner = msgSender;
434         emit OwnershipTransferred(address(0), msgSender);
435     }
436 
437     /**
438      * @dev Returns the address of the current owner.
439      */
440     function owner() public view returns (address) {
441         return _owner;
442     }
443 
444     /**
445      * @dev Throws if called by any account other than the owner.
446      */
447     modifier onlyOwner() {
448         require(_owner == _msgSender(), "Ownable: caller is not the owner");
449         _;
450     }
451 
452     /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * NOTE: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public virtual onlyOwner {
460         emit OwnershipTransferred(_owner, address(0));
461         _owner = address(0);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         emit OwnershipTransferred(_owner, newOwner);
471         _owner = newOwner;
472     }
473 }
474 
475 
476 interface IUniswapV2Factory {
477     function createPair(address tokenA, address tokenB) external returns (address pair);
478 }
479 
480 interface IUniswapV2Pair {
481     function sync() external;
482 }
483 
484 interface IUniswapV2Router01 {
485     function factory() external pure returns (address);
486     function WETH() external pure returns (address);
487     function addLiquidity(
488         address tokenA,
489         address tokenB,
490         uint amountADesired,
491         uint amountBDesired,
492         uint amountAMin,
493         uint amountBMin,
494         address to,
495         uint deadline
496     ) external returns (uint amountA, uint amountB, uint liquidity);
497     function addLiquidityETH(
498         address token,
499         uint amountTokenDesired,
500         uint amountTokenMin,
501         uint amountETHMin,
502         address to,
503         uint deadline
504     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
505 }
506 
507 interface IUniswapV2Router02 is IUniswapV2Router01 {
508     function removeLiquidityETHSupportingFeeOnTransferTokens(
509       address token,
510       uint liquidity,
511       uint amountTokenMin,
512       uint amountETHMin,
513       address to,
514       uint deadline
515     ) external returns (uint amountETH);
516     function swapExactTokensForETHSupportingFeeOnTransferTokens(
517         uint amountIn,
518         uint amountOutMin,
519         address[] calldata path,
520         address to,
521         uint deadline
522     ) external;
523     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
524         uint amountIn,
525         uint amountOutMin,
526         address[] calldata path,
527         address to,
528         uint deadline
529     ) external;
530     function swapExactETHForTokensSupportingFeeOnTransferTokens(
531         uint amountOutMin,
532         address[] calldata path,
533         address to,
534         uint deadline
535     ) external payable;
536 }
537 
538 pragma solidity ^0.6.12;
539 
540 contract RewardWallet {
541     constructor() public {
542     }
543 }
544 
545 contract Balancer {
546     using SafeMath for uint256;
547     IUniswapV2Router02 public immutable _uniswapV2Router;
548     OUROBOROS private _tokenContract;
549     
550     constructor(OUROBOROS tokenContract, IUniswapV2Router02 uniswapV2Router) public {
551         _tokenContract =tokenContract;
552         _uniswapV2Router = uniswapV2Router;
553     }
554     
555     receive() external payable {}
556     
557     function rebalance() external returns (uint256) { 
558         swapEthForTokens(address(this).balance);
559     }
560 
561     function swapEthForTokens(uint256 EthAmount) private {
562         address[] memory uniswapPairPath = new address[](2);
563         uniswapPairPath[0] = _uniswapV2Router.WETH();
564         uniswapPairPath[1] = address(_tokenContract);
565 
566         _uniswapV2Router
567             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
568                 0,
569                 uniswapPairPath,
570                 address(this),
571                 block.timestamp
572             );
573     }
574 }
575 
576 contract Swaper {
577     using SafeMath for uint256;
578     IUniswapV2Router02 public immutable _uniswapV2Router;
579     OUROBOROS private _tokenContract;
580     
581     constructor(OUROBOROS tokenContract, IUniswapV2Router02 uniswapV2Router) public {
582         _tokenContract = tokenContract;
583         _uniswapV2Router = uniswapV2Router;
584     }
585     
586     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
587         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
588         swapTokensForTokens(pairTokenAddress, tokenAmount);
589         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
590         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
591     }
592     
593     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
594         address[] memory path = new address[](2);
595         path[0] = address(_tokenContract);
596         path[1] = pairTokenAddress;
597 
598         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
599 
600         // make the swap
601         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
602             tokenAmount,
603             0, // accept any amount of pair token
604             path,
605             address(this),
606             block.timestamp
607         );
608     }
609 }
610 
611 contract OUROBOROS is Context, IERC20, Ownable {
612     using SafeMath for uint256;
613     using Address for address;
614 
615     IUniswapV2Router02 public immutable _uniswapV2Router;
616 
617     mapping (address => uint256) private _rOwned;
618     mapping (address => uint256) private _tOwned;
619     mapping (address => mapping (address => uint256)) private _allowances;
620 
621     mapping (address => bool) private _isExcluded;
622     address[] private _excluded;
623     address public _rewardWallet;
624     address public _uniswapETHPool;
625     
626     uint256 private constant MAX = ~uint256(0);
627     uint256 private _tTotal = 1000000e9;
628     uint256 private _rTotal = (MAX - (MAX % _tTotal));
629     uint256 public _tFeeTotal;
630     uint256 public _tBurnTotal;
631 
632     string private _name = 'Ouroboros';
633     string private _symbol = 'ORBS';
634     uint8 private _decimals = 9;
635     
636     uint256 public _feeDecimals = 1;
637     uint256 public _taxFee = 0;
638     uint256 public _lockFee = 0;
639     uint256 public _maxTxAmount = 200000e9;
640     uint256 public _minTokensBeforeSwap = 1000e9;
641     uint256 private _autoSwapCallerFee = 20e9;
642     
643     bool private inSwapAndLiquify;
644     bool public swapAndLiquifyEnabled;
645     bool public tradingEnabled;
646     
647     address private currentPairTokenAddress;
648     address private currentPoolAddress;
649     
650     uint256 private _liquidityRemoveFee = 50;
651     uint256 private _alchemyCallerFee = 20;
652     uint256 private _lastAlchemy;
653     uint256 private _alchemyInterval = 12 hours;
654     
655 
656     event FeeDecimalsUpdated(uint256 taxFeeDecimals);
657     event TaxFeeUpdated(uint256 taxFee);
658     event LockFeeUpdated(uint256 lockFee);
659     event MaxTxAmountUpdated(uint256 maxTxAmount);
660     event WhitelistUpdated(address indexed pairTokenAddress);
661     event TradingEnabled();
662     event SwapAndLiquifyEnabledUpdated(bool enabled);
663     event SwapAndLiquify(
664         address indexed pairTokenAddress,
665         uint256 tokensSwapped,
666         uint256 pairTokenReceived,
667         uint256 tokensIntoLiqudity
668     );
669     event Rebalance(uint256 tokenBurnt);
670     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
671     event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
672    
673     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
674     event AlchemyCallerFeeUpdated(uint256 rebalnaceCallerFee);
675     event MinTokenForAlchemyUpdated(uint256 minRebalanceAmount);
676     event AlchemyIntervalUpdated(uint256 rebalanceInterval);
677 
678     modifier lockTheSwap {
679         inSwapAndLiquify = true;
680         _;
681         inSwapAndLiquify = false;
682     }
683     
684     Balancer public balancer;
685     Swaper public swaper;
686 
687     constructor (IUniswapV2Router02 uniswapV2Router) public {
688         _lastAlchemy = now;
689         
690         _uniswapV2Router = uniswapV2Router;
691         _rewardWallet = address(new RewardWallet());
692        
693         balancer = new Balancer(this, uniswapV2Router);
694         swaper = new Swaper(this, uniswapV2Router);
695         
696         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
697             .createPair(address(this), uniswapV2Router.WETH());
698         currentPairTokenAddress = uniswapV2Router.WETH();
699         _uniswapETHPool = currentPoolAddress;
700         
701         updateSwapAndLiquifyEnabled(false);
702         
703         _rOwned[_msgSender()] = reflectionFromToken(_tTotal, false);
704         
705         emit Transfer(address(0), _msgSender(), _tTotal);
706     }
707 
708     function name() public view returns (string memory) {
709         return _name;
710     }
711 
712     function symbol() public view returns (string memory) {
713         return _symbol;
714     }
715 
716     function decimals() public view returns (uint8) {
717         return _decimals;
718     }
719 
720     function totalSupply() public view override returns (uint256) {
721         return _tTotal;
722     }
723 
724     function balanceOf(address account) public view override returns (uint256) {
725         if (_isExcluded[account]) return _tOwned[account];
726         return tokenFromReflection(_rOwned[account]);
727     }
728 
729     function transfer(address recipient, uint256 amount) public override returns (bool) {
730         _transfer(_msgSender(), recipient, amount);
731         return true;
732     }
733 
734     function allowance(address owner, address spender) public view override returns (uint256) {
735         return _allowances[owner][spender];
736     }
737 
738     function approve(address spender, uint256 amount) public override returns (bool) {
739         _approve(_msgSender(), spender, amount);
740         return true;
741     }
742 
743     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
744         _transfer(sender, recipient, amount);
745         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
746         return true;
747     }
748 
749     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
751         return true;
752     }
753 
754     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
755         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
756         return true;
757     }
758 
759     function isExcluded(address account) public view returns (bool) {
760         return _isExcluded[account];
761     }
762 
763     
764     function reflect(uint256 tAmount) public {
765         address sender = _msgSender();
766         require(!_isExcluded[sender], "Ouroboros: Excluded addresses cannot call this function");
767         (uint256 rAmount,,,,,) = _getValues(tAmount);
768         _rOwned[sender] = _rOwned[sender].sub(rAmount);
769         _rTotal = _rTotal.sub(rAmount);
770         _tFeeTotal = _tFeeTotal.add(tAmount);
771     }
772 
773     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
774         require(tAmount <= _tTotal, "Amount must be less than supply");
775         if (!deductTransferFee) {
776             (uint256 rAmount,,,,,) = _getValues(tAmount);
777             return rAmount;
778         } else {
779             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
780             return rTransferAmount;
781         }
782     }
783 
784     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
785         require(rAmount <= _rTotal, "Ouroboros: Amount must be less than total reflections");
786         uint256 currentRate =  _getRate();
787         return rAmount.div(currentRate);
788     }
789 
790     function excludeAccount(address account) external onlyOwner() {
791         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Ouroboros: We can not exclude Uniswap router.');
792         require(account != address(this), 'Ouroboros: We can not exclude contract self.');
793         require(account != _rewardWallet, 'Ouroboros: We can not exclude reweard wallet.');
794         require(!_isExcluded[account], "Ouroboros: Account is already excluded");
795         
796         if(_rOwned[account] > 0) {
797             _tOwned[account] = tokenFromReflection(_rOwned[account]);
798         }
799         _isExcluded[account] = true;
800         _excluded.push(account);
801     }
802 
803     function includeAccount(address account) external onlyOwner() {
804         require(_isExcluded[account], "Ouroboros: Account is already included");
805         for (uint256 i = 0; i < _excluded.length; i++) {
806             if (_excluded[i] == account) {
807                 _excluded[i] = _excluded[_excluded.length - 1];
808                 _tOwned[account] = 0;
809                 _isExcluded[account] = false;
810                 _excluded.pop();
811                 break;
812             }
813         }
814     }
815 
816     function _approve(address owner, address spender, uint256 amount) private {
817         require(owner != address(0), "Ouroboros: approve from the zero address");
818         require(spender != address(0), "Ouroboros: approve to the zero address");
819 
820         _allowances[owner][spender] = amount;
821         emit Approval(owner, spender, amount);
822     }
823 
824     function _transfer(address sender, address recipient, uint256 amount) private {
825         require(sender != address(0), "Ouroboros: transfer from the zero address");
826         require(recipient != address(0), "Ouroboros: transfer to the zero address");
827         require(amount > 0, "Ouroboros: Transfer amount must be greater than zero");
828         
829         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
830             require(amount <= _maxTxAmount, "Ouroboros: Transfer amount exceeds the maxTxAmount.");
831             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
832                 require(false, "Ouroboros: trading is disabled.");
833         }
834         
835         if(!inSwapAndLiquify) {
836             uint256 lockedBalanceForPool = balanceOf(address(this));
837             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
838             if (
839                 overMinTokenBalance &&
840                 msg.sender != currentPoolAddress &&
841                 swapAndLiquifyEnabled
842             ) {
843                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
844                     swapAndLiquifyForEth(lockedBalanceForPool);
845                 else
846                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
847             }
848         }
849         
850         if (_isExcluded[sender] && !_isExcluded[recipient]) {
851             _transferFromExcluded(sender, recipient, amount);
852         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
853             _transferToExcluded(sender, recipient, amount);
854         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
855             _transferStandard(sender, recipient, amount);
856         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
857             _transferBothExcluded(sender, recipient, amount);
858         } else {
859             _transferStandard(sender, recipient, amount);
860         }
861     }
862     
863     receive() external payable {}
864     
865     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
866         // split the contract balance except swapCallerFee into halves
867         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
868         uint256 half = lockedForSwap.div(2);
869         uint256 otherHalf = lockedForSwap.sub(half);
870 
871         // capture the contract's current ETH balance.
872         // this is so that we can capture exactly the amount of ETH that the
873         // swap creates, and not make the liquidity event include any ETH that
874         // has been manually sent to the contract
875         uint256 initialBalance = address(this).balance;
876 
877         // swap tokens for ETH
878         swapTokensForEth(half);
879         
880         // how much ETH did we just swap into?
881         uint256 newBalance = address(this).balance.sub(initialBalance);
882 
883         // add liquidity to uniswap
884         addLiquidityForEth(otherHalf, newBalance);
885         
886         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
887         
888         _transfer(address(this), tx.origin, _autoSwapCallerFee);
889     }
890     
891     function swapTokensForEth(uint256 tokenAmount) private {
892         // generate the uniswap pair path of token -> weth
893         address[] memory path = new address[](2);
894         path[0] = address(this);
895         path[1] = _uniswapV2Router.WETH();
896 
897         _approve(address(this), address(_uniswapV2Router), tokenAmount);
898 
899         // make the swap
900         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
901             tokenAmount,
902             0, // accept any amount of ETH
903             path,
904             address(this),
905             block.timestamp
906         );
907     }
908 
909     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
910         // approve token transfer to cover all possible scenarios
911         _approve(address(this), address(_uniswapV2Router), tokenAmount);
912 
913         // add the liquidity
914         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
915             address(this),
916             tokenAmount,
917             0, // slippage is unavoidable
918             0, // slippage is unavoidable
919             address(this),
920             block.timestamp
921         );
922     }
923     
924     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
925         // split the contract balance except swapCallerFee into halves
926         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
927         uint256 half = lockedForSwap.div(2);
928         uint256 otherHalf = lockedForSwap.sub(half);
929         
930         _transfer(address(this), address(swaper), half);
931         
932         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
933         
934         // swap tokens for pairToken
935         swaper.swapTokens(pairTokenAddress, half);
936         
937         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
938 
939         // add liquidity to uniswap
940         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
941         
942         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
943         
944         _transfer(address(this), tx.origin, _autoSwapCallerFee);
945         
946         
947     }
948 
949     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
950         // approve token transfer to cover all possible scenarios
951         _approve(address(this), address(_uniswapV2Router), tokenAmount);
952         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
953 
954         // add the liquidity
955         _uniswapV2Router.addLiquidity(
956             address(this),
957             pairTokenAddress,
958             tokenAmount,
959             pairTokenAmount,
960             0, // slippage is unavoidable
961             0, // slippage is unavoidable
962             address(this),
963             block.timestamp
964         );
965     }
966 
967     function alchemy() public lockTheSwap {
968         require(_msgSender() == owner());
969         require(now > _lastAlchemy + _alchemyInterval, 'Ouroboros: Too Soon.');
970         
971         _lastAlchemy = now;
972 
973         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
974 
975         removeLiquidityETH(amountToRemove);
976         balancer.rebalance();
977 
978         uint256 tNewTokenBalance = balanceOf(address(balancer));
979         uint256 tRewardForCaller = tNewTokenBalance.mul(_alchemyCallerFee).div(100);
980         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
981         
982         uint256 currentRate =  _getRate();
983         uint256 rBurn =  tBurn.mul(currentRate);
984         
985         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
986         _rOwned[address(balancer)] = 0;
987         
988         _tBurnTotal = _tBurnTotal.add(tBurn);
989         _tTotal = _tTotal.sub(tBurn);
990         _rTotal = _rTotal.sub(rBurn);
991 
992         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
993         emit Transfer(address(balancer), address(0), tBurn);
994         emit Rebalance(tBurn);
995     }
996     
997     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
998         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
999         (ETHAmount) = _uniswapV2Router
1000             .removeLiquidityETHSupportingFeeOnTransferTokens(
1001                 address(this),
1002                 lpAmount,
1003                 0,
1004                 0,
1005                 address(balancer),
1006                 block.timestamp
1007             );
1008     }
1009 
1010     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1011         uint256 currentRate =  _getRate();
1012         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1013         uint256 rLock =  tLock.mul(currentRate);
1014         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1015         if(inSwapAndLiquify) {
1016             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1017             emit Transfer(sender, recipient, tAmount);
1018         } else {
1019             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1020             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1021             _reflectFee(rFee, tFee);
1022             emit Transfer(sender, address(this), tLock);
1023             emit Transfer(sender, recipient, tTransferAmount);
1024         }
1025     }
1026 
1027     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1028         uint256 currentRate =  _getRate();
1029         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1030         uint256 rLock =  tLock.mul(currentRate);
1031         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1032         if(inSwapAndLiquify) {
1033             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1034             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1035             emit Transfer(sender, recipient, tAmount);
1036         } else {
1037             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1038             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1039             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1040             _reflectFee(rFee, tFee);
1041             emit Transfer(sender, address(this), tLock);
1042             emit Transfer(sender, recipient, tTransferAmount);
1043         }
1044     }
1045 
1046     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1047         uint256 currentRate =  _getRate();
1048         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1049         uint256 rLock =  tLock.mul(currentRate);
1050         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1051         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1052         if(inSwapAndLiquify) {
1053             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1054             emit Transfer(sender, recipient, tAmount);
1055         } else {
1056             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1057             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1058             _reflectFee(rFee, tFee);
1059             emit Transfer(sender, address(this), tLock);
1060             emit Transfer(sender, recipient, tTransferAmount);
1061         }
1062     }
1063 
1064     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1065         uint256 currentRate =  _getRate();
1066         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1067         uint256 rLock =  tLock.mul(currentRate);
1068         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1069         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1070         if(inSwapAndLiquify) {
1071             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1072             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1073             emit Transfer(sender, recipient, tAmount);
1074         }
1075         else {
1076             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1077             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1078             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1079             _reflectFee(rFee, tFee);
1080             emit Transfer(sender, address(this), tLock);
1081             emit Transfer(sender, recipient, tTransferAmount);
1082         }
1083     }
1084 
1085     function _reflectFee(uint256 rFee, uint256 tFee) private {
1086         _rTotal = _rTotal.sub(rFee);
1087         _tFeeTotal = _tFeeTotal.add(tFee);
1088     }
1089 
1090     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1091         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1092         uint256 currentRate =  _getRate();
1093         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1094         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1095     }
1096 
1097     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1098         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1099         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1100         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1101         return (tTransferAmount, tFee, tLockFee);
1102     }
1103 
1104     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1105         uint256 rAmount = tAmount.mul(currentRate);
1106         uint256 rFee = tFee.mul(currentRate);
1107         uint256 rLock = tLock.mul(currentRate);
1108         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1109         return (rAmount, rTransferAmount, rFee);
1110     }
1111 
1112     function _getRate() public view returns(uint256) {
1113         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1114         return rSupply.div(tSupply);
1115     }
1116 
1117     function _getCurrentSupply() public view returns(uint256, uint256) {
1118         uint256 rSupply = _rTotal;
1119         uint256 tSupply = _tTotal;      
1120         for (uint256 i = 0; i < _excluded.length; i++) {
1121             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1122             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1123             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1124         }
1125         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1126         return (rSupply, tSupply);
1127     }
1128     
1129     function getCurrentPoolAddress() public view returns(address) {
1130         return currentPoolAddress;
1131     }
1132     
1133     function getCurrentPairTokenAddress() public view returns(address) {
1134         return currentPairTokenAddress;
1135     }
1136 
1137     function getLiquidityRemoveFee() public view returns(uint256) {
1138         return _liquidityRemoveFee;
1139     }
1140     
1141     function getAlchemyCallerFee() public view returns(uint256) {
1142         return _alchemyCallerFee;
1143     }
1144     
1145     function getLastAlchemy() public view returns(uint256) {
1146         return _lastAlchemy;
1147     }
1148     
1149     function getAlchemyInterval() public view returns(uint256) {
1150         return _alchemyInterval;
1151     }
1152     
1153     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1154         require(feeDecimals >= 0 && feeDecimals <= 2, 'Ouroboros: fee decimals should be in 0 - 2');
1155         _feeDecimals = feeDecimals;
1156         emit FeeDecimalsUpdated(feeDecimals);
1157     }
1158     
1159     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1160         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Ouroboros: taxFee should be in 0 - 5');
1161         _taxFee = taxFee;
1162         emit TaxFeeUpdated(taxFee);
1163     }
1164     
1165     function _setLockFee(uint256 lockFee) external onlyOwner() {
1166         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Ouroboros: lockFee should be in 0 - 5');
1167         _lockFee = lockFee;
1168         emit LockFeeUpdated(lockFee);
1169     }
1170     
1171     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1172         require(maxTxAmount >= 500000e9 , 'Ouroboros: maxTxAmount should be greater than 500000e9');
1173         _maxTxAmount = maxTxAmount;
1174         emit MaxTxAmountUpdated(maxTxAmount);
1175     }
1176     
1177     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1178         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Ouroboros: minTokenBeforeSwap should be in 50e9 - 25000e9');
1179         require(minTokensBeforeSwap > _autoSwapCallerFee , 'Ouroboros: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1180         _minTokensBeforeSwap = minTokensBeforeSwap;
1181         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1182     }
1183     
1184     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1185         require(autoSwapCallerFee >= 1e9, 'Ouroboros: autoSwapCallerFee should be greater than 1e9');
1186         _autoSwapCallerFee = autoSwapCallerFee;
1187         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1188     }
1189     
1190     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1191         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Ouroboros: liquidityRemoveFee should be in 1 - 10');
1192         _liquidityRemoveFee = liquidityRemoveFee;
1193         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1194     }
1195     
1196     function _setAlchemyCallerFee(uint256 alchemyCallerFee) external onlyOwner() {
1197         require(alchemyCallerFee >= 1 && alchemyCallerFee <= 15 , 'Ouroboros: alchemyCallerFee should be in 1 - 15');
1198         _alchemyCallerFee = alchemyCallerFee;
1199         emit AlchemyCallerFeeUpdated(alchemyCallerFee);
1200     }
1201     
1202     function _setAlchemyInterval(uint256 alchemyInterval) external onlyOwner() {
1203         _alchemyInterval = alchemyInterval;
1204         emit AlchemyIntervalUpdated(alchemyInterval);
1205     }
1206     
1207     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1208         swapAndLiquifyEnabled = _enabled;
1209         emit SwapAndLiquifyEnabledUpdated(_enabled);
1210     }
1211     
1212     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1213         require(poolAddress != address(0), "Ouroboros: Pool address is zero.");
1214         require(pairTokenAddress != address(0), "Ouroboros: Pair token address is zero.");
1215         require(pairTokenAddress != address(this), "Ouroboros: Pair token address self address.");
1216         require(pairTokenAddress != currentPairTokenAddress, "Ouroboros: Pair token address is same as current one.");
1217         
1218         currentPoolAddress = poolAddress;
1219         currentPairTokenAddress = pairTokenAddress;
1220         
1221         emit WhitelistUpdated(pairTokenAddress);
1222     }
1223 
1224     function _enableTrading() external onlyOwner() {
1225         tradingEnabled = true;
1226         TradingEnabled();
1227     }
1228 }