1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-14
3 */
4 
5 pragma solidity ^0.8.1;
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
236     function _msgSender() internal view virtual returns (address) {
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
322         return functionCall(target, data, "Address: low-level call failed");
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
407     constructor () {
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
428     /**
429     * @dev Leaves the contract without owner. It will not be possible to call
430     * `onlyOwner` functions anymore. Can only be called by the current owner.
431     *
432     * NOTE: Renouncing ownership will leave the contract without an owner,
433     * thereby removing any functionality that is only available to the owner.
434     */
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
458         _lockTime = block.timestamp + time;
459         emit OwnershipTransferred(_owner, address(0));
460     }
461     
462     //Unlocks the contract for owner when _lockTime is exceeds
463     function unlock() public virtual {
464         require(_previousOwner == msg.sender, "You don't have permission to unlock");
465         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
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
618     external
619     payable
620     returns (uint[] memory amounts);
621     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
622     external
623     returns (uint[] memory amounts);
624     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
625     external
626     returns (uint[] memory amounts);
627     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
628     external
629     payable
630     returns (uint[] memory amounts);
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
684 contract METAPORTAL is Context, IERC20, Ownable {
685     using SafeMath for uint256;
686     using Address for address;
687     address deadAddress = 0x000000000000000000000000000000000000dEaD;
688 
689     string private _name = "MetaPortal";
690     string private _symbol = "MetaPortal";
691     uint8 private _decimals = 9;    
692     uint256 private initialsupply = 1_000_000_000;
693     uint256 private _tTotal = initialsupply * 10 ** _decimals;
694     address payable private _marketingWallet;
695     
696     mapping (address => uint256) private _rOwned;
697     mapping (address => uint256) private _tOwned;
698     mapping(address => uint256) private buycooldown;
699     mapping(address => uint256) private sellcooldown;
700     mapping (address => mapping (address => uint256)) private _allowances;
701     mapping (address => bool) private _isExcludedFromFee;
702     mapping (address => bool) private _isExcluded;
703     mapping (address => bool) private _isBlacklisted;
704     address[] private _excluded;
705     bool private cooldownEnabled = true;
706     uint256 public cooldown = 30 seconds;
707     
708     uint256 private constant MAX = ~uint256(0);
709     uint256 private _rTotal = (MAX - (MAX % _tTotal));
710     uint256 private _tFeeTotal;
711     uint256 public _taxFee = 0;
712     uint256 private _previousTaxFee = _taxFee;
713     uint256 public _liquidityFee = 4;
714     uint256 private _previousLiquidityFee = _liquidityFee;
715     uint256 public _marketingFee = 7;
716     uint256 private _previousMarketingFee = _marketingFee;
717     
718     uint256 private maxBuyPercent = 10;
719     uint256 private maxBuyDivisor = 1000;
720     uint256 private _maxBuyAmount = (_tTotal * maxBuyPercent) / maxBuyDivisor;
721    
722     IUniswapV2Router02 public immutable uniswapV2Router;
723     address public immutable uniswapV2Pair;
724     bool inSwapAndLiquify;
725     bool public swapAndLiquifyEnabled = true;
726     
727     uint256 private numTokensSellToAddToLiquidity = _tTotal / 100; // 1%
728     
729     event ToMarketing(uint256 bnbSent);
730     event SwapAndLiquifyEnabledUpdated(bool enabled);
731     event SwapAndLiquify(
732         uint256 tokensSwapped,
733         uint256 ethReceived,
734         uint256 tokensIntoLiqudity
735     );
736     
737     modifier lockTheSwap {
738         inSwapAndLiquify = true;
739         _;
740         inSwapAndLiquify = false;
741     }
742 
743     constructor (address marketingWallet) {
744         _rOwned[_msgSender()] = _rTotal;
745          _marketingWallet = payable(marketingWallet);
746         // Pancake Swap V2 address
747         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
748         // uniswap address
749         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
750         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
751         .createPair(address(this), _uniswapV2Router.WETH());
752         uniswapV2Router = _uniswapV2Router;
753         _isExcludedFromFee[owner()] = true;
754         _isExcludedFromFee[address(this)] = true;
755         _isExcludedFromFee[_marketingWallet] = true;
756 
757         emit Transfer(address(0), _msgSender(), _tTotal);
758     }
759 
760     function name() public view returns (string memory) {return _name;}
761     function symbol() public view returns (string memory) {return _symbol;}
762     function decimals() public view returns (uint8) {return _decimals;}
763     function totalSupply() public view override returns (uint256) {return _tTotal;}
764     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
765     function balanceOf(address account) public view override returns (uint256) {
766         if (_isExcluded[account]) return _tOwned[account];
767         return tokenFromReflection(_rOwned[account]);
768     }
769     function approve(address spender, uint256 amount) public override returns (bool) {
770         _approve(_msgSender(), spender, amount);
771         return true;
772     }
773 
774     function setNumTokensSellToAddToLiquidity(uint256 percent, uint256 divisor) external onlyOwner() {
775         uint256 swapAmount = _tTotal.mul(percent).div(divisor);
776         numTokensSellToAddToLiquidity = swapAmount;
777     }
778         
779     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
780         _liquidityFee = liquidityFee;
781     }    
782     
783     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
784         _marketingFee = marketingFee;
785     }    
786     
787     function setCooldown(uint256 _cooldown) external onlyOwner() {
788         cooldown = _cooldown;
789     }
790     
791     function setMaxBuyPercent(uint256 percent, uint divisor) external onlyOwner {
792         require(percent >= 1 && divisor <= 1000); // cannot set lower than .1%
793         uint256 new_tx = _tTotal.mul(percent).div(divisor);
794         require(new_tx >= (_tTotal / 1000), "Max tx must be above 0.1% of total supply.");
795         _maxBuyAmount = new_tx;
796     }
797 
798     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
799         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
800         return true;
801     }
802 
803     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
804         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
805         return true;
806     }
807     
808     function setBlacklistStatus(address account, bool Blacklisted) external onlyOwner {
809     		if (Blacklisted = true) {
810                 _isBlacklisted[account] = true; 
811     		} else if(Blacklisted = false) {
812                 _isBlacklisted[account] = false;
813                 }
814     }
815     
816     function deliver(uint256 tAmount) public {
817         address sender = _msgSender();
818         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
819         (uint256 rAmount,,,,,,) = _getValues(tAmount);
820         _rOwned[sender] = _rOwned[sender].sub(rAmount);
821         _rTotal = _rTotal.sub(rAmount);
822         _tFeeTotal = _tFeeTotal.add(tAmount);
823     }
824 
825     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
826         require(tAmount <= _tTotal, "Amount must be less than supply");
827         if (!deductTransferFee) {
828             (uint256 rAmount,,,,,,) = _getValues(tAmount);
829             return rAmount;
830         } else {
831             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
832             return rTransferAmount;
833         }
834     }
835 
836     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
837         require(rAmount <= _rTotal, "Amount must be less than total reflections");
838         uint256 currentRate =  _getRate();
839         return rAmount.div(currentRate);
840     }
841 
842     function isExcludedFromReward(address account) public view returns (bool) {
843         return _isExcluded[account];
844     }
845 
846     function excludeFromReward(address account) public onlyOwner() {
847         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
848         // require(account != 0x10ED43C718714eb63d5aA57B78B54704E256024E, 'We can not exclude Uniswap router.');
849         require(!_isExcluded[account], "Account is already excluded");
850         if(_rOwned[account] > 0) {
851             _tOwned[account] = tokenFromReflection(_rOwned[account]);
852         }
853         _isExcluded[account] = true;
854         _excluded.push(account);
855     }
856 
857     function includeInReward(address account) external onlyOwner() {
858         require(_isExcluded[account], "Account is already excluded");
859         for (uint256 i = 0; i < _excluded.length; i++) {
860             if (_excluded[i] == account) {
861                 _excluded[i] = _excluded[_excluded.length - 1];
862                 _tOwned[account] = 0;
863                 _isExcluded[account] = false;
864                 _excluded.pop();
865                 break;
866             }
867         }
868     }
869 
870     function excludeFromFee(address account) public onlyOwner {
871         _isExcludedFromFee[account] = true;
872     }
873 
874     function includeInFee(address account) public onlyOwner {
875         _isExcludedFromFee[account] = false;
876     }
877     
878     function isExcludedFromFee(address account) public view returns(bool) {
879         return _isExcludedFromFee[account];
880     }
881     
882     function totalFees() public view returns (uint256) {
883         return _tFeeTotal;
884     }
885 
886     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
887         swapAndLiquifyEnabled = _enabled;
888         emit SwapAndLiquifyEnabledUpdated(_enabled);
889     }
890 
891     //to receive ETH from uniswapV2Router when swapping
892     receive() external payable {}
893 
894     function _reflectFee(uint256 rFee, uint256 tFee) private {
895         _rTotal = _rTotal.sub(rFee);
896         _tFeeTotal = _tFeeTotal.add(tFee);
897     }
898 
899     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
900         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getTValues(tAmount);
901         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tMarketing, _getRate());
902         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tMarketing);
903     }
904 
905     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
906         uint256 tFee = calculateTaxFee(tAmount);
907         uint256 tMarketing = calculateMarketingFee(tAmount);
908         uint256 tLiquidity = calculateLiquidityFee(tAmount);
909         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tMarketing);
910         return (tTransferAmount, tFee, tMarketing, tLiquidity);
911     }
912 
913     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
914         uint256 rAmount = tAmount.mul(currentRate);
915         uint256 rFee = tFee.mul(currentRate);
916         uint256 rMarketing = tMarketing.mul(currentRate);
917         uint256 rLiquidity = tLiquidity.mul(currentRate);
918         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rMarketing);
919         return (rAmount, rTransferAmount, rFee);
920     }
921 
922     function _getRate() private view returns(uint256) {
923         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
924         return rSupply.div(tSupply);
925     }
926 
927     function _getCurrentSupply() private view returns(uint256, uint256) {
928         uint256 rSupply = _rTotal;
929         uint256 tSupply = _tTotal;
930         for (uint256 i = 0; i < _excluded.length; i++) {
931             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
932             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
933             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
934         }
935         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
936         return (rSupply, tSupply);
937     }
938 
939     function _takeLiquidity(uint256 tLiquidity) private {
940         uint256 currentRate =  _getRate();
941         uint256 rLiquidity = tLiquidity.mul(currentRate);
942         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
943         if(_isExcluded[address(this)])
944             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
945     }    
946     
947     function _takeMarketing(uint256 tMarketing) private {
948         uint256 currentRate =  _getRate();
949         uint256 rMarketing = tMarketing.mul(currentRate);
950         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
951         if(_isExcluded[address(this)])
952             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
953     }
954 
955     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
956         return _amount.mul(_taxFee).div(
957             10**2
958         );
959     }
960 
961     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
962         return _amount.mul(_marketingFee).div(
963             10**2
964         );
965     }
966     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
967         return _amount.mul(_liquidityFee).div(
968             10**2
969         );
970     }
971 
972     function removeAllFee() private {
973         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
974 
975         _previousTaxFee = _taxFee;
976         _previousMarketingFee = _marketingFee;
977         _previousLiquidityFee = _liquidityFee;
978 
979         _taxFee = 0;
980         _marketingFee = 0;
981         _liquidityFee = 0;
982     }
983 
984     function restoreAllFee() private {
985         _taxFee = _previousTaxFee;
986         _marketingFee = _previousMarketingFee;
987         _liquidityFee = _previousLiquidityFee;
988     }
989 
990     function _approve(address owner, address spender, uint256 amount) private {
991         require(owner != address(0), "ERC20: approve from the zero address");
992         require(spender != address(0), "ERC20: approve to the zero address");
993 
994         _allowances[owner][spender] = amount;
995         emit Approval(owner, spender, amount);
996     }
997 
998     // swapAndLiquify takes the balance to be liquified and make sure it is equally distributed
999     // in BNB and Harold
1000     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1001         // 1/2 balance is sent to the marketing wallet, 1/2 is added to the liquidity pool
1002         uint256 marketingTokenBalance = contractTokenBalance.div(2);
1003         uint256 liquidityTokenBalance = contractTokenBalance.sub(marketingTokenBalance);
1004         uint256 tokenBalanceToLiquifyAsBNB = liquidityTokenBalance.div(2);
1005         uint256 tokenBalanceToLiquify = liquidityTokenBalance.sub(tokenBalanceToLiquifyAsBNB);
1006         uint256 initialBalance = address(this).balance;
1007 
1008         // 75% of the balance will be converted into BNB
1009         uint256 tokensToSwapToBNB = tokenBalanceToLiquifyAsBNB.add(marketingTokenBalance);
1010 
1011         swapTokensForEth(tokensToSwapToBNB);
1012 
1013         uint256 bnbSwapped = address(this).balance.sub(initialBalance);
1014 
1015         uint256 bnbToLiquify = bnbSwapped.div(3);
1016 
1017         addLiquidity(tokenBalanceToLiquify, bnbToLiquify);
1018 
1019         emit SwapAndLiquify(tokenBalanceToLiquifyAsBNB, bnbToLiquify, tokenBalanceToLiquify);
1020 
1021         uint256 marketingBNB = bnbSwapped.sub(bnbToLiquify);
1022 
1023         // Transfer the BNB to the marketing wallet
1024         _marketingWallet.transfer(marketingBNB);
1025         emit ToMarketing(marketingBNB);
1026     }
1027 
1028     function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
1029         require(amountPercentage <= 100);
1030         uint256 amountBNB = address(this).balance;
1031         payable(_marketingWallet).transfer(amountBNB.mul(amountPercentage).div(100));
1032     }
1033 
1034     function swapTokensForEth(uint256 tokenAmount) private {
1035         // generate the uniswap pair path of token -> weth
1036         address[] memory path = new address[](2);
1037         path[0] = address(this);
1038         path[1] = uniswapV2Router.WETH();
1039 
1040         _approve(address(this), address(uniswapV2Router), tokenAmount);
1041 
1042         // make the swap
1043         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1044             tokenAmount,
1045             0, // accept any amount of ETH
1046             path,
1047             address(this),
1048             block.timestamp
1049         );
1050     }
1051 
1052     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1053         // approve token transfer to cover all possible scenarios
1054         _approve(address(this), address(uniswapV2Router), tokenAmount);
1055 
1056         // add the liquidity
1057         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1058             address(this),
1059             tokenAmount,
1060             0, // slippage is unavoidable
1061             0, // slippage is unavoidable
1062             owner(),
1063             block.timestamp
1064         );
1065     }
1066     
1067     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1068         _transfer(sender, recipient, amount);
1069         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1070         return true;
1071     }
1072 
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 amount
1077     ) private {
1078         require(from != address(0), "ERC20: transfer from the zero address");
1079         require(to != address(0), "ERC20: transfer to the zero address");
1080         require(amount > 0, "Transfer amount must be greater than zero");
1081         require(_isBlacklisted[from] == false, "Hehe");
1082         require(_isBlacklisted[to] == false, "Hehe");
1083         if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
1084                 require(amount <= _maxBuyAmount);
1085                 require(buycooldown[to] < block.timestamp);
1086                 buycooldown[to] = block.timestamp.add(cooldown);        
1087             } else if(from == uniswapV2Pair && cooldownEnabled && !_isExcludedFromFee[to]) {
1088             require(sellcooldown[from] <= block.timestamp);
1089             sellcooldown[from] = block.timestamp.add(cooldown);
1090         }
1091             
1092         uint256 contractTokenBalance = balanceOf(address(this));
1093 
1094         if(contractTokenBalance >= numTokensSellToAddToLiquidity)
1095         {
1096             contractTokenBalance = numTokensSellToAddToLiquidity;
1097         }
1098 
1099         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1100         if (
1101             overMinTokenBalance &&
1102             !inSwapAndLiquify &&
1103             from != uniswapV2Pair &&
1104             swapAndLiquifyEnabled            
1105         ) {
1106             contractTokenBalance = numTokensSellToAddToLiquidity;
1107             swapAndLiquify(contractTokenBalance);
1108         }
1109 
1110         //indicates if fee should be deducted from transfer
1111         bool takeFee = true;
1112 
1113         //if any account belongs to _isExcludedFromFee account then remove the fee
1114         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1115             takeFee = false;
1116         }
1117 
1118         //transfer amount, it will take tax, burn, liquidity fee
1119         _tokenTransfer(from,to,amount,takeFee);
1120     }
1121 
1122     function transfer(address recipient, uint256 amount) public override returns (bool) {
1123         _transfer(_msgSender(), recipient, amount);
1124         return true;
1125     }
1126 
1127     //this method is responsible for taking all fee, if takeFee is true
1128     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1129         if(!takeFee)
1130             removeAllFee();
1131 
1132         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1133             _transferFromExcluded(sender, recipient, amount);
1134         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1135             _transferToExcluded(sender, recipient, amount);
1136         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1137             _transferStandard(sender, recipient, amount);
1138         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1139             _transferBothExcluded(sender, recipient, amount);
1140         } else {
1141             _transferStandard(sender, recipient, amount);
1142         }
1143 
1144         if(!takeFee)
1145             restoreAllFee();
1146     }
1147 
1148     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1149         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
1150         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1151         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1152         _takeLiquidity(tLiquidity);        
1153         _takeMarketing(tMarketing);
1154         _reflectFee(rFee, tFee);
1155         emit Transfer(sender, recipient, tTransferAmount);
1156     }
1157 
1158     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1159         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
1160         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1161         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1162         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1163         _takeLiquidity(tLiquidity);        
1164         _takeMarketing(tMarketing);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 
1169     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1170         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
1171         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1172         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1173         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1174         _takeLiquidity(tLiquidity);       
1175         _takeMarketing(tMarketing);
1176         _reflectFee(rFee, tFee);
1177         emit Transfer(sender, recipient, tTransferAmount);
1178     }
1179     
1180     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1181         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tMarketing) = _getValues(tAmount);
1182         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1183         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1184         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1185         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1186         _takeLiquidity(tLiquidity);        
1187         _takeMarketing(tMarketing);
1188         _reflectFee(rFee, tFee);
1189         emit Transfer(sender, recipient, tTransferAmount);
1190     }
1191 
1192     function cooldownStatus() public view returns (bool) {
1193         return cooldownEnabled;
1194     }
1195     
1196     function setCooldownEnabled(bool onoff) external onlyOwner() {
1197         cooldownEnabled = onoff;
1198     }
1199 }