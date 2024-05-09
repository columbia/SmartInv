1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-25
3 */
4 
5 /**
6 MultiBlockCapital : $MBC 
7 -Buy on ETH network and we will farm and return profits to $MBC holders. We are an aggressive $MCC fork and have 15% sell fee.
8 
9 Telegram: https://t.me/MultiBlockCapital
10 
11 
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.6.12;
16 
17     abstract contract Context {
18         function _msgSender() internal view virtual returns (address payable) {
19             return msg.sender;
20         }
21 
22         function _msgData() internal view virtual returns (bytes memory) {
23             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24             return msg.data;
25         }
26     }
27 
28     interface IERC20 {
29         /**
30         * @dev Returns the amount of tokens in existence.
31         */
32         function totalSupply() external view returns (uint256);
33 
34         /**
35         * @dev Returns the amount of tokens owned by `account`.
36         */
37         function balanceOf(address account) external view returns (uint256);
38 
39         /**
40         * @dev Moves `amount` tokens from the caller's account to `recipient`.
41         *
42         * Returns a boolean value indicating whether the operation succeeded.
43         *
44         * Emits a {Transfer} event.
45         */
46         function transfer(address recipient, uint256 amount) external returns (bool);
47 
48         /**
49         * @dev Returns the remaining number of tokens that `spender` will be
50         * allowed to spend on behalf of `owner` through {transferFrom}. This is
51         * zero by default.
52         *
53         * This value changes when {approve} or {transferFrom} are called.
54         */
55         function allowance(address owner, address spender) external view returns (uint256);
56 
57         /**
58         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59         *
60         * Returns a boolean value indicating whether the operation succeeded.
61         *
62         * IMPORTANT: Beware that changing an allowance with this method brings the risk
63         * that someone may use both the old and the new allowance by unfortunate
64         * transaction ordering. One possible solution to mitigate this race
65         * condition is to first reduce the spender's allowance to 0 and set the
66         * desired value afterwards:
67         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68         *
69         * Emits an {Approval} event.
70         */
71         function approve(address spender, uint256 amount) external returns (bool);
72 
73         /**
74         * @dev Moves `amount` tokens from `sender` to `recipient` using the
75         * allowance mechanism. `amount` is then deducted from the caller's
76         * allowance.
77         *
78         * Returns a boolean value indicating whether the operation succeeded.
79         *
80         * Emits a {Transfer} event.
81         */
82         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84         /**
85         * @dev Emitted when `value` tokens are moved from one account (`from`) to
86         * another (`to`).
87         *
88         * Note that `value` may be zero.
89         */
90         event Transfer(address indexed from, address indexed to, uint256 value);
91 
92         /**
93         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94         * a call to {approve}. `value` is the new allowance.
95         */
96         event Approval(address indexed owner, address indexed spender, uint256 value);
97     }
98 
99     library SafeMath {
100         /**
101         * @dev Returns the addition of two unsigned integers, reverting on
102         * overflow.
103         *
104         * Counterpart to Solidity's `+` operator.
105         *
106         * Requirements:
107         *
108         * - Addition cannot overflow.
109         */
110         function add(uint256 a, uint256 b) internal pure returns (uint256) {
111             uint256 c = a + b;
112             require(c >= a, "SafeMath: addition overflow");
113 
114             return c;
115         }
116 
117         /**
118         * @dev Returns the subtraction of two unsigned integers, reverting on
119         * overflow (when the result is negative).
120         *
121         * Counterpart to Solidity's `-` operator.
122         *
123         * Requirements:
124         *
125         * - Subtraction cannot overflow.
126         */
127         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128             return sub(a, b, "SafeMath: subtraction overflow");
129         }
130 
131         /**
132         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
133         * overflow (when the result is negative).
134         *
135         * Counterpart to Solidity's `-` operator.
136         *
137         * Requirements:
138         *
139         * - Subtraction cannot overflow.
140         */
141         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142             require(b <= a, errorMessage);
143             uint256 c = a - b;
144 
145             return c;
146         }
147 
148         /**
149         * @dev Returns the multiplication of two unsigned integers, reverting on
150         * overflow.
151         *
152         * Counterpart to Solidity's `*` operator.
153         *
154         * Requirements:
155         *
156         * - Multiplication cannot overflow.
157         */
158         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
159             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160             // benefit is lost if 'b' is also tested.
161             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162             if (a == 0) {
163                 return 0;
164             }
165 
166             uint256 c = a * b;
167             require(c / a == b, "SafeMath: multiplication overflow");
168 
169             return c;
170         }
171 
172         /**
173         * @dev Returns the integer division of two unsigned integers. Reverts on
174         * division by zero. The result is rounded towards zero.
175         *
176         * Counterpart to Solidity's `/` operator. Note: this function uses a
177         * `revert` opcode (which leaves remaining gas untouched) while Solidity
178         * uses an invalid opcode to revert (consuming all remaining gas).
179         *
180         * Requirements:
181         *
182         * - The divisor cannot be zero.
183         */
184         function div(uint256 a, uint256 b) internal pure returns (uint256) {
185             return div(a, b, "SafeMath: division by zero");
186         }
187 
188         /**
189         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190         * division by zero. The result is rounded towards zero.
191         *
192         * Counterpart to Solidity's `/` operator. Note: this function uses a
193         * `revert` opcode (which leaves remaining gas untouched) while Solidity
194         * uses an invalid opcode to revert (consuming all remaining gas).
195         *
196         * Requirements:
197         *
198         * - The divisor cannot be zero.
199         */
200         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201             require(b > 0, errorMessage);
202             uint256 c = a / b;
203             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204 
205             return c;
206         }
207 
208         /**
209         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210         * Reverts when dividing by zero.
211         *
212         * Counterpart to Solidity's `%` operator. This function uses a `revert`
213         * opcode (which leaves remaining gas untouched) while Solidity uses an
214         * invalid opcode to revert (consuming all remaining gas).
215         *
216         * Requirements:
217         *
218         * - The divisor cannot be zero.
219         */
220         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221             return mod(a, b, "SafeMath: modulo by zero");
222         }
223 
224         /**
225         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226         * Reverts with custom message when dividing by zero.
227         *
228         * Counterpart to Solidity's `%` operator. This function uses a `revert`
229         * opcode (which leaves remaining gas untouched) while Solidity uses an
230         * invalid opcode to revert (consuming all remaining gas).
231         *
232         * Requirements:
233         *
234         * - The divisor cannot be zero.
235         */
236         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237             require(b != 0, errorMessage);
238             return a % b;
239         }
240     }
241 
242     library Address {
243         /**
244         * @dev Returns true if `account` is a contract.
245         *
246         * [IMPORTANT]
247         * ====
248         * It is unsafe to assume that an address for which this function returns
249         * false is an externally-owned account (EOA) and not a contract.
250         *
251         * Among others, `isContract` will return false for the following
252         * types of addresses:
253         *
254         *  - an externally-owned account
255         *  - a contract in construction
256         *  - an address where a contract will be created
257         *  - an address where a contract lived, but was destroyed
258         * ====
259         */
260         function isContract(address account) internal view returns (bool) {
261             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
262             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
263             // for accounts without code, i.e. `keccak256('')`
264             bytes32 codehash;
265             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
266             // solhint-disable-next-line no-inline-assembly
267             assembly { codehash := extcodehash(account) }
268             return (codehash != accountHash && codehash != 0x0);
269         }
270 
271         /**
272         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273         * `recipient`, forwarding all available gas and reverting on errors.
274         *
275         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276         * of certain opcodes, possibly making contracts go over the 2300 gas limit
277         * imposed by `transfer`, making them unable to receive funds via
278         * `transfer`. {sendValue} removes this limitation.
279         *
280         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281         *
282         * IMPORTANT: because control is transferred to `recipient`, care must be
283         * taken to not create reentrancy vulnerabilities. Consider using
284         * {ReentrancyGuard} or the
285         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286         */
287         function sendValue(address payable recipient, uint256 amount) internal {
288             require(address(this).balance >= amount, "Address: insufficient balance");
289 
290             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
291             (bool success, ) = recipient.call{ value: amount }("");
292             require(success, "Address: unable to send value, recipient may have reverted");
293         }
294 
295         /**
296         * @dev Performs a Solidity function call using a low level `call`. A
297         * plain`call` is an unsafe replacement for a function call: use this
298         * function instead.
299         *
300         * If `target` reverts with a revert reason, it is bubbled up by this
301         * function (like regular Solidity function calls).
302         *
303         * Returns the raw returned data. To convert to the expected return value,
304         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305         *
306         * Requirements:
307         *
308         * - `target` must be a contract.
309         * - calling `target` with `data` must not revert.
310         *
311         * _Available since v3.1._
312         */
313         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315         }
316 
317         /**
318         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319         * `errorMessage` as a fallback revert reason when `target` reverts.
320         *
321         * _Available since v3.1._
322         */
323         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
324             return _functionCallWithValue(target, data, 0, errorMessage);
325         }
326 
327         /**
328         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329         * but also transferring `value` wei to `target`.
330         *
331         * Requirements:
332         *
333         * - the calling contract must have an ETH balance of at least `value`.
334         * - the called Solidity function must be `payable`.
335         *
336         * _Available since v3.1._
337         */
338         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
339             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
340         }
341 
342         /**
343         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
344         * with `errorMessage` as a fallback revert reason when `target` reverts.
345         *
346         * _Available since v3.1._
347         */
348         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
349             require(address(this).balance >= value, "Address: insufficient balance for call");
350             return _functionCallWithValue(target, data, value, errorMessage);
351         }
352 
353         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
354             require(isContract(target), "Address: call to non-contract");
355 
356             // solhint-disable-next-line avoid-low-level-calls
357             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
358             if (success) {
359                 return returndata;
360             } else {
361                 // Look for revert reason and bubble it up if present
362                 if (returndata.length > 0) {
363                     // The easiest way to bubble the revert reason is using memory via assembly
364 
365                     // solhint-disable-next-line no-inline-assembly
366                     assembly {
367                         let returndata_size := mload(returndata)
368                         revert(add(32, returndata), returndata_size)
369                     }
370                 } else {
371                     revert(errorMessage);
372                 }
373             }
374         }
375     }
376 
377     contract Ownable is Context {
378         address private _owner;
379         address private _previousOwner;
380         uint256 private _lockTime;
381 
382         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
383 
384         /**
385         * @dev Initializes the contract setting the deployer as the initial owner.
386         */
387         constructor () internal {
388             address msgSender = _msgSender();
389             _owner = msgSender;
390             emit OwnershipTransferred(address(0), msgSender);
391         }
392 
393         /**
394         * @dev Returns the address of the current owner.
395         */
396         function owner() public view returns (address) {
397             return _owner;
398         }
399 
400         /**
401         * @dev Throws if called by any account other than the owner.
402         */
403         modifier onlyOwner() {
404             require(_owner == _msgSender(), "Ownable: caller is not the owner");
405             _;
406         }
407 
408         /**
409         * @dev Leaves the contract without owner. It will not be possible to call
410         * `onlyOwner` functions anymore. Can only be called by the current owner.
411         *
412         * NOTE: Renouncing ownership will leave the contract without an owner,
413         * thereby removing any functionality that is only available to the owner.
414         */
415         function renounceOwnership() public virtual onlyOwner {
416             emit OwnershipTransferred(_owner, address(0));
417             _owner = address(0);
418         }
419 
420         /**
421         * @dev Transfers ownership of the contract to a new account (`newOwner`).
422         * Can only be called by the current owner.
423         */
424         function transferOwnership(address newOwner) public virtual onlyOwner {
425             require(newOwner != address(0), "Ownable: new owner is the zero address");
426             emit OwnershipTransferred(_owner, newOwner);
427             _owner = newOwner;
428         }
429 
430         function geUnlockTime() public view returns (uint256) {
431             return _lockTime;
432         }
433 
434         //Locks the contract for owner for the amount of time provided
435         function lock(uint256 time) public virtual onlyOwner {
436             _previousOwner = _owner;
437             _owner = address(0);
438             _lockTime = now + time;
439             emit OwnershipTransferred(_owner, address(0));
440         }
441 
442         //Unlocks the contract for owner when _lockTime is exceeds
443         function unlock() public virtual {
444             require(_previousOwner == msg.sender, "You don't have permission to unlock");
445             require(now > _lockTime , "Contract is locked until 7 days");
446             emit OwnershipTransferred(_owner, _previousOwner);
447             _owner = _previousOwner;
448         }
449     }
450 
451     interface IUniswapV2Factory {
452         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
453 
454         function feeTo() external view returns (address);
455         function feeToSetter() external view returns (address);
456 
457         function getPair(address tokenA, address tokenB) external view returns (address pair);
458         function allPairs(uint) external view returns (address pair);
459         function allPairsLength() external view returns (uint);
460 
461         function createPair(address tokenA, address tokenB) external returns (address pair);
462 
463         function setFeeTo(address) external;
464         function setFeeToSetter(address) external;
465     }
466 
467     interface IUniswapV2Pair {
468         event Approval(address indexed owner, address indexed spender, uint value);
469         event Transfer(address indexed from, address indexed to, uint value);
470 
471         function name() external pure returns (string memory);
472         function symbol() external pure returns (string memory);
473         function decimals() external pure returns (uint8);
474         function totalSupply() external view returns (uint);
475         function balanceOf(address owner) external view returns (uint);
476         function allowance(address owner, address spender) external view returns (uint);
477 
478         function approve(address spender, uint value) external returns (bool);
479         function transfer(address to, uint value) external returns (bool);
480         function transferFrom(address from, address to, uint value) external returns (bool);
481 
482         function DOMAIN_SEPARATOR() external view returns (bytes32);
483         function PERMIT_TYPEHASH() external pure returns (bytes32);
484         function nonces(address owner) external view returns (uint);
485 
486         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
487 
488         event Mint(address indexed sender, uint amount0, uint amount1);
489         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
490         event Swap(
491             address indexed sender,
492             uint amount0In,
493             uint amount1In,
494             uint amount0Out,
495             uint amount1Out,
496             address indexed to
497         );
498         event Sync(uint112 reserve0, uint112 reserve1);
499 
500         function MINIMUM_LIQUIDITY() external pure returns (uint);
501         function factory() external view returns (address);
502         function token0() external view returns (address);
503         function token1() external view returns (address);
504         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
505         function price0CumulativeLast() external view returns (uint);
506         function price1CumulativeLast() external view returns (uint);
507         function kLast() external view returns (uint);
508 
509         function mint(address to) external returns (uint liquidity);
510         function burn(address to) external returns (uint amount0, uint amount1);
511         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
512         function skim(address to) external;
513         function sync() external;
514 
515         function initialize(address, address) external;
516     }
517 
518     interface IUniswapV2Router01 {
519         function factory() external pure returns (address);
520         function WETH() external pure returns (address);
521 
522         function addLiquidity(
523             address tokenA,
524             address tokenB,
525             uint amountADesired,
526             uint amountBDesired,
527             uint amountAMin,
528             uint amountBMin,
529             address to,
530             uint deadline
531         ) external returns (uint amountA, uint amountB, uint liquidity);
532         function addLiquidityETH(
533             address token,
534             uint amountTokenDesired,
535             uint amountTokenMin,
536             uint amountETHMin,
537             address to,
538             uint deadline
539         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
540         function removeLiquidity(
541             address tokenA,
542             address tokenB,
543             uint liquidity,
544             uint amountAMin,
545             uint amountBMin,
546             address to,
547             uint deadline
548         ) external returns (uint amountA, uint amountB);
549         function removeLiquidityETH(
550             address token,
551             uint liquidity,
552             uint amountTokenMin,
553             uint amountETHMin,
554             address to,
555             uint deadline
556         ) external returns (uint amountToken, uint amountETH);
557         function removeLiquidityWithPermit(
558             address tokenA,
559             address tokenB,
560             uint liquidity,
561             uint amountAMin,
562             uint amountBMin,
563             address to,
564             uint deadline,
565             bool approveMax, uint8 v, bytes32 r, bytes32 s
566         ) external returns (uint amountA, uint amountB);
567         function removeLiquidityETHWithPermit(
568             address token,
569             uint liquidity,
570             uint amountTokenMin,
571             uint amountETHMin,
572             address to,
573             uint deadline,
574             bool approveMax, uint8 v, bytes32 r, bytes32 s
575         ) external returns (uint amountToken, uint amountETH);
576         function swapExactTokensForTokens(
577             uint amountIn,
578             uint amountOutMin,
579             address[] calldata path,
580             address to,
581             uint deadline
582         ) external returns (uint[] memory amounts);
583         function swapTokensForExactTokens(
584             uint amountOut,
585             uint amountInMax,
586             address[] calldata path,
587             address to,
588             uint deadline
589         ) external returns (uint[] memory amounts);
590         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
591             external
592             payable
593             returns (uint[] memory amounts);
594         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
595             external
596             returns (uint[] memory amounts);
597         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
598             external
599             returns (uint[] memory amounts);
600         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
601             external
602             payable
603             returns (uint[] memory amounts);
604 
605         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
606         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
607         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
608         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
609         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
610     }
611 
612     interface IUniswapV2Router02 is IUniswapV2Router01 {
613         function removeLiquidityETHSupportingFeeOnTransferTokens(
614             address token,
615             uint liquidity,
616             uint amountTokenMin,
617             uint amountETHMin,
618             address to,
619             uint deadline
620         ) external returns (uint amountETH);
621         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
622             address token,
623             uint liquidity,
624             uint amountTokenMin,
625             uint amountETHMin,
626             address to,
627             uint deadline,
628             bool approveMax, uint8 v, bytes32 r, bytes32 s
629         ) external returns (uint amountETH);
630 
631         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
632             uint amountIn,
633             uint amountOutMin,
634             address[] calldata path,
635             address to,
636             uint deadline
637         ) external;
638         function swapExactETHForTokensSupportingFeeOnTransferTokens(
639             uint amountOutMin,
640             address[] calldata path,
641             address to,
642             uint deadline
643         ) external payable;
644         function swapExactTokensForETHSupportingFeeOnTransferTokens(
645             uint amountIn,
646             uint amountOutMin,
647             address[] calldata path,
648             address to,
649             uint deadline
650         ) external;
651     }
652 
653     // Contract implementation
654     contract MultiBlockCapital is Context, IERC20, Ownable {
655         using SafeMath for uint256;
656         using Address for address;
657 
658         mapping (address => uint256) private _rOwned;
659         mapping (address => uint256) private _tOwned;
660         mapping (address => mapping (address => uint256)) private _allowances;
661 
662         mapping (address => bool) private _isExcludedFromFee;
663 
664         mapping (address => bool) private _isExcluded;
665         address[] private _excluded;
666 
667         uint256 private constant MAX = ~uint256(0);
668         uint256 private _tTotal = 1000000000000 * 10**9;
669         uint256 private _rTotal = (MAX - (MAX % _tTotal));
670         uint256 private _tFeeTotal;
671 
672         string private _name = 'MultiBlockCapital';
673         string private _symbol = 'MBC';
674         uint8 private _decimals = 9;
675 
676         uint256 private _taxFee = 10;
677         uint256 private _teamFee = 15;
678         uint256 private _previousTaxFee = _taxFee;
679         uint256 private _previousTeamFee = _teamFee;
680 
681         address payable public _MBCWalletAddress;
682         address payable public _marketingWalletAddress;
683 
684         IUniswapV2Router02 public immutable uniswapV2Router;
685         address public immutable uniswapV2Pair;
686 
687         bool inSwap = false;
688         bool public swapEnabled = true;
689 
690         uint256 private _maxTxAmount = 100000000000000e9;
691         // We will set a minimum amount of tokens to be swaped => 5M
692         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
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
703         constructor (address payable MBCWalletAddress, address payable marketingWalletAddress) public {
704             _MBCWalletAddress = MBCWalletAddress;
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
923             _MBCWalletAddress.transfer(amount.div(2));
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
1079         function _setMBCWallet(address payable MBCWalletAddress) external onlyOwner() {
1080             _MBCWalletAddress = MBCWalletAddress;
1081         }
1082 
1083         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1084             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1085             _maxTxAmount = maxTxAmount;
1086         }
1087     }