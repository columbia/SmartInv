1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-03
3 */
4 
5 /**
6 
7 Manifesto. Read my Manifesto. I`ve written a Manifesto. It`s all in the Manifesto!
8 
9 #readthemanifesto and you will understand.
10 
11 Trust me, it’s not diffiCULT, do it while your FATE is still in your own hands…
12 
13 */
14 
15 pragma solidity ^0.8.9;
16 // SPDX-License-Identifier: Unlicensed
17 interface IERC20 {
18 
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101  
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      *
111      * - Addition cannot overflow.
112      */
113     function add(uint256 a, uint256 b) internal pure returns (uint256) {
114         uint256 c = a + b;
115         require(c >= a, "SafeMath: addition overflow");
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return sub(a, b, "SafeMath: subtraction overflow");
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145         require(b <= a, errorMessage);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `*` operator.
156      *
157      * Requirements:
158      *
159      * - Multiplication cannot overflow.
160      */
161     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) {
166             return 0;
167         }
168 
169         uint256 c = a * b;
170         require(c / a == b, "SafeMath: multiplication overflow");
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b) internal pure returns (uint256) {
188         return div(a, b, "SafeMath: division by zero");
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204         require(b > 0, errorMessage);
205         uint256 c = a / b;
206         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224         return mod(a, b, "SafeMath: modulo by zero");
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts with custom message when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b != 0, errorMessage);
241         return a % b;
242     }
243 }
244 
245 abstract contract Context {
246     //function _msgSender() internal view virtual returns (address payable) {
247     function _msgSender() internal view virtual returns (address) {
248         return msg.sender;
249     }
250 
251     function _msgData() internal view virtual returns (bytes memory) {
252         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
253         return msg.data;
254     }
255 }
256 
257 
258 /**
259  * @dev Collection of functions related to the address type
260  */
261 library Address {
262     /**
263      * @dev Returns true if `account` is a contract.
264      *
265      * [IMPORTANT]
266      * ====
267      * It is unsafe to assume that an address for which this function returns
268      * false is an externally-owned account (EOA) and not a contract.
269      *
270      * Among others, `isContract` will return false for the following
271      * types of addresses:
272      *
273      *  - an externally-owned account
274      *  - a contract in construction
275      *  - an address where a contract will be created
276      *  - an address where a contract lived, but was destroyed
277      * ====
278      */
279     function isContract(address account) internal view returns (bool) {
280         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282         // for accounts without code, i.e. `keccak256('')`
283         bytes32 codehash;
284         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { codehash := extcodehash(account) }
287         return (codehash != accountHash && codehash != 0x0);
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310         (bool success, ) = recipient.call{ value: amount }("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain`call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333       return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
343         return _functionCallWithValue(target, data, 0, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but also transferring `value` wei to `target`.
349      *
350      * Requirements:
351      *
352      * - the calling contract must have an ETH balance of at least `value`.
353      * - the called Solidity function must be `payable`.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
368         require(address(this).balance >= value, "Address: insufficient balance for call");
369         return _functionCallWithValue(target, data, value, errorMessage);
370     }
371 
372     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
373         require(isContract(target), "Address: call to non-contract");
374 
375         // solhint-disable-next-line avoid-low-level-calls
376         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
377         if (success) {
378             return returndata;
379         } else {
380             // Look for revert reason and bubble it up if present
381             if (returndata.length > 0) {
382                 // The easiest way to bubble the revert reason is using memory via assembly
383 
384                 // solhint-disable-next-line no-inline-assembly
385                 assembly {
386                     let returndata_size := mload(returndata)
387                     revert(add(32, returndata), returndata_size)
388                 }
389             } else {
390                 revert(errorMessage);
391             }
392         }
393     }
394 }
395 
396 /**
397  * @dev Contract module which provides a basic access control mechanism, where
398  * there is an account (an owner) that can be granted exclusive access to
399  * specific functions.
400  *
401  * By default, the owner account will be the one that deploys the contract. This
402  * can later be changed with {transferOwnership}.
403  *
404  * This module is used through inheritance. It will make available the modifier
405  * `onlyOwner`, which can be applied to your functions to restrict their use to
406  * the owner.
407  */
408 contract Ownable is Context {
409     address private _owner;
410     address private _previousOwner;
411     uint256 private _lockTime;
412 
413     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
414 
415     /**
416      * @dev Initializes the contract setting the deployer as the initial owner.
417      */
418     constructor () {
419         address msgSender = _msgSender();
420         _owner = msgSender;
421         emit OwnershipTransferred(address(0), msgSender);
422     }
423 
424     /**
425      * @dev Returns the address of the current owner.
426      */
427     function owner() public view returns (address) {
428         return _owner;
429     }
430 
431     /**
432      * @dev Throws if called by any account other than the owner.
433      */
434     modifier onlyOwner() {
435         require(_owner == _msgSender(), "Ownable: caller is not the owner");
436         _;
437     }
438 
439      /**
440      * @dev Leaves the contract without owner. It will not be possible to call
441      * `onlyOwner` functions anymore. Can only be called by the current owner.
442      *
443      * NOTE: Renouncing ownership will leave the contract without an owner,
444      * thereby removing any functionality that is only available to the owner.
445      */
446     function renounceOwnership() public virtual onlyOwner {
447         emit OwnershipTransferred(_owner, address(0));
448         _owner = address(0);
449     }
450 
451     /**
452      * @dev Transfers ownership of the contract to a new account (`newOwner`).
453      * Can only be called by the current owner.
454      */
455     function transferOwnership(address newOwner) public virtual onlyOwner {
456         require(newOwner != address(0), "Ownable: new owner is the zero address");
457         emit OwnershipTransferred(_owner, newOwner);
458         _owner = newOwner;
459     }
460 
461     function geUnlockTime() public view returns (uint256) {
462         return _lockTime;
463     }
464 
465     //Locks the contract for owner for the amount of time provided
466     function lock(uint256 time) public virtual onlyOwner {
467         _previousOwner = _owner;
468         _owner = address(0);
469         _lockTime = block.timestamp + time;
470         emit OwnershipTransferred(_owner, address(0));
471     }
472     
473     //Unlocks the contract for owner when _lockTime is exceeds
474     function unlock() public virtual {
475         require(_previousOwner == msg.sender, "You don't have permission to unlock");
476         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
477         emit OwnershipTransferred(_owner, _previousOwner);
478         _owner = _previousOwner;
479     }
480 }
481 
482 
483 interface IUniswapV2Factory {
484     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
485 
486     function feeTo() external view returns (address);
487     function feeToSetter() external view returns (address);
488 
489     function getPair(address tokenA, address tokenB) external view returns (address pair);
490     function allPairs(uint) external view returns (address pair);
491     function allPairsLength() external view returns (uint);
492 
493     function createPair(address tokenA, address tokenB) external returns (address pair);
494 
495     function setFeeTo(address) external;
496     function setFeeToSetter(address) external;
497 }
498 
499 
500 
501 interface IUniswapV2Pair {
502     event Approval(address indexed owner, address indexed spender, uint value);
503     event Transfer(address indexed from, address indexed to, uint value);
504 
505     function name() external pure returns (string memory);
506     function symbol() external pure returns (string memory);
507     function decimals() external pure returns (uint8);
508     function totalSupply() external view returns (uint);
509     function balanceOf(address owner) external view returns (uint);
510     function allowance(address owner, address spender) external view returns (uint);
511 
512     function approve(address spender, uint value) external returns (bool);
513     function transfer(address to, uint value) external returns (bool);
514     function transferFrom(address from, address to, uint value) external returns (bool);
515 
516     function DOMAIN_SEPARATOR() external view returns (bytes32);
517     function PERMIT_TYPEHASH() external pure returns (bytes32);
518     function nonces(address owner) external view returns (uint);
519 
520     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
521 
522     event Mint(address indexed sender, uint amount0, uint amount1);
523     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
524     event Swap(
525         address indexed sender,
526         uint amount0In,
527         uint amount1In,
528         uint amount0Out,
529         uint amount1Out,
530         address indexed to
531     );
532     event Sync(uint112 reserve0, uint112 reserve1);
533 
534     function MINIMUM_LIQUIDITY() external pure returns (uint);
535     function factory() external view returns (address);
536     function token0() external view returns (address);
537     function token1() external view returns (address);
538     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
539     function price0CumulativeLast() external view returns (uint);
540     function price1CumulativeLast() external view returns (uint);
541     function kLast() external view returns (uint);
542 
543     function mint(address to) external returns (uint liquidity);
544     function burn(address to) external returns (uint amount0, uint amount1);
545     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
546     function skim(address to) external;
547     function sync() external;
548 
549     function initialize(address, address) external;
550 }
551 
552 
553 interface IUniswapV2Router01 {
554     function factory() external pure returns (address);
555     function WETH() external pure returns (address);
556 
557     function addLiquidity(
558         address tokenA,
559         address tokenB,
560         uint amountADesired,
561         uint amountBDesired,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline
566     ) external returns (uint amountA, uint amountB, uint liquidity);
567     function addLiquidityETH(
568         address token,
569         uint amountTokenDesired,
570         uint amountTokenMin,
571         uint amountETHMin,
572         address to,
573         uint deadline
574     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
575     function removeLiquidity(
576         address tokenA,
577         address tokenB,
578         uint liquidity,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountA, uint amountB);
584     function removeLiquidityETH(
585         address token,
586         uint liquidity,
587         uint amountTokenMin,
588         uint amountETHMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountToken, uint amountETH);
592     function removeLiquidityWithPermit(
593         address tokenA,
594         address tokenB,
595         uint liquidity,
596         uint amountAMin,
597         uint amountBMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns (uint amountA, uint amountB);
602     function removeLiquidityETHWithPermit(
603         address token,
604         uint liquidity,
605         uint amountTokenMin,
606         uint amountETHMin,
607         address to,
608         uint deadline,
609         bool approveMax, uint8 v, bytes32 r, bytes32 s
610     ) external returns (uint amountToken, uint amountETH);
611     function swapExactTokensForTokens(
612         uint amountIn,
613         uint amountOutMin,
614         address[] calldata path,
615         address to,
616         uint deadline
617     ) external returns (uint[] memory amounts);
618     function swapTokensForExactTokens(
619         uint amountOut,
620         uint amountInMax,
621         address[] calldata path,
622         address to,
623         uint deadline
624     ) external returns (uint[] memory amounts);
625     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
626         external
627         payable
628         returns (uint[] memory amounts);
629     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
630         external
631         returns (uint[] memory amounts);
632     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
633         external
634         returns (uint[] memory amounts);
635     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
636         external
637         payable
638         returns (uint[] memory amounts);
639 
640     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
641     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
642     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
643     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
644     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
645 }
646 
647 
648 
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
691 interface IAirdrop {
692     function airdrop(address recipient, uint256 amount) external;
693 }
694 
695 contract MANIFESTO is Context, IERC20, Ownable {
696     using SafeMath for uint256;
697     using Address for address;
698 
699     mapping (address => uint256) private _rOwned;
700     mapping (address => uint256) private _tOwned;
701     mapping (address => mapping (address => uint256)) private _allowances;
702 
703     mapping (address => bool) private _isExcludedFromFee;
704 
705     mapping (address => bool) private _isExcluded;
706     address[] private _excluded;
707     
708     mapping (address => bool) private botWallets;
709     bool botscantrade = false;
710     
711     bool public canTrade = false;
712    
713     uint256 private constant MAX = ~uint256(0);
714     uint256 private _tTotal = 6666666666666 * 10**9;
715     uint256 private _rTotal = (MAX - (MAX % _tTotal));
716     uint256 private _tFeeTotal;
717     address public marketingWallet;
718 
719     string private _name = "MANIFESTO";
720     string private _symbol = "MANIFESTO";
721     uint8 private _decimals = 9;
722     
723     uint256 public _taxFee = 0;
724     uint256 private _previousTaxFee = _taxFee;
725 
726     uint256 public marketingFeePercent = 0;
727     
728     uint256 public _liquidityFee = 6;
729     uint256 private _previousLiquidityFee = _liquidityFee;
730 
731     IUniswapV2Router02 public immutable uniswapV2Router;
732     address public immutable uniswapV2Pair;
733     
734     bool inSwapAndLiquify;
735     bool public swapAndLiquifyEnabled = true;
736     
737     uint256 public _maxTxAmount = 33333333333 * 10**9;
738     uint256 public numTokensSellToAddToLiquidity = 66666666666 * 10**9;
739     uint256 public _maxWalletSize = 66666666666 * 10**9;
740     
741     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
742     event SwapAndLiquifyEnabledUpdated(bool enabled);
743     event SwapAndLiquify(
744         uint256 tokensSwapped,
745         uint256 ethReceived,
746         uint256 tokensIntoLiqudity
747     );
748     
749     modifier lockTheSwap {
750         inSwapAndLiquify = true;
751         _;
752         inSwapAndLiquify = false;
753     }
754     
755     constructor () {
756         _rOwned[_msgSender()] = _rTotal;
757         
758         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
759          // Create a uniswap pair for this new token
760         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
761             .createPair(address(this), _uniswapV2Router.WETH());
762 
763         // set the rest of the contract variables
764         uniswapV2Router = _uniswapV2Router;
765         
766         //exclude owner and this contract from fee
767         _isExcludedFromFee[owner()] = true;
768         _isExcludedFromFee[address(this)] = true;
769         
770         emit Transfer(address(0), _msgSender(), _tTotal);
771     }
772 
773     function name() public view returns (string memory) {
774         return _name;
775     }
776 
777     function symbol() public view returns (string memory) {
778         return _symbol;
779     }
780 
781     function decimals() public view returns (uint8) {
782         return _decimals;
783     }
784 
785     function totalSupply() public view override returns (uint256) {
786         return _tTotal;
787     }
788 
789     function balanceOf(address account) public view override returns (uint256) {
790         if (_isExcluded[account]) return _tOwned[account];
791         return tokenFromReflection(_rOwned[account]);
792     }
793 
794     function transfer(address recipient, uint256 amount) public override returns (bool) {
795         _transfer(_msgSender(), recipient, amount);
796         return true;
797     }
798 
799     function allowance(address owner, address spender) public view override returns (uint256) {
800         return _allowances[owner][spender];
801     }
802 
803     function approve(address spender, uint256 amount) public override returns (bool) {
804         _approve(_msgSender(), spender, amount);
805         return true;
806     }
807 
808     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
809         _transfer(sender, recipient, amount);
810         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
811         return true;
812     }
813 
814     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
815         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
816         return true;
817     }
818 
819     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
820         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
821         return true;
822     }
823 
824     function isExcludedFromReward(address account) public view returns (bool) {
825         return _isExcluded[account];
826     }
827 
828     function totalFees() public view returns (uint256) {
829         return _tFeeTotal;
830     }
831     
832     function airdrop(address recipient, uint256 amount) external onlyOwner() {
833         removeAllFee();
834         _transfer(_msgSender(), recipient, amount * 10**9);
835         restoreAllFee();
836     }
837     
838     function airdropInternal(address recipient, uint256 amount) internal {
839         removeAllFee();
840         _transfer(_msgSender(), recipient, amount);
841         restoreAllFee();
842     }
843     
844     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
845         uint256 iterator = 0;
846         require(newholders.length == amounts.length, "must be the same length");
847         while(iterator < newholders.length){
848             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
849             iterator += 1;
850         }
851     }
852 
853     function deliver(uint256 tAmount) public {
854         address sender = _msgSender();
855         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
856         (uint256 rAmount,,,,,) = _getValues(tAmount);
857         _rOwned[sender] = _rOwned[sender].sub(rAmount);
858         _rTotal = _rTotal.sub(rAmount);
859         _tFeeTotal = _tFeeTotal.add(tAmount);
860     }
861 
862     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
863         require(tAmount <= _tTotal, "Amount must be less than supply");
864         if (!deductTransferFee) {
865             (uint256 rAmount,,,,,) = _getValues(tAmount);
866             return rAmount;
867         } else {
868             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
869             return rTransferAmount;
870         }
871     }
872 
873     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
874         require(rAmount <= _rTotal, "Amount must be less than total reflections");
875         uint256 currentRate =  _getRate();
876         return rAmount.div(currentRate);
877     }
878 
879     function excludeFromReward(address account) public onlyOwner() {
880         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
881         require(!_isExcluded[account], "Account is already excluded");
882         if(_rOwned[account] > 0) {
883             _tOwned[account] = tokenFromReflection(_rOwned[account]);
884         }
885         _isExcluded[account] = true;
886         _excluded.push(account);
887     }
888 
889     function includeInReward(address account) external onlyOwner() {
890         require(_isExcluded[account], "Account is already excluded");
891         for (uint256 i = 0; i < _excluded.length; i++) {
892             if (_excluded[i] == account) {
893                 _excluded[i] = _excluded[_excluded.length - 1];
894                 _tOwned[account] = 0;
895                 _isExcluded[account] = false;
896                 _excluded.pop();
897                 break;
898             }
899         }
900     }
901         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
902         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
903         _tOwned[sender] = _tOwned[sender].sub(tAmount);
904         _rOwned[sender] = _rOwned[sender].sub(rAmount);
905         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
906         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
907         _takeLiquidity(tLiquidity);
908         _reflectFee(rFee, tFee);
909         emit Transfer(sender, recipient, tTransferAmount);
910     }
911     
912     function excludeFromFee(address account) public onlyOwner {
913         _isExcludedFromFee[account] = true;
914     }
915     
916     function includeInFee(address account) public onlyOwner {
917         _isExcludedFromFee[account] = false;
918     }
919     function setMarketingFeePercent(uint256 fee) public onlyOwner {
920         marketingFeePercent = fee;
921     }
922 
923     function setMarketingWallet(address walletAddress) public onlyOwner {
924         marketingWallet = walletAddress;
925     }
926     
927     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
928         require(taxFee < 10, "Tax fee cannot be more than 10%");
929         _taxFee = taxFee;
930     }
931     
932     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
933         _liquidityFee = liquidityFee;
934     }
935 
936     function _setMaxWalletSizePercent(uint256 maxWalletSize)
937         external
938         onlyOwner
939     {
940         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
941     }
942    
943     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
944         require(maxTxAmount > 200000, "Max Tx Amount cannot be less than 69 Million");
945         _maxTxAmount = maxTxAmount * 10**9;
946     }
947     
948     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
949         require(SwapThresholdAmount > 200000, "Swap Threshold Amount cannot be less than 69 Million");
950         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
951     }
952     
953     function claimTokens () public onlyOwner {
954         // make sure we capture all BNB that may or may not be sent to this contract
955         payable(marketingWallet).transfer(address(this).balance);
956     }
957     
958     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
959         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
960     }
961     
962     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
963         walletaddress.transfer(address(this).balance);
964     }
965     
966     function addBotWallet(address botwallet) external onlyOwner() {
967         botWallets[botwallet] = true;
968     }
969     
970     function removeBotWallet(address botwallet) external onlyOwner() {
971         botWallets[botwallet] = false;
972     }
973     
974     function getBotWalletStatus(address botwallet) public view returns (bool) {
975         return botWallets[botwallet];
976     }
977     
978     function allowtrading()external onlyOwner() {
979         canTrade = true;
980     }
981 
982     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
983         swapAndLiquifyEnabled = _enabled;
984         emit SwapAndLiquifyEnabledUpdated(_enabled);
985     }
986     
987      //to recieve ETH from uniswapV2Router when swaping
988     receive() external payable {}
989 
990     function _reflectFee(uint256 rFee, uint256 tFee) private {
991         _rTotal = _rTotal.sub(rFee);
992         _tFeeTotal = _tFeeTotal.add(tFee);
993     }
994 
995     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
996         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
997         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
998         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
999     }
1000 
1001     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1002         uint256 tFee = calculateTaxFee(tAmount);
1003         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1004         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1005         return (tTransferAmount, tFee, tLiquidity);
1006     }
1007 
1008     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1009         uint256 rAmount = tAmount.mul(currentRate);
1010         uint256 rFee = tFee.mul(currentRate);
1011         uint256 rLiquidity = tLiquidity.mul(currentRate);
1012         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1013         return (rAmount, rTransferAmount, rFee);
1014     }
1015 
1016     function _getRate() private view returns(uint256) {
1017         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1018         return rSupply.div(tSupply);
1019     }
1020 
1021     function _getCurrentSupply() private view returns(uint256, uint256) {
1022         uint256 rSupply = _rTotal;
1023         uint256 tSupply = _tTotal;      
1024         for (uint256 i = 0; i < _excluded.length; i++) {
1025             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1026             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1027             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1028         }
1029         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1030         return (rSupply, tSupply);
1031     }
1032     
1033     function _takeLiquidity(uint256 tLiquidity) private {
1034         uint256 currentRate =  _getRate();
1035         uint256 rLiquidity = tLiquidity.mul(currentRate);
1036         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1037         if(_isExcluded[address(this)])
1038             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1039     }
1040     
1041     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1042         return _amount.mul(_taxFee).div(
1043             10**2
1044         );
1045     }
1046 
1047     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1048         return _amount.mul(_liquidityFee).div(
1049             10**2
1050         );
1051     }
1052     
1053     function removeAllFee() private {
1054         if(_taxFee == 0 && _liquidityFee == 0) return;
1055         
1056         _previousTaxFee = _taxFee;
1057         _previousLiquidityFee = _liquidityFee;
1058         
1059         _taxFee = 0;
1060         _liquidityFee = 0;
1061     }
1062     
1063     function restoreAllFee() private {
1064         _taxFee = _previousTaxFee;
1065         _liquidityFee = _previousLiquidityFee;
1066     }
1067     
1068     function isExcludedFromFee(address account) public view returns(bool) {
1069         return _isExcludedFromFee[account];
1070     }
1071 
1072     function _approve(address owner, address spender, uint256 amount) private {
1073         require(owner != address(0), "ERC20: approve from the zero address");
1074         require(spender != address(0), "ERC20: approve to the zero address");
1075 
1076         _allowances[owner][spender] = amount;
1077         emit Approval(owner, spender, amount);
1078     }
1079 
1080     function _transfer(
1081         address from,
1082         address to,
1083         uint256 amount
1084     ) private {
1085         require(from != address(0), "ERC20: transfer from the zero address");
1086         require(to != address(0), "ERC20: transfer to the zero address");
1087         require(amount > 0, "Transfer amount must be greater than zero");
1088         if(from != owner() && to != owner())
1089             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1090 
1091         // is the token balance of this contract address over the min number of
1092         // tokens that we need to initiate a swap + liquidity lock?
1093         // also, don't get caught in a circular liquidity event.
1094         // also, don't swap & liquify if sender is uniswap pair.
1095         uint256 contractTokenBalance = balanceOf(address(this));
1096         
1097         if(contractTokenBalance >= _maxTxAmount)
1098         {
1099             contractTokenBalance = _maxTxAmount;
1100         }
1101         
1102         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1103         if (
1104             overMinTokenBalance &&
1105             !inSwapAndLiquify &&
1106             from != uniswapV2Pair &&
1107             swapAndLiquifyEnabled
1108         ) {
1109             contractTokenBalance = numTokensSellToAddToLiquidity;
1110             //add liquidity
1111             swapAndLiquify(contractTokenBalance);
1112         }
1113         
1114         //indicates if fee should be deducted from transfer
1115         bool takeFee = true;
1116         
1117         //if any account belongs to _isExcludedFromFee account then remove the fee
1118         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1119             takeFee = false;
1120         }
1121 
1122         if (takeFee) {
1123             if (to != uniswapV2Pair) {
1124                 require(
1125                     amount + balanceOf(to) <= _maxWalletSize,
1126                     "Recipient exceeds max wallet size."
1127                 );
1128             }
1129         }
1130         
1131         
1132         //transfer amount, it will take tax, burn, liquidity fee
1133         _tokenTransfer(from,to,amount,takeFee);
1134     }
1135 
1136     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1137         // split the contract balance into halves
1138         // add the marketing wallet
1139         uint256 half = contractTokenBalance.div(2);
1140         uint256 otherHalf = contractTokenBalance.sub(half);
1141 
1142         // capture the contract's current ETH balance.
1143         // this is so that we can capture exactly the amount of ETH that the
1144         // swap creates, and not make the liquidity event include any ETH that
1145         // has been manually sent to the contract
1146         uint256 initialBalance = address(this).balance;
1147 
1148         // swap tokens for ETH
1149         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1150 
1151         // how much ETH did we just swap into?
1152         uint256 newBalance = address(this).balance.sub(initialBalance);
1153         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1154         payable(marketingWallet).transfer(marketingshare);
1155         newBalance -= marketingshare;
1156         // add liquidity to uniswap
1157         addLiquidity(otherHalf, newBalance);
1158         
1159         emit SwapAndLiquify(half, newBalance, otherHalf);
1160     }
1161 
1162     function swapTokensForEth(uint256 tokenAmount) private {
1163         // generate the uniswap pair path of token -> weth
1164         address[] memory path = new address[](2);
1165         path[0] = address(this);
1166         path[1] = uniswapV2Router.WETH();
1167 
1168         _approve(address(this), address(uniswapV2Router), tokenAmount);
1169 
1170         // make the swap
1171         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1172             tokenAmount,
1173             0, // accept any amount of ETH
1174             path,
1175             address(this),
1176             block.timestamp
1177         );
1178     }
1179 
1180     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1181         // approve token transfer to cover all possible scenarios
1182         _approve(address(this), address(uniswapV2Router), tokenAmount);
1183 
1184         // add the liquidity
1185         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1186             address(this),
1187             tokenAmount,
1188             0, // slippage is unavoidable
1189             0, // slippage is unavoidable
1190             owner(),
1191             block.timestamp
1192         );
1193     }
1194 
1195     //this method is responsible for taking all fee, if takeFee is true
1196     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1197         if(!canTrade){
1198             require(sender == owner()); // only owner allowed to trade or add liquidity
1199         }
1200         
1201         if(botWallets[sender] || botWallets[recipient]){
1202             require(botscantrade, "bots arent allowed to trade");
1203         }
1204         
1205         if(!takeFee)
1206             removeAllFee();
1207         
1208         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1209             _transferFromExcluded(sender, recipient, amount);
1210         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1211             _transferToExcluded(sender, recipient, amount);
1212         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1213             _transferStandard(sender, recipient, amount);
1214         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1215             _transferBothExcluded(sender, recipient, amount);
1216         } else {
1217             _transferStandard(sender, recipient, amount);
1218         }
1219         
1220         if(!takeFee)
1221             restoreAllFee();
1222     }
1223 
1224     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1225         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1226         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1227         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1228         _takeLiquidity(tLiquidity);
1229         _reflectFee(rFee, tFee);
1230         emit Transfer(sender, recipient, tTransferAmount);
1231     }
1232 
1233     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1234         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1235         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1236         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1237         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1238         _takeLiquidity(tLiquidity);
1239         _reflectFee(rFee, tFee);
1240         emit Transfer(sender, recipient, tTransferAmount);
1241     }
1242 
1243     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1244         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1245         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1246         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1247         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1248         _takeLiquidity(tLiquidity);
1249         _reflectFee(rFee, tFee);
1250         emit Transfer(sender, recipient, tTransferAmount);
1251     }
1252 
1253 }