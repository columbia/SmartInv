1 /*
2 
3     Jerome Powell
4     Chair of the Federal Reserve of the United States
5    
6    
7     https://t.me/PowellCoin
8     https://jeromepowell.co
9 
10 
11 */
12 
13 
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.8.9;
18 interface IERC20 {
19 
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102  
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      *
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b > 0, errorMessage);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b != 0, errorMessage);
242         return a % b;
243     }
244 }
245 
246 abstract contract Context {
247     //function _msgSender() internal view virtual returns (address payable) {
248     function _msgSender() internal view virtual returns (address) {
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
419     constructor () {
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
462     function geUnlockTime() public view returns (uint256) {
463         return _lockTime;
464     }
465 
466     //Locks the contract for owner for the amount of time provided
467     function lock(uint256 time) public virtual onlyOwner {
468         _previousOwner = _owner;
469         _owner = address(0);
470         _lockTime = block.timestamp + time;
471         emit OwnershipTransferred(_owner, address(0));
472     }
473     
474     //Unlocks the contract for owner when _lockTime is exceeds
475     function unlock() public virtual {
476         require(_previousOwner == msg.sender, "You don't have permission to unlock");
477         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
478         emit OwnershipTransferred(_owner, _previousOwner);
479         _owner = _previousOwner;
480     }
481 }
482 
483 
484 interface IUniswapV2Factory {
485     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
486 
487     function feeTo() external view returns (address);
488     function feeToSetter() external view returns (address);
489 
490     function getPair(address tokenA, address tokenB) external view returns (address pair);
491     function allPairs(uint) external view returns (address pair);
492     function allPairsLength() external view returns (uint);
493 
494     function createPair(address tokenA, address tokenB) external returns (address pair);
495 
496     function setFeeTo(address) external;
497     function setFeeToSetter(address) external;
498 }
499 
500 
501 
502 interface IUniswapV2Pair {
503     event Approval(address indexed owner, address indexed spender, uint value);
504     event Transfer(address indexed from, address indexed to, uint value);
505 
506     function name() external pure returns (string memory);
507     function symbol() external pure returns (string memory);
508     function decimals() external pure returns (uint8);
509     function totalSupply() external view returns (uint);
510     function balanceOf(address owner) external view returns (uint);
511     function allowance(address owner, address spender) external view returns (uint);
512 
513     function approve(address spender, uint value) external returns (bool);
514     function transfer(address to, uint value) external returns (bool);
515     function transferFrom(address from, address to, uint value) external returns (bool);
516 
517     function DOMAIN_SEPARATOR() external view returns (bytes32);
518     function PERMIT_TYPEHASH() external pure returns (bytes32);
519     function nonces(address owner) external view returns (uint);
520 
521     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
522 
523     event Mint(address indexed sender, uint amount0, uint amount1);
524     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
525     event Swap(
526         address indexed sender,
527         uint amount0In,
528         uint amount1In,
529         uint amount0Out,
530         uint amount1Out,
531         address indexed to
532     );
533     event Sync(uint112 reserve0, uint112 reserve1);
534 
535     function MINIMUM_LIQUIDITY() external pure returns (uint);
536     function factory() external view returns (address);
537     function token0() external view returns (address);
538     function token1() external view returns (address);
539     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
540     function price0CumulativeLast() external view returns (uint);
541     function price1CumulativeLast() external view returns (uint);
542     function kLast() external view returns (uint);
543 
544     function mint(address to) external returns (uint liquidity);
545     function burn(address to) external returns (uint amount0, uint amount1);
546     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
547     function skim(address to) external;
548     function sync() external;
549 
550     function initialize(address, address) external;
551 }
552 
553 
554 interface IUniswapV2Router01 {
555     function factory() external pure returns (address);
556     function WETH() external pure returns (address);
557 
558     function addLiquidity(
559         address tokenA,
560         address tokenB,
561         uint amountADesired,
562         uint amountBDesired,
563         uint amountAMin,
564         uint amountBMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountA, uint amountB, uint liquidity);
568     function addLiquidityETH(
569         address token,
570         uint amountTokenDesired,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline
575     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
576     function removeLiquidity(
577         address tokenA,
578         address tokenB,
579         uint liquidity,
580         uint amountAMin,
581         uint amountBMin,
582         address to,
583         uint deadline
584     ) external returns (uint amountA, uint amountB);
585     function removeLiquidityETH(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external returns (uint amountToken, uint amountETH);
593     function removeLiquidityWithPermit(
594         address tokenA,
595         address tokenB,
596         uint liquidity,
597         uint amountAMin,
598         uint amountBMin,
599         address to,
600         uint deadline,
601         bool approveMax, uint8 v, bytes32 r, bytes32 s
602     ) external returns (uint amountA, uint amountB);
603     function removeLiquidityETHWithPermit(
604         address token,
605         uint liquidity,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline,
610         bool approveMax, uint8 v, bytes32 r, bytes32 s
611     ) external returns (uint amountToken, uint amountETH);
612     function swapExactTokensForTokens(
613         uint amountIn,
614         uint amountOutMin,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external returns (uint[] memory amounts);
619     function swapTokensForExactTokens(
620         uint amountOut,
621         uint amountInMax,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external returns (uint[] memory amounts);
626     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
627         external
628         payable
629         returns (uint[] memory amounts);
630     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
631         external
632         returns (uint[] memory amounts);
633     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
634         external
635         returns (uint[] memory amounts);
636     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
637         external
638         payable
639         returns (uint[] memory amounts);
640 
641     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
642     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
643     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
644     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
645     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
646 }
647 
648 
649 
650 
651 interface IUniswapV2Router02 is IUniswapV2Router01 {
652     function removeLiquidityETHSupportingFeeOnTransferTokens(
653         address token,
654         uint liquidity,
655         uint amountTokenMin,
656         uint amountETHMin,
657         address to,
658         uint deadline
659     ) external returns (uint amountETH);
660     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
661         address token,
662         uint liquidity,
663         uint amountTokenMin,
664         uint amountETHMin,
665         address to,
666         uint deadline,
667         bool approveMax, uint8 v, bytes32 r, bytes32 s
668     ) external returns (uint amountETH);
669 
670     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external;
677     function swapExactETHForTokensSupportingFeeOnTransferTokens(
678         uint amountOutMin,
679         address[] calldata path,
680         address to,
681         uint deadline
682     ) external payable;
683     function swapExactTokensForETHSupportingFeeOnTransferTokens(
684         uint amountIn,
685         uint amountOutMin,
686         address[] calldata path,
687         address to,
688         uint deadline
689     ) external;
690 }
691 
692 interface IAirdrop {
693     function airdrop(address recipient, uint256 amount) external;
694 }
695 
696 contract POWELL is Context, IERC20, Ownable {
697     using SafeMath for uint256;
698     using Address for address;
699 
700     mapping (address => uint256) private _rOwned;
701     mapping (address => uint256) private _tOwned;
702     mapping (address => mapping (address => uint256)) private _allowances;
703 
704     mapping (address => bool) private _isExcludedFromFee;
705 
706     mapping (address => bool) private _isExcluded;
707     address[] private _excluded;
708     
709     mapping (address => bool) private botWallets;
710     bool botscantrade = false;
711     
712     bool public canTrade = false;
713    
714     uint256 private constant MAX = ~uint256(0);
715     uint256 private _tTotal = 69000000000000000000000 * 10**9;
716     uint256 private _rTotal = (MAX - (MAX % _tTotal));
717     uint256 private _tFeeTotal;
718     address public marketingWallet;
719 
720     string private _name = "Powell";
721     string private _symbol = "POWELL";
722     uint8 private _decimals = 9;
723     
724     uint256 public _taxFee = 1;
725     uint256 private _previousTaxFee = _taxFee;
726     
727     uint256 public _liquidityFee = 12;
728     uint256 private _previousLiquidityFee = _liquidityFee;
729 
730     IUniswapV2Router02 public immutable uniswapV2Router;
731     address public immutable uniswapV2Pair;
732     
733     bool inSwapAndLiquify;
734     bool public swapAndLiquifyEnabled = true;
735     
736     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
737     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
738     
739     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
740     event SwapAndLiquifyEnabledUpdated(bool enabled);
741     event SwapAndLiquify(
742         uint256 tokensSwapped,
743         uint256 ethReceived,
744         uint256 tokensIntoLiqudity
745     );
746     
747     modifier lockTheSwap {
748         inSwapAndLiquify = true;
749         _;
750         inSwapAndLiquify = false;
751     }
752     
753     constructor () {
754         _rOwned[_msgSender()] = _rTotal;
755         
756         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
757          // Create a uniswap pair for this new token
758         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
759             .createPair(address(this), _uniswapV2Router.WETH());
760 
761         // set the rest of the contract variables
762         uniswapV2Router = _uniswapV2Router;
763         
764         //exclude owner and this contract from fee
765         _isExcludedFromFee[owner()] = true;
766         _isExcludedFromFee[address(this)] = true;
767         
768         emit Transfer(address(0), _msgSender(), _tTotal);
769     }
770 
771     function name() public view returns (string memory) {
772         return _name;
773     }
774 
775     function symbol() public view returns (string memory) {
776         return _symbol;
777     }
778 
779     function decimals() public view returns (uint8) {
780         return _decimals;
781     }
782 
783     function totalSupply() public view override returns (uint256) {
784         return _tTotal;
785     }
786 
787     function balanceOf(address account) public view override returns (uint256) {
788         if (_isExcluded[account]) return _tOwned[account];
789         return tokenFromReflection(_rOwned[account]);
790     }
791 
792     function transfer(address recipient, uint256 amount) public override returns (bool) {
793         _transfer(_msgSender(), recipient, amount);
794         return true;
795     }
796 
797     function allowance(address owner, address spender) public view override returns (uint256) {
798         return _allowances[owner][spender];
799     }
800 
801     function approve(address spender, uint256 amount) public override returns (bool) {
802         _approve(_msgSender(), spender, amount);
803         return true;
804     }
805 
806     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
807         _transfer(sender, recipient, amount);
808         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
809         return true;
810     }
811 
812     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
814         return true;
815     }
816 
817     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
818         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
819         return true;
820     }
821 
822     function isExcludedFromReward(address account) public view returns (bool) {
823         return _isExcluded[account];
824     }
825 
826     function totalFees() public view returns (uint256) {
827         return _tFeeTotal;
828     }
829     
830     function airdrop(address recipient, uint256 amount) external onlyOwner() {
831         removeAllFee();
832         _transfer(_msgSender(), recipient, amount * 10**9);
833         restoreAllFee();
834     }
835     
836     function airdropInternal(address recipient, uint256 amount) internal {
837         removeAllFee();
838         _transfer(_msgSender(), recipient, amount);
839         restoreAllFee();
840     }
841     
842     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
843         uint256 iterator = 0;
844         require(newholders.length == amounts.length, "must be the same length");
845         while(iterator < newholders.length){
846             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
847             iterator += 1;
848         }
849     }
850 
851     function deliver(uint256 tAmount) public {
852         address sender = _msgSender();
853         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
854         (uint256 rAmount,,,,,) = _getValues(tAmount);
855         _rOwned[sender] = _rOwned[sender].sub(rAmount);
856         _rTotal = _rTotal.sub(rAmount);
857         _tFeeTotal = _tFeeTotal.add(tAmount);
858     }
859 
860     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
861         require(tAmount <= _tTotal, "Amount must be less than supply");
862         if (!deductTransferFee) {
863             (uint256 rAmount,,,,,) = _getValues(tAmount);
864             return rAmount;
865         } else {
866             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
867             return rTransferAmount;
868         }
869     }
870 
871     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
872         require(rAmount <= _rTotal, "Amount must be less than total reflections");
873         uint256 currentRate =  _getRate();
874         return rAmount.div(currentRate);
875     }
876 
877     function excludeFromReward(address account) public onlyOwner() {
878         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
879         require(!_isExcluded[account], "Account is already excluded");
880         if(_rOwned[account] > 0) {
881             _tOwned[account] = tokenFromReflection(_rOwned[account]);
882         }
883         _isExcluded[account] = true;
884         _excluded.push(account);
885     }
886 
887     function includeInReward(address account) external onlyOwner() {
888         require(_isExcluded[account], "Account is already excluded");
889         for (uint256 i = 0; i < _excluded.length; i++) {
890             if (_excluded[i] == account) {
891                 _excluded[i] = _excluded[_excluded.length - 1];
892                 _tOwned[account] = 0;
893                 _isExcluded[account] = false;
894                 _excluded.pop();
895                 break;
896             }
897         }
898     }
899         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
900         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
901         _tOwned[sender] = _tOwned[sender].sub(tAmount);
902         _rOwned[sender] = _rOwned[sender].sub(rAmount);
903         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
904         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
905         _takeLiquidity(tLiquidity);
906         _reflectFee(rFee, tFee);
907         emit Transfer(sender, recipient, tTransferAmount);
908     }
909     
910     function excludeFromFee(address account) public onlyOwner {
911         _isExcludedFromFee[account] = true;
912     }
913     
914     function includeInFee(address account) public onlyOwner {
915         _isExcludedFromFee[account] = false;
916     }
917 
918     function setMarketingWallet(address walletAddress) public onlyOwner {
919         marketingWallet = walletAddress;
920     }
921 
922     function upliftTxAmount() external onlyOwner() {
923         _maxTxAmount = 69000000000000000000000 * 10**9;
924     }
925     
926     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
927         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
928         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
929     }
930     
931     function claimTokens () public onlyOwner {
932         // make sure we capture all BNB that may or may not be sent to this contract
933         payable(marketingWallet).transfer(address(this).balance);
934     }
935     
936     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
937         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
938     }
939     
940     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
941         walletaddress.transfer(address(this).balance);
942     }
943     
944     function addBotWallet(address botwallet) external onlyOwner() {
945         botWallets[botwallet] = true;
946     }
947     
948     function removeBotWallet(address botwallet) external onlyOwner() {
949         botWallets[botwallet] = false;
950     }
951     
952     function getBotWalletStatus(address botwallet) public view returns (bool) {
953         return botWallets[botwallet];
954     }
955     
956     function allowtrading()external onlyOwner() {
957         canTrade = true;
958     }
959 
960     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
961         swapAndLiquifyEnabled = _enabled;
962         emit SwapAndLiquifyEnabledUpdated(_enabled);
963     }
964     
965      //to recieve ETH from uniswapV2Router when swaping
966     receive() external payable {}
967 
968     function _reflectFee(uint256 rFee, uint256 tFee) private {
969         _rTotal = _rTotal.sub(rFee);
970         _tFeeTotal = _tFeeTotal.add(tFee);
971     }
972 
973     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
974         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
975         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
976         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
977     }
978 
979     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
980         uint256 tFee = calculateTaxFee(tAmount);
981         uint256 tLiquidity = calculateLiquidityFee(tAmount);
982         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
983         return (tTransferAmount, tFee, tLiquidity);
984     }
985 
986     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
987         uint256 rAmount = tAmount.mul(currentRate);
988         uint256 rFee = tFee.mul(currentRate);
989         uint256 rLiquidity = tLiquidity.mul(currentRate);
990         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
991         return (rAmount, rTransferAmount, rFee);
992     }
993 
994     function _getRate() private view returns(uint256) {
995         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
996         return rSupply.div(tSupply);
997     }
998 
999     function _getCurrentSupply() private view returns(uint256, uint256) {
1000         uint256 rSupply = _rTotal;
1001         uint256 tSupply = _tTotal;      
1002         for (uint256 i = 0; i < _excluded.length; i++) {
1003             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1004             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1005             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1006         }
1007         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1008         return (rSupply, tSupply);
1009     }
1010     
1011     function _takeLiquidity(uint256 tLiquidity) private {
1012         uint256 currentRate =  _getRate();
1013         uint256 rLiquidity = tLiquidity.mul(currentRate);
1014         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1015         if(_isExcluded[address(this)])
1016             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1017     }
1018     
1019     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1020         return _amount.mul(_taxFee).div(
1021             10**2
1022         );
1023     }
1024 
1025     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1026         return _amount.mul(_liquidityFee).div(
1027             10**2
1028         );
1029     }
1030     
1031     function removeAllFee() private {
1032         if(_taxFee == 0 && _liquidityFee == 0) return;
1033         
1034         _previousTaxFee = _taxFee;
1035         _previousLiquidityFee = _liquidityFee;
1036         
1037         _taxFee = 0;
1038         _liquidityFee = 0;
1039     }
1040     
1041     function restoreAllFee() private {
1042         _taxFee = _previousTaxFee;
1043         _liquidityFee = _previousLiquidityFee;
1044     }
1045     
1046     function isExcludedFromFee(address account) public view returns(bool) {
1047         return _isExcludedFromFee[account];
1048     }
1049 
1050     function _approve(address owner, address spender, uint256 amount) private {
1051         require(owner != address(0), "ERC20: approve from the zero address");
1052         require(spender != address(0), "ERC20: approve to the zero address");
1053 
1054         _allowances[owner][spender] = amount;
1055         emit Approval(owner, spender, amount);
1056     }
1057 
1058     function _transfer(
1059         address from,
1060         address to,
1061         uint256 amount
1062     ) private {
1063         require(from != address(0), "ERC20: transfer from the zero address");
1064         require(to != address(0), "ERC20: transfer to the zero address");
1065         require(amount > 0, "Transfer amount must be greater than zero");
1066         if(from != owner() && to != owner())
1067             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1068 
1069         // is the token balance of this contract address over the min number of
1070         // tokens that we need to initiate a swap + liquidity lock?
1071         // also, don't get caught in a circular liquidity event.
1072         // also, don't swap & liquify if sender is uniswap pair.
1073         uint256 contractTokenBalance = balanceOf(address(this));
1074         
1075         if(contractTokenBalance >= _maxTxAmount)
1076         {
1077             contractTokenBalance = _maxTxAmount;
1078         }
1079         
1080         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1081         if (
1082             overMinTokenBalance &&
1083             !inSwapAndLiquify &&
1084             from != uniswapV2Pair &&
1085             swapAndLiquifyEnabled
1086         ) {
1087             contractTokenBalance = numTokensSellToAddToLiquidity;
1088             //add liquidity
1089             swapAndLiquify(contractTokenBalance);
1090         }
1091         
1092         //indicates if fee should be deducted from transfer
1093         bool takeFee = true;
1094         
1095         //if any account belongs to _isExcludedFromFee account then remove the fee
1096         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1097             takeFee = false;
1098         }
1099         
1100         //transfer amount, it will take tax, burn, liquidity fee
1101         _tokenTransfer(from,to,amount,takeFee);
1102     }
1103 
1104     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1105         // split the contract balance into halves
1106         // add the marketing wallet
1107         uint256 half = contractTokenBalance.div(2);
1108         uint256 otherHalf = contractTokenBalance.sub(half);
1109 
1110         // capture the contract's current ETH balance.
1111         // this is so that we can capture exactly the amount of ETH that the
1112         // swap creates, and not make the liquidity event include any ETH that
1113         // has been manually sent to the contract
1114         uint256 initialBalance = address(this).balance;
1115 
1116         // swap tokens for ETH
1117         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1118 
1119         // how much ETH did we just swap into?
1120         uint256 newBalance = address(this).balance.sub(initialBalance);
1121         uint256 marketingshare = newBalance.mul(75).div(100);
1122         payable(marketingWallet).transfer(marketingshare);
1123         newBalance -= marketingshare;
1124         // add liquidity to uniswap
1125         addLiquidity(otherHalf, newBalance);
1126         
1127         emit SwapAndLiquify(half, newBalance, otherHalf);
1128     }
1129 
1130     function swapTokensForEth(uint256 tokenAmount) private {
1131         // generate the uniswap pair path of token -> weth
1132         address[] memory path = new address[](2);
1133         path[0] = address(this);
1134         path[1] = uniswapV2Router.WETH();
1135 
1136         _approve(address(this), address(uniswapV2Router), tokenAmount);
1137 
1138         // make the swap
1139         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1140             tokenAmount,
1141             0, // accept any amount of ETH
1142             path,
1143             address(this),
1144             block.timestamp
1145         );
1146     }
1147 
1148     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1149         // approve token transfer to cover all possible scenarios
1150         _approve(address(this), address(uniswapV2Router), tokenAmount);
1151 
1152         // add the liquidity
1153         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1154             address(this),
1155             tokenAmount,
1156             0, // slippage is unavoidable
1157             0, // slippage is unavoidable
1158             owner(),
1159             block.timestamp
1160         );
1161     }
1162 
1163     //this method is responsible for taking all fee, if takeFee is true
1164     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1165         if(!canTrade){
1166             require(sender == owner()); // only owner allowed to trade or add liquidity
1167         }
1168         
1169         if(botWallets[sender] || botWallets[recipient]){
1170             require(botscantrade, "bots arent allowed to trade");
1171         }
1172         
1173         if(!takeFee)
1174             removeAllFee();
1175         
1176         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1177             _transferFromExcluded(sender, recipient, amount);
1178         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1179             _transferToExcluded(sender, recipient, amount);
1180         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1181             _transferStandard(sender, recipient, amount);
1182         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1183             _transferBothExcluded(sender, recipient, amount);
1184         } else {
1185             _transferStandard(sender, recipient, amount);
1186         }
1187         
1188         if(!takeFee)
1189             restoreAllFee();
1190     }
1191 
1192     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1193         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1194         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1195         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1196         _takeLiquidity(tLiquidity);
1197         _reflectFee(rFee, tFee);
1198         emit Transfer(sender, recipient, tTransferAmount);
1199     }
1200 
1201     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1202         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1203         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1204         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1205         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1206         _takeLiquidity(tLiquidity);
1207         _reflectFee(rFee, tFee);
1208         emit Transfer(sender, recipient, tTransferAmount);
1209     }
1210 
1211     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1212         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1213         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1214         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1215         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1216         _takeLiquidity(tLiquidity);
1217         _reflectFee(rFee, tFee);
1218         emit Transfer(sender, recipient, tTransferAmount);
1219     }
1220 
1221 }