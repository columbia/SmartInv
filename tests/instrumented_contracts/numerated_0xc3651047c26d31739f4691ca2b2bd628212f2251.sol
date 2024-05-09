1 /**
2 Telegram: https://t.me/DOGELLACOIN
3 
4 Website: https://www.dogellacoin.com/
5 
6 Twitter: https://twitter.com/Dogellacoin
7 */
8 
9 pragma solidity ^0.8.9;
10 // SPDX-License-Identifier: Unlicensed
11 interface IERC20 {
12 
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 
81 
82 /**
83  * @dev Wrappers over Solidity's arithmetic operations with added overflow
84  * checks.
85  *
86  * Arithmetic operations in Solidity wrap on overflow. This can easily result
87  * in bugs, because programmers usually assume that an overflow raises an
88  * error, which is the standard behavior in high level programming languages.
89  * `SafeMath` restores this intuition by reverting the transaction when an
90  * operation overflows.
91  *
92  * Using this library instead of the unchecked operations eliminates an entire
93  * class of bugs, so it's recommended to use it always.
94  */
95  
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 abstract contract Context {
240     //function _msgSender() internal view virtual returns (address payable) {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes memory) {
246         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
247         return msg.data;
248     }
249 }
250 
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 contract Ownable is Context {
403     address private _owner;
404     address private _previousOwner;
405     uint256 private _lockTime;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     /**
410      * @dev Initializes the contract setting the deployer as the initial owner.
411      */
412     constructor () {
413         address msgSender = _msgSender();
414         _owner = msgSender;
415         emit OwnershipTransferred(address(0), msgSender);
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if called by any account other than the owner.
427      */
428     modifier onlyOwner() {
429         require(_owner == _msgSender(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433      /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public virtual onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 
455     function geUnlockTime() public view returns (uint256) {
456         return _lockTime;
457     }
458 
459     //Locks the contract for owner for the amount of time provided
460     function lock(uint256 time) public virtual onlyOwner {
461         _previousOwner = _owner;
462         _owner = address(0);
463         _lockTime = block.timestamp + time;
464         emit OwnershipTransferred(_owner, address(0));
465     }
466     
467     //Unlocks the contract for owner when _lockTime is exceeds
468     function unlock() public virtual {
469         require(_previousOwner == msg.sender, "You don't have permission to unlock");
470         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
471         emit OwnershipTransferred(_owner, _previousOwner);
472         _owner = _previousOwner;
473     }
474 }
475 
476 
477 interface IUniswapV2Factory {
478     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
479 
480     function feeTo() external view returns (address);
481     function feeToSetter() external view returns (address);
482 
483     function getPair(address tokenA, address tokenB) external view returns (address pair);
484     function allPairs(uint) external view returns (address pair);
485     function allPairsLength() external view returns (uint);
486 
487     function createPair(address tokenA, address tokenB) external returns (address pair);
488 
489     function setFeeTo(address) external;
490     function setFeeToSetter(address) external;
491 }
492 
493 
494 
495 interface IUniswapV2Pair {
496     event Approval(address indexed owner, address indexed spender, uint value);
497     event Transfer(address indexed from, address indexed to, uint value);
498 
499     function name() external pure returns (string memory);
500     function symbol() external pure returns (string memory);
501     function decimals() external pure returns (uint8);
502     function totalSupply() external view returns (uint);
503     function balanceOf(address owner) external view returns (uint);
504     function allowance(address owner, address spender) external view returns (uint);
505 
506     function approve(address spender, uint value) external returns (bool);
507     function transfer(address to, uint value) external returns (bool);
508     function transferFrom(address from, address to, uint value) external returns (bool);
509 
510     function DOMAIN_SEPARATOR() external view returns (bytes32);
511     function PERMIT_TYPEHASH() external pure returns (bytes32);
512     function nonces(address owner) external view returns (uint);
513 
514     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
515 
516     event Mint(address indexed sender, uint amount0, uint amount1);
517     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
518     event Swap(
519         address indexed sender,
520         uint amount0In,
521         uint amount1In,
522         uint amount0Out,
523         uint amount1Out,
524         address indexed to
525     );
526     event Sync(uint112 reserve0, uint112 reserve1);
527 
528     function MINIMUM_LIQUIDITY() external pure returns (uint);
529     function factory() external view returns (address);
530     function token0() external view returns (address);
531     function token1() external view returns (address);
532     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
533     function price0CumulativeLast() external view returns (uint);
534     function price1CumulativeLast() external view returns (uint);
535     function kLast() external view returns (uint);
536 
537     function mint(address to) external returns (uint liquidity);
538     function burn(address to) external returns (uint amount0, uint amount1);
539     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
540     function skim(address to) external;
541     function sync() external;
542 
543     function initialize(address, address) external;
544 }
545 
546 
547 interface IUniswapV2Router01 {
548     function factory() external pure returns (address);
549     function WETH() external pure returns (address);
550 
551     function addLiquidity(
552         address tokenA,
553         address tokenB,
554         uint amountADesired,
555         uint amountBDesired,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline
560     ) external returns (uint amountA, uint amountB, uint liquidity);
561     function addLiquidityETH(
562         address token,
563         uint amountTokenDesired,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
569     function removeLiquidity(
570         address tokenA,
571         address tokenB,
572         uint liquidity,
573         uint amountAMin,
574         uint amountBMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountA, uint amountB);
578     function removeLiquidityETH(
579         address token,
580         uint liquidity,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountToken, uint amountETH);
586     function removeLiquidityWithPermit(
587         address tokenA,
588         address tokenB,
589         uint liquidity,
590         uint amountAMin,
591         uint amountBMin,
592         address to,
593         uint deadline,
594         bool approveMax, uint8 v, bytes32 r, bytes32 s
595     ) external returns (uint amountA, uint amountB);
596     function removeLiquidityETHWithPermit(
597         address token,
598         uint liquidity,
599         uint amountTokenMin,
600         uint amountETHMin,
601         address to,
602         uint deadline,
603         bool approveMax, uint8 v, bytes32 r, bytes32 s
604     ) external returns (uint amountToken, uint amountETH);
605     function swapExactTokensForTokens(
606         uint amountIn,
607         uint amountOutMin,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external returns (uint[] memory amounts);
612     function swapTokensForExactTokens(
613         uint amountOut,
614         uint amountInMax,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external returns (uint[] memory amounts);
619     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         payable
622         returns (uint[] memory amounts);
623     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
624         external
625         returns (uint[] memory amounts);
626     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
630         external
631         payable
632         returns (uint[] memory amounts);
633 
634     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
635     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
636     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
637     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
638     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
639 }
640 
641 
642 
643 
644 interface IUniswapV2Router02 is IUniswapV2Router01 {
645     function removeLiquidityETHSupportingFeeOnTransferTokens(
646         address token,
647         uint liquidity,
648         uint amountTokenMin,
649         uint amountETHMin,
650         address to,
651         uint deadline
652     ) external returns (uint amountETH);
653     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline,
660         bool approveMax, uint8 v, bytes32 r, bytes32 s
661     ) external returns (uint amountETH);
662 
663     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
664         uint amountIn,
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external;
670     function swapExactETHForTokensSupportingFeeOnTransferTokens(
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external payable;
676     function swapExactTokensForETHSupportingFeeOnTransferTokens(
677         uint amountIn,
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external;
683 }
684 
685 interface IAirdrop {
686     function airdrop(address recipient, uint256 amount) external;
687 }
688 
689 contract DOGELLACOIN is Context, IERC20, Ownable {
690     using SafeMath for uint256;
691     using Address for address;
692 
693     mapping (address => uint256) private _rOwned;
694     mapping (address => uint256) private _tOwned;
695     mapping (address => mapping (address => uint256)) private _allowances;
696 
697     mapping (address => bool) private _isExcludedFromFee;
698 
699     mapping (address => bool) private _isExcluded;
700     address[] private _excluded;
701     
702     mapping (address => bool) private botWallets;
703     bool botscantrade = false;
704     
705     bool public canTrade = false;
706    
707     uint256 private constant MAX = ~uint256(0);
708     uint256 private _tTotal = 42000000000000 * 10**9;
709     uint256 private _rTotal = (MAX - (MAX % _tTotal));
710     uint256 private _tFeeTotal;
711     address public marketingWallet;
712 
713     string private _name = "Dogella Coin";
714     string private _symbol = "DOGELLA";
715     uint8 private _decimals = 9;
716     
717     uint256 public _taxFee = 0;
718     uint256 private _previousTaxFee = _taxFee;
719 
720     uint256 public marketingFeePercent = 85;
721     
722     uint256 public _liquidityFee = 8;
723     uint256 private _previousLiquidityFee = _liquidityFee;
724 
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public immutable uniswapV2Pair;
727     
728     bool inSwapAndLiquify;
729     bool public swapAndLiquifyEnabled = true;
730     
731     uint256 public _maxTxAmount = 420000000000 * 10**9;
732     uint256 public numTokensSellToAddToLiquidity = 420000000000 * 10**9;
733     uint256 public _maxWalletSize = 1260000000000 * 10**9;
734     
735     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
736     event SwapAndLiquifyEnabledUpdated(bool enabled);
737     event SwapAndLiquify(
738         uint256 tokensSwapped,
739         uint256 ethReceived,
740         uint256 tokensIntoLiqudity
741     );
742     
743     modifier lockTheSwap {
744         inSwapAndLiquify = true;
745         _;
746         inSwapAndLiquify = false;
747     }
748     
749     constructor () {
750         _rOwned[_msgSender()] = _rTotal;
751         
752         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
753          // Create a uniswap pair for this new token
754         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
755             .createPair(address(this), _uniswapV2Router.WETH());
756 
757         // set the rest of the contract variables
758         uniswapV2Router = _uniswapV2Router;
759         
760         //exclude owner and this contract from fee
761         _isExcludedFromFee[owner()] = true;
762         _isExcludedFromFee[address(this)] = true;
763         
764         emit Transfer(address(0), _msgSender(), _tTotal);
765     }
766 
767     function name() public view returns (string memory) {
768         return _name;
769     }
770 
771     function symbol() public view returns (string memory) {
772         return _symbol;
773     }
774 
775     function decimals() public view returns (uint8) {
776         return _decimals;
777     }
778 
779     function totalSupply() public view override returns (uint256) {
780         return _tTotal;
781     }
782 
783     function balanceOf(address account) public view override returns (uint256) {
784         if (_isExcluded[account]) return _tOwned[account];
785         return tokenFromReflection(_rOwned[account]);
786     }
787 
788     function transfer(address recipient, uint256 amount) public override returns (bool) {
789         _transfer(_msgSender(), recipient, amount);
790         return true;
791     }
792 
793     function allowance(address owner, address spender) public view override returns (uint256) {
794         return _allowances[owner][spender];
795     }
796 
797     function approve(address spender, uint256 amount) public override returns (bool) {
798         _approve(_msgSender(), spender, amount);
799         return true;
800     }
801 
802     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
803         _transfer(sender, recipient, amount);
804         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
805         return true;
806     }
807 
808     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
809         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
810         return true;
811     }
812 
813     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
815         return true;
816     }
817 
818     function isExcludedFromReward(address account) public view returns (bool) {
819         return _isExcluded[account];
820     }
821 
822     function totalFees() public view returns (uint256) {
823         return _tFeeTotal;
824     }
825     
826     function airdrop(address recipient, uint256 amount) external onlyOwner() {
827         removeAllFee();
828         _transfer(_msgSender(), recipient, amount * 10**9);
829         restoreAllFee();
830     }
831     
832     function airdropInternal(address recipient, uint256 amount) internal {
833         removeAllFee();
834         _transfer(_msgSender(), recipient, amount);
835         restoreAllFee();
836     }
837     
838     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
839         uint256 iterator = 0;
840         require(newholders.length == amounts.length, "must be the same length");
841         while(iterator < newholders.length){
842             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
843             iterator += 1;
844         }
845     }
846 
847     function deliver(uint256 tAmount) public {
848         address sender = _msgSender();
849         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
850         (uint256 rAmount,,,,,) = _getValues(tAmount);
851         _rOwned[sender] = _rOwned[sender].sub(rAmount);
852         _rTotal = _rTotal.sub(rAmount);
853         _tFeeTotal = _tFeeTotal.add(tAmount);
854     }
855 
856     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
857         require(tAmount <= _tTotal, "Amount must be less than supply");
858         if (!deductTransferFee) {
859             (uint256 rAmount,,,,,) = _getValues(tAmount);
860             return rAmount;
861         } else {
862             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
863             return rTransferAmount;
864         }
865     }
866 
867     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
868         require(rAmount <= _rTotal, "Amount must be less than total reflections");
869         uint256 currentRate =  _getRate();
870         return rAmount.div(currentRate);
871     }
872 
873     function excludeFromReward(address account) public onlyOwner() {
874         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
875         require(!_isExcluded[account], "Account is already excluded");
876         if(_rOwned[account] > 0) {
877             _tOwned[account] = tokenFromReflection(_rOwned[account]);
878         }
879         _isExcluded[account] = true;
880         _excluded.push(account);
881     }
882 
883     function includeInReward(address account) external onlyOwner() {
884         require(_isExcluded[account], "Account is already excluded");
885         for (uint256 i = 0; i < _excluded.length; i++) {
886             if (_excluded[i] == account) {
887                 _excluded[i] = _excluded[_excluded.length - 1];
888                 _tOwned[account] = 0;
889                 _isExcluded[account] = false;
890                 _excluded.pop();
891                 break;
892             }
893         }
894     }
895         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
896         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
897         _tOwned[sender] = _tOwned[sender].sub(tAmount);
898         _rOwned[sender] = _rOwned[sender].sub(rAmount);
899         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
900         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
901         _takeLiquidity(tLiquidity);
902         _reflectFee(rFee, tFee);
903         emit Transfer(sender, recipient, tTransferAmount);
904     }
905     
906     function excludeFromFee(address account) public onlyOwner {
907         _isExcludedFromFee[account] = true;
908     }
909     
910     function includeInFee(address account) public onlyOwner {
911         _isExcludedFromFee[account] = false;
912     }
913     function setMarketingFeePercent(uint256 fee) public onlyOwner {
914         marketingFeePercent = fee;
915     }
916 
917     function setMarketingWallet(address walletAddress) public onlyOwner {
918         marketingWallet = walletAddress;
919     }
920     
921     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
922         require(taxFee < 10, "Tax fee cannot be more than 10%");
923         _taxFee = taxFee;
924     }
925     
926     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
927         _liquidityFee = liquidityFee;
928     }
929 
930     function _setMaxWalletSizePercent(uint256 maxWalletSize)
931         external
932         onlyOwner
933     {
934         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
935     }
936    
937     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
938         require(maxTxAmount > 420000000000, "Max Tx Amount cannot be less than 69 Million");
939         _maxTxAmount = maxTxAmount * 10**9;
940     }
941     
942     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
943         require(SwapThresholdAmount > 420000000000, "Swap Threshold Amount cannot be less than 69 Million");
944         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
945     }
946     
947     function claimTokens () public onlyOwner {
948         // make sure we capture all BNB that may or may not be sent to this contract
949         payable(marketingWallet).transfer(address(this).balance);
950     }
951     
952     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
953         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
954     }
955     
956     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
957         walletaddress.transfer(address(this).balance);
958     }
959     
960     function addBotWallet(address botwallet) external onlyOwner() {
961         botWallets[botwallet] = true;
962     }
963     
964     function removeBotWallet(address botwallet) external onlyOwner() {
965         botWallets[botwallet] = false;
966     }
967     
968     function getBotWalletStatus(address botwallet) public view returns (bool) {
969         return botWallets[botwallet];
970     }
971     
972     function allowtrading()external onlyOwner() {
973         canTrade = true;
974     }
975 
976     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
977         swapAndLiquifyEnabled = _enabled;
978         emit SwapAndLiquifyEnabledUpdated(_enabled);
979     }
980     
981      //to recieve ETH from uniswapV2Router when swaping
982     receive() external payable {}
983 
984     function _reflectFee(uint256 rFee, uint256 tFee) private {
985         _rTotal = _rTotal.sub(rFee);
986         _tFeeTotal = _tFeeTotal.add(tFee);
987     }
988 
989     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
990         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
991         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
992         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
993     }
994 
995     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
996         uint256 tFee = calculateTaxFee(tAmount);
997         uint256 tLiquidity = calculateLiquidityFee(tAmount);
998         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
999         return (tTransferAmount, tFee, tLiquidity);
1000     }
1001 
1002     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1003         uint256 rAmount = tAmount.mul(currentRate);
1004         uint256 rFee = tFee.mul(currentRate);
1005         uint256 rLiquidity = tLiquidity.mul(currentRate);
1006         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1007         return (rAmount, rTransferAmount, rFee);
1008     }
1009 
1010     function _getRate() private view returns(uint256) {
1011         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1012         return rSupply.div(tSupply);
1013     }
1014 
1015     function _getCurrentSupply() private view returns(uint256, uint256) {
1016         uint256 rSupply = _rTotal;
1017         uint256 tSupply = _tTotal;      
1018         for (uint256 i = 0; i < _excluded.length; i++) {
1019             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1020             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1021             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1022         }
1023         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1024         return (rSupply, tSupply);
1025     }
1026     
1027     function _takeLiquidity(uint256 tLiquidity) private {
1028         uint256 currentRate =  _getRate();
1029         uint256 rLiquidity = tLiquidity.mul(currentRate);
1030         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1031         if(_isExcluded[address(this)])
1032             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1033     }
1034     
1035     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1036         return _amount.mul(_taxFee).div(
1037             10**2
1038         );
1039     }
1040 
1041     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1042         return _amount.mul(_liquidityFee).div(
1043             10**2
1044         );
1045     }
1046     
1047     function removeAllFee() private {
1048         if(_taxFee == 0 && _liquidityFee == 0) return;
1049         
1050         _previousTaxFee = _taxFee;
1051         _previousLiquidityFee = _liquidityFee;
1052         
1053         _taxFee = 0;
1054         _liquidityFee = 0;
1055     }
1056     
1057     function restoreAllFee() private {
1058         _taxFee = _previousTaxFee;
1059         _liquidityFee = _previousLiquidityFee;
1060     }
1061     
1062     function isExcludedFromFee(address account) public view returns(bool) {
1063         return _isExcludedFromFee[account];
1064     }
1065 
1066     function _approve(address owner, address spender, uint256 amount) private {
1067         require(owner != address(0), "ERC20: approve from the zero address");
1068         require(spender != address(0), "ERC20: approve to the zero address");
1069 
1070         _allowances[owner][spender] = amount;
1071         emit Approval(owner, spender, amount);
1072     }
1073 
1074     function _transfer(
1075         address from,
1076         address to,
1077         uint256 amount
1078     ) private {
1079         require(from != address(0), "ERC20: transfer from the zero address");
1080         require(to != address(0), "ERC20: transfer to the zero address");
1081         require(amount > 0, "Transfer amount must be greater than zero");
1082         if(from != owner() && to != owner())
1083             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1084 
1085         // is the token balance of this contract address over the min number of
1086         // tokens that we need to initiate a swap + liquidity lock?
1087         // also, don't get caught in a circular liquidity event.
1088         // also, don't swap & liquify if sender is uniswap pair.
1089         uint256 contractTokenBalance = balanceOf(address(this));
1090         
1091         if(contractTokenBalance >= _maxTxAmount)
1092         {
1093             contractTokenBalance = _maxTxAmount;
1094         }
1095         
1096         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1097         if (
1098             overMinTokenBalance &&
1099             !inSwapAndLiquify &&
1100             from != uniswapV2Pair &&
1101             swapAndLiquifyEnabled
1102         ) {
1103             contractTokenBalance = numTokensSellToAddToLiquidity;
1104             //add liquidity
1105             swapAndLiquify(contractTokenBalance);
1106         }
1107         
1108         //indicates if fee should be deducted from transfer
1109         bool takeFee = true;
1110         
1111         //if any account belongs to _isExcludedFromFee account then remove the fee
1112         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1113             takeFee = false;
1114         }
1115 
1116         if (takeFee) {
1117             if (to != uniswapV2Pair) {
1118                 require(
1119                     amount + balanceOf(to) <= _maxWalletSize,
1120                     "Recipient exceeds max wallet size."
1121                 );
1122             }
1123         }
1124         
1125         
1126         //transfer amount, it will take tax, burn, liquidity fee
1127         _tokenTransfer(from,to,amount,takeFee);
1128     }
1129 
1130     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1131         // split the contract balance into halves
1132         // add the marketing wallet
1133         uint256 half = contractTokenBalance.div(2);
1134         uint256 otherHalf = contractTokenBalance.sub(half);
1135 
1136         // capture the contract's current ETH balance.
1137         // this is so that we can capture exactly the amount of ETH that the
1138         // swap creates, and not make the liquidity event include any ETH that
1139         // has been manually sent to the contract
1140         uint256 initialBalance = address(this).balance;
1141 
1142         // swap tokens for ETH
1143         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1144 
1145         // how much ETH did we just swap into?
1146         uint256 newBalance = address(this).balance.sub(initialBalance);
1147         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1148         payable(marketingWallet).transfer(marketingshare);
1149         newBalance -= marketingshare;
1150         // add liquidity to uniswap
1151         addLiquidity(otherHalf, newBalance);
1152         
1153         emit SwapAndLiquify(half, newBalance, otherHalf);
1154     }
1155 
1156     function swapTokensForEth(uint256 tokenAmount) private {
1157         // generate the uniswap pair path of token -> weth
1158         address[] memory path = new address[](2);
1159         path[0] = address(this);
1160         path[1] = uniswapV2Router.WETH();
1161 
1162         _approve(address(this), address(uniswapV2Router), tokenAmount);
1163 
1164         // make the swap
1165         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1166             tokenAmount,
1167             0, // accept any amount of ETH
1168             path,
1169             address(this),
1170             block.timestamp
1171         );
1172     }
1173 
1174     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1175         // approve token transfer to cover all possible scenarios
1176         _approve(address(this), address(uniswapV2Router), tokenAmount);
1177 
1178         // add the liquidity
1179         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1180             address(this),
1181             tokenAmount,
1182             0, // slippage is unavoidable
1183             0, // slippage is unavoidable
1184             owner(),
1185             block.timestamp
1186         );
1187     }
1188 
1189     //this method is responsible for taking all fee, if takeFee is true
1190     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1191         if(!canTrade){
1192             require(sender == owner()); // only owner allowed to trade or add liquidity
1193         }
1194         
1195         if(botWallets[sender] || botWallets[recipient]){
1196             require(botscantrade, "bots arent allowed to trade");
1197         }
1198         
1199         if(!takeFee)
1200             removeAllFee();
1201         
1202         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1203             _transferFromExcluded(sender, recipient, amount);
1204         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1205             _transferToExcluded(sender, recipient, amount);
1206         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1207             _transferStandard(sender, recipient, amount);
1208         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1209             _transferBothExcluded(sender, recipient, amount);
1210         } else {
1211             _transferStandard(sender, recipient, amount);
1212         }
1213         
1214         if(!takeFee)
1215             restoreAllFee();
1216     }
1217 
1218     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1219         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1220         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1221         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1222         _takeLiquidity(tLiquidity);
1223         _reflectFee(rFee, tFee);
1224         emit Transfer(sender, recipient, tTransferAmount);
1225     }
1226 
1227     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1228         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1229         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1230         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1231         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1232         _takeLiquidity(tLiquidity);
1233         _reflectFee(rFee, tFee);
1234         emit Transfer(sender, recipient, tTransferAmount);
1235     }
1236 
1237     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1238         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1239         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1240         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1241         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1242         _takeLiquidity(tLiquidity);
1243         _reflectFee(rFee, tFee);
1244         emit Transfer(sender, recipient, tTransferAmount);
1245     }
1246 
1247 }