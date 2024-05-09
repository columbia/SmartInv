1 /*
2 
3 might be a moonshot but...DYOR
4  https://t.me/dyor_token
5  
6 */
7 
8 // SPDX-License-Identifier: Unlicensed
9 
10 pragma solidity ^0.6.12;
11 
12     abstract contract Context {
13         function _msgSender() internal view virtual returns (address payable) {
14             return msg.sender;
15         }
16 
17         function _msgData() internal view virtual returns (bytes memory) {
18             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19             return msg.data;
20         }
21     }
22 
23     interface IERC20 {
24         /**
25         * @dev Returns the amount of tokens in existence.
26         */
27         function totalSupply() external view returns (uint256);
28 
29         /**
30         * @dev Returns the amount of tokens owned by `account`.
31         */
32         function balanceOf(address account) external view returns (uint256);
33 
34         /**
35         * @dev Moves `amount` tokens from the caller's account to `recipient`.
36         *
37         * Returns a boolean value indicating whether the operation succeeded.
38         *
39         * Emits a {Transfer} event.
40         */
41         function transfer(address recipient, uint256 amount) external returns (bool);
42 
43         /**
44         * @dev Returns the remaining number of tokens that `spender` will be
45         * allowed to spend on behalf of `owner` through {transferFrom}. This is
46         * zero by default.
47         *
48         * This value changes when {approve} or {transferFrom} are called.
49         */
50         function allowance(address owner, address spender) external view returns (uint256);
51 
52         /**
53         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54         *
55         * Returns a boolean value indicating whether the operation succeeded.
56         *
57         * IMPORTANT: Beware that changing an allowance with this method brings the risk
58         * that someone may use both the old and the new allowance by unfortunate
59         * transaction ordering. One possible solution to mitigate this race
60         * condition is to first reduce the spender's allowance to 0 and set the
61         * desired value afterwards:
62         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63         *
64         * Emits an {Approval} event.
65         */
66         function approve(address spender, uint256 amount) external returns (bool);
67 
68         /**
69         * @dev Moves `amount` tokens from `sender` to `recipient` using the
70         * allowance mechanism. `amount` is then deducted from the caller's
71         * allowance.
72         *
73         * Returns a boolean value indicating whether the operation succeeded.
74         *
75         * Emits a {Transfer} event.
76         */
77         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79         /**
80         * @dev Emitted when `value` tokens are moved from one account (`from`) to
81         * another (`to`).
82         *
83         * Note that `value` may be zero.
84         */
85         event Transfer(address indexed from, address indexed to, uint256 value);
86 
87         /**
88         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89         * a call to {approve}. `value` is the new allowance.
90         */
91         event Approval(address indexed owner, address indexed spender, uint256 value);
92     }
93 
94     library SafeMath {
95         /**
96         * @dev Returns the addition of two unsigned integers, reverting on
97         * overflow.
98         *
99         * Counterpart to Solidity's `+` operator.
100         *
101         * Requirements:
102         *
103         * - Addition cannot overflow.
104         */
105         function add(uint256 a, uint256 b) internal pure returns (uint256) {
106             uint256 c = a + b;
107             require(c >= a, "SafeMath: addition overflow");
108 
109             return c;
110         }
111 
112         /**
113         * @dev Returns the subtraction of two unsigned integers, reverting on
114         * overflow (when the result is negative).
115         *
116         * Counterpart to Solidity's `-` operator.
117         *
118         * Requirements:
119         *
120         * - Subtraction cannot overflow.
121         */
122         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123             return sub(a, b, "SafeMath: subtraction overflow");
124         }
125 
126         /**
127         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128         * overflow (when the result is negative).
129         *
130         * Counterpart to Solidity's `-` operator.
131         *
132         * Requirements:
133         *
134         * - Subtraction cannot overflow.
135         */
136         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137             require(b <= a, errorMessage);
138             uint256 c = a - b;
139 
140             return c;
141         }
142 
143         /**
144         * @dev Returns the multiplication of two unsigned integers, reverting on
145         * overflow.
146         *
147         * Counterpart to Solidity's `*` operator.
148         *
149         * Requirements:
150         *
151         * - Multiplication cannot overflow.
152         */
153         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155             // benefit is lost if 'b' is also tested.
156             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157             if (a == 0) {
158                 return 0;
159             }
160 
161             uint256 c = a * b;
162             require(c / a == b, "SafeMath: multiplication overflow");
163 
164             return c;
165         }
166 
167         /**
168         * @dev Returns the integer division of two unsigned integers. Reverts on
169         * division by zero. The result is rounded towards zero.
170         *
171         * Counterpart to Solidity's `/` operator. Note: this function uses a
172         * `revert` opcode (which leaves remaining gas untouched) while Solidity
173         * uses an invalid opcode to revert (consuming all remaining gas).
174         *
175         * Requirements:
176         *
177         * - The divisor cannot be zero.
178         */
179         function div(uint256 a, uint256 b) internal pure returns (uint256) {
180             return div(a, b, "SafeMath: division by zero");
181         }
182 
183         /**
184         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185         * division by zero. The result is rounded towards zero.
186         *
187         * Counterpart to Solidity's `/` operator. Note: this function uses a
188         * `revert` opcode (which leaves remaining gas untouched) while Solidity
189         * uses an invalid opcode to revert (consuming all remaining gas).
190         *
191         * Requirements:
192         *
193         * - The divisor cannot be zero.
194         */
195         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196             require(b > 0, errorMessage);
197             uint256 c = a / b;
198             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200             return c;
201         }
202 
203         /**
204         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205         * Reverts when dividing by zero.
206         *
207         * Counterpart to Solidity's `%` operator. This function uses a `revert`
208         * opcode (which leaves remaining gas untouched) while Solidity uses an
209         * invalid opcode to revert (consuming all remaining gas).
210         *
211         * Requirements:
212         *
213         * - The divisor cannot be zero.
214         */
215         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216             return mod(a, b, "SafeMath: modulo by zero");
217         }
218 
219         /**
220         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221         * Reverts with custom message when dividing by zero.
222         *
223         * Counterpart to Solidity's `%` operator. This function uses a `revert`
224         * opcode (which leaves remaining gas untouched) while Solidity uses an
225         * invalid opcode to revert (consuming all remaining gas).
226         *
227         * Requirements:
228         *
229         * - The divisor cannot be zero.
230         */
231         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232             require(b != 0, errorMessage);
233             return a % b;
234         }
235     }
236 
237     library Address {
238         /**
239         * @dev Returns true if `account` is a contract.
240         *
241         * [IMPORTANT]
242         * ====
243         * It is unsafe to assume that an address for which this function returns
244         * false is an externally-owned account (EOA) and not a contract.
245         *
246         * Among others, `isContract` will return false for the following
247         * types of addresses:
248         *
249         *  - an externally-owned account
250         *  - a contract in construction
251         *  - an address where a contract will be created
252         *  - an address where a contract lived, but was destroyed
253         * ====
254         */
255         function isContract(address account) internal view returns (bool) {
256             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258             // for accounts without code, i.e. `keccak256('')`
259             bytes32 codehash;
260             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261             // solhint-disable-next-line no-inline-assembly
262             assembly { codehash := extcodehash(account) }
263             return (codehash != accountHash && codehash != 0x0);
264         }
265 
266         /**
267         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268         * `recipient`, forwarding all available gas and reverting on errors.
269         *
270         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271         * of certain opcodes, possibly making contracts go over the 2300 gas limit
272         * imposed by `transfer`, making them unable to receive funds via
273         * `transfer`. {sendValue} removes this limitation.
274         *
275         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276         *
277         * IMPORTANT: because control is transferred to `recipient`, care must be
278         * taken to not create reentrancy vulnerabilities. Consider using
279         * {ReentrancyGuard} or the
280         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281         */
282         function sendValue(address payable recipient, uint256 amount) internal {
283             require(address(this).balance >= amount, "Address: insufficient balance");
284 
285             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286             (bool success, ) = recipient.call{ value: amount }("");
287             require(success, "Address: unable to send value, recipient may have reverted");
288         }
289 
290         /**
291         * @dev Performs a Solidity function call using a low level `call`. A
292         * plain`call` is an unsafe replacement for a function call: use this
293         * function instead.
294         *
295         * If `target` reverts with a revert reason, it is bubbled up by this
296         * function (like regular Solidity function calls).
297         *
298         * Returns the raw returned data. To convert to the expected return value,
299         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300         *
301         * Requirements:
302         *
303         * - `target` must be a contract.
304         * - calling `target` with `data` must not revert.
305         *
306         * _Available since v3.1._
307         */
308         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310         }
311 
312         /**
313         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314         * `errorMessage` as a fallback revert reason when `target` reverts.
315         *
316         * _Available since v3.1._
317         */
318         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319             return _functionCallWithValue(target, data, 0, errorMessage);
320         }
321 
322         /**
323         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324         * but also transferring `value` wei to `target`.
325         *
326         * Requirements:
327         *
328         * - the calling contract must have an ETH balance of at least `value`.
329         * - the called Solidity function must be `payable`.
330         *
331         * _Available since v3.1._
332         */
333         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335         }
336 
337         /**
338         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339         * with `errorMessage` as a fallback revert reason when `target` reverts.
340         *
341         * _Available since v3.1._
342         */
343         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344             require(address(this).balance >= value, "Address: insufficient balance for call");
345             return _functionCallWithValue(target, data, value, errorMessage);
346         }
347 
348         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
349             require(isContract(target), "Address: call to non-contract");
350 
351             // solhint-disable-next-line avoid-low-level-calls
352             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
353             if (success) {
354                 return returndata;
355             } else {
356                 // Look for revert reason and bubble it up if present
357                 if (returndata.length > 0) {
358                     // The easiest way to bubble the revert reason is using memory via assembly
359 
360                     // solhint-disable-next-line no-inline-assembly
361                     assembly {
362                         let returndata_size := mload(returndata)
363                         revert(add(32, returndata), returndata_size)
364                     }
365                 } else {
366                     revert(errorMessage);
367                 }
368             }
369         }
370     }
371 
372     contract Ownable is Context {
373         address private _owner;
374         address private _previousOwner;
375         uint256 private _lockTime;
376 
377         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379         /**
380         * @dev Initializes the contract setting the deployer as the initial owner.
381         */
382         constructor () internal {
383             address msgSender = _msgSender();
384             _owner = msgSender;
385             emit OwnershipTransferred(address(0), msgSender);
386         }
387 
388         /**
389         * @dev Returns the address of the current owner.
390         */
391         function owner() public view returns (address) {
392             return _owner;
393         }
394 
395         /**
396         * @dev Throws if called by any account other than the owner.
397         */
398         modifier onlyOwner() {
399             require(_owner == _msgSender(), "Ownable: caller is not the owner");
400             _;
401         }
402 
403         /**
404         * @dev Leaves the contract without owner. It will not be possible to call
405         * `onlyOwner` functions anymore. Can only be called by the current owner.
406         *
407         * NOTE: Renouncing ownership will leave the contract without an owner,
408         * thereby removing any functionality that is only available to the owner.
409         */
410         function renounceOwnership() public virtual onlyOwner {
411             emit OwnershipTransferred(_owner, address(0));
412             _owner = address(0);
413         }
414 
415         /**
416         * @dev Transfers ownership of the contract to a new account (`newOwner`).
417         * Can only be called by the current owner.
418         */
419         function transferOwnership(address newOwner) public virtual onlyOwner {
420             require(newOwner != address(0), "Ownable: new owner is the zero address");
421             emit OwnershipTransferred(_owner, newOwner);
422             _owner = newOwner;
423         }
424 
425         function getUnlockTime() public view returns (uint256) {
426             return _lockTime;
427         }
428 
429     }
430 
431     interface IUniswapV2Factory {
432         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
433 
434         function feeTo() external view returns (address);
435         function feeToSetter() external view returns (address);
436 
437         function getPair(address tokenA, address tokenB) external view returns (address pair);
438         function allPairs(uint) external view returns (address pair);
439         function allPairsLength() external view returns (uint);
440 
441         function createPair(address tokenA, address tokenB) external returns (address pair);
442 
443         function setFeeTo(address) external;
444         function setFeeToSetter(address) external;
445     }
446 
447     interface IUniswapV2Pair {
448         event Approval(address indexed owner, address indexed spender, uint value);
449         event Transfer(address indexed from, address indexed to, uint value);
450 
451         function name() external pure returns (string memory);
452         function symbol() external pure returns (string memory);
453         function decimals() external pure returns (uint8);
454         function totalSupply() external view returns (uint);
455         function balanceOf(address owner) external view returns (uint);
456         function allowance(address owner, address spender) external view returns (uint);
457 
458         function approve(address spender, uint value) external returns (bool);
459         function transfer(address to, uint value) external returns (bool);
460         function transferFrom(address from, address to, uint value) external returns (bool);
461 
462         function DOMAIN_SEPARATOR() external view returns (bytes32);
463         function PERMIT_TYPEHASH() external pure returns (bytes32);
464         function nonces(address owner) external view returns (uint);
465 
466         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
467 
468         event Mint(address indexed sender, uint amount0, uint amount1);
469         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
470         event Swap(
471             address indexed sender,
472             uint amount0In,
473             uint amount1In,
474             uint amount0Out,
475             uint amount1Out,
476             address indexed to
477         );
478         event Sync(uint112 reserve0, uint112 reserve1);
479 
480         function MINIMUM_LIQUIDITY() external pure returns (uint);
481         function factory() external view returns (address);
482         function token0() external view returns (address);
483         function token1() external view returns (address);
484         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
485         function price0CumulativeLast() external view returns (uint);
486         function price1CumulativeLast() external view returns (uint);
487         function kLast() external view returns (uint);
488 
489         function mint(address to) external returns (uint liquidity);
490         function burn(address to) external returns (uint amount0, uint amount1);
491         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
492         function skim(address to) external;
493         function sync() external;
494 
495         function initialize(address, address) external;
496     }
497 
498     interface IUniswapV2Router01 {
499         function factory() external pure returns (address);
500         function WETH() external pure returns (address);
501 
502         function addLiquidity(
503             address tokenA,
504             address tokenB,
505             uint amountADesired,
506             uint amountBDesired,
507             uint amountAMin,
508             uint amountBMin,
509             address to,
510             uint deadline
511         ) external returns (uint amountA, uint amountB, uint liquidity);
512         function addLiquidityETH(
513             address token,
514             uint amountTokenDesired,
515             uint amountTokenMin,
516             uint amountETHMin,
517             address to,
518             uint deadline
519         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
520         function removeLiquidity(
521             address tokenA,
522             address tokenB,
523             uint liquidity,
524             uint amountAMin,
525             uint amountBMin,
526             address to,
527             uint deadline
528         ) external returns (uint amountA, uint amountB);
529         function removeLiquidityETH(
530             address token,
531             uint liquidity,
532             uint amountTokenMin,
533             uint amountETHMin,
534             address to,
535             uint deadline
536         ) external returns (uint amountToken, uint amountETH);
537         function removeLiquidityWithPermit(
538             address tokenA,
539             address tokenB,
540             uint liquidity,
541             uint amountAMin,
542             uint amountBMin,
543             address to,
544             uint deadline,
545             bool approveMax, uint8 v, bytes32 r, bytes32 s
546         ) external returns (uint amountA, uint amountB);
547         function removeLiquidityETHWithPermit(
548             address token,
549             uint liquidity,
550             uint amountTokenMin,
551             uint amountETHMin,
552             address to,
553             uint deadline,
554             bool approveMax, uint8 v, bytes32 r, bytes32 s
555         ) external returns (uint amountToken, uint amountETH);
556         function swapExactTokensForTokens(
557             uint amountIn,
558             uint amountOutMin,
559             address[] calldata path,
560             address to,
561             uint deadline
562         ) external returns (uint[] memory amounts);
563         function swapTokensForExactTokens(
564             uint amountOut,
565             uint amountInMax,
566             address[] calldata path,
567             address to,
568             uint deadline
569         ) external returns (uint[] memory amounts);
570         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
571             external
572             payable
573             returns (uint[] memory amounts);
574         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
575             external
576             returns (uint[] memory amounts);
577         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
578             external
579             returns (uint[] memory amounts);
580         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
581             external
582             payable
583             returns (uint[] memory amounts);
584 
585         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
586         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
587         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
588         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
589         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
590     }
591 
592     interface IUniswapV2Router02 is IUniswapV2Router01 {
593         function removeLiquidityETHSupportingFeeOnTransferTokens(
594             address token,
595             uint liquidity,
596             uint amountTokenMin,
597             uint amountETHMin,
598             address to,
599             uint deadline
600         ) external returns (uint amountETH);
601         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
602             address token,
603             uint liquidity,
604             uint amountTokenMin,
605             uint amountETHMin,
606             address to,
607             uint deadline,
608             bool approveMax, uint8 v, bytes32 r, bytes32 s
609         ) external returns (uint amountETH);
610 
611         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
612             uint amountIn,
613             uint amountOutMin,
614             address[] calldata path,
615             address to,
616             uint deadline
617         ) external;
618         function swapExactETHForTokensSupportingFeeOnTransferTokens(
619             uint amountOutMin,
620             address[] calldata path,
621             address to,
622             uint deadline
623         ) external payable;
624         function swapExactTokensForETHSupportingFeeOnTransferTokens(
625             uint amountIn,
626             uint amountOutMin,
627             address[] calldata path,
628             address to,
629             uint deadline
630         ) external;
631     }
632 
633     contract DYOR is Context, IERC20, Ownable {
634         using SafeMath for uint256;
635         using Address for address;
636 
637         mapping (address => uint256) private _rOwned;
638         mapping (address => uint256) private _tOwned;
639         mapping (address => mapping (address => uint256)) private _allowances;
640 
641         mapping (address => bool) private _isExcludedFromFee;
642 
643         mapping (address => bool) private _isExcluded;
644         address[] private _excluded;
645         mapping (address => bool) private _isBlackListedBot;
646         address[] private _blackListedBots;
647 
648         uint256 private constant MAX = ~uint256(0);
649         uint256 private constant _tTotal = 1000000000 * 10**18;
650         uint256 private _rTotal = (MAX - (MAX % _tTotal));
651         uint256 private _tFeeTotal;
652 
653         string private constant _name = 'DYOR';
654         string private constant _symbol = 'DYOR';
655         uint8 private constant _decimals = 18;
656 
657         uint256 private _taxFee = 1;
658         uint256 private _teamFee = 7;
659         uint256 private _previousTaxFee = _taxFee;
660         uint256 private _previousTeamFee = _teamFee;
661 
662         address payable public _devWalletAddress;
663         address payable public _marketingWalletAddress;
664 
665 
666         IUniswapV2Router02 public immutable uniswapV2Router;
667         address public immutable uniswapV2Pair;
668 
669         bool inSwap = false;
670         bool public swapEnabled = true;
671 
672         uint256 private _maxTxAmount = 20000000 * 10**18;
673         uint256 private constant _numOfTokensToExchangeForTeam = 7000 * 10**18;
674         uint256 private _maxWalletSize = 20000000 * 10**18;
675 
676         event botAddedToBlacklist(address account);
677         event botRemovedFromBlacklist(address account);
678 
679         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
680         // event SwapEnabledUpdated(bool enabled);
681 
682         modifier lockTheSwap {
683             inSwap = true;
684             _;
685             inSwap = false;
686         }
687 
688         constructor (address payable devWalletAddress, address payable marketingWalletAddress) public {
689             _devWalletAddress = devWalletAddress;
690             _marketingWalletAddress = marketingWalletAddress;
691 
692             _rOwned[_msgSender()] = _rTotal;
693 
694             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
695             // Create a uniswap pair for this new token
696             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
697                 .createPair(address(this), _uniswapV2Router.WETH());
698 
699             // set the rest of the contract variables
700             uniswapV2Router = _uniswapV2Router;
701 
702             // Exclude owner and this contract from fee
703             _isExcludedFromFee[owner()] = true;
704             _isExcludedFromFee[address(this)] = true;
705 
706             emit Transfer(address(0), _msgSender(), _tTotal);
707         }
708 
709         function name() public pure returns (string memory) {
710             return _name;
711         }
712 
713         function symbol() public pure returns (string memory) {
714             return _symbol;
715         }
716 
717         function decimals() public pure returns (uint8) {
718             return _decimals;
719         }
720 
721         function totalSupply() public view override returns (uint256) {
722             return _tTotal;
723         }
724 
725         function balanceOf(address account) public view override returns (uint256) {
726             if (_isExcluded[account]) return _tOwned[account];
727             return tokenFromReflection(_rOwned[account]);
728         }
729 
730         function transfer(address recipient, uint256 amount) public override returns (bool) {
731             _transfer(_msgSender(), recipient, amount);
732             return true;
733         }
734 
735         function allowance(address owner, address spender) public view override returns (uint256) {
736             return _allowances[owner][spender];
737         }
738 
739         function approve(address spender, uint256 amount) public override returns (bool) {
740             _approve(_msgSender(), spender, amount);
741             return true;
742         }
743 
744         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
745             _transfer(sender, recipient, amount);
746             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
747             return true;
748         }
749 
750         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
751             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
752             return true;
753         }
754 
755         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
756             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
757             return true;
758         }
759 
760         function isExcluded(address account) public view returns (bool) {
761             return _isExcluded[account];
762         }
763 
764         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
765             _isExcludedFromFee[account] = excluded;
766         }
767 
768         function totalFees() public view returns (uint256) {
769             return _tFeeTotal;
770         }
771 
772         function deliver(uint256 tAmount) public {
773             address sender = _msgSender();
774             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
775             (uint256 rAmount,,,,,) = _getValues(tAmount);
776             _rOwned[sender] = _rOwned[sender].sub(rAmount);
777             _rTotal = _rTotal.sub(rAmount);
778             _tFeeTotal = _tFeeTotal.add(tAmount);
779         }
780 
781         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
782             require(tAmount <= _tTotal, "Amount must be less than supply");
783             if (!deductTransferFee) {
784                 (uint256 rAmount,,,,,) = _getValues(tAmount);
785                 return rAmount;
786             } else {
787                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
788                 return rTransferAmount;
789             }
790         }
791 
792         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
793             require(rAmount <= _rTotal, "Amount must be less than total reflections");
794             uint256 currentRate =  _getRate();
795             return rAmount.div(currentRate);
796         }
797 
798         function addBotToBlacklist (address account) external onlyOwner() {
799            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
800            require (!_isBlackListedBot[account], 'Account is already blacklisted');
801            _isBlackListedBot[account] = true;
802            _blackListedBots.push(account);
803         }
804 
805         function removeBotFromBlacklist(address account) external onlyOwner() {
806           require (_isBlackListedBot[account], 'Account is not blacklisted');
807           for (uint256 i = 0; i < _blackListedBots.length; i++) {
808                  if (_blackListedBots[i] == account) {
809                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
810                      _isBlackListedBot[account] = false;
811                      _blackListedBots.pop();
812                      break;
813                  }
814            }
815        }
816 
817         function excludeAccount(address account) external onlyOwner() {
818             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
819             require(!_isExcluded[account], "Account is already excluded");
820             if(_rOwned[account] > 0) {
821                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
822             }
823             _isExcluded[account] = true;
824             _excluded.push(account);
825         }
826 
827         function includeAccount(address account) external onlyOwner() {
828             require(_isExcluded[account], "Account is not excluded");
829             for (uint256 i = 0; i < _excluded.length; i++) {
830                 if (_excluded[i] == account) {
831                     _excluded[i] = _excluded[_excluded.length - 1];
832                     _tOwned[account] = 0;
833                     _isExcluded[account] = false;
834                     _excluded.pop();
835                     break;
836                 }
837             }
838         }
839 
840         function removeAllFee() private {
841             if(_taxFee == 0 && _teamFee == 0) return;
842 
843             _previousTaxFee = _taxFee;
844             _previousTeamFee = _teamFee;
845 
846             _taxFee = 0;
847             _teamFee = 0;
848         }
849 
850         function restoreAllFee() private {
851             _taxFee = _previousTaxFee;
852             _teamFee = _previousTeamFee;
853         }
854 
855         function isExcludedFromFee(address account) public view returns(bool) {
856             return _isExcludedFromFee[account];
857         }
858 
859         function _approve(address owner, address spender, uint256 amount) private {
860             require(owner != address(0), "ERC20: approve from the zero address");
861             require(spender != address(0), "ERC20: approve to the zero address");
862 
863             _allowances[owner][spender] = amount;
864             emit Approval(owner, spender, amount);
865         }
866 
867         function _transfer(address sender, address recipient, uint256 amount) private {
868             require(sender != address(0), "ERC20: transfer from the zero address");
869             require(recipient != address(0), "ERC20: transfer to the zero address");
870             require(amount > 0, "Transfer amount must be greater than zero");
871             require(!_isBlackListedBot[sender], "You are blacklisted");
872             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
873             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
874             if(sender != owner() && recipient != owner()) {
875                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
876             }
877             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
878                 uint256 tokenBalanceRecipient = balanceOf(recipient);
879                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
880             }
881             // is the token balance of this contract address over the min number of
882             // tokens that we need to initiate a swap?
883             // also, don't get caught in a circular team event.
884             // also, don't swap if sender is uniswap pair.
885             uint256 contractTokenBalance = balanceOf(address(this));
886 
887             if(contractTokenBalance >= _maxTxAmount)
888             {
889                 contractTokenBalance = _maxTxAmount;
890             }
891 
892             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
893             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
894                 // Swap tokens for ETH and send to resepctive wallets
895                 swapTokensForEth(contractTokenBalance);
896 
897                 uint256 contractETHBalance = address(this).balance;
898                 if(contractETHBalance > 0) {
899                     sendETHToTeam(address(this).balance);
900                 }
901             }
902 
903             //indicates if fee should be deducted from transfer
904             bool takeFee = true;
905 
906             //if any account belongs to _isExcludedFromFee account then remove the fee
907             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
908                 takeFee = false;
909             }
910 
911             //transfer amount, it will take tax and team fee
912             _tokenTransfer(sender,recipient,amount,takeFee);
913         }
914 
915         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
916             // generate the uniswap pair path of token -> weth
917             address[] memory path = new address[](2);
918             path[0] = address(this);
919             path[1] = uniswapV2Router.WETH();
920 
921             _approve(address(this), address(uniswapV2Router), tokenAmount);
922 
923             // make the swap
924             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
925                 tokenAmount,
926                 0, // accept any amount of ETH
927                 path,
928                 address(this),
929                 block.timestamp
930             );
931         }
932 
933         function sendETHToTeam(uint256 amount) private {
934             _devWalletAddress.transfer(amount.div(5));
935             _marketingWalletAddress.transfer(amount.div(10).mul(8));
936         }
937 
938         function manualSwap() external onlyOwner() {
939             uint256 contractBalance = balanceOf(address(this));
940             swapTokensForEth(contractBalance);
941         }
942 
943         function manualSend() external onlyOwner() {
944             uint256 contractETHBalance = address(this).balance;
945             sendETHToTeam(contractETHBalance);
946         }
947 
948         function setSwapEnabled(bool enabled) external onlyOwner(){
949             swapEnabled = enabled;
950         }
951 
952         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
953             if(!takeFee)
954                 removeAllFee();
955 
956             if (_isExcluded[sender] && !_isExcluded[recipient]) {
957                 _transferFromExcluded(sender, recipient, amount);
958             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
959                 _transferToExcluded(sender, recipient, amount);
960             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
961                 _transferStandard(sender, recipient, amount);
962             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
963                 _transferBothExcluded(sender, recipient, amount);
964             } else {
965                 _transferStandard(sender, recipient, amount);
966             }
967 
968             if(!takeFee)
969                 restoreAllFee();
970         }
971 
972         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
973             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
974             _rOwned[sender] = _rOwned[sender].sub(rAmount);
975             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
976             _takeTeam(tTeam);
977             _reflectFee(rFee, tFee);
978             emit Transfer(sender, recipient, tTransferAmount);
979         }
980 
981         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
982             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
983             _rOwned[sender] = _rOwned[sender].sub(rAmount);
984             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
985             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
986             _takeTeam(tTeam);
987             _reflectFee(rFee, tFee);
988             emit Transfer(sender, recipient, tTransferAmount);
989         }
990 
991         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
992             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
993             _tOwned[sender] = _tOwned[sender].sub(tAmount);
994             _rOwned[sender] = _rOwned[sender].sub(rAmount);
995             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
996             _takeTeam(tTeam);
997             _reflectFee(rFee, tFee);
998             emit Transfer(sender, recipient, tTransferAmount);
999         }
1000 
1001         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1002             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1003             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1004             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1005             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1006             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1007             _takeTeam(tTeam);
1008             _reflectFee(rFee, tFee);
1009             emit Transfer(sender, recipient, tTransferAmount);
1010         }
1011 
1012         function _takeTeam(uint256 tTeam) private {
1013             uint256 currentRate =  _getRate();
1014             uint256 rTeam = tTeam.mul(currentRate);
1015             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1016             if(_isExcluded[address(this)])
1017                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1018         }
1019 
1020         function _reflectFee(uint256 rFee, uint256 tFee) private {
1021             _rTotal = _rTotal.sub(rFee);
1022             _tFeeTotal = _tFeeTotal.add(tFee);
1023         }
1024 
1025          //to recieve ETH from uniswapV2Router when swaping
1026         receive() external payable {}
1027 
1028         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1029         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1030         uint256 currentRate = _getRate();
1031         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1032         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1033     }
1034 
1035         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1036             uint256 tFee = tAmount.mul(taxFee).div(100);
1037             uint256 tTeam = tAmount.mul(teamFee).div(100);
1038             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1039             return (tTransferAmount, tFee, tTeam);
1040         }
1041 
1042         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1043             uint256 rAmount = tAmount.mul(currentRate);
1044             uint256 rFee = tFee.mul(currentRate);
1045             uint256 rTeam = tTeam.mul(currentRate);
1046             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1047             return (rAmount, rTransferAmount, rFee);
1048         }
1049 
1050         function _getRate() private view returns(uint256) {
1051             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1052             return rSupply.div(tSupply);
1053         }
1054 
1055         function _getCurrentSupply() private view returns(uint256, uint256) {
1056             uint256 rSupply = _rTotal;
1057             uint256 tSupply = _tTotal;
1058             for (uint256 i = 0; i < _excluded.length; i++) {
1059                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1060                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1061                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1062             }
1063             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1064             return (rSupply, tSupply);
1065         }
1066 
1067         function _getTaxFee() public view returns(uint256) {
1068             return _taxFee;
1069         }
1070 
1071         function _getTeamFee() public view returns (uint256) {
1072           return _teamFee;
1073         }
1074 
1075         function _getMaxTxAmount() public view returns(uint256) {
1076             return _maxTxAmount;
1077         }
1078 
1079         function _getETHBalance() public view returns(uint256 balance) {
1080             return address(this).balance;
1081         }
1082 
1083         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1084             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1085             _taxFee = taxFee;
1086         }
1087 
1088         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1089             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1090             _teamFee = teamFee;
1091         }
1092 
1093         function _setDevWallet(address payable devWalletAddress) external onlyOwner() {
1094             _devWalletAddress = devWalletAddress;
1095         }
1096 
1097         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1098             _marketingWalletAddress = marketingWalletAddress;
1099         }
1100 
1101         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1102             _maxTxAmount = maxTxAmount;
1103         }
1104 
1105         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1106           _maxWalletSize = maxWalletSize;
1107         }
1108     }