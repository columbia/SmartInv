1 // SPDX-License-Identifier: Unlicensed
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
39     * This value changes when {approve} or {transferFrom} are called.
40     */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45     *
46     * Returns a boolean value indicating whether the operation succeeded.
47     *
48     * IMPORTANT: Beware that changing an allowance with this method brings the risk
49     * that someone may use both the old and the new allowance by unfortunate
50     * transaction ordering. One possible solution to mitigate this race
51     * condition is to first reduce the spender's allowance to 0 and set the
52     * desired value afterwards:
53     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54     *
55     * Emits an {Approval} event.
56     */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60     * @dev Moves `amount` tokens from `sender` to `recipient` using the
61     * allowance mechanism. `amount` is then deducted from the caller's
62     * allowance.
63     *
64     * Returns a boolean value indicating whether the operation succeeded.
65     *
66     * Emits a {Transfer} event.
67     */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71     * @dev Emitted when `value` tokens are moved from one account (`from`) to
72     * another (`to`).
73     *
74     * Note that `value` may be zero.
75     */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80     * a call to {approve}. `value` is the new allowance.
81     */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 library SafeMath {
86     /**
87     * @dev Returns the addition of two unsigned integers, reverting on
88     * overflow.
89     *
90     * Counterpart to Solidity's `+` operator.
91     *
92     * Requirements:
93     *
94     * - Addition cannot overflow.
95     */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     /**
104     * @dev Returns the subtraction of two unsigned integers, reverting on
105     * overflow (when the result is negative).
106     *
107     * Counterpart to Solidity's `-` operator.
108     *
109     * Requirements:
110     *
111     * - Subtraction cannot overflow.
112     */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return sub(a, b, "SafeMath: subtraction overflow");
115     }
116 
117     /**
118     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
119     * overflow (when the result is negative).
120     *
121     * Counterpart to Solidity's `-` operator.
122     *
123     * Requirements:
124     *
125     * - Subtraction cannot overflow.
126     */
127     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135     * @dev Returns the multiplication of two unsigned integers, reverting on
136     * overflow.
137     *
138     * Counterpart to Solidity's `*` operator.
139     *
140     * Requirements:
141     *
142     * - Multiplication cannot overflow.
143     */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159     * @dev Returns the integer division of two unsigned integers. Reverts on
160     * division by zero. The result is rounded towards zero.
161     *
162     * Counterpart to Solidity's `/` operator. Note: this function uses a
163     * `revert` opcode (which leaves remaining gas untouched) while Solidity
164     * uses an invalid opcode to revert (consuming all remaining gas).
165     *
166     * Requirements:
167     *
168     * - The divisor cannot be zero.
169     */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     /**
175     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
176     * division by zero. The result is rounded towards zero.
177     *
178     * Counterpart to Solidity's `/` operator. Note: this function uses a
179     * `revert` opcode (which leaves remaining gas untouched) while Solidity
180     * uses an invalid opcode to revert (consuming all remaining gas).
181     *
182     * Requirements:
183     *
184     * - The divisor cannot be zero.
185     */
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b > 0, errorMessage);
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191         return c;
192     }
193 
194     /**
195     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196     * Reverts when dividing by zero.
197     *
198     * Counterpart to Solidity's `%` operator. This function uses a `revert`
199     * opcode (which leaves remaining gas untouched) while Solidity uses an
200     * invalid opcode to revert (consuming all remaining gas).
201     *
202     * Requirements:
203     *
204     * - The divisor cannot be zero.
205     */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return mod(a, b, "SafeMath: modulo by zero");
208     }
209 
210     /**
211     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212     * Reverts with custom message when dividing by zero.
213     *
214     * Counterpart to Solidity's `%` operator. This function uses a `revert`
215     * opcode (which leaves remaining gas untouched) while Solidity uses an
216     * invalid opcode to revert (consuming all remaining gas).
217     *
218     * Requirements:
219     *
220     * - The divisor cannot be zero.
221     */
222     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b != 0, errorMessage);
224         return a % b;
225     }
226 }
227 
228 library Address {
229     /**
230     * @dev Returns true if `account` is a contract.
231     *
232     * [IMPORTANT]
233     * ====
234     * It is unsafe to assume that an address for which this function returns
235     * false is an externally-owned account (EOA) and not a contract.
236     *
237     * Among others, `isContract` will return false for the following
238     * types of addresses:
239     *
240     *  - an externally-owned account
241     *  - a contract in construction
242     *  - an address where a contract will be created
243     *  - an address where a contract lived, but was destroyed
244     * ====
245     */
246     function isContract(address account) internal view returns (bool) {
247         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
248         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
249         // for accounts without code, i.e. `keccak256('')`
250         bytes32 codehash;
251         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
252         // solhint-disable-next-line no-inline-assembly
253         assembly { codehash := extcodehash(account) }
254         return (codehash != accountHash && codehash != 0x0);
255     }
256 
257     /**
258     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
259     * `recipient`, forwarding all available gas and reverting on errors.
260     *
261     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
262     * of certain opcodes, possibly making contracts go over the 2300 gas limit
263     * imposed by `transfer`, making them unable to receive funds via
264     * `transfer`. {sendValue} removes this limitation.
265     *
266     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
267     *
268     * IMPORTANT: because control is transferred to `recipient`, care must be
269     * taken to not create reentrancy vulnerabilities. Consider using
270     * {ReentrancyGuard} or the
271     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
272     */
273     function sendValue(address payable recipient, uint256 amount) internal {
274         require(address(this).balance >= amount, "Address: insufficient balance");
275 
276         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
277         (bool success, ) = recipient.call{ value: amount }("");
278         require(success, "Address: unable to send value, recipient may have reverted");
279     }
280 
281     /**
282     * @dev Performs a Solidity function call using a low level `call`. A
283     * plain`call` is an unsafe replacement for a function call: use this
284     * function instead.
285     *
286     * If `target` reverts with a revert reason, it is bubbled up by this
287     * function (like regular Solidity function calls).
288     *
289     * Returns the raw returned data. To convert to the expected return value,
290     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
291     *
292     * Requirements:
293     *
294     * - `target` must be a contract.
295     * - calling `target` with `data` must not revert.
296     *
297     * _Available since v3.1._
298     */
299     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
300     return functionCall(target, data, "Address: low-level call failed");
301     }
302 
303     /**
304     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
305     * `errorMessage` as a fallback revert reason when `target` reverts.
306     *
307     * _Available since v3.1._
308     */
309     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
310         return _functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315     * but also transferring `value` wei to `target`.
316     *
317     * Requirements:
318     *
319     * - the calling contract must have an ETH balance of at least `value`.
320     * - the called Solidity function must be `payable`.
321     *
322     * _Available since v3.1._
323     */
324     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330     * with `errorMessage` as a fallback revert reason when `target` reverts.
331     *
332     * _Available since v3.1._
333     */
334     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
335         require(address(this).balance >= value, "Address: insufficient balance for call");
336         return _functionCallWithValue(target, data, value, errorMessage);
337     }
338 
339     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
340         require(isContract(target), "Address: call to non-contract");
341 
342         // solhint-disable-next-line avoid-low-level-calls
343         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
344         if (success) {
345             return returndata;
346         } else {
347             // Look for revert reason and bubble it up if present
348             if (returndata.length > 0) {
349                 // The easiest way to bubble the revert reason is using memory via assembly
350 
351                 // solhint-disable-next-line no-inline-assembly
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 contract Ownable is Context {
364     address private _owner;
365     address private _previousOwner;
366     uint256 private _lockTime;
367 
368     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370     /**
371     * @dev Initializes the contract setting the deployer as the initial owner.
372     */
373     constructor () internal {
374         address msgSender = _msgSender();
375         _owner = msgSender;
376         emit OwnershipTransferred(address(0), msgSender);
377     }
378 
379     /**
380     * @dev Returns the address of the current owner.
381     */
382     function owner() public view returns (address) {
383         return _owner;
384     }
385 
386     /**
387     * @dev Throws if called by any account other than the owner.
388     */
389     modifier onlyOwner() {
390         require(_owner == _msgSender(), "Ownable: caller is not the owner");
391         _;
392     }
393 
394     /**
395     * @dev Leaves the contract without owner. It will not be possible to call
396     * `onlyOwner` functions anymore. Can only be called by the current owner.
397     *
398     * NOTE: Renouncing ownership will leave the contract without an owner,
399     * thereby removing any functionality that is only available to the owner.
400     */
401     function renounceOwnership() public virtual onlyOwner {
402         emit OwnershipTransferred(_owner, address(0));
403         _owner = address(0);
404     }
405 
406     /**
407     * @dev Transfers ownership of the contract to a new account (`newOwner`).
408     * Can only be called by the current owner.
409     */
410     function transferOwnership(address newOwner) public virtual onlyOwner {
411         require(newOwner != address(0), "Ownable: new owner is the zero address");
412         emit OwnershipTransferred(_owner, newOwner);
413         _owner = newOwner;
414     }
415 
416     function geUnlockTime() public view returns (uint256) {
417         return _lockTime;
418     }
419 
420     //Locks the contract for owner for the amount of time provided
421     function lock(uint256 time) public virtual onlyOwner {
422         _previousOwner = _owner;
423         _owner = address(0);
424         _lockTime = now + time;
425         emit OwnershipTransferred(_owner, address(0));
426     }
427 
428     //Unlocks the contract for owner when _lockTime is exceeds
429     function unlock() public virtual {
430         require(_previousOwner == msg.sender, "You don't have permission to unlock");
431         require(now > _lockTime , "Contract is locked until 7 days");
432         emit OwnershipTransferred(_owner, _previousOwner);
433         _owner = _previousOwner;
434     }
435 }
436 
437 interface IUniswapV2Factory {
438     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
439 
440     function feeTo() external view returns (address);
441     function feeToSetter() external view returns (address);
442 
443     function getPair(address tokenA, address tokenB) external view returns (address pair);
444     function allPairs(uint) external view returns (address pair);
445     function allPairsLength() external view returns (uint);
446 
447     function createPair(address tokenA, address tokenB) external returns (address pair);
448 
449     function setFeeTo(address) external;
450     function setFeeToSetter(address) external;
451 }
452 
453 interface IUniswapV2Pair {
454     event Approval(address indexed owner, address indexed spender, uint value);
455     event Transfer(address indexed from, address indexed to, uint value);
456 
457     function name() external pure returns (string memory);
458     function symbol() external pure returns (string memory);
459     function decimals() external pure returns (uint8);
460     function totalSupply() external view returns (uint);
461     function balanceOf(address owner) external view returns (uint);
462     function allowance(address owner, address spender) external view returns (uint);
463 
464     function approve(address spender, uint value) external returns (bool);
465     function transfer(address to, uint value) external returns (bool);
466     function transferFrom(address from, address to, uint value) external returns (bool);
467 
468     function DOMAIN_SEPARATOR() external view returns (bytes32);
469     function PERMIT_TYPEHASH() external pure returns (bytes32);
470     function nonces(address owner) external view returns (uint);
471 
472     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
473 
474     event Mint(address indexed sender, uint amount0, uint amount1);
475     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
476     event Swap(
477         address indexed sender,
478         uint amount0In,
479         uint amount1In,
480         uint amount0Out,
481         uint amount1Out,
482         address indexed to
483     );
484     event Sync(uint112 reserve0, uint112 reserve1);
485 
486     function MINIMUM_LIQUIDITY() external pure returns (uint);
487     function factory() external view returns (address);
488     function token0() external view returns (address);
489     function token1() external view returns (address);
490     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
491     function price0CumulativeLast() external view returns (uint);
492     function price1CumulativeLast() external view returns (uint);
493     function kLast() external view returns (uint);
494 
495     function mint(address to) external returns (uint liquidity);
496     function burn(address to) external returns (uint amount0, uint amount1);
497     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
498     function skim(address to) external;
499     function sync() external;
500 
501     function initialize(address, address) external;
502 }
503 
504 interface IUniswapV2Router01 {
505     function factory() external pure returns (address);
506     function WETH() external pure returns (address);
507 
508     function addLiquidity(
509         address tokenA,
510         address tokenB,
511         uint amountADesired,
512         uint amountBDesired,
513         uint amountAMin,
514         uint amountBMin,
515         address to,
516         uint deadline
517     ) external returns (uint amountA, uint amountB, uint liquidity);
518     function addLiquidityETH(
519         address token,
520         uint amountTokenDesired,
521         uint amountTokenMin,
522         uint amountETHMin,
523         address to,
524         uint deadline
525     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
526     function removeLiquidity(
527         address tokenA,
528         address tokenB,
529         uint liquidity,
530         uint amountAMin,
531         uint amountBMin,
532         address to,
533         uint deadline
534     ) external returns (uint amountA, uint amountB);
535     function removeLiquidityETH(
536         address token,
537         uint liquidity,
538         uint amountTokenMin,
539         uint amountETHMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountToken, uint amountETH);
543     function removeLiquidityWithPermit(
544         address tokenA,
545         address tokenB,
546         uint liquidity,
547         uint amountAMin,
548         uint amountBMin,
549         address to,
550         uint deadline,
551         bool approveMax, uint8 v, bytes32 r, bytes32 s
552     ) external returns (uint amountA, uint amountB);
553     function removeLiquidityETHWithPermit(
554         address token,
555         uint liquidity,
556         uint amountTokenMin,
557         uint amountETHMin,
558         address to,
559         uint deadline,
560         bool approveMax, uint8 v, bytes32 r, bytes32 s
561     ) external returns (uint amountToken, uint amountETH);
562     function swapExactTokensForTokens(
563         uint amountIn,
564         uint amountOutMin,
565         address[] calldata path,
566         address to,
567         uint deadline
568     ) external returns (uint[] memory amounts);
569     function swapTokensForExactTokens(
570         uint amountOut,
571         uint amountInMax,
572         address[] calldata path,
573         address to,
574         uint deadline
575     ) external returns (uint[] memory amounts);
576     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
577         external
578         payable
579         returns (uint[] memory amounts);
580     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
581         external
582         returns (uint[] memory amounts);
583     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
584         external
585         returns (uint[] memory amounts);
586     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
587         external
588         payable
589         returns (uint[] memory amounts);
590 
591     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
592     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
593     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
594     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
595     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
596 }
597 
598 interface IUniswapV2Router02 is IUniswapV2Router01 {
599     function removeLiquidityETHSupportingFeeOnTransferTokens(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline
606     ) external returns (uint amountETH);
607     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline,
614         bool approveMax, uint8 v, bytes32 r, bytes32 s
615     ) external returns (uint amountETH);
616 
617     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
618         uint amountIn,
619         uint amountOutMin,
620         address[] calldata path,
621         address to,
622         uint deadline
623     ) external;
624     function swapExactETHForTokensSupportingFeeOnTransferTokens(
625         uint amountOutMin,
626         address[] calldata path,
627         address to,
628         uint deadline
629     ) external payable;
630     function swapExactTokensForETHSupportingFeeOnTransferTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external;
637 }
638 
639 // Contract implementation
640 contract Tenshi is Context, IERC20, Ownable {
641     using SafeMath for uint256;
642     using Address for address;
643 
644     mapping (address => uint256) private _rOwned;
645     mapping (address => uint256) private _tOwned;
646     mapping (address => mapping (address => uint256)) private _allowances;
647 
648     mapping (address => bool) private _isExcludedFromFee;
649 
650     mapping (address => bool) private _isExcluded;
651     address[] private _excluded;
652 
653     uint256 private constant MAX = ~uint256(0);
654     uint256 private _tTotal = 1000000000000 * 10**9;
655     uint256 private _rTotal = (MAX - (MAX % _tTotal));
656     uint256 private _tFeeTotal;
657 
658     string private _name = 'Tenshi';
659     string private _symbol = 'TENSHI';
660     uint8 private _decimals = 9;
661 
662     // Tax and kishu fees will start at 0 so we don't have a big impact when deploying to Uniswap
663     // Kishu wallet address is null but the method to set the address is exposed
664     uint256 private _taxFee = 1;
665     uint256 private _kishuFee = 15;
666     uint256 private _previousTaxFee = _taxFee;
667     uint256 private _previousKishuFee = _kishuFee;
668 
669     address payable public _kishuWalletAddress;
670     address payable public _marketingWalletAddress;
671 
672     IUniswapV2Router02 public immutable uniswapV2Router;
673     address public immutable uniswapV2Pair;
674 
675     bool inSwap = false;
676     bool public swapEnabled = true;
677 
678     uint256 private _maxTxAmount = 10000000000 * 10**9;
679     // We will set a minimum amount of tokens to be swaped => 5M
680     uint256 private _numOfTokensToExchangeForKishu = 5 * 10**3 * 10**9;
681 
682     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
683     event SwapEnabledUpdated(bool enabled);
684 
685     modifier lockTheSwap {
686         inSwap = true;
687         _;
688         inSwap = false;
689     }
690 
691     constructor (address payable kishuWalletAddress, address payable marketingWalletAddress) public {
692         _kishuWalletAddress = kishuWalletAddress;
693         _marketingWalletAddress = marketingWalletAddress;
694         _rOwned[_msgSender()] = _rTotal;
695 
696         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
697         // Create a uniswap pair for this new token
698         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
699             .createPair(address(this), _uniswapV2Router.WETH());
700 
701         // set the rest of the contract variables
702         uniswapV2Router = _uniswapV2Router;
703 
704         // Exclude owner and this contract from fee
705         _isExcludedFromFee[owner()] = true;
706         _isExcludedFromFee[address(this)] = true;
707 
708         emit Transfer(address(0), _msgSender(), _tTotal);
709     }
710 
711     function name() public view returns (string memory) {
712         return _name;
713     }
714 
715     function symbol() public view returns (string memory) {
716         return _symbol;
717     }
718 
719     function decimals() public view returns (uint8) {
720         return _decimals;
721     }
722 
723     function totalSupply() public view override returns (uint256) {
724         return _tTotal;
725     }
726 
727     function balanceOf(address account) public view override returns (uint256) {
728         if (_isExcluded[account]) return _tOwned[account];
729         return tokenFromReflection(_rOwned[account]);
730     }
731 
732     function transfer(address recipient, uint256 amount) public override returns (bool) {
733         _transfer(_msgSender(), recipient, amount);
734         return true;
735     }
736 
737     function allowance(address owner, address spender) public view override returns (uint256) {
738         return _allowances[owner][spender];
739     }
740 
741     function approve(address spender, uint256 amount) public override returns (bool) {
742         _approve(_msgSender(), spender, amount);
743         return true;
744     }
745 
746     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
747         _transfer(sender, recipient, amount);
748         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
749         return true;
750     }
751 
752     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
753         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
754         return true;
755     }
756 
757     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
758         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
759         return true;
760     }
761 
762     function isExcluded(address account) public view returns (bool) {
763         return _isExcluded[account];
764     }
765 
766     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
767         _isExcludedFromFee[account] = excluded;
768     }
769 
770     function totalFees() public view returns (uint256) {
771         return _tFeeTotal;
772     }
773 
774     function deliver(uint256 tAmount) public {
775         address sender = _msgSender();
776         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
777         (uint256 rAmount,,,,,) = _getValues(tAmount);
778         _rOwned[sender] = _rOwned[sender].sub(rAmount);
779         _rTotal = _rTotal.sub(rAmount);
780         _tFeeTotal = _tFeeTotal.add(tAmount);
781     }
782 
783     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
784         require(tAmount <= _tTotal, "Amount must be less than supply");
785         if (!deductTransferFee) {
786             (uint256 rAmount,,,,,) = _getValues(tAmount);
787             return rAmount;
788         } else {
789             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
790             return rTransferAmount;
791         }
792     }
793 
794     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
795         require(rAmount <= _rTotal, "Amount must be less than total reflections");
796         uint256 currentRate =  _getRate();
797         return rAmount.div(currentRate);
798     }
799 
800     function excludeAccount(address account) external onlyOwner() {
801         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
802         require(!_isExcluded[account], "Account is already excluded");
803         if(_rOwned[account] > 0) {
804             _tOwned[account] = tokenFromReflection(_rOwned[account]);
805         }
806         _isExcluded[account] = true;
807         _excluded.push(account);
808     }
809 
810     function includeAccount(address account) external onlyOwner() {
811         require(_isExcluded[account], "Account is already excluded");
812         for (uint256 i = 0; i < _excluded.length; i++) {
813             if (_excluded[i] == account) {
814                 _excluded[i] = _excluded[_excluded.length - 1];
815                 _tOwned[account] = 0;
816                 _isExcluded[account] = false;
817                 _excluded.pop();
818                 break;
819             }
820         }
821     }
822 
823     function removeAllFee() private {
824         if(_taxFee == 0 && _kishuFee == 0) return;
825 
826         _previousTaxFee = _taxFee;
827         _previousKishuFee = _kishuFee;
828 
829         _taxFee = 0;
830         _kishuFee = 0;
831     }
832 
833     function restoreAllFee() private {
834         _taxFee = _previousTaxFee;
835         _kishuFee = _previousKishuFee;
836     }
837 
838     function isExcludedFromFee(address account) public view returns(bool) {
839         return _isExcludedFromFee[account];
840     }
841 
842     function _approve(address owner, address spender, uint256 amount) private {
843         require(owner != address(0), "ERC20: approve from the zero address");
844         require(spender != address(0), "ERC20: approve to the zero address");
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     function _transfer(address sender, address recipient, uint256 amount) private {
851         require(sender != address(0), "ERC20: transfer from the zero address");
852         require(recipient != address(0), "ERC20: transfer to the zero address");
853         require(amount > 0, "Transfer amount must be greater than zero");
854 
855         if(sender != owner() && recipient != owner())
856             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
857 
858         // is the token balance of this contract address over the min number of
859         // tokens that we need to initiate a swap?
860         // also, don't get caught in a circular kishu event.
861         // also, don't swap if sender is uniswap pair.
862         uint256 contractTokenBalance = balanceOf(address(this));
863 
864         if(contractTokenBalance >= _maxTxAmount)
865         {
866             contractTokenBalance = _maxTxAmount;
867         }
868 
869         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForKishu;
870         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
871             // We need to swap the current tokens to ETH and send to the kishu wallet
872             swapTokensForEth(contractTokenBalance);
873 
874             uint256 contractETHBalance = address(this).balance;
875             if(contractETHBalance > 0) {
876                 sendETHToKishu(address(this).balance);
877             }
878         }
879 
880         //indicates if fee should be deducted from transfer
881         bool takeFee = true;
882 
883         //if any account belongs to _isExcludedFromFee account then remove the fee
884         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
885             takeFee = false;
886         }
887 
888         //transfer amount, it will take tax and kishu fee
889         _tokenTransfer(sender,recipient,amount,takeFee);
890     }
891 
892     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
893         // generate the uniswap pair path of token -> weth
894         address[] memory path = new address[](2);
895         path[0] = address(this);
896         path[1] = uniswapV2Router.WETH();
897 
898         _approve(address(this), address(uniswapV2Router), tokenAmount);
899 
900         // make the swap
901         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
902             tokenAmount,
903             0, // accept any amount of ETH
904             path,
905             address(this),
906             block.timestamp
907         );
908     }
909 
910     function sendETHToKishu(uint256 amount) private {
911         _kishuWalletAddress.transfer(amount.div(2));
912         _marketingWalletAddress.transfer(amount.div(2));
913     }
914 
915     // We are exposing these functions to be able to manual swap and send
916     // in case the token is highly valued and 5M becomes too much
917     function manualSwap() external onlyOwner() {
918         uint256 contractBalance = balanceOf(address(this));
919         swapTokensForEth(contractBalance);
920     }
921 
922     function manualSend() external onlyOwner() {
923         uint256 contractETHBalance = address(this).balance;
924         sendETHToKishu(contractETHBalance);
925     }
926 
927     function setSwapEnabled(bool enabled) external onlyOwner(){
928         swapEnabled = enabled;
929     }
930 
931     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
932         if(!takeFee)
933             removeAllFee();
934 
935         if (_isExcluded[sender] && !_isExcluded[recipient]) {
936             _transferFromExcluded(sender, recipient, amount);
937         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
938             _transferToExcluded(sender, recipient, amount);
939         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
940             _transferStandard(sender, recipient, amount);
941         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
942             _transferBothExcluded(sender, recipient, amount);
943         } else {
944             _transferStandard(sender, recipient, amount);
945         }
946 
947         if(!takeFee)
948             restoreAllFee();
949     }
950 
951     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
952         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tKishu) = _getValues(tAmount);
953         _rOwned[sender] = _rOwned[sender].sub(rAmount);
954         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
955         _takeKishu(tKishu);
956         _reflectFee(rFee, tFee);
957         emit Transfer(sender, recipient, tTransferAmount);
958     }
959 
960     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
961         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tKishu) = _getValues(tAmount);
962         _rOwned[sender] = _rOwned[sender].sub(rAmount);
963         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
964         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
965         _takeKishu(tKishu);
966         _reflectFee(rFee, tFee);
967         emit Transfer(sender, recipient, tTransferAmount);
968     }
969 
970     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
971         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tKishu) = _getValues(tAmount);
972         _tOwned[sender] = _tOwned[sender].sub(tAmount);
973         _rOwned[sender] = _rOwned[sender].sub(rAmount);
974         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
975         _takeKishu(tKishu);
976         _reflectFee(rFee, tFee);
977         emit Transfer(sender, recipient, tTransferAmount);
978     }
979 
980     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
981         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tKishu) = _getValues(tAmount);
982         _tOwned[sender] = _tOwned[sender].sub(tAmount);
983         _rOwned[sender] = _rOwned[sender].sub(rAmount);
984         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
985         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
986         _takeKishu(tKishu);
987         _reflectFee(rFee, tFee);
988         emit Transfer(sender, recipient, tTransferAmount);
989     }
990 
991     function _takeKishu(uint256 tKishu) private {
992         uint256 currentRate =  _getRate();
993         uint256 rKishu = tKishu.mul(currentRate);
994         _rOwned[address(this)] = _rOwned[address(this)].add(rKishu);
995         if(_isExcluded[address(this)])
996             _tOwned[address(this)] = _tOwned[address(this)].add(tKishu);
997     }
998 
999     function _reflectFee(uint256 rFee, uint256 tFee) private {
1000         _rTotal = _rTotal.sub(rFee);
1001         _tFeeTotal = _tFeeTotal.add(tFee);
1002     }
1003 
1004      //to recieve ETH from uniswapV2Router when swaping
1005     receive() external payable {}
1006 
1007     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1008         (uint256 tTransferAmount, uint256 tFee, uint256 tKishu) = _getTValues(tAmount, _taxFee, _kishuFee);
1009         uint256 currentRate =  _getRate();
1010         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1011         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tKishu);
1012     }
1013 
1014     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 kishuFee) private pure returns (uint256, uint256, uint256) {
1015         uint256 tFee = tAmount.mul(taxFee).div(100);
1016         uint256 tKishu = tAmount.mul(kishuFee).div(100);
1017         uint256 tTransferAmount = tAmount.sub(tFee).sub(tKishu);
1018         return (tTransferAmount, tFee, tKishu);
1019     }
1020 
1021     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1022         uint256 rAmount = tAmount.mul(currentRate);
1023         uint256 rFee = tFee.mul(currentRate);
1024         uint256 rTransferAmount = rAmount.sub(rFee);
1025         return (rAmount, rTransferAmount, rFee);
1026     }
1027 
1028     function _getRate() private view returns(uint256) {
1029         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1030         return rSupply.div(tSupply);
1031     }
1032 
1033     function _getCurrentSupply() private view returns(uint256, uint256) {
1034         uint256 rSupply = _rTotal;
1035         uint256 tSupply = _tTotal;
1036         for (uint256 i = 0; i < _excluded.length; i++) {
1037             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1038             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1039             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1040         }
1041         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1042         return (rSupply, tSupply);
1043     }
1044 
1045     function _getTaxFee() private view returns(uint256) {
1046         return _taxFee;
1047     }
1048 
1049     function _getMaxTxAmount() private view returns(uint256) {
1050         return _maxTxAmount;
1051     }
1052 
1053     function _getETHBalance() public view returns(uint256 balance) {
1054         return address(this).balance;
1055     }
1056 
1057     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1058         require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1059         _taxFee = taxFee;
1060     }
1061 
1062     function _setKishuFee(uint256 kishuFee) external onlyOwner() {
1063         require(kishuFee >= 1 && kishuFee <= 11, 'kishuFee should be in 1 - 11');
1064         _kishuFee = kishuFee;
1065     }
1066 
1067     function _setKishuWallet(address payable kishuWalletAddress) external onlyOwner() {
1068         _kishuWalletAddress = kishuWalletAddress;
1069     }
1070 
1071     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1072         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1073             10**2
1074         );
1075     }
1076 }