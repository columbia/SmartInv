1 /*
2 
3  t.me/AsukaInu
4  
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 
9 pragma solidity ^0.6.12;
10 
11     abstract contract Context {
12         function _msgSender() internal view virtual returns (address payable) {
13             return msg.sender;
14         }
15 
16         function _msgData() internal view virtual returns (bytes memory) {
17             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18             return msg.data;
19         }
20     }
21 
22     interface IERC20 {
23         /**
24         * @dev Returns the amount of tokens in existence.
25         */
26         function totalSupply() external view returns (uint256);
27 
28         /**
29         * @dev Returns the amount of tokens owned by `account`.
30         */
31         function balanceOf(address account) external view returns (uint256);
32 
33         /**
34         * @dev Moves `amount` tokens from the caller's account to `recipient`.
35         *
36         * Returns a boolean value indicating whether the operation succeeded.
37         *
38         * Emits a {Transfer} event.
39         */
40         function transfer(address recipient, uint256 amount) external returns (bool);
41 
42         /**
43         * @dev Returns the remaining number of tokens that `spender` will be
44         * allowed to spend on behalf of `owner` through {transferFrom}. This is
45         * zero by default.
46         *
47         * This value changes when {approve} or {transferFrom} are called.
48         */
49         function allowance(address owner, address spender) external view returns (uint256);
50 
51         /**
52         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53         *
54         * Returns a boolean value indicating whether the operation succeeded.
55         *
56         * IMPORTANT: Beware that changing an allowance with this method brings the risk
57         * that someone may use both the old and the new allowance by unfortunate
58         * transaction ordering. One possible solution to mitigate this race
59         * condition is to first reduce the spender's allowance to 0 and set the
60         * desired value afterwards:
61         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62         *
63         * Emits an {Approval} event.
64         */
65         function approve(address spender, uint256 amount) external returns (bool);
66 
67         /**
68         * @dev Moves `amount` tokens from `sender` to `recipient` using the
69         * allowance mechanism. `amount` is then deducted from the caller's
70         * allowance.
71         *
72         * Returns a boolean value indicating whether the operation succeeded.
73         *
74         * Emits a {Transfer} event.
75         */
76         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78         /**
79         * @dev Emitted when `value` tokens are moved from one account (`from`) to
80         * another (`to`).
81         *
82         * Note that `value` may be zero.
83         */
84         event Transfer(address indexed from, address indexed to, uint256 value);
85 
86         /**
87         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88         * a call to {approve}. `value` is the new allowance.
89         */
90         event Approval(address indexed owner, address indexed spender, uint256 value);
91     }
92 
93     library SafeMath {
94         /**
95         * @dev Returns the addition of two unsigned integers, reverting on
96         * overflow.
97         *
98         * Counterpart to Solidity's `+` operator.
99         *
100         * Requirements:
101         *
102         * - Addition cannot overflow.
103         */
104         function add(uint256 a, uint256 b) internal pure returns (uint256) {
105             uint256 c = a + b;
106             require(c >= a, "SafeMath: addition overflow");
107 
108             return c;
109         }
110 
111         /**
112         * @dev Returns the subtraction of two unsigned integers, reverting on
113         * overflow (when the result is negative).
114         *
115         * Counterpart to Solidity's `-` operator.
116         *
117         * Requirements:
118         *
119         * - Subtraction cannot overflow.
120         */
121         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122             return sub(a, b, "SafeMath: subtraction overflow");
123         }
124 
125         /**
126         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127         * overflow (when the result is negative).
128         *
129         * Counterpart to Solidity's `-` operator.
130         *
131         * Requirements:
132         *
133         * - Subtraction cannot overflow.
134         */
135         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136             require(b <= a, errorMessage);
137             uint256 c = a - b;
138 
139             return c;
140         }
141 
142         /**
143         * @dev Returns the multiplication of two unsigned integers, reverting on
144         * overflow.
145         *
146         * Counterpart to Solidity's `*` operator.
147         *
148         * Requirements:
149         *
150         * - Multiplication cannot overflow.
151         */
152         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154             // benefit is lost if 'b' is also tested.
155             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156             if (a == 0) {
157                 return 0;
158             }
159 
160             uint256 c = a * b;
161             require(c / a == b, "SafeMath: multiplication overflow");
162 
163             return c;
164         }
165 
166         /**
167         * @dev Returns the integer division of two unsigned integers. Reverts on
168         * division by zero. The result is rounded towards zero.
169         *
170         * Counterpart to Solidity's `/` operator. Note: this function uses a
171         * `revert` opcode (which leaves remaining gas untouched) while Solidity
172         * uses an invalid opcode to revert (consuming all remaining gas).
173         *
174         * Requirements:
175         *
176         * - The divisor cannot be zero.
177         */
178         function div(uint256 a, uint256 b) internal pure returns (uint256) {
179             return div(a, b, "SafeMath: division by zero");
180         }
181 
182         /**
183         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184         * division by zero. The result is rounded towards zero.
185         *
186         * Counterpart to Solidity's `/` operator. Note: this function uses a
187         * `revert` opcode (which leaves remaining gas untouched) while Solidity
188         * uses an invalid opcode to revert (consuming all remaining gas).
189         *
190         * Requirements:
191         *
192         * - The divisor cannot be zero.
193         */
194         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195             require(b > 0, errorMessage);
196             uint256 c = a / b;
197             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199             return c;
200         }
201 
202         /**
203         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204         * Reverts when dividing by zero.
205         *
206         * Counterpart to Solidity's `%` operator. This function uses a `revert`
207         * opcode (which leaves remaining gas untouched) while Solidity uses an
208         * invalid opcode to revert (consuming all remaining gas).
209         *
210         * Requirements:
211         *
212         * - The divisor cannot be zero.
213         */
214         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215             return mod(a, b, "SafeMath: modulo by zero");
216         }
217 
218         /**
219         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220         * Reverts with custom message when dividing by zero.
221         *
222         * Counterpart to Solidity's `%` operator. This function uses a `revert`
223         * opcode (which leaves remaining gas untouched) while Solidity uses an
224         * invalid opcode to revert (consuming all remaining gas).
225         *
226         * Requirements:
227         *
228         * - The divisor cannot be zero.
229         */
230         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231             require(b != 0, errorMessage);
232             return a % b;
233         }
234     }
235 
236     library Address {
237         /**
238         * @dev Returns true if `account` is a contract.
239         *
240         * [IMPORTANT]
241         * ====
242         * It is unsafe to assume that an address for which this function returns
243         * false is an externally-owned account (EOA) and not a contract.
244         *
245         * Among others, `isContract` will return false for the following
246         * types of addresses:
247         *
248         *  - an externally-owned account
249         *  - a contract in construction
250         *  - an address where a contract will be created
251         *  - an address where a contract lived, but was destroyed
252         * ====
253         */
254         function isContract(address account) internal view returns (bool) {
255             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
256             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
257             // for accounts without code, i.e. `keccak256('')`
258             bytes32 codehash;
259             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
260             // solhint-disable-next-line no-inline-assembly
261             assembly { codehash := extcodehash(account) }
262             return (codehash != accountHash && codehash != 0x0);
263         }
264 
265         /**
266         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267         * `recipient`, forwarding all available gas and reverting on errors.
268         *
269         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270         * of certain opcodes, possibly making contracts go over the 2300 gas limit
271         * imposed by `transfer`, making them unable to receive funds via
272         * `transfer`. {sendValue} removes this limitation.
273         *
274         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275         *
276         * IMPORTANT: because control is transferred to `recipient`, care must be
277         * taken to not create reentrancy vulnerabilities. Consider using
278         * {ReentrancyGuard} or the
279         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280         */
281         function sendValue(address payable recipient, uint256 amount) internal {
282             require(address(this).balance >= amount, "Address: insufficient balance");
283 
284             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285             (bool success, ) = recipient.call{ value: amount }("");
286             require(success, "Address: unable to send value, recipient may have reverted");
287         }
288 
289         /**
290         * @dev Performs a Solidity function call using a low level `call`. A
291         * plain`call` is an unsafe replacement for a function call: use this
292         * function instead.
293         *
294         * If `target` reverts with a revert reason, it is bubbled up by this
295         * function (like regular Solidity function calls).
296         *
297         * Returns the raw returned data. To convert to the expected return value,
298         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299         *
300         * Requirements:
301         *
302         * - `target` must be a contract.
303         * - calling `target` with `data` must not revert.
304         *
305         * _Available since v3.1._
306         */
307         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309         }
310 
311         /**
312         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313         * `errorMessage` as a fallback revert reason when `target` reverts.
314         *
315         * _Available since v3.1._
316         */
317         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
318             return _functionCallWithValue(target, data, 0, errorMessage);
319         }
320 
321         /**
322         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323         * but also transferring `value` wei to `target`.
324         *
325         * Requirements:
326         *
327         * - the calling contract must have an ETH balance of at least `value`.
328         * - the called Solidity function must be `payable`.
329         *
330         * _Available since v3.1._
331         */
332         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
333             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334         }
335 
336         /**
337         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338         * with `errorMessage` as a fallback revert reason when `target` reverts.
339         *
340         * _Available since v3.1._
341         */
342         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
343             require(address(this).balance >= value, "Address: insufficient balance for call");
344             return _functionCallWithValue(target, data, value, errorMessage);
345         }
346 
347         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
348             require(isContract(target), "Address: call to non-contract");
349 
350             // solhint-disable-next-line avoid-low-level-calls
351             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
352             if (success) {
353                 return returndata;
354             } else {
355                 // Look for revert reason and bubble it up if present
356                 if (returndata.length > 0) {
357                     // The easiest way to bubble the revert reason is using memory via assembly
358 
359                     // solhint-disable-next-line no-inline-assembly
360                     assembly {
361                         let returndata_size := mload(returndata)
362                         revert(add(32, returndata), returndata_size)
363                     }
364                 } else {
365                     revert(errorMessage);
366                 }
367             }
368         }
369     }
370 
371     contract Ownable is Context {
372         address private _owner;
373         address private _previousOwner;
374         uint256 private _lockTime;
375 
376         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377 
378         /**
379         * @dev Initializes the contract setting the deployer as the initial owner.
380         */
381         constructor () internal {
382             address msgSender = _msgSender();
383             _owner = msgSender;
384             emit OwnershipTransferred(address(0), msgSender);
385         }
386 
387         /**
388         * @dev Returns the address of the current owner.
389         */
390         function owner() public view returns (address) {
391             return _owner;
392         }
393 
394         /**
395         * @dev Throws if called by any account other than the owner.
396         */
397         modifier onlyOwner() {
398             require(_owner == _msgSender(), "Ownable: caller is not the owner");
399             _;
400         }
401 
402         /**
403         * @dev Leaves the contract without owner. It will not be possible to call
404         * `onlyOwner` functions anymore. Can only be called by the current owner.
405         *
406         * NOTE: Renouncing ownership will leave the contract without an owner,
407         * thereby removing any functionality that is only available to the owner.
408         */
409         function renounceOwnership() public virtual onlyOwner {
410             emit OwnershipTransferred(_owner, address(0));
411             _owner = address(0);
412         }
413 
414         /**
415         * @dev Transfers ownership of the contract to a new account (`newOwner`).
416         * Can only be called by the current owner.
417         */
418         function transferOwnership(address newOwner) public virtual onlyOwner {
419             require(newOwner != address(0), "Ownable: new owner is the zero address");
420             emit OwnershipTransferred(_owner, newOwner);
421             _owner = newOwner;
422         }
423 
424         function getUnlockTime() public view returns (uint256) {
425             return _lockTime;
426         }
427 
428     }
429 
430     interface IUniswapV2Factory {
431         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
432 
433         function feeTo() external view returns (address);
434         function feeToSetter() external view returns (address);
435 
436         function getPair(address tokenA, address tokenB) external view returns (address pair);
437         function allPairs(uint) external view returns (address pair);
438         function allPairsLength() external view returns (uint);
439 
440         function createPair(address tokenA, address tokenB) external returns (address pair);
441 
442         function setFeeTo(address) external;
443         function setFeeToSetter(address) external;
444     }
445 
446     interface IUniswapV2Pair {
447         event Approval(address indexed owner, address indexed spender, uint value);
448         event Transfer(address indexed from, address indexed to, uint value);
449 
450         function name() external pure returns (string memory);
451         function symbol() external pure returns (string memory);
452         function decimals() external pure returns (uint8);
453         function totalSupply() external view returns (uint);
454         function balanceOf(address owner) external view returns (uint);
455         function allowance(address owner, address spender) external view returns (uint);
456 
457         function approve(address spender, uint value) external returns (bool);
458         function transfer(address to, uint value) external returns (bool);
459         function transferFrom(address from, address to, uint value) external returns (bool);
460 
461         function DOMAIN_SEPARATOR() external view returns (bytes32);
462         function PERMIT_TYPEHASH() external pure returns (bytes32);
463         function nonces(address owner) external view returns (uint);
464 
465         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
466 
467         event Mint(address indexed sender, uint amount0, uint amount1);
468         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
469         event Swap(
470             address indexed sender,
471             uint amount0In,
472             uint amount1In,
473             uint amount0Out,
474             uint amount1Out,
475             address indexed to
476         );
477         event Sync(uint112 reserve0, uint112 reserve1);
478 
479         function MINIMUM_LIQUIDITY() external pure returns (uint);
480         function factory() external view returns (address);
481         function token0() external view returns (address);
482         function token1() external view returns (address);
483         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
484         function price0CumulativeLast() external view returns (uint);
485         function price1CumulativeLast() external view returns (uint);
486         function kLast() external view returns (uint);
487 
488         function mint(address to) external returns (uint liquidity);
489         function burn(address to) external returns (uint amount0, uint amount1);
490         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
491         function skim(address to) external;
492         function sync() external;
493 
494         function initialize(address, address) external;
495     }
496 
497     interface IUniswapV2Router01 {
498         function factory() external pure returns (address);
499         function WETH() external pure returns (address);
500 
501         function addLiquidity(
502             address tokenA,
503             address tokenB,
504             uint amountADesired,
505             uint amountBDesired,
506             uint amountAMin,
507             uint amountBMin,
508             address to,
509             uint deadline
510         ) external returns (uint amountA, uint amountB, uint liquidity);
511         function addLiquidityETH(
512             address token,
513             uint amountTokenDesired,
514             uint amountTokenMin,
515             uint amountETHMin,
516             address to,
517             uint deadline
518         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
519         function removeLiquidity(
520             address tokenA,
521             address tokenB,
522             uint liquidity,
523             uint amountAMin,
524             uint amountBMin,
525             address to,
526             uint deadline
527         ) external returns (uint amountA, uint amountB);
528         function removeLiquidityETH(
529             address token,
530             uint liquidity,
531             uint amountTokenMin,
532             uint amountETHMin,
533             address to,
534             uint deadline
535         ) external returns (uint amountToken, uint amountETH);
536         function removeLiquidityWithPermit(
537             address tokenA,
538             address tokenB,
539             uint liquidity,
540             uint amountAMin,
541             uint amountBMin,
542             address to,
543             uint deadline,
544             bool approveMax, uint8 v, bytes32 r, bytes32 s
545         ) external returns (uint amountA, uint amountB);
546         function removeLiquidityETHWithPermit(
547             address token,
548             uint liquidity,
549             uint amountTokenMin,
550             uint amountETHMin,
551             address to,
552             uint deadline,
553             bool approveMax, uint8 v, bytes32 r, bytes32 s
554         ) external returns (uint amountToken, uint amountETH);
555         function swapExactTokensForTokens(
556             uint amountIn,
557             uint amountOutMin,
558             address[] calldata path,
559             address to,
560             uint deadline
561         ) external returns (uint[] memory amounts);
562         function swapTokensForExactTokens(
563             uint amountOut,
564             uint amountInMax,
565             address[] calldata path,
566             address to,
567             uint deadline
568         ) external returns (uint[] memory amounts);
569         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
570             external
571             payable
572             returns (uint[] memory amounts);
573         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
574             external
575             returns (uint[] memory amounts);
576         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
577             external
578             returns (uint[] memory amounts);
579         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
580             external
581             payable
582             returns (uint[] memory amounts);
583 
584         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
585         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
586         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
587         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
588         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
589     }
590 
591     interface IUniswapV2Router02 is IUniswapV2Router01 {
592         function removeLiquidityETHSupportingFeeOnTransferTokens(
593             address token,
594             uint liquidity,
595             uint amountTokenMin,
596             uint amountETHMin,
597             address to,
598             uint deadline
599         ) external returns (uint amountETH);
600         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
601             address token,
602             uint liquidity,
603             uint amountTokenMin,
604             uint amountETHMin,
605             address to,
606             uint deadline,
607             bool approveMax, uint8 v, bytes32 r, bytes32 s
608         ) external returns (uint amountETH);
609 
610         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
611             uint amountIn,
612             uint amountOutMin,
613             address[] calldata path,
614             address to,
615             uint deadline
616         ) external;
617         function swapExactETHForTokensSupportingFeeOnTransferTokens(
618             uint amountOutMin,
619             address[] calldata path,
620             address to,
621             uint deadline
622         ) external payable;
623         function swapExactTokensForETHSupportingFeeOnTransferTokens(
624             uint amountIn,
625             uint amountOutMin,
626             address[] calldata path,
627             address to,
628             uint deadline
629         ) external;
630     }
631 
632     contract Asuka is Context, IERC20, Ownable {
633         using SafeMath for uint256;
634         using Address for address;
635 
636         mapping (address => uint256) private _rOwned;
637         mapping (address => uint256) private _tOwned;
638         mapping (address => mapping (address => uint256)) private _allowances;
639 
640         mapping (address => bool) private _isExcludedFromFee;
641 
642         mapping (address => bool) private _isExcluded;
643         address[] private _excluded;
644         mapping (address => bool) private _isBlackListedBot;
645         address[] private _blackListedBots;
646 
647         uint256 private constant MAX = ~uint256(0);
648         uint256 private constant _tTotal = 1000000000 * 10**18;
649         uint256 private _rTotal = (MAX - (MAX % _tTotal));
650         uint256 private _tFeeTotal;
651 
652         string private constant _name = 'Asuka Inu ';
653         string private constant _symbol = 'ASUKA';
654         uint8 private constant _decimals = 18;
655 
656         uint256 private _taxFee = 1;
657         uint256 private _teamFee = 10;
658         uint256 private _previousTaxFee = _taxFee;
659         uint256 private _previousTeamFee = _teamFee;
660 
661         address payable public _devWalletAddress;
662         address payable public _marketingWalletAddress;
663 
664 
665         IUniswapV2Router02 public immutable uniswapV2Router;
666         address public immutable uniswapV2Pair;
667 
668         bool inSwap = false;
669         bool public swapEnabled = true;
670 
671         uint256 private _maxTxAmount = 20000000 * 10**18;
672         uint256 private constant _numOfTokensToExchangeForTeam = 7000 * 10**18;
673         uint256 private _maxWalletSize = 20000000 * 10**18;
674 
675         event botAddedToBlacklist(address account);
676         event botRemovedFromBlacklist(address account);
677 
678         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
679         // event SwapEnabledUpdated(bool enabled);
680 
681         modifier lockTheSwap {
682             inSwap = true;
683             _;
684             inSwap = false;
685         }
686 
687         constructor (address payable devWalletAddress, address payable marketingWalletAddress) public {
688             _devWalletAddress = devWalletAddress;
689             _marketingWalletAddress = marketingWalletAddress;
690 
691             _rOwned[_msgSender()] = _rTotal;
692 
693             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
694             // Create a uniswap pair for this new token
695             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
696                 .createPair(address(this), _uniswapV2Router.WETH());
697 
698             // set the rest of the contract variables
699             uniswapV2Router = _uniswapV2Router;
700 
701             // Exclude owner and this contract from fee
702             _isExcludedFromFee[owner()] = true;
703             _isExcludedFromFee[address(this)] = true;
704 
705             emit Transfer(address(0), _msgSender(), _tTotal);
706         }
707 
708         function name() public pure returns (string memory) {
709             return _name;
710         }
711 
712         function symbol() public pure returns (string memory) {
713             return _symbol;
714         }
715 
716         function decimals() public pure returns (uint8) {
717             return _decimals;
718         }
719 
720         function totalSupply() public view override returns (uint256) {
721             return _tTotal;
722         }
723 
724         function balanceOf(address account) public view override returns (uint256) {
725             if (_isExcluded[account]) return _tOwned[account];
726             return tokenFromReflection(_rOwned[account]);
727         }
728 
729         function transfer(address recipient, uint256 amount) public override returns (bool) {
730             _transfer(_msgSender(), recipient, amount);
731             return true;
732         }
733 
734         function allowance(address owner, address spender) public view override returns (uint256) {
735             return _allowances[owner][spender];
736         }
737 
738         function approve(address spender, uint256 amount) public override returns (bool) {
739             _approve(_msgSender(), spender, amount);
740             return true;
741         }
742 
743         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
744             _transfer(sender, recipient, amount);
745             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
746             return true;
747         }
748 
749         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
750             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
751             return true;
752         }
753 
754         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
755             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
756             return true;
757         }
758 
759         function isExcluded(address account) public view returns (bool) {
760             return _isExcluded[account];
761         }
762 
763         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
764             _isExcludedFromFee[account] = excluded;
765         }
766 
767         function totalFees() public view returns (uint256) {
768             return _tFeeTotal;
769         }
770 
771         function deliver(uint256 tAmount) public {
772             address sender = _msgSender();
773             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
774             (uint256 rAmount,,,,,) = _getValues(tAmount);
775             _rOwned[sender] = _rOwned[sender].sub(rAmount);
776             _rTotal = _rTotal.sub(rAmount);
777             _tFeeTotal = _tFeeTotal.add(tAmount);
778         }
779 
780         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
781             require(tAmount <= _tTotal, "Amount must be less than supply");
782             if (!deductTransferFee) {
783                 (uint256 rAmount,,,,,) = _getValues(tAmount);
784                 return rAmount;
785             } else {
786                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
787                 return rTransferAmount;
788             }
789         }
790 
791         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
792             require(rAmount <= _rTotal, "Amount must be less than total reflections");
793             uint256 currentRate =  _getRate();
794             return rAmount.div(currentRate);
795         }
796 
797         function addBotToBlacklist (address account) external onlyOwner() {
798            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
799            require (!_isBlackListedBot[account], 'Account is already blacklisted');
800            _isBlackListedBot[account] = true;
801            _blackListedBots.push(account);
802         }
803 
804         function removeBotFromBlacklist(address account) external onlyOwner() {
805           require (_isBlackListedBot[account], 'Account is not blacklisted');
806           for (uint256 i = 0; i < _blackListedBots.length; i++) {
807                  if (_blackListedBots[i] == account) {
808                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
809                      _isBlackListedBot[account] = false;
810                      _blackListedBots.pop();
811                      break;
812                  }
813            }
814        }
815 
816         function excludeAccount(address account) external onlyOwner() {
817             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
818             require(!_isExcluded[account], "Account is already excluded");
819             if(_rOwned[account] > 0) {
820                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
821             }
822             _isExcluded[account] = true;
823             _excluded.push(account);
824         }
825 
826         function includeAccount(address account) external onlyOwner() {
827             require(_isExcluded[account], "Account is not excluded");
828             for (uint256 i = 0; i < _excluded.length; i++) {
829                 if (_excluded[i] == account) {
830                     _excluded[i] = _excluded[_excluded.length - 1];
831                     _tOwned[account] = 0;
832                     _isExcluded[account] = false;
833                     _excluded.pop();
834                     break;
835                 }
836             }
837         }
838 
839         function removeAllFee() private {
840             if(_taxFee == 0 && _teamFee == 0) return;
841 
842             _previousTaxFee = _taxFee;
843             _previousTeamFee = _teamFee;
844 
845             _taxFee = 0;
846             _teamFee = 0;
847         }
848 
849         function restoreAllFee() private {
850             _taxFee = _previousTaxFee;
851             _teamFee = _previousTeamFee;
852         }
853 
854         function isExcludedFromFee(address account) public view returns(bool) {
855             return _isExcludedFromFee[account];
856         }
857 
858         function _approve(address owner, address spender, uint256 amount) private {
859             require(owner != address(0), "ERC20: approve from the zero address");
860             require(spender != address(0), "ERC20: approve to the zero address");
861 
862             _allowances[owner][spender] = amount;
863             emit Approval(owner, spender, amount);
864         }
865 
866         function _transfer(address sender, address recipient, uint256 amount) private {
867             require(sender != address(0), "ERC20: transfer from the zero address");
868             require(recipient != address(0), "ERC20: transfer to the zero address");
869             require(amount > 0, "Transfer amount must be greater than zero");
870             require(!_isBlackListedBot[sender], "You are blacklisted");
871             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
872             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
873             if(sender != owner() && recipient != owner()) {
874                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
875             }
876             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
877                 uint256 tokenBalanceRecipient = balanceOf(recipient);
878                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
879             }
880             // is the token balance of this contract address over the min number of
881             // tokens that we need to initiate a swap?
882             // also, don't get caught in a circular team event.
883             // also, don't swap if sender is uniswap pair.
884             uint256 contractTokenBalance = balanceOf(address(this));
885 
886             if(contractTokenBalance >= _maxTxAmount)
887             {
888                 contractTokenBalance = _maxTxAmount;
889             }
890 
891             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
892             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
893                 // Swap tokens for ETH and send to resepctive wallets
894                 swapTokensForEth(contractTokenBalance);
895 
896                 uint256 contractETHBalance = address(this).balance;
897                 if(contractETHBalance > 0) {
898                     sendETHToTeam(address(this).balance);
899                 }
900             }
901 
902             //indicates if fee should be deducted from transfer
903             bool takeFee = true;
904 
905             //if any account belongs to _isExcludedFromFee account then remove the fee
906             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
907                 takeFee = false;
908             }
909 
910             //transfer amount, it will take tax and team fee
911             _tokenTransfer(sender,recipient,amount,takeFee);
912         }
913 
914         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
915             // generate the uniswap pair path of token -> weth
916             address[] memory path = new address[](2);
917             path[0] = address(this);
918             path[1] = uniswapV2Router.WETH();
919 
920             _approve(address(this), address(uniswapV2Router), tokenAmount);
921 
922             // make the swap
923             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
924                 tokenAmount,
925                 0, // accept any amount of ETH
926                 path,
927                 address(this),
928                 block.timestamp
929             );
930         }
931 
932         function sendETHToTeam(uint256 amount) private {
933             _devWalletAddress.transfer(amount.div(5));
934             _marketingWalletAddress.transfer(amount.div(10).mul(8));
935         }
936 
937         function manualSwap() external onlyOwner() {
938             uint256 contractBalance = balanceOf(address(this));
939             swapTokensForEth(contractBalance);
940         }
941 
942         function manualSend() external onlyOwner() {
943             uint256 contractETHBalance = address(this).balance;
944             sendETHToTeam(contractETHBalance);
945         }
946 
947         function setSwapEnabled(bool enabled) external onlyOwner(){
948             swapEnabled = enabled;
949         }
950 
951         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
952             if(!takeFee)
953                 removeAllFee();
954 
955             if (_isExcluded[sender] && !_isExcluded[recipient]) {
956                 _transferFromExcluded(sender, recipient, amount);
957             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
958                 _transferToExcluded(sender, recipient, amount);
959             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
960                 _transferStandard(sender, recipient, amount);
961             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
962                 _transferBothExcluded(sender, recipient, amount);
963             } else {
964                 _transferStandard(sender, recipient, amount);
965             }
966 
967             if(!takeFee)
968                 restoreAllFee();
969         }
970 
971         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
972             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
973             _rOwned[sender] = _rOwned[sender].sub(rAmount);
974             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
975             _takeTeam(tTeam);
976             _reflectFee(rFee, tFee);
977             emit Transfer(sender, recipient, tTransferAmount);
978         }
979 
980         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
981             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
982             _rOwned[sender] = _rOwned[sender].sub(rAmount);
983             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
984             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
985             _takeTeam(tTeam);
986             _reflectFee(rFee, tFee);
987             emit Transfer(sender, recipient, tTransferAmount);
988         }
989 
990         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
991             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
992             _tOwned[sender] = _tOwned[sender].sub(tAmount);
993             _rOwned[sender] = _rOwned[sender].sub(rAmount);
994             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
995             _takeTeam(tTeam);
996             _reflectFee(rFee, tFee);
997             emit Transfer(sender, recipient, tTransferAmount);
998         }
999 
1000         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1001             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1002             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1003             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1004             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1005             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1006             _takeTeam(tTeam);
1007             _reflectFee(rFee, tFee);
1008             emit Transfer(sender, recipient, tTransferAmount);
1009         }
1010 
1011         function _takeTeam(uint256 tTeam) private {
1012             uint256 currentRate =  _getRate();
1013             uint256 rTeam = tTeam.mul(currentRate);
1014             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1015             if(_isExcluded[address(this)])
1016                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1017         }
1018 
1019         function _reflectFee(uint256 rFee, uint256 tFee) private {
1020             _rTotal = _rTotal.sub(rFee);
1021             _tFeeTotal = _tFeeTotal.add(tFee);
1022         }
1023 
1024          //to recieve ETH from uniswapV2Router when swaping
1025         receive() external payable {}
1026 
1027         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1028         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1029         uint256 currentRate = _getRate();
1030         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1031         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1032     }
1033 
1034         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1035             uint256 tFee = tAmount.mul(taxFee).div(100);
1036             uint256 tTeam = tAmount.mul(teamFee).div(100);
1037             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1038             return (tTransferAmount, tFee, tTeam);
1039         }
1040 
1041         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1042             uint256 rAmount = tAmount.mul(currentRate);
1043             uint256 rFee = tFee.mul(currentRate);
1044             uint256 rTeam = tTeam.mul(currentRate);
1045             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1046             return (rAmount, rTransferAmount, rFee);
1047         }
1048 
1049         function _getRate() private view returns(uint256) {
1050             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1051             return rSupply.div(tSupply);
1052         }
1053 
1054         function _getCurrentSupply() private view returns(uint256, uint256) {
1055             uint256 rSupply = _rTotal;
1056             uint256 tSupply = _tTotal;
1057             for (uint256 i = 0; i < _excluded.length; i++) {
1058                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1059                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1060                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1061             }
1062             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1063             return (rSupply, tSupply);
1064         }
1065 
1066         function _getTaxFee() public view returns(uint256) {
1067             return _taxFee;
1068         }
1069 
1070         function _getTeamFee() public view returns (uint256) {
1071           return _teamFee;
1072         }
1073 
1074         function _getMaxTxAmount() public view returns(uint256) {
1075             return _maxTxAmount;
1076         }
1077 
1078         function _getETHBalance() public view returns(uint256 balance) {
1079             return address(this).balance;
1080         }
1081 
1082         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1083             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1084             _taxFee = taxFee;
1085         }
1086 
1087         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1088             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1089             _teamFee = teamFee;
1090         }
1091 
1092         function _setDevWallet(address payable devWalletAddress) external onlyOwner() {
1093             _devWalletAddress = devWalletAddress;
1094         }
1095 
1096         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1097             _marketingWalletAddress = marketingWalletAddress;
1098         }
1099 
1100         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1101             _maxTxAmount = maxTxAmount;
1102         }
1103 
1104         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1105           _maxWalletSize = maxWalletSize;
1106         }
1107     }