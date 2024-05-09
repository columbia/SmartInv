1 /**
2 
3 Telegram t.me/McBasePortal
4 Website wwww.mcbase.finance
5 Twitter www.twitter.com/Mcbase_Finance
6 Medium: https://mcbase-finance.medium.com/
7 
8 */ 
9 
10 // SPDX-License-Identifier: MIT
11 
12 pragma solidity ^0.6.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
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
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 contract Ownable is Context {
420     address private _owner;
421 
422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
423 
424     /**
425      * @dev Initializes the contract setting the deployer as the initial owner.
426      */
427     constructor () internal {
428         address msgSender = _msgSender();
429         _owner = msgSender;
430         emit OwnershipTransferred(address(0), msgSender);
431     }
432 
433     /**
434      * @dev Returns the address of the current owner.
435      */
436     function owner() public view returns (address) {
437         return _owner;
438     }
439 
440     /**
441      * @dev Throws if called by any account other than the owner.
442      */
443     modifier onlyOwner() {
444         require(_owner == _msgSender(), "Ownable: caller is not the owner");
445         _;
446     }
447 
448     /**
449      * @dev Leaves the contract without owner. It will not be possible to call
450      * `onlyOwner` functions anymore. Can only be called by the current owner.
451      *
452      * NOTE: Renouncing ownership will leave the contract without an owner,
453      * thereby removing any functionality that is only available to the owner.
454      */
455     function renounceOwnership() public virtual onlyOwner {
456         emit OwnershipTransferred(_owner, address(0));
457         _owner = address(0);
458     }
459 
460     /**
461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
462      * Can only be called by the current owner.
463      */
464     function transferOwnership(address newOwner) public virtual onlyOwner {
465         require(newOwner != address(0), "Ownable: new owner is the zero address");
466         emit OwnershipTransferred(_owner, newOwner);
467         _owner = newOwner;
468     }
469 }
470 
471 interface AggregatorV3Interface {
472 
473   function decimals() external view returns (uint8);
474   function description() external view returns (string memory);
475   function version() external view returns (uint256);
476 
477   // getRoundData and latestRoundData should both raise "No data present"
478   // if they do not have data to report, instead of returning unset values
479   // which could be misinterpreted as actual reported values.
480   function getRoundData(uint80 _roundId)
481     external
482     view
483     returns (
484       uint80 roundId,
485       int256 answer,
486       uint256 startedAt,
487       uint256 updatedAt,
488       uint80 answeredInRound
489     );
490   function latestRoundData()
491     external
492     view
493     returns (
494       uint80 roundId,
495       int256 answer,
496       uint256 startedAt,
497       uint256 updatedAt,
498       uint80 answeredInRound
499     );
500 
501 }
502 
503 contract PriceConsumerV3 {
504 
505     AggregatorV3Interface internal priceFeed;
506 
507     /**
508      * Network: Goerli
509      * Aggregator: ETH/USD
510      * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
511      */
512     constructor() public {
513         priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); //eth mainnet : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
514     }
515 
516     /**
517      * Returns the latest price
518      */
519     function getLatestPrice() public view returns (int) {
520         (
521             uint80 roundID, 
522             int price,
523             uint startedAt,
524             uint timeStamp,
525             uint80 answeredInRound
526         ) = priceFeed.latestRoundData();
527         return price;
528     }
529 }
530 
531 interface IUniswapV2Factory {
532     function createPair(address tokenA, address tokenB) external returns (address pair);
533 }
534 
535 interface IUniswapV2Pair {
536     function sync() external;
537 }
538 
539 interface IUniswapV2Router01 {
540     function factory() external pure returns (address);
541     function WETH() external pure returns (address);
542 
543     function addLiquidity(
544         address tokenA,
545         address tokenB,
546         uint amountADesired,
547         uint amountBDesired,
548         uint amountAMin,
549         uint amountBMin,
550         address to,
551         uint deadline
552     ) external returns (uint amountA, uint amountB, uint liquidity);
553     function addLiquidityETH(
554         address token,
555         uint amountTokenDesired,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline
560     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
561     function removeLiquidity(
562         address tokenA,
563         address tokenB,
564         uint liquidity,
565         uint amountAMin,
566         uint amountBMin,
567         address to,
568         uint deadline
569     ) external returns (uint amountA, uint amountB);
570     function removeLiquidityETH(
571         address token,
572         uint liquidity,
573         uint amountTokenMin,
574         uint amountETHMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountToken, uint amountETH);
578     function removeLiquidityWithPermit(
579         address tokenA,
580         address tokenB,
581         uint liquidity,
582         uint amountAMin,
583         uint amountBMin,
584         address to,
585         uint deadline,
586         bool approveMax, uint8 v, bytes32 r, bytes32 s
587     ) external returns (uint amountA, uint amountB);
588     function removeLiquidityETHWithPermit(
589         address token,
590         uint liquidity,
591         uint amountTokenMin,
592         uint amountETHMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountToken, uint amountETH);
597     function swapExactTokensForTokens(
598         uint amountIn,
599         uint amountOutMin,
600         address[] calldata path,
601         address to,
602         uint deadline
603     ) external returns (uint[] memory amounts);
604     function swapTokensForExactTokens(
605         uint amountOut,
606         uint amountInMax,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external returns (uint[] memory amounts);
611     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
612         external
613         payable
614         returns (uint[] memory amounts);
615     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
616         external
617         returns (uint[] memory amounts);
618     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
619         external
620         returns (uint[] memory amounts);
621     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
622         external
623         payable
624         returns (uint[] memory amounts);
625 
626     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
627     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
628     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
629     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
630     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
631 }
632 
633 interface IUniswapV2Router02 is IUniswapV2Router01 {
634     function removeLiquidityETHSupportingFeeOnTransferTokens(
635         address token,
636         uint liquidity,
637         uint amountTokenMin,
638         uint amountETHMin,
639         address to,
640         uint deadline
641     ) external returns (uint amountETH);
642     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
643         address token,
644         uint liquidity,
645         uint amountTokenMin,
646         uint amountETHMin,
647         address to,
648         uint deadline,
649         bool approveMax, uint8 v, bytes32 r, bytes32 s
650     ) external returns (uint amountETH);
651 
652     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
653         uint amountIn,
654         uint amountOutMin,
655         address[] calldata path,
656         address to,
657         uint deadline
658     ) external;
659     function swapExactETHForTokensSupportingFeeOnTransferTokens(
660         uint amountOutMin,
661         address[] calldata path,
662         address to,
663         uint deadline
664     ) external payable;
665     function swapExactTokensForETHSupportingFeeOnTransferTokens(
666         uint amountIn,
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external;
672 }
673 
674 contract MCBASE is Context, IERC20, Ownable {
675     using SafeMath for uint256;
676     using Address for address;
677     
678     IUniswapV2Router02 public uniV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
679     address public uniEthPool;
680     address[] public uniPairPath;
681     
682     PriceConsumerV3 _priceContract;
683     
684     string private _name = 'McBase.finance';
685     string private _symbol = 'MCBASE';
686     uint8 private _decimals = 18;
687     
688     uint256 private constant MAX_UINT256 = ~uint256(0);
689     uint256 private constant INITIAL_TOTAL_SUPPLY = 3000 * 1e18;
690     uint256 private constant TOTAL_MUL = MAX_UINT256 - (MAX_UINT256 % INITIAL_TOTAL_SUPPLY);
691     uint256 private constant MAX_SUPPLY = ~uint128(0);
692     uint256 public PEGGED_PRICE = 515e6;                                                // $5.15
693 
694     uint256 private _totalSupply;
695     uint256 private _rebaseRate;
696     mapping (address => uint256) private _balance;
697     mapping (address => mapping (address => uint256)) private _allowances;
698     mapping(address => bool) public blacklist;
699     
700     uint256 public _supersize_caller_fee = 5e18;
701     uint256 public _epochCycle = 12 hours;    //main net 12 hours;
702     uint256 public _lastEpochTime;
703     uint256 public _lastRebaseBlock;
704     bool public _live;
705     uint256 public _rebaseLag = 50;                         // lag 5
706     
707     uint256 private _lastPriceCheckTime;
708     uint256 private _priceCumulative;
709     uint256 private _priceCheckInterval = 30 seconds;
710 
711     bool swapping;
712     uint256 public _txFee = 5;  // 2.5% to liquidity, 2.5% to team
713     modifier lockTheSwap {swapping = true; _; swapping = false;}
714     address private team = 0x366098c9a8f4f2C13F68348cbd37b71c02886B8e;
715     uint256 public _swapThreshold = 1000; //0.1% of total supply
716     
717     
718     constructor () public {
719         _priceContract = new PriceConsumerV3();
720         
721         _totalSupply = INITIAL_TOTAL_SUPPLY;
722         _balance[_msgSender()] = TOTAL_MUL;
723         _rebaseRate = TOTAL_MUL.div(INITIAL_TOTAL_SUPPLY);
724         
725         uniEthPool = IUniswapV2Factory(uniV2Router.factory())
726             .createPair(address(this), uniV2Router.WETH());
727             
728         uniPairPath = new address[](2);
729         uniPairPath[0] = uniV2Router.WETH();
730         uniPairPath[1] = address(this);
731         
732         emit Transfer(address(0x0), _msgSender(), _totalSupply);
733     }
734 
735     receive() external payable {}
736     
737     function name() public view returns (string memory) {
738         return _name;
739     }
740 
741     function symbol() public view returns (string memory) {
742         return _symbol;
743     }
744 
745     function decimals() public view returns (uint8) {
746         return _decimals;
747     }
748 
749     function totalSupply() public view override returns (uint256) {
750         return _totalSupply;
751     }
752 
753     function balanceOf(address account) public view override returns (uint256) {
754         return _balance[account].div(_rebaseRate);
755     }
756 
757     function transfer(address recipient, uint256 amount) public override returns (bool) {
758         _transfer(_msgSender(), recipient, amount);
759         return true;
760     }
761     
762     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
763         _transfer(sender, recipient, amount);
764         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
765         return true;
766     }
767 
768     function allowance(address owner, address spender) public view override returns (uint256) {
769         return _allowances[owner][spender];
770     }
771 
772     function approve(address spender, uint256 amount) public override returns (bool) {
773         _approve(_msgSender(), spender, amount);
774         return true;
775     }
776 
777     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
778         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
779         return true;
780     }
781 
782     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
783         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
784         return true;
785     }
786     
787     function _transfer(address sender, address recipient, uint256 amount) private {
788         require(sender != address(0), "ERC20: transfer from the zero address");
789         require(recipient != address(0), "ERC20: transfer from the zero address");
790         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
791         
792         if(block.number == _lastRebaseBlock)
793             require(sender == address(this), 'MCBASE: the transaction is not allowed at epoch block.');
794             
795         if(sender != uniEthPool)
796             require(!blacklist[recipient] && !blacklist[sender], 'MCBASE: the transaction was blocked.');
797         
798         uint256 currentTime =  block.timestamp;
799         if(_live && currentTime.sub(_lastPriceCheckTime) >= _priceCheckInterval) {
800             uint256 tokenPriceInUSD = getTokenPriceInUSD();
801             _priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
802             _lastPriceCheckTime = currentTime;
803         }
804 
805         if(!swapping && balanceOf(address(this)) >= _totalSupply.div(_swapThreshold) && msg.sender != uniEthPool) {
806             swapAndLiquify(_totalSupply.div(_swapThreshold));
807         }
808                
809         uint256 rebaseValue = amount.mul(_rebaseRate);
810         _balance[sender] = _balance[sender].sub(rebaseValue);
811 
812         if(sender != owner() && recipient != owner() && (sender == uniEthPool || sender == address(uniV2Router) || recipient == uniEthPool || recipient == address(uniV2Router))) {
813             uint256 txFee = _live ? _txFee : 25;
814             uint256 feeAmount = amount.mul(txFee).div(100);
815             uint256 rebaseFeeAmount = feeAmount.mul(_rebaseRate);
816             _balance[recipient] = _balance[recipient].add(rebaseValue.sub(rebaseFeeAmount));
817             _balance[address(this)] = _balance[address(this)].add(rebaseFeeAmount);
818             emit Transfer(sender, recipient, amount.sub(feeAmount));
819             emit Transfer(sender, address(this), feeAmount);
820         } else {
821             _balance[recipient] = _balance[recipient].add(rebaseValue);
822             emit Transfer(sender, recipient, amount);
823         }
824     }
825     
826     function swapAndLiquify(uint256 tokens) private lockTheSwap {
827         uint256 toTeam = tokens.mul(3).div(4);
828         uint256 initialBalance = address(this).balance;
829         swapTokensForETH(toTeam);
830         uint256 deltaBalance = address(this).balance.sub(initialBalance);
831         uint256 teamBalance= deltaBalance.mul(2).div(3);
832         uint256 ETHToAddLiquidityWith = deltaBalance.sub(teamBalance);
833         if(ETHToAddLiquidityWith > 0){
834             addLiquidity(tokens.sub(toTeam), ETHToAddLiquidityWith); }
835         if(teamBalance > 0){
836           payable(team).transfer(teamBalance); }
837     }
838 
839     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
840         _approve(address(this), address(uniV2Router), tokenAmount);
841         uniV2Router.addLiquidityETH{value: ETHAmount}(
842             address(this),
843             tokenAmount,
844             0,
845             0,
846             address(this),
847             block.timestamp);
848     }
849 
850     function swapTokensForETH(uint256 tokenAmount) private {
851         address[] memory path = new address[](2);
852         path[0] = address(this);
853         path[1] = uniV2Router.WETH();
854         _approve(address(this), address(uniV2Router), tokenAmount);
855         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
856             tokenAmount,
857             0,
858             path,
859             address(this),
860             block.timestamp);
861     }
862 
863     function _approve(address owner, address spender, uint256 amount) private {
864         require(owner != address(0), "ERC20: approve from the zero address");
865         require(spender != address(0), "ERC20: approve to the zero address");
866 
867         _allowances[owner][spender] = amount;
868         emit Approval(owner, spender, amount);
869     }
870     
871     function Supersize() public returns(uint256) {
872         require(_live && block.timestamp >= _lastEpochTime + _epochCycle, 'MCBASE: early epoch.');
873 
874         uint256 currentTime =  block.timestamp;
875         uint256 tokenPriceInUSD = getTokenPriceInUSD();
876         uint256 peggedPriceInUSD = PEGGED_PRICE.mul(1e18);
877         
878         uint256 priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
879         uint256 tokenAveragePriceInUSD = priceCumulative.div(currentTime.sub(_lastEpochTime));
880 
881         _lastEpochTime = currentTime;
882         _lastPriceCheckTime = currentTime;
883         _priceCumulative = 0;
884         _lastRebaseBlock = block.number;
885         
886         uint256 newTotalSupply = _totalSupply.mul(tokenAveragePriceInUSD).div(peggedPriceInUSD);
887         
888         if(newTotalSupply > _totalSupply) {
889             uint256 increaseAmount = (newTotalSupply.sub(_totalSupply)).mul(10).div(_rebaseLag);
890             _totalSupply = _totalSupply.add(increaseAmount);
891         }
892         else if(newTotalSupply < _totalSupply) {
893             uint256 decreaseAmount = (_totalSupply.sub(newTotalSupply)).mul(10).div(_rebaseLag);
894             _totalSupply = _totalSupply.sub(decreaseAmount);
895         }
896         
897         _rebaseRate = TOTAL_MUL.div(_totalSupply);
898         IUniswapV2Pair(uniEthPool).sync();
899         
900         if(_supersize_caller_fee > 0)
901             _transfer(address(this), _msgSender(), _supersize_caller_fee);
902 
903         return newTotalSupply;
904     }
905     
906     function updateLive() public onlyOwner {
907         if(!_live) {
908             _lastEpochTime = block.timestamp;
909             _lastPriceCheckTime = _lastEpochTime;
910             _live = true;    
911         }
912     }
913     
914     function updateRebaseLag(uint256 rebaseLag) public onlyOwner {
915         require(rebaseLag > 0, 'MCBASE: rebase lag is 0');
916         _rebaseLag = rebaseLag;
917     }
918 
919     function updateSuperizeCallerFee(uint256 supersize_caller_fee) public onlyOwner {
920         _supersize_caller_fee = supersize_caller_fee;
921     }
922     
923     function unblockWallet(address account) public onlyOwner {
924         blacklist[account] = false;
925     }
926 
927     function updateTxFee(uint256 txFee) public onlyOwner {
928         require(txFee <=5, 'max txFee is 5.');
929         _txFee = txFee;
930     }
931 
932     function updatePeggedPrice(uint256 peggedPrice) public onlyOwner {
933         require(peggedPrice > 1e6, 'pegged price should be greater than $0.01');
934         PEGGED_PRICE = peggedPrice;
935     }
936 
937     function updateSwapThreshold(uint256 swapThreshold) public onlyOwner {
938         require(swapThreshold >= 100, 'max swap threshold percentage is 1% of total supply');
939         _swapThreshold = swapThreshold;
940     }
941     
942     function getTokenAveragePriceInUSD() public view returns(uint256) {
943         uint256 currentTime =  block.timestamp;
944         uint256 tokenPriceInUSD = getTokenPriceInUSD();
945         uint256 priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
946         return priceCumulative.div(currentTime.sub(_lastEpochTime));
947     }
948     
949     function getTokenPriceInETH() public view returns(uint256) {
950         return uniV2Router.getAmountsIn(1e18, uniPairPath)[0];
951     }
952     
953     function getETHPriceInUSD() public view returns(uint256) {
954         return uint256(_priceContract.getLatestPrice());
955     }
956     
957     function getTokenPriceInUSD() public view returns(uint256) {
958         uint256 tokenPriceInETH = getTokenPriceInETH();
959         uint256 ETHPriceInUSD = uint256(_priceContract.getLatestPrice());
960         return tokenPriceInETH.mul(ETHPriceInUSD);
961     }
962     
963     function getSupersizeRate() public view returns(uint256, bool) {
964         uint256 currentTime =  block.timestamp;
965         uint256 tokenPriceInUSD = getTokenPriceInUSD();
966         uint256 peggedPriceInUSD = PEGGED_PRICE.mul(1e18);
967         
968         uint256 priceCumulative = _priceCumulative.add(tokenPriceInUSD.mul(currentTime.sub(_lastPriceCheckTime)));
969         uint256 tokenAveragePriceInUSD = priceCumulative.div(currentTime.sub(_lastEpochTime));
970         
971         uint256 newTotalSupply = _totalSupply.mul(tokenAveragePriceInUSD).div(peggedPriceInUSD);
972         
973         if(newTotalSupply >= _totalSupply) {
974             return ((newTotalSupply.sub(_totalSupply)).mul(10000).div(_totalSupply), true);
975         } else if(newTotalSupply < _totalSupply) {
976             return ((_totalSupply.sub(newTotalSupply)).mul(10000).div(_totalSupply), false);
977         }
978     }
979 }