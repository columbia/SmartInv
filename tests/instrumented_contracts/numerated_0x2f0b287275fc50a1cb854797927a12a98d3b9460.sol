1 /**
2 https://t.me/ethereumgodtoken
3 */
4 
5 //SPDX-License-Identifier: GPL-3.0-or-later
6 pragma solidity ^0.6.12;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address payable) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes memory) {
14         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15         return msg.data;
16     }
17 }
18 
19 interface IERC20 {
20     /**
21     * @dev Returns the amount of tokens in existence.
22     */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26     * @dev Returns the amount of tokens owned by `account`.
27     */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31     * @dev Moves `amount` tokens from the caller's account to `recipient`.
32     *
33     * Returns a boolean value indicating whether the operation succeeded.
34     *
35     * Emits a {Transfer} event.
36     */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40     * @dev Returns the remaining number of tokens that `spender` will be
41     * allowed to spend on behalf of `owner` through {transferFrom}. This is
42     * zero by default.
43     *
44     * This value changes when {approve} or {transferFrom} are called.
45     */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50     *
51     * Returns a boolean value indicating whether the operation succeeded.
52     *
53     * IMPORTANT: Beware that changing an allowance with this method brings the risk
54     * that someone may use both the old and the new allowance by unfortunate
55     * transaction ordering. One possible solution to mitigate this race
56     * condition is to first reduce the spender's allowance to 0 and set the
57     * desired value afterwards:
58     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59     *
60     * Emits an {Approval} event.
61     */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65     * @dev Moves `amount` tokens from `sender` to `recipient` using the
66     * allowance mechanism. `amount` is then deducted from the caller's
67     * allowance.
68     *
69     * Returns a boolean value indicating whether the operation succeeded.
70     *
71     * Emits a {Transfer} event.
72     */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76     * @dev Emitted when `value` tokens are moved from one account (`from`) to
77     * another (`to`).
78     *
79     * Note that `value` may be zero.
80     */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85     * a call to {approve}. `value` is the new allowance.
86     */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 library SafeMath {
91     /**
92     * @dev Returns the addition of two unsigned integers, reverting on
93     * overflow.
94     *
95     * Counterpart to Solidity's `+` operator.
96     *
97     * Requirements:
98     *
99     * - Addition cannot overflow.
100     */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109     * @dev Returns the subtraction of two unsigned integers, reverting on
110     * overflow (when the result is negative).
111     *
112     * Counterpart to Solidity's `-` operator.
113     *
114     * Requirements:
115     *
116     * - Subtraction cannot overflow.
117     */
118     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119         return sub(a, b, "SafeMath: subtraction overflow");
120     }
121 
122     /**
123     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124     * overflow (when the result is negative).
125     *
126     * Counterpart to Solidity's `-` operator.
127     *
128     * Requirements:
129     *
130     * - Subtraction cannot overflow.
131     */
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138 
139     /**
140     * @dev Returns the multiplication of two unsigned integers, reverting on
141     * overflow.
142     *
143     * Counterpart to Solidity's `*` operator.
144     *
145     * Requirements:
146     *
147     * - Multiplication cannot overflow.
148     */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151         // benefit is lost if 'b' is also tested.
152         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153         if (a == 0) {
154             return 0;
155         }
156 
157         uint256 c = a * b;
158         require(c / a == b, "SafeMath: multiplication overflow");
159 
160         return c;
161     }
162 
163     /**
164     * @dev Returns the integer division of two unsigned integers. Reverts on
165     * division by zero. The result is rounded towards zero.
166     *
167     * Counterpart to Solidity's `/` operator. Note: this function uses a
168     * `revert` opcode (which leaves remaining gas untouched) while Solidity
169     * uses an invalid opcode to revert (consuming all remaining gas).
170     *
171     * Requirements:
172     *
173     * - The divisor cannot be zero.
174     */
175     function div(uint256 a, uint256 b) internal pure returns (uint256) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178 
179     /**
180     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181     * division by zero. The result is rounded towards zero.
182     *
183     * Counterpart to Solidity's `/` operator. Note: this function uses a
184     * `revert` opcode (which leaves remaining gas untouched) while Solidity
185     * uses an invalid opcode to revert (consuming all remaining gas).
186     *
187     * Requirements:
188     *
189     * - The divisor cannot be zero.
190     */
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         require(b > 0, errorMessage);
193         uint256 c = a / b;
194         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196         return c;
197     }
198 
199     /**
200     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201     * Reverts when dividing by zero.
202     *
203     * Counterpart to Solidity's `%` operator. This function uses a `revert`
204     * opcode (which leaves remaining gas untouched) while Solidity uses an
205     * invalid opcode to revert (consuming all remaining gas).
206     *
207     * Requirements:
208     *
209     * - The divisor cannot be zero.
210     */
211     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212         return mod(a, b, "SafeMath: modulo by zero");
213     }
214 
215     /**
216     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217     * Reverts with custom message when dividing by zero.
218     *
219     * Counterpart to Solidity's `%` operator. This function uses a `revert`
220     * opcode (which leaves remaining gas untouched) while Solidity uses an
221     * invalid opcode to revert (consuming all remaining gas).
222     *
223     * Requirements:
224     *
225     * - The divisor cannot be zero.
226     */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 library Address {
234     /**
235     * @dev Returns true if `account` is a contract.
236     *
237     * [IMPORTANT]
238     * ====
239     * It is unsafe to assume that an address for which this function returns
240     * false is an externally-owned account (EOA) and not a contract.
241     *
242     * Among others, `isContract` will return false for the following
243     * types of addresses:
244     *
245     *  - an externally-owned account
246     *  - a contract in construction
247     *  - an address where a contract will be created
248     *  - an address where a contract lived, but was destroyed
249     * ====
250     */
251     function isContract(address account) internal view returns (bool) {
252         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
253         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
254         // for accounts without code, i.e. `keccak256('')`
255         bytes32 codehash;
256         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
257         // solhint-disable-next-line no-inline-assembly
258         assembly { codehash := extcodehash(account) }
259         return (codehash != accountHash && codehash != 0x0);
260     }
261 
262     /**
263     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264     * `recipient`, forwarding all available gas and reverting on errors.
265     *
266     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267     * of certain opcodes, possibly making contracts go over the 2300 gas limit
268     * imposed by `transfer`, making them unable to receive funds via
269     * `transfer`. {sendValue} removes this limitation.
270     *
271     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272     *
273     * IMPORTANT: because control is transferred to `recipient`, care must be
274     * taken to not create reentrancy vulnerabilities. Consider using
275     * {ReentrancyGuard} or the
276     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277     */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
282         (bool success, ) = recipient.call{ value: amount }("");
283         require(success, "Address: unable to send value, recipient may have reverted");
284     }
285 
286     /**
287     * @dev Performs a Solidity function call using a low level `call`. A
288     * plain`call` is an unsafe replacement for a function call: use this
289     * function instead.
290     *
291     * If `target` reverts with a revert reason, it is bubbled up by this
292     * function (like regular Solidity function calls).
293     *
294     * Returns the raw returned data. To convert to the expected return value,
295     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296     *
297     * Requirements:
298     *
299     * - `target` must be a contract.
300     * - calling `target` with `data` must not revert.
301     *
302     * _Available since v3.1._
303     */
304     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306     }
307 
308     /**
309     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310     * `errorMessage` as a fallback revert reason when `target` reverts.
311     *
312     * _Available since v3.1._
313     */
314     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
315         return _functionCallWithValue(target, data, 0, errorMessage);
316     }
317 
318     /**
319     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320     * but also transferring `value` wei to `target`.
321     *
322     * Requirements:
323     *
324     * - the calling contract must have an ETH balance of at least `value`.
325     * - the called Solidity function must be `payable`.
326     *
327     * _Available since v3.1._
328     */
329     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
330         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331     }
332 
333     /**
334     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335     * with `errorMessage` as a fallback revert reason when `target` reverts.
336     *
337     * _Available since v3.1._
338     */
339     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
340         require(address(this).balance >= value, "Address: insufficient balance for call");
341         return _functionCallWithValue(target, data, value, errorMessage);
342     }
343 
344     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
345         require(isContract(target), "Address: call to non-contract");
346 
347         // solhint-disable-next-line avoid-low-level-calls
348         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
349         if (success) {
350             return returndata;
351         } else {
352             // Look for revert reason and bubble it up if present
353             if (returndata.length > 0) {
354                 // The easiest way to bubble the revert reason is using memory via assembly
355 
356                 // solhint-disable-next-line no-inline-assembly
357                 assembly {
358                     let returndata_size := mload(returndata)
359                     revert(add(32, returndata), returndata_size)
360                 }
361             } else {
362                 revert(errorMessage);
363             }
364         }
365     }
366 }
367 
368 contract Ownable is Context {
369     address private _owner;
370     address private _previousOwner;
371     uint256 private _lockTime;
372 
373     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375     /**
376     * @dev Initializes the contract setting the deployer as the initial owner.
377     */
378     constructor () internal {
379         address msgSender = _msgSender();
380         _owner = msgSender;
381         emit OwnershipTransferred(address(0), msgSender);
382     }
383 
384     /**
385     * @dev Returns the address of the current owner.
386     */
387     function owner() public view returns (address) {
388         return _owner;
389     }
390 
391     /**
392     * @dev Throws if called by any account other than the owner.
393     */
394     modifier onlyOwner() {
395         require(_owner == _msgSender(), "Ownable: caller is not the owner");
396         _;
397     }
398 
399     /**
400     * @dev Leaves the contract without owner. It will not be possible to call
401     * `onlyOwner` functions anymore. Can only be called by the current owner.
402     *
403     * NOTE: Renouncing ownership will leave the contract without an owner,
404     * thereby removing any functionality that is only available to the owner.
405     */
406     function renounceOwnership() public virtual onlyOwner {
407         emit OwnershipTransferred(_owner, address(0));
408         _owner = address(0);
409     }
410 
411     /**
412     * @dev Transfers ownership of the contract to a new account (`newOwner`).
413     * Can only be called by the current owner.
414     */
415     function transferOwnership(address newOwner) public virtual onlyOwner {
416         require(newOwner != address(0), "Ownable: new owner is the zero address");
417         emit OwnershipTransferred(_owner, newOwner);
418         _owner = newOwner;
419     }
420     
421 }
422 
423 interface IUniswapV2Factory {
424     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
425 
426     function feeTo() external view returns (address);
427     function feeToSetter() external view returns (address);
428 
429     function getPair(address tokenA, address tokenB) external view returns (address pair);
430     function allPairs(uint) external view returns (address pair);
431     function allPairsLength() external view returns (uint);
432 
433     function createPair(address tokenA, address tokenB) external returns (address pair);
434 
435     function setFeeTo(address) external;
436     function setFeeToSetter(address) external;
437 }
438 
439 interface IUniswapV2Pair {
440     event Approval(address indexed owner, address indexed spender, uint value);
441     event Transfer(address indexed from, address indexed to, uint value);
442 
443     function name() external pure returns (string memory);
444     function symbol() external pure returns (string memory);
445     function decimals() external pure returns (uint8);
446     function totalSupply() external view returns (uint);
447     function balanceOf(address owner) external view returns (uint);
448     function allowance(address owner, address spender) external view returns (uint);
449 
450     function approve(address spender, uint value) external returns (bool);
451     function transfer(address to, uint value) external returns (bool);
452     function transferFrom(address from, address to, uint value) external returns (bool);
453 
454     function DOMAIN_SEPARATOR() external view returns (bytes32);
455     function PERMIT_TYPEHASH() external pure returns (bytes32);
456     function nonces(address owner) external view returns (uint);
457 
458     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
459 
460     event Mint(address indexed sender, uint amount0, uint amount1);
461     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
462     event Swap(
463         address indexed sender,
464         uint amount0In,
465         uint amount1In,
466         uint amount0Out,
467         uint amount1Out,
468         address indexed to
469     );
470     event Sync(uint112 reserve0, uint112 reserve1);
471 
472     function MINIMUM_LIQUIDITY() external pure returns (uint);
473     function factory() external view returns (address);
474     function token0() external view returns (address);
475     function token1() external view returns (address);
476     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
477     function price0CumulativeLast() external view returns (uint);
478     function price1CumulativeLast() external view returns (uint);
479     function kLast() external view returns (uint);
480 
481     function mint(address to) external returns (uint liquidity);
482     function burn(address to) external returns (uint amount0, uint amount1);
483     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
484     function skim(address to) external;
485     function sync() external;
486 
487     function initialize(address, address) external;
488 }
489 
490 interface IUniswapV2Router01 {
491     function factory() external pure returns (address);
492     function WETH() external pure returns (address);
493 
494     function addLiquidity(
495         address tokenA,
496         address tokenB,
497         uint amountADesired,
498         uint amountBDesired,
499         uint amountAMin,
500         uint amountBMin,
501         address to,
502         uint deadline
503     ) external returns (uint amountA, uint amountB, uint liquidity);
504     function addLiquidityETH(
505         address token,
506         uint amountTokenDesired,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline
511     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
512     function removeLiquidity(
513         address tokenA,
514         address tokenB,
515         uint liquidity,
516         uint amountAMin,
517         uint amountBMin,
518         address to,
519         uint deadline
520     ) external returns (uint amountA, uint amountB);
521     function removeLiquidityETH(
522         address token,
523         uint liquidity,
524         uint amountTokenMin,
525         uint amountETHMin,
526         address to,
527         uint deadline
528     ) external returns (uint amountToken, uint amountETH);
529     function removeLiquidityWithPermit(
530         address tokenA,
531         address tokenB,
532         uint liquidity,
533         uint amountAMin,
534         uint amountBMin,
535         address to,
536         uint deadline,
537         bool approveMax, uint8 v, bytes32 r, bytes32 s
538     ) external returns (uint amountA, uint amountB);
539     function removeLiquidityETHWithPermit(
540         address token,
541         uint liquidity,
542         uint amountTokenMin,
543         uint amountETHMin,
544         address to,
545         uint deadline,
546         bool approveMax, uint8 v, bytes32 r, bytes32 s
547     ) external returns (uint amountToken, uint amountETH);
548     function swapExactTokensForTokens(
549         uint amountIn,
550         uint amountOutMin,
551         address[] calldata path,
552         address to,
553         uint deadline
554     ) external returns (uint[] memory amounts);
555     function swapTokensForExactTokens(
556         uint amountOut,
557         uint amountInMax,
558         address[] calldata path,
559         address to,
560         uint deadline
561     ) external returns (uint[] memory amounts);
562     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
563     external
564     payable
565     returns (uint[] memory amounts);
566     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
567     external
568     returns (uint[] memory amounts);
569     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
570     external
571     returns (uint[] memory amounts);
572     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
573     external
574     payable
575     returns (uint[] memory amounts);
576 
577     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
578     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
579     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
580     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
581     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
582 }
583 
584 interface IUniswapV2Router02 is IUniswapV2Router01 {
585     function removeLiquidityETHSupportingFeeOnTransferTokens(
586         address token,
587         uint liquidity,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external returns (uint amountETH);
593     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
594         address token,
595         uint liquidity,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline,
600         bool approveMax, uint8 v, bytes32 r, bytes32 s
601     ) external returns (uint amountETH);
602 
603     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
604         uint amountIn,
605         uint amountOutMin,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external;
610     function swapExactETHForTokensSupportingFeeOnTransferTokens(
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external payable;
616     function swapExactTokensForETHSupportingFeeOnTransferTokens(
617         uint amountIn,
618         uint amountOutMin,
619         address[] calldata path,
620         address to,
621         uint deadline
622     ) external;
623 }
624 
625 // Contract implementation
626 contract EthereumGod is Context, IERC20, Ownable {
627     using SafeMath for uint256;
628     using Address for address;
629 
630     mapping (address => uint256) private _rOwned;
631     mapping (address => uint256) private _tOwned;
632     mapping (address => mapping (address => uint256)) private _allowances;
633 
634     mapping (address => bool) private _isExcludedFromFee;
635 
636     mapping (address => bool) private _isExcluded; // excluded from reward
637     address[] private _excluded;
638     mapping (address => bool) private _isBlackListedBot;
639     address[] private _blackListedBots;
640 
641     uint256 private constant MAX = ~uint256(0);
642 
643     uint256 private _tTotal = 100_000_000_000_000 * 10**9;
644     uint256 private _rTotal = (MAX - (MAX % _tTotal));
645     uint256 private _tFeeTotal;
646 
647     string private _name = 'Ethereum God';
648     string private _symbol = 'EGOD';
649     uint8 private _decimals = 9;
650 
651     uint256 private _taxFee = 4; // 4% reflection fee for every holder
652     uint256 private _marketingFee = 2; // 2% marketing
653     uint256 private _liquidityFee = 4; // 4% into liquidity
654 
655     uint256 private _previousTaxFee = _taxFee;
656     uint256 private _previousMarketingFee = _marketingFee;
657     uint256 private _previousLiquidityFee = _liquidityFee;
658 
659     address payable private _marketingWalletAddress = payable(0x63a391e3b4174f63D3e45Dedf5044Ca2540E783f);
660 
661     IUniswapV2Router02 public immutable uniswapV2Router;
662     address public immutable uniswapV2Pair;
663 
664     bool inSwapAndLiquify = false;
665     bool public swapAndLiquifyEnabled = true;
666 
667     uint256 private _maxTxAmount = _tTotal / 1000;
668     // We will set a minimum amount of tokens to be swapped
669     uint256 private _numTokensSellToAddToLiquidity = 1000000000 * 10**9;
670 
671     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
672     event SwapAndLiquifyEnabledUpdated(bool enabled);
673     event SwapAndLiquify(
674         uint256 tokensSwapped,
675         uint256 ethReceived,
676         uint256 tokensIntoLiqudity
677     );
678 
679     modifier lockTheSwap {
680         inSwapAndLiquify = true;
681         _;
682         inSwapAndLiquify = false;
683     }
684 
685     constructor () public {
686         _rOwned[_msgSender()] = _rTotal;
687 
688         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
689         // Create a uniswap pair for this new token
690         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
691         .createPair(address(this), _uniswapV2Router.WETH());
692 
693         // set the rest of the contract variables
694         uniswapV2Router = _uniswapV2Router;
695 
696         // Exclude owner and this contract from fee
697         _isExcludedFromFee[owner()] = true;
698         _isExcludedFromFee[address(this)] = true;
699         _isExcludedFromFee[_marketingWalletAddress] = true;
700 
701         // BLACKLIST
702         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
703         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
704 
705         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
706         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
707 
708         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
709         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
710 
711         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
712         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
713 
714         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
715         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
716 
717         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
718         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
719 
720         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
721         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
722 
723         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
724         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
725 
726         emit Transfer(address(0), _msgSender(), _tTotal);
727     }
728 
729     function name() public view returns (string memory) {
730         return _name;
731     }
732 
733     function symbol() public view returns (string memory) {
734         return _symbol;
735     }
736 
737     function decimals() public view returns (uint8) {
738         return _decimals;
739     }
740 
741     function totalSupply() public view override returns (uint256) {
742         return _tTotal;
743     }
744 
745     function balanceOf(address account) public view override returns (uint256) {
746         if (_isExcluded[account]) return _tOwned[account];
747         return tokenFromReflection(_rOwned[account]);
748     }
749 
750     function transfer(address recipient, uint256 amount) public override returns (bool) {
751         _transfer(_msgSender(), recipient, amount);
752         return true;
753     }
754 
755     function allowance(address owner, address spender) public view override returns (uint256) {
756         return _allowances[owner][spender];
757     }
758 
759     function approve(address spender, uint256 amount) public override returns (bool) {
760         _approve(_msgSender(), spender, amount);
761         return true;
762     }
763 
764     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
765         _transfer(sender, recipient, amount);
766         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
767         return true;
768     }
769 
770     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
771         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
772         return true;
773     }
774 
775     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
776         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
777         return true;
778     }
779 
780     function isExcludedFromReward(address account) public view returns (bool) {
781         return _isExcluded[account];
782     }
783 
784     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
785         _isExcludedFromFee[account] = excluded;
786     }
787 
788     function totalFees() public view returns (uint256) {
789         return _tFeeTotal;
790     }
791 
792     function deliver(uint256 tAmount) public {
793         address sender = _msgSender();
794         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
795         (uint256 rAmount,,,,,) = _getValues(tAmount);
796         _rOwned[sender] = _rOwned[sender].sub(rAmount);
797         _rTotal = _rTotal.sub(rAmount);
798         _tFeeTotal = _tFeeTotal.add(tAmount);
799     }
800 
801     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
802         require(tAmount <= _tTotal, "Amount must be less than supply");
803         if (!deductTransferFee) {
804             (uint256 rAmount,,,,,) = _getValues(tAmount);
805             return rAmount;
806         } else {
807             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
808             return rTransferAmount;
809         }
810     }
811 
812     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
813         require(rAmount <= _rTotal, "Amount must be less than total reflections");
814         uint256 currentRate =  _getRate();
815         return rAmount.div(currentRate);
816     }
817 
818     function excludeFromReward(address account) external onlyOwner() {
819         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
820         require(!_isExcluded[account], "Account is already excluded");
821         if(_rOwned[account] > 0) {
822             _tOwned[account] = tokenFromReflection(_rOwned[account]);
823         }
824         _isExcluded[account] = true;
825         _excluded.push(account);
826     }
827 
828     function includeInReward(address account) external onlyOwner() {
829         require(_isExcluded[account], "Account is already excluded");
830         for (uint256 i = 0; i < _excluded.length; i++) {
831             if (_excluded[i] == account) {
832                 _excluded[i] = _excluded[_excluded.length - 1];
833                 _tOwned[account] = 0;
834                 _isExcluded[account] = false;
835                 _excluded.pop();
836                 break;
837             }
838         }
839     }
840 
841     function addBotToBlackList(address account) external onlyOwner() {
842         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
843         require(!_isBlackListedBot[account], "Account is already blacklisted");
844         _isBlackListedBot[account] = true;
845         _blackListedBots.push(account);
846     }
847 
848     function removeBotFromBlackList(address account) external onlyOwner() {
849         require(_isBlackListedBot[account], "Account is not blacklisted");
850         for (uint256 i = 0; i < _blackListedBots.length; i++) {
851             if (_blackListedBots[i] == account) {
852                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
853                 _isBlackListedBot[account] = false;
854                 _blackListedBots.pop();
855                 break;
856             }
857         }
858     }
859 
860     function removeAllFee() private {
861         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
862 
863         _previousTaxFee = _taxFee;
864         _previousMarketingFee = _marketingFee;
865         _previousLiquidityFee = _liquidityFee;
866 
867         _taxFee = 0;
868         _marketingFee = 0;
869         _liquidityFee = 0;
870     }
871 
872     function restoreAllFee() private {
873         _taxFee = _previousTaxFee;
874         _marketingFee = _previousMarketingFee;
875         _liquidityFee = _previousLiquidityFee;
876     }
877 
878     function isExcludedFromFee(address account) public view returns(bool) {
879         return _isExcludedFromFee[account];
880     }
881 
882     function _approve(address owner, address spender, uint256 amount) private {
883         require(owner != address(0), "ERC20: approve from the zero address");
884         require(spender != address(0), "ERC20: approve to the zero address");
885 
886         _allowances[owner][spender] = amount;
887         emit Approval(owner, spender, amount);
888     }
889 
890     function _transfer(address sender, address recipient, uint256 amount) private {
891         require(sender != address(0), "ERC20: transfer from the zero address");
892         require(recipient != address(0), "ERC20: transfer to the zero address");
893         require(amount > 0, "Transfer amount must be greater than zero");
894         require(!_isBlackListedBot[sender], "You have no power here!");
895         require(!_isBlackListedBot[recipient], "You have no power here!");
896         require(!_isBlackListedBot[tx.origin], "You have no power here!");
897 
898         if(sender != owner() && recipient != owner()) {
899             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
900         }
901 
902         // is the token balance of this contract address over the min number of
903         // tokens that we need to initiate a swap + liquidity lock?
904         // also, don't get caught in a circular liquidity event.
905         // also, don't swap & liquify if sender is uniswap pair.
906         uint256 contractTokenBalance = balanceOf(address(this));
907 
908         if(contractTokenBalance >= _maxTxAmount)
909         {
910             contractTokenBalance = _maxTxAmount;
911         }
912 
913         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
914         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
915             contractTokenBalance = _numTokensSellToAddToLiquidity;
916             //add liquidity
917             swapAndLiquify(contractTokenBalance);
918         }
919 
920         //indicates if fee should be deducted from transfer
921         bool takeFee = true;
922 
923         //if any account belongs to _isExcludedFromFee account then remove the fee
924         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
925             takeFee = false;
926         }
927 
928         //transfer amount, it will take tax and charity fee
929         _tokenTransfer(sender, recipient, amount, takeFee);
930     }
931 
932     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
933         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
934         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
935 
936         // split the contract balance into halves
937         uint256 half = toLiquify.div(2);
938         uint256 otherHalf = toLiquify.sub(half);
939 
940         // capture the contract's current ETH balance.
941         // this is so that we can capture exactly the amount of ETH that the
942         // swap creates, and not make the liquidity event include any ETH that
943         // has been manually sent to the contract
944         uint256 initialBalance = address(this).balance;
945 
946         // swap tokens for ETH
947         uint256 toSwapForEth = half.add(toMarketing);
948         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
949 
950         // how much ETH did we just swap into?
951         uint256 fromSwap = address(this).balance.sub(initialBalance);
952         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
953 
954         // add liquidity to uniswap
955         addLiquidity(otherHalf, newBalance);
956 
957         emit SwapAndLiquify(half, newBalance, otherHalf);
958 
959         sendETHToMarketing(fromSwap.sub(newBalance));
960     }
961 
962     function swapTokensForEth(uint256 tokenAmount) private {
963         // generate the uniswap pair path of token -> weth
964         address[] memory path = new address[](2);
965         path[0] = address(this);
966         path[1] = uniswapV2Router.WETH();
967 
968         _approve(address(this), address(uniswapV2Router), tokenAmount);
969 
970         // make the swap
971         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
972             tokenAmount,
973             0, // accept any amount of ETH
974             path,
975             address(this),
976             block.timestamp
977         );
978     }
979 
980     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
981         // approve token transfer to cover all possible scenarios
982         _approve(address(this), address(uniswapV2Router), tokenAmount);
983 
984         // add the liquidity
985         uniswapV2Router.addLiquidityETH{value: ethAmount}(
986             address(this),
987             tokenAmount,
988             0, // slippage is unavoidable
989             0, // slippage is unavoidable
990             owner(),
991             block.timestamp
992         );
993     }
994 
995     function sendETHToMarketing(uint256 amount) private {
996         _marketingWalletAddress.transfer(amount);
997     }
998 
999     // We are exposing these functions to be able to manual swap and send
1000     // in case the token is highly valued and 5M becomes too much
1001     function manualSwap() external onlyOwner() {
1002         uint256 contractBalance = balanceOf(address(this));
1003         swapTokensForEth(contractBalance);
1004     }
1005 
1006     function manualSend() public onlyOwner() {
1007         uint256 contractETHBalance = address(this).balance;
1008         sendETHToMarketing(contractETHBalance);
1009     }
1010 
1011     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1012         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1013     }
1014 
1015     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1016         if(!takeFee)
1017             removeAllFee();
1018 
1019         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1020             _transferFromExcluded(sender, recipient, amount);
1021         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1022             _transferToExcluded(sender, recipient, amount);
1023         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1024             _transferStandard(sender, recipient, amount);
1025         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1026             _transferBothExcluded(sender, recipient, amount);
1027         } else {
1028             _transferStandard(sender, recipient, amount);
1029         }
1030 
1031         if(!takeFee)
1032             restoreAllFee();
1033     }
1034 
1035     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1036         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1037         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1038         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1039         _takeMarketingLiquidity(tMarketingLiquidity);
1040         _reflectFee(rFee, tFee);
1041         emit Transfer(sender, recipient, tTransferAmount);
1042     }
1043 
1044     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1045         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1046         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1047         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1048         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1049         _takeMarketingLiquidity(tMarketingLiquidity);
1050         _reflectFee(rFee, tFee);
1051         emit Transfer(sender, recipient, tTransferAmount);
1052     }
1053 
1054     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1055         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1056         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1057         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1058         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1059         _takeMarketingLiquidity(tMarketingLiquidity);
1060         _reflectFee(rFee, tFee);
1061         emit Transfer(sender, recipient, tTransferAmount);
1062     }
1063 
1064     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1065         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1066         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1067         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1068         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1069         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1070         _takeMarketingLiquidity(tMarketingLiquidity);
1071         _reflectFee(rFee, tFee);
1072         emit Transfer(sender, recipient, tTransferAmount);
1073     }
1074 
1075     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1076         uint256 currentRate = _getRate();
1077         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1078         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1079         if(_isExcluded[address(this)])
1080             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1081     }
1082 
1083     function _reflectFee(uint256 rFee, uint256 tFee) private {
1084         _rTotal = _rTotal.sub(rFee);
1085         _tFeeTotal = _tFeeTotal.add(tFee);
1086     }
1087 
1088     //to recieve ETH from uniswapV2Router when swapping
1089     receive() external payable {}
1090 
1091     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1092         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1093         uint256 currentRate = _getRate();
1094         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1095         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1096     }
1097 
1098     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1099         uint256 tFee = tAmount.mul(taxFee).div(100);
1100         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1101         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1102         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1103     }
1104 
1105     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1106         uint256 rAmount = tAmount.mul(currentRate);
1107         uint256 rFee = tFee.mul(currentRate);
1108         uint256 rTransferAmount = rAmount.sub(rFee);
1109         return (rAmount, rTransferAmount, rFee);
1110     }
1111 
1112     function _getRate() private view returns(uint256) {
1113         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1114         return rSupply.div(tSupply);
1115     }
1116 
1117     function _getCurrentSupply() private view returns(uint256, uint256) {
1118         uint256 rSupply = _rTotal;
1119         uint256 tSupply = _tTotal;
1120         for (uint256 i = 0; i < _excluded.length; i++) {
1121             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1122             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1123             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1124         }
1125         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1126         return (rSupply, tSupply);
1127     }
1128 
1129     function _getTaxFee() private view returns(uint256) {
1130         return _taxFee;
1131     }
1132 
1133     function _getMaxTxAmount() private view returns(uint256) {
1134         return _maxTxAmount / 10**9;
1135     }
1136 
1137     function _getETHBalance() public view returns(uint256 balance) {
1138         return address(this).balance;
1139     }
1140 
1141     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1142         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1143         _taxFee = taxFee;
1144     }
1145 
1146     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1147         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1148         _marketingFee = marketingFee;
1149     }
1150 
1151     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1152         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1153         _liquidityFee = liquidityFee;
1154     }
1155 
1156     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1157         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1158         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1159     }
1160 
1161     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1162         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1163             10**3 // Division by 1000, set to 20 for 2%, set to 2 for 0.2%
1164         );
1165     }
1166 
1167     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1168         _approve(address(this), owner(), tokenAmount);
1169         _transfer(address(this), owner(), tokenAmount);
1170     }
1171 }