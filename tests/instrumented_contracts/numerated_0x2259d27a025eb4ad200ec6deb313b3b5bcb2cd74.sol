1 // $HACKD
2 // TG: https://t.me/HACKDToken
3 // Made in honour of the PolyNetwork Exploiter, and his many bananas
4 
5 // Ape Play Fair Launch: 10% Burn, 1% to PolyNetwork Exploiter
6 
7 // Slippage Recommended: 10%
8 // Launched by https://t.me/FairLaunchCalls
9 // Community-owned token
10 
11 // SPDX-License-Identifier: Unlicensed
12 pragma solidity ^0.6.12;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     /**
27     * @dev Returns the amount of tokens in existence.
28     */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32     * @dev Returns the amount of tokens owned by `account`.
33     */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37     * @dev Moves `amount` tokens from the caller's account to `recipient`.
38     *
39     * Returns a boolean value indicating whether the operation succeeded.
40     *
41     * Emits a {Transfer} event.
42     */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46     * @dev Returns the remaining number of tokens that `spender` will be
47     * allowed to spend on behalf of `owner` through {transferFrom}. This is
48     * zero by default.
49     *
50     * This value changes when {approve} or {transferFrom} are called.
51     */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56     *
57     * Returns a boolean value indicating whether the operation succeeded.
58     *
59     * IMPORTANT: Beware that changing an allowance with this method brings the risk
60     * that someone may use both the old and the new allowance by unfortunate
61     * transaction ordering. One possible solution to mitigate this race
62     * condition is to first reduce the spender's allowance to 0 and set the
63     * desired value afterwards:
64     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65     *
66     * Emits an {Approval} event.
67     */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71     * @dev Moves `amount` tokens from `sender` to `recipient` using the
72     * allowance mechanism. `amount` is then deducted from the caller's
73     * allowance.
74     *
75     * Returns a boolean value indicating whether the operation succeeded.
76     *
77     * Emits a {Transfer} event.
78     */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82     * @dev Emitted when `value` tokens are moved from one account (`from`) to
83     * another (`to`).
84     *
85     * Note that `value` may be zero.
86     */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91     * a call to {approve}. `value` is the new allowance.
92     */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 library SafeMath {
97     /**
98     * @dev Returns the addition of two unsigned integers, reverting on
99     * overflow.
100     *
101     * Counterpart to Solidity's `+` operator.
102     *
103     * Requirements:
104     *
105     * - Addition cannot overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115     * @dev Returns the subtraction of two unsigned integers, reverting on
116     * overflow (when the result is negative).
117     *
118     * Counterpart to Solidity's `-` operator.
119     *
120     * Requirements:
121     *
122     * - Subtraction cannot overflow.
123     */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130     * overflow (when the result is negative).
131     *
132     * Counterpart to Solidity's `-` operator.
133     *
134     * Requirements:
135     *
136     * - Subtraction cannot overflow.
137     */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146     * @dev Returns the multiplication of two unsigned integers, reverting on
147     * overflow.
148     *
149     * Counterpart to Solidity's `*` operator.
150     *
151     * Requirements:
152     *
153     * - Multiplication cannot overflow.
154     */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170     * @dev Returns the integer division of two unsigned integers. Reverts on
171     * division by zero. The result is rounded towards zero.
172     *
173     * Counterpart to Solidity's `/` operator. Note: this function uses a
174     * `revert` opcode (which leaves remaining gas untouched) while Solidity
175     * uses an invalid opcode to revert (consuming all remaining gas).
176     *
177     * Requirements:
178     *
179     * - The divisor cannot be zero.
180     */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187     * division by zero. The result is rounded towards zero.
188     *
189     * Counterpart to Solidity's `/` operator. Note: this function uses a
190     * `revert` opcode (which leaves remaining gas untouched) while Solidity
191     * uses an invalid opcode to revert (consuming all remaining gas).
192     *
193     * Requirements:
194     *
195     * - The divisor cannot be zero.
196     */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207     * Reverts when dividing by zero.
208     *
209     * Counterpart to Solidity's `%` operator. This function uses a `revert`
210     * opcode (which leaves remaining gas untouched) while Solidity uses an
211     * invalid opcode to revert (consuming all remaining gas).
212     *
213     * Requirements:
214     *
215     * - The divisor cannot be zero.
216     */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223     * Reverts with custom message when dividing by zero.
224     *
225     * Counterpart to Solidity's `%` operator. This function uses a `revert`
226     * opcode (which leaves remaining gas untouched) while Solidity uses an
227     * invalid opcode to revert (consuming all remaining gas).
228     *
229     * Requirements:
230     *
231     * - The divisor cannot be zero.
232     */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 library Address {
240     /**
241     * @dev Returns true if `account` is a contract.
242     *
243     * [IMPORTANT]
244     * ====
245     * It is unsafe to assume that an address for which this function returns
246     * false is an externally-owned account (EOA) and not a contract.
247     *
248     * Among others, `isContract` will return false for the following
249     * types of addresses:
250     *
251     *  - an externally-owned account
252     *  - a contract in construction
253     *  - an address where a contract will be created
254     *  - an address where a contract lived, but was destroyed
255     * ====
256     */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270     * `recipient`, forwarding all available gas and reverting on errors.
271     *
272     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273     * of certain opcodes, possibly making contracts go over the 2300 gas limit
274     * imposed by `transfer`, making them unable to receive funds via
275     * `transfer`. {sendValue} removes this limitation.
276     *
277     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278     *
279     * IMPORTANT: because control is transferred to `recipient`, care must be
280     * taken to not create reentrancy vulnerabilities. Consider using
281     * {ReentrancyGuard} or the
282     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283     */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293     * @dev Performs a Solidity function call using a low level `call`. A
294     * plain`call` is an unsafe replacement for a function call: use this
295     * function instead.
296     *
297     * If `target` reverts with a revert reason, it is bubbled up by this
298     * function (like regular Solidity function calls).
299     *
300     * Returns the raw returned data. To convert to the expected return value,
301     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302     *
303     * Requirements:
304     *
305     * - `target` must be a contract.
306     * - calling `target` with `data` must not revert.
307     *
308     * _Available since v3.1._
309     */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316     * `errorMessage` as a fallback revert reason when `target` reverts.
317     *
318     * _Available since v3.1._
319     */
320     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         return _functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326     * but also transferring `value` wei to `target`.
327     *
328     * Requirements:
329     *
330     * - the calling contract must have an ETH balance of at least `value`.
331     * - the called Solidity function must be `payable`.
332     *
333     * _Available since v3.1._
334     */
335     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341     * with `errorMessage` as a fallback revert reason when `target` reverts.
342     *
343     * _Available since v3.1._
344     */
345     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         return _functionCallWithValue(target, data, value, errorMessage);
348     }
349 
350     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 // solhint-disable-next-line no-inline-assembly
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 contract Ownable is Context {
375     address private _owner;
376     address private _previousOwner;
377     uint256 private _lockTime;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382     * @dev Initializes the contract setting the deployer as the initial owner.
383     */
384     constructor () internal {
385         address msgSender = _msgSender();
386         _owner = msgSender;
387         emit OwnershipTransferred(address(0), msgSender);
388     }
389 
390     /**
391     * @dev Returns the address of the current owner.
392     */
393     function owner() public view returns (address) {
394         return _owner;
395     }
396 
397     /**
398     * @dev Throws if called by any account other than the owner.
399     */
400     modifier onlyOwner() {
401         require(_owner == _msgSender(), "Ownable: caller is not the owner");
402         _;
403     }
404 
405     /**
406     * @dev Leaves the contract without owner. It will not be possible to call
407     * `onlyOwner` functions anymore. Can only be called by the current owner.
408     *
409     * NOTE: Renouncing ownership will leave the contract without an owner,
410     * thereby removing any functionality that is only available to the owner.
411     */
412     function renounceOwnership() public virtual onlyOwner {
413         emit OwnershipTransferred(_owner, address(0));
414         _owner = address(0);
415     }
416 
417     /**
418     * @dev Transfers ownership of the contract to a new account (`newOwner`).
419     * Can only be called by the current owner.
420     */
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(newOwner != address(0), "Ownable: new owner is the zero address");
423         emit OwnershipTransferred(_owner, newOwner);
424         _owner = newOwner;
425     }
426 
427 }
428 
429 interface IUniswapV2Factory {
430     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
431 
432     function feeTo() external view returns (address);
433     function feeToSetter() external view returns (address);
434 
435     function getPair(address tokenA, address tokenB) external view returns (address pair);
436     function allPairs(uint) external view returns (address pair);
437     function allPairsLength() external view returns (uint);
438 
439     function createPair(address tokenA, address tokenB) external returns (address pair);
440 
441     function setFeeTo(address) external;
442     function setFeeToSetter(address) external;
443 }
444 
445 interface IUniswapV2Pair {
446     event Approval(address indexed owner, address indexed spender, uint value);
447     event Transfer(address indexed from, address indexed to, uint value);
448 
449     function name() external pure returns (string memory);
450     function symbol() external pure returns (string memory);
451     function decimals() external pure returns (uint8);
452     function totalSupply() external view returns (uint);
453     function balanceOf(address owner) external view returns (uint);
454     function allowance(address owner, address spender) external view returns (uint);
455 
456     function approve(address spender, uint value) external returns (bool);
457     function transfer(address to, uint value) external returns (bool);
458     function transferFrom(address from, address to, uint value) external returns (bool);
459 
460     function DOMAIN_SEPARATOR() external view returns (bytes32);
461     function PERMIT_TYPEHASH() external pure returns (bytes32);
462     function nonces(address owner) external view returns (uint);
463 
464     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
465 
466     //NB: This is an INTERFACE FUNCTION on the default UniSwapV2 Library.
467     //Feel free to check the contract itself - there's no implementation/way to use it to mint tokens.
468     event Mint(address indexed sender, uint amount0, uint amount1);
469     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
470     event Swap(
471         address indexed sender,
472         uint amount0In,
473         uint amount1In,
474         uint amount0Out,
475         uint amount1Out,
476         address indexed to
477     );
478     event Sync(uint112 reserve0, uint112 reserve1);
479 
480     function MINIMUM_LIQUIDITY() external pure returns (uint);
481     function factory() external view returns (address);
482     function token0() external view returns (address);
483     function token1() external view returns (address);
484     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
485     function price0CumulativeLast() external view returns (uint);
486     function price1CumulativeLast() external view returns (uint);
487     function kLast() external view returns (uint);
488 
489     //NB: This is an INTERFACE FUNCTION on the default UniSwapV2 Library.
490     //Feel free to check the contract itself - there's no implementation/way to use it to mint tokens.
491     function mint(address to) external returns (uint liquidity);
492     function burn(address to) external returns (uint amount0, uint amount1);
493     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
494     function skim(address to) external;
495     function sync() external;
496 
497     function initialize(address, address) external;
498 }
499 
500 interface IUniswapV2Router01 {
501     function factory() external pure returns (address);
502     function WETH() external pure returns (address);
503 
504     function addLiquidity(
505         address tokenA,
506         address tokenB,
507         uint amountADesired,
508         uint amountBDesired,
509         uint amountAMin,
510         uint amountBMin,
511         address to,
512         uint deadline
513     ) external returns (uint amountA, uint amountB, uint liquidity);
514     function addLiquidityETH(
515         address token,
516         uint amountTokenDesired,
517         uint amountTokenMin,
518         uint amountETHMin,
519         address to,
520         uint deadline
521     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
522     function removeLiquidity(
523         address tokenA,
524         address tokenB,
525         uint liquidity,
526         uint amountAMin,
527         uint amountBMin,
528         address to,
529         uint deadline
530     ) external returns (uint amountA, uint amountB);
531     function removeLiquidityETH(
532         address token,
533         uint liquidity,
534         uint amountTokenMin,
535         uint amountETHMin,
536         address to,
537         uint deadline
538     ) external returns (uint amountToken, uint amountETH);
539     function removeLiquidityWithPermit(
540         address tokenA,
541         address tokenB,
542         uint liquidity,
543         uint amountAMin,
544         uint amountBMin,
545         address to,
546         uint deadline,
547         bool approveMax, uint8 v, bytes32 r, bytes32 s
548     ) external returns (uint amountA, uint amountB);
549     function removeLiquidityETHWithPermit(
550         address token,
551         uint liquidity,
552         uint amountTokenMin,
553         uint amountETHMin,
554         address to,
555         uint deadline,
556         bool approveMax, uint8 v, bytes32 r, bytes32 s
557     ) external returns (uint amountToken, uint amountETH);
558     function swapExactTokensForTokens(
559         uint amountIn,
560         uint amountOutMin,
561         address[] calldata path,
562         address to,
563         uint deadline
564     ) external returns (uint[] memory amounts);
565     function swapTokensForExactTokens(
566         uint amountOut,
567         uint amountInMax,
568         address[] calldata path,
569         address to,
570         uint deadline
571     ) external returns (uint[] memory amounts);
572     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
573     external
574     payable
575     returns (uint[] memory amounts);
576     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
577     external
578     returns (uint[] memory amounts);
579     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
580     external
581     returns (uint[] memory amounts);
582     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
583     external
584     payable
585     returns (uint[] memory amounts);
586 
587     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
588     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
589     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
590     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
591     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
592 }
593 
594 interface IUniswapV2Router02 is IUniswapV2Router01 {
595     function removeLiquidityETHSupportingFeeOnTransferTokens(
596         address token,
597         uint liquidity,
598         uint amountTokenMin,
599         uint amountETHMin,
600         address to,
601         uint deadline
602     ) external returns (uint amountETH);
603     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
604         address token,
605         uint liquidity,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline,
610         bool approveMax, uint8 v, bytes32 r, bytes32 s
611     ) external returns (uint amountETH);
612 
613     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
614         uint amountIn,
615         uint amountOutMin,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external;
620     function swapExactETHForTokensSupportingFeeOnTransferTokens(
621         uint amountOutMin,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external payable;
626     function swapExactTokensForETHSupportingFeeOnTransferTokens(
627         uint amountIn,
628         uint amountOutMin,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external;
633 }
634 
635 contract Hackd is Context, IERC20, Ownable {
636     using SafeMath for uint256;
637     using Address for address;
638 
639     mapping (address => uint256) private _rOwned;
640     mapping (address => uint256) private _tOwned;
641     mapping (address => uint256) private _lastTx;
642     mapping (address => mapping (address => uint256)) private _allowances;
643 
644     mapping (address => bool) private _isExcludedFromFee;
645 
646     mapping (address => bool) private _isExcluded;
647     address[] private _excluded;
648 
649     uint256 private constant MAX = ~uint256(0);
650     uint256 private _tTotal = 1000000000000000000000000;
651     uint256 private _rTotal = (MAX - (MAX % _tTotal));
652     uint256 private _tFeeTotal;
653     uint256 public launchTime;
654     mapping (address => bool) private _isSniper;
655     address[] private _confirmedSnipers;
656 
657     string private _name = 'HACKD | t.me/HACKDToken';
658     string private _symbol = 'HACKD \xF0\x9F\x9A\x93';
659     uint8 private _decimals = 9;
660 
661     uint256 private _taxFee = 0;
662     uint256 private _teamDev = 0;
663     uint256 private _previousTaxFee = _taxFee;
664     uint256 private _previousTeamDev = _teamDev;
665 
666     address payable private _teamDevAddress;
667     address payable private _multisigAddress;
668     address private _router = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
669     address private _dead = address(0x000000000000000000000000000000000000dEaD);
670 
671     IUniswapV2Router02 public uniswapV2Router;
672     address public uniswapV2Pair;
673 
674     bool inSwap = false;
675     bool public swapEnabled = true;
676     bool public tradingOpen = false;
677     bool private snipeProtectionOn = false;
678     bool private contractSafetyProtocol = true;
679 
680     uint256 public _maxTxAmount = 1000000000000000000000000;
681     uint256 private _numOfTokensToExchangeForTeamDev = 100000000000000000000;
682     uint256 public _safetyProtocolLimitContract = 5000000000000000000000;
683     bool _txLimitsEnabled = true;
684 
685     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
686     event SwapEnabledUpdated(bool enabled);
687 
688     modifier lockTheSwap {
689         inSwap = true;
690         _;
691         inSwap = false;
692     }
693 
694     constructor () public {
695         _rOwned[_msgSender()] = _rTotal;
696         emit Transfer(address(0), _msgSender(), _tTotal);
697     }
698 
699     function initContract() external onlyOwner() {
700         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
701         // Create a uniswap pair for this new token
702         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
703         .createPair(address(this), _uniswapV2Router.WETH());
704 
705         // set the rest of the contract variables
706         uniswapV2Router = _uniswapV2Router;
707         // Exclude owner and this contract from fee
708         _isExcludedFromFee[owner()] = true;
709         _isExcludedFromFee[address(this)] = true;
710     }
711 
712     function initDefaultLists() external onlyOwner() {
713         // List of front-runner & sniper bots from t.me/FairLaunchCalls
714         blacklistFrontrunnerBot(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
715         blacklistFrontrunnerBot(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
716         blacklistFrontrunnerBot(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
717         blacklistFrontrunnerBot(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
718         blacklistFrontrunnerBot(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
719         blacklistFrontrunnerBot(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
720         blacklistFrontrunnerBot(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
721         blacklistFrontrunnerBot(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
722         blacklistFrontrunnerBot(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
723         blacklistFrontrunnerBot(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
724         blacklistFrontrunnerBot(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
725         blacklistFrontrunnerBot(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
726         blacklistFrontrunnerBot(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
727         blacklistFrontrunnerBot(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
728         blacklistFrontrunnerBot(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
729         blacklistFrontrunnerBot(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
730         blacklistFrontrunnerBot(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
731         blacklistFrontrunnerBot(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
732         blacklistFrontrunnerBot(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
733         blacklistFrontrunnerBot(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
734         blacklistFrontrunnerBot(address(0x72b30cDc1583224381132D379A052A6B10725415));
735         blacklistFrontrunnerBot(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
736         blacklistFrontrunnerBot(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
737         blacklistFrontrunnerBot(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
738         blacklistFrontrunnerBot(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
739         blacklistFrontrunnerBot(address(0x0000000000007673393729D5618DC555FD13f9aA));
740         blacklistFrontrunnerBot(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
741         blacklistFrontrunnerBot(address(0x000000005804B22091aa9830E50459A15E7C9241));
742         blacklistFrontrunnerBot(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
743         blacklistFrontrunnerBot(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
744         blacklistFrontrunnerBot(address(0x000000000000084e91743124a982076C59f10084));
745         blacklistFrontrunnerBot(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
746         blacklistFrontrunnerBot(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
747         blacklistFrontrunnerBot(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
748         blacklistFrontrunnerBot(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
749         blacklistFrontrunnerBot(address(0xDC81a3450817A58D00f45C86d0368290088db848));
750         blacklistFrontrunnerBot(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
751         blacklistFrontrunnerBot(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
752         blacklistFrontrunnerBot(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
753         blacklistFrontrunnerBot(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
754         blacklistFrontrunnerBot(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
755         blacklistFrontrunnerBot(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
756         blacklistFrontrunnerBot(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
757         blacklistFrontrunnerBot(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
758         blacklistFrontrunnerBot(address(0x0000000099cB7fC48a935BcEb9f05BbaE54e8987));
759         blacklistFrontrunnerBot(address(0x03BB05BBa541842400541142d20e9C128Ba3d17c));
760 
761         _teamDevAddress = payable(0x25bebB6A2Bc14c626481B2D03dEC80bFB316b2FB);
762         _isExcluded[uniswapV2Pair] = true;
763     }
764 
765     function blacklistFrontrunnerBot(address addr) private {
766         _isSniper[addr] = true;
767         _confirmedSnipers.push(addr);
768     }
769 
770     function liftOpeningTXLimits() external onlyOwner() {
771         _maxTxAmount = 100000000000000000000000;
772     }
773 
774     function openTrading() external onlyOwner() {
775         swapEnabled = true;
776         tradingOpen = true;
777         launchTime = block.timestamp;
778     }
779 
780     function enableFees() external onlyOwner() {
781         _taxFee = 2;
782         _teamDev = 9;
783     }
784 
785     function openAntiBotFees() external onlyOwner() {
786         _taxFee = 0;
787         _teamDev = 25;
788     }
789 
790     function decTaxForRFI() external onlyOwner() {
791         if (_teamDev > 0) {
792             _teamDev--;
793             _taxFee++;
794         }
795     }
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
813     function balanceOf(address account) public view override returns (uint256) {
814         if (_isExcluded[account]) return _tOwned[account];
815         return tokenFromReflection(_rOwned[account]);
816     }
817 
818     function transfer(address recipient, uint256 amount) public override returns (bool) {
819         _transfer(_msgSender(), recipient, amount);
820         return true;
821     }
822 
823     function allowance(address owner, address spender) public view override returns (uint256) {
824         return _allowances[owner][spender];
825     }
826 
827     function approve(address spender, uint256 amount) public override returns (bool) {
828         _approve(_msgSender(), spender, amount);
829         return true;
830     }
831 
832     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
833         _transfer(sender, recipient, amount);
834         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
835         return true;
836     }
837 
838     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
839         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
840         return true;
841     }
842 
843     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
844         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
845         return true;
846     }
847 
848     function isExcluded(address account) public view returns (bool) {
849         return _isExcluded[account];
850     }
851 
852     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
853         _isExcludedFromFee[account] = excluded;
854     }
855 
856     function totalFees() public view returns (uint256) {
857         return _tFeeTotal;
858     }
859 
860     function deliver(uint256 tAmount) public {
861         address sender = _msgSender();
862         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
863         (uint256 rAmount,,,,,,) = _getValues(tAmount);
864         _rOwned[sender] = _rOwned[sender].sub(rAmount);
865         _rTotal = _rTotal.sub(rAmount);
866         _tFeeTotal = _tFeeTotal.add(tAmount);
867     }
868 
869     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
870         require(tAmount <= _tTotal, "Amount must be less than supply");
871         if (!deductTransferFee) {
872             (uint256 rAmount,,,,,,) = _getValues(tAmount);
873             return rAmount;
874         } else {
875             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
876             return rTransferAmount;
877         }
878     }
879 
880     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
881         require(rAmount <= _rTotal, "Amount must be less than total reflections");
882         uint256 currentRate =  _getRate();
883         return rAmount.div(currentRate);
884     }
885 
886     function excludeAccount(address account) external onlyOwner() {
887         require(account != _router, 'We can not exclude our router.');
888         require(!_isExcluded[account], "Account is already excluded");
889         if(_rOwned[account] > 0) {
890             _tOwned[account] = tokenFromReflection(_rOwned[account]);
891         }
892         _isExcluded[account] = true;
893         _excluded.push(account);
894     }
895 
896     function includeAccount(address account) external onlyOwner() {
897         require(_isExcluded[account], "Account is already excluded");
898         for (uint256 i = 0; i < _excluded.length; i++) {
899             if (_excluded[i] == account) {
900                 _excluded[i] = _excluded[_excluded.length - 1];
901                 _tOwned[account] = 0;
902                 _isExcluded[account] = false;
903                 _excluded.pop();
904                 break;
905             }
906         }
907     }
908 
909     function removeAllFee() private {
910         if(_taxFee == 0 && _teamDev == 0) return;
911 
912         _previousTaxFee = _taxFee;
913         _previousTeamDev = _teamDev;
914 
915         _taxFee = 0;
916         _teamDev = 0;
917     }
918 
919     function restoreAllFee() private {
920         _taxFee = _previousTaxFee;
921         _teamDev = _previousTeamDev;
922     }
923 
924     function isExcludedFromFee(address account) public view returns(bool) {
925         return _isExcludedFromFee[account];
926     }
927 
928     function _approve(address owner, address spender, uint256 amount) private {
929         require(owner != address(0), "ERC20: approve from the zero address");
930         require(spender != address(0), "ERC20: approve to the zero address");
931 
932         _allowances[owner][spender] = amount;
933         emit Approval(owner, spender, amount);
934     }
935 
936     function RemoveSniper(address account) external onlyOwner() {
937         require(account != _router, 'We can not blacklist our router.');
938         require(account != uniswapV2Pair, 'We can not blacklist our pair.');
939         require(account != owner(), 'We can not blacklist the contract owner.');
940         require(account != address(this), 'We can not blacklist the contract. Srsly?');
941         require(!_isSniper[account], "Account is already blacklisted");
942         _isSniper[account] = true;
943         _confirmedSnipers.push(account);
944     }
945 
946     function amnestySniper(address account) external onlyOwner() {
947         require(_isSniper[account], "Account is not blacklisted");
948         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
949             if (_confirmedSnipers[i] == account) {
950                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
951                 _isSniper[account] = false;
952                 _confirmedSnipers.pop();
953                 break;
954             }
955         }
956     }
957 
958     function _transfer(address sender, address recipient, uint256 amount) private {
959         require(sender != address(0), "ERC20: transfer from the zero address");
960         require(recipient != address(0), "ERC20: transfer to the zero address");
961         require(amount > 0, "Transfer amount must be greater than zero");
962         require(!_isSniper[recipient], "You have no power here!");
963         require(!_isSniper[msg.sender], "You have no power here!");
964         require(!_isSniper[sender], "You have no power here!");
965 
966         if(sender != owner() && recipient != owner()) {
967             //require(amount < _maxTxAmount, "Maximum TX amount exceeded - try a lower value!");
968             if (!tradingOpen) {
969                 if (!(sender == address(this) || recipient == address(this)
970                 || sender == address(owner()) || recipient == address(owner()))) {
971                     require(tradingOpen, "Trading is not enabled");
972                 }
973             }
974         }
975 
976         // is the token balance of this contract address over the min number of
977         // tokens that we need to initiate a swap?
978         // also, don't get caught in a circular teamDev event.
979         // also, don't swap if sender is uniswap pair.
980         uint256 contractTokenBalance = balanceOf(address(this));
981 
982         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeamDev;
983         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
984             // We need to swap the current tokens to ETH and send to the ext wallet
985             if (contractSafetyProtocol && contractTokenBalance > _safetyProtocolLimitContract) {
986                 swapTokensForEth(_safetyProtocolLimitContract);
987             }
988             swapTokensForEth(contractTokenBalance);
989 
990             uint256 contractETHBalance = address(this).balance;
991             if(contractETHBalance > 0) {
992                 sendETHToTeamDev(address(this).balance);
993             }
994         }
995 
996         //indicates if fee should be deducted from transfer
997         bool takeFee = true;
998 
999         //if any account belongs to _isExcludedFromFee account then remove the fee
1000         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1001             takeFee = false;
1002         }
1003 
1004         //transfer amount, it will take tax and fee
1005 
1006         _tokenTransfer(sender,recipient,amount,takeFee);
1007     }
1008 
1009     function secSweepStart() external onlyOwner() {
1010         tradingOpen = false;
1011     }
1012 
1013     function secSweepEnd() external onlyOwner() {
1014         tradingOpen = true;
1015     }
1016 
1017     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1018         // generate the uniswap pair path of token -> weth
1019         address[] memory path = new address[](2);
1020         path[0] = address(this);
1021         path[1] = uniswapV2Router.WETH();
1022 
1023         _approve(address(this), address(uniswapV2Router), tokenAmount);
1024 
1025         // make the swap
1026         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1027             tokenAmount,
1028             0, // accept any amount of ETH
1029             path,
1030             address(this),
1031             block.timestamp
1032         );
1033     }
1034 
1035     function sendETHToTeamDev(uint256 amount) private {
1036         _teamDevAddress.transfer(amount.div(2));
1037     }
1038 
1039     // We are exposing these functions to be able to manual swap and send
1040     // in case the token is highly valued and 5M becomes too much
1041     function manualSwap() external onlyOwner() {
1042         uint256 contractBalance = balanceOf(address(this));
1043         swapTokensForEth(contractBalance);
1044     }
1045 
1046     function manualSend() external onlyOwner() {
1047         uint256 contractETHBalance = address(this).balance;
1048         sendETHToTeamDev(contractETHBalance);
1049     }
1050 
1051     function setSwapEnabled(bool enabled) external onlyOwner(){
1052         swapEnabled = enabled;
1053     }
1054 
1055     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
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
1076         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1077         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1078         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1079         _devF(rDev, tDev);
1080         _reflectFee(rFee, tFee);
1081         emit Transfer(sender, recipient, tTransferAmount);
1082     }
1083 
1084     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1085         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1086         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1087         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1088         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1089         _devF(rDev, tDev);
1090         _reflectFee(rFee, tFee);
1091         emit Transfer(sender, recipient, tTransferAmount);
1092     }
1093 
1094     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1095         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1096         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1097         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1098         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1099         _devF(rDev, tDev);
1100         _reflectFee(rFee, tFee);
1101         emit Transfer(sender, recipient, tTransferAmount);
1102     }
1103 
1104     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1105         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1106         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1107         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1108         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1109         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1110         _devF(rDev, tDev);
1111         _reflectFee(rFee, tFee);
1112         emit Transfer(sender, recipient, tTransferAmount);
1113     }
1114 
1115     function _devF(uint256 rDev, uint256 tDev) private {
1116         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1117         if(_isExcluded[address(this)]) {
1118             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1119         }
1120     }
1121 
1122     function _reflectFee(uint256 rFee, uint256 tFee) private {
1123         _rTotal = _rTotal.sub(rFee);
1124         _tFeeTotal = _tFeeTotal.add(tFee);
1125     }
1126 
1127     //to receive ETH from uniswap when swapping
1128     receive() external payable {}
1129 
1130     struct RVals {
1131         uint256 rAmount;
1132         uint256 rTransferAmount;
1133         uint256 rFee;
1134         uint256 rTeamDev;
1135     }
1136 
1137     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1138         (uint256 tTransferAmount, uint256 tFee, uint256 tTeamDev) = _getTValues(tAmount, _taxFee, _teamDev);
1139         uint256 currentRate =  _getRate();
1140         RVals memory rVal = _getRValues(tAmount, tFee, tTeamDev, currentRate);
1141         return (rVal.rAmount, rVal.rTransferAmount, rVal.rFee, tTransferAmount, tFee, tTeamDev, rVal.rTeamDev);
1142     }
1143 
1144     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamDev) private pure returns (uint256, uint256, uint256) {
1145         uint256 tFee = tAmount.mul(taxFee).div(100);
1146         uint256 tTeamDev = tAmount.mul(teamDev).div(100);
1147         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeamDev);
1148         return (tTransferAmount, tFee, tTeamDev);
1149     }
1150 
1151     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeamDev, uint256 currentRate) private pure returns (RVals memory) {
1152         uint256 rAmount = tAmount.mul(currentRate);
1153         uint256 rFee = tFee.mul(currentRate);
1154         uint256 rTeamDev = tTeamDev.mul(currentRate);
1155         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeamDev);
1156         return RVals(rAmount, rTransferAmount, rFee, rTeamDev);
1157     }
1158 
1159     function _getRate() private view returns(uint256) {
1160         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1161         return rSupply.div(tSupply);
1162     }
1163 
1164     function _getCurrentSupply() private view returns(uint256, uint256) {
1165         uint256 rSupply = _rTotal;
1166         uint256 tSupply = _tTotal;
1167         for (uint256 i = 0; i < _excluded.length; i++) {
1168             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1169             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1170             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1171         }
1172         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1173         return (rSupply, tSupply);
1174     }
1175 
1176     function _getTaxFee() private view returns(uint256) {
1177         return _taxFee;
1178     }
1179 
1180     function _getMaxTxAmount() private view returns(uint256) {
1181         return _maxTxAmount;
1182     }
1183 
1184     function _getETHBalance() public view returns(uint256 balance) {
1185         return address(this).balance;
1186     }
1187 
1188     function wreckSniper(address account) external onlyOwner {
1189         Transfer(account, _dead, balanceOf(account));
1190     }
1191 
1192     function decrementTeamDevMultisig() external onlyOwner() {
1193         if (_teamDev > 0) {
1194             _teamDev--;
1195         }
1196     }
1197 
1198     function setMultisigAddress(address payable multiSigAddress) external onlyOwner() {
1199         _multisigAddress = multiSigAddress;
1200     }
1201 
1202     function isBanned(address account) public view returns (bool) {
1203         return _isSniper[account];
1204     }
1205 
1206     function checkTeamDevMultisig() public view returns (uint256) {
1207         return _teamDev;
1208     }
1209 
1210     function disableSellSafetyProtocol() external onlyOwner() {
1211         contractSafetyProtocol = false;
1212     }
1213 
1214     //People keep accidentally sending random ERC20 tokens to the contract.
1215     //This will let us send them back.
1216     function revertAccidentalERC20Tx(address tokenAddress, address ownerAddress, uint tokens) public onlyOwner returns (bool success) {
1217         return IERC20(tokenAddress).transfer(ownerAddress, tokens);
1218     }
1219 }