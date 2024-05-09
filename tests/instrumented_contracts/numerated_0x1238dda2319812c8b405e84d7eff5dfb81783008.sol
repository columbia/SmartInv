1 /*
2 Telegram: https://t.me/FreedomINU
3 Website: freedominu.io
4 
5 This launch brought to you by A+ Tokens Calls, please join their telegram channel - https://t.me/APlusTokens
6 */
7 pragma solidity ^0.6.12;
8 // SPDX-License-Identifier: Unlicensed
9 
10     abstract contract Context {
11         function _msgSender() internal view virtual returns (address payable) {
12             return msg.sender;
13         }
14 
15         function _msgData() internal view virtual returns (bytes memory) {
16             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17             return msg.data;
18         }
19     }
20 
21     interface IERC20 {
22         /**
23         * @dev Returns the amount of tokens in existence.
24         */
25         function totalSupply() external view returns (uint256);
26 
27         /**
28         * @dev Returns the amount of tokens owned by `account`.
29         */
30         function balanceOf(address account) external view returns (uint256);
31 
32         /**
33         * @dev Moves `amount` tokens from the caller's account to `recipient`.
34         *
35         * Returns a boolean value indicating whether the operation succeeded.
36         *
37         * Emits a {Transfer} event.
38         */
39         function transfer(address recipient, uint256 amount) external returns (bool);
40 
41         /**
42         * @dev Returns the remaining number of tokens that `spender` will be
43         * allowed to spend on behalf of `owner` through {transferFrom}. This is
44         * zero by default.
45         *
46         * This value changes when {approve} or {transferFrom} are called.
47         */
48         function allowance(address owner, address spender) external view returns (uint256);
49 
50         /**
51         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52         *
53         * Returns a boolean value indicating whether the operation succeeded.
54         *
55         * IMPORTANT: Beware that changing an allowance with this method brings the risk
56         * that someone may use both the old and the new allowance by unfortunate
57         * transaction ordering. One possible solution to mitigate this race
58         * condition is to first reduce the spender's allowance to 0 and set the
59         * desired value afterwards:
60         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61         *
62         * Emits an {Approval} event.
63         */
64         function approve(address spender, uint256 amount) external returns (bool);
65 
66         /**
67         * @dev Moves `amount` tokens from `sender` to `recipient` using the
68         * allowance mechanism. `amount` is then deducted from the caller's
69         * allowance.
70         *
71         * Returns a boolean value indicating whether the operation succeeded.
72         *
73         * Emits a {Transfer} event.
74         */
75         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77         /**
78         * @dev Emitted when `value` tokens are moved from one account (`from`) to
79         * another (`to`).
80         *
81         * Note that `value` may be zero.
82         */
83         event Transfer(address indexed from, address indexed to, uint256 value);
84 
85         /**
86         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87         * a call to {approve}. `value` is the new allowance.
88         */
89         event Approval(address indexed owner, address indexed spender, uint256 value);
90     }
91 
92     library SafeMath {
93         /**
94         * @dev Returns the addition of two unsigned integers, reverting on
95         * overflow.
96         *
97         * Counterpart to Solidity's `+` operator.
98         *
99         * Requirements:
100         *
101         * - Addition cannot overflow.
102         */
103         function add(uint256 a, uint256 b) internal pure returns (uint256) {
104             uint256 c = a + b;
105             require(c >= a, "SafeMath: addition overflow");
106 
107             return c;
108         }
109 
110         /**
111         * @dev Returns the subtraction of two unsigned integers, reverting on
112         * overflow (when the result is negative).
113         *
114         * Counterpart to Solidity's `-` operator.
115         *
116         * Requirements:
117         *
118         * - Subtraction cannot overflow.
119         */
120         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121             return sub(a, b, "SafeMath: subtraction overflow");
122         }
123 
124         /**
125         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126         * overflow (when the result is negative).
127         *
128         * Counterpart to Solidity's `-` operator.
129         *
130         * Requirements:
131         *
132         * - Subtraction cannot overflow.
133         */
134         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135             require(b <= a, errorMessage);
136             uint256 c = a - b;
137 
138             return c;
139         }
140 
141         /**
142         * @dev Returns the multiplication of two unsigned integers, reverting on
143         * overflow.
144         *
145         * Counterpart to Solidity's `*` operator.
146         *
147         * Requirements:
148         *
149         * - Multiplication cannot overflow.
150         */
151         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153             // benefit is lost if 'b' is also tested.
154             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155             if (a == 0) {
156                 return 0;
157             }
158 
159             uint256 c = a * b;
160             require(c / a == b, "SafeMath: multiplication overflow");
161 
162             return c;
163         }
164 
165         /**
166         * @dev Returns the integer division of two unsigned integers. Reverts on
167         * division by zero. The result is rounded towards zero.
168         *
169         * Counterpart to Solidity's `/` operator. Note: this function uses a
170         * `revert` opcode (which leaves remaining gas untouched) while Solidity
171         * uses an invalid opcode to revert (consuming all remaining gas).
172         *
173         * Requirements:
174         *
175         * - The divisor cannot be zero.
176         */
177         function div(uint256 a, uint256 b) internal pure returns (uint256) {
178             return div(a, b, "SafeMath: division by zero");
179         }
180 
181         /**
182         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183         * division by zero. The result is rounded towards zero.
184         *
185         * Counterpart to Solidity's `/` operator. Note: this function uses a
186         * `revert` opcode (which leaves remaining gas untouched) while Solidity
187         * uses an invalid opcode to revert (consuming all remaining gas).
188         *
189         * Requirements:
190         *
191         * - The divisor cannot be zero.
192         */
193         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194             require(b > 0, errorMessage);
195             uint256 c = a / b;
196             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198             return c;
199         }
200 
201         /**
202         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203         * Reverts when dividing by zero.
204         *
205         * Counterpart to Solidity's `%` operator. This function uses a `revert`
206         * opcode (which leaves remaining gas untouched) while Solidity uses an
207         * invalid opcode to revert (consuming all remaining gas).
208         *
209         * Requirements:
210         *
211         * - The divisor cannot be zero.
212         */
213         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214             return mod(a, b, "SafeMath: modulo by zero");
215         }
216 
217         /**
218         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219         * Reverts with custom message when dividing by zero.
220         *
221         * Counterpart to Solidity's `%` operator. This function uses a `revert`
222         * opcode (which leaves remaining gas untouched) while Solidity uses an
223         * invalid opcode to revert (consuming all remaining gas).
224         *
225         * Requirements:
226         *
227         * - The divisor cannot be zero.
228         */
229         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230             require(b != 0, errorMessage);
231             return a % b;
232         }
233     }
234 
235     library Address {
236         /**
237         * @dev Returns true if `account` is a contract.
238         *
239         * [IMPORTANT]
240         * ====
241         * It is unsafe to assume that an address for which this function returns
242         * false is an externally-owned account (EOA) and not a contract.
243         *
244         * Among others, `isContract` will return false for the following
245         * types of addresses:
246         *
247         *  - an externally-owned account
248         *  - a contract in construction
249         *  - an address where a contract will be created
250         *  - an address where a contract lived, but was destroyed
251         * ====
252         */
253         function isContract(address account) internal view returns (bool) {
254             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
255             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
256             // for accounts without code, i.e. `keccak256('')`
257             bytes32 codehash;
258             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
259             // solhint-disable-next-line no-inline-assembly
260             assembly { codehash := extcodehash(account) }
261             return (codehash != accountHash && codehash != 0x0);
262         }
263 
264         /**
265         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266         * `recipient`, forwarding all available gas and reverting on errors.
267         *
268         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269         * of certain opcodes, possibly making contracts go over the 2300 gas limit
270         * imposed by `transfer`, making them unable to receive funds via
271         * `transfer`. {sendValue} removes this limitation.
272         *
273         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274         *
275         * IMPORTANT: because control is transferred to `recipient`, care must be
276         * taken to not create reentrancy vulnerabilities. Consider using
277         * {ReentrancyGuard} or the
278         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279         */
280         function sendValue(address payable recipient, uint256 amount) internal {
281             require(address(this).balance >= amount, "Address: insufficient balance");
282 
283             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
284             (bool success, ) = recipient.call{ value: amount }("");
285             require(success, "Address: unable to send value, recipient may have reverted");
286         }
287 
288         /**
289         * @dev Performs a Solidity function call using a low level `call`. A
290         * plain`call` is an unsafe replacement for a function call: use this
291         * function instead.
292         *
293         * If `target` reverts with a revert reason, it is bubbled up by this
294         * function (like regular Solidity function calls).
295         *
296         * Returns the raw returned data. To convert to the expected return value,
297         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298         *
299         * Requirements:
300         *
301         * - `target` must be a contract.
302         * - calling `target` with `data` must not revert.
303         *
304         * _Available since v3.1._
305         */
306         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCall(target, data, "Address: low-level call failed");
308         }
309 
310         /**
311         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312         * `errorMessage` as a fallback revert reason when `target` reverts.
313         *
314         * _Available since v3.1._
315         */
316         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
317             return _functionCallWithValue(target, data, 0, errorMessage);
318         }
319 
320         /**
321         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322         * but also transferring `value` wei to `target`.
323         *
324         * Requirements:
325         *
326         * - the calling contract must have an ETH balance of at least `value`.
327         * - the called Solidity function must be `payable`.
328         *
329         * _Available since v3.1._
330         */
331         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
332             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333         }
334 
335         /**
336         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337         * with `errorMessage` as a fallback revert reason when `target` reverts.
338         *
339         * _Available since v3.1._
340         */
341         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
342             require(address(this).balance >= value, "Address: insufficient balance for call");
343             return _functionCallWithValue(target, data, value, errorMessage);
344         }
345 
346         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
347             require(isContract(target), "Address: call to non-contract");
348 
349             // solhint-disable-next-line avoid-low-level-calls
350             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
351             if (success) {
352                 return returndata;
353             } else {
354                 // Look for revert reason and bubble it up if present
355                 if (returndata.length > 0) {
356                     // The easiest way to bubble the revert reason is using memory via assembly
357 
358                     // solhint-disable-next-line no-inline-assembly
359                     assembly {
360                         let returndata_size := mload(returndata)
361                         revert(add(32, returndata), returndata_size)
362                     }
363                 } else {
364                     revert(errorMessage);
365                 }
366             }
367         }
368     }
369 
370     contract Ownable is Context {
371         address private _owner;
372         address private _previousOwner;
373         uint256 private _lockTime;
374 
375         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377         /**
378         * @dev Initializes the contract setting the deployer as the initial owner.
379         */
380         constructor () internal {
381             address msgSender = _msgSender();
382             _owner = msgSender;
383             emit OwnershipTransferred(address(0), msgSender);
384         }
385 
386         /**
387         * @dev Returns the address of the current owner.
388         */
389         function owner() public view returns (address) {
390             return _owner;
391         }
392 
393         /**
394         * @dev Throws if called by any account other than the owner.
395         */
396         modifier onlyOwner() {
397             require(_owner == _msgSender(), "Ownable: caller is not the owner");
398             _;
399         }
400 
401         /**
402         * @dev Leaves the contract without owner. It will not be possible to call
403         * `onlyOwner` functions anymore. Can only be called by the current owner.
404         *
405         * NOTE: Renouncing ownership will leave the contract without an owner,
406         * thereby removing any functionality that is only available to the owner.
407         */
408         function renounceOwnership() public virtual onlyOwner {
409             emit OwnershipTransferred(_owner, address(0));
410             _owner = address(0);
411         }
412 
413         /**
414         * @dev Transfers ownership of the contract to a new account (`newOwner`).
415         * Can only be called by the current owner.
416         */
417         function transferOwnership(address newOwner) public virtual onlyOwner {
418             require(newOwner != address(0), "Ownable: new owner is the zero address");
419             emit OwnershipTransferred(_owner, newOwner);
420             _owner = newOwner;
421         }
422 
423         function geUnlockTime() public view returns (uint256) {
424             return _lockTime;
425         }
426 
427     }  
428 
429     interface IUniswapV2Factory {
430         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
431 
432         function feeTo() external view returns (address);
433         function feeToSetter() external view returns (address);
434 
435         function getPair(address tokenA, address tokenB) external view returns (address pair);
436         function allPairs(uint) external view returns (address pair);
437         function allPairsLength() external view returns (uint);
438 
439         function createPair(address tokenA, address tokenB) external returns (address pair);
440 
441         function setFeeTo(address) external;
442         function setFeeToSetter(address) external;
443     } 
444 
445     interface IUniswapV2Pair {
446         event Approval(address indexed owner, address indexed spender, uint value);
447         event Transfer(address indexed from, address indexed to, uint value);
448 
449         function name() external pure returns (string memory);
450         function symbol() external pure returns (string memory);
451         function decimals() external pure returns (uint8);
452         function totalSupply() external view returns (uint);
453         function balanceOf(address owner) external view returns (uint);
454         function allowance(address owner, address spender) external view returns (uint);
455 
456         function approve(address spender, uint value) external returns (bool);
457         function transfer(address to, uint value) external returns (bool);
458         function transferFrom(address from, address to, uint value) external returns (bool);
459 
460         function DOMAIN_SEPARATOR() external view returns (bytes32);
461         function PERMIT_TYPEHASH() external pure returns (bytes32);
462         function nonces(address owner) external view returns (uint);
463 
464         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
465 
466         event Mint(address indexed sender, uint amount0, uint amount1);
467         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
468         event Swap(
469             address indexed sender,
470             uint amount0In,
471             uint amount1In,
472             uint amount0Out,
473             uint amount1Out,
474             address indexed to
475         );
476         event Sync(uint112 reserve0, uint112 reserve1);
477 
478         function MINIMUM_LIQUIDITY() external pure returns (uint);
479         function factory() external view returns (address);
480         function token0() external view returns (address);
481         function token1() external view returns (address);
482         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
483         function price0CumulativeLast() external view returns (uint);
484         function price1CumulativeLast() external view returns (uint);
485         function kLast() external view returns (uint);
486 
487         function mint(address to) external returns (uint liquidity);
488         function burn(address to) external returns (uint amount0, uint amount1);
489         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
490         function skim(address to) external;
491         function sync() external;
492 
493         function initialize(address, address) external;
494     }
495 
496     interface IUniswapV2Router01 {
497         function factory() external pure returns (address);
498         function WETH() external pure returns (address);
499 
500         function addLiquidity(
501             address tokenA,
502             address tokenB,
503             uint amountADesired,
504             uint amountBDesired,
505             uint amountAMin,
506             uint amountBMin,
507             address to,
508             uint deadline
509         ) external returns (uint amountA, uint amountB, uint liquidity);
510         function addLiquidityETH(
511             address token,
512             uint amountTokenDesired,
513             uint amountTokenMin,
514             uint amountETHMin,
515             address to,
516             uint deadline
517         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
518         function removeLiquidity(
519             address tokenA,
520             address tokenB,
521             uint liquidity,
522             uint amountAMin,
523             uint amountBMin,
524             address to,
525             uint deadline
526         ) external returns (uint amountA, uint amountB);
527         function removeLiquidityETH(
528             address token,
529             uint liquidity,
530             uint amountTokenMin,
531             uint amountETHMin,
532             address to,
533             uint deadline
534         ) external returns (uint amountToken, uint amountETH);
535         function removeLiquidityWithPermit(
536             address tokenA,
537             address tokenB,
538             uint liquidity,
539             uint amountAMin,
540             uint amountBMin,
541             address to,
542             uint deadline,
543             bool approveMax, uint8 v, bytes32 r, bytes32 s
544         ) external returns (uint amountA, uint amountB);
545         function removeLiquidityETHWithPermit(
546             address token,
547             uint liquidity,
548             uint amountTokenMin,
549             uint amountETHMin,
550             address to,
551             uint deadline,
552             bool approveMax, uint8 v, bytes32 r, bytes32 s
553         ) external returns (uint amountToken, uint amountETH);
554         function swapExactTokensForTokens(
555             uint amountIn,
556             uint amountOutMin,
557             address[] calldata path,
558             address to,
559             uint deadline
560         ) external returns (uint[] memory amounts);
561         function swapTokensForExactTokens(
562             uint amountOut,
563             uint amountInMax,
564             address[] calldata path,
565             address to,
566             uint deadline
567         ) external returns (uint[] memory amounts);
568         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
569             external
570             payable
571             returns (uint[] memory amounts);
572         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
573             external
574             returns (uint[] memory amounts);
575         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
576             external
577             returns (uint[] memory amounts);
578         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
579             external
580             payable
581             returns (uint[] memory amounts);
582 
583         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
584         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
585         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
586         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
587         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
588     }
589 
590     interface IUniswapV2Router02 is IUniswapV2Router01 {
591         function removeLiquidityETHSupportingFeeOnTransferTokens(
592             address token,
593             uint liquidity,
594             uint amountTokenMin,
595             uint amountETHMin,
596             address to,
597             uint deadline
598         ) external returns (uint amountETH);
599         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
600             address token,
601             uint liquidity,
602             uint amountTokenMin,
603             uint amountETHMin,
604             address to,
605             uint deadline,
606             bool approveMax, uint8 v, bytes32 r, bytes32 s
607         ) external returns (uint amountETH);
608 
609         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
610             uint amountIn,
611             uint amountOutMin,
612             address[] calldata path,
613             address to,
614             uint deadline
615         ) external;
616         function swapExactETHForTokensSupportingFeeOnTransferTokens(
617             uint amountOutMin,
618             address[] calldata path,
619             address to,
620             uint deadline
621         ) external payable;
622         function swapExactTokensForETHSupportingFeeOnTransferTokens(
623             uint amountIn,
624             uint amountOutMin,
625             address[] calldata path,
626             address to,
627             uint deadline
628         ) external;
629     }
630 
631     // Contract implementation
632     contract FreedomInu is Context, IERC20, Ownable {
633         using SafeMath for uint256;
634         using Address for address;
635 
636         mapping (address => uint256) private _rOwned;
637         mapping (address => uint256) private _tOwned;
638         mapping (address => mapping (address => uint256)) private _allowances;
639         mapping (address => uint256) public timestamp;
640 
641         mapping (address => bool) private _isExcludedFromFee;
642     
643         mapping (address => bool) private _isExcluded;
644         address[] private _excluded;
645         mapping (address => bool) private _isBlackListedBot;
646         address[] private _blackListedBots;
647     
648         uint256 private constant MAX = ~uint256(0);
649         uint256 private _tTotal = 100000000 * 10**6 * 10**9;
650         uint256 private _rTotal = (MAX - (MAX % _tTotal));
651         uint256 private _tFeeTotal;
652         uint256 private _CoolDown = 45 seconds;
653 
654         string private _name = 'Freedom Inu';
655         string private _symbol = 'FRDM';
656         uint8 private _decimals = 9;
657          
658         uint256 private _taxFee = 2;
659         uint256 private _teamFee = 10;
660         uint256 private _previousTaxFee = _taxFee;
661         uint256 private _previousteamFee = _teamFee;
662 
663         address payable private _teamWalletAddress;
664         address payable private _charityWalletAddress;
665         
666         IUniswapV2Router02 public immutable uniswapV2Router;
667         address public immutable uniswapV2Pair;
668 
669         bool inSwap = false;
670         bool private swapEnabled = true;
671         bool private tradingEnabled = false;
672         bool private cooldownEnabled = true;
673 
674         uint256 public _maxTxAmount = 300000 * 10**6 * 10**9; 
675         //no max tx limit at deploy
676         uint256 private _numOfTokensToExchangeForteam = 500000000000000;
677 
678         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
679         event SwapEnabledUpdated(bool enabled);
680 
681         modifier lockTheSwap {
682             inSwap = true;
683             _;
684             inSwap = false;
685         }
686 
687         constructor (address payable teamWalletAddress, address payable charityWalletAddress) public {
688             _teamWalletAddress = teamWalletAddress;
689             _charityWalletAddress = charityWalletAddress;
690             _rOwned[_msgSender()] = _rTotal;
691 
692             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
693             // Create a uniswap pair for this new token
694             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
695                 .createPair(address(this), _uniswapV2Router.WETH());
696 
697             // set the rest of the contract variables
698             uniswapV2Router = _uniswapV2Router;
699 
700             // Exclude owner and this contract from fee
701             _isExcludedFromFee[owner()] = true;
702             _isExcludedFromFee[address(this)] = true;
703             
704             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
705             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
706             
707             _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
708             _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
709             
710             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
711             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
712             
713             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
714             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
715     
716             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
717             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
718     
719             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
720             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
721     
722             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
723             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
724     
725             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
726             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
727     
728             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
729             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
730     
731             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
732             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
733     
734             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
735             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
736             
737             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
738             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
739             
740             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
741             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
742             
743             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
744             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
745             
746             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
747             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
748 
749             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
750             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
751             
752             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
753             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
754             
755             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
756             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
757             
758             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
759             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
760             
761             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
762             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
763             
764             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
765             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
766             
767             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
768             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
769             
770             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
771             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
772             
773             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
774             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
775             
776             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
777             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
778             
779             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
780             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
781             
782             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
783             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
784 
785             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
786             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
787             
788             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
789             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
790             
791             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
792             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
793 
794             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
795             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
796 
797             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
798             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
799 
800             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
801             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
802             
803             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
804             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
805             
806             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
807             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
808             
809             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
810             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
811             
812             
813             emit Transfer(address(0), _msgSender(), _tTotal);
814         }
815 
816         function name() public view returns (string memory) {
817             return _name;
818         }
819 
820         function symbol() public view returns (string memory) {
821             return _symbol;
822         }
823 
824         function decimals() public view returns (uint8) {
825             return _decimals;
826         }
827 
828         function totalSupply() public view override returns (uint256) {
829             return _tTotal;
830         }
831 
832         function balanceOf(address account) public view override returns (uint256) {
833             if (_isExcluded[account]) return _tOwned[account];
834             return tokenFromReflection(_rOwned[account]);
835         }
836 
837         function transfer(address recipient, uint256 amount) public override returns (bool) {
838             _transfer(_msgSender(), recipient, amount);
839             return true;
840         }
841 
842         function allowance(address owner, address spender) public view override returns (uint256) {
843             return _allowances[owner][spender];
844         }
845 
846         function approve(address spender, uint256 amount) public override returns (bool) {
847             _approve(_msgSender(), spender, amount);
848             return true;
849         }
850 
851         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
852             _transfer(sender, recipient, amount);
853             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
854             return true;
855         }
856 
857         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
858             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
859             return true;
860         }
861 
862         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
863             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
864             return true;
865         }
866 
867         function isExcluded(address account) public view returns (bool) {
868             return _isExcluded[account];
869         }
870         
871         function isBlackListed(address account) public view returns (bool) {
872             return _isBlackListedBot[account];
873         }
874 
875         function totalFees() public view returns (uint256) {
876             return _tFeeTotal;
877         }
878 
879         function deliver(uint256 tAmount) public {
880             address sender = _msgSender();
881             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
882             (uint256 rAmount,,,,,) = _getValues(tAmount);
883             _rOwned[sender] = _rOwned[sender].sub(rAmount);
884             _rTotal = _rTotal.sub(rAmount);
885             _tFeeTotal = _tFeeTotal.add(tAmount);
886         }
887 
888         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
889             require(tAmount <= _tTotal, "Amount must be less than supply");
890             if (!deductTransferFee) {
891                 (uint256 rAmount,,,,,) = _getValues(tAmount);
892                 return rAmount;
893             } else {
894                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
895                 return rTransferAmount;
896             }
897         }
898 
899         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
900             require(rAmount <= _rTotal, "Amount must be less than total reflections");
901             uint256 currentRate =  _getRate();
902             return rAmount.div(currentRate);
903         }
904 
905         function addBotToBlackList(address account) external onlyOwner() {
906             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
907             require(!_isBlackListedBot[account], "Account is already blacklisted");
908             _isBlackListedBot[account] = true;
909             _blackListedBots.push(account);
910         }
911     
912         function removeBotFromBlackList(address account) external onlyOwner() {
913             require(_isBlackListedBot[account], "Account is not blacklisted");
914             for (uint256 i = 0; i < _blackListedBots.length; i++) {
915                 if (_blackListedBots[i] == account) {
916                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
917                     _isBlackListedBot[account] = false;
918                     _blackListedBots.pop();
919                     break;
920                 }
921             }
922         }
923 
924         function removeAllFee() private {
925             if(_taxFee == 0 && _teamFee == 0) return;
926             
927             _previousTaxFee = _taxFee;
928             _previousteamFee = _teamFee;
929             
930             _taxFee = 0;
931             _teamFee = 0;
932         }
933     
934         function restoreAllFee() private {
935             _taxFee = _previousTaxFee;
936             _teamFee = _previousteamFee;
937         }
938     
939         function isExcludedFromFee(address account) public view returns(bool) {
940             return _isExcludedFromFee[account];
941         }
942         
943         function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
944             _maxTxAmount = _tTotal.mul(maxTxPercent).div(
945             10**2
946         );
947         }
948 
949         function _approve(address owner, address spender, uint256 amount) private {
950             require(owner != address(0), "ERC20: approve from the zero address");
951             require(spender != address(0), "ERC20: approve to the zero address");
952 
953             _allowances[owner][spender] = amount;
954             emit Approval(owner, spender, amount);
955         }
956 
957         function _transfer(address sender, address recipient, uint256 amount) private {
958             require(sender != address(0), "ERC20: transfer from the zero address");
959             require(recipient != address(0), "ERC20: transfer to the zero address");
960             require(amount > 0, "Transfer amount must be greater than zero");
961             require(!_isBlackListedBot[recipient], "You have no power here!");
962             require(!_isBlackListedBot[sender], "You have no power here!");
963 
964             if(sender != owner() && recipient != owner()) {
965                     
966                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
967                 
968                     //you can't trade this on a dex until trading enabled
969                     if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled yet");}
970               
971             }
972             
973             
974              //cooldown logic starts
975              
976              if(cooldownEnabled) {
977               
978               //perform all cooldown checks below only if enabled
979               
980                       if (sender == uniswapV2Pair ) {
981                         
982                         //they just bought add cooldown    
983                         if (!_isExcluded[recipient]) { timestamp[recipient] = block.timestamp.add(_CoolDown); }
984 
985                       }
986                       
987 
988                       // exclude owner and uniswap
989                       if(sender != owner() && sender != uniswapV2Pair) {
990 
991                         // dont apply cooldown to other excluded addresses
992                         if (!_isExcluded[sender]) { require(block.timestamp >= timestamp[sender], "Cooldown"); }
993 
994                       }
995               
996              }
997 
998             // is the token balance of this contract address over the min number of
999             // tokens that we need to initiate a swap?
1000             // also, don't get caught in a circular team event.
1001             // also, don't swap if sender is uniswap pair.
1002             uint256 contractTokenBalance = balanceOf(address(this));
1003             
1004             if(contractTokenBalance >= _maxTxAmount)
1005             {
1006                 contractTokenBalance = _maxTxAmount;
1007             }
1008             
1009             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForteam;
1010             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1011                 // We need to swap the current tokens to ETH and send to the team wallet
1012                 swapTokensForEth(contractTokenBalance);
1013                 
1014                 uint256 contractETHBalance = address(this).balance;
1015                 if(contractETHBalance > 0) {
1016                     sendETHToteam(address(this).balance);
1017                 }
1018             }
1019             
1020             //indicates if fee should be deducted from transfer
1021             bool takeFee = true;
1022             
1023             //if any account belongs to _isExcludedFromFee account then remove the fee
1024             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1025                 takeFee = false;
1026             }
1027             
1028             //transfer amount, it will take tax and team fee
1029             _tokenTransfer(sender,recipient,amount,takeFee);
1030         }
1031 
1032         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1033             // generate the uniswap pair path of token -> weth
1034             address[] memory path = new address[](2);
1035             path[0] = address(this);
1036             path[1] = uniswapV2Router.WETH();
1037 
1038             _approve(address(this), address(uniswapV2Router), tokenAmount);
1039 
1040             // make the swap
1041             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1042                 tokenAmount,
1043                 0, // accept any amount of ETH
1044                 path,
1045                 address(this),
1046                 block.timestamp
1047             );
1048         }
1049         
1050         function sendETHToteam(uint256 amount) private {
1051             _teamWalletAddress.transfer(amount.div(2));
1052             _charityWalletAddress.transfer(amount.div(2));
1053         }
1054         
1055         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1056             if(!takeFee)
1057                 removeAllFee();
1058 
1059             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1060                 _transferFromExcluded(sender, recipient, amount);
1061             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1062                 _transferToExcluded(sender, recipient, amount);
1063             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1064                 _transferStandard(sender, recipient, amount);
1065             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1066                 _transferBothExcluded(sender, recipient, amount);
1067             } else {
1068                 _transferStandard(sender, recipient, amount);
1069             }
1070 
1071             if(!takeFee)
1072                 restoreAllFee();
1073         }
1074 
1075         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1076             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1077             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1078             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1079             _taketeam(tteam); 
1080             _reflectFee(rFee, tFee);
1081             emit Transfer(sender, recipient, tTransferAmount);
1082         }
1083 
1084         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1085             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1086             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1087             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1088             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1089             _taketeam(tteam);           
1090             _reflectFee(rFee, tFee);
1091             emit Transfer(sender, recipient, tTransferAmount);
1092         }
1093 
1094         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1095             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1096             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1097             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1098             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1099             _taketeam(tteam);   
1100             _reflectFee(rFee, tFee);
1101             emit Transfer(sender, recipient, tTransferAmount);
1102         }
1103 
1104         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1105             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1106             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1107             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1108             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1109             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1110             _taketeam(tteam);         
1111             _reflectFee(rFee, tFee);
1112             emit Transfer(sender, recipient, tTransferAmount);
1113         }
1114 
1115         function _taketeam(uint256 tteam) private {
1116             uint256 currentRate =  _getRate();
1117             uint256 rteam = tteam.mul(currentRate);
1118             _rOwned[address(this)] = _rOwned[address(this)].add(rteam);
1119             if(_isExcluded[address(this)])
1120                 _tOwned[address(this)] = _tOwned[address(this)].add(tteam);
1121         }
1122 
1123         function _reflectFee(uint256 rFee, uint256 tFee) private {
1124             _rTotal = _rTotal.sub(rFee);
1125             _tFeeTotal = _tFeeTotal.add(tFee);
1126         }
1127 
1128          //to recieve ETH from uniswapV2Router when swaping
1129         receive() external payable {}
1130 
1131         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1132             (uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getTValues(tAmount, _taxFee, _teamFee);
1133             uint256 currentRate =  _getRate();
1134             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1135             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tteam);
1136         }
1137 
1138         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1139             uint256 tFee = tAmount.mul(taxFee).div(100);
1140             uint256 tteam = tAmount.mul(teamFee).div(100);
1141             uint256 tTransferAmount = tAmount.sub(tFee).sub(tteam);
1142             return (tTransferAmount, tFee, tteam);
1143         }
1144 
1145         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1146             uint256 rAmount = tAmount.mul(currentRate);
1147             uint256 rFee = tFee.mul(currentRate);
1148             uint256 rTransferAmount = rAmount.sub(rFee);
1149             return (rAmount, rTransferAmount, rFee);
1150         }
1151 
1152         function _getRate() private view returns(uint256) {
1153             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1154             return rSupply.div(tSupply);
1155         }
1156 
1157         function _getCurrentSupply() private view returns(uint256, uint256) {
1158             uint256 rSupply = _rTotal;
1159             uint256 tSupply = _tTotal;      
1160             for (uint256 i = 0; i < _excluded.length; i++) {
1161                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1162                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1163                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1164             }
1165             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1166             return (rSupply, tSupply);
1167         }
1168         
1169         function _getTaxFee() private view returns(uint256) {
1170             return _taxFee;
1171         }
1172 
1173         function _getMaxTxAmount() private view returns(uint256) {
1174             return _maxTxAmount;
1175         }
1176 
1177         function _getETHBalance() public view returns(uint256 balance) {
1178             return address(this).balance;
1179         }
1180         
1181          function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
1182              tradingEnabled = _tradingEnabled;
1183          }
1184          
1185          function ToggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
1186              cooldownEnabled = _cooldownEnabled;
1187          }
1188         
1189     }