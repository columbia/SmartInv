1 /**
2   
3    Satoshi Dog token
4    
5    Features:
6    1% fee auto distributed to all hodlers
7    1% fee auto burnt
8    1% fee auto distributed to the charity wallet
9    
10 */
11 
12 pragma solidity ^0.6.12;
13 // SPDX-License-Identifier: Unlicensed
14 interface IERC20 {
15 
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98  
99 library SafeMath {
100     /**
101      * @dev Returns the addition of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `+` operator.
105      *
106      * Requirements:
107      *
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b <= a, errorMessage);
143         uint256 c = a - b;
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the multiplication of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `*` operator.
153      *
154      * Requirements:
155      *
156      * - Multiplication cannot overflow.
157      */
158     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint256 c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the integer division of two unsigned integers. Reverts on
174      * division by zero. The result is rounded towards zero.
175      *
176      * Counterpart to Solidity's `/` operator. Note: this function uses a
177      * `revert` opcode (which leaves remaining gas untouched) while Solidity
178      * uses an invalid opcode to revert (consuming all remaining gas).
179      *
180      * Requirements:
181      *
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201         require(b > 0, errorMessage);
202         uint256 c = a / b;
203         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return mod(a, b, "SafeMath: modulo by zero");
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts with custom message when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b != 0, errorMessage);
238         return a % b;
239     }
240 }
241 
242 abstract contract Context {
243     function _msgSender() internal view virtual returns (address payable) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view virtual returns (bytes memory) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
277         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
278         // for accounts without code, i.e. `keccak256('')`
279         bytes32 codehash;
280         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { codehash := extcodehash(account) }
283         return (codehash != accountHash && codehash != 0x0);
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return _functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         return _functionCallWithValue(target, data, value, errorMessage);
366     }
367 
368     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
369         require(isContract(target), "Address: call to non-contract");
370 
371         // solhint-disable-next-line avoid-low-level-calls
372         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 /**
393  * @dev Contract module which provides a basic access control mechanism, where
394  * there is an account (an owner) that can be granted exclusive access to
395  * specific functions.
396  *
397  * By default, the owner account will be the one that deploys the contract. This
398  * can later be changed with {transferOwnership}.
399  *
400  * This module is used through inheritance. It will make available the modifier
401  * `onlyOwner`, which can be applied to your functions to restrict their use to
402  * the owner.
403  */
404 contract Ownable is Context {
405     address private _owner;
406     address private _previousOwner;
407     uint256 private _lockTime;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor () internal {
415         address msgSender = _msgSender();
416         _owner = msgSender;
417         emit OwnershipTransferred(address(0), msgSender);
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(_owner == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435      /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         emit OwnershipTransferred(_owner, address(0));
444         _owner = address(0);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         emit OwnershipTransferred(_owner, newOwner);
454         _owner = newOwner;
455     }
456 
457     function geUnlockTime() public view returns (uint256) {
458         return _lockTime;
459     }
460 
461     //Locks the contract for owner for the amount of time provided
462     function lock(uint256 time) public virtual onlyOwner {
463         _previousOwner = _owner;
464         _owner = address(0);
465         _lockTime = now + time;
466         emit OwnershipTransferred(_owner, address(0));
467     }
468     
469     //Unlocks the contract for owner when _lockTime is exceeds
470     function unlock() public virtual {
471         require(_previousOwner == msg.sender, "You don't have permission to unlock");
472         require(now > _lockTime , "Contract is locked until 7 days");
473         emit OwnershipTransferred(_owner, _previousOwner);
474         _owner = _previousOwner;
475     }
476 }
477 
478 // pragma solidity >=0.5.0;
479 
480 interface IUniswapV2Factory {
481     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
482 
483     function feeTo() external view returns (address);
484     function feeToSetter() external view returns (address);
485 
486     function getPair(address tokenA, address tokenB) external view returns (address pair);
487     function allPairs(uint) external view returns (address pair);
488     function allPairsLength() external view returns (uint);
489 
490     function createPair(address tokenA, address tokenB) external returns (address pair);
491 
492     function setFeeTo(address) external;
493     function setFeeToSetter(address) external;
494 }
495 
496 
497 // pragma solidity >=0.5.0;
498 
499 interface IUniswapV2Pair {
500     event Approval(address indexed owner, address indexed spender, uint value);
501     event Transfer(address indexed from, address indexed to, uint value);
502 
503     function name() external pure returns (string memory);
504     function symbol() external pure returns (string memory);
505     function decimals() external pure returns (uint8);
506     function totalSupply() external view returns (uint);
507     function balanceOf(address owner) external view returns (uint);
508     function allowance(address owner, address spender) external view returns (uint);
509 
510     function approve(address spender, uint value) external returns (bool);
511     function transfer(address to, uint value) external returns (bool);
512     function transferFrom(address from, address to, uint value) external returns (bool);
513 
514     function DOMAIN_SEPARATOR() external view returns (bytes32);
515     function PERMIT_TYPEHASH() external pure returns (bytes32);
516     function nonces(address owner) external view returns (uint);
517 
518     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
519 
520     event Mint(address indexed sender, uint amount0, uint amount1);
521     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
522     event Swap(
523         address indexed sender,
524         uint amount0In,
525         uint amount1In,
526         uint amount0Out,
527         uint amount1Out,
528         address indexed to
529     );
530     event Sync(uint112 reserve0, uint112 reserve1);
531 
532     function MINIMUM_LIQUIDITY() external pure returns (uint);
533     function factory() external view returns (address);
534     function token0() external view returns (address);
535     function token1() external view returns (address);
536     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
537     function price0CumulativeLast() external view returns (uint);
538     function price1CumulativeLast() external view returns (uint);
539     function kLast() external view returns (uint);
540 
541     function mint(address to) external returns (uint liquidity);
542     function burn(address to) external returns (uint amount0, uint amount1);
543     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
544     function skim(address to) external;
545     function sync() external;
546 
547     function initialize(address, address) external;
548 }
549 
550 // pragma solidity >=0.6.2;
551 
552 interface IUniswapV2Router01 {
553     function factory() external pure returns (address);
554     function WETH() external pure returns (address);
555 
556     function addLiquidity(
557         address tokenA,
558         address tokenB,
559         uint amountADesired,
560         uint amountBDesired,
561         uint amountAMin,
562         uint amountBMin,
563         address to,
564         uint deadline
565     ) external returns (uint amountA, uint amountB, uint liquidity);
566     function addLiquidityETH(
567         address token,
568         uint amountTokenDesired,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline
573     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
574     function removeLiquidity(
575         address tokenA,
576         address tokenB,
577         uint liquidity,
578         uint amountAMin,
579         uint amountBMin,
580         address to,
581         uint deadline
582     ) external returns (uint amountA, uint amountB);
583     function removeLiquidityETH(
584         address token,
585         uint liquidity,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountToken, uint amountETH);
591     function removeLiquidityWithPermit(
592         address tokenA,
593         address tokenB,
594         uint liquidity,
595         uint amountAMin,
596         uint amountBMin,
597         address to,
598         uint deadline,
599         bool approveMax, uint8 v, bytes32 r, bytes32 s
600     ) external returns (uint amountA, uint amountB);
601     function removeLiquidityETHWithPermit(
602         address token,
603         uint liquidity,
604         uint amountTokenMin,
605         uint amountETHMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountToken, uint amountETH);
610     function swapExactTokensForTokens(
611         uint amountIn,
612         uint amountOutMin,
613         address[] calldata path,
614         address to,
615         uint deadline
616     ) external returns (uint[] memory amounts);
617     function swapTokensForExactTokens(
618         uint amountOut,
619         uint amountInMax,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external returns (uint[] memory amounts);
624     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
625         external
626         payable
627         returns (uint[] memory amounts);
628     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
629         external
630         returns (uint[] memory amounts);
631     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
632         external
633         returns (uint[] memory amounts);
634     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
635         external
636         payable
637         returns (uint[] memory amounts);
638 
639     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
640     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
641     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
642     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
643     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
644 }
645 
646 
647 
648 // pragma solidity >=0.6.2;
649 
650 interface IUniswapV2Router02 is IUniswapV2Router01 {
651     function removeLiquidityETHSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline
658     ) external returns (uint amountETH);
659     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
660         address token,
661         uint liquidity,
662         uint amountTokenMin,
663         uint amountETHMin,
664         address to,
665         uint deadline,
666         bool approveMax, uint8 v, bytes32 r, bytes32 s
667     ) external returns (uint amountETH);
668 
669     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
670         uint amountIn,
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external;
676     function swapExactETHForTokensSupportingFeeOnTransferTokens(
677         uint amountOutMin,
678         address[] calldata path,
679         address to,
680         uint deadline
681     ) external payable;
682     function swapExactTokensForETHSupportingFeeOnTransferTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external;
689 }
690 
691 
692 contract SatoshiDogToken is Context, IERC20, Ownable {
693     using SafeMath for uint256;
694     using Address for address;
695 
696     mapping (address => uint256) private _rOwned;
697     mapping (address => uint256) private _tOwned;
698     mapping (address => mapping (address => uint256)) private _allowances;
699 
700     mapping (address => bool) private _isExcludedFromFee;
701 
702     mapping (address => bool) private _isExcluded;
703     address[] private _excluded;
704    
705     uint256 private constant MAX = ~uint256(0);
706     uint256 private _tTotal = 1000000000000000 * 10**9;
707     uint256 private _rTotal = (MAX - (MAX % _tTotal));
708     uint256 private _tFeeTotal;
709 
710     string private _name = "SatoshiDog";
711     string private _symbol = "STD";
712     uint8 private _decimals = 9;
713     
714     uint256 public _taxFee = 0;
715     uint256 private _previousTaxFee = _taxFee;
716     
717     uint256 public _liquidityFee = 0;
718     uint256 private _previousLiquidityFee = _liquidityFee;
719 
720     uint256 public _burnFee = 0;
721     uint256 private _previousBurnFee = _burnFee;
722 
723     uint256 public _charityFee = 0;
724     address public charityWallet = 0xA5F5bbF736dff96B8A84CebDdA125035FEEFfa4d;
725     uint256 private _previousCharityFee = _charityFee;
726 
727     IUniswapV2Router02 public immutable uniswapV2Router;
728     address public immutable uniswapV2Pair;
729     
730     bool inSwapAndLiquify;
731     bool public swapAndLiquifyEnabled = false;
732     
733     uint256 public _maxTxAmount = 4000000000 * 10**9;
734     uint256 private numTokensSellToAddToLiquidity = 428571428 * 10**9;
735     
736     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
737     event SwapAndLiquifyEnabledUpdated(bool enabled);
738     event SwapAndLiquify(
739         uint256 tokensSwapped,
740         uint256 ethReceived,
741         uint256 tokensIntoLiqudity
742     );
743     
744     modifier lockTheSwap {
745         inSwapAndLiquify = true;
746         _;
747         inSwapAndLiquify = false;
748     }
749     
750     constructor () public {
751         _rOwned[_msgSender()] = _rTotal;
752         
753         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
754          // Create a uniswap pair for this new token
755         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
756             .createPair(address(this), _uniswapV2Router.WETH());
757 
758         // set the rest of the contract variables
759         uniswapV2Router = _uniswapV2Router;
760         
761         //exclude owner and this contract from fee
762         _isExcludedFromFee[owner()] = true;
763         _isExcludedFromFee[address(this)] = true;
764         
765         emit Transfer(address(0), _msgSender(), _tTotal);
766     }
767 
768     function name() public view returns (string memory) {
769         return _name;
770     }
771 
772     function symbol() public view returns (string memory) {
773         return _symbol;
774     }
775 
776     function decimals() public view returns (uint8) {
777         return _decimals;
778     }
779 
780     function totalSupply() public view override returns (uint256) {
781         return _tTotal;
782     }
783 
784     function balanceOf(address account) public view override returns (uint256) {
785         if (_isExcluded[account]) return _tOwned[account];
786         return tokenFromReflection(_rOwned[account]);
787     }
788 
789     function transfer(address recipient, uint256 amount) public override returns (bool) {
790         _transfer(_msgSender(), recipient, amount);
791         return true;
792     }
793 
794     function allowance(address owner, address spender) public view override returns (uint256) {
795         return _allowances[owner][spender];
796     }
797 
798     function approve(address spender, uint256 amount) public override returns (bool) {
799         _approve(_msgSender(), spender, amount);
800         return true;
801     }
802 
803     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
804         _transfer(sender, recipient, amount);
805         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
806         return true;
807     }
808 
809     /**
810      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
811      * @param tokenAddress The token contract address
812      * @param tokenAmount Number of tokens to be sent
813      */
814     function recoverBEP20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
815         IERC20(tokenAddress).transfer(0x7875653C825cBD4591a16e74a5a5d9FB08546820, tokenAmount);
816     }
817 
818     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
820         return true;
821     }
822 
823     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
824         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
825         return true;
826     }
827 
828     function isExcludedFromReward(address account) public view returns (bool) {
829         return _isExcluded[account];
830     }
831 
832     function totalFees() public view returns (uint256) {
833         return _tFeeTotal;
834     }
835 
836     function deliver(uint256 tAmount) public {
837         address sender = _msgSender();
838         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
839         (uint256 rAmount,,,,,) = _getValues(tAmount);
840         _rOwned[sender] = _rOwned[sender].sub(rAmount);
841         _rTotal = _rTotal.sub(rAmount);
842         _tFeeTotal = _tFeeTotal.add(tAmount);
843     }
844 
845     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
846         require(tAmount <= _tTotal, "Amount must be less than supply");
847         if (!deductTransferFee) {
848             (uint256 rAmount,,,,,) = _getValues(tAmount);
849             return rAmount;
850         } else {
851             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
852             return rTransferAmount;
853         }
854     }
855 
856     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
857         require(rAmount <= _rTotal, "Amount must be less than total reflections");
858         uint256 currentRate =  _getRate();
859         return rAmount.div(currentRate);
860     }
861 
862     function excludeFromReward(address account) public onlyOwner() {
863         require(account != 0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F, 'We can not exclude Pancake router.');
864         require(!_isExcluded[account], "Account is already excluded");
865         if(_rOwned[account] > 0) {
866             _tOwned[account] = tokenFromReflection(_rOwned[account]);
867         }
868         _isExcluded[account] = true;
869         _excluded.push(account);
870     }
871 
872     function includeInReward(address account) external onlyOwner() {
873         require(_isExcluded[account], "Account is already excluded");
874         for (uint256 i = 0; i < _excluded.length; i++) {
875             if (_excluded[i] == account) {
876                 _excluded[i] = _excluded[_excluded.length - 1];
877                 _tOwned[account] = 0;
878                 _isExcluded[account] = false;
879                 _excluded.pop();
880                 break;
881             }
882         }
883     }
884 
885     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
886         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
887         _tOwned[sender] = _tOwned[sender].sub(tAmount);
888         _rOwned[sender] = _rOwned[sender].sub(rAmount);
889         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
890         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
891         _takeLiquidity(tLiquidity);
892         _reflectFee(rFee, tFee);
893         emit Transfer(sender, recipient, tTransferAmount);
894     }
895     
896 
897     
898      //to recieve ETH from uniswapV2Router when swaping
899     receive() external payable {}
900 
901     function _reflectFee(uint256 rFee, uint256 tFee) private {
902         _rTotal = _rTotal.sub(rFee);
903         _tFeeTotal = _tFeeTotal.add(tFee);
904     }
905 
906     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
907         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
908         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
909         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
910     }
911 
912     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
913         uint256 tFee = calculateTaxFee(tAmount);
914         uint256 tLiquidity = calculateLiquidityFee(tAmount);
915         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
916         return (tTransferAmount, tFee, tLiquidity);
917     }
918 
919     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
920         uint256 rAmount = tAmount.mul(currentRate);
921         uint256 rFee = tFee.mul(currentRate);
922         uint256 rLiquidity = tLiquidity.mul(currentRate);
923         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
924         return (rAmount, rTransferAmount, rFee);
925     }
926 
927     function _getRate() private view returns(uint256) {
928         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
929         return rSupply.div(tSupply);
930     }
931 
932     function _getCurrentSupply() private view returns(uint256, uint256) {
933         uint256 rSupply = _rTotal;
934         uint256 tSupply = _tTotal;      
935         for (uint256 i = 0; i < _excluded.length; i++) {
936             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
937             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
938             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
939         }
940         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
941         return (rSupply, tSupply);
942     }
943     
944     function _takeLiquidity(uint256 tLiquidity) private {
945         uint256 currentRate =  _getRate();
946         uint256 rLiquidity = tLiquidity.mul(currentRate);
947         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
948         if(_isExcluded[address(this)])
949             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
950     }
951     
952     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
953         return _amount.mul(_taxFee).div(
954             10**2
955         );
956     }
957 
958     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
959         return _amount.mul(_liquidityFee).div(
960             10**2
961         );
962     }
963     
964     function removeAllFee() private {
965         _taxFee = 0;
966         _liquidityFee = 0;
967         _burnFee = 0;
968         _charityFee = 0;
969     }
970     
971     function restoreAllFee() private {
972         _taxFee = 1;
973         _liquidityFee = 0;
974         _burnFee = 1;
975         _charityFee = 1;
976     }
977     
978     function isExcludedFromFee(address account) public view returns(bool) {
979         return _isExcludedFromFee[account];
980     }
981 
982     function _approve(address owner, address spender, uint256 amount) private {
983         require(owner != address(0), "ERC20: approve from the zero address");
984         require(spender != address(0), "ERC20: approve to the zero address");
985 
986         _allowances[owner][spender] = amount;
987         emit Approval(owner, spender, amount);
988     }
989 
990     function _transfer(
991         address from,
992         address to,
993         uint256 amount
994     ) private {
995         require(from != address(0), "ERC20: transfer from the zero address");
996         require(to != address(0), "ERC20: transfer to the zero address");
997         require(amount > 0, "Transfer amount must be greater than zero");
998         
999         if(from != owner() && to != owner())
1000             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1001 
1002         // is the token balance of this contract address over the min number of
1003         // tokens that we need to initiate a swap + liquidity lock?
1004         // also, don't get caught in a circular liquidity event.
1005         // also, don't swap & liquify if sender is uniswap pair.
1006         uint256 contractTokenBalance = balanceOf(address(this));        
1007         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1008         if (
1009             overMinTokenBalance &&
1010             !inSwapAndLiquify &&
1011             from != uniswapV2Pair &&
1012             swapAndLiquifyEnabled
1013         ) {
1014             contractTokenBalance = numTokensSellToAddToLiquidity;
1015             //add liquidity
1016             swapAndLiquify(contractTokenBalance);
1017         }
1018         
1019         //transfer amount, it will take tax, burn, liquidity fee
1020         _tokenTransfer(from,to,amount);
1021     }
1022 
1023     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1024         // split the contract balance into halves
1025         uint256 half = contractTokenBalance.div(2);
1026         uint256 otherHalf = contractTokenBalance.sub(half);
1027 
1028         // capture the contract's current ETH balance.
1029         // this is so that we can capture exactly the amount of ETH that the
1030         // swap creates, and not make the liquidity event include any ETH that
1031         // has been manually sent to the contract
1032         uint256 initialBalance = address(this).balance;
1033 
1034         // swap tokens for ETH
1035         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1036 
1037         // how much ETH did we just swap into?
1038         uint256 newBalance = address(this).balance.sub(initialBalance);
1039 
1040         // add liquidity to uniswap
1041         addLiquidity(otherHalf, newBalance);
1042         
1043         emit SwapAndLiquify(half, newBalance, otherHalf);
1044     }
1045 
1046     function swapTokensForEth(uint256 tokenAmount) private {
1047         // generate the uniswap pair path of token -> weth
1048         address[] memory path = new address[](2);
1049         path[0] = address(this);
1050         path[1] = uniswapV2Router.WETH();
1051 
1052         _approve(address(this), address(uniswapV2Router), tokenAmount);
1053 
1054         // make the swap
1055         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1056             tokenAmount,
1057             0, // accept any amount of ETH
1058             path,
1059             address(this),
1060             block.timestamp
1061         );
1062     }
1063 
1064     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1065         // approve token transfer to cover all possible scenarios
1066         _approve(address(this), address(uniswapV2Router), tokenAmount);
1067 
1068         // add the liquidity
1069         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1070             address(this),
1071             tokenAmount,
1072             0, // slippage is unavoidable
1073             0, // slippage is unavoidable
1074             owner(),
1075             block.timestamp
1076         );
1077     }
1078 
1079     //this method is responsible for taking all fee, if takeFee is true
1080     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
1081         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1082             removeAllFee();
1083         }
1084         else{
1085             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1086         }
1087         
1088         //Calculate burn amount and charity amount
1089         uint256 burnAmt = amount.mul(_burnFee).div(100);
1090         uint256 charityAmt = amount.mul(_charityFee).div(100);
1091 
1092         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1093             _transferFromExcluded(sender, recipient, (amount.sub(burnAmt).sub(charityAmt)));
1094         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1095             _transferToExcluded(sender, recipient, (amount.sub(burnAmt).sub(charityAmt)));
1096         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1097             _transferStandard(sender, recipient, (amount.sub(burnAmt).sub(charityAmt)));
1098         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1099             _transferBothExcluded(sender, recipient, (amount.sub(burnAmt).sub(charityAmt)));
1100         } else {
1101             _transferStandard(sender, recipient, (amount.sub(burnAmt).sub(charityAmt)));
1102         }
1103         
1104         //Temporarily remove fees to transfer to burn address and charity wallet
1105         _taxFee = 0;
1106         _liquidityFee = 0;
1107 
1108         //Send transfers to burn and charity wallet
1109         _transferStandard(sender, address(0), burnAmt);
1110         _transferStandard(sender, charityWallet, charityAmt);
1111 
1112         //Restore tax and liquidity fees
1113         _taxFee = _previousTaxFee;
1114         _liquidityFee = _previousLiquidityFee;
1115 
1116 
1117         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1118             restoreAllFee();
1119     }
1120 
1121     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1122         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1123         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1124         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1125         _takeLiquidity(tLiquidity);
1126         _reflectFee(rFee, tFee);
1127         emit Transfer(sender, recipient, tTransferAmount);
1128     }
1129 
1130     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1131         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1132         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1133         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1134         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1135         _takeLiquidity(tLiquidity);
1136         _reflectFee(rFee, tFee);
1137         emit Transfer(sender, recipient, tTransferAmount);
1138     }
1139 
1140     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1141         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1142         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1143         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1144         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1145         _takeLiquidity(tLiquidity);
1146         _reflectFee(rFee, tFee);
1147         emit Transfer(sender, recipient, tTransferAmount);
1148     }
1149 
1150     function excludeFromFee(address account) public onlyOwner {
1151         _isExcludedFromFee[account] = true;
1152     }
1153     
1154     function includeInFee(address account) public onlyOwner {
1155         _isExcludedFromFee[account] = false;
1156     }
1157     
1158     //Call this function after finalizing the presale on DxSale
1159     function enableAllFees() external onlyOwner() {
1160         _taxFee = 1;
1161         _previousTaxFee = _taxFee;
1162         _liquidityFee = 0;
1163         _previousLiquidityFee = _liquidityFee;
1164         _burnFee = 1;
1165         _previousBurnFee = _taxFee;
1166         _charityFee = 1;
1167         _previousCharityFee = _charityFee;
1168         inSwapAndLiquify = true;
1169         emit SwapAndLiquifyEnabledUpdated(true);
1170     }
1171 
1172     function setCharityWallet(address newWallet) external onlyOwner() {
1173         charityWallet = newWallet;
1174     }
1175    
1176     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1177         require(maxTxPercent > 10, "Cannot set transaction amount less than 10 percent!");
1178         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1179             10**2
1180         );
1181     }
1182 
1183     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1184         swapAndLiquifyEnabled = _enabled;
1185         emit SwapAndLiquifyEnabledUpdated(_enabled);
1186     }
1187 }