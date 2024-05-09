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
686 contract NIRVANA is Context, IERC20, Ownable {
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
700     uint256 private _tTotal = 8 * 10**5 * 10**18;
701     uint256 private _rTotal = (MAX - (MAX % _tTotal));
702     uint256 private _tFeeTotal;
703 
704     string private _name = "NIRVANA";
705     string private _symbol = "VANA";
706     uint8 private _decimals = 18;
707     
708     uint256 public _taxFee = 3;
709     uint256 private _previousTaxFee = _taxFee;
710     
711     uint256 public _liquidityFee = 3;
712     uint256 private _previousLiquidityFee = _liquidityFee;
713     
714     //No limit
715     uint256 public _maxTxAmount = _tTotal;
716     
717     IUniswapV2Router02 public immutable uniswapV2Router;
718     address public immutable uniswapV2Pair;
719     
720     bool inSwapAndLiquify;
721     bool public swapAndLiquifyEnabled = true;
722     uint256 private minTokensBeforeSwap = 8;
723     
724     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
725     event SwapAndLiquifyEnabledUpdated(bool enabled);
726     event SwapAndLiquify(
727         uint256 tokensSwapped,
728         uint256 ethReceived,
729         uint256 tokensIntoLiqudity
730     );
731     
732     modifier lockTheSwap {
733         inSwapAndLiquify = true;
734         _;
735         inSwapAndLiquify = false;
736     }
737     
738     constructor () public {
739         _rOwned[_msgSender()] = _rTotal;
740         
741         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
742          // Create a uniswap pair for this new token
743         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
744             .createPair(address(this), _uniswapV2Router.WETH());
745 
746         // set the rest of the contract variables
747         uniswapV2Router = _uniswapV2Router;
748         
749         //exclude owner and this contract from fee
750         _isExcludedFromFee[owner()] = true;
751         _isExcludedFromFee[address(this)] = true;
752         
753         emit Transfer(address(0), _msgSender(), _tTotal);
754     }
755 
756     function name() public view returns (string memory) {
757         return _name;
758     }
759 
760     function symbol() public view returns (string memory) {
761         return _symbol;
762     }
763 
764     function decimals() public view returns (uint8) {
765         return _decimals;
766     }
767 
768     function totalSupply() public view override returns (uint256) {
769         return _tTotal;
770     }
771 
772     function balanceOf(address account) public view override returns (uint256) {
773         if (_isExcluded[account]) return _tOwned[account];
774         return tokenFromReflection(_rOwned[account]);
775     }
776 
777     function transfer(address recipient, uint256 amount) public override returns (bool) {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender) public view override returns (uint256) {
783         return _allowances[owner][spender];
784     }
785 
786     function approve(address spender, uint256 amount) public override returns (bool) {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790 
791     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
792         _transfer(sender, recipient, amount);
793         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
794         return true;
795     }
796 
797     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
798         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
799         return true;
800     }
801 
802     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
803         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
804         return true;
805     }
806 
807     function isExcludedFromReward(address account) public view returns (bool) {
808         return _isExcluded[account];
809     }
810 
811     function totalFees() public view returns (uint256) {
812         return _tFeeTotal;
813     }
814 
815     function deliver(uint256 tAmount) public {
816         address sender = _msgSender();
817         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
818         (uint256 rAmount,,,,,) = _getValues(tAmount);
819         _rOwned[sender] = _rOwned[sender].sub(rAmount);
820         _rTotal = _rTotal.sub(rAmount);
821         _tFeeTotal = _tFeeTotal.add(tAmount);
822     }
823 
824     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
825         require(tAmount <= _tTotal, "Amount must be less than supply");
826         if (!deductTransferFee) {
827             (uint256 rAmount,,,,,) = _getValues(tAmount);
828             return rAmount;
829         } else {
830             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
831             return rTransferAmount;
832         }
833     }
834 
835     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
836         require(rAmount <= _rTotal, "Amount must be less than total reflections");
837         uint256 currentRate =  _getRate();
838         return rAmount.div(currentRate);
839     }
840 
841     function excludeFromReward(address account) public onlyOwner() {
842         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
843         require(!_isExcluded[account], "Account is already excluded");
844         if(_rOwned[account] > 0) {
845             _tOwned[account] = tokenFromReflection(_rOwned[account]);
846         }
847         _isExcluded[account] = true;
848         _excluded.push(account);
849     }
850 
851     function includeInReward(address account) external onlyOwner() {
852         require(_isExcluded[account], "Account is already excluded");
853         for (uint256 i = 0; i < _excluded.length; i++) {
854             if (_excluded[i] == account) {
855                 _excluded[i] = _excluded[_excluded.length - 1];
856                 _tOwned[account] = 0;
857                 _isExcluded[account] = false;
858                 _excluded.pop();
859                 break;
860             }
861         }
862     }
863 
864     function _approve(address owner, address spender, uint256 amount) private {
865         require(owner != address(0), "ERC20: approve from the zero address");
866         require(spender != address(0), "ERC20: approve to the zero address");
867 
868         _allowances[owner][spender] = amount;
869         emit Approval(owner, spender, amount);
870     }
871 
872     function _transfer(
873         address from,
874         address to,
875         uint256 amount
876     ) private {
877         require(from != address(0), "ERC20: transfer from the zero address");
878         require(to != address(0), "ERC20: transfer to the zero address");
879         require(amount > 0, "Transfer amount must be greater than zero");
880         if(from != owner() && to != owner())
881             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
882 
883         // is the token balance of this contract address over the min number of
884         // tokens that we need to initiate a swap + liquidity lock?
885         // also, don't get caught in a circular liquidity event.
886         // also, don't swap & liquify if sender is uniswap pair.
887         uint256 contractTokenBalance = balanceOf(address(this));
888         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
889         if (
890             overMinTokenBalance &&
891             !inSwapAndLiquify &&
892             from != uniswapV2Pair &&
893             swapAndLiquifyEnabled
894         ) {
895             //add liquidity
896             swapAndLiquify(contractTokenBalance);
897         }
898         
899         //indicates if fee should be deducted from transfer
900         bool takeFee = true;
901         
902         //if any account belongs to _isExcludedFromFee account then remove the fee
903         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
904             takeFee = false;
905         }
906         
907         //transfer amount, it will take tax, burn, liquidity fee
908         _tokenTransfer(from,to,amount,takeFee);
909     }
910 
911     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
912         // split the contract balance into halves
913         uint256 half = contractTokenBalance.div(2);
914         uint256 otherHalf = contractTokenBalance.sub(half);
915 
916         // capture the contract's current ETH balance.
917         // this is so that we can capture exactly the amount of ETH that the
918         // swap creates, and not make the liquidity event include any ETH that
919         // has been manually sent to the contract
920         uint256 initialBalance = address(this).balance;
921 
922         // swap tokens for ETH
923         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
924 
925         // how much ETH did we just swap into?
926         uint256 newBalance = address(this).balance.sub(initialBalance);
927 
928         // add liquidity to uniswap
929         addLiquidity(otherHalf, newBalance);
930         
931         emit SwapAndLiquify(half, newBalance, otherHalf);
932     }
933 
934     function swapTokensForEth(uint256 tokenAmount) private {
935         // generate the uniswap pair path of token -> weth
936         address[] memory path = new address[](2);
937         path[0] = address(this);
938         path[1] = uniswapV2Router.WETH();
939 
940         _approve(address(this), address(uniswapV2Router), tokenAmount);
941 
942         // make the swap
943         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
944             tokenAmount,
945             0, // accept any amount of ETH
946             path,
947             address(this),
948             block.timestamp
949         );
950     }
951 
952     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
953         // approve token transfer to cover all possible scenarios
954         _approve(address(this), address(uniswapV2Router), tokenAmount);
955 
956         // add the liquidity
957         uniswapV2Router.addLiquidityETH{value: ethAmount}(
958             address(this),
959             tokenAmount,
960             0, // slippage is unavoidable
961             0, // slippage is unavoidable
962             owner(),
963             block.timestamp
964         );
965     }
966 
967     //this method is responsible for taking all fee, if takeFee is true
968     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
969         if(!takeFee)
970             removeAllFee();
971         
972         if (_isExcluded[sender] && !_isExcluded[recipient]) {
973             _transferFromExcluded(sender, recipient, amount);
974         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
975             _transferToExcluded(sender, recipient, amount);
976         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
977             _transferStandard(sender, recipient, amount);
978         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
979             _transferBothExcluded(sender, recipient, amount);
980         } else {
981             _transferStandard(sender, recipient, amount);
982         }
983         
984         if(!takeFee)
985             restoreAllFee();
986     }
987 
988     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
990         _rOwned[sender] = _rOwned[sender].sub(rAmount);
991         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
992         _takeLiquidity(tLiquidity);
993         _reflectFee(rFee, tFee);
994         emit Transfer(sender, recipient, tTransferAmount);
995     }
996 
997     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
998         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
999         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1000         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1001         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1002         _takeLiquidity(tLiquidity);
1003         _reflectFee(rFee, tFee);
1004         emit Transfer(sender, recipient, tTransferAmount);
1005     }
1006 
1007     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1008         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1009         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1010         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1011         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1012         _takeLiquidity(tLiquidity);
1013         _reflectFee(rFee, tFee);
1014         emit Transfer(sender, recipient, tTransferAmount);
1015     }
1016 
1017     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1018         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1019         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1020         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1021         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1022         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1023         _takeLiquidity(tLiquidity);
1024         _reflectFee(rFee, tFee);
1025         emit Transfer(sender, recipient, tTransferAmount);
1026     }
1027 
1028     function _reflectFee(uint256 rFee, uint256 tFee) private {
1029         _rTotal = _rTotal.sub(rFee);
1030         _tFeeTotal = _tFeeTotal.add(tFee);
1031     }
1032 
1033     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1034         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1035         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1036         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1037     }
1038 
1039     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1040         uint256 tFee = calculateTaxFee(tAmount);
1041         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1042         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1043         return (tTransferAmount, tFee, tLiquidity);
1044     }
1045 
1046     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1047         uint256 rAmount = tAmount.mul(currentRate);
1048         uint256 rFee = tFee.mul(currentRate);
1049         uint256 rLiquidity = tLiquidity.mul(currentRate);
1050         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1051         return (rAmount, rTransferAmount, rFee);
1052     }
1053 
1054     function _getRate() private view returns(uint256) {
1055         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1056         return rSupply.div(tSupply);
1057     }
1058 
1059     function _getCurrentSupply() private view returns(uint256, uint256) {
1060         uint256 rSupply = _rTotal;
1061         uint256 tSupply = _tTotal;      
1062         for (uint256 i = 0; i < _excluded.length; i++) {
1063             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1064             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1065             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1066         }
1067         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1068         return (rSupply, tSupply);
1069     }
1070     
1071     function _takeLiquidity(uint256 tLiquidity) private {
1072         uint256 currentRate =  _getRate();
1073         uint256 rLiquidity = tLiquidity.mul(currentRate);
1074         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1075         if(_isExcluded[address(this)])
1076             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1077     }
1078     
1079     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1080         return _amount.mul(_taxFee).div(
1081             10**2
1082         );
1083     }
1084 
1085     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1086         return _amount.mul(_liquidityFee).div(
1087             10**2
1088         );
1089     }
1090     
1091     function removeAllFee() private {
1092         if(_taxFee == 0 && _liquidityFee == 0) return;
1093         
1094         _previousTaxFee = _taxFee;
1095         _previousLiquidityFee = _liquidityFee;
1096         
1097         _taxFee = 0;
1098         _liquidityFee = 0;
1099     }
1100     
1101     function restoreAllFee() private {
1102         _taxFee = _previousTaxFee;
1103         _liquidityFee = _previousLiquidityFee;
1104     }
1105     
1106     function isExcludedFromFee(address account) public view returns(bool) {
1107         return _isExcludedFromFee[account];
1108     }
1109     
1110     function excludeFromFee(address account) public onlyOwner {
1111         _isExcludedFromFee[account] = true;
1112     }
1113     
1114     function includeInFee(address account) public onlyOwner {
1115         _isExcludedFromFee[account] = false;
1116     }
1117     
1118     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1119         _taxFee = taxFee;
1120     }
1121     
1122     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1123         _liquidityFee = liquidityFee;
1124     }
1125    
1126     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1127         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1128             10**2
1129         );
1130     }
1131 
1132     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1133         swapAndLiquifyEnabled = _enabled;
1134         emit SwapAndLiquifyEnabledUpdated(_enabled);
1135     }
1136     
1137      //to recieve ETH from uniswapV2Router when swaping
1138     receive() external payable {}
1139 }