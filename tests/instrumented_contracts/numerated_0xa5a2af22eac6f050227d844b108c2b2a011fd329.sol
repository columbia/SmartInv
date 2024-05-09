1 // SPDX-License-Identifier: MIT
2 
3 
4 //████████╗██╗░░░██╗███╗░░██╗███╗░░██╗███████╗██╗░░░░░
5 //╚══██╔══╝██║░░░██║████╗░██║████╗░██║██╔════╝██║░░░░░
6 //░░░██║░░░██║░░░██║██╔██╗██║██╔██╗██║█████╗░░██║░░░░░
7 //░░░██║░░░██║░░░██║██║╚████║██║╚████║██╔══╝░░██║░░░░░
8 //░░░██║░░░╚██████╔╝██║░╚███║██║░╚███║███████╗███████╗
9 //░░░╚═╝░░░░╚═════╝░╚═╝░░╚══╝╚═╝░░╚══╝╚══════╝╚══════╝
10 //
11 // Liquidity connector for DeFi     
12 // tunnelprotocol.io
13 
14 pragma solidity ^0.6.0;
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 
38 
39 /**
40  * @dev Interface of the ERC20 standard as defined in the EIP.
41  */
42 interface IERC20 {
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `recipient`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 }
112 
113 
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295         // for accounts without code, i.e. `keccak256('')`
296         bytes32 codehash;
297         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
298         // solhint-disable-next-line no-inline-assembly
299         assembly { codehash := extcodehash(account) }
300         return (codehash != accountHash && codehash != 0x0);
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{ value: amount }("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain`call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346       return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356         return _functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         return _functionCallWithValue(target, data, value, errorMessage);
383     }
384 
385     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 /**
410  * @dev Contract module which provides a basic access control mechanism, where
411  * there is an account (an owner) that can be granted exclusive access to
412  * specific functions.
413  *
414  * By default, the owner account will be the one that deploys the contract. This
415  * can later be changed with {transferOwnership}.
416  *
417  * This module is used through inheritance. It will make available the modifier
418  * `onlyOwner`, which can be applied to your functions to restrict their use to
419  * the owner.
420  */
421 contract Ownable is Context {
422     address private _owner;
423 
424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
425 
426     /**
427      * @dev Initializes the contract setting the deployer as the initial owner.
428      */
429     constructor () internal {
430         address msgSender = _msgSender();
431         _owner = msgSender;
432         emit OwnershipTransferred(address(0), msgSender);
433     }
434 
435     /**
436      * @dev Returns the address of the current owner.
437      */
438     function owner() public view returns (address) {
439         return _owner;
440     }
441 
442     /**
443      * @dev Throws if called by any account other than the owner.
444      */
445     modifier onlyOwner() {
446         require(_owner == _msgSender(), "Ownable: caller is not the owner");
447         _;
448     }
449 
450     /**
451      * @dev Leaves the contract without owner. It will not be possible to call
452      * `onlyOwner` functions anymore. Can only be called by the current owner.
453      *
454      * NOTE: Renouncing ownership will leave the contract without an owner,
455      * thereby removing any functionality that is only available to the owner.
456      */
457     function renounceOwnership() public virtual onlyOwner {
458         emit OwnershipTransferred(_owner, address(0));
459         _owner = address(0);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Can only be called by the current owner.
465      */
466     function transferOwnership(address newOwner) public virtual onlyOwner {
467         require(newOwner != address(0), "Ownable: new owner is the zero address");
468         emit OwnershipTransferred(_owner, newOwner);
469         _owner = newOwner;
470     }
471 }
472 
473 
474 interface IUniswapV2Factory {
475     function createPair(address tokenA, address tokenB) external returns (address pair);
476 }
477 
478 interface IUniswapV2Pair {
479     function sync() external;
480 }
481 
482 interface IUniswapV2Router01 {
483     function factory() external pure returns (address);
484     function WETH() external pure returns (address);
485     function addLiquidity(
486         address tokenA,
487         address tokenB,
488         uint amountADesired,
489         uint amountBDesired,
490         uint amountAMin,
491         uint amountBMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountA, uint amountB, uint liquidity);
495     function addLiquidityETH(
496         address token,
497         uint amountTokenDesired,
498         uint amountTokenMin,
499         uint amountETHMin,
500         address to,
501         uint deadline
502     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
503 }
504 
505 interface IUniswapV2Router02 is IUniswapV2Router01 {
506     function removeLiquidityETHSupportingFeeOnTransferTokens(
507       address token,
508       uint liquidity,
509       uint amountTokenMin,
510       uint amountETHMin,
511       address to,
512       uint deadline
513     ) external returns (uint amountETH);
514     function swapExactTokensForETHSupportingFeeOnTransferTokens(
515         uint amountIn,
516         uint amountOutMin,
517         address[] calldata path,
518         address to,
519         uint deadline
520     ) external;
521     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
522         uint amountIn,
523         uint amountOutMin,
524         address[] calldata path,
525         address to,
526         uint deadline
527     ) external;
528     function swapExactETHForTokensSupportingFeeOnTransferTokens(
529         uint amountOutMin,
530         address[] calldata path,
531         address to,
532         uint deadline
533     ) external payable;
534 }
535 
536 pragma solidity ^0.6.12;
537 
538 contract RewardWallet {
539     constructor() public {
540     }
541 }
542 
543 contract Balancer {
544     using SafeMath for uint256;
545     IUniswapV2Router02 public immutable _uniswapV2Router;
546     TUNNEL private _tokenContract;
547     
548     constructor(TUNNEL tokenContract, IUniswapV2Router02 uniswapV2Router) public {
549         _tokenContract =tokenContract;
550         _uniswapV2Router = uniswapV2Router;
551     }
552     
553     receive() external payable {}
554     
555     function rebalance() external returns (uint256) { 
556         swapEthForTokens(address(this).balance);
557     }
558 
559     function swapEthForTokens(uint256 EthAmount) private {
560         address[] memory uniswapPairPath = new address[](2);
561         uniswapPairPath[0] = _uniswapV2Router.WETH();
562         uniswapPairPath[1] = address(_tokenContract);
563 
564         _uniswapV2Router
565             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
566                 0,
567                 uniswapPairPath,
568                 address(this),
569                 block.timestamp
570             );
571     }
572 }
573 
574 contract Swaper {
575     using SafeMath for uint256;
576     IUniswapV2Router02 public immutable _uniswapV2Router;
577     TUNNEL private _tokenContract;
578     
579     constructor(TUNNEL tokenContract, IUniswapV2Router02 uniswapV2Router) public {
580         _tokenContract = tokenContract;
581         _uniswapV2Router = uniswapV2Router;
582     }
583     
584     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
585         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
586         swapTokensForTokens(pairTokenAddress, tokenAmount);
587         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
588         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
589     }
590     
591     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
592         address[] memory path = new address[](2);
593         path[0] = address(_tokenContract);
594         path[1] = pairTokenAddress;
595 
596         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
597 
598         // make the swap
599         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
600             tokenAmount,
601             0, // accept any amount of pair token
602             path,
603             address(this),
604             block.timestamp
605         );
606     }
607 }
608 
609 contract TUNNEL is Context, IERC20, Ownable {
610     using SafeMath for uint256;
611     using Address for address;
612 
613     IUniswapV2Router02 public immutable _uniswapV2Router;
614 
615     mapping (address => uint256) private _rOwned;
616     mapping (address => uint256) private _tOwned;
617     mapping (address => mapping (address => uint256)) private _allowances;
618 
619     mapping (address => bool) private _isExcluded;
620     address[] private _excluded;
621     address public _rewardWallet;
622     uint256 public _initialRewardLockAmount;
623     address public _uniswapETHPool;
624     
625     uint256 private constant MAX = ~uint256(0);
626     uint256 private _tTotal = 10000000e9;
627     uint256 private _rTotal = (MAX - (MAX % _tTotal));
628     uint256 public _tFeeTotal;
629     uint256 public _tBurnTotal;
630 
631     string private _name = 'Tunnel';
632     string private _symbol = 'TNI';
633     uint8 private _decimals = 9;
634     
635     uint256 public _feeDecimals = 1;
636     uint256 public _taxFee = 0;
637     uint256 public _lockFee = 0;
638     uint256 public _maxTxAmount = 2000000e9;
639     uint256 public _minTokensBeforeSwap = 10000e9;
640     uint256 public _minInterestForReward = 10e9;
641     uint256 private _autoSwapCallerFee = 200e9;
642     
643     bool private inSwapAndLiquify;
644     bool public swapAndLiquifyEnabled;
645     bool public tradingEnabled;
646     
647     address private currentPairTokenAddress;
648     address private currentPoolAddress;
649     
650     uint256 private _liquidityRemoveFee = 2;
651     uint256 private _alchemyCallerFee = 5;
652     uint256 private _minTokenForAlchemy = 1000e9;
653     uint256 private _lastAlchemy;
654     uint256 private _alchemyInterval = 1 hours;
655     
656 
657     event FeeDecimalsUpdated(uint256 taxFeeDecimals);
658     event TaxFeeUpdated(uint256 taxFee);
659     event LockFeeUpdated(uint256 lockFee);
660     event MaxTxAmountUpdated(uint256 maxTxAmount);
661     event WhitelistUpdated(address indexed pairTokenAddress);
662     event TradingEnabled();
663     event SwapAndLiquifyEnabledUpdated(bool enabled);
664     event SwapAndLiquify(
665         address indexed pairTokenAddress,
666         uint256 tokensSwapped,
667         uint256 pairTokenReceived,
668         uint256 tokensIntoLiqudity
669     );
670     event Rebalance(uint256 tokenBurnt);
671     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
672     event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
673     event MinInterestForRewardUpdated(uint256 minInterestForReward);
674     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
675     event AlchemyCallerFeeUpdated(uint256 rebalnaceCallerFee);
676     event MinTokenForAlchemyUpdated(uint256 minRebalanceAmount);
677     event AlchemyIntervalUpdated(uint256 rebalanceInterval);
678 
679     modifier lockTheSwap {
680         inSwapAndLiquify = true;
681         _;
682         inSwapAndLiquify = false;
683     }
684     
685     Balancer public balancer;
686     Swaper public swaper;
687 
688     constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
689         _lastAlchemy = now;
690         
691         _uniswapV2Router = uniswapV2Router;
692         _rewardWallet = address(new RewardWallet());
693         _initialRewardLockAmount = initialRewardLockAmount;
694         
695         balancer = new Balancer(this, uniswapV2Router);
696         swaper = new Swaper(this, uniswapV2Router);
697         
698         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
699             .createPair(address(this), uniswapV2Router.WETH());
700         currentPairTokenAddress = uniswapV2Router.WETH();
701         _uniswapETHPool = currentPoolAddress;
702         
703         updateSwapAndLiquifyEnabled(false);
704         
705         _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
706         _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
707         
708         emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
709         emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
710     }
711 
712     function name() public view returns (string memory) {
713         return _name;
714     }
715 
716     function symbol() public view returns (string memory) {
717         return _symbol;
718     }
719 
720     function decimals() public view returns (uint8) {
721         return _decimals;
722     }
723 
724     function totalSupply() public view override returns (uint256) {
725         return _tTotal;
726     }
727 
728     function balanceOf(address account) public view override returns (uint256) {
729         if (_isExcluded[account]) return _tOwned[account];
730         return tokenFromReflection(_rOwned[account]);
731     }
732 
733     function transfer(address recipient, uint256 amount) public override returns (bool) {
734         _transfer(_msgSender(), recipient, amount);
735         return true;
736     }
737 
738     function allowance(address owner, address spender) public view override returns (uint256) {
739         return _allowances[owner][spender];
740     }
741 
742     function approve(address spender, uint256 amount) public override returns (bool) {
743         _approve(_msgSender(), spender, amount);
744         return true;
745     }
746 
747     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
748         _transfer(sender, recipient, amount);
749         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
750         return true;
751     }
752 
753     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
754         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
755         return true;
756     }
757 
758     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
759         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
760         return true;
761     }
762 
763     function isExcluded(address account) public view returns (bool) {
764         return _isExcluded[account];
765     }
766 
767     
768     function reflect(uint256 tAmount) public {
769         address sender = _msgSender();
770         require(!_isExcluded[sender], "Tunnel: Excluded addresses cannot call this function");
771         (uint256 rAmount,,,,,) = _getValues(tAmount);
772         _rOwned[sender] = _rOwned[sender].sub(rAmount);
773         _rTotal = _rTotal.sub(rAmount);
774         _tFeeTotal = _tFeeTotal.add(tAmount);
775     }
776 
777     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
778         require(tAmount <= _tTotal, "Amount must be less than supply");
779         if (!deductTransferFee) {
780             (uint256 rAmount,,,,,) = _getValues(tAmount);
781             return rAmount;
782         } else {
783             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
784             return rTransferAmount;
785         }
786     }
787 
788     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
789         require(rAmount <= _rTotal, "Tunnel: Amount must be less than total reflections");
790         uint256 currentRate =  _getRate();
791         return rAmount.div(currentRate);
792     }
793 
794     function excludeAccount(address account) external onlyOwner() {
795         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Tunnel: We can not exclude Uniswap router.');
796         require(account != address(this), 'Tunnel: We can not exclude contract self.');
797         require(account != _rewardWallet, 'Tunnel: We can not exclude reweard wallet.');
798         require(!_isExcluded[account], "Tunnel: Account is already excluded");
799         
800         if(_rOwned[account] > 0) {
801             _tOwned[account] = tokenFromReflection(_rOwned[account]);
802         }
803         _isExcluded[account] = true;
804         _excluded.push(account);
805     }
806 
807     function includeAccount(address account) external onlyOwner() {
808         require(_isExcluded[account], "Tunnel: Account is already included");
809         for (uint256 i = 0; i < _excluded.length; i++) {
810             if (_excluded[i] == account) {
811                 _excluded[i] = _excluded[_excluded.length - 1];
812                 _tOwned[account] = 0;
813                 _isExcluded[account] = false;
814                 _excluded.pop();
815                 break;
816             }
817         }
818     }
819 
820     function _approve(address owner, address spender, uint256 amount) private {
821         require(owner != address(0), "Tunnel: approve from the zero address");
822         require(spender != address(0), "Tunnel: approve to the zero address");
823 
824         _allowances[owner][spender] = amount;
825         emit Approval(owner, spender, amount);
826     }
827 
828     function _transfer(address sender, address recipient, uint256 amount) private {
829         require(sender != address(0), "Tunnel: transfer from the zero address");
830         require(recipient != address(0), "Tunnel: transfer to the zero address");
831         require(amount > 0, "Tunnel: Transfer amount must be greater than zero");
832         
833         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
834             require(amount <= _maxTxAmount, "Tunnel: Transfer amount exceeds the maxTxAmount.");
835             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
836                 require(false, "Tunnel: trading is disabled.");
837         }
838         
839         if(!inSwapAndLiquify) {
840             uint256 lockedBalanceForPool = balanceOf(address(this));
841             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
842             if (
843                 overMinTokenBalance &&
844                 msg.sender != currentPoolAddress &&
845                 swapAndLiquifyEnabled
846             ) {
847                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
848                     swapAndLiquifyForEth(lockedBalanceForPool);
849                 else
850                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
851             }
852         }
853         
854         if (_isExcluded[sender] && !_isExcluded[recipient]) {
855             _transferFromExcluded(sender, recipient, amount);
856         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
857             _transferToExcluded(sender, recipient, amount);
858         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
859             _transferStandard(sender, recipient, amount);
860         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
861             _transferBothExcluded(sender, recipient, amount);
862         } else {
863             _transferStandard(sender, recipient, amount);
864         }
865     }
866     
867     receive() external payable {}
868     
869     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
870         // split the contract balance except swapCallerFee into halves
871         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
872         uint256 half = lockedForSwap.div(2);
873         uint256 otherHalf = lockedForSwap.sub(half);
874 
875         // capture the contract's current ETH balance.
876         // this is so that we can capture exactly the amount of ETH that the
877         // swap creates, and not make the liquidity event include any ETH that
878         // has been manually sent to the contract
879         uint256 initialBalance = address(this).balance;
880 
881         // swap tokens for ETH
882         swapTokensForEth(half);
883         
884         // how much ETH did we just swap into?
885         uint256 newBalance = address(this).balance.sub(initialBalance);
886 
887         // add liquidity to uniswap
888         addLiquidityForEth(otherHalf, newBalance);
889         
890         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
891         
892         _transfer(address(this), tx.origin, _autoSwapCallerFee);
893         
894         _sendRewardInterestToPool();
895     }
896     
897     function swapTokensForEth(uint256 tokenAmount) private {
898         // generate the uniswap pair path of token -> weth
899         address[] memory path = new address[](2);
900         path[0] = address(this);
901         path[1] = _uniswapV2Router.WETH();
902 
903         _approve(address(this), address(_uniswapV2Router), tokenAmount);
904 
905         // make the swap
906         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
907             tokenAmount,
908             0, // accept any amount of ETH
909             path,
910             address(this),
911             block.timestamp
912         );
913     }
914 
915     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
916         // approve token transfer to cover all possible scenarios
917         _approve(address(this), address(_uniswapV2Router), tokenAmount);
918 
919         // add the liquidity
920         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
921             address(this),
922             tokenAmount,
923             0, // slippage is unavoidable
924             0, // slippage is unavoidable
925             address(this),
926             block.timestamp
927         );
928     }
929     
930     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
931         // split the contract balance except swapCallerFee into halves
932         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
933         uint256 half = lockedForSwap.div(2);
934         uint256 otherHalf = lockedForSwap.sub(half);
935         
936         _transfer(address(this), address(swaper), half);
937         
938         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
939         
940         // swap tokens for pairToken
941         swaper.swapTokens(pairTokenAddress, half);
942         
943         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
944 
945         // add liquidity to uniswap
946         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
947         
948         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
949         
950         _transfer(address(this), tx.origin, _autoSwapCallerFee);
951         
952         _sendRewardInterestToPool();
953     }
954 
955     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
956         // approve token transfer to cover all possible scenarios
957         _approve(address(this), address(_uniswapV2Router), tokenAmount);
958         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
959 
960         // add the liquidity
961         _uniswapV2Router.addLiquidity(
962             address(this),
963             pairTokenAddress,
964             tokenAmount,
965             pairTokenAmount,
966             0, // slippage is unavoidable
967             0, // slippage is unavoidable
968             address(this),
969             block.timestamp
970         );
971     }
972 
973     function alchemy() public lockTheSwap {
974         require(balanceOf(_msgSender()) >= _minTokenForAlchemy, "Tunnel: You have not enough Tunnel to ");
975         require(now > _lastAlchemy + _alchemyInterval, 'Tunnel: Too Soon.');
976         
977         _lastAlchemy = now;
978 
979         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
980 
981         removeLiquidityETH(amountToRemove);
982         balancer.rebalance();
983 
984         uint256 tNewTokenBalance = balanceOf(address(balancer));
985         uint256 tRewardForCaller = tNewTokenBalance.mul(_alchemyCallerFee).div(100);
986         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
987         
988         uint256 currentRate =  _getRate();
989         uint256 rBurn =  tBurn.mul(currentRate);
990         
991         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
992         _rOwned[address(balancer)] = 0;
993         
994         _tBurnTotal = _tBurnTotal.add(tBurn);
995         _tTotal = _tTotal.sub(tBurn);
996         _rTotal = _rTotal.sub(rBurn);
997 
998         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
999         emit Transfer(address(balancer), address(0), tBurn);
1000         emit Rebalance(tBurn);
1001     }
1002     
1003     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
1004         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
1005         (ETHAmount) = _uniswapV2Router
1006             .removeLiquidityETHSupportingFeeOnTransferTokens(
1007                 address(this),
1008                 lpAmount,
1009                 0,
1010                 0,
1011                 address(balancer),
1012                 block.timestamp
1013             );
1014     }
1015 
1016     function _sendRewardInterestToPool() private {
1017         uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
1018         if(tRewardInterest > _minInterestForReward) {
1019             uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
1020             _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
1021             _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
1022             emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
1023             IUniswapV2Pair(currentPoolAddress).sync();
1024         }
1025     }
1026 
1027     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1028         uint256 currentRate =  _getRate();
1029         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1030         uint256 rLock =  tLock.mul(currentRate);
1031         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1032         if(inSwapAndLiquify) {
1033             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1034             emit Transfer(sender, recipient, tAmount);
1035         } else {
1036             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1037             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1038             _reflectFee(rFee, tFee);
1039             emit Transfer(sender, address(this), tLock);
1040             emit Transfer(sender, recipient, tTransferAmount);
1041         }
1042     }
1043 
1044     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1045         uint256 currentRate =  _getRate();
1046         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1047         uint256 rLock =  tLock.mul(currentRate);
1048         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1049         if(inSwapAndLiquify) {
1050             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1051             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1052             emit Transfer(sender, recipient, tAmount);
1053         } else {
1054             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1055             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1056             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1057             _reflectFee(rFee, tFee);
1058             emit Transfer(sender, address(this), tLock);
1059             emit Transfer(sender, recipient, tTransferAmount);
1060         }
1061     }
1062 
1063     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1064         uint256 currentRate =  _getRate();
1065         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1066         uint256 rLock =  tLock.mul(currentRate);
1067         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1068         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1069         if(inSwapAndLiquify) {
1070             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1071             emit Transfer(sender, recipient, tAmount);
1072         } else {
1073             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1074             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1075             _reflectFee(rFee, tFee);
1076             emit Transfer(sender, address(this), tLock);
1077             emit Transfer(sender, recipient, tTransferAmount);
1078         }
1079     }
1080 
1081     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1082         uint256 currentRate =  _getRate();
1083         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1084         uint256 rLock =  tLock.mul(currentRate);
1085         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1086         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1087         if(inSwapAndLiquify) {
1088             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1089             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1090             emit Transfer(sender, recipient, tAmount);
1091         }
1092         else {
1093             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1094             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1095             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1096             _reflectFee(rFee, tFee);
1097             emit Transfer(sender, address(this), tLock);
1098             emit Transfer(sender, recipient, tTransferAmount);
1099         }
1100     }
1101 
1102     function _reflectFee(uint256 rFee, uint256 tFee) private {
1103         _rTotal = _rTotal.sub(rFee);
1104         _tFeeTotal = _tFeeTotal.add(tFee);
1105     }
1106 
1107     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1108         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1109         uint256 currentRate =  _getRate();
1110         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1111         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1112     }
1113 
1114     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1115         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1116         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1117         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1118         return (tTransferAmount, tFee, tLockFee);
1119     }
1120 
1121     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1122         uint256 rAmount = tAmount.mul(currentRate);
1123         uint256 rFee = tFee.mul(currentRate);
1124         uint256 rLock = tLock.mul(currentRate);
1125         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1126         return (rAmount, rTransferAmount, rFee);
1127     }
1128 
1129     function _getRate() public view returns(uint256) {
1130         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1131         return rSupply.div(tSupply);
1132     }
1133 
1134     function _getCurrentSupply() public view returns(uint256, uint256) {
1135         uint256 rSupply = _rTotal;
1136         uint256 tSupply = _tTotal;      
1137         for (uint256 i = 0; i < _excluded.length; i++) {
1138             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1139             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1140             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1141         }
1142         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1143         return (rSupply, tSupply);
1144     }
1145     
1146     function getCurrentPoolAddress() public view returns(address) {
1147         return currentPoolAddress;
1148     }
1149     
1150     function getCurrentPairTokenAddress() public view returns(address) {
1151         return currentPairTokenAddress;
1152     }
1153 
1154     function getLiquidityRemoveFee() public view returns(uint256) {
1155         return _liquidityRemoveFee;
1156     }
1157     
1158     function getAlchemyCallerFee() public view returns(uint256) {
1159         return _alchemyCallerFee;
1160     }
1161     
1162     function getMinTokenForAlchemy() public view returns(uint256) {
1163         return _minTokenForAlchemy;
1164     }
1165     
1166     function getLastAlchemy() public view returns(uint256) {
1167         return _lastAlchemy;
1168     }
1169     
1170     function getAlchemyInterval() public view returns(uint256) {
1171         return _alchemyInterval;
1172     }
1173     
1174     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1175         require(feeDecimals >= 0 && feeDecimals <= 2, 'Tunnel: fee decimals should be in 0 - 2');
1176         _feeDecimals = feeDecimals;
1177         emit FeeDecimalsUpdated(feeDecimals);
1178     }
1179     
1180     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1181         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Tunnel: taxFee should be in 0 - 5');
1182         _taxFee = taxFee;
1183         emit TaxFeeUpdated(taxFee);
1184     }
1185     
1186     function _setLockFee(uint256 lockFee) external onlyOwner() {
1187         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Tunnel: lockFee should be in 0 - 5');
1188         _lockFee = lockFee;
1189         emit LockFeeUpdated(lockFee);
1190     }
1191     
1192     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1193         require(maxTxAmount >= 500000e9 , 'Tunnel: maxTxAmount should be greater than 500000e9');
1194         _maxTxAmount = maxTxAmount;
1195         emit MaxTxAmountUpdated(maxTxAmount);
1196     }
1197     
1198     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1199         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Tunnel: minTokenBeforeSwap should be in 50e9 - 25000e9');
1200         require(minTokensBeforeSwap > _autoSwapCallerFee , 'Tunnel: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1201         _minTokensBeforeSwap = minTokensBeforeSwap;
1202         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1203     }
1204     
1205     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1206         require(autoSwapCallerFee >= 1e9, 'Tunnel: autoSwapCallerFee should be greater than 1e9');
1207         _autoSwapCallerFee = autoSwapCallerFee;
1208         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1209     }
1210     
1211     function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
1212         _minInterestForReward = minInterestForReward;
1213         emit MinInterestForRewardUpdated(minInterestForReward);
1214     }
1215     
1216     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1217         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Tunnel: liquidityRemoveFee should be in 1 - 10');
1218         _liquidityRemoveFee = liquidityRemoveFee;
1219         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1220     }
1221     
1222     function _setAlchemyCallerFee(uint256 alchemyCallerFee) external onlyOwner() {
1223         require(alchemyCallerFee >= 1 && alchemyCallerFee <= 15 , 'Tunnel: alchemyCallerFee should be in 1 - 15');
1224         _alchemyCallerFee = alchemyCallerFee;
1225         emit AlchemyCallerFeeUpdated(alchemyCallerFee);
1226     }
1227     
1228     function _setMinTokenForAlchemy(uint256 minTokenForAlchemy) external onlyOwner() {
1229         _minTokenForAlchemy = minTokenForAlchemy;
1230         emit MinTokenForAlchemyUpdated(minTokenForAlchemy);
1231     }
1232     
1233     function _setAlchemyInterval(uint256 alchemyInterval) external onlyOwner() {
1234         _alchemyInterval = alchemyInterval;
1235         emit AlchemyIntervalUpdated(alchemyInterval);
1236     }
1237     
1238     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1239         swapAndLiquifyEnabled = _enabled;
1240         emit SwapAndLiquifyEnabledUpdated(_enabled);
1241     }
1242     
1243     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1244         require(poolAddress != address(0), "Tunnel: Pool address is zero.");
1245         require(pairTokenAddress != address(0), "Tunnel: Pair token address is zero.");
1246         require(pairTokenAddress != address(this), "Tunnel: Pair token address self address.");
1247         require(pairTokenAddress != currentPairTokenAddress, "Tunnel: Pair token address is same as current one.");
1248         
1249         currentPoolAddress = poolAddress;
1250         currentPairTokenAddress = pairTokenAddress;
1251         
1252         emit WhitelistUpdated(pairTokenAddress);
1253     }
1254 
1255     function _enableTrading() external onlyOwner() {
1256         tradingEnabled = true;
1257         TradingEnabled();
1258     }
1259 }