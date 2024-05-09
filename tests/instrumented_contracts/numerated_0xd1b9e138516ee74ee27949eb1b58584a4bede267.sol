1 // SPDX-License-Identifier: MIT
2 /*
3               _   _  _  ___ ___ _    
4              /_\ | \| |/ __| __| |   
5             / _ \| .` | (_ | _|| |__ 
6            /_/ \_\_|\_|\___|___|____|
7                            
8         .--------.  <<<<*>>>>  .--------.
9        / .-----.  \  ,#####,  /  .-----. \
10       / /{{{{{{{`. \ #_   _# / .`}}} }}}\ \
11      / /{{ {{{ {{ ".\|6` `6|/."}} }}}} }}\ \
12     { {{ {{{ {{{{ {{;|  u  |;} }} }} }} }}} }
13     { {{{{ {{{{ {{{{ \  =  /}}} }} }} }}} } }
14     { { {{{ {{{{{ {{{|\___/|} }} }} }}}} }} }
15     { {{{ {{{ {{____/:     :\____}}}}}} }}} }
16     { {{{{.'"""`.-===-\   /-===-.`"""'.}} } }
17     { {{{/           ""-.-""           \}}} }
18     \ \/'                              '\/ /
19 */
20 
21 pragma solidity ^0.6.0;
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      *
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b != 0, errorMessage);
274         return a % b;
275     }
276 }
277 
278 /**
279  * @dev Collection of functions related to the address type
280  */
281 library Address {
282     /**
283      * @dev Returns true if `account` is a contract.
284      *
285      * [IMPORTANT]
286      * ====
287      * It is unsafe to assume that an address for which this function returns
288      * false is an externally-owned account (EOA) and not a contract.
289      *
290      * Among others, `isContract` will return false for the following
291      * types of addresses:
292      *
293      *  - an externally-owned account
294      *  - a contract in construction
295      *  - an address where a contract will be created
296      *  - an address where a contract lived, but was destroyed
297      * ====
298      */
299     function isContract(address account) internal view returns (bool) {
300         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
301         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
302         // for accounts without code, i.e. `keccak256('')`
303         bytes32 codehash;
304         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
305         // solhint-disable-next-line no-inline-assembly
306         assembly { codehash := extcodehash(account) }
307         return (codehash != accountHash && codehash != 0x0);
308     }
309 
310     /**
311      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
312      * `recipient`, forwarding all available gas and reverting on errors.
313      *
314      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
315      * of certain opcodes, possibly making contracts go over the 2300 gas limit
316      * imposed by `transfer`, making them unable to receive funds via
317      * `transfer`. {sendValue} removes this limitation.
318      *
319      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
320      *
321      * IMPORTANT: because control is transferred to `recipient`, care must be
322      * taken to not create reentrancy vulnerabilities. Consider using
323      * {ReentrancyGuard} or the
324      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
325      */
326     function sendValue(address payable recipient, uint256 amount) internal {
327         require(address(this).balance >= amount, "Address: insufficient balance");
328 
329         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
330         (bool success, ) = recipient.call{ value: amount }("");
331         require(success, "Address: unable to send value, recipient may have reverted");
332     }
333 
334     /**
335      * @dev Performs a Solidity function call using a low level `call`. A
336      * plain`call` is an unsafe replacement for a function call: use this
337      * function instead.
338      *
339      * If `target` reverts with a revert reason, it is bubbled up by this
340      * function (like regular Solidity function calls).
341      *
342      * Returns the raw returned data. To convert to the expected return value,
343      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
344      *
345      * Requirements:
346      *
347      * - `target` must be a contract.
348      * - calling `target` with `data` must not revert.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
353       return functionCall(target, data, "Address: low-level call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
358      * `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
378         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
383      * with `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
388         require(address(this).balance >= value, "Address: insufficient balance for call");
389         return _functionCallWithValue(target, data, value, errorMessage);
390     }
391 
392     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
393         require(isContract(target), "Address: call to non-contract");
394 
395         // solhint-disable-next-line avoid-low-level-calls
396         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 /**
417  * @dev Contract module which provides a basic access control mechanism, where
418  * there is an account (an owner) that can be granted exclusive access to
419  * specific functions.
420  *
421  * By default, the owner account will be the one that deploys the contract. This
422  * can later be changed with {transferOwnership}.
423  *
424  * This module is used through inheritance. It will make available the modifier
425  * `onlyOwner`, which can be applied to your functions to restrict their use to
426  * the owner.
427  */
428 contract Ownable is Context {
429     address private _owner;
430 
431     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
432 
433     /**
434      * @dev Initializes the contract setting the deployer as the initial owner.
435      */
436     constructor () internal {
437         address msgSender = _msgSender();
438         _owner = msgSender;
439         emit OwnershipTransferred(address(0), msgSender);
440     }
441 
442     /**
443      * @dev Returns the address of the current owner.
444      */
445     function owner() public view returns (address) {
446         return _owner;
447     }
448 
449     /**
450      * @dev Throws if called by any account other than the owner.
451      */
452     modifier onlyOwner() {
453         require(_owner == _msgSender(), "Ownable: caller is not the owner");
454         _;
455     }
456 
457     /**
458      * @dev Leaves the contract without owner. It will not be possible to call
459      * `onlyOwner` functions anymore. Can only be called by the current owner.
460      *
461      * NOTE: Renouncing ownership will leave the contract without an owner,
462      * thereby removing any functionality that is only available to the owner.
463      */
464     function renounceOwnership() public virtual onlyOwner {
465         emit OwnershipTransferred(_owner, address(0));
466         _owner = address(0);
467     }
468 
469     /**
470      * @dev Transfers ownership of the contract to a new account (`newOwner`).
471      * Can only be called by the current owner.
472      */
473     function transferOwnership(address newOwner) public virtual onlyOwner {
474         require(newOwner != address(0), "Ownable: new owner is the zero address");
475         emit OwnershipTransferred(_owner, newOwner);
476         _owner = newOwner;
477     }
478 }
479 
480 
481 interface IUniswapV2Factory {
482     function createPair(address tokenA, address tokenB) external returns (address pair);
483 }
484 
485 interface IUniswapV2Pair {
486     function sync() external;
487 }
488 
489 interface IUniswapV2Router01 {
490     function factory() external pure returns (address);
491     function WETH() external pure returns (address);
492     function addLiquidity(
493         address tokenA,
494         address tokenB,
495         uint amountADesired,
496         uint amountBDesired,
497         uint amountAMin,
498         uint amountBMin,
499         address to,
500         uint deadline
501     ) external returns (uint amountA, uint amountB, uint liquidity);
502     function addLiquidityETH(
503         address token,
504         uint amountTokenDesired,
505         uint amountTokenMin,
506         uint amountETHMin,
507         address to,
508         uint deadline
509     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
510 }
511 
512 interface IUniswapV2Router02 is IUniswapV2Router01 {
513     function removeLiquidityETHSupportingFeeOnTransferTokens(
514       address token,
515       uint liquidity,
516       uint amountTokenMin,
517       uint amountETHMin,
518       address to,
519       uint deadline
520     ) external returns (uint amountETH);
521     function swapExactTokensForETHSupportingFeeOnTransferTokens(
522         uint amountIn,
523         uint amountOutMin,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external;
528     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
529         uint amountIn,
530         uint amountOutMin,
531         address[] calldata path,
532         address to,
533         uint deadline
534     ) external;
535     function swapExactETHForTokensSupportingFeeOnTransferTokens(
536         uint amountOutMin,
537         address[] calldata path,
538         address to,
539         uint deadline
540     ) external payable;
541 }
542 
543 pragma solidity ^0.6.12;
544 
545 contract RewardWallet {
546     constructor() public {
547     }
548 }
549 
550 contract Balancer {
551     using SafeMath for uint256;
552     IUniswapV2Router02 public immutable _uniswapV2Router;
553     ANGEL private _tokenContract;
554     
555     constructor(ANGEL tokenContract, IUniswapV2Router02 uniswapV2Router) public {
556         _tokenContract =tokenContract;
557         _uniswapV2Router = uniswapV2Router;
558     }
559     
560     receive() external payable {}
561     
562     function rebalance() external returns (uint256) { 
563         swapEthForTokens(address(this).balance);
564     }
565 
566     function swapEthForTokens(uint256 EthAmount) private {
567         address[] memory uniswapPairPath = new address[](2);
568         uniswapPairPath[0] = _uniswapV2Router.WETH();
569         uniswapPairPath[1] = address(_tokenContract);
570 
571         _uniswapV2Router
572             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
573                 0,
574                 uniswapPairPath,
575                 address(this),
576                 block.timestamp
577             );
578     }
579 }
580 
581 contract Swaper {
582     using SafeMath for uint256;
583     IUniswapV2Router02 public immutable _uniswapV2Router;
584     ANGEL private _tokenContract;
585     
586     constructor(ANGEL tokenContract, IUniswapV2Router02 uniswapV2Router) public {
587         _tokenContract = tokenContract;
588         _uniswapV2Router = uniswapV2Router;
589     }
590     
591     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
592         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
593         swapTokensForTokens(pairTokenAddress, tokenAmount);
594         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
595         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
596     }
597     
598     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
599         address[] memory path = new address[](2);
600         path[0] = address(_tokenContract);
601         path[1] = pairTokenAddress;
602 
603         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
604 
605         // make the swap
606         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
607             tokenAmount,
608             0, // accept any amount of pair token
609             path,
610             address(this),
611             block.timestamp
612         );
613     }
614 }
615 
616 contract ANGEL is Context, IERC20, Ownable {
617     using SafeMath for uint256;
618     using Address for address;
619 
620     IUniswapV2Router02 public immutable _uniswapV2Router;
621 
622     mapping (address => uint256) private _rOwned;
623     mapping (address => uint256) private _tOwned;
624     mapping (address => mapping (address => uint256)) private _allowances;
625 
626     mapping (address => bool) private _isExcluded;
627     address[] private _excluded;
628     address public _rewardWallet;
629     uint256 public _initialRewardLockAmount;
630     address public _uniswapETHPool;
631     
632     uint256 private constant MAX = ~uint256(0);
633     uint256 private _tTotal = 1860085e9;
634     uint256 private _rTotal = (MAX - (MAX % _tTotal));
635     uint256 public _tFeeTotal;
636     uint256 public _tBurnTotal;
637 
638     string private _name = 'Angel';
639     string private _symbol = 'AGL';
640     uint8 private _decimals = 9;
641     
642     uint256 public _feeDecimals = 1;
643     uint256 public _taxFee = 0;
644     uint256 public _lockFee = 0;
645     uint256 public _maxTxAmount = 1000000e9;
646     uint256 public _minTokensBeforeSwap = 2500e9;
647     uint256 public _minInterestForReward = 10e9;
648     uint256 private _autoSwapCallerFee = 200e9;
649     
650     bool private inSwapAndLiquify;
651     bool public swapAndLiquifyEnabled;
652     bool public tradingEnabled;
653     
654     address private currentPairTokenAddress;
655     address private currentPoolAddress;
656     
657     uint256 private _liquidityRemoveFee = 1;
658     uint256 private _rebirthCallerFee = 50;
659     uint256 private _minTokenForRebirth = 10000e9;
660     uint256 private _lastRebirth;
661     uint256 private _rebirthInterval = 8 hours;
662     
663 
664     event FeeDecimalsUpdated(uint256 taxFeeDecimals);
665     event TaxFeeUpdated(uint256 taxFee);
666     event LockFeeUpdated(uint256 lockFee);
667     event MaxTxAmountUpdated(uint256 maxTxAmount);
668     event WhitelistUpdated(address indexed pairTokenAddress);
669     event TradingEnabled();
670     event SwapAndLiquifyEnabledUpdated(bool enabled);
671     event SwapAndLiquify(
672         address indexed pairTokenAddress,
673         uint256 tokensSwapped,
674         uint256 pairTokenReceived,
675         uint256 tokensIntoLiqudity
676     );
677     event Rebalance(uint256 tokenBurnt);
678     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
679     event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
680     event MinInterestForRewardUpdated(uint256 minInterestForReward);
681     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
682     event RebirthCallerFeeUpdated(uint256 rebalnaceCallerFee);
683     event MinTokenForRebirthUpdated(uint256 minRebalanceAmount);
684     event RebirthIntervalUpdated(uint256 rebalanceInterval);
685 
686     modifier lockTheSwap {
687         inSwapAndLiquify = true;
688         _;
689         inSwapAndLiquify = false;
690     }
691     
692     Balancer public balancer;
693     Swaper public swaper;
694 
695     constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
696         _lastRebirth = now;
697         
698         _uniswapV2Router = uniswapV2Router;
699         _rewardWallet = address(new RewardWallet());
700         _initialRewardLockAmount = initialRewardLockAmount;
701         
702         balancer = new Balancer(this, uniswapV2Router);
703         swaper = new Swaper(this, uniswapV2Router);
704         
705         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
706             .createPair(address(this), uniswapV2Router.WETH());
707         currentPairTokenAddress = uniswapV2Router.WETH();
708         _uniswapETHPool = currentPoolAddress;
709         
710         updateSwapAndLiquifyEnabled(false);
711         
712         _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
713         _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
714         
715         emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
716         emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
717     }
718 
719     function name() public view returns (string memory) {
720         return _name;
721     }
722 
723     function symbol() public view returns (string memory) {
724         return _symbol;
725     }
726 
727     function decimals() public view returns (uint8) {
728         return _decimals;
729     }
730 
731     function totalSupply() public view override returns (uint256) {
732         return _tTotal;
733     }
734 
735     function balanceOf(address account) public view override returns (uint256) {
736         if (_isExcluded[account]) return _tOwned[account];
737         return tokenFromReflection(_rOwned[account]);
738     }
739 
740     function transfer(address recipient, uint256 amount) public override returns (bool) {
741         _transfer(_msgSender(), recipient, amount);
742         return true;
743     }
744 
745     function allowance(address owner, address spender) public view override returns (uint256) {
746         return _allowances[owner][spender];
747     }
748 
749     function approve(address spender, uint256 amount) public override returns (bool) {
750         _approve(_msgSender(), spender, amount);
751         return true;
752     }
753 
754     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
755         _transfer(sender, recipient, amount);
756         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
757         return true;
758     }
759 
760     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
761         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
762         return true;
763     }
764 
765     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
766         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
767         return true;
768     }
769 
770     function isExcluded(address account) public view returns (bool) {
771         return _isExcluded[account];
772     }
773 
774     
775     function reflect(uint256 tAmount) public {
776         address sender = _msgSender();
777         require(!_isExcluded[sender], "Angel: Excluded addresses cannot call this function");
778         (uint256 rAmount,,,,,) = _getValues(tAmount);
779         _rOwned[sender] = _rOwned[sender].sub(rAmount);
780         _rTotal = _rTotal.sub(rAmount);
781         _tFeeTotal = _tFeeTotal.add(tAmount);
782     }
783 
784     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
785         require(tAmount <= _tTotal, "Amount must be less than supply");
786         if (!deductTransferFee) {
787             (uint256 rAmount,,,,,) = _getValues(tAmount);
788             return rAmount;
789         } else {
790             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
791             return rTransferAmount;
792         }
793     }
794 
795     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
796         require(rAmount <= _rTotal, "Angel: Amount must be less than total reflections");
797         uint256 currentRate =  _getRate();
798         return rAmount.div(currentRate);
799     }
800 
801     function excludeAccount(address account) external onlyOwner() {
802         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Angel: We can not exclude Uniswap router.');
803         require(account != address(this), 'Angel: We can not exclude contract self.');
804         require(account != _rewardWallet, 'Angel: We can not exclude reweard wallet.');
805         require(!_isExcluded[account], "Angel: Account is already excluded");
806         
807         if(_rOwned[account] > 0) {
808             _tOwned[account] = tokenFromReflection(_rOwned[account]);
809         }
810         _isExcluded[account] = true;
811         _excluded.push(account);
812     }
813 
814     function includeAccount(address account) external onlyOwner() {
815         require(_isExcluded[account], "Angel: Account is already included");
816         for (uint256 i = 0; i < _excluded.length; i++) {
817             if (_excluded[i] == account) {
818                 _excluded[i] = _excluded[_excluded.length - 1];
819                 _tOwned[account] = 0;
820                 _isExcluded[account] = false;
821                 _excluded.pop();
822                 break;
823             }
824         }
825     }
826 
827     function _approve(address owner, address spender, uint256 amount) private {
828         require(owner != address(0), "Angel: approve from the zero address");
829         require(spender != address(0), "Angel: approve to the zero address");
830 
831         _allowances[owner][spender] = amount;
832         emit Approval(owner, spender, amount);
833     }
834 
835     function _transfer(address sender, address recipient, uint256 amount) private {
836         require(sender != address(0), "Angel: transfer from the zero address");
837         require(recipient != address(0), "Angel: transfer to the zero address");
838         require(amount > 0, "Angel: Transfer amount must be greater than zero");
839         
840         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
841             require(amount <= _maxTxAmount, "Angel: Transfer amount exceeds the maxTxAmount.");
842             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
843                 require(false, "Angel: trading is disabled.");
844         }
845         
846         if(!inSwapAndLiquify) {
847             uint256 lockedBalanceForPool = balanceOf(address(this));
848             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
849             if (
850                 overMinTokenBalance &&
851                 msg.sender != currentPoolAddress &&
852                 swapAndLiquifyEnabled
853             ) {
854                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
855                     swapAndLiquifyForEth(lockedBalanceForPool);
856                 else
857                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
858             }
859         }
860         
861         if (_isExcluded[sender] && !_isExcluded[recipient]) {
862             _transferFromExcluded(sender, recipient, amount);
863         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
864             _transferToExcluded(sender, recipient, amount);
865         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
866             _transferStandard(sender, recipient, amount);
867         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
868             _transferBothExcluded(sender, recipient, amount);
869         } else {
870             _transferStandard(sender, recipient, amount);
871         }
872     }
873     
874     receive() external payable {}
875     
876     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
877         // split the contract balance except swapCallerFee into halves
878         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
879         uint256 half = lockedForSwap.div(2);
880         uint256 otherHalf = lockedForSwap.sub(half);
881 
882         // capture the contract's current ETH balance.
883         // this is so that we can capture exactly the amount of ETH that the
884         // swap creates, and not make the liquidity event include any ETH that
885         // has been manually sent to the contract
886         uint256 initialBalance = address(this).balance;
887 
888         // swap tokens for ETH
889         swapTokensForEth(half);
890         
891         // how much ETH did we just swap into?
892         uint256 newBalance = address(this).balance.sub(initialBalance);
893 
894         // add liquidity to uniswap
895         addLiquidityForEth(otherHalf, newBalance);
896         
897         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
898         
899         _transfer(address(this), tx.origin, _autoSwapCallerFee);
900         
901         _sendRewardInterestToPool();
902     }
903     
904     function swapTokensForEth(uint256 tokenAmount) private {
905         // generate the uniswap pair path of token -> weth
906         address[] memory path = new address[](2);
907         path[0] = address(this);
908         path[1] = _uniswapV2Router.WETH();
909 
910         _approve(address(this), address(_uniswapV2Router), tokenAmount);
911 
912         // make the swap
913         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
914             tokenAmount,
915             0, // accept any amount of ETH
916             path,
917             address(this),
918             block.timestamp
919         );
920     }
921 
922     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
923         // approve token transfer to cover all possible scenarios
924         _approve(address(this), address(_uniswapV2Router), tokenAmount);
925 
926         // add the liquidity
927         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
928             address(this),
929             tokenAmount,
930             0, // slippage is unavoidable
931             0, // slippage is unavoidable
932             address(this),
933             block.timestamp
934         );
935     }
936     
937     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
938         // split the contract balance except swapCallerFee into halves
939         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
940         uint256 half = lockedForSwap.div(2);
941         uint256 otherHalf = lockedForSwap.sub(half);
942         
943         _transfer(address(this), address(swaper), half);
944         
945         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
946         
947         // swap tokens for pairToken
948         swaper.swapTokens(pairTokenAddress, half);
949         
950         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
951 
952         // add liquidity to uniswap
953         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
954         
955         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
956         
957         _transfer(address(this), tx.origin, _autoSwapCallerFee);
958         
959         _sendRewardInterestToPool();
960     }
961 
962     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
963         // approve token transfer to cover all possible scenarios
964         _approve(address(this), address(_uniswapV2Router), tokenAmount);
965         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
966 
967         // add the liquidity
968         _uniswapV2Router.addLiquidity(
969             address(this),
970             pairTokenAddress,
971             tokenAmount,
972             pairTokenAmount,
973             0, // slippage is unavoidable
974             0, // slippage is unavoidable
975             address(this),
976             block.timestamp
977         );
978     }
979 
980     function rebirth() public lockTheSwap {
981         require(balanceOf(_msgSender()) >= _minTokenForRebirth, "Angel: You have not enough Angel to ");
982         require(now > _lastRebirth + _rebirthInterval, 'Angel: Too Soon.');
983         
984         _lastRebirth = now;
985 
986         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
987 
988         removeLiquidityETH(amountToRemove);
989         balancer.rebalance();
990 
991         uint256 tNewTokenBalance = balanceOf(address(balancer));
992         uint256 tRewardForCaller = tNewTokenBalance.mul(_rebirthCallerFee).div(100);
993         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
994         
995         uint256 currentRate =  _getRate();
996         uint256 rBurn =  tBurn.mul(currentRate);
997         
998         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
999         _rOwned[address(balancer)] = 0;
1000         
1001         _tBurnTotal = _tBurnTotal.add(tBurn);
1002         _tTotal = _tTotal.sub(tBurn);
1003         _rTotal = _rTotal.sub(rBurn);
1004 
1005         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
1006         emit Transfer(address(balancer), address(0), tBurn);
1007         emit Rebalance(tBurn);
1008     }
1009     
1010     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
1011         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
1012         (ETHAmount) = _uniswapV2Router
1013             .removeLiquidityETHSupportingFeeOnTransferTokens(
1014                 address(this),
1015                 lpAmount,
1016                 0,
1017                 0,
1018                 address(balancer),
1019                 block.timestamp
1020             );
1021     }
1022 
1023     function _sendRewardInterestToPool() private {
1024         uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
1025         if(tRewardInterest > _minInterestForReward) {
1026             uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
1027             _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
1028             _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
1029             emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
1030             IUniswapV2Pair(currentPoolAddress).sync();
1031         }
1032     }
1033 
1034     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1035         uint256 currentRate =  _getRate();
1036         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1037         uint256 rLock =  tLock.mul(currentRate);
1038         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1039         if(inSwapAndLiquify) {
1040             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1041             emit Transfer(sender, recipient, tAmount);
1042         } else {
1043             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1044             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1045             _reflectFee(rFee, tFee);
1046             emit Transfer(sender, address(this), tLock);
1047             emit Transfer(sender, recipient, tTransferAmount);
1048         }
1049     }
1050 
1051     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1052         uint256 currentRate =  _getRate();
1053         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1054         uint256 rLock =  tLock.mul(currentRate);
1055         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1056         if(inSwapAndLiquify) {
1057             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1058             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1059             emit Transfer(sender, recipient, tAmount);
1060         } else {
1061             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1062             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1063             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1064             _reflectFee(rFee, tFee);
1065             emit Transfer(sender, address(this), tLock);
1066             emit Transfer(sender, recipient, tTransferAmount);
1067         }
1068     }
1069 
1070     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1071         uint256 currentRate =  _getRate();
1072         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1073         uint256 rLock =  tLock.mul(currentRate);
1074         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1075         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1076         if(inSwapAndLiquify) {
1077             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1078             emit Transfer(sender, recipient, tAmount);
1079         } else {
1080             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1081             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1082             _reflectFee(rFee, tFee);
1083             emit Transfer(sender, address(this), tLock);
1084             emit Transfer(sender, recipient, tTransferAmount);
1085         }
1086     }
1087 
1088     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1089         uint256 currentRate =  _getRate();
1090         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1091         uint256 rLock =  tLock.mul(currentRate);
1092         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1093         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1094         if(inSwapAndLiquify) {
1095             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1096             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1097             emit Transfer(sender, recipient, tAmount);
1098         }
1099         else {
1100             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1101             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1102             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1103             _reflectFee(rFee, tFee);
1104             emit Transfer(sender, address(this), tLock);
1105             emit Transfer(sender, recipient, tTransferAmount);
1106         }
1107     }
1108 
1109     function _reflectFee(uint256 rFee, uint256 tFee) private {
1110         _rTotal = _rTotal.sub(rFee);
1111         _tFeeTotal = _tFeeTotal.add(tFee);
1112     }
1113 
1114     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1115         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1116         uint256 currentRate =  _getRate();
1117         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1118         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1119     }
1120 
1121     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1122         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1123         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1124         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1125         return (tTransferAmount, tFee, tLockFee);
1126     }
1127 
1128     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1129         uint256 rAmount = tAmount.mul(currentRate);
1130         uint256 rFee = tFee.mul(currentRate);
1131         uint256 rLock = tLock.mul(currentRate);
1132         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1133         return (rAmount, rTransferAmount, rFee);
1134     }
1135 
1136     function _getRate() public view returns(uint256) {
1137         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1138         return rSupply.div(tSupply);
1139     }
1140 
1141     function _getCurrentSupply() public view returns(uint256, uint256) {
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
1153     function getCurrentPoolAddress() public view returns(address) {
1154         return currentPoolAddress;
1155     }
1156     
1157     function getCurrentPairTokenAddress() public view returns(address) {
1158         return currentPairTokenAddress;
1159     }
1160 
1161     function getLiquidityRemoveFee() public view returns(uint256) {
1162         return _liquidityRemoveFee;
1163     }
1164     
1165     function getRebirthCallerFee() public view returns(uint256) {
1166         return _rebirthCallerFee;
1167     }
1168     
1169     function getMinTokenForRebirth() public view returns(uint256) {
1170         return _minTokenForRebirth;
1171     }
1172     
1173     function getLastRebirth() public view returns(uint256) {
1174         return _lastRebirth;
1175     }
1176     
1177     function getRebirthInterval() public view returns(uint256) {
1178         return _rebirthInterval;
1179     }
1180     
1181     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1182         require(feeDecimals >= 0 && feeDecimals <= 2, 'Angel: fee decimals should be in 0 - 2');
1183         _feeDecimals = feeDecimals;
1184         emit FeeDecimalsUpdated(feeDecimals);
1185     }
1186     
1187     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1188         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Angel: taxFee should be in 0 - 5');
1189         _taxFee = taxFee;
1190         emit TaxFeeUpdated(taxFee);
1191     }
1192     
1193     function _setLockFee(uint256 lockFee) external onlyOwner() {
1194         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Angel: lockFee should be in 0 - 5');
1195         _lockFee = lockFee;
1196         emit LockFeeUpdated(lockFee);
1197     }
1198     
1199     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1200         require(maxTxAmount >= 500000e9 , 'Angel: maxTxAmount should be greater than 500000e9');
1201         _maxTxAmount = maxTxAmount;
1202         emit MaxTxAmountUpdated(maxTxAmount);
1203     }
1204     
1205     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1206         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Angel: minTokenBeforeSwap should be in 50e9 - 25000e9');
1207         require(minTokensBeforeSwap > _autoSwapCallerFee , 'Angel: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1208         _minTokensBeforeSwap = minTokensBeforeSwap;
1209         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1210     }
1211     
1212     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1213         require(autoSwapCallerFee >= 1e9, 'Angel: autoSwapCallerFee should be greater than 1e9');
1214         _autoSwapCallerFee = autoSwapCallerFee;
1215         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1216     }
1217     
1218     function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
1219         _minInterestForReward = minInterestForReward;
1220         emit MinInterestForRewardUpdated(minInterestForReward);
1221     }
1222     
1223     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1224         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Angel: liquidityRemoveFee should be in 1 - 10');
1225         _liquidityRemoveFee = liquidityRemoveFee;
1226         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1227     }
1228     
1229     function _setRebirthCallerFee(uint256 rebirthCallerFee) external onlyOwner() {
1230         require(rebirthCallerFee >= 1 && rebirthCallerFee <= 15 , 'Angel: rebirthCallerFee should be in 1 - 15');
1231         _rebirthCallerFee = rebirthCallerFee;
1232         emit RebirthCallerFeeUpdated(rebirthCallerFee);
1233     }
1234     
1235     function _setMinTokenForRebirth(uint256 minTokenForRebirth) external onlyOwner() {
1236         _minTokenForRebirth = minTokenForRebirth;
1237         emit MinTokenForRebirthUpdated(minTokenForRebirth);
1238     }
1239     
1240     function _setRebirthInterval(uint256 rebirthInterval) external onlyOwner() {
1241         _rebirthInterval = rebirthInterval;
1242         emit RebirthIntervalUpdated(rebirthInterval);
1243     }
1244     
1245     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1246         swapAndLiquifyEnabled = _enabled;
1247         emit SwapAndLiquifyEnabledUpdated(_enabled);
1248     }
1249     
1250     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1251         require(poolAddress != address(0), "Angel: Pool address is zero.");
1252         require(pairTokenAddress != address(0), "Angel: Pair token address is zero.");
1253         require(pairTokenAddress != address(this), "Angel: Pair token address self address.");
1254         require(pairTokenAddress != currentPairTokenAddress, "Angel: Pair token address is same as current one.");
1255         
1256         currentPoolAddress = poolAddress;
1257         currentPairTokenAddress = pairTokenAddress;
1258         
1259         emit WhitelistUpdated(pairTokenAddress);
1260     }
1261 
1262     function _enableTrading() external onlyOwner() {
1263         tradingEnabled = true;
1264         TradingEnabled();
1265     }
1266 }