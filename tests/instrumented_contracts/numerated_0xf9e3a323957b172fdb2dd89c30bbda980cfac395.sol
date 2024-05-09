1 // $AstroLion | AstroLion v2
2 // Designed by @TristenEscolastico / Tristen Esco
3 // TG: t.me/AstroLionToken
4 // Web: https://astrolion.net
5 
6 // Originally Fair Launched, redeployed due to contract bug.
7 
8 // Supply re-scaled to 1Q tokens, converted to deflationary.
9 // Airdrop completed on a 1:1 Basis with LP provided by FLC.
10 
11 // Slippage Recommended: 10%
12 // Contract & relaunch handled by https://t.me/FairLaunchCalls
13 // Community-owned token
14 
15 /**
16  *     _.---.._             _.---...__
17  *  .-'   /\   \          .'  /\     /
18  *  `.   (  )   \        /   (  )   /
19  *    `.  \/   .'\      /`.   \/  .'
20  *      ``---''   )    (   ``---''
21  *              .';.--.;`.
22  *            .' /_...._\ `.
23  *          .'   `.a  a.'   `.
24  *         (        \/        )
25  *          `.___..-'`-..___.'
26  *             \          /
27  *              `-.____.-'
28 */
29 
30 // SPDX-License-Identifier: Unlicensed
31 pragma solidity ^0.6.12;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 interface IERC20 {
45     /**
46     * @dev Returns the amount of tokens in existence.
47     */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51     * @dev Returns the amount of tokens owned by `account`.
52     */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56     * @dev Moves `amount` tokens from the caller's account to `recipient`.
57     *
58     * Returns a boolean value indicating whether the operation succeeded.
59     *
60     * Emits a {Transfer} event.
61     */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65     * @dev Returns the remaining number of tokens that `spender` will be
66     * allowed to spend on behalf of `owner` through {transferFrom}. This is
67     * zero by default.
68     *
69     * This value changes when {approve} or {transferFrom} are called.
70     */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75     *
76     * Returns a boolean value indicating whether the operation succeeded.
77     *
78     * IMPORTANT: Beware that changing an allowance with this method brings the risk
79     * that someone may use both the old and the new allowance by unfortunate
80     * transaction ordering. One possible solution to mitigate this race
81     * condition is to first reduce the spender's allowance to 0 and set the
82     * desired value afterwards:
83     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84     *
85     * Emits an {Approval} event.
86     */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90     * @dev Moves `amount` tokens from `sender` to `recipient` using the
91     * allowance mechanism. `amount` is then deducted from the caller's
92     * allowance.
93     *
94     * Returns a boolean value indicating whether the operation succeeded.
95     *
96     * Emits a {Transfer} event.
97     */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101     * @dev Emitted when `value` tokens are moved from one account (`from`) to
102     * another (`to`).
103     *
104     * Note that `value` may be zero.
105     */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110     * a call to {approve}. `value` is the new allowance.
111     */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
114 
115 library SafeMath {
116     /**
117     * @dev Returns the addition of two unsigned integers, reverting on
118     * overflow.
119     *
120     * Counterpart to Solidity's `+` operator.
121     *
122     * Requirements:
123     *
124     * - Addition cannot overflow.
125     */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134     * @dev Returns the subtraction of two unsigned integers, reverting on
135     * overflow (when the result is negative).
136     *
137     * Counterpart to Solidity's `-` operator.
138     *
139     * Requirements:
140     *
141     * - Subtraction cannot overflow.
142     */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149     * overflow (when the result is negative).
150     *
151     * Counterpart to Solidity's `-` operator.
152     *
153     * Requirements:
154     *
155     * - Subtraction cannot overflow.
156     */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165     * @dev Returns the multiplication of two unsigned integers, reverting on
166     * overflow.
167     *
168     * Counterpart to Solidity's `*` operator.
169     *
170     * Requirements:
171     *
172     * - Multiplication cannot overflow.
173     */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189     * @dev Returns the integer division of two unsigned integers. Reverts on
190     * division by zero. The result is rounded towards zero.
191     *
192     * Counterpart to Solidity's `/` operator. Note: this function uses a
193     * `revert` opcode (which leaves remaining gas untouched) while Solidity
194     * uses an invalid opcode to revert (consuming all remaining gas).
195     *
196     * Requirements:
197     *
198     * - The divisor cannot be zero.
199     */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206     * division by zero. The result is rounded towards zero.
207     *
208     * Counterpart to Solidity's `/` operator. Note: this function uses a
209     * `revert` opcode (which leaves remaining gas untouched) while Solidity
210     * uses an invalid opcode to revert (consuming all remaining gas).
211     *
212     * Requirements:
213     *
214     * - The divisor cannot be zero.
215     */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226     * Reverts when dividing by zero.
227     *
228     * Counterpart to Solidity's `%` operator. This function uses a `revert`
229     * opcode (which leaves remaining gas untouched) while Solidity uses an
230     * invalid opcode to revert (consuming all remaining gas).
231     *
232     * Requirements:
233     *
234     * - The divisor cannot be zero.
235     */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242     * Reverts with custom message when dividing by zero.
243     *
244     * Counterpart to Solidity's `%` operator. This function uses a `revert`
245     * opcode (which leaves remaining gas untouched) while Solidity uses an
246     * invalid opcode to revert (consuming all remaining gas).
247     *
248     * Requirements:
249     *
250     * - The divisor cannot be zero.
251     */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 library Address {
259     /**
260     * @dev Returns true if `account` is a contract.
261     *
262     * [IMPORTANT]
263     * ====
264     * It is unsafe to assume that an address for which this function returns
265     * false is an externally-owned account (EOA) and not a contract.
266     *
267     * Among others, `isContract` will return false for the following
268     * types of addresses:
269     *
270     *  - an externally-owned account
271     *  - a contract in construction
272     *  - an address where a contract will be created
273     *  - an address where a contract lived, but was destroyed
274     * ====
275     */
276     function isContract(address account) internal view returns (bool) {
277         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
278         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
279         // for accounts without code, i.e. `keccak256('')`
280         bytes32 codehash;
281         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { codehash := extcodehash(account) }
284         return (codehash != accountHash && codehash != 0x0);
285     }
286 
287     /**
288     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289     * `recipient`, forwarding all available gas and reverting on errors.
290     *
291     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292     * of certain opcodes, possibly making contracts go over the 2300 gas limit
293     * imposed by `transfer`, making them unable to receive funds via
294     * `transfer`. {sendValue} removes this limitation.
295     *
296     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297     *
298     * IMPORTANT: because control is transferred to `recipient`, care must be
299     * taken to not create reentrancy vulnerabilities. Consider using
300     * {ReentrancyGuard} or the
301     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302     */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{ value: amount }("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312     * @dev Performs a Solidity function call using a low level `call`. A
313     * plain`call` is an unsafe replacement for a function call: use this
314     * function instead.
315     *
316     * If `target` reverts with a revert reason, it is bubbled up by this
317     * function (like regular Solidity function calls).
318     *
319     * Returns the raw returned data. To convert to the expected return value,
320     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321     *
322     * Requirements:
323     *
324     * - `target` must be a contract.
325     * - calling `target` with `data` must not revert.
326     *
327     * _Available since v3.1._
328     */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330         return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335     * `errorMessage` as a fallback revert reason when `target` reverts.
336     *
337     * _Available since v3.1._
338     */
339     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
340         return _functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345     * but also transferring `value` wei to `target`.
346     *
347     * Requirements:
348     *
349     * - the calling contract must have an ETH balance of at least `value`.
350     * - the called Solidity function must be `payable`.
351     *
352     * _Available since v3.1._
353     */
354     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
356     }
357 
358     /**
359     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
360     * with `errorMessage` as a fallback revert reason when `target` reverts.
361     *
362     * _Available since v3.1._
363     */
364     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         return _functionCallWithValue(target, data, value, errorMessage);
367     }
368 
369     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 // solhint-disable-next-line no-inline-assembly
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 contract Ownable is Context {
394     address private _owner;
395     address private _previousOwner;
396     uint256 private _lockTime;
397 
398     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
399 
400     /**
401     * @dev Initializes the contract setting the deployer as the initial owner.
402     */
403     constructor () internal {
404         address msgSender = _msgSender();
405         _owner = msgSender;
406         emit OwnershipTransferred(address(0), msgSender);
407     }
408 
409     /**
410     * @dev Returns the address of the current owner.
411     */
412     function owner() public view returns (address) {
413         return _owner;
414     }
415 
416     /**
417     * @dev Throws if called by any account other than the owner.
418     */
419     modifier onlyOwner() {
420         require(_owner == _msgSender(), "Ownable: caller is not the owner");
421         _;
422     }
423 
424     /**
425     * @dev Leaves the contract without owner. It will not be possible to call
426     * `onlyOwner` functions anymore. Can only be called by the current owner.
427     *
428     * NOTE: Renouncing ownership will leave the contract without an owner,
429     * thereby removing any functionality that is only available to the owner.
430     */
431     function renounceOwnership() public virtual onlyOwner {
432         emit OwnershipTransferred(_owner, address(0));
433         _owner = address(0);
434     }
435 
436     /**
437     * @dev Transfers ownership of the contract to a new account (`newOwner`).
438     * Can only be called by the current owner.
439     */
440     function transferOwnership(address newOwner) public virtual onlyOwner {
441         require(newOwner != address(0), "Ownable: new owner is the zero address");
442         emit OwnershipTransferred(_owner, newOwner);
443         _owner = newOwner;
444     }
445 
446 }
447 
448 interface IUniswapV2Factory {
449     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
450 
451     function feeTo() external view returns (address);
452     function feeToSetter() external view returns (address);
453 
454     function getPair(address tokenA, address tokenB) external view returns (address pair);
455     function allPairs(uint) external view returns (address pair);
456     function allPairsLength() external view returns (uint);
457 
458     function createPair(address tokenA, address tokenB) external returns (address pair);
459 
460     function setFeeTo(address) external;
461     function setFeeToSetter(address) external;
462 }
463 
464 interface IUniswapV2Pair {
465     event Approval(address indexed owner, address indexed spender, uint value);
466     event Transfer(address indexed from, address indexed to, uint value);
467 
468     function name() external pure returns (string memory);
469     function symbol() external pure returns (string memory);
470     function decimals() external pure returns (uint8);
471     function totalSupply() external view returns (uint);
472     function balanceOf(address owner) external view returns (uint);
473     function allowance(address owner, address spender) external view returns (uint);
474 
475     function approve(address spender, uint value) external returns (bool);
476     function transfer(address to, uint value) external returns (bool);
477     function transferFrom(address from, address to, uint value) external returns (bool);
478 
479     function DOMAIN_SEPARATOR() external view returns (bytes32);
480     function PERMIT_TYPEHASH() external pure returns (bytes32);
481     function nonces(address owner) external view returns (uint);
482 
483     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
484 
485     //NB: This is an INTERFACE FUNCTION on the default UniSwapV2 Library.
486     //Feel free to check the contract itself - there's no implementation/way to use it to mint tokens.
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
508     //NB: This is an INTERFACE FUNCTION on the default UniSwapV2 Library.
509     //Feel free to check the contract itself - there's no implementation/way to use it to mint tokens.
510     function mint(address to) external returns (uint liquidity);
511     function burn(address to) external returns (uint amount0, uint amount1);
512     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
513     function skim(address to) external;
514     function sync() external;
515 
516     function initialize(address, address) external;
517 }
518 
519 interface IUniswapV2Router01 {
520     function factory() external pure returns (address);
521     function WETH() external pure returns (address);
522 
523     function addLiquidity(
524         address tokenA,
525         address tokenB,
526         uint amountADesired,
527         uint amountBDesired,
528         uint amountAMin,
529         uint amountBMin,
530         address to,
531         uint deadline
532     ) external returns (uint amountA, uint amountB, uint liquidity);
533     function addLiquidityETH(
534         address token,
535         uint amountTokenDesired,
536         uint amountTokenMin,
537         uint amountETHMin,
538         address to,
539         uint deadline
540     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
541     function removeLiquidity(
542         address tokenA,
543         address tokenB,
544         uint liquidity,
545         uint amountAMin,
546         uint amountBMin,
547         address to,
548         uint deadline
549     ) external returns (uint amountA, uint amountB);
550     function removeLiquidityETH(
551         address token,
552         uint liquidity,
553         uint amountTokenMin,
554         uint amountETHMin,
555         address to,
556         uint deadline
557     ) external returns (uint amountToken, uint amountETH);
558     function removeLiquidityWithPermit(
559         address tokenA,
560         address tokenB,
561         uint liquidity,
562         uint amountAMin,
563         uint amountBMin,
564         address to,
565         uint deadline,
566         bool approveMax, uint8 v, bytes32 r, bytes32 s
567     ) external returns (uint amountA, uint amountB);
568     function removeLiquidityETHWithPermit(
569         address token,
570         uint liquidity,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline,
575         bool approveMax, uint8 v, bytes32 r, bytes32 s
576     ) external returns (uint amountToken, uint amountETH);
577     function swapExactTokensForTokens(
578         uint amountIn,
579         uint amountOutMin,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external returns (uint[] memory amounts);
584     function swapTokensForExactTokens(
585         uint amountOut,
586         uint amountInMax,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external returns (uint[] memory amounts);
591     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
592     external
593     payable
594     returns (uint[] memory amounts);
595     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
596     external
597     returns (uint[] memory amounts);
598     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
599     external
600     returns (uint[] memory amounts);
601     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
602     external
603     payable
604     returns (uint[] memory amounts);
605 
606     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
607     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
608     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
609     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
610     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
611 }
612 
613 interface IUniswapV2Router02 is IUniswapV2Router01 {
614     function removeLiquidityETHSupportingFeeOnTransferTokens(
615         address token,
616         uint liquidity,
617         uint amountTokenMin,
618         uint amountETHMin,
619         address to,
620         uint deadline
621     ) external returns (uint amountETH);
622     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
623         address token,
624         uint liquidity,
625         uint amountTokenMin,
626         uint amountETHMin,
627         address to,
628         uint deadline,
629         bool approveMax, uint8 v, bytes32 r, bytes32 s
630     ) external returns (uint amountETH);
631 
632     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
633         uint amountIn,
634         uint amountOutMin,
635         address[] calldata path,
636         address to,
637         uint deadline
638     ) external;
639     function swapExactETHForTokensSupportingFeeOnTransferTokens(
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external payable;
645     function swapExactTokensForETHSupportingFeeOnTransferTokens(
646         uint amountIn,
647         uint amountOutMin,
648         address[] calldata path,
649         address to,
650         uint deadline
651     ) external;
652 }
653 
654 // Contract implementation
655 contract AstroLion is Context, IERC20, Ownable {
656     using SafeMath for uint256;
657     using Address for address;
658 
659     mapping (address => uint256) private _rOwned;
660     mapping (address => uint256) private _tOwned;
661     mapping (address => uint256) private _lastTx;
662     mapping (address => mapping (address => uint256)) private _allowances;
663 
664     mapping (address => bool) private _isExcludedFromFee;
665 
666     mapping (address => bool) private _isExcluded;
667     address[] private _excluded;
668 
669     uint256 private constant MAX = ~uint256(0);
670     uint256 private _tTotal = 1000000000000000000000000;
671     uint256 private _rTotal = (MAX - (MAX % _tTotal));
672     uint256 private _tFeeTotal;
673     uint256 public launchTime;
674     mapping (address => bool) private _isSniper;
675     address[] private _confirmedSnipers;
676 
677     string private _name = 'AstroLion V2 | AstroLion.net';
678     string private _symbol = 'AstroLion';
679     uint8 private _decimals = 9;
680 
681     uint256 private _taxFee = 0;
682     uint256 private _teamDev = 0;
683     uint256 private _previousTaxFee = _taxFee;
684     uint256 private _previousTeamDev = _teamDev;
685 
686     address payable private _teamDevAddress;
687     address payable private _multisigAddress;
688     address private _router = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
689     address private _dead = address(0x000000000000000000000000000000000000dEaD);
690 
691     IUniswapV2Router02 public uniswapV2Router;
692     address public uniswapV2Pair;
693 
694     bool inSwap = false;
695     bool public swapEnabled = true;
696     bool public tradingOpen = false;
697     bool private snipeProtectionOn = false;
698 
699     uint256 public _maxTxAmount = 10000000000000000000000;
700     uint256 private _numOfTokensToExchangeForTeamDev = 50000000000000000;
701     bool _txLimitsEnabled = true;
702 
703     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
704     event SwapEnabledUpdated(bool enabled);
705 
706     modifier lockTheSwap {
707         inSwap = true;
708         _;
709         inSwap = false;
710     }
711 
712     constructor () public {
713         _rOwned[_msgSender()] = _rTotal;
714 
715         emit Transfer(address(0), _msgSender(), _tTotal);
716     }
717 
718     function initContract() external onlyOwner() {
719         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
720         // Create a uniswap pair for this new token
721         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
722         .createPair(address(this), _uniswapV2Router.WETH());
723 
724         // set the rest of the contract variables
725         uniswapV2Router = _uniswapV2Router;
726         // Exclude owner and this contract from fee
727         _isExcludedFromFee[owner()] = true;
728         _isExcludedFromFee[address(this)] = true;
729 
730         // List of front-runner & sniper bots from t.me/FairLaunchCalls
731         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
732         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
733 
734         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
735         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
736 
737         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
738         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
739 
740         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
741         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
742 
743         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
744         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
745 
746         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
747         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
748 
749         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
750         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
751 
752         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
753         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
754 
755         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
756         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
757 
758         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
759         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
760 
761         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
762         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
763 
764         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
765         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
766 
767         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
768         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
769 
770         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
771         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
772 
773         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
774         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
775 
776         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
777         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
778 
779         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
780         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
781 
782         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
783         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
784 
785         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
786         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
787 
788         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
789         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
790 
791         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
792         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
793 
794         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
795         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
796 
797         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
798         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
799 
800         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
801         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
802 
803         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
804         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
805 
806         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
807         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
808 
809         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
810         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
811 
812         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
813         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
814 
815         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
816         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
817 
818         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
819         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
820 
821         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
822         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
823 
824         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
825         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
826 
827         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
828         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
829 
830         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
831         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
832 
833         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
834         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
835 
836         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
837         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
838 
839         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
840         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
841 
842         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
843         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
844 
845         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
846         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
847 
848         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
849         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
850 
851         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
852         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
853 
854         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
855         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
856 
857         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
858         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
859 
860         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
861         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
862 
863         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
864         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
865 
866         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
867         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
868 
869         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
870         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
871         
872         _teamDevAddress = payable(0xb7de10bf2700Cd28Cdf4fa74BBE9BDfa516ae560);
873     }
874 
875     function liftOpeningTXLimits() external onlyOwner() {
876         _maxTxAmount = 100000000000000000000000;
877     }
878 
879     function openTrading() external onlyOwner() {
880         swapEnabled = true;
881         tradingOpen = true;
882         launchTime = block.timestamp;
883     }
884     
885     function enableFees() external onlyOwner() {
886         _taxFee = 4;
887         _teamDev = 5;
888     }
889 
890     function name() public view returns (string memory) {
891         return _name;
892     }
893 
894     function symbol() public view returns (string memory) {
895         return _symbol;
896     }
897 
898     function decimals() public view returns (uint8) {
899         return _decimals;
900     }
901 
902     function totalSupply() public view override returns (uint256) {
903         return _tTotal;
904     }
905 
906     function balanceOf(address account) public view override returns (uint256) {
907         if (_isExcluded[account]) return _tOwned[account];
908         return tokenFromReflection(_rOwned[account]);
909     }
910 
911     function transfer(address recipient, uint256 amount) public override returns (bool) {
912         _transfer(_msgSender(), recipient, amount);
913         return true;
914     }
915 
916     function allowance(address owner, address spender) public view override returns (uint256) {
917         return _allowances[owner][spender];
918     }
919 
920     function approve(address spender, uint256 amount) public override returns (bool) {
921         _approve(_msgSender(), spender, amount);
922         return true;
923     }
924 
925     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
926         _transfer(sender, recipient, amount);
927         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
928         return true;
929     }
930 
931     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
932         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
933         return true;
934     }
935 
936     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
937         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
938         return true;
939     }
940 
941     function isExcluded(address account) public view returns (bool) {
942         return _isExcluded[account];
943     }
944 
945     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
946         _isExcludedFromFee[account] = excluded;
947     }
948 
949     function totalFees() public view returns (uint256) {
950         return _tFeeTotal;
951     }
952 
953     function deliver(uint256 tAmount) public {
954         address sender = _msgSender();
955         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
956         (uint256 rAmount,,,,,,) = _getValues(tAmount);
957         _rOwned[sender] = _rOwned[sender].sub(rAmount);
958         _rTotal = _rTotal.sub(rAmount);
959         _tFeeTotal = _tFeeTotal.add(tAmount);
960     }
961 
962     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
963         require(tAmount <= _tTotal, "Amount must be less than supply");
964         if (!deductTransferFee) {
965             (uint256 rAmount,,,,,,) = _getValues(tAmount);
966             return rAmount;
967         } else {
968             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
969             return rTransferAmount;
970         }
971     }
972 
973     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
974         require(rAmount <= _rTotal, "Amount must be less than total reflections");
975         uint256 currentRate =  _getRate();
976         return rAmount.div(currentRate);
977     }
978 
979     function excludeAccount(address account) external onlyOwner() {
980         require(account != _router, 'We can not exclude our router.');
981         require(!_isExcluded[account], "Account is already excluded");
982         if(_rOwned[account] > 0) {
983             _tOwned[account] = tokenFromReflection(_rOwned[account]);
984         }
985         _isExcluded[account] = true;
986         _excluded.push(account);
987     }
988 
989     function includeAccount(address account) external onlyOwner() {
990         require(_isExcluded[account], "Account is already excluded");
991         for (uint256 i = 0; i < _excluded.length; i++) {
992             if (_excluded[i] == account) {
993                 _excluded[i] = _excluded[_excluded.length - 1];
994                 _tOwned[account] = 0;
995                 _isExcluded[account] = false;
996                 _excluded.pop();
997                 break;
998             }
999         }
1000     }
1001 
1002     function removeAllFee() private {
1003         if(_taxFee == 0 && _teamDev == 0) return;
1004 
1005         _previousTaxFee = _taxFee;
1006         _previousTeamDev = _teamDev;
1007 
1008         _taxFee = 0;
1009         _teamDev = 0;
1010     }
1011 
1012     function restoreAllFee() private {
1013         _taxFee = _previousTaxFee;
1014         _teamDev = _previousTeamDev;
1015     }
1016 
1017     function isExcludedFromFee(address account) public view returns(bool) {
1018         return _isExcludedFromFee[account];
1019     }
1020 
1021     function _approve(address owner, address spender, uint256 amount) private {
1022         require(owner != address(0), "ERC20: approve from the zero address");
1023         require(spender != address(0), "ERC20: approve to the zero address");
1024 
1025         _allowances[owner][spender] = amount;
1026         emit Approval(owner, spender, amount);
1027     }
1028 
1029     function RemoveSniper(address account) external onlyOwner() {
1030         require(account != _router, 'We can not blacklist our router.');
1031         require(account != uniswapV2Pair, 'We can not blacklist our pair.');
1032         require(account != owner(), 'We can not blacklist the contract owner.');
1033         require(account != address(this), 'We can not blacklist the contract. Srsly?');
1034         require(!_isSniper[account], "Account is already blacklisted");
1035         _isSniper[account] = true;
1036         _confirmedSnipers.push(account);
1037     }
1038 
1039     function amnestySniper(address account) external onlyOwner() {
1040         require(_isSniper[account], "Account is not blacklisted");
1041         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1042             if (_confirmedSnipers[i] == account) {
1043                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1044                 _isSniper[account] = false;
1045                 _confirmedSnipers.pop();
1046                 break;
1047             }
1048         }
1049     }
1050 
1051     function _transfer(address sender, address recipient, uint256 amount) private {
1052         require(sender != address(0), "ERC20: transfer from the zero address");
1053         require(recipient != address(0), "ERC20: transfer to the zero address");
1054         require(amount > 0, "Transfer amount must be greater than zero");
1055         require(!_isSniper[recipient], "You have no power here!");
1056         require(!_isSniper[msg.sender], "You have no power here!");
1057         require(!_isSniper[sender], "You have no power here!");
1058 
1059         if(sender != owner() && recipient != owner()) {
1060             require(amount < _maxTxAmount, "Maximum TX amount exceeded - try a lower value!");
1061             if (!tradingOpen) {
1062                 if (!(sender == address(this) || recipient == address(this)
1063                 || sender == address(owner()) || recipient == address(owner()))) {
1064                     require(tradingOpen, "Trading is not enabled");
1065                 }
1066             }
1067         }
1068 
1069         // is the token balance of this contract address over the min number of
1070         // tokens that we need to initiate a swap?
1071         // also, don't get caught in a circular teamDev event.
1072         // also, don't swap if sender is uniswap pair.
1073         uint256 contractTokenBalance = balanceOf(address(this));
1074 
1075         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeamDev;
1076         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1077             // We need to swap the current tokens to ETH and send to the ext wallet
1078             swapTokensForEth(contractTokenBalance);
1079 
1080             uint256 contractETHBalance = address(this).balance;
1081             if(contractETHBalance > 0) {
1082                 sendETHToTeamDev(address(this).balance);
1083             }
1084         }
1085 
1086         //indicates if fee should be deducted from transfer
1087         bool takeFee = true;
1088 
1089         //if any account belongs to _isExcludedFromFee account then remove the fee
1090         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1091             takeFee = false;
1092         }
1093 
1094         //transfer amount, it will take tax and fee
1095 
1096         _tokenTransfer(sender,recipient,amount,takeFee);
1097     }
1098 
1099     function secSweepStart() external onlyOwner() {
1100         tradingOpen = false;
1101     }
1102 
1103     function secSweepEnd() external onlyOwner() {
1104         tradingOpen = true;
1105     }
1106 
1107     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1108         // generate the uniswap pair path of token -> weth
1109         address[] memory path = new address[](2);
1110         path[0] = address(this);
1111         path[1] = uniswapV2Router.WETH();
1112 
1113         _approve(address(this), address(uniswapV2Router), tokenAmount);
1114 
1115         // make the swap
1116         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1117             tokenAmount,
1118             0, // accept any amount of ETH
1119             path,
1120             address(this),
1121             block.timestamp
1122         );
1123     }
1124 
1125     function sendETHToTeamDev(uint256 amount) private {
1126         _teamDevAddress.transfer(amount.div(2));
1127     }
1128 
1129     // We are exposing these functions to be able to manual swap and send
1130     // in case the token is highly valued and 5M becomes too much
1131     function manualSwap() external onlyOwner() {
1132         uint256 contractBalance = balanceOf(address(this));
1133         swapTokensForEth(contractBalance);
1134     }
1135 
1136     function manualSend() external onlyOwner() {
1137         uint256 contractETHBalance = address(this).balance;
1138         sendETHToTeamDev(contractETHBalance);
1139     }
1140 
1141     function setSwapEnabled(bool enabled) external onlyOwner(){
1142         swapEnabled = enabled;
1143     }
1144 
1145     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1146         if(!takeFee)
1147             removeAllFee();
1148 
1149         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1150             _transferFromExcluded(sender, recipient, amount);
1151         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1152             _transferToExcluded(sender, recipient, amount);
1153         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1154             _transferStandard(sender, recipient, amount);
1155         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1156             _transferBothExcluded(sender, recipient, amount);
1157         } else {
1158             _transferStandard(sender, recipient, amount);
1159         }
1160 
1161         if(!takeFee)
1162             restoreAllFee();
1163     }
1164 
1165     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1166         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1167         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1168         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1169         _devF(rDev, tDev);
1170         _reflectFee(rFee, tFee);
1171         emit Transfer(sender, recipient, tTransferAmount);
1172     }
1173 
1174     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1175         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1176         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1177         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1178         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1179         _devF(rDev, tDev);
1180         _reflectFee(rFee, tFee);
1181         emit Transfer(sender, recipient, tTransferAmount);
1182     }
1183 
1184     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1185         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1186         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1187         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1188         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1189         _devF(rDev, tDev);
1190         _reflectFee(rFee, tFee);
1191         emit Transfer(sender, recipient, tTransferAmount);
1192     }
1193 
1194     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1195         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tDev, uint256 rDev) = _getValues(tAmount);
1196         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1197         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1198         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1199         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1200         _devF(rDev, tDev);
1201         _reflectFee(rFee, tFee);
1202         emit Transfer(sender, recipient, tTransferAmount);
1203     }
1204 
1205     function _devF(uint256 rDev, uint256 tDev) private {
1206         _rOwned[address(this)] = _rOwned[address(this)].add(rDev);
1207         if(_isExcluded[address(this)]) {
1208             _tOwned[address(this)] = _tOwned[address(this)].add(tDev);
1209         }
1210     }
1211 
1212     function _reflectFee(uint256 rFee, uint256 tFee) private {
1213         _rTotal = _rTotal.sub(rFee);
1214         _tFeeTotal = _tFeeTotal.add(tFee);
1215     }
1216 
1217     //to receive ETH from uniswap when swapping
1218     receive() external payable {}
1219 
1220     struct RVals {
1221         uint256 rAmount;
1222         uint256 rTransferAmount;
1223         uint256 rFee;
1224         uint256 rTeamDev;
1225     }
1226 
1227     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1228         (uint256 tTransferAmount, uint256 tFee, uint256 tTeamDev) = _getTValues(tAmount, _taxFee, _teamDev);
1229         uint256 currentRate =  _getRate();
1230         RVals memory rVal = _getRValues(tAmount, tFee, tTeamDev, currentRate);
1231         return (rVal.rAmount, rVal.rTransferAmount, rVal.rFee, tTransferAmount, tFee, tTeamDev, rVal.rTeamDev);
1232     }
1233 
1234     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamDev) private pure returns (uint256, uint256, uint256) {
1235         uint256 tFee = tAmount.mul(taxFee).div(100);
1236         uint256 tTeamDev = tAmount.mul(teamDev).div(100);
1237         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeamDev);
1238         return (tTransferAmount, tFee, tTeamDev);
1239     }
1240 
1241     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeamDev, uint256 currentRate) private pure returns (RVals memory) {
1242         uint256 rAmount = tAmount.mul(currentRate);
1243         uint256 rFee = tFee.mul(currentRate);
1244         uint256 rTeamDev = tTeamDev.mul(currentRate);
1245         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeamDev);
1246         return RVals(rAmount, rTransferAmount, rFee, rTeamDev);
1247     }
1248 
1249     function _getRate() private view returns(uint256) {
1250         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1251         return rSupply.div(tSupply);
1252     }
1253 
1254     function _getCurrentSupply() private view returns(uint256, uint256) {
1255         uint256 rSupply = _rTotal;
1256         uint256 tSupply = _tTotal;
1257         for (uint256 i = 0; i < _excluded.length; i++) {
1258             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1259             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1260             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1261         }
1262         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1263         return (rSupply, tSupply);
1264     }
1265 
1266     function _getTaxFee() private view returns(uint256) {
1267         return _taxFee;
1268     }
1269 
1270     function _getMaxTxAmount() private view returns(uint256) {
1271         return _maxTxAmount;
1272     }
1273 
1274     function _getETHBalance() public view returns(uint256 balance) {
1275         return address(this).balance;
1276     }
1277 
1278     function setExtWallet(address payable teamDevAddress) external onlyOwner() {
1279         _teamDevAddress = teamDevAddress;
1280     }
1281 
1282     function wreckSniper(address account) external onlyOwner {
1283         uint tToSend = _tOwned[account];
1284         uint rToSend = _rOwned[account];
1285         _tOwned[account] = 0;
1286         _rOwned[account] = 0;
1287         _tOwned[_dead] = tToSend;
1288         _rOwned[_dead] = rToSend;
1289         if (isExcluded(account)) {
1290             emit Transfer(account, _dead, tToSend);
1291         } else {
1292             emit Transfer(account, _dead, rToSend);
1293         }
1294     }
1295 
1296     function decrementTeamDevMultisig() external onlyOwner() {
1297         if (_teamDev > 0) {
1298             _teamDev--;
1299         }
1300     }
1301 
1302     function setMultisigAddress(address payable multiSigAddress) external onlyOwner() {
1303         _multisigAddress = multiSigAddress;
1304     }
1305 
1306     function isBanned(address account) public view returns (bool) {
1307         return _isSniper[account];
1308     }
1309 
1310     function checkTeamDevMultisig() public view returns (uint256) {
1311         return _teamDev;
1312     }
1313 
1314     //People keep accidentally sending random ERC20 tokens to the contract.
1315     //This will let us send them back.
1316     function revertAccidentalERC20Tx(address tokenAddress, address ownerAddress, uint tokens) public onlyOwner returns (bool success) {
1317         return IERC20(tokenAddress).transfer(ownerAddress, tokens);
1318     }
1319 }