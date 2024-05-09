1 /**
2  *
3 
4 Website:
5 https://fedinu.com
6 
7 Telegram:
8 https://t.me/fedinu
9 
10 Twitter:
11 https://twitter.com/agentfedinu
12 
13 */
14 
15 // SPDX-License-Identifier: Unlicensed
16 pragma solidity ^0.6.12;
17 
18     abstract contract Context {
19         function _msgSender() internal view virtual returns (address payable) {
20             return msg.sender;
21         }
22 
23         function _msgData() internal view virtual returns (bytes memory) {
24             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25             return msg.data;
26         }
27     }
28 
29     interface IERC20 {
30         /**
31         * @dev Returns the amount of tokens in existence.
32         */
33         function totalSupply() external view returns (uint256);
34 
35         /**
36         * @dev Returns the amount of tokens owned by `account`.
37         */
38         function balanceOf(address account) external view returns (uint256);
39 
40         /**
41         * @dev Moves `amount` tokens from the caller's account to `recipient`.
42         *
43         * Returns a boolean value indicating whether the operation succeeded.
44         *
45         * Emits a {Transfer} event.
46         */
47         function transfer(address recipient, uint256 amount) external returns (bool);
48 
49         /**
50         * @dev Returns the remaining number of tokens that `spender` will be
51         * allowed to spend on behalf of `owner` through {transferFrom}. This is
52         * zero by default.
53         *
54         * This value changes when {approve} or {transferFrom} are called.
55         */
56         function allowance(address owner, address spender) external view returns (uint256);
57 
58         /**
59         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60         *
61         * Returns a boolean value indicating whether the operation succeeded.
62         *
63         * IMPORTANT: Beware that changing an allowance with this method brings the risk
64         * that someone may use both the old and the new allowance by unfortunate
65         * transaction ordering. One possible solution to mitigate this race
66         * condition is to first reduce the spender's allowance to 0 and set the
67         * desired value afterwards:
68         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69         *
70         * Emits an {Approval} event.
71         */
72         function approve(address spender, uint256 amount) external returns (bool);
73 
74         /**
75         * @dev Moves `amount` tokens from `sender` to `recipient` using the
76         * allowance mechanism. `amount` is then deducted from the caller's
77         * allowance.
78         *
79         * Returns a boolean value indicating whether the operation succeeded.
80         *
81         * Emits a {Transfer} event.
82         */
83         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85         /**
86         * @dev Emitted when `value` tokens are moved from one account (`from`) to
87         * another (`to`).
88         *
89         * Note that `value` may be zero.
90         */
91         event Transfer(address indexed from, address indexed to, uint256 value);
92 
93         /**
94         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95         * a call to {approve}. `value` is the new allowance.
96         */
97         event Approval(address indexed owner, address indexed spender, uint256 value);
98     }
99 
100     library SafeMath {
101         /**
102         * @dev Returns the addition of two unsigned integers, reverting on
103         * overflow.
104         *
105         * Counterpart to Solidity's `+` operator.
106         *
107         * Requirements:
108         *
109         * - Addition cannot overflow.
110         */
111         function add(uint256 a, uint256 b) internal pure returns (uint256) {
112             uint256 c = a + b;
113             require(c >= a, "SafeMath: addition overflow");
114 
115             return c;
116         }
117 
118         /**
119         * @dev Returns the subtraction of two unsigned integers, reverting on
120         * overflow (when the result is negative).
121         *
122         * Counterpart to Solidity's `-` operator.
123         *
124         * Requirements:
125         *
126         * - Subtraction cannot overflow.
127         */
128         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129             return sub(a, b, "SafeMath: subtraction overflow");
130         }
131 
132         /**
133         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134         * overflow (when the result is negative).
135         *
136         * Counterpart to Solidity's `-` operator.
137         *
138         * Requirements:
139         *
140         * - Subtraction cannot overflow.
141         */
142         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143             require(b <= a, errorMessage);
144             uint256 c = a - b;
145 
146             return c;
147         }
148 
149         /**
150         * @dev Returns the multiplication of two unsigned integers, reverting on
151         * overflow.
152         *
153         * Counterpart to Solidity's `*` operator.
154         *
155         * Requirements:
156         *
157         * - Multiplication cannot overflow.
158         */
159         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161             // benefit is lost if 'b' is also tested.
162             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163             if (a == 0) {
164                 return 0;
165             }
166 
167             uint256 c = a * b;
168             require(c / a == b, "SafeMath: multiplication overflow");
169 
170             return c;
171         }
172 
173         /**
174         * @dev Returns the integer division of two unsigned integers. Reverts on
175         * division by zero. The result is rounded towards zero.
176         *
177         * Counterpart to Solidity's `/` operator. Note: this function uses a
178         * `revert` opcode (which leaves remaining gas untouched) while Solidity
179         * uses an invalid opcode to revert (consuming all remaining gas).
180         *
181         * Requirements:
182         *
183         * - The divisor cannot be zero.
184         */
185         function div(uint256 a, uint256 b) internal pure returns (uint256) {
186             return div(a, b, "SafeMath: division by zero");
187         }
188 
189         /**
190         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191         * division by zero. The result is rounded towards zero.
192         *
193         * Counterpart to Solidity's `/` operator. Note: this function uses a
194         * `revert` opcode (which leaves remaining gas untouched) while Solidity
195         * uses an invalid opcode to revert (consuming all remaining gas).
196         *
197         * Requirements:
198         *
199         * - The divisor cannot be zero.
200         */
201         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202             require(b > 0, errorMessage);
203             uint256 c = a / b;
204             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206             return c;
207         }
208 
209         /**
210         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211         * Reverts when dividing by zero.
212         *
213         * Counterpart to Solidity's `%` operator. This function uses a `revert`
214         * opcode (which leaves remaining gas untouched) while Solidity uses an
215         * invalid opcode to revert (consuming all remaining gas).
216         *
217         * Requirements:
218         *
219         * - The divisor cannot be zero.
220         */
221         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222             return mod(a, b, "SafeMath: modulo by zero");
223         }
224 
225         /**
226         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227         * Reverts with custom message when dividing by zero.
228         *
229         * Counterpart to Solidity's `%` operator. This function uses a `revert`
230         * opcode (which leaves remaining gas untouched) while Solidity uses an
231         * invalid opcode to revert (consuming all remaining gas).
232         *
233         * Requirements:
234         *
235         * - The divisor cannot be zero.
236         */
237         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238             require(b != 0, errorMessage);
239             return a % b;
240         }
241     }
242 
243     library Address {
244         /**
245         * @dev Returns true if `account` is a contract.
246         *
247         * [IMPORTANT]
248         * ====
249         * It is unsafe to assume that an address for which this function returns
250         * false is an externally-owned account (EOA) and not a contract.
251         *
252         * Among others, `isContract` will return false for the following
253         * types of addresses:
254         *
255         *  - an externally-owned account
256         *  - a contract in construction
257         *  - an address where a contract will be created
258         *  - an address where a contract lived, but was destroyed
259         * ====
260         */
261         function isContract(address account) internal view returns (bool) {
262             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264             // for accounts without code, i.e. `keccak256('')`
265             bytes32 codehash;
266             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
267             // solhint-disable-next-line no-inline-assembly
268             assembly { codehash := extcodehash(account) }
269             return (codehash != accountHash && codehash != 0x0);
270         }
271 
272         /**
273         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274         * `recipient`, forwarding all available gas and reverting on errors.
275         *
276         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277         * of certain opcodes, possibly making contracts go over the 2300 gas limit
278         * imposed by `transfer`, making them unable to receive funds via
279         * `transfer`. {sendValue} removes this limitation.
280         *
281         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282         *
283         * IMPORTANT: because control is transferred to `recipient`, care must be
284         * taken to not create reentrancy vulnerabilities. Consider using
285         * {ReentrancyGuard} or the
286         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287         */
288         function sendValue(address payable recipient, uint256 amount) internal {
289             require(address(this).balance >= amount, "Address: insufficient balance");
290 
291             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292             (bool success, ) = recipient.call{ value: amount }("");
293             require(success, "Address: unable to send value, recipient may have reverted");
294         }
295 
296         /**
297         * @dev Performs a Solidity function call using a low level `call`. A
298         * plain`call` is an unsafe replacement for a function call: use this
299         * function instead.
300         *
301         * If `target` reverts with a revert reason, it is bubbled up by this
302         * function (like regular Solidity function calls).
303         *
304         * Returns the raw returned data. To convert to the expected return value,
305         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306         *
307         * Requirements:
308         *
309         * - `target` must be a contract.
310         * - calling `target` with `data` must not revert.
311         *
312         * _Available since v3.1._
313         */
314         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316         }
317 
318         /**
319         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320         * `errorMessage` as a fallback revert reason when `target` reverts.
321         *
322         * _Available since v3.1._
323         */
324         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325             return _functionCallWithValue(target, data, 0, errorMessage);
326         }
327 
328         /**
329         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330         * but also transferring `value` wei to `target`.
331         *
332         * Requirements:
333         *
334         * - the calling contract must have an ETH balance of at least `value`.
335         * - the called Solidity function must be `payable`.
336         *
337         * _Available since v3.1._
338         */
339         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341         }
342 
343         /**
344         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345         * with `errorMessage` as a fallback revert reason when `target` reverts.
346         *
347         * _Available since v3.1._
348         */
349         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350             require(address(this).balance >= value, "Address: insufficient balance for call");
351             return _functionCallWithValue(target, data, value, errorMessage);
352         }
353 
354         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
355             require(isContract(target), "Address: call to non-contract");
356 
357             // solhint-disable-next-line avoid-low-level-calls
358             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
359             if (success) {
360                 return returndata;
361             } else {
362                 // Look for revert reason and bubble it up if present
363                 if (returndata.length > 0) {
364                     // The easiest way to bubble the revert reason is using memory via assembly
365 
366                     // solhint-disable-next-line no-inline-assembly
367                     assembly {
368                         let returndata_size := mload(returndata)
369                         revert(add(32, returndata), returndata_size)
370                     }
371                 } else {
372                     revert(errorMessage);
373                 }
374             }
375         }
376     }
377 
378     contract Ownable is Context {
379         address private _owner;
380         address private _previousOwner;
381         uint256 private _lockTime;
382 
383         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385         /**
386         * @dev Initializes the contract setting the deployer as the initial owner.
387         */
388         constructor () internal {
389             address msgSender = _msgSender();
390             _owner = msgSender;
391             emit OwnershipTransferred(address(0), msgSender);
392         }
393 
394         /**
395         * @dev Returns the address of the current owner.
396         */
397         function owner() public view returns (address) {
398             return _owner;
399         }
400 
401         /**
402         * @dev Throws if called by any account other than the owner.
403         */
404         modifier onlyOwner() {
405             require(_owner == _msgSender(), "Ownable: caller is not the owner");
406             _;
407         }
408 
409         /**
410         * @dev Leaves the contract without owner. It will not be possible to call
411         * `onlyOwner` functions anymore. Can only be called by the current owner.
412         *
413         * NOTE: Renouncing ownership will leave the contract without an owner,
414         * thereby removing any functionality that is only available to the owner.
415         */
416         function renounceOwnership() public virtual onlyOwner {
417             emit OwnershipTransferred(_owner, address(0));
418             _owner = address(0);
419         }
420 
421         /**
422         * @dev Transfers ownership of the contract to a new account (`newOwner`).
423         * Can only be called by the current owner.
424         */
425         function transferOwnership(address newOwner) public virtual onlyOwner {
426             require(newOwner != address(0), "Ownable: new owner is the zero address");
427             emit OwnershipTransferred(_owner, newOwner);
428             _owner = newOwner;
429         }
430 
431         function geUnlockTime() public view returns (uint256) {
432             return _lockTime;
433         }
434 
435         //Locks the contract for owner for the amount of time provided
436         function lock(uint256 time) public virtual onlyOwner {
437             _previousOwner = _owner;
438             _owner = address(0);
439             _lockTime = now + time;
440             emit OwnershipTransferred(_owner, address(0));
441         }
442 
443         //Unlocks the contract for owner when _lockTime is exceeds
444         function unlock() public virtual {
445             require(_previousOwner == msg.sender, "You don't have permission to unlock");
446             require(now > _lockTime , "Contract is locked until 7 days");
447             emit OwnershipTransferred(_owner, _previousOwner);
448             _owner = _previousOwner;
449         }
450     }
451 
452     interface IUniswapV2Factory {
453         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
454 
455         function feeTo() external view returns (address);
456         function feeToSetter() external view returns (address);
457 
458         function getPair(address tokenA, address tokenB) external view returns (address pair);
459         function allPairs(uint) external view returns (address pair);
460         function allPairsLength() external view returns (uint);
461 
462         function createPair(address tokenA, address tokenB) external returns (address pair);
463 
464         function setFeeTo(address) external;
465         function setFeeToSetter(address) external;
466     }
467 
468     interface IUniswapV2Pair {
469         event Approval(address indexed owner, address indexed spender, uint value);
470         event Transfer(address indexed from, address indexed to, uint value);
471 
472         function name() external pure returns (string memory);
473         function symbol() external pure returns (string memory);
474         function decimals() external pure returns (uint8);
475         function totalSupply() external view returns (uint);
476         function balanceOf(address owner) external view returns (uint);
477         function allowance(address owner, address spender) external view returns (uint);
478 
479         function approve(address spender, uint value) external returns (bool);
480         function transfer(address to, uint value) external returns (bool);
481         function transferFrom(address from, address to, uint value) external returns (bool);
482 
483         function DOMAIN_SEPARATOR() external view returns (bytes32);
484         function PERMIT_TYPEHASH() external pure returns (bytes32);
485         function nonces(address owner) external view returns (uint);
486 
487         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
488 
489         event Mint(address indexed sender, uint amount0, uint amount1);
490         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
491         event Swap(
492             address indexed sender,
493             uint amount0In,
494             uint amount1In,
495             uint amount0Out,
496             uint amount1Out,
497             address indexed to
498         );
499         event Sync(uint112 reserve0, uint112 reserve1);
500 
501         function MINIMUM_LIQUIDITY() external pure returns (uint);
502         function factory() external view returns (address);
503         function token0() external view returns (address);
504         function token1() external view returns (address);
505         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
506         function price0CumulativeLast() external view returns (uint);
507         function price1CumulativeLast() external view returns (uint);
508         function kLast() external view returns (uint);
509 
510         function mint(address to) external returns (uint liquidity);
511         function burn(address to) external returns (uint amount0, uint amount1);
512         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
513         function skim(address to) external;
514         function sync() external;
515 
516         function initialize(address, address) external;
517     }
518 
519     interface IUniswapV2Router01 {
520         function factory() external pure returns (address);
521         function WETH() external pure returns (address);
522 
523         function addLiquidity(
524             address tokenA,
525             address tokenB,
526             uint amountADesired,
527             uint amountBDesired,
528             uint amountAMin,
529             uint amountBMin,
530             address to,
531             uint deadline
532         ) external returns (uint amountA, uint amountB, uint liquidity);
533         function addLiquidityETH(
534             address token,
535             uint amountTokenDesired,
536             uint amountTokenMin,
537             uint amountETHMin,
538             address to,
539             uint deadline
540         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
541         function removeLiquidity(
542             address tokenA,
543             address tokenB,
544             uint liquidity,
545             uint amountAMin,
546             uint amountBMin,
547             address to,
548             uint deadline
549         ) external returns (uint amountA, uint amountB);
550         function removeLiquidityETH(
551             address token,
552             uint liquidity,
553             uint amountTokenMin,
554             uint amountETHMin,
555             address to,
556             uint deadline
557         ) external returns (uint amountToken, uint amountETH);
558         function removeLiquidityWithPermit(
559             address tokenA,
560             address tokenB,
561             uint liquidity,
562             uint amountAMin,
563             uint amountBMin,
564             address to,
565             uint deadline,
566             bool approveMax, uint8 v, bytes32 r, bytes32 s
567         ) external returns (uint amountA, uint amountB);
568         function removeLiquidityETHWithPermit(
569             address token,
570             uint liquidity,
571             uint amountTokenMin,
572             uint amountETHMin,
573             address to,
574             uint deadline,
575             bool approveMax, uint8 v, bytes32 r, bytes32 s
576         ) external returns (uint amountToken, uint amountETH);
577         function swapExactTokensForTokens(
578             uint amountIn,
579             uint amountOutMin,
580             address[] calldata path,
581             address to,
582             uint deadline
583         ) external returns (uint[] memory amounts);
584         function swapTokensForExactTokens(
585             uint amountOut,
586             uint amountInMax,
587             address[] calldata path,
588             address to,
589             uint deadline
590         ) external returns (uint[] memory amounts);
591         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
592             external
593             payable
594             returns (uint[] memory amounts);
595         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
596             external
597             returns (uint[] memory amounts);
598         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
599             external
600             returns (uint[] memory amounts);
601         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
602             external
603             payable
604             returns (uint[] memory amounts);
605 
606         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
607         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
608         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
609         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
610         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
611     }
612 
613     interface IUniswapV2Router02 is IUniswapV2Router01 {
614         function removeLiquidityETHSupportingFeeOnTransferTokens(
615             address token,
616             uint liquidity,
617             uint amountTokenMin,
618             uint amountETHMin,
619             address to,
620             uint deadline
621         ) external returns (uint amountETH);
622         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
623             address token,
624             uint liquidity,
625             uint amountTokenMin,
626             uint amountETHMin,
627             address to,
628             uint deadline,
629             bool approveMax, uint8 v, bytes32 r, bytes32 s
630         ) external returns (uint amountETH);
631 
632         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
633             uint amountIn,
634             uint amountOutMin,
635             address[] calldata path,
636             address to,
637             uint deadline
638         ) external;
639         function swapExactETHForTokensSupportingFeeOnTransferTokens(
640             uint amountOutMin,
641             address[] calldata path,
642             address to,
643             uint deadline
644         ) external payable;
645         function swapExactTokensForETHSupportingFeeOnTransferTokens(
646             uint amountIn,
647             uint amountOutMin,
648             address[] calldata path,
649             address to,
650             uint deadline
651         ) external;
652     }
653 
654     // Contract implementation
655     contract FedInu is Context, IERC20, Ownable {
656         using SafeMath for uint256;
657         using Address for address;
658 
659         mapping (address => uint256) private _rOwned;
660         mapping (address => uint256) private _tOwned;
661         mapping (address => mapping (address => uint256)) private _allowances;
662 
663         mapping (address => bool) private _isExcludedFromFee;
664 
665         mapping (address => bool) private _isExcluded;
666         address[] private _excluded;
667 
668         uint256 private constant MAX = ~uint256(0);
669         uint256 private _tTotal = 1000 * 10**9 * 10**9;
670         uint256 private _rTotal = (MAX - (MAX % _tTotal));
671         uint256 private _tFeeTotal;
672 
673         string private _name = 'Fed Inu';
674         string private _symbol = 'COKEN';
675         uint8 private _decimals = 9;
676 
677         uint256 private _taxFee = 10;
678         uint256 private _teamFee = 4;
679         uint256 private _previousTaxFee = _taxFee;
680         uint256 private _previousTeamFee = _teamFee;
681 
682         address payable public _TeamWallet;
683         address payable public _marketingWalletAddress;
684 
685         IUniswapV2Router02 public immutable uniswapV2Router;
686         address public immutable uniswapV2Pair;
687 
688         bool inSwap = false;
689         bool public swapEnabled = true;
690 
691         uint256 private _maxTxAmount = 100 * 10**7 * 10**9; // .1%
692         uint256 private _numOfTokensToExchangeForTeam = 500 * 10**7 * 10**9; // 0.05%
693 
694         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
695         event SwapEnabledUpdated(bool enabled);
696 
697         modifier lockTheSwap {
698             inSwap = true;
699             _;
700             inSwap = false;
701         }
702 
703         constructor (address payable TeamWalletAddress, address payable marketingWalletAddress) public {
704             _TeamWallet = TeamWalletAddress;
705             _marketingWalletAddress = marketingWalletAddress;
706             _rOwned[_msgSender()] = _rTotal;
707 
708             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
709             // Create a uniswap pair for this new token
710             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
711                 .createPair(address(this), _uniswapV2Router.WETH());
712 
713             // set the rest of the contract variables
714             uniswapV2Router = _uniswapV2Router;
715 
716             // Exclude owner and this contract from fee
717             _isExcludedFromFee[owner()] = true;
718             _isExcludedFromFee[address(this)] = true;
719 
720             emit Transfer(address(0), _msgSender(), _tTotal);
721         }
722 
723         function name() public view returns (string memory) {
724             return _name;
725         }
726 
727         function symbol() public view returns (string memory) {
728             return _symbol;
729         }
730 
731         function decimals() public view returns (uint8) {
732             return _decimals;
733         }
734 
735         function totalSupply() public view override returns (uint256) {
736             return _tTotal;
737         }
738 
739         function balanceOf(address account) public view override returns (uint256) {
740             if (_isExcluded[account]) return _tOwned[account];
741             return tokenFromReflection(_rOwned[account]);
742         }
743 
744         function transfer(address recipient, uint256 amount) public override returns (bool) {
745             _transfer(_msgSender(), recipient, amount);
746             return true;
747         }
748 
749         function allowance(address owner, address spender) public view override returns (uint256) {
750             return _allowances[owner][spender];
751         }
752 
753         function approve(address spender, uint256 amount) public override returns (bool) {
754             _approve(_msgSender(), spender, amount);
755             return true;
756         }
757 
758         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
759             _transfer(sender, recipient, amount);
760             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
761             return true;
762         }
763 
764         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
765             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
766             return true;
767         }
768 
769         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
770             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
771             return true;
772         }
773 
774         function isExcluded(address account) public view returns (bool) {
775             return _isExcluded[account];
776         }
777 
778         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
779             _isExcludedFromFee[account] = excluded;
780         }
781 
782         function totalFees() public view returns (uint256) {
783             return _tFeeTotal;
784         }
785 
786         function deliver(uint256 tAmount) public {
787             address sender = _msgSender();
788             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
789             (uint256 rAmount,,,,,) = _getValues(tAmount);
790             _rOwned[sender] = _rOwned[sender].sub(rAmount);
791             _rTotal = _rTotal.sub(rAmount);
792             _tFeeTotal = _tFeeTotal.add(tAmount);
793         }
794 
795         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
796             require(tAmount <= _tTotal, "Amount must be less than supply");
797             if (!deductTransferFee) {
798                 (uint256 rAmount,,,,,) = _getValues(tAmount);
799                 return rAmount;
800             } else {
801                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
802                 return rTransferAmount;
803             }
804         }
805 
806         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
807             require(rAmount <= _rTotal, "Amount must be less than total reflections");
808             uint256 currentRate =  _getRate();
809             return rAmount.div(currentRate);
810         }
811 
812         function excludeAccount(address account) external onlyOwner() {
813             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
814             require(!_isExcluded[account], "Account is already excluded");
815             if(_rOwned[account] > 0) {
816                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
817             }
818             _isExcluded[account] = true;
819             _excluded.push(account);
820         }
821 
822         function includeAccount(address account) external onlyOwner() {
823             require(_isExcluded[account], "Account is already excluded");
824             for (uint256 i = 0; i < _excluded.length; i++) {
825                 if (_excluded[i] == account) {
826                     _excluded[i] = _excluded[_excluded.length - 1];
827                     _tOwned[account] = 0;
828                     _isExcluded[account] = false;
829                     _excluded.pop();
830                     break;
831                 }
832             }
833         }
834 
835         function removeAllFee() private {
836             if(_taxFee == 0 && _teamFee == 0) return;
837 
838             _previousTaxFee = _taxFee;
839             _previousTeamFee = _teamFee;
840 
841             _taxFee = 0;
842             _teamFee = 0;
843         }
844 
845         function restoreAllFee() private {
846             _taxFee = _previousTaxFee;
847             _teamFee = _previousTeamFee;
848         }
849 
850         function isExcludedFromFee(address account) public view returns(bool) {
851             return _isExcludedFromFee[account];
852         }
853 
854         function _approve(address owner, address spender, uint256 amount) private {
855             require(owner != address(0), "ERC20: approve from the zero address");
856             require(spender != address(0), "ERC20: approve to the zero address");
857 
858             _allowances[owner][spender] = amount;
859             emit Approval(owner, spender, amount);
860         }
861 
862         function _transfer(address sender, address recipient, uint256 amount) private {
863             require(sender != address(0), "ERC20: transfer from the zero address");
864             require(recipient != address(0), "ERC20: transfer to the zero address");
865             require(amount > 0, "Transfer amount must be greater than zero");
866 
867             if(sender != owner() && recipient != owner())
868                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
869 
870             // is the token balance of this contract address over the min number of
871             // tokens that we need to initiate a swap?
872             // also, don't get caught in a circular team event.
873             // also, don't swap if sender is uniswap pair.
874             uint256 contractTokenBalance = balanceOf(address(this));
875 
876             if(contractTokenBalance >= _maxTxAmount)
877             {
878                 contractTokenBalance = _maxTxAmount;
879             }
880 
881             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
882             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
883                 // We need to swap the current tokens to ETH and send to the team wallet
884                 swapTokensForEth(contractTokenBalance);
885 
886                 uint256 contractETHBalance = address(this).balance;
887                 if(contractETHBalance > 0) {
888                     sendETHToTeam(address(this).balance);
889                 }
890             }
891 
892             //indicates if fee should be deducted from transfer
893             bool takeFee = true;
894 
895             //if any account belongs to _isExcludedFromFee account then remove the fee
896             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
897                 takeFee = false;
898             }
899 
900             //transfer amount, it will take tax and team fee
901             _tokenTransfer(sender,recipient,amount,takeFee);
902         }
903 
904         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
905             // generate the uniswap pair path of token -> weth
906             address[] memory path = new address[](2);
907             path[0] = address(this);
908             path[1] = uniswapV2Router.WETH();
909 
910             _approve(address(this), address(uniswapV2Router), tokenAmount);
911 
912             // make the swap
913             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
914                 tokenAmount,
915                 0, // accept any amount of ETH
916                 path,
917                 address(this),
918                 block.timestamp
919             );
920         }
921 
922         function sendETHToTeam(uint256 amount) private {
923             _TeamWallet.transfer(amount.div(2));
924             _marketingWalletAddress.transfer(amount.div(2));
925         }
926 
927         // We are exposing these functions to be able to manual swap and send
928         // in case the token is highly valued and 5M becomes too much
929         function manualSwap() external onlyOwner() {
930             uint256 contractBalance = balanceOf(address(this));
931             swapTokensForEth(contractBalance);
932         }
933 
934         function manualSend() external onlyOwner() {
935             uint256 contractETHBalance = address(this).balance;
936             sendETHToTeam(contractETHBalance);
937         }
938 
939         function setSwapEnabled(bool enabled) external onlyOwner(){
940             swapEnabled = enabled;
941         }
942 
943         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
944             if(!takeFee)
945                 removeAllFee();
946 
947             if (_isExcluded[sender] && !_isExcluded[recipient]) {
948                 _transferFromExcluded(sender, recipient, amount);
949             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
950                 _transferToExcluded(sender, recipient, amount);
951             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
952                 _transferStandard(sender, recipient, amount);
953             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
954                 _transferBothExcluded(sender, recipient, amount);
955             } else {
956                 _transferStandard(sender, recipient, amount);
957             }
958 
959             if(!takeFee)
960                 restoreAllFee();
961         }
962 
963         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
964             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
965             _rOwned[sender] = _rOwned[sender].sub(rAmount);
966             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
967             _takeTeam(tTeam);
968             _reflectFee(rFee, tFee);
969             emit Transfer(sender, recipient, tTransferAmount);
970         }
971 
972         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
973             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
974             _rOwned[sender] = _rOwned[sender].sub(rAmount);
975             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
976             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
977             _takeTeam(tTeam);
978             _reflectFee(rFee, tFee);
979             emit Transfer(sender, recipient, tTransferAmount);
980         }
981 
982         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
983             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
984             _tOwned[sender] = _tOwned[sender].sub(tAmount);
985             _rOwned[sender] = _rOwned[sender].sub(rAmount);
986             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
987             _takeTeam(tTeam);
988             _reflectFee(rFee, tFee);
989             emit Transfer(sender, recipient, tTransferAmount);
990         }
991 
992         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
993             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
994             _tOwned[sender] = _tOwned[sender].sub(tAmount);
995             _rOwned[sender] = _rOwned[sender].sub(rAmount);
996             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
997             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
998             _takeTeam(tTeam);
999             _reflectFee(rFee, tFee);
1000             emit Transfer(sender, recipient, tTransferAmount);
1001         }
1002 
1003         function _takeTeam(uint256 tTeam) private {
1004             uint256 currentRate =  _getRate();
1005             uint256 rTeam = tTeam.mul(currentRate);
1006             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1007             if(_isExcluded[address(this)])
1008                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1009         }
1010 
1011         function _reflectFee(uint256 rFee, uint256 tFee) private {
1012             _rTotal = _rTotal.sub(rFee);
1013             _tFeeTotal = _tFeeTotal.add(tFee);
1014         }
1015 
1016          //to recieve ETH from uniswapV2Router when swaping
1017         receive() external payable {}
1018 
1019         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1020             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1021             uint256 currentRate =  _getRate();
1022             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1023             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1024         }
1025 
1026         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1027             uint256 tFee = tAmount.mul(taxFee).div(100);
1028             uint256 tTeam = tAmount.mul(teamFee).div(100);
1029             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1030             return (tTransferAmount, tFee, tTeam);
1031         }
1032 
1033         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1034             uint256 rAmount = tAmount.mul(currentRate);
1035             uint256 rFee = tFee.mul(currentRate);
1036             uint256 rTransferAmount = rAmount.sub(rFee);
1037             return (rAmount, rTransferAmount, rFee);
1038         }
1039 
1040         function _getRate() private view returns(uint256) {
1041             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1042             return rSupply.div(tSupply);
1043         }
1044 
1045         function _getCurrentSupply() private view returns(uint256, uint256) {
1046             uint256 rSupply = _rTotal;
1047             uint256 tSupply = _tTotal;
1048             for (uint256 i = 0; i < _excluded.length; i++) {
1049                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1050                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1051                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1052             }
1053             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1054             return (rSupply, tSupply);
1055         }
1056 
1057         function _getTaxFee() private view returns(uint256) {
1058             return _taxFee;
1059         }
1060 
1061         function _getMaxTxAmount() private view returns(uint256) {
1062             return _maxTxAmount;
1063         }
1064 
1065         function _getETHBalance() public view returns(uint256 balance) {
1066             return address(this).balance;
1067         }
1068 
1069         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1070             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1071             _taxFee = taxFee;
1072         }
1073 
1074         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1075             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1076             _teamFee = teamFee;
1077         }
1078 
1079         function _setTeamWallet(address payable TeamWalletAddress) external onlyOwner() {
1080             _TeamWallet = TeamWalletAddress;
1081         }
1082 
1083         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1084             _maxTxAmount = maxTxAmount;
1085         }
1086 
1087         function airdrop(address[] memory airdropWallets, uint256[] memory amounts) external onlyOwner {
1088             require(airdropWallets.length < 200, "Can only airdrop 200 wallets per txn due to gas limits"); // allows for airdrop
1089             for(uint256 i = 0; i < airdropWallets.length; i++){
1090                 address wallet = airdropWallets[i];
1091                 uint256 amount = amounts[i] * 10**9;
1092                 _transfer(msg.sender, wallet, amount);
1093         }
1094     }
1095     }