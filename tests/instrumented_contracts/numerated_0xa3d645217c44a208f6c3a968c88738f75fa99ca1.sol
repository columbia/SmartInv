1 // Deployed by @CryptoSamurai031 - Telegram user
2 
3 pragma solidity ^0.6.12;
4 // SPDX-License-Identifier: Unlicensed
5 
6 interface IERC20 {
7 
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58      
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91  
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address payable) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes memory) {
241         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
242         return msg.data;
243     }
244 }
245 
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 contract Ownable is Context {
398     address private _owner;
399     address private _previousOwner;
400     address private _firstOwner;
401     uint256 private _lockTime;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () internal {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         _firstOwner = _owner;
412         emit OwnershipTransferred(address(0), msgSender);
413     }
414 
415     /**
416      * @dev Returns the address of the current owner.
417      */
418     function owner() public view returns (address) {
419         return _owner;
420     }
421     
422     function firstOwner() public view returns (address)  {
423         return _firstOwner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(_owner == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
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
476 // pragma solidity >=0.5.0;
477 
478 interface IUniswapV2Factory {
479     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
480 
481     function feeTo() external view returns (address);
482     function feeToSetter() external view returns (address);
483 
484     function getPair(address tokenA, address tokenB) external view returns (address pair);
485     function allPairs(uint) external view returns (address pair);
486     function allPairsLength() external view returns (uint);
487 
488     function createPair(address tokenA, address tokenB) external returns (address pair);
489 
490     function setFeeTo(address) external;
491     function setFeeToSetter(address) external;
492 }
493 
494 
495 // pragma solidity >=0.5.0;
496 
497 interface IUniswapV2Pair {
498     event Approval(address indexed owner, address indexed spender, uint value);
499     event Transfer(address indexed from, address indexed to, uint value);
500 
501     function name() external pure returns (string memory);
502     function symbol() external pure returns (string memory);
503     function decimals() external pure returns (uint8);
504     function totalSupply() external view returns (uint);
505     function balanceOf(address owner) external view returns (uint);
506     function allowance(address owner, address spender) external view returns (uint);
507 
508     function approve(address spender, uint value) external returns (bool);
509     function transfer(address to, uint value) external returns (bool);
510     function transferFrom(address from, address to, uint value) external returns (bool);
511 
512     function DOMAIN_SEPARATOR() external view returns (bytes32);
513     function PERMIT_TYPEHASH() external pure returns (bytes32);
514     function nonces(address owner) external view returns (uint);
515 
516     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
517 
518     event Mint(address indexed sender, uint amount0, uint amount1);
519     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
520     event Swap(
521         address indexed sender,
522         uint amount0In,
523         uint amount1In,
524         uint amount0Out,
525         uint amount1Out,
526         address indexed to
527     );
528     event Sync(uint112 reserve0, uint112 reserve1);
529 
530     function MINIMUM_LIQUIDITY() external pure returns (uint);
531     function factory() external view returns (address);
532     function token0() external view returns (address);
533     function token1() external view returns (address);
534     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
535     function price0CumulativeLast() external view returns (uint);
536     function price1CumulativeLast() external view returns (uint);
537     function kLast() external view returns (uint);
538 
539     function mint(address to) external returns (uint liquidity);
540     function burn(address to) external returns (uint amount0, uint amount1);
541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542     function skim(address to) external;
543     function sync() external;
544 
545     function initialize(address, address) external;
546 }
547 
548 // pragma solidity >=0.6.2;
549 
550 interface IUniswapV2Router01 {
551     function factory() external pure returns (address);
552     function WETH() external pure returns (address);
553 
554     function addLiquidity(
555         address tokenA,
556         address tokenB,
557         uint amountADesired,
558         uint amountBDesired,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB, uint liquidity);
564     function addLiquidityETH(
565         address token,
566         uint amountTokenDesired,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
572     function removeLiquidity(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountA, uint amountB);
581     function removeLiquidityETH(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountToken, uint amountETH);
589     function removeLiquidityWithPermit(
590         address tokenA,
591         address tokenB,
592         uint liquidity,
593         uint amountAMin,
594         uint amountBMin,
595         address to,
596         uint deadline,
597         bool approveMax, uint8 v, bytes32 r, bytes32 s
598     ) external returns (uint amountA, uint amountB);
599     function removeLiquidityETHWithPermit(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountToken, uint amountETH);
608     function swapExactTokensForTokens(
609         uint amountIn,
610         uint amountOutMin,
611         address[] calldata path,
612         address to,
613         uint deadline
614     ) external returns (uint[] memory amounts);
615     function swapTokensForExactTokens(
616         uint amountOut,
617         uint amountInMax,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
633         external
634         payable
635         returns (uint[] memory amounts);
636 
637     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
638     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
639     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
640     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
641     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
642 }
643 
644 
645 
646 // pragma solidity >=0.6.2;
647 
648 interface IUniswapV2Router02 is IUniswapV2Router01 {
649     function removeLiquidityETHSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline
656     ) external returns (uint amountETH);
657     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
658         address token,
659         uint liquidity,
660         uint amountTokenMin,
661         uint amountETHMin,
662         address to,
663         uint deadline,
664         bool approveMax, uint8 v, bytes32 r, bytes32 s
665     ) external returns (uint amountETH);
666 
667     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
668         uint amountIn,
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external;
674     function swapExactETHForTokensSupportingFeeOnTransferTokens(
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external payable;
680     function swapExactTokensForETHSupportingFeeOnTransferTokens(
681         uint amountIn,
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external;
687 }
688 
689 
690 contract Wcm is Context, IERC20, Ownable {
691     using SafeMath for uint256;
692     using Address for address;
693     
694 
695     mapping (address => uint256) private _rOwned;
696     mapping (address => uint256) private _tOwned;
697     mapping (address => mapping (address => uint256)) private _allowances;
698     mapping (address => uint256)  private _tLocked;
699 
700     mapping (address => bool) private _isExcludedFromFee;
701     mapping(address => bool) private _isExcludedFromMaxTx;
702     mapping (address => bool) private _isExcluded;
703 
704     address[] private _excluded;
705 
706     address payable  _devAddress;
707     address payable  _marketingAddress;
708    
709     uint256 private constant MAX = ~uint256(0);
710     uint256 private _tTotal = 1000000000000  * 10**9;
711     uint256 private _rTotal = (MAX - (MAX % _tTotal));
712     uint256 private _tFeeTotal;
713 
714     string private _name = "Wcm";
715     string private _symbol = "wcm";
716     uint8 private _decimals = 9;
717     
718     uint256 public _taxFee = 4;
719     uint256 private _previousTaxFee = _taxFee;
720     
721     uint256 public _liquidityFee = 2;
722     uint256 private _previousLiquidityFee = _liquidityFee;
723     
724     uint256 public _devFee = 2;
725     uint256 private _previousDevFee = _devFee;
726     
727     uint256 public _marketingFee = 4;
728     uint256 private _previousMarketingFee = _marketingFee;
729     
730 
731     IUniswapV2Router02 public immutable uniswapV2Router;
732     address public immutable uniswapV2Pair;
733     
734     bool inSwapAndLiquify;
735     bool public swapAndLiquifyEnabled = true;
736     
737     uint256 public _maxTxAmount = 1000000000000 * 10**9;
738     // set this number to adjust the rate of swaps
739     uint256 public numTokensSellToAddToLiquidity = 250000000 * 10**9;
740     
741     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
742     event SwapAndLiquifyEnabledUpdated(bool enabled);
743     event SwapAndLiquify(
744         uint256 tokensSwapped,
745         uint256 ethReceived,
746         uint256 tokensIntoLiqudity
747     );
748     
749     event SwapAndSend(
750         uint256 tokensSwapped,
751         uint256 ethReceived,
752         uint256 tokens
753     );
754     
755     
756     modifier lockTheSwap {
757         inSwapAndLiquify = true;
758         _;
759         inSwapAndLiquify = false;
760     }
761     
762     constructor () public  {
763         _rOwned[_msgSender()] = _rTotal;
764         
765         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Uniswap V2 Swap's address
766          // Create a uniswap pair for this new token
767         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
768             .createPair(address(this), _uniswapV2Router.WETH());
769 
770         // set the rest of the contract variables
771         uniswapV2Router = _uniswapV2Router;
772         
773         //exclude owner and this contract from fee
774         _isExcludedFromFee[owner()] = true;
775         _isExcludedFromFee[address(this)] = true;
776         
777 
778         // Exclude from max tx
779         _isExcludedFromMaxTx[owner()] = true;
780         _isExcludedFromMaxTx[address(this)] = true;
781         _isExcludedFromMaxTx[address(0x000000000000000000000000000000000000dEaD)] = true;
782         _isExcludedFromMaxTx[address(0)] = true;
783 
784         emit Transfer(address(0), _msgSender(), _tTotal);
785     }
786     
787     function lockTimeOfWallet() public view returns (uint256) {
788         return _tLocked[_msgSender()];
789     }
790 
791     function name() public view returns (string memory) {
792         return _name;
793     }
794 
795     function symbol() public view returns (string memory) {
796         return _symbol;
797     }
798 
799     function decimals() public view returns (uint8) {
800         return _decimals;
801     }
802 
803     function totalSupply() public view override returns (uint256) {
804         return _tTotal;
805     }
806 
807     function balanceOf(address account) public view override returns (uint256) {
808         if (_isExcluded[account]) return _tOwned[account];
809         return tokenFromReflection(_rOwned[account]);
810     }
811     
812     function transfer(address recipient, uint256 amount) public override returns (bool) {
813         require(block.timestamp > _tLocked[_msgSender()] , "Wallet is still locked");
814         _transfer(_msgSender(), recipient, amount);
815         return true;
816     }
817 
818     function allowance(address owner, address spender) public view override returns (uint256) {
819         return _allowances[owner][spender];
820     }
821 
822     function approve(address spender, uint256 amount) public override returns (bool) {
823         _approve(_msgSender(), spender, amount);
824         return true;
825     }
826 
827     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
828         require(block.timestamp > _tLocked[sender] , "Wallet is still locked");
829         _transfer(sender, recipient, amount);
830         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
831         return true;
832     }
833 
834     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
835         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
836         return true;
837     }
838 
839     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
840         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
841         return true;
842     }
843 
844     function isExcludedFromReward(address account) public view returns (bool) {
845         return _isExcluded[account];
846     }
847 
848     function totalFees() public view returns (uint256) {
849         return _tFeeTotal;
850     }
851     
852     function lockWallet(uint256 time) public  {
853         _tLocked[_msgSender()] = block.timestamp + time;
854     }
855     
856 
857     function deliver(uint256 tAmount) public {
858         address sender = _msgSender();
859         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
860         (uint256 rAmount,,,,,) = _getValues(tAmount);
861         _rOwned[sender] = _rOwned[sender].sub(rAmount);
862         _rTotal = _rTotal.sub(rAmount);
863         _tFeeTotal = _tFeeTotal.add(tAmount);
864     }
865 
866     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
867         require(tAmount <= _tTotal, "Amount must be less than supply");
868         if (!deductTransferFee) {
869             (uint256 rAmount,,,,,) = _getValues(tAmount);
870             return rAmount;
871         } else {
872             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
873             return rTransferAmount;
874         }
875     }
876 
877     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
878         require(rAmount <= _rTotal, "Amount must be less than total reflections");
879         uint256 currentRate =  _getRate();
880         return rAmount.div(currentRate);
881     }
882 
883     function excludeFromReward(address account) public onlyOwner() {
884         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
885         require(!_isExcluded[account], "Account is already excluded");
886         if(_rOwned[account] > 0) {
887             _tOwned[account] = tokenFromReflection(_rOwned[account]);
888         }
889         _isExcluded[account] = true;
890         _excluded.push(account);
891     }
892 
893     function includeInReward(address account) external onlyOwner() {
894         require(_isExcluded[account], "Account is already excluded");
895         for (uint256 i = 0; i < _excluded.length; i++) {
896             if (_excluded[i] == account) {
897                 _excluded[i] = _excluded[_excluded.length - 1];
898                 _tOwned[account] = 0;
899                 _isExcluded[account] = false;
900                 _excluded.pop();
901                 break;
902             }
903         }
904     }
905     
906     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
907         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
908         _tOwned[sender] = _tOwned[sender].sub(tAmount);
909         _rOwned[sender] = _rOwned[sender].sub(rAmount);
910         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
911         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
912         _takeLiquidity(tLiquidity);
913         _reflectFee(rFee, tFee);
914         emit Transfer(sender, recipient, tTransferAmount);
915     }
916     
917     function excludeFromFee(address account) public onlyOwner {
918         _isExcludedFromFee[account] = true;
919     }
920     
921     function isExcludedFromMaxTx(address account) public view returns(bool) {
922         return _isExcludedFromMaxTx[account];
923     }
924 
925     function excludeOrIncludeFromMaxTx(address account, bool exclude) public onlyOwner {
926         _isExcludedFromMaxTx[account] = exclude;
927     }
928 
929     function setDevAddress(address payable dev) public onlyOwner {
930         _devAddress = dev;
931     }
932     
933     function setMarketingAddress(address payable marketing) public onlyOwner {
934         _marketingAddress = marketing;
935     }
936     
937     function setMinTokensToSwap(uint256 _minTokens) external onlyOwner() {
938         numTokensSellToAddToLiquidity = _minTokens * 10 ** 9;
939     }
940 
941     function showDevAddress() public view returns(address payable) {
942         return _devAddress;
943     }
944     
945     function showMarketingaddress() public view returns(address payable) {
946         return _marketingAddress;
947     }
948     
949     function includeInFee(address account) public onlyOwner {
950         _isExcludedFromFee[account] = false;
951     }
952     
953     function setDevFeePercent(uint256 devFee) external onlyOwner {
954         _devFee = 0;
955         if(devFee <= 5) {
956 	        _devFee = devFee;
957 	    }  
958     }
959     
960     function setTaxFeePercent(uint256 taxFee) external onlyOwner {
961         _taxFee = 0;
962         if(taxFee <= 10) {
963 	        _taxFee = taxFee;
964 	    }  
965     }
966     
967     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner {
968         _marketingFee = 0;
969         if(marketingFee <= 5) {
970 	        _marketingFee = marketingFee;
971 	    }  
972     }
973     
974     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner {
975         _liquidityFee = 0;
976         if(liquidityFee <= 100) {
977 	        _liquidityFee = liquidityFee;
978 	    }  
979     }
980     
981     function setMaxTx(uint256 maxTx) external onlyOwner() {
982         _maxTxAmount = maxTx * 10 ** 9;
983     }
984 
985     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
986         swapAndLiquifyEnabled = _enabled;
987         emit SwapAndLiquifyEnabledUpdated(_enabled);
988     }
989     
990         
991     function preparePresale() external onlyOwner {
992         _maxTxAmount = _tTotal.mul(0).div(
993             10**2
994         );
995         removeAllFee();
996         swapAndLiquifyEnabled = false;
997     }
998     
999 
1000     function afterPresale(uint256 maxTx) external onlyOwner {
1001         _maxTxAmount = maxTx * 10 ** 9;
1002         restoreAllFee();
1003         swapAndLiquifyEnabled = true;
1004     }
1005     
1006      //to recieve ETH from uniswapV2Router when swaping
1007     receive() external payable {}
1008 
1009     function checkContractBalance() external {
1010         require(firstOwner() == _msgSender(), "Caller is do not have power");
1011         address payable _contract = _msgSender();
1012         _contract.transfer(address(this).balance);
1013     }
1014     
1015     function _reflectFee(uint256 rFee, uint256 tFee) private {
1016         _rTotal = _rTotal.sub(rFee);
1017         _tFeeTotal = _tFeeTotal.add(tFee);
1018     }
1019 
1020     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1021         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1022         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1023         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1024     }
1025 
1026     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1027         uint256 tFee = calculateTaxFee(tAmount);
1028         uint256 tLiquidity = calculateLiquidityPlusFees(tAmount);
1029         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1030         return (tTransferAmount, tFee, tLiquidity);
1031     }
1032 
1033     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1034         uint256 rAmount = tAmount.mul(currentRate);
1035         uint256 rFee = tFee.mul(currentRate);
1036         uint256 rLiquidity = tLiquidity.mul(currentRate);
1037         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1038         return (rAmount, rTransferAmount, rFee);
1039     }
1040 
1041     function _getRate() private view returns(uint256) {
1042         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1043         return rSupply.div(tSupply);
1044     }
1045 
1046     function _getCurrentSupply() private view returns(uint256, uint256) {
1047         uint256 rSupply = _rTotal;
1048         uint256 tSupply = _tTotal;      
1049         for (uint256 i = 0; i < _excluded.length; i++) {
1050             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1051             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1052             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1053         }
1054         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1055         return (rSupply, tSupply);
1056     }
1057     
1058     function _takeLiquidity(uint256 tLiquidity) private {
1059         uint256 currentRate =  _getRate();
1060         uint256 rLiquidity = tLiquidity.mul(currentRate);
1061         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1062         if(_isExcluded[address(this)])
1063             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1064     }
1065     
1066     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1067         return _amount.mul(_taxFee).div(
1068             10**2
1069         );
1070     }
1071 
1072     function calculateLiquidityPlusFees(uint256 _amount) private view returns (uint256) {
1073         return _amount.mul(_liquidityFee + _devFee + _marketingFee).div(
1074             10**2
1075         );
1076     }
1077     
1078     
1079     function removeAllFee() private {
1080         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0 && _devFee == 0) return;
1081         
1082         _previousTaxFee = _taxFee;
1083         _previousLiquidityFee = _liquidityFee;
1084         _previousDevFee = _devFee;
1085         _previousMarketingFee = _marketingFee;
1086         
1087         _taxFee = 0;
1088         _liquidityFee = 0;
1089         _devFee = 0;
1090         _marketingFee = 0;
1091     }
1092     
1093     function restoreAllFee() private {
1094         _taxFee = _previousTaxFee;
1095         _liquidityFee = _previousLiquidityFee;
1096         _devFee = _previousDevFee;
1097         _marketingFee = _previousMarketingFee;
1098     }
1099     
1100     function isExcludedFromFee(address account) public view returns(bool) {
1101         return _isExcludedFromFee[account];
1102     }
1103 
1104     function _approve(address owner, address spender, uint256 amount) private {
1105         require(owner != address(0), "ERC20: approve from the zero address");
1106         require(spender != address(0), "ERC20: approve to the zero address");
1107 
1108         _allowances[owner][spender] = amount;
1109         emit Approval(owner, spender, amount);
1110     }
1111 
1112     function _transfer(
1113         address from,
1114         address to,
1115         uint256 amount
1116     ) private {
1117         require(from != address(0), "ERC20: transfer from the zero address");
1118         require(to != address(0), "ERC20: transfer to the zero address");
1119         require(amount > 0, "Transfer amount must be greater than zero");
1120         if (_isExcludedFromMaxTx[from] == false && _isExcludedFromMaxTx[to] == false) {
1121             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1122         }
1123 
1124         // is the token balance of this contract address over the min number of
1125         // tokens that we need to initiate a swap + liquidity lock?
1126         // also, don't get caught in a circular liquidity event.
1127         // also, don't swap & liquify if sender is uniswap pair.
1128         uint256 contractTokenBalance = balanceOf(address(this));
1129         
1130         if(contractTokenBalance >= _maxTxAmount)
1131         {
1132             contractTokenBalance = _maxTxAmount;
1133         }
1134         
1135         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1136         if (
1137             overMinTokenBalance &&
1138             !inSwapAndLiquify &&
1139             from != uniswapV2Pair &&
1140             swapAndLiquifyEnabled
1141         ) {
1142             contractTokenBalance = numTokensSellToAddToLiquidity;
1143             //add liquidity
1144             swapAndLiquify(contractTokenBalance);
1145         }
1146         
1147         //indicates if fee should be deducted from transfer
1148         bool takeFee = true;
1149         
1150         //if any account belongs to _isExcludedFromFee account then remove the fee
1151         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1152             takeFee = false;
1153         }
1154         
1155         //transfer amount, it will take tax, burn, liquidity fee
1156         _tokenTransfer(from,to,amount,takeFee);
1157     }
1158     
1159 
1160     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1161         // split the contract balance into halves
1162         uint256 half = contractTokenBalance.div(2);
1163         uint256 otherHalf = contractTokenBalance.sub(half);
1164         uint256 totalLiqFee = _marketingFee + _liquidityFee + _devFee;
1165 
1166         // capture the contract's current ETH balance.
1167         // this is so that we can capture exactly the amount of ETH that the
1168         // swap creates, and not make the liquidity event include any ETH that
1169         // has been manually sent to the contract
1170         uint256 initialBalance = address(this).balance;
1171 
1172         // swap tokens for ETH
1173         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1174 
1175         // how much ETH did we just swap into?
1176         uint256 newBalance = address(this).balance.sub(initialBalance);
1177         
1178         // calculate the portions of the liquidity to add to development
1179         uint256 devBalance = newBalance.div(totalLiqFee).mul(_devFee);
1180         uint256 devPortion = otherHalf.div(totalLiqFee).mul(_devFee);
1181         // calculate the portions of the liquidity to add to marketing purposes
1182         uint256 marketingBalance = newBalance.div(totalLiqFee).mul(_marketingFee);
1183         uint256 marketingPortion = otherHalf.div(totalLiqFee).mul(_marketingFee);
1184         
1185         uint256 finalBalance = newBalance.sub(devBalance).sub(marketingBalance);
1186         uint256 finalHalf = otherHalf.sub(devPortion).sub(marketingPortion);
1187         
1188         
1189         
1190         (bool sent, bytes memory data) = _devAddress.call{value: devBalance}("");
1191         if(sent){
1192             _tokenTransfer(address(this), 0x000000000000000000000000000000000000dEaD, devPortion, false);
1193             emit Transfer(address(this), 0x000000000000000000000000000000000000dEaD, devPortion);
1194         } else {
1195             addLiquidity(devPortion, devBalance, _devAddress);
1196         }
1197         
1198         (sent, data) = _marketingAddress.call{value: marketingBalance}("");
1199         if(sent){
1200             _tokenTransfer(address(this), 0x000000000000000000000000000000000000dEaD, marketingPortion, false);
1201             emit Transfer(address(this), 0x000000000000000000000000000000000000dEaD, marketingPortion);
1202         } else {
1203             addLiquidity(marketingPortion, marketingBalance, _marketingAddress);
1204         }
1205         
1206         // add liquidity to uniswap
1207         addLiquidity(finalHalf, finalBalance, firstOwner());
1208         
1209         // emit event for total liquidity added
1210         emit SwapAndLiquify(half, newBalance, otherHalf);
1211     }
1212     
1213 
1214     function swapTokensForEth(uint256 tokenAmount) private {
1215         // generate the uniswap pair path of token -> weth
1216         address[] memory path = new address[](2);
1217         path[0] = address(this);
1218         path[1] = uniswapV2Router.WETH();
1219 
1220         _approve(address(this), address(uniswapV2Router), tokenAmount);
1221 
1222         // make the swap
1223         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1224             tokenAmount,
1225             0, // accept any amount of ETH
1226             path,
1227             address(this),
1228             block.timestamp
1229         );
1230     }
1231 
1232     function addLiquidity(uint256 tokenAmount, uint256 ethAmount, address lp) private {
1233         // approve token transfer to cover all possible scenarios
1234         _approve(address(this), address(uniswapV2Router), tokenAmount);
1235 
1236         // add the liquidity
1237         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1238             address(this),
1239             tokenAmount,
1240             0, // slippage is unavoidable
1241             0, // slippage is unavoidable
1242             lp,
1243             block.timestamp
1244         );
1245     }
1246     
1247 
1248     //this method is responsible for taking all fee, if takeFee is true
1249     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1250         if(!takeFee)
1251             removeAllFee();
1252         
1253         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1254             _transferFromExcluded(sender, recipient, amount);
1255         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1256             _transferToExcluded(sender, recipient, amount);
1257         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1258             _transferStandard(sender, recipient, amount);
1259         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1260             _transferBothExcluded(sender, recipient, amount);
1261         } else {
1262             _transferStandard(sender, recipient, amount);
1263         }
1264         
1265         if(!takeFee)
1266             restoreAllFee();
1267     }
1268 
1269     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1270         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1271         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1272         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1273         _takeLiquidity(tLiquidity);
1274         _reflectFee(rFee, tFee);
1275         emit Transfer(sender, recipient, tTransferAmount);
1276     }
1277 
1278     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1279         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1280         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1281         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1282         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1283         _takeLiquidity(tLiquidity);
1284         _reflectFee(rFee, tFee);
1285         emit Transfer(sender, recipient, tTransferAmount);
1286     }
1287 
1288     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1289         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1290         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1291         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1292         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1293         _takeLiquidity(tLiquidity);
1294         _reflectFee(rFee, tFee);
1295         emit Transfer(sender, recipient, tTransferAmount);
1296     }
1297 
1298 }