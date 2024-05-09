1 /**
2 Multi-Gen Capital: $MGC
3 -You buy on Ethereum, we farm on multiple chains and return the profits to $MGC holders.
4 
5 Tokenomics:
6 10% of each buy goes to existing holders.
7 15% of each sell goes into multi-chain farming to add to the treasury and buy back MGC tokens.
8 
9 Telegram:
10 https://t.me/MultiGenCapital
11 
12 Website:
13 https://multigencapital.io/
14 
15 Twitter: 
16 https://twitter.com/multigencap
17 
18 */
19 
20 // SPDX-License-Identifier: Unlicensed
21 pragma solidity ^0.6.12;
22 
23     abstract contract Context {
24         function _msgSender() internal view virtual returns (address payable) {
25             return msg.sender;
26         }
27 
28         function _msgData() internal view virtual returns (bytes memory) {
29             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30             return msg.data;
31         }
32     }
33 
34     interface IERC20 {
35         /**
36         * @dev Returns the amount of tokens in existence.
37         */
38         function totalSupply() external view returns (uint256);
39 
40         /**
41         * @dev Returns the amount of tokens owned by `account`.
42         */
43         function balanceOf(address account) external view returns (uint256);
44 
45         /**
46         * @dev Moves `amount` tokens from the caller's account to `recipient`.
47         *
48         * Returns a boolean value indicating whether the operation succeeded.
49         *
50         * Emits a {Transfer} event.
51         */
52         function transfer(address recipient, uint256 amount) external returns (bool);
53 
54         /**
55         * @dev Returns the remaining number of tokens that `spender` will be
56         * allowed to spend on behalf of `owner` through {transferFrom}. This is
57         * zero by default.
58         *
59         * This value changes when {approve} or {transferFrom} are called.
60         */
61         function allowance(address owner, address spender) external view returns (uint256);
62 
63         /**
64         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65         *
66         * Returns a boolean value indicating whether the operation succeeded.
67         *
68         * IMPORTANT: Beware that changing an allowance with this method brings the risk
69         * that someone may use both the old and the new allowance by unfortunate
70         * transaction ordering. One possible solution to mitigate this race
71         * condition is to first reduce the spender's allowance to 0 and set the
72         * desired value afterwards:
73         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74         *
75         * Emits an {Approval} event.
76         */
77         function approve(address spender, uint256 amount) external returns (bool);
78 
79         /**
80         * @dev Moves `amount` tokens from `sender` to `recipient` using the
81         * allowance mechanism. `amount` is then deducted from the caller's
82         * allowance.
83         *
84         * Returns a boolean value indicating whether the operation succeeded.
85         *
86         * Emits a {Transfer} event.
87         */
88         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90         /**
91         * @dev Emitted when `value` tokens are moved from one account (`from`) to
92         * another (`to`).
93         *
94         * Note that `value` may be zero.
95         */
96         event Transfer(address indexed from, address indexed to, uint256 value);
97 
98         /**
99         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100         * a call to {approve}. `value` is the new allowance.
101         */
102         event Approval(address indexed owner, address indexed spender, uint256 value);
103     }
104 
105     library SafeMath {
106         /**
107         * @dev Returns the addition of two unsigned integers, reverting on
108         * overflow.
109         *
110         * Counterpart to Solidity's `+` operator.
111         *
112         * Requirements:
113         *
114         * - Addition cannot overflow.
115         */
116         function add(uint256 a, uint256 b) internal pure returns (uint256) {
117             uint256 c = a + b;
118             require(c >= a, "SafeMath: addition overflow");
119 
120             return c;
121         }
122 
123         /**
124         * @dev Returns the subtraction of two unsigned integers, reverting on
125         * overflow (when the result is negative).
126         *
127         * Counterpart to Solidity's `-` operator.
128         *
129         * Requirements:
130         *
131         * - Subtraction cannot overflow.
132         */
133         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134             return sub(a, b, "SafeMath: subtraction overflow");
135         }
136 
137         /**
138         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139         * overflow (when the result is negative).
140         *
141         * Counterpart to Solidity's `-` operator.
142         *
143         * Requirements:
144         *
145         * - Subtraction cannot overflow.
146         */
147         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148             require(b <= a, errorMessage);
149             uint256 c = a - b;
150 
151             return c;
152         }
153 
154         /**
155         * @dev Returns the multiplication of two unsigned integers, reverting on
156         * overflow.
157         *
158         * Counterpart to Solidity's `*` operator.
159         *
160         * Requirements:
161         *
162         * - Multiplication cannot overflow.
163         */
164         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166             // benefit is lost if 'b' is also tested.
167             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168             if (a == 0) {
169                 return 0;
170             }
171 
172             uint256 c = a * b;
173             require(c / a == b, "SafeMath: multiplication overflow");
174 
175             return c;
176         }
177 
178         /**
179         * @dev Returns the integer division of two unsigned integers. Reverts on
180         * division by zero. The result is rounded towards zero.
181         *
182         * Counterpart to Solidity's `/` operator. Note: this function uses a
183         * `revert` opcode (which leaves remaining gas untouched) while Solidity
184         * uses an invalid opcode to revert (consuming all remaining gas).
185         *
186         * Requirements:
187         *
188         * - The divisor cannot be zero.
189         */
190         function div(uint256 a, uint256 b) internal pure returns (uint256) {
191             return div(a, b, "SafeMath: division by zero");
192         }
193 
194         /**
195         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196         * division by zero. The result is rounded towards zero.
197         *
198         * Counterpart to Solidity's `/` operator. Note: this function uses a
199         * `revert` opcode (which leaves remaining gas untouched) while Solidity
200         * uses an invalid opcode to revert (consuming all remaining gas).
201         *
202         * Requirements:
203         *
204         * - The divisor cannot be zero.
205         */
206         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207             require(b > 0, errorMessage);
208             uint256 c = a / b;
209             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211             return c;
212         }
213 
214         /**
215         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216         * Reverts when dividing by zero.
217         *
218         * Counterpart to Solidity's `%` operator. This function uses a `revert`
219         * opcode (which leaves remaining gas untouched) while Solidity uses an
220         * invalid opcode to revert (consuming all remaining gas).
221         *
222         * Requirements:
223         *
224         * - The divisor cannot be zero.
225         */
226         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227             return mod(a, b, "SafeMath: modulo by zero");
228         }
229 
230         /**
231         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232         * Reverts with custom message when dividing by zero.
233         *
234         * Counterpart to Solidity's `%` operator. This function uses a `revert`
235         * opcode (which leaves remaining gas untouched) while Solidity uses an
236         * invalid opcode to revert (consuming all remaining gas).
237         *
238         * Requirements:
239         *
240         * - The divisor cannot be zero.
241         */
242         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243             require(b != 0, errorMessage);
244             return a % b;
245         }
246     }
247 
248     library Address {
249         /**
250         * @dev Returns true if `account` is a contract.
251         *
252         * [IMPORTANT]
253         * ====
254         * It is unsafe to assume that an address for which this function returns
255         * false is an externally-owned account (EOA) and not a contract.
256         *
257         * Among others, `isContract` will return false for the following
258         * types of addresses:
259         *
260         *  - an externally-owned account
261         *  - a contract in construction
262         *  - an address where a contract will be created
263         *  - an address where a contract lived, but was destroyed
264         * ====
265         */
266         function isContract(address account) internal view returns (bool) {
267             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269             // for accounts without code, i.e. `keccak256('')`
270             bytes32 codehash;
271             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272             // solhint-disable-next-line no-inline-assembly
273             assembly { codehash := extcodehash(account) }
274             return (codehash != accountHash && codehash != 0x0);
275         }
276 
277         /**
278         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279         * `recipient`, forwarding all available gas and reverting on errors.
280         *
281         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282         * of certain opcodes, possibly making contracts go over the 2300 gas limit
283         * imposed by `transfer`, making them unable to receive funds via
284         * `transfer`. {sendValue} removes this limitation.
285         *
286         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287         *
288         * IMPORTANT: because control is transferred to `recipient`, care must be
289         * taken to not create reentrancy vulnerabilities. Consider using
290         * {ReentrancyGuard} or the
291         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292         */
293         function sendValue(address payable recipient, uint256 amount) internal {
294             require(address(this).balance >= amount, "Address: insufficient balance");
295 
296             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297             (bool success, ) = recipient.call{ value: amount }("");
298             require(success, "Address: unable to send value, recipient may have reverted");
299         }
300 
301         /**
302         * @dev Performs a Solidity function call using a low level `call`. A
303         * plain`call` is an unsafe replacement for a function call: use this
304         * function instead.
305         *
306         * If `target` reverts with a revert reason, it is bubbled up by this
307         * function (like regular Solidity function calls).
308         *
309         * Returns the raw returned data. To convert to the expected return value,
310         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311         *
312         * Requirements:
313         *
314         * - `target` must be a contract.
315         * - calling `target` with `data` must not revert.
316         *
317         * _Available since v3.1._
318         */
319         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320         return functionCall(target, data, "Address: low-level call failed");
321         }
322 
323         /**
324         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325         * `errorMessage` as a fallback revert reason when `target` reverts.
326         *
327         * _Available since v3.1._
328         */
329         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330             return _functionCallWithValue(target, data, 0, errorMessage);
331         }
332 
333         /**
334         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335         * but also transferring `value` wei to `target`.
336         *
337         * Requirements:
338         *
339         * - the calling contract must have an ETH balance of at least `value`.
340         * - the called Solidity function must be `payable`.
341         *
342         * _Available since v3.1._
343         */
344         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346         }
347 
348         /**
349         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350         * with `errorMessage` as a fallback revert reason when `target` reverts.
351         *
352         * _Available since v3.1._
353         */
354         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355             require(address(this).balance >= value, "Address: insufficient balance for call");
356             return _functionCallWithValue(target, data, value, errorMessage);
357         }
358 
359         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360             require(isContract(target), "Address: call to non-contract");
361 
362             // solhint-disable-next-line avoid-low-level-calls
363             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364             if (success) {
365                 return returndata;
366             } else {
367                 // Look for revert reason and bubble it up if present
368                 if (returndata.length > 0) {
369                     // The easiest way to bubble the revert reason is using memory via assembly
370 
371                     // solhint-disable-next-line no-inline-assembly
372                     assembly {
373                         let returndata_size := mload(returndata)
374                         revert(add(32, returndata), returndata_size)
375                     }
376                 } else {
377                     revert(errorMessage);
378                 }
379             }
380         }
381     }
382 
383     contract Ownable is Context {
384         address private _owner;
385         address private _previousOwner;
386         uint256 private _lockTime;
387 
388         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390         /**
391         * @dev Initializes the contract setting the deployer as the initial owner.
392         */
393         constructor () internal {
394             address msgSender = _msgSender();
395             _owner = msgSender;
396             emit OwnershipTransferred(address(0), msgSender);
397         }
398 
399         /**
400         * @dev Returns the address of the current owner.
401         */
402         function owner() public view returns (address) {
403             return _owner;
404         }
405 
406         /**
407         * @dev Throws if called by any account other than the owner.
408         */
409         modifier onlyOwner() {
410             require(_owner == _msgSender(), "Ownable: caller is not the owner");
411             _;
412         }
413 
414         /**
415         * @dev Leaves the contract without owner. It will not be possible to call
416         * `onlyOwner` functions anymore. Can only be called by the current owner.
417         *
418         * NOTE: Renouncing ownership will leave the contract without an owner,
419         * thereby removing any functionality that is only available to the owner.
420         */
421         function renounceOwnership() public virtual onlyOwner {
422             emit OwnershipTransferred(_owner, address(0));
423             _owner = address(0);
424         }
425 
426         /**
427         * @dev Transfers ownership of the contract to a new account (`newOwner`).
428         * Can only be called by the current owner.
429         */
430         function transferOwnership(address newOwner) public virtual onlyOwner {
431             require(newOwner != address(0), "Ownable: new owner is the zero address");
432             emit OwnershipTransferred(_owner, newOwner);
433             _owner = newOwner;
434         }
435 
436         function geUnlockTime() public view returns (uint256) {
437             return _lockTime;
438         }
439 
440         //Locks the contract for owner for the amount of time provided
441         function lock(uint256 time) public virtual onlyOwner {
442             _previousOwner = _owner;
443             _owner = address(0);
444             _lockTime = now + time;
445             emit OwnershipTransferred(_owner, address(0));
446         }
447 
448         //Unlocks the contract for owner when _lockTime is exceeds
449         function unlock() public virtual {
450             require(_previousOwner == msg.sender, "You don't have permission to unlock");
451             require(now > _lockTime , "Contract is locked until 7 days");
452             emit OwnershipTransferred(_owner, _previousOwner);
453             _owner = _previousOwner;
454         }
455     }
456 
457     interface IUniswapV2Factory {
458         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
459 
460         function feeTo() external view returns (address);
461         function feeToSetter() external view returns (address);
462 
463         function getPair(address tokenA, address tokenB) external view returns (address pair);
464         function allPairs(uint) external view returns (address pair);
465         function allPairsLength() external view returns (uint);
466 
467         function createPair(address tokenA, address tokenB) external returns (address pair);
468 
469         function setFeeTo(address) external;
470         function setFeeToSetter(address) external;
471     }
472 
473     interface IUniswapV2Pair {
474         event Approval(address indexed owner, address indexed spender, uint value);
475         event Transfer(address indexed from, address indexed to, uint value);
476 
477         function name() external pure returns (string memory);
478         function symbol() external pure returns (string memory);
479         function decimals() external pure returns (uint8);
480         function totalSupply() external view returns (uint);
481         function balanceOf(address owner) external view returns (uint);
482         function allowance(address owner, address spender) external view returns (uint);
483 
484         function approve(address spender, uint value) external returns (bool);
485         function transfer(address to, uint value) external returns (bool);
486         function transferFrom(address from, address to, uint value) external returns (bool);
487 
488         function DOMAIN_SEPARATOR() external view returns (bytes32);
489         function PERMIT_TYPEHASH() external pure returns (bytes32);
490         function nonces(address owner) external view returns (uint);
491 
492         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
493 
494         event Mint(address indexed sender, uint amount0, uint amount1);
495         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
496         event Swap(
497             address indexed sender,
498             uint amount0In,
499             uint amount1In,
500             uint amount0Out,
501             uint amount1Out,
502             address indexed to
503         );
504         event Sync(uint112 reserve0, uint112 reserve1);
505 
506         function MINIMUM_LIQUIDITY() external pure returns (uint);
507         function factory() external view returns (address);
508         function token0() external view returns (address);
509         function token1() external view returns (address);
510         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
511         function price0CumulativeLast() external view returns (uint);
512         function price1CumulativeLast() external view returns (uint);
513         function kLast() external view returns (uint);
514 
515         function mint(address to) external returns (uint liquidity);
516         function burn(address to) external returns (uint amount0, uint amount1);
517         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
518         function skim(address to) external;
519         function sync() external;
520 
521         function initialize(address, address) external;
522     }
523 
524     interface IUniswapV2Router01 {
525         function factory() external pure returns (address);
526         function WETH() external pure returns (address);
527 
528         function addLiquidity(
529             address tokenA,
530             address tokenB,
531             uint amountADesired,
532             uint amountBDesired,
533             uint amountAMin,
534             uint amountBMin,
535             address to,
536             uint deadline
537         ) external returns (uint amountA, uint amountB, uint liquidity);
538         function addLiquidityETH(
539             address token,
540             uint amountTokenDesired,
541             uint amountTokenMin,
542             uint amountETHMin,
543             address to,
544             uint deadline
545         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
546         function removeLiquidity(
547             address tokenA,
548             address tokenB,
549             uint liquidity,
550             uint amountAMin,
551             uint amountBMin,
552             address to,
553             uint deadline
554         ) external returns (uint amountA, uint amountB);
555         function removeLiquidityETH(
556             address token,
557             uint liquidity,
558             uint amountTokenMin,
559             uint amountETHMin,
560             address to,
561             uint deadline
562         ) external returns (uint amountToken, uint amountETH);
563         function removeLiquidityWithPermit(
564             address tokenA,
565             address tokenB,
566             uint liquidity,
567             uint amountAMin,
568             uint amountBMin,
569             address to,
570             uint deadline,
571             bool approveMax, uint8 v, bytes32 r, bytes32 s
572         ) external returns (uint amountA, uint amountB);
573         function removeLiquidityETHWithPermit(
574             address token,
575             uint liquidity,
576             uint amountTokenMin,
577             uint amountETHMin,
578             address to,
579             uint deadline,
580             bool approveMax, uint8 v, bytes32 r, bytes32 s
581         ) external returns (uint amountToken, uint amountETH);
582         function swapExactTokensForTokens(
583             uint amountIn,
584             uint amountOutMin,
585             address[] calldata path,
586             address to,
587             uint deadline
588         ) external returns (uint[] memory amounts);
589         function swapTokensForExactTokens(
590             uint amountOut,
591             uint amountInMax,
592             address[] calldata path,
593             address to,
594             uint deadline
595         ) external returns (uint[] memory amounts);
596         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
597             external
598             payable
599             returns (uint[] memory amounts);
600         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
601             external
602             returns (uint[] memory amounts);
603         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
604             external
605             returns (uint[] memory amounts);
606         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
607             external
608             payable
609             returns (uint[] memory amounts);
610 
611         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
612         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
613         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
614         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
615         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
616     }
617 
618     interface IUniswapV2Router02 is IUniswapV2Router01 {
619         function removeLiquidityETHSupportingFeeOnTransferTokens(
620             address token,
621             uint liquidity,
622             uint amountTokenMin,
623             uint amountETHMin,
624             address to,
625             uint deadline
626         ) external returns (uint amountETH);
627         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
628             address token,
629             uint liquidity,
630             uint amountTokenMin,
631             uint amountETHMin,
632             address to,
633             uint deadline,
634             bool approveMax, uint8 v, bytes32 r, bytes32 s
635         ) external returns (uint amountETH);
636 
637         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
638             uint amountIn,
639             uint amountOutMin,
640             address[] calldata path,
641             address to,
642             uint deadline
643         ) external;
644         function swapExactETHForTokensSupportingFeeOnTransferTokens(
645             uint amountOutMin,
646             address[] calldata path,
647             address to,
648             uint deadline
649         ) external payable;
650         function swapExactTokensForETHSupportingFeeOnTransferTokens(
651             uint amountIn,
652             uint amountOutMin,
653             address[] calldata path,
654             address to,
655             uint deadline
656         ) external;
657     }
658 
659     // Contract implementation
660     contract MultiGenCapital is Context, IERC20, Ownable {
661         using SafeMath for uint256;
662         using Address for address;
663 
664         mapping (address => uint256) private _rOwned;
665         mapping (address => uint256) private _tOwned;
666         mapping (address => mapping (address => uint256)) private _allowances;
667 
668         mapping (address => bool) private _isExcludedFromFee;
669 
670         mapping (address => bool) private _isExcluded;
671         address[] private _excluded;
672 
673         uint256 private constant MAX = ~uint256(0);
674         uint256 private _tTotal = 1000000000000 * 10**9;
675         uint256 private _rTotal = (MAX - (MAX % _tTotal));
676         uint256 private _tFeeTotal;
677 
678         string private _name = 'MultiGenCapital';
679         string private _symbol = 'MGC';
680         uint8 private _decimals = 9;
681 
682         uint256 private _taxFee = 10;
683         uint256 private _teamFee = 15;
684         uint256 private _previousTaxFee = _taxFee;
685         uint256 private _previousTeamFee = _teamFee;
686 
687         address payable public _MGCWalletAddress;
688         address payable public _marketingWalletAddress;
689 
690         IUniswapV2Router02 public immutable uniswapV2Router;
691         address public immutable uniswapV2Pair;
692 
693         bool inSwap = false;
694         bool public swapEnabled = true;
695 
696         uint256 private _maxTxAmount = 100000000000000e9;
697         // We will set a minimum amount of tokens to be swaped => 5M
698         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
699 
700         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
701         event SwapEnabledUpdated(bool enabled);
702 
703         modifier lockTheSwap {
704             inSwap = true;
705             _;
706             inSwap = false;
707         }
708 
709         constructor (address payable MGCWalletAddress, address payable marketingWalletAddress) public {
710             _MGCWalletAddress = MGCWalletAddress;
711             _marketingWalletAddress = marketingWalletAddress;
712             _rOwned[_msgSender()] = _rTotal;
713 
714             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
715             // Create a uniswap pair for this new token
716             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
717                 .createPair(address(this), _uniswapV2Router.WETH());
718 
719             // set the rest of the contract variables
720             uniswapV2Router = _uniswapV2Router;
721 
722             // Exclude owner and this contract from fee
723             _isExcludedFromFee[owner()] = true;
724             _isExcludedFromFee[address(this)] = true;
725 
726             emit Transfer(address(0), _msgSender(), _tTotal);
727         }
728 
729         function name() public view returns (string memory) {
730             return _name;
731         }
732 
733         function symbol() public view returns (string memory) {
734             return _symbol;
735         }
736 
737         function decimals() public view returns (uint8) {
738             return _decimals;
739         }
740 
741         function totalSupply() public view override returns (uint256) {
742             return _tTotal;
743         }
744 
745         function balanceOf(address account) public view override returns (uint256) {
746             if (_isExcluded[account]) return _tOwned[account];
747             return tokenFromReflection(_rOwned[account]);
748         }
749 
750         function transfer(address recipient, uint256 amount) public override returns (bool) {
751             _transfer(_msgSender(), recipient, amount);
752             return true;
753         }
754 
755         function allowance(address owner, address spender) public view override returns (uint256) {
756             return _allowances[owner][spender];
757         }
758 
759         function approve(address spender, uint256 amount) public override returns (bool) {
760             _approve(_msgSender(), spender, amount);
761             return true;
762         }
763 
764         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
765             _transfer(sender, recipient, amount);
766             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
767             return true;
768         }
769 
770         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
771             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
772             return true;
773         }
774 
775         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
776             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
777             return true;
778         }
779 
780         function isExcluded(address account) public view returns (bool) {
781             return _isExcluded[account];
782         }
783 
784         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
785             _isExcludedFromFee[account] = excluded;
786         }
787 
788         function totalFees() public view returns (uint256) {
789             return _tFeeTotal;
790         }
791 
792         function deliver(uint256 tAmount) public {
793             address sender = _msgSender();
794             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
795             (uint256 rAmount,,,,,) = _getValues(tAmount);
796             _rOwned[sender] = _rOwned[sender].sub(rAmount);
797             _rTotal = _rTotal.sub(rAmount);
798             _tFeeTotal = _tFeeTotal.add(tAmount);
799         }
800 
801         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
802             require(tAmount <= _tTotal, "Amount must be less than supply");
803             if (!deductTransferFee) {
804                 (uint256 rAmount,,,,,) = _getValues(tAmount);
805                 return rAmount;
806             } else {
807                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
808                 return rTransferAmount;
809             }
810         }
811 
812         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
813             require(rAmount <= _rTotal, "Amount must be less than total reflections");
814             uint256 currentRate =  _getRate();
815             return rAmount.div(currentRate);
816         }
817 
818         function excludeAccount(address account) external onlyOwner() {
819             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
820             require(!_isExcluded[account], "Account is already excluded");
821             if(_rOwned[account] > 0) {
822                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
823             }
824             _isExcluded[account] = true;
825             _excluded.push(account);
826         }
827 
828         function includeAccount(address account) external onlyOwner() {
829             require(_isExcluded[account], "Account is already excluded");
830             for (uint256 i = 0; i < _excluded.length; i++) {
831                 if (_excluded[i] == account) {
832                     _excluded[i] = _excluded[_excluded.length - 1];
833                     _tOwned[account] = 0;
834                     _isExcluded[account] = false;
835                     _excluded.pop();
836                     break;
837                 }
838             }
839         }
840 
841         function removeAllFee() private {
842             if(_taxFee == 0 && _teamFee == 0) return;
843 
844             _previousTaxFee = _taxFee;
845             _previousTeamFee = _teamFee;
846 
847             _taxFee = 0;
848             _teamFee = 0;
849         }
850 
851         function restoreAllFee() private {
852             _taxFee = _previousTaxFee;
853             _teamFee = _previousTeamFee;
854         }
855 
856         function isExcludedFromFee(address account) public view returns(bool) {
857             return _isExcludedFromFee[account];
858         }
859 
860         function _approve(address owner, address spender, uint256 amount) private {
861             require(owner != address(0), "ERC20: approve from the zero address");
862             require(spender != address(0), "ERC20: approve to the zero address");
863 
864             _allowances[owner][spender] = amount;
865             emit Approval(owner, spender, amount);
866         }
867 
868         function _transfer(address sender, address recipient, uint256 amount) private {
869             require(sender != address(0), "ERC20: transfer from the zero address");
870             require(recipient != address(0), "ERC20: transfer to the zero address");
871             require(amount > 0, "Transfer amount must be greater than zero");
872 
873             if(sender != owner() && recipient != owner())
874                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
875 
876             // is the token balance of this contract address over the min number of
877             // tokens that we need to initiate a swap?
878             // also, don't get caught in a circular team event.
879             // also, don't swap if sender is uniswap pair.
880             uint256 contractTokenBalance = balanceOf(address(this));
881 
882             if(contractTokenBalance >= _maxTxAmount)
883             {
884                 contractTokenBalance = _maxTxAmount;
885             }
886 
887             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
888             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
889                 // We need to swap the current tokens to ETH and send to the team wallet
890                 swapTokensForEth(contractTokenBalance);
891 
892                 uint256 contractETHBalance = address(this).balance;
893                 if(contractETHBalance > 0) {
894                     sendETHToTeam(address(this).balance);
895                 }
896             }
897 
898             //indicates if fee should be deducted from transfer
899             bool takeFee = true;
900 
901             //if any account belongs to _isExcludedFromFee account then remove the fee
902             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
903                 takeFee = false;
904             }
905 
906             //transfer amount, it will take tax and team fee
907             _tokenTransfer(sender,recipient,amount,takeFee);
908         }
909 
910         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
911             // generate the uniswap pair path of token -> weth
912             address[] memory path = new address[](2);
913             path[0] = address(this);
914             path[1] = uniswapV2Router.WETH();
915 
916             _approve(address(this), address(uniswapV2Router), tokenAmount);
917 
918             // make the swap
919             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
920                 tokenAmount,
921                 0, // accept any amount of ETH
922                 path,
923                 address(this),
924                 block.timestamp
925             );
926         }
927 
928         function sendETHToTeam(uint256 amount) private {
929             _MGCWalletAddress.transfer(amount.div(2));
930             _marketingWalletAddress.transfer(amount.div(2));
931         }
932 
933         // We are exposing these functions to be able to manual swap and send
934         // in case the token is highly valued and 5M becomes too much
935         function manualSwap() external onlyOwner() {
936             uint256 contractBalance = balanceOf(address(this));
937             swapTokensForEth(contractBalance);
938         }
939 
940         function manualSend() external onlyOwner() {
941             uint256 contractETHBalance = address(this).balance;
942             sendETHToTeam(contractETHBalance);
943         }
944 
945         function setSwapEnabled(bool enabled) external onlyOwner(){
946             swapEnabled = enabled;
947         }
948 
949         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
950             if(!takeFee)
951                 removeAllFee();
952 
953             if (_isExcluded[sender] && !_isExcluded[recipient]) {
954                 _transferFromExcluded(sender, recipient, amount);
955             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
956                 _transferToExcluded(sender, recipient, amount);
957             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
958                 _transferStandard(sender, recipient, amount);
959             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
960                 _transferBothExcluded(sender, recipient, amount);
961             } else {
962                 _transferStandard(sender, recipient, amount);
963             }
964 
965             if(!takeFee)
966                 restoreAllFee();
967         }
968 
969         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
970             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
971             _rOwned[sender] = _rOwned[sender].sub(rAmount);
972             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
973             _takeTeam(tTeam);
974             _reflectFee(rFee, tFee);
975             emit Transfer(sender, recipient, tTransferAmount);
976         }
977 
978         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
979             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
980             _rOwned[sender] = _rOwned[sender].sub(rAmount);
981             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
982             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
983             _takeTeam(tTeam);
984             _reflectFee(rFee, tFee);
985             emit Transfer(sender, recipient, tTransferAmount);
986         }
987 
988         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
989             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
990             _tOwned[sender] = _tOwned[sender].sub(tAmount);
991             _rOwned[sender] = _rOwned[sender].sub(rAmount);
992             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
993             _takeTeam(tTeam);
994             _reflectFee(rFee, tFee);
995             emit Transfer(sender, recipient, tTransferAmount);
996         }
997 
998         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
999             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1000             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1001             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1002             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1003             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1004             _takeTeam(tTeam);
1005             _reflectFee(rFee, tFee);
1006             emit Transfer(sender, recipient, tTransferAmount);
1007         }
1008 
1009         function _takeTeam(uint256 tTeam) private {
1010             uint256 currentRate =  _getRate();
1011             uint256 rTeam = tTeam.mul(currentRate);
1012             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1013             if(_isExcluded[address(this)])
1014                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1015         }
1016 
1017         function _reflectFee(uint256 rFee, uint256 tFee) private {
1018             _rTotal = _rTotal.sub(rFee);
1019             _tFeeTotal = _tFeeTotal.add(tFee);
1020         }
1021 
1022          //to recieve ETH from uniswapV2Router when swaping
1023         receive() external payable {}
1024 
1025         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1026             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1027             uint256 currentRate =  _getRate();
1028             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1029             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1030         }
1031 
1032         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1033             uint256 tFee = tAmount.mul(taxFee).div(100);
1034             uint256 tTeam = tAmount.mul(teamFee).div(100);
1035             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1036             return (tTransferAmount, tFee, tTeam);
1037         }
1038 
1039         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1040             uint256 rAmount = tAmount.mul(currentRate);
1041             uint256 rFee = tFee.mul(currentRate);
1042             uint256 rTransferAmount = rAmount.sub(rFee);
1043             return (rAmount, rTransferAmount, rFee);
1044         }
1045 
1046         function _getRate() private view returns(uint256) {
1047             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1048             return rSupply.div(tSupply);
1049         }
1050 
1051         function _getCurrentSupply() private view returns(uint256, uint256) {
1052             uint256 rSupply = _rTotal;
1053             uint256 tSupply = _tTotal;
1054             for (uint256 i = 0; i < _excluded.length; i++) {
1055                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1056                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1057                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1058             }
1059             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1060             return (rSupply, tSupply);
1061         }
1062 
1063         function _getTaxFee() private view returns(uint256) {
1064             return _taxFee;
1065         }
1066 
1067         function _getMaxTxAmount() private view returns(uint256) {
1068             return _maxTxAmount;
1069         }
1070 
1071         function _getETHBalance() public view returns(uint256 balance) {
1072             return address(this).balance;
1073         }
1074 
1075         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1076             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1077             _taxFee = taxFee;
1078         }
1079 
1080         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1081             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1082             _teamFee = teamFee;
1083         }
1084 
1085         function _setMGCWallet(address payable MGCWalletAddress) external onlyOwner() {
1086             _MGCWalletAddress = MGCWalletAddress;
1087         }
1088 
1089         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1090             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1091             _maxTxAmount = maxTxAmount;
1092         }
1093     }