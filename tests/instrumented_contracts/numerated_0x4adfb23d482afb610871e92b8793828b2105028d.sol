1 /*
2 
3   _____ _  __     __
4  |_   _| | \ \   / /
5    | | | |  \ \_/ / 
6    | | | |   \   /  
7   _| |_| |____| |   
8  |_____|______|_|   
9                     
10  Website
11  https://i-love-you.io/
12  
13  
14 */
15 
16 // SPDX-License-Identifier: Unlicensed
17 
18 pragma solidity ^0.6.12;
19 
20     abstract contract Context {
21         function _msgSender() internal view virtual returns (address payable) {
22             return msg.sender;
23         }
24 
25         function _msgData() internal view virtual returns (bytes memory) {
26             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27             return msg.data;
28         }
29     }
30 
31     interface IERC20 {
32         /**
33         * @dev Returns the amount of tokens in existence.
34         */
35         function totalSupply() external view returns (uint256);
36 
37         /**
38         * @dev Returns the amount of tokens owned by `account`.
39         */
40         function balanceOf(address account) external view returns (uint256);
41 
42         /**
43         * @dev Moves `amount` tokens from the caller's account to `recipient`.
44         *
45         * Returns a boolean value indicating whether the operation succeeded.
46         *
47         * Emits a {Transfer} event.
48         */
49         function transfer(address recipient, uint256 amount) external returns (bool);
50 
51         /**
52         * @dev Returns the remaining number of tokens that `spender` will be
53         * allowed to spend on behalf of `owner` through {transferFrom}. This is
54         * zero by default.
55         *
56         * This value changes when {approve} or {transferFrom} are called.
57         */
58         function allowance(address owner, address spender) external view returns (uint256);
59 
60         /**
61         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62         *
63         * Returns a boolean value indicating whether the operation succeeded.
64         *
65         * IMPORTANT: Beware that changing an allowance with this method brings the risk
66         * that someone may use both the old and the new allowance by unfortunate
67         * transaction ordering. One possible solution to mitigate this race
68         * condition is to first reduce the spender's allowance to 0 and set the
69         * desired value afterwards:
70         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71         *
72         * Emits an {Approval} event.
73         */
74         function approve(address spender, uint256 amount) external returns (bool);
75 
76         /**
77         * @dev Moves `amount` tokens from `sender` to `recipient` using the
78         * allowance mechanism. `amount` is then deducted from the caller's
79         * allowance.
80         *
81         * Returns a boolean value indicating whether the operation succeeded.
82         *
83         * Emits a {Transfer} event.
84         */
85         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87         /**
88         * @dev Emitted when `value` tokens are moved from one account (`from`) to
89         * another (`to`).
90         *
91         * Note that `value` may be zero.
92         */
93         event Transfer(address indexed from, address indexed to, uint256 value);
94 
95         /**
96         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97         * a call to {approve}. `value` is the new allowance.
98         */
99         event Approval(address indexed owner, address indexed spender, uint256 value);
100     }
101 
102     library SafeMath {
103         /**
104         * @dev Returns the addition of two unsigned integers, reverting on
105         * overflow.
106         *
107         * Counterpart to Solidity's `+` operator.
108         *
109         * Requirements:
110         *
111         * - Addition cannot overflow.
112         */
113         function add(uint256 a, uint256 b) internal pure returns (uint256) {
114             uint256 c = a + b;
115             require(c >= a, "SafeMath: addition overflow");
116 
117             return c;
118         }
119 
120         /**
121         * @dev Returns the subtraction of two unsigned integers, reverting on
122         * overflow (when the result is negative).
123         *
124         * Counterpart to Solidity's `-` operator.
125         *
126         * Requirements:
127         *
128         * - Subtraction cannot overflow.
129         */
130         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131             return sub(a, b, "SafeMath: subtraction overflow");
132         }
133 
134         /**
135         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
136         * overflow (when the result is negative).
137         *
138         * Counterpart to Solidity's `-` operator.
139         *
140         * Requirements:
141         *
142         * - Subtraction cannot overflow.
143         */
144         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
145             require(b <= a, errorMessage);
146             uint256 c = a - b;
147 
148             return c;
149         }
150 
151         /**
152         * @dev Returns the multiplication of two unsigned integers, reverting on
153         * overflow.
154         *
155         * Counterpart to Solidity's `*` operator.
156         *
157         * Requirements:
158         *
159         * - Multiplication cannot overflow.
160         */
161         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
162             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163             // benefit is lost if 'b' is also tested.
164             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165             if (a == 0) {
166                 return 0;
167             }
168 
169             uint256 c = a * b;
170             require(c / a == b, "SafeMath: multiplication overflow");
171 
172             return c;
173         }
174 
175         /**
176         * @dev Returns the integer division of two unsigned integers. Reverts on
177         * division by zero. The result is rounded towards zero.
178         *
179         * Counterpart to Solidity's `/` operator. Note: this function uses a
180         * `revert` opcode (which leaves remaining gas untouched) while Solidity
181         * uses an invalid opcode to revert (consuming all remaining gas).
182         *
183         * Requirements:
184         *
185         * - The divisor cannot be zero.
186         */
187         function div(uint256 a, uint256 b) internal pure returns (uint256) {
188             return div(a, b, "SafeMath: division by zero");
189         }
190 
191         /**
192         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
193         * division by zero. The result is rounded towards zero.
194         *
195         * Counterpart to Solidity's `/` operator. Note: this function uses a
196         * `revert` opcode (which leaves remaining gas untouched) while Solidity
197         * uses an invalid opcode to revert (consuming all remaining gas).
198         *
199         * Requirements:
200         *
201         * - The divisor cannot be zero.
202         */
203         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
204             require(b > 0, errorMessage);
205             uint256 c = a / b;
206             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
207 
208             return c;
209         }
210 
211         /**
212         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213         * Reverts when dividing by zero.
214         *
215         * Counterpart to Solidity's `%` operator. This function uses a `revert`
216         * opcode (which leaves remaining gas untouched) while Solidity uses an
217         * invalid opcode to revert (consuming all remaining gas).
218         *
219         * Requirements:
220         *
221         * - The divisor cannot be zero.
222         */
223         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
224             return mod(a, b, "SafeMath: modulo by zero");
225         }
226 
227         /**
228         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229         * Reverts with custom message when dividing by zero.
230         *
231         * Counterpart to Solidity's `%` operator. This function uses a `revert`
232         * opcode (which leaves remaining gas untouched) while Solidity uses an
233         * invalid opcode to revert (consuming all remaining gas).
234         *
235         * Requirements:
236         *
237         * - The divisor cannot be zero.
238         */
239         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240             require(b != 0, errorMessage);
241             return a % b;
242         }
243     }
244 
245     library Address {
246         /**
247         * @dev Returns true if `account` is a contract.
248         *
249         * [IMPORTANT]
250         * ====
251         * It is unsafe to assume that an address for which this function returns
252         * false is an externally-owned account (EOA) and not a contract.
253         *
254         * Among others, `isContract` will return false for the following
255         * types of addresses:
256         *
257         *  - an externally-owned account
258         *  - a contract in construction
259         *  - an address where a contract will be created
260         *  - an address where a contract lived, but was destroyed
261         * ====
262         */
263         function isContract(address account) internal view returns (bool) {
264             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
265             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
266             // for accounts without code, i.e. `keccak256('')`
267             bytes32 codehash;
268             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269             // solhint-disable-next-line no-inline-assembly
270             assembly { codehash := extcodehash(account) }
271             return (codehash != accountHash && codehash != 0x0);
272         }
273 
274         /**
275         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276         * `recipient`, forwarding all available gas and reverting on errors.
277         *
278         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279         * of certain opcodes, possibly making contracts go over the 2300 gas limit
280         * imposed by `transfer`, making them unable to receive funds via
281         * `transfer`. {sendValue} removes this limitation.
282         *
283         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284         *
285         * IMPORTANT: because control is transferred to `recipient`, care must be
286         * taken to not create reentrancy vulnerabilities. Consider using
287         * {ReentrancyGuard} or the
288         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289         */
290         function sendValue(address payable recipient, uint256 amount) internal {
291             require(address(this).balance >= amount, "Address: insufficient balance");
292 
293             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294             (bool success, ) = recipient.call{ value: amount }("");
295             require(success, "Address: unable to send value, recipient may have reverted");
296         }
297 
298         /**
299         * @dev Performs a Solidity function call using a low level `call`. A
300         * plain`call` is an unsafe replacement for a function call: use this
301         * function instead.
302         *
303         * If `target` reverts with a revert reason, it is bubbled up by this
304         * function (like regular Solidity function calls).
305         *
306         * Returns the raw returned data. To convert to the expected return value,
307         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
308         *
309         * Requirements:
310         *
311         * - `target` must be a contract.
312         * - calling `target` with `data` must not revert.
313         *
314         * _Available since v3.1._
315         */
316         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
317         return functionCall(target, data, "Address: low-level call failed");
318         }
319 
320         /**
321         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
322         * `errorMessage` as a fallback revert reason when `target` reverts.
323         *
324         * _Available since v3.1._
325         */
326         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
327             return _functionCallWithValue(target, data, 0, errorMessage);
328         }
329 
330         /**
331         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332         * but also transferring `value` wei to `target`.
333         *
334         * Requirements:
335         *
336         * - the calling contract must have an ETH balance of at least `value`.
337         * - the called Solidity function must be `payable`.
338         *
339         * _Available since v3.1._
340         */
341         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
342             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343         }
344 
345         /**
346         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347         * with `errorMessage` as a fallback revert reason when `target` reverts.
348         *
349         * _Available since v3.1._
350         */
351         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
352             require(address(this).balance >= value, "Address: insufficient balance for call");
353             return _functionCallWithValue(target, data, value, errorMessage);
354         }
355 
356         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
357             require(isContract(target), "Address: call to non-contract");
358 
359             // solhint-disable-next-line avoid-low-level-calls
360             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
361             if (success) {
362                 return returndata;
363             } else {
364                 // Look for revert reason and bubble it up if present
365                 if (returndata.length > 0) {
366                     // The easiest way to bubble the revert reason is using memory via assembly
367 
368                     // solhint-disable-next-line no-inline-assembly
369                     assembly {
370                         let returndata_size := mload(returndata)
371                         revert(add(32, returndata), returndata_size)
372                     }
373                 } else {
374                     revert(errorMessage);
375                 }
376             }
377         }
378     }
379 
380     contract Ownable is Context {
381         address private _owner;
382         address private _previousOwner;
383         uint256 private _lockTime;
384 
385         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387         /**
388         * @dev Initializes the contract setting the deployer as the initial owner.
389         */
390         constructor () internal {
391             address msgSender = _msgSender();
392             _owner = msgSender;
393             emit OwnershipTransferred(address(0), msgSender);
394         }
395 
396         /**
397         * @dev Returns the address of the current owner.
398         */
399         function owner() public view returns (address) {
400             return _owner;
401         }
402 
403         /**
404         * @dev Throws if called by any account other than the owner.
405         */
406         modifier onlyOwner() {
407             require(_owner == _msgSender(), "Ownable: caller is not the owner");
408             _;
409         }
410 
411         /**
412         * @dev Leaves the contract without owner. It will not be possible to call
413         * `onlyOwner` functions anymore. Can only be called by the current owner.
414         *
415         * NOTE: Renouncing ownership will leave the contract without an owner,
416         * thereby removing any functionality that is only available to the owner.
417         */
418         function renounceOwnership() public virtual onlyOwner {
419             emit OwnershipTransferred(_owner, address(0));
420             _owner = address(0);
421         }
422 
423         /**
424         * @dev Transfers ownership of the contract to a new account (`newOwner`).
425         * Can only be called by the current owner.
426         */
427         function transferOwnership(address newOwner) public virtual onlyOwner {
428             require(newOwner != address(0), "Ownable: new owner is the zero address");
429             emit OwnershipTransferred(_owner, newOwner);
430             _owner = newOwner;
431         }
432 
433         function getUnlockTime() public view returns (uint256) {
434             return _lockTime;
435         }
436 
437     }
438 
439     interface IUniswapV2Factory {
440         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
441 
442         function feeTo() external view returns (address);
443         function feeToSetter() external view returns (address);
444 
445         function getPair(address tokenA, address tokenB) external view returns (address pair);
446         function allPairs(uint) external view returns (address pair);
447         function allPairsLength() external view returns (uint);
448 
449         function createPair(address tokenA, address tokenB) external returns (address pair);
450 
451         function setFeeTo(address) external;
452         function setFeeToSetter(address) external;
453     }
454 
455     interface IUniswapV2Pair {
456         event Approval(address indexed owner, address indexed spender, uint value);
457         event Transfer(address indexed from, address indexed to, uint value);
458 
459         function name() external pure returns (string memory);
460         function symbol() external pure returns (string memory);
461         function decimals() external pure returns (uint8);
462         function totalSupply() external view returns (uint);
463         function balanceOf(address owner) external view returns (uint);
464         function allowance(address owner, address spender) external view returns (uint);
465 
466         function approve(address spender, uint value) external returns (bool);
467         function transfer(address to, uint value) external returns (bool);
468         function transferFrom(address from, address to, uint value) external returns (bool);
469 
470         function DOMAIN_SEPARATOR() external view returns (bytes32);
471         function PERMIT_TYPEHASH() external pure returns (bytes32);
472         function nonces(address owner) external view returns (uint);
473 
474         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
475 
476         event Mint(address indexed sender, uint amount0, uint amount1);
477         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
478         event Swap(
479             address indexed sender,
480             uint amount0In,
481             uint amount1In,
482             uint amount0Out,
483             uint amount1Out,
484             address indexed to
485         );
486         event Sync(uint112 reserve0, uint112 reserve1);
487 
488         function MINIMUM_LIQUIDITY() external pure returns (uint);
489         function factory() external view returns (address);
490         function token0() external view returns (address);
491         function token1() external view returns (address);
492         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
493         function price0CumulativeLast() external view returns (uint);
494         function price1CumulativeLast() external view returns (uint);
495         function kLast() external view returns (uint);
496 
497         function mint(address to) external returns (uint liquidity);
498         function burn(address to) external returns (uint amount0, uint amount1);
499         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
500         function skim(address to) external;
501         function sync() external;
502 
503         function initialize(address, address) external;
504     }
505 
506     interface IUniswapV2Router01 {
507         function factory() external pure returns (address);
508         function WETH() external pure returns (address);
509 
510         function addLiquidity(
511             address tokenA,
512             address tokenB,
513             uint amountADesired,
514             uint amountBDesired,
515             uint amountAMin,
516             uint amountBMin,
517             address to,
518             uint deadline
519         ) external returns (uint amountA, uint amountB, uint liquidity);
520         function addLiquidityETH(
521             address token,
522             uint amountTokenDesired,
523             uint amountTokenMin,
524             uint amountETHMin,
525             address to,
526             uint deadline
527         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
528         function removeLiquidity(
529             address tokenA,
530             address tokenB,
531             uint liquidity,
532             uint amountAMin,
533             uint amountBMin,
534             address to,
535             uint deadline
536         ) external returns (uint amountA, uint amountB);
537         function removeLiquidityETH(
538             address token,
539             uint liquidity,
540             uint amountTokenMin,
541             uint amountETHMin,
542             address to,
543             uint deadline
544         ) external returns (uint amountToken, uint amountETH);
545         function removeLiquidityWithPermit(
546             address tokenA,
547             address tokenB,
548             uint liquidity,
549             uint amountAMin,
550             uint amountBMin,
551             address to,
552             uint deadline,
553             bool approveMax, uint8 v, bytes32 r, bytes32 s
554         ) external returns (uint amountA, uint amountB);
555         function removeLiquidityETHWithPermit(
556             address token,
557             uint liquidity,
558             uint amountTokenMin,
559             uint amountETHMin,
560             address to,
561             uint deadline,
562             bool approveMax, uint8 v, bytes32 r, bytes32 s
563         ) external returns (uint amountToken, uint amountETH);
564         function swapExactTokensForTokens(
565             uint amountIn,
566             uint amountOutMin,
567             address[] calldata path,
568             address to,
569             uint deadline
570         ) external returns (uint[] memory amounts);
571         function swapTokensForExactTokens(
572             uint amountOut,
573             uint amountInMax,
574             address[] calldata path,
575             address to,
576             uint deadline
577         ) external returns (uint[] memory amounts);
578         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
579             external
580             payable
581             returns (uint[] memory amounts);
582         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
583             external
584             returns (uint[] memory amounts);
585         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
586             external
587             returns (uint[] memory amounts);
588         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
589             external
590             payable
591             returns (uint[] memory amounts);
592 
593         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
594         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
595         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
596         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
597         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
598     }
599 
600     interface IUniswapV2Router02 is IUniswapV2Router01 {
601         function removeLiquidityETHSupportingFeeOnTransferTokens(
602             address token,
603             uint liquidity,
604             uint amountTokenMin,
605             uint amountETHMin,
606             address to,
607             uint deadline
608         ) external returns (uint amountETH);
609         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
610             address token,
611             uint liquidity,
612             uint amountTokenMin,
613             uint amountETHMin,
614             address to,
615             uint deadline,
616             bool approveMax, uint8 v, bytes32 r, bytes32 s
617         ) external returns (uint amountETH);
618 
619         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
620             uint amountIn,
621             uint amountOutMin,
622             address[] calldata path,
623             address to,
624             uint deadline
625         ) external;
626         function swapExactETHForTokensSupportingFeeOnTransferTokens(
627             uint amountOutMin,
628             address[] calldata path,
629             address to,
630             uint deadline
631         ) external payable;
632         function swapExactTokensForETHSupportingFeeOnTransferTokens(
633             uint amountIn,
634             uint amountOutMin,
635             address[] calldata path,
636             address to,
637             uint deadline
638         ) external;
639     }
640 
641     contract ILY is Context, IERC20, Ownable {
642         using SafeMath for uint256;
643         using Address for address;
644 
645         mapping (address => uint256) private _rOwned;
646         mapping (address => uint256) private _tOwned;
647         mapping (address => mapping (address => uint256)) private _allowances;
648 
649         mapping (address => bool) private _isExcludedFromFee;
650 
651         mapping (address => bool) private _isExcluded;
652         address[] private _excluded;
653         mapping (address => bool) private _isBlackListedBot;
654         address[] private _blackListedBots;
655 
656         uint256 private constant MAX = ~uint256(0);
657         uint256 private constant _tTotal = 1000000000 * 10**18;
658         uint256 private _rTotal = (MAX - (MAX % _tTotal));
659         uint256 private _tFeeTotal;
660 
661         string private constant _name = 'I Love You';
662         string private constant _symbol = 'ILY';
663         uint8 private constant _decimals = 18;
664 
665         uint256 private _taxFee = 1;
666         uint256 private _teamFee = 10;
667         uint256 private _previousTaxFee = _taxFee;
668         uint256 private _previousTeamFee = _teamFee;
669 
670         address payable public _devWalletAddress;
671         address payable public _marketingWalletAddress;
672 
673 
674         IUniswapV2Router02 public immutable uniswapV2Router;
675         address public immutable uniswapV2Pair;
676 
677         bool inSwap = false;
678         bool public swapEnabled = true;
679 
680         uint256 private _maxTxAmount = 20000000 * 10**18;
681         uint256 private constant _numOfTokensToExchangeForTeam = 7000 * 10**18;
682         uint256 private _maxWalletSize = 20000000 * 10**18;
683 
684         event botAddedToBlacklist(address account);
685         event botRemovedFromBlacklist(address account);
686 
687         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
688         // event SwapEnabledUpdated(bool enabled);
689 
690         modifier lockTheSwap {
691             inSwap = true;
692             _;
693             inSwap = false;
694         }
695 
696         constructor (address payable devWalletAddress, address payable marketingWalletAddress) public {
697             _devWalletAddress = devWalletAddress;
698             _marketingWalletAddress = marketingWalletAddress;
699 
700             _rOwned[_msgSender()] = _rTotal;
701 
702             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
703             // Create a uniswap pair for this new token
704             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
705                 .createPair(address(this), _uniswapV2Router.WETH());
706 
707             // set the rest of the contract variables
708             uniswapV2Router = _uniswapV2Router;
709 
710             // Exclude owner and this contract from fee
711             _isExcludedFromFee[owner()] = true;
712             _isExcludedFromFee[address(this)] = true;
713 
714             emit Transfer(address(0), _msgSender(), _tTotal);
715         }
716 
717         function name() public pure returns (string memory) {
718             return _name;
719         }
720 
721         function symbol() public pure returns (string memory) {
722             return _symbol;
723         }
724 
725         function decimals() public pure returns (uint8) {
726             return _decimals;
727         }
728 
729         function totalSupply() public view override returns (uint256) {
730             return _tTotal;
731         }
732 
733         function balanceOf(address account) public view override returns (uint256) {
734             if (_isExcluded[account]) return _tOwned[account];
735             return tokenFromReflection(_rOwned[account]);
736         }
737 
738         function transfer(address recipient, uint256 amount) public override returns (bool) {
739             _transfer(_msgSender(), recipient, amount);
740             return true;
741         }
742 
743         function allowance(address owner, address spender) public view override returns (uint256) {
744             return _allowances[owner][spender];
745         }
746 
747         function approve(address spender, uint256 amount) public override returns (bool) {
748             _approve(_msgSender(), spender, amount);
749             return true;
750         }
751 
752         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
753             _transfer(sender, recipient, amount);
754             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
755             return true;
756         }
757 
758         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
759             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
760             return true;
761         }
762 
763         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
764             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
765             return true;
766         }
767 
768         function isExcluded(address account) public view returns (bool) {
769             return _isExcluded[account];
770         }
771 
772         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
773             _isExcludedFromFee[account] = excluded;
774         }
775 
776         function totalFees() public view returns (uint256) {
777             return _tFeeTotal;
778         }
779 
780         function deliver(uint256 tAmount) public {
781             address sender = _msgSender();
782             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
783             (uint256 rAmount,,,,,) = _getValues(tAmount);
784             _rOwned[sender] = _rOwned[sender].sub(rAmount);
785             _rTotal = _rTotal.sub(rAmount);
786             _tFeeTotal = _tFeeTotal.add(tAmount);
787         }
788 
789         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
790             require(tAmount <= _tTotal, "Amount must be less than supply");
791             if (!deductTransferFee) {
792                 (uint256 rAmount,,,,,) = _getValues(tAmount);
793                 return rAmount;
794             } else {
795                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
796                 return rTransferAmount;
797             }
798         }
799 
800         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
801             require(rAmount <= _rTotal, "Amount must be less than total reflections");
802             uint256 currentRate =  _getRate();
803             return rAmount.div(currentRate);
804         }
805 
806         function addBotToBlacklist (address account) external onlyOwner() {
807            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
808            require (!_isBlackListedBot[account], 'Account is already blacklisted');
809            _isBlackListedBot[account] = true;
810            _blackListedBots.push(account);
811         }
812 
813         function removeBotFromBlacklist(address account) external onlyOwner() {
814           require (_isBlackListedBot[account], 'Account is not blacklisted');
815           for (uint256 i = 0; i < _blackListedBots.length; i++) {
816                  if (_blackListedBots[i] == account) {
817                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
818                      _isBlackListedBot[account] = false;
819                      _blackListedBots.pop();
820                      break;
821                  }
822            }
823        }
824 
825         function excludeAccount(address account) external onlyOwner() {
826             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
827             require(!_isExcluded[account], "Account is already excluded");
828             if(_rOwned[account] > 0) {
829                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
830             }
831             _isExcluded[account] = true;
832             _excluded.push(account);
833         }
834 
835         function includeAccount(address account) external onlyOwner() {
836             require(_isExcluded[account], "Account is not excluded");
837             for (uint256 i = 0; i < _excluded.length; i++) {
838                 if (_excluded[i] == account) {
839                     _excluded[i] = _excluded[_excluded.length - 1];
840                     _tOwned[account] = 0;
841                     _isExcluded[account] = false;
842                     _excluded.pop();
843                     break;
844                 }
845             }
846         }
847 
848         function removeAllFee() private {
849             if(_taxFee == 0 && _teamFee == 0) return;
850 
851             _previousTaxFee = _taxFee;
852             _previousTeamFee = _teamFee;
853 
854             _taxFee = 0;
855             _teamFee = 0;
856         }
857 
858         function restoreAllFee() private {
859             _taxFee = _previousTaxFee;
860             _teamFee = _previousTeamFee;
861         }
862 
863         function isExcludedFromFee(address account) public view returns(bool) {
864             return _isExcludedFromFee[account];
865         }
866 
867         function _approve(address owner, address spender, uint256 amount) private {
868             require(owner != address(0), "ERC20: approve from the zero address");
869             require(spender != address(0), "ERC20: approve to the zero address");
870 
871             _allowances[owner][spender] = amount;
872             emit Approval(owner, spender, amount);
873         }
874 
875         function _transfer(address sender, address recipient, uint256 amount) private {
876             require(sender != address(0), "ERC20: transfer from the zero address");
877             require(recipient != address(0), "ERC20: transfer to the zero address");
878             require(amount > 0, "Transfer amount must be greater than zero");
879             require(!_isBlackListedBot[sender], "You are blacklisted");
880             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
881             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
882             if(sender != owner() && recipient != owner()) {
883                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
884             }
885             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
886                 uint256 tokenBalanceRecipient = balanceOf(recipient);
887                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
888             }
889             // is the token balance of this contract address over the min number of
890             // tokens that we need to initiate a swap?
891             // also, don't get caught in a circular team event.
892             // also, don't swap if sender is uniswap pair.
893             uint256 contractTokenBalance = balanceOf(address(this));
894 
895             if(contractTokenBalance >= _maxTxAmount)
896             {
897                 contractTokenBalance = _maxTxAmount;
898             }
899 
900             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
901             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
902                 // Swap tokens for ETH and send to resepctive wallets
903                 swapTokensForEth(contractTokenBalance);
904 
905                 uint256 contractETHBalance = address(this).balance;
906                 if(contractETHBalance > 0) {
907                     sendETHToTeam(address(this).balance);
908                 }
909             }
910 
911             //indicates if fee should be deducted from transfer
912             bool takeFee = true;
913 
914             //if any account belongs to _isExcludedFromFee account then remove the fee
915             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
916                 takeFee = false;
917             }
918 
919             //transfer amount, it will take tax and team fee
920             _tokenTransfer(sender,recipient,amount,takeFee);
921         }
922 
923         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
924             // generate the uniswap pair path of token -> weth
925             address[] memory path = new address[](2);
926             path[0] = address(this);
927             path[1] = uniswapV2Router.WETH();
928 
929             _approve(address(this), address(uniswapV2Router), tokenAmount);
930 
931             // make the swap
932             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
933                 tokenAmount,
934                 0, // accept any amount of ETH
935                 path,
936                 address(this),
937                 block.timestamp
938             );
939         }
940 
941         function sendETHToTeam(uint256 amount) private {
942             _devWalletAddress.transfer(amount.div(5));
943             _marketingWalletAddress.transfer(amount.div(10).mul(8));
944         }
945 
946         function manualSwap() external onlyOwner() {
947             uint256 contractBalance = balanceOf(address(this));
948             swapTokensForEth(contractBalance);
949         }
950 
951         function manualSend() external onlyOwner() {
952             uint256 contractETHBalance = address(this).balance;
953             sendETHToTeam(contractETHBalance);
954         }
955 
956         function setSwapEnabled(bool enabled) external onlyOwner(){
957             swapEnabled = enabled;
958         }
959 
960         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
961             if(!takeFee)
962                 removeAllFee();
963 
964             if (_isExcluded[sender] && !_isExcluded[recipient]) {
965                 _transferFromExcluded(sender, recipient, amount);
966             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
967                 _transferToExcluded(sender, recipient, amount);
968             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
969                 _transferStandard(sender, recipient, amount);
970             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
971                 _transferBothExcluded(sender, recipient, amount);
972             } else {
973                 _transferStandard(sender, recipient, amount);
974             }
975 
976             if(!takeFee)
977                 restoreAllFee();
978         }
979 
980         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
981             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
982             _rOwned[sender] = _rOwned[sender].sub(rAmount);
983             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
984             _takeTeam(tTeam);
985             _reflectFee(rFee, tFee);
986             emit Transfer(sender, recipient, tTransferAmount);
987         }
988 
989         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
990             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
991             _rOwned[sender] = _rOwned[sender].sub(rAmount);
992             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
993             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
994             _takeTeam(tTeam);
995             _reflectFee(rFee, tFee);
996             emit Transfer(sender, recipient, tTransferAmount);
997         }
998 
999         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1000             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1001             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1002             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1003             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1004             _takeTeam(tTeam);
1005             _reflectFee(rFee, tFee);
1006             emit Transfer(sender, recipient, tTransferAmount);
1007         }
1008 
1009         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1010             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1011             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1012             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1013             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1014             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1015             _takeTeam(tTeam);
1016             _reflectFee(rFee, tFee);
1017             emit Transfer(sender, recipient, tTransferAmount);
1018         }
1019 
1020         function _takeTeam(uint256 tTeam) private {
1021             uint256 currentRate =  _getRate();
1022             uint256 rTeam = tTeam.mul(currentRate);
1023             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1024             if(_isExcluded[address(this)])
1025                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1026         }
1027 
1028         function _reflectFee(uint256 rFee, uint256 tFee) private {
1029             _rTotal = _rTotal.sub(rFee);
1030             _tFeeTotal = _tFeeTotal.add(tFee);
1031         }
1032 
1033          //to recieve ETH from uniswapV2Router when swaping
1034         receive() external payable {}
1035 
1036         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1037         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1038         uint256 currentRate = _getRate();
1039         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1040         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1041     }
1042 
1043         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1044             uint256 tFee = tAmount.mul(taxFee).div(100);
1045             uint256 tTeam = tAmount.mul(teamFee).div(100);
1046             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1047             return (tTransferAmount, tFee, tTeam);
1048         }
1049 
1050         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1051             uint256 rAmount = tAmount.mul(currentRate);
1052             uint256 rFee = tFee.mul(currentRate);
1053             uint256 rTeam = tTeam.mul(currentRate);
1054             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1055             return (rAmount, rTransferAmount, rFee);
1056         }
1057 
1058         function _getRate() private view returns(uint256) {
1059             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1060             return rSupply.div(tSupply);
1061         }
1062 
1063         function _getCurrentSupply() private view returns(uint256, uint256) {
1064             uint256 rSupply = _rTotal;
1065             uint256 tSupply = _tTotal;
1066             for (uint256 i = 0; i < _excluded.length; i++) {
1067                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1068                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1069                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1070             }
1071             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1072             return (rSupply, tSupply);
1073         }
1074 
1075         function _getTaxFee() public view returns(uint256) {
1076             return _taxFee;
1077         }
1078 
1079         function _getTeamFee() public view returns (uint256) {
1080           return _teamFee;
1081         }
1082 
1083         function _getMaxTxAmount() public view returns(uint256) {
1084             return _maxTxAmount;
1085         }
1086 
1087         function _getETHBalance() public view returns(uint256 balance) {
1088             return address(this).balance;
1089         }
1090 
1091         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1092             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1093             _taxFee = taxFee;
1094         }
1095 
1096         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1097             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1098             _teamFee = teamFee;
1099         }
1100 
1101         function _setDevWallet(address payable devWalletAddress) external onlyOwner() {
1102             _devWalletAddress = devWalletAddress;
1103         }
1104 
1105         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1106             _marketingWalletAddress = marketingWalletAddress;
1107         }
1108 
1109         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1110             _maxTxAmount = maxTxAmount;
1111         }
1112 
1113         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1114           _maxWalletSize = maxWalletSize;
1115         }
1116     }