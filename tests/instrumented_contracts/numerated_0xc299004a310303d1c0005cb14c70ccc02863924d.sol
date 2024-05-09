1 // SPDX-License-Identifier: MIT
2 //
3 //888888888888 88888888ba  88 888b      88 88 888888888888 8b        d8  
4 //     88      88      "8b 88 8888b     88 88      88       Y8,    ,8P   
5 //     88      88      ,8P 88 88 `8b    88 88      88        Y8,  ,8P    
6 //     88      88aaaaaa8P' 88 88  `8b   88 88      88         "8aa8"     
7 //     88      88""""88'   88 88   `8b  88 88      88          `88'      
8 //     88      88    `8b   88 88    `8b 88 88      88           88       
9 //     88      88     `8b  88 88     `8888 88      88           88       
10 //     88      88      `8b 88 88      `888 88      88           88   
11 //
12 // Liquidity connector for DeFi     
13 // trinityprotocol.io
14 
15 pragma solidity ^0.6.0;
16 
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { codehash := extcodehash(account) }
301         return (codehash != accountHash && codehash != 0x0);
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347       return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return _functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         return _functionCallWithValue(target, data, value, errorMessage);
384     }
385 
386     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 /**
411  * @dev Contract module which provides a basic access control mechanism, where
412  * there is an account (an owner) that can be granted exclusive access to
413  * specific functions.
414  *
415  * By default, the owner account will be the one that deploys the contract. This
416  * can later be changed with {transferOwnership}.
417  *
418  * This module is used through inheritance. It will make available the modifier
419  * `onlyOwner`, which can be applied to your functions to restrict their use to
420  * the owner.
421  */
422 contract Ownable is Context {
423     address private _owner;
424 
425     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
426 
427     /**
428      * @dev Initializes the contract setting the deployer as the initial owner.
429      */
430     constructor () internal {
431         address msgSender = _msgSender();
432         _owner = msgSender;
433         emit OwnershipTransferred(address(0), msgSender);
434     }
435 
436     /**
437      * @dev Returns the address of the current owner.
438      */
439     function owner() public view returns (address) {
440         return _owner;
441     }
442 
443     /**
444      * @dev Throws if called by any account other than the owner.
445      */
446     modifier onlyOwner() {
447         require(_owner == _msgSender(), "Ownable: caller is not the owner");
448         _;
449     }
450 
451     /**
452      * @dev Leaves the contract without owner. It will not be possible to call
453      * `onlyOwner` functions anymore. Can only be called by the current owner.
454      *
455      * NOTE: Renouncing ownership will leave the contract without an owner,
456      * thereby removing any functionality that is only available to the owner.
457      */
458     function renounceOwnership() public virtual onlyOwner {
459         emit OwnershipTransferred(_owner, address(0));
460         _owner = address(0);
461     }
462 
463     /**
464      * @dev Transfers ownership of the contract to a new account (`newOwner`).
465      * Can only be called by the current owner.
466      */
467     function transferOwnership(address newOwner) public virtual onlyOwner {
468         require(newOwner != address(0), "Ownable: new owner is the zero address");
469         emit OwnershipTransferred(_owner, newOwner);
470         _owner = newOwner;
471     }
472 }
473 
474 
475 interface IUniswapV2Factory {
476     function createPair(address tokenA, address tokenB) external returns (address pair);
477 }
478 
479 interface IUniswapV2Pair {
480     function sync() external;
481 }
482 
483 interface IUniswapV2Router01 {
484     function factory() external pure returns (address);
485     function WETH() external pure returns (address);
486     function addLiquidity(
487         address tokenA,
488         address tokenB,
489         uint amountADesired,
490         uint amountBDesired,
491         uint amountAMin,
492         uint amountBMin,
493         address to,
494         uint deadline
495     ) external returns (uint amountA, uint amountB, uint liquidity);
496     function addLiquidityETH(
497         address token,
498         uint amountTokenDesired,
499         uint amountTokenMin,
500         uint amountETHMin,
501         address to,
502         uint deadline
503     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
504 }
505 
506 interface IUniswapV2Router02 is IUniswapV2Router01 {
507     function removeLiquidityETHSupportingFeeOnTransferTokens(
508       address token,
509       uint liquidity,
510       uint amountTokenMin,
511       uint amountETHMin,
512       address to,
513       uint deadline
514     ) external returns (uint amountETH);
515     function swapExactTokensForETHSupportingFeeOnTransferTokens(
516         uint amountIn,
517         uint amountOutMin,
518         address[] calldata path,
519         address to,
520         uint deadline
521     ) external;
522     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
523         uint amountIn,
524         uint amountOutMin,
525         address[] calldata path,
526         address to,
527         uint deadline
528     ) external;
529     function swapExactETHForTokensSupportingFeeOnTransferTokens(
530         uint amountOutMin,
531         address[] calldata path,
532         address to,
533         uint deadline
534     ) external payable;
535 }
536 
537 pragma solidity ^0.6.12;
538 
539 contract RewardWallet {
540     constructor() public {
541     }
542 }
543 
544 contract Balancer {
545     using SafeMath for uint256;
546     IUniswapV2Router02 public immutable _uniswapV2Router;
547     TRINITY private _tokenContract;
548     
549     constructor(TRINITY tokenContract, IUniswapV2Router02 uniswapV2Router) public {
550         _tokenContract =tokenContract;
551         _uniswapV2Router = uniswapV2Router;
552     }
553     
554     receive() external payable {}
555     
556     function rebalance() external returns (uint256) { 
557         swapEthForTokens(address(this).balance);
558     }
559 
560     function swapEthForTokens(uint256 EthAmount) private {
561         address[] memory uniswapPairPath = new address[](2);
562         uniswapPairPath[0] = _uniswapV2Router.WETH();
563         uniswapPairPath[1] = address(_tokenContract);
564 
565         _uniswapV2Router
566             .swapExactETHForTokensSupportingFeeOnTransferTokens{value: EthAmount}(
567                 0,
568                 uniswapPairPath,
569                 address(this),
570                 block.timestamp
571             );
572     }
573 }
574 
575 contract Swaper {
576     using SafeMath for uint256;
577     IUniswapV2Router02 public immutable _uniswapV2Router;
578     TRINITY private _tokenContract;
579     
580     constructor(TRINITY tokenContract, IUniswapV2Router02 uniswapV2Router) public {
581         _tokenContract = tokenContract;
582         _uniswapV2Router = uniswapV2Router;
583     }
584     
585     function swapTokens(address pairTokenAddress, uint256 tokenAmount) external {
586         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
587         swapTokensForTokens(pairTokenAddress, tokenAmount);
588         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
589         IERC20(pairTokenAddress).transfer(address(_tokenContract), newPairTokenBalance);
590     }
591     
592     function swapTokensForTokens(address pairTokenAddress, uint256 tokenAmount) private {
593         address[] memory path = new address[](2);
594         path[0] = address(_tokenContract);
595         path[1] = pairTokenAddress;
596 
597         _tokenContract.approve(address(_uniswapV2Router), tokenAmount);
598 
599         // make the swap
600         _uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
601             tokenAmount,
602             0, // accept any amount of pair token
603             path,
604             address(this),
605             block.timestamp
606         );
607     }
608 }
609 
610 contract TRINITY is Context, IERC20, Ownable {
611     using SafeMath for uint256;
612     using Address for address;
613 
614     IUniswapV2Router02 public immutable _uniswapV2Router;
615 
616     mapping (address => uint256) private _rOwned;
617     mapping (address => uint256) private _tOwned;
618     mapping (address => mapping (address => uint256)) private _allowances;
619 
620     mapping (address => bool) private _isExcluded;
621     address[] private _excluded;
622     address public _rewardWallet;
623     uint256 public _initialRewardLockAmount;
624     address public _uniswapETHPool;
625     
626     uint256 private constant MAX = ~uint256(0);
627     uint256 private _tTotal = 10000000e9;
628     uint256 private _rTotal = (MAX - (MAX % _tTotal));
629     uint256 public _tFeeTotal;
630     uint256 public _tBurnTotal;
631 
632     string private _name = 'Trinity';
633     string private _symbol = 'TRI';
634     uint8 private _decimals = 9;
635     
636     uint256 public _feeDecimals = 1;
637     uint256 public _taxFee = 0;
638     uint256 public _lockFee = 0;
639     uint256 public _maxTxAmount = 2000000e9;
640     uint256 public _minTokensBeforeSwap = 10000e9;
641     uint256 public _minInterestForReward = 10e9;
642     uint256 private _autoSwapCallerFee = 200e9;
643     
644     bool private inSwapAndLiquify;
645     bool public swapAndLiquifyEnabled;
646     bool public tradingEnabled;
647     
648     address private currentPairTokenAddress;
649     address private currentPoolAddress;
650     
651     uint256 private _liquidityRemoveFee = 2;
652     uint256 private _alchemyCallerFee = 5;
653     uint256 private _minTokenForAlchemy = 1000e9;
654     uint256 private _lastAlchemy;
655     uint256 private _alchemyInterval = 1 hours;
656     
657 
658     event FeeDecimalsUpdated(uint256 taxFeeDecimals);
659     event TaxFeeUpdated(uint256 taxFee);
660     event LockFeeUpdated(uint256 lockFee);
661     event MaxTxAmountUpdated(uint256 maxTxAmount);
662     event WhitelistUpdated(address indexed pairTokenAddress);
663     event TradingEnabled();
664     event SwapAndLiquifyEnabledUpdated(bool enabled);
665     event SwapAndLiquify(
666         address indexed pairTokenAddress,
667         uint256 tokensSwapped,
668         uint256 pairTokenReceived,
669         uint256 tokensIntoLiqudity
670     );
671     event Rebalance(uint256 tokenBurnt);
672     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
673     event AutoSwapCallerFeeUpdated(uint256 autoSwapCallerFee);
674     event MinInterestForRewardUpdated(uint256 minInterestForReward);
675     event LiquidityRemoveFeeUpdated(uint256 liquidityRemoveFee);
676     event AlchemyCallerFeeUpdated(uint256 rebalnaceCallerFee);
677     event MinTokenForAlchemyUpdated(uint256 minRebalanceAmount);
678     event AlchemyIntervalUpdated(uint256 rebalanceInterval);
679 
680     modifier lockTheSwap {
681         inSwapAndLiquify = true;
682         _;
683         inSwapAndLiquify = false;
684     }
685     
686     Balancer public balancer;
687     Swaper public swaper;
688 
689     constructor (IUniswapV2Router02 uniswapV2Router, uint256 initialRewardLockAmount) public {
690         _lastAlchemy = now;
691         
692         _uniswapV2Router = uniswapV2Router;
693         _rewardWallet = address(new RewardWallet());
694         _initialRewardLockAmount = initialRewardLockAmount;
695         
696         balancer = new Balancer(this, uniswapV2Router);
697         swaper = new Swaper(this, uniswapV2Router);
698         
699         currentPoolAddress = IUniswapV2Factory(uniswapV2Router.factory())
700             .createPair(address(this), uniswapV2Router.WETH());
701         currentPairTokenAddress = uniswapV2Router.WETH();
702         _uniswapETHPool = currentPoolAddress;
703         
704         updateSwapAndLiquifyEnabled(false);
705         
706         _rOwned[_msgSender()] = reflectionFromToken(_tTotal.sub(_initialRewardLockAmount), false);
707         _rOwned[_rewardWallet] = reflectionFromToken(_initialRewardLockAmount, false);
708         
709         emit Transfer(address(0), _msgSender(), _tTotal.sub(_initialRewardLockAmount));
710         emit Transfer(address(0), _rewardWallet, _initialRewardLockAmount);
711     }
712 
713     function name() public view returns (string memory) {
714         return _name;
715     }
716 
717     function symbol() public view returns (string memory) {
718         return _symbol;
719     }
720 
721     function decimals() public view returns (uint8) {
722         return _decimals;
723     }
724 
725     function totalSupply() public view override returns (uint256) {
726         return _tTotal;
727     }
728 
729     function balanceOf(address account) public view override returns (uint256) {
730         if (_isExcluded[account]) return _tOwned[account];
731         return tokenFromReflection(_rOwned[account]);
732     }
733 
734     function transfer(address recipient, uint256 amount) public override returns (bool) {
735         _transfer(_msgSender(), recipient, amount);
736         return true;
737     }
738 
739     function allowance(address owner, address spender) public view override returns (uint256) {
740         return _allowances[owner][spender];
741     }
742 
743     function approve(address spender, uint256 amount) public override returns (bool) {
744         _approve(_msgSender(), spender, amount);
745         return true;
746     }
747 
748     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
749         _transfer(sender, recipient, amount);
750         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
751         return true;
752     }
753 
754     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
755         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
756         return true;
757     }
758 
759     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
760         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
761         return true;
762     }
763 
764     function isExcluded(address account) public view returns (bool) {
765         return _isExcluded[account];
766     }
767 
768     
769     function reflect(uint256 tAmount) public {
770         address sender = _msgSender();
771         require(!_isExcluded[sender], "Trinity: Excluded addresses cannot call this function");
772         (uint256 rAmount,,,,,) = _getValues(tAmount);
773         _rOwned[sender] = _rOwned[sender].sub(rAmount);
774         _rTotal = _rTotal.sub(rAmount);
775         _tFeeTotal = _tFeeTotal.add(tAmount);
776     }
777 
778     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
779         require(tAmount <= _tTotal, "Amount must be less than supply");
780         if (!deductTransferFee) {
781             (uint256 rAmount,,,,,) = _getValues(tAmount);
782             return rAmount;
783         } else {
784             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
785             return rTransferAmount;
786         }
787     }
788 
789     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
790         require(rAmount <= _rTotal, "Trinity: Amount must be less than total reflections");
791         uint256 currentRate =  _getRate();
792         return rAmount.div(currentRate);
793     }
794 
795     function excludeAccount(address account) external onlyOwner() {
796         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'Trinity: We can not exclude Uniswap router.');
797         require(account != address(this), 'Trinity: We can not exclude contract self.');
798         require(account != _rewardWallet, 'Trinity: We can not exclude reweard wallet.');
799         require(!_isExcluded[account], "Trinity: Account is already excluded");
800         
801         if(_rOwned[account] > 0) {
802             _tOwned[account] = tokenFromReflection(_rOwned[account]);
803         }
804         _isExcluded[account] = true;
805         _excluded.push(account);
806     }
807 
808     function includeAccount(address account) external onlyOwner() {
809         require(_isExcluded[account], "Trinity: Account is already included");
810         for (uint256 i = 0; i < _excluded.length; i++) {
811             if (_excluded[i] == account) {
812                 _excluded[i] = _excluded[_excluded.length - 1];
813                 _tOwned[account] = 0;
814                 _isExcluded[account] = false;
815                 _excluded.pop();
816                 break;
817             }
818         }
819     }
820 
821     function _approve(address owner, address spender, uint256 amount) private {
822         require(owner != address(0), "Trinity: approve from the zero address");
823         require(spender != address(0), "Trinity: approve to the zero address");
824 
825         _allowances[owner][spender] = amount;
826         emit Approval(owner, spender, amount);
827     }
828 
829     function _transfer(address sender, address recipient, uint256 amount) private {
830         require(sender != address(0), "Trinity: transfer from the zero address");
831         require(recipient != address(0), "Trinity: transfer to the zero address");
832         require(amount > 0, "Trinity: Transfer amount must be greater than zero");
833         
834         if(sender != owner() && recipient != owner() && !inSwapAndLiquify) {
835             require(amount <= _maxTxAmount, "Trinity: Transfer amount exceeds the maxTxAmount.");
836             if((_msgSender() == currentPoolAddress || _msgSender() == address(_uniswapV2Router)) && !tradingEnabled)
837                 require(false, "Trinity: trading is disabled.");
838         }
839         
840         if(!inSwapAndLiquify) {
841             uint256 lockedBalanceForPool = balanceOf(address(this));
842             bool overMinTokenBalance = lockedBalanceForPool >= _minTokensBeforeSwap;
843             if (
844                 overMinTokenBalance &&
845                 msg.sender != currentPoolAddress &&
846                 swapAndLiquifyEnabled
847             ) {
848                 if(currentPairTokenAddress == _uniswapV2Router.WETH())
849                     swapAndLiquifyForEth(lockedBalanceForPool);
850                 else
851                     swapAndLiquifyForTokens(currentPairTokenAddress, lockedBalanceForPool);
852             }
853         }
854         
855         if (_isExcluded[sender] && !_isExcluded[recipient]) {
856             _transferFromExcluded(sender, recipient, amount);
857         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
858             _transferToExcluded(sender, recipient, amount);
859         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
860             _transferStandard(sender, recipient, amount);
861         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
862             _transferBothExcluded(sender, recipient, amount);
863         } else {
864             _transferStandard(sender, recipient, amount);
865         }
866     }
867     
868     receive() external payable {}
869     
870     function swapAndLiquifyForEth(uint256 lockedBalanceForPool) private lockTheSwap {
871         // split the contract balance except swapCallerFee into halves
872         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
873         uint256 half = lockedForSwap.div(2);
874         uint256 otherHalf = lockedForSwap.sub(half);
875 
876         // capture the contract's current ETH balance.
877         // this is so that we can capture exactly the amount of ETH that the
878         // swap creates, and not make the liquidity event include any ETH that
879         // has been manually sent to the contract
880         uint256 initialBalance = address(this).balance;
881 
882         // swap tokens for ETH
883         swapTokensForEth(half);
884         
885         // how much ETH did we just swap into?
886         uint256 newBalance = address(this).balance.sub(initialBalance);
887 
888         // add liquidity to uniswap
889         addLiquidityForEth(otherHalf, newBalance);
890         
891         emit SwapAndLiquify(_uniswapV2Router.WETH(), half, newBalance, otherHalf);
892         
893         _transfer(address(this), tx.origin, _autoSwapCallerFee);
894         
895         _sendRewardInterestToPool();
896     }
897     
898     function swapTokensForEth(uint256 tokenAmount) private {
899         // generate the uniswap pair path of token -> weth
900         address[] memory path = new address[](2);
901         path[0] = address(this);
902         path[1] = _uniswapV2Router.WETH();
903 
904         _approve(address(this), address(_uniswapV2Router), tokenAmount);
905 
906         // make the swap
907         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
908             tokenAmount,
909             0, // accept any amount of ETH
910             path,
911             address(this),
912             block.timestamp
913         );
914     }
915 
916     function addLiquidityForEth(uint256 tokenAmount, uint256 ethAmount) private {
917         // approve token transfer to cover all possible scenarios
918         _approve(address(this), address(_uniswapV2Router), tokenAmount);
919 
920         // add the liquidity
921         _uniswapV2Router.addLiquidityETH{value: ethAmount}(
922             address(this),
923             tokenAmount,
924             0, // slippage is unavoidable
925             0, // slippage is unavoidable
926             address(this),
927             block.timestamp
928         );
929     }
930     
931     function swapAndLiquifyForTokens(address pairTokenAddress, uint256 lockedBalanceForPool) private lockTheSwap {
932         // split the contract balance except swapCallerFee into halves
933         uint256 lockedForSwap = lockedBalanceForPool.sub(_autoSwapCallerFee);
934         uint256 half = lockedForSwap.div(2);
935         uint256 otherHalf = lockedForSwap.sub(half);
936         
937         _transfer(address(this), address(swaper), half);
938         
939         uint256 initialPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this));
940         
941         // swap tokens for pairToken
942         swaper.swapTokens(pairTokenAddress, half);
943         
944         uint256 newPairTokenBalance = IERC20(pairTokenAddress).balanceOf(address(this)).sub(initialPairTokenBalance);
945 
946         // add liquidity to uniswap
947         addLiquidityForTokens(pairTokenAddress, otherHalf, newPairTokenBalance);
948         
949         emit SwapAndLiquify(pairTokenAddress, half, newPairTokenBalance, otherHalf);
950         
951         _transfer(address(this), tx.origin, _autoSwapCallerFee);
952         
953         _sendRewardInterestToPool();
954     }
955 
956     function addLiquidityForTokens(address pairTokenAddress, uint256 tokenAmount, uint256 pairTokenAmount) private {
957         // approve token transfer to cover all possible scenarios
958         _approve(address(this), address(_uniswapV2Router), tokenAmount);
959         IERC20(pairTokenAddress).approve(address(_uniswapV2Router), pairTokenAmount);
960 
961         // add the liquidity
962         _uniswapV2Router.addLiquidity(
963             address(this),
964             pairTokenAddress,
965             tokenAmount,
966             pairTokenAmount,
967             0, // slippage is unavoidable
968             0, // slippage is unavoidable
969             address(this),
970             block.timestamp
971         );
972     }
973 
974     function alchemy() public lockTheSwap {
975         require(balanceOf(_msgSender()) >= _minTokenForAlchemy, "Trinity: You have not enough Trinity to ");
976         require(now > _lastAlchemy + _alchemyInterval, 'Trinity: Too Soon.');
977         
978         _lastAlchemy = now;
979 
980         uint256 amountToRemove = IERC20(_uniswapETHPool).balanceOf(address(this)).mul(_liquidityRemoveFee).div(100);
981 
982         removeLiquidityETH(amountToRemove);
983         balancer.rebalance();
984 
985         uint256 tNewTokenBalance = balanceOf(address(balancer));
986         uint256 tRewardForCaller = tNewTokenBalance.mul(_alchemyCallerFee).div(100);
987         uint256 tBurn = tNewTokenBalance.sub(tRewardForCaller);
988         
989         uint256 currentRate =  _getRate();
990         uint256 rBurn =  tBurn.mul(currentRate);
991         
992         _rOwned[_msgSender()] = _rOwned[_msgSender()].add(tRewardForCaller.mul(currentRate));
993         _rOwned[address(balancer)] = 0;
994         
995         _tBurnTotal = _tBurnTotal.add(tBurn);
996         _tTotal = _tTotal.sub(tBurn);
997         _rTotal = _rTotal.sub(rBurn);
998 
999         emit Transfer(address(balancer), _msgSender(), tRewardForCaller);
1000         emit Transfer(address(balancer), address(0), tBurn);
1001         emit Rebalance(tBurn);
1002     }
1003     
1004     function removeLiquidityETH(uint256 lpAmount) private returns(uint ETHAmount) {
1005         IERC20(_uniswapETHPool).approve(address(_uniswapV2Router), lpAmount);
1006         (ETHAmount) = _uniswapV2Router
1007             .removeLiquidityETHSupportingFeeOnTransferTokens(
1008                 address(this),
1009                 lpAmount,
1010                 0,
1011                 0,
1012                 address(balancer),
1013                 block.timestamp
1014             );
1015     }
1016 
1017     function _sendRewardInterestToPool() private {
1018         uint256 tRewardInterest = balanceOf(_rewardWallet).sub(_initialRewardLockAmount);
1019         if(tRewardInterest > _minInterestForReward) {
1020             uint256 rRewardInterest = reflectionFromToken(tRewardInterest, false);
1021             _rOwned[currentPoolAddress] = _rOwned[currentPoolAddress].add(rRewardInterest);
1022             _rOwned[_rewardWallet] = _rOwned[_rewardWallet].sub(rRewardInterest);
1023             emit Transfer(_rewardWallet, currentPoolAddress, tRewardInterest);
1024             IUniswapV2Pair(currentPoolAddress).sync();
1025         }
1026     }
1027 
1028     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1029         uint256 currentRate =  _getRate();
1030         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1031         uint256 rLock =  tLock.mul(currentRate);
1032         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1033         if(inSwapAndLiquify) {
1034             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1035             emit Transfer(sender, recipient, tAmount);
1036         } else {
1037             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1038             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1039             _reflectFee(rFee, tFee);
1040             emit Transfer(sender, address(this), tLock);
1041             emit Transfer(sender, recipient, tTransferAmount);
1042         }
1043     }
1044 
1045     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1046         uint256 currentRate =  _getRate();
1047         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1048         uint256 rLock =  tLock.mul(currentRate);
1049         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1050         if(inSwapAndLiquify) {
1051             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1052             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1053             emit Transfer(sender, recipient, tAmount);
1054         } else {
1055             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1056             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1057             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1058             _reflectFee(rFee, tFee);
1059             emit Transfer(sender, address(this), tLock);
1060             emit Transfer(sender, recipient, tTransferAmount);
1061         }
1062     }
1063 
1064     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1065         uint256 currentRate =  _getRate();
1066         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1067         uint256 rLock =  tLock.mul(currentRate);
1068         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1069         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1070         if(inSwapAndLiquify) {
1071             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1072             emit Transfer(sender, recipient, tAmount);
1073         } else {
1074             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1075             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1076             _reflectFee(rFee, tFee);
1077             emit Transfer(sender, address(this), tLock);
1078             emit Transfer(sender, recipient, tTransferAmount);
1079         }
1080     }
1081 
1082     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1083         uint256 currentRate =  _getRate();
1084         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getValues(tAmount);
1085         uint256 rLock =  tLock.mul(currentRate);
1086         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1087         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1088         if(inSwapAndLiquify) {
1089             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1090             _rOwned[recipient] = _rOwned[recipient].add(rAmount);
1091             emit Transfer(sender, recipient, tAmount);
1092         }
1093         else {
1094             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1095             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1096             _rOwned[address(this)] = _rOwned[address(this)].add(rLock);
1097             _reflectFee(rFee, tFee);
1098             emit Transfer(sender, address(this), tLock);
1099             emit Transfer(sender, recipient, tTransferAmount);
1100         }
1101     }
1102 
1103     function _reflectFee(uint256 rFee, uint256 tFee) private {
1104         _rTotal = _rTotal.sub(rFee);
1105         _tFeeTotal = _tFeeTotal.add(tFee);
1106     }
1107 
1108     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1109         (uint256 tTransferAmount, uint256 tFee, uint256 tLock) = _getTValues(tAmount, _taxFee, _lockFee, _feeDecimals);
1110         uint256 currentRate =  _getRate();
1111         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLock, currentRate);
1112         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLock);
1113     }
1114 
1115     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 lockFee, uint256 feeDecimals) private pure returns (uint256, uint256, uint256) {
1116         uint256 tFee = tAmount.mul(taxFee).div(10**(feeDecimals + 2));
1117         uint256 tLockFee = tAmount.mul(lockFee).div(10**(feeDecimals + 2));
1118         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLockFee);
1119         return (tTransferAmount, tFee, tLockFee);
1120     }
1121 
1122     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLock, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1123         uint256 rAmount = tAmount.mul(currentRate);
1124         uint256 rFee = tFee.mul(currentRate);
1125         uint256 rLock = tLock.mul(currentRate);
1126         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLock);
1127         return (rAmount, rTransferAmount, rFee);
1128     }
1129 
1130     function _getRate() public view returns(uint256) {
1131         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1132         return rSupply.div(tSupply);
1133     }
1134 
1135     function _getCurrentSupply() public view returns(uint256, uint256) {
1136         uint256 rSupply = _rTotal;
1137         uint256 tSupply = _tTotal;      
1138         for (uint256 i = 0; i < _excluded.length; i++) {
1139             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1140             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1141             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1142         }
1143         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1144         return (rSupply, tSupply);
1145     }
1146     
1147     function getCurrentPoolAddress() public view returns(address) {
1148         return currentPoolAddress;
1149     }
1150     
1151     function getCurrentPairTokenAddress() public view returns(address) {
1152         return currentPairTokenAddress;
1153     }
1154 
1155     function getLiquidityRemoveFee() public view returns(uint256) {
1156         return _liquidityRemoveFee;
1157     }
1158     
1159     function getAlchemyCallerFee() public view returns(uint256) {
1160         return _alchemyCallerFee;
1161     }
1162     
1163     function getMinTokenForAlchemy() public view returns(uint256) {
1164         return _minTokenForAlchemy;
1165     }
1166     
1167     function getLastAlchemy() public view returns(uint256) {
1168         return _lastAlchemy;
1169     }
1170     
1171     function getAlchemyInterval() public view returns(uint256) {
1172         return _alchemyInterval;
1173     }
1174     
1175     function _setFeeDecimals(uint256 feeDecimals) external onlyOwner() {
1176         require(feeDecimals >= 0 && feeDecimals <= 2, 'Trinity: fee decimals should be in 0 - 2');
1177         _feeDecimals = feeDecimals;
1178         emit FeeDecimalsUpdated(feeDecimals);
1179     }
1180     
1181     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1182         require(taxFee >= 0  && taxFee <= 5 * 10 ** _feeDecimals, 'Trinity: taxFee should be in 0 - 5');
1183         _taxFee = taxFee;
1184         emit TaxFeeUpdated(taxFee);
1185     }
1186     
1187     function _setLockFee(uint256 lockFee) external onlyOwner() {
1188         require(lockFee >= 0 && lockFee <= 5 * 10 ** _feeDecimals, 'Trinity: lockFee should be in 0 - 5');
1189         _lockFee = lockFee;
1190         emit LockFeeUpdated(lockFee);
1191     }
1192     
1193     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1194         require(maxTxAmount >= 500000e9 , 'Trinity: maxTxAmount should be greater than 500000e9');
1195         _maxTxAmount = maxTxAmount;
1196         emit MaxTxAmountUpdated(maxTxAmount);
1197     }
1198     
1199     function _setMinTokensBeforeSwap(uint256 minTokensBeforeSwap) external onlyOwner() {
1200         require(minTokensBeforeSwap >= 50e9 && minTokensBeforeSwap <= 25000e9 , 'Trinity: minTokenBeforeSwap should be in 50e9 - 25000e9');
1201         require(minTokensBeforeSwap > _autoSwapCallerFee , 'Trinity: minTokenBeforeSwap should be greater than autoSwapCallerFee');
1202         _minTokensBeforeSwap = minTokensBeforeSwap;
1203         emit MinTokensBeforeSwapUpdated(minTokensBeforeSwap);
1204     }
1205     
1206     function _setAutoSwapCallerFee(uint256 autoSwapCallerFee) external onlyOwner() {
1207         require(autoSwapCallerFee >= 1e9, 'Trinity: autoSwapCallerFee should be greater than 1e9');
1208         _autoSwapCallerFee = autoSwapCallerFee;
1209         emit AutoSwapCallerFeeUpdated(autoSwapCallerFee);
1210     }
1211     
1212     function _setMinInterestForReward(uint256 minInterestForReward) external onlyOwner() {
1213         _minInterestForReward = minInterestForReward;
1214         emit MinInterestForRewardUpdated(minInterestForReward);
1215     }
1216     
1217     function _setLiquidityRemoveFee(uint256 liquidityRemoveFee) external onlyOwner() {
1218         require(liquidityRemoveFee >= 1 && liquidityRemoveFee <= 10 , 'Trinity: liquidityRemoveFee should be in 1 - 10');
1219         _liquidityRemoveFee = liquidityRemoveFee;
1220         emit LiquidityRemoveFeeUpdated(liquidityRemoveFee);
1221     }
1222     
1223     function _setAlchemyCallerFee(uint256 alchemyCallerFee) external onlyOwner() {
1224         require(alchemyCallerFee >= 1 && alchemyCallerFee <= 15 , 'Trinity: alchemyCallerFee should be in 1 - 15');
1225         _alchemyCallerFee = alchemyCallerFee;
1226         emit AlchemyCallerFeeUpdated(alchemyCallerFee);
1227     }
1228     
1229     function _setMinTokenForAlchemy(uint256 minTokenForAlchemy) external onlyOwner() {
1230         _minTokenForAlchemy = minTokenForAlchemy;
1231         emit MinTokenForAlchemyUpdated(minTokenForAlchemy);
1232     }
1233     
1234     function _setAlchemyInterval(uint256 alchemyInterval) external onlyOwner() {
1235         _alchemyInterval = alchemyInterval;
1236         emit AlchemyIntervalUpdated(alchemyInterval);
1237     }
1238     
1239     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1240         swapAndLiquifyEnabled = _enabled;
1241         emit SwapAndLiquifyEnabledUpdated(_enabled);
1242     }
1243     
1244     function _updateWhitelist(address poolAddress, address pairTokenAddress) public onlyOwner() {
1245         require(poolAddress != address(0), "Trinity: Pool address is zero.");
1246         require(pairTokenAddress != address(0), "Trinity: Pair token address is zero.");
1247         require(pairTokenAddress != address(this), "Trinity: Pair token address self address.");
1248         require(pairTokenAddress != currentPairTokenAddress, "Trinity: Pair token address is same as current one.");
1249         
1250         currentPoolAddress = poolAddress;
1251         currentPairTokenAddress = pairTokenAddress;
1252         
1253         emit WhitelistUpdated(pairTokenAddress);
1254     }
1255 
1256     function _enableTrading() external onlyOwner() {
1257         tradingEnabled = true;
1258         TradingEnabled();
1259     }
1260 }