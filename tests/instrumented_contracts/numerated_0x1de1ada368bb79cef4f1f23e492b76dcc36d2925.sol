1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 /**
388  * @dev Contract module which provides a basic access control mechanism, where
389  * there is an account (an owner) that can be granted exclusive access to
390  * specific functions.
391  *
392  * By default, the owner account will be the one that deploys the contract. This
393  * can later be changed with {transferOwnership}.
394  *
395  * This module is used through inheritance. It will make available the modifier
396  * `onlyOwner`, which can be applied to your functions to restrict their use to
397  * the owner.
398  */
399 contract Ownable is Context {
400     address private _owner;
401     address private _previousOwner;
402     uint256 private _lockTime;
403 
404     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
405 
406     /**
407      * @dev Initializes the contract setting the deployer as the initial owner.
408      */
409     constructor () internal {
410         address msgSender = _msgSender();
411         _owner = _msgSender();
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
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         require(_owner == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429 
430      /**
431      * @dev Leaves the contract without owner. It will not be possible to call
432      * `onlyOwner` functions anymore. Can only be called by the current owner.
433      *
434      * NOTE: Renouncing ownership will leave the contract without an owner,
435      * thereby removing any functionality that is only available to the owner.
436      */
437     function renounceOwnership() public virtual onlyOwner {
438         emit OwnershipTransferred(_owner, address(0));
439         _owner = address(0);
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Can only be called by the current owner.
445      */
446     function transferOwnership(address newOwner) public virtual onlyOwner {
447         require(newOwner != address(0), "Ownable: new owner is the zero address");
448         emit OwnershipTransferred(_owner, newOwner);
449         _owner = newOwner;
450     }
451 
452     function geUnlockTime() public view returns (uint256) {
453         return _lockTime;
454     }
455 
456     //Locks the contract for owner for the amount of time provided
457     function lock(uint256 time) public virtual onlyOwner {
458         _previousOwner = _owner;
459         _owner = address(0);
460         _lockTime = now + time;
461         emit OwnershipTransferred(_owner, address(0));
462     }
463 
464     //Unlocks the contract for owner when _lockTime is exceeds
465     function unlock() public virtual {
466         require(_previousOwner == msg.sender, "You don't have permission to unlock");
467         require(now > _lockTime , "Contract is locked until 7 days");
468         emit OwnershipTransferred(_owner, _previousOwner);
469         _owner = _previousOwner;
470     }
471 }
472 
473 // pragma solidity >=0.5.0;
474 
475 interface IPancakeFactory {
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
491 // pragma solidity >=0.5.0;
492 
493 interface IPancakePair {
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
546 interface IPancakeRouter01 {
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
644 interface IPancakeRouter02 is IPancakeRouter01 {
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
685 contract ErzaInu is Context, IERC20, Ownable {
686     using SafeMath for uint256;
687     using Address for address;
688 
689     mapping (address => uint256) private _rOwned;
690     mapping (address => uint256) private _tOwned;
691     mapping (address => mapping (address => uint256)) private _allowances;
692     mapping (address => bool) private _isExcludedFromFee;
693 
694     mapping (address => bool) private _isExcluded;
695     mapping (address => User) private cooldown;
696     address[] private _excluded;
697 
698     uint256 private constant MAX = ~uint256(0);
699     uint256 private _tTotal = 100000000 * 10**6 * 10**9;
700     uint256 private _rTotal = (MAX - (MAX % _tTotal));
701     uint256 private _tFeeTotal;
702 
703     string private _name = "Erza Inu";
704     string private _symbol = "ERZA";
705     uint8 private _decimals = 9;
706 
707     uint256 public _taxFee = 1;
708     uint256 private _previousTaxFee = _taxFee;
709 
710     uint256 public _liquidityFee = 9; //(2% liquidityAddition + 3% rewardsDistribution + 5% devExpenses)
711     uint256 private _previousLiquidityFee = _liquidityFee;
712     bool private _cooldownEnabled = true;
713 
714     address [] public tokenHolder;
715     uint256 public numberOfTokenHolders = 0;
716     mapping(address => bool) public exist;
717 
718     mapping (address => bool) private _isBlackListedBot;
719     address[] private _blackListedBots;
720     mapping (address => bool) private bots;
721     mapping (address => bool) private _isBlacklisted;
722 
723     // limit
724     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
725     uint256 public _maxBuyAmount = 100000 * 10**6 * 10**9;
726 
727     address payable wallet;
728     address payable rewardsWallet;
729     address payable marketingWallet;
730     IPancakeRouter02 public pancakeRouter;
731     address public pancakePair;
732     uint256 private buyLimitEnd;
733 
734     bool inSwapAndLiquify;
735     bool public swapAndLiquifyEnabled = false;
736     uint256 private minTokensBeforeSwap = 8;
737 
738         struct User {
739         uint256 buy;
740         uint256 sell;
741         bool exists;
742     }
743 
744     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
745     event SwapAndLiquifyEnabledUpdated(bool enabled);
746     event SwapAndLiquify(
747         uint256 tokensSwapped,
748         uint256 ethReceived,
749         uint256 tokensIntoLiqudity
750     );
751     event CooldownEnabledUpdated(bool _cooldown);
752     modifier lockTheSwap {
753         inSwapAndLiquify = true;
754          _;
755         inSwapAndLiquify = false;
756     }
757 
758     constructor (address payable addr1, address payable addr2, address payable addr3) public {
759         _rOwned[_msgSender()] = _rTotal;
760 
761         wallet = addr1;
762         rewardsWallet = addr2;
763         marketingWallet = addr3;
764 
765         //exclude owner and this contract from fee
766         _isExcludedFromFee[owner()] = true;
767         _isExcludedFromFee[address(this)] = true;
768         _isExcludedFromFee[addr3] = true;
769         _isExcludedFromFee[wallet] = true;
770         _isExcludedFromFee[rewardsWallet] = true;
771 
772         emit Transfer(address(0), _msgSender(), _tTotal);
773     }
774 
775     // @dev set Pair
776     function setPair(address _pancakePair) external onlyOwner {
777         pancakePair = _pancakePair;
778     }
779 
780     // @dev set Router
781     function setRouter(address _newPancakeRouter) external onlyOwner {
782         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_newPancakeRouter);
783         pancakeRouter = _pancakeRouter;
784     }
785 
786     function name() public view returns (string memory) {
787         return _name;
788     }
789 
790     function symbol() public view returns (string memory) {
791         return _symbol;
792     }
793 
794     function decimals() public view returns (uint8) {
795         return _decimals;
796     }
797 
798     function totalSupply() public view override returns (uint256) {
799         return _tTotal;
800     }
801 
802     function balanceOf(address account) public view override returns (uint256) {
803         if (_isExcluded[account]) return _tOwned[account];
804         return tokenFromReflection(_rOwned[account]);
805     }
806 
807     function transfer(address recipient, uint256 amount) public override returns (bool) {
808         _transfer(_msgSender(), recipient, amount);
809         return true;
810     }
811 
812     function addBotToBlackList(address account) external onlyOwner() {
813         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
814         require(!_isBlackListedBot[account], "Account is already blacklisted");
815         _isBlackListedBot[account] = true;
816         _blackListedBots.push(account);
817     }
818 
819     function removeBotFromBlackList(address account) external onlyOwner() {
820         require(_isBlackListedBot[account], "Account is not blacklisted");
821         for (uint256 i = 0; i < _blackListedBots.length; i++) {
822             if (_blackListedBots[i] == account) {
823                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
824                 _isBlackListedBot[account] = false;
825                 _blackListedBots.pop();
826                 break;
827             }
828         }
829     }
830 
831     function isBlackListed(address account) public view returns (bool) {
832         return _isBlackListedBot[account];
833     }
834 
835     function blacklistSingleWallet(address addresses) public onlyOwner(){
836         if(_isBlacklisted[addresses] == true) return;
837         _isBlacklisted[addresses] = true;
838     }
839 
840     function blacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
841         for (uint256 i; i < addresses.length; ++i) {
842             _isBlacklisted[addresses[i]] = true;
843         }
844     }
845 
846     function isBlacklisted(address addresses) public view returns (bool){
847         if(_isBlacklisted[addresses] == true) return true;
848         else return false;
849     }
850 
851 
852     function unBlacklistSingleWallet(address addresses) external onlyOwner(){
853          if(_isBlacklisted[addresses] == false) return;
854         _isBlacklisted[addresses] = false;
855     }
856 
857     function unBlacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
858         for (uint256 i; i < addresses.length; ++i) {
859             _isBlacklisted[addresses[i]] = false;
860         }
861     }
862 
863     function allowance(address owner, address spender) public view override returns (uint256) {
864         return _allowances[owner][spender];
865     }
866 
867     function approve(address spender, uint256 amount) public override returns (bool) {
868         _approve(_msgSender(), spender, amount);
869         return true;
870     }
871 
872     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
873         _transfer(sender, recipient, amount);
874         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
875         return true;
876     }
877 
878     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
879         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
880         return true;
881     }
882 
883     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
884         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
885         return true;
886     }
887 
888     function isExcludedFromReward(address account) public view returns (bool) {
889         return _isExcluded[account];
890     }
891 
892     function totalFees() public view returns (uint256) {
893         return _tFeeTotal;
894     }
895 
896     function deliver(uint256 tAmount) public {
897         address sender = _msgSender();
898         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
899         (uint256 rAmount,,,,,) = _getValues(tAmount);
900         _rOwned[sender] = _rOwned[sender].sub(rAmount);
901         _rTotal = _rTotal.sub(rAmount);
902         _tFeeTotal = _tFeeTotal.add(tAmount);
903     }
904 
905     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
906         require(tAmount <= _tTotal, "Amount must be less than supply");
907         if (!deductTransferFee) {
908             (uint256 rAmount,,,,,) = _getValues(tAmount);
909             return rAmount;
910         } else {
911             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
912             return rTransferAmount;
913         }
914     }
915 
916     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
917         require(rAmount <= _rTotal, "Amount must be less than total reflections");
918         uint256 currentRate =  _getRate();
919         return rAmount.div(currentRate);
920     }
921 
922     function excludeFromReward(address account) public onlyOwner() {
923         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancake router.');
924         require(!_isExcluded[account], "Account is already excluded");
925         if(_rOwned[account] > 0) {
926             _tOwned[account] = tokenFromReflection(_rOwned[account]);
927         }
928         _isExcluded[account] = true;
929         _excluded.push(account);
930     }
931 
932     function includeInReward(address account) external onlyOwner() {
933         require(_isExcluded[account], "Account is already excluded");
934         for (uint256 i = 0; i < _excluded.length; i++) {
935             if (_excluded[i] == account) {
936                 _excluded[i] = _excluded[_excluded.length - 1];
937                 _tOwned[account] = 0;
938                 _isExcluded[account] = false;
939                 _excluded.pop();
940                 break;
941             }
942         }
943     }
944 
945     function _approve(address owner, address spender, uint256 amount) private {
946         require(owner != address(0));
947         require(spender != address(0));
948 
949         _allowances[owner][spender] = amount;
950         emit Approval(owner, spender, amount);
951     }
952 
953     bool public limit = true;
954     function changeLimit() public onlyOwner(){
955         require(limit == true, 'limit is already false');
956             limit = false;
957             buyLimitEnd = block.timestamp + (120 seconds);
958     }
959 
960 
961 
962     function expectedRewards(address _sender) external view returns(uint256){
963         uint256 _balance = address(this).balance;
964         address sender = _sender;
965         uint256 holdersBal = balanceOf(sender);
966         uint totalExcludedBal;
967         for(uint256 i = 0; i<_excluded.length; i++){
968          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);
969         }
970         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(pancakePair)).sub(totalExcludedBal));
971         return rewards;
972     }
973 
974     function _transfer(
975         address from,
976         address to,
977         uint256 amount
978     ) private {
979         require(from != address(0), "ERC20: transfer from the zero address");
980         require(to != address(0), "ERC20: transfer to the zero address");
981         require(amount > 0, "Transfer amount must be greater than zero");
982         require(!_isBlackListedBot[to], "You have no power here!");
983         require(!_isBlackListedBot[from], "You have no power here!");
984         require(_isBlacklisted[from] == false || to == address(0), "You are banned");
985         require(_isBlacklisted[to] == false, "The recipient is banned");
986 
987         if (!_isExcludedFromFee[to] && !_isExcludedFromFee[from])
988         {
989             require(limit == false, "You have no power here!");
990         }
991 
992         if(limit ==  true && from != owner() && to != owner() && !_isExcludedFromFee[to]){
993             if(to != pancakePair){
994                 require(((balanceOf(to).add(amount)) <= 500 ether));
995             }
996             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
997             }
998         if(from != owner() && to != owner() && !_isExcludedFromFee[to]) {
999                         if(_cooldownEnabled) {
1000                 if(!cooldown[msg.sender].exists) {
1001                     cooldown[msg.sender] = User(0,0,true);
1002                 }
1003             }
1004         }
1005 
1006             // buy
1007             if(from == pancakePair && to != address(pancakeRouter) && !_isExcludedFromFee[to]) {
1008                     if(buyLimitEnd > block.timestamp) {
1009                         require(amount <= _maxBuyAmount);
1010                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
1011                         cooldown[to].buy = block.timestamp + (30 seconds);
1012                     }
1013 
1014             }
1015 
1016         // is the token balance of this contract address over the min number of
1017         // tokens that we need to initiate a swap + liquidity lock?
1018         // also, don't get caught in a circular liquidity event.
1019         // also, don't swap & liquify if sender is pancake pair.
1020         if(!exist[to]){
1021             tokenHolder.push(to);
1022             numberOfTokenHolders++;
1023             exist[to] = true;
1024         }
1025         uint256 contractTokenBalance = balanceOf(address(this));
1026         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
1027         if (
1028             overMinTokenBalance &&
1029             !inSwapAndLiquify &&
1030             from != pancakePair &&
1031             swapAndLiquifyEnabled
1032         ) {
1033             //add liquidity
1034             swapAndLiquify(contractTokenBalance);
1035         }
1036 
1037         //indicates if fee should be deducted from transfer
1038         bool takeFee = true;
1039 
1040         //if any account belongs to _isExcludedFromFee account then remove the fee
1041         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1042             takeFee = false;
1043         }
1044 
1045         //transfer amount, it will take tax, burn, liquidity fee
1046         _tokenTransfer(from,to,amount,takeFee);
1047     }
1048     mapping(address => uint256) public myRewards;
1049     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1050         // split the contract balance into halves
1051         uint256 forLiquidity = contractTokenBalance.div(3);
1052         uint256 devExp = contractTokenBalance.div(3);
1053         uint256 forRewards = contractTokenBalance.div(3);
1054         // split the liquidity
1055         uint256 half = forLiquidity.div(2);
1056         uint256 otherHalf = forLiquidity.sub(half);
1057         // capture the contract's current ETH balance.
1058         // this is so that we can capture exactly the amount of ETH that the
1059         // swap creates, and not make the liquidity event include any ETH that
1060         // has been manually sent to the contract
1061         uint256 initialBalance = address(this).balance;
1062 
1063         // swap tokens for ETH
1064         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1065 
1066         // how much ETH did we just swap into?
1067         uint256 Balance = address(this).balance.sub(initialBalance);
1068         uint256 oneThird = Balance.div(3);
1069         uint256 devTeam = Balance.div(5);
1070         wallet.transfer(devTeam);
1071         rewardsWallet.transfer(oneThird);
1072        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
1073          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
1074            // myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
1075         //}
1076         // add liquidity to pancake
1077         addLiquidity(otherHalf, oneThird);
1078 
1079         emit SwapAndLiquify(half, oneThird, otherHalf);
1080     }
1081 
1082 
1083 
1084 
1085     function BNBBalance() external view returns(uint256){
1086         return address(this).balance;
1087     }
1088     function swapTokensForEth(uint256 tokenAmount) private {
1089         // generate the pancake pair path of token -> weth
1090         address[] memory path = new address[](2);
1091         path[0] = address(this);
1092         path[1] = pancakeRouter.WETH();
1093 
1094         _approve(address(this), address(pancakeRouter), tokenAmount);
1095 
1096         // make the swap
1097         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1098             tokenAmount,
1099             0, // accept any amount of ETH
1100             path,
1101             address(this),
1102             block.timestamp
1103         );
1104     }
1105 
1106     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1107         // approve token transfer to cover all possible scenarios
1108         _approve(address(this), address(pancakeRouter), tokenAmount);
1109 
1110         // add the liquidity
1111         pancakeRouter.addLiquidityETH{value: ethAmount}(
1112             address(this),
1113             tokenAmount,
1114             0, // slippage is unavoidable
1115             0, // slippage is unavoidable
1116             owner(),
1117             block.timestamp
1118         );
1119     }
1120 
1121     //this method is responsible for taking all fee, if takeFee is true
1122     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1123         if(!takeFee)
1124             removeAllFee();
1125 
1126         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1127             _transferFromExcluded(sender, recipient, amount);
1128         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1129             _transferToExcluded(sender, recipient, amount);
1130         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1131             _transferStandard(sender, recipient, amount);
1132         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1133             _transferBothExcluded(sender, recipient, amount);
1134         } else {
1135             _transferStandard(sender, recipient, amount);
1136         }
1137 
1138         if(!takeFee)
1139             restoreAllFee();
1140     }
1141 
1142     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1143         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1144         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1145         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1146         _takeLiquidity(tLiquidity);
1147         _reflectFee(rFee, tFee);
1148         emit Transfer(sender, recipient, tTransferAmount);
1149     }
1150 
1151     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1152         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1153         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1154         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1155         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1156         _takeLiquidity(tLiquidity);
1157         _reflectFee(rFee, tFee);
1158         emit Transfer(sender, recipient, tTransferAmount);
1159     }
1160 
1161     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1162         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1163         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1164         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1165         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1166         _takeLiquidity(tLiquidity);
1167         _reflectFee(rFee, tFee);
1168         emit Transfer(sender, recipient, tTransferAmount);
1169     }
1170 
1171     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1172         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1173         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1174         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1175         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1176         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1177         _takeLiquidity(tLiquidity);
1178         _reflectFee(rFee, tFee);
1179         emit Transfer(sender, recipient, tTransferAmount);
1180     }
1181 
1182     function _reflectFee(uint256 rFee, uint256 tFee) private {
1183         _rTotal = _rTotal.sub(rFee);
1184         _tFeeTotal = _tFeeTotal.add(tFee);
1185     }
1186 
1187     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1188         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1189         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1190         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1191     }
1192 
1193     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1194         uint256 tFee = calculateTaxFee(tAmount);
1195         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1196         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1197         return (tTransferAmount, tFee, tLiquidity);
1198     }
1199 
1200     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1201         uint256 rAmount = tAmount.mul(currentRate);
1202         uint256 rFee = tFee.mul(currentRate);
1203         uint256 rLiquidity = tLiquidity.mul(currentRate);
1204         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1205         return (rAmount, rTransferAmount, rFee);
1206     }
1207 
1208     function _getRate() private view returns(uint256) {
1209         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1210         return rSupply.div(tSupply);
1211     }
1212 
1213     function _getCurrentSupply() private view returns(uint256, uint256) {
1214         uint256 rSupply = _rTotal;
1215         uint256 tSupply = _tTotal;
1216         for (uint256 i = 0; i < _excluded.length; i++) {
1217             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1218             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1219             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1220         }
1221         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1222         return (rSupply, tSupply);
1223     }
1224 
1225     function _takeLiquidity(uint256 tLiquidity) private {
1226         uint256 currentRate =  _getRate();
1227         uint256 rLiquidity = tLiquidity.mul(currentRate);
1228         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1229         if(_isExcluded[address(this)])
1230             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1231     }
1232 
1233     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1234         return _amount.mul(_taxFee).div(
1235             10**2
1236         );
1237     }
1238 
1239     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1240         return _amount.mul(_liquidityFee).div(
1241             10**2
1242         );
1243     }
1244 
1245     function removeAllFee() private {
1246         if(_taxFee == 0 && _liquidityFee == 0) return;
1247 
1248         _previousTaxFee = _taxFee;
1249         _previousLiquidityFee = _liquidityFee;
1250 
1251         _taxFee = 0;
1252         _liquidityFee = 0;
1253     }
1254 
1255     function restoreAllFee() private {
1256         _taxFee = _previousTaxFee;
1257         _liquidityFee = _previousLiquidityFee;
1258     }
1259 
1260     function excludeFromFee(address account) public onlyOwner {
1261         _isExcludedFromFee[account] = true;
1262     }
1263 
1264     function includeInFee(address account) public onlyOwner {
1265         _isExcludedFromFee[account] = false;
1266     }
1267 
1268     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1269          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1270         _taxFee = taxFee;
1271     }
1272 
1273     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1274         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1275         _liquidityFee = liquidityFee;
1276     }
1277 
1278     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1279           require(maxTxPercent <= 100, "Maximum tax limit is 10 percent");
1280         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1281             10**2);
1282             _maxBuyAmount = _tTotal.mul(maxTxPercent).div(
1283                 10**2);
1284     }
1285 
1286     function setCooldownEnabled(bool onoff) external onlyOwner() {
1287         _cooldownEnabled = onoff;
1288         emit CooldownEnabledUpdated(_cooldownEnabled);
1289     }
1290 
1291     function manualswap() external {
1292         require(_msgSender() == rewardsWallet);
1293         uint256 contractBalance = balanceOf(address(this));
1294         swapTokensForEth(contractBalance);
1295     }
1296 
1297     function manualSend() external {
1298         uint256 contractETHBalance = address(this).balance;
1299         sendETHToMarketing(contractETHBalance);
1300     }
1301 
1302     function sendETHToMarketing(uint256 amount) private {
1303         marketingWallet.transfer(amount);
1304     }
1305 
1306     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1307         swapAndLiquifyEnabled = _enabled;
1308         emit SwapAndLiquifyEnabledUpdated(_enabled);
1309     }
1310 
1311         function timeToBuy(address buyer) public view returns (uint) {
1312         return block.timestamp - cooldown[buyer].buy;
1313     }
1314 
1315      //to recieve ETH from pancakeRouter when swaping
1316     receive() external payable {}
1317 }