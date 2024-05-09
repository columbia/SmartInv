1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-08
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 pragma solidity ^0.6.12;
8 interface IERC20 {
9 
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Emitted when `value` tokens are moved from one account (`from`) to
64      * another (`to`).
65      *
66      * Note that `value` may be zero.
67      */
68     event Transfer(address indexed from, address indexed to, uint256 value);
69 
70     /**
71      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
72      * a call to {approve}. `value` is the new allowance.
73      */
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92  
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address payable) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable is Context {
399     address private _owner;
400     address private _previousOwner;
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
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429      /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 
451     function geUnlockTime() public view returns (uint256) {
452         return _lockTime;
453     }
454 
455     //Locks the contract for owner for the amount of time provided
456     function lock(uint256 time) public virtual onlyOwner {
457         _previousOwner = _owner;
458         _owner = address(0);
459         _lockTime = now + time;
460         emit OwnershipTransferred(_owner, address(0));
461     }
462     
463     //Unlocks the contract for owner when _lockTime is exceeds
464     function unlock() public virtual {
465         require(_previousOwner == msg.sender, "You don't have permission to unlock");
466         require(now > _lockTime , "Contract is locked until 7 days");
467         emit OwnershipTransferred(_owner, _previousOwner);
468         _owner = _previousOwner;
469     }
470 }
471 
472 // pragma solidity >=0.5.0;
473 
474 interface IUniswapV2Factory {
475     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
476 
477     function feeTo() external view returns (address);
478     function feeToSetter() external view returns (address);
479 
480     function getPair(address tokenA, address tokenB) external view returns (address pair);
481     function allPairs(uint) external view returns (address pair);
482     function allPairsLength() external view returns (uint);
483 
484     function createPair(address tokenA, address tokenB) external returns (address pair);
485 
486     function setFeeTo(address) external;
487     function setFeeToSetter(address) external;
488 }
489 
490 
491 // pragma solidity >=0.5.0;
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
544 // pragma solidity >=0.6.2;
545 
546 interface IUniswapV2Router01 {
547     function factory() external pure returns (address);
548     function WETH() external pure returns (address);
549 
550     function addLiquidity(
551         address tokenA,
552         address tokenB,
553         uint amountADesired,
554         uint amountBDesired,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountA, uint amountB, uint liquidity);
560     function addLiquidityETH(
561         address token,
562         uint amountTokenDesired,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
568     function removeLiquidity(
569         address tokenA,
570         address tokenB,
571         uint liquidity,
572         uint amountAMin,
573         uint amountBMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountA, uint amountB);
577     function removeLiquidityETH(
578         address token,
579         uint liquidity,
580         uint amountTokenMin,
581         uint amountETHMin,
582         address to,
583         uint deadline
584     ) external returns (uint amountToken, uint amountETH);
585     function removeLiquidityWithPermit(
586         address tokenA,
587         address tokenB,
588         uint liquidity,
589         uint amountAMin,
590         uint amountBMin,
591         address to,
592         uint deadline,
593         bool approveMax, uint8 v, bytes32 r, bytes32 s
594     ) external returns (uint amountA, uint amountB);
595     function removeLiquidityETHWithPermit(
596         address token,
597         uint liquidity,
598         uint amountTokenMin,
599         uint amountETHMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external returns (uint amountToken, uint amountETH);
604     function swapExactTokensForTokens(
605         uint amountIn,
606         uint amountOutMin,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external returns (uint[] memory amounts);
611     function swapTokensForExactTokens(
612         uint amountOut,
613         uint amountInMax,
614         address[] calldata path,
615         address to,
616         uint deadline
617     ) external returns (uint[] memory amounts);
618     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
619         external
620         payable
621         returns (uint[] memory amounts);
622     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
623         external
624         returns (uint[] memory amounts);
625     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
626         external
627         returns (uint[] memory amounts);
628     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
629         external
630         payable
631         returns (uint[] memory amounts);
632 
633     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
634     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
635     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
636     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
637     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
638 }
639 
640 
641 
642 // pragma solidity >=0.6.2;
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
685 
686 contract Few is Context, IERC20, Ownable {
687     using SafeMath for uint256;
688     using Address for address;
689 
690     mapping (address => uint256) private _rOwned;
691     mapping (address => uint256) private _tOwned;
692     mapping (address => mapping (address => uint256)) private _allowances;
693 
694     mapping (address => bool) private _isExcludedFromFee;
695 
696     mapping (address => bool) private _isExcluded;
697     address[] private _excluded;
698    
699     uint256 private constant MAX = ~uint256(0);
700     uint256 private _tTotal = 100000000000 * 10**1 * 10**9;
701     uint256 private _rTotal = (MAX - (MAX % _tTotal));
702     uint256 private _tFeeTotal;
703 
704     string private _name = "Few Understand";
705     string private _symbol = "FEW";
706     uint8 private _decimals = 9;
707     
708     uint256 public _taxFee = 2;
709     uint256 private _previousTaxFee = _taxFee;
710     
711     uint256 public _liquidityFee = 8;
712     uint256 private _previousLiquidityFee = _liquidityFee;
713 
714     IUniswapV2Router02 public immutable uniswapV2Router;
715     address public immutable uniswapV2Pair;
716     address payable public _charityWalletAddress;
717     
718     bool inSwapAndLiquify;
719     bool public swapAndLiquifyEnabled = true;
720     
721     uint256 public _maxTxAmount = 1000000000 * 10**1 * 10**9;
722     uint256 private numTokensSellToAddToLiquidity = 300000000 * 10**1 * 10**9;
723     
724     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
725     event SwapAndLiquifyEnabledUpdated(bool enabled);
726     event SwapAndLiquify(
727         uint256 tokensSwapped,
728         uint256 ethReceived,
729         uint256 tokensIntoLiqudity
730     );
731     
732     modifier lockTheSwap {
733         inSwapAndLiquify = true;
734         _;
735         inSwapAndLiquify = false;
736     }
737     
738     constructor (address payable charityWalletAddress) public {
739         _charityWalletAddress = charityWalletAddress;
740         _rOwned[_msgSender()] = _rTotal;
741         
742         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
743          // Create a uniswap pair for this new token
744         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
745             .createPair(address(this), _uniswapV2Router.WETH());
746 
747         // set the rest of the contract variables
748         uniswapV2Router = _uniswapV2Router;
749         
750         //exclude owner and this contract from fee
751         _isExcludedFromFee[owner()] = true;
752         _isExcludedFromFee[address(this)] = true;
753         
754         emit Transfer(address(0), _msgSender(), _tTotal);
755     }
756 
757     function name() public view returns (string memory) {
758         return _name;
759     }
760 
761     function symbol() public view returns (string memory) {
762         return _symbol;
763     }
764 
765     function decimals() public view returns (uint8) {
766         return _decimals;
767     }
768 
769     function totalSupply() public view override returns (uint256) {
770         return _tTotal;
771     }
772 
773     function balanceOf(address account) public view override returns (uint256) {
774         if (_isExcluded[account]) return _tOwned[account];
775         return tokenFromReflection(_rOwned[account]);
776     }
777 
778     function transfer(address recipient, uint256 amount) public override returns (bool) {
779         _transfer(_msgSender(), recipient, amount);
780         return true;
781     }
782 
783     function allowance(address owner, address spender) public view override returns (uint256) {
784         return _allowances[owner][spender];
785     }
786 
787     function approve(address spender, uint256 amount) public override returns (bool) {
788         _approve(_msgSender(), spender, amount);
789         return true;
790     }
791 
792     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
793         _transfer(sender, recipient, amount);
794         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
795         return true;
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
808     function isExcludedFromReward(address account) public view returns (bool) {
809         return _isExcluded[account];
810     }
811 
812     function totalFees() public view returns (uint256) {
813         return _tFeeTotal;
814     }
815 
816     function deliver(uint256 tAmount) public {
817         address sender = _msgSender();
818         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
819         (uint256 rAmount,,,,,) = _getValues(tAmount);
820         _rOwned[sender] = _rOwned[sender].sub(rAmount);
821         _rTotal = _rTotal.sub(rAmount);
822         _tFeeTotal = _tFeeTotal.add(tAmount);
823     }
824 
825     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
826         require(tAmount <= _tTotal, "Amount must be less than supply");
827         if (!deductTransferFee) {
828             (uint256 rAmount,,,,,) = _getValues(tAmount);
829             return rAmount;
830         } else {
831             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
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
842     function excludeFromReward(address account) public onlyOwner() {
843         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
844         require(!_isExcluded[account], "Account is already excluded");
845         if(_rOwned[account] > 0) {
846             _tOwned[account] = tokenFromReflection(_rOwned[account]);
847         }
848         _isExcluded[account] = true;
849         _excluded.push(account);
850     }
851 
852     function includeInReward(address account) external onlyOwner() {
853         require(_isExcluded[account], "Account is already excluded");
854         for (uint256 i = 0; i < _excluded.length; i++) {
855             if (_excluded[i] == account) {
856                 _excluded[i] = _excluded[_excluded.length - 1];
857                 _tOwned[account] = 0;
858                 _isExcluded[account] = false;
859                 _excluded.pop();
860                 break;
861             }
862         }
863     }
864         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
865         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
866         _tOwned[sender] = _tOwned[sender].sub(tAmount);
867         _rOwned[sender] = _rOwned[sender].sub(rAmount);
868         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
869         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
870         _takeLiquidity(tLiquidity);
871         _reflectFee(rFee, tFee);
872         emit Transfer(sender, recipient, tTransferAmount);
873     }
874     
875         function excludeFromFee(address account) public onlyOwner {
876         _isExcludedFromFee[account] = true;
877     }
878     
879     function includeInFee(address account) public onlyOwner {
880         _isExcludedFromFee[account] = false;
881     }
882     
883     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
884         _taxFee = taxFee;
885     }
886     
887     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
888         _liquidityFee = liquidityFee;
889     }
890    
891     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
892         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
893             10**2
894         );
895     }
896 
897     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
898         swapAndLiquifyEnabled = _enabled;
899         emit SwapAndLiquifyEnabledUpdated(_enabled);
900     }
901     
902      //to recieve ETH from uniswapV2Router when swaping
903     receive() external payable {}
904 
905     function _reflectFee(uint256 rFee, uint256 tFee) private {
906         _rTotal = _rTotal.sub(rFee);
907         _tFeeTotal = _tFeeTotal.add(tFee);
908     }
909 
910     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
911         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
912         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
913         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
914     }
915 
916     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
917         uint256 tFee = calculateTaxFee(tAmount);
918         uint256 tLiquidity = calculateLiquidityFee(tAmount);
919         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
920         return (tTransferAmount, tFee, tLiquidity);
921     }
922 
923     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
924         uint256 rAmount = tAmount.mul(currentRate);
925         uint256 rFee = tFee.mul(currentRate);
926         uint256 rLiquidity = tLiquidity.mul(currentRate);
927         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
928         return (rAmount, rTransferAmount, rFee);
929     }
930 
931     function _getRate() private view returns(uint256) {
932         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
933         return rSupply.div(tSupply);
934     }
935 
936     function _getCurrentSupply() private view returns(uint256, uint256) {
937         uint256 rSupply = _rTotal;
938         uint256 tSupply = _tTotal;      
939         for (uint256 i = 0; i < _excluded.length; i++) {
940             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
941             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
942             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
943         }
944         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
945         return (rSupply, tSupply);
946     }
947     
948     function _takeLiquidity(uint256 tLiquidity) private {
949         uint256 currentRate =  _getRate();
950         uint256 rLiquidity = tLiquidity.mul(currentRate);
951         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
952         if(_isExcluded[address(this)])
953             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
954     }
955     
956     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
957         return _amount.mul(_taxFee).div(
958             10**2
959         );
960     }
961 
962     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
963         return _amount.mul(_liquidityFee).div(
964             10**2
965         );
966     }
967     
968     function removeAllFee() private {
969         if(_taxFee == 0 && _liquidityFee == 0) return;
970         
971         _previousTaxFee = _taxFee;
972         _previousLiquidityFee = _liquidityFee;
973         
974         _taxFee = 0;
975         _liquidityFee = 0;
976     }
977     
978     function restoreAllFee() private {
979         _taxFee = _previousTaxFee;
980         _liquidityFee = _previousLiquidityFee;
981     }
982     
983     function isExcludedFromFee(address account) public view returns(bool) {
984         return _isExcludedFromFee[account];
985     }
986     
987     function sendBNBToCharity(uint256 amount) private { 
988         swapTokensForEth(amount); 
989         _charityWalletAddress.transfer(address(this).balance); 
990     }
991     
992     function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
993         _charityWalletAddress = charityWalletAddress;
994     }
995 
996     function _approve(address owner, address spender, uint256 amount) private {
997         require(owner != address(0), "ERC20: approve from the zero address");
998         require(spender != address(0), "ERC20: approve to the zero address");
999 
1000         _allowances[owner][spender] = amount;
1001         emit Approval(owner, spender, amount);
1002     }
1003 
1004     function _transfer(
1005         address from,
1006         address to,
1007         uint256 amount
1008     ) private {
1009         require(from != address(0), "ERC20: transfer from the zero address");
1010         require(to != address(0), "ERC20: transfer to the zero address");
1011         require(amount > 0, "Transfer amount must be greater than zero");
1012         if(from != owner() && to != owner())
1013             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1014 
1015         // is the token balance of this contract address over the min number of
1016         // tokens that we need to initiate a swap + liquidity lock?
1017         // also, don't get caught in a circular liquidity event.
1018         // also, don't swap & liquify if sender is uniswap pair.
1019         uint256 contractTokenBalance = balanceOf(address(this));
1020         
1021         if(contractTokenBalance >= _maxTxAmount)
1022         {
1023             contractTokenBalance = _maxTxAmount;
1024         }
1025         
1026         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1027         if (
1028             overMinTokenBalance &&
1029             !inSwapAndLiquify &&
1030             from != uniswapV2Pair &&
1031             swapAndLiquifyEnabled
1032         ) {
1033             contractTokenBalance = numTokensSellToAddToLiquidity;
1034             //add liquidity
1035             swapAndLiquify(contractTokenBalance);
1036         }
1037         
1038         //indicates if fee should be deducted from transfer
1039         bool takeFee = true;
1040         
1041         //if any account belongs to _isExcludedFromFee account then remove the fee
1042         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1043             takeFee = false;
1044         }
1045         
1046         //transfer amount, it will take tax, burn, liquidity fee
1047         _tokenTransfer(from,to,amount,takeFee);
1048     }
1049 
1050     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1051         // split the contract balance into thirds
1052         uint256 halfOfLiquify = contractTokenBalance.div(4);
1053         uint256 otherHalfOfLiquify = contractTokenBalance.div(4);
1054         uint256 portionForFees = contractTokenBalance.sub(halfOfLiquify).sub(otherHalfOfLiquify);
1055 
1056         // capture the contract's current ETH balance.
1057         // this is so that we can capture exactly the amount of ETH that the
1058         // swap creates, and not make the liquidity event include any ETH that
1059         // has been manually sent to the contract
1060         uint256 initialBalance = address(this).balance;
1061 
1062         // swap tokens for ETH
1063         swapTokensForEth(halfOfLiquify); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1064 
1065         // how much ETH did we just swap into?
1066         uint256 newBalance = address(this).balance.sub(initialBalance);
1067 
1068         // add liquidity to uniswap
1069         addLiquidity(otherHalfOfLiquify, newBalance);
1070         sendBNBToCharity(portionForFees);
1071         
1072         emit SwapAndLiquify(halfOfLiquify, newBalance, otherHalfOfLiquify);
1073     }
1074 
1075     function swapTokensForEth(uint256 tokenAmount) private {
1076         // generate the uniswap pair path of token -> weth
1077         address[] memory path = new address[](2);
1078         path[0] = address(this);
1079         path[1] = uniswapV2Router.WETH();
1080 
1081         _approve(address(this), address(uniswapV2Router), tokenAmount);
1082 
1083         // make the swap
1084         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1085             tokenAmount,
1086             0, // accept any amount of ETH
1087             path,
1088             address(this),
1089             block.timestamp
1090         );
1091     }
1092 
1093     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1094         // approve token transfer to cover all possible scenarios
1095         _approve(address(this), address(uniswapV2Router), tokenAmount);
1096 
1097         // add the liquidity
1098         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1099             address(this),
1100             tokenAmount,
1101             0, // slippage is unavoidable
1102             0, // slippage is unavoidable
1103             owner(),
1104             block.timestamp
1105         );
1106     }
1107 
1108     //this method is responsible for taking all fee, if takeFee is true
1109     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1110         if(!takeFee)
1111             removeAllFee();
1112         
1113         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1114             _transferFromExcluded(sender, recipient, amount);
1115         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1116             _transferToExcluded(sender, recipient, amount);
1117         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1118             _transferStandard(sender, recipient, amount);
1119         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1120             _transferBothExcluded(sender, recipient, amount);
1121         } else {
1122             _transferStandard(sender, recipient, amount);
1123         }
1124         
1125         if(!takeFee)
1126             restoreAllFee();
1127     }
1128 
1129     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1130         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1131         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1132         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1133         _takeLiquidity(tLiquidity);
1134         _reflectFee(rFee, tFee);
1135         emit Transfer(sender, recipient, tTransferAmount);
1136     }
1137 
1138     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1139         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1140         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1141         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1142         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1143         _takeLiquidity(tLiquidity);
1144         _reflectFee(rFee, tFee);
1145         emit Transfer(sender, recipient, tTransferAmount);
1146     }
1147 
1148     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1149         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1150         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1151         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1152         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1153         _takeLiquidity(tLiquidity);
1154         _reflectFee(rFee, tFee);
1155         emit Transfer(sender, recipient, tTransferAmount);
1156     }
1157 
1158 
1159     
1160 
1161 }