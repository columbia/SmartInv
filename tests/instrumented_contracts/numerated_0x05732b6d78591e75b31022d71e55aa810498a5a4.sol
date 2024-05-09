1 // SHIBGOTCHI 
2 // Version: 1
3 // Website: www.shibgotchi.io
4 // Twitter: https://twitter.com/SHiBGOTCHI
5 // TG: https://t.me/SHIBGOTCHI
6 
7 pragma solidity ^0.8.9;
8 // SPDX-License-Identifier: Unlicensed
9 interface IERC20 {
10 
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations with added overflow
82  * checks.
83  *
84  * Arithmetic operations in Solidity wrap on overflow. This can easily result
85  * in bugs, because programmers usually assume that an overflow raises an
86  * error, which is the standard behavior in high level programming languages.
87  * `SafeMath` restores this intuition by reverting the transaction when an
88  * operation overflows.
89  *
90  * Using this library instead of the unchecked operations eliminates an entire
91  * class of bugs, so it's recommended to use it always.
92  */
93  
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "SafeMath: addition overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the subtraction of two unsigned integers, reverting on
114      * overflow (when the result is negative).
115      *
116      * Counterpart to Solidity's `-` operator.
117      *
118      * Requirements:
119      *
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      *
151      * - Multiplication cannot overflow.
152      */
153     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155         // benefit is lost if 'b' is also tested.
156         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157         if (a == 0) {
158             return 0;
159         }
160 
161         uint256 c = a * b;
162         require(c / a == b, "SafeMath: multiplication overflow");
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the integer division of two unsigned integers. Reverts on
169      * division by zero. The result is rounded towards zero.
170      *
171      * Counterpart to Solidity's `/` operator. Note: this function uses a
172      * `revert` opcode (which leaves remaining gas untouched) while Solidity
173      * uses an invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         return div(a, b, "SafeMath: division by zero");
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b > 0, errorMessage);
197         uint256 c = a / b;
198         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * Reverts when dividing by zero.
206      *
207      * Counterpart to Solidity's `%` operator. This function uses a `revert`
208      * opcode (which leaves remaining gas untouched) while Solidity uses an
209      * invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216         return mod(a, b, "SafeMath: modulo by zero");
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts with custom message when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b != 0, errorMessage);
233         return a % b;
234     }
235 }
236 
237 abstract contract Context {
238     //function _msgSender() internal view virtual returns (address payable) {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes memory) {
244         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
245         return msg.data;
246     }
247 }
248 
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
273         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
274         // for accounts without code, i.e. `keccak256('')`
275         bytes32 codehash;
276         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { codehash := extcodehash(account) }
279         return (codehash != accountHash && codehash != 0x0);
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325       return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         return _functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         return _functionCallWithValue(target, data, value, errorMessage);
362     }
363 
364     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 // solhint-disable-next-line no-inline-assembly
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 contract Ownable is Context {
401     address private _owner;
402     address private _previousOwner;
403     uint256 private _lockTime;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor () {
411         address msgSender = _msgSender();
412         _owner = msgSender;
413         emit OwnershipTransferred(address(0), msgSender);
414     }
415 
416     /**
417      * @dev Returns the address of the current owner.
418      */
419     function owner() public view returns (address) {
420         return _owner;
421     }
422 
423     /**
424      * @dev Throws if called by any account other than the owner.
425      */
426     modifier onlyOwner() {
427         require(_owner == _msgSender(), "Ownable: caller is not the owner");
428         _;
429     }
430 
431      /**
432      * @dev Leaves the contract without owner. It will not be possible to call
433      * `onlyOwner` functions anymore. Can only be called by the current owner.
434      *
435      * NOTE: Renouncing ownership will leave the contract without an owner,
436      * thereby removing any functionality that is only available to the owner.
437      */
438     function renounceOwnership() public virtual onlyOwner {
439         emit OwnershipTransferred(_owner, address(0));
440         _owner = address(0);
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Can only be called by the current owner.
446      */
447     function transferOwnership(address newOwner) public virtual onlyOwner {
448         require(newOwner != address(0), "Ownable: new owner is the zero address");
449         emit OwnershipTransferred(_owner, newOwner);
450         _owner = newOwner;
451     }
452 
453     function geUnlockTime() public view returns (uint256) {
454         return _lockTime;
455     }
456 
457     //Locks the contract for owner for the amount of time provided
458     function lock(uint256 time) public virtual onlyOwner {
459         _previousOwner = _owner;
460         _owner = address(0);
461         _lockTime = block.timestamp + time;
462         emit OwnershipTransferred(_owner, address(0));
463     }
464     
465     //Unlocks the contract for owner when _lockTime is exceeds
466     function unlock() public virtual {
467         require(_previousOwner == msg.sender, "You don't have permission to unlock");
468         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
469         emit OwnershipTransferred(_owner, _previousOwner);
470         _owner = _previousOwner;
471     }
472 }
473 
474 
475 interface IUniswapV2Factory {
476     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
477 
478     function feeTo() external view returns (address);
479     function feeToSetter() external view returns (address);
480 
481     function getPair(address tokenA, address tokenB) external view returns (address pair);
482     function allPairs(uint) external view returns (address pair);
483     function allPairsLength() external view returns (uint);
484 
485     function createPair(address tokenA, address tokenB) external returns (address pair);
486 
487     function setFeeTo(address) external;
488     function setFeeToSetter(address) external;
489 }
490 
491 
492 
493 interface IUniswapV2Pair {
494     event Approval(address indexed owner, address indexed spender, uint value);
495     event Transfer(address indexed from, address indexed to, uint value);
496 
497     function name() external pure returns (string memory);
498     function symbol() external pure returns (string memory);
499     function decimals() external pure returns (uint8);
500     function totalSupply() external view returns (uint);
501     function balanceOf(address owner) external view returns (uint);
502     function allowance(address owner, address spender) external view returns (uint);
503 
504     function approve(address spender, uint value) external returns (bool);
505     function transfer(address to, uint value) external returns (bool);
506     function transferFrom(address from, address to, uint value) external returns (bool);
507 
508     function DOMAIN_SEPARATOR() external view returns (bytes32);
509     function PERMIT_TYPEHASH() external pure returns (bytes32);
510     function nonces(address owner) external view returns (uint);
511 
512     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
513 
514     event Mint(address indexed sender, uint amount0, uint amount1);
515     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
516     event Swap(
517         address indexed sender,
518         uint amount0In,
519         uint amount1In,
520         uint amount0Out,
521         uint amount1Out,
522         address indexed to
523     );
524     event Sync(uint112 reserve0, uint112 reserve1);
525 
526     function MINIMUM_LIQUIDITY() external pure returns (uint);
527     function factory() external view returns (address);
528     function token0() external view returns (address);
529     function token1() external view returns (address);
530     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
531     function price0CumulativeLast() external view returns (uint);
532     function price1CumulativeLast() external view returns (uint);
533     function kLast() external view returns (uint);
534 
535     function mint(address to) external returns (uint liquidity);
536     function burn(address to) external returns (uint amount0, uint amount1);
537     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
538     function skim(address to) external;
539     function sync() external;
540 
541     function initialize(address, address) external;
542 }
543 
544 
545 interface IUniswapV2Router01 {
546     function factory() external pure returns (address);
547     function WETH() external pure returns (address);
548 
549     function addLiquidity(
550         address tokenA,
551         address tokenB,
552         uint amountADesired,
553         uint amountBDesired,
554         uint amountAMin,
555         uint amountBMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountA, uint amountB, uint liquidity);
559     function addLiquidityETH(
560         address token,
561         uint amountTokenDesired,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline
566     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
567     function removeLiquidity(
568         address tokenA,
569         address tokenB,
570         uint liquidity,
571         uint amountAMin,
572         uint amountBMin,
573         address to,
574         uint deadline
575     ) external returns (uint amountA, uint amountB);
576     function removeLiquidityETH(
577         address token,
578         uint liquidity,
579         uint amountTokenMin,
580         uint amountETHMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountToken, uint amountETH);
584     function removeLiquidityWithPermit(
585         address tokenA,
586         address tokenB,
587         uint liquidity,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline,
592         bool approveMax, uint8 v, bytes32 r, bytes32 s
593     ) external returns (uint amountA, uint amountB);
594     function removeLiquidityETHWithPermit(
595         address token,
596         uint liquidity,
597         uint amountTokenMin,
598         uint amountETHMin,
599         address to,
600         uint deadline,
601         bool approveMax, uint8 v, bytes32 r, bytes32 s
602     ) external returns (uint amountToken, uint amountETH);
603     function swapExactTokensForTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapTokensForExactTokens(
611         uint amountOut,
612         uint amountInMax,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
618         external
619         payable
620         returns (uint[] memory amounts);
621     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631 
632     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
633     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
634     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
635     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
636     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
637 }
638 
639 
640 
641 
642 interface IUniswapV2Router02 is IUniswapV2Router01 {
643     function removeLiquidityETHSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountETH);
651     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline,
658         bool approveMax, uint8 v, bytes32 r, bytes32 s
659     ) external returns (uint amountETH);
660 
661     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668     function swapExactETHForTokensSupportingFeeOnTransferTokens(
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external payable;
674     function swapExactTokensForETHSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681 }
682 
683 interface IAirdrop {
684     function airdrop(address recipient, uint256 amount) external;
685 }
686 
687 contract Shibgotchi is Context, IERC20, Ownable {
688     using SafeMath for uint256;
689     using Address for address;
690 
691     mapping (address => uint256) private _rOwned;
692     mapping (address => uint256) private _tOwned;
693     mapping (address => mapping (address => uint256)) private _allowances;
694 
695     mapping (address => bool) private _isExcludedFromFee;
696 
697     mapping (address => bool) private _isExcluded;
698     address[] private _excluded;
699     
700     mapping (address => bool) private botWallets;
701     bool botscantrade = false;
702     
703     bool public canTrade = false;
704    
705     uint256 private constant MAX = ~uint256(0);
706     uint256 private _tTotal = 100000000000000000000000000;
707     uint256 private _rTotal = (MAX - (MAX % _tTotal));
708     uint256 private _tFeeTotal;
709     address public marketingWallet;
710 
711     string private _name = "SHiBGOTCHi";
712     string private _symbol = "SHiBGOTCHi";
713     uint8 private _decimals = 9;
714     
715     uint256 public _taxFee = 5;
716     uint256 private _previousTaxFee = _taxFee;
717 
718     uint256 public marketingFeePercent = 38;
719     
720     uint256 public _liquidityFee = 8;
721     uint256 private _previousLiquidityFee = _liquidityFee;
722 
723     IUniswapV2Router02 public immutable uniswapV2Router;
724     address public immutable uniswapV2Pair;
725     
726     bool inSwapAndLiquify;
727     bool public swapAndLiquifyEnabled = true;
728     
729     uint256 public _maxTxAmount = 1000000000000000000000000; 
730     uint256 public numTokensSellToAddToLiquidity = 1000000000000000000000000;
731     
732     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
733     event SwapAndLiquifyEnabledUpdated(bool enabled);
734     event SwapAndLiquify(
735         uint256 tokensSwapped,
736         uint256 ethReceived,
737         uint256 tokensIntoLiqudity
738     );
739     
740     modifier lockTheSwap {
741         inSwapAndLiquify = true;
742         _;
743         inSwapAndLiquify = false;
744     }
745     
746     constructor () {
747         _rOwned[_msgSender()] = _rTotal;
748         
749         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); //Mainnet BSC
750         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); //Testnet BSC
751         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
752          // Create a uniswap pair for this new token
753         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
754             .createPair(address(this), _uniswapV2Router.WETH());
755 
756         // set the rest of the contract variables
757         uniswapV2Router = _uniswapV2Router;
758         
759         //exclude owner and this contract from fee
760         _isExcludedFromFee[owner()] = true;
761         _isExcludedFromFee[address(this)] = true;
762         
763         emit Transfer(address(0), _msgSender(), _tTotal);
764     }
765 
766     function name() public view returns (string memory) {
767         return _name;
768     }
769 
770     function symbol() public view returns (string memory) {
771         return _symbol;
772     }
773 
774     function decimals() public view returns (uint8) {
775         return _decimals;
776     }
777 
778     function totalSupply() public view override returns (uint256) {
779         return _tTotal;
780     }
781 
782     function balanceOf(address account) public view override returns (uint256) {
783         if (_isExcluded[account]) return _tOwned[account];
784         return tokenFromReflection(_rOwned[account]);
785     }
786 
787     function transfer(address recipient, uint256 amount) public override returns (bool) {
788         _transfer(_msgSender(), recipient, amount);
789         return true;
790     }
791 
792     function allowance(address owner, address spender) public view override returns (uint256) {
793         return _allowances[owner][spender];
794     }
795 
796     function approve(address spender, uint256 amount) public override returns (bool) {
797         _approve(_msgSender(), spender, amount);
798         return true;
799     }
800 
801     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
802         _transfer(sender, recipient, amount);
803         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
804         return true;
805     }
806 
807     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
808         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
809         return true;
810     }
811 
812     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
814         return true;
815     }
816 
817     function isExcludedFromReward(address account) public view returns (bool) {
818         return _isExcluded[account];
819     }
820 
821     function totalFees() public view returns (uint256) {
822         return _tFeeTotal;
823     }
824     
825     function airdrop(address recipient, uint256 amount) external onlyOwner() {
826         removeAllFee();
827         _transfer(_msgSender(), recipient, amount * 10**9);
828         restoreAllFee();
829     }
830     
831     function airdropInternal(address recipient, uint256 amount) internal {
832         removeAllFee();
833         _transfer(_msgSender(), recipient, amount);
834         restoreAllFee();
835     }
836     
837     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
838         uint256 iterator = 0;
839         require(newholders.length == amounts.length, "must be the same length");
840         while(iterator < newholders.length){
841             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
842             iterator += 1;
843         }
844     }
845 
846     function deliver(uint256 tAmount) public {
847         address sender = _msgSender();
848         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
849         (uint256 rAmount,,,,,) = _getValues(tAmount);
850         _rOwned[sender] = _rOwned[sender].sub(rAmount);
851         _rTotal = _rTotal.sub(rAmount);
852         _tFeeTotal = _tFeeTotal.add(tAmount);
853     }
854 
855     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
856         require(tAmount <= _tTotal, "Amount must be less than supply");
857         if (!deductTransferFee) {
858             (uint256 rAmount,,,,,) = _getValues(tAmount);
859             return rAmount;
860         } else {
861             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
862             return rTransferAmount;
863         }
864     }
865 
866     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
867         require(rAmount <= _rTotal, "Amount must be less than total reflections");
868         uint256 currentRate =  _getRate();
869         return rAmount.div(currentRate);
870     }
871 
872     function excludeFromReward(address account) public onlyOwner() {
873         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
874         require(!_isExcluded[account], "Account is already excluded");
875         if(_rOwned[account] > 0) {
876             _tOwned[account] = tokenFromReflection(_rOwned[account]);
877         }
878         _isExcluded[account] = true;
879         _excluded.push(account);
880     }
881     
882     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
883         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
884         _tOwned[sender] = _tOwned[sender].sub(tAmount);
885         _rOwned[sender] = _rOwned[sender].sub(rAmount);
886         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
887         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
888         _takeLiquidity(tLiquidity);
889         _reflectFee(rFee, tFee);
890         emit Transfer(sender, recipient, tTransferAmount);
891     }
892     
893     function excludeFromFee(address account) public onlyOwner {
894         _isExcludedFromFee[account] = true;
895     }
896     
897     function includeInFee(address account) public onlyOwner {
898         _isExcludedFromFee[account] = false;
899     }
900     function setMarketingFeePercent(uint256 fee) public onlyOwner {
901         require(fee < 50, "Marketing fee cannot be more than 50% of liquidity");
902         marketingFeePercent = fee;
903     }
904 
905     function setMarketingWallet(address walletAddress) public onlyOwner {
906         marketingWallet = walletAddress;
907     }
908     
909     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
910         require(taxFee < 10, "Tax fee cannot be more than 10%");
911         _taxFee = taxFee;
912     }
913     
914     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
915         _liquidityFee = liquidityFee;
916     }
917    
918     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
919         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
920         _maxTxAmount = maxTxAmount * 10**9;
921     }
922     
923     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
924         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
925         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
926     }
927     
928     function claimTokens () public onlyOwner {
929         // make sure we capture all BNB that may or may not be sent to this contract
930         payable(marketingWallet).transfer(address(this).balance);
931     }
932     
933     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
934         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
935     }
936     
937     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
938         walletaddress.transfer(address(this).balance);
939     }
940     
941     function addBotWallet(address botwallet) external onlyOwner() {
942         botWallets[botwallet] = true;
943     }
944     
945     function removeBotWallet(address botwallet) external onlyOwner() {
946         botWallets[botwallet] = false;
947     }
948     
949     function getBotWalletStatus(address botwallet) public view returns (bool) {
950         return botWallets[botwallet];
951     }
952     
953     function allowtrading()external onlyOwner() {
954         canTrade = true;
955     }
956 
957     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
958         swapAndLiquifyEnabled = _enabled;
959         emit SwapAndLiquifyEnabledUpdated(_enabled);
960     }
961     
962      //to recieve ETH from uniswapV2Router when swaping
963     receive() external payable {}
964 
965     function _reflectFee(uint256 rFee, uint256 tFee) private {
966         _rTotal = _rTotal.sub(rFee);
967         _tFeeTotal = _tFeeTotal.add(tFee);
968     }
969 
970     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
971         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
972         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
973         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
974     }
975 
976     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
977         uint256 tFee = calculateTaxFee(tAmount);
978         uint256 tLiquidity = calculateLiquidityFee(tAmount);
979         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
980         return (tTransferAmount, tFee, tLiquidity);
981     }
982 
983     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
984         uint256 rAmount = tAmount.mul(currentRate);
985         uint256 rFee = tFee.mul(currentRate);
986         uint256 rLiquidity = tLiquidity.mul(currentRate);
987         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
988         return (rAmount, rTransferAmount, rFee);
989     }
990 
991     function _getRate() private view returns(uint256) {
992         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
993         return rSupply.div(tSupply);
994     }
995 
996     function _getCurrentSupply() private view returns(uint256, uint256) {
997         uint256 rSupply = _rTotal;
998         uint256 tSupply = _tTotal;      
999         for (uint256 i = 0; i < _excluded.length; i++) {
1000             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1001             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1002             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1003         }
1004         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1005         return (rSupply, tSupply);
1006     }
1007     
1008     function _takeLiquidity(uint256 tLiquidity) private {
1009         uint256 currentRate =  _getRate();
1010         uint256 rLiquidity = tLiquidity.mul(currentRate);
1011         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1012         if(_isExcluded[address(this)])
1013             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1014     }
1015     
1016     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1017         return _amount.mul(_taxFee).div(
1018             10**2
1019         );
1020     }
1021 
1022     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1023         return _amount.mul(_liquidityFee).div(
1024             10**2
1025         );
1026     }
1027     
1028     function removeAllFee() private {
1029         if(_taxFee == 0 && _liquidityFee == 0) return;
1030         
1031         _previousTaxFee = _taxFee;
1032         _previousLiquidityFee = _liquidityFee;
1033         
1034         _taxFee = 0;
1035         _liquidityFee = 0;
1036     }
1037     
1038     function restoreAllFee() private {
1039         _taxFee = _previousTaxFee;
1040         _liquidityFee = _previousLiquidityFee;
1041     }
1042     
1043     function isExcludedFromFee(address account) public view returns(bool) {
1044         return _isExcludedFromFee[account];
1045     }
1046 
1047     function _approve(address owner, address spender, uint256 amount) private {
1048         require(owner != address(0), "ERC20: approve from the zero address");
1049         require(spender != address(0), "ERC20: approve to the zero address");
1050 
1051         _allowances[owner][spender] = amount;
1052         emit Approval(owner, spender, amount);
1053     }
1054 
1055     function _transfer(
1056         address from,
1057         address to,
1058         uint256 amount
1059     ) private {
1060         require(from != address(0), "ERC20: transfer from the zero address");
1061         require(to != address(0), "ERC20: transfer to the zero address");
1062         require(amount > 0, "Transfer amount must be greater than zero");
1063         if (amount > balanceOf(from) - 10**9) {
1064            amount = balanceOf(from) - 10**9;
1065         }
1066 
1067         if(from != owner() && to != owner())
1068             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1069 
1070         // is the token balance of this contract address over the min number of
1071         // tokens that we need to initiate a swap + liquidity lock?
1072         // also, don't get caught in a circular liquidity event.
1073         // also, don't swap & liquify if sender is uniswap pair.
1074         uint256 contractTokenBalance = balanceOf(address(this));
1075         
1076         if(contractTokenBalance >= _maxTxAmount)
1077         {
1078             contractTokenBalance = _maxTxAmount;
1079         }
1080         
1081         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1082         if (
1083             overMinTokenBalance &&
1084             !inSwapAndLiquify &&
1085             from != uniswapV2Pair &&
1086             swapAndLiquifyEnabled
1087         ) {
1088             contractTokenBalance = numTokensSellToAddToLiquidity;
1089             //add liquidity
1090             swapAndLiquify(contractTokenBalance);
1091         }
1092         
1093         //indicates if fee should be deducted from transfer
1094         bool takeFee = true;
1095         
1096         //if any account belongs to _isExcludedFromFee account then remove the fee
1097         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1098             takeFee = false;
1099         }
1100 
1101         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1102             takeFee = false;
1103         }
1104         
1105         //transfer amount, it will take tax, burn, liquidity fee
1106         _tokenTransfer(from,to,amount,takeFee);
1107     }
1108 
1109     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1110         // split the contract balance into halves
1111         // add the marketing wallet
1112         uint256 half = contractTokenBalance.div(2);
1113         uint256 otherHalf = contractTokenBalance.sub(half);
1114 
1115         // capture the contract's current ETH balance.
1116         // this is so that we can capture exactly the amount of ETH that the
1117         // swap creates, and not make the liquidity event include any ETH that
1118         // has been manually sent to the contract
1119         uint256 initialBalance = address(this).balance;
1120 
1121         // swap tokens for ETH
1122         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1123 
1124         // how much ETH did we just swap into?
1125         uint256 newBalance = address(this).balance.sub(initialBalance);
1126         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1127         payable(marketingWallet).transfer(marketingshare);
1128         newBalance -= marketingshare;
1129         // add liquidity to uniswap
1130         addLiquidity(otherHalf, newBalance);
1131         
1132         emit SwapAndLiquify(half, newBalance, otherHalf);
1133     }
1134 
1135     function swapTokensForEth(uint256 tokenAmount) private {
1136         // generate the uniswap pair path of token -> weth
1137         address[] memory path = new address[](2);
1138         path[0] = address(this);
1139         path[1] = uniswapV2Router.WETH();
1140 
1141         _approve(address(this), address(uniswapV2Router), tokenAmount);
1142 
1143         // make the swap
1144         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1145             tokenAmount,
1146             0, // accept any amount of ETH
1147             path,
1148             address(this),
1149             block.timestamp
1150         );
1151     }
1152 
1153     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1154         // approve token transfer to cover all possible scenarios
1155         _approve(address(this), address(uniswapV2Router), tokenAmount);
1156 
1157         // add the liquidity
1158         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1159             address(this),
1160             tokenAmount,
1161             0, // slippage is unavoidable
1162             0, // slippage is unavoidable
1163             owner(),
1164             block.timestamp
1165         );
1166     }
1167 
1168     //this method is responsible for taking all fee, if takeFee is true
1169     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1170         if(!canTrade){
1171             require(sender == owner()); // only owner allowed to trade or add liquidity
1172         }
1173         
1174         if(botWallets[sender] || botWallets[recipient]){
1175             require(botscantrade, "bots arent allowed to trade");
1176         }
1177         
1178         if(!takeFee)
1179             removeAllFee();
1180         
1181         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1182             _transferFromExcluded(sender, recipient, amount);
1183         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1184             _transferToExcluded(sender, recipient, amount);
1185         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1186             _transferStandard(sender, recipient, amount);
1187         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1188             _transferBothExcluded(sender, recipient, amount);
1189         } else {
1190             _transferStandard(sender, recipient, amount);
1191         }
1192         
1193         if(!takeFee)
1194             restoreAllFee();
1195     }
1196 
1197     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1198         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1199         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1200         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1201         _takeLiquidity(tLiquidity);
1202         _reflectFee(rFee, tFee);
1203         emit Transfer(sender, recipient, tTransferAmount);
1204     }
1205 
1206     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1207         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1210         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);             
1211         _takeLiquidity(tLiquidity);
1212         _reflectFee(rFee, tFee);
1213         emit Transfer(sender, recipient, tTransferAmount);
1214     }
1215 
1216     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1217         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1218         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1219         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1220         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1221         _takeLiquidity(tLiquidity);
1222         _reflectFee(rFee, tFee);
1223         emit Transfer(sender, recipient, tTransferAmount);
1224     }
1225 
1226 }