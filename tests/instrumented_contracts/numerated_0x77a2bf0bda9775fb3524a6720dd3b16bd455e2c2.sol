1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-31
3 */
4 
5 pragma solidity ^0.6.12;
6 // SPDX-License-Identifier: Unlicensed
7 interface IERC20 {
8 
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
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
400     uint256 private _lockTime;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405      * @dev Initializes the contract setting the deployer as the initial owner.
406      */
407     constructor () internal {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414      * @dev Returns the address of the current owner.
415      */
416     function owner() public view returns (address) {
417         return _owner;
418     }
419 
420     /**
421      * @dev Throws if called by any account other than the owner.
422      */
423     modifier onlyOwner() {
424         require(_owner == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428      /**
429      * @dev Leaves the contract without owner. It will not be possible to call
430      * `onlyOwner` functions anymore. Can only be called by the current owner.
431      *
432      * NOTE: Renouncing ownership will leave the contract without an owner,
433      * thereby removing any functionality that is only available to the owner.
434      */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441      * @dev Transfers ownership of the contract to a new account (`newOwner`).
442      * Can only be called by the current owner.
443      */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 
450     function geUnlockTime() public view returns (uint256) {
451         return _lockTime;
452     }
453 
454     //Locks the contract for owner for the amount of time provided
455     function lock(uint256 time) public virtual onlyOwner {
456         _previousOwner = _owner;
457         _owner = address(0);
458         _lockTime = now + time;
459         emit OwnershipTransferred(_owner, address(0));
460     }
461     
462     //Unlocks the contract for owner when _lockTime is exceeds
463     function unlock() public virtual {
464         require(_previousOwner == msg.sender, "You don't have permission to unlock");
465         require(now > _lockTime , "Contract is locked until 7 days");
466         emit OwnershipTransferred(_owner, _previousOwner);
467         _owner = _previousOwner;
468     }
469 }
470 
471 // pragma solidity >=0.5.0;
472 
473 interface IUniswapV2Factory {
474     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
475 
476     function feeTo() external view returns (address);
477     function feeToSetter() external view returns (address);
478 
479     function getPair(address tokenA, address tokenB) external view returns (address pair);
480     function allPairs(uint) external view returns (address pair);
481     function allPairsLength() external view returns (uint);
482 
483     function createPair(address tokenA, address tokenB) external returns (address pair);
484 
485     function setFeeTo(address) external;
486     function setFeeToSetter(address) external;
487 }
488 
489 
490 // pragma solidity >=0.5.0;
491 
492 interface IUniswapV2Pair {
493     event Approval(address indexed owner, address indexed spender, uint value);
494     event Transfer(address indexed from, address indexed to, uint value);
495 
496     function name() external pure returns (string memory);
497     function symbol() external pure returns (string memory);
498     function decimals() external pure returns (uint8);
499     function totalSupply() external view returns (uint);
500     function balanceOf(address owner) external view returns (uint);
501     function allowance(address owner, address spender) external view returns (uint);
502 
503     function approve(address spender, uint value) external returns (bool);
504     function transfer(address to, uint value) external returns (bool);
505     function transferFrom(address from, address to, uint value) external returns (bool);
506 
507     function DOMAIN_SEPARATOR() external view returns (bytes32);
508     function PERMIT_TYPEHASH() external pure returns (bytes32);
509     function nonces(address owner) external view returns (uint);
510 
511     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
512 
513     event Mint(address indexed sender, uint amount0, uint amount1);
514     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
515     event Swap(
516         address indexed sender,
517         uint amount0In,
518         uint amount1In,
519         uint amount0Out,
520         uint amount1Out,
521         address indexed to
522     );
523     event Sync(uint112 reserve0, uint112 reserve1);
524 
525     function MINIMUM_LIQUIDITY() external pure returns (uint);
526     function factory() external view returns (address);
527     function token0() external view returns (address);
528     function token1() external view returns (address);
529     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
530     function price0CumulativeLast() external view returns (uint);
531     function price1CumulativeLast() external view returns (uint);
532     function kLast() external view returns (uint);
533 
534     function mint(address to) external returns (uint liquidity);
535     function burn(address to) external returns (uint amount0, uint amount1);
536     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
537     function skim(address to) external;
538     function sync() external;
539 
540     function initialize(address, address) external;
541 }
542 
543 // pragma solidity >=0.6.2;
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
641 // pragma solidity >=0.6.2;
642 
643 interface IUniswapV2Router02 is IUniswapV2Router01 {
644     function removeLiquidityETHSupportingFeeOnTransferTokens(
645         address token,
646         uint liquidity,
647         uint amountTokenMin,
648         uint amountETHMin,
649         address to,
650         uint deadline
651     ) external returns (uint amountETH);
652     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
653         address token,
654         uint liquidity,
655         uint amountTokenMin,
656         uint amountETHMin,
657         address to,
658         uint deadline,
659         bool approveMax, uint8 v, bytes32 r, bytes32 s
660     ) external returns (uint amountETH);
661 
662     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
663         uint amountIn,
664         uint amountOutMin,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external;
669     function swapExactETHForTokensSupportingFeeOnTransferTokens(
670         uint amountOutMin,
671         address[] calldata path,
672         address to,
673         uint deadline
674     ) external payable;
675     function swapExactTokensForETHSupportingFeeOnTransferTokens(
676         uint amountIn,
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external;
682 }
683 
684 
685 contract SafeBreast is Context, IERC20, Ownable {
686     using SafeMath for uint256;
687     using Address for address;
688 
689     mapping (address => uint256) private _rOwned;
690     mapping (address => uint256) private _tOwned;
691     mapping (address => mapping (address => uint256)) private _allowances;
692 
693     mapping (address => bool) private _isExcludedFromFee;
694 
695     mapping (address => bool) private _isExcluded;
696     address[] private _excluded;
697    
698     uint256 private constant MAX = ~uint256(0);
699     uint256 private _tTotal = 100000000000 * 10**1 * 10**9;
700     uint256 private _rTotal = (MAX - (MAX % _tTotal));
701     uint256 private _tFeeTotal;
702 
703     string private _name = "SafeBreastInu";
704     string private _symbol = "$BREAST";
705     uint8 private _decimals = 9;
706     
707     uint256 public _taxFee = 2;
708     uint256 private _previousTaxFee = _taxFee;
709     
710     uint256 public _liquidityFee = 4;
711     uint256 private _previousLiquidityFee = _liquidityFee;
712 
713     IUniswapV2Router02 public  uniswapV2Router;
714     address public  uniswapV2Pair;
715     address payable public _charityWalletAddress;
716     
717     bool inSwapAndLiquify;
718     bool public swapAndLiquifyEnabled = true;
719     
720     uint256 public _maxTxAmount = 1000000000 * 10**1 * 10**9;
721     uint256 private numTokensSellToAddToLiquidity = 300000000 * 10**1 * 10**9;
722     
723     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
724     event SwapAndLiquifyEnabledUpdated(bool enabled);
725     event SwapAndLiquify(
726         uint256 tokensSwapped,
727         uint256 ethReceived,
728         uint256 tokensIntoLiqudity
729     );
730     
731     modifier lockTheSwap {
732         inSwapAndLiquify = true;
733         _;
734         inSwapAndLiquify = false;
735     }
736     
737     constructor (address payable charityWalletAddress) public {
738         _charityWalletAddress = charityWalletAddress;
739         _rOwned[_msgSender()] = _rTotal;
740         
741         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
742          // Create a uniswap pair for this new token
743         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
744             .createPair(address(this), _uniswapV2Router.WETH());
745 
746         // set the rest of the contract variables
747         uniswapV2Router = _uniswapV2Router;
748         
749         //exclude owner and this contract from fee
750         _isExcludedFromFee[owner()] = true;
751         _isExcludedFromFee[address(this)] = true;
752         
753         emit Transfer(address(0), _msgSender(), _tTotal);
754     }
755 
756     function name() public view returns (string memory) {
757         return _name;
758     }
759 
760     function symbol() public view returns (string memory) {
761         return _symbol;
762     }
763 
764     function decimals() public view returns (uint8) {
765         return _decimals;
766     }
767 
768     function totalSupply() public view override returns (uint256) {
769         return _tTotal;
770     }
771 
772     function balanceOf(address account) public view override returns (uint256) {
773         if (_isExcluded[account]) return _tOwned[account];
774         return tokenFromReflection(_rOwned[account]);
775     }
776 
777     function transfer(address recipient, uint256 amount) public override returns (bool) {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender) public view override returns (uint256) {
783         return _allowances[owner][spender];
784     }
785 
786     function approve(address spender, uint256 amount) public override returns (bool) {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790 
791     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
792         _transfer(sender, recipient, amount);
793         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
794         return true;
795     }
796 
797     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
798         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
799         return true;
800     }
801 
802     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
803         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
804         return true;
805     }
806 
807     function isExcludedFromReward(address account) public view returns (bool) {
808         return _isExcluded[account];
809     }
810 
811     function totalFees() public view returns (uint256) {
812         return _tFeeTotal;
813     }
814 
815     function deliver(uint256 tAmount) public {
816         address sender = _msgSender();
817         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
818         (uint256 rAmount,,,,,) = _getValues(tAmount);
819         _rOwned[sender] = _rOwned[sender].sub(rAmount);
820         _rTotal = _rTotal.sub(rAmount);
821         _tFeeTotal = _tFeeTotal.add(tAmount);
822     }
823 
824     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
825         require(tAmount <= _tTotal, "Amount must be less than supply");
826         if (!deductTransferFee) {
827             (uint256 rAmount,,,,,) = _getValues(tAmount);
828             return rAmount;
829         } else {
830             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
831             return rTransferAmount;
832         }
833     }
834 
835     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
836         require(rAmount <= _rTotal, "Amount must be less than total reflections");
837         uint256 currentRate =  _getRate();
838         return rAmount.div(currentRate);
839     }
840 
841     function excludeFromReward(address account) public onlyOwner() {
842         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
843         require(!_isExcluded[account], "Account is already excluded");
844         if(_rOwned[account] > 0) {
845             _tOwned[account] = tokenFromReflection(_rOwned[account]);
846         }
847         _isExcluded[account] = true;
848         _excluded.push(account);
849     }
850 
851     function includeInReward(address account) external onlyOwner() {
852         require(_isExcluded[account], "Account is already excluded");
853         for (uint256 i = 0; i < _excluded.length; i++) {
854             if (_excluded[i] == account) {
855                 _excluded[i] = _excluded[_excluded.length - 1];
856                 _tOwned[account] = 0;
857                 _isExcluded[account] = false;
858                 _excluded.pop();
859                 break;
860             }
861         }
862     }
863         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
864         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
865         _tOwned[sender] = _tOwned[sender].sub(tAmount);
866         _rOwned[sender] = _rOwned[sender].sub(rAmount);
867         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
868         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
869         _takeLiquidity(tLiquidity);
870         _reflectFee(rFee, tFee);
871         emit Transfer(sender, recipient, tTransferAmount);
872     }
873     
874         function excludeFromFee(address account) public onlyOwner {
875         _isExcludedFromFee[account] = true;
876     }
877     
878     function includeInFee(address account) public onlyOwner {
879         _isExcludedFromFee[account] = false;
880     }
881     
882      function setRouterAddress(address newRouter) public onlyOwner() {
883         IUniswapV2Router02 _newUniswapRouter = IUniswapV2Router02(newRouter);
884         uniswapV2Pair = IUniswapV2Factory(_newUniswapRouter.factory()).createPair(address(this), _newUniswapRouter.WETH());
885         uniswapV2Router = _newUniswapRouter;
886     }
887     
888     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
889         _taxFee = taxFee;
890     }
891     
892     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
893         _liquidityFee = liquidityFee;
894     }
895    
896     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
897         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
898             10**2
899         );
900     }
901 
902     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
903         swapAndLiquifyEnabled = _enabled;
904         emit SwapAndLiquifyEnabledUpdated(_enabled);
905     }
906     
907      //to recieve ETH from uniswapV2Router when swaping
908     receive() external payable {}
909 
910     function _reflectFee(uint256 rFee, uint256 tFee) private {
911         _rTotal = _rTotal.sub(rFee);
912         _tFeeTotal = _tFeeTotal.add(tFee);
913     }
914 
915     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
916         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
917         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
918         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
919     }
920 
921     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
922         uint256 tFee = calculateTaxFee(tAmount);
923         uint256 tLiquidity = calculateLiquidityFee(tAmount);
924         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
925         return (tTransferAmount, tFee, tLiquidity);
926     }
927 
928     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
929         uint256 rAmount = tAmount.mul(currentRate);
930         uint256 rFee = tFee.mul(currentRate);
931         uint256 rLiquidity = tLiquidity.mul(currentRate);
932         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
933         return (rAmount, rTransferAmount, rFee);
934     }
935 
936     function _getRate() private view returns(uint256) {
937         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
938         return rSupply.div(tSupply);
939     }
940 
941     function _getCurrentSupply() private view returns(uint256, uint256) {
942         uint256 rSupply = _rTotal;
943         uint256 tSupply = _tTotal;      
944         for (uint256 i = 0; i < _excluded.length; i++) {
945             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
946             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
947             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
948         }
949         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
950         return (rSupply, tSupply);
951     }
952     
953     function _takeLiquidity(uint256 tLiquidity) private {
954         uint256 currentRate =  _getRate();
955         uint256 rLiquidity = tLiquidity.mul(currentRate);
956         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
957         if(_isExcluded[address(this)])
958             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
959     }
960     
961     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
962         return _amount.mul(_taxFee).div(
963             10**2
964         );
965     }
966 
967     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
968         return _amount.mul(_liquidityFee).div(
969             10**2
970         );
971     }
972     
973     function removeAllFee() private {
974         if(_taxFee == 0 && _liquidityFee == 0) return;
975         
976         _previousTaxFee = _taxFee;
977         _previousLiquidityFee = _liquidityFee;
978         
979         _taxFee = 0;
980         _liquidityFee = 0;
981     }
982     
983     function restoreAllFee() private {
984         _taxFee = _previousTaxFee;
985         _liquidityFee = _previousLiquidityFee;
986     }
987     
988     function isExcludedFromFee(address account) public view returns(bool) {
989         return _isExcludedFromFee[account];
990     }
991     
992     function sendBNBToCharity(uint256 amount) private { 
993         swapTokensForEth(amount); 
994         _charityWalletAddress.transfer(address(this).balance); 
995     }
996     
997     function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
998         _charityWalletAddress = charityWalletAddress;
999     }
1000 
1001     function _approve(address owner, address spender, uint256 amount) private {
1002         require(owner != address(0), "ERC20: approve from the zero address");
1003         require(spender != address(0), "ERC20: approve to the zero address");
1004 
1005         _allowances[owner][spender] = amount;
1006         emit Approval(owner, spender, amount);
1007     }
1008 
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 amount
1013     ) private {
1014         require(from != address(0), "ERC20: transfer from the zero address");
1015         require(to != address(0), "ERC20: transfer to the zero address");
1016         require(amount > 0, "Transfer amount must be greater than zero");
1017         if(from != owner() && to != owner())
1018             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1019 
1020         // is the token balance of this contract address over the min number of
1021         // tokens that we need to initiate a swap + liquidity lock?
1022         // also, don't get caught in a circular liquidity event.
1023         // also, don't swap & liquify if sender is uniswap pair.
1024         uint256 contractTokenBalance = balanceOf(address(this));
1025         
1026         if(contractTokenBalance >= _maxTxAmount)
1027         {
1028             contractTokenBalance = _maxTxAmount;
1029         }
1030         
1031         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1032         if (
1033             overMinTokenBalance &&
1034             !inSwapAndLiquify &&
1035             from != uniswapV2Pair &&
1036             swapAndLiquifyEnabled
1037         ) {
1038             contractTokenBalance = numTokensSellToAddToLiquidity;
1039             //add liquidity
1040             swapAndLiquify(contractTokenBalance);
1041         }
1042         
1043         //indicates if fee should be deducted from transfer
1044         bool takeFee = true;
1045         
1046         //if any account belongs to _isExcludedFromFee account then remove the fee
1047         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1048             takeFee = false;
1049         }
1050         
1051         //transfer amount, it will take tax, burn, liquidity fee
1052         _tokenTransfer(from,to,amount,takeFee);
1053     }
1054 
1055     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1056         // split the contract balance into thirds
1057         uint256 halfOfLiquify = contractTokenBalance.div(4);
1058         uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
1059         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);
1060 
1061         // capture the contract's current ETH balance.
1062         // this is so that we can capture exactly the amount of ETH that the
1063         // swap creates, and not make the liquidity event include any ETH that
1064         // has been manually sent to the contract
1065         uint256 initialBalance = address(this).balance;
1066 
1067         // swap tokens for ETH
1068         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1069 
1070         // how much ETH did we just swap into?
1071         uint256 newBalance = address(this).balance.sub(initialBalance);
1072 
1073         // add liquidity to uniswap
1074         addLiquidity(otherHalfOfLiquify, newBalance);
1075         sendBNBToCharity(portionForFees);
1076         
1077         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
1078     }
1079 
1080     function swapTokensForEth(uint256 tokenAmount) private {
1081         // generate the uniswap pair path of token -> weth
1082         address[] memory path = new address[](2);
1083         path[0] = address(this);
1084         path[1] = uniswapV2Router.WETH();
1085 
1086         _approve(address(this), address(uniswapV2Router), tokenAmount);
1087 
1088         // make the swap
1089         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1090             tokenAmount,
1091             0, // accept any amount of ETH
1092             path,
1093             address(this),
1094             block.timestamp
1095         );
1096     }
1097 
1098     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1099         // approve token transfer to cover all possible scenarios
1100         _approve(address(this), address(uniswapV2Router), tokenAmount);
1101 
1102         // add the liquidity
1103         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1104             address(this),
1105             tokenAmount,
1106             0, // slippage is unavoidable
1107             0, // slippage is unavoidable
1108             owner(),
1109             block.timestamp
1110         );
1111     }
1112 
1113     //this method is responsible for taking all fee, if takeFee is true
1114     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1115         if(!takeFee)
1116             removeAllFee();
1117         
1118         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1119             _transferFromExcluded(sender, recipient, amount);
1120         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1121             _transferToExcluded(sender, recipient, amount);
1122         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1123             _transferStandard(sender, recipient, amount);
1124         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1125             _transferBothExcluded(sender, recipient, amount);
1126         } else {
1127             _transferStandard(sender, recipient, amount);
1128         }
1129         
1130         if(!takeFee)
1131             restoreAllFee();
1132     }
1133 
1134     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1135         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1136         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1137         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1138         _takeLiquidity(tLiquidity);
1139         _reflectFee(rFee, tFee);
1140         emit Transfer(sender, recipient, tTransferAmount);
1141     }
1142 
1143     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1144         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1145         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1146         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1147         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1148         _takeLiquidity(tLiquidity);
1149         _reflectFee(rFee, tFee);
1150         emit Transfer(sender, recipient, tTransferAmount);
1151     }
1152 
1153     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1154         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1155         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1156         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1157         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1158         _takeLiquidity(tLiquidity);
1159         _reflectFee(rFee, tFee);
1160         emit Transfer(sender, recipient, tTransferAmount);
1161     }
1162 
1163 
1164     
1165 
1166 }