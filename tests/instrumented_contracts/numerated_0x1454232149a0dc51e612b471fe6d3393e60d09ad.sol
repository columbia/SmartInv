1 /**
2 *Submitted for verification at Etherscan.io on 2021-11-29
3 */
4 
5 /**
6 Multi-Chain Capital: $MCC
7 You buy on Ethereum. Farmers gain incentives to farm on multiple chains and return the profits to $MCC holders through buybacks.
8 
9 Tokenomics:
10 10% of each buy is proportionally distributed to existing holders via "reflections".
11 10% of each sell goes into multi-chain farming to add to the treasury and buy back MCC tokens.
12 
13 Website (Web 3.0):
14 ipfs://multichaincapital.eth
15 
16 Website (Web 2.5):
17 https://multichaincapital.eth.limo
18 
19 Website (Web 2.0):
20 https://mcc.holdings
21 
22 Telegram:
23 https://t.me/MultiChainCapital
24 
25 Twitter:
26 https://twitter.com/MulChainCapital
27 
28 Medium:
29 https://multichaincapital.medium.com
30 */
31 
32 // SPDX-License-Identifier: Unlicensed
33 pragma solidity ^0.6.12;
34 
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address payable) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 interface IERC20 {
47     /**
48     * @dev Returns the amount of tokens in existence.
49     */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53     * @dev Returns the amount of tokens owned by `account`.
54     */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58     * @dev Moves `amount` tokens from the caller's account to `recipient`.
59     *
60     * Returns a boolean value indicating whether the operation succeeded.
61     *
62     * Emits a {Transfer} event.
63     */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67     * @dev Returns the remaining number of tokens that `spender` will be
68     * allowed to spend on behalf of `owner` through {transferFrom}. This is
69     * zero by default.
70     *
71     * This value changes when {approve} or {transferFrom} are called.
72     */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77     *
78     * Returns a boolean value indicating whether the operation succeeded.
79     *
80     * IMPORTANT: Beware that changing an allowance with this method brings the risk
81     * that someone may use both the old and the new allowance by unfortunate
82     * transaction ordering. One possible solution to mitigate this race
83     * condition is to first reduce the spender's allowance to 0 and set the
84     * desired value afterwards:
85     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86     *
87     * Emits an {Approval} event.
88     */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92     * @dev Moves `amount` tokens from `sender` to `recipient` using the
93     * allowance mechanism. `amount` is then deducted from the caller's
94     * allowance.
95     *
96     * Returns a boolean value indicating whether the operation succeeded.
97     *
98     * Emits a {Transfer} event.
99     */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103     * @dev Emitted when `value` tokens are moved from one account (`from`) to
104     * another (`to`).
105     *
106     * Note that `value` may be zero.
107     */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112     * a call to {approve}. `value` is the new allowance.
113     */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 library SafeMath {
118     /**
119     * @dev Returns the addition of two unsigned integers, reverting on
120     * overflow.
121     *
122     * Counterpart to Solidity's `+` operator.
123     *
124     * Requirements:
125     *
126     * - Addition cannot overflow.
127     */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136     * @dev Returns the subtraction of two unsigned integers, reverting on
137     * overflow (when the result is negative).
138     *
139     * Counterpart to Solidity's `-` operator.
140     *
141     * Requirements:
142     *
143     * - Subtraction cannot overflow.
144     */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151     * overflow (when the result is negative).
152     *
153     * Counterpart to Solidity's `-` operator.
154     *
155     * Requirements:
156     *
157     * - Subtraction cannot overflow.
158     */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167     * @dev Returns the multiplication of two unsigned integers, reverting on
168     * overflow.
169     *
170     * Counterpart to Solidity's `*` operator.
171     *
172     * Requirements:
173     *
174     * - Multiplication cannot overflow.
175     */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191     * @dev Returns the integer division of two unsigned integers. Reverts on
192     * division by zero. The result is rounded towards zero.
193     *
194     * Counterpart to Solidity's `/` operator. Note: this function uses a
195     * `revert` opcode (which leaves remaining gas untouched) while Solidity
196     * uses an invalid opcode to revert (consuming all remaining gas).
197     *
198     * Requirements:
199     *
200     * - The divisor cannot be zero.
201     */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208     * division by zero. The result is rounded towards zero.
209     *
210     * Counterpart to Solidity's `/` operator. Note: this function uses a
211     * `revert` opcode (which leaves remaining gas untouched) while Solidity
212     * uses an invalid opcode to revert (consuming all remaining gas).
213     *
214     * Requirements:
215     *
216     * - The divisor cannot be zero.
217     */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228     * Reverts when dividing by zero.
229     *
230     * Counterpart to Solidity's `%` operator. This function uses a `revert`
231     * opcode (which leaves remaining gas untouched) while Solidity uses an
232     * invalid opcode to revert (consuming all remaining gas).
233     *
234     * Requirements:
235     *
236     * - The divisor cannot be zero.
237     */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244     * Reverts with custom message when dividing by zero.
245     *
246     * Counterpart to Solidity's `%` operator. This function uses a `revert`
247     * opcode (which leaves remaining gas untouched) while Solidity uses an
248     * invalid opcode to revert (consuming all remaining gas).
249     *
250     * Requirements:
251     *
252     * - The divisor cannot be zero.
253     */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 library Address {
261     /**
262     * @dev Returns true if `account` is a contract.
263     *
264     * [IMPORTANT]
265     * ====
266     * It is unsafe to assume that an address for which this function returns
267     * false is an externally-owned account (EOA) and not a contract.
268     *
269     * Among others, `isContract` will return false for the following
270     * types of addresses:
271     *
272     *  - an externally-owned account
273     *  - a contract in construction
274     *  - an address where a contract will be created
275     *  - an address where a contract lived, but was destroyed
276     * ====
277     */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291     * `recipient`, forwarding all available gas and reverting on errors.
292     *
293     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294     * of certain opcodes, possibly making contracts go over the 2300 gas limit
295     * imposed by `transfer`, making them unable to receive funds via
296     * `transfer`. {sendValue} removes this limitation.
297     *
298     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299     *
300     * IMPORTANT: because control is transferred to `recipient`, care must be
301     * taken to not create reentrancy vulnerabilities. Consider using
302     * {ReentrancyGuard} or the
303     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304     */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314     * @dev Performs a Solidity function call using a low level `call`. A
315     * plain`call` is an unsafe replacement for a function call: use this
316     * function instead.
317     *
318     * If `target` reverts with a revert reason, it is bubbled up by this
319     * function (like regular Solidity function calls).
320     *
321     * Returns the raw returned data. To convert to the expected return value,
322     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323     *
324     * Requirements:
325     *
326     * - `target` must be a contract.
327     * - calling `target` with `data` must not revert.
328     *
329     * _Available since v3.1._
330     */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332     return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337     * `errorMessage` as a fallback revert reason when `target` reverts.
338     *
339     * _Available since v3.1._
340     */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347     * but also transferring `value` wei to `target`.
348     *
349     * Requirements:
350     *
351     * - the calling contract must have an ETH balance of at least `value`.
352     * - the called Solidity function must be `payable`.
353     *
354     * _Available since v3.1._
355     */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362     * with `errorMessage` as a fallback revert reason when `target` reverts.
363     *
364     * _Available since v3.1._
365     */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 contract Ownable is Context {
396     address private _owner;
397     address private _previousOwner;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402     * @dev Initializes the contract setting the deployer as the initial owner.
403     */
404     constructor () internal {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411     * @dev Returns the address of the current owner.
412     */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418     * @dev Throws if called by any account other than the owner.
419     */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426     * @dev Leaves the contract without owner. It will not be possible to call
427     * `onlyOwner` functions anymore. Can only be called by the current owner.
428     *
429     * NOTE: Renouncing ownership will leave the contract without an owner,
430     * thereby removing any functionality that is only available to the owner.
431     */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438     * @dev Transfers ownership of the contract to a new account (`newOwner`).
439     * Can only be called by the current owner.
440     */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 
447 
448 }
449 
450 interface IUniswapV2Factory {
451     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
452 
453     function feeTo() external view returns (address);
454     function feeToSetter() external view returns (address);
455 
456     function getPair(address tokenA, address tokenB) external view returns (address pair);
457     function allPairs(uint) external view returns (address pair);
458     function allPairsLength() external view returns (uint);
459 
460     function createPair(address tokenA, address tokenB) external returns (address pair);
461 
462     function setFeeTo(address) external;
463     function setFeeToSetter(address) external;
464 }
465 
466 interface IUniswapV2Pair {
467     event Approval(address indexed owner, address indexed spender, uint value);
468     event Transfer(address indexed from, address indexed to, uint value);
469 
470     function name() external pure returns (string memory);
471     function symbol() external pure returns (string memory);
472     function decimals() external pure returns (uint8);
473     function totalSupply() external view returns (uint);
474     function balanceOf(address owner) external view returns (uint);
475     function allowance(address owner, address spender) external view returns (uint);
476 
477     function approve(address spender, uint value) external returns (bool);
478     function transfer(address to, uint value) external returns (bool);
479     function transferFrom(address from, address to, uint value) external returns (bool);
480 
481     function DOMAIN_SEPARATOR() external view returns (bytes32);
482     function PERMIT_TYPEHASH() external pure returns (bytes32);
483     function nonces(address owner) external view returns (uint);
484 
485     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
486 
487     event Mint(address indexed sender, uint amount0, uint amount1);
488     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
489     event Swap(
490         address indexed sender,
491         uint amount0In,
492         uint amount1In,
493         uint amount0Out,
494         uint amount1Out,
495         address indexed to
496     );
497     event Sync(uint112 reserve0, uint112 reserve1);
498 
499     function MINIMUM_LIQUIDITY() external pure returns (uint);
500     function factory() external view returns (address);
501     function token0() external view returns (address);
502     function token1() external view returns (address);
503     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
504     function price0CumulativeLast() external view returns (uint);
505     function price1CumulativeLast() external view returns (uint);
506     function kLast() external view returns (uint);
507 
508     function mint(address to) external returns (uint liquidity);
509     function burn(address to) external returns (uint amount0, uint amount1);
510     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
511     function skim(address to) external;
512     function sync() external;
513 
514     function initialize(address, address) external;
515 }
516 
517 interface IUniswapV2Router01 {
518     function factory() external pure returns (address);
519     function WETH() external pure returns (address);
520 
521     function addLiquidity(
522         address tokenA,
523         address tokenB,
524         uint amountADesired,
525         uint amountBDesired,
526         uint amountAMin,
527         uint amountBMin,
528         address to,
529         uint deadline
530     ) external returns (uint amountA, uint amountB, uint liquidity);
531     function addLiquidityETH(
532         address token,
533         uint amountTokenDesired,
534         uint amountTokenMin,
535         uint amountETHMin,
536         address to,
537         uint deadline
538     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
539     function removeLiquidity(
540         address tokenA,
541         address tokenB,
542         uint liquidity,
543         uint amountAMin,
544         uint amountBMin,
545         address to,
546         uint deadline
547     ) external returns (uint amountA, uint amountB);
548     function removeLiquidityETH(
549         address token,
550         uint liquidity,
551         uint amountTokenMin,
552         uint amountETHMin,
553         address to,
554         uint deadline
555     ) external returns (uint amountToken, uint amountETH);
556     function removeLiquidityWithPermit(
557         address tokenA,
558         address tokenB,
559         uint liquidity,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline,
564         bool approveMax, uint8 v, bytes32 r, bytes32 s
565     ) external returns (uint amountA, uint amountB);
566     function removeLiquidityETHWithPermit(
567         address token,
568         uint liquidity,
569         uint amountTokenMin,
570         uint amountETHMin,
571         address to,
572         uint deadline,
573         bool approveMax, uint8 v, bytes32 r, bytes32 s
574     ) external returns (uint amountToken, uint amountETH);
575     function swapExactTokensForTokens(
576         uint amountIn,
577         uint amountOutMin,
578         address[] calldata path,
579         address to,
580         uint deadline
581     ) external returns (uint[] memory amounts);
582     function swapTokensForExactTokens(
583         uint amountOut,
584         uint amountInMax,
585         address[] calldata path,
586         address to,
587         uint deadline
588     ) external returns (uint[] memory amounts);
589     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
590         external
591         payable
592         returns (uint[] memory amounts);
593     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
594         external
595         returns (uint[] memory amounts);
596     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
597         external
598         returns (uint[] memory amounts);
599     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
600         external
601         payable
602         returns (uint[] memory amounts);
603 
604     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
605     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
606     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
607     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
608     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
609 }
610 
611 interface IUniswapV2Router02 is IUniswapV2Router01 {
612     function removeLiquidityETHSupportingFeeOnTransferTokens(
613         address token,
614         uint liquidity,
615         uint amountTokenMin,
616         uint amountETHMin,
617         address to,
618         uint deadline
619     ) external returns (uint amountETH);
620     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline,
627         bool approveMax, uint8 v, bytes32 r, bytes32 s
628     ) external returns (uint amountETH);
629 
630     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
631         uint amountIn,
632         uint amountOutMin,
633         address[] calldata path,
634         address to,
635         uint deadline
636     ) external;
637     function swapExactETHForTokensSupportingFeeOnTransferTokens(
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external payable;
643     function swapExactTokensForETHSupportingFeeOnTransferTokens(
644         uint amountIn,
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external;
650 }
651 
652 contract MultiChainCapitalV2 is Context, IERC20, Ownable {
653     using SafeMath for uint256;
654     using Address for address;
655 
656     /**
657       * [ADDRESS MAPPINGS]
658       *
659       */
660 
661     mapping (address => uint256) private _rOwned;
662     mapping (address => uint256) private _tOwned;
663     mapping (address => mapping (address => uint256)) private _allowances;
664 
665     mapping (address => bool) private _isExcludedFromFee;
666 
667     mapping (address => bool) private _isMultisig;
668 
669     address[] private multisigParties;
670 
671     bool public multisigDestroyed = false;
672 
673     struct TreasuryNomination {
674         address nominee;
675         bool valid;
676     }
677 
678     struct WhitelistNomination {
679         address nominee;
680         bool valid;
681     }
682 
683     struct DestructionNomination {
684         bool valid;
685     }
686 
687     mapping (address => TreasuryNomination) private _treasuryNominations;
688 
689     mapping (address => WhitelistNomination) private _whitelistNominations;
690 
691     mapping (address => DestructionNomination) private _destructionNominations;
692 
693     /**
694       * [MISC. VARIABLES]
695       *
696       */
697 
698     uint256 private constant MAX = ~uint256(0);
699     uint256 private _tTotal = 1000000000000 * 10**9;
700     uint256 private _rTotal = (MAX - (MAX % _tTotal));
701     uint256 private _tFeeTotal;
702 
703     string private _name = 'MultiChainCapital';
704     string private _symbol = 'MCC';
705     uint8 private _decimals = 9;
706 
707     uint256 private _taxFee = 10;
708     uint256 private _teamFee = 10;
709     uint256 private _previousTaxFee = _taxFee;
710     uint256 private _previousTeamFee = _teamFee;
711 
712     address payable public MCCTreasury;
713 
714     IUniswapV2Router02 public immutable uniswapV2Router;
715     address public immutable uniswapV2Pair;
716 
717     bool inSwap = false;
718     bool public swapEnabled = true;
719 
720     // Has the treasury been linked yet:
721     bool treasuryLinked = false;
722 
723     uint256 private _maxTxAmount = 100000000000000e9;
724     // We will set a minimum amount of tokens to be swaped => 5M
725     uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
726 
727     /**
728       * [EVENTS]
729       *
730       */
731 
732     event MinTokensBeforeSwapUpdated(
733         uint256 minTokensBeforeSwap
734     );
735     event SwapEnabledUpdated(
736         bool enabled
737     );
738 
739     /**
740       * [MODIFIERS]
741       *
742       */
743 
744     modifier lockTheSwap {
745         inSwap = true;
746         _;
747         inSwap = false;
748     }
749 
750     modifier onlyMultisig {
751         require(_isMultisig[msg.sender], "You are not a multisig party.");
752         _;
753     }
754 
755     /**
756       * [CONSTRUCTOR]
757       *
758       */
759 
760     constructor (
761         address payable _MCCTreasury,
762         address[] memory _multisigParties
763         //IUniswapV2Router02 _uniswapV2Router
764     ) public {
765         require(_multisigParties.length == 7, "There must be 7 multisig parties.");
766 
767         MCCTreasury = _MCCTreasury;
768         _rOwned[_msgSender()] = _rTotal;
769 
770         multisigParties = _multisigParties;
771         for (uint8 i = 0; i < multisigParties.length; i++) {
772             _isMultisig[multisigParties[i]] = true;
773         }
774 
775         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
776         // Create a uniswap pair for this new token
777         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
778 
779         // set the rest of the contract variables
780         uniswapV2Router = _uniswapV2Router;
781 
782         // Exclude contract from fee
783         _isExcludedFromFee[address(this)] = true;
784 
785         emit Transfer(
786             address(0),
787             _msgSender(),
788             _tTotal
789         );
790     }
791 
792     /**
793       * [STANDARD ERC20 FUNCTIONS]
794       *
795       */
796 
797     function name() public view returns (string memory) {
798         return _name;
799     }
800 
801     function symbol() public view returns (string memory) {
802         return _symbol;
803     }
804 
805     function decimals() public view returns (uint8) {
806         return _decimals;
807     }
808 
809     function totalSupply() public view override returns (uint256) {
810         return _tTotal;
811     }
812 
813     function balanceOf(
814         address account
815     ) public view override returns (uint256) {
816         return tokenFromReflection(_rOwned[account]);
817     }
818 
819     function transfer(
820         address recipient,
821         uint256 amount
822     ) public override returns (bool) {
823         _transfer(_msgSender(), recipient, amount);
824         return true;
825     }
826 
827     function allowance(
828         address owner,
829         address spender
830     ) public view override returns (uint256) {
831         return _allowances[owner][spender];
832     }
833 
834     function approve(
835         address spender,
836         uint256 amount
837     ) public override returns (bool) {
838         _approve(_msgSender(), spender, amount);
839         return true;
840     }
841 
842     function transferFrom(
843         address sender,
844         address recipient,
845         uint256 amount
846     ) public override returns (bool) {
847         _transfer(sender, recipient, amount);
848         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
849         return true;
850     }
851 
852     /**
853       * [ALLOWANCE FUNCTIONS]
854       *
855       */
856 
857     function increaseAllowance(
858         address spender,
859         uint256 addedValue
860     ) public virtual returns (bool) {
861         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
862         return true;
863     }
864 
865     function decreaseAllowance(
866         address spender,
867         uint256 subtractedValue
868     ) public virtual returns (bool) {
869         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
870         return true;
871     }
872 
873     /**
874       * [TAX WHITELIST FUNCTIONS]
875       *
876       */
877 
878     function isExcludedFromFee(
879         address account
880     ) public view returns (bool) {
881         return _isExcludedFromFee[account];
882     }
883 
884     /**
885       * [BUY TAX (REFLECTION) FUNCTIONS]
886       *
887       */
888 
889     function reflectionFromToken(
890         uint256 tAmount,
891         bool deductTransferFee
892     ) public view returns (uint256) {
893         require(tAmount <= _tTotal, "Amount must be less than supply");
894         if (!deductTransferFee) {
895             (uint256 rAmount,,,,,,) = _getValues(tAmount);
896             return rAmount;
897         } else {
898             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
899             return rTransferAmount;
900         }
901     }
902 
903     function tokenFromReflection(
904         uint256 rAmount
905     ) public view returns (uint256) {
906         require(rAmount <= _rTotal, "Amount must be less than total reflections");
907         uint256 currentRate =  _getRate();
908         return rAmount.div(currentRate);
909     }
910 
911     function deliver(
912         uint256 tAmount
913     ) public {
914         address sender = _msgSender();
915         (uint256 rAmount,,,,,,) = _getValues(tAmount);
916         _rOwned[sender] = _rOwned[sender].sub(rAmount);
917         _rTotal = _rTotal.sub(rAmount);
918         _tFeeTotal = _tFeeTotal.add(tAmount);
919     }
920 
921     /**
922       * [SELL TAX FUNCTIONS]
923       *
924       */
925 
926     function sendETHToTeam(
927         uint256 amount
928     ) private {
929         MCCTreasury.transfer(amount);
930     }
931 
932 
933     /**
934       * [UTILITY FUNCTIONS]
935       *
936       */
937 
938     function removeAllFee() private {
939         if(_taxFee == 0 && _teamFee == 0) return;
940 
941         _previousTaxFee = _taxFee;
942         _previousTeamFee = _teamFee;
943 
944         _taxFee = 0;
945         _teamFee = 0;
946     }
947 
948     function restoreAllFee() private {
949         _taxFee = _previousTaxFee;
950         _teamFee = _previousTeamFee;
951     }
952 
953     /**
954       * [CUSTOM STANDARD FUNCTION EXTENSIONS]
955       *
956       */
957 
958     function _approve(
959         address owner,
960         address spender,
961         uint256 amount
962     ) private {
963         require(owner != address(0), "ERC20: approve from the zero address");
964         require(spender != address(0), "ERC20: approve to the zero address");
965 
966         _allowances[owner][spender] = amount;
967         emit Approval(owner, spender, amount);
968     }
969 
970     function _transfer(
971         address sender,
972         address recipient,
973         uint256 amount
974     ) private {
975         require(sender != address(0), "ERC20: transfer from the zero address");
976         require(recipient != address(0), "ERC20: transfer to the zero address");
977         require(amount > 0, "Transfer amount must be greater than zero");
978 
979         if (sender != owner() && recipient != owner()) {
980             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
981         }
982 
983         // is the token balance of this contract address over the min number of
984         // tokens that we need to initiate a swap?
985         // also, don't get caught in a circular team event.
986         // also, don't swap if sender is uniswap pair.
987         uint256 contractTokenBalance = balanceOf(address(this));
988 
989         if (contractTokenBalance >= _maxTxAmount) {
990             contractTokenBalance = _maxTxAmount;
991         }
992 
993         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
994         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
995             // We need to swap the current tokens to ETH and send to the team wallet
996             swapTokensForEth(contractTokenBalance);
997 
998             uint256 contractETHBalance = address(this).balance;
999             if(contractETHBalance > 0) {
1000                 sendETHToTeam(address(this).balance);
1001             }
1002         }
1003 
1004         //indicates if fee should be deducted from transfer
1005         bool takeFee = true;
1006 
1007         //if any account belongs to _isExcludedFromFee account then remove the fee
1008         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1009             takeFee = false;
1010         }
1011 
1012         //transfer amount, it will take tax and team fee
1013         _tokenTransfer(sender,recipient,amount,takeFee);
1014     }
1015 
1016     function _tokenTransfer(
1017         address sender,
1018         address recipient,
1019         uint256 amount,
1020         bool takeFee
1021     ) private {
1022         if(!takeFee) {
1023             removeAllFee();
1024         }
1025 
1026         _transferStandard(sender, recipient, amount);
1027 
1028         if(!takeFee) {
1029             restoreAllFee();
1030         }
1031     }
1032 
1033     function _transferStandard(
1034         address sender,
1035         address recipient,
1036         uint256 tAmount
1037     ) private {
1038         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rTeam, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1039         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1040         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1041         _takeTeam(rTeam);
1042         _reflectFee(rFee, tFee);
1043         emit Transfer(sender, recipient, tTransferAmount);
1044     }
1045 
1046     /**
1047       * [UNISWAP V2 FUNCTIONS]
1048       *
1049       */
1050 
1051     function swapTokensForEth(
1052         uint256 tokenAmount
1053     ) private lockTheSwap{
1054         // generate the uniswap pair path of token -> weth
1055         address[] memory path = new address[](2);
1056         path[0] = address(this);
1057         path[1] = uniswapV2Router.WETH();
1058 
1059         _approve(address(this), address(uniswapV2Router), tokenAmount);
1060 
1061         // make the swap
1062         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1063             tokenAmount,
1064             0, // accept any amount of ETH
1065             path,
1066             address(this),
1067             block.timestamp
1068         );
1069     }
1070 
1071     //to recieve ETH from uniswapV2Router when swaping
1072     receive() external payable {}
1073 
1074     /**
1075       * [MISC. PRIVATE FEE FUNCTIONS]
1076       *
1077       */
1078 
1079     function _takeTeam(
1080         uint256 rTeam
1081     ) private {
1082         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1083     }
1084 
1085     function _reflectFee(
1086         uint256 rFee,
1087         uint256 tFee
1088     ) private {
1089         _rTotal = _rTotal.sub(rFee);
1090         _tFeeTotal = _tFeeTotal.add(tFee);
1091     }
1092 
1093     /**
1094       * [PRIVATE PURE FUNCTIONS]
1095       *
1096       */
1097 
1098     function _getTValues(
1099         uint256 tAmount,
1100         uint256 taxFee,
1101         uint256 teamFee
1102     ) private pure returns (uint256, uint256, uint256) {
1103         uint256 tFee = tAmount.mul(taxFee).div(100);
1104         uint256 tTeam = tAmount.mul(teamFee).div(100);
1105         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1106         return (tTransferAmount, tFee, tTeam);
1107     }
1108 
1109     function _getRValues(
1110         uint256 tAmount,
1111         uint256 tFee,
1112         uint256 tTeam,
1113         uint256 currentRate
1114     ) private pure returns (uint256, uint256, uint256, uint256) {
1115         uint256 rAmount = tAmount.mul(currentRate);
1116         uint256 rFee = tFee.mul(currentRate);
1117         uint256 rTeam = tTeam.mul(currentRate);
1118         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1119         return (rAmount, rTransferAmount, rFee, rTeam);
1120     }
1121 
1122     /**
1123       * [PRIVATE VIEW FUNCTIONS]
1124       *
1125       */
1126 
1127     function _getValues(
1128         uint256 tAmount
1129     ) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1130         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1131         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rTeam) = _getRValues(tAmount, tFee, tTeam, _getRate());
1132         return (rAmount, rTransferAmount, rFee, rTeam, tTransferAmount, tFee, tTeam);
1133     }
1134 
1135     function _getRate() private view returns (uint256) {
1136         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1137         return rSupply.div(tSupply);
1138     }
1139 
1140     function _getCurrentSupply() private view returns (uint256, uint256) {
1141         uint256 rSupply = _rTotal;
1142         uint256 tSupply = _tTotal;
1143         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1144         return (rSupply, tSupply);
1145     }
1146 
1147     function _getTaxFee() private view returns (uint256) {
1148         return _taxFee;
1149     }
1150 
1151     function _getMaxTxAmount() private view returns (uint256) {
1152         return _maxTxAmount;
1153     }
1154 
1155     /**
1156       * [PUBLIC VIEW FUNCTIONS]
1157       *
1158       */
1159 
1160     function totalFees() public view returns (uint256) {
1161         return _tFeeTotal;
1162     }
1163 
1164     function _getETHBalance() public view returns (uint256 balance) {
1165         return address(this).balance;
1166     }
1167 
1168     function isMultisigDestroyed() public view returns (bool) {
1169         return multisigDestroyed;
1170     }
1171 
1172     function isMultisigParty(
1173         address _party
1174     ) public view returns (bool) {
1175         return _isMultisig[_party];
1176     }
1177 
1178     function getTreasury() public view returns (address payable) {
1179         return MCCTreasury;
1180     }
1181 
1182     /**
1183       * [MULTISIG]
1184       *
1185       */
1186 
1187     function _nominateTreasury(
1188         address _nominee,
1189         bool _valid
1190     ) external onlyMultisig() {
1191         require(multisigDestroyed == false, "The multisig has been destroyed.");
1192         require(treasuryLinked == false, "The treasury contract has already been linked.");
1193 
1194         _treasuryNominations[msg.sender].nominee = _nominee;
1195         _treasuryNominations[msg.sender].valid = _valid;
1196     }
1197 
1198     function _linkTreasury(
1199         address _MCCTreasury
1200     ) external onlyMultisig() {
1201         require(multisigDestroyed == false, "The multisig has been destroyed.");
1202         require(treasuryLinked == false, "The treasury contract has already been linked.");
1203 
1204         uint8 agreements = 0;
1205 
1206         for (uint8 i = 0; i < multisigParties.length; i++) {
1207             if (_treasuryNominations[multisigParties[i]].nominee == _MCCTreasury && _treasuryNominations[multisigParties[i]].valid == true) {
1208                 agreements++;
1209             }
1210         }
1211 
1212         require(agreements >= 5, "Multisig requires 5/7 approval.");
1213 
1214         _isExcludedFromFee[_MCCTreasury] = true;
1215         MCCTreasury = payable(_MCCTreasury);
1216 
1217         treasuryLinked = true;
1218     }
1219 
1220     function _nominateFeeExclusion(
1221         address _nominee,
1222         bool _valid
1223     ) external onlyMultisig() {
1224         require(multisigDestroyed == false, "The multisig has been destroyed.");
1225 
1226         _whitelistNominations[msg.sender].nominee = _nominee;
1227         _whitelistNominations[msg.sender].valid = _valid;
1228     }
1229 
1230     function setExcludeFromFee(
1231         address _nominee,
1232         bool _excluded
1233     ) external onlyMultisig() {
1234         require(multisigDestroyed == false, "The multisig has been destroyed.");
1235 
1236         uint8 agreements = 0;
1237 
1238         for (uint8 i = 0; i < multisigParties.length; i++) {
1239             if (_treasuryNominations[multisigParties[i]].nominee == _nominee && _treasuryNominations[multisigParties[i]].valid == _excluded) {
1240                 agreements++;
1241             }
1242         }
1243 
1244         require(agreements >= 5, "Multisig requires 5/7 approval.");
1245 
1246         _isExcludedFromFee[_nominee] = _excluded;
1247     }
1248 
1249     function _nominateDestruction(
1250         bool _valid
1251     ) external onlyMultisig() {
1252         require(multisigDestroyed == false, "The multisig has been destroyed.");
1253 
1254         _destructionNominations[msg.sender].valid = _valid;
1255     }
1256 
1257     function _destroyMultisig() external onlyMultisig() {
1258         require(multisigDestroyed == false, "The multisig has been destroyed.");
1259 
1260         uint8 agreements = 0;
1261 
1262         for (uint8 i = 0; i < multisigParties.length; i++) {
1263             if (_destructionNominations[multisigParties[i]].valid == true) {
1264                 agreements++;
1265             }
1266         }
1267 
1268         require(agreements >= 5, "Multisig requires 5/7 approval.");
1269 
1270         multisigDestroyed = true;
1271     }
1272 }