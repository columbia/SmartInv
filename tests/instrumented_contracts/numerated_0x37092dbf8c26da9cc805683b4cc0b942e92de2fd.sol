1 /**
2  *Submitted for verification at EthScan.com on 2021-05-11
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 
7 /**
8  *
9  * Blue-Eyes White Doge
10  * Telegram: https://t.me/bdogenet
11  * A token with 6% tax at every transaction:
12  * 3% distribution
13  * 3% liquidity swap
14  * 
15  */
16 
17 pragma solidity ^0.6.12;
18 
19 interface IERC20 {
20 
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103  
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address payable) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes memory) {
253         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
254         return msg.data;
255     }
256 }
257 
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 /**
398  * @dev Contract module which provides a basic access control mechanism, where
399  * there is an account (an owner) that can be granted exclusive access to
400  * specific functions.
401  *
402  * By default, the owner account will be the one that deploys the contract. This
403  * can later be changed with {transferOwnership}.
404  *
405  * This module is used through inheritance. It will make available the modifier
406  * `onlyOwner`, which can be applied to your functions to restrict their use to
407  * the owner.
408  */
409 contract Ownable is Context {
410     address private _owner;
411     address private _previousOwner;
412     uint256 private _lockTime;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor () internal {
420         address msgSender = _msgSender();
421         _owner = msgSender;
422         emit OwnershipTransferred(address(0), msgSender);
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(_owner == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440      /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 
462     function getUnlockTime() public view returns (uint256) {
463         return _lockTime;
464     }
465 
466     //Locks the contract for owner for the amount of time provided
467     function lock(uint256 time) public virtual onlyOwner {
468         _previousOwner = _owner;
469         _owner = address(0);
470         _lockTime = now + time;
471         emit OwnershipTransferred(_owner, address(0));
472     }
473     
474     //Unlocks the contract for owner when _lockTime is exceeds
475     function unlock() public virtual {
476         require(_previousOwner == msg.sender, "You don't have permission to unlock");
477         require(now > _lockTime , "Contract is locked until 7 days");
478         emit OwnershipTransferred(_owner, _previousOwner);
479         _owner = _previousOwner;
480     }
481 }
482 
483 // pragma solidity >=0.5.0;
484 
485 interface IUniswapV2Factory {
486     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
487 
488     function feeTo() external view returns (address);
489     function feeToSetter() external view returns (address);
490 
491     function getPair(address tokenA, address tokenB) external view returns (address pair);
492     function allPairs(uint) external view returns (address pair);
493     function allPairsLength() external view returns (uint);
494 
495     function createPair(address tokenA, address tokenB) external returns (address pair);
496 
497     function setFeeTo(address) external;
498     function setFeeToSetter(address) external;
499 }
500 
501 
502 // pragma solidity >=0.5.0;
503 
504 interface IUniswapV2Pair {
505     event Approval(address indexed owner, address indexed spender, uint value);
506     event Transfer(address indexed from, address indexed to, uint value);
507 
508     function name() external pure returns (string memory);
509     function symbol() external pure returns (string memory);
510     function decimals() external pure returns (uint8);
511     function totalSupply() external view returns (uint);
512     function balanceOf(address owner) external view returns (uint);
513     function allowance(address owner, address spender) external view returns (uint);
514 
515     function approve(address spender, uint value) external returns (bool);
516     function transfer(address to, uint value) external returns (bool);
517     function transferFrom(address from, address to, uint value) external returns (bool);
518 
519     function DOMAIN_SEPARATOR() external view returns (bytes32);
520     function PERMIT_TYPEHASH() external pure returns (bytes32);
521     function nonces(address owner) external view returns (uint);
522 
523     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
524 
525     event Mint(address indexed sender, uint amount0, uint amount1);
526     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
527     event Swap(
528         address indexed sender,
529         uint amount0In,
530         uint amount1In,
531         uint amount0Out,
532         uint amount1Out,
533         address indexed to
534     );
535     event Sync(uint112 reserve0, uint112 reserve1);
536 
537     function MINIMUM_LIQUIDITY() external pure returns (uint);
538     function factory() external view returns (address);
539     function token0() external view returns (address);
540     function token1() external view returns (address);
541     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
542     function price0CumulativeLast() external view returns (uint);
543     function price1CumulativeLast() external view returns (uint);
544     function kLast() external view returns (uint);
545 
546     function mint(address to) external returns (uint liquidity);
547     function burn(address to) external returns (uint amount0, uint amount1);
548     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
549     function skim(address to) external;
550     function sync() external;
551 
552     function initialize(address, address) external;
553 }
554 
555 // pragma solidity >=0.6.2;
556 
557 interface IUniswapV2Router01 {
558     function factory() external pure returns (address);
559     function WETH() external pure returns (address);
560 
561     function addLiquidity(
562         address tokenA,
563         address tokenB,
564         uint amountADesired,
565         uint amountBDesired,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline
570     ) external returns (uint amountA, uint amountB, uint liquidity);
571     function addLiquidityETH(
572         address token,
573         uint amountTokenDesired,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline
578     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
579     function removeLiquidity(
580         address tokenA,
581         address tokenB,
582         uint liquidity,
583         uint amountAMin,
584         uint amountBMin,
585         address to,
586         uint deadline
587     ) external returns (uint amountA, uint amountB);
588     function removeLiquidityETH(
589         address token,
590         uint liquidity,
591         uint amountTokenMin,
592         uint amountETHMin,
593         address to,
594         uint deadline
595     ) external returns (uint amountToken, uint amountETH);
596     function removeLiquidityWithPermit(
597         address tokenA,
598         address tokenB,
599         uint liquidity,
600         uint amountAMin,
601         uint amountBMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountA, uint amountB);
606     function removeLiquidityETHWithPermit(
607         address token,
608         uint liquidity,
609         uint amountTokenMin,
610         uint amountETHMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountToken, uint amountETH);
615     function swapExactTokensForTokens(
616         uint amountIn,
617         uint amountOutMin,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external returns (uint[] memory amounts);
622     function swapTokensForExactTokens(
623         uint amountOut,
624         uint amountInMax,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external returns (uint[] memory amounts);
629     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
630         external
631         payable
632         returns (uint[] memory amounts);
633     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
634         external
635         returns (uint[] memory amounts);
636     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
637         external
638         returns (uint[] memory amounts);
639     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
640         external
641         payable
642         returns (uint[] memory amounts);
643 
644     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
645     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
646     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
647     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
648     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
649 }
650 
651 
652 
653 // pragma solidity >=0.6.2;
654 
655 interface IUniswapV2Router02 is IUniswapV2Router01 {
656     function removeLiquidityETHSupportingFeeOnTransferTokens(
657         address token,
658         uint liquidity,
659         uint amountTokenMin,
660         uint amountETHMin,
661         address to,
662         uint deadline
663     ) external returns (uint amountETH);
664     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountETH);
673 
674     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681     function swapExactETHForTokensSupportingFeeOnTransferTokens(
682         uint amountOutMin,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external payable;
687     function swapExactTokensForETHSupportingFeeOnTransferTokens(
688         uint amountIn,
689         uint amountOutMin,
690         address[] calldata path,
691         address to,
692         uint deadline
693     ) external;
694 }
695 
696 
697 contract bDOGE is Context, IERC20, Ownable {
698     
699     using SafeMath for uint256;
700     using Address for address;
701 
702     mapping (address => uint256) private _rOwned;
703     mapping (address => uint256) private _tOwned;
704     mapping (address => mapping (address => uint256)) private _allowances;
705 
706     mapping (address => bool) private _isExcludedFromFee;
707     mapping (address => bool) private _isExcluded;
708     address[] private _excluded;
709     
710     //  100,000,000,000 total supply (100%)
711     //      500,000,000 max transaction (0.5%)
712     //       50,000,000 to add to liquidity (0.05%)
713     
714     string  private _name       = "Blue-Eyes White Doge";
715     string  private _symbol     = "bDOGE";
716     uint8   private _decimals   = 9;
717    
718     uint256 private constant MAX    = ~uint256(0);
719     uint256 private _tTotal         = 100000 * 10**6 * 10**9; //100 Billion
720     uint256 private _rTotal         = (MAX - (MAX % _tTotal));
721     
722     uint256 private _tFeeTotal;
723     uint256 private _tBurnTotal;
724     
725     uint256 public _taxFee = 3;
726     uint256 private _previousTaxFee = _taxFee;
727     
728     uint256 public _burnFee = 0;
729     uint256 private _previousBurnFee = _burnFee;
730     
731     uint256 public _liquidityFee = 3;
732     uint256 private _previousLiquidityFee = _liquidityFee;
733 
734     IUniswapV2Router02 public immutable uniswapV2Router;
735     address public immutable uniswapV2Pair;
736     
737     bool inSwapAndLiquify;
738     bool public swapAndLiquifyEnabled = true;
739     
740     uint256 public _maxTxAmount = 500 * 10**6 * 10**9; // 0.5 Billion
741     uint256 private numTokensSellToAddToLiquidity = 50 * 10**6 * 10**9; // 50 Million
742     
743     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
744     event SwapAndLiquifyEnabledUpdated(bool enabled);
745     event SwapAndLiquify(
746         uint256 tokensSwapped,
747         uint256 ethReceived,
748         uint256 tokensIntoLiqudity
749     );
750     
751     modifier lockTheSwap {
752         inSwapAndLiquify = true;
753         _;
754         inSwapAndLiquify = false;
755     }
756     
757     constructor () public {
758         _rOwned[_msgSender()] = _rTotal;
759         
760         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
761          // Create a uniswap pair for this new token
762         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
763             .createPair(address(this), _uniswapV2Router.WETH());
764 
765         // set the rest of the contract variables
766         uniswapV2Router = _uniswapV2Router;
767         
768         //exclude owner and this contract from fee
769         _isExcludedFromFee[owner()] = true;
770         _isExcludedFromFee[address(this)] = true;
771         
772         emit Transfer(address(0), _msgSender(), _tTotal);
773     }
774 
775     function name() public view returns (string memory) {
776         return _name;
777     }
778 
779     function symbol() public view returns (string memory) {
780         return _symbol;
781     }
782 
783     function decimals() public view returns (uint8) {
784         return _decimals;
785     }
786 
787     function totalSupply() public view override returns (uint256) {
788         return _tTotal;
789     }
790 
791     function balanceOf(address account) public view override returns (uint256) {
792         if (_isExcluded[account]) return _tOwned[account];
793         return tokenFromReflection(_rOwned[account]);
794     }
795 
796     function transfer(address recipient, uint256 amount) public override returns (bool) {
797         _transfer(_msgSender(), recipient, amount);
798         return true;
799     }
800 
801     function allowance(address owner, address spender) public view override returns (uint256) {
802         return _allowances[owner][spender];
803     }
804 
805     function approve(address spender, uint256 amount) public override returns (bool) {
806         _approve(_msgSender(), spender, amount);
807         return true;
808     }
809 
810     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
811         _transfer(sender, recipient, amount);
812         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
813         return true;
814     }
815 
816     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
817         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
818         return true;
819     }
820 
821     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
822         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
823         return true;
824     }
825 
826     function isExcludedFromReward(address account) public view returns (bool) {
827         return _isExcluded[account];
828     }
829 
830     function totalFees() public view returns (uint256) {
831         return _tFeeTotal;
832     }
833     
834     function totalBurn() public view returns (uint256) {
835         return _tBurnTotal;
836     }
837 
838     function deliver(uint256 tAmount) public {
839         address sender = _msgSender();
840         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
841         (uint256 rAmount,,,,,,) = _getValues(tAmount);
842         _rOwned[sender] = _rOwned[sender].sub(rAmount);
843         _rTotal = _rTotal.sub(rAmount);
844         _tFeeTotal = _tFeeTotal.add(tAmount);
845     }
846 
847     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
848         require(tAmount <= _tTotal, "Amount must be less than supply");
849         if (!deductTransferFee) {
850             (uint256 rAmount,,,,,,) = _getValues(tAmount);
851             return rAmount;
852         } else {
853             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
854             return rTransferAmount;
855         }
856     }
857 
858     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
859         require(rAmount <= _rTotal, "Amount must be less than total reflections");
860         uint256 currentRate =  _getRate();
861         return rAmount.div(currentRate);
862     }
863 
864     function excludeFromReward(address account) public onlyOwner() {
865         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
866         require(!_isExcluded[account], "Account is already excluded");
867         if(_rOwned[account] > 0) {
868             _tOwned[account] = tokenFromReflection(_rOwned[account]);
869         }
870         _isExcluded[account] = true;
871         _excluded.push(account);
872     }
873 
874     function includeInReward(address account) external onlyOwner() {
875         require(_isExcluded[account], "Account is already excluded");
876         for (uint256 i = 0; i < _excluded.length; i++) {
877             if (_excluded[i] == account) {
878                 _excluded[i] = _excluded[_excluded.length - 1];
879                 _tOwned[account] = 0;
880                 _isExcluded[account] = false;
881                 _excluded.pop();
882                 break;
883             }
884         }
885     }
886     
887     function excludeFromFee(address account) public onlyOwner {
888         _isExcludedFromFee[account] = true;
889     }
890     
891     function includeInFee(address account) public onlyOwner {
892         _isExcludedFromFee[account] = false;
893     }
894     
895     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
896         _taxFee = taxFee;
897     }
898     
899     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
900         _liquidityFee = liquidityFee;
901     }
902     
903     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
904         _burnFee = burnFee;
905     }
906    
907     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
908         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
909     }
910 
911     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
912         swapAndLiquifyEnabled = _enabled;
913         emit SwapAndLiquifyEnabledUpdated(_enabled);
914     }
915     
916      //to recieve ETH from uniswapV2Router when swaping
917     receive() external payable {}
918 
919     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
920         _rTotal = _rTotal.sub(rFee).sub(rBurn);
921         _tFeeTotal = _tFeeTotal.add(tFee);
922         _tBurnTotal = _tBurnTotal.add(tBurn);
923         _tTotal = _tTotal.sub(tBurn);
924     }
925 
926     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
927         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getTValues(tAmount);
928         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
929         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
930     }
931 
932     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
933         uint256 tFee = calculateTaxFee(tAmount);
934         uint256 tBurn = calculateBurnFee(tAmount);
935         uint256 tLiquidity = calculateLiquidityFee(tAmount);
936         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
937         return (tTransferAmount, tFee, tBurn, tLiquidity);
938     }
939 
940     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
941         uint256 rAmount = tAmount.mul(currentRate);
942         uint256 rFee = tFee.mul(currentRate);
943         uint256 rBurn = tBurn.mul(currentRate);
944         uint256 rLiquidity = tLiquidity.mul(currentRate);
945         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rLiquidity);
946         return (rAmount, rTransferAmount, rFee);
947     }
948 
949     function _getRate() private view returns(uint256) {
950         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
951         return rSupply.div(tSupply);
952     }
953 
954     function _getCurrentSupply() private view returns(uint256, uint256) {
955         uint256 rSupply = _rTotal;
956         uint256 tSupply = _tTotal;      
957         for (uint256 i = 0; i < _excluded.length; i++) {
958             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
959             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
960             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
961         }
962         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
963         return (rSupply, tSupply);
964     }
965     
966     function _takeLiquidity(uint256 tLiquidity) private {
967         uint256 currentRate =  _getRate();
968         uint256 rLiquidity = tLiquidity.mul(currentRate);
969         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
970         if(_isExcluded[address(this)])
971             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
972     }
973     
974     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
975         return _amount.mul(_taxFee).div(10**2);
976     }
977 
978     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
979         return _amount.mul(_burnFee).div(10**2);
980     }
981 
982     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
983         return _amount.mul(_liquidityFee).div(10**2);
984     }
985     
986     function removeAllFee() private {
987         if(_taxFee == 0 && _burnFee == 0 && _liquidityFee == 0) return;
988         
989         _previousTaxFee = _taxFee;
990         _previousBurnFee = _burnFee;
991         _previousLiquidityFee = _liquidityFee;
992         
993         _taxFee = 0;
994         _burnFee = 0;
995         _liquidityFee = 0;
996     }
997     
998     function restoreAllFee() private {
999         _taxFee = _previousTaxFee;
1000         _burnFee = _previousBurnFee;
1001         _liquidityFee = _previousLiquidityFee;
1002     }
1003     
1004     function isExcludedFromFee(address account) public view returns(bool) {
1005         return _isExcludedFromFee[account];
1006     }
1007 
1008     function _approve(address owner, address spender, uint256 amount) private {
1009         require(owner != address(0), "ERC20: approve from the zero address");
1010         require(spender != address(0), "ERC20: approve to the zero address");
1011 
1012         _allowances[owner][spender] = amount;
1013         emit Approval(owner, spender, amount);
1014     }
1015 
1016     function _transfer(
1017         address from,
1018         address to,
1019         uint256 amount
1020     ) private {
1021         require(from != address(0), "ERC20: transfer from the zero address");
1022         require(to != address(0), "ERC20: transfer to the zero address");
1023         require(amount > 0, "Transfer amount must be greater than zero");
1024         if(from != owner() && to != owner())
1025             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1026 
1027         // is the token balance of this contract address over the min number of
1028         // tokens that we need to initiate a swap + liquidity lock?
1029         // also, don't get caught in a circular liquidity event.
1030         // also, don't swap & liquify if sender is uniswap pair.
1031         uint256 contractTokenBalance = balanceOf(address(this));
1032         
1033         if(contractTokenBalance >= _maxTxAmount)
1034         {
1035             contractTokenBalance = _maxTxAmount;
1036         }
1037         
1038         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1039         if (
1040             overMinTokenBalance &&
1041             !inSwapAndLiquify &&
1042             from != uniswapV2Pair &&
1043             swapAndLiquifyEnabled
1044         ) {
1045             contractTokenBalance = numTokensSellToAddToLiquidity;
1046             //add liquidity
1047             swapAndLiquify(contractTokenBalance);
1048         }
1049         
1050         //indicates if fee should be deducted from transfer
1051         bool takeFee = true;
1052         
1053         //if any account belongs to _isExcludedFromFee account then remove the fee
1054         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1055             takeFee = false;
1056         }
1057         
1058         //transfer amount, it will take tax, burn, liquidity fee
1059         _tokenTransfer(from,to,amount,takeFee);
1060     }
1061 
1062     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1063         // split the contract balance into halves
1064         uint256 half = contractTokenBalance.div(2);
1065         uint256 otherHalf = contractTokenBalance.sub(half);
1066 
1067         // capture the contract's current ETH balance.
1068         // this is so that we can capture exactly the amount of ETH that the
1069         // swap creates, and not make the liquidity event include any ETH that
1070         // has been manually sent to the contract
1071         uint256 initialBalance = address(this).balance;
1072 
1073         // swap tokens for ETH
1074         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1075 
1076         // how much ETH did we just swap into?
1077         uint256 newBalance = address(this).balance.sub(initialBalance);
1078 
1079         // add liquidity to uniswap
1080         addLiquidity(otherHalf, newBalance);
1081         
1082         emit SwapAndLiquify(half, newBalance, otherHalf);
1083     }
1084 
1085     function swapTokensForEth(uint256 tokenAmount) private {
1086         // generate the uniswap pair path of token -> weth
1087         address[] memory path = new address[](2);
1088         path[0] = address(this);
1089         path[1] = uniswapV2Router.WETH();
1090 
1091         _approve(address(this), address(uniswapV2Router), tokenAmount);
1092 
1093         // make the swap
1094         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1095             tokenAmount,
1096             0, // accept any amount of ETH
1097             path,
1098             address(this),
1099             block.timestamp
1100         );
1101     }
1102 
1103     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1104         // approve token transfer to cover all possible scenarios
1105         _approve(address(this), address(uniswapV2Router), tokenAmount);
1106 
1107         // add the liquidity
1108         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1109             address(this),
1110             tokenAmount,
1111             0, // slippage is unavoidable
1112             0, // slippage is unavoidable
1113             owner(),
1114             block.timestamp
1115         );
1116     }
1117 
1118     //this method is responsible for taking all fee, if takeFee is true
1119     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1120         if(!takeFee)
1121             removeAllFee();
1122         
1123         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1124             _transferFromExcluded(sender, recipient, amount);
1125         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1126             _transferToExcluded(sender, recipient, amount);
1127         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1128             _transferStandard(sender, recipient, amount);
1129         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1130             _transferBothExcluded(sender, recipient, amount);
1131         } else {
1132             _transferStandard(sender, recipient, amount);
1133         }
1134         
1135         if(!takeFee)
1136             restoreAllFee();
1137     }
1138 
1139     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1140         uint256 currentRate =  _getRate();
1141         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1142          uint256 rBurn =  tBurn.mul(currentRate);
1143         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1144         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1145         _takeLiquidity(tLiquidity);
1146         _reflectFee(rFee, rBurn, tFee, tBurn);
1147         emit Transfer(sender, recipient, tTransferAmount);
1148     }
1149 
1150     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1151         uint256 currentRate =  _getRate();
1152         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1153         uint256 rBurn =  tBurn.mul(currentRate);
1154         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1155         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1157         _takeLiquidity(tLiquidity);
1158         _reflectFee(rFee, rBurn, tFee, tBurn);
1159         emit Transfer(sender, recipient, tTransferAmount);
1160     }
1161 
1162     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1163         uint256 currentRate =  _getRate();
1164         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1165         uint256 rBurn =  tBurn.mul(currentRate);
1166         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1167         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1168         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1169         _takeLiquidity(tLiquidity);
1170         _reflectFee(rFee, rBurn, tFee, tBurn);
1171         emit Transfer(sender, recipient, tTransferAmount);
1172     }
1173     
1174     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1175         uint256 currentRate =  _getRate();
1176         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1177         uint256 rBurn =  tBurn.mul(currentRate);
1178         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1179         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1180         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1181         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1182         _takeLiquidity(tLiquidity);
1183         _reflectFee(rFee, rBurn, tFee, tBurn);
1184         emit Transfer(sender, recipient, tTransferAmount);
1185     }
1186 
1187 }