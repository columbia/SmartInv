1 /**
2   
3    #BEE
4    
5    #LIQ+#RFI+#SHIB+#DOGE = #BEE
6    #SAFEMOON features:
7    3% fee auto add to the liquidity pool to locked forever when selling
8    2% fee auto distribute to all holders
9    I created a black hole so #Bee token will deflate itself in supply with every transaction
10    50% Supply is burned at start.
11    
12  */
13 
14 pragma solidity ^0.6.12;
15 // SPDX-License-Identifier: Unlicensed
16 interface IERC20 {
17 
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100  
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      *
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      *
158      * - Multiplication cannot overflow.
159      */
160     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint256 c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b) internal pure returns (uint256) {
187         return div(a, b, "SafeMath: division by zero");
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223         return mod(a, b, "SafeMath: modulo by zero");
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts with custom message when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
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
418         _owner = msgSender;
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
482 interface IUniswapV2Factory {
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
498 
499 // pragma solidity >=0.5.0;
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
552 // pragma solidity >=0.6.2;
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
650 // pragma solidity >=0.6.2;
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
693 
694 contract DekuInu is Context, IERC20, Ownable {
695     using SafeMath for uint256;
696     using Address for address;
697 
698     mapping (address => uint256) private _rOwned;
699     mapping (address => uint256) private _tOwned;
700     mapping (address => mapping (address => uint256)) private _allowances;
701 
702     mapping (address => bool) private _isExcludedFromFee;
703 
704     mapping (address => bool) private _isExcluded;
705     address[] private _excluded;
706    
707     uint256 private constant MAX = ~uint256(0);
708     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
709     uint256 private _rTotal = (MAX - (MAX % _tTotal));
710     uint256 private _tFeeTotal;
711 
712     string private _name = "DekuInu";
713     string private _symbol = "DEKU";
714     uint8 private _decimals = 9;
715     
716     uint256 public _taxFee = 3;
717     uint256 private _previousTaxFee = _taxFee;
718     
719     uint256 public _liquidityFee = 2;
720     uint256 private _previousLiquidityFee = _liquidityFee;
721 
722     uint256 public _marketingFee = 3; // All taxes are divided by 100 for more accuracy.
723     uint256 private _previousMarketingFee = _marketingFee;    
724 
725     IUniswapV2Router02 public immutable uniswapV2Router;
726     address public immutable uniswapV2Pair;
727     
728     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
729     address payable private _marketingWallet;
730 
731     bool inSwapAndLiquify;
732     bool public swapAndLiquifyEnabled = true;
733     
734     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
735     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
736     
737     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
738     event SwapAndLiquifyEnabledUpdated(bool enabled);
739     event SwapAndLiquify(
740         uint256 tokensSwapped,
741         uint256 ethReceived,
742         uint256 tokensIntoLiqudity
743     );
744     
745     modifier lockTheSwap {
746         inSwapAndLiquify = true;
747         _;
748         inSwapAndLiquify = false;
749     }
750     
751     constructor (address marketingWallet) public {
752         _rOwned[_msgSender()] = _rTotal;
753         
754         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
755          // Create a uniswap pair for this new token
756         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
757             .createPair(address(this), _uniswapV2Router.WETH());
758 
759         // set the rest of the contract variables
760         uniswapV2Router = _uniswapV2Router;
761         _marketingWallet = payable(marketingWallet);
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
829     function deliver(uint256 tAmount) public {
830         address sender = _msgSender();
831         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
832         (uint256 rAmount,,,,,) = _getValues(tAmount);
833         _rOwned[sender] = _rOwned[sender].sub(rAmount);
834         _rTotal = _rTotal.sub(rAmount);
835         _tFeeTotal = _tFeeTotal.add(tAmount);
836     }
837 
838     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
839         require(tAmount <= _tTotal, "Amount must be less than supply");
840         if (!deductTransferFee) {
841             (uint256 rAmount,,,,,) = _getValues(tAmount);
842             return rAmount;
843         } else {
844             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
845             return rTransferAmount;
846         }
847     }
848 
849     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
850         require(rAmount <= _rTotal, "Amount must be less than total reflections");
851         uint256 currentRate =  _getRate();
852         return rAmount.div(currentRate);
853     }
854 
855     function excludeFromReward(address account) public onlyOwner() {
856         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
857         require(!_isExcluded[account], "Account is already excluded");
858         if(_rOwned[account] > 0) {
859             _tOwned[account] = tokenFromReflection(_rOwned[account]);
860         }
861         _isExcluded[account] = true;
862         _excluded.push(account);
863     }
864 
865     function includeInReward(address account) external onlyOwner() {
866         require(_isExcluded[account], "Account is already excluded");
867         for (uint256 i = 0; i < _excluded.length; i++) {
868             if (_excluded[i] == account) {
869                 _excluded[i] = _excluded[_excluded.length - 1];
870                 _tOwned[account] = 0;
871                 _isExcluded[account] = false;
872                 _excluded.pop();
873                 break;
874             }
875         }
876     }
877         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
878         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
879         _tOwned[sender] = _tOwned[sender].sub(tAmount);
880         _rOwned[sender] = _rOwned[sender].sub(rAmount);
881         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
882         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
883         _takeLiquidity(tLiquidity);
884         _reflectFee(rFee, tFee);
885         emit Transfer(sender, recipient, tTransferAmount);
886     }
887     
888         function excludeFromFee(address account) public onlyOwner {
889         _isExcludedFromFee[account] = true;
890     }
891     
892     function includeInFee(address account) public onlyOwner {
893         _isExcludedFromFee[account] = false;
894     }
895     
896     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
897         _taxFee = taxFee;
898     }
899     
900     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
901         _liquidityFee = liquidityFee;
902     }
903 
904     function setMarketingFeePercent(uint256 marketingFee) external onlyOwner() {
905         _marketingFee = marketingFee;
906     }    
907    
908     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
909         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
910             10**2
911         );
912     }
913 
914     function setMarketingWallet(address payable newWallet) external onlyOwner {
915         require(_marketingWallet != newWallet, "Wallet already set!");
916         _marketingWallet = payable(newWallet);
917     }
918 
919     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
920         swapAndLiquifyEnabled = _enabled;
921         emit SwapAndLiquifyEnabledUpdated(_enabled);
922     }
923     
924      //to recieve ETH from uniswapV2Router when swaping
925     receive() external payable {}
926 
927     function _reflectFee(uint256 rFee, uint256 tFee) private {
928         _rTotal = _rTotal.sub(rFee);
929         _tFeeTotal = _tFeeTotal.add(tFee);
930     }
931 
932     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
933         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
934         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
935         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
936     }
937 
938     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
939         uint256 tFee = calculateTaxFee(tAmount);
940         uint256 tLiquidity = calculateLiquidityFee(tAmount);
941         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
942         return (tTransferAmount, tFee, tLiquidity);
943     }
944 
945     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
946         uint256 rAmount = tAmount.mul(currentRate);
947         uint256 rFee = tFee.mul(currentRate);
948         uint256 rLiquidity = tLiquidity.mul(currentRate);
949         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
950         return (rAmount, rTransferAmount, rFee);
951     }
952 
953     function _getRate() private view returns(uint256) {
954         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
955         return rSupply.div(tSupply);
956     }
957 
958     function _getCurrentSupply() private view returns(uint256, uint256) {
959         uint256 rSupply = _rTotal;
960         uint256 tSupply = _tTotal;      
961         for (uint256 i = 0; i < _excluded.length; i++) {
962             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
963             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
964             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
965         }
966         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
967         return (rSupply, tSupply);
968     }
969     
970     function _takeLiquidity(uint256 tLiquidity) private {
971         uint256 currentRate =  _getRate();
972         uint256 rLiquidity = tLiquidity.mul(currentRate);
973         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
974         if(_isExcluded[address(this)])
975             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
976     }
977     
978     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
979         return _amount.mul(_taxFee).div(
980             10**2
981         );
982     }
983 
984     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
985         return _amount.mul(_liquidityFee.add(_marketingFee)).div(
986             10**2
987         );
988     }
989     
990     function removeAllFee() private {
991         if(_taxFee == 0 && _liquidityFee == 0 && _marketingFee == 0) return;
992         
993         _previousTaxFee = _taxFee;
994         _previousLiquidityFee = _liquidityFee;
995         _previousMarketingFee = _marketingFee;
996         
997         _taxFee = 0;
998         _liquidityFee = 0;
999         _marketingFee = 0;
1000     }
1001     
1002     function restoreAllFee() private {
1003         _taxFee = _previousTaxFee;
1004         _liquidityFee = _previousLiquidityFee;
1005         _marketingFee = _previousMarketingFee;
1006     }
1007     
1008     function isExcludedFromFee(address account) public view returns(bool) {
1009         return _isExcludedFromFee[account];
1010     }
1011 
1012     function _approve(address owner, address spender, uint256 amount) private {
1013         require(owner != address(0), "ERC20: approve from the zero address");
1014         require(spender != address(0), "ERC20: approve to the zero address");
1015 
1016         _allowances[owner][spender] = amount;
1017         emit Approval(owner, spender, amount);
1018     }
1019 
1020     function _transfer(
1021         address from,
1022         address to,
1023         uint256 amount
1024     ) private {
1025         require(from != address(0), "ERC20: transfer from the zero address");
1026         require(to != address(0), "ERC20: transfer to the zero address");
1027         require(amount > 0, "Transfer amount must be greater than zero");
1028         if(from != owner() && to != owner())
1029             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1030 
1031         // is the token balance of this contract address over the min number of
1032         // tokens that we need to initiate a swap + liquidity lock?
1033         // also, don't get caught in a circular liquidity event.
1034         // also, don't swap & liquify if sender is uniswap pair.
1035         uint256 contractTokenBalance = balanceOf(address(this));
1036         
1037         if(contractTokenBalance >= _maxTxAmount)
1038         {
1039             contractTokenBalance = _maxTxAmount;
1040         }
1041         
1042         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1043         if (
1044             overMinTokenBalance &&
1045             !inSwapAndLiquify &&
1046             from != uniswapV2Pair &&
1047             swapAndLiquifyEnabled
1048         ) {
1049             contractTokenBalance = numTokensSellToAddToLiquidity;
1050             //add liquidity
1051             swapAndLiquify(contractTokenBalance);
1052         }
1053         
1054         //indicates if fee should be deducted from transfer
1055         bool takeFee = true;
1056         
1057         //if any account belongs to _isExcludedFromFee account then remove the fee
1058         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1059             takeFee = false;
1060         }
1061         
1062         //transfer amount, it will take tax, burn, liquidity fee
1063         _tokenTransfer(from,to,amount,takeFee);
1064     }
1065 
1066     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1067         if (_marketingFee + _liquidityFee == 0)
1068             return;
1069         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
1070         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
1071 
1072         // split the contract balance into halves
1073         uint256 half = toLiquify.div(2);
1074         uint256 otherHalf = toLiquify.sub(half);
1075 
1076         // capture the contract's current ETH balance.
1077         // this is so that we can capture exactly the amount of ETH that the
1078         // swap creates, and not make the liquidity event include any ETH that
1079         // has been manually sent to the contract
1080         uint256 initialBalance = address(this).balance;
1081 
1082         // swap tokens for ETH
1083         uint256 toSwapForEth = half.add(toMarketing);
1084         swapTokensForEth(toSwapForEth);
1085 
1086         // how much ETH did we just swap into?
1087         uint256 fromSwap = address(this).balance.sub(initialBalance);
1088         uint256 liquidityBalance = fromSwap.mul(half).div(toSwapForEth);
1089 
1090         addLiquidity(otherHalf, liquidityBalance);
1091 
1092         emit SwapAndLiquify(half, liquidityBalance, otherHalf);
1093 
1094         _marketingWallet.transfer(fromSwap.sub(liquidityBalance));
1095     }
1096 
1097     function swapTokensForEth(uint256 tokenAmount) private {
1098         // generate the uniswap pair path of token -> weth
1099         address[] memory path = new address[](2);
1100         path[0] = address(this);
1101         path[1] = uniswapV2Router.WETH();
1102 
1103         _approve(address(this), address(uniswapV2Router), tokenAmount);
1104 
1105         // make the swap
1106         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1107             tokenAmount,
1108             0, // accept any amount of ETH
1109             path,
1110             address(this),
1111             block.timestamp
1112         );
1113     }
1114 
1115     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1116         // approve token transfer to cover all possible scenarios
1117         _approve(address(this), address(uniswapV2Router), tokenAmount);
1118 
1119         // add the liquidity
1120         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1121             address(this),
1122             tokenAmount,
1123             0, // slippage is unavoidable
1124             0, // slippage is unavoidable
1125             burnAddress,
1126             block.timestamp
1127         );
1128     }
1129 
1130     //this method is responsible for taking all fee, if takeFee is true
1131     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1132         if(!takeFee)
1133             removeAllFee();
1134         
1135         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1136             _transferFromExcluded(sender, recipient, amount);
1137         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1138             _transferToExcluded(sender, recipient, amount);
1139         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1140             _transferStandard(sender, recipient, amount);
1141         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1142             _transferBothExcluded(sender, recipient, amount);
1143         } else {
1144             _transferStandard(sender, recipient, amount);
1145         }
1146         
1147         if(!takeFee)
1148             restoreAllFee();
1149     }
1150 
1151     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1152         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1153         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1154         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1155         _takeLiquidity(tLiquidity);
1156         _reflectFee(rFee, tFee);
1157         emit Transfer(sender, recipient, tTransferAmount);
1158     }
1159 
1160     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1161         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1164         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1165         _takeLiquidity(tLiquidity);
1166         _reflectFee(rFee, tFee);
1167         emit Transfer(sender, recipient, tTransferAmount);
1168     }
1169 
1170     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1171         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1172         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1173         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1174         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1175         _takeLiquidity(tLiquidity);
1176         _reflectFee(rFee, tFee);
1177         emit Transfer(sender, recipient, tTransferAmount);
1178     }
1179 
1180 
1181     
1182 
1183 }