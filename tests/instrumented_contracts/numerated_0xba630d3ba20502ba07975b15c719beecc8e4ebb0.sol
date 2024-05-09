1 //SPDX-License-Identifier: GPL-3.0-or-later
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
15 interface IERC20 {
16     /**
17     * @dev Returns the amount of tokens in existence.
18     */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22     * @dev Returns the amount of tokens owned by `account`.
23     */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27     * @dev Moves `amount` tokens from the caller's account to `recipient`.
28     *
29     * Returns a boolean value indicating whether the operation succeeded.
30     *
31     * Emits a {Transfer} event.
32     */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36     * @dev Returns the remaining number of tokens that `spender` will be
37     * allowed to spend on behalf of `owner` through {transferFrom}. This is
38     * zero by default.
39     *
40     * This value changes when {approve} or {transferFrom} are called.
41     */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46     *
47     * Returns a boolean value indicating whether the operation succeeded.
48     *
49     * IMPORTANT: Beware that changing an allowance with this method brings the risk
50     * that someone may use both the old and the new allowance by unfortunate
51     * transaction ordering. One possible solution to mitigate this race
52     * condition is to first reduce the spender's allowance to 0 and set the
53     * desired value afterwards:
54     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55     *
56     * Emits an {Approval} event.
57     */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61     * @dev Moves `amount` tokens from `sender` to `recipient` using the
62     * allowance mechanism. `amount` is then deducted from the caller's
63     * allowance.
64     *
65     * Returns a boolean value indicating whether the operation succeeded.
66     *
67     * Emits a {Transfer} event.
68     */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72     * @dev Emitted when `value` tokens are moved from one account (`from`) to
73     * another (`to`).
74     *
75     * Note that `value` may be zero.
76     */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81     * a call to {approve}. `value` is the new allowance.
82     */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 library SafeMath {
87     /**
88     * @dev Returns the addition of two unsigned integers, reverting on
89     * overflow.
90     *
91     * Counterpart to Solidity's `+` operator.
92     *
93     * Requirements:
94     *
95     * - Addition cannot overflow.
96     */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100 
101         return c;
102     }
103 
104     /**
105     * @dev Returns the subtraction of two unsigned integers, reverting on
106     * overflow (when the result is negative).
107     *
108     * Counterpart to Solidity's `-` operator.
109     *
110     * Requirements:
111     *
112     * - Subtraction cannot overflow.
113     */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120     * overflow (when the result is negative).
121     *
122     * Counterpart to Solidity's `-` operator.
123     *
124     * Requirements:
125     *
126     * - Subtraction cannot overflow.
127     */
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136     * @dev Returns the multiplication of two unsigned integers, reverting on
137     * overflow.
138     *
139     * Counterpart to Solidity's `*` operator.
140     *
141     * Requirements:
142     *
143     * - Multiplication cannot overflow.
144     */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160     * @dev Returns the integer division of two unsigned integers. Reverts on
161     * division by zero. The result is rounded towards zero.
162     *
163     * Counterpart to Solidity's `/` operator. Note: this function uses a
164     * `revert` opcode (which leaves remaining gas untouched) while Solidity
165     * uses an invalid opcode to revert (consuming all remaining gas).
166     *
167     * Requirements:
168     *
169     * - The divisor cannot be zero.
170     */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177     * division by zero. The result is rounded towards zero.
178     *
179     * Counterpart to Solidity's `/` operator. Note: this function uses a
180     * `revert` opcode (which leaves remaining gas untouched) while Solidity
181     * uses an invalid opcode to revert (consuming all remaining gas).
182     *
183     * Requirements:
184     *
185     * - The divisor cannot be zero.
186     */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b > 0, errorMessage);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197     * Reverts when dividing by zero.
198     *
199     * Counterpart to Solidity's `%` operator. This function uses a `revert`
200     * opcode (which leaves remaining gas untouched) while Solidity uses an
201     * invalid opcode to revert (consuming all remaining gas).
202     *
203     * Requirements:
204     *
205     * - The divisor cannot be zero.
206     */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213     * Reverts with custom message when dividing by zero.
214     *
215     * Counterpart to Solidity's `%` operator. This function uses a `revert`
216     * opcode (which leaves remaining gas untouched) while Solidity uses an
217     * invalid opcode to revert (consuming all remaining gas).
218     *
219     * Requirements:
220     *
221     * - The divisor cannot be zero.
222     */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b != 0, errorMessage);
225         return a % b;
226     }
227 }
228 
229 library Address {
230     /**
231     * @dev Returns true if `account` is a contract.
232     *
233     * [IMPORTANT]
234     * ====
235     * It is unsafe to assume that an address for which this function returns
236     * false is an externally-owned account (EOA) and not a contract.
237     *
238     * Among others, `isContract` will return false for the following
239     * types of addresses:
240     *
241     *  - an externally-owned account
242     *  - a contract in construction
243     *  - an address where a contract will be created
244     *  - an address where a contract lived, but was destroyed
245     * ====
246     */
247     function isContract(address account) internal view returns (bool) {
248         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
249         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
250         // for accounts without code, i.e. `keccak256('')`
251         bytes32 codehash;
252         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
253         // solhint-disable-next-line no-inline-assembly
254         assembly { codehash := extcodehash(account) }
255         return (codehash != accountHash && codehash != 0x0);
256     }
257 
258     /**
259     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260     * `recipient`, forwarding all available gas and reverting on errors.
261     *
262     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263     * of certain opcodes, possibly making contracts go over the 2300 gas limit
264     * imposed by `transfer`, making them unable to receive funds via
265     * `transfer`. {sendValue} removes this limitation.
266     *
267     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268     *
269     * IMPORTANT: because control is transferred to `recipient`, care must be
270     * taken to not create reentrancy vulnerabilities. Consider using
271     * {ReentrancyGuard} or the
272     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273     */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276 
277         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
278         (bool success, ) = recipient.call{ value: amount }("");
279         require(success, "Address: unable to send value, recipient may have reverted");
280     }
281 
282     /**
283     * @dev Performs a Solidity function call using a low level `call`. A
284     * plain`call` is an unsafe replacement for a function call: use this
285     * function instead.
286     *
287     * If `target` reverts with a revert reason, it is bubbled up by this
288     * function (like regular Solidity function calls).
289     *
290     * Returns the raw returned data. To convert to the expected return value,
291     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
292     *
293     * Requirements:
294     *
295     * - `target` must be a contract.
296     * - calling `target` with `data` must not revert.
297     *
298     * _Available since v3.1._
299     */
300     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionCall(target, data, "Address: low-level call failed");
302     }
303 
304     /**
305     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
306     * `errorMessage` as a fallback revert reason when `target` reverts.
307     *
308     * _Available since v3.1._
309     */
310     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311         return _functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316     * but also transferring `value` wei to `target`.
317     *
318     * Requirements:
319     *
320     * - the calling contract must have an ETH balance of at least `value`.
321     * - the called Solidity function must be `payable`.
322     *
323     * _Available since v3.1._
324     */
325     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331     * with `errorMessage` as a fallback revert reason when `target` reverts.
332     *
333     * _Available since v3.1._
334     */
335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         return _functionCallWithValue(target, data, value, errorMessage);
338     }
339 
340     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
341         require(isContract(target), "Address: call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 // solhint-disable-next-line no-inline-assembly
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 contract Ownable is Context {
365     address private _owner;
366     address private _previousOwner;
367     uint256 private _lockTime;
368 
369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371     /**
372     * @dev Initializes the contract setting the deployer as the initial owner.
373     */
374     constructor () internal {
375         address msgSender = _msgSender();
376         _owner = msgSender;
377         emit OwnershipTransferred(address(0), msgSender);
378     }
379 
380     /**
381     * @dev Returns the address of the current owner.
382     */
383     function owner() public view returns (address) {
384         return _owner;
385     }
386 
387     /**
388     * @dev Throws if called by any account other than the owner.
389     */
390     modifier onlyOwner() {
391         require(_owner == _msgSender(), "Ownable: caller is not the owner");
392         _;
393     }
394 
395     /**
396     * @dev Leaves the contract without owner. It will not be possible to call
397     * `onlyOwner` functions anymore. Can only be called by the current owner.
398     *
399     * NOTE: Renouncing ownership will leave the contract without an owner,
400     * thereby removing any functionality that is only available to the owner.
401     */
402     function renounceOwnership() public virtual onlyOwner {
403         emit OwnershipTransferred(_owner, address(0));
404         _owner = address(0);
405     }
406 
407     /**
408     * @dev Transfers ownership of the contract to a new account (`newOwner`).
409     * Can only be called by the current owner.
410     */
411     function transferOwnership(address newOwner) public virtual onlyOwner {
412         require(newOwner != address(0), "Ownable: new owner is the zero address");
413         emit OwnershipTransferred(_owner, newOwner);
414         _owner = newOwner;
415     }
416     
417 }
418 
419 interface IUniswapV2Factory {
420     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
421 
422     function feeTo() external view returns (address);
423     function feeToSetter() external view returns (address);
424 
425     function getPair(address tokenA, address tokenB) external view returns (address pair);
426     function allPairs(uint) external view returns (address pair);
427     function allPairsLength() external view returns (uint);
428 
429     function createPair(address tokenA, address tokenB) external returns (address pair);
430 
431     function setFeeTo(address) external;
432     function setFeeToSetter(address) external;
433 }
434 
435 interface IUniswapV2Pair {
436     event Approval(address indexed owner, address indexed spender, uint value);
437     event Transfer(address indexed from, address indexed to, uint value);
438 
439     function name() external pure returns (string memory);
440     function symbol() external pure returns (string memory);
441     function decimals() external pure returns (uint8);
442     function totalSupply() external view returns (uint);
443     function balanceOf(address owner) external view returns (uint);
444     function allowance(address owner, address spender) external view returns (uint);
445 
446     function approve(address spender, uint value) external returns (bool);
447     function transfer(address to, uint value) external returns (bool);
448     function transferFrom(address from, address to, uint value) external returns (bool);
449 
450     function DOMAIN_SEPARATOR() external view returns (bytes32);
451     function PERMIT_TYPEHASH() external pure returns (bytes32);
452     function nonces(address owner) external view returns (uint);
453 
454     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
455 
456     event Mint(address indexed sender, uint amount0, uint amount1);
457     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
458     event Swap(
459         address indexed sender,
460         uint amount0In,
461         uint amount1In,
462         uint amount0Out,
463         uint amount1Out,
464         address indexed to
465     );
466     event Sync(uint112 reserve0, uint112 reserve1);
467 
468     function MINIMUM_LIQUIDITY() external pure returns (uint);
469     function factory() external view returns (address);
470     function token0() external view returns (address);
471     function token1() external view returns (address);
472     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
473     function price0CumulativeLast() external view returns (uint);
474     function price1CumulativeLast() external view returns (uint);
475     function kLast() external view returns (uint);
476 
477     function mint(address to) external returns (uint liquidity);
478     function burn(address to) external returns (uint amount0, uint amount1);
479     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
480     function skim(address to) external;
481     function sync() external;
482 
483     function initialize(address, address) external;
484 }
485 
486 interface IUniswapV2Router01 {
487     function factory() external pure returns (address);
488     function WETH() external pure returns (address);
489 
490     function addLiquidity(
491         address tokenA,
492         address tokenB,
493         uint amountADesired,
494         uint amountBDesired,
495         uint amountAMin,
496         uint amountBMin,
497         address to,
498         uint deadline
499     ) external returns (uint amountA, uint amountB, uint liquidity);
500     function addLiquidityETH(
501         address token,
502         uint amountTokenDesired,
503         uint amountTokenMin,
504         uint amountETHMin,
505         address to,
506         uint deadline
507     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
508     function removeLiquidity(
509         address tokenA,
510         address tokenB,
511         uint liquidity,
512         uint amountAMin,
513         uint amountBMin,
514         address to,
515         uint deadline
516     ) external returns (uint amountA, uint amountB);
517     function removeLiquidityETH(
518         address token,
519         uint liquidity,
520         uint amountTokenMin,
521         uint amountETHMin,
522         address to,
523         uint deadline
524     ) external returns (uint amountToken, uint amountETH);
525     function removeLiquidityWithPermit(
526         address tokenA,
527         address tokenB,
528         uint liquidity,
529         uint amountAMin,
530         uint amountBMin,
531         address to,
532         uint deadline,
533         bool approveMax, uint8 v, bytes32 r, bytes32 s
534     ) external returns (uint amountA, uint amountB);
535     function removeLiquidityETHWithPermit(
536         address token,
537         uint liquidity,
538         uint amountTokenMin,
539         uint amountETHMin,
540         address to,
541         uint deadline,
542         bool approveMax, uint8 v, bytes32 r, bytes32 s
543     ) external returns (uint amountToken, uint amountETH);
544     function swapExactTokensForTokens(
545         uint amountIn,
546         uint amountOutMin,
547         address[] calldata path,
548         address to,
549         uint deadline
550     ) external returns (uint[] memory amounts);
551     function swapTokensForExactTokens(
552         uint amountOut,
553         uint amountInMax,
554         address[] calldata path,
555         address to,
556         uint deadline
557     ) external returns (uint[] memory amounts);
558     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
559     external
560     payable
561     returns (uint[] memory amounts);
562     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
563     external
564     returns (uint[] memory amounts);
565     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
566     external
567     returns (uint[] memory amounts);
568     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
569     external
570     payable
571     returns (uint[] memory amounts);
572 
573     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
574     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
575     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
576     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
577     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
578 }
579 
580 interface IUniswapV2Router02 is IUniswapV2Router01 {
581     function removeLiquidityETHSupportingFeeOnTransferTokens(
582         address token,
583         uint liquidity,
584         uint amountTokenMin,
585         uint amountETHMin,
586         address to,
587         uint deadline
588     ) external returns (uint amountETH);
589     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external returns (uint amountETH);
598 
599     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
600         uint amountIn,
601         uint amountOutMin,
602         address[] calldata path,
603         address to,
604         uint deadline
605     ) external;
606     function swapExactETHForTokensSupportingFeeOnTransferTokens(
607         uint amountOutMin,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external payable;
612     function swapExactTokensForETHSupportingFeeOnTransferTokens(
613         uint amountIn,
614         uint amountOutMin,
615         address[] calldata path,
616         address to,
617         uint deadline
618     ) external;
619 }
620 
621 // Contract implementation
622 contract EthereumPro is Context, IERC20, Ownable {
623     using SafeMath for uint256;
624     using Address for address;
625 
626     mapping (address => uint256) private _rOwned;
627     mapping (address => uint256) private _tOwned;
628     mapping (address => mapping (address => uint256)) private _allowances;
629 
630     mapping (address => bool) private _isExcludedFromFee;
631 
632     mapping (address => bool) private _isExcluded; // excluded from reward
633     address[] private _excluded;
634     mapping (address => bool) private _isBlackListedBot;
635     address[] private _blackListedBots;
636 
637     uint256 private constant MAX = ~uint256(0);
638 
639     uint256 private _tTotal = 100_000_000_000_000 * 10**9;
640     uint256 private _rTotal = (MAX - (MAX % _tTotal));
641     uint256 private _tFeeTotal;
642 
643     string private _name = 'Ethereum Pro';
644     string private _symbol = 'EPRO';
645     uint8 private _decimals = 9;
646 
647     uint256 private _taxFee = 4; // 4% reflection fee for every holder
648     uint256 private _marketingFee = 2; // 2% marketing
649     uint256 private _liquidityFee = 4; // 4% into liquidity
650 
651     uint256 private _previousTaxFee = _taxFee;
652     uint256 private _previousMarketingFee = _marketingFee;
653     uint256 private _previousLiquidityFee = _liquidityFee;
654 
655     address payable private _marketingWalletAddress = payable(0x0fe60E55a8C0700b47d4a2663079c445Fc4A5893);
656 
657     IUniswapV2Router02 public immutable uniswapV2Router;
658     address public immutable uniswapV2Pair;
659 
660     bool inSwapAndLiquify = false;
661     bool public swapAndLiquifyEnabled = true;
662 
663     uint256 private _maxTxAmount = _tTotal;
664     // We will set a minimum amount of tokens to be swapped
665     uint256 private _numTokensSellToAddToLiquidity = 1000000000 * 10**9;
666 
667     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
668     event SwapAndLiquifyEnabledUpdated(bool enabled);
669     event SwapAndLiquify(
670         uint256 tokensSwapped,
671         uint256 ethReceived,
672         uint256 tokensIntoLiqudity
673     );
674 
675     modifier lockTheSwap {
676         inSwapAndLiquify = true;
677         _;
678         inSwapAndLiquify = false;
679     }
680 
681     constructor () public {
682         _rOwned[_msgSender()] = _rTotal;
683 
684         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
685         // Create a uniswap pair for this new token
686         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
687         .createPair(address(this), _uniswapV2Router.WETH());
688 
689         // set the rest of the contract variables
690         uniswapV2Router = _uniswapV2Router;
691 
692         // Exclude owner and this contract from fee
693         _isExcludedFromFee[owner()] = true;
694         _isExcludedFromFee[address(this)] = true;
695         _isExcludedFromFee[_marketingWalletAddress] = true;
696 
697         // BLACKLIST
698         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
699         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
700 
701         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
702         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
703 
704         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
705         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
706 
707         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
708         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
709 
710         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
711         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
712 
713         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
714         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
715 
716         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
717         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
718 
719         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
720         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
721 
722         emit Transfer(address(0), _msgSender(), _tTotal);
723     }
724 
725     function name() public view returns (string memory) {
726         return _name;
727     }
728 
729     function symbol() public view returns (string memory) {
730         return _symbol;
731     }
732 
733     function decimals() public view returns (uint8) {
734         return _decimals;
735     }
736 
737     function totalSupply() public view override returns (uint256) {
738         return _tTotal;
739     }
740 
741     function balanceOf(address account) public view override returns (uint256) {
742         if (_isExcluded[account]) return _tOwned[account];
743         return tokenFromReflection(_rOwned[account]);
744     }
745 
746     function transfer(address recipient, uint256 amount) public override returns (bool) {
747         _transfer(_msgSender(), recipient, amount);
748         return true;
749     }
750 
751     function allowance(address owner, address spender) public view override returns (uint256) {
752         return _allowances[owner][spender];
753     }
754 
755     function approve(address spender, uint256 amount) public override returns (bool) {
756         _approve(_msgSender(), spender, amount);
757         return true;
758     }
759 
760     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
761         _transfer(sender, recipient, amount);
762         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
763         return true;
764     }
765 
766     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
767         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
768         return true;
769     }
770 
771     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
772         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
773         return true;
774     }
775 
776     function isExcludedFromReward(address account) public view returns (bool) {
777         return _isExcluded[account];
778     }
779 
780     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
781         _isExcludedFromFee[account] = excluded;
782     }
783 
784     function totalFees() public view returns (uint256) {
785         return _tFeeTotal;
786     }
787 
788     function deliver(uint256 tAmount) public {
789         address sender = _msgSender();
790         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
791         (uint256 rAmount,,,,,) = _getValues(tAmount);
792         _rOwned[sender] = _rOwned[sender].sub(rAmount);
793         _rTotal = _rTotal.sub(rAmount);
794         _tFeeTotal = _tFeeTotal.add(tAmount);
795     }
796 
797     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
798         require(tAmount <= _tTotal, "Amount must be less than supply");
799         if (!deductTransferFee) {
800             (uint256 rAmount,,,,,) = _getValues(tAmount);
801             return rAmount;
802         } else {
803             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
804             return rTransferAmount;
805         }
806     }
807 
808     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
809         require(rAmount <= _rTotal, "Amount must be less than total reflections");
810         uint256 currentRate =  _getRate();
811         return rAmount.div(currentRate);
812     }
813 
814     function excludeFromReward(address account) external onlyOwner() {
815         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
816         require(!_isExcluded[account], "Account is already excluded");
817         if(_rOwned[account] > 0) {
818             _tOwned[account] = tokenFromReflection(_rOwned[account]);
819         }
820         _isExcluded[account] = true;
821         _excluded.push(account);
822     }
823 
824     function includeInReward(address account) external onlyOwner() {
825         require(_isExcluded[account], "Account is already excluded");
826         for (uint256 i = 0; i < _excluded.length; i++) {
827             if (_excluded[i] == account) {
828                 _excluded[i] = _excluded[_excluded.length - 1];
829                 _tOwned[account] = 0;
830                 _isExcluded[account] = false;
831                 _excluded.pop();
832                 break;
833             }
834         }
835     }
836 
837     function addBotToBlackList(address account) external onlyOwner() {
838         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
839         require(!_isBlackListedBot[account], "Account is already blacklisted");
840         _isBlackListedBot[account] = true;
841         _blackListedBots.push(account);
842     }
843 
844     function removeBotFromBlackList(address account) external onlyOwner() {
845         require(_isBlackListedBot[account], "Account is not blacklisted");
846         for (uint256 i = 0; i < _blackListedBots.length; i++) {
847             if (_blackListedBots[i] == account) {
848                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
849                 _isBlackListedBot[account] = false;
850                 _blackListedBots.pop();
851                 break;
852             }
853         }
854     }
855 
856     function removeAllFee() private {
857         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
858 
859         _previousTaxFee = _taxFee;
860         _previousMarketingFee = _marketingFee;
861         _previousLiquidityFee = _liquidityFee;
862 
863         _taxFee = 0;
864         _marketingFee = 0;
865         _liquidityFee = 0;
866     }
867 
868     function restoreAllFee() private {
869         _taxFee = _previousTaxFee;
870         _marketingFee = _previousMarketingFee;
871         _liquidityFee = _previousLiquidityFee;
872     }
873 
874     function isExcludedFromFee(address account) public view returns(bool) {
875         return _isExcludedFromFee[account];
876     }
877 
878     function _approve(address owner, address spender, uint256 amount) private {
879         require(owner != address(0), "ERC20: approve from the zero address");
880         require(spender != address(0), "ERC20: approve to the zero address");
881 
882         _allowances[owner][spender] = amount;
883         emit Approval(owner, spender, amount);
884     }
885 
886     function _transfer(address sender, address recipient, uint256 amount) private {
887         require(sender != address(0), "ERC20: transfer from the zero address");
888         require(recipient != address(0), "ERC20: transfer to the zero address");
889         require(amount > 0, "Transfer amount must be greater than zero");
890         require(!_isBlackListedBot[sender], "You have no power here!");
891         require(!_isBlackListedBot[recipient], "You have no power here!");
892         require(!_isBlackListedBot[tx.origin], "You have no power here!");
893 
894         if(sender != owner() && recipient != owner()) {
895             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
896             // sorry about that, but sniper bots nowadays are buying multiple times, hope I have something more robust to prevent them to nuke the launch :-(
897             require(balanceOf(recipient).add(amount) <= _maxTxAmount, "Already bought maxTxAmount, wait till check off");
898         }
899 
900         // is the token balance of this contract address over the min number of
901         // tokens that we need to initiate a swap + liquidity lock?
902         // also, don't get caught in a circular liquidity event.
903         // also, don't swap & liquify if sender is uniswap pair.
904         uint256 contractTokenBalance = balanceOf(address(this));
905 
906         if(contractTokenBalance >= _maxTxAmount)
907         {
908             contractTokenBalance = _maxTxAmount;
909         }
910 
911         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
912         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
913             contractTokenBalance = _numTokensSellToAddToLiquidity;
914             //add liquidity
915             swapAndLiquify(contractTokenBalance);
916         }
917 
918         //indicates if fee should be deducted from transfer
919         bool takeFee = true;
920 
921         //if any account belongs to _isExcludedFromFee account then remove the fee
922         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
923             takeFee = false;
924         }
925 
926         //transfer amount, it will take tax and charity fee
927         _tokenTransfer(sender, recipient, amount, takeFee);
928     }
929 
930     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
931         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
932         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
933 
934         // split the contract balance into halves
935         uint256 half = toLiquify.div(2);
936         uint256 otherHalf = toLiquify.sub(half);
937 
938         // capture the contract's current ETH balance.
939         // this is so that we can capture exactly the amount of ETH that the
940         // swap creates, and not make the liquidity event include any ETH that
941         // has been manually sent to the contract
942         uint256 initialBalance = address(this).balance;
943 
944         // swap tokens for ETH
945         uint256 toSwapForEth = half.add(toMarketing);
946         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
947 
948         // how much ETH did we just swap into?
949         uint256 fromSwap = address(this).balance.sub(initialBalance);
950         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
951 
952         // add liquidity to uniswap
953         addLiquidity(otherHalf, newBalance);
954 
955         emit SwapAndLiquify(half, newBalance, otherHalf);
956 
957         sendETHToMarketing(fromSwap.sub(newBalance));
958     }
959 
960     function swapTokensForEth(uint256 tokenAmount) private {
961         // generate the uniswap pair path of token -> weth
962         address[] memory path = new address[](2);
963         path[0] = address(this);
964         path[1] = uniswapV2Router.WETH();
965 
966         _approve(address(this), address(uniswapV2Router), tokenAmount);
967 
968         // make the swap
969         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
970             tokenAmount,
971             0, // accept any amount of ETH
972             path,
973             address(this),
974             block.timestamp
975         );
976     }
977 
978     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
979         // approve token transfer to cover all possible scenarios
980         _approve(address(this), address(uniswapV2Router), tokenAmount);
981 
982         // add the liquidity
983         uniswapV2Router.addLiquidityETH{value: ethAmount}(
984             address(this),
985             tokenAmount,
986             0, // slippage is unavoidable
987             0, // slippage is unavoidable
988             owner(),
989             block.timestamp
990         );
991     }
992 
993     function sendETHToMarketing(uint256 amount) private {
994         _marketingWalletAddress.transfer(amount);
995     }
996 
997     // We are exposing these functions to be able to manual swap and send
998     // in case the token is highly valued and 5M becomes too much
999     function manualSwap() external onlyOwner() {
1000         uint256 contractBalance = balanceOf(address(this));
1001         swapTokensForEth(contractBalance);
1002     }
1003 
1004     function manualSend() public onlyOwner() {
1005         uint256 contractETHBalance = address(this).balance;
1006         sendETHToMarketing(contractETHBalance);
1007     }
1008 
1009     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1010         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1011     }
1012 
1013     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1014         if(!takeFee)
1015             removeAllFee();
1016 
1017         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1018             _transferFromExcluded(sender, recipient, amount);
1019         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1020             _transferToExcluded(sender, recipient, amount);
1021         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1022             _transferStandard(sender, recipient, amount);
1023         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1024             _transferBothExcluded(sender, recipient, amount);
1025         } else {
1026             _transferStandard(sender, recipient, amount);
1027         }
1028 
1029         if(!takeFee)
1030             restoreAllFee();
1031     }
1032 
1033     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1034         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1035         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1036         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1037         _takeMarketingLiquidity(tMarketingLiquidity);
1038         _reflectFee(rFee, tFee);
1039         emit Transfer(sender, recipient, tTransferAmount);
1040     }
1041 
1042     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1043         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1044         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1045         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1046         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1047         _takeMarketingLiquidity(tMarketingLiquidity);
1048         _reflectFee(rFee, tFee);
1049         emit Transfer(sender, recipient, tTransferAmount);
1050     }
1051 
1052     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1053         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1054         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1055         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1056         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1057         _takeMarketingLiquidity(tMarketingLiquidity);
1058         _reflectFee(rFee, tFee);
1059         emit Transfer(sender, recipient, tTransferAmount);
1060     }
1061 
1062     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1063         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1064         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1065         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1066         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1067         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1068         _takeMarketingLiquidity(tMarketingLiquidity);
1069         _reflectFee(rFee, tFee);
1070         emit Transfer(sender, recipient, tTransferAmount);
1071     }
1072 
1073     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1074         uint256 currentRate = _getRate();
1075         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1076         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1077         if(_isExcluded[address(this)])
1078             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1079     }
1080 
1081     function _reflectFee(uint256 rFee, uint256 tFee) private {
1082         _rTotal = _rTotal.sub(rFee);
1083         _tFeeTotal = _tFeeTotal.add(tFee);
1084     }
1085 
1086     //to recieve ETH from uniswapV2Router when swapping
1087     receive() external payable {}
1088 
1089     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1090         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1091         uint256 currentRate = _getRate();
1092         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1093         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1094     }
1095 
1096     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1097         uint256 tFee = tAmount.mul(taxFee).div(100);
1098         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1099         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1100         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1101     }
1102 
1103     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1104         uint256 rAmount = tAmount.mul(currentRate);
1105         uint256 rFee = tFee.mul(currentRate);
1106         uint256 rTransferAmount = rAmount.sub(rFee);
1107         return (rAmount, rTransferAmount, rFee);
1108     }
1109 
1110     function _getRate() private view returns(uint256) {
1111         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1112         return rSupply.div(tSupply);
1113     }
1114 
1115     function _getCurrentSupply() private view returns(uint256, uint256) {
1116         uint256 rSupply = _rTotal;
1117         uint256 tSupply = _tTotal;
1118         for (uint256 i = 0; i < _excluded.length; i++) {
1119             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1120             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1121             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1122         }
1123         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1124         return (rSupply, tSupply);
1125     }
1126 
1127     function _getTaxFee() private view returns(uint256) {
1128         return _taxFee;
1129     }
1130 
1131     function _getMaxTxAmount() private view returns(uint256) {
1132         return _maxTxAmount;
1133     }
1134 
1135     function _getETHBalance() public view returns(uint256 balance) {
1136         return address(this).balance;
1137     }
1138 
1139     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1140         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1141         _taxFee = taxFee;
1142     }
1143 
1144     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1145         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1146         _marketingFee = marketingFee;
1147     }
1148 
1149     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1150         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1151         _liquidityFee = liquidityFee;
1152     }
1153 
1154     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1155         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1156         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1157     }
1158 
1159     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1160         require(maxTxAmount >= 10**9 , 'maxTxAmount should be greater than total 1e9');
1161         _maxTxAmount = maxTxAmount;
1162     }
1163 
1164     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1165         _approve(address(this), owner(), tokenAmount);
1166         _transfer(address(this), owner(), tokenAmount);
1167     }
1168 }