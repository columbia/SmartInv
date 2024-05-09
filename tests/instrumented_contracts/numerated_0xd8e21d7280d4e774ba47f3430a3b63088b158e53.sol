1 /*
2 
3    Shibgoose - $SHIBGOOSE 
4 
5    https://t.me/ShibGooseETH
6 
7    https://twitter.com/ShibGooseETH
8 
9    https://www.shibgoose.com/
10 
11    Mongoose and Shiba Inu did it wild.
12 */
13 
14 
15 
16 // SPDX-License-Identifier: Unlicensed
17 
18 pragma solidity ^0.8.9;
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
248     //function _msgSender() internal view virtual returns (address payable) {
249     function _msgSender() internal view virtual returns (address) {
250         return msg.sender;
251     }
252 
253     function _msgData() internal view virtual returns (bytes memory) {
254         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
255         return msg.data;
256     }
257 }
258 
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284         // for accounts without code, i.e. `keccak256('')`
285         bytes32 codehash;
286         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { codehash := extcodehash(account) }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335       return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 /**
399  * @dev Contract module which provides a basic access control mechanism, where
400  * there is an account (an owner) that can be granted exclusive access to
401  * specific functions.
402  *
403  * By default, the owner account will be the one that deploys the contract. This
404  * can later be changed with {transferOwnership}.
405  *
406  * This module is used through inheritance. It will make available the modifier
407  * `onlyOwner`, which can be applied to your functions to restrict their use to
408  * the owner.
409  */
410 contract Ownable is Context {
411     address private _owner;
412     address private _previousOwner;
413     uint256 private _lockTime;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     /**
418      * @dev Initializes the contract setting the deployer as the initial owner.
419      */
420     constructor () {
421         address msgSender = _msgSender();
422         _owner = msgSender;
423         emit OwnershipTransferred(address(0), msgSender);
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(_owner == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441      /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         emit OwnershipTransferred(_owner, address(0));
450         _owner = address(0);
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Can only be called by the current owner.
456      */
457     function transferOwnership(address newOwner) public virtual onlyOwner {
458         require(newOwner != address(0), "Ownable: new owner is the zero address");
459         emit OwnershipTransferred(_owner, newOwner);
460         _owner = newOwner;
461     }
462 
463     function geUnlockTime() public view returns (uint256) {
464         return _lockTime;
465     }
466 
467     //Locks the contract for owner for the amount of time provided
468     function lock(uint256 time) public virtual onlyOwner {
469         _previousOwner = _owner;
470         _owner = address(0);
471         _lockTime = block.timestamp + time;
472         emit OwnershipTransferred(_owner, address(0));
473     }
474     
475     //Unlocks the contract for owner when _lockTime is exceeds
476     function unlock() public virtual {
477         require(_previousOwner == msg.sender, "You don't have permission to unlock");
478         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
479         emit OwnershipTransferred(_owner, _previousOwner);
480         _owner = _previousOwner;
481     }
482 }
483 
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
502 
503 interface IUniswapV2Pair {
504     event Approval(address indexed owner, address indexed spender, uint value);
505     event Transfer(address indexed from, address indexed to, uint value);
506 
507     function name() external pure returns (string memory);
508     function symbol() external pure returns (string memory);
509     function decimals() external pure returns (uint8);
510     function totalSupply() external view returns (uint);
511     function balanceOf(address owner) external view returns (uint);
512     function allowance(address owner, address spender) external view returns (uint);
513 
514     function approve(address spender, uint value) external returns (bool);
515     function transfer(address to, uint value) external returns (bool);
516     function transferFrom(address from, address to, uint value) external returns (bool);
517 
518     function DOMAIN_SEPARATOR() external view returns (bytes32);
519     function PERMIT_TYPEHASH() external pure returns (bytes32);
520     function nonces(address owner) external view returns (uint);
521 
522     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
523 
524     event Mint(address indexed sender, uint amount0, uint amount1);
525     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
526     event Swap(
527         address indexed sender,
528         uint amount0In,
529         uint amount1In,
530         uint amount0Out,
531         uint amount1Out,
532         address indexed to
533     );
534     event Sync(uint112 reserve0, uint112 reserve1);
535 
536     function MINIMUM_LIQUIDITY() external pure returns (uint);
537     function factory() external view returns (address);
538     function token0() external view returns (address);
539     function token1() external view returns (address);
540     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
541     function price0CumulativeLast() external view returns (uint);
542     function price1CumulativeLast() external view returns (uint);
543     function kLast() external view returns (uint);
544 
545     function mint(address to) external returns (uint liquidity);
546     function burn(address to) external returns (uint amount0, uint amount1);
547     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
548     function skim(address to) external;
549     function sync() external;
550 
551     function initialize(address, address) external;
552 }
553 
554 
555 interface IUniswapV2Router01 {
556     function factory() external pure returns (address);
557     function WETH() external pure returns (address);
558 
559     function addLiquidity(
560         address tokenA,
561         address tokenB,
562         uint amountADesired,
563         uint amountBDesired,
564         uint amountAMin,
565         uint amountBMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountA, uint amountB, uint liquidity);
569     function addLiquidityETH(
570         address token,
571         uint amountTokenDesired,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
577     function removeLiquidity(
578         address tokenA,
579         address tokenB,
580         uint liquidity,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline
585     ) external returns (uint amountA, uint amountB);
586     function removeLiquidityETH(
587         address token,
588         uint liquidity,
589         uint amountTokenMin,
590         uint amountETHMin,
591         address to,
592         uint deadline
593     ) external returns (uint amountToken, uint amountETH);
594     function removeLiquidityWithPermit(
595         address tokenA,
596         address tokenB,
597         uint liquidity,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline,
602         bool approveMax, uint8 v, bytes32 r, bytes32 s
603     ) external returns (uint amountA, uint amountB);
604     function removeLiquidityETHWithPermit(
605         address token,
606         uint liquidity,
607         uint amountTokenMin,
608         uint amountETHMin,
609         address to,
610         uint deadline,
611         bool approveMax, uint8 v, bytes32 r, bytes32 s
612     ) external returns (uint amountToken, uint amountETH);
613     function swapExactTokensForTokens(
614         uint amountIn,
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapTokensForExactTokens(
621         uint amountOut,
622         uint amountInMax,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external returns (uint[] memory amounts);
627     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         payable
630         returns (uint[] memory amounts);
631     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
632         external
633         returns (uint[] memory amounts);
634     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
635         external
636         returns (uint[] memory amounts);
637     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
638         external
639         payable
640         returns (uint[] memory amounts);
641 
642     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
643     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
644     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
645     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
646     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
647 }
648 
649 
650 
651 
652 interface IUniswapV2Router02 is IUniswapV2Router01 {
653     function removeLiquidityETHSupportingFeeOnTransferTokens(
654         address token,
655         uint liquidity,
656         uint amountTokenMin,
657         uint amountETHMin,
658         address to,
659         uint deadline
660     ) external returns (uint amountETH);
661     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
662         address token,
663         uint liquidity,
664         uint amountTokenMin,
665         uint amountETHMin,
666         address to,
667         uint deadline,
668         bool approveMax, uint8 v, bytes32 r, bytes32 s
669     ) external returns (uint amountETH);
670 
671     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
672         uint amountIn,
673         uint amountOutMin,
674         address[] calldata path,
675         address to,
676         uint deadline
677     ) external;
678     function swapExactETHForTokensSupportingFeeOnTransferTokens(
679         uint amountOutMin,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external payable;
684     function swapExactTokensForETHSupportingFeeOnTransferTokens(
685         uint amountIn,
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external;
691 }
692 
693 interface IAirdrop {
694     function airdrop(address recipient, uint256 amount) external;
695 }
696 
697 contract SHIBGOOSE is Context, IERC20, Ownable {
698     using SafeMath for uint256;
699     using Address for address;
700 
701     mapping (address => uint256) private _rOwned;
702     mapping (address => uint256) private _tOwned;
703     mapping (address => mapping (address => uint256)) private _allowances;
704 
705     mapping (address => bool) private _isExcludedFromFee;
706 
707     mapping (address => bool) private _isExcluded;
708     address[] private _excluded;
709     
710     mapping (address => bool) private botWallets;
711     bool botscantrade = false;
712     
713     bool public canTrade = false;
714    
715     uint256 private constant MAX = ~uint256(0);
716     uint256 private _tTotal = 69000000000000000000000 * 10**9;
717     uint256 private _rTotal = (MAX - (MAX % _tTotal));
718     uint256 private _tFeeTotal;
719     address public marketingWallet;
720 
721     string private _name = "Shibgoose";
722     string private _symbol = "SHIBGOOSE";
723     uint8 private _decimals = 9;
724     
725     uint256 public _taxFee = 1;
726     uint256 private _previousTaxFee = _taxFee;
727     
728     uint256 public _liquidityFee = 12;
729     uint256 private _previousLiquidityFee = _liquidityFee;
730 
731     IUniswapV2Router02 public immutable uniswapV2Router;
732     address public immutable uniswapV2Pair;
733     
734     bool inSwapAndLiquify;
735     bool public swapAndLiquifyEnabled = true;
736     
737     uint256 public _maxTxAmount = 990000000000000000000 * 10**9;
738     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
739     
740     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
741     event SwapAndLiquifyEnabledUpdated(bool enabled);
742     event SwapAndLiquify(
743         uint256 tokensSwapped,
744         uint256 ethReceived,
745         uint256 tokensIntoLiqudity
746     );
747     
748     modifier lockTheSwap {
749         inSwapAndLiquify = true;
750         _;
751         inSwapAndLiquify = false;
752     }
753     
754     constructor () {
755         _rOwned[_msgSender()] = _rTotal;
756         
757         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
758          // Create a uniswap pair for this new token
759         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
760             .createPair(address(this), _uniswapV2Router.WETH());
761 
762         // set the rest of the contract variables
763         uniswapV2Router = _uniswapV2Router;
764         
765         //exclude owner and this contract from fee
766         _isExcludedFromFee[owner()] = true;
767         _isExcludedFromFee[address(this)] = true;
768         
769         emit Transfer(address(0), _msgSender(), _tTotal);
770     }
771 
772     function name() public view returns (string memory) {
773         return _name;
774     }
775 
776     function symbol() public view returns (string memory) {
777         return _symbol;
778     }
779 
780     function decimals() public view returns (uint8) {
781         return _decimals;
782     }
783 
784     function totalSupply() public view override returns (uint256) {
785         return _tTotal;
786     }
787 
788     function balanceOf(address account) public view override returns (uint256) {
789         if (_isExcluded[account]) return _tOwned[account];
790         return tokenFromReflection(_rOwned[account]);
791     }
792 
793     function transfer(address recipient, uint256 amount) public override returns (bool) {
794         _transfer(_msgSender(), recipient, amount);
795         return true;
796     }
797 
798     function allowance(address owner, address spender) public view override returns (uint256) {
799         return _allowances[owner][spender];
800     }
801 
802     function approve(address spender, uint256 amount) public override returns (bool) {
803         _approve(_msgSender(), spender, amount);
804         return true;
805     }
806 
807     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
810         return true;
811     }
812 
813     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
815         return true;
816     }
817 
818     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
820         return true;
821     }
822 
823     function isExcludedFromReward(address account) public view returns (bool) {
824         return _isExcluded[account];
825     }
826 
827     function totalFees() public view returns (uint256) {
828         return _tFeeTotal;
829     }
830     
831     function airdrop(address recipient, uint256 amount) external onlyOwner() {
832         removeAllFee();
833         _transfer(_msgSender(), recipient, amount * 10**9);
834         restoreAllFee();
835     }
836     
837     function airdropInternal(address recipient, uint256 amount) internal {
838         removeAllFee();
839         _transfer(_msgSender(), recipient, amount);
840         restoreAllFee();
841     }
842     
843     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
844         uint256 iterator = 0;
845         require(newholders.length == amounts.length, "must be the same length");
846         while(iterator < newholders.length){
847             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
848             iterator += 1;
849         }
850     }
851 
852     function deliver(uint256 tAmount) public {
853         address sender = _msgSender();
854         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
855         (uint256 rAmount,,,,,) = _getValues(tAmount);
856         _rOwned[sender] = _rOwned[sender].sub(rAmount);
857         _rTotal = _rTotal.sub(rAmount);
858         _tFeeTotal = _tFeeTotal.add(tAmount);
859     }
860 
861     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
862         require(tAmount <= _tTotal, "Amount must be less than supply");
863         if (!deductTransferFee) {
864             (uint256 rAmount,,,,,) = _getValues(tAmount);
865             return rAmount;
866         } else {
867             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
868             return rTransferAmount;
869         }
870     }
871 
872     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
873         require(rAmount <= _rTotal, "Amount must be less than total reflections");
874         uint256 currentRate =  _getRate();
875         return rAmount.div(currentRate);
876     }
877 
878     function excludeFromReward(address account) public onlyOwner() {
879         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
880         require(!_isExcluded[account], "Account is already excluded");
881         if(_rOwned[account] > 0) {
882             _tOwned[account] = tokenFromReflection(_rOwned[account]);
883         }
884         _isExcluded[account] = true;
885         _excluded.push(account);
886     }
887 
888     function includeInReward(address account) external onlyOwner() {
889         require(_isExcluded[account], "Account is already excluded");
890         for (uint256 i = 0; i < _excluded.length; i++) {
891             if (_excluded[i] == account) {
892                 _excluded[i] = _excluded[_excluded.length - 1];
893                 _tOwned[account] = 0;
894                 _isExcluded[account] = false;
895                 _excluded.pop();
896                 break;
897             }
898         }
899     }
900         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
901         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
902         _tOwned[sender] = _tOwned[sender].sub(tAmount);
903         _rOwned[sender] = _rOwned[sender].sub(rAmount);
904         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
905         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
906         _takeLiquidity(tLiquidity);
907         _reflectFee(rFee, tFee);
908         emit Transfer(sender, recipient, tTransferAmount);
909     }
910     
911     function excludeFromFee(address account) public onlyOwner {
912         _isExcludedFromFee[account] = true;
913     }
914     
915     function includeInFee(address account) public onlyOwner {
916         _isExcludedFromFee[account] = false;
917     }
918 
919     function setMarketingWallet(address walletAddress) public onlyOwner {
920         marketingWallet = walletAddress;
921     }
922 
923     function upliftTxAmount() external onlyOwner() {
924         _maxTxAmount = 69000000000000000000000 * 10**9;
925     }
926     
927     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
928         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
929         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
930     }
931     
932     function claimTokens () public onlyOwner {
933         // make sure we capture all BNB that may or may not be sent to this contract
934         payable(marketingWallet).transfer(address(this).balance);
935     }
936     
937     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
938         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
939     }
940     
941     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
942         walletaddress.transfer(address(this).balance);
943     }
944     
945     function addBotWallet(address botwallet) external onlyOwner() {
946         botWallets[botwallet] = true;
947     }
948     
949     function removeBotWallet(address botwallet) external onlyOwner() {
950         botWallets[botwallet] = false;
951     }
952     
953     function getBotWalletStatus(address botwallet) public view returns (bool) {
954         return botWallets[botwallet];
955     }
956     
957     function allowtrading()external onlyOwner() {
958         canTrade = true;
959     }
960 
961     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
962         swapAndLiquifyEnabled = _enabled;
963         emit SwapAndLiquifyEnabledUpdated(_enabled);
964     }
965     
966      //to recieve ETH from uniswapV2Router when swaping
967     receive() external payable {}
968 
969     function _reflectFee(uint256 rFee, uint256 tFee) private {
970         _rTotal = _rTotal.sub(rFee);
971         _tFeeTotal = _tFeeTotal.add(tFee);
972     }
973 
974     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
975         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
976         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
977         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
978     }
979 
980     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
981         uint256 tFee = calculateTaxFee(tAmount);
982         uint256 tLiquidity = calculateLiquidityFee(tAmount);
983         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
984         return (tTransferAmount, tFee, tLiquidity);
985     }
986 
987     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
988         uint256 rAmount = tAmount.mul(currentRate);
989         uint256 rFee = tFee.mul(currentRate);
990         uint256 rLiquidity = tLiquidity.mul(currentRate);
991         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
992         return (rAmount, rTransferAmount, rFee);
993     }
994 
995     function _getRate() private view returns(uint256) {
996         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
997         return rSupply.div(tSupply);
998     }
999 
1000     function _getCurrentSupply() private view returns(uint256, uint256) {
1001         uint256 rSupply = _rTotal;
1002         uint256 tSupply = _tTotal;      
1003         for (uint256 i = 0; i < _excluded.length; i++) {
1004             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1005             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1006             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1007         }
1008         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1009         return (rSupply, tSupply);
1010     }
1011     
1012     function _takeLiquidity(uint256 tLiquidity) private {
1013         uint256 currentRate =  _getRate();
1014         uint256 rLiquidity = tLiquidity.mul(currentRate);
1015         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1016         if(_isExcluded[address(this)])
1017             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1018     }
1019     
1020     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1021         return _amount.mul(_taxFee).div(
1022             10**2
1023         );
1024     }
1025 
1026     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1027         return _amount.mul(_liquidityFee).div(
1028             10**2
1029         );
1030     }
1031     
1032     function removeAllFee() private {
1033         if(_taxFee == 0 && _liquidityFee == 0) return;
1034         
1035         _previousTaxFee = _taxFee;
1036         _previousLiquidityFee = _liquidityFee;
1037         
1038         _taxFee = 0;
1039         _liquidityFee = 0;
1040     }
1041     
1042     function restoreAllFee() private {
1043         _taxFee = _previousTaxFee;
1044         _liquidityFee = _previousLiquidityFee;
1045     }
1046     
1047     function isExcludedFromFee(address account) public view returns(bool) {
1048         return _isExcludedFromFee[account];
1049     }
1050 
1051     function _approve(address owner, address spender, uint256 amount) private {
1052         require(owner != address(0), "ERC20: approve from the zero address");
1053         require(spender != address(0), "ERC20: approve to the zero address");
1054 
1055         _allowances[owner][spender] = amount;
1056         emit Approval(owner, spender, amount);
1057     }
1058 
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 amount
1063     ) private {
1064         require(from != address(0), "ERC20: transfer from the zero address");
1065         require(to != address(0), "ERC20: transfer to the zero address");
1066         require(amount > 0, "Transfer amount must be greater than zero");
1067         if(from != owner() && to != owner())
1068             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1069 
1070         // is the token balance of this contract address over the min number of
1071         // tokens that we need to initiate a swap + liquidity lock?
1072         // also, don't get caught in a circular liquidity event.
1073         // also, don't swap & liquify if sender is uniswap pair.
1074         uint256 contractTokenBalance = balanceOf(address(this));
1075         
1076         if(contractTokenBalance >= _maxTxAmount)
1077         {
1078             contractTokenBalance = _maxTxAmount;
1079         }
1080         
1081         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1082         if (
1083             overMinTokenBalance &&
1084             !inSwapAndLiquify &&
1085             from != uniswapV2Pair &&
1086             swapAndLiquifyEnabled
1087         ) {
1088             contractTokenBalance = numTokensSellToAddToLiquidity;
1089             //add liquidity
1090             swapAndLiquify(contractTokenBalance);
1091         }
1092         
1093         //indicates if fee should be deducted from transfer
1094         bool takeFee = true;
1095         
1096         //if any account belongs to _isExcludedFromFee account then remove the fee
1097         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1098             takeFee = false;
1099         }
1100         
1101         //transfer amount, it will take tax, burn, liquidity fee
1102         _tokenTransfer(from,to,amount,takeFee);
1103     }
1104 
1105     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1106         // split the contract balance into halves
1107         // add the marketing wallet
1108         uint256 half = contractTokenBalance.div(2);
1109         uint256 otherHalf = contractTokenBalance.sub(half);
1110 
1111         // capture the contract's current ETH balance.
1112         // this is so that we can capture exactly the amount of ETH that the
1113         // swap creates, and not make the liquidity event include any ETH that
1114         // has been manually sent to the contract
1115         uint256 initialBalance = address(this).balance;
1116 
1117         // swap tokens for ETH
1118         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1119 
1120         // how much ETH did we just swap into?
1121         uint256 newBalance = address(this).balance.sub(initialBalance);
1122         uint256 marketingshare = newBalance.mul(75).div(100);
1123         payable(marketingWallet).transfer(marketingshare);
1124         newBalance -= marketingshare;
1125         // add liquidity to uniswap
1126         addLiquidity(otherHalf, newBalance);
1127         
1128         emit SwapAndLiquify(half, newBalance, otherHalf);
1129     }
1130 
1131     function swapTokensForEth(uint256 tokenAmount) private {
1132         // generate the uniswap pair path of token -> weth
1133         address[] memory path = new address[](2);
1134         path[0] = address(this);
1135         path[1] = uniswapV2Router.WETH();
1136 
1137         _approve(address(this), address(uniswapV2Router), tokenAmount);
1138 
1139         // make the swap
1140         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1141             tokenAmount,
1142             0, // accept any amount of ETH
1143             path,
1144             address(this),
1145             block.timestamp
1146         );
1147     }
1148 
1149     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1150         // approve token transfer to cover all possible scenarios
1151         _approve(address(this), address(uniswapV2Router), tokenAmount);
1152 
1153         // add the liquidity
1154         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1155             address(this),
1156             tokenAmount,
1157             0, // slippage is unavoidable
1158             0, // slippage is unavoidable
1159             owner(),
1160             block.timestamp
1161         );
1162     }
1163 
1164     //this method is responsible for taking all fee, if takeFee is true
1165     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1166         if(!canTrade){
1167             require(sender == owner()); // only owner allowed to trade or add liquidity
1168         }
1169         
1170         if(botWallets[sender] || botWallets[recipient]){
1171             require(botscantrade, "bots arent allowed to trade");
1172         }
1173         
1174         if(!takeFee)
1175             removeAllFee();
1176         
1177         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1178             _transferFromExcluded(sender, recipient, amount);
1179         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1180             _transferToExcluded(sender, recipient, amount);
1181         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1182             _transferStandard(sender, recipient, amount);
1183         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1184             _transferBothExcluded(sender, recipient, amount);
1185         } else {
1186             _transferStandard(sender, recipient, amount);
1187         }
1188         
1189         if(!takeFee)
1190             restoreAllFee();
1191     }
1192 
1193     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1194         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1195         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1196         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1197         _takeLiquidity(tLiquidity);
1198         _reflectFee(rFee, tFee);
1199         emit Transfer(sender, recipient, tTransferAmount);
1200     }
1201 
1202     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1203         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1204         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1205         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1206         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1207         _takeLiquidity(tLiquidity);
1208         _reflectFee(rFee, tFee);
1209         emit Transfer(sender, recipient, tTransferAmount);
1210     }
1211 
1212     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1213         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1214         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1217         _takeLiquidity(tLiquidity);
1218         _reflectFee(rFee, tFee);
1219         emit Transfer(sender, recipient, tTransferAmount);
1220     }
1221 
1222 }