1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 
93 /**
94  * @dev Wrappers over Solidity's arithmetic operations with added overflow
95  * checks.
96  *
97  * Arithmetic operations in Solidity wrap on overflow. This can easily result
98  * in bugs, because programmers usually assume that an overflow raises an
99  * error, which is the standard behavior in high level programming languages.
100  * `SafeMath` restores this intuition by reverting the transaction when an
101  * operation overflows.
102  *
103  * Using this library instead of the unchecked operations eliminates an entire
104  * class of bugs, so it's recommended to use it always.
105  */
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
411         _owner = msgSender;
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
475 interface IUniswapV2Factory {
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
491 
492 // pragma solidity >=0.5.0;
493 
494 interface IUniswapV2Pair {
495     event Approval(address indexed owner, address indexed spender, uint value);
496     event Transfer(address indexed from, address indexed to, uint value);
497 
498     function name() external pure returns (string memory);
499     function symbol() external pure returns (string memory);
500     function decimals() external pure returns (uint8);
501     function totalSupply() external view returns (uint);
502     function balanceOf(address owner) external view returns (uint);
503     function allowance(address owner, address spender) external view returns (uint);
504 
505     function approve(address spender, uint value) external returns (bool);
506     function transfer(address to, uint value) external returns (bool);
507     function transferFrom(address from, address to, uint value) external returns (bool);
508 
509     function DOMAIN_SEPARATOR() external view returns (bytes32);
510     function PERMIT_TYPEHASH() external pure returns (bytes32);
511     function nonces(address owner) external view returns (uint);
512 
513     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
514 
515     event Mint(address indexed sender, uint amount0, uint amount1);
516     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
517     event Swap(
518         address indexed sender,
519         uint amount0In,
520         uint amount1In,
521         uint amount0Out,
522         uint amount1Out,
523         address indexed to
524     );
525     event Sync(uint112 reserve0, uint112 reserve1);
526 
527     function MINIMUM_LIQUIDITY() external pure returns (uint);
528     function factory() external view returns (address);
529     function token0() external view returns (address);
530     function token1() external view returns (address);
531     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
532     function price0CumulativeLast() external view returns (uint);
533     function price1CumulativeLast() external view returns (uint);
534     function kLast() external view returns (uint);
535 
536     function mint(address to) external returns (uint liquidity);
537     function burn(address to) external returns (uint amount0, uint amount1);
538     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
539     function skim(address to) external;
540     function sync() external;
541 
542     function initialize(address, address) external;
543 }
544 
545 // pragma solidity >=0.6.2;
546 
547 interface IUniswapV2Router01 {
548     function factory() external pure returns (address);
549     function WETH() external pure returns (address);
550 
551     function addLiquidity(
552         address tokenA,
553         address tokenB,
554         uint amountADesired,
555         uint amountBDesired,
556         uint amountAMin,
557         uint amountBMin,
558         address to,
559         uint deadline
560     ) external returns (uint amountA, uint amountB, uint liquidity);
561     function addLiquidityETH(
562         address token,
563         uint amountTokenDesired,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline
568     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
569     function removeLiquidity(
570         address tokenA,
571         address tokenB,
572         uint liquidity,
573         uint amountAMin,
574         uint amountBMin,
575         address to,
576         uint deadline
577     ) external returns (uint amountA, uint amountB);
578     function removeLiquidityETH(
579         address token,
580         uint liquidity,
581         uint amountTokenMin,
582         uint amountETHMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountToken, uint amountETH);
586     function removeLiquidityWithPermit(
587         address tokenA,
588         address tokenB,
589         uint liquidity,
590         uint amountAMin,
591         uint amountBMin,
592         address to,
593         uint deadline,
594         bool approveMax, uint8 v, bytes32 r, bytes32 s
595     ) external returns (uint amountA, uint amountB);
596     function removeLiquidityETHWithPermit(
597         address token,
598         uint liquidity,
599         uint amountTokenMin,
600         uint amountETHMin,
601         address to,
602         uint deadline,
603         bool approveMax, uint8 v, bytes32 r, bytes32 s
604     ) external returns (uint amountToken, uint amountETH);
605     function swapExactTokensForTokens(
606         uint amountIn,
607         uint amountOutMin,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external returns (uint[] memory amounts);
612     function swapTokensForExactTokens(
613         uint amountOut,
614         uint amountInMax,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external returns (uint[] memory amounts);
619     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         payable
622         returns (uint[] memory amounts);
623     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
624         external
625         returns (uint[] memory amounts);
626     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
627         external
628         returns (uint[] memory amounts);
629     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
630         external
631         payable
632         returns (uint[] memory amounts);
633 
634     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
635     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
636     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
637     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
638     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
639 }
640 
641 
642 
643 // pragma solidity >=0.6.2;
644 
645 interface IUniswapV2Router02 is IUniswapV2Router01 {
646     function removeLiquidityETHSupportingFeeOnTransferTokens(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) external returns (uint amountETH);
654     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
655         address token,
656         uint liquidity,
657         uint amountTokenMin,
658         uint amountETHMin,
659         address to,
660         uint deadline,
661         bool approveMax, uint8 v, bytes32 r, bytes32 s
662     ) external returns (uint amountETH);
663 
664     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
665         uint amountIn,
666         uint amountOutMin,
667         address[] calldata path,
668         address to,
669         uint deadline
670     ) external;
671     function swapExactETHForTokensSupportingFeeOnTransferTokens(
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external payable;
677     function swapExactTokensForETHSupportingFeeOnTransferTokens(
678         uint amountIn,
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external;
684 }
685 
686 
687 contract SPLIT is Context, IERC20, Ownable {
688     using SafeMath for uint256;
689     using Address for address;
690 
691      struct TValues{
692         uint256 tTransferAmount;
693         uint256 tFee;
694         uint256 tBurn;
695         uint256 tLpReward;
696         uint256 tDevReward;
697     }
698     
699     struct RValues{
700         uint256 rate;
701         uint256 rAmount;
702         uint256 rTransferAmount;
703         uint256 tTransferAmount;
704         uint256 rFee;
705         uint256 tFee;
706         uint256 rBurn;
707         uint256 rLpReward;
708         uint256 rDevReward;
709     }
710 
711     mapping (address => uint256) private _rOwned;
712     mapping (address => uint256) private _tOwned;
713     mapping (address => mapping (address => uint256)) private _allowances;
714 
715     mapping (address => bool) private _isExcludedFromFee;
716 
717     mapping (address => bool) private _isExcluded;
718     address[] private _excluded;
719    
720     uint256 private constant MAX = ~uint256(0);
721     uint256 private _tTotal = 1000 * 10**18;
722     uint256 private _rTotal = (MAX - (MAX % _tTotal));
723     uint256 private _tFeeTotal;
724     uint256 private _tBurnTotal;
725 
726     string private _name = "split protocol";
727     string private _symbol = "SPLIT";
728     uint8 private _decimals = 18;
729     
730     //2%
731     uint256 public _taxFee = 1;
732     uint256 private _previousTaxFee = _taxFee;
733     
734     //3%
735     uint256 public _burnFee = 2;
736     uint256 private _previousBurnFee = _burnFee;
737     
738     //4%
739     uint256 public _lpRewardFee = 2;
740     uint256 private _previousLpRewardFee = _lpRewardFee;
741     
742     uint256 public _devRewardFee = 1;
743     uint256 private _previousDevRewardFee = _devRewardFee;
744     
745     //No limit
746     uint256 public _maxTxAmount = _tTotal;
747     
748     //tracks the total amount of token rewarded to liquidity providers
749     uint256 public totalLiquidityProviderRewards;
750     
751     //locks the contract for any transfers
752     bool public isTransferLocked = true;
753     
754     IUniswapV2Router02 public immutable uniswapV2Router;
755     address public immutable uniswapV2Pair;
756     
757     bool public lpRewardEnabled = true;
758     uint256 private minTokensBeforeReward = 10;
759 
760     event LiquidityProvidersRewarded(uint256 tokenAmount);
761     event LpRewardEnabledUpdated(bool enabled);
762     event MinTokensBeforeRewardUpdated(uint256 tokenAmount);
763 
764     constructor () public {
765         _rOwned[_msgSender()] = _rTotal;
766         
767         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
768          // Create a uniswap pair for this new token
769         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
770             .createPair(address(this), _uniswapV2Router.WETH());
771 
772         // set the rest of the contract variables
773         uniswapV2Router = _uniswapV2Router;
774         
775         //exclude owner and this contract from fee
776         _isExcludedFromFee[owner()] = true;
777         _isExcludedFromFee[address(this)] = true;
778         
779         emit Transfer(address(0), _msgSender(), _tTotal);
780     }
781 
782     function name() public view returns (string memory) {
783         return _name;
784     }
785 
786     function symbol() public view returns (string memory) {
787         return _symbol;
788     }
789 
790     function decimals() public view returns (uint8) {
791         return _decimals;
792     }
793 
794     function totalSupply() public view override returns (uint256) {
795         return _tTotal;
796     }
797 
798     function balanceOf(address account) public view override returns (uint256) {
799         if (_isExcluded[account]) return _tOwned[account];
800         return tokenFromReflection(_rOwned[account]);
801     }
802 
803     function transfer(address recipient, uint256 amount) public override returns (bool) {
804         _transfer(_msgSender(), recipient, amount);
805         return true;
806     }
807 
808     function allowance(address owner, address spender) public view override returns (uint256) {
809         return _allowances[owner][spender];
810     }
811 
812     function approve(address spender, uint256 amount) public override returns (bool) {
813         _approve(_msgSender(), spender, amount);
814         return true;
815     }
816 
817     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
818         _transfer(sender, recipient, amount);
819         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
820         return true;
821     }
822 
823     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
824         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
825         return true;
826     }
827 
828     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
829         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
830         return true;
831     }
832 
833     function isExcludedFromReward(address account) public view returns (bool) {
834         return _isExcluded[account];
835     }
836 
837     function totalFees() public view returns (uint256) {
838         return _tFeeTotal;
839     }
840     
841     function totalBurn() public view returns (uint256) {
842         return _tBurnTotal;
843     }
844 
845     function deliver(uint256 tAmount) public {
846         address sender = _msgSender();
847         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
848          (,RValues memory values) = _getValues(tAmount);
849         _rOwned[sender] = _rOwned[sender].sub(values.rAmount);
850         _rTotal = _rTotal.sub(values.rAmount);
851         _tFeeTotal = _tFeeTotal.add(tAmount);
852     }
853 
854     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
855         require(tAmount <= _tTotal, "Amount must be less than supply");
856         (,RValues memory values) = _getValues(tAmount);
857         if (!deductTransferFee) {
858             return values.rAmount;
859         } else {
860             return values.rTransferAmount;
861         }
862     }
863 
864     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
865         require(rAmount <= _rTotal, "Amount must be less than total reflections");
866         uint256 currentRate =  _getRate();
867         return rAmount.div(currentRate);
868     }
869 
870     function excludeFromReward(address account) public onlyOwner() {
871         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
872         require(!_isExcluded[account], "Account is already excluded");
873         if(_rOwned[account] > 0) {
874             _tOwned[account] = tokenFromReflection(_rOwned[account]);
875         }
876         _isExcluded[account] = true;
877         _excluded.push(account);
878     }
879 
880     function includeInReward(address account) external onlyOwner() {
881         require(_isExcluded[account], "Account is already excluded");
882         for (uint256 i = 0; i < _excluded.length; i++) {
883             if (_excluded[i] == account) {
884                 _excluded[i] = _excluded[_excluded.length - 1];
885                 _tOwned[account] = 0;
886                 _isExcluded[account] = false;
887                 _excluded.pop();
888                 break;
889             }
890         }
891     }
892 
893     function _approve(address owner, address spender, uint256 amount) private {
894         require(owner != address(0), "ERC20: approve from the zero address");
895         require(spender != address(0), "ERC20: approve to the zero address");
896 
897         _allowances[owner][spender] = amount;
898         emit Approval(owner, spender, amount);
899     }
900 
901     function _transfer(
902         address from,
903         address to,
904         uint256 amount
905     ) private {
906         require(!isTransferLocked || _isExcludedFromFee[from], "Transfer is locked before presale is completed.");
907         require(from != address(0), "ERC20: transfer from the zero address");
908         require(to != address(0), "ERC20: transfer to the zero address");
909         require(amount > 0, "Transfer amount must be greater than zero");
910         if(from != owner() && to != owner())
911             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
912 
913         // is the token balance of this contract address over the min number of
914         // tokens that we need to initiate a swap + liquidity lock?
915         // also, don't get caught in a circular liquidity event.
916         // also, don't swap & liquify if sender is uniswap pair.
917         uint256 contractTokenBalance = balanceOf(address(this));
918         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeReward;
919         if (
920             overMinTokenBalance &&
921             lpRewardEnabled
922         ) {
923             //distribute rewards
924             _rewardLiquidityProviders(contractTokenBalance);
925         }
926         
927         //indicates if fee should be deducted from transfer
928         bool takeFee = true;
929         
930         //if any account belongs to _isExcludedFromFee account then remove the fee
931         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
932             takeFee = false;
933         }
934         
935         //transfer amount, it will take tax, burn, liquidity fee
936         _tokenTransfer(from,to,amount,takeFee);
937     }
938 
939     //this method is responsible for taking all fee, if takeFee is true
940     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
941         if(!takeFee)
942             removeAllFee();
943         
944         if (_isExcluded[sender] && !_isExcluded[recipient]) {
945             _transferFromExcluded(sender, recipient, amount);
946         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
947             _transferToExcluded(sender, recipient, amount);
948         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
949             _transferStandard(sender, recipient, amount);
950         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
951             _transferBothExcluded(sender, recipient, amount);
952         } else {
953             _transferStandard(sender, recipient, amount);
954         }
955         
956         if(!takeFee)
957             restoreAllFee();
958     }
959 
960     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
961         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
962         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
963         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);
964         _takeLpAndDevRewards(tValues.tLpReward,tValues.tDevReward);
965         _reflectFee(rValues.rFee, rValues.rBurn, tValues.tFee, tValues.tBurn);
966         emit Transfer(sender, recipient, tValues.tTransferAmount);
967     }
968 
969     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
970         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
971         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
972         _tOwned[recipient] = _tOwned[recipient].add(tValues.tTransferAmount);
973         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);           
974         _takeLpAndDevRewards(tValues.tLpReward,tValues.tDevReward);
975         _reflectFee(rValues.rFee, rValues.rBurn, tValues.tFee, tValues.tBurn);
976         emit Transfer(sender, recipient, tValues.tTransferAmount);
977     }
978 
979     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
980         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
981         _tOwned[sender] = _tOwned[sender].sub(tAmount);
982         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
983         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);   
984         _takeLpAndDevRewards(tValues.tLpReward,tValues.tDevReward);
985         _reflectFee(rValues.rFee, rValues.rBurn, tValues.tFee, tValues.tBurn);
986         emit Transfer(sender, recipient, tValues.tTransferAmount);
987     }
988 
989     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
990         (TValues memory tValues, RValues memory rValues) = _getValues(tAmount);
991         _tOwned[sender] = _tOwned[sender].sub(tAmount);
992         _rOwned[sender] = _rOwned[sender].sub(rValues.rAmount);
993         _tOwned[recipient] = _tOwned[recipient].add(tValues.tTransferAmount);
994         _rOwned[recipient] = _rOwned[recipient].add(rValues.rTransferAmount);        
995         _takeLpAndDevRewards(tValues.tLpReward,tValues.tDevReward);
996         _reflectFee(rValues.rFee, rValues.rBurn, tValues.tFee, tValues.tBurn);
997         emit Transfer(sender, recipient, tValues.tTransferAmount);
998     }
999 
1000     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
1001         _rTotal = _rTotal.sub(rFee).sub(rBurn);
1002         _tFeeTotal = _tFeeTotal.add(tFee);
1003         _tBurnTotal = _tBurnTotal.add(tBurn);
1004         _tTotal = _tTotal.sub(tBurn);
1005     }
1006     
1007     function _getValues(uint256 tAmount) private view returns (TValues memory tValues, RValues memory rValues) {
1008         tValues = _getTValues(tAmount);
1009         rValues = _getRValues(tAmount,tValues);
1010     }
1011 
1012     function _getTValues(uint256 tAmount) private view returns (TValues memory values) {
1013         values.tFee = calculateTaxFee(tAmount);
1014         values.tBurn = calculateBurnFee(tAmount);
1015         values.tLpReward = calculateLpRewardFee(tAmount);
1016         values.tDevReward = calculateDevRewardFee(tAmount);
1017         values.tTransferAmount = tAmount.sub(values.tFee).sub(values.tBurn).sub(values.tLpReward).sub(values.tDevReward);
1018     }
1019 
1020     function _getRValues(uint256 tAmount, TValues memory tValues) private view returns (RValues memory values) {
1021         values.rate = _getRate();
1022         values.rAmount = tAmount.mul(values.rate);
1023         values.rFee = tValues.tFee.mul(values.rate);
1024         values.rBurn = tValues.tBurn.mul(values.rate);
1025         values.rLpReward = tValues.tLpReward.mul(values.rate);
1026         values.rDevReward = tValues.tDevReward.mul(values.rate);
1027         values.rTransferAmount = values.rAmount.sub(values.rFee).sub(values.rBurn).sub(values.rLpReward).sub(values.rDevReward);
1028     }
1029 
1030     function _getRate() private view returns(uint256) {
1031         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1032         return rSupply.div(tSupply);
1033     }
1034 
1035     function _getCurrentSupply() private view returns(uint256, uint256) {
1036         uint256 rSupply = _rTotal;
1037         uint256 tSupply = _tTotal;      
1038         for (uint256 i = 0; i < _excluded.length; i++) {
1039             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1040             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1041             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1042         }
1043         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1044         return (rSupply, tSupply);
1045     }
1046     
1047     function _takeLpAndDevRewards(uint256 tLiquidity,uint256 tDevRewards) private {
1048         uint256 currentRate =  _getRate();
1049         
1050         //take lp providers reward
1051         uint256 rLiquidity = tLiquidity.mul(currentRate);
1052         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1053         if(_isExcluded[address(this)])
1054             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1055         
1056         //take dev rewards
1057         uint256 rDevRewards = tDevRewards.mul(currentRate);
1058         _rOwned[owner()] = _rOwned[owner()].add(rDevRewards);
1059         if(_isExcluded[owner()])
1060             _tOwned[owner()] = _tOwned[owner()].add(tDevRewards);
1061     }
1062     
1063     function _rewardLiquidityProviders(uint256 liquidityRewards) private {
1064         // avoid fee calling _tokenTransfer with false
1065         _tokenTransfer(address(this), uniswapV2Pair, liquidityRewards,false);
1066         IUniswapV2Pair(uniswapV2Pair).sync();
1067         totalLiquidityProviderRewards = totalLiquidityProviderRewards.add(liquidityRewards);
1068         emit LiquidityProvidersRewarded(liquidityRewards);
1069     }
1070     
1071     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1072         return _amount.mul(_taxFee).div(
1073             10**2
1074         );
1075     }
1076     
1077     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1078         return _amount.mul(_burnFee).div(
1079             10**2
1080         );
1081     }
1082     
1083     function calculateLpRewardFee(uint256 _amount) private view returns (uint256) {
1084         return _amount.mul(_lpRewardFee).div(
1085             10**2
1086         );
1087     }
1088     
1089     function calculateDevRewardFee(uint256 _amount) private view returns (uint256) {
1090         return _amount.mul(_devRewardFee).div(
1091             10**2
1092         );
1093     }
1094     
1095     function removeAllFee() private {
1096         if(_taxFee == 0 && _burnFee == 0 && _lpRewardFee == 0 && _devRewardFee == 0) return;
1097         
1098         _previousTaxFee = _taxFee;
1099         _previousBurnFee = _burnFee;
1100         _previousLpRewardFee = _lpRewardFee;
1101         _previousDevRewardFee = _devRewardFee;
1102         
1103         _taxFee = 0;
1104         _burnFee = 0;
1105         _lpRewardFee = 0;
1106         _devRewardFee = 0;
1107     }
1108     
1109     function restoreAllFee() private {
1110         _taxFee = _previousTaxFee;
1111         _burnFee = _previousBurnFee;
1112         _lpRewardFee = _previousLpRewardFee;
1113         _devRewardFee = _previousDevRewardFee;
1114     }
1115     
1116     function isExcludedFromFee(address account) public view returns(bool) {
1117         return _isExcludedFromFee[account];
1118     }
1119     
1120     function excludeFromFee(address account) public onlyOwner {
1121         _isExcludedFromFee[account] = true;
1122     }
1123     
1124     function includeInFee(address account) public onlyOwner {
1125         _isExcludedFromFee[account] = false;
1126     }
1127     
1128     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1129         _taxFee = taxFee;
1130     }
1131     
1132     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
1133         _burnFee = burnFee;
1134     }
1135     
1136     function setLpRewardFeePercent(uint256 lpRewardFee) external onlyOwner() {
1137         _lpRewardFee = lpRewardFee;
1138     }
1139     
1140     function setDevRewardFeePercent(uint256 devRewardFee) external onlyOwner() {
1141         _devRewardFee = devRewardFee;
1142     }
1143     
1144     function setMaxTxPercent(uint256 maxTxPercent, uint256 maxTxDecimals) external onlyOwner() {
1145         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1146             10**(uint256(maxTxDecimals) + 2)
1147         );
1148     }
1149     
1150     function setMinTokensBeforeSwapPercent(uint256 _minTokensBeforeRewardPercent, uint256 _minTokensBeforeRewardDecimal) public onlyOwner{
1151         minTokensBeforeReward = _tTotal.mul(_minTokensBeforeRewardPercent).div(
1152             10**(uint256(_minTokensBeforeRewardDecimal) + 2)
1153         );
1154         emit MinTokensBeforeRewardUpdated(minTokensBeforeReward);
1155     }
1156 
1157     function setLpRewardEnabled(bool _enabled) public onlyOwner {
1158         lpRewardEnabled = _enabled;
1159         emit LpRewardEnabledUpdated(_enabled);
1160     }
1161     
1162     function setIsTransferLocked(bool enabled) public onlyOwner {
1163         isTransferLocked = enabled;
1164     }
1165     
1166      //to recieve ETH from uniswapV2Router when swaping
1167     receive() external payable {}
1168 }