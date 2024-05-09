1 /**
2 Multi-Chain Capital: $MCC
3 -You buy on Ethereum, we farm on multiple chains and return the profits to $MCC holders.
4 
5 Tokenomics:
6 10% of each buy goes to existing holders.
7 10% of each sell goes into multi-chain farming to add to the treasury and buy back MCC tokens.
8 
9 Website:
10 https://multichaincapital.eth.link
11 
12 Telegram:
13 https://t.me/MultiChainCapital
14 
15 Twitter:
16 https://twitter.com/MChainCapital
17 
18 Medium:
19 https://multichaincapital.medium.com
20 */
21 
22 // SPDX-License-Identifier: Unlicensed
23 pragma solidity ^0.6.12;
24 
25     abstract contract Context {
26         function _msgSender() internal view virtual returns (address payable) {
27             return msg.sender;
28         }
29 
30         function _msgData() internal view virtual returns (bytes memory) {
31             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32             return msg.data;
33         }
34     }
35 
36     interface IERC20 {
37         /**
38         * @dev Returns the amount of tokens in existence.
39         */
40         function totalSupply() external view returns (uint256);
41 
42         /**
43         * @dev Returns the amount of tokens owned by `account`.
44         */
45         function balanceOf(address account) external view returns (uint256);
46 
47         /**
48         * @dev Moves `amount` tokens from the caller's account to `recipient`.
49         *
50         * Returns a boolean value indicating whether the operation succeeded.
51         *
52         * Emits a {Transfer} event.
53         */
54         function transfer(address recipient, uint256 amount) external returns (bool);
55 
56         /**
57         * @dev Returns the remaining number of tokens that `spender` will be
58         * allowed to spend on behalf of `owner` through {transferFrom}. This is
59         * zero by default.
60         *
61         * This value changes when {approve} or {transferFrom} are called.
62         */
63         function allowance(address owner, address spender) external view returns (uint256);
64 
65         /**
66         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67         *
68         * Returns a boolean value indicating whether the operation succeeded.
69         *
70         * IMPORTANT: Beware that changing an allowance with this method brings the risk
71         * that someone may use both the old and the new allowance by unfortunate
72         * transaction ordering. One possible solution to mitigate this race
73         * condition is to first reduce the spender's allowance to 0 and set the
74         * desired value afterwards:
75         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76         *
77         * Emits an {Approval} event.
78         */
79         function approve(address spender, uint256 amount) external returns (bool);
80 
81         /**
82         * @dev Moves `amount` tokens from `sender` to `recipient` using the
83         * allowance mechanism. `amount` is then deducted from the caller's
84         * allowance.
85         *
86         * Returns a boolean value indicating whether the operation succeeded.
87         *
88         * Emits a {Transfer} event.
89         */
90         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92         /**
93         * @dev Emitted when `value` tokens are moved from one account (`from`) to
94         * another (`to`).
95         *
96         * Note that `value` may be zero.
97         */
98         event Transfer(address indexed from, address indexed to, uint256 value);
99 
100         /**
101         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102         * a call to {approve}. `value` is the new allowance.
103         */
104         event Approval(address indexed owner, address indexed spender, uint256 value);
105     }
106 
107     library SafeMath {
108         /**
109         * @dev Returns the addition of two unsigned integers, reverting on
110         * overflow.
111         *
112         * Counterpart to Solidity's `+` operator.
113         *
114         * Requirements:
115         *
116         * - Addition cannot overflow.
117         */
118         function add(uint256 a, uint256 b) internal pure returns (uint256) {
119             uint256 c = a + b;
120             require(c >= a, "SafeMath: addition overflow");
121 
122             return c;
123         }
124 
125         /**
126         * @dev Returns the subtraction of two unsigned integers, reverting on
127         * overflow (when the result is negative).
128         *
129         * Counterpart to Solidity's `-` operator.
130         *
131         * Requirements:
132         *
133         * - Subtraction cannot overflow.
134         */
135         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136             return sub(a, b, "SafeMath: subtraction overflow");
137         }
138 
139         /**
140         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141         * overflow (when the result is negative).
142         *
143         * Counterpart to Solidity's `-` operator.
144         *
145         * Requirements:
146         *
147         * - Subtraction cannot overflow.
148         */
149         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150             require(b <= a, errorMessage);
151             uint256 c = a - b;
152 
153             return c;
154         }
155 
156         /**
157         * @dev Returns the multiplication of two unsigned integers, reverting on
158         * overflow.
159         *
160         * Counterpart to Solidity's `*` operator.
161         *
162         * Requirements:
163         *
164         * - Multiplication cannot overflow.
165         */
166         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168             // benefit is lost if 'b' is also tested.
169             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170             if (a == 0) {
171                 return 0;
172             }
173 
174             uint256 c = a * b;
175             require(c / a == b, "SafeMath: multiplication overflow");
176 
177             return c;
178         }
179 
180         /**
181         * @dev Returns the integer division of two unsigned integers. Reverts on
182         * division by zero. The result is rounded towards zero.
183         *
184         * Counterpart to Solidity's `/` operator. Note: this function uses a
185         * `revert` opcode (which leaves remaining gas untouched) while Solidity
186         * uses an invalid opcode to revert (consuming all remaining gas).
187         *
188         * Requirements:
189         *
190         * - The divisor cannot be zero.
191         */
192         function div(uint256 a, uint256 b) internal pure returns (uint256) {
193             return div(a, b, "SafeMath: division by zero");
194         }
195 
196         /**
197         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198         * division by zero. The result is rounded towards zero.
199         *
200         * Counterpart to Solidity's `/` operator. Note: this function uses a
201         * `revert` opcode (which leaves remaining gas untouched) while Solidity
202         * uses an invalid opcode to revert (consuming all remaining gas).
203         *
204         * Requirements:
205         *
206         * - The divisor cannot be zero.
207         */
208         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209             require(b > 0, errorMessage);
210             uint256 c = a / b;
211             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213             return c;
214         }
215 
216         /**
217         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218         * Reverts when dividing by zero.
219         *
220         * Counterpart to Solidity's `%` operator. This function uses a `revert`
221         * opcode (which leaves remaining gas untouched) while Solidity uses an
222         * invalid opcode to revert (consuming all remaining gas).
223         *
224         * Requirements:
225         *
226         * - The divisor cannot be zero.
227         */
228         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229             return mod(a, b, "SafeMath: modulo by zero");
230         }
231 
232         /**
233         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234         * Reverts with custom message when dividing by zero.
235         *
236         * Counterpart to Solidity's `%` operator. This function uses a `revert`
237         * opcode (which leaves remaining gas untouched) while Solidity uses an
238         * invalid opcode to revert (consuming all remaining gas).
239         *
240         * Requirements:
241         *
242         * - The divisor cannot be zero.
243         */
244         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245             require(b != 0, errorMessage);
246             return a % b;
247         }
248     }
249 
250     library Address {
251         /**
252         * @dev Returns true if `account` is a contract.
253         *
254         * [IMPORTANT]
255         * ====
256         * It is unsafe to assume that an address for which this function returns
257         * false is an externally-owned account (EOA) and not a contract.
258         *
259         * Among others, `isContract` will return false for the following
260         * types of addresses:
261         *
262         *  - an externally-owned account
263         *  - a contract in construction
264         *  - an address where a contract will be created
265         *  - an address where a contract lived, but was destroyed
266         * ====
267         */
268         function isContract(address account) internal view returns (bool) {
269             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271             // for accounts without code, i.e. `keccak256('')`
272             bytes32 codehash;
273             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274             // solhint-disable-next-line no-inline-assembly
275             assembly { codehash := extcodehash(account) }
276             return (codehash != accountHash && codehash != 0x0);
277         }
278 
279         /**
280         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281         * `recipient`, forwarding all available gas and reverting on errors.
282         *
283         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284         * of certain opcodes, possibly making contracts go over the 2300 gas limit
285         * imposed by `transfer`, making them unable to receive funds via
286         * `transfer`. {sendValue} removes this limitation.
287         *
288         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289         *
290         * IMPORTANT: because control is transferred to `recipient`, care must be
291         * taken to not create reentrancy vulnerabilities. Consider using
292         * {ReentrancyGuard} or the
293         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294         */
295         function sendValue(address payable recipient, uint256 amount) internal {
296             require(address(this).balance >= amount, "Address: insufficient balance");
297 
298             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299             (bool success, ) = recipient.call{ value: amount }("");
300             require(success, "Address: unable to send value, recipient may have reverted");
301         }
302 
303         /**
304         * @dev Performs a Solidity function call using a low level `call`. A
305         * plain`call` is an unsafe replacement for a function call: use this
306         * function instead.
307         *
308         * If `target` reverts with a revert reason, it is bubbled up by this
309         * function (like regular Solidity function calls).
310         *
311         * Returns the raw returned data. To convert to the expected return value,
312         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313         *
314         * Requirements:
315         *
316         * - `target` must be a contract.
317         * - calling `target` with `data` must not revert.
318         *
319         * _Available since v3.1._
320         */
321         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionCall(target, data, "Address: low-level call failed");
323         }
324 
325         /**
326         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327         * `errorMessage` as a fallback revert reason when `target` reverts.
328         *
329         * _Available since v3.1._
330         */
331         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332             return _functionCallWithValue(target, data, 0, errorMessage);
333         }
334 
335         /**
336         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337         * but also transferring `value` wei to `target`.
338         *
339         * Requirements:
340         *
341         * - the calling contract must have an ETH balance of at least `value`.
342         * - the called Solidity function must be `payable`.
343         *
344         * _Available since v3.1._
345         */
346         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348         }
349 
350         /**
351         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352         * with `errorMessage` as a fallback revert reason when `target` reverts.
353         *
354         * _Available since v3.1._
355         */
356         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357             require(address(this).balance >= value, "Address: insufficient balance for call");
358             return _functionCallWithValue(target, data, value, errorMessage);
359         }
360 
361         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362             require(isContract(target), "Address: call to non-contract");
363 
364             // solhint-disable-next-line avoid-low-level-calls
365             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366             if (success) {
367                 return returndata;
368             } else {
369                 // Look for revert reason and bubble it up if present
370                 if (returndata.length > 0) {
371                     // The easiest way to bubble the revert reason is using memory via assembly
372 
373                     // solhint-disable-next-line no-inline-assembly
374                     assembly {
375                         let returndata_size := mload(returndata)
376                         revert(add(32, returndata), returndata_size)
377                     }
378                 } else {
379                     revert(errorMessage);
380                 }
381             }
382         }
383     }
384 
385     contract Ownable is Context {
386         address private _owner;
387         address private _previousOwner;
388         uint256 private _lockTime;
389 
390         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
391 
392         /**
393         * @dev Initializes the contract setting the deployer as the initial owner.
394         */
395         constructor () internal {
396             address msgSender = _msgSender();
397             _owner = msgSender;
398             emit OwnershipTransferred(address(0), msgSender);
399         }
400 
401         /**
402         * @dev Returns the address of the current owner.
403         */
404         function owner() public view returns (address) {
405             return _owner;
406         }
407 
408         /**
409         * @dev Throws if called by any account other than the owner.
410         */
411         modifier onlyOwner() {
412             require(_owner == _msgSender(), "Ownable: caller is not the owner");
413             _;
414         }
415 
416         /**
417         * @dev Leaves the contract without owner. It will not be possible to call
418         * `onlyOwner` functions anymore. Can only be called by the current owner.
419         *
420         * NOTE: Renouncing ownership will leave the contract without an owner,
421         * thereby removing any functionality that is only available to the owner.
422         */
423         function renounceOwnership() public virtual onlyOwner {
424             emit OwnershipTransferred(_owner, address(0));
425             _owner = address(0);
426         }
427 
428         /**
429         * @dev Transfers ownership of the contract to a new account (`newOwner`).
430         * Can only be called by the current owner.
431         */
432         function transferOwnership(address newOwner) public virtual onlyOwner {
433             require(newOwner != address(0), "Ownable: new owner is the zero address");
434             emit OwnershipTransferred(_owner, newOwner);
435             _owner = newOwner;
436         }
437 
438         function geUnlockTime() public view returns (uint256) {
439             return _lockTime;
440         }
441 
442         //Locks the contract for owner for the amount of time provided
443         function lock(uint256 time) public virtual onlyOwner {
444             _previousOwner = _owner;
445             _owner = address(0);
446             _lockTime = now + time;
447             emit OwnershipTransferred(_owner, address(0));
448         }
449 
450         //Unlocks the contract for owner when _lockTime is exceeds
451         function unlock() public virtual {
452             require(_previousOwner == msg.sender, "You don't have permission to unlock");
453             require(now > _lockTime , "Contract is locked until 7 days");
454             emit OwnershipTransferred(_owner, _previousOwner);
455             _owner = _previousOwner;
456         }
457     }
458 
459     interface IUniswapV2Factory {
460         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
461 
462         function feeTo() external view returns (address);
463         function feeToSetter() external view returns (address);
464 
465         function getPair(address tokenA, address tokenB) external view returns (address pair);
466         function allPairs(uint) external view returns (address pair);
467         function allPairsLength() external view returns (uint);
468 
469         function createPair(address tokenA, address tokenB) external returns (address pair);
470 
471         function setFeeTo(address) external;
472         function setFeeToSetter(address) external;
473     }
474 
475     interface IUniswapV2Pair {
476         event Approval(address indexed owner, address indexed spender, uint value);
477         event Transfer(address indexed from, address indexed to, uint value);
478 
479         function name() external pure returns (string memory);
480         function symbol() external pure returns (string memory);
481         function decimals() external pure returns (uint8);
482         function totalSupply() external view returns (uint);
483         function balanceOf(address owner) external view returns (uint);
484         function allowance(address owner, address spender) external view returns (uint);
485 
486         function approve(address spender, uint value) external returns (bool);
487         function transfer(address to, uint value) external returns (bool);
488         function transferFrom(address from, address to, uint value) external returns (bool);
489 
490         function DOMAIN_SEPARATOR() external view returns (bytes32);
491         function PERMIT_TYPEHASH() external pure returns (bytes32);
492         function nonces(address owner) external view returns (uint);
493 
494         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
495 
496         event Mint(address indexed sender, uint amount0, uint amount1);
497         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
498         event Swap(
499             address indexed sender,
500             uint amount0In,
501             uint amount1In,
502             uint amount0Out,
503             uint amount1Out,
504             address indexed to
505         );
506         event Sync(uint112 reserve0, uint112 reserve1);
507 
508         function MINIMUM_LIQUIDITY() external pure returns (uint);
509         function factory() external view returns (address);
510         function token0() external view returns (address);
511         function token1() external view returns (address);
512         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
513         function price0CumulativeLast() external view returns (uint);
514         function price1CumulativeLast() external view returns (uint);
515         function kLast() external view returns (uint);
516 
517         function mint(address to) external returns (uint liquidity);
518         function burn(address to) external returns (uint amount0, uint amount1);
519         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
520         function skim(address to) external;
521         function sync() external;
522 
523         function initialize(address, address) external;
524     }
525 
526     interface IUniswapV2Router01 {
527         function factory() external pure returns (address);
528         function WETH() external pure returns (address);
529 
530         function addLiquidity(
531             address tokenA,
532             address tokenB,
533             uint amountADesired,
534             uint amountBDesired,
535             uint amountAMin,
536             uint amountBMin,
537             address to,
538             uint deadline
539         ) external returns (uint amountA, uint amountB, uint liquidity);
540         function addLiquidityETH(
541             address token,
542             uint amountTokenDesired,
543             uint amountTokenMin,
544             uint amountETHMin,
545             address to,
546             uint deadline
547         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
548         function removeLiquidity(
549             address tokenA,
550             address tokenB,
551             uint liquidity,
552             uint amountAMin,
553             uint amountBMin,
554             address to,
555             uint deadline
556         ) external returns (uint amountA, uint amountB);
557         function removeLiquidityETH(
558             address token,
559             uint liquidity,
560             uint amountTokenMin,
561             uint amountETHMin,
562             address to,
563             uint deadline
564         ) external returns (uint amountToken, uint amountETH);
565         function removeLiquidityWithPermit(
566             address tokenA,
567             address tokenB,
568             uint liquidity,
569             uint amountAMin,
570             uint amountBMin,
571             address to,
572             uint deadline,
573             bool approveMax, uint8 v, bytes32 r, bytes32 s
574         ) external returns (uint amountA, uint amountB);
575         function removeLiquidityETHWithPermit(
576             address token,
577             uint liquidity,
578             uint amountTokenMin,
579             uint amountETHMin,
580             address to,
581             uint deadline,
582             bool approveMax, uint8 v, bytes32 r, bytes32 s
583         ) external returns (uint amountToken, uint amountETH);
584         function swapExactTokensForTokens(
585             uint amountIn,
586             uint amountOutMin,
587             address[] calldata path,
588             address to,
589             uint deadline
590         ) external returns (uint[] memory amounts);
591         function swapTokensForExactTokens(
592             uint amountOut,
593             uint amountInMax,
594             address[] calldata path,
595             address to,
596             uint deadline
597         ) external returns (uint[] memory amounts);
598         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
599             external
600             payable
601             returns (uint[] memory amounts);
602         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
603             external
604             returns (uint[] memory amounts);
605         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
606             external
607             returns (uint[] memory amounts);
608         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
609             external
610             payable
611             returns (uint[] memory amounts);
612 
613         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
614         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
615         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
616         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
617         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
618     }
619 
620     interface IUniswapV2Router02 is IUniswapV2Router01 {
621         function removeLiquidityETHSupportingFeeOnTransferTokens(
622             address token,
623             uint liquidity,
624             uint amountTokenMin,
625             uint amountETHMin,
626             address to,
627             uint deadline
628         ) external returns (uint amountETH);
629         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
630             address token,
631             uint liquidity,
632             uint amountTokenMin,
633             uint amountETHMin,
634             address to,
635             uint deadline,
636             bool approveMax, uint8 v, bytes32 r, bytes32 s
637         ) external returns (uint amountETH);
638 
639         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
640             uint amountIn,
641             uint amountOutMin,
642             address[] calldata path,
643             address to,
644             uint deadline
645         ) external;
646         function swapExactETHForTokensSupportingFeeOnTransferTokens(
647             uint amountOutMin,
648             address[] calldata path,
649             address to,
650             uint deadline
651         ) external payable;
652         function swapExactTokensForETHSupportingFeeOnTransferTokens(
653             uint amountIn,
654             uint amountOutMin,
655             address[] calldata path,
656             address to,
657             uint deadline
658         ) external;
659     }
660 
661     // Contract implementation
662     contract MultiChainCapital is Context, IERC20, Ownable {
663         using SafeMath for uint256;
664         using Address for address;
665 
666         mapping (address => uint256) private _rOwned;
667         mapping (address => uint256) private _tOwned;
668         mapping (address => mapping (address => uint256)) private _allowances;
669 
670         mapping (address => bool) private _isExcludedFromFee;
671 
672         mapping (address => bool) private _isExcluded;
673         address[] private _excluded;
674 
675         uint256 private constant MAX = ~uint256(0);
676         uint256 private _tTotal = 1000000000000 * 10**9;
677         uint256 private _rTotal = (MAX - (MAX % _tTotal));
678         uint256 private _tFeeTotal;
679 
680         string private _name = 'MultiChainCapital';
681         string private _symbol = 'MCC';
682         uint8 private _decimals = 9;
683 
684         uint256 private _taxFee = 10;
685         uint256 private _teamFee = 10;
686         uint256 private _previousTaxFee = _taxFee;
687         uint256 private _previousTeamFee = _teamFee;
688 
689         address payable public _MCCWalletAddress;
690         address payable public _marketingWalletAddress;
691 
692         IUniswapV2Router02 public immutable uniswapV2Router;
693         address public immutable uniswapV2Pair;
694 
695         bool inSwap = false;
696         bool public swapEnabled = true;
697 
698         uint256 private _maxTxAmount = 100000000000000e9;
699         // We will set a minimum amount of tokens to be swaped => 5M
700         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
701 
702         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
703         event SwapEnabledUpdated(bool enabled);
704 
705         modifier lockTheSwap {
706             inSwap = true;
707             _;
708             inSwap = false;
709         }
710 
711         constructor (address payable MCCWalletAddress, address payable marketingWalletAddress) public {
712             _MCCWalletAddress = MCCWalletAddress;
713             _marketingWalletAddress = marketingWalletAddress;
714             _rOwned[_msgSender()] = _rTotal;
715 
716             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
717             // Create a uniswap pair for this new token
718             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
719                 .createPair(address(this), _uniswapV2Router.WETH());
720 
721             // set the rest of the contract variables
722             uniswapV2Router = _uniswapV2Router;
723 
724             // Exclude owner and this contract from fee
725             _isExcludedFromFee[owner()] = true;
726             _isExcludedFromFee[address(this)] = true;
727 
728             emit Transfer(address(0), _msgSender(), _tTotal);
729         }
730 
731         function name() public view returns (string memory) {
732             return _name;
733         }
734 
735         function symbol() public view returns (string memory) {
736             return _symbol;
737         }
738 
739         function decimals() public view returns (uint8) {
740             return _decimals;
741         }
742 
743         function totalSupply() public view override returns (uint256) {
744             return _tTotal;
745         }
746 
747         function balanceOf(address account) public view override returns (uint256) {
748             if (_isExcluded[account]) return _tOwned[account];
749             return tokenFromReflection(_rOwned[account]);
750         }
751 
752         function transfer(address recipient, uint256 amount) public override returns (bool) {
753             _transfer(_msgSender(), recipient, amount);
754             return true;
755         }
756 
757         function allowance(address owner, address spender) public view override returns (uint256) {
758             return _allowances[owner][spender];
759         }
760 
761         function approve(address spender, uint256 amount) public override returns (bool) {
762             _approve(_msgSender(), spender, amount);
763             return true;
764         }
765 
766         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
767             _transfer(sender, recipient, amount);
768             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
769             return true;
770         }
771 
772         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
773             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
774             return true;
775         }
776 
777         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
778             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
779             return true;
780         }
781 
782         function isExcluded(address account) public view returns (bool) {
783             return _isExcluded[account];
784         }
785 
786         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
787             _isExcludedFromFee[account] = excluded;
788         }
789 
790         function totalFees() public view returns (uint256) {
791             return _tFeeTotal;
792         }
793 
794         function deliver(uint256 tAmount) public {
795             address sender = _msgSender();
796             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
797             (uint256 rAmount,,,,,) = _getValues(tAmount);
798             _rOwned[sender] = _rOwned[sender].sub(rAmount);
799             _rTotal = _rTotal.sub(rAmount);
800             _tFeeTotal = _tFeeTotal.add(tAmount);
801         }
802 
803         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
804             require(tAmount <= _tTotal, "Amount must be less than supply");
805             if (!deductTransferFee) {
806                 (uint256 rAmount,,,,,) = _getValues(tAmount);
807                 return rAmount;
808             } else {
809                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
810                 return rTransferAmount;
811             }
812         }
813 
814         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
815             require(rAmount <= _rTotal, "Amount must be less than total reflections");
816             uint256 currentRate =  _getRate();
817             return rAmount.div(currentRate);
818         }
819 
820         function excludeAccount(address account) external onlyOwner() {
821             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
822             require(!_isExcluded[account], "Account is already excluded");
823             if(_rOwned[account] > 0) {
824                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
825             }
826             _isExcluded[account] = true;
827             _excluded.push(account);
828         }
829 
830         function includeAccount(address account) external onlyOwner() {
831             require(_isExcluded[account], "Account is already excluded");
832             for (uint256 i = 0; i < _excluded.length; i++) {
833                 if (_excluded[i] == account) {
834                     _excluded[i] = _excluded[_excluded.length - 1];
835                     _tOwned[account] = 0;
836                     _isExcluded[account] = false;
837                     _excluded.pop();
838                     break;
839                 }
840             }
841         }
842 
843         function removeAllFee() private {
844             if(_taxFee == 0 && _teamFee == 0) return;
845 
846             _previousTaxFee = _taxFee;
847             _previousTeamFee = _teamFee;
848 
849             _taxFee = 0;
850             _teamFee = 0;
851         }
852 
853         function restoreAllFee() private {
854             _taxFee = _previousTaxFee;
855             _teamFee = _previousTeamFee;
856         }
857 
858         function isExcludedFromFee(address account) public view returns(bool) {
859             return _isExcludedFromFee[account];
860         }
861 
862         function _approve(address owner, address spender, uint256 amount) private {
863             require(owner != address(0), "ERC20: approve from the zero address");
864             require(spender != address(0), "ERC20: approve to the zero address");
865 
866             _allowances[owner][spender] = amount;
867             emit Approval(owner, spender, amount);
868         }
869 
870         function _transfer(address sender, address recipient, uint256 amount) private {
871             require(sender != address(0), "ERC20: transfer from the zero address");
872             require(recipient != address(0), "ERC20: transfer to the zero address");
873             require(amount > 0, "Transfer amount must be greater than zero");
874 
875             if(sender != owner() && recipient != owner())
876                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
877 
878             // is the token balance of this contract address over the min number of
879             // tokens that we need to initiate a swap?
880             // also, don't get caught in a circular team event.
881             // also, don't swap if sender is uniswap pair.
882             uint256 contractTokenBalance = balanceOf(address(this));
883 
884             if(contractTokenBalance >= _maxTxAmount)
885             {
886                 contractTokenBalance = _maxTxAmount;
887             }
888 
889             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
890             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
891                 // We need to swap the current tokens to ETH and send to the team wallet
892                 swapTokensForEth(contractTokenBalance);
893 
894                 uint256 contractETHBalance = address(this).balance;
895                 if(contractETHBalance > 0) {
896                     sendETHToTeam(address(this).balance);
897                 }
898             }
899 
900             //indicates if fee should be deducted from transfer
901             bool takeFee = true;
902 
903             //if any account belongs to _isExcludedFromFee account then remove the fee
904             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
905                 takeFee = false;
906             }
907 
908             //transfer amount, it will take tax and team fee
909             _tokenTransfer(sender,recipient,amount,takeFee);
910         }
911 
912         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
913             // generate the uniswap pair path of token -> weth
914             address[] memory path = new address[](2);
915             path[0] = address(this);
916             path[1] = uniswapV2Router.WETH();
917 
918             _approve(address(this), address(uniswapV2Router), tokenAmount);
919 
920             // make the swap
921             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
922                 tokenAmount,
923                 0, // accept any amount of ETH
924                 path,
925                 address(this),
926                 block.timestamp
927             );
928         }
929 
930         function sendETHToTeam(uint256 amount) private {
931             _MCCWalletAddress.transfer(amount.div(2));
932             _marketingWalletAddress.transfer(amount.div(2));
933         }
934 
935         // We are exposing these functions to be able to manual swap and send
936         // in case the token is highly valued and 5M becomes too much
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
1028             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1029             uint256 currentRate =  _getRate();
1030             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1031             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1032         }
1033 
1034         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1035             uint256 tFee = tAmount.mul(taxFee).div(100);
1036             uint256 tTeam = tAmount.mul(teamFee).div(100);
1037             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1038             return (tTransferAmount, tFee, tTeam);
1039         }
1040 
1041         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1042             uint256 rAmount = tAmount.mul(currentRate);
1043             uint256 rFee = tFee.mul(currentRate);
1044             uint256 rTransferAmount = rAmount.sub(rFee);
1045             return (rAmount, rTransferAmount, rFee);
1046         }
1047 
1048         function _getRate() private view returns(uint256) {
1049             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1050             return rSupply.div(tSupply);
1051         }
1052 
1053         function _getCurrentSupply() private view returns(uint256, uint256) {
1054             uint256 rSupply = _rTotal;
1055             uint256 tSupply = _tTotal;
1056             for (uint256 i = 0; i < _excluded.length; i++) {
1057                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1058                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1059                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1060             }
1061             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1062             return (rSupply, tSupply);
1063         }
1064 
1065         function _getTaxFee() private view returns(uint256) {
1066             return _taxFee;
1067         }
1068 
1069         function _getMaxTxAmount() private view returns(uint256) {
1070             return _maxTxAmount;
1071         }
1072 
1073         function _getETHBalance() public view returns(uint256 balance) {
1074             return address(this).balance;
1075         }
1076 
1077         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1078             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1079             _taxFee = taxFee;
1080         }
1081 
1082         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1083             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1084             _teamFee = teamFee;
1085         }
1086 
1087         function _setMCCWallet(address payable MCCWalletAddress) external onlyOwner() {
1088             _MCCWalletAddress = MCCWalletAddress;
1089         }
1090 
1091         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1092             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1093             _maxTxAmount = maxTxAmount;
1094         }
1095     }