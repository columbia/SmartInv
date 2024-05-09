1 /*
2 
3     Tigger Inu - $TIGGER
4 
5     $TIGGER is an automatic liquidity providing protocol that pays out static rewards to holders. 
6     1% reflection 6% liq 6% marketing
7 
8     https://t.me/TiggerInuToken
9 
10     https://www.tiggerinu.com
11 
12     https://twitter.com/TiggerInuToken
13 
14 */
15 
16 
17 
18 // SPDX-License-Identifier: Unlicensed
19 
20 pragma solidity ^0.8.9;
21 interface IERC20 {
22 
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
249 abstract contract Context {
250     //function _msgSender() internal view virtual returns (address payable) {
251     function _msgSender() internal view virtual returns (address) {
252         return msg.sender;
253     }
254 
255     function _msgData() internal view virtual returns (bytes memory) {
256         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
257         return msg.data;
258     }
259 }
260 
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 /**
401  * @dev Contract module which provides a basic access control mechanism, where
402  * there is an account (an owner) that can be granted exclusive access to
403  * specific functions.
404  *
405  * By default, the owner account will be the one that deploys the contract. This
406  * can later be changed with {transferOwnership}.
407  *
408  * This module is used through inheritance. It will make available the modifier
409  * `onlyOwner`, which can be applied to your functions to restrict their use to
410  * the owner.
411  */
412 contract Ownable is Context {
413     address private _owner;
414     address private _previousOwner;
415     uint256 private _lockTime;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor () {
423         address msgSender = _msgSender();
424         _owner = msgSender;
425         emit OwnershipTransferred(address(0), msgSender);
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(_owner == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443      /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         emit OwnershipTransferred(_owner, address(0));
452         _owner = address(0);
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) public virtual onlyOwner {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         emit OwnershipTransferred(_owner, newOwner);
462         _owner = newOwner;
463     }
464 
465     function geUnlockTime() public view returns (uint256) {
466         return _lockTime;
467     }
468 
469     //Locks the contract for owner for the amount of time provided
470     function lock(uint256 time) public virtual onlyOwner {
471         _previousOwner = _owner;
472         _owner = address(0);
473         _lockTime = block.timestamp + time;
474         emit OwnershipTransferred(_owner, address(0));
475     }
476     
477     //Unlocks the contract for owner when _lockTime is exceeds
478     function unlock() public virtual {
479         require(_previousOwner == msg.sender, "You don't have permission to unlock");
480         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
481         emit OwnershipTransferred(_owner, _previousOwner);
482         _owner = _previousOwner;
483     }
484 }
485 
486 
487 interface IUniswapV2Factory {
488     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
489 
490     function feeTo() external view returns (address);
491     function feeToSetter() external view returns (address);
492 
493     function getPair(address tokenA, address tokenB) external view returns (address pair);
494     function allPairs(uint) external view returns (address pair);
495     function allPairsLength() external view returns (uint);
496 
497     function createPair(address tokenA, address tokenB) external returns (address pair);
498 
499     function setFeeTo(address) external;
500     function setFeeToSetter(address) external;
501 }
502 
503 
504 
505 interface IUniswapV2Pair {
506     event Approval(address indexed owner, address indexed spender, uint value);
507     event Transfer(address indexed from, address indexed to, uint value);
508 
509     function name() external pure returns (string memory);
510     function symbol() external pure returns (string memory);
511     function decimals() external pure returns (uint8);
512     function totalSupply() external view returns (uint);
513     function balanceOf(address owner) external view returns (uint);
514     function allowance(address owner, address spender) external view returns (uint);
515 
516     function approve(address spender, uint value) external returns (bool);
517     function transfer(address to, uint value) external returns (bool);
518     function transferFrom(address from, address to, uint value) external returns (bool);
519 
520     function DOMAIN_SEPARATOR() external view returns (bytes32);
521     function PERMIT_TYPEHASH() external pure returns (bytes32);
522     function nonces(address owner) external view returns (uint);
523 
524     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
525 
526     event Mint(address indexed sender, uint amount0, uint amount1);
527     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
528     event Swap(
529         address indexed sender,
530         uint amount0In,
531         uint amount1In,
532         uint amount0Out,
533         uint amount1Out,
534         address indexed to
535     );
536     event Sync(uint112 reserve0, uint112 reserve1);
537 
538     function MINIMUM_LIQUIDITY() external pure returns (uint);
539     function factory() external view returns (address);
540     function token0() external view returns (address);
541     function token1() external view returns (address);
542     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
543     function price0CumulativeLast() external view returns (uint);
544     function price1CumulativeLast() external view returns (uint);
545     function kLast() external view returns (uint);
546 
547     function mint(address to) external returns (uint liquidity);
548     function burn(address to) external returns (uint amount0, uint amount1);
549     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
550     function skim(address to) external;
551     function sync() external;
552 
553     function initialize(address, address) external;
554 }
555 
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
653 
654 interface IUniswapV2Router02 is IUniswapV2Router01 {
655     function removeLiquidityETHSupportingFeeOnTransferTokens(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline
662     ) external returns (uint amountETH);
663     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
664         address token,
665         uint liquidity,
666         uint amountTokenMin,
667         uint amountETHMin,
668         address to,
669         uint deadline,
670         bool approveMax, uint8 v, bytes32 r, bytes32 s
671     ) external returns (uint amountETH);
672 
673     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external;
680     function swapExactETHForTokensSupportingFeeOnTransferTokens(
681         uint amountOutMin,
682         address[] calldata path,
683         address to,
684         uint deadline
685     ) external payable;
686     function swapExactTokensForETHSupportingFeeOnTransferTokens(
687         uint amountIn,
688         uint amountOutMin,
689         address[] calldata path,
690         address to,
691         uint deadline
692     ) external;
693 }
694 
695 contract TIGGER is Context, IERC20, Ownable {
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
714     uint256 private _tTotal = 69000000000000000000000 * 10**9;
715     uint256 private _rTotal = (MAX - (MAX % _tTotal));
716     uint256 private _tFeeTotal;
717     address public marketingWallet;
718 
719     string private _name = "Tigger Inu";
720     string private _symbol = "TIGGER";
721     uint8 private _decimals = 9;
722     
723     uint256 public _taxFee = 1;
724     uint256 private _previousTaxFee = _taxFee;
725     
726     uint256 public _liquidityFee = 12;
727     uint256 private _previousLiquidityFee = _liquidityFee;
728 
729     IUniswapV2Router02 public immutable uniswapV2Router;
730     address public immutable uniswapV2Pair;
731     
732     bool inSwapAndLiquify;
733     bool public swapAndLiquifyEnabled = true;
734     
735     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
736     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
737     
738     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
739     event SwapAndLiquifyEnabledUpdated(bool enabled);
740     event SwapAndLiquify(
741         uint256 tokensSwapped,
742         uint256 ethReceived,
743         uint256 tokensIntoLiqudity
744     );
745     
746     modifier lockTheSwap {
747         inSwapAndLiquify = true;
748         _;
749         inSwapAndLiquify = false;
750     }
751     
752     constructor () {
753         _rOwned[_msgSender()] = _rTotal;
754         
755         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
756          // Create a uniswap pair for this new token
757         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
758             .createPair(address(this), _uniswapV2Router.WETH());
759 
760         // set the rest of the contract variables
761         uniswapV2Router = _uniswapV2Router;
762         
763         //exclude owner and this contract from fee
764         _isExcludedFromFee[owner()] = true;
765         _isExcludedFromFee[address(this)] = true;
766         
767         emit Transfer(address(0), _msgSender(), _tTotal);
768     }
769 
770     function name() public view returns (string memory) {
771         return _name;
772     }
773 
774     function symbol() public view returns (string memory) {
775         return _symbol;
776     }
777 
778     function decimals() public view returns (uint8) {
779         return _decimals;
780     }
781 
782     function totalSupply() public view override returns (uint256) {
783         return _tTotal;
784     }
785 
786     function balanceOf(address account) public view override returns (uint256) {
787         if (_isExcluded[account]) return _tOwned[account];
788         return tokenFromReflection(_rOwned[account]);
789     }
790 
791     function transfer(address recipient, uint256 amount) public override returns (bool) {
792         _transfer(_msgSender(), recipient, amount);
793         return true;
794     }
795 
796     function allowance(address owner, address spender) public view override returns (uint256) {
797         return _allowances[owner][spender];
798     }
799 
800     function approve(address spender, uint256 amount) public override returns (bool) {
801         _approve(_msgSender(), spender, amount);
802         return true;
803     }
804 
805     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
806         _transfer(sender, recipient, amount);
807         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
808         return true;
809     }
810 
811     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
812         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
813         return true;
814     }
815 
816     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
817         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
818         return true;
819     }
820 
821     function isExcludedFromReward(address account) public view returns (bool) {
822         return _isExcluded[account];
823     }
824 
825     function totalFees() public view returns (uint256) {
826         return _tFeeTotal;
827     }
828     
829     function airdrop(address recipient, uint256 amount) external onlyOwner() {
830         removeAllFee();
831         _transfer(_msgSender(), recipient, amount * 10**9);
832         restoreAllFee();
833     }
834     
835     function airdropInternal(address recipient, uint256 amount) internal {
836         removeAllFee();
837         _transfer(_msgSender(), recipient, amount);
838         restoreAllFee();
839     }
840     
841     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
842         uint256 iterator = 0;
843         require(newholders.length == amounts.length, "must be the same length");
844         while(iterator < newholders.length){
845             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
846             iterator += 1;
847         }
848     }
849 
850     function deliver(uint256 tAmount) public {
851         address sender = _msgSender();
852         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
853         (uint256 rAmount,,,,,) = _getValues(tAmount);
854         _rOwned[sender] = _rOwned[sender].sub(rAmount);
855         _rTotal = _rTotal.sub(rAmount);
856         _tFeeTotal = _tFeeTotal.add(tAmount);
857     }
858 
859     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
860         require(tAmount <= _tTotal, "Amount must be less than supply");
861         if (!deductTransferFee) {
862             (uint256 rAmount,,,,,) = _getValues(tAmount);
863             return rAmount;
864         } else {
865             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
866             return rTransferAmount;
867         }
868     }
869 
870     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
871         require(rAmount <= _rTotal, "Amount must be less than total reflections");
872         uint256 currentRate =  _getRate();
873         return rAmount.div(currentRate);
874     }
875 
876     function excludeFromReward(address account) public onlyOwner() {
877         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
878         require(!_isExcluded[account], "Account is already excluded");
879         if(_rOwned[account] > 0) {
880             _tOwned[account] = tokenFromReflection(_rOwned[account]);
881         }
882         _isExcluded[account] = true;
883         _excluded.push(account);
884     }
885 
886     function includeInReward(address account) external onlyOwner() {
887         require(_isExcluded[account], "Account is already excluded");
888         for (uint256 i = 0; i < _excluded.length; i++) {
889             if (_excluded[i] == account) {
890                 _excluded[i] = _excluded[_excluded.length - 1];
891                 _tOwned[account] = 0;
892                 _isExcluded[account] = false;
893                 _excluded.pop();
894                 break;
895             }
896         }
897     }
898         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
899         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
900         _tOwned[sender] = _tOwned[sender].sub(tAmount);
901         _rOwned[sender] = _rOwned[sender].sub(rAmount);
902         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
903         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
904         _takeLiquidity(tLiquidity);
905         _reflectFee(rFee, tFee);
906         emit Transfer(sender, recipient, tTransferAmount);
907     }
908     
909     function excludeFromFee(address account) public onlyOwner {
910         _isExcludedFromFee[account] = true;
911     }
912     
913     function includeInFee(address account) public onlyOwner {
914         _isExcludedFromFee[account] = false;
915     }
916 
917     function setMarketingWallet(address walletAddress) public onlyOwner {
918         marketingWallet = walletAddress;
919     }
920 
921     function upliftTxAmount() external onlyOwner() {
922         _maxTxAmount = 69000000000000000000000 * 10**9;
923     }
924     
925     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
926         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
927         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
928     }
929     
930     function claimTokens () public onlyOwner {
931         // make sure we capture all BNB that may or may not be sent to this contract
932         payable(marketingWallet).transfer(address(this).balance);
933     }
934     
935     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
936         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
937     }
938     
939     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
940         walletaddress.transfer(address(this).balance);
941     }
942     
943     function addBotWallet(address botwallet) external onlyOwner() {
944         botWallets[botwallet] = true;
945     }
946     
947     function removeBotWallet(address botwallet) external onlyOwner() {
948         botWallets[botwallet] = false;
949     }
950     
951     function getBotWalletStatus(address botwallet) public view returns (bool) {
952         return botWallets[botwallet];
953     }
954     
955     function allowtrading()external onlyOwner() {
956         canTrade = true;
957     }
958 
959     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
960         swapAndLiquifyEnabled = _enabled;
961         emit SwapAndLiquifyEnabledUpdated(_enabled);
962     }
963     
964      //to recieve ETH from uniswapV2Router when swaping
965     receive() external payable {}
966 
967     function _reflectFee(uint256 rFee, uint256 tFee) private {
968         _rTotal = _rTotal.sub(rFee);
969         _tFeeTotal = _tFeeTotal.add(tFee);
970     }
971 
972     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
973         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
974         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
975         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
976     }
977 
978     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
979         uint256 tFee = calculateTaxFee(tAmount);
980         uint256 tLiquidity = calculateLiquidityFee(tAmount);
981         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
982         return (tTransferAmount, tFee, tLiquidity);
983     }
984 
985     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
986         uint256 rAmount = tAmount.mul(currentRate);
987         uint256 rFee = tFee.mul(currentRate);
988         uint256 rLiquidity = tLiquidity.mul(currentRate);
989         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
990         return (rAmount, rTransferAmount, rFee);
991     }
992 
993     function _getRate() private view returns(uint256) {
994         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
995         return rSupply.div(tSupply);
996     }
997 
998     function _getCurrentSupply() private view returns(uint256, uint256) {
999         uint256 rSupply = _rTotal;
1000         uint256 tSupply = _tTotal;      
1001         for (uint256 i = 0; i < _excluded.length; i++) {
1002             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1003             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1004             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1005         }
1006         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1007         return (rSupply, tSupply);
1008     }
1009     
1010     function _takeLiquidity(uint256 tLiquidity) private {
1011         uint256 currentRate =  _getRate();
1012         uint256 rLiquidity = tLiquidity.mul(currentRate);
1013         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1014         if(_isExcluded[address(this)])
1015             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1016     }
1017     
1018     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1019         return _amount.mul(_taxFee).div(
1020             10**2
1021         );
1022     }
1023 
1024     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1025         return _amount.mul(_liquidityFee).div(
1026             10**2
1027         );
1028     }
1029     
1030     function removeAllFee() private {
1031         if(_taxFee == 0 && _liquidityFee == 0) return;
1032         
1033         _previousTaxFee = _taxFee;
1034         _previousLiquidityFee = _liquidityFee;
1035         
1036         _taxFee = 0;
1037         _liquidityFee = 0;
1038     }
1039     
1040     function restoreAllFee() private {
1041         _taxFee = _previousTaxFee;
1042         _liquidityFee = _previousLiquidityFee;
1043     }
1044     
1045     function isExcludedFromFee(address account) public view returns(bool) {
1046         return _isExcludedFromFee[account];
1047     }
1048 
1049     function _approve(address owner, address spender, uint256 amount) private {
1050         require(owner != address(0), "ERC20: approve from the zero address");
1051         require(spender != address(0), "ERC20: approve to the zero address");
1052 
1053         _allowances[owner][spender] = amount;
1054         emit Approval(owner, spender, amount);
1055     }
1056 
1057     function _transfer(
1058         address from,
1059         address to,
1060         uint256 amount
1061     ) private {
1062         require(from != address(0), "ERC20: transfer from the zero address");
1063         require(to != address(0), "ERC20: transfer to the zero address");
1064         require(amount > 0, "Transfer amount must be greater than zero");
1065         if(from != owner() && to != owner())
1066             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1067 
1068         // is the token balance of this contract address over the min number of
1069         // tokens that we need to initiate a swap + liquidity lock?
1070         // also, don't get caught in a circular liquidity event.
1071         // also, don't swap & liquify if sender is uniswap pair.
1072         uint256 contractTokenBalance = balanceOf(address(this));
1073         
1074         if(contractTokenBalance >= _maxTxAmount)
1075         {
1076             contractTokenBalance = _maxTxAmount;
1077         }
1078         
1079         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1080         if (
1081             overMinTokenBalance &&
1082             !inSwapAndLiquify &&
1083             from != uniswapV2Pair &&
1084             swapAndLiquifyEnabled
1085         ) {
1086             contractTokenBalance = numTokensSellToAddToLiquidity;
1087             //add liquidity
1088             swapAndLiquify(contractTokenBalance);
1089         }
1090         
1091         //indicates if fee should be deducted from transfer
1092         bool takeFee = true;
1093         
1094         //if any account belongs to _isExcludedFromFee account then remove the fee
1095         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1096             takeFee = false;
1097         }
1098         
1099         //transfer amount, it will take tax, burn, liquidity fee
1100         _tokenTransfer(from,to,amount,takeFee);
1101     }
1102 
1103     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1104         // split the contract balance into halves
1105         // add the marketing wallet
1106         uint256 half = contractTokenBalance.div(2);
1107         uint256 otherHalf = contractTokenBalance.sub(half);
1108 
1109         // capture the contract's current ETH balance.
1110         // this is so that we can capture exactly the amount of ETH that the
1111         // swap creates, and not make the liquidity event include any ETH that
1112         // has been manually sent to the contract
1113         uint256 initialBalance = address(this).balance;
1114 
1115         // swap tokens for ETH
1116         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1117 
1118         // how much ETH did we just swap into?
1119         uint256 newBalance = address(this).balance.sub(initialBalance);
1120         uint256 marketingshare = newBalance.mul(75).div(100);
1121         payable(marketingWallet).transfer(marketingshare);
1122         newBalance -= marketingshare;
1123         // add liquidity to uniswap
1124         addLiquidity(otherHalf, newBalance);
1125         
1126         emit SwapAndLiquify(half, newBalance, otherHalf);
1127     }
1128 
1129     function swapTokensForEth(uint256 tokenAmount) private {
1130         // generate the uniswap pair path of token -> weth
1131         address[] memory path = new address[](2);
1132         path[0] = address(this);
1133         path[1] = uniswapV2Router.WETH();
1134 
1135         _approve(address(this), address(uniswapV2Router), tokenAmount);
1136 
1137         // make the swap
1138         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1139             tokenAmount,
1140             0, // accept any amount of ETH
1141             path,
1142             address(this),
1143             block.timestamp
1144         );
1145     }
1146 
1147     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1148         // approve token transfer to cover all possible scenarios
1149         _approve(address(this), address(uniswapV2Router), tokenAmount);
1150 
1151         // add the liquidity
1152         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1153             address(this),
1154             tokenAmount,
1155             0, // slippage is unavoidable
1156             0, // slippage is unavoidable
1157             owner(),
1158             block.timestamp
1159         );
1160     }
1161 
1162     //this method is responsible for taking all fee, if takeFee is true
1163     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1164         if(!canTrade){
1165             require(sender == owner()); // only owner allowed to trade or add liquidity
1166         }
1167         
1168         if(botWallets[sender] || botWallets[recipient]){
1169             require(botscantrade, "bots arent allowed to trade");
1170         }
1171         
1172         if(!takeFee)
1173             removeAllFee();
1174         
1175         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1176             _transferFromExcluded(sender, recipient, amount);
1177         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1178             _transferToExcluded(sender, recipient, amount);
1179         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1180             _transferStandard(sender, recipient, amount);
1181         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1182             _transferBothExcluded(sender, recipient, amount);
1183         } else {
1184             _transferStandard(sender, recipient, amount);
1185         }
1186         
1187         if(!takeFee)
1188             restoreAllFee();
1189     }
1190 
1191     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1192         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1193         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1194         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1195         _takeLiquidity(tLiquidity);
1196         _reflectFee(rFee, tFee);
1197         emit Transfer(sender, recipient, tTransferAmount);
1198     }
1199 
1200     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1201         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1202         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1203         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1204         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1205         _takeLiquidity(tLiquidity);
1206         _reflectFee(rFee, tFee);
1207         emit Transfer(sender, recipient, tTransferAmount);
1208     }
1209 
1210     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1211         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1212         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1213         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1214         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1215         _takeLiquidity(tLiquidity);
1216         _reflectFee(rFee, tFee);
1217         emit Transfer(sender, recipient, tTransferAmount);
1218     }
1219 
1220 }