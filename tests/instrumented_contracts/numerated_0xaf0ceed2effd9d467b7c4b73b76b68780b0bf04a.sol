1 //SPDX-License-Identifier: GPL-3.0-or-later
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
16 interface IERC20 {
17     /**
18     * @dev Returns the amount of tokens in existence.
19     */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23     * @dev Returns the amount of tokens owned by `account`.
24     */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28     * @dev Moves `amount` tokens from the caller's account to `recipient`.
29     *
30     * Returns a boolean value indicating whether the operation succeeded.
31     *
32     * Emits a {Transfer} event.
33     */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37     * @dev Returns the remaining number of tokens that `spender` will be
38     * allowed to spend on behalf of `owner` through {transferFrom}. This is
39     * zero by default.
40     *
41     * This value changes when {approve} or {transferFrom} are called.
42     */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47     *
48     * Returns a boolean value indicating whether the operation succeeded.
49     *
50     * IMPORTANT: Beware that changing an allowance with this method brings the risk
51     * that someone may use both the old and the new allowance by unfortunate
52     * transaction ordering. One possible solution to mitigate this race
53     * condition is to first reduce the spender's allowance to 0 and set the
54     * desired value afterwards:
55     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56     *
57     * Emits an {Approval} event.
58     */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62     * @dev Moves `amount` tokens from `sender` to `recipient` using the
63     * allowance mechanism. `amount` is then deducted from the caller's
64     * allowance.
65     *
66     * Returns a boolean value indicating whether the operation succeeded.
67     *
68     * Emits a {Transfer} event.
69     */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73     * @dev Emitted when `value` tokens are moved from one account (`from`) to
74     * another (`to`).
75     *
76     * Note that `value` may be zero.
77     */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82     * a call to {approve}. `value` is the new allowance.
83     */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 library SafeMath {
88     /**
89     * @dev Returns the addition of two unsigned integers, reverting on
90     * overflow.
91     *
92     * Counterpart to Solidity's `+` operator.
93     *
94     * Requirements:
95     *
96     * - Addition cannot overflow.
97     */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106     * @dev Returns the subtraction of two unsigned integers, reverting on
107     * overflow (when the result is negative).
108     *
109     * Counterpart to Solidity's `-` operator.
110     *
111     * Requirements:
112     *
113     * - Subtraction cannot overflow.
114     */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121     * overflow (when the result is negative).
122     *
123     * Counterpart to Solidity's `-` operator.
124     *
125     * Requirements:
126     *
127     * - Subtraction cannot overflow.
128     */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137     * @dev Returns the multiplication of two unsigned integers, reverting on
138     * overflow.
139     *
140     * Counterpart to Solidity's `*` operator.
141     *
142     * Requirements:
143     *
144     * - Multiplication cannot overflow.
145     */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161     * @dev Returns the integer division of two unsigned integers. Reverts on
162     * division by zero. The result is rounded towards zero.
163     *
164     * Counterpart to Solidity's `/` operator. Note: this function uses a
165     * `revert` opcode (which leaves remaining gas untouched) while Solidity
166     * uses an invalid opcode to revert (consuming all remaining gas).
167     *
168     * Requirements:
169     *
170     * - The divisor cannot be zero.
171     */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178     * division by zero. The result is rounded towards zero.
179     *
180     * Counterpart to Solidity's `/` operator. Note: this function uses a
181     * `revert` opcode (which leaves remaining gas untouched) while Solidity
182     * uses an invalid opcode to revert (consuming all remaining gas).
183     *
184     * Requirements:
185     *
186     * - The divisor cannot be zero.
187     */
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198     * Reverts when dividing by zero.
199     *
200     * Counterpart to Solidity's `%` operator. This function uses a `revert`
201     * opcode (which leaves remaining gas untouched) while Solidity uses an
202     * invalid opcode to revert (consuming all remaining gas).
203     *
204     * Requirements:
205     *
206     * - The divisor cannot be zero.
207     */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214     * Reverts with custom message when dividing by zero.
215     *
216     * Counterpart to Solidity's `%` operator. This function uses a `revert`
217     * opcode (which leaves remaining gas untouched) while Solidity uses an
218     * invalid opcode to revert (consuming all remaining gas).
219     *
220     * Requirements:
221     *
222     * - The divisor cannot be zero.
223     */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library Address {
231     /**
232     * @dev Returns true if `account` is a contract.
233     *
234     * [IMPORTANT]
235     * ====
236     * It is unsafe to assume that an address for which this function returns
237     * false is an externally-owned account (EOA) and not a contract.
238     *
239     * Among others, `isContract` will return false for the following
240     * types of addresses:
241     *
242     *  - an externally-owned account
243     *  - a contract in construction
244     *  - an address where a contract will be created
245     *  - an address where a contract lived, but was destroyed
246     * ====
247     */
248     function isContract(address account) internal view returns (bool) {
249         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
250         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
251         // for accounts without code, i.e. `keccak256('')`
252         bytes32 codehash;
253         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
254         // solhint-disable-next-line no-inline-assembly
255         assembly { codehash := extcodehash(account) }
256         return (codehash != accountHash && codehash != 0x0);
257     }
258 
259     /**
260     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261     * `recipient`, forwarding all available gas and reverting on errors.
262     *
263     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264     * of certain opcodes, possibly making contracts go over the 2300 gas limit
265     * imposed by `transfer`, making them unable to receive funds via
266     * `transfer`. {sendValue} removes this limitation.
267     *
268     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269     *
270     * IMPORTANT: because control is transferred to `recipient`, care must be
271     * taken to not create reentrancy vulnerabilities. Consider using
272     * {ReentrancyGuard} or the
273     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274     */
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(address(this).balance >= amount, "Address: insufficient balance");
277 
278         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
279         (bool success, ) = recipient.call{ value: amount }("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284     * @dev Performs a Solidity function call using a low level `call`. A
285     * plain`call` is an unsafe replacement for a function call: use this
286     * function instead.
287     *
288     * If `target` reverts with a revert reason, it is bubbled up by this
289     * function (like regular Solidity function calls).
290     *
291     * Returns the raw returned data. To convert to the expected return value,
292     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293     *
294     * Requirements:
295     *
296     * - `target` must be a contract.
297     * - calling `target` with `data` must not revert.
298     *
299     * _Available since v3.1._
300     */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307     * `errorMessage` as a fallback revert reason when `target` reverts.
308     *
309     * _Available since v3.1._
310     */
311     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
312         return _functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317     * but also transferring `value` wei to `target`.
318     *
319     * Requirements:
320     *
321     * - the calling contract must have an ETH balance of at least `value`.
322     * - the called Solidity function must be `payable`.
323     *
324     * _Available since v3.1._
325     */
326     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332     * with `errorMessage` as a fallback revert reason when `target` reverts.
333     *
334     * _Available since v3.1._
335     */
336     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
337         require(address(this).balance >= value, "Address: insufficient balance for call");
338         return _functionCallWithValue(target, data, value, errorMessage);
339     }
340 
341     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
342         require(isContract(target), "Address: call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 // solhint-disable-next-line no-inline-assembly
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 contract Ownable is Context {
366     
367     address private _owner;
368     address private _previousOwner;
369     uint256 private _lockTime;
370 
371     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
372 
373     /**
374     * @dev Initializes the contract setting the deployer as the initial owner.
375     */
376     constructor () internal {
377         address msgSender = _msgSender();
378         _owner = msgSender;
379         emit OwnershipTransferred(address(0), msgSender);
380     }
381 
382     /**
383     * @dev Returns the address of the current owner.
384     */
385     function owner() public view returns (address) {
386         return _owner;
387     }
388 
389     /**
390     * @dev Throws if called by any account other than the owner.
391     */
392     modifier onlyOwner() {
393         require(_owner == _msgSender(), "Ownable: caller is not the owner");
394         _;
395     }
396 
397     /**
398     * @dev Leaves the contract without owner. It will not be possible to call
399     * `onlyOwner` functions anymore. Can only be called by the current owner.
400     *
401     * NOTE: Renouncing ownership will leave the contract without an owner,
402     * thereby removing any functionality that is only available to the owner.
403     */
404     function renounceOwnership() public virtual onlyOwner {
405         emit OwnershipTransferred(_owner, address(0));
406         _owner = address(0);
407     }
408 
409     /**
410     * @dev Transfers ownership of the contract to a new account (`newOwner`).
411     * Can only be called by the current owner.
412     */
413     function transferOwnership(address newOwner) public virtual onlyOwner {
414         require(newOwner != address(0), "Ownable: new owner is the zero address");
415         emit OwnershipTransferred(_owner, newOwner);
416         _owner = newOwner;
417     }
418     
419 }
420 
421 interface IUniswapV2Factory {
422     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
423 
424     function feeTo() external view returns (address);
425     function feeToSetter() external view returns (address);
426 
427     function getPair(address tokenA, address tokenB) external view returns (address pair);
428     function allPairs(uint) external view returns (address pair);
429     function allPairsLength() external view returns (uint);
430 
431     function createPair(address tokenA, address tokenB) external returns (address pair);
432 
433     function setFeeTo(address) external;
434     function setFeeToSetter(address) external;
435 }
436 
437 interface IUniswapV2Pair {
438     event Approval(address indexed owner, address indexed spender, uint value);
439     event Transfer(address indexed from, address indexed to, uint value);
440 
441     function name() external pure returns (string memory);
442     function symbol() external pure returns (string memory);
443     function decimals() external pure returns (uint8);
444     function totalSupply() external view returns (uint);
445     function balanceOf(address owner) external view returns (uint);
446     function allowance(address owner, address spender) external view returns (uint);
447 
448     function approve(address spender, uint value) external returns (bool);
449     function transfer(address to, uint value) external returns (bool);
450     function transferFrom(address from, address to, uint value) external returns (bool);
451 
452     function DOMAIN_SEPARATOR() external view returns (bytes32);
453     function PERMIT_TYPEHASH() external pure returns (bytes32);
454     function nonces(address owner) external view returns (uint);
455 
456     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
457 
458     event Mint(address indexed sender, uint amount0, uint amount1);
459     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
460     event Swap(
461         address indexed sender,
462         uint amount0In,
463         uint amount1In,
464         uint amount0Out,
465         uint amount1Out,
466         address indexed to
467     );
468     event Sync(uint112 reserve0, uint112 reserve1);
469 
470     function MINIMUM_LIQUIDITY() external pure returns (uint);
471     function factory() external view returns (address);
472     function token0() external view returns (address);
473     function token1() external view returns (address);
474     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
475     function price0CumulativeLast() external view returns (uint);
476     function price1CumulativeLast() external view returns (uint);
477     function kLast() external view returns (uint);
478 
479     function mint(address to) external returns (uint liquidity);
480     function burn(address to) external returns (uint amount0, uint amount1);
481     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
482     function skim(address to) external;
483     function sync() external;
484 
485     function initialize(address, address) external;
486 }
487 
488 interface IUniswapV2Router01 {
489     function factory() external pure returns (address);
490     function WETH() external pure returns (address);
491 
492     function addLiquidity(
493         address tokenA,
494         address tokenB,
495         uint amountADesired,
496         uint amountBDesired,
497         uint amountAMin,
498         uint amountBMin,
499         address to,
500         uint deadline
501     ) external returns (uint amountA, uint amountB, uint liquidity);
502     function addLiquidityETH(
503         address token,
504         uint amountTokenDesired,
505         uint amountTokenMin,
506         uint amountETHMin,
507         address to,
508         uint deadline
509     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
510     function removeLiquidity(
511         address tokenA,
512         address tokenB,
513         uint liquidity,
514         uint amountAMin,
515         uint amountBMin,
516         address to,
517         uint deadline
518     ) external returns (uint amountA, uint amountB);
519     function removeLiquidityETH(
520         address token,
521         uint liquidity,
522         uint amountTokenMin,
523         uint amountETHMin,
524         address to,
525         uint deadline
526     ) external returns (uint amountToken, uint amountETH);
527     function removeLiquidityWithPermit(
528         address tokenA,
529         address tokenB,
530         uint liquidity,
531         uint amountAMin,
532         uint amountBMin,
533         address to,
534         uint deadline,
535         bool approveMax, uint8 v, bytes32 r, bytes32 s
536     ) external returns (uint amountA, uint amountB);
537     function removeLiquidityETHWithPermit(
538         address token,
539         uint liquidity,
540         uint amountTokenMin,
541         uint amountETHMin,
542         address to,
543         uint deadline,
544         bool approveMax, uint8 v, bytes32 r, bytes32 s
545     ) external returns (uint amountToken, uint amountETH);
546     function swapExactTokensForTokens(
547         uint amountIn,
548         uint amountOutMin,
549         address[] calldata path,
550         address to,
551         uint deadline
552     ) external returns (uint[] memory amounts);
553     function swapTokensForExactTokens(
554         uint amountOut,
555         uint amountInMax,
556         address[] calldata path,
557         address to,
558         uint deadline
559     ) external returns (uint[] memory amounts);
560     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
561     external
562     payable
563     returns (uint[] memory amounts);
564     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
565     external
566     returns (uint[] memory amounts);
567     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
568     external
569     returns (uint[] memory amounts);
570     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
571     external
572     payable
573     returns (uint[] memory amounts);
574 
575     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
576     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
577     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
578     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
579     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
580 }
581 
582 interface IUniswapV2Router02 is IUniswapV2Router01 {
583     function removeLiquidityETHSupportingFeeOnTransferTokens(
584         address token,
585         uint liquidity,
586         uint amountTokenMin,
587         uint amountETHMin,
588         address to,
589         uint deadline
590     ) external returns (uint amountETH);
591     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline,
598         bool approveMax, uint8 v, bytes32 r, bytes32 s
599     ) external returns (uint amountETH);
600 
601     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
602         uint amountIn,
603         uint amountOutMin,
604         address[] calldata path,
605         address to,
606         uint deadline
607     ) external;
608     function swapExactETHForTokensSupportingFeeOnTransferTokens(
609         uint amountOutMin,
610         address[] calldata path,
611         address to,
612         uint deadline
613     ) external payable;
614     function swapExactTokensForETHSupportingFeeOnTransferTokens(
615         uint amountIn,
616         uint amountOutMin,
617         address[] calldata path,
618         address to,
619         uint deadline
620     ) external;
621 }
622 
623 // Contract implementation
624 
625 contract RobotInu is Context, IERC20, Ownable {
626     using SafeMath for uint256;
627     using Address for address;
628 
629     mapping (address => uint256) private _rOwned;
630     mapping (address => uint256) private _tOwned;
631     mapping (address => mapping (address => uint256)) private _allowances;
632 
633     mapping (address => bool) private _isExcludedFromFee;
634 
635     mapping (address => bool) private _isExcluded; // excluded from reward
636     address[] private _excluded;
637     mapping (address => bool) private _isBlackListedBot;
638     address[] private _blackListedBots;
639 
640     uint256 private constant MAX = ~uint256(0);
641 
642     uint256 private _tTotal = 100_000_000_000_000 * 10**9;
643     uint256 private _rTotal = (MAX - (MAX % _tTotal));
644     uint256 private _tFeeTotal;
645 
646     string private _name = 'Robot Inu';
647     string private _symbol = 'RINU';
648     uint8 private _decimals = 9;
649 
650     uint256 private _taxFee = 2; // 4% reflection fee for every holder
651     uint256 private _marketingFee = 0; // 2% marketing
652     uint256 private _liquidityFee = 0; // 4% into liquidity
653 
654     uint256 private _previousTaxFee = _taxFee;
655     uint256 private _previousMarketingFee = _marketingFee;
656     uint256 private _previousLiquidityFee = _liquidityFee;
657 
658     address payable private _marketingWalletAddress = payable(0x24F21293D0DA887435f25EA039bA9c17F4dA6D14);
659 
660     IUniswapV2Router02 public immutable uniswapV2Router;
661     address public immutable uniswapV2Pair;
662 
663     bool inSwapAndLiquify = false;
664     bool public swapAndLiquifyEnabled = true;
665 
666     uint256 private _maxTxAmount = _tTotal / 1000;
667     // We will set a minimum amount of tokens to be swapped
668     uint256 private _numTokensSellToAddToLiquidity = 1000000000 * 10**9;
669 
670     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
671     event SwapAndLiquifyEnabledUpdated(bool enabled);
672     event SwapAndLiquify(
673         uint256 tokensSwapped,
674         uint256 ethReceived,
675         uint256 tokensIntoLiqudity
676     );
677 
678     modifier lockTheSwap {
679         inSwapAndLiquify = true;
680         _;
681         inSwapAndLiquify = false;
682     }
683 
684     constructor () public {
685         _rOwned[_msgSender()] = _rTotal;
686 
687         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
688         // Create a uniswap pair for this new token
689         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
690         .createPair(address(this), _uniswapV2Router.WETH());
691 
692         // set the rest of the contract variables
693         uniswapV2Router = _uniswapV2Router;
694 
695         // Exclude owner and this contract from fee
696         _isExcludedFromFee[owner()] = true;
697         _isExcludedFromFee[address(this)] = true;
698         _isExcludedFromFee[_marketingWalletAddress] = true;
699 
700         // BLACKLIST
701         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
702         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
703 
704         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
705         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
706 
707         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
708         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
709 
710         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
711         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
712 
713         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
714         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
715 
716         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
717         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
718 
719         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
720         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
721 
722         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
723         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
724 
725         emit Transfer(address(0), _msgSender(), _tTotal);
726     }
727 
728     function name() public view returns (string memory) {
729         return _name;
730     }
731 
732     function symbol() public view returns (string memory) {
733         return _symbol;
734     }
735 
736     function decimals() public view returns (uint8) {
737         return _decimals;
738     }
739 
740     function totalSupply() public view override returns (uint256) {
741         return _tTotal;
742     }
743 
744     function balanceOf(address account) public view override returns (uint256) {
745         if (_isExcluded[account]) return _tOwned[account];
746         return tokenFromReflection(_rOwned[account]);
747     }
748 
749     function transfer(address recipient, uint256 amount) public override returns (bool) {
750         _transfer(_msgSender(), recipient, amount);
751         return true;
752     }
753 
754     function allowance(address owner, address spender) public view override returns (uint256) {
755         return _allowances[owner][spender];
756     }
757 
758     function approve(address spender, uint256 amount) public override returns (bool) {
759         _approve(_msgSender(), spender, amount);
760         return true;
761     }
762 
763     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
764         _transfer(sender, recipient, amount);
765         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
766         return true;
767     }
768 
769     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
770         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
771         return true;
772     }
773 
774     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
775         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
776         return true;
777     }
778 
779     function isExcludedFromReward(address account) public view returns (bool) {
780         return _isExcluded[account];
781     }
782 
783     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
784         _isExcludedFromFee[account] = excluded;
785     }
786 
787     function totalFees() public view returns (uint256) {
788         return _tFeeTotal;
789     }
790 
791     function deliver(uint256 tAmount) public {
792         address sender = _msgSender();
793         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
794         (uint256 rAmount,,,,,) = _getValues(tAmount);
795         _rOwned[sender] = _rOwned[sender].sub(rAmount);
796         _rTotal = _rTotal.sub(rAmount);
797         _tFeeTotal = _tFeeTotal.add(tAmount);
798     }
799 
800     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
801         require(tAmount <= _tTotal, "Amount must be less than supply");
802         if (!deductTransferFee) {
803             (uint256 rAmount,,,,,) = _getValues(tAmount);
804             return rAmount;
805         } else {
806             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
807             return rTransferAmount;
808         }
809     }
810 
811     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
812         require(rAmount <= _rTotal, "Amount must be less than total reflections");
813         uint256 currentRate =  _getRate();
814         return rAmount.div(currentRate);
815     }
816 
817     function excludeFromReward(address account) external onlyOwner() {
818         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
819         require(!_isExcluded[account], "Account is already excluded");
820         if(_rOwned[account] > 0) {
821             _tOwned[account] = tokenFromReflection(_rOwned[account]);
822         }
823         _isExcluded[account] = true;
824         _excluded.push(account);
825     }
826 
827     function includeInReward(address account) external onlyOwner() {
828         require(_isExcluded[account], "Account is already excluded");
829         for (uint256 i = 0; i < _excluded.length; i++) {
830             if (_excluded[i] == account) {
831                 _excluded[i] = _excluded[_excluded.length - 1];
832                 _tOwned[account] = 0;
833                 _isExcluded[account] = false;
834                 _excluded.pop();
835                 break;
836             }
837         }
838     }
839 
840     function addBotToBlackList(address account) external onlyOwner() {
841         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
842         require(!_isBlackListedBot[account], "Account is already blacklisted");
843         _isBlackListedBot[account] = true;
844         _blackListedBots.push(account);
845     }
846 
847     function removeBotFromBlackList(address account) external onlyOwner() {
848         require(_isBlackListedBot[account], "Account is not blacklisted");
849         for (uint256 i = 0; i < _blackListedBots.length; i++) {
850             if (_blackListedBots[i] == account) {
851                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
852                 _isBlackListedBot[account] = false;
853                 _blackListedBots.pop();
854                 break;
855             }
856         }
857     }
858 
859     function removeAllFee() private {
860         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
861 
862         _previousTaxFee = _taxFee;
863         _previousMarketingFee = _marketingFee;
864         _previousLiquidityFee = _liquidityFee;
865 
866         _taxFee = 0;
867         _marketingFee = 0;
868         _liquidityFee = 0;
869     }
870 
871     function restoreAllFee() private {
872         _taxFee = _previousTaxFee;
873         _marketingFee = _previousMarketingFee;
874         _liquidityFee = _previousLiquidityFee;
875     }
876 
877     function isExcludedFromFee(address account) public view returns(bool) {
878         return _isExcludedFromFee[account];
879     }
880 
881     function _approve(address owner, address spender, uint256 amount) private {
882         require(owner != address(0), "ERC20: approve from the zero address");
883         require(spender != address(0), "ERC20: approve to the zero address");
884 
885         _allowances[owner][spender] = amount;
886         emit Approval(owner, spender, amount);
887     }
888 
889     function _transfer(address sender, address recipient, uint256 amount) private {
890         require(sender != address(0), "ERC20: transfer from the zero address");
891         require(recipient != address(0), "ERC20: transfer to the zero address");
892         require(amount > 0, "Transfer amount must be greater than zero");
893         require(!_isBlackListedBot[sender], "You have no power here!");
894         require(!_isBlackListedBot[recipient], "You have no power here!");
895         require(!_isBlackListedBot[tx.origin], "You have no power here!");
896 
897         if(sender != owner() && recipient != owner()) {
898             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
899         }
900 
901         // is the token balance of this contract address over the min number of
902         // tokens that we need to initiate a swap + liquidity lock?
903         // also, don't get caught in a circular liquidity event.
904         // also, don't swap & liquify if sender is uniswap pair.
905         uint256 contractTokenBalance = balanceOf(address(this));
906 
907         if(contractTokenBalance >= _maxTxAmount)
908         {
909             contractTokenBalance = _maxTxAmount;
910         }
911 
912         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
913         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
914             contractTokenBalance = _numTokensSellToAddToLiquidity;
915             //add liquidity
916             swapAndLiquify(contractTokenBalance);
917         }
918 
919         //indicates if fee should be deducted from transfer
920         bool takeFee = true;
921 
922         //if any account belongs to _isExcludedFromFee account then remove the fee
923         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
924             takeFee = false;
925         }
926 
927         //transfer amount, it will take tax and charity fee
928         _tokenTransfer(sender, recipient, amount, takeFee);
929     }
930 
931     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
932         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
933         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
934 
935         // split the contract balance into halves
936         uint256 half = toLiquify.div(2);
937         uint256 otherHalf = toLiquify.sub(half);
938 
939         // capture the contract's current ETH balance.
940         // this is so that we can capture exactly the amount of ETH that the
941         // swap creates, and not make the liquidity event include any ETH that
942         // has been manually sent to the contract
943         uint256 initialBalance = address(this).balance;
944 
945         // swap tokens for ETH
946         uint256 toSwapForEth = half.add(toMarketing);
947         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
948 
949         // how much ETH did we just swap into?
950         uint256 fromSwap = address(this).balance.sub(initialBalance);
951         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
952 
953         // add liquidity to uniswap
954         addLiquidity(otherHalf, newBalance);
955 
956         emit SwapAndLiquify(half, newBalance, otherHalf);
957 
958         sendETHToMarketing(fromSwap.sub(newBalance));
959     }
960 
961     function swapTokensForEth(uint256 tokenAmount) private {
962         // generate the uniswap pair path of token -> weth
963         address[] memory path = new address[](2);
964         path[0] = address(this);
965         path[1] = uniswapV2Router.WETH();
966 
967         _approve(address(this), address(uniswapV2Router), tokenAmount);
968 
969         // make the swap
970         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
971             tokenAmount,
972             0, // accept any amount of ETH
973             path,
974             address(this),
975             block.timestamp
976         );
977     }
978 
979     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
980         // approve token transfer to cover all possible scenarios
981         _approve(address(this), address(uniswapV2Router), tokenAmount);
982 
983         // add the liquidity
984         uniswapV2Router.addLiquidityETH{value: ethAmount}(
985             address(this),
986             tokenAmount,
987             0, // slippage is unavoidable
988             0, // slippage is unavoidable
989             owner(),
990             block.timestamp
991         );
992     }
993 
994     function sendETHToMarketing(uint256 amount) private {
995         _marketingWalletAddress.transfer(amount);
996     }
997 
998     // We are exposing these functions to be able to manual swap and send
999     // in case the token is highly valued and 5M becomes too much
1000     function manualSwap() external onlyOwner() {
1001         uint256 contractBalance = balanceOf(address(this));
1002         swapTokensForEth(contractBalance);
1003     }
1004 
1005     function manualSend() public onlyOwner() {
1006         uint256 contractETHBalance = address(this).balance;
1007         sendETHToMarketing(contractETHBalance);
1008     }
1009 
1010     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1011         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1012     }
1013 
1014     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1015         if(!takeFee)
1016             removeAllFee();
1017 
1018         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1019             _transferFromExcluded(sender, recipient, amount);
1020         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1021             _transferToExcluded(sender, recipient, amount);
1022         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1023             _transferStandard(sender, recipient, amount);
1024         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1025             _transferBothExcluded(sender, recipient, amount);
1026         } else {
1027             _transferStandard(sender, recipient, amount);
1028         }
1029 
1030         if(!takeFee)
1031             restoreAllFee();
1032     }
1033 
1034     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1035         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1036         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1037         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1038         _takeMarketingLiquidity(tMarketingLiquidity);
1039         _reflectFee(rFee, tFee);
1040         emit Transfer(sender, recipient, tTransferAmount);
1041     }
1042 
1043     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1044         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1045         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1046         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1047         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1048         _takeMarketingLiquidity(tMarketingLiquidity);
1049         _reflectFee(rFee, tFee);
1050         emit Transfer(sender, recipient, tTransferAmount);
1051     }
1052 
1053     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1054         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1055         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1056         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1057         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1058         _takeMarketingLiquidity(tMarketingLiquidity);
1059         _reflectFee(rFee, tFee);
1060         emit Transfer(sender, recipient, tTransferAmount);
1061     }
1062 
1063     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1064         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1065         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1066         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1067         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1068         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1069         _takeMarketingLiquidity(tMarketingLiquidity);
1070         _reflectFee(rFee, tFee);
1071         emit Transfer(sender, recipient, tTransferAmount);
1072     }
1073 
1074     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1075         uint256 currentRate = _getRate();
1076         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1077         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1078         if(_isExcluded[address(this)])
1079             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1080     }
1081 
1082     function _reflectFee(uint256 rFee, uint256 tFee) private {
1083         _rTotal = _rTotal.sub(rFee);
1084         _tFeeTotal = _tFeeTotal.add(tFee);
1085     }
1086 
1087     //to recieve ETH from uniswapV2Router when swapping
1088     receive() external payable {}
1089 
1090     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1091         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1092         uint256 currentRate = _getRate();
1093         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1094         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1095     }
1096 
1097     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1098         uint256 tFee = tAmount.mul(taxFee).div(100);
1099         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1100         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1101         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1102     }
1103 
1104     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1105         uint256 rAmount = tAmount.mul(currentRate);
1106         uint256 rFee = tFee.mul(currentRate);
1107         uint256 rTransferAmount = rAmount.sub(rFee);
1108         return (rAmount, rTransferAmount, rFee);
1109     }
1110 
1111     function _getRate() private view returns(uint256) {
1112         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1113         return rSupply.div(tSupply);
1114     }
1115 
1116     function _getCurrentSupply() private view returns(uint256, uint256) {
1117         uint256 rSupply = _rTotal;
1118         uint256 tSupply = _tTotal;
1119         for (uint256 i = 0; i < _excluded.length; i++) {
1120             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1121             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1122             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1123         }
1124         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1125         return (rSupply, tSupply);
1126     }
1127 
1128     function _getTaxFee() private view returns(uint256) {
1129         return _taxFee;
1130     }
1131 
1132     function _getMaxTxAmount() private view returns(uint256) {
1133         return _maxTxAmount / 10**9;
1134     }
1135 
1136     function _getETHBalance() public view returns(uint256 balance) {
1137         return address(this).balance;
1138     }
1139 
1140     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1141         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1142         _taxFee = taxFee;
1143     }
1144 
1145     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1146         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1147         _marketingFee = marketingFee;
1148     }
1149 
1150     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1151         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1152         _liquidityFee = liquidityFee;
1153     }
1154 
1155     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1156         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1157         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1158     }
1159 
1160     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1161         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1162             10**3 // Division by 1000, set to 20 for 2%, set to 2 for 0.2%
1163         );
1164     }
1165 
1166     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1167         _approve(address(this), owner(), tokenAmount);
1168         _transfer(address(this), owner(), tokenAmount);
1169     }
1170 }