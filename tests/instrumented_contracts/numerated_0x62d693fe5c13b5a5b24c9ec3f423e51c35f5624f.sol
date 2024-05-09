1 pragma solidity ^0.6.12;
2 interface IERC20 {
3 
4     function totalSupply() external view returns (uint256);
5 
6     /**
7      * @dev Returns the amount of tokens owned by `account`.
8      */
9     function balanceOf(address account) external view returns (uint256);
10 
11     /**
12      * @dev Moves `amount` tokens from the caller's account to `recipient`.
13      *
14      * Returns a boolean value indicating whether the operation succeeded.
15      *
16      * Emits a {Transfer} event.
17      */
18     function transfer(address recipient, uint256 amount) external returns (bool);
19 
20     /**
21      * @dev Returns the remaining number of tokens that `spender` will be
22      * allowed to spend on behalf of `owner` through {transferFrom}. This is
23      * zero by default.
24      *
25      * This value changes when {approve} or {transferFrom} are called.
26      */
27     function allowance(address owner, address spender) external view returns (uint256);
28 
29     /**
30      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * IMPORTANT: Beware that changing an allowance with this method brings the risk
35      * that someone may use both the old and the new allowance by unfortunate
36      * transaction ordering. One possible solution to mitigate this race
37      * condition is to first reduce the spender's allowance to 0 and set the
38      * desired value afterwards:
39      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
40      *
41      * Emits an {Approval} event.
42      */
43     function approve(address spender, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Moves `amount` tokens from `sender` to `recipient` using the
47      * allowance mechanism. `amount` is then deducted from the caller's
48      * allowance.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Emitted when `value` tokens are moved from one account (`from`) to
58      * another (`to`).
59      *
60      * Note that `value` may be zero.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 value);
63 
64     /**
65      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
66      * a call to {approve}. `value` is the new allowance.
67      */
68     event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 library SafeMath {
72     /**
73      * @dev Returns the addition of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `+` operator.
77      *
78      * Requirements:
79      *
80      * - Addition cannot overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         uint256 c = a + b;
84         require(c >= a, "SafeMath: addition overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the subtraction of two unsigned integers, reverting on
91      * overflow (when the result is negative).
92      *
93      * Counterpart to Solidity's `-` operator.
94      *
95      * Requirements:
96      *
97      * - Subtraction cannot overflow.
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         return sub(a, b, "SafeMath: subtraction overflow");
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         require(b <= a, errorMessage);
115         uint256 c = a - b;
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the multiplication of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `*` operator.
125      *
126      * Requirements:
127      *
128      * - Multiplication cannot overflow.
129      */
130     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
131         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
132         // benefit is lost if 'b' is also tested.
133         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
134         if (a == 0) {
135             return 0;
136         }
137 
138         uint256 c = a * b;
139         require(c / a == b, "SafeMath: multiplication overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the integer division of two unsigned integers. Reverts on
146      * division by zero. The result is rounded towards zero.
147      *
148      * Counterpart to Solidity's `/` operator. Note: this function uses a
149      * `revert` opcode (which leaves remaining gas untouched) while Solidity
150      * uses an invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         return div(a, b, "SafeMath: division by zero");
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b > 0, errorMessage);
174         uint256 c = a / b;
175         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
182      * Reverts when dividing by zero.
183      *
184      * Counterpart to Solidity's `%` operator. This function uses a `revert`
185      * opcode (which leaves remaining gas untouched) while Solidity uses an
186      * invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
193         return mod(a, b, "SafeMath: modulo by zero");
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts with custom message when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b != 0, errorMessage);
210         return a % b;
211     }
212 }
213 
214 abstract contract Context {
215     function _msgSender() internal view virtual returns (address payable) {
216         return msg.sender;
217     }
218 
219     function _msgData() internal view virtual returns (bytes memory) {
220         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
221         return msg.data;
222     }
223 }
224 
225 library Address {
226     /**
227      * @dev Returns true if `account` is a contract.
228      *
229      * [IMPORTANT]
230      * ====
231      * It is unsafe to assume that an address for which this function returns
232      * false is an externally-owned account (EOA) and not a contract.
233      *
234      * Among others, `isContract` will return false for the following
235      * types of addresses:
236      *
237      *  - an externally-owned account
238      *  - a contract in construction
239      *  - an address where a contract will be created
240      *  - an address where a contract lived, but was destroyed
241      * ====
242      */
243     function isContract(address account) internal view returns (bool) {
244         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
245         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
246         // for accounts without code, i.e. `keccak256('')`
247         bytes32 codehash;
248         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
249         // solhint-disable-next-line no-inline-assembly
250         assembly { codehash := extcodehash(account) }
251         return (codehash != accountHash && codehash != 0x0);
252     }
253 
254     /**
255      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
256      * `recipient`, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by `transfer`, making them unable to receive funds via
261      * `transfer`. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to `recipient`, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
274         (bool success, ) = recipient.call{ value: amount }("");
275         require(success, "Address: unable to send value, recipient may have reverted");
276     }
277 
278     /**
279      * @dev Performs a Solidity function call using a low level `call`. A
280      * plain`call` is an unsafe replacement for a function call: use this
281      * function instead.
282      *
283      * If `target` reverts with a revert reason, it is bubbled up by this
284      * function (like regular Solidity function calls).
285      *
286      * Returns the raw returned data. To convert to the expected return value,
287      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
288      *
289      * Requirements:
290      *
291      * - `target` must be a contract.
292      * - calling `target` with `data` must not revert.
293      *
294      * _Available since v3.1._
295      */
296     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
297         return functionCall(target, data, "Address: low-level call failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
302      * `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
307         return _functionCallWithValue(target, data, 0, errorMessage);
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
312      * but also transferring `value` wei to `target`.
313      *
314      * Requirements:
315      *
316      * - the calling contract must have an ETH balance of at least `value`.
317      * - the called Solidity function must be `payable`.
318      *
319      * _Available since v3.1._
320      */
321     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
327      * with `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
332         require(address(this).balance >= value, "Address: insufficient balance for call");
333         return _functionCallWithValue(target, data, value, errorMessage);
334     }
335 
336     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
337         require(isContract(target), "Address: call to non-contract");
338 
339         // solhint-disable-next-line avoid-low-level-calls
340         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly
347 
348                 // solhint-disable-next-line no-inline-assembly
349                 assembly {
350                     let returndata_size := mload(returndata)
351                     revert(add(32, returndata), returndata_size)
352                 }
353             } else {
354                 revert(errorMessage);
355             }
356         }
357     }
358 }
359 
360 contract Ownable is Context {
361     address private _owner;
362     address private _previousOwner;
363     uint256 private _lockTime;
364 
365     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
366 
367     /**
368      * @dev Initializes the contract setting the deployer as the initial owner.
369      */
370     constructor () internal {
371         address msgSender = _msgSender();
372         _owner = msgSender;
373         emit OwnershipTransferred(address(0), msgSender);
374     }
375 
376     /**
377      * @dev Returns the address of the current owner.
378      */
379     function owner() public view returns (address) {
380         return _owner;
381     }
382 
383     /**
384      * @dev Throws if called by any account other than the owner.
385      */
386     modifier onlyOwner() {
387         require(_owner == _msgSender(), "Ownable: caller is not the owner");
388         _;
389     }
390 
391     /**
392     * @dev Leaves the contract without owner. It will not be possible to call
393     * `onlyOwner` functions anymore. Can only be called by the current owner.
394     *
395     * NOTE: Renouncing ownership will leave the contract without an owner,
396     * thereby removing any functionality that is only available to the owner.
397     */
398     function renounceOwnership() public virtual onlyOwner {
399         emit OwnershipTransferred(_owner, address(0));
400         _owner = address(0);
401     }
402 
403     /**
404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
405      * Can only be called by the current owner.
406      */
407     function transferOwnership(address newOwner) public virtual onlyOwner {
408         require(newOwner != address(0), "Ownable: new owner is the zero address");
409         emit OwnershipTransferred(_owner, newOwner);
410         _owner = newOwner;
411     }
412 
413     function geUnlockTime() public view returns (uint256) {
414         return _lockTime;
415     }
416 
417     //Locks the contract for owner for the amount of time provided
418     function lock(uint256 time) public virtual onlyOwner {
419         _previousOwner = _owner;
420         _owner = address(0);
421         _lockTime = now + time;
422         emit OwnershipTransferred(_owner, address(0));
423     }
424 
425     //Unlocks the contract for owner when _lockTime is exceeds
426     function unlock() public virtual {
427         require(_previousOwner == msg.sender, "You don't have permission to unlock");
428         require(now > _lockTime , "Contract is locked until 7 days");
429         emit OwnershipTransferred(_owner, _previousOwner);
430         _owner = _previousOwner;
431     }
432 }
433 
434 interface IUniswapV2Factory {
435     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
436 
437     function feeTo() external view returns (address);
438     function feeToSetter() external view returns (address);
439 
440     function getPair(address tokenA, address tokenB) external view returns (address pair);
441     function allPairs(uint) external view returns (address pair);
442     function allPairsLength() external view returns (uint);
443 
444     function createPair(address tokenA, address tokenB) external returns (address pair);
445 
446     function setFeeTo(address) external;
447     function setFeeToSetter(address) external;
448 }
449 
450 interface IUniswapV2Pair {
451     event Approval(address indexed owner, address indexed spender, uint value);
452     event Transfer(address indexed from, address indexed to, uint value);
453 
454     function name() external pure returns (string memory);
455     function symbol() external pure returns (string memory);
456     function decimals() external pure returns (uint8);
457     function totalSupply() external view returns (uint);
458     function balanceOf(address owner) external view returns (uint);
459     function allowance(address owner, address spender) external view returns (uint);
460 
461     function approve(address spender, uint value) external returns (bool);
462     function transfer(address to, uint value) external returns (bool);
463     function transferFrom(address from, address to, uint value) external returns (bool);
464 
465     function DOMAIN_SEPARATOR() external view returns (bytes32);
466     function PERMIT_TYPEHASH() external pure returns (bytes32);
467     function nonces(address owner) external view returns (uint);
468 
469     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
470 
471     event Mint(address indexed sender, uint amount0, uint amount1);
472     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
473     event Swap(
474         address indexed sender,
475         uint amount0In,
476         uint amount1In,
477         uint amount0Out,
478         uint amount1Out,
479         address indexed to
480     );
481     event Sync(uint112 reserve0, uint112 reserve1);
482 
483     function MINIMUM_LIQUIDITY() external pure returns (uint);
484     function factory() external view returns (address);
485     function token0() external view returns (address);
486     function token1() external view returns (address);
487     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
488     function price0CumulativeLast() external view returns (uint);
489     function price1CumulativeLast() external view returns (uint);
490     function kLast() external view returns (uint);
491 
492     function mint(address to) external returns (uint liquidity);
493     function burn(address to) external returns (uint amount0, uint amount1);
494     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
495     function skim(address to) external;
496     function sync() external;
497 
498     function initialize(address, address) external;
499 }
500 
501 interface IUniswapV2Router01 {
502     function factory() external pure returns (address);
503     function WETH() external pure returns (address);
504 
505     function addLiquidity(
506         address tokenA,
507         address tokenB,
508         uint amountADesired,
509         uint amountBDesired,
510         uint amountAMin,
511         uint amountBMin,
512         address to,
513         uint deadline
514     ) external returns (uint amountA, uint amountB, uint liquidity);
515     function addLiquidityETH(
516         address token,
517         uint amountTokenDesired,
518         uint amountTokenMin,
519         uint amountETHMin,
520         address to,
521         uint deadline
522     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
523     function removeLiquidity(
524         address tokenA,
525         address tokenB,
526         uint liquidity,
527         uint amountAMin,
528         uint amountBMin,
529         address to,
530         uint deadline
531     ) external returns (uint amountA, uint amountB);
532     function removeLiquidityETH(
533         address token,
534         uint liquidity,
535         uint amountTokenMin,
536         uint amountETHMin,
537         address to,
538         uint deadline
539     ) external returns (uint amountToken, uint amountETH);
540     function removeLiquidityWithPermit(
541         address tokenA,
542         address tokenB,
543         uint liquidity,
544         uint amountAMin,
545         uint amountBMin,
546         address to,
547         uint deadline,
548         bool approveMax, uint8 v, bytes32 r, bytes32 s
549     ) external returns (uint amountA, uint amountB);
550     function removeLiquidityETHWithPermit(
551         address token,
552         uint liquidity,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline,
557         bool approveMax, uint8 v, bytes32 r, bytes32 s
558     ) external returns (uint amountToken, uint amountETH);
559     function swapExactTokensForTokens(
560         uint amountIn,
561         uint amountOutMin,
562         address[] calldata path,
563         address to,
564         uint deadline
565     ) external returns (uint[] memory amounts);
566     function swapTokensForExactTokens(
567         uint amountOut,
568         uint amountInMax,
569         address[] calldata path,
570         address to,
571         uint deadline
572     ) external returns (uint[] memory amounts);
573     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
574     external
575     payable
576     returns (uint[] memory amounts);
577     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
578     external
579     returns (uint[] memory amounts);
580     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
581     external
582     returns (uint[] memory amounts);
583     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
584     external
585     payable
586     returns (uint[] memory amounts);
587 
588     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
589     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
590     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
591     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
592     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
593 }
594 
595 interface IUniswapV2Router02 is IUniswapV2Router01 {
596     function removeLiquidityETHSupportingFeeOnTransferTokens(
597         address token,
598         uint liquidity,
599         uint amountTokenMin,
600         uint amountETHMin,
601         address to,
602         uint deadline
603     ) external returns (uint amountETH);
604     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
605         address token,
606         uint liquidity,
607         uint amountTokenMin,
608         uint amountETHMin,
609         address to,
610         uint deadline,
611         bool approveMax, uint8 v, bytes32 r, bytes32 s
612     ) external returns (uint amountETH);
613 
614     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
615         uint amountIn,
616         uint amountOutMin,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external;
621     function swapExactETHForTokensSupportingFeeOnTransferTokens(
622         uint amountOutMin,
623         address[] calldata path,
624         address to,
625         uint deadline
626     ) external payable;
627     function swapExactTokensForETHSupportingFeeOnTransferTokens(
628         uint amountIn,
629         uint amountOutMin,
630         address[] calldata path,
631         address to,
632         uint deadline
633     ) external;
634 }
635 
636 contract SafeBitcoin is Context, IERC20, Ownable {
637     using SafeMath for uint256;
638     using Address for address;
639 
640     mapping (address => uint256) private _rOwned;
641     mapping (address => uint256) private _tOwned;
642     mapping (address => mapping (address => uint256)) private _allowances;
643 
644     mapping (address => bool) private _isExcludedFromFee;
645 
646     mapping (address => bool) private _isExcluded;
647     address[] private _excluded;
648 
649     uint256 private constant MAX = ~uint256(0);
650     uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
651     uint256 private _rTotal = (MAX - (MAX % _tTotal));
652     uint256 private _tFeeTotal;
653 
654     string private _name = "SafeBitcoin";
655     string private _symbol = "SafeBTC";
656     uint8 private _decimals = 9;
657 
658     uint256 public _taxFee = 2;
659     uint256 private _previousTaxFee = _taxFee;
660 
661     uint256 public _liquidityFee = 2;
662     uint256 private _previousLiquidityFee = _liquidityFee;
663 
664     IUniswapV2Router02 public immutable uniswapV2Router;
665     address public immutable uniswapV2Pair;
666 
667     bool inSwapAndLiquify;
668     bool public swapAndLiquifyEnabled = true;
669     bool public tradingEnabled = false;
670 
671     uint256 public _maxTxAmount = 5000000 * 10**6 * 10**9;
672     uint256 private numTokensSellToAddToLiquidity = 500000 * 10**6 * 10**9;
673 
674     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
675     event SwapAndLiquifyEnabledUpdated(bool enabled);
676     event SwapAndLiquify(
677         uint256 tokensSwapped,
678         uint256 ethReceived,
679         uint256 tokensIntoLiqudity
680     );
681 
682     modifier lockTheSwap {
683         inSwapAndLiquify = true;
684         _;
685         inSwapAndLiquify = false;
686     }
687 
688     constructor () public {
689         _rOwned[0x426c91B3e87a5B1e95554dB8A688ccabBF04D541] = _rTotal;
690 
691         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
692         // Create a uniswap pair for this new token
693         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
694         .createPair(address(this), _uniswapV2Router.WETH());
695 
696         // set the rest of the contract variables
697         uniswapV2Router = _uniswapV2Router;
698 
699         //exclude owner and this contract from fee
700         _isExcludedFromFee[owner()] = true;
701         _isExcludedFromFee[address(this)] = true;
702         _isExcludedFromFee[0x426c91B3e87a5B1e95554dB8A688ccabBF04D541] = true;
703 
704         emit Transfer(address(0), 0x426c91B3e87a5B1e95554dB8A688ccabBF04D541, _tTotal);
705     }
706 
707     function name() public view returns (string memory) {
708         return _name;
709     }
710 
711     function symbol() public view returns (string memory) {
712         return _symbol;
713     }
714 
715     function decimals() public view returns (uint8) {
716         return _decimals;
717     }
718 
719     function totalSupply() public view override returns (uint256) {
720         return _tTotal;
721     }
722 
723     function balanceOf(address account) public view override returns (uint256) {
724         if (_isExcluded[account]) return _tOwned[account];
725         return tokenFromReflection(_rOwned[account]);
726     }
727 
728     function transfer(address recipient, uint256 amount) public override returns (bool) {
729         _transfer(_msgSender(), recipient, amount);
730         return true;
731     }
732 
733     function allowance(address owner, address spender) public view override returns (uint256) {
734         return _allowances[owner][spender];
735     }
736 
737     function approve(address spender, uint256 amount) public override returns (bool) {
738         _approve(_msgSender(), spender, amount);
739         return true;
740     }
741 
742     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
743         _transfer(sender, recipient, amount);
744         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
745         return true;
746     }
747 
748     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
749         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
750         return true;
751     }
752 
753     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
754         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
755         return true;
756     }
757 
758     function isExcludedFromReward(address account) public view returns (bool) {
759         return _isExcluded[account];
760     }
761 
762     function totalFees() public view returns (uint256) {
763         return _tFeeTotal;
764     }
765 
766     function deliver(uint256 tAmount) public {
767         address sender = _msgSender();
768         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
769         (uint256 rAmount,,,,,) = _getValues(tAmount);
770         _rOwned[sender] = _rOwned[sender].sub(rAmount);
771         _rTotal = _rTotal.sub(rAmount);
772         _tFeeTotal = _tFeeTotal.add(tAmount);
773     }
774 
775     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
776         require(tAmount <= _tTotal, "Amount must be less than supply");
777         if (!deductTransferFee) {
778             (uint256 rAmount,,,,,) = _getValues(tAmount);
779             return rAmount;
780         } else {
781             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
782             return rTransferAmount;
783         }
784     }
785 
786     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
787         require(rAmount <= _rTotal, "Amount must be less than total reflections");
788         uint256 currentRate =  _getRate();
789         return rAmount.div(currentRate);
790     }
791 
792     function excludeFromReward(address account) public onlyOwner() {
793         require(!_isExcluded[account], "Account is already excluded");
794         if(_rOwned[account] > 0) {
795             _tOwned[account] = tokenFromReflection(_rOwned[account]);
796         }
797         _isExcluded[account] = true;
798         _excluded.push(account);
799     }
800 
801     function includeInReward(address account) external onlyOwner() {
802         require(_isExcluded[account], "Account is already excluded");
803         for (uint256 i = 0; i < _excluded.length; i++) {
804             if (_excluded[i] == account) {
805                 _excluded[i] = _excluded[_excluded.length - 1];
806                 _tOwned[account] = 0;
807                 _isExcluded[account] = false;
808                 _excluded.pop();
809                 break;
810             }
811         }
812     }
813     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
814         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
815         _tOwned[sender] = _tOwned[sender].sub(tAmount);
816         _rOwned[sender] = _rOwned[sender].sub(rAmount);
817         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
818         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
819         _takeLiquidity(tLiquidity);
820         _reflectFee(rFee, tFee);
821         emit Transfer(sender, recipient, tTransferAmount);
822     }
823 
824     function excludeFromFee(address account) public onlyOwner {
825         _isExcludedFromFee[account] = true;
826     }
827 
828     function includeInFee(address account) public onlyOwner {
829         _isExcludedFromFee[account] = false;
830     }
831 
832     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
833         _taxFee = taxFee;
834     }
835 
836     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
837         _liquidityFee = liquidityFee;
838     }
839 
840     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
841         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
842             10**2
843         );
844     }
845 
846     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
847         swapAndLiquifyEnabled = _enabled;
848         emit SwapAndLiquifyEnabledUpdated(_enabled);
849     }
850 
851     function enableTrading() external onlyOwner() {
852         tradingEnabled = true;
853     }
854 
855     receive() external payable {}
856 
857     function _reflectFee(uint256 rFee, uint256 tFee) private {
858         _rTotal = _rTotal.sub(rFee);
859         _tFeeTotal = _tFeeTotal.add(tFee);
860     }
861 
862     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
863         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
864         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
865         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
866     }
867 
868     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
869         uint256 tFee = calculateTaxFee(tAmount);
870         uint256 tLiquidity = calculateLiquidityFee(tAmount);
871         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
872         return (tTransferAmount, tFee, tLiquidity);
873     }
874 
875     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
876         uint256 rAmount = tAmount.mul(currentRate);
877         uint256 rFee = tFee.mul(currentRate);
878         uint256 rLiquidity = tLiquidity.mul(currentRate);
879         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
880         return (rAmount, rTransferAmount, rFee);
881     }
882 
883     function _getRate() private view returns(uint256) {
884         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
885         return rSupply.div(tSupply);
886     }
887 
888     function _getCurrentSupply() private view returns(uint256, uint256) {
889         uint256 rSupply = _rTotal;
890         uint256 tSupply = _tTotal;
891         for (uint256 i = 0; i < _excluded.length; i++) {
892             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
893             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
894             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
895         }
896         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
897         return (rSupply, tSupply);
898     }
899 
900     function _takeLiquidity(uint256 tLiquidity) private {
901         uint256 currentRate =  _getRate();
902         uint256 rLiquidity = tLiquidity.mul(currentRate);
903         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
904         if(_isExcluded[address(this)])
905             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
906     }
907 
908     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
909         return _amount.mul(_taxFee).div(
910             10**2
911         );
912     }
913 
914     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
915         return _amount.mul(_liquidityFee).div(
916             10**2
917         );
918     }
919 
920     function removeAllFee() private {
921         if(_taxFee == 0 && _liquidityFee == 0) return;
922 
923         _previousTaxFee = _taxFee;
924         _previousLiquidityFee = _liquidityFee;
925 
926         _taxFee = 0;
927         _liquidityFee = 0;
928     }
929 
930     function restoreAllFee() private {
931         _taxFee = _previousTaxFee;
932         _liquidityFee = _previousLiquidityFee;
933     }
934 
935     function isExcludedFromFee(address account) public view returns(bool) {
936         return _isExcludedFromFee[account];
937     }
938 
939     function _approve(address owner, address spender, uint256 amount) private {
940         require(owner != address(0), "ERC20: approve from the zero address");
941         require(spender != address(0), "ERC20: approve to the zero address");
942 
943         _allowances[owner][spender] = amount;
944         emit Approval(owner, spender, amount);
945     }
946 
947     function _transfer(
948         address from,
949         address to,
950         uint256 amount
951     ) private {
952         require(from != address(0), "ERC20: transfer from the zero address");
953         require(to != address(0), "ERC20: transfer to the zero address");
954         require(amount > 0, "Transfer amount must be greater than zero");
955 
956         if(from != owner() && to != owner())
957             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
958 
959         if (from != owner() && !tradingEnabled) {
960             require(tradingEnabled, "Trading is not enabled yet");
961         }
962 
963         // is the token balance of this contract address over the min number of
964         // tokens that we need to initiate a swap + liquidity lock?
965         // also, don't get caught in a circular liquidity event.
966         // also, don't swap & liquify if sender is uniswap pair.
967         uint256 contractTokenBalance = balanceOf(address(this));
968 
969         if(contractTokenBalance >= _maxTxAmount)
970         {
971             contractTokenBalance = _maxTxAmount;
972         }
973 
974         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
975         if (
976             overMinTokenBalance &&
977             !inSwapAndLiquify &&
978             from != uniswapV2Pair &&
979             swapAndLiquifyEnabled
980         ) {
981             contractTokenBalance = numTokensSellToAddToLiquidity;
982             //add liquidity
983             swapAndLiquify(contractTokenBalance);
984         }
985 
986         //indicates if fee should be deducted from transfer
987         bool takeFee = true;
988 
989         //if any account belongs to _isExcludedFromFee account then remove the fee
990         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
991             takeFee = false;
992         }
993 
994         //transfer amount, it will take tax, burn, liquidity fee
995         _tokenTransfer(from,to,amount,takeFee);
996     }
997 
998     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
999         // split the contract balance into halves
1000         uint256 half = contractTokenBalance.div(2);
1001         uint256 otherHalf = contractTokenBalance.sub(half);
1002 
1003         // capture the contract's current ETH balance.
1004         // this is so that we can capture exactly the amount of ETH that the
1005         // swap creates, and not make the liquidity event include any ETH that
1006         // has been manually sent to the contract
1007         uint256 initialBalance = address(this).balance;
1008 
1009         // swap tokens for ETH
1010         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1011 
1012         // how much ETH did we just swap into?
1013         uint256 newBalance = address(this).balance.sub(initialBalance);
1014 
1015         // add liquidity to uniswap
1016         addLiquidity(otherHalf, newBalance);
1017 
1018         emit SwapAndLiquify(half, newBalance, otherHalf);
1019     }
1020 
1021     function swapTokensForEth(uint256 tokenAmount) private {
1022         // generate the uniswap pair path of token -> weth
1023         address[] memory path = new address[](2);
1024         path[0] = address(this);
1025         path[1] = uniswapV2Router.WETH();
1026 
1027         _approve(address(this), address(uniswapV2Router), tokenAmount);
1028 
1029         // make the swap
1030         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1031             tokenAmount,
1032             0, // accept any amount of ETH
1033             path,
1034             address(this),
1035             block.timestamp
1036         );
1037     }
1038 
1039     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1040         // approve token transfer to cover all possible scenarios
1041         _approve(address(this), address(uniswapV2Router), tokenAmount);
1042 
1043         // add the liquidity
1044         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1045             address(this),
1046             tokenAmount,
1047             0, // slippage is unavoidable
1048             0, // slippage is unavoidable
1049             owner(),
1050             block.timestamp
1051         );
1052     }
1053 
1054     //this method is responsible for taking all fee, if takeFee is true
1055     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1056         if(!takeFee)
1057             removeAllFee();
1058 
1059         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1060             _transferFromExcluded(sender, recipient, amount);
1061         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1062             _transferToExcluded(sender, recipient, amount);
1063         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1064             _transferStandard(sender, recipient, amount);
1065         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1066             _transferBothExcluded(sender, recipient, amount);
1067         } else {
1068             _transferStandard(sender, recipient, amount);
1069         }
1070 
1071         if(!takeFee)
1072             restoreAllFee();
1073     }
1074 
1075     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1076         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1077         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1078         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1079         _takeLiquidity(tLiquidity);
1080         _reflectFee(rFee, tFee);
1081         emit Transfer(sender, recipient, tTransferAmount);
1082     }
1083 
1084     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1085         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1086         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1087         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1088         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1089         _takeLiquidity(tLiquidity);
1090         _reflectFee(rFee, tFee);
1091         emit Transfer(sender, recipient, tTransferAmount);
1092     }
1093 
1094     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1095         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1096         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1097         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1098         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1099         _takeLiquidity(tLiquidity);
1100         _reflectFee(rFee, tFee);
1101         emit Transfer(sender, recipient, tTransferAmount);
1102     }
1103 
1104 
1105 
1106 
1107 }