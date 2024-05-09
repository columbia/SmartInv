1 // $GANYMEDE | Ganymede Token
2 // Telegram: https://t.me/GanymedeFLC
3 
4 // Fair Launch, no Dev Tokens. 100% LP.
5 // Snipers will be nuked.
6 
7 // LP Burn on launch.
8 // Ownership will be renounced 30 minutes after launch.
9 
10 // Slippage Recommended: 12%
11 // Variable tax, converts to zero-fee, RFI-Only, or team multisig at Community request
12 // Audit & Fair Launch handled by https://t.me/FairLaunchCalls
13 // Community-owned token, Ape Play
14 
15 /**
16  *         _..._
17  *       .'     '.      _
18  *      /    .-""-\   _/ \
19  *    .-|   /:.   |  |   |
20  *    |  \  |:.   /.-'-./
21  *    | .-'-;:__.'    =/
22  *    .'=  *=|     _.='
23  *   /   _.  |    ;
24  *  ;-.-'|    \   |
25  * /   | \    _\  _\
26  * \__/'._;.  ==' ==\
27  *          \    \   |
28  *          /    /   /
29  *          /-._/-._/
30  *   jgs    \   `\  \
31  *           `-._/._/
32 */
33 
34 // SPDX-License-Identifier: Unlicensed
35 pragma solidity ^0.6.12;
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 interface IERC20 {
49     /**
50     * @dev Returns the amount of tokens in existence.
51     */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55     * @dev Returns the amount of tokens owned by `account`.
56     */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60     * @dev Moves `amount` tokens from the caller's account to `recipient`.
61     *
62     * Returns a boolean value indicating whether the operation succeeded.
63     *
64     * Emits a {Transfer} event.
65     */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69     * @dev Returns the remaining number of tokens that `spender` will be
70     * allowed to spend on behalf of `owner` through {transferFrom}. This is
71     * zero by default.
72     *
73     * This value changes when {approve} or {transferFrom} are called.
74     */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79     *
80     * Returns a boolean value indicating whether the operation succeeded.
81     *
82     * IMPORTANT: Beware that changing an allowance with this method brings the risk
83     * that someone may use both the old and the new allowance by unfortunate
84     * transaction ordering. One possible solution to mitigate this race
85     * condition is to first reduce the spender's allowance to 0 and set the
86     * desired value afterwards:
87     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88     *
89     * Emits an {Approval} event.
90     */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94     * @dev Moves `amount` tokens from `sender` to `recipient` using the
95     * allowance mechanism. `amount` is then deducted from the caller's
96     * allowance.
97     *
98     * Returns a boolean value indicating whether the operation succeeded.
99     *
100     * Emits a {Transfer} event.
101     */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105     * @dev Emitted when `value` tokens are moved from one account (`from`) to
106     * another (`to`).
107     *
108     * Note that `value` may be zero.
109     */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114     * a call to {approve}. `value` is the new allowance.
115     */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 library SafeMath {
120     /**
121     * @dev Returns the addition of two unsigned integers, reverting on
122     * overflow.
123     *
124     * Counterpart to Solidity's `+` operator.
125     *
126     * Requirements:
127     *
128     * - Addition cannot overflow.
129     */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138     * @dev Returns the subtraction of two unsigned integers, reverting on
139     * overflow (when the result is negative).
140     *
141     * Counterpart to Solidity's `-` operator.
142     *
143     * Requirements:
144     *
145     * - Subtraction cannot overflow.
146     */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153     * overflow (when the result is negative).
154     *
155     * Counterpart to Solidity's `-` operator.
156     *
157     * Requirements:
158     *
159     * - Subtraction cannot overflow.
160     */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169     * @dev Returns the multiplication of two unsigned integers, reverting on
170     * overflow.
171     *
172     * Counterpart to Solidity's `*` operator.
173     *
174     * Requirements:
175     *
176     * - Multiplication cannot overflow.
177     */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193     * @dev Returns the integer division of two unsigned integers. Reverts on
194     * division by zero. The result is rounded towards zero.
195     *
196     * Counterpart to Solidity's `/` operator. Note: this function uses a
197     * `revert` opcode (which leaves remaining gas untouched) while Solidity
198     * uses an invalid opcode to revert (consuming all remaining gas).
199     *
200     * Requirements:
201     *
202     * - The divisor cannot be zero.
203     */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210     * division by zero. The result is rounded towards zero.
211     *
212     * Counterpart to Solidity's `/` operator. Note: this function uses a
213     * `revert` opcode (which leaves remaining gas untouched) while Solidity
214     * uses an invalid opcode to revert (consuming all remaining gas).
215     *
216     * Requirements:
217     *
218     * - The divisor cannot be zero.
219     */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230     * Reverts when dividing by zero.
231     *
232     * Counterpart to Solidity's `%` operator. This function uses a `revert`
233     * opcode (which leaves remaining gas untouched) while Solidity uses an
234     * invalid opcode to revert (consuming all remaining gas).
235     *
236     * Requirements:
237     *
238     * - The divisor cannot be zero.
239     */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246     * Reverts with custom message when dividing by zero.
247     *
248     * Counterpart to Solidity's `%` operator. This function uses a `revert`
249     * opcode (which leaves remaining gas untouched) while Solidity uses an
250     * invalid opcode to revert (consuming all remaining gas).
251     *
252     * Requirements:
253     *
254     * - The divisor cannot be zero.
255     */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 library Address {
263     /**
264     * @dev Returns true if `account` is a contract.
265     *
266     * [IMPORTANT]
267     * ====
268     * It is unsafe to assume that an address for which this function returns
269     * false is an externally-owned account (EOA) and not a contract.
270     *
271     * Among others, `isContract` will return false for the following
272     * types of addresses:
273     *
274     *  - an externally-owned account
275     *  - a contract in construction
276     *  - an address where a contract will be created
277     *  - an address where a contract lived, but was destroyed
278     * ====
279     */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293     * `recipient`, forwarding all available gas and reverting on errors.
294     *
295     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296     * of certain opcodes, possibly making contracts go over the 2300 gas limit
297     * imposed by `transfer`, making them unable to receive funds via
298     * `transfer`. {sendValue} removes this limitation.
299     *
300     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301     *
302     * IMPORTANT: because control is transferred to `recipient`, care must be
303     * taken to not create reentrancy vulnerabilities. Consider using
304     * {ReentrancyGuard} or the
305     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306     */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316     * @dev Performs a Solidity function call using a low level `call`. A
317     * plain`call` is an unsafe replacement for a function call: use this
318     * function instead.
319     *
320     * If `target` reverts with a revert reason, it is bubbled up by this
321     * function (like regular Solidity function calls).
322     *
323     * Returns the raw returned data. To convert to the expected return value,
324     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325     *
326     * Requirements:
327     *
328     * - `target` must be a contract.
329     * - calling `target` with `data` must not revert.
330     *
331     * _Available since v3.1._
332     */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334         return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339     * `errorMessage` as a fallback revert reason when `target` reverts.
340     *
341     * _Available since v3.1._
342     */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349     * but also transferring `value` wei to `target`.
350     *
351     * Requirements:
352     *
353     * - the calling contract must have an ETH balance of at least `value`.
354     * - the called Solidity function must be `payable`.
355     *
356     * _Available since v3.1._
357     */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364     * with `errorMessage` as a fallback revert reason when `target` reverts.
365     *
366     * _Available since v3.1._
367     */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 contract Ownable is Context {
398     address private _owner;
399     address private _previousOwner;
400     uint256 private _lockTime;
401 
402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
403 
404     /**
405     * @dev Initializes the contract setting the deployer as the initial owner.
406     */
407     constructor () internal {
408         address msgSender = _msgSender();
409         _owner = msgSender;
410         emit OwnershipTransferred(address(0), msgSender);
411     }
412 
413     /**
414     * @dev Returns the address of the current owner.
415     */
416     function owner() public view returns (address) {
417         return _owner;
418     }
419 
420     /**
421     * @dev Throws if called by any account other than the owner.
422     */
423     modifier onlyOwner() {
424         require(_owner == _msgSender(), "Ownable: caller is not the owner");
425         _;
426     }
427 
428     /**
429     * @dev Leaves the contract without owner. It will not be possible to call
430     * `onlyOwner` functions anymore. Can only be called by the current owner.
431     *
432     * NOTE: Renouncing ownership will leave the contract without an owner,
433     * thereby removing any functionality that is only available to the owner.
434     */
435     function renounceOwnership() public virtual onlyOwner {
436         emit OwnershipTransferred(_owner, address(0));
437         _owner = address(0);
438     }
439 
440     /**
441     * @dev Transfers ownership of the contract to a new account (`newOwner`).
442     * Can only be called by the current owner.
443     */
444     function transferOwnership(address newOwner) public virtual onlyOwner {
445         require(newOwner != address(0), "Ownable: new owner is the zero address");
446         emit OwnershipTransferred(_owner, newOwner);
447         _owner = newOwner;
448     }
449 
450 }
451 
452 interface IUniswapV2Factory {
453     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
454 
455     function feeTo() external view returns (address);
456     function feeToSetter() external view returns (address);
457 
458     function getPair(address tokenA, address tokenB) external view returns (address pair);
459     function allPairs(uint) external view returns (address pair);
460     function allPairsLength() external view returns (uint);
461 
462     function createPair(address tokenA, address tokenB) external returns (address pair);
463 
464     function setFeeTo(address) external;
465     function setFeeToSetter(address) external;
466 }
467 
468 interface IUniswapV2Pair {
469     event Approval(address indexed owner, address indexed spender, uint value);
470     event Transfer(address indexed from, address indexed to, uint value);
471 
472     function name() external pure returns (string memory);
473     function symbol() external pure returns (string memory);
474     function decimals() external pure returns (uint8);
475     function totalSupply() external view returns (uint);
476     function balanceOf(address owner) external view returns (uint);
477     function allowance(address owner, address spender) external view returns (uint);
478 
479     function approve(address spender, uint value) external returns (bool);
480     function transfer(address to, uint value) external returns (bool);
481     function transferFrom(address from, address to, uint value) external returns (bool);
482 
483     function DOMAIN_SEPARATOR() external view returns (bytes32);
484     function PERMIT_TYPEHASH() external pure returns (bytes32);
485     function nonces(address owner) external view returns (uint);
486 
487     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
488 
489     //NB: This is an INTERFACE FUNCTION on the default UniSwapV2 Library.
490     //Feel free to check the contract itself - there's no implementation/way to use it to mint tokens.
491     event Mint(address indexed sender, uint amount0, uint amount1);
492     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
493     event Swap(
494         address indexed sender,
495         uint amount0In,
496         uint amount1In,
497         uint amount0Out,
498         uint amount1Out,
499         address indexed to
500     );
501     event Sync(uint112 reserve0, uint112 reserve1);
502 
503     function MINIMUM_LIQUIDITY() external pure returns (uint);
504     function factory() external view returns (address);
505     function token0() external view returns (address);
506     function token1() external view returns (address);
507     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
508     function price0CumulativeLast() external view returns (uint);
509     function price1CumulativeLast() external view returns (uint);
510     function kLast() external view returns (uint);
511 
512     //NB: This is an INTERFACE FUNCTION on the default UniSwapV2 Library.
513     //Feel free to check the contract itself - there's no implementation/way to use it to mint tokens.
514     function mint(address to) external returns (uint liquidity);
515     function burn(address to) external returns (uint amount0, uint amount1);
516     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
517     function skim(address to) external;
518     function sync() external;
519 
520     function initialize(address, address) external;
521 }
522 
523 interface IUniswapV2Router01 {
524     function factory() external pure returns (address);
525     function WETH() external pure returns (address);
526 
527     function addLiquidity(
528         address tokenA,
529         address tokenB,
530         uint amountADesired,
531         uint amountBDesired,
532         uint amountAMin,
533         uint amountBMin,
534         address to,
535         uint deadline
536     ) external returns (uint amountA, uint amountB, uint liquidity);
537     function addLiquidityETH(
538         address token,
539         uint amountTokenDesired,
540         uint amountTokenMin,
541         uint amountETHMin,
542         address to,
543         uint deadline
544     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
545     function removeLiquidity(
546         address tokenA,
547         address tokenB,
548         uint liquidity,
549         uint amountAMin,
550         uint amountBMin,
551         address to,
552         uint deadline
553     ) external returns (uint amountA, uint amountB);
554     function removeLiquidityETH(
555         address token,
556         uint liquidity,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountToken, uint amountETH);
562     function removeLiquidityWithPermit(
563         address tokenA,
564         address tokenB,
565         uint liquidity,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline,
570         bool approveMax, uint8 v, bytes32 r, bytes32 s
571     ) external returns (uint amountA, uint amountB);
572     function removeLiquidityETHWithPermit(
573         address token,
574         uint liquidity,
575         uint amountTokenMin,
576         uint amountETHMin,
577         address to,
578         uint deadline,
579         bool approveMax, uint8 v, bytes32 r, bytes32 s
580     ) external returns (uint amountToken, uint amountETH);
581     function swapExactTokensForTokens(
582         uint amountIn,
583         uint amountOutMin,
584         address[] calldata path,
585         address to,
586         uint deadline
587     ) external returns (uint[] memory amounts);
588     function swapTokensForExactTokens(
589         uint amountOut,
590         uint amountInMax,
591         address[] calldata path,
592         address to,
593         uint deadline
594     ) external returns (uint[] memory amounts);
595     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
596     external
597     payable
598     returns (uint[] memory amounts);
599     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
600     external
601     returns (uint[] memory amounts);
602     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
603     external
604     returns (uint[] memory amounts);
605     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
606     external
607     payable
608     returns (uint[] memory amounts);
609 
610     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
611     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
612     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
613     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
614     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
615 }
616 
617 interface IUniswapV2Router02 is IUniswapV2Router01 {
618     function removeLiquidityETHSupportingFeeOnTransferTokens(
619         address token,
620         uint liquidity,
621         uint amountTokenMin,
622         uint amountETHMin,
623         address to,
624         uint deadline
625     ) external returns (uint amountETH);
626     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
627         address token,
628         uint liquidity,
629         uint amountTokenMin,
630         uint amountETHMin,
631         address to,
632         uint deadline,
633         bool approveMax, uint8 v, bytes32 r, bytes32 s
634     ) external returns (uint amountETH);
635 
636     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
637         uint amountIn,
638         uint amountOutMin,
639         address[] calldata path,
640         address to,
641         uint deadline
642     ) external;
643     function swapExactETHForTokensSupportingFeeOnTransferTokens(
644         uint amountOutMin,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external payable;
649     function swapExactTokensForETHSupportingFeeOnTransferTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external;
656 }
657 
658 contract Ganymede is Context, IERC20, Ownable {
659     using SafeMath for uint256;
660     using Address for address;
661 
662     mapping (address => uint256) private _rOwned;
663     mapping (address => uint256) private _tOwned;
664     mapping (address => uint256) private _lastTx;
665     mapping (address => mapping (address => uint256)) private _allowances;
666 
667     mapping (address => bool) private _isExcludedFromFee;
668 
669     mapping (address => bool) private _isExcluded;
670     address[] private _excluded;
671 
672     uint256 private constant MAX = ~uint256(0);
673     uint256 private _tTotal = 1000000000000000000000000;
674     uint256 private _rTotal = (MAX - (MAX % _tTotal));
675     uint256 private _tFeeTotal;
676     uint256 public launchTime;
677     mapping (address => bool) private _isSniper;
678     address[] private _confirmedSnipers;
679 
680     string private _name = 'Ganymede | t.me/GanymedeFLC';
681     string private _symbol = 'GANYMEDE';
682     uint8 private _decimals = 9;
683 
684     uint256 private _taxFee = 0;
685     uint256 private _teamDev = 0;
686     uint256 private _previousTaxFee = _taxFee;
687     uint256 private _previousTeamDev = _teamDev;
688 
689     address payable private _teamDevAddress;
690     address payable private _multisigAddress;
691     address private _router = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
692     address private _dead = address(0x000000000000000000000000000000000000dEaD);
693 
694     IUniswapV2Router02 public uniswapV2Router;
695     address public uniswapV2Pair;
696 
697     bool inSwap = false;
698     bool public swapEnabled = true;
699     bool public tradingOpen = false;
700     bool private snipeProtectionOn = false;
701 
702     uint256 public _maxTxAmount = 10000000000000000000000;
703     uint256 private _numOfTokensToExchangeForTeamDev = 50000000000000000;
704     bool _txLimitsEnabled = true;
705 
706     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
707     event SwapEnabledUpdated(bool enabled);
708 
709     modifier lockTheSwap {
710         inSwap = true;
711         _;
712         inSwap = false;
713     }
714 
715     constructor () public {
716         _rOwned[_msgSender()] = _rTotal;
717         emit Transfer(address(0), _msgSender(), _tTotal);
718     }
719 
720     function initContract() external onlyOwner() {
721         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
722         // Create a uniswap pair for this new token
723         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
724         .createPair(address(this), _uniswapV2Router.WETH());
725 
726         // set the rest of the contract variables
727         uniswapV2Router = _uniswapV2Router;
728         // Exclude owner and this contract from fee
729         _isExcludedFromFee[owner()] = true;
730         _isExcludedFromFee[address(this)] = true;
731     }
732 
733     function initDefaultLists() external onlyOwner() {
734         // List of front-runner & sniper bots from t.me/FairLaunchCalls
735         blacklistFrontrunnerBot(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
736         blacklistFrontrunnerBot(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
737         blacklistFrontrunnerBot(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
738         blacklistFrontrunnerBot(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
739         blacklistFrontrunnerBot(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
740         blacklistFrontrunnerBot(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
741         blacklistFrontrunnerBot(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
742         blacklistFrontrunnerBot(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
743         blacklistFrontrunnerBot(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
744         blacklistFrontrunnerBot(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
745         blacklistFrontrunnerBot(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
746         blacklistFrontrunnerBot(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
747         blacklistFrontrunnerBot(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
748         blacklistFrontrunnerBot(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
749         blacklistFrontrunnerBot(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
750         blacklistFrontrunnerBot(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
751         blacklistFrontrunnerBot(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
752         blacklistFrontrunnerBot(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
753         blacklistFrontrunnerBot(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
754         blacklistFrontrunnerBot(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
755         blacklistFrontrunnerBot(address(0x72b30cDc1583224381132D379A052A6B10725415));
756         blacklistFrontrunnerBot(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
757         blacklistFrontrunnerBot(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
758         blacklistFrontrunnerBot(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
759         blacklistFrontrunnerBot(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
760         blacklistFrontrunnerBot(address(0x0000000000007673393729D5618DC555FD13f9aA));
761         blacklistFrontrunnerBot(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
762         blacklistFrontrunnerBot(address(0x000000005804B22091aa9830E50459A15E7C9241));
763         blacklistFrontrunnerBot(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
764         blacklistFrontrunnerBot(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
765         blacklistFrontrunnerBot(address(0x000000000000084e91743124a982076C59f10084));
766         blacklistFrontrunnerBot(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
767         blacklistFrontrunnerBot(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
768         blacklistFrontrunnerBot(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
769         blacklistFrontrunnerBot(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
770         blacklistFrontrunnerBot(address(0xDC81a3450817A58D00f45C86d0368290088db848));
771         blacklistFrontrunnerBot(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
772         blacklistFrontrunnerBot(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
773         blacklistFrontrunnerBot(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
774         blacklistFrontrunnerBot(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
775         blacklistFrontrunnerBot(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
776         blacklistFrontrunnerBot(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
777         blacklistFrontrunnerBot(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
778         blacklistFrontrunnerBot(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
779         blacklistFrontrunnerBot(address(0x0000000099cB7fC48a935BcEb9f05BbaE54e8987));
780         blacklistFrontrunnerBot(address(0x03BB05BBa541842400541142d20e9C128Ba3d17c));
781 
782         _teamDevAddress = payable(0x30c5A6d62d178944C6DA987B369f182969DF9A70);
783         _isExcluded[uniswapV2Pair] = true;
784     }
785 
786     function blacklistFrontrunnerBot(address addr) private {
787         _isSniper[addr] = true;
788         _confirmedSnipers.push(addr);
789     }
790 
791     function liftOpeningTXLimits() external onlyOwner() {
792         _maxTxAmount = 100000000000000000000000;
793     }
794 
795     function openTrading() external onlyOwner() {
796         swapEnabled = true;
797         tradingOpen = true;
798         launchTime = block.timestamp;
799     }
800 
801     function enableFees() external onlyOwner() {
802         _taxFee = 2;
803         _teamDev = 9;
804     }
805 
806     function openAntiBotFees() external onlyOwner() {
807         _taxFee = 0;
808         _teamDev = 25;
809     }
810     
811     function noFeeTrading() external onlyOwner() {
812         _taxFee = 0;
813         _teamDev = 0;
814     }
815     
816     function multisigOnlyTrading() external onlyOwner() {
817         _taxFee = 0;
818         _teamDev = 5;
819     }
820 
821     function decTaxForRFI() external onlyOwner() {
822         if (_teamDev > 0) {
823             _teamDev--;
824             _taxFee++;
825         }
826     }
827 
828     function name() public view returns (string memory) {
829         return _name;
830     }
831 
832     function symbol() public view returns (string memory) {
833         return _symbol;
834     }
835 
836     function decimals() public view returns (uint8) {
837         return _decimals;
838     }
839 
840     function totalSupply() public view override returns (uint256) {
841         return _tTotal;
842     }
843 
844     function balanceOf(address account) public view override returns (uint256) {
845         if (_isExcluded[account]) return _tOwned[account];
846         return tokenFromReflection(_rOwned[account]);
847     }
848 
849     function transfer(address recipient, uint256 amount) public override returns (bool) {
850         _transfer(_msgSender(), recipient, amount);
851         return true;
852     }
853 
854     function allowance(address owner, address spender) public view override returns (uint256) {
855         return _allowances[owner][spender];
856     }
857 
858     function approve(address spender, uint256 amount) public override returns (bool) {
859         _approve(_msgSender(), spender, amount);
860         return true;
861     }
862 
863     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
864         _transfer(sender, recipient, amount);
865         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
866         return true;
867     }
868 
869     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
870         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
871         return true;
872     }
873 
874     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
875         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
876         return true;
877     }
878 
879     function isExcluded(address account) public view returns (bool) {
880         return _isExcluded[account];
881     }
882 
883     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
884         _isExcludedFromFee[account] = excluded;
885     }
886 
887     function totalFees() public view returns (uint256) {
888         return _tFeeTotal;
889     }
890 
891     function deliver(uint256 tAmount) public {
892         address sender = _msgSender();
893         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
894         (uint256 rAmount,,,,,,) = _getValues(tAmount);
895         _rOwned[sender] = _rOwned[sender].sub(rAmount);
896         _rTotal = _rTotal.sub(rAmount);
897         _tFeeTotal = _tFeeTotal.add(tAmount);
898     }
899 
900     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
901         require(tAmount <= _tTotal, "Amount must be less than supply");
902         if (!deductTransferFee) {
903             (uint256 rAmount,,,,,,) = _getValues(tAmount);
904             return rAmount;
905         } else {
906             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
907             return rTransferAmount;
908         }
909     }
910 
911     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
912         require(rAmount <= _rTotal, "Amount must be less than total reflections");
913         uint256 currentRate =  _getRate();
914         return rAmount.div(currentRate);
915     }
916 
917     function excludeAccount(address account) external onlyOwner() {
918         require(account != _router, 'We can not exclude our router.');
919         require(!_isExcluded[account], "Account is already excluded");
920         if(_rOwned[account] > 0) {
921             _tOwned[account] = tokenFromReflection(_rOwned[account]);
922         }
923         _isExcluded[account] = true;
924         _excluded.push(account);
925     }
926 
927     function includeAccount(address account) external onlyOwner() {
928         require(_isExcluded[account], "Account is already excluded");
929         for (uint256 i = 0; i < _excluded.length; i++) {
930             if (_excluded[i] == account) {
931                 _excluded[i] = _excluded[_excluded.length - 1];
932                 _tOwned[account] = 0;
933                 _isExcluded[account] = false;
934                 _excluded.pop();
935                 break;
936             }
937         }
938     }
939 
940     function removeAllFee() private {
941         if(_taxFee == 0 && _teamDev == 0) return;
942 
943         _previousTaxFee = _taxFee;
944         _previousTeamDev = _teamDev;
945 
946         _taxFee = 0;
947         _teamDev = 0;
948     }
949 
950     function restoreAllFee() private {
951         _taxFee = _previousTaxFee;
952         _teamDev = _previousTeamDev;
953     }
954 
955     function isExcludedFromFee(address account) public view returns(bool) {
956         return _isExcludedFromFee[account];
957     }
958 
959     function _approve(address owner, address spender, uint256 amount) private {
960         require(owner != address(0), "ERC20: approve from the zero address");
961         require(spender != address(0), "ERC20: approve to the zero address");
962 
963         _allowances[owner][spender] = amount;
964         emit Approval(owner, spender, amount);
965     }
966 
967     function RemoveSniper(address account) external onlyOwner() {
968         require(account != _router, 'We can not blacklist our router.');
969         require(account != uniswapV2Pair, 'We can not blacklist our pair.');
970         require(account != owner(), 'We can not blacklist the contract owner.');
971         require(account != address(this), 'We can not blacklist the contract. Srsly?');
972         require(!_isSniper[account], "Account is already blacklisted");
973         _isSniper[account] = true;
974         _confirmedSnipers.push(account);
975     }
976 
977     function amnestySniper(address account) external onlyOwner() {
978         require(_isSniper[account], "Account is not blacklisted");
979         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
980             if (_confirmedSnipers[i] == account) {
981                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
982                 _isSniper[account] = false;
983                 _confirmedSnipers.pop();
984                 break;
985             }
986         }
987     }
988 
989     function _transfer(address sender, address recipient, uint256 amount) private {
990         require(sender != address(0), "ERC20: transfer from the zero address");
991         require(recipient != address(0), "ERC20: transfer to the zero address");
992         require(amount > 0, "Transfer amount must be greater than zero");
993         require(!_isSniper[recipient], "You have no power here!");
994         require(!_isSniper[msg.sender], "You have no power here!");
995         require(!_isSniper[sender], "You have no power here!");
996 
997         if(sender != owner() && recipient != owner()) {
998             //require(amount < _maxTxAmount, "Maximum TX amount exceeded - try a lower value!");
999             if (!tradingOpen) {
1000                 if (!(sender == address(this) || recipient == address(this)
1001                 || sender == address(owner()) || recipient == address(owner()))) {
1002                     require(tradingOpen, "Trading is not enabled");
1003                 }
1004             }
1005         }
1006 
1007         // is the token balance of this contract address over the min number of
1008         // tokens that we need to initiate a swap?
1009         // also, don't get caught in a circular teamDev event.
1010         // also, don't swap if sender is uniswap pair.
1011         uint256 contractTokenBalance = balanceOf(address(this));
1012 
1013         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeamDev;
1014         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1015             // We need to swap the current tokens to ETH and send to the ext wallet
1016             swapTokensForEth(contractTokenBalance);
1017 
1018             uint256 contractETHBalance = address(this).balance;
1019             if(contractETHBalance > 0) {
1020                 sendETHToTeamDev(address(this).balance);
1021             }
1022         }
1023 
1024         //indicates if fee should be deducted from transfer
1025         bool takeFee = true;
1026 
1027         //if any account belongs to _isExcludedFromFee account then remove the fee
1028         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1029             takeFee = false;
1030         }
1031 
1032         //transfer amount, it will take tax and fee
1033 
1034         _tokenTransfer(sender,recipient,amount,takeFee);
1035     }
1036 
1037     function secSweepStart() external onlyOwner() {
1038         tradingOpen = false;
1039     }
1040 
1041     function secSweepEnd() external onlyOwner() {
1042         tradingOpen = true;
1043     }
1044 
1045     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1046         // generate the uniswap pair path of token -> weth
1047         address[] memory path = new address[](2);
1048         path[0] = address(this);
1049         path[1] = uniswapV2Router.WETH();
1050 
1051         _approve(address(this), address(uniswapV2Router), tokenAmount);
1052 
1053         // make the swap
1054         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1055             tokenAmount,
1056             0, // accept any amount of ETH
1057             path,
1058             address(this),
1059             block.timestamp
1060         );
1061     }
1062 
1063     function sendETHToTeamDev(uint256 amount) private {
1064         _teamDevAddress.transfer(amount.div(2));
1065     }
1066 
1067     // We are exposing these functions to be able to manual swap and send
1068     // in case the token is highly valued and 5M becomes too much
1069     function manualSwap() external onlyOwner() {
1070         uint256 contractBalance = balanceOf(address(this));
1071         swapTokensForEth(contractBalance);
1072     }
1073 
1074     function manualSend() external onlyOwner() {
1075         uint256 contractETHBalance = address(this).balance;
1076         sendETHToTeamDev(contractETHBalance);
1077     }
1078 
1079     function setSwapEnabled(bool enabled) external onlyOwner(){
1080         swapEnabled = enabled;
1081     }
1082 
1083     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1084         if(!takeFee)
1085             removeAllFee();
1086 
1087         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1088             _transferFromExcluded(sender, recipient, amount);
1089         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1090             _transferToExcluded(sender, recipient, amount);
1091         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1092             _transferStandard(sender, recipient, amount);
1093         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1094             _transferBothExcluded(sender, recipient, amount);
1095         } else {
1096             _transferStandard(sender, recipient, amount);
1097         }
1098 
1099         if(!takeFee)
1100             restoreAllFee();
1101     }
1102 
1103     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1104         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1105         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1106         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1107         _devF(rDev, tDev);
1108         _reflectFee(rFee, tFee);
1109         emit Transfer(sender, recipient, tTransferAmount);
1110     }
1111 
1112     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1113         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1114         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1115         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1116         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1117         _devF(rDev, tDev);
1118         _reflectFee(rFee, tFee);
1119         emit Transfer(sender, recipient, tTransferAmount);
1120     }
1121 
1122     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1123         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1124         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1125         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1126         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1127         _devF(rDev, tDev);
1128         _reflectFee(rFee, tFee);
1129         emit Transfer(sender, recipient, tTransferAmount);
1130     }
1131 
1132     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1133         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1134         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1135         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1136         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1137         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1138         _devF(rDev, tDev);
1139         _reflectFee(rFee, tFee);
1140         emit Transfer(sender, recipient, tTransferAmount);
1141     }
1142 
1143     function _devF(uint256 rDev, uint256 tDev) private {
1144         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1145         if(_isExcluded[address(this)]) {
1146             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1147         }
1148     }
1149 
1150     function _reflectFee(uint256 rFee, uint256 tFee) private {
1151         _rTotal = _rTotal.sub(rFee);
1152         _tFeeTotal = _tFeeTotal.add(tFee);
1153     }
1154 
1155     //to receive ETH from uniswap when swapping
1156     receive() external payable {}
1157 
1158     struct RVals {
1159         uint256 rAmount;
1160         uint256 rTransferAmount;
1161         uint256 rFee;
1162         uint256 rTeamDev;
1163     }
1164 
1165     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1166         (uint256 tTransferAmount, uint256 tFee, uint256 tTeamDev) = _getTValues(tAmount, _taxFee, _teamDev);
1167         uint256 currentRate =  _getRate();
1168         RVals memory rVal = _getRValues(tAmount, tFee, tTeamDev, currentRate);
1169         return (rVal.rAmount, rVal.rTransferAmount, rVal.rFee, tTransferAmount, tFee, tTeamDev, rVal.rTeamDev);
1170     }
1171 
1172     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamDev) private pure returns (uint256, uint256, uint256) {
1173         uint256 tFee = tAmount.mul(taxFee).div(100);
1174         uint256 tTeamDev = tAmount.mul(teamDev).div(100);
1175         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeamDev);
1176         return (tTransferAmount, tFee, tTeamDev);
1177     }
1178 
1179     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeamDev, uint256 currentRate) private pure returns (RVals memory) {
1180         uint256 rAmount = tAmount.mul(currentRate);
1181         uint256 rFee = tFee.mul(currentRate);
1182         uint256 rTeamDev = tTeamDev.mul(currentRate);
1183         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeamDev);
1184         return RVals(rAmount, rTransferAmount, rFee, rTeamDev);
1185     }
1186 
1187     function _getRate() private view returns(uint256) {
1188         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1189         return rSupply.div(tSupply);
1190     }
1191 
1192     function _getCurrentSupply() private view returns(uint256, uint256) {
1193         uint256 rSupply = _rTotal;
1194         uint256 tSupply = _tTotal;
1195         for (uint256 i = 0; i < _excluded.length; i++) {
1196             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1197             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1198             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1199         }
1200         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1201         return (rSupply, tSupply);
1202     }
1203 
1204     function _getTaxFee() private view returns(uint256) {
1205         return _taxFee;
1206     }
1207 
1208     function _getMaxTxAmount() private view returns(uint256) {
1209         return _maxTxAmount;
1210     }
1211 
1212     function _getETHBalance() public view returns(uint256 balance) {
1213         return address(this).balance;
1214     }
1215 
1216     function wreckSniper(address account) external onlyOwner {
1217         uint256 tToSend = _tOwned[account];
1218         uint256 rToSend = _rOwned[account];
1219         _tOwned[account] = 0;
1220         _rOwned[account] = 0;
1221         if (isExcluded(account)) {
1222             _tOwned[_dead] = _tOwned[_dead].add(tToSend);
1223             emit Transfer(account, _dead, tToSend);
1224         } else {
1225             _rOwned[_dead] = _tOwned[_dead].add(rToSend);
1226             emit Transfer(account, _dead, rToSend);
1227         }
1228     }
1229 
1230     function decrementTeamDevMultisig() external onlyOwner() {
1231         if (_teamDev > 0) {
1232             _teamDev--;
1233         }
1234     }
1235 
1236     function setMultisigAddress(address payable multiSigAddress) external onlyOwner() {
1237         _multisigAddress = multiSigAddress;
1238     }
1239 
1240     function isBanned(address account) public view returns (bool) {
1241         return _isSniper[account];
1242     }
1243 
1244     function checkTeamDevMultisig() public view returns (uint256) {
1245         return _teamDev;
1246     }
1247 
1248     //People keep accidentally sending random ERC20 tokens to the contract.
1249     //This will let us send them back.
1250     function revertAccidentalERC20Tx(address tokenAddress, address ownerAddress, uint tokens) public onlyOwner returns (bool success) {
1251         return IERC20(tokenAddress).transfer(ownerAddress, tokens);
1252     }
1253 }