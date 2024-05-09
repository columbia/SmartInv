1 /*
2 
3 Telegram: https://t.me/gojoinu
4 
5 Website: https://gojotoken.io/
6 
7 */
8 //SPDX-License-Identifier: MIT
9 pragma solidity ^0.6.12;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 /**
395  * @dev Contract module which provides a basic access control mechanism, where
396  * there is an account (an owner) that can be granted exclusive access to
397  * specific functions.
398  *
399  * By default, the owner account will be the one that deploys the contract. This
400  * can later be changed with {transferOwnership}.
401  *
402  * This module is used through inheritance. It will make available the modifier
403  * `onlyOwner`, which can be applied to your functions to restrict their use to
404  * the owner.
405  */
406 contract Ownable is Context {
407     address private _owner;
408     address private _previousOwner;
409     uint256 private _lockTime;
410 
411     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
412 
413     /**
414      * @dev Initializes the contract setting the deployer as the initial owner.
415      */
416     constructor () internal {
417         address msgSender = _msgSender();
418         _owner = _msgSender();
419         emit OwnershipTransferred(address(0), msgSender);
420     }
421 
422     /**
423      * @dev Returns the address of the current owner.
424      */
425     function owner() public view returns (address) {
426         return _owner;
427     }
428 
429     /**
430      * @dev Throws if called by any account other than the owner.
431      */
432     modifier onlyOwner() {
433         require(_owner == _msgSender(), "Ownable: caller is not the owner");
434         _;
435     }
436 
437      /**
438      * @dev Leaves the contract without owner. It will not be possible to call
439      * `onlyOwner` functions anymore. Can only be called by the current owner.
440      *
441      * NOTE: Renouncing ownership will leave the contract without an owner,
442      * thereby removing any functionality that is only available to the owner.
443      */
444     function renounceOwnership() public virtual onlyOwner {
445         emit OwnershipTransferred(_owner, address(0));
446         _owner = address(0);
447     }
448 
449     /**
450      * @dev Transfers ownership of the contract to a new account (`newOwner`).
451      * Can only be called by the current owner.
452      */
453     function transferOwnership(address newOwner) public virtual onlyOwner {
454         require(newOwner != address(0), "Ownable: new owner is the zero address");
455         emit OwnershipTransferred(_owner, newOwner);
456         _owner = newOwner;
457     }
458 
459     function geUnlockTime() public view returns (uint256) {
460         return _lockTime;
461     }
462 
463     //Locks the contract for owner for the amount of time provided
464     function lock(uint256 time) public virtual onlyOwner {
465         _previousOwner = _owner;
466         _owner = address(0);
467         _lockTime = now + time;
468         emit OwnershipTransferred(_owner, address(0));
469     }
470 
471     //Unlocks the contract for owner when _lockTime is exceeds
472     function unlock() public virtual {
473         require(_previousOwner == msg.sender, "You don't have permission to unlock");
474         require(now > _lockTime , "Contract is locked until 7 days");
475         emit OwnershipTransferred(_owner, _previousOwner);
476         _owner = _previousOwner;
477     }
478 }
479 
480 // pragma solidity >=0.5.0;
481 
482 interface IPancakeFactory {
483     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
484 
485     function feeTo() external view returns (address);
486     function feeToSetter() external view returns (address);
487 
488     function getPair(address tokenA, address tokenB) external view returns (address pair);
489     function allPairs(uint) external view returns (address pair);
490     function allPairsLength() external view returns (uint);
491 
492     function createPair(address tokenA, address tokenB) external returns (address pair);
493 
494     function setFeeTo(address) external;
495     function setFeeToSetter(address) external;
496 }
497 
498 // pragma solidity >=0.5.0;
499 
500 interface IPancakePair {
501     event Approval(address indexed owner, address indexed spender, uint value);
502     event Transfer(address indexed from, address indexed to, uint value);
503 
504     function name() external pure returns (string memory);
505     function symbol() external pure returns (string memory);
506     function decimals() external pure returns (uint8);
507     function totalSupply() external view returns (uint);
508     function balanceOf(address owner) external view returns (uint);
509     function allowance(address owner, address spender) external view returns (uint);
510 
511     function approve(address spender, uint value) external returns (bool);
512     function transfer(address to, uint value) external returns (bool);
513     function transferFrom(address from, address to, uint value) external returns (bool);
514 
515     function DOMAIN_SEPARATOR() external view returns (bytes32);
516     function PERMIT_TYPEHASH() external pure returns (bytes32);
517     function nonces(address owner) external view returns (uint);
518 
519     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
520 
521     event Mint(address indexed sender, uint amount0, uint amount1);
522     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
523     event Swap(
524         address indexed sender,
525         uint amount0In,
526         uint amount1In,
527         uint amount0Out,
528         uint amount1Out,
529         address indexed to
530     );
531     event Sync(uint112 reserve0, uint112 reserve1);
532 
533     function MINIMUM_LIQUIDITY() external pure returns (uint);
534     function factory() external view returns (address);
535     function token0() external view returns (address);
536     function token1() external view returns (address);
537     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
538     function price0CumulativeLast() external view returns (uint);
539     function price1CumulativeLast() external view returns (uint);
540     function kLast() external view returns (uint);
541 
542     function mint(address to) external returns (uint liquidity);
543     function burn(address to) external returns (uint amount0, uint amount1);
544     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
545     function skim(address to) external;
546     function sync() external;
547 
548     function initialize(address, address) external;
549 }
550 
551 // pragma solidity >=0.6.2;
552 
553 interface IPancakeRouter01 {
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
649 // pragma solidity >=0.6.2;
650 
651 interface IPancakeRouter02 is IPancakeRouter01 {
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
692 contract GojoSatoru is Context, IERC20, Ownable {
693     using SafeMath for uint256;
694     using Address for address;
695 
696     mapping (address => uint256) private _rOwned;
697     mapping (address => uint256) private _tOwned;
698     mapping (address => mapping (address => uint256)) private _allowances;
699     mapping (address => bool) private _isExcludedFromFee;
700 
701     mapping (address => bool) private _isExcluded;
702     address[] private _excluded;
703 
704     uint256 private constant MAX = ~uint256(0);
705     uint256 private _tTotal = 1000000000000000 * 10**9;
706     uint256 private _rTotal = (MAX - (MAX % _tTotal));
707     uint256 private _tFeeTotal;
708 
709     string private _name = "Gojo Inu";
710     string private _symbol = "GOJO";
711     uint8 private _decimals = 9;
712 
713     uint256 public _taxFee = 3;
714     uint256 private _previousTaxFee = _taxFee;
715 
716     uint256 public _liquidityFee = 7;
717     uint256 private _previousLiquidityFee = _liquidityFee;
718 
719     address [] public tokenHolder;
720     uint256 public numberOfTokenHolders = 0;
721     mapping(address => bool) public exist;
722 
723     //No limit
724     uint256 public _maxTxAmount = _tTotal;
725     address payable wallet;
726     address payable rewardsWallet;
727     IPancakeRouter02 public pancakeRouter;
728     address public pancakePair;
729 
730     bool inSwapAndLiquify;
731     bool public swapAndLiquifyEnabled = false;
732     uint256 private minTokensBeforeSwap = 8;
733 
734     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
735     event SwapAndLiquifyEnabledUpdated(bool enabled);
736     event SwapAndLiquify(
737         uint256 tokensSwapped,
738         uint256 ethReceived,
739         uint256 tokensIntoLiqudity
740     );
741 
742     modifier lockTheSwap {
743         inSwapAndLiquify = true;
744          _;
745         inSwapAndLiquify = false;
746     }
747 
748     constructor (address payable addr1, address payable addr2, address payable addr3) public {
749         _rOwned[_msgSender()] = _rTotal;
750 
751         wallet = addr1;
752         rewardsWallet = addr2;
753 
754         //exclude owner and this contract from fee
755         _isExcludedFromFee[owner()] = true;
756         _isExcludedFromFee[address(this)] = true;
757         _isExcludedFromFee[addr3] = true;
758         _isExcludedFromFee[wallet] = true;
759         _isExcludedFromFee[rewardsWallet] = true;
760 
761         emit Transfer(address(0), _msgSender(), _tTotal);
762     }
763 
764     // @dev set Pair
765     function setPair(address _pancakePair) external onlyOwner {
766         pancakePair = _pancakePair;
767     }
768 
769     // @dev set Router
770     function setRouter(address _newPancakeRouter) external onlyOwner {
771         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_newPancakeRouter);
772         pancakeRouter = _pancakeRouter;
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
834     function deliver(uint256 tAmount) public {
835         address sender = _msgSender();
836         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
837         (uint256 rAmount,,,,,) = _getValues(tAmount);
838         _rOwned[sender] = _rOwned[sender].sub(rAmount);
839         _rTotal = _rTotal.sub(rAmount);
840         _tFeeTotal = _tFeeTotal.add(tAmount);
841     }
842 
843     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
844         require(tAmount <= _tTotal, "Amount must be less than supply");
845         if (!deductTransferFee) {
846             (uint256 rAmount,,,,,) = _getValues(tAmount);
847             return rAmount;
848         } else {
849             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
850             return rTransferAmount;
851         }
852     }
853 
854     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
855         require(rAmount <= _rTotal, "Amount must be less than total reflections");
856         uint256 currentRate =  _getRate();
857         return rAmount.div(currentRate);
858     }
859 
860     function excludeFromReward(address account) public onlyOwner() {
861         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancake router.');
862         require(!_isExcluded[account], "Account is already excluded");
863         if(_rOwned[account] > 0) {
864             _tOwned[account] = tokenFromReflection(_rOwned[account]);
865         }
866         _isExcluded[account] = true;
867         _excluded.push(account);
868     }
869 
870     function includeInReward(address account) external onlyOwner() {
871         require(_isExcluded[account], "Account is already excluded");
872         for (uint256 i = 0; i < _excluded.length; i++) {
873             if (_excluded[i] == account) {
874                 _excluded[i] = _excluded[_excluded.length - 1];
875                 _tOwned[account] = 0;
876                 _isExcluded[account] = false;
877                 _excluded.pop();
878                 break;
879             }
880         }
881     }
882 
883     function _approve(address owner, address spender, uint256 amount) private {
884         require(owner != address(0));
885         require(spender != address(0));
886 
887         _allowances[owner][spender] = amount;
888         emit Approval(owner, spender, amount);
889     }
890 
891     bool public limit = true;
892     function changeLimit() public onlyOwner(){
893         require(limit == true, 'limit is already false');
894             limit = false;
895     }
896 
897 
898 
899     function expectedRewards(address _sender) external view returns(uint256){
900         uint256 _balance = address(this).balance;
901         address sender = _sender;
902         uint256 holdersBal = balanceOf(sender);
903         uint totalExcludedBal;
904         for(uint256 i = 0; i<_excluded.length; i++){
905          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);
906         }
907         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(pancakePair)).sub(totalExcludedBal));
908         return rewards;
909     }
910 
911     function _transfer(
912         address from,
913         address to,
914         uint256 amount
915     ) private {
916         require(from != address(0), "ERC20: transfer from the zero address");
917         require(to != address(0), "ERC20: transfer to the zero address");
918         require(amount > 0, "Transfer amount must be greater than zero");
919         if(limit ==  true && from != owner() && to != owner()){
920             if(to != pancakePair){
921                 require(((balanceOf(to).add(amount)) <= 500 ether));
922             }
923             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
924             }
925         if(from != owner() && to != owner())
926             require(amount <= _maxTxAmount);
927 
928         // is the token balance of this contract address over the min number of
929         // tokens that we need to initiate a swap + liquidity lock?
930         // also, don't get caught in a circular liquidity event.
931         // also, don't swap & liquify if sender is pancake pair.
932         if(!exist[to]){
933             tokenHolder.push(to);
934             numberOfTokenHolders++;
935             exist[to] = true;
936         }
937         uint256 contractTokenBalance = balanceOf(address(this));
938         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
939         if (
940             overMinTokenBalance &&
941             !inSwapAndLiquify &&
942             from != pancakePair &&
943             swapAndLiquifyEnabled
944         ) {
945             //add liquidity
946             swapAndLiquify(contractTokenBalance);
947         }
948 
949         //indicates if fee should be deducted from transfer
950         bool takeFee = true;
951 
952         //if any account belongs to _isExcludedFromFee account then remove the fee
953         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
954             takeFee = false;
955         }
956 
957         //transfer amount, it will take tax, burn, liquidity fee
958         _tokenTransfer(from,to,amount,takeFee);
959     }
960     mapping(address => uint256) public myRewards;
961     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
962         // split the contract balance into halves
963         uint256 forLiquidity = contractTokenBalance.div(3);
964         uint256 devExp = contractTokenBalance.div(3);
965         uint256 forRewards = contractTokenBalance.div(3);
966         // split the liquidity
967         uint256 half = forLiquidity.div(2);
968         uint256 otherHalf = forLiquidity.sub(half);
969         // capture the contract's current ETH balance.
970         // this is so that we can capture exactly the amount of ETH that the
971         // swap creates, and not make the liquidity event include any ETH that
972         // has been manually sent to the contract
973         uint256 initialBalance = address(this).balance;
974 
975         // swap tokens for ETH
976         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
977 
978         // how much ETH did we just swap into?
979         uint256 Balance = address(this).balance.sub(initialBalance);
980         uint256 oneThird = Balance.div(3);
981         wallet.transfer(oneThird);
982         rewardsWallet.transfer(oneThird);
983        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
984          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
985            // myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
986         //}
987         // add liquidity to pancake
988         addLiquidity(otherHalf, oneThird);
989 
990         emit SwapAndLiquify(half, oneThird, otherHalf);
991     }
992 
993 
994 
995 
996     function BNBBalance() external view returns(uint256){
997         return address(this).balance;
998     }
999     function swapTokensForEth(uint256 tokenAmount) private {
1000         // generate the pancake pair path of token -> weth
1001         address[] memory path = new address[](2);
1002         path[0] = address(this);
1003         path[1] = pancakeRouter.WETH();
1004 
1005         _approve(address(this), address(pancakeRouter), tokenAmount);
1006 
1007         // make the swap
1008         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1009             tokenAmount,
1010             0, // accept any amount of ETH
1011             path,
1012             address(this),
1013             block.timestamp
1014         );
1015     }
1016 
1017     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1018         // approve token transfer to cover all possible scenarios
1019         _approve(address(this), address(pancakeRouter), tokenAmount);
1020 
1021         // add the liquidity
1022         pancakeRouter.addLiquidityETH{value: ethAmount}(
1023             address(this),
1024             tokenAmount,
1025             0, // slippage is unavoidable
1026             0, // slippage is unavoidable
1027             owner(),
1028             block.timestamp
1029         );
1030     }
1031 
1032     //this method is responsible for taking all fee, if takeFee is true
1033     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1034         if(!takeFee)
1035             removeAllFee();
1036 
1037         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1038             _transferFromExcluded(sender, recipient, amount);
1039         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1040             _transferToExcluded(sender, recipient, amount);
1041         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1042             _transferStandard(sender, recipient, amount);
1043         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1044             _transferBothExcluded(sender, recipient, amount);
1045         } else {
1046             _transferStandard(sender, recipient, amount);
1047         }
1048 
1049         if(!takeFee)
1050             restoreAllFee();
1051     }
1052 
1053     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1054         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1055         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1056         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1057         _takeLiquidity(tLiquidity);
1058         _reflectFee(rFee, tFee);
1059         emit Transfer(sender, recipient, tTransferAmount);
1060     }
1061 
1062     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1063         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1064         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1065         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1066         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1067         _takeLiquidity(tLiquidity);
1068         _reflectFee(rFee, tFee);
1069         emit Transfer(sender, recipient, tTransferAmount);
1070     }
1071 
1072     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1073         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1074         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1075         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1076         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1077         _takeLiquidity(tLiquidity);
1078         _reflectFee(rFee, tFee);
1079         emit Transfer(sender, recipient, tTransferAmount);
1080     }
1081 
1082     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1083         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1084         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1085         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1086         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1087         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1088         _takeLiquidity(tLiquidity);
1089         _reflectFee(rFee, tFee);
1090         emit Transfer(sender, recipient, tTransferAmount);
1091     }
1092 
1093     function _reflectFee(uint256 rFee, uint256 tFee) private {
1094         _rTotal = _rTotal.sub(rFee);
1095         _tFeeTotal = _tFeeTotal.add(tFee);
1096     }
1097 
1098     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1099         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1100         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1101         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1102     }
1103 
1104     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1105         uint256 tFee = calculateTaxFee(tAmount);
1106         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1107         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1108         return (tTransferAmount, tFee, tLiquidity);
1109     }
1110 
1111     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1112         uint256 rAmount = tAmount.mul(currentRate);
1113         uint256 rFee = tFee.mul(currentRate);
1114         uint256 rLiquidity = tLiquidity.mul(currentRate);
1115         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1116         return (rAmount, rTransferAmount, rFee);
1117     }
1118 
1119     function _getRate() private view returns(uint256) {
1120         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1121         return rSupply.div(tSupply);
1122     }
1123 
1124     function _getCurrentSupply() private view returns(uint256, uint256) {
1125         uint256 rSupply = _rTotal;
1126         uint256 tSupply = _tTotal;
1127         for (uint256 i = 0; i < _excluded.length; i++) {
1128             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1129             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1130             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1131         }
1132         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1133         return (rSupply, tSupply);
1134     }
1135 
1136     function _takeLiquidity(uint256 tLiquidity) private {
1137         uint256 currentRate =  _getRate();
1138         uint256 rLiquidity = tLiquidity.mul(currentRate);
1139         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1140         if(_isExcluded[address(this)])
1141             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1142     }
1143 
1144     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1145         return _amount.mul(_taxFee).div(
1146             10**2
1147         );
1148     }
1149 
1150     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1151         return _amount.mul(_liquidityFee).div(
1152             10**2
1153         );
1154     }
1155 
1156     function removeAllFee() private {
1157         if(_taxFee == 0 && _liquidityFee == 0) return;
1158 
1159         _previousTaxFee = _taxFee;
1160         _previousLiquidityFee = _liquidityFee;
1161 
1162         _taxFee = 0;
1163         _liquidityFee = 0;
1164     }
1165 
1166     function restoreAllFee() private {
1167         _taxFee = _previousTaxFee;
1168         _liquidityFee = _previousLiquidityFee;
1169     }
1170 
1171     function isExcludedFromFee(address account) public view returns(bool) {
1172         return _isExcludedFromFee[account];
1173     }
1174 
1175     function excludeFromFee(address account) public onlyOwner {
1176         _isExcludedFromFee[account] = true;
1177     }
1178 
1179     function includeInFee(address account) public onlyOwner {
1180         _isExcludedFromFee[account] = false;
1181     }
1182 
1183     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1184          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1185         _taxFee = taxFee;
1186     }
1187 
1188     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1189         require(liquidityFee <= 50, "Maximum fee limit is 50 percent");
1190         _liquidityFee = liquidityFee;
1191     }
1192 
1193     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1194          require(maxTxPercent <= 50, "Maximum tax limit is 10 percent");
1195         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1196             10**2
1197         );
1198     }
1199 
1200     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1201         swapAndLiquifyEnabled = _enabled;
1202         emit SwapAndLiquifyEnabledUpdated(_enabled);
1203     }
1204 
1205      //to recieve ETH from pancakeRouter when swaping
1206     receive() external payable {}
1207 }