1 pragma solidity ^0.6.12;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `recipient`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address recipient, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `sender` to `recipient` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104  
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
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
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 /**
249  * @dev Collection of functions related to the address type
250  */
251 library Address {
252     /**
253      * @dev Returns true if `account` is a contract.
254      *
255      * [IMPORTANT]
256      * ====
257      * It is unsafe to assume that an address for which this function returns
258      * false is an externally-owned account (EOA) and not a contract.
259      *
260      * Among others, `isContract` will return false for the following
261      * types of addresses:
262      *
263      *  - an externally-owned account
264      *  - a contract in construction
265      *  - an address where a contract will be created
266      *  - an address where a contract lived, but was destroyed
267      * ====
268      */
269     function isContract(address account) internal view returns (bool) {
270         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272         // for accounts without code, i.e. `keccak256('')`
273         bytes32 codehash;
274         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275         // solhint-disable-next-line no-inline-assembly
276         assembly { codehash := extcodehash(account) }
277         return (codehash != accountHash && codehash != 0x0);
278     }
279 
280     /**
281      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282      * `recipient`, forwarding all available gas and reverting on errors.
283      *
284      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285      * of certain opcodes, possibly making contracts go over the 2300 gas limit
286      * imposed by `transfer`, making them unable to receive funds via
287      * `transfer`. {sendValue} removes this limitation.
288      *
289      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290      *
291      * IMPORTANT: because control is transferred to `recipient`, care must be
292      * taken to not create reentrancy vulnerabilities. Consider using
293      * {ReentrancyGuard} or the
294      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295      */
296     function sendValue(address payable recipient, uint256 amount) internal {
297         require(address(this).balance >= amount, "Address: insufficient balance");
298 
299         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300         (bool success, ) = recipient.call{ value: amount }("");
301         require(success, "Address: unable to send value, recipient may have reverted");
302     }
303 
304     /**
305      * @dev Performs a Solidity function call using a low level `call`. A
306      * plain`call` is an unsafe replacement for a function call: use this
307      * function instead.
308      *
309      * If `target` reverts with a revert reason, it is bubbled up by this
310      * function (like regular Solidity function calls).
311      *
312      * Returns the raw returned data. To convert to the expected return value,
313      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314      *
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable is Context {
399     address private _owner;
400     address private _previousOwner;
401     uint256 private _lockTime;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () internal {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429      /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 
451     function geUnlockTime() public view returns (uint256) {
452         return _lockTime;
453     }
454 
455     //Locks the contract for owner for the amount of time provided
456     function lock(uint256 time) public virtual onlyOwner {
457         _previousOwner = _owner;
458         _owner = address(0);
459         _lockTime = now + time;
460         emit OwnershipTransferred(_owner, address(0));
461     }
462     
463     //Unlocks the contract for owner when _lockTime is exceeds
464     function unlock() public virtual {
465         require(_previousOwner == msg.sender, "You don't have permission to unlock");
466         require(now > _lockTime , "Contract is locked until 7 days");
467         emit OwnershipTransferred(_owner, _previousOwner);
468         _owner = _previousOwner;
469     }
470 }
471 
472 // pragma solidity >=0.5.0;
473 
474 interface IUniswapV2Factory {
475     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
476 
477     function feeTo() external view returns (address);
478     function feeToSetter() external view returns (address);
479 
480     function getPair(address tokenA, address tokenB) external view returns (address pair);
481     function allPairs(uint) external view returns (address pair);
482     function allPairsLength() external view returns (uint);
483 
484     function createPair(address tokenA, address tokenB) external returns (address pair);
485 
486     function setFeeTo(address) external;
487     function setFeeToSetter(address) external;
488 }
489 
490 
491 // pragma solidity >=0.5.0;
492 
493 interface IUniswapV2Pair {
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
546 interface IUniswapV2Router01 {
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
644 interface IUniswapV2Router02 is IUniswapV2Router01 {
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
685 
686 contract Taxyield is Context, IERC20, Ownable {
687     using SafeMath for uint256;
688     using Address for address;
689 
690     mapping (address => uint256) private _rOwned;
691     mapping (address => uint256) private _tOwned;
692     mapping (address => mapping (address => uint256)) private _allowances;
693 
694     mapping (address => bool) private _isExcludedFromFee;
695 
696     mapping (address => bool) private _isExcluded;
697     address[] private _excluded;
698    
699     uint256 private constant MAX = ~uint256(0);
700     uint256 private _tTotal = 11000 * 10**18;
701     uint256 private _rTotal = (MAX - (MAX % _tTotal));
702     uint256 private _tFeeTotal;
703 
704     string private _name = "Txy Yield";
705     string private _symbol = "TXY";
706     uint8 private _decimals = 18;
707     
708     //2%
709     uint256 public _taxFee = 1;
710     uint256 private _previousTaxFee = _taxFee;
711     
712     //2%
713     uint256 public _liquidityFee = 1;
714     uint256 private _previousLiquidityFee = _liquidityFee;
715     
716     //No limit
717     uint256 public _maxTxAmount = _tTotal;
718     
719     IUniswapV2Router02 public immutable uniswapV2Router;
720     address public immutable uniswapV2Pair;
721     
722     bool inSwapAndLiquify;
723     bool public swapAndLiquifyEnabled = true;
724     uint256 private minTokensBeforeSwap = 8;
725     
726     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
727     event SwapAndLiquifyEnabledUpdated(bool enabled);
728     event SwapAndLiquify(
729         uint256 tokensSwapped,
730         uint256 ethReceived,
731         uint256 tokensIntoLiqudity
732     );
733     
734     modifier lockTheSwap {
735         inSwapAndLiquify = true;
736         _;
737         inSwapAndLiquify = false;
738     }
739     
740     constructor () public {
741         _rOwned[_msgSender()] = _rTotal;
742         
743         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
744          // Create a uniswap pair for this new token
745         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
746             .createPair(address(this), _uniswapV2Router.WETH());
747 
748         // set the rest of the contract variables
749         uniswapV2Router = _uniswapV2Router;
750         
751         //exclude owner and this contract from fee
752         _isExcludedFromFee[owner()] = true;
753         _isExcludedFromFee[address(this)] = true;
754         
755         emit Transfer(address(0), _msgSender(), _tTotal);
756     }
757 
758     function name() public view returns (string memory) {
759         return _name;
760     }
761 
762     function symbol() public view returns (string memory) {
763         return _symbol;
764     }
765 
766     function decimals() public view returns (uint8) {
767         return _decimals;
768     }
769 
770     function totalSupply() public view override returns (uint256) {
771         return _tTotal;
772     }
773 
774     function balanceOf(address account) public view override returns (uint256) {
775         if (_isExcluded[account]) return _tOwned[account];
776         return tokenFromReflection(_rOwned[account]);
777     }
778 
779     function transfer(address recipient, uint256 amount) public override returns (bool) {
780         _transfer(_msgSender(), recipient, amount);
781         return true;
782     }
783 
784     function allowance(address owner, address spender) public view override returns (uint256) {
785         return _allowances[owner][spender];
786     }
787 
788     function approve(address spender, uint256 amount) public override returns (bool) {
789         _approve(_msgSender(), spender, amount);
790         return true;
791     }
792 
793     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
794         _transfer(sender, recipient, amount);
795         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
796         return true;
797     }
798 
799     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
800         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
801         return true;
802     }
803 
804     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
805         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
806         return true;
807     }
808 
809     function isExcludedFromReward(address account) public view returns (bool) {
810         return _isExcluded[account];
811     }
812 
813     function totalFees() public view returns (uint256) {
814         return _tFeeTotal;
815     }
816 
817     function deliver(uint256 tAmount) public {
818         address sender = _msgSender();
819         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
820         (uint256 rAmount,,,,,) = _getValues(tAmount);
821         _rOwned[sender] = _rOwned[sender].sub(rAmount);
822         _rTotal = _rTotal.sub(rAmount);
823         _tFeeTotal = _tFeeTotal.add(tAmount);
824     }
825 
826     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
827         require(tAmount <= _tTotal, "Amount must be less than supply");
828         if (!deductTransferFee) {
829             (uint256 rAmount,,,,,) = _getValues(tAmount);
830             return rAmount;
831         } else {
832             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
833             return rTransferAmount;
834         }
835     }
836 
837     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
838         require(rAmount <= _rTotal, "Amount must be less than total reflections");
839         uint256 currentRate =  _getRate();
840         return rAmount.div(currentRate);
841     }
842 
843     function excludeFromReward(address account) public onlyOwner() {
844         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
845         require(!_isExcluded[account], "Account is already excluded");
846         if(_rOwned[account] > 0) {
847             _tOwned[account] = tokenFromReflection(_rOwned[account]);
848         }
849         _isExcluded[account] = true;
850         _excluded.push(account);
851     }
852 
853     function includeInReward(address account) external onlyOwner() {
854         require(_isExcluded[account], "Account is already excluded");
855         for (uint256 i = 0; i < _excluded.length; i++) {
856             if (_excluded[i] == account) {
857                 _excluded[i] = _excluded[_excluded.length - 1];
858                 _tOwned[account] = 0;
859                 _isExcluded[account] = false;
860                 _excluded.pop();
861                 break;
862             }
863         }
864     }
865 
866     function _approve(address owner, address spender, uint256 amount) private {
867         require(owner != address(0), "ERC20: approve from the zero address");
868         require(spender != address(0), "ERC20: approve to the zero address");
869 
870         _allowances[owner][spender] = amount;
871         emit Approval(owner, spender, amount);
872     }
873 
874     function _transfer(
875         address from,
876         address to,
877         uint256 amount
878     ) private {
879         require(from != address(0), "ERC20: transfer from the zero address");
880         require(to != address(0), "ERC20: transfer to the zero address");
881         require(amount > 0, "Transfer amount must be greater than zero");
882         if(from != owner() && to != owner())
883             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
884 
885         // is the token balance of this contract address over the min number of
886         // tokens that we need to initiate a swap + liquidity lock?
887         // also, don't get caught in a circular liquidity event.
888         // also, don't swap & liquify if sender is uniswap pair.
889         uint256 contractTokenBalance = balanceOf(address(this));
890         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
891         if (
892             overMinTokenBalance &&
893             !inSwapAndLiquify &&
894             from != uniswapV2Pair &&
895             swapAndLiquifyEnabled
896         ) {
897             //add liquidity
898             swapAndLiquify(contractTokenBalance);
899         }
900         
901         //indicates if fee should be deducted from transfer
902         bool takeFee = true;
903         
904         //if any account belongs to _isExcludedFromFee account then remove the fee
905         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
906             takeFee = false;
907         }
908         
909         //transfer amount, it will take tax, burn, liquidity fee
910         _tokenTransfer(from,to,amount,takeFee);
911     }
912 
913     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
914         // split the contract balance into halves
915         uint256 half = contractTokenBalance.div(2);
916         uint256 otherHalf = contractTokenBalance.sub(half);
917 
918         // capture the contract's current ETH balance.
919         // this is so that we can capture exactly the amount of ETH that the
920         // swap creates, and not make the liquidity event include any ETH that
921         // has been manually sent to the contract
922         uint256 initialBalance = address(this).balance;
923 
924         // swap tokens for ETH
925         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
926 
927         // how much ETH did we just swap into?
928         uint256 newBalance = address(this).balance.sub(initialBalance);
929 
930         // add liquidity to uniswap
931         addLiquidity(otherHalf, newBalance);
932         
933         emit SwapAndLiquify(half, newBalance, otherHalf);
934     }
935 
936     function swapTokensForEth(uint256 tokenAmount) private {
937         // generate the uniswap pair path of token -> weth
938         address[] memory path = new address[](2);
939         path[0] = address(this);
940         path[1] = uniswapV2Router.WETH();
941 
942         _approve(address(this), address(uniswapV2Router), tokenAmount);
943 
944         // make the swap
945         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
946             tokenAmount,
947             0, // accept any amount of ETH
948             path,
949             address(this),
950             block.timestamp
951         );
952     }
953 
954     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
955         // approve token transfer to cover all possible scenarios
956         _approve(address(this), address(uniswapV2Router), tokenAmount);
957 
958         // add the liquidity
959         uniswapV2Router.addLiquidityETH{value: ethAmount}(
960             address(this),
961             tokenAmount,
962             0, // slippage is unavoidable
963             0, // slippage is unavoidable
964             owner(),
965             block.timestamp
966         );
967     }
968 
969     //this method is responsible for taking all fee, if takeFee is true
970     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
971         if(!takeFee)
972             removeAllFee();
973         
974         if (_isExcluded[sender] && !_isExcluded[recipient]) {
975             _transferFromExcluded(sender, recipient, amount);
976         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
977             _transferToExcluded(sender, recipient, amount);
978         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
979             _transferStandard(sender, recipient, amount);
980         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
981             _transferBothExcluded(sender, recipient, amount);
982         } else {
983             _transferStandard(sender, recipient, amount);
984         }
985         
986         if(!takeFee)
987             restoreAllFee();
988     }
989 
990     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
991         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
992         _rOwned[sender] = _rOwned[sender].sub(rAmount);
993         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
994         _takeLiquidity(tLiquidity);
995         _reflectFee(rFee, tFee);
996         emit Transfer(sender, recipient, tTransferAmount);
997     }
998 
999     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1000         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1001         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1002         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1003         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1004         _takeLiquidity(tLiquidity);
1005         _reflectFee(rFee, tFee);
1006         emit Transfer(sender, recipient, tTransferAmount);
1007     }
1008 
1009     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1010         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1011         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1012         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1013         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1014         _takeLiquidity(tLiquidity);
1015         _reflectFee(rFee, tFee);
1016         emit Transfer(sender, recipient, tTransferAmount);
1017     }
1018 
1019     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1020         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1021         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1022         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1023         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1024         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1025         _takeLiquidity(tLiquidity);
1026         _reflectFee(rFee, tFee);
1027         emit Transfer(sender, recipient, tTransferAmount);
1028     }
1029 
1030     function _reflectFee(uint256 rFee, uint256 tFee) private {
1031         _rTotal = _rTotal.sub(rFee);
1032         _tFeeTotal = _tFeeTotal.add(tFee);
1033     }
1034 
1035     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1036         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1037         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1038         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1039     }
1040 
1041     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1042         uint256 tFee = calculateTaxFee(tAmount);
1043         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1044         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1045         return (tTransferAmount, tFee, tLiquidity);
1046     }
1047 
1048     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1049         uint256 rAmount = tAmount.mul(currentRate);
1050         uint256 rFee = tFee.mul(currentRate);
1051         uint256 rLiquidity = tLiquidity.mul(currentRate);
1052         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1053         return (rAmount, rTransferAmount, rFee);
1054     }
1055 
1056     function _getRate() private view returns(uint256) {
1057         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1058         return rSupply.div(tSupply);
1059     }
1060 
1061     function _getCurrentSupply() private view returns(uint256, uint256) {
1062         uint256 rSupply = _rTotal;
1063         uint256 tSupply = _tTotal;      
1064         for (uint256 i = 0; i < _excluded.length; i++) {
1065             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1066             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1067             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1068         }
1069         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1070         return (rSupply, tSupply);
1071     }
1072     
1073     function _takeLiquidity(uint256 tLiquidity) private {
1074         uint256 currentRate =  _getRate();
1075         uint256 rLiquidity = tLiquidity.mul(currentRate);
1076         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1077         if(_isExcluded[address(this)])
1078             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1079     }
1080     
1081     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1082         return _amount.mul(_taxFee).div(
1083             10**2
1084         );
1085     }
1086 
1087     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1088         return _amount.mul(_liquidityFee).div(
1089             10**2
1090         );
1091     }
1092     
1093     function removeAllFee() private {
1094         if(_taxFee == 0 && _liquidityFee == 0) return;
1095         
1096         _previousTaxFee = _taxFee;
1097         _previousLiquidityFee = _liquidityFee;
1098         
1099         _taxFee = 0;
1100         _liquidityFee = 0;
1101     }
1102     
1103     function restoreAllFee() private {
1104         _taxFee = _previousTaxFee;
1105         _liquidityFee = _previousLiquidityFee;
1106     }
1107     
1108     function isExcludedFromFee(address account) public view returns(bool) {
1109         return _isExcludedFromFee[account];
1110     }
1111     
1112     function excludeFromFee(address account) public onlyOwner {
1113         _isExcludedFromFee[account] = true;
1114     }
1115     
1116     function includeInFee(address account) public onlyOwner {
1117         _isExcludedFromFee[account] = false;
1118     }
1119     
1120     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1121         _taxFee = taxFee;
1122     }
1123     
1124     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1125         _liquidityFee = liquidityFee;
1126     }
1127    
1128     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1129         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1130             10**2
1131         );
1132     }
1133 
1134     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1135         swapAndLiquifyEnabled = _enabled;
1136         emit SwapAndLiquifyEnabledUpdated(_enabled);
1137     }
1138     
1139      //to recieve ETH from uniswapV2Router when swaping
1140     receive() external payable {}
1141 }