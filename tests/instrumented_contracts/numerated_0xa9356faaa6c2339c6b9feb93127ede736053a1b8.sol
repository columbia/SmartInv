1 /*
2 Telegram: https://t.me/jeffinspaceofficial
3 Website: jeffin.space
4 */
5 pragma solidity ^0.6.12;
6 // SPDX-License-Identifier: Unlicensed
7 
8     abstract contract Context {
9         function _msgSender() internal view virtual returns (address payable) {
10             return msg.sender;
11         }
12 
13         function _msgData() internal view virtual returns (bytes memory) {
14             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15             return msg.data;
16         }
17     }
18 
19     interface IERC20 {
20         /**
21         * @dev Returns the amount of tokens in existence.
22         */
23         function totalSupply() external view returns (uint256);
24 
25         /**
26         * @dev Returns the amount of tokens owned by `account`.
27         */
28         function balanceOf(address account) external view returns (uint256);
29 
30         /**
31         * @dev Moves `amount` tokens from the caller's account to `recipient`.
32         *
33         * Returns a boolean value indicating whether the operation succeeded.
34         *
35         * Emits a {Transfer} event.
36         */
37         function transfer(address recipient, uint256 amount) external returns (bool);
38 
39         /**
40         * @dev Returns the remaining number of tokens that `spender` will be
41         * allowed to spend on behalf of `owner` through {transferFrom}. This is
42         * zero by default.
43         *
44         * This value changes when {approve} or {transferFrom} are called.
45         */
46         function allowance(address owner, address spender) external view returns (uint256);
47 
48         /**
49         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50         *
51         * Returns a boolean value indicating whether the operation succeeded.
52         *
53         * IMPORTANT: Beware that changing an allowance with this method brings the risk
54         * that someone may use both the old and the new allowance by unfortunate
55         * transaction ordering. One possible solution to mitigate this race
56         * condition is to first reduce the spender's allowance to 0 and set the
57         * desired value afterwards:
58         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59         *
60         * Emits an {Approval} event.
61         */
62         function approve(address spender, uint256 amount) external returns (bool);
63 
64         /**
65         * @dev Moves `amount` tokens from `sender` to `recipient` using the
66         * allowance mechanism. `amount` is then deducted from the caller's
67         * allowance.
68         *
69         * Returns a boolean value indicating whether the operation succeeded.
70         *
71         * Emits a {Transfer} event.
72         */
73         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75         /**
76         * @dev Emitted when `value` tokens are moved from one account (`from`) to
77         * another (`to`).
78         *
79         * Note that `value` may be zero.
80         */
81         event Transfer(address indexed from, address indexed to, uint256 value);
82 
83         /**
84         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85         * a call to {approve}. `value` is the new allowance.
86         */
87         event Approval(address indexed owner, address indexed spender, uint256 value);
88     }
89 
90     library SafeMath {
91         /**
92         * @dev Returns the addition of two unsigned integers, reverting on
93         * overflow.
94         *
95         * Counterpart to Solidity's `+` operator.
96         *
97         * Requirements:
98         *
99         * - Addition cannot overflow.
100         */
101         function add(uint256 a, uint256 b) internal pure returns (uint256) {
102             uint256 c = a + b;
103             require(c >= a, "SafeMath: addition overflow");
104 
105             return c;
106         }
107 
108         /**
109         * @dev Returns the subtraction of two unsigned integers, reverting on
110         * overflow (when the result is negative).
111         *
112         * Counterpart to Solidity's `-` operator.
113         *
114         * Requirements:
115         *
116         * - Subtraction cannot overflow.
117         */
118         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119             return sub(a, b, "SafeMath: subtraction overflow");
120         }
121 
122         /**
123         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124         * overflow (when the result is negative).
125         *
126         * Counterpart to Solidity's `-` operator.
127         *
128         * Requirements:
129         *
130         * - Subtraction cannot overflow.
131         */
132         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133             require(b <= a, errorMessage);
134             uint256 c = a - b;
135 
136             return c;
137         }
138 
139         /**
140         * @dev Returns the multiplication of two unsigned integers, reverting on
141         * overflow.
142         *
143         * Counterpart to Solidity's `*` operator.
144         *
145         * Requirements:
146         *
147         * - Multiplication cannot overflow.
148         */
149         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151             // benefit is lost if 'b' is also tested.
152             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153             if (a == 0) {
154                 return 0;
155             }
156 
157             uint256 c = a * b;
158             require(c / a == b, "SafeMath: multiplication overflow");
159 
160             return c;
161         }
162 
163         /**
164         * @dev Returns the integer division of two unsigned integers. Reverts on
165         * division by zero. The result is rounded towards zero.
166         *
167         * Counterpart to Solidity's `/` operator. Note: this function uses a
168         * `revert` opcode (which leaves remaining gas untouched) while Solidity
169         * uses an invalid opcode to revert (consuming all remaining gas).
170         *
171         * Requirements:
172         *
173         * - The divisor cannot be zero.
174         */
175         function div(uint256 a, uint256 b) internal pure returns (uint256) {
176             return div(a, b, "SafeMath: division by zero");
177         }
178 
179         /**
180         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181         * division by zero. The result is rounded towards zero.
182         *
183         * Counterpart to Solidity's `/` operator. Note: this function uses a
184         * `revert` opcode (which leaves remaining gas untouched) while Solidity
185         * uses an invalid opcode to revert (consuming all remaining gas).
186         *
187         * Requirements:
188         *
189         * - The divisor cannot be zero.
190         */
191         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192             require(b > 0, errorMessage);
193             uint256 c = a / b;
194             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196             return c;
197         }
198 
199         /**
200         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201         * Reverts when dividing by zero.
202         *
203         * Counterpart to Solidity's `%` operator. This function uses a `revert`
204         * opcode (which leaves remaining gas untouched) while Solidity uses an
205         * invalid opcode to revert (consuming all remaining gas).
206         *
207         * Requirements:
208         *
209         * - The divisor cannot be zero.
210         */
211         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212             return mod(a, b, "SafeMath: modulo by zero");
213         }
214 
215         /**
216         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217         * Reverts with custom message when dividing by zero.
218         *
219         * Counterpart to Solidity's `%` operator. This function uses a `revert`
220         * opcode (which leaves remaining gas untouched) while Solidity uses an
221         * invalid opcode to revert (consuming all remaining gas).
222         *
223         * Requirements:
224         *
225         * - The divisor cannot be zero.
226         */
227         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228             require(b != 0, errorMessage);
229             return a % b;
230         }
231     }
232 
233     library Address {
234         /**
235         * @dev Returns true if `account` is a contract.
236         *
237         * [IMPORTANT]
238         * ====
239         * It is unsafe to assume that an address for which this function returns
240         * false is an externally-owned account (EOA) and not a contract.
241         *
242         * Among others, `isContract` will return false for the following
243         * types of addresses:
244         *
245         *  - an externally-owned account
246         *  - a contract in construction
247         *  - an address where a contract will be created
248         *  - an address where a contract lived, but was destroyed
249         * ====
250         */
251         function isContract(address account) internal view returns (bool) {
252             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
253             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
254             // for accounts without code, i.e. `keccak256('')`
255             bytes32 codehash;
256             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
257             // solhint-disable-next-line no-inline-assembly
258             assembly { codehash := extcodehash(account) }
259             return (codehash != accountHash && codehash != 0x0);
260         }
261 
262         /**
263         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264         * `recipient`, forwarding all available gas and reverting on errors.
265         *
266         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267         * of certain opcodes, possibly making contracts go over the 2300 gas limit
268         * imposed by `transfer`, making them unable to receive funds via
269         * `transfer`. {sendValue} removes this limitation.
270         *
271         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272         *
273         * IMPORTANT: because control is transferred to `recipient`, care must be
274         * taken to not create reentrancy vulnerabilities. Consider using
275         * {ReentrancyGuard} or the
276         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277         */
278         function sendValue(address payable recipient, uint256 amount) internal {
279             require(address(this).balance >= amount, "Address: insufficient balance");
280 
281             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
282             (bool success, ) = recipient.call{ value: amount }("");
283             require(success, "Address: unable to send value, recipient may have reverted");
284         }
285 
286         /**
287         * @dev Performs a Solidity function call using a low level `call`. A
288         * plain`call` is an unsafe replacement for a function call: use this
289         * function instead.
290         *
291         * If `target` reverts with a revert reason, it is bubbled up by this
292         * function (like regular Solidity function calls).
293         *
294         * Returns the raw returned data. To convert to the expected return value,
295         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296         *
297         * Requirements:
298         *
299         * - `target` must be a contract.
300         * - calling `target` with `data` must not revert.
301         *
302         * _Available since v3.1._
303         */
304         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306         }
307 
308         /**
309         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310         * `errorMessage` as a fallback revert reason when `target` reverts.
311         *
312         * _Available since v3.1._
313         */
314         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
315             return _functionCallWithValue(target, data, 0, errorMessage);
316         }
317 
318         /**
319         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320         * but also transferring `value` wei to `target`.
321         *
322         * Requirements:
323         *
324         * - the calling contract must have an ETH balance of at least `value`.
325         * - the called Solidity function must be `payable`.
326         *
327         * _Available since v3.1._
328         */
329         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
330             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331         }
332 
333         /**
334         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335         * with `errorMessage` as a fallback revert reason when `target` reverts.
336         *
337         * _Available since v3.1._
338         */
339         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
340             require(address(this).balance >= value, "Address: insufficient balance for call");
341             return _functionCallWithValue(target, data, value, errorMessage);
342         }
343 
344         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
345             require(isContract(target), "Address: call to non-contract");
346 
347             // solhint-disable-next-line avoid-low-level-calls
348             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
349             if (success) {
350                 return returndata;
351             } else {
352                 // Look for revert reason and bubble it up if present
353                 if (returndata.length > 0) {
354                     // The easiest way to bubble the revert reason is using memory via assembly
355 
356                     // solhint-disable-next-line no-inline-assembly
357                     assembly {
358                         let returndata_size := mload(returndata)
359                         revert(add(32, returndata), returndata_size)
360                     }
361                 } else {
362                     revert(errorMessage);
363                 }
364             }
365         }
366     }
367 
368     contract Ownable is Context {
369         address private _owner;
370         address private _previousOwner;
371         uint256 private _lockTime;
372 
373         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375         /**
376         * @dev Initializes the contract setting the deployer as the initial owner.
377         */
378         constructor () internal {
379             address msgSender = _msgSender();
380             _owner = msgSender;
381             emit OwnershipTransferred(address(0), msgSender);
382         }
383 
384         /**
385         * @dev Returns the address of the current owner.
386         */
387         function owner() public view returns (address) {
388             return _owner;
389         }
390 
391         /**
392         * @dev Throws if called by any account other than the owner.
393         */
394         modifier onlyOwner() {
395             require(_owner == _msgSender(), "Ownable: caller is not the owner");
396             _;
397         }
398 
399         /**
400         * @dev Leaves the contract without owner. It will not be possible to call
401         * `onlyOwner` functions anymore. Can only be called by the current owner.
402         *
403         * NOTE: Renouncing ownership will leave the contract without an owner,
404         * thereby removing any functionality that is only available to the owner.
405         */
406         function renounceOwnership() public virtual onlyOwner {
407             emit OwnershipTransferred(_owner, address(0));
408             _owner = address(0);
409         }
410 
411         /**
412         * @dev Transfers ownership of the contract to a new account (`newOwner`).
413         * Can only be called by the current owner.
414         */
415         function transferOwnership(address newOwner) public virtual onlyOwner {
416             require(newOwner != address(0), "Ownable: new owner is the zero address");
417             emit OwnershipTransferred(_owner, newOwner);
418             _owner = newOwner;
419         }
420 
421         function geUnlockTime() public view returns (uint256) {
422             return _lockTime;
423         }
424 
425     }  
426 
427     interface IUniswapV2Factory {
428         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
429 
430         function feeTo() external view returns (address);
431         function feeToSetter() external view returns (address);
432 
433         function getPair(address tokenA, address tokenB) external view returns (address pair);
434         function allPairs(uint) external view returns (address pair);
435         function allPairsLength() external view returns (uint);
436 
437         function createPair(address tokenA, address tokenB) external returns (address pair);
438 
439         function setFeeTo(address) external;
440         function setFeeToSetter(address) external;
441     } 
442 
443     interface IUniswapV2Pair {
444         event Approval(address indexed owner, address indexed spender, uint value);
445         event Transfer(address indexed from, address indexed to, uint value);
446 
447         function name() external pure returns (string memory);
448         function symbol() external pure returns (string memory);
449         function decimals() external pure returns (uint8);
450         function totalSupply() external view returns (uint);
451         function balanceOf(address owner) external view returns (uint);
452         function allowance(address owner, address spender) external view returns (uint);
453 
454         function approve(address spender, uint value) external returns (bool);
455         function transfer(address to, uint value) external returns (bool);
456         function transferFrom(address from, address to, uint value) external returns (bool);
457 
458         function DOMAIN_SEPARATOR() external view returns (bytes32);
459         function PERMIT_TYPEHASH() external pure returns (bytes32);
460         function nonces(address owner) external view returns (uint);
461 
462         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
463 
464         event Mint(address indexed sender, uint amount0, uint amount1);
465         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
466         event Swap(
467             address indexed sender,
468             uint amount0In,
469             uint amount1In,
470             uint amount0Out,
471             uint amount1Out,
472             address indexed to
473         );
474         event Sync(uint112 reserve0, uint112 reserve1);
475 
476         function MINIMUM_LIQUIDITY() external pure returns (uint);
477         function factory() external view returns (address);
478         function token0() external view returns (address);
479         function token1() external view returns (address);
480         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
481         function price0CumulativeLast() external view returns (uint);
482         function price1CumulativeLast() external view returns (uint);
483         function kLast() external view returns (uint);
484 
485         function mint(address to) external returns (uint liquidity);
486         function burn(address to) external returns (uint amount0, uint amount1);
487         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
488         function skim(address to) external;
489         function sync() external;
490 
491         function initialize(address, address) external;
492     }
493 
494     interface IUniswapV2Router01 {
495         function factory() external pure returns (address);
496         function WETH() external pure returns (address);
497 
498         function addLiquidity(
499             address tokenA,
500             address tokenB,
501             uint amountADesired,
502             uint amountBDesired,
503             uint amountAMin,
504             uint amountBMin,
505             address to,
506             uint deadline
507         ) external returns (uint amountA, uint amountB, uint liquidity);
508         function addLiquidityETH(
509             address token,
510             uint amountTokenDesired,
511             uint amountTokenMin,
512             uint amountETHMin,
513             address to,
514             uint deadline
515         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
516         function removeLiquidity(
517             address tokenA,
518             address tokenB,
519             uint liquidity,
520             uint amountAMin,
521             uint amountBMin,
522             address to,
523             uint deadline
524         ) external returns (uint amountA, uint amountB);
525         function removeLiquidityETH(
526             address token,
527             uint liquidity,
528             uint amountTokenMin,
529             uint amountETHMin,
530             address to,
531             uint deadline
532         ) external returns (uint amountToken, uint amountETH);
533         function removeLiquidityWithPermit(
534             address tokenA,
535             address tokenB,
536             uint liquidity,
537             uint amountAMin,
538             uint amountBMin,
539             address to,
540             uint deadline,
541             bool approveMax, uint8 v, bytes32 r, bytes32 s
542         ) external returns (uint amountA, uint amountB);
543         function removeLiquidityETHWithPermit(
544             address token,
545             uint liquidity,
546             uint amountTokenMin,
547             uint amountETHMin,
548             address to,
549             uint deadline,
550             bool approveMax, uint8 v, bytes32 r, bytes32 s
551         ) external returns (uint amountToken, uint amountETH);
552         function swapExactTokensForTokens(
553             uint amountIn,
554             uint amountOutMin,
555             address[] calldata path,
556             address to,
557             uint deadline
558         ) external returns (uint[] memory amounts);
559         function swapTokensForExactTokens(
560             uint amountOut,
561             uint amountInMax,
562             address[] calldata path,
563             address to,
564             uint deadline
565         ) external returns (uint[] memory amounts);
566         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
567             external
568             payable
569             returns (uint[] memory amounts);
570         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
571             external
572             returns (uint[] memory amounts);
573         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
574             external
575             returns (uint[] memory amounts);
576         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
577             external
578             payable
579             returns (uint[] memory amounts);
580 
581         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
582         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
583         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
584         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
585         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
586     }
587 
588     interface IUniswapV2Router02 is IUniswapV2Router01 {
589         function removeLiquidityETHSupportingFeeOnTransferTokens(
590             address token,
591             uint liquidity,
592             uint amountTokenMin,
593             uint amountETHMin,
594             address to,
595             uint deadline
596         ) external returns (uint amountETH);
597         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
598             address token,
599             uint liquidity,
600             uint amountTokenMin,
601             uint amountETHMin,
602             address to,
603             uint deadline,
604             bool approveMax, uint8 v, bytes32 r, bytes32 s
605         ) external returns (uint amountETH);
606 
607         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
608             uint amountIn,
609             uint amountOutMin,
610             address[] calldata path,
611             address to,
612             uint deadline
613         ) external;
614         function swapExactETHForTokensSupportingFeeOnTransferTokens(
615             uint amountOutMin,
616             address[] calldata path,
617             address to,
618             uint deadline
619         ) external payable;
620         function swapExactTokensForETHSupportingFeeOnTransferTokens(
621             uint amountIn,
622             uint amountOutMin,
623             address[] calldata path,
624             address to,
625             uint deadline
626         ) external;
627     }
628 
629     // Contract implementation
630     contract JeffInSpace is Context, IERC20, Ownable {
631         using SafeMath for uint256;
632         using Address for address;
633 
634         mapping (address => uint256) private _rOwned;
635         mapping (address => uint256) private _tOwned;
636         mapping (address => mapping (address => uint256)) private _allowances;
637         mapping (address => uint256) public timestamp;
638 
639         mapping (address => bool) private _isExcludedFromFee;
640     
641         mapping (address => bool) private _isExcluded;
642         address[] private _excluded;
643         mapping (address => bool) private _isBlackListedBot;
644         address[] private _blackListedBots;
645     
646         uint256 private constant MAX = ~uint256(0);
647         uint256 private _tTotal = 1441441441440 * 10**9;
648         uint256 private _rTotal = (MAX - (MAX % _tTotal));
649         uint256 private _tFeeTotal;
650         uint256 private _CoolDown = 45 seconds;
651 
652         string private _name = 'JEFF IN SPACE';
653         string private _symbol = 'JEFF';
654         uint8 private _decimals = 9;
655          
656         uint256 private _taxFee = 0;
657         uint256 private _teamFee = 0;
658         uint256 private _previousTaxFee = _taxFee;
659         uint256 private _previousteamFee = _teamFee;
660 
661         address payable private _teamWalletAddress;
662         address payable private _marketingWalletAddress;
663         
664         IUniswapV2Router02 public immutable uniswapV2Router;
665         address public immutable uniswapV2Pair;
666 
667         bool inSwap = false;
668         bool private swapEnabled = true;
669         bool private tradingEnabled = false;
670         bool private cooldownEnabled = true;
671 
672         uint256 public _maxTxAmount = 7207207207 * 10**9; 
673         //no max tx limit at deploy
674         uint256 private _numOfTokensToExchangeForteam = 500000000000000;
675 
676         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
677         event SwapEnabledUpdated(bool enabled);
678 
679         modifier lockTheSwap {
680             inSwap = true;
681             _;
682             inSwap = false;
683         }
684 
685         constructor (address payable teamWalletAddress, address payable marketingWalletAddress) public {
686             _teamWalletAddress = teamWalletAddress;
687             _marketingWalletAddress = marketingWalletAddress;
688             _rOwned[_msgSender()] = _rTotal;
689 
690             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
691             // Create a uniswap pair for this new token
692             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
693                 .createPair(address(this), _uniswapV2Router.WETH());
694 
695             // set the rest of the contract variables
696             uniswapV2Router = _uniswapV2Router;
697 
698             // Exclude owner and this contract from fee
699             _isExcludedFromFee[owner()] = true;
700             _isExcludedFromFee[address(this)] = true;
701             
702             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
703             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
704             
705             _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
706             _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
707             
708             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
709             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
710             
711             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
712             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
713     
714             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
715             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
716     
717             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
718             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
719     
720             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
721             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
722     
723             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
724             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
725     
726             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
727             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
728     
729             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
730             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
731     
732             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
733             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
734             
735             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
736             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
737             
738             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
739             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
740             
741             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
742             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
743             
744             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
745             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
746 
747             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
748             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
749             
750             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
751             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
752             
753             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
754             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
755             
756             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
757             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
758             
759             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
760             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
761             
762             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
763             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
764             
765             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
766             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
767             
768             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
769             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
770             
771             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
772             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
773             
774             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
775             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
776             
777             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
778             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
779             
780             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
781             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
782 
783             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
784             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
785             
786             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
787             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
788             
789             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
790             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
791 
792             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
793             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
794 
795             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
796             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
797 
798             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
799             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
800             
801             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
802             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
803             
804             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
805             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
806             
807             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
808             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
809             
810             
811             emit Transfer(address(0), _msgSender(), _tTotal);
812         }
813 
814         function name() public view returns (string memory) {
815             return _name;
816         }
817 
818         function symbol() public view returns (string memory) {
819             return _symbol;
820         }
821 
822         function decimals() public view returns (uint8) {
823             return _decimals;
824         }
825 
826         function totalSupply() public view override returns (uint256) {
827             return _tTotal;
828         }
829 
830         function balanceOf(address account) public view override returns (uint256) {
831             if (_isExcluded[account]) return _tOwned[account];
832             return tokenFromReflection(_rOwned[account]);
833         }
834 
835         function transfer(address recipient, uint256 amount) public override returns (bool) {
836             _transfer(_msgSender(), recipient, amount);
837             return true;
838         }
839 
840         function allowance(address owner, address spender) public view override returns (uint256) {
841             return _allowances[owner][spender];
842         }
843 
844         function approve(address spender, uint256 amount) public override returns (bool) {
845             _approve(_msgSender(), spender, amount);
846             return true;
847         }
848 
849         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
850             _transfer(sender, recipient, amount);
851             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
852             return true;
853         }
854 
855         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
856             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
857             return true;
858         }
859 
860         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
861             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
862             return true;
863         }
864 
865         function isExcluded(address account) public view returns (bool) {
866             return _isExcluded[account];
867         }
868         
869         function isBlackListed(address account) public view returns (bool) {
870             return _isBlackListedBot[account];
871         }
872 
873         function totalFees() public view returns (uint256) {
874             return _tFeeTotal;
875         }
876 
877         function deliver(uint256 tAmount) public {
878             address sender = _msgSender();
879             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
880             (uint256 rAmount,,,,,) = _getValues(tAmount);
881             _rOwned[sender] = _rOwned[sender].sub(rAmount);
882             _rTotal = _rTotal.sub(rAmount);
883             _tFeeTotal = _tFeeTotal.add(tAmount);
884         }
885 
886         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
887             require(tAmount <= _tTotal, "Amount must be less than supply");
888             if (!deductTransferFee) {
889                 (uint256 rAmount,,,,,) = _getValues(tAmount);
890                 return rAmount;
891             } else {
892                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
893                 return rTransferAmount;
894             }
895         }
896 
897         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
898             require(rAmount <= _rTotal, "Amount must be less than total reflections");
899             uint256 currentRate =  _getRate();
900             return rAmount.div(currentRate);
901         }
902 
903         function addBotToBlackList(address account) external onlyOwner() {
904             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
905             require(!_isBlackListedBot[account], "Account is already blacklisted");
906             _isBlackListedBot[account] = true;
907             _blackListedBots.push(account);
908         }
909     
910         function removeBotFromBlackList(address account) external onlyOwner() {
911             require(_isBlackListedBot[account], "Account is not blacklisted");
912             for (uint256 i = 0; i < _blackListedBots.length; i++) {
913                 if (_blackListedBots[i] == account) {
914                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
915                     _isBlackListedBot[account] = false;
916                     _blackListedBots.pop();
917                     break;
918                 }
919             }
920         }
921 
922         function removeAllFee() private {
923             if(_taxFee == 0 && _teamFee == 0) return;
924             
925             _previousTaxFee = _taxFee;
926             _previousteamFee = _teamFee;
927             
928             _taxFee = 0;
929             _teamFee = 0;
930         }
931     
932         function restoreAllFee() private {
933             _taxFee = _previousTaxFee;
934             _teamFee = _previousteamFee;
935         }
936     
937         function isExcludedFromFee(address account) public view returns(bool) {
938             return _isExcludedFromFee[account];
939         }
940         
941         function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
942             _maxTxAmount = _tTotal.mul(maxTxPercent).div(
943             10**2
944         );
945         }
946 
947         function _approve(address owner, address spender, uint256 amount) private {
948             require(owner != address(0), "ERC20: approve from the zero address");
949             require(spender != address(0), "ERC20: approve to the zero address");
950 
951             _allowances[owner][spender] = amount;
952             emit Approval(owner, spender, amount);
953         }
954 
955         function _transfer(address sender, address recipient, uint256 amount) private {
956             require(sender != address(0), "ERC20: transfer from the zero address");
957             require(recipient != address(0), "ERC20: transfer to the zero address");
958             require(amount > 0, "Transfer amount must be greater than zero");
959             require(!_isBlackListedBot[recipient], "You have no power here!");
960             require(!_isBlackListedBot[sender], "You have no power here!");
961 
962             if(sender != owner() && recipient != owner()) {
963                     
964                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
965                 
966                     //you can't trade this on a dex until trading enabled
967                     if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled yet");}
968               
969             }
970             
971             
972              //cooldown logic starts
973              
974              if(cooldownEnabled) {
975               
976               //perform all cooldown checks below only if enabled
977               
978                       if (sender == uniswapV2Pair ) {
979                         
980                         //they just bought add cooldown    
981                         if (!_isExcluded[recipient]) { timestamp[recipient] = block.timestamp.add(_CoolDown); }
982 
983                       }
984                       
985 
986                       // exclude owner and uniswap
987                       if(sender != owner() && sender != uniswapV2Pair) {
988 
989                         // dont apply cooldown to other excluded addresses
990                         if (!_isExcluded[sender]) { require(block.timestamp >= timestamp[sender], "Cooldown"); }
991 
992                       }
993               
994              }
995 
996             // is the token balance of this contract address over the min number of
997             // tokens that we need to initiate a swap?
998             // also, don't get caught in a circular team event.
999             // also, don't swap if sender is uniswap pair.
1000             uint256 contractTokenBalance = balanceOf(address(this));
1001             
1002             if(contractTokenBalance >= _maxTxAmount)
1003             {
1004                 contractTokenBalance = _maxTxAmount;
1005             }
1006             
1007             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForteam;
1008             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1009                 // We need to swap the current tokens to ETH and send to the team wallet
1010                 swapTokensForEth(contractTokenBalance);
1011                 
1012                 uint256 contractETHBalance = address(this).balance;
1013                 if(contractETHBalance > 0) {
1014                     sendETHToteam(address(this).balance);
1015                 }
1016             }
1017             
1018             //indicates if fee should be deducted from transfer
1019             bool takeFee = true;
1020             
1021             //if any account belongs to _isExcludedFromFee account then remove the fee
1022             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1023                 takeFee = false;
1024             }
1025             
1026             //transfer amount, it will take tax and team fee
1027             _tokenTransfer(sender,recipient,amount,takeFee);
1028         }
1029 
1030         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1031             // generate the uniswap pair path of token -> weth
1032             address[] memory path = new address[](2);
1033             path[0] = address(this);
1034             path[1] = uniswapV2Router.WETH();
1035 
1036             _approve(address(this), address(uniswapV2Router), tokenAmount);
1037 
1038             // make the swap
1039             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1040                 tokenAmount,
1041                 0, // accept any amount of ETH
1042                 path,
1043                 address(this),
1044                 block.timestamp
1045             );
1046         }
1047         
1048         function sendETHToteam(uint256 amount) private {
1049             _teamWalletAddress.transfer(amount.div(2));
1050             _marketingWalletAddress.transfer(amount.div(2));
1051         }
1052         
1053         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1054             if(!takeFee)
1055                 removeAllFee();
1056 
1057             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1058                 _transferFromExcluded(sender, recipient, amount);
1059             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1060                 _transferToExcluded(sender, recipient, amount);
1061             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1062                 _transferStandard(sender, recipient, amount);
1063             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1064                 _transferBothExcluded(sender, recipient, amount);
1065             } else {
1066                 _transferStandard(sender, recipient, amount);
1067             }
1068 
1069             if(!takeFee)
1070                 restoreAllFee();
1071         }
1072 
1073         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1074             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1075             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1076             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1077             _taketeam(tteam); 
1078             _reflectFee(rFee, tFee);
1079             emit Transfer(sender, recipient, tTransferAmount);
1080         }
1081 
1082         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1083             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1084             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1085             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1086             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1087             _taketeam(tteam);           
1088             _reflectFee(rFee, tFee);
1089             emit Transfer(sender, recipient, tTransferAmount);
1090         }
1091 
1092         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1093             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1094             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1095             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1096             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1097             _taketeam(tteam);   
1098             _reflectFee(rFee, tFee);
1099             emit Transfer(sender, recipient, tTransferAmount);
1100         }
1101 
1102         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1103             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1104             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1105             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1106             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1107             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1108             _taketeam(tteam);         
1109             _reflectFee(rFee, tFee);
1110             emit Transfer(sender, recipient, tTransferAmount);
1111         }
1112 
1113         function _taketeam(uint256 tteam) private {
1114             uint256 currentRate =  _getRate();
1115             uint256 rteam = tteam.mul(currentRate);
1116             _rOwned[address(this)] = _rOwned[address(this)].add(rteam);
1117             if(_isExcluded[address(this)])
1118                 _tOwned[address(this)] = _tOwned[address(this)].add(tteam);
1119         }
1120 
1121         function _reflectFee(uint256 rFee, uint256 tFee) private {
1122             _rTotal = _rTotal.sub(rFee);
1123             _tFeeTotal = _tFeeTotal.add(tFee);
1124         }
1125 
1126          //to recieve ETH from uniswapV2Router when swaping
1127         receive() external payable {}
1128 
1129         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1130             (uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getTValues(tAmount, _taxFee, _teamFee);
1131             uint256 currentRate =  _getRate();
1132             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1133             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tteam);
1134         }
1135 
1136         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1137             uint256 tFee = tAmount.mul(taxFee).div(100);
1138             uint256 tteam = tAmount.mul(teamFee).div(100);
1139             uint256 tTransferAmount = tAmount.sub(tFee).sub(tteam);
1140             return (tTransferAmount, tFee, tteam);
1141         }
1142 
1143         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1144             uint256 rAmount = tAmount.mul(currentRate);
1145             uint256 rFee = tFee.mul(currentRate);
1146             uint256 rTransferAmount = rAmount.sub(rFee);
1147             return (rAmount, rTransferAmount, rFee);
1148         }
1149 
1150         function _getRate() private view returns(uint256) {
1151             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1152             return rSupply.div(tSupply);
1153         }
1154 
1155         function _getCurrentSupply() private view returns(uint256, uint256) {
1156             uint256 rSupply = _rTotal;
1157             uint256 tSupply = _tTotal;      
1158             for (uint256 i = 0; i < _excluded.length; i++) {
1159                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1160                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1161                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1162             }
1163             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1164             return (rSupply, tSupply);
1165         }
1166         
1167         function _getTaxFee() private view returns(uint256) {
1168             return _taxFee;
1169         }
1170 
1171         function _getMaxTxAmount() private view returns(uint256) {
1172             return _maxTxAmount;
1173         }
1174 
1175         function _getETHBalance() public view returns(uint256 balance) {
1176             return address(this).balance;
1177         }
1178         
1179         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1180             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1181             _taxFee = taxFee;
1182         }
1183 
1184         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1185             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1186             _teamFee = teamFee;
1187         }
1188         
1189          function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
1190              tradingEnabled = _tradingEnabled;
1191          }
1192          
1193          function ToggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
1194              cooldownEnabled = _cooldownEnabled;
1195          }
1196         
1197     }