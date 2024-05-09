1 /**
2 
3     t.me/MeliodasBoarHat
4     theboarhat.net
5 
6     Supply: 100,000,000,000
7     Max TXN: 500 million
8     Max Wallet 3%
9     2% Redistrubiton
10     6% Marketing/
11     1% Trivia Wallet for Trivia Thursdays at The Boar Hat
12 
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 
17 pragma solidity ^0.6.12;
18 
19     abstract contract Context {
20         function _msgSender() internal view virtual returns (address payable) {
21             return msg.sender;
22         }
23 
24         function _msgData() internal view virtual returns (bytes memory) {
25             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26             return msg.data;
27         }
28     }
29 
30     interface IERC20 {
31         /**
32         * @dev Returns the amount of tokens in existence.
33         */
34         function totalSupply() external view returns (uint256);
35 
36         /**
37         * @dev Returns the amount of tokens owned by `account`.
38         */
39         function balanceOf(address account) external view returns (uint256);
40 
41         /**
42         * @dev Moves `amount` tokens from the caller's account to `recipient`.
43         *
44         * Returns a boolean value indicating whether the operation succeeded.
45         *
46         * Emits a {Transfer} event.
47         */
48         function transfer(address recipient, uint256 amount) external returns (bool);
49 
50         /**
51         * @dev Returns the remaining number of tokens that `spender` will be
52         * allowed to spend on behalf of `owner` through {transferFrom}. This is
53         * zero by default.
54         *
55         * This value changes when {approve} or {transferFrom} are called.
56         */
57         function allowance(address owner, address spender) external view returns (uint256);
58 
59         /**
60         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61         *
62         * Returns a boolean value indicating whether the operation succeeded.
63         *
64         * IMPORTANT: Beware that changing an allowance with this method brings the risk
65         * that someone may use both the old and the new allowance by unfortunate
66         * transaction ordering. One possible solution to mitigate this race
67         * condition is to first reduce the spender's allowance to 0 and set the
68         * desired value afterwards:
69         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70         *
71         * Emits an {Approval} event.
72         */
73         function approve(address spender, uint256 amount) external returns (bool);
74 
75         /**
76         * @dev Moves `amount` tokens from `sender` to `recipient` using the
77         * allowance mechanism. `amount` is then deducted from the caller's
78         * allowance.
79         *
80         * Returns a boolean value indicating whether the operation succeeded.
81         *
82         * Emits a {Transfer} event.
83         */
84         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
85 
86         /**
87         * @dev Emitted when `value` tokens are moved from one account (`from`) to
88         * another (`to`).
89         *
90         * Note that `value` may be zero.
91         */
92         event Transfer(address indexed from, address indexed to, uint256 value);
93 
94         /**
95         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
96         * a call to {approve}. `value` is the new allowance.
97         */
98         event Approval(address indexed owner, address indexed spender, uint256 value);
99     }
100 
101     library SafeMath {
102         /**
103         * @dev Returns the addition of two unsigned integers, reverting on
104         * overflow.
105         *
106         * Counterpart to Solidity's `+` operator.
107         *
108         * Requirements:
109         *
110         * - Addition cannot overflow.
111         */
112         function add(uint256 a, uint256 b) internal pure returns (uint256) {
113             uint256 c = a + b;
114             require(c >= a, "SafeMath: addition overflow");
115 
116             return c;
117         }
118 
119         /**
120         * @dev Returns the subtraction of two unsigned integers, reverting on
121         * overflow (when the result is negative).
122         *
123         * Counterpart to Solidity's `-` operator.
124         *
125         * Requirements:
126         *
127         * - Subtraction cannot overflow.
128         */
129         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130             return sub(a, b, "SafeMath: subtraction overflow");
131         }
132 
133         /**
134         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
135         * overflow (when the result is negative).
136         *
137         * Counterpart to Solidity's `-` operator.
138         *
139         * Requirements:
140         *
141         * - Subtraction cannot overflow.
142         */
143         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144             require(b <= a, errorMessage);
145             uint256 c = a - b;
146 
147             return c;
148         }
149 
150         /**
151         * @dev Returns the multiplication of two unsigned integers, reverting on
152         * overflow.
153         *
154         * Counterpart to Solidity's `*` operator.
155         *
156         * Requirements:
157         *
158         * - Multiplication cannot overflow.
159         */
160         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
161             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162             // benefit is lost if 'b' is also tested.
163             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164             if (a == 0) {
165                 return 0;
166             }
167 
168             uint256 c = a * b;
169             require(c / a == b, "SafeMath: multiplication overflow");
170 
171             return c;
172         }
173 
174         /**
175         * @dev Returns the integer division of two unsigned integers. Reverts on
176         * division by zero. The result is rounded towards zero.
177         *
178         * Counterpart to Solidity's `/` operator. Note: this function uses a
179         * `revert` opcode (which leaves remaining gas untouched) while Solidity
180         * uses an invalid opcode to revert (consuming all remaining gas).
181         *
182         * Requirements:
183         *
184         * - The divisor cannot be zero.
185         */
186         function div(uint256 a, uint256 b) internal pure returns (uint256) {
187             return div(a, b, "SafeMath: division by zero");
188         }
189 
190         /**
191         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
192         * division by zero. The result is rounded towards zero.
193         *
194         * Counterpart to Solidity's `/` operator. Note: this function uses a
195         * `revert` opcode (which leaves remaining gas untouched) while Solidity
196         * uses an invalid opcode to revert (consuming all remaining gas).
197         *
198         * Requirements:
199         *
200         * - The divisor cannot be zero.
201         */
202         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
203             require(b > 0, errorMessage);
204             uint256 c = a / b;
205             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207             return c;
208         }
209 
210         /**
211         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212         * Reverts when dividing by zero.
213         *
214         * Counterpart to Solidity's `%` operator. This function uses a `revert`
215         * opcode (which leaves remaining gas untouched) while Solidity uses an
216         * invalid opcode to revert (consuming all remaining gas).
217         *
218         * Requirements:
219         *
220         * - The divisor cannot be zero.
221         */
222         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
223             return mod(a, b, "SafeMath: modulo by zero");
224         }
225 
226         /**
227         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228         * Reverts with custom message when dividing by zero.
229         *
230         * Counterpart to Solidity's `%` operator. This function uses a `revert`
231         * opcode (which leaves remaining gas untouched) while Solidity uses an
232         * invalid opcode to revert (consuming all remaining gas).
233         *
234         * Requirements:
235         *
236         * - The divisor cannot be zero.
237         */
238         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239             require(b != 0, errorMessage);
240             return a % b;
241         }
242     }
243 
244     library Address {
245         /**
246         * @dev Returns true if `account` is a contract.
247         *
248         * [IMPORTANT]
249         * ====
250         * It is unsafe to assume that an address for which this function returns
251         * false is an externally-owned account (EOA) and not a contract.
252         *
253         * Among others, `isContract` will return false for the following
254         * types of addresses:
255         *
256         *  - an externally-owned account
257         *  - a contract in construction
258         *  - an address where a contract will be created
259         *  - an address where a contract lived, but was destroyed
260         * ====
261         */
262         function isContract(address account) internal view returns (bool) {
263             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
264             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
265             // for accounts without code, i.e. `keccak256('')`
266             bytes32 codehash;
267             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
268             // solhint-disable-next-line no-inline-assembly
269             assembly { codehash := extcodehash(account) }
270             return (codehash != accountHash && codehash != 0x0);
271         }
272 
273         /**
274         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
275         * `recipient`, forwarding all available gas and reverting on errors.
276         *
277         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
278         * of certain opcodes, possibly making contracts go over the 2300 gas limit
279         * imposed by `transfer`, making them unable to receive funds via
280         * `transfer`. {sendValue} removes this limitation.
281         *
282         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
283         *
284         * IMPORTANT: because control is transferred to `recipient`, care must be
285         * taken to not create reentrancy vulnerabilities. Consider using
286         * {ReentrancyGuard} or the
287         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
288         */
289         function sendValue(address payable recipient, uint256 amount) internal {
290             require(address(this).balance >= amount, "Address: insufficient balance");
291 
292             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
293             (bool success, ) = recipient.call{ value: amount }("");
294             require(success, "Address: unable to send value, recipient may have reverted");
295         }
296 
297         /**
298         * @dev Performs a Solidity function call using a low level `call`. A
299         * plain`call` is an unsafe replacement for a function call: use this
300         * function instead.
301         *
302         * If `target` reverts with a revert reason, it is bubbled up by this
303         * function (like regular Solidity function calls).
304         *
305         * Returns the raw returned data. To convert to the expected return value,
306         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
307         *
308         * Requirements:
309         *
310         * - `target` must be a contract.
311         * - calling `target` with `data` must not revert.
312         *
313         * _Available since v3.1._
314         */
315         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionCall(target, data, "Address: low-level call failed");
317         }
318 
319         /**
320         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
321         * `errorMessage` as a fallback revert reason when `target` reverts.
322         *
323         * _Available since v3.1._
324         */
325         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326             return _functionCallWithValue(target, data, 0, errorMessage);
327         }
328 
329         /**
330         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331         * but also transferring `value` wei to `target`.
332         *
333         * Requirements:
334         *
335         * - the calling contract must have an ETH balance of at least `value`.
336         * - the called Solidity function must be `payable`.
337         *
338         * _Available since v3.1._
339         */
340         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
341             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
342         }
343 
344         /**
345         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346         * with `errorMessage` as a fallback revert reason when `target` reverts.
347         *
348         * _Available since v3.1._
349         */
350         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
351             require(address(this).balance >= value, "Address: insufficient balance for call");
352             return _functionCallWithValue(target, data, value, errorMessage);
353         }
354 
355         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
356             require(isContract(target), "Address: call to non-contract");
357 
358             // solhint-disable-next-line avoid-low-level-calls
359             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
360             if (success) {
361                 return returndata;
362             } else {
363                 // Look for revert reason and bubble it up if present
364                 if (returndata.length > 0) {
365                     // The easiest way to bubble the revert reason is using memory via assembly
366 
367                     // solhint-disable-next-line no-inline-assembly
368                     assembly {
369                         let returndata_size := mload(returndata)
370                         revert(add(32, returndata), returndata_size)
371                     }
372                 } else {
373                     revert(errorMessage);
374                 }
375             }
376         }
377     }
378 
379     contract Ownable is Context {
380         address private _owner;
381         address private _previousOwner;
382         uint256 private _lockTime;
383 
384         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
385 
386         /**
387         * @dev Initializes the contract setting the deployer as the initial owner.
388         */
389         constructor () internal {
390             address msgSender = _msgSender();
391             _owner = msgSender;
392             emit OwnershipTransferred(address(0), msgSender);
393         }
394 
395         /**
396         * @dev Returns the address of the current owner.
397         */
398         function owner() public view returns (address) {
399             return _owner;
400         }
401 
402         /**
403         * @dev Throws if called by any account other than the owner.
404         */
405         modifier onlyOwner() {
406             require(_owner == _msgSender(), "Ownable: caller is not the owner");
407             _;
408         }
409 
410         /**
411         * @dev Leaves the contract without owner. It will not be possible to call
412         * `onlyOwner` functions anymore. Can only be called by the current owner.
413         *
414         * NOTE: Renouncing ownership will leave the contract without an owner,
415         * thereby removing any functionality that is only available to the owner.
416         */
417         function renounceOwnership() public virtual onlyOwner {
418             emit OwnershipTransferred(_owner, address(0));
419             _owner = address(0);
420         }
421 
422         /**
423         * @dev Transfers ownership of the contract to a new account (`newOwner`).
424         * Can only be called by the current owner.
425         */
426         function transferOwnership(address newOwner) public virtual onlyOwner {
427             require(newOwner != address(0), "Ownable: new owner is the zero address");
428             emit OwnershipTransferred(_owner, newOwner);
429             _owner = newOwner;
430         }
431 
432         function getUnlockTime() public view returns (uint256) {
433             return _lockTime;
434         }
435 
436     }
437 
438     interface IUniswapV2Factory {
439         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
440 
441         function feeTo() external view returns (address);
442         function feeToSetter() external view returns (address);
443 
444         function getPair(address tokenA, address tokenB) external view returns (address pair);
445         function allPairs(uint) external view returns (address pair);
446         function allPairsLength() external view returns (uint);
447 
448         function createPair(address tokenA, address tokenB) external returns (address pair);
449 
450         function setFeeTo(address) external;
451         function setFeeToSetter(address) external;
452     }
453 
454     interface IUniswapV2Pair {
455         event Approval(address indexed owner, address indexed spender, uint value);
456         event Transfer(address indexed from, address indexed to, uint value);
457 
458         function name() external pure returns (string memory);
459         function symbol() external pure returns (string memory);
460         function decimals() external pure returns (uint8);
461         function totalSupply() external view returns (uint);
462         function balanceOf(address owner) external view returns (uint);
463         function allowance(address owner, address spender) external view returns (uint);
464 
465         function approve(address spender, uint value) external returns (bool);
466         function transfer(address to, uint value) external returns (bool);
467         function transferFrom(address from, address to, uint value) external returns (bool);
468 
469         function DOMAIN_SEPARATOR() external view returns (bytes32);
470         function PERMIT_TYPEHASH() external pure returns (bytes32);
471         function nonces(address owner) external view returns (uint);
472 
473         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
474 
475         event Mint(address indexed sender, uint amount0, uint amount1);
476         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
477         event Swap(
478             address indexed sender,
479             uint amount0In,
480             uint amount1In,
481             uint amount0Out,
482             uint amount1Out,
483             address indexed to
484         );
485         event Sync(uint112 reserve0, uint112 reserve1);
486 
487         function MINIMUM_LIQUIDITY() external pure returns (uint);
488         function factory() external view returns (address);
489         function token0() external view returns (address);
490         function token1() external view returns (address);
491         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
492         function price0CumulativeLast() external view returns (uint);
493         function price1CumulativeLast() external view returns (uint);
494         function kLast() external view returns (uint);
495 
496         function mint(address to) external returns (uint liquidity);
497         function burn(address to) external returns (uint amount0, uint amount1);
498         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
499         function skim(address to) external;
500         function sync() external;
501 
502         function initialize(address, address) external;
503     }
504 
505     interface IUniswapV2Router01 {
506         function factory() external pure returns (address);
507         function WETH() external pure returns (address);
508 
509         function addLiquidity(
510             address tokenA,
511             address tokenB,
512             uint amountADesired,
513             uint amountBDesired,
514             uint amountAMin,
515             uint amountBMin,
516             address to,
517             uint deadline
518         ) external returns (uint amountA, uint amountB, uint liquidity);
519         function addLiquidityETH(
520             address token,
521             uint amountTokenDesired,
522             uint amountTokenMin,
523             uint amountETHMin,
524             address to,
525             uint deadline
526         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
527         function removeLiquidity(
528             address tokenA,
529             address tokenB,
530             uint liquidity,
531             uint amountAMin,
532             uint amountBMin,
533             address to,
534             uint deadline
535         ) external returns (uint amountA, uint amountB);
536         function removeLiquidityETH(
537             address token,
538             uint liquidity,
539             uint amountTokenMin,
540             uint amountETHMin,
541             address to,
542             uint deadline
543         ) external returns (uint amountToken, uint amountETH);
544         function removeLiquidityWithPermit(
545             address tokenA,
546             address tokenB,
547             uint liquidity,
548             uint amountAMin,
549             uint amountBMin,
550             address to,
551             uint deadline,
552             bool approveMax, uint8 v, bytes32 r, bytes32 s
553         ) external returns (uint amountA, uint amountB);
554         function removeLiquidityETHWithPermit(
555             address token,
556             uint liquidity,
557             uint amountTokenMin,
558             uint amountETHMin,
559             address to,
560             uint deadline,
561             bool approveMax, uint8 v, bytes32 r, bytes32 s
562         ) external returns (uint amountToken, uint amountETH);
563         function swapExactTokensForTokens(
564             uint amountIn,
565             uint amountOutMin,
566             address[] calldata path,
567             address to,
568             uint deadline
569         ) external returns (uint[] memory amounts);
570         function swapTokensForExactTokens(
571             uint amountOut,
572             uint amountInMax,
573             address[] calldata path,
574             address to,
575             uint deadline
576         ) external returns (uint[] memory amounts);
577         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
578             external
579             payable
580             returns (uint[] memory amounts);
581         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
582             external
583             returns (uint[] memory amounts);
584         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
585             external
586             returns (uint[] memory amounts);
587         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
588             external
589             payable
590             returns (uint[] memory amounts);
591 
592         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
593         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
594         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
595         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
596         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
597     }
598 
599     interface IUniswapV2Router02 is IUniswapV2Router01 {
600         function removeLiquidityETHSupportingFeeOnTransferTokens(
601             address token,
602             uint liquidity,
603             uint amountTokenMin,
604             uint amountETHMin,
605             address to,
606             uint deadline
607         ) external returns (uint amountETH);
608         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
609             address token,
610             uint liquidity,
611             uint amountTokenMin,
612             uint amountETHMin,
613             address to,
614             uint deadline,
615             bool approveMax, uint8 v, bytes32 r, bytes32 s
616         ) external returns (uint amountETH);
617 
618         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
619             uint amountIn,
620             uint amountOutMin,
621             address[] calldata path,
622             address to,
623             uint deadline
624         ) external;
625         function swapExactETHForTokensSupportingFeeOnTransferTokens(
626             uint amountOutMin,
627             address[] calldata path,
628             address to,
629             uint deadline
630         ) external payable;
631         function swapExactTokensForETHSupportingFeeOnTransferTokens(
632             uint amountIn,
633             uint amountOutMin,
634             address[] calldata path,
635             address to,
636             uint deadline
637         ) external;
638     }
639 
640     contract Meliodas is Context, IERC20, Ownable {
641         using SafeMath for uint256;
642         using Address for address;
643 
644         mapping (address => uint256) private _rOwned;
645         mapping (address => uint256) private _tOwned;
646         mapping (address => mapping (address => uint256)) private _allowances;
647 
648         mapping (address => bool) private _isExcludedFromFee;
649 
650         mapping (address => bool) private _isExcluded;
651         address[] private _excluded;
652         mapping (address => bool) private _isBlackListedBot;
653         address[] private _blackListedBots;
654 
655         uint256 private constant MAX = ~uint256(0);
656         uint256 private constant _tTotal = 100000000000 * 10**18;
657         uint256 private _rTotal = (MAX - (MAX % _tTotal));
658         uint256 private _tFeeTotal;
659 
660         string private constant _name = 'Meliodas';
661         string private constant _symbol = 'MELIODAS';
662         uint8 private constant _decimals = 18;
663 
664         uint256 private _taxFee = 2;
665         uint256 private _teamFee = 8;
666         uint256 private _previousTaxFee = _taxFee;
667         uint256 private _previousTeamFee = _teamFee;
668 
669         address payable public _triviaWalletAddress;
670         address payable public _marketingWalletAddress;
671 
672 
673         IUniswapV2Router02 public immutable uniswapV2Router;
674         address public immutable uniswapV2Pair;
675 
676         bool inSwap = false;
677         bool public swapEnabled = true;
678 
679         uint256 private _maxTxAmount = 500000000 * 10**18;
680         uint256 private constant _numOfTokensToExchangeForTeam = 700000 * 10**18;
681         uint256 private _maxWalletSize = 3000000000 * 10**18;
682 
683         event botAddedToBlacklist(address account);
684         event botRemovedFromBlacklist(address account);
685 
686         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
687         // event SwapEnabledUpdated(bool enabled);
688 
689         modifier lockTheSwap {
690             inSwap = true;
691             _;
692             inSwap = false;
693         }
694 
695         constructor (address payable triviaWalletAddress, address payable marketingWalletAddress) public {
696             _triviaWalletAddress = triviaWalletAddress;
697             _marketingWalletAddress = marketingWalletAddress;
698 
699             _rOwned[_msgSender()] = _rTotal;
700 
701             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
702             // Create a uniswap pair for this new token
703             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
704                 .createPair(address(this), _uniswapV2Router.WETH());
705 
706             // set the rest of the contract variables
707             uniswapV2Router = _uniswapV2Router;
708 
709             // Exclude owner and this contract from fee
710             _isExcludedFromFee[owner()] = true;
711             _isExcludedFromFee[address(this)] = true;
712 
713             emit Transfer(address(0), _msgSender(), _tTotal);
714         }
715 
716         function name() public pure returns (string memory) {
717             return _name;
718         }
719 
720         function symbol() public pure returns (string memory) {
721             return _symbol;
722         }
723 
724         function decimals() public pure returns (uint8) {
725             return _decimals;
726         }
727 
728         function totalSupply() public view override returns (uint256) {
729             return _tTotal;
730         }
731 
732         function balanceOf(address account) public view override returns (uint256) {
733             if (_isExcluded[account]) return _tOwned[account];
734             return tokenFromReflection(_rOwned[account]);
735         }
736 
737         function transfer(address recipient, uint256 amount) public override returns (bool) {
738             _transfer(_msgSender(), recipient, amount);
739             return true;
740         }
741 
742         function allowance(address owner, address spender) public view override returns (uint256) {
743             return _allowances[owner][spender];
744         }
745 
746         function approve(address spender, uint256 amount) public override returns (bool) {
747             _approve(_msgSender(), spender, amount);
748             return true;
749         }
750 
751         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
752             _transfer(sender, recipient, amount);
753             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
754             return true;
755         }
756 
757         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
758             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
759             return true;
760         }
761 
762         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
763             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
764             return true;
765         }
766 
767         function isExcluded(address account) public view returns (bool) {
768             return _isExcluded[account];
769         }
770 
771         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
772             _isExcludedFromFee[account] = excluded;
773         }
774 
775         function totalFees() public view returns (uint256) {
776             return _tFeeTotal;
777         }
778 
779         function deliver(uint256 tAmount) public {
780             address sender = _msgSender();
781             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
782             (uint256 rAmount,,,,,) = _getValues(tAmount);
783             _rOwned[sender] = _rOwned[sender].sub(rAmount);
784             _rTotal = _rTotal.sub(rAmount);
785             _tFeeTotal = _tFeeTotal.add(tAmount);
786         }
787 
788         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
789             require(tAmount <= _tTotal, "Amount must be less than supply");
790             if (!deductTransferFee) {
791                 (uint256 rAmount,,,,,) = _getValues(tAmount);
792                 return rAmount;
793             } else {
794                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
795                 return rTransferAmount;
796             }
797         }
798 
799         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
800             require(rAmount <= _rTotal, "Amount must be less than total reflections");
801             uint256 currentRate =  _getRate();
802             return rAmount.div(currentRate);
803         }
804 
805         function addBotToBlacklist (address account) external onlyOwner() {
806            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
807            require (!_isBlackListedBot[account], 'Account is already blacklisted');
808            _isBlackListedBot[account] = true;
809            _blackListedBots.push(account);
810         }
811 
812         function removeBotFromBlacklist(address account) external onlyOwner() {
813           require (_isBlackListedBot[account], 'Account is not blacklisted');
814           for (uint256 i = 0; i < _blackListedBots.length; i++) {
815                  if (_blackListedBots[i] == account) {
816                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
817                      _isBlackListedBot[account] = false;
818                      _blackListedBots.pop();
819                      break;
820                  }
821            }
822        }
823 
824         function excludeAccount(address account) external onlyOwner() {
825             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
826             require(!_isExcluded[account], "Account is already excluded");
827             if(_rOwned[account] > 0) {
828                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
829             }
830             _isExcluded[account] = true;
831             _excluded.push(account);
832         }
833 
834         function includeAccount(address account) external onlyOwner() {
835             require(_isExcluded[account], "Account is not excluded");
836             for (uint256 i = 0; i < _excluded.length; i++) {
837                 if (_excluded[i] == account) {
838                     _excluded[i] = _excluded[_excluded.length - 1];
839                     _tOwned[account] = 0;
840                     _isExcluded[account] = false;
841                     _excluded.pop();
842                     break;
843                 }
844             }
845         }
846 
847         function removeAllFee() private {
848             if(_taxFee == 0 && _teamFee == 0) return;
849 
850             _previousTaxFee = _taxFee;
851             _previousTeamFee = _teamFee;
852 
853             _taxFee = 0;
854             _teamFee = 0;
855         }
856 
857         function restoreAllFee() private {
858             _taxFee = _previousTaxFee;
859             _teamFee = _previousTeamFee;
860         }
861 
862         function isExcludedFromFee(address account) public view returns(bool) {
863             return _isExcludedFromFee[account];
864         }
865 
866         function _approve(address owner, address spender, uint256 amount) private {
867             require(owner != address(0), "ERC20: approve from the zero address");
868             require(spender != address(0), "ERC20: approve to the zero address");
869 
870             _allowances[owner][spender] = amount;
871             emit Approval(owner, spender, amount);
872         }
873 
874         function _transfer(address sender, address recipient, uint256 amount) private {
875             require(sender != address(0), "ERC20: transfer from the zero address");
876             require(recipient != address(0), "ERC20: transfer to the zero address");
877             require(amount > 0, "Transfer amount must be greater than zero");
878             require(!_isBlackListedBot[sender], "You are blacklisted");
879             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
880             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
881             if(sender != owner() && recipient != owner()) {
882                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
883             }
884             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
885                 uint256 tokenBalanceRecipient = balanceOf(recipient);
886                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
887             }
888             // is the token balance of this contract address over the min number of
889             // tokens that we need to initiate a swap?
890             // also, don't get caught in a circular team event.
891             // also, don't swap if sender is uniswap pair.
892             uint256 contractTokenBalance = balanceOf(address(this));
893 
894             if(contractTokenBalance >= _maxTxAmount)
895             {
896                 contractTokenBalance = _maxTxAmount;
897             }
898 
899             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
900             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
901                 // Swap tokens for ETH and send to resepctive wallets
902                 swapTokensForEth(contractTokenBalance);
903 
904                 uint256 contractETHBalance = address(this).balance;
905                 if(contractETHBalance > 0) {
906                     sendETHToTeam(address(this).balance);
907                 }
908             }
909 
910             //indicates if fee should be deducted from transfer
911             bool takeFee = true;
912 
913             //if any account belongs to _isExcludedFromFee account then remove the fee
914             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
915                 takeFee = false;
916             }
917 
918             //transfer amount, it will take tax and team fee
919             _tokenTransfer(sender,recipient,amount,takeFee);
920         }
921 
922         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
923             // generate the uniswap pair path of token -> weth
924             address[] memory path = new address[](2);
925             path[0] = address(this);
926             path[1] = uniswapV2Router.WETH();
927 
928             _approve(address(this), address(uniswapV2Router), tokenAmount);
929 
930             // make the swap
931             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
932                 tokenAmount,
933                 0, // accept any amount of ETH
934                 path,
935                 address(this),
936                 block.timestamp
937             );
938         }
939 
940         function sendETHToTeam(uint256 amount) private {
941             _triviaWalletAddress.transfer(amount.div(8));
942             _marketingWalletAddress.transfer(amount.div(8).mul(7));
943         }
944 
945         function manualSwap() external onlyOwner() {
946             uint256 contractBalance = balanceOf(address(this));
947             swapTokensForEth(contractBalance);
948         }
949 
950         function manualSend() external onlyOwner() {
951             uint256 contractETHBalance = address(this).balance;
952             sendETHToTeam(contractETHBalance);
953         }
954 
955         function setSwapEnabled(bool enabled) external onlyOwner(){
956             swapEnabled = enabled;
957         }
958 
959         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
960             if(!takeFee)
961                 removeAllFee();
962 
963             if (_isExcluded[sender] && !_isExcluded[recipient]) {
964                 _transferFromExcluded(sender, recipient, amount);
965             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
966                 _transferToExcluded(sender, recipient, amount);
967             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
968                 _transferStandard(sender, recipient, amount);
969             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
970                 _transferBothExcluded(sender, recipient, amount);
971             } else {
972                 _transferStandard(sender, recipient, amount);
973             }
974 
975             if(!takeFee)
976                 restoreAllFee();
977         }
978 
979         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
980             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
981             _rOwned[sender] = _rOwned[sender].sub(rAmount);
982             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
983             _takeTeam(tTeam);
984             _reflectFee(rFee, tFee);
985             emit Transfer(sender, recipient, tTransferAmount);
986         }
987 
988         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
989             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
990             _rOwned[sender] = _rOwned[sender].sub(rAmount);
991             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
992             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
993             _takeTeam(tTeam);
994             _reflectFee(rFee, tFee);
995             emit Transfer(sender, recipient, tTransferAmount);
996         }
997 
998         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
999             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1000             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1001             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1002             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1003             _takeTeam(tTeam);
1004             _reflectFee(rFee, tFee);
1005             emit Transfer(sender, recipient, tTransferAmount);
1006         }
1007 
1008         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1009             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1010             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1011             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1012             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1013             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1014             _takeTeam(tTeam);
1015             _reflectFee(rFee, tFee);
1016             emit Transfer(sender, recipient, tTransferAmount);
1017         }
1018 
1019         function _takeTeam(uint256 tTeam) private {
1020             uint256 currentRate =  _getRate();
1021             uint256 rTeam = tTeam.mul(currentRate);
1022             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1023             if(_isExcluded[address(this)])
1024                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1025         }
1026 
1027         function _reflectFee(uint256 rFee, uint256 tFee) private {
1028             _rTotal = _rTotal.sub(rFee);
1029             _tFeeTotal = _tFeeTotal.add(tFee);
1030         }
1031 
1032          //to recieve ETH from uniswapV2Router when swaping
1033         receive() external payable {}
1034 
1035         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1036         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1037         uint256 currentRate = _getRate();
1038         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1039         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1040     }
1041 
1042         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1043             uint256 tFee = tAmount.mul(taxFee).div(100);
1044             uint256 tTeam = tAmount.mul(teamFee).div(100);
1045             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1046             return (tTransferAmount, tFee, tTeam);
1047         }
1048 
1049         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1050             uint256 rAmount = tAmount.mul(currentRate);
1051             uint256 rFee = tFee.mul(currentRate);
1052             uint256 rTeam = tTeam.mul(currentRate);
1053             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1054             return (rAmount, rTransferAmount, rFee);
1055         }
1056 
1057         function _getRate() private view returns(uint256) {
1058             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1059             return rSupply.div(tSupply);
1060         }
1061 
1062         function _getCurrentSupply() private view returns(uint256, uint256) {
1063             uint256 rSupply = _rTotal;
1064             uint256 tSupply = _tTotal;
1065             for (uint256 i = 0; i < _excluded.length; i++) {
1066                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1067                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1068                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1069             }
1070             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1071             return (rSupply, tSupply);
1072         }
1073 
1074         function _getTaxFee() public view returns(uint256) {
1075             return _taxFee;
1076         }
1077 
1078         function _getTeamFee() public view returns (uint256) {
1079           return _teamFee;
1080         }
1081 
1082         function _getMaxTxAmount() public view returns(uint256) {
1083             return _maxTxAmount;
1084         }
1085 
1086         function _getETHBalance() public view returns(uint256 balance) {
1087             return address(this).balance;
1088         }
1089 
1090         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1091             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1092             _taxFee = taxFee;
1093         }
1094 
1095         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1096             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1097             _teamFee = teamFee;
1098         }
1099 
1100         function _setTriviaWallet(address payable triviaWalletAddress) external onlyOwner() {
1101             _triviaWalletAddress = triviaWalletAddress;
1102         }
1103 
1104         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1105             _marketingWalletAddress = marketingWalletAddress;
1106         }
1107 
1108         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1109             _maxTxAmount = maxTxAmount;
1110         }
1111 
1112         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1113           _maxWalletSize = maxWalletSize;
1114         }
1115     }