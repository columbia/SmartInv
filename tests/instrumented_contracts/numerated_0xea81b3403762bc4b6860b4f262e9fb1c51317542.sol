1 // SPDX-License-Identifier: MIT
2 /*
3 
4 ████████╗██████╗░██╗██╗░█████╗░██████╗░
5 ╚══██╔══╝██╔══██╗██║██║██╔══██╗██╔══██╗
6 ░░░██║░░░██████╔╝██║██║███████║██║░░██║
7 ░░░██║░░░██╔══██╗██║██║██╔══██║██║░░██║
8 ░░░██║░░░██║░░██║██║██║██║░░██║██████╔╝
9 ░░░╚═╝░░░╚═╝░░╚═╝╚═╝╚═╝╚═╝░░╚═╝╚═════╝░
10       -https://triiad.finance-
11 */
12 
13 pragma solidity ^0.6.0;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 /**
409  * @dev Contract module which provides a basic access control mechanism, where
410  * there is an account (an owner) that can be granted exclusive access to
411  * specific functions.
412  *
413  * By default, the owner account will be the one that deploys the contract. This
414  * can later be changed with {transferOwnership}.
415  *
416  * This module is used through inheritance. It will make available the modifier
417  * `onlyOwner`, which can be applied to your functions to restrict their use to
418  * the owner.
419  */
420 contract Ownable is Context {
421     address private _owner;
422 
423     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
424 
425     /**
426      * @dev Initializes the contract setting the deployer as the initial owner.
427      */
428     constructor () internal {
429         address msgSender = _msgSender();
430         _owner = msgSender;
431         emit OwnershipTransferred(address(0), msgSender);
432     }
433 
434     /**
435      * @dev Returns the address of the current owner.
436      */
437     function owner() public view returns (address) {
438         return _owner;
439     }
440 
441     /**
442      * @dev Throws if called by any account other than the owner.
443      */
444     modifier onlyOwner() {
445         require(_owner == _msgSender(), "Ownable: caller is not the owner");
446         _;
447     }
448 
449     /**
450      * @dev Leaves the contract without owner. It will not be possible to call
451      * `onlyOwner` functions anymore. Can only be called by the current owner.
452      *
453      * NOTE: Renouncing ownership will leave the contract without an owner,
454      * thereby removing any functionality that is only available to the owner.
455      */
456     function renounceOwnership() public virtual onlyOwner {
457         emit OwnershipTransferred(_owner, address(0));
458         _owner = address(0);
459     }
460 
461     /**
462      * @dev Transfers ownership of the contract to a new account (`newOwner`).
463      * Can only be called by the current owner.
464      */
465     function transferOwnership(address newOwner) public virtual onlyOwner {
466         require(newOwner != address(0), "Ownable: new owner is the zero address");
467         emit OwnershipTransferred(_owner, newOwner);
468         _owner = newOwner;
469     }
470 }
471 
472 
473 interface IUniswapV2Factory {
474     function createPair(address tokenA, address tokenB) external returns (address pair);
475 }
476 
477 interface IUniswapV2Pair {
478     function sync() external;
479 }
480 
481 interface IUniswapV2Router01 {
482     function factory() external pure returns (address);
483     function WETH() external pure returns (address);
484     function addLiquidity(
485         address tokenA,
486         address tokenB,
487         uint amountADesired,
488         uint amountBDesired,
489         uint amountAMin,
490         uint amountBMin,
491         address to,
492         uint deadline
493     ) external returns (uint amountA, uint amountB, uint liquidity);
494     function addLiquidityETH(
495         address token,
496         uint amountTokenDesired,
497         uint amountTokenMin,
498         uint amountETHMin,
499         address to,
500         uint deadline
501     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
502 }
503 
504 interface IUniswapV2Router02 is IUniswapV2Router01 {
505     function removeLiquidityETHSupportingFeeOnTransferTokens(
506       address token,
507       uint liquidity,
508       uint amountTokenMin,
509       uint amountETHMin,
510       address to,
511       uint deadline
512     ) external returns (uint amountETH);
513     function swapExactTokensForETHSupportingFeeOnTransferTokens(
514         uint amountIn,
515         uint amountOutMin,
516         address[] calldata path,
517         address to,
518         uint deadline
519     ) external;
520     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
521         uint amountIn,
522         uint amountOutMin,
523         address[] calldata path,
524         address to,
525         uint deadline
526     ) external;
527     function swapExactETHForTokensSupportingFeeOnTransferTokens(
528         uint amountOutMin,
529         address[] calldata path,
530         address to,
531         uint deadline
532     ) external payable;
533 }
534 
535 pragma solidity ^0.6.12;
536 
537 contract RewardWallet {
538     constructor() public {
539     }
540 }
541 
542 contract Balancer {
543     using SafeMath for uint256;
544     IUniswapV2Router02 public immutable _uniswapV2Router;
545     TRIIAD private _tokenContract;
546     
547     constructor(TRIIAD tokenContract, IUniswapV2Router02 uniswapV2Router) public {
548         _tokenContract =tokenContract;
549         _uniswapV2Router = uniswapV2Router;
550     }
551     
552     receive() external payable {}
553     
554     function rebalance() external returns (uint256) { 
555         swapEthForTokens(address(this).balance);
556     }
557 
558     function swapEthForTokens(uint256 EthAmount) private {
559         address[] memory uniswapPairPath = new address[](2);
560         uniswapPairPath[0] = _uniswapV2Router.WETH();
561         uniswapPairPath[1] = address(_tokenContract);
562 
563         _uniswapV2Router
564             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
565                 0,
566                 uniswapPairPath,
567                 address(this),
568                 block.timestamp
569             );
570     }
571 }
572 
573 contract Swaper {
574     using SafeMath for uint256;
575     IUniswapV2Router02 public immutable _uniswapV2Router;
576     TRIIAD private _tokenContract;
577     
578     constructor(TRIIAD tokenContract, IUniswapV2Router02 uniswapV2Router) public {
579         _tokenContract = tokenContract;
580         _uniswapV2Router = uniswapV2Router;
581     }
582     
583     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
584         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
585         swapTokensForTokens(pairTokenAddress, tokenAmount);
586         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
587         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
588     }
589     
590     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
591         address[] memory path = new address[](2);
592         path[0] = address(_tokenContract);
593         path[1] = pairTokenAddress;
594 
595         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
596 
597         // make the swap
598         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
599             tokenAmount,
600             0, // accept any amount of pair token
601             path,
602             address(this),
603             block.timestamp
604         );
605     }
606 }
607 
608 contract TRIIAD is Context, IERC20, Ownable {
609     using SafeMath for uint256;
610     using Address for address;
611 
612     IUniswapV2Router02 public immutable _uniswapV2Router;
613 
614     mapping (address => uint256) private _rOwned;
615     mapping (address => uint256) private _tOwned;
616     mapping (address => mapping (address => uint256)) private _allowances;
617 
618     mapping (address => bool) private _isExcluded;
619     address[] private _excluded;
620     address public _rewardWallet;
621     uint256 public _initialRewardLockAmount;
622     address public _uniswapETHPool;
623     
624     uint256 private constant MAX = ~uint256(0);
625     uint256 private _tTotal = 33000000e9;
626     uint256 private _rTotal = (MAX - (MAX % _tTotal));
627     uint256 public _tFeeTotal;
628     uint256 public _tBurnTotal;
629 
630     string private _name = 'Triiad';
631     string private _symbol = 'TRII';
632     uint8 private _decimals = 9;
633     
634     uint256 public _feeDecimals = 1;
635     uint256 public _taxFee = 0;
636     uint256 public _lockFee = 0;
637     uint256 public _maxTxAmount = 2000000e9;
638     uint256 public _minTokensBeforeSwap = 10000e9;
639     uint256 public _minInterestForReward = 10e9;
640     uint256 private _autoSwapCallerFee = 200e9;
641     
642     bool private inSwapAndLiquify;
643     bool public swapAndLiquifyEnabled;
644     bool public tradingEnabled;
645     
646     address private currentPairTokenAddress;
647     address private currentPoolAddress;
648     
649     uint256 private _liquidityRemoveFee = 3;
650     uint256 private _sorceryCallerFee = 5;
651     uint256 private _minTokenForSorcery = 3300e9;
652     uint256 private _lastSorcery;
653     uint256 private _sorceryInterval = 3 hours;
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
672     event MinInterestForRewardUpdated(uint256 minInterestForReward);
673     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
674     event SorceryCallerFeeUpdated(uint256 rebalnaceCallerFee);
675     event MinTokenForSorceryUpdated(uint256 minRebalanceAmount);
676     event SorceryIntervalUpdated(uint256 rebalanceInterval);
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
687     constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
688         _lastSorcery = now;
689         
690         _uniswapV2Router = uniswapV2Router;
691         _rewardWallet = address(new RewardWallet());
692         _initialRewardLockAmount = initialRewardLockAmount;
693         
694         balancer = new Balancer(this, uniswapV2Router);
695         swaper = new Swaper(this, uniswapV2Router);
696         
697         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
698             .createPair(address(this), uniswapV2Router.WETH());
699         currentPairTokenAddress = uniswapV2Router.WETH();
700         _uniswapETHPool = currentPoolAddress;
701         
702         updateSwapAndLiquifyEnabled(false);
703         
704         _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
705         _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
706         
707         emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
708         emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
709     }
710 
711     function name() public view returns (string memory) {
712         return _name;
713     }
714 
715     function symbol() public view returns (string memory) {
716         return _symbol;
717     }
718 
719     function decimals() public view returns (uint8) {
720         return _decimals;
721     }
722 
723     function totalSupply() public view override returns (uint256) {
724         return _tTotal;
725     }
726 
727     function balanceOf(address account) public view override returns (uint256) {
728         if (_isExcluded[account]) return _tOwned[account];
729         return tokenFromReflection(_rOwned[account]);
730     }
731 
732     function transfer(address recipient, uint256 amount) public override returns (bool) {
733         _transfer(_msgSender(), recipient, amount);
734         return true;
735     }
736 
737     function allowance(address owner, address spender) public view override returns (uint256) {
738         return _allowances[owner][spender];
739     }
740 
741     function approve(address spender, uint256 amount) public override returns (bool) {
742         _approve(_msgSender(), spender, amount);
743         return true;
744     }
745 
746     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
747         _transfer(sender, recipient, amount);
748         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
749         return true;
750     }
751 
752     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
753         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
754         return true;
755     }
756 
757     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
758         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
759         return true;
760     }
761 
762     function isExcluded(address account) public view returns (bool) {
763         return _isExcluded[account];
764     }
765 
766     
767     function reflect(uint256 tAmount) public {
768         address sender = _msgSender();
769         require(!_isExcluded[sender], "Triiad: Excluded addresses cannot call this function");
770         (uint256 rAmount,,,,,) = _getValues(tAmount);
771         _rOwned[sender] = _rOwned[sender].sub(rAmount);
772         _rTotal = _rTotal.sub(rAmount);
773         _tFeeTotal = _tFeeTotal.add(tAmount);
774     }
775 
776     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
777         require(tAmount <= _tTotal, "Amount must be less than supply");
778         if (!deductTransferFee) {
779             (uint256 rAmount,,,,,) = _getValues(tAmount);
780             return rAmount;
781         } else {
782             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
783             return rTransferAmount;
784         }
785     }
786 
787     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
788         require(rAmount <= _rTotal, "Triiad: Amount must be less than total reflections");
789         uint256 currentRate =  _getRate();
790         return rAmount.div(currentRate);
791     }
792 
793     function excludeAccount(address account) external onlyOwner() {
794         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Triiad: We can not exclude Uniswap router.');
795         require(account != address(this), 'Triiad: We can not exclude contract self.');
796         require(account != _rewardWallet, 'Triiad: We can not exclude reweard wallet.');
797         require(!_isExcluded[account], "Triiad: Account is already excluded");
798         
799         if(_rOwned[account] > 0) {
800             _tOwned[account] = tokenFromReflection(_rOwned[account]);
801         }
802         _isExcluded[account] = true;
803         _excluded.push(account);
804     }
805 
806     function includeAccount(address account) external onlyOwner() {
807         require(_isExcluded[account], "Triiad: Account is already included");
808         for (uint256 i = 0; i < _excluded.length; i++) {
809             if (_excluded[i] == account) {
810                 _excluded[i] = _excluded[_excluded.length - 1];
811                 _tOwned[account] = 0;
812                 _isExcluded[account] = false;
813                 _excluded.pop();
814                 break;
815             }
816         }
817     }
818 
819     function _approve(address owner, address spender, uint256 amount) private {
820         require(owner != address(0), "Triiad: approve from the zero address");
821         require(spender != address(0), "Triiad: approve to the zero address");
822 
823         _allowances[owner][spender] = amount;
824         emit Approval(owner, spender, amount);
825     }
826 
827     function _transfer(address sender, address recipient, uint256 amount) private {
828         require(sender != address(0), "Triiad: transfer from the zero address");
829         require(recipient != address(0), "Triiad: transfer to the zero address");
830         require(amount > 0, "Triiad: Transfer amount must be greater than zero");
831         
832         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
833             require(amount <= _maxTxAmount, "Triiad: Transfer amount exceeds the maxTxAmount.");
834             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
835                 require(false, "Triiad: trading is disabled.");
836         }
837         
838         if(!inSwapAndLiquify) {
839             uint256 lockedBalanceForPool = balanceOf(address(this));
840             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
841             if (
842                 overMinTokenBalance &&
843                 msg.sender != currentPoolAddress &&
844                 swapAndLiquifyEnabled
845             ) {
846                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
847                     swapAndLiquifyForEth(lockedBalanceForPool);
848                 else
849                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
850             }
851         }
852         
853         if (_isExcluded[sender] && !_isExcluded[recipient]) {
854             _transferFromExcluded(sender, recipient, amount);
855         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
856             _transferToExcluded(sender, recipient, amount);
857         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
858             _transferStandard(sender, recipient, amount);
859         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
860             _transferBothExcluded(sender, recipient, amount);
861         } else {
862             _transferStandard(sender, recipient, amount);
863         }
864     }
865     
866     receive() external payable {}
867     
868     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
869         // split the contract balance except swapCallerFee into halves
870         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
871         uint256 half = lockedForSwap.div(2);
872         uint256 otherHalf = lockedForSwap.sub(half);
873 
874         // capture the contract's current ETH balance.
875         // this is so that we can capture exactly the amount of ETH that the
876         // swap creates, and not make the liquidity event include any ETH that
877         // has been manually sent to the contract
878         uint256 initialBalance = address(this).balance;
879 
880         // swap tokens for ETH
881         swapTokensForEth(half);
882         
883         // how much ETH did we just swap into?
884         uint256 newBalance = address(this).balance.sub(initialBalance);
885 
886         // add liquidity to uniswap
887         addLiquidityForEth(otherHalf, newBalance);
888         
889         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
890         
891         _transfer(address(this), tx.origin, _autoSwapCallerFee);
892         
893         _sendRewardInterestToPool();
894     }
895     
896     function swapTokensForEth(uint256 tokenAmount) private {
897         // generate the uniswap pair path of token -> weth
898         address[] memory path = new address[](2);
899         path[0] = address(this);
900         path[1] = _uniswapV2Router.WETH();
901 
902         _approve(address(this), address(_uniswapV2Router), tokenAmount);
903 
904         // make the swap
905         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
906             tokenAmount,
907             0, // accept any amount of ETH
908             path,
909             address(this),
910             block.timestamp
911         );
912     }
913 
914     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
915         // approve token transfer to cover all possible scenarios
916         _approve(address(this), address(_uniswapV2Router), tokenAmount);
917 
918         // add the liquidity
919         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
920             address(this),
921             tokenAmount,
922             0, // slippage is unavoidable
923             0, // slippage is unavoidable
924             address(this),
925             block.timestamp
926         );
927     }
928     
929     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
930         // split the contract balance except swapCallerFee into halves
931         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
932         uint256 half = lockedForSwap.div(2);
933         uint256 otherHalf = lockedForSwap.sub(half);
934         
935         _transfer(address(this), address(swaper), half);
936         
937         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
938         
939         // swap tokens for pairToken
940         swaper.swapTokens(pairTokenAddress, half);
941         
942         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
943 
944         // add liquidity to uniswap
945         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
946         
947         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
948         
949         _transfer(address(this), tx.origin, _autoSwapCallerFee);
950         
951         _sendRewardInterestToPool();
952     }
953 
954     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
955         // approve token transfer to cover all possible scenarios
956         _approve(address(this), address(_uniswapV2Router), tokenAmount);
957         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
958 
959         // add the liquidity
960         _uniswapV2Router.addLiquidity(
961             address(this),
962             pairTokenAddress,
963             tokenAmount,
964             pairTokenAmount,
965             0, // slippage is unavoidable
966             0, // slippage is unavoidable
967             address(this),
968             block.timestamp
969         );
970     }
971 
972     function sorcery() public lockTheSwap {
973         require(balanceOf(_msgSender()) >= _minTokenForSorcery, "Triiad: You have not enough Triiad to ");
974         require(now > _lastSorcery + _sorceryInterval, 'Triiad: Too Soon.');
975         
976         _lastSorcery = now;
977 
978         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
979 
980         removeLiquidityETH(amountToRemove);
981         balancer.rebalance();
982 
983         uint256 tNewTokenBalance = balanceOf(address(balancer));
984         uint256 tRewardForCaller = tNewTokenBalance.mul(_sorceryCallerFee).div(100);
985         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
986         
987         uint256 currentRate =  _getRate();
988         uint256 rBurn =  tBurn.mul(currentRate);
989         
990         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
991         _rOwned[address(balancer)] = 0;
992         
993         _tBurnTotal = _tBurnTotal.add(tBurn);
994         _tTotal = _tTotal.sub(tBurn);
995         _rTotal = _rTotal.sub(rBurn);
996 
997         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
998         emit Transfer(address(balancer), address(0), tBurn);
999         emit Rebalance(tBurn);
1000     }
1001     
1002     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
1003         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
1004         (ETHAmount) = _uniswapV2Router
1005             .removeLiquidityETHSupportingFeeOnTransferTokens(
1006                 address(this),
1007                 lpAmount,
1008                 0,
1009                 0,
1010                 address(balancer),
1011                 block.timestamp
1012             );
1013     }
1014 
1015     function _sendRewardInterestToPool() private {
1016         uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
1017         if(tRewardInterest > _minInterestForReward) {
1018             uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
1019             _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
1020             _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
1021             emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
1022             IUniswapV2Pair(currentPoolAddress).sync();
1023         }
1024     }
1025 
1026     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1027         uint256 currentRate =  _getRate();
1028         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1029         uint256 rLock =  tLock.mul(currentRate);
1030         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1031         if(inSwapAndLiquify) {
1032             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1033             emit Transfer(sender, recipient, tAmount);
1034         } else {
1035             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1036             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1037             _reflectFee(rFee, tFee);
1038             emit Transfer(sender, address(this), tLock);
1039             emit Transfer(sender, recipient, tTransferAmount);
1040         }
1041     }
1042 
1043     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1044         uint256 currentRate =  _getRate();
1045         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1046         uint256 rLock =  tLock.mul(currentRate);
1047         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1048         if(inSwapAndLiquify) {
1049             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1050             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1051             emit Transfer(sender, recipient, tAmount);
1052         } else {
1053             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1054             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1055             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1056             _reflectFee(rFee, tFee);
1057             emit Transfer(sender, address(this), tLock);
1058             emit Transfer(sender, recipient, tTransferAmount);
1059         }
1060     }
1061 
1062     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1063         uint256 currentRate =  _getRate();
1064         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1065         uint256 rLock =  tLock.mul(currentRate);
1066         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1067         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1068         if(inSwapAndLiquify) {
1069             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1070             emit Transfer(sender, recipient, tAmount);
1071         } else {
1072             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1073             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1074             _reflectFee(rFee, tFee);
1075             emit Transfer(sender, address(this), tLock);
1076             emit Transfer(sender, recipient, tTransferAmount);
1077         }
1078     }
1079 
1080     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1081         uint256 currentRate =  _getRate();
1082         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1083         uint256 rLock =  tLock.mul(currentRate);
1084         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1085         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1086         if(inSwapAndLiquify) {
1087             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1088             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1089             emit Transfer(sender, recipient, tAmount);
1090         }
1091         else {
1092             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1093             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1094             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1095             _reflectFee(rFee, tFee);
1096             emit Transfer(sender, address(this), tLock);
1097             emit Transfer(sender, recipient, tTransferAmount);
1098         }
1099     }
1100 
1101     function _reflectFee(uint256 rFee, uint256 tFee) private {
1102         _rTotal = _rTotal.sub(rFee);
1103         _tFeeTotal = _tFeeTotal.add(tFee);
1104     }
1105 
1106     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1107         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1108         uint256 currentRate =  _getRate();
1109         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1110         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1111     }
1112 
1113     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1114         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1115         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1116         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1117         return (tTransferAmount, tFee, tLockFee);
1118     }
1119 
1120     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1121         uint256 rAmount = tAmount.mul(currentRate);
1122         uint256 rFee = tFee.mul(currentRate);
1123         uint256 rLock = tLock.mul(currentRate);
1124         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1125         return (rAmount, rTransferAmount, rFee);
1126     }
1127 
1128     function _getRate() public view returns(uint256) {
1129         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1130         return rSupply.div(tSupply);
1131     }
1132 
1133     function _getCurrentSupply() public view returns(uint256, uint256) {
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
1145     function getCurrentPoolAddress() public view returns(address) {
1146         return currentPoolAddress;
1147     }
1148     
1149     function getCurrentPairTokenAddress() public view returns(address) {
1150         return currentPairTokenAddress;
1151     }
1152 
1153     function getLiquidityRemoveFee() public view returns(uint256) {
1154         return _liquidityRemoveFee;
1155     }
1156     
1157     function getSorceryCallerFee() public view returns(uint256) {
1158         return _sorceryCallerFee;
1159     }
1160     
1161     function getMinTokenForSorcery() public view returns(uint256) {
1162         return _minTokenForSorcery;
1163     }
1164     
1165     function getLastSorcery() public view returns(uint256) {
1166         return _lastSorcery;
1167     }
1168     
1169     function getSorceryInterval() public view returns(uint256) {
1170         return _sorceryInterval;
1171     }
1172     
1173     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1174         require(feeDecimals >= 0 && feeDecimals <= 2, 'Triiad: fee decimals should be in 0 - 2');
1175         _feeDecimals = feeDecimals;
1176         emit FeeDecimalsUpdated(feeDecimals);
1177     }
1178     
1179     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1180         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Triiad: taxFee should be in 0 - 5');
1181         _taxFee = taxFee;
1182         emit TaxFeeUpdated(taxFee);
1183     }
1184     
1185     function _setLockFee(uint256 lockFee) external onlyOwner() {
1186         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Triiad: lockFee should be in 0 - 5');
1187         _lockFee = lockFee;
1188         emit LockFeeUpdated(lockFee);
1189     }
1190     
1191     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1192         require(maxTxAmount >= 500000e9 , 'Triiad: maxTxAmount should be greater than 500000e9');
1193         _maxTxAmount = maxTxAmount;
1194         emit MaxTxAmountUpdated(maxTxAmount);
1195     }
1196     
1197     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1198         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Triiad: minTokenBeforeSwap should be in 50e9 - 25000e9');
1199         require(minTokensBeforeSwap > _autoSwapCallerFee , 'Triiad: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1200         _minTokensBeforeSwap = minTokensBeforeSwap;
1201         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1202     }
1203     
1204     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1205         require(autoSwapCallerFee >= 1e9, 'Triiad: autoSwapCallerFee should be greater than 1e9');
1206         _autoSwapCallerFee = autoSwapCallerFee;
1207         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1208     }
1209     
1210     function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
1211         _minInterestForReward = minInterestForReward;
1212         emit MinInterestForRewardUpdated(minInterestForReward);
1213     }
1214     
1215     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1216         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Triiad: liquidityRemoveFee should be in 1 - 10');
1217         _liquidityRemoveFee = liquidityRemoveFee;
1218         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1219     }
1220     
1221     function _setSorceryCallerFee(uint256 sorceryCallerFee) external onlyOwner() {
1222         require(sorceryCallerFee >= 1 && sorceryCallerFee <= 15 , 'Triiad: sorceryCallerFee should be in 1 - 15');
1223         _sorceryCallerFee = sorceryCallerFee;
1224         emit SorceryCallerFeeUpdated(sorceryCallerFee);
1225     }
1226     
1227     function _setMinTokenForSorcery(uint256 minTokenForSorcery) external onlyOwner() {
1228         _minTokenForSorcery = minTokenForSorcery;
1229         emit MinTokenForSorceryUpdated(minTokenForSorcery);
1230     }
1231     
1232     function _setSorceryInterval(uint256 sorceryInterval) external onlyOwner() {
1233         _sorceryInterval = sorceryInterval;
1234         emit SorceryIntervalUpdated(sorceryInterval);
1235     }
1236     
1237     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1238         swapAndLiquifyEnabled = _enabled;
1239         emit SwapAndLiquifyEnabledUpdated(_enabled);
1240     }
1241     
1242     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1243         require(poolAddress != address(0), "Triiad: Pool address is zero.");
1244         require(pairTokenAddress != address(0), "Triiad: Pair token address is zero.");
1245         require(pairTokenAddress != address(this), "Triiad: Pair token address self address.");
1246         require(pairTokenAddress != currentPairTokenAddress, "Triiad: Pair token address is same as current one.");
1247         
1248         currentPoolAddress = poolAddress;
1249         currentPairTokenAddress = pairTokenAddress;
1250         
1251         emit WhitelistUpdated(pairTokenAddress);
1252     }
1253 
1254     function _enableTrading() external onlyOwner() {
1255         tradingEnabled = true;
1256         TradingEnabled();
1257     }
1258 }