1 // SPDX-License-Identifier: MIT
2 // https://t.me/MRINITYprotocol
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor () internal {
420         address msgSender = _msgSender();
421         _owner = msgSender;
422         emit OwnershipTransferred(address(0), msgSender);
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(_owner == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 
464 interface IUniswapV2Factory {
465     function createPair(address tokenA, address tokenB) external returns (address pair);
466 }
467 
468 interface IUniswapV2Pair {
469     function sync() external;
470 }
471 
472 interface IUniswapV2Router01 {
473     function factory() external pure returns (address);
474     function WETH() external pure returns (address);
475     function addLiquidity(
476         address tokenA,
477         address tokenB,
478         uint amountADesired,
479         uint amountBDesired,
480         uint amountAMin,
481         uint amountBMin,
482         address to,
483         uint deadline
484     ) external returns (uint amountA, uint amountB, uint liquidity);
485     function addLiquidityETH(
486         address token,
487         uint amountTokenDesired,
488         uint amountTokenMin,
489         uint amountETHMin,
490         address to,
491         uint deadline
492     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
493 }
494 
495 interface IUniswapV2Router02 is IUniswapV2Router01 {
496     function removeLiquidityETHSupportingFeeOnTransferTokens(
497       address token,
498       uint liquidity,
499       uint amountTokenMin,
500       uint amountETHMin,
501       address to,
502       uint deadline
503     ) external returns (uint amountETH);
504     function swapExactTokensForETHSupportingFeeOnTransferTokens(
505         uint amountIn,
506         uint amountOutMin,
507         address[] calldata path,
508         address to,
509         uint deadline
510     ) external;
511     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
512         uint amountIn,
513         uint amountOutMin,
514         address[] calldata path,
515         address to,
516         uint deadline
517     ) external;
518     function swapExactETHForTokensSupportingFeeOnTransferTokens(
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external payable;
524 }
525 
526 pragma solidity ^0.6.12;
527 
528 contract RewardWallet {
529     constructor() public {
530     }
531 }
532 
533 contract Balancer {
534     using SafeMath for uint256;
535     IUniswapV2Router02 public immutable _uniswapV2Router;
536     MRINITY private _tokenContract;
537     
538     constructor(MRINITY tokenContract, IUniswapV2Router02 uniswapV2Router) public {
539         _tokenContract =tokenContract;
540         _uniswapV2Router = uniswapV2Router;
541     }
542     
543     receive() external payable {}
544     
545     function rebalance() external returns (uint256) { 
546         swapEthForTokens(address(this).balance);
547     }
548 
549     function swapEthForTokens(uint256 EthAmount) private {
550         address[] memory uniswapPairPath = new address[](2);
551         uniswapPairPath[0] = _uniswapV2Router.WETH();
552         uniswapPairPath[1] = address(_tokenContract);
553 
554         _uniswapV2Router
555             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
556                 0,
557                 uniswapPairPath,
558                 address(this),
559                 block.timestamp
560             );
561     }
562 }
563 
564 contract Swapper {
565     using SafeMath for uint256;
566     IUniswapV2Router02 public immutable _uniswapV2Router;
567     MRINITY private _tokenContract;
568     
569     constructor(MRINITY tokenContract, IUniswapV2Router02 uniswapV2Router) public {
570         _tokenContract = tokenContract;
571         _uniswapV2Router = uniswapV2Router;
572     }
573     
574     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
575         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
576         swapTokensForTokens(pairTokenAddress, tokenAmount);
577         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
578         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
579     }
580     
581     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
582         address[] memory path = new address[](2);
583         path[0] = address(_tokenContract);
584         path[1] = pairTokenAddress;
585 
586         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
587 
588         // make the swap
589         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
590             tokenAmount,
591             0, // accept any amount of pair token
592             path,
593             address(this),
594             block.timestamp
595         );
596     }
597 }
598 
599 contract MRINITY is Context, IERC20, Ownable {
600     using SafeMath for uint256;
601     using Address for address;
602 
603     IUniswapV2Router02 public immutable _uniswapV2Router;
604 
605     mapping (address => uint256) private _rOwned;
606     mapping (address => uint256) private _tOwned;
607     mapping (address => mapping (address => uint256)) private _allowances;
608 
609     mapping (address => bool) private _isExcluded;
610     address[] private _excluded;
611     address public _rewardWallet;
612     uint256 public _initialRewardLockAmount;
613     address public _uniswapETHPool;
614     
615     uint256 private constant MAX = ~uint256(0);
616     uint256 private _tTotal = 10000000e9;
617     uint256 private _rTotal = (MAX - (MAX % _tTotal));
618     uint256 public _tFeeTotal;
619     uint256 public _tBurnTotal;
620 
621     string private _name = 'Mrinity';
622     string private _symbol = 'MRINITY';
623     uint8 private _decimals = 9;
624     
625     uint256 public _feeDecimals = 1;
626     uint256 public _taxFee = 0;
627     uint256 public _lockFee = 0;
628     uint256 public _maxTxAmount = 2000000e9;
629     uint256 public _minTokensBeforeSwap = 10000e9;
630     uint256 public _minInterestForReward = 10e9;
631     uint256 private _autoSwapCallerFee = 200e9;
632     
633     bool private inSwapAndLiquify;
634     bool public swapAndLiquifyEnabled;
635     bool public tradingEnabled;
636     
637     address private currentPairTokenAddress;
638     address private currentPoolAddress;
639     
640     uint256 private _liquidityRemoveFee = 2;
641     uint256 private _magicCallerFee = 5;
642     uint256 private _minTokenForMagic = 1000e9;
643     uint256 private _lastMagic;
644     uint256 private _magicInterval = 1 hours;
645     
646 
647     event FeeDecimalsUpdated(uint256 taxFeeDecimals);
648     event TaxFeeUpdated(uint256 taxFee);
649     event LockFeeUpdated(uint256 lockFee);
650     event MaxTxAmountUpdated(uint256 maxTxAmount);
651     event WhitelistUpdated(address indexed pairTokenAddress);
652     event TradingEnabled();
653     event SwapAndLiquifyEnabledUpdated(bool enabled);
654     event SwapAndLiquify(
655         address indexed pairTokenAddress,
656         uint256 tokensSwapped,
657         uint256 pairTokenReceived,
658         uint256 tokensIntoLiqudity
659     );
660     event Rebalance(uint256 tokenBurnt);
661     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
662     event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
663     event MinInterestForRewardUpdated(uint256 minInterestForReward);
664     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
665     event MagicCallerFeeUpdated(uint256 rebalanceCallerFee);
666     event MinTokenForMagicUpdated(uint256 minRebalanceAmount);
667     event MagicIntervalUpdated(uint256 rebalanceInterval);
668 
669     modifier lockTheSwap {
670         inSwapAndLiquify = true;
671         _;
672         inSwapAndLiquify = false;
673     }
674     
675     Balancer public balancer;
676     Swapper public swapper;
677 
678     constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
679         _lastMagic = now;
680         
681         _uniswapV2Router = uniswapV2Router;
682         _rewardWallet = address(new RewardWallet());
683         _initialRewardLockAmount = initialRewardLockAmount;
684         
685         balancer = new Balancer(this, uniswapV2Router);
686         swapper = new Swapper(this, uniswapV2Router);
687         
688         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
689             .createPair(address(this), uniswapV2Router.WETH());
690         currentPairTokenAddress = uniswapV2Router.WETH();
691         _uniswapETHPool = currentPoolAddress;
692         
693         updateSwapAndLiquifyEnabled(false);
694         
695         _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
696         _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
697         
698         emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
699         emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
700     }
701 
702     function name() public view returns (string memory) {
703         return _name;
704     }
705 
706     function symbol() public view returns (string memory) {
707         return _symbol;
708     }
709 
710     function decimals() public view returns (uint8) {
711         return _decimals;
712     }
713 
714     function totalSupply() public view override returns (uint256) {
715         return _tTotal;
716     }
717 
718     function balanceOf(address account) public view override returns (uint256) {
719         if (_isExcluded[account]) return _tOwned[account];
720         return tokenFromReflection(_rOwned[account]);
721     }
722 
723     function transfer(address recipient, uint256 amount) public override returns (bool) {
724         _transfer(_msgSender(), recipient, amount);
725         return true;
726     }
727 
728     function allowance(address owner, address spender) public view override returns (uint256) {
729         return _allowances[owner][spender];
730     }
731 
732     function approve(address spender, uint256 amount) public override returns (bool) {
733         _approve(_msgSender(), spender, amount);
734         return true;
735     }
736 
737     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
738         _transfer(sender, recipient, amount);
739         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
740         return true;
741     }
742 
743     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
744         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
745         return true;
746     }
747 
748     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
749         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
750         return true;
751     }
752 
753     function isExcluded(address account) public view returns (bool) {
754         return _isExcluded[account];
755     }
756 
757     
758     function reflect(uint256 tAmount) public {
759         address sender = _msgSender();
760         require(!_isExcluded[sender], "Mrinity: Excluded addresses cannot call this function");
761         (uint256 rAmount,,,,,) = _getValues(tAmount);
762         _rOwned[sender] = _rOwned[sender].sub(rAmount);
763         _rTotal = _rTotal.sub(rAmount);
764         _tFeeTotal = _tFeeTotal.add(tAmount);
765     }
766 
767     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
768         require(tAmount <= _tTotal, "Amount must be less than supply");
769         if (!deductTransferFee) {
770             (uint256 rAmount,,,,,) = _getValues(tAmount);
771             return rAmount;
772         } else {
773             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
774             return rTransferAmount;
775         }
776     }
777 
778     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
779         require(rAmount <= _rTotal, "Mrinity: Amount must be less than total reflections");
780         uint256 currentRate =  _getRate();
781         return rAmount.div(currentRate);
782     }
783 
784     function excludeAccount(address account) external onlyOwner() {
785         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Mrinity: We can not exclude Uniswap router.');
786         require(account != address(this), 'Mrinity: We can not exclude contract self.');
787         require(account != _rewardWallet, 'Mrinity: We can not exclude reweard wallet.');
788         require(!_isExcluded[account], "Mrinity: Account is already excluded");
789         
790         if(_rOwned[account] > 0) {
791             _tOwned[account] = tokenFromReflection(_rOwned[account]);
792         }
793         _isExcluded[account] = true;
794         _excluded.push(account);
795     }
796 
797     function includeAccount(address account) external onlyOwner() {
798         require(_isExcluded[account], "Mrinity: Account is already included");
799         for (uint256 i = 0; i < _excluded.length; i++) {
800             if (_excluded[i] == account) {
801                 _excluded[i] = _excluded[_excluded.length - 1];
802                 _tOwned[account] = 0;
803                 _isExcluded[account] = false;
804                 _excluded.pop();
805                 break;
806             }
807         }
808     }
809 
810     function _approve(address owner, address spender, uint256 amount) private {
811         require(owner != address(0), "Mrinity: approve from the zero address");
812         require(spender != address(0), "Mrinity: approve to the zero address");
813 
814         _allowances[owner][spender] = amount;
815         emit Approval(owner, spender, amount);
816     }
817 
818     function _transfer(address sender, address recipient, uint256 amount) private {
819         require(sender != address(0), "Mrinity: transfer from the zero address");
820         require(recipient != address(0), "Mrinity: transfer to the zero address");
821         require(amount > 0, "Mrinity: Transfer amount must be greater than zero");
822         
823         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
824             require(amount <= _maxTxAmount, "Mrinity: Transfer amount exceeds the maxTxAmount.");
825             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
826                 require(false, "Mrinity: trading is disabled.");
827         }
828         
829         if(!inSwapAndLiquify) {
830             uint256 lockedBalanceForPool = balanceOf(address(this));
831             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
832             if (
833                 overMinTokenBalance &&
834                 msg.sender != currentPoolAddress &&
835                 swapAndLiquifyEnabled
836             ) {
837                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
838                     swapAndLiquifyForEth(lockedBalanceForPool);
839                 else
840                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
841             }
842         }
843         
844         if (_isExcluded[sender] && !_isExcluded[recipient]) {
845             _transferFromExcluded(sender, recipient, amount);
846         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
847             _transferToExcluded(sender, recipient, amount);
848         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
849             _transferStandard(sender, recipient, amount);
850         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
851             _transferBothExcluded(sender, recipient, amount);
852         } else {
853             _transferStandard(sender, recipient, amount);
854         }
855     }
856     
857     receive() external payable {}
858     
859     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
860         // split the contract balance except swapCallerFee into halves
861         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
862         uint256 half = lockedForSwap.div(2);
863         uint256 otherHalf = lockedForSwap.sub(half);
864 
865         // capture the contract's current ETH balance.
866         // this is so that we can capture exactly the amount of ETH that the
867         // swap creates, and not make the liquidity event include any ETH that
868         // has been manually sent to the contract
869         uint256 initialBalance = address(this).balance;
870 
871         // swap tokens for ETH
872         swapTokensForEth(half);
873         
874         // how much ETH did we just swap into?
875         uint256 newBalance = address(this).balance.sub(initialBalance);
876 
877         // add liquidity to uniswap
878         addLiquidityForEth(otherHalf, newBalance);
879         
880         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
881         
882         _transfer(address(this), tx.origin, _autoSwapCallerFee);
883         
884         _sendRewardInterestToPool();
885     }
886     
887     function swapTokensForEth(uint256 tokenAmount) private {
888         // generate the uniswap pair path of token -> weth
889         address[] memory path = new address[](2);
890         path[0] = address(this);
891         path[1] = _uniswapV2Router.WETH();
892 
893         _approve(address(this), address(_uniswapV2Router), tokenAmount);
894 
895         // make the swap
896         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
897             tokenAmount,
898             0, // accept any amount of ETH
899             path,
900             address(this),
901             block.timestamp
902         );
903     }
904 
905     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
906         // approve token transfer to cover all possible scenarios
907         _approve(address(this), address(_uniswapV2Router), tokenAmount);
908 
909         // add the liquidity
910         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
911             address(this),
912             tokenAmount,
913             0, // slippage is unavoidable
914             0, // slippage is unavoidable
915             address(this),
916             block.timestamp
917         );
918     }
919     
920     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
921         // split the contract balance except swapCallerFee into halves
922         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
923         uint256 half = lockedForSwap.div(2);
924         uint256 otherHalf = lockedForSwap.sub(half);
925         
926         _transfer(address(this), address(swapper), half);
927         
928         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
929         
930         // swap tokens for pairToken
931         swapper.swapTokens(pairTokenAddress, half);
932         
933         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
934 
935         // add liquidity to uniswap
936         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
937         
938         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
939         
940         _transfer(address(this), tx.origin, _autoSwapCallerFee);
941         
942         _sendRewardInterestToPool();
943     }
944 
945     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
946         // approve token transfer to cover all possible scenarios
947         _approve(address(this), address(_uniswapV2Router), tokenAmount);
948         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
949 
950         // add the liquidity
951         _uniswapV2Router.addLiquidity(
952             address(this),
953             pairTokenAddress,
954             tokenAmount,
955             pairTokenAmount,
956             0, // slippage is unavoidable
957             0, // slippage is unavoidable
958             address(this),
959             block.timestamp
960         );
961     }
962 
963     function magic() public lockTheSwap {
964         require(balanceOf(_msgSender()) >= _minTokenForMagic, "Mrinity: You do not have enough Mrinity to ");
965         require(now > _lastMagic + _magicInterval, 'Mrinity: Too Soon.');
966         
967         _lastMagic = now;
968 
969         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
970 
971         removeLiquidityETH(amountToRemove);
972         balancer.rebalance();
973 
974         uint256 tNewTokenBalance = balanceOf(address(balancer));
975         uint256 tRewardForCaller = tNewTokenBalance.mul(_magicCallerFee).div(100);
976         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
977         
978         uint256 currentRate =  _getRate();
979         uint256 rBurn =  tBurn.mul(currentRate);
980         
981         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
982         _rOwned[address(balancer)] = 0;
983         
984         _tBurnTotal = _tBurnTotal.add(tBurn);
985         _tTotal = _tTotal.sub(tBurn);
986         _rTotal = _rTotal.sub(rBurn);
987 
988         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
989         emit Transfer(address(balancer), address(0), tBurn);
990         emit Rebalance(tBurn);
991     }
992     
993     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
994         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
995         (ETHAmount) = _uniswapV2Router
996             .removeLiquidityETHSupportingFeeOnTransferTokens(
997                 address(this),
998                 lpAmount,
999                 0,
1000                 0,
1001                 address(balancer),
1002                 block.timestamp
1003             );
1004     }
1005 
1006     function _sendRewardInterestToPool() private {
1007         uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
1008         if(tRewardInterest > _minInterestForReward) {
1009             uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
1010             _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
1011             _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
1012             emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
1013             IUniswapV2Pair(currentPoolAddress).sync();
1014         }
1015     }
1016 
1017     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1018         uint256 currentRate =  _getRate();
1019         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1020         uint256 rLock =  tLock.mul(currentRate);
1021         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1022         if(inSwapAndLiquify) {
1023             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1024             emit Transfer(sender, recipient, tAmount);
1025         } else {
1026             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1027             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1028             _reflectFee(rFee, tFee);
1029             emit Transfer(sender, address(this), tLock);
1030             emit Transfer(sender, recipient, tTransferAmount);
1031         }
1032     }
1033 
1034     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1035         uint256 currentRate =  _getRate();
1036         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1037         uint256 rLock =  tLock.mul(currentRate);
1038         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1039         if(inSwapAndLiquify) {
1040             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1041             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1042             emit Transfer(sender, recipient, tAmount);
1043         } else {
1044             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1045             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1046             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1047             _reflectFee(rFee, tFee);
1048             emit Transfer(sender, address(this), tLock);
1049             emit Transfer(sender, recipient, tTransferAmount);
1050         }
1051     }
1052 
1053     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1054         uint256 currentRate =  _getRate();
1055         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1056         uint256 rLock =  tLock.mul(currentRate);
1057         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1058         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1059         if(inSwapAndLiquify) {
1060             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1061             emit Transfer(sender, recipient, tAmount);
1062         } else {
1063             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1064             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1065             _reflectFee(rFee, tFee);
1066             emit Transfer(sender, address(this), tLock);
1067             emit Transfer(sender, recipient, tTransferAmount);
1068         }
1069     }
1070 
1071     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1072         uint256 currentRate =  _getRate();
1073         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1074         uint256 rLock =  tLock.mul(currentRate);
1075         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1076         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1077         if(inSwapAndLiquify) {
1078             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1079             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1080             emit Transfer(sender, recipient, tAmount);
1081         }
1082         else {
1083             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1084             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1085             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1086             _reflectFee(rFee, tFee);
1087             emit Transfer(sender, address(this), tLock);
1088             emit Transfer(sender, recipient, tTransferAmount);
1089         }
1090     }
1091 
1092     function _reflectFee(uint256 rFee, uint256 tFee) private {
1093         _rTotal = _rTotal.sub(rFee);
1094         _tFeeTotal = _tFeeTotal.add(tFee);
1095     }
1096 
1097     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1098         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1099         uint256 currentRate =  _getRate();
1100         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1101         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1102     }
1103 
1104     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1105         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1106         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1107         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1108         return (tTransferAmount, tFee, tLockFee);
1109     }
1110 
1111     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1112         uint256 rAmount = tAmount.mul(currentRate);
1113         uint256 rFee = tFee.mul(currentRate);
1114         uint256 rLock = tLock.mul(currentRate);
1115         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1116         return (rAmount, rTransferAmount, rFee);
1117     }
1118 
1119     function _getRate() public view returns(uint256) {
1120         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1121         return rSupply.div(tSupply);
1122     }
1123 
1124     function _getCurrentSupply() public view returns(uint256, uint256) {
1125         uint256 rSupply = _rTotal;
1126         uint256 tSupply = _tTotal;      
1127         for (uint256 i = 0; i < _excluded.length; i++) {
1128             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1129             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1130             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1131         }
1132         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1133         return (rSupply, tSupply);
1134     }
1135     
1136     function getCurrentPoolAddress() public view returns(address) {
1137         return currentPoolAddress;
1138     }
1139     
1140     function getCurrentPairTokenAddress() public view returns(address) {
1141         return currentPairTokenAddress;
1142     }
1143 
1144     function getLiquidityRemoveFee() public view returns(uint256) {
1145         return _liquidityRemoveFee;
1146     }
1147     
1148     function getMagicCallerFee() public view returns(uint256) {
1149         return _magicCallerFee;
1150     }
1151     
1152     function getMinTokenForMagic() public view returns(uint256) {
1153         return _minTokenForMagic;
1154     }
1155     
1156     function getLastMagic() public view returns(uint256) {
1157         return _lastMagic;
1158     }
1159     
1160     function getMagicInterval() public view returns(uint256) {
1161         return _magicInterval;
1162     }
1163     
1164     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1165         require(feeDecimals >= 0 && feeDecimals <= 2, 'Mrinity: fee decimals should be in 0 - 2');
1166         _feeDecimals = feeDecimals;
1167         emit FeeDecimalsUpdated(feeDecimals);
1168     }
1169     
1170     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1171         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Mrinity: taxFee should be in 0 - 5');
1172         _taxFee = taxFee;
1173         emit TaxFeeUpdated(taxFee);
1174     }
1175     
1176     function _setLockFee(uint256 lockFee) external onlyOwner() {
1177         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Mrinity: lockFee should be in 0 - 5');
1178         _lockFee = lockFee;
1179         emit LockFeeUpdated(lockFee);
1180     }
1181     
1182     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1183         require(maxTxAmount >= 500000e9 , 'Mrinity: maxTxAmount should be greater than 500000e9');
1184         _maxTxAmount = maxTxAmount;
1185         emit MaxTxAmountUpdated(maxTxAmount);
1186     }
1187     
1188     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1189         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Mrinity: minTokenBeforeSwap should be in 50e9 - 25000e9');
1190         require(minTokensBeforeSwap > _autoSwapCallerFee , 'Mrinity: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1191         _minTokensBeforeSwap = minTokensBeforeSwap;
1192         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1193     }
1194     
1195     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1196         require(autoSwapCallerFee >= 1e9, 'Mrinity: autoSwapCallerFee should be greater than 1e9');
1197         _autoSwapCallerFee = autoSwapCallerFee;
1198         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1199     }
1200     
1201     function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
1202         _minInterestForReward = minInterestForReward;
1203         emit MinInterestForRewardUpdated(minInterestForReward);
1204     }
1205     
1206     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1207         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Mrinity: liquidityRemoveFee should be in 1 - 10');
1208         _liquidityRemoveFee = liquidityRemoveFee;
1209         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1210     }
1211     
1212     function _setMagicCallerFee(uint256 magicCallerFee) external onlyOwner() {
1213         require(magicCallerFee >= 1 && magicCallerFee <= 15 , 'Mrinity: magicCallerFee should be in 1 - 15');
1214         _magicCallerFee = magicCallerFee;
1215         emit MagicCallerFeeUpdated(magicCallerFee);
1216     }
1217     
1218     function _setMinTokenForMagic(uint256 minTokenForMagic) external onlyOwner() {
1219         _minTokenForMagic = minTokenForMagic;
1220         emit MinTokenForMagicUpdated(minTokenForMagic);
1221     }
1222     
1223     function _setMagicInterval(uint256 magicInterval) external onlyOwner() {
1224         _magicInterval = magicInterval;
1225         emit MagicIntervalUpdated(magicInterval);
1226     }
1227     
1228     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1229         swapAndLiquifyEnabled = _enabled;
1230         emit SwapAndLiquifyEnabledUpdated(_enabled);
1231     }
1232     
1233     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1234         require(poolAddress != address(0), "Mrinity: Pool address is zero.");
1235         require(pairTokenAddress != address(0), "Mrinity: Pair token address is zero.");
1236         require(pairTokenAddress != address(this), "Mrinity: Pair token address self address.");
1237         require(pairTokenAddress != currentPairTokenAddress, "Mrinity: Pair token address is same as current one.");
1238         
1239         currentPoolAddress = poolAddress;
1240         currentPairTokenAddress = pairTokenAddress;
1241         
1242         emit WhitelistUpdated(pairTokenAddress);
1243     }
1244 
1245     function _enableTrading() external onlyOwner() {
1246         tradingEnabled = true;
1247         TradingEnabled();
1248     }
1249 }