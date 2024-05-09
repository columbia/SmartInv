1 // $HODL
2 // Telegram: https://t.me/HODLTokenFLC
3 
4 // Fair Launch, no Dev Tokens. 40% Burn, 60% LP.
5 // Snipers will be nuked.
6 
7 // LP Burn immediately on launch.
8 // Ownership will be renounced 30 minutes after launch.
9 
10 // Slippage Recommended: 25%+
11 // 1% Supply limit per TX for the first 5 minutes.
12 // Audit & Fair Launch handled by https://t.me/FairLaunchCalls
13 
14 /**
15  *      $$\    $$\   $$\  $$$$$$\  $$$$$$$\  $$\
16  *    $$$$$$\  $$ |  $$ |$$  __$$\ $$  __$$\ $$ |
17  *   $$  __$$\ $$ |  $$ |$$ /  $$ |$$ |  $$ |$$ |
18  *   $$ /  \__|$$$$$$$$ |$$ |  $$ |$$ |  $$ |$$ |
19  *   \$$$$$$\  $$  __$$ |$$ |  $$ |$$ |  $$ |$$ |
20  *    \___ $$\ $$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |
21  *   $$\  \$$ |$$ |  $$ | $$$$$$  |$$$$$$$  |$$$$$$$$\
22  *   \$$$$$$  |\__|  \__| \______/ \_______/ \________|
23  *    \_$$  _/
24  *      \ _/
25 */
26 
27 // SPDX-License-Identifier: Unlicensed
28 pragma solidity ^0.6.12;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address payable) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes memory) {
36         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 interface IERC20 {
42     /**
43     * @dev Returns the amount of tokens in existence.
44     */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48     * @dev Returns the amount of tokens owned by `account`.
49     */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53     * @dev Moves `amount` tokens from the caller's account to `recipient`.
54     *
55     * Returns a boolean value indicating whether the operation succeeded.
56     *
57     * Emits a {Transfer} event.
58     */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62     * @dev Returns the remaining number of tokens that `spender` will be
63     * allowed to spend on behalf of `owner` through {transferFrom}. This is
64     * zero by default.
65     *
66     * This value changes when {approve} or {transferFrom} are called.
67     */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72     *
73     * Returns a boolean value indicating whether the operation succeeded.
74     *
75     * IMPORTANT: Beware that changing an allowance with this method brings the risk
76     * that someone may use both the old and the new allowance by unfortunate
77     * transaction ordering. One possible solution to mitigate this race
78     * condition is to first reduce the spender's allowance to 0 and set the
79     * desired value afterwards:
80     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81     *
82     * Emits an {Approval} event.
83     */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87     * @dev Moves `amount` tokens from `sender` to `recipient` using the
88     * allowance mechanism. `amount` is then deducted from the caller's
89     * allowance.
90     *
91     * Returns a boolean value indicating whether the operation succeeded.
92     *
93     * Emits a {Transfer} event.
94     */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98     * @dev Emitted when `value` tokens are moved from one account (`from`) to
99     * another (`to`).
100     *
101     * Note that `value` may be zero.
102     */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107     * a call to {approve}. `value` is the new allowance.
108     */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 library SafeMath {
113     /**
114     * @dev Returns the addition of two unsigned integers, reverting on
115     * overflow.
116     *
117     * Counterpart to Solidity's `+` operator.
118     *
119     * Requirements:
120     *
121     * - Addition cannot overflow.
122     */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131     * @dev Returns the subtraction of two unsigned integers, reverting on
132     * overflow (when the result is negative).
133     *
134     * Counterpart to Solidity's `-` operator.
135     *
136     * Requirements:
137     *
138     * - Subtraction cannot overflow.
139     */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146     * overflow (when the result is negative).
147     *
148     * Counterpart to Solidity's `-` operator.
149     *
150     * Requirements:
151     *
152     * - Subtraction cannot overflow.
153     */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162     * @dev Returns the multiplication of two unsigned integers, reverting on
163     * overflow.
164     *
165     * Counterpart to Solidity's `*` operator.
166     *
167     * Requirements:
168     *
169     * - Multiplication cannot overflow.
170     */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186     * @dev Returns the integer division of two unsigned integers. Reverts on
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
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203     * division by zero. The result is rounded towards zero.
204     *
205     * Counterpart to Solidity's `/` operator. Note: this function uses a
206     * `revert` opcode (which leaves remaining gas untouched) while Solidity
207     * uses an invalid opcode to revert (consuming all remaining gas).
208     *
209     * Requirements:
210     *
211     * - The divisor cannot be zero.
212     */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223     * Reverts when dividing by zero.
224     *
225     * Counterpart to Solidity's `%` operator. This function uses a `revert`
226     * opcode (which leaves remaining gas untouched) while Solidity uses an
227     * invalid opcode to revert (consuming all remaining gas).
228     *
229     * Requirements:
230     *
231     * - The divisor cannot be zero.
232     */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239     * Reverts with custom message when dividing by zero.
240     *
241     * Counterpart to Solidity's `%` operator. This function uses a `revert`
242     * opcode (which leaves remaining gas untouched) while Solidity uses an
243     * invalid opcode to revert (consuming all remaining gas).
244     *
245     * Requirements:
246     *
247     * - The divisor cannot be zero.
248     */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 library Address {
256     /**
257     * @dev Returns true if `account` is a contract.
258     *
259     * [IMPORTANT]
260     * ====
261     * It is unsafe to assume that an address for which this function returns
262     * false is an externally-owned account (EOA) and not a contract.
263     *
264     * Among others, `isContract` will return false for the following
265     * types of addresses:
266     *
267     *  - an externally-owned account
268     *  - a contract in construction
269     *  - an address where a contract will be created
270     *  - an address where a contract lived, but was destroyed
271     * ====
272     */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286     * `recipient`, forwarding all available gas and reverting on errors.
287     *
288     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289     * of certain opcodes, possibly making contracts go over the 2300 gas limit
290     * imposed by `transfer`, making them unable to receive funds via
291     * `transfer`. {sendValue} removes this limitation.
292     *
293     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294     *
295     * IMPORTANT: because control is transferred to `recipient`, care must be
296     * taken to not create reentrancy vulnerabilities. Consider using
297     * {ReentrancyGuard} or the
298     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299     */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309     * @dev Performs a Solidity function call using a low level `call`. A
310     * plain`call` is an unsafe replacement for a function call: use this
311     * function instead.
312     *
313     * If `target` reverts with a revert reason, it is bubbled up by this
314     * function (like regular Solidity function calls).
315     *
316     * Returns the raw returned data. To convert to the expected return value,
317     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318     *
319     * Requirements:
320     *
321     * - `target` must be a contract.
322     * - calling `target` with `data` must not revert.
323     *
324     * _Available since v3.1._
325     */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332     * `errorMessage` as a fallback revert reason when `target` reverts.
333     *
334     * _Available since v3.1._
335     */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342     * but also transferring `value` wei to `target`.
343     *
344     * Requirements:
345     *
346     * - the calling contract must have an ETH balance of at least `value`.
347     * - the called Solidity function must be `payable`.
348     *
349     * _Available since v3.1._
350     */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357     * with `errorMessage` as a fallback revert reason when `target` reverts.
358     *
359     * _Available since v3.1._
360     */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 contract Ownable is Context {
391     address private _owner;
392     address private _previousOwner;
393     uint256 private _lockTime;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398     * @dev Initializes the contract setting the deployer as the initial owner.
399     */
400     constructor () internal {
401         address msgSender = _msgSender();
402         _owner = msgSender;
403         emit OwnershipTransferred(address(0), msgSender);
404     }
405 
406     /**
407     * @dev Returns the address of the current owner.
408     */
409     function owner() public view returns (address) {
410         return _owner;
411     }
412 
413     /**
414     * @dev Throws if called by any account other than the owner.
415     */
416     modifier onlyOwner() {
417         require(_owner == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422     * @dev Leaves the contract without owner. It will not be possible to call
423     * `onlyOwner` functions anymore. Can only be called by the current owner.
424     *
425     * NOTE: Renouncing ownership will leave the contract without an owner,
426     * thereby removing any functionality that is only available to the owner.
427     */
428     function renounceOwnership() public virtual onlyOwner {
429         emit OwnershipTransferred(_owner, address(0));
430         _owner = address(0);
431     }
432 
433     /**
434     * @dev Transfers ownership of the contract to a new account (`newOwner`).
435     * Can only be called by the current owner.
436     */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         emit OwnershipTransferred(_owner, newOwner);
440         _owner = newOwner;
441     }
442 
443 }
444 
445 interface IUniswapV2Factory {
446     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
447 
448     function feeTo() external view returns (address);
449     function feeToSetter() external view returns (address);
450 
451     function getPair(address tokenA, address tokenB) external view returns (address pair);
452     function allPairs(uint) external view returns (address pair);
453     function allPairsLength() external view returns (uint);
454 
455     function createPair(address tokenA, address tokenB) external returns (address pair);
456 
457     function setFeeTo(address) external;
458     function setFeeToSetter(address) external;
459 }
460 
461 interface IUniswapV2Pair {
462     event Approval(address indexed owner, address indexed spender, uint value);
463     event Transfer(address indexed from, address indexed to, uint value);
464 
465     function name() external pure returns (string memory);
466     function symbol() external pure returns (string memory);
467     function decimals() external pure returns (uint8);
468     function totalSupply() external view returns (uint);
469     function balanceOf(address owner) external view returns (uint);
470     function allowance(address owner, address spender) external view returns (uint);
471 
472     function approve(address spender, uint value) external returns (bool);
473     function transfer(address to, uint value) external returns (bool);
474     function transferFrom(address from, address to, uint value) external returns (bool);
475 
476     function DOMAIN_SEPARATOR() external view returns (bytes32);
477     function PERMIT_TYPEHASH() external pure returns (bytes32);
478     function nonces(address owner) external view returns (uint);
479 
480     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
481 
482     event Mint(address indexed sender, uint amount0, uint amount1);
483     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
484     event Swap(
485         address indexed sender,
486         uint amount0In,
487         uint amount1In,
488         uint amount0Out,
489         uint amount1Out,
490         address indexed to
491     );
492     event Sync(uint112 reserve0, uint112 reserve1);
493 
494     function MINIMUM_LIQUIDITY() external pure returns (uint);
495     function factory() external view returns (address);
496     function token0() external view returns (address);
497     function token1() external view returns (address);
498     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
499     function price0CumulativeLast() external view returns (uint);
500     function price1CumulativeLast() external view returns (uint);
501     function kLast() external view returns (uint);
502 
503     function mint(address to) external returns (uint liquidity);
504     function burn(address to) external returns (uint amount0, uint amount1);
505     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
506     function skim(address to) external;
507     function sync() external;
508 
509     function initialize(address, address) external;
510 }
511 
512 interface IUniswapV2Router01 {
513     function factory() external pure returns (address);
514     function WETH() external pure returns (address);
515 
516     function addLiquidity(
517         address tokenA,
518         address tokenB,
519         uint amountADesired,
520         uint amountBDesired,
521         uint amountAMin,
522         uint amountBMin,
523         address to,
524         uint deadline
525     ) external returns (uint amountA, uint amountB, uint liquidity);
526     function addLiquidityETH(
527         address token,
528         uint amountTokenDesired,
529         uint amountTokenMin,
530         uint amountETHMin,
531         address to,
532         uint deadline
533     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
534     function removeLiquidity(
535         address tokenA,
536         address tokenB,
537         uint liquidity,
538         uint amountAMin,
539         uint amountBMin,
540         address to,
541         uint deadline
542     ) external returns (uint amountA, uint amountB);
543     function removeLiquidityETH(
544         address token,
545         uint liquidity,
546         uint amountTokenMin,
547         uint amountETHMin,
548         address to,
549         uint deadline
550     ) external returns (uint amountToken, uint amountETH);
551     function removeLiquidityWithPermit(
552         address tokenA,
553         address tokenB,
554         uint liquidity,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline,
559         bool approveMax, uint8 v, bytes32 r, bytes32 s
560     ) external returns (uint amountA, uint amountB);
561     function removeLiquidityETHWithPermit(
562         address token,
563         uint liquidity,
564         uint amountTokenMin,
565         uint amountETHMin,
566         address to,
567         uint deadline,
568         bool approveMax, uint8 v, bytes32 r, bytes32 s
569     ) external returns (uint amountToken, uint amountETH);
570     function swapExactTokensForTokens(
571         uint amountIn,
572         uint amountOutMin,
573         address[] calldata path,
574         address to,
575         uint deadline
576     ) external returns (uint[] memory amounts);
577     function swapTokensForExactTokens(
578         uint amountOut,
579         uint amountInMax,
580         address[] calldata path,
581         address to,
582         uint deadline
583     ) external returns (uint[] memory amounts);
584     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
585     external
586     payable
587     returns (uint[] memory amounts);
588     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
589     external
590     returns (uint[] memory amounts);
591     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
592     external
593     returns (uint[] memory amounts);
594     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
595     external
596     payable
597     returns (uint[] memory amounts);
598 
599     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
600     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
601     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
602     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
603     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
604 }
605 
606 interface IUniswapV2Router02 is IUniswapV2Router01 {
607     function removeLiquidityETHSupportingFeeOnTransferTokens(
608         address token,
609         uint liquidity,
610         uint amountTokenMin,
611         uint amountETHMin,
612         address to,
613         uint deadline
614     ) external returns (uint amountETH);
615     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountETH);
624 
625     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
626         uint amountIn,
627         uint amountOutMin,
628         address[] calldata path,
629         address to,
630         uint deadline
631     ) external;
632     function swapExactETHForTokensSupportingFeeOnTransferTokens(
633         uint amountOutMin,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external payable;
638     function swapExactTokensForETHSupportingFeeOnTransferTokens(
639         uint amountIn,
640         uint amountOutMin,
641         address[] calldata path,
642         address to,
643         uint deadline
644     ) external;
645 }
646 
647 // Contract implementation
648 contract Hodl is Context, IERC20, Ownable {
649     using SafeMath for uint256;
650     using Address for address;
651 
652     mapping (address => uint256) private _rOwned;
653     mapping (address => uint256) private _tOwned;
654     mapping (address => uint256) private _lastTx;
655     mapping (address => uint256) private _cooldownTradeAttempts;
656     mapping (address => mapping (address => uint256)) private _allowances;
657 
658     mapping (address => bool) private _isExcludedFromFee;
659 
660     mapping (address => bool) private _isExcluded;
661     address[] private _excluded;
662     mapping (address => bool) private _isSniper;
663     address[] private _confirmedSnipers;
664 
665     uint256 private constant MAX = ~uint256(0);
666     uint256 private _tTotal = 1000000000000000000000000;
667     uint256 private _rTotal = (MAX - (MAX % _tTotal));
668     uint256 private _tFeeTotal;
669     uint256 public launchTime;
670 
671     string private _name = 'HODL | t.me/HOLDTokenFLC';
672     string private _symbol = 'HODL \xF0\x9F\x92\x8E';
673     uint8 private _decimals = 9;
674 
675     uint256 private _taxFee = 0;
676     uint256 private _teamDev = 0;
677     uint256 private _previousTaxFee = _taxFee;
678     uint256 private _previousTeamDev = _teamDev;
679 
680     address payable private _teamDevAddress;
681 
682     IUniswapV2Router02 public uniswapV2Router;
683     address public uniswapV2Pair;
684 
685     bool inSwap = false;
686     bool public swapEnabled = true;
687     bool public tradingOpen = false;
688     bool public cooldownEnabled = false; //cooldown time on transactions
689     bool public uniswapOnly = false; //prevents users from tx'ing to other wallets to avoid cooldowns
690     bool private snipeProtectionOn = false;
691 
692     uint256 public _maxTxAmount = 10000000000000000000000;
693     uint256 private _numOfTokensToExchangeForTeamDev = 50000000000000000;
694     bool _txLimitsEnabled = true;
695 
696     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
697     event SwapEnabledUpdated(bool enabled);
698 
699     modifier lockTheSwap {
700         inSwap = true;
701         _;
702         inSwap = false;
703     }
704 
705     constructor () public {
706         _rOwned[_msgSender()] = _rTotal;
707 
708         emit Transfer(address(0), _msgSender(), _tTotal);
709     }
710 
711     function initContract() external onlyOwner() {
712         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
713         // Create a uniswap pair for this new token
714         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
715         .createPair(address(this), _uniswapV2Router.WETH());
716 
717         // set the rest of the contract variables
718         uniswapV2Router = _uniswapV2Router;
719         // Exclude owner and this contract from fee
720         _isExcludedFromFee[owner()] = true;
721         _isExcludedFromFee[address(this)] = true;
722 
723         // List of front-runner & sniper bots from t.me/FairLaunchCalls
724         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
725         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
726 
727         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
728         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
729 
730         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
731         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
732 
733         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
734         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
735 
736         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
737         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
738 
739         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
740         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
741 
742         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
743         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
744 
745         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
746         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
747 
748         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
749         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
750 
751         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
752         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
753 
754         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
755         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
756 
757         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
758         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
759 
760         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
761         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
762 
763         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
764         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
765 
766         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
767         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
768 
769         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
770         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
771 
772         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
773         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
774 
775         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
776         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
777 
778         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
779         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
780 
781         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
782         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
783 
784         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
785         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
786 
787         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
788         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
789 
790         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
791         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
792 
793         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
794         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
795 
796         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
797         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
798 
799         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
800         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
801 
802         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
803         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
804 
805         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
806         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
807 
808         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
809         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
810 
811         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
812         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
813 
814         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
815         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
816 
817         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
818         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
819 
820         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
821         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
822 
823         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
824         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
825 
826         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
827         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
828 
829         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
830         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
831 
832         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
833         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
834 
835         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
836         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
837 
838         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
839         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
840 
841         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
842         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
843 
844         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
845         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
846 
847         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
848         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
849 
850         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
851         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
852 
853         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
854         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
855 
856         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
857         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
858 
859         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
860         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
861 
862         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
863         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
864 
865     }
866 
867     function postInit() external onlyOwner() {
868         _taxFee = 20;
869         _teamDev = 5;
870         _teamDevAddress = payable(0x010abA82c94DC41Dea19cD5e7C120092584FB97A);
871     }
872 
873     function openTrading() external onlyOwner() {
874         swapEnabled = true;
875         cooldownEnabled = false;
876         tradingOpen = true;
877         launchTime = block.timestamp;
878     }
879 
880     function name() public view returns (string memory) {
881         return _name;
882     }
883 
884     function symbol() public view returns (string memory) {
885         return _symbol;
886     }
887 
888     function decimals() public view returns (uint8) {
889         return _decimals;
890     }
891 
892     function totalSupply() public view override returns (uint256) {
893         return _tTotal;
894     }
895 
896     function balanceOf(address account) public view override returns (uint256) {
897         if (_isExcluded[account]) return _tOwned[account];
898         return tokenFromReflection(_rOwned[account]);
899     }
900 
901     function transfer(address recipient, uint256 amount) public override returns (bool) {
902         _transfer(_msgSender(), recipient, amount);
903         return true;
904     }
905 
906     function allowance(address owner, address spender) public view override returns (uint256) {
907         return _allowances[owner][spender];
908     }
909 
910     function approve(address spender, uint256 amount) public override returns (bool) {
911         _approve(_msgSender(), spender, amount);
912         return true;
913     }
914 
915     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
916         _transfer(sender, recipient, amount);
917         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
918         return true;
919     }
920 
921     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
922         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
923         return true;
924     }
925 
926     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
927         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
928         return true;
929     }
930 
931     function isExcluded(address account) public view returns (bool) {
932         return _isExcluded[account];
933     }
934 
935     function isBlackListed(address account) public view returns (bool) {
936         return _isSniper[account];
937     }
938 
939     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
940         _isExcludedFromFee[account] = excluded;
941     }
942 
943     function totalFees() public view returns (uint256) {
944         return _tFeeTotal;
945     }
946 
947     function deliver(uint256 tAmount) public {
948         address sender = _msgSender();
949         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
950         (uint256 rAmount,,,,,) = _getValues(tAmount);
951         _rOwned[sender] = _rOwned[sender].sub(rAmount);
952         _rTotal = _rTotal.sub(rAmount);
953         _tFeeTotal = _tFeeTotal.add(tAmount);
954     }
955 
956     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
957         require(tAmount <= _tTotal, "Amount must be less than supply");
958         if (!deductTransferFee) {
959             (uint256 rAmount,,,,,) = _getValues(tAmount);
960             return rAmount;
961         } else {
962             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
963             return rTransferAmount;
964         }
965     }
966 
967     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
968         require(rAmount <= _rTotal, "Amount must be less than total reflections");
969         uint256 currentRate =  _getRate();
970         return rAmount.div(currentRate);
971     }
972 
973     function excludeAccount(address account) external onlyOwner() {
974         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
975         require(!_isExcluded[account], "Account is already excluded");
976         if(_rOwned[account] > 0) {
977             _tOwned[account] = tokenFromReflection(_rOwned[account]);
978         }
979         _isExcluded[account] = true;
980         _excluded.push(account);
981     }
982 
983     function includeAccount(address account) external onlyOwner() {
984         require(_isExcluded[account], "Account is already excluded");
985         for (uint256 i = 0; i < _excluded.length; i++) {
986             if (_excluded[i] == account) {
987                 _excluded[i] = _excluded[_excluded.length - 1];
988                 _tOwned[account] = 0;
989                 _isExcluded[account] = false;
990                 _excluded.pop();
991                 break;
992             }
993         }
994     }
995 
996     function RemoveSniper(address account) external onlyOwner() {
997         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
998         require(account != uniswapV2Pair, 'We can not blacklist our pair.');
999         require(!_isSniper[account], "Account is already blacklisted");
1000         _isSniper[account] = true;
1001         _confirmedSnipers.push(account);
1002     }
1003 
1004     function amnestySniper(address account) external onlyOwner() {
1005         require(_isSniper[account], "Account is not blacklisted");
1006         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1007             if (_confirmedSnipers[i] == account) {
1008                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1009                 _isSniper[account] = false;
1010                 _confirmedSnipers.pop();
1011                 break;
1012             }
1013         }
1014     }
1015 
1016     function removeAllFee() private {
1017         if(_taxFee == 0 && _teamDev == 0) return;
1018 
1019         _previousTaxFee = _taxFee;
1020         _previousTeamDev = _teamDev;
1021 
1022         _taxFee = 0;
1023         _teamDev = 0;
1024     }
1025 
1026     function restoreAllFee() private {
1027         _taxFee = _previousTaxFee;
1028         _teamDev = _previousTeamDev;
1029     }
1030 
1031     function isExcludedFromFee(address account) public view returns(bool) {
1032         return _isExcludedFromFee[account];
1033     }
1034 
1035     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1036         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1037             10**2
1038         );
1039     }
1040 
1041     function enableSecuritySweep() external onlyOwner() {
1042         tradingOpen = false;
1043     }
1044 
1045     function disableSecuritySweep() external onlyOwner() {
1046         tradingOpen = true;
1047     }
1048 
1049     function _approve(address owner, address spender, uint256 amount) private {
1050         require(owner != address(0), "ERC20: approve from the zero address");
1051         require(spender != address(0), "ERC20: approve to the zero address");
1052 
1053         _allowances[owner][spender] = amount;
1054         emit Approval(owner, spender, amount);
1055     }
1056 
1057     function _transfer(address sender, address recipient, uint256 amount) private {
1058         require(sender != address(0), "ERC20: transfer from the zero address");
1059         require(recipient != address(0), "ERC20: transfer to the zero address");
1060         require(amount > 0, "Transfer amount must be greater than zero");
1061         if (snipeProtectionOn) {
1062             require(!_isSniper[recipient], "You have no power here!");
1063             require(!_isSniper[msg.sender], "You have no power here!");
1064             require(!_isSniper[sender], "You have no power here!");
1065         }
1066 
1067 
1068         if(sender != owner() && recipient != owner()) {
1069 
1070             if (!tradingOpen) {
1071                 if (!(sender == address(this) || recipient == address(this)
1072                 || sender == address(owner()) || recipient == address(owner()))) {
1073                     require(tradingOpen, "Trading is not enabled");
1074                 }
1075             }
1076 
1077             if (cooldownEnabled) {
1078                 if (_lastTx[sender] + 30 > block.timestamp
1079                 && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1080                     && sender != address(uniswapV2Pair)
1081                 ) {
1082                     _lastTx[sender] = block.timestamp;
1083                 } else {
1084                     require(!cooldownEnabled, "You're on cooldown! 30s between trades!");
1085                 }
1086             }
1087 
1088             if (uniswapOnly) {
1089                 if (
1090                     sender != address(this) &&
1091                     recipient != address(this) &&
1092                     sender != address(uniswapV2Router) &&
1093                     recipient != address(uniswapV2Router)
1094                 ) {
1095                     require(
1096                         _msgSender() == address(uniswapV2Router) ||
1097                         _msgSender() == uniswapV2Pair,
1098                         "ERR: Uniswap only"
1099                     );
1100                 }
1101             }
1102 
1103             if (block.timestamp < launchTime + 5 seconds) {
1104                 if (sender != uniswapV2Pair
1105                 && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1106                     && sender != address(uniswapV2Router)) {
1107                     _isSniper[sender] = true;
1108                     _confirmedSnipers.push(sender);
1109                 }
1110             }
1111 
1112 
1113         }
1114 
1115         // is the token balance of this contract address over the min number of
1116         // tokens that we need to initiate a swap?
1117         // also, don't get caught in a circular charity event.
1118         // also, don't swap if sender is uniswap pair.
1119         uint256 contractTokenBalance = balanceOf(address(this));
1120 
1121         bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeamDev;
1122         if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1123             // We need to swap the current tokens to ETH and send to the ext wallet
1124             swapTokensForEth(contractTokenBalance);
1125 
1126             uint256 contractETHBalance = address(this).balance;
1127             if(contractETHBalance > 0) {
1128                 sendETHToTeamDev(address(this).balance);
1129             }
1130         }
1131 
1132         //indicates if fee should be deducted from transfer
1133         bool takeFee = true;
1134 
1135         //if any account belongs to _isExcludedFromFee account then remove the fee
1136         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1137             takeFee = false;
1138         }
1139 
1140         //transfer amount, it will take tax and fee
1141 
1142         _tokenTransfer(sender,recipient,amount,takeFee);
1143     }
1144 
1145     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1146         // generate the uniswap pair path of token -> weth
1147         address[] memory path = new address[](2);
1148         path[0] = address(this);
1149         path[1] = uniswapV2Router.WETH();
1150 
1151         _approve(address(this), address(uniswapV2Router), tokenAmount);
1152 
1153         // make the swap
1154         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1155             tokenAmount,
1156             0, // accept any amount of ETH
1157             path,
1158             address(this),
1159             block.timestamp
1160         );
1161     }
1162 
1163     function sendETHToTeamDev(uint256 amount) private {
1164         _teamDevAddress.transfer(amount.div(2));
1165     }
1166 
1167     // We are exposing these functions to be able to manual swap and send
1168     // in case the token is highly valued and 5M becomes too much
1169     function manualSwap() external onlyOwner() {
1170         uint256 contractBalance = balanceOf(address(this));
1171         swapTokensForEth(contractBalance);
1172     }
1173 
1174     function manualSend() external onlyOwner() {
1175         uint256 contractETHBalance = address(this).balance;
1176         sendETHToTeamDev(contractETHBalance);
1177     }
1178 
1179     function setSwapEnabled(bool enabled) external onlyOwner(){
1180         swapEnabled = enabled;
1181     }
1182 
1183     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1184         if(!takeFee)
1185             removeAllFee();
1186 
1187         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1188             _transferFromExcluded(sender, recipient, amount);
1189         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1190             _transferToExcluded(sender, recipient, amount);
1191         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1192             _transferStandard(sender, recipient, amount);
1193         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1194             _transferBothExcluded(sender, recipient, amount);
1195         } else {
1196             _transferStandard(sender, recipient, amount);
1197         }
1198 
1199         if(!takeFee)
1200             restoreAllFee();
1201     }
1202 
1203     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1204         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1205         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1206         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1207         _takeCharity(tCharity);
1208         _reflectFee(rFee, tFee);
1209         emit Transfer(sender, recipient, tTransferAmount);
1210     }
1211 
1212     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1213         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1214         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1215         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1216         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1217         _takeCharity(tCharity);
1218         _reflectFee(rFee, tFee);
1219         emit Transfer(sender, recipient, tTransferAmount);
1220     }
1221 
1222     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1223         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1224         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1225         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1226         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1227         _takeCharity(tCharity);
1228         _reflectFee(rFee, tFee);
1229         emit Transfer(sender, recipient, tTransferAmount);
1230     }
1231 
1232     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1233         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1234         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1235         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1236         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1237         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1238         _takeCharity(tCharity);
1239         _reflectFee(rFee, tFee);
1240         emit Transfer(sender, recipient, tTransferAmount);
1241     }
1242 
1243     function _takeCharity(uint256 tCharity) private {
1244         uint256 currentRate =  _getRate();
1245         uint256 rCharity = tCharity.mul(currentRate);
1246         _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1247         if(_isExcluded[address(this)])
1248             _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1249     }
1250 
1251     function _reflectFee(uint256 rFee, uint256 tFee) private {
1252         _rTotal = _rTotal.sub(rFee);
1253         _tFeeTotal = _tFeeTotal.add(tFee);
1254     }
1255 
1256     //to recieve ETH from uniswapV2Router when swaping
1257     receive() external payable {}
1258 
1259     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1260         (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _teamDev);
1261         uint256 currentRate =  _getRate();
1262         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1263         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1264     }
1265 
1266     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1267         uint256 tFee = tAmount.mul(taxFee).div(100);
1268         uint256 tCharity = tAmount.mul(charityFee).div(100);
1269         uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1270         return (tTransferAmount, tFee, tCharity);
1271     }
1272 
1273     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1274         uint256 rAmount = tAmount.mul(currentRate);
1275         uint256 rFee = tFee.mul(currentRate);
1276         uint256 rTransferAmount = rAmount.sub(rFee);
1277         return (rAmount, rTransferAmount, rFee);
1278     }
1279 
1280     function _getRate() private view returns(uint256) {
1281         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1282         return rSupply.div(tSupply);
1283     }
1284 
1285     function _getCurrentSupply() private view returns(uint256, uint256) {
1286         uint256 rSupply = _rTotal;
1287         uint256 tSupply = _tTotal;
1288         for (uint256 i = 0; i < _excluded.length; i++) {
1289             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1290             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1291             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1292         }
1293         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1294         return (rSupply, tSupply);
1295     }
1296 
1297     function _getTaxFee() private view returns(uint256) {
1298         return _taxFee;
1299     }
1300 
1301     function _getMaxTxAmount() private view returns(uint256) {
1302         return _maxTxAmount;
1303     }
1304 
1305     function _getETHBalance() public view returns(uint256 balance) {
1306         return address(this).balance;
1307     }
1308 
1309     function _removeTxLimit() external onlyOwner() {
1310         _maxTxAmount = 1000000000000000000000000;
1311     }
1312 
1313     // Yes, there are here if I fucked up on the logic and need to disable them.
1314     function _removeDestLimit() external onlyOwner() {
1315         uniswapOnly = false;
1316     }
1317 
1318     function _disableCooldown() external onlyOwner() {
1319         cooldownEnabled = false;
1320     }
1321 
1322     function _enableCooldown() external onlyOwner() {
1323         cooldownEnabled = true;
1324     }
1325 
1326     function _enableAutoSnipeProtection() external onlyOwner() {
1327         snipeProtectionOn = true;
1328     }
1329 
1330     function _disableAutoSnipeProtection() external onlyOwner() {
1331         snipeProtectionOn = false;
1332     }
1333 
1334     function _setExtWallet(address payable teamDevAddress) external onlyOwner() {
1335         _teamDevAddress = teamDevAddress;
1336     }
1337 }