1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284         // for accounts without code, i.e. `keccak256('')`
285         bytes32 codehash;
286         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { codehash := extcodehash(account) }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 /**
399  * @dev Contract module which provides a basic access control mechanism, where
400  * there is an account (an owner) that can be granted exclusive access to
401  * specific functions.
402  *
403  * By default, the owner account will be the one that deploys the contract. This
404  * can later be changed with {transferOwnership}.
405  *
406  * This module is used through inheritance. It will make available the modifier
407  * `onlyOwner`, which can be applied to your functions to restrict their use to
408  * the owner.
409  */
410 contract Ownable is Context {
411     address private _owner;
412 
413     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
414 
415     /**
416      * @dev Initializes the contract setting the deployer as the initial owner.
417      */
418     constructor () internal {
419         address msgSender = _msgSender();
420         _owner = msgSender;
421         emit OwnershipTransferred(address(0), msgSender);
422     }
423 
424     /**
425      * @dev Returns the address of the current owner.
426      */
427     function owner() public view returns (address) {
428         return _owner;
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         require(_owner == _msgSender(), "Ownable: caller is not the owner");
436         _;
437     }
438 
439     /**
440      * @dev Leaves the contract without owner. It will not be possible to call
441      * `onlyOwner` functions anymore. Can only be called by the current owner.
442      *
443      * NOTE: Renouncing ownership will leave the contract without an owner,
444      * thereby removing any functionality that is only available to the owner.
445      */
446     function renounceOwnership() public virtual onlyOwner {
447         emit OwnershipTransferred(_owner, address(0));
448         _owner = address(0);
449     }
450 
451     /**
452      * @dev Transfers ownership of the contract to a new account (`newOwner`).
453      * Can only be called by the current owner.
454      */
455     function transferOwnership(address newOwner) public virtual onlyOwner {
456         require(newOwner != address(0), "Ownable: new owner is the zero address");
457         emit OwnershipTransferred(_owner, newOwner);
458         _owner = newOwner;
459     }
460 }
461 
462 
463 interface IUniswapV2Factory {
464     function createPair(address tokenA, address tokenB) external returns (address pair);
465 }
466 
467 interface IUniswapV2Pair {
468     function sync() external;
469 }
470 
471 interface IUniswapV2Router01 {
472     function factory() external pure returns (address);
473     function WETH() external pure returns (address);
474     function addLiquidity(
475         address tokenA,
476         address tokenB,
477         uint amountADesired,
478         uint amountBDesired,
479         uint amountAMin,
480         uint amountBMin,
481         address to,
482         uint deadline
483     ) external returns (uint amountA, uint amountB, uint liquidity);
484     function addLiquidityETH(
485         address token,
486         uint amountTokenDesired,
487         uint amountTokenMin,
488         uint amountETHMin,
489         address to,
490         uint deadline
491     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
492 }
493 
494 interface IUniswapV2Router02 is IUniswapV2Router01 {
495     function removeLiquidityETHSupportingFeeOnTransferTokens(
496       address token,
497       uint liquidity,
498       uint amountTokenMin,
499       uint amountETHMin,
500       address to,
501       uint deadline
502     ) external returns (uint amountETH);
503     function swapExactTokensForETHSupportingFeeOnTransferTokens(
504         uint amountIn,
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external;
510     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
511         uint amountIn,
512         uint amountOutMin,
513         address[] calldata path,
514         address to,
515         uint deadline
516     ) external;
517     function swapExactETHForTokensSupportingFeeOnTransferTokens(
518         uint amountOutMin,
519         address[] calldata path,
520         address to,
521         uint deadline
522     ) external payable;
523 }
524 
525 pragma solidity ^0.6.12;
526 
527 contract RewardWallet {
528     constructor() public {
529     }
530 }
531 
532 contract Balancer {
533     using SafeMath for uint256;
534     IUniswapV2Router02 public immutable _uniswapV2Router;
535     HOLYTRINITY private _tokenContract;
536     
537     constructor(HOLYTRINITY tokenContract, IUniswapV2Router02 uniswapV2Router) public {
538         _tokenContract =tokenContract;
539         _uniswapV2Router = uniswapV2Router;
540     }
541     
542     receive() external payable {}
543     
544     function rebalance() external returns (uint256) { 
545         swapEthForTokens(address(this).balance);
546     }
547 
548     function swapEthForTokens(uint256 EthAmount) private {
549         address[] memory uniswapPairPath = new address[](2);
550         uniswapPairPath[0] = _uniswapV2Router.WETH();
551         uniswapPairPath[1] = address(_tokenContract);
552 
553         _uniswapV2Router
554             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
555                 0,
556                 uniswapPairPath,
557                 address(this),
558                 block.timestamp
559             );
560     }
561 }
562 
563 contract Swaper {
564     using SafeMath for uint256;
565     IUniswapV2Router02 public immutable _uniswapV2Router;
566     HOLYTRINITY private _tokenContract;
567     
568     constructor(HOLYTRINITY tokenContract, IUniswapV2Router02 uniswapV2Router) public {
569         _tokenContract = tokenContract;
570         _uniswapV2Router = uniswapV2Router;
571     }
572     
573     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
574         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
575         swapTokensForTokens(pairTokenAddress, tokenAmount);
576         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
577         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
578     }
579     
580     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
581         address[] memory path = new address[](2);
582         path[0] = address(_tokenContract);
583         path[1] = pairTokenAddress;
584 
585         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
586 
587         // make the swap
588         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
589             tokenAmount,
590             0, // accept any amount of pair token
591             path,
592             address(this),
593             block.timestamp
594         );
595     }
596 }
597 
598 contract HOLYTRINITY is Context, IERC20, Ownable {
599     using SafeMath for uint256;
600     using Address for address;
601 
602     IUniswapV2Router02 public immutable _uniswapV2Router;
603 
604     mapping (address => uint256) private _rOwned;
605     mapping (address => uint256) private _tOwned;
606     mapping (address => mapping (address => uint256)) private _allowances;
607 
608     mapping (address => bool) private _isExcluded;
609     address[] private _excluded;
610     address public _rewardWallet;
611     uint256 public _initialRewardLockAmount;
612     address public _uniswapETHPool;
613     
614     uint256 private constant MAX = ~uint256(0);
615     uint256 private _tTotal = 10000000e9;
616     uint256 private _rTotal = (MAX - (MAX % _tTotal));
617     uint256 public _tFeeTotal;
618     uint256 public _tBurnTotal;
619 
620     string private _name = 'HolyTrinity';
621     string private _symbol = 'HOLY';
622     uint8 private _decimals = 9;
623     
624     uint256 public _feeDecimals = 1;
625     uint256 public _taxFee = 0;
626     uint256 public _lockFee = 0;
627     uint256 public _maxTxAmount = 2000000e9;
628     uint256 public _minTokensBeforeSwap = 10000e9;
629     uint256 public _minInterestForReward = 10e9;
630     uint256 private _autoSwapCallerFee = 200e9;
631     
632     bool private inSwapAndLiquify;
633     bool public swapAndLiquifyEnabled;
634     bool public tradingEnabled;
635     
636     address private currentPairTokenAddress;
637     address private currentPoolAddress;
638     
639     uint256 private _liquidityRemoveFee = 2;
640     uint256 private _alchemyCallerFee = 5;
641     uint256 private _minTokenForAlchemy = 1000e9;
642     uint256 private _lastAlchemy;
643     uint256 private _alchemyInterval = 1 hours;
644     
645 
646     event FeeDecimalsUpdated(uint256 taxFeeDecimals);
647     event TaxFeeUpdated(uint256 taxFee);
648     event LockFeeUpdated(uint256 lockFee);
649     event MaxTxAmountUpdated(uint256 maxTxAmount);
650     event WhitelistUpdated(address indexed pairTokenAddress);
651     event TradingEnabled();
652     event SwapAndLiquifyEnabledUpdated(bool enabled);
653     event SwapAndLiquify(
654         address indexed pairTokenAddress,
655         uint256 tokensSwapped,
656         uint256 pairTokenReceived,
657         uint256 tokensIntoLiqudity
658     );
659     event Rebalance(uint256 tokenBurnt);
660     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
661     event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
662     event MinInterestForRewardUpdated(uint256 minInterestForReward);
663     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
664     event AlchemyCallerFeeUpdated(uint256 rebalnaceCallerFee);
665     event MinTokenForAlchemyUpdated(uint256 minRebalanceAmount);
666     event AlchemyIntervalUpdated(uint256 rebalanceInterval);
667 
668     modifier lockTheSwap {
669         inSwapAndLiquify = true;
670         _;
671         inSwapAndLiquify = false;
672     }
673     
674     Balancer public balancer;
675     Swaper public swaper;
676 
677     constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
678         _lastAlchemy = now;
679         
680         _uniswapV2Router = uniswapV2Router;
681         _rewardWallet = address(new RewardWallet());
682         _initialRewardLockAmount = initialRewardLockAmount;
683         
684         balancer = new Balancer(this, uniswapV2Router);
685         swaper = new Swaper(this, uniswapV2Router);
686         
687         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
688             .createPair(address(this), uniswapV2Router.WETH());
689         currentPairTokenAddress = uniswapV2Router.WETH();
690         _uniswapETHPool = currentPoolAddress;
691         
692         updateSwapAndLiquifyEnabled(false);
693         
694         _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
695         _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
696         
697         emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
698         emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
699     }
700 
701     function name() public view returns (string memory) {
702         return _name;
703     }
704 
705     function symbol() public view returns (string memory) {
706         return _symbol;
707     }
708 
709     function decimals() public view returns (uint8) {
710         return _decimals;
711     }
712 
713     function totalSupply() public view override returns (uint256) {
714         return _tTotal;
715     }
716 
717     function balanceOf(address account) public view override returns (uint256) {
718         if (_isExcluded[account]) return _tOwned[account];
719         return tokenFromReflection(_rOwned[account]);
720     }
721 
722     function transfer(address recipient, uint256 amount) public override returns (bool) {
723         _transfer(_msgSender(), recipient, amount);
724         return true;
725     }
726 
727     function allowance(address owner, address spender) public view override returns (uint256) {
728         return _allowances[owner][spender];
729     }
730 
731     function approve(address spender, uint256 amount) public override returns (bool) {
732         _approve(_msgSender(), spender, amount);
733         return true;
734     }
735 
736     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
737         _transfer(sender, recipient, amount);
738         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
739         return true;
740     }
741 
742     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
743         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
744         return true;
745     }
746 
747     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
748         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
749         return true;
750     }
751 
752     function isExcluded(address account) public view returns (bool) {
753         return _isExcluded[account];
754     }
755 
756     
757     function reflect(uint256 tAmount) public {
758         address sender = _msgSender();
759         require(!_isExcluded[sender], "HolyTrinity: Excluded addresses cannot call this function");
760         (uint256 rAmount,,,,,) = _getValues(tAmount);
761         _rOwned[sender] = _rOwned[sender].sub(rAmount);
762         _rTotal = _rTotal.sub(rAmount);
763         _tFeeTotal = _tFeeTotal.add(tAmount);
764     }
765 
766     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
767         require(tAmount <= _tTotal, "Amount must be less than supply");
768         if (!deductTransferFee) {
769             (uint256 rAmount,,,,,) = _getValues(tAmount);
770             return rAmount;
771         } else {
772             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
773             return rTransferAmount;
774         }
775     }
776 
777     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
778         require(rAmount <= _rTotal, "HolyTrinity: Amount must be less than total reflections");
779         uint256 currentRate =  _getRate();
780         return rAmount.div(currentRate);
781     }
782 
783     function excludeAccount(address account) external onlyOwner() {
784         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'HolyTrinity: We can not exclude Uniswap router.');
785         require(account != address(this), 'HolyTrinity: We can not exclude contract self.');
786         require(account != _rewardWallet, 'HolyTrinity: We can not exclude reweard wallet.');
787         require(!_isExcluded[account], "HolyTrinity: Account is already excluded");
788         
789         if(_rOwned[account] > 0) {
790             _tOwned[account] = tokenFromReflection(_rOwned[account]);
791         }
792         _isExcluded[account] = true;
793         _excluded.push(account);
794     }
795 
796     function includeAccount(address account) external onlyOwner() {
797         require(_isExcluded[account], "HolyTrinity: Account is already included");
798         for (uint256 i = 0; i < _excluded.length; i++) {
799             if (_excluded[i] == account) {
800                 _excluded[i] = _excluded[_excluded.length - 1];
801                 _tOwned[account] = 0;
802                 _isExcluded[account] = false;
803                 _excluded.pop();
804                 break;
805             }
806         }
807     }
808 
809     function _approve(address owner, address spender, uint256 amount) private {
810         require(owner != address(0), "HolyTrinity: approve from the zero address");
811         require(spender != address(0), "HolyTrinity: approve to the zero address");
812 
813         _allowances[owner][spender] = amount;
814         emit Approval(owner, spender, amount);
815     }
816 
817     function _transfer(address sender, address recipient, uint256 amount) private {
818         require(sender != address(0), "HolyTrinity: transfer from the zero address");
819         require(recipient != address(0), "HolyTrinity: transfer to the zero address");
820         require(amount > 0, "HolyTrinity: Transfer amount must be greater than zero");
821         
822         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
823             require(amount <= _maxTxAmount, "HolyTrinity: Transfer amount exceeds the maxTxAmount.");
824             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
825                 require(false, "HolyTrinity: trading is disabled.");
826         }
827         
828         if(!inSwapAndLiquify) {
829             uint256 lockedBalanceForPool = balanceOf(address(this));
830             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
831             if (
832                 overMinTokenBalance &&
833                 msg.sender != currentPoolAddress &&
834                 swapAndLiquifyEnabled
835             ) {
836                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
837                     swapAndLiquifyForEth(lockedBalanceForPool);
838                 else
839                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
840             }
841         }
842         
843         if (_isExcluded[sender] && !_isExcluded[recipient]) {
844             _transferFromExcluded(sender, recipient, amount);
845         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
846             _transferToExcluded(sender, recipient, amount);
847         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
848             _transferStandard(sender, recipient, amount);
849         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
850             _transferBothExcluded(sender, recipient, amount);
851         } else {
852             _transferStandard(sender, recipient, amount);
853         }
854     }
855     
856     receive() external payable {}
857     
858     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
859         // split the contract balance except swapCallerFee into halves
860         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
861         uint256 half = lockedForSwap.div(2);
862         uint256 otherHalf = lockedForSwap.sub(half);
863 
864         // capture the contract's current ETH balance.
865         // this is so that we can capture exactly the amount of ETH that the
866         // swap creates, and not make the liquidity event include any ETH that
867         // has been manually sent to the contract
868         uint256 initialBalance = address(this).balance;
869 
870         // swap tokens for ETH
871         swapTokensForEth(half);
872         
873         // how much ETH did we just swap into?
874         uint256 newBalance = address(this).balance.sub(initialBalance);
875 
876         // add liquidity to uniswap
877         addLiquidityForEth(otherHalf, newBalance);
878         
879         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
880         
881         _transfer(address(this), tx.origin, _autoSwapCallerFee);
882         
883         _sendRewardInterestToPool();
884     }
885     
886     function swapTokensForEth(uint256 tokenAmount) private {
887         // generate the uniswap pair path of token -> weth
888         address[] memory path = new address[](2);
889         path[0] = address(this);
890         path[1] = _uniswapV2Router.WETH();
891 
892         _approve(address(this), address(_uniswapV2Router), tokenAmount);
893 
894         // make the swap
895         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
896             tokenAmount,
897             0, // accept any amount of ETH
898             path,
899             address(this),
900             block.timestamp
901         );
902     }
903 
904     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
905         // approve token transfer to cover all possible scenarios
906         _approve(address(this), address(_uniswapV2Router), tokenAmount);
907 
908         // add the liquidity
909         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
910             address(this),
911             tokenAmount,
912             0, // slippage is unavoidable
913             0, // slippage is unavoidable
914             address(this),
915             block.timestamp
916         );
917     }
918     
919     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
920         // split the contract balance except swapCallerFee into halves
921         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
922         uint256 half = lockedForSwap.div(2);
923         uint256 otherHalf = lockedForSwap.sub(half);
924         
925         _transfer(address(this), address(swaper), half);
926         
927         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
928         
929         // swap tokens for pairToken
930         swaper.swapTokens(pairTokenAddress, half);
931         
932         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
933 
934         // add liquidity to uniswap
935         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
936         
937         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
938         
939         _transfer(address(this), tx.origin, _autoSwapCallerFee);
940         
941         _sendRewardInterestToPool();
942     }
943 
944     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
945         // approve token transfer to cover all possible scenarios
946         _approve(address(this), address(_uniswapV2Router), tokenAmount);
947         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
948 
949         // add the liquidity
950         _uniswapV2Router.addLiquidity(
951             address(this),
952             pairTokenAddress,
953             tokenAmount,
954             pairTokenAmount,
955             0, // slippage is unavoidable
956             0, // slippage is unavoidable
957             address(this),
958             block.timestamp
959         );
960     }
961 
962     function alchemy() public lockTheSwap {
963         require(balanceOf(_msgSender()) >= _minTokenForAlchemy, "HolyTrinity: You have not enough HolyTrinity to ");
964         require(now > _lastAlchemy + _alchemyInterval, 'HolyTrinity: Too Soon.');
965         
966         _lastAlchemy = now;
967 
968         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
969 
970         removeLiquidityETH(amountToRemove);
971         balancer.rebalance();
972 
973         uint256 tNewTokenBalance = balanceOf(address(balancer));
974         uint256 tRewardForCaller = tNewTokenBalance.mul(_alchemyCallerFee).div(100);
975         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
976         
977         uint256 currentRate =  _getRate();
978         uint256 rBurn =  tBurn.mul(currentRate);
979         
980         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
981         _rOwned[address(balancer)] = 0;
982         
983         _tBurnTotal = _tBurnTotal.add(tBurn);
984         _tTotal = _tTotal.sub(tBurn);
985         _rTotal = _rTotal.sub(rBurn);
986 
987         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
988         emit Transfer(address(balancer), address(0), tBurn);
989         emit Rebalance(tBurn);
990     }
991     
992     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
993         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
994         (ETHAmount) = _uniswapV2Router
995             .removeLiquidityETHSupportingFeeOnTransferTokens(
996                 address(this),
997                 lpAmount,
998                 0,
999                 0,
1000                 address(balancer),
1001                 block.timestamp
1002             );
1003     }
1004 
1005     function _sendRewardInterestToPool() private {
1006         uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
1007         if(tRewardInterest > _minInterestForReward) {
1008             uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
1009             _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
1010             _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
1011             emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
1012             IUniswapV2Pair(currentPoolAddress).sync();
1013         }
1014     }
1015 
1016     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1017         uint256 currentRate =  _getRate();
1018         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1019         uint256 rLock =  tLock.mul(currentRate);
1020         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1021         if(inSwapAndLiquify) {
1022             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1023             emit Transfer(sender, recipient, tAmount);
1024         } else {
1025             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1026             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1027             _reflectFee(rFee, tFee);
1028             emit Transfer(sender, address(this), tLock);
1029             emit Transfer(sender, recipient, tTransferAmount);
1030         }
1031     }
1032 
1033     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1034         uint256 currentRate =  _getRate();
1035         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1036         uint256 rLock =  tLock.mul(currentRate);
1037         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1038         if(inSwapAndLiquify) {
1039             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1040             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1041             emit Transfer(sender, recipient, tAmount);
1042         } else {
1043             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1044             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1045             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1046             _reflectFee(rFee, tFee);
1047             emit Transfer(sender, address(this), tLock);
1048             emit Transfer(sender, recipient, tTransferAmount);
1049         }
1050     }
1051 
1052     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1053         uint256 currentRate =  _getRate();
1054         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1055         uint256 rLock =  tLock.mul(currentRate);
1056         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1057         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1058         if(inSwapAndLiquify) {
1059             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1060             emit Transfer(sender, recipient, tAmount);
1061         } else {
1062             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1063             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1064             _reflectFee(rFee, tFee);
1065             emit Transfer(sender, address(this), tLock);
1066             emit Transfer(sender, recipient, tTransferAmount);
1067         }
1068     }
1069 
1070     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1071         uint256 currentRate =  _getRate();
1072         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1073         uint256 rLock =  tLock.mul(currentRate);
1074         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1075         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1076         if(inSwapAndLiquify) {
1077             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1078             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1079             emit Transfer(sender, recipient, tAmount);
1080         }
1081         else {
1082             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1083             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1084             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1085             _reflectFee(rFee, tFee);
1086             emit Transfer(sender, address(this), tLock);
1087             emit Transfer(sender, recipient, tTransferAmount);
1088         }
1089     }
1090 
1091     function _reflectFee(uint256 rFee, uint256 tFee) private {
1092         _rTotal = _rTotal.sub(rFee);
1093         _tFeeTotal = _tFeeTotal.add(tFee);
1094     }
1095 
1096     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1097         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1098         uint256 currentRate =  _getRate();
1099         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1100         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1101     }
1102 
1103     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1104         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1105         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1106         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1107         return (tTransferAmount, tFee, tLockFee);
1108     }
1109 
1110     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1111         uint256 rAmount = tAmount.mul(currentRate);
1112         uint256 rFee = tFee.mul(currentRate);
1113         uint256 rLock = tLock.mul(currentRate);
1114         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1115         return (rAmount, rTransferAmount, rFee);
1116     }
1117 
1118     function _getRate() public view returns(uint256) {
1119         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1120         return rSupply.div(tSupply);
1121     }
1122 
1123     function _getCurrentSupply() public view returns(uint256, uint256) {
1124         uint256 rSupply = _rTotal;
1125         uint256 tSupply = _tTotal;      
1126         for (uint256 i = 0; i < _excluded.length; i++) {
1127             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1128             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1129             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1130         }
1131         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1132         return (rSupply, tSupply);
1133     }
1134     
1135     function getCurrentPoolAddress() public view returns(address) {
1136         return currentPoolAddress;
1137     }
1138     
1139     function getCurrentPairTokenAddress() public view returns(address) {
1140         return currentPairTokenAddress;
1141     }
1142 
1143     function getLiquidityRemoveFee() public view returns(uint256) {
1144         return _liquidityRemoveFee;
1145     }
1146     
1147     function getAlchemyCallerFee() public view returns(uint256) {
1148         return _alchemyCallerFee;
1149     }
1150     
1151     function getMinTokenForAlchemy() public view returns(uint256) {
1152         return _minTokenForAlchemy;
1153     }
1154     
1155     function getLastAlchemy() public view returns(uint256) {
1156         return _lastAlchemy;
1157     }
1158     
1159     function getAlchemyInterval() public view returns(uint256) {
1160         return _alchemyInterval;
1161     }
1162     
1163     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1164         require(feeDecimals >= 0 && feeDecimals <= 2, 'HolyTrinity: fee decimals should be in 0 - 2');
1165         _feeDecimals = feeDecimals;
1166         emit FeeDecimalsUpdated(feeDecimals);
1167     }
1168     
1169     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1170         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'HolyTrinity: taxFee should be in 0 - 5');
1171         _taxFee = taxFee;
1172         emit TaxFeeUpdated(taxFee);
1173     }
1174     
1175     function _setLockFee(uint256 lockFee) external onlyOwner() {
1176         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'HolyTrinity: lockFee should be in 0 - 5');
1177         _lockFee = lockFee;
1178         emit LockFeeUpdated(lockFee);
1179     }
1180     
1181     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1182         require(maxTxAmount >= 500000e9 , 'HolyTrinity: maxTxAmount should be greater than 500000e9');
1183         _maxTxAmount = maxTxAmount;
1184         emit MaxTxAmountUpdated(maxTxAmount);
1185     }
1186     
1187     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1188         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'HolyTrinity: minTokenBeforeSwap should be in 50e9 - 25000e9');
1189         require(minTokensBeforeSwap > _autoSwapCallerFee , 'HolyTrinity: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1190         _minTokensBeforeSwap = minTokensBeforeSwap;
1191         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1192     }
1193     
1194     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1195         require(autoSwapCallerFee >= 1e9, 'HolyTrinity: autoSwapCallerFee should be greater than 1e9');
1196         _autoSwapCallerFee = autoSwapCallerFee;
1197         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1198     }
1199     
1200     function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
1201         _minInterestForReward = minInterestForReward;
1202         emit MinInterestForRewardUpdated(minInterestForReward);
1203     }
1204     
1205     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1206         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'HolyTrinity: liquidityRemoveFee should be in 1 - 10');
1207         _liquidityRemoveFee = liquidityRemoveFee;
1208         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1209     }
1210     
1211     function _setAlchemyCallerFee(uint256 alchemyCallerFee) external onlyOwner() {
1212         require(alchemyCallerFee >= 1 && alchemyCallerFee <= 15 , 'HolyTrinity: alchemyCallerFee should be in 1 - 15');
1213         _alchemyCallerFee = alchemyCallerFee;
1214         emit AlchemyCallerFeeUpdated(alchemyCallerFee);
1215     }
1216     
1217     function _setMinTokenForAlchemy(uint256 minTokenForAlchemy) external onlyOwner() {
1218         _minTokenForAlchemy = minTokenForAlchemy;
1219         emit MinTokenForAlchemyUpdated(minTokenForAlchemy);
1220     }
1221     
1222     function _setAlchemyInterval(uint256 alchemyInterval) external onlyOwner() {
1223         _alchemyInterval = alchemyInterval;
1224         emit AlchemyIntervalUpdated(alchemyInterval);
1225     }
1226     
1227     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1228         swapAndLiquifyEnabled = _enabled;
1229         emit SwapAndLiquifyEnabledUpdated(_enabled);
1230     }
1231     
1232     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1233         require(poolAddress != address(0), "HolyTrinity: Pool address is zero.");
1234         require(pairTokenAddress != address(0), "HolyTrinity: Pair token address is zero.");
1235         require(pairTokenAddress != address(this), "HolyTrinity: Pair token address self address.");
1236         require(pairTokenAddress != currentPairTokenAddress, "HolyTrinity: Pair token address is same as current one.");
1237         
1238         currentPoolAddress = poolAddress;
1239         currentPairTokenAddress = pairTokenAddress;
1240         
1241         emit WhitelistUpdated(pairTokenAddress);
1242     }
1243 
1244     function _enableTrading() external onlyOwner() {
1245         tradingEnabled = true;
1246         TradingEnabled();
1247     }
1248 }