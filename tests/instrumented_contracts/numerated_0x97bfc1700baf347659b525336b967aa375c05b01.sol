1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 interface IERC20 {
5 
6     function totalSupply() external view returns (uint256);
7 
8     /**
9      * @dev Returns the amount of tokens owned by `account`.
10      */
11     function balanceOf(address account) external view returns (uint256);
12 
13     /**
14      * @dev Moves `amount` tokens from the caller's account to `recipient`.
15      *
16      * Returns a boolean value indicating whether the operation succeeded.
17      *
18      * Emits a {Transfer} event.
19      */
20     function transfer(address recipient, uint256 amount) external returns (bool);
21 
22     /**
23      * @dev Returns the remaining number of tokens that `spender` will be
24      * allowed to spend on behalf of `owner` through {transferFrom}. This is
25      * zero by default.
26      *
27      * This value changes when {approve} or {transferFrom} are called.
28      */
29     function allowance(address owner, address spender) external view returns (uint256);
30 
31     /**
32      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * IMPORTANT: Beware that changing an allowance with this method brings the risk
37      * that someone may use both the old and the new allowance by unfortunate
38      * transaction ordering. One possible solution to mitigate this race
39      * condition is to first reduce the spender's allowance to 0 and set the
40      * desired value afterwards:
41      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
42      *
43      * Emits an {Approval} event.
44      */
45     function approve(address spender, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Moves `amount` tokens from `sender` to `recipient` using the
49      * allowance mechanism. `amount` is then deducted from the caller's
50      * allowance.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 
74 
75 /**
76  * @dev Wrappers over Solidity's arithmetic operations with added overflow
77  * checks.
78  *
79  * Arithmetic operations in Solidity wrap on overflow. This can easily result
80  * in bugs, because programmers usually assume that an overflow raises an
81  * error, which is the standard behavior in high level programming languages.
82  * `SafeMath` restores this intuition by reverting the transaction when an
83  * operation overflows.
84  *
85  * Using this library instead of the unchecked operations eliminates an entire
86  * class of bugs, so it's recommended to use it always.
87  */
88 
89 library SafeMath {
90     /**
91      * @dev Returns the addition of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `+` operator.
95      *
96      * Requirements:
97      *
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the subtraction of two unsigned integers, reverting on
109      * overflow (when the result is negative).
110      *
111      * Counterpart to Solidity's `-` operator.
112      *
113      * Requirements:
114      *
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         return sub(a, b, "SafeMath: subtraction overflow");
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132         require(b <= a, errorMessage);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
150         // benefit is lost if 'b' is also tested.
151         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
152         if (a == 0) {
153             return 0;
154         }
155 
156         uint256 c = a * b;
157         require(c / a == b, "SafeMath: multiplication overflow");
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b) internal pure returns (uint256) {
175         return div(a, b, "SafeMath: division by zero");
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         uint256 c = a / b;
193         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
211         return mod(a, b, "SafeMath: modulo by zero");
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts with custom message when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b != 0, errorMessage);
228         return a % b;
229     }
230 }
231 
232 abstract contract Context {
233     function _msgSender() internal view virtual returns (address payable) {
234         return msg.sender;
235     }
236 
237     function _msgData() internal view virtual returns (bytes memory) {
238         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
239         return msg.data;
240     }
241 }
242 
243 
244 /**
245  * @dev Collection of functions related to the address type
246  */
247 library Address {
248     /**
249      * @dev Returns true if `account` is a contract.
250      *
251      * [IMPORTANT]
252      * ====
253      * It is unsafe to assume that an address for which this function returns
254      * false is an externally-owned account (EOA) and not a contract.
255      *
256      * Among others, `isContract` will return false for the following
257      * types of addresses:
258      *
259      *  - an externally-owned account
260      *  - a contract in construction
261      *  - an address where a contract will be created
262      *  - an address where a contract lived, but was destroyed
263      * ====
264      */
265     function isContract(address account) internal view returns (bool) {
266         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
267         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
268         // for accounts without code, i.e. `keccak256('')`
269         bytes32 codehash;
270         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
271         // solhint-disable-next-line no-inline-assembly
272         assembly { codehash := extcodehash(account) }
273         return (codehash != accountHash && codehash != 0x0);
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
296         (bool success, ) = recipient.call{ value: amount }("");
297         require(success, "Address: unable to send value, recipient may have reverted");
298     }
299 
300     /**
301      * @dev Performs a Solidity function call using a low level `call`. A
302      * plain`call` is an unsafe replacement for a function call: use this
303      * function instead.
304      *
305      * If `target` reverts with a revert reason, it is bubbled up by this
306      * function (like regular Solidity function calls).
307      *
308      * Returns the raw returned data. To convert to the expected return value,
309      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
310      *
311      * Requirements:
312      *
313      * - `target` must be a contract.
314      * - calling `target` with `data` must not revert.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
319       return functionCall(target, data, "Address: low-level call failed");
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
324      * `errorMessage` as a fallback revert reason when `target` reverts.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
329         return _functionCallWithValue(target, data, 0, errorMessage);
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
334      * but also transferring `value` wei to `target`.
335      *
336      * Requirements:
337      *
338      * - the calling contract must have an ETH balance of at least `value`.
339      * - the called Solidity function must be `payable`.
340      *
341      * _Available since v3.1._
342      */
343     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
344         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
349      * with `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
354         require(address(this).balance >= value, "Address: insufficient balance for call");
355         return _functionCallWithValue(target, data, value, errorMessage);
356     }
357 
358     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
359         require(isContract(target), "Address: call to non-contract");
360 
361         // solhint-disable-next-line avoid-low-level-calls
362         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
363         if (success) {
364             return returndata;
365         } else {
366             // Look for revert reason and bubble it up if present
367             if (returndata.length > 0) {
368                 // The easiest way to bubble the revert reason is using memory via assembly
369 
370                 // solhint-disable-next-line no-inline-assembly
371                 assembly {
372                     let returndata_size := mload(returndata)
373                     revert(add(32, returndata), returndata_size)
374                 }
375             } else {
376                 revert(errorMessage);
377             }
378         }
379     }
380 }
381 
382 /**
383  * @dev Contract module which provides a basic access control mechanism, where
384  * there is an account (an owner) that can be granted exclusive access to
385  * specific functions.
386  *
387  * By default, the owner account will be the one that deploys the contract. This
388  * can later be changed with {transferOwnership}.
389  *
390  * This module is used through inheritance. It will make available the modifier
391  * `onlyOwner`, which can be applied to your functions to restrict their use to
392  * the owner.
393  */
394 contract Ownable is Context {
395     address private _owner;
396     address private _previousOwner;
397     uint256 private _lockTime;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor () internal {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425      /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 
447     function geUnlockTime() public view returns (uint256) {
448         return _lockTime;
449     }
450 
451     //Locks the contract for owner for the amount of time provided
452     function lock(uint256 time) public virtual onlyOwner {
453         _previousOwner = _owner;
454         _owner = address(0);
455         _lockTime = now + time;
456         emit OwnershipTransferred(_owner, address(0));
457     }
458 
459     //Unlocks the contract for owner when _lockTime is exceeds
460     function unlock() public virtual {
461         require(_previousOwner == msg.sender, "You don't have permission to unlock");
462         require(now > _lockTime , "Contract is locked until 7 days");
463         emit OwnershipTransferred(_owner, _previousOwner);
464         _owner = _previousOwner;
465     }
466 }
467 
468 // pragma solidity >=0.5.0;
469 
470 interface IUniswapV2Factory {
471     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
472 
473     function feeTo() external view returns (address);
474     function feeToSetter() external view returns (address);
475 
476     function getPair(address tokenA, address tokenB) external view returns (address pair);
477     function allPairs(uint) external view returns (address pair);
478     function allPairsLength() external view returns (uint);
479 
480     function createPair(address tokenA, address tokenB) external returns (address pair);
481 
482     function setFeeTo(address) external;
483     function setFeeToSetter(address) external;
484 }
485 
486 
487 // pragma solidity >=0.5.0;
488 
489 interface IUniswapV2Pair {
490     event Approval(address indexed owner, address indexed spender, uint value);
491     event Transfer(address indexed from, address indexed to, uint value);
492 
493     function name() external pure returns (string memory);
494     function symbol() external pure returns (string memory);
495     function decimals() external pure returns (uint8);
496     function totalSupply() external view returns (uint);
497     function balanceOf(address owner) external view returns (uint);
498     function allowance(address owner, address spender) external view returns (uint);
499 
500     function approve(address spender, uint value) external returns (bool);
501     function transfer(address to, uint value) external returns (bool);
502     function transferFrom(address from, address to, uint value) external returns (bool);
503 
504     function DOMAIN_SEPARATOR() external view returns (bytes32);
505     function PERMIT_TYPEHASH() external pure returns (bytes32);
506     function nonces(address owner) external view returns (uint);
507 
508     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
509 
510     event Mint(address indexed sender, uint amount0, uint amount1);
511     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
512     event Swap(
513         address indexed sender,
514         uint amount0In,
515         uint amount1In,
516         uint amount0Out,
517         uint amount1Out,
518         address indexed to
519     );
520     event Sync(uint112 reserve0, uint112 reserve1);
521 
522     function MINIMUM_LIQUIDITY() external pure returns (uint);
523     function factory() external view returns (address);
524     function token0() external view returns (address);
525     function token1() external view returns (address);
526     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
527     function price0CumulativeLast() external view returns (uint);
528     function price1CumulativeLast() external view returns (uint);
529     function kLast() external view returns (uint);
530 
531     function mint(address to) external returns (uint liquidity);
532     function burn(address to) external returns (uint amount0, uint amount1);
533     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
534     function skim(address to) external;
535     function sync() external;
536 
537     function initialize(address, address) external;
538 }
539 
540 // pragma solidity >=0.6.2;
541 
542 interface IUniswapV2Router01 {
543     function factory() external pure returns (address);
544     function WETH() external pure returns (address);
545 
546     function addLiquidity(
547         address tokenA,
548         address tokenB,
549         uint amountADesired,
550         uint amountBDesired,
551         uint amountAMin,
552         uint amountBMin,
553         address to,
554         uint deadline
555     ) external returns (uint amountA, uint amountB, uint liquidity);
556     function addLiquidityETH(
557         address token,
558         uint amountTokenDesired,
559         uint amountTokenMin,
560         uint amountETHMin,
561         address to,
562         uint deadline
563     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
564     function removeLiquidity(
565         address tokenA,
566         address tokenB,
567         uint liquidity,
568         uint amountAMin,
569         uint amountBMin,
570         address to,
571         uint deadline
572     ) external returns (uint amountA, uint amountB);
573     function removeLiquidityETH(
574         address token,
575         uint liquidity,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline
580     ) external returns (uint amountToken, uint amountETH);
581     function removeLiquidityWithPermit(
582         address tokenA,
583         address tokenB,
584         uint liquidity,
585         uint amountAMin,
586         uint amountBMin,
587         address to,
588         uint deadline,
589         bool approveMax, uint8 v, bytes32 r, bytes32 s
590     ) external returns (uint amountA, uint amountB);
591     function removeLiquidityETHWithPermit(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountToken, uint amountETH);
600     function swapExactTokensForTokens(
601         uint amountIn,
602         uint amountOutMin,
603         address[] calldata path,
604         address to,
605         uint deadline
606     ) external returns (uint[] memory amounts);
607     function swapTokensForExactTokens(
608         uint amountOut,
609         uint amountInMax,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external returns (uint[] memory amounts);
614     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
615         external
616         payable
617         returns (uint[] memory amounts);
618     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
619         external
620         returns (uint[] memory amounts);
621     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
622         external
623         returns (uint[] memory amounts);
624     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
625         external
626         payable
627         returns (uint[] memory amounts);
628 
629     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
630     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
631     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
632     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
633     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
634 }
635 
636 
637 
638 // pragma solidity >=0.6.2;
639 
640 interface IUniswapV2Router02 is IUniswapV2Router01 {
641     function removeLiquidityETHSupportingFeeOnTransferTokens(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline
648     ) external returns (uint amountETH);
649     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
650         address token,
651         uint liquidity,
652         uint amountTokenMin,
653         uint amountETHMin,
654         address to,
655         uint deadline,
656         bool approveMax, uint8 v, bytes32 r, bytes32 s
657     ) external returns (uint amountETH);
658 
659     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
660         uint amountIn,
661         uint amountOutMin,
662         address[] calldata path,
663         address to,
664         uint deadline
665     ) external;
666     function swapExactETHForTokensSupportingFeeOnTransferTokens(
667         uint amountOutMin,
668         address[] calldata path,
669         address to,
670         uint deadline
671     ) external payable;
672     function swapExactTokensForETHSupportingFeeOnTransferTokens(
673         uint amountIn,
674         uint amountOutMin,
675         address[] calldata path,
676         address to,
677         uint deadline
678     ) external;
679 }
680 
681 
682 contract HeroInu is Context, IERC20, Ownable {
683     using SafeMath for uint256;
684     using Address for address payable;
685 
686     mapping (address => uint256) private _rOwned;
687     mapping (address => uint256) private _tOwned;
688     mapping (address => mapping (address => uint256)) private _allowances;
689     mapping (address => uint256) public _firstBuyTime;
690     mapping (address => bool) private _isExcludedFromFee;
691 
692     address payable public marketing;
693     address payable public charity;
694     address payable private _burnPool = 0x0000000000000000000000000000000000000000;
695 
696     uint256 private constant MAX = ~uint256(0);
697     uint256 private _tTotal = 100 * 10**15 * 10**9;
698     uint256 private _rTotal = (MAX - (MAX % _tTotal));
699     uint256 private _tFeeTotal;
700 
701     string private _name = "Hero Inu";
702     string private _symbol = "HEROS";
703     uint8 private _decimals = 9;
704 
705     uint256 public _taxBuyFee = 2;
706     uint256 public _taxSellFee = 2;
707     uint256 public _taxTransferFee = 1;
708 
709     uint256 private _operationsFee = 0; //adjusted on the go
710     uint256 private _liquidityFee = 0; //adjusted on the go
711     uint256 private _taxFee = 0; //adjusted on the go
712     uint256 private _burnFee = 0; //adjusted on the go
713 
714     uint256 public _marketingBuyFee = 3;
715     uint256 public _marketingSellFee = 3;
716     uint256 public _marketingTransferFee = 1;
717 
718     uint256 public _charityBuyFee = 1;
719     uint256 public _charitySellFee = 1;
720     uint256 public _charityTransferFee = 1;
721 
722     uint256 public _liquidityBuyFee = 2;
723     uint256 public _liquiditySellFee = 2;
724     uint256 public _liquidityTransferFee = 1;
725 
726     uint256 public _burnBuyFee = 2;
727     uint256 public _burnSellFee = 2;
728     uint256 public _burnTransferFee = 1;
729 
730     uint256 public _prev_liquiditySellFee = 0;
731     uint256 public _prev_burnSellFee = 0;
732     uint256 public _prev_marketingSellFee = 0;
733     uint256 public _prev_charitySellFee = 0;
734     uint256 public _prev_taxSellFee = 0;
735 
736     //These fees are accumulated and adjusted on a per-transfer basis up until swapAndLiquify is called, during which the accumulated funds get distributed as intended
737     uint256 public _pendingCharityFees = 0;
738     uint256 public _pendingLiquidityFees = 0;
739 
740     IUniswapV2Router02 public immutable uniswapV2Router;
741     address public immutable uniswapV2Pair;
742 
743     bool inSwapAndLiquify;
744     bool public swapAndLiquifyEnabled = true;
745 
746     uint256 public _maxWalletHolding = 3 * 10**15 * 10**9;
747     uint256 private numTokensSellToAddToLiquidity = 200 * 10**12 * 10**9;
748 
749     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
750     event SwapAndLiquifyEnabledUpdated(bool enabled);
751     event SwapAndLiquify(
752         uint256 tokensSwapped,
753         uint256 ethReceived,
754         uint256 tokensIntoLiquidity
755     );
756 
757     modifier lockTheSwap {
758         inSwapAndLiquify = true;
759         _;
760         inSwapAndLiquify = false;
761     }
762 
763     constructor (address payable _marketing, address payable _charity) public {
764       marketing = _marketing;
765       charity = _charity;
766       _rOwned[_msgSender()] = _rTotal;
767       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
768       uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
769       uniswapV2Router = _uniswapV2Router;
770       _isExcludedFromFee[owner()] = true;
771       _isExcludedFromFee[address(this)] = true;
772       emit Transfer(address(0), _msgSender(), _tTotal);
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
792         return tokenFromReflection(_rOwned[account]);
793     }
794 
795     function transfer(address recipient, uint256 amount) public override returns (bool) {
796         _transfer(_msgSender(), recipient, amount);
797         return true;
798     }
799 
800     function allowance(address owner, address spender) public view override returns (uint256) {
801         return _allowances[owner][spender];
802     }
803 
804     function approve(address spender, uint256 amount) public override returns (bool) {
805         _approve(_msgSender(), spender, amount);
806         return true;
807     }
808 
809     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
810         _transfer(sender, recipient, amount);
811         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
812         return true;
813     }
814 
815     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
816         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
817         return true;
818     }
819 
820     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
821         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
822         return true;
823     }
824 
825     function totalFees() public view returns (uint256) {
826         return _tFeeTotal;
827     }
828 
829     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
830         require(tAmount <= _tTotal, "Amount must be less than supply");
831         if (!deductTransferFee) {
832             (uint256 rAmount,,,,,,) = _getValues(tAmount);
833             return rAmount;
834         } else {
835             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
836             return rTransferAmount;
837         }
838     }
839 
840     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
841         require(rAmount <= _rTotal, "Amount must be less than total reflections");
842         uint256 currentRate =  _getRate();
843         return rAmount.div(currentRate);
844     }
845 
846     //this can be called externally by deployer to immediately process accumulated fees accordingly (distribute to treasury & liquidity)
847     function manualSwapAndLiquify() public onlyOwner() {
848         uint256 contractTokenBalance = balanceOf(address(this));
849         swapAndLiquify(contractTokenBalance);
850     }
851 
852     function excludeFromFee(address account) public onlyOwner {
853         _isExcludedFromFee[account] = true;
854     }
855 
856     function includeInFee(address account) public onlyOwner {
857         _isExcludedFromFee[account] = false;
858     }
859 
860     function setTax(uint256 _taxType, uint _taxSize) external onlyOwner() {
861       if (_taxType == 1) {
862         _taxSellFee = _taxSize;
863       }
864       else if (_taxType == 2) {
865         _taxBuyFee = _taxSize;
866       }
867       else if (_taxType == 3) {
868         _taxTransferFee = _taxSize;
869       }
870       else if (_taxType == 4) {
871         _marketingBuyFee = _taxSize;
872       }
873       else if (_taxType == 5) {
874         _marketingSellFee = _taxSize;
875       }
876       else if (_taxType == 6) {
877         _marketingTransferFee = _taxSize;
878       }
879       else if (_taxType == 7) {
880         _burnBuyFee = _taxSize;
881       }
882       else if (_taxType == 8) {
883         _burnSellFee = _taxSize;
884       }
885       else if (_taxType == 9) {
886         _burnTransferFee = _taxSize;
887       }
888       else if (_taxType == 10) {
889         _charityBuyFee = _taxSize;
890       }
891       else if (_taxType == 11) {
892         _charitySellFee = _taxSize;
893       }
894       else if (_taxType == 12) {
895         _charityTransferFee = _taxSize;
896       }
897       else if (_taxType == 13) {
898         _liquidityBuyFee = _taxSize;
899       }
900       else if (_taxType == 14) {
901         _liquiditySellFee = _taxSize;
902       }
903       else if (_taxType == 15) {
904         _liquidityTransferFee = _taxSize;
905       }
906     }
907 
908     function setMaxWalletHoldingPercent(uint256 maxHoldingPercent) external onlyOwner() {
909         _maxWalletHolding = _tTotal.mul(maxHoldingPercent).div(
910             10**2
911         );
912     }
913 
914     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
915         swapAndLiquifyEnabled = _enabled;
916         emit SwapAndLiquifyEnabledUpdated(_enabled);
917     }
918 
919      //to receive ETH from uniswapV2Router when swaping
920     receive() external payable {}
921 
922     function _reflectFee(uint256 rFee, uint256 tFee) private {
923         _rTotal = _rTotal.sub(rFee);
924         _tFeeTotal = _tFeeTotal.add(tFee);
925     }
926 
927     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
928         uint256[4] memory tValues = _getTValuesArray(tAmount);
929         uint256[3] memory rValues = _getRValuesArray(tAmount, tValues[1], tValues[2], tValues[3]);
930         return (rValues[0], rValues[1], rValues[2], tValues[0], tValues[1], tValues[2], tValues[3]);
931     }
932 
933     function _getTValuesArray(uint256 tAmount) private view returns (uint256[4] memory val) {
934         uint256 tFee = calculateTaxFee(tAmount);
935         uint256 tLiquidity = calculateLiquidityFee(tAmount);
936         uint256 tOperations = calculateOperationsFee(tAmount);
937         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tOperations);
938         return [tTransferAmount, tFee, tLiquidity, tOperations];
939     }
940 
941     function _getRValuesArray(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations) private view returns (uint256[3] memory val) {
942         uint256 currentRate = _getRate();
943         uint256 rAmount = tAmount.mul(currentRate);
944         uint256 rFee = tFee.mul(currentRate);
945         uint256 rTransferAmount = rAmount.sub(rFee).sub(tLiquidity.mul(currentRate)).sub(tOperations.mul(currentRate));
946         return [rAmount, rTransferAmount, rFee];
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
957         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
958         return (rSupply, tSupply);
959     }
960 
961     function _takeLiquidity(uint256 tLiquidity) private {
962         uint256 currentRate =  _getRate();
963         uint256 rLiquidity = tLiquidity.mul(currentRate);
964         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
965         _pendingLiquidityFees = _pendingLiquidityFees.add(tLiquidity);
966     }
967 
968     function _takeOperations(uint256 tOperations, uint8 transferType) private {
969         uint256 currentRate =  _getRate();
970         uint256 tBurn = 0;
971         if (_operationsFee > 0) {
972           tBurn = _burnFee.mul(tOperations).div(_operationsFee);
973           emit Transfer(address(this), address(0), tBurn);
974         }
975         uint256 rOperations = tOperations.sub(tBurn).mul(currentRate);
976         _rOwned[address(this)] = _rOwned[address(this)].add(rOperations);
977         _rOwned[_burnPool] = _rOwned[_burnPool].add(tBurn.mul(currentRate));
978 
979         if (_operationsFee > 0) {
980           uint256 _deltaCharityFees = 0;
981 
982           if (transferType == 1) {
983             _deltaCharityFees = tOperations.mul(_charityBuyFee).div(_operationsFee);
984           }
985           else if (transferType == 2) {
986             _deltaCharityFees = tOperations.mul(_charitySellFee).div(_operationsFee);
987           }
988           else if (transferType == 0) {
989             _deltaCharityFees = tOperations.mul(_charityTransferFee).div(_operationsFee);
990           }
991 
992           if (_deltaCharityFees > 0) _pendingCharityFees = _pendingCharityFees.add(_deltaCharityFees);
993         }
994 
995     }
996 
997     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
998         return _amount.mul(_taxFee).div(
999             10**2
1000         );
1001     }
1002 
1003     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1004         return _amount.mul(_liquidityFee).div(
1005             10**2
1006         );
1007     }
1008 
1009     function calculateOperationsFee(uint256 _amount) private view returns (uint256) {
1010         return _amount.mul(_operationsFee).div(
1011             10**2
1012         );
1013     }
1014 
1015     function removeAllFee() private {
1016         _taxFee = 0;
1017         _liquidityFee = 0;
1018         _operationsFee = 0;
1019         _burnFee = 0;
1020 
1021         _liquiditySellFee = _prev_liquiditySellFee;
1022         _marketingSellFee = _prev_marketingSellFee;
1023         _burnSellFee = _prev_burnSellFee;
1024         _taxSellFee = _prev_taxSellFee;
1025         _charitySellFee = _prev_charitySellFee;
1026     }
1027 
1028     function saveAllFee() private {
1029         _prev_liquiditySellFee = _liquiditySellFee;
1030         _prev_marketingSellFee = _marketingSellFee;
1031         _prev_burnSellFee = _burnSellFee;
1032         _prev_taxSellFee = _taxSellFee;
1033         _prev_charitySellFee = _charitySellFee;
1034     }
1035 
1036     function isExcludedFromFee(address account) public view returns(bool) {
1037         return _isExcludedFromFee[account];
1038     }
1039 
1040     function _approve(address owner, address spender, uint256 amount) private {
1041         require(owner != address(0), "ERC20: approve from the zero address");
1042         require(spender != address(0), "ERC20: approve to the zero address");
1043 
1044         _allowances[owner][spender] = amount;
1045         emit Approval(owner, spender, amount);
1046     }
1047 
1048     function _transfer(
1049         address from,
1050         address to,
1051         uint256 amount
1052     ) private {
1053         require(from != address(0), "ERC20: transfer from the zero address");
1054         require(to != address(0), "ERC20: transfer to the zero address");
1055         require(amount > 0, "Transfer amount must be greater than zero");
1056         saveAllFee();
1057         uint256 contractTokenBalance = balanceOf(address(this));
1058 
1059         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1060         if (
1061             overMinTokenBalance &&
1062             !inSwapAndLiquify &&
1063             from != uniswapV2Pair &&
1064             swapAndLiquifyEnabled
1065         ) {
1066             swapAndLiquify(contractTokenBalance);
1067         }
1068 
1069         //indicates if fee should be deducted from transfer
1070         bool takeFee = true;
1071 
1072         //if any account belongs to _isExcludedFromFee account then remove the fee
1073         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1074             takeFee = false;
1075         }
1076 
1077         //depending on type of transfer (buy, sell, or p2p tokens transfer) different taxes & fees are imposed
1078         uint8 transferType = 0;
1079         bool isTransferBuy = from == uniswapV2Pair;
1080         bool isTransferSell = to == uniswapV2Pair;
1081 
1082         if (!isTransferBuy && !isTransferSell) {
1083           _operationsFee = _marketingTransferFee.add(_charityTransferFee).add(_burnTransferFee);
1084           _liquidityFee = _liquidityTransferFee;
1085           _taxFee = _taxTransferFee;
1086           _burnFee = _burnTransferFee;
1087         }
1088         else if (isTransferBuy) {
1089           _operationsFee = _marketingBuyFee.add(_charityBuyFee).add(_burnBuyFee);
1090           _liquidityFee = _liquidityBuyFee;
1091           _taxFee = _taxBuyFee;
1092           _burnFee = _burnBuyFee;
1093           transferType = 1;
1094           if (_firstBuyTime[to] == 0) _firstBuyTime[to] = block.timestamp;
1095         }
1096         else if (isTransferSell) {
1097           _operationsFee = _marketingSellFee.add(_charitySellFee).add(_burnSellFee);
1098           _liquidityFee = _liquiditySellFee;
1099           _taxFee = _taxSellFee;
1100           _burnFee = _burnSellFee;
1101           transferType = 2;
1102           if (_firstBuyTime[from] != 0 && (_firstBuyTime[from] + (24 hours) > block.timestamp) ) {
1103             //doubling sell tax when user is flipping within 24 hrs
1104             _marketingSellFee = _marketingSellFee.mul(2);
1105             _liquiditySellFee = _liquiditySellFee.mul(2);
1106             _burnSellFee = _burnSellFee.mul(2);
1107             _taxSellFee = _taxSellFee.mul(2);
1108             _charitySellFee = _charitySellFee.mul(2);
1109             _operationsFee = _operationsFee.mul(2);
1110             _liquidityFee = _liquidityFee.mul(2);
1111             _taxFee = _taxFee.mul(2);
1112             _burnFee = _burnFee.mul(2);
1113           }
1114         }
1115 
1116         //transfer amount, it will take tax, liquidity & treasury fees
1117         _tokenTransfer(from,to,amount,takeFee,transferType);
1118         removeAllFee();
1119     }
1120 
1121     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1122         uint256 liquidityPart = 0;
1123         if (_pendingLiquidityFees < contractTokenBalance) liquidityPart = _pendingLiquidityFees;
1124         uint256 distributionPart = contractTokenBalance.sub(liquidityPart);
1125         uint256 liquidityHalfPart = liquidityPart.div(2);
1126         uint256 liquidityHalfTokenPart = liquidityPart.sub(liquidityHalfPart);
1127 
1128         //now swapping half of the liquidity part + all of the distribution part into ETH
1129         uint256 totalETHSwap = liquidityHalfPart.add(distributionPart);
1130 
1131         uint256 initialBalance = address(this).balance;
1132 
1133         // swap tokens for ETH
1134         swapTokensForEth(totalETHSwap);
1135 
1136         uint256 newBalance = address(this).balance.sub(initialBalance);
1137         uint256 liquidityBalance = liquidityHalfPart.mul(newBalance).div(totalETHSwap);
1138 
1139         // add liquidity to uniswap
1140         if (liquidityHalfTokenPart > 0 && liquidityBalance > 0) addLiquidity(liquidityHalfTokenPart, liquidityBalance);
1141         emit SwapAndLiquify(liquidityHalfPart, liquidityBalance, liquidityHalfPart);
1142 
1143         newBalance = address(this).balance;
1144         uint256 charityETHPart = newBalance.mul(_pendingCharityFees).div(distributionPart);
1145         uint256 marketingETHPart = newBalance.sub(charityETHPart);
1146         payDistribution(marketingETHPart, charityETHPart);
1147         _pendingLiquidityFees = 0;
1148         _pendingCharityFees = 0;
1149     }
1150 
1151     function swapTokensForEth(uint256 tokenAmount) private {
1152         // generate the uniswap pair path of token -> weth
1153         address[] memory path = new address[](2);
1154         path[0] = address(this);
1155         path[1] = uniswapV2Router.WETH();
1156 
1157         _approve(address(this), address(uniswapV2Router), tokenAmount);
1158 
1159         // make the swap
1160         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1161             tokenAmount,
1162             0, // accept any amount of ETH
1163             path,
1164             address(this),
1165             block.timestamp
1166         );
1167     }
1168 
1169     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1170         // approve token transfer to cover all possible scenarios
1171         _approve(address(this), address(uniswapV2Router), tokenAmount);
1172 
1173         // add the liquidity
1174         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1175             address(this),
1176             tokenAmount,
1177             0, // slippage is unavoidable
1178             0, // slippage is unavoidable
1179             address(this),
1180             block.timestamp
1181         );
1182     }
1183 
1184     function payDistribution(uint256 marketingETHPart, uint256 charityETHPart) private {
1185       marketing.sendValue(marketingETHPart);
1186       charity.sendValue(charityETHPart);
1187     }
1188 
1189     //this method is responsible for taking all fee, if takeFee is true
1190     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee, uint8 transferType) private {
1191         if(!takeFee) removeAllFee();
1192         _transferStandard(sender, recipient, amount, transferType);
1193         if (!_isExcludedFromFee[recipient] && (recipient != uniswapV2Pair)) require(balanceOf(recipient) < _maxWalletHolding, "Max Wallet holding limit exceeded");
1194     }
1195 
1196     function _transferStandard(address sender, address recipient, uint256 tAmount, uint8 transferType) private {
1197         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tOperations) = _getValues(tAmount);
1198         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1199         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1200         _takeLiquidity(tLiquidity);
1201         _takeOperations(tOperations, transferType);
1202         _reflectFee(rFee, tFee);
1203         emit Transfer(sender, recipient, tTransferAmount);
1204     }
1205 
1206 }