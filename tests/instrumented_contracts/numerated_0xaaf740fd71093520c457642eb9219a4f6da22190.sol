1 /**
2 WE ARE TIRED OF THE "MAN."
3 WE ARE SICK OF THE LIES.
4 WE ARE DISGUSTED WITH THE “FED.”
5 WE ARE UPSET WITH POLITICIANS.
6 WE ARE ANGRY AT THE CORRUPTION.
7 
8 WE WILL REGAIN OUR FREEDOM.
9 WE WILL REVEAL THE TRUTH.
10 WE WILL EXPOSE THE MANIPULATION.
11 WE WILL DEFEAT THE FRAUD.
12 
13 WE WILL RISE.
14 
15 WE ARE ONE.
16 
17 WE ARE ANONYMOUS. WE ARE LEGION.
18 
19 —————————————————————
20 
21 FAIR LAUNCH.
22 
23 
24 JOIN THE REVOLUTION.
25 */
26 
27 // SPDX-License-Identifier: Unlicensed
28 pragma solidity ^0.6.12;
29 
30     abstract contract Context {
31         function _msgSender() internal view virtual returns (address payable) {
32             return msg.sender;
33         }
34 
35         function _msgData() internal view virtual returns (bytes memory) {
36             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37             return msg.data;
38         }
39     }
40 
41     interface IERC20 {
42         /**
43         * @dev Returns the amount of tokens in existence.
44         */
45         function totalSupply() external view returns (uint256);
46 
47         /**
48         * @dev Returns the amount of tokens owned by `account`.
49         */
50         function balanceOf(address account) external view returns (uint256);
51 
52         /**
53         * @dev Moves `amount` tokens from the caller's account to `recipient`.
54         *
55         * Returns a boolean value indicating whether the operation succeeded.
56         *
57         * Emits a {Transfer} event.
58         */
59         function transfer(address recipient, uint256 amount) external returns (bool);
60 
61         /**
62         * @dev Returns the remaining number of tokens that `spender` will be
63         * allowed to spend on behalf of `owner` through {transferFrom}. This is
64         * zero by default.
65         *
66         * This value changes when {approve} or {transferFrom} are called.
67         */
68         function allowance(address owner, address spender) external view returns (uint256);
69 
70         /**
71         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72         *
73         * Returns a boolean value indicating whether the operation succeeded.
74         *
75         * IMPORTANT: Beware that changing an allowance with this method brings the risk
76         * that someone may use both the old and the new allowance by unfortunate
77         * transaction ordering. One possible solution to mitigate this race
78         * condition is to first reduce the spender's allowance to 0 and set the
79         * desired value afterwards:
80         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81         *
82         * Emits an {Approval} event.
83         */
84         function approve(address spender, uint256 amount) external returns (bool);
85 
86         /**
87         * @dev Moves `amount` tokens from `sender` to `recipient` using the
88         * allowance mechanism. `amount` is then deducted from the caller's
89         * allowance.
90         *
91         * Returns a boolean value indicating whether the operation succeeded.
92         *
93         * Emits a {Transfer} event.
94         */
95         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97         /**
98         * @dev Emitted when `value` tokens are moved from one account (`from`) to
99         * another (`to`).
100         *
101         * Note that `value` may be zero.
102         */
103         event Transfer(address indexed from, address indexed to, uint256 value);
104 
105         /**
106         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107         * a call to {approve}. `value` is the new allowance.
108         */
109         event Approval(address indexed owner, address indexed spender, uint256 value);
110     }
111 
112     library SafeMath {
113         /**
114         * @dev Returns the addition of two unsigned integers, reverting on
115         * overflow.
116         *
117         * Counterpart to Solidity's `+` operator.
118         *
119         * Requirements:
120         *
121         * - Addition cannot overflow.
122         */
123         function add(uint256 a, uint256 b) internal pure returns (uint256) {
124             uint256 c = a + b;
125             require(c >= a, "SafeMath: addition overflow");
126 
127             return c;
128         }
129 
130         /**
131         * @dev Returns the subtraction of two unsigned integers, reverting on
132         * overflow (when the result is negative).
133         *
134         * Counterpart to Solidity's `-` operator.
135         *
136         * Requirements:
137         *
138         * - Subtraction cannot overflow.
139         */
140         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141             return sub(a, b, "SafeMath: subtraction overflow");
142         }
143 
144         /**
145         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146         * overflow (when the result is negative).
147         *
148         * Counterpart to Solidity's `-` operator.
149         *
150         * Requirements:
151         *
152         * - Subtraction cannot overflow.
153         */
154         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155             require(b <= a, errorMessage);
156             uint256 c = a - b;
157 
158             return c;
159         }
160 
161         /**
162         * @dev Returns the multiplication of two unsigned integers, reverting on
163         * overflow.
164         *
165         * Counterpart to Solidity's `*` operator.
166         *
167         * Requirements:
168         *
169         * - Multiplication cannot overflow.
170         */
171         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173             // benefit is lost if 'b' is also tested.
174             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175             if (a == 0) {
176                 return 0;
177             }
178 
179             uint256 c = a * b;
180             require(c / a == b, "SafeMath: multiplication overflow");
181 
182             return c;
183         }
184 
185         /**
186         * @dev Returns the integer division of two unsigned integers. Reverts on
187         * division by zero. The result is rounded towards zero.
188         *
189         * Counterpart to Solidity's `/` operator. Note: this function uses a
190         * `revert` opcode (which leaves remaining gas untouched) while Solidity
191         * uses an invalid opcode to revert (consuming all remaining gas).
192         *
193         * Requirements:
194         *
195         * - The divisor cannot be zero.
196         */
197         function div(uint256 a, uint256 b) internal pure returns (uint256) {
198             return div(a, b, "SafeMath: division by zero");
199         }
200 
201         /**
202         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203         * division by zero. The result is rounded towards zero.
204         *
205         * Counterpart to Solidity's `/` operator. Note: this function uses a
206         * `revert` opcode (which leaves remaining gas untouched) while Solidity
207         * uses an invalid opcode to revert (consuming all remaining gas).
208         *
209         * Requirements:
210         *
211         * - The divisor cannot be zero.
212         */
213         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214             require(b > 0, errorMessage);
215             uint256 c = a / b;
216             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218             return c;
219         }
220 
221         /**
222         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223         * Reverts when dividing by zero.
224         *
225         * Counterpart to Solidity's `%` operator. This function uses a `revert`
226         * opcode (which leaves remaining gas untouched) while Solidity uses an
227         * invalid opcode to revert (consuming all remaining gas).
228         *
229         * Requirements:
230         *
231         * - The divisor cannot be zero.
232         */
233         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234             return mod(a, b, "SafeMath: modulo by zero");
235         }
236 
237         /**
238         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239         * Reverts with custom message when dividing by zero.
240         *
241         * Counterpart to Solidity's `%` operator. This function uses a `revert`
242         * opcode (which leaves remaining gas untouched) while Solidity uses an
243         * invalid opcode to revert (consuming all remaining gas).
244         *
245         * Requirements:
246         *
247         * - The divisor cannot be zero.
248         */
249         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250             require(b != 0, errorMessage);
251             return a % b;
252         }
253     }
254 
255     library Address {
256         /**
257         * @dev Returns true if `account` is a contract.
258         *
259         * [IMPORTANT]
260         * ====
261         * It is unsafe to assume that an address for which this function returns
262         * false is an externally-owned account (EOA) and not a contract.
263         *
264         * Among others, `isContract` will return false for the following
265         * types of addresses:
266         *
267         *  - an externally-owned account
268         *  - a contract in construction
269         *  - an address where a contract will be created
270         *  - an address where a contract lived, but was destroyed
271         * ====
272         */
273         function isContract(address account) internal view returns (bool) {
274             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276             // for accounts without code, i.e. `keccak256('')`
277             bytes32 codehash;
278             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279             // solhint-disable-next-line no-inline-assembly
280             assembly { codehash := extcodehash(account) }
281             return (codehash != accountHash && codehash != 0x0);
282         }
283 
284         /**
285         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286         * `recipient`, forwarding all available gas and reverting on errors.
287         *
288         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289         * of certain opcodes, possibly making contracts go over the 2300 gas limit
290         * imposed by `transfer`, making them unable to receive funds via
291         * `transfer`. {sendValue} removes this limitation.
292         *
293         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294         *
295         * IMPORTANT: because control is transferred to `recipient`, care must be
296         * taken to not create reentrancy vulnerabilities. Consider using
297         * {ReentrancyGuard} or the
298         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299         */
300         function sendValue(address payable recipient, uint256 amount) internal {
301             require(address(this).balance >= amount, "Address: insufficient balance");
302 
303             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304             (bool success, ) = recipient.call{ value: amount }("");
305             require(success, "Address: unable to send value, recipient may have reverted");
306         }
307 
308         /**
309         * @dev Performs a Solidity function call using a low level `call`. A
310         * plain`call` is an unsafe replacement for a function call: use this
311         * function instead.
312         *
313         * If `target` reverts with a revert reason, it is bubbled up by this
314         * function (like regular Solidity function calls).
315         *
316         * Returns the raw returned data. To convert to the expected return value,
317         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318         *
319         * Requirements:
320         *
321         * - `target` must be a contract.
322         * - calling `target` with `data` must not revert.
323         *
324         * _Available since v3.1._
325         */
326         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328         }
329 
330         /**
331         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332         * `errorMessage` as a fallback revert reason when `target` reverts.
333         *
334         * _Available since v3.1._
335         */
336         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337             return _functionCallWithValue(target, data, 0, errorMessage);
338         }
339 
340         /**
341         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342         * but also transferring `value` wei to `target`.
343         *
344         * Requirements:
345         *
346         * - the calling contract must have an ETH balance of at least `value`.
347         * - the called Solidity function must be `payable`.
348         *
349         * _Available since v3.1._
350         */
351         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353         }
354 
355         /**
356         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357         * with `errorMessage` as a fallback revert reason when `target` reverts.
358         *
359         * _Available since v3.1._
360         */
361         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362             require(address(this).balance >= value, "Address: insufficient balance for call");
363             return _functionCallWithValue(target, data, value, errorMessage);
364         }
365 
366         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367             require(isContract(target), "Address: call to non-contract");
368 
369             // solhint-disable-next-line avoid-low-level-calls
370             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371             if (success) {
372                 return returndata;
373             } else {
374                 // Look for revert reason and bubble it up if present
375                 if (returndata.length > 0) {
376                     // The easiest way to bubble the revert reason is using memory via assembly
377 
378                     // solhint-disable-next-line no-inline-assembly
379                     assembly {
380                         let returndata_size := mload(returndata)
381                         revert(add(32, returndata), returndata_size)
382                     }
383                 } else {
384                     revert(errorMessage);
385                 }
386             }
387         }
388     }
389 
390     contract Ownable is Context {
391         address private _owner;
392         address private _previousOwner;
393         uint256 private _lockTime;
394 
395         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397         /**
398         * @dev Initializes the contract setting the deployer as the initial owner.
399         */
400         constructor () internal {
401             address msgSender = _msgSender();
402             _owner = msgSender;
403             emit OwnershipTransferred(address(0), msgSender);
404         }
405 
406         /**
407         * @dev Returns the address of the current owner.
408         */
409         function owner() public view returns (address) {
410             return _owner;
411         }
412 
413         /**
414         * @dev Throws if called by any account other than the owner.
415         */
416         modifier onlyOwner() {
417             require(_owner == _msgSender(), "Ownable: caller is not the owner");
418             _;
419         }
420 
421         /**
422         * @dev Leaves the contract without owner. It will not be possible to call
423         * `onlyOwner` functions anymore. Can only be called by the current owner.
424         *
425         * NOTE: Renouncing ownership will leave the contract without an owner,
426         * thereby removing any functionality that is only available to the owner.
427         */
428         function renounceOwnership() public virtual onlyOwner {
429             emit OwnershipTransferred(_owner, address(0));
430             _owner = address(0);
431         }
432 
433         /**
434         * @dev Transfers ownership of the contract to a new account (`newOwner`).
435         * Can only be called by the current owner.
436         */
437         function transferOwnership(address newOwner) public virtual onlyOwner {
438             require(newOwner != address(0), "Ownable: new owner is the zero address");
439             emit OwnershipTransferred(_owner, newOwner);
440             _owner = newOwner;
441         }
442 
443         function geUnlockTime() public view returns (uint256) {
444             return _lockTime;
445         }
446 
447         //Locks the contract for owner for the amount of time provided
448         function lock(uint256 time) public virtual onlyOwner {
449             _previousOwner = _owner;
450             _owner = address(0);
451             _lockTime = now + time;
452             emit OwnershipTransferred(_owner, address(0));
453         }
454 
455         //Unlocks the contract for owner when _lockTime is exceeds
456         function unlock() public virtual {
457             require(_previousOwner == msg.sender, "You don't have permission to unlock");
458             require(now > _lockTime , "Contract is locked until 7 days");
459             emit OwnershipTransferred(_owner, _previousOwner);
460             _owner = _previousOwner;
461         }
462     }
463 
464     interface IUniswapV2Factory {
465         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
466 
467         function feeTo() external view returns (address);
468         function feeToSetter() external view returns (address);
469 
470         function getPair(address tokenA, address tokenB) external view returns (address pair);
471         function allPairs(uint) external view returns (address pair);
472         function allPairsLength() external view returns (uint);
473 
474         function createPair(address tokenA, address tokenB) external returns (address pair);
475 
476         function setFeeTo(address) external;
477         function setFeeToSetter(address) external;
478     }
479 
480     interface IUniswapV2Pair {
481         event Approval(address indexed owner, address indexed spender, uint value);
482         event Transfer(address indexed from, address indexed to, uint value);
483 
484         function name() external pure returns (string memory);
485         function symbol() external pure returns (string memory);
486         function decimals() external pure returns (uint8);
487         function totalSupply() external view returns (uint);
488         function balanceOf(address owner) external view returns (uint);
489         function allowance(address owner, address spender) external view returns (uint);
490 
491         function approve(address spender, uint value) external returns (bool);
492         function transfer(address to, uint value) external returns (bool);
493         function transferFrom(address from, address to, uint value) external returns (bool);
494 
495         function DOMAIN_SEPARATOR() external view returns (bytes32);
496         function PERMIT_TYPEHASH() external pure returns (bytes32);
497         function nonces(address owner) external view returns (uint);
498 
499         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
500 
501         event Mint(address indexed sender, uint amount0, uint amount1);
502         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
503         event Swap(
504             address indexed sender,
505             uint amount0In,
506             uint amount1In,
507             uint amount0Out,
508             uint amount1Out,
509             address indexed to
510         );
511         event Sync(uint112 reserve0, uint112 reserve1);
512 
513         function MINIMUM_LIQUIDITY() external pure returns (uint);
514         function factory() external view returns (address);
515         function token0() external view returns (address);
516         function token1() external view returns (address);
517         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
518         function price0CumulativeLast() external view returns (uint);
519         function price1CumulativeLast() external view returns (uint);
520         function kLast() external view returns (uint);
521 
522         function mint(address to) external returns (uint liquidity);
523         function burn(address to) external returns (uint amount0, uint amount1);
524         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
525         function skim(address to) external;
526         function sync() external;
527 
528         function initialize(address, address) external;
529     }
530 
531     interface IUniswapV2Router01 {
532         function factory() external pure returns (address);
533         function WETH() external pure returns (address);
534 
535         function addLiquidity(
536             address tokenA,
537             address tokenB,
538             uint amountADesired,
539             uint amountBDesired,
540             uint amountAMin,
541             uint amountBMin,
542             address to,
543             uint deadline
544         ) external returns (uint amountA, uint amountB, uint liquidity);
545         function addLiquidityETH(
546             address token,
547             uint amountTokenDesired,
548             uint amountTokenMin,
549             uint amountETHMin,
550             address to,
551             uint deadline
552         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
553         function removeLiquidity(
554             address tokenA,
555             address tokenB,
556             uint liquidity,
557             uint amountAMin,
558             uint amountBMin,
559             address to,
560             uint deadline
561         ) external returns (uint amountA, uint amountB);
562         function removeLiquidityETH(
563             address token,
564             uint liquidity,
565             uint amountTokenMin,
566             uint amountETHMin,
567             address to,
568             uint deadline
569         ) external returns (uint amountToken, uint amountETH);
570         function removeLiquidityWithPermit(
571             address tokenA,
572             address tokenB,
573             uint liquidity,
574             uint amountAMin,
575             uint amountBMin,
576             address to,
577             uint deadline,
578             bool approveMax, uint8 v, bytes32 r, bytes32 s
579         ) external returns (uint amountA, uint amountB);
580         function removeLiquidityETHWithPermit(
581             address token,
582             uint liquidity,
583             uint amountTokenMin,
584             uint amountETHMin,
585             address to,
586             uint deadline,
587             bool approveMax, uint8 v, bytes32 r, bytes32 s
588         ) external returns (uint amountToken, uint amountETH);
589         function swapExactTokensForTokens(
590             uint amountIn,
591             uint amountOutMin,
592             address[] calldata path,
593             address to,
594             uint deadline
595         ) external returns (uint[] memory amounts);
596         function swapTokensForExactTokens(
597             uint amountOut,
598             uint amountInMax,
599             address[] calldata path,
600             address to,
601             uint deadline
602         ) external returns (uint[] memory amounts);
603         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
604             external
605             payable
606             returns (uint[] memory amounts);
607         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
608             external
609             returns (uint[] memory amounts);
610         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
611             external
612             returns (uint[] memory amounts);
613         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
614             external
615             payable
616             returns (uint[] memory amounts);
617 
618         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
619         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
620         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
621         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
622         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
623     }
624 
625     interface IUniswapV2Router02 is IUniswapV2Router01 {
626         function removeLiquidityETHSupportingFeeOnTransferTokens(
627             address token,
628             uint liquidity,
629             uint amountTokenMin,
630             uint amountETHMin,
631             address to,
632             uint deadline
633         ) external returns (uint amountETH);
634         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
635             address token,
636             uint liquidity,
637             uint amountTokenMin,
638             uint amountETHMin,
639             address to,
640             uint deadline,
641             bool approveMax, uint8 v, bytes32 r, bytes32 s
642         ) external returns (uint amountETH);
643 
644         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
645             uint amountIn,
646             uint amountOutMin,
647             address[] calldata path,
648             address to,
649             uint deadline
650         ) external;
651         function swapExactETHForTokensSupportingFeeOnTransferTokens(
652             uint amountOutMin,
653             address[] calldata path,
654             address to,
655             uint deadline
656         ) external payable;
657         function swapExactTokensForETHSupportingFeeOnTransferTokens(
658             uint amountIn,
659             uint amountOutMin,
660             address[] calldata path,
661             address to,
662             uint deadline
663         ) external;
664     }
665 
666     contract ANON is Context, IERC20, Ownable {
667       using SafeMath for uint256;
668       using Address for address;
669     
670       mapping (address => uint256) private _rOwned;
671       mapping (address => uint256) private _tOwned;
672       mapping (address => mapping (address => uint256)) private _allowances;
673     
674       mapping (address => bool) private _isExcludedFromFee;
675     
676       mapping (address => bool) private _isExcluded;
677       address[] private _excluded;
678       mapping (address => bool) private _isBlackListedBot;
679       address[] private _blackListedBots;
680     
681       uint256 private constant MAX = ~uint256(0);
682       uint256 private _tTotal = 500000000000 * 10**9;
683       uint256 private _rTotal = (MAX - (MAX % _tTotal));
684       uint256 private _tFeeTotal;
685     
686       string private _name = 'Anonymous';
687       string private _symbol = 'ANON';
688       uint8 private _decimals = 9;
689     
690       uint256 private _taxFee = 2;
691       uint256 private _teamFee = 10;
692       uint256 private _previousTaxFee = _taxFee;
693       uint256 private _previousTeamFee = _teamFee;
694     
695       address payable public _devWalletAddress1;
696       address payable public _devWalletAddress2;
697       address payable public _marketingWalletAddress;
698       address payable public _dipWalletAddress;
699     
700       IUniswapV2Router02 public immutable uniswapV2Router;
701       address public immutable uniswapV2Pair;
702     
703       bool inSwap = false;
704       bool public swapEnabled = true;
705     
706       uint256 private _maxTxAmount = 5000000000 * 10**9;
707       uint256 private _numOfTokensToExchangeForTeam = 10000 * 10**9;
708     
709       event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
710       event SwapEnabledUpdated(bool enabled);
711     
712       modifier lockTheSwap {
713           inSwap = true;
714           _;
715           inSwap = false;
716       }
717     
718       constructor (address payable devWalletAddress1, address payable devWalletAddress2, address payable marketingWalletAddress, address payable dipWalletAddress) public {
719           _devWalletAddress1 = devWalletAddress1;
720           _devWalletAddress2 = devWalletAddress2;
721           _marketingWalletAddress = marketingWalletAddress;
722           _dipWalletAddress = dipWalletAddress;
723           _rOwned[_msgSender()] = _rTotal;
724     
725           IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
726           // Create a uniswap pair for this new token
727           uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
728               .createPair(address(this), _uniswapV2Router.WETH());
729     
730           // set the rest of the contract variables
731           uniswapV2Router = _uniswapV2Router;
732     
733           // Exclude owner and this contract from fee
734           _isExcludedFromFee[owner()] = true;
735           _isExcludedFromFee[address(this)] = true;
736     
737           emit Transfer(address(0), _msgSender(), _tTotal);
738       }
739     
740       function name() public view returns (string memory) {
741           return _name;
742       }
743     
744       function symbol() public view returns (string memory) {
745           return _symbol;
746       }
747     
748       function decimals() public view returns (uint8) {
749           return _decimals;
750       }
751     
752       function totalSupply() public view override returns (uint256) {
753           return _tTotal;
754       }
755     
756       function balanceOf(address account) public view override returns (uint256) {
757           if (_isExcluded[account]) return _tOwned[account];
758           return tokenFromReflection(_rOwned[account]);
759       }
760     
761       function transfer(address recipient, uint256 amount) public override returns (bool) {
762           _transfer(_msgSender(), recipient, amount);
763           return true;
764       }
765     
766       function allowance(address owner, address spender) public view override returns (uint256) {
767           return _allowances[owner][spender];
768       }
769     
770       function approve(address spender, uint256 amount) public override returns (bool) {
771           _approve(_msgSender(), spender, amount);
772           return true;
773       }
774     
775       function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
776           _transfer(sender, recipient, amount);
777           _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
778           return true;
779       }
780     
781       function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
782           _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
783           return true;
784       }
785     
786       function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
787           _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
788           return true;
789       }
790     
791       function isExcluded(address account) public view returns (bool) {
792           return _isExcluded[account];
793       }
794     
795       function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
796           _isExcludedFromFee[account] = excluded;
797       }
798     
799       function totalFees() public view returns (uint256) {
800           return _tFeeTotal;
801       }
802     
803       function deliver(uint256 tAmount) public {
804           address sender = _msgSender();
805           require(!_isExcluded[sender], "Excluded addresses cannot call this function");
806           (uint256 rAmount,,,,,) = _getValues(tAmount);
807           _rOwned[sender] = _rOwned[sender].sub(rAmount);
808           _rTotal = _rTotal.sub(rAmount);
809           _tFeeTotal = _tFeeTotal.add(tAmount);
810       }
811     
812       function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
813           require(tAmount <= _tTotal, "Amount must be less than supply");
814           if (!deductTransferFee) {
815               (uint256 rAmount,,,,,) = _getValues(tAmount);
816               return rAmount;
817           } else {
818               (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
819               return rTransferAmount;
820           }
821       }
822     
823       function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
824           require(rAmount <= _rTotal, "Amount must be less than total reflections");
825           uint256 currentRate =  _getRate();
826           return rAmount.div(currentRate);
827       }
828     
829       function addBotToBlacklist (address account) external onlyOwner() {
830          require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
831          require (!_isBlackListedBot[account], 'Account is already blacklisted');
832          _isBlackListedBot[account] = true;
833          _blackListedBots.push(account);
834       }
835     
836       function removeBotFromBlacklist(address account) external onlyOwner() {
837         require (_isBlackListedBot[account], 'Account is not blacklisted');
838         for (uint256 i = 0; i < _blackListedBots.length; i++) {
839                if (_blackListedBots[i] == account) {
840                    _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
841                    _isBlackListedBot[account] = false;
842                    _blackListedBots.pop();
843                    break;
844                }
845          }
846      }
847     
848       function excludeAccount(address account) external onlyOwner() {
849           require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
850           require(!_isExcluded[account], "Account is already excluded");
851           if(_rOwned[account] > 0) {
852               _tOwned[account] = tokenFromReflection(_rOwned[account]);
853           }
854           _isExcluded[account] = true;
855           _excluded.push(account);
856       }
857     
858       function includeAccount(address account) external onlyOwner() {
859           require(_isExcluded[account], "Account is already excluded");
860           for (uint256 i = 0; i < _excluded.length; i++) {
861               if (_excluded[i] == account) {
862                   _excluded[i] = _excluded[_excluded.length - 1];
863                   _tOwned[account] = 0;
864                   _isExcluded[account] = false;
865                   _excluded.pop();
866                   break;
867               }
868           }
869       }
870     
871       function removeAllFee() private {
872           if(_taxFee == 0 && _teamFee == 0) return;
873     
874           _previousTaxFee = _taxFee;
875           _previousTeamFee = _teamFee;
876     
877           _taxFee = 0;
878           _teamFee = 0;
879       }
880     
881       function restoreAllFee() private {
882           _taxFee = _previousTaxFee;
883           _teamFee = _previousTeamFee;
884       }
885     
886       function isExcludedFromFee(address account) public view returns(bool) {
887           return _isExcludedFromFee[account];
888       }
889     
890       function _approve(address owner, address spender, uint256 amount) private {
891           require(owner != address(0), "ERC20: approve from the zero address");
892           require(spender != address(0), "ERC20: approve to the zero address");
893     
894           _allowances[owner][spender] = amount;
895           emit Approval(owner, spender, amount);
896       }
897     
898       function _transfer(address sender, address recipient, uint256 amount) private {
899           require(sender != address(0), "ERC20: transfer from the zero address");
900           require(recipient != address(0), "ERC20: transfer to the zero address");
901           require(amount > 0, "Transfer amount must be greater than zero");
902           require(!_isBlackListedBot[recipient], "You are blacklisted");
903           require(!_isBlackListedBot[msg.sender], "You are blacklisted");
904           require(!_isBlackListedBot[tx.origin], "You are blacklisted");
905           if(sender != owner() && recipient != owner())
906               require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
907     
908           // is the token balance of this contract address over the min number of
909           // tokens that we need to initiate a swap?
910           // also, don't get caught in a circular team event.
911           // also, don't swap if sender is uniswap pair.
912           uint256 contractTokenBalance = balanceOf(address(this));
913     
914           if(contractTokenBalance >= _maxTxAmount)
915           {
916               contractTokenBalance = _maxTxAmount;
917           }
918     
919           bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
920           if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
921               // Swap tokens for ETH and send to resepctive wallets
922               swapTokensForEth(contractTokenBalance);
923     
924               uint256 contractETHBalance = address(this).balance;
925               if(contractETHBalance > 0) {
926                   sendETHToTeam(address(this).balance);
927               }
928           }
929     
930           //indicates if fee should be deducted from transfer
931           bool takeFee = true;
932     
933           //if any account belongs to _isExcludedFromFee account then remove the fee
934           if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
935               takeFee = false;
936           }
937     
938           //transfer amount, it will take tax and team fee
939           _tokenTransfer(sender,recipient,amount,takeFee);
940       }
941     
942       function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
943           // generate the uniswap pair path of token -> weth
944           address[] memory path = new address[](2);
945           path[0] = address(this);
946           path[1] = uniswapV2Router.WETH();
947     
948           _approve(address(this), address(uniswapV2Router), tokenAmount);
949     
950           // make the swap
951           uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
952               tokenAmount,
953               0, // accept any amount of ETH
954               path,
955               address(this),
956               block.timestamp
957           );
958       }
959     
960       function sendETHToTeam(uint256 amount) private {
961           _devWalletAddress1.transfer(amount.div(10).mul(4));
962           _devWalletAddress2.transfer(amount.div(10).mul(3));
963           _marketingWalletAddress.transfer(amount.div(10).mul(2));
964           _dipWalletAddress.transfer(amount.div(10));
965       }
966     
967       function manualSwap() external onlyOwner() {
968           uint256 contractBalance = balanceOf(address(this));
969           swapTokensForEth(contractBalance);
970       }
971     
972       function manualSend() external onlyOwner() {
973           uint256 contractETHBalance = address(this).balance;
974           sendETHToTeam(contractETHBalance);
975       }
976     
977       function setSwapEnabled(bool enabled) external onlyOwner(){
978           swapEnabled = enabled;
979       }
980     
981       function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
982           if(!takeFee)
983               removeAllFee();
984     
985           if (_isExcluded[sender] && !_isExcluded[recipient]) {
986               _transferFromExcluded(sender, recipient, amount);
987           } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
988               _transferToExcluded(sender, recipient, amount);
989           } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
990               _transferStandard(sender, recipient, amount);
991           } else if (_isExcluded[sender] && _isExcluded[recipient]) {
992               _transferBothExcluded(sender, recipient, amount);
993           } else {
994               _transferStandard(sender, recipient, amount);
995           }
996     
997           if(!takeFee)
998               restoreAllFee();
999       }
1000     
1001       function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1002           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1003           _rOwned[sender] = _rOwned[sender].sub(rAmount);
1004           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1005           _takeTeam(tTeam);
1006           _reflectFee(rFee, tFee);
1007           emit Transfer(sender, recipient, tTransferAmount);
1008       }
1009     
1010       function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1011           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1012           _rOwned[sender] = _rOwned[sender].sub(rAmount);
1013           _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1014           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1015           _takeTeam(tTeam);
1016           _reflectFee(rFee, tFee);
1017           emit Transfer(sender, recipient, tTransferAmount);
1018       }
1019     
1020       function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1021           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1022           _tOwned[sender] = _tOwned[sender].sub(tAmount);
1023           _rOwned[sender] = _rOwned[sender].sub(rAmount);
1024           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1025           _takeTeam(tTeam);
1026           _reflectFee(rFee, tFee);
1027           emit Transfer(sender, recipient, tTransferAmount);
1028       }
1029     
1030       function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1031           (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1032           _tOwned[sender] = _tOwned[sender].sub(tAmount);
1033           _rOwned[sender] = _rOwned[sender].sub(rAmount);
1034           _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1035           _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1036           _takeTeam(tTeam);
1037           _reflectFee(rFee, tFee);
1038           emit Transfer(sender, recipient, tTransferAmount);
1039       }
1040     
1041       function _takeTeam(uint256 tTeam) private {
1042           uint256 currentRate =  _getRate();
1043           uint256 rTeam = tTeam.mul(currentRate);
1044           _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1045           if(_isExcluded[address(this)])
1046               _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1047       }
1048     
1049       function _reflectFee(uint256 rFee, uint256 tFee) private {
1050           _rTotal = _rTotal.sub(rFee);
1051           _tFeeTotal = _tFeeTotal.add(tFee);
1052       }
1053     
1054        //to recieve ETH from uniswapV2Router when swaping
1055       receive() external payable {}
1056     
1057       function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1058       (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1059       uint256 currentRate = _getRate();
1060       (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1061       return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1062     }
1063     
1064       function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1065           uint256 tFee = tAmount.mul(taxFee).div(100);
1066           uint256 tTeam = tAmount.mul(teamFee).div(100);
1067           uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1068           return (tTransferAmount, tFee, tTeam);
1069       }
1070     
1071       function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1072           uint256 rAmount = tAmount.mul(currentRate);
1073           uint256 rFee = tFee.mul(currentRate);
1074           uint256 rTeam = tTeam.mul(currentRate);
1075           uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1076           return (rAmount, rTransferAmount, rFee);
1077       }
1078     
1079       function _getRate() private view returns(uint256) {
1080           (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1081           return rSupply.div(tSupply);
1082       }
1083     
1084       function _getCurrentSupply() private view returns(uint256, uint256) {
1085           uint256 rSupply = _rTotal;
1086           uint256 tSupply = _tTotal;
1087           for (uint256 i = 0; i < _excluded.length; i++) {
1088               if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1089               rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1090               tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1091           }
1092           if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1093           return (rSupply, tSupply);
1094       }
1095     
1096       function _getTaxFee() public view returns(uint256) {
1097           return _taxFee;
1098       }
1099     
1100       function _getMaxTxAmount() public view returns(uint256) {
1101           return _maxTxAmount;
1102       }
1103     
1104       function _getETHBalance() public view returns(uint256 balance) {
1105           return address(this).balance;
1106       }
1107     
1108       function _setTaxFee(uint256 taxFee) external onlyOwner() {
1109           require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1110           _taxFee = taxFee;
1111       }
1112     
1113       function _setTeamFee(uint256 teamFee) external onlyOwner() {
1114           require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1115           _teamFee = teamFee;
1116       }
1117     
1118       function _setDevWallet1(address payable devWalletAddress1) external onlyOwner() {
1119           _devWalletAddress1 = devWalletAddress1;
1120       }
1121     
1122       function _setDevWallet2(address payable devWalletAddress2) external onlyOwner() {
1123           _devWalletAddress2 = devWalletAddress2;
1124       }
1125       function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1126           _marketingWalletAddress = marketingWalletAddress;
1127       }
1128     
1129     
1130       function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1131           _maxTxAmount = maxTxAmount;
1132       }
1133     }