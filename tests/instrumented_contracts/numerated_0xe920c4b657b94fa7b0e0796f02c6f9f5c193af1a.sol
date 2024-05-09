1 /*
2 Telegram: https://t.me/ReaperInu
3 Website: www.reaperinu.com
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
427         //Locks the contract for owner for the amount of time provided
428         function lock(uint256 time) public virtual onlyOwner {
429             _previousOwner = _owner;
430             _owner = address(0);
431             _lockTime = now + time;
432             emit OwnershipTransferred(_owner, address(0));
433         }
434         
435         //Unlocks the contract for owner when _lockTime is exceeds
436         function unlock() public virtual {
437             require(_previousOwner == msg.sender, "You don't have permission to unlock");
438             require(now > _lockTime , "Contract is locked until 7 days");
439             emit OwnershipTransferred(_owner, _previousOwner);
440             _owner = _previousOwner;
441         }
442     }  
443 
444     interface IUniswapV2Factory {
445         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
446 
447         function feeTo() external view returns (address);
448         function feeToSetter() external view returns (address);
449 
450         function getPair(address tokenA, address tokenB) external view returns (address pair);
451         function allPairs(uint) external view returns (address pair);
452         function allPairsLength() external view returns (uint);
453 
454         function createPair(address tokenA, address tokenB) external returns (address pair);
455 
456         function setFeeTo(address) external;
457         function setFeeToSetter(address) external;
458     } 
459 
460     interface IUniswapV2Pair {
461         event Approval(address indexed owner, address indexed spender, uint value);
462         event Transfer(address indexed from, address indexed to, uint value);
463 
464         function name() external pure returns (string memory);
465         function symbol() external pure returns (string memory);
466         function decimals() external pure returns (uint8);
467         function totalSupply() external view returns (uint);
468         function balanceOf(address owner) external view returns (uint);
469         function allowance(address owner, address spender) external view returns (uint);
470 
471         function approve(address spender, uint value) external returns (bool);
472         function transfer(address to, uint value) external returns (bool);
473         function transferFrom(address from, address to, uint value) external returns (bool);
474 
475         function DOMAIN_SEPARATOR() external view returns (bytes32);
476         function PERMIT_TYPEHASH() external pure returns (bytes32);
477         function nonces(address owner) external view returns (uint);
478 
479         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
480 
481         event Mint(address indexed sender, uint amount0, uint amount1);
482         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
483         event Swap(
484             address indexed sender,
485             uint amount0In,
486             uint amount1In,
487             uint amount0Out,
488             uint amount1Out,
489             address indexed to
490         );
491         event Sync(uint112 reserve0, uint112 reserve1);
492 
493         function MINIMUM_LIQUIDITY() external pure returns (uint);
494         function factory() external view returns (address);
495         function token0() external view returns (address);
496         function token1() external view returns (address);
497         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
498         function price0CumulativeLast() external view returns (uint);
499         function price1CumulativeLast() external view returns (uint);
500         function kLast() external view returns (uint);
501 
502         function mint(address to) external returns (uint liquidity);
503         function burn(address to) external returns (uint amount0, uint amount1);
504         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
505         function skim(address to) external;
506         function sync() external;
507 
508         function initialize(address, address) external;
509     }
510 
511     interface IUniswapV2Router01 {
512         function factory() external pure returns (address);
513         function WETH() external pure returns (address);
514 
515         function addLiquidity(
516             address tokenA,
517             address tokenB,
518             uint amountADesired,
519             uint amountBDesired,
520             uint amountAMin,
521             uint amountBMin,
522             address to,
523             uint deadline
524         ) external returns (uint amountA, uint amountB, uint liquidity);
525         function addLiquidityETH(
526             address token,
527             uint amountTokenDesired,
528             uint amountTokenMin,
529             uint amountETHMin,
530             address to,
531             uint deadline
532         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
533         function removeLiquidity(
534             address tokenA,
535             address tokenB,
536             uint liquidity,
537             uint amountAMin,
538             uint amountBMin,
539             address to,
540             uint deadline
541         ) external returns (uint amountA, uint amountB);
542         function removeLiquidityETH(
543             address token,
544             uint liquidity,
545             uint amountTokenMin,
546             uint amountETHMin,
547             address to,
548             uint deadline
549         ) external returns (uint amountToken, uint amountETH);
550         function removeLiquidityWithPermit(
551             address tokenA,
552             address tokenB,
553             uint liquidity,
554             uint amountAMin,
555             uint amountBMin,
556             address to,
557             uint deadline,
558             bool approveMax, uint8 v, bytes32 r, bytes32 s
559         ) external returns (uint amountA, uint amountB);
560         function removeLiquidityETHWithPermit(
561             address token,
562             uint liquidity,
563             uint amountTokenMin,
564             uint amountETHMin,
565             address to,
566             uint deadline,
567             bool approveMax, uint8 v, bytes32 r, bytes32 s
568         ) external returns (uint amountToken, uint amountETH);
569         function swapExactTokensForTokens(
570             uint amountIn,
571             uint amountOutMin,
572             address[] calldata path,
573             address to,
574             uint deadline
575         ) external returns (uint[] memory amounts);
576         function swapTokensForExactTokens(
577             uint amountOut,
578             uint amountInMax,
579             address[] calldata path,
580             address to,
581             uint deadline
582         ) external returns (uint[] memory amounts);
583         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
584             external
585             payable
586             returns (uint[] memory amounts);
587         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
588             external
589             returns (uint[] memory amounts);
590         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
591             external
592             returns (uint[] memory amounts);
593         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
594             external
595             payable
596             returns (uint[] memory amounts);
597 
598         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
599         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
600         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
601         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
602         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
603     }
604 
605     interface IUniswapV2Router02 is IUniswapV2Router01 {
606         function removeLiquidityETHSupportingFeeOnTransferTokens(
607             address token,
608             uint liquidity,
609             uint amountTokenMin,
610             uint amountETHMin,
611             address to,
612             uint deadline
613         ) external returns (uint amountETH);
614         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
615             address token,
616             uint liquidity,
617             uint amountTokenMin,
618             uint amountETHMin,
619             address to,
620             uint deadline,
621             bool approveMax, uint8 v, bytes32 r, bytes32 s
622         ) external returns (uint amountETH);
623 
624         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
625             uint amountIn,
626             uint amountOutMin,
627             address[] calldata path,
628             address to,
629             uint deadline
630         ) external;
631         function swapExactETHForTokensSupportingFeeOnTransferTokens(
632             uint amountOutMin,
633             address[] calldata path,
634             address to,
635             uint deadline
636         ) external payable;
637         function swapExactTokensForETHSupportingFeeOnTransferTokens(
638             uint amountIn,
639             uint amountOutMin,
640             address[] calldata path,
641             address to,
642             uint deadline
643         ) external;
644     }
645 
646     // Contract implementation
647     contract ReaperInu is Context, IERC20, Ownable {
648         using SafeMath for uint256;
649         using Address for address;
650 
651         mapping (address => uint256) private _rOwned;
652         mapping (address => uint256) private _tOwned;
653         mapping (address => mapping (address => uint256)) private _allowances;
654         mapping (address => uint256) public timestamp;
655 
656         mapping (address => bool) private _isExcludedFromFee;
657     
658         mapping (address => bool) private _isExcluded;
659         address[] private _excluded;
660         mapping (address => bool) private _isBlackListedBot;
661         address[] private _blackListedBots;
662     
663         uint256 private constant MAX = ~uint256(0);
664         uint256 private _tTotal = 1000000000 * 10**6 * 10**9;
665         uint256 private _rTotal = (MAX - (MAX % _tTotal));
666         uint256 private _tFeeTotal;
667         uint256 public _CoolDown = 45 seconds;
668 
669         string private _name = 'Reaper Inu';
670         string private _symbol = 'REAPER';
671         uint8 private _decimals = 9;
672          
673         uint256 private _taxFee = 3;
674         uint256 private _teamFee = 7;
675         uint256 private _previousTaxFee = _taxFee;
676         uint256 private _previousteamFee = _teamFee;
677 
678         address payable public _teamWalletAddress;
679         address payable public _marketingWalletAddress;
680         
681         IUniswapV2Router02 public immutable uniswapV2Router;
682         address public immutable uniswapV2Pair;
683 
684         bool inSwap = false;
685         bool public swapEnabled = true;
686         bool public tradingEnabled = false;
687         bool public cooldownEnabled = true;
688 
689         uint256 public _maxTxAmount = 3000000 * 10**6 * 10**9; 
690         //no max tx limit at deploy
691         uint256 private _numOfTokensToExchangeForteam = 5000000000000000;
692 
693         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
694         event SwapEnabledUpdated(bool enabled);
695 
696         modifier lockTheSwap {
697             inSwap = true;
698             _;
699             inSwap = false;
700         }
701 
702         constructor (address payable teamWalletAddress, address payable marketingWalletAddress) public {
703             _teamWalletAddress = teamWalletAddress;
704             _marketingWalletAddress = marketingWalletAddress;
705             _rOwned[_msgSender()] = _rTotal;
706 
707             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
708             // Create a uniswap pair for this new token
709             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
710                 .createPair(address(this), _uniswapV2Router.WETH());
711 
712             // set the rest of the contract variables
713             uniswapV2Router = _uniswapV2Router;
714 
715             // Exclude owner and this contract from fee
716             _isExcludedFromFee[owner()] = true;
717             _isExcludedFromFee[address(this)] = true;
718             
719             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
720             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
721             
722             _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
723             _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
724             
725             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
726             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
727             
728             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
729             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
730     
731             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
732             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
733     
734             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
735             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
736     
737             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
738             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
739     
740             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
741             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
742     
743             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
744             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
745     
746             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
747             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
748     
749             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
750             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
751             
752             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
753             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
754             
755             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
756             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
757             
758             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
759             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
760             
761             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
762             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
763 
764             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
765             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
766             
767             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
768             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
769             
770             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
771             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
772             
773             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
774             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
775             
776             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
777             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
778             
779             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
780             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
781             
782             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
783             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
784             
785             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
786             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
787             
788             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
789             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
790             
791             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
792             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
793             
794             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
795             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
796             
797             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
798             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
799 
800             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
801             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
802             
803             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
804             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
805             
806             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
807             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
808 
809             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
810             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
811 
812             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
813             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
814 
815             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
816             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
817             
818             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
819             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
820             
821             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
822             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
823             
824             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
825             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
826             
827             
828             emit Transfer(address(0), _msgSender(), _tTotal);
829         }
830 
831         function name() public view returns (string memory) {
832             return _name;
833         }
834 
835         function symbol() public view returns (string memory) {
836             return _symbol;
837         }
838 
839         function decimals() public view returns (uint8) {
840             return _decimals;
841         }
842 
843         function totalSupply() public view override returns (uint256) {
844             return _tTotal;
845         }
846 
847         function balanceOf(address account) public view override returns (uint256) {
848             if (_isExcluded[account]) return _tOwned[account];
849             return tokenFromReflection(_rOwned[account]);
850         }
851 
852         function transfer(address recipient, uint256 amount) public override returns (bool) {
853             _transfer(_msgSender(), recipient, amount);
854             return true;
855         }
856 
857         function allowance(address owner, address spender) public view override returns (uint256) {
858             return _allowances[owner][spender];
859         }
860 
861         function approve(address spender, uint256 amount) public override returns (bool) {
862             _approve(_msgSender(), spender, amount);
863             return true;
864         }
865 
866         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
867             _transfer(sender, recipient, amount);
868             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
869             return true;
870         }
871 
872         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
873             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
874             return true;
875         }
876 
877         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
878             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
879             return true;
880         }
881 
882         function isExcluded(address account) public view returns (bool) {
883             return _isExcluded[account];
884         }
885         
886         function isBlackListed(address account) public view returns (bool) {
887             return _isBlackListedBot[account];
888         }
889 
890         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
891             _isExcludedFromFee[account] = excluded;
892         }
893 
894         function totalFees() public view returns (uint256) {
895             return _tFeeTotal;
896         }
897 
898         function deliver(uint256 tAmount) public {
899             address sender = _msgSender();
900             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
901             (uint256 rAmount,,,,,) = _getValues(tAmount);
902             _rOwned[sender] = _rOwned[sender].sub(rAmount);
903             _rTotal = _rTotal.sub(rAmount);
904             _tFeeTotal = _tFeeTotal.add(tAmount);
905         }
906 
907         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
908             require(tAmount <= _tTotal, "Amount must be less than supply");
909             if (!deductTransferFee) {
910                 (uint256 rAmount,,,,,) = _getValues(tAmount);
911                 return rAmount;
912             } else {
913                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
914                 return rTransferAmount;
915             }
916         }
917 
918         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
919             require(rAmount <= _rTotal, "Amount must be less than total reflections");
920             uint256 currentRate =  _getRate();
921             return rAmount.div(currentRate);
922         }
923 
924         function excludeAccount(address account) external onlyOwner() {
925             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
926             require(!_isExcluded[account], "Account is already excluded");
927             if(_rOwned[account] > 0) {
928                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
929             }
930             _isExcluded[account] = true;
931             _excluded.push(account);
932         }
933 
934         function includeAccount(address account) external onlyOwner() {
935             require(_isExcluded[account], "Account is already excluded");
936             for (uint256 i = 0; i < _excluded.length; i++) {
937                 if (_excluded[i] == account) {
938                     _excluded[i] = _excluded[_excluded.length - 1];
939                     _tOwned[account] = 0;
940                     _isExcluded[account] = false;
941                     _excluded.pop();
942                     break;
943                 }
944             }
945         }
946         
947         function addBotToBlackList(address account) external onlyOwner() {
948             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
949             require(!_isBlackListedBot[account], "Account is already blacklisted");
950             _isBlackListedBot[account] = true;
951             _blackListedBots.push(account);
952         }
953     
954         function removeBotFromBlackList(address account) external onlyOwner() {
955             require(_isBlackListedBot[account], "Account is not blacklisted");
956             for (uint256 i = 0; i < _blackListedBots.length; i++) {
957                 if (_blackListedBots[i] == account) {
958                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
959                     _isBlackListedBot[account] = false;
960                     _blackListedBots.pop();
961                     break;
962                 }
963             }
964         }
965 
966         function removeAllFee() private {
967             if(_taxFee == 0 && _teamFee == 0) return;
968             
969             _previousTaxFee = _taxFee;
970             _previousteamFee = _teamFee;
971             
972             _taxFee = 0;
973             _teamFee = 0;
974         }
975     
976         function restoreAllFee() private {
977             _taxFee = _previousTaxFee;
978             _teamFee = _previousteamFee;
979         }
980     
981         function isExcludedFromFee(address account) public view returns(bool) {
982             return _isExcludedFromFee[account];
983         }
984         
985             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
986         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
987             10**2
988         );
989         }
990 
991         function _approve(address owner, address spender, uint256 amount) private {
992             require(owner != address(0), "ERC20: approve from the zero address");
993             require(spender != address(0), "ERC20: approve to the zero address");
994 
995             _allowances[owner][spender] = amount;
996             emit Approval(owner, spender, amount);
997         }
998 
999         function _transfer(address sender, address recipient, uint256 amount) private {
1000             require(sender != address(0), "ERC20: transfer from the zero address");
1001             require(recipient != address(0), "ERC20: transfer to the zero address");
1002             require(amount > 0, "Transfer amount must be greater than zero");
1003             require(!_isBlackListedBot[recipient], "You have no power here!");
1004             require(!_isBlackListedBot[sender], "You have no power here!");
1005 
1006             if(sender != owner() && recipient != owner()) {
1007                     
1008                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1009                 
1010                     //you can't trade this on a dex until trading enabled
1011                     if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled yet");}
1012               
1013             }
1014             
1015             
1016              //cooldown logic starts
1017              
1018              if(cooldownEnabled) {
1019               
1020               //perform all cooldown checks below only if enabled
1021               
1022                       if (sender == uniswapV2Pair ) {
1023                         
1024                         //they just bought add cooldown    
1025                         if (!_isExcluded[recipient]) { timestamp[recipient] = block.timestamp.add(_CoolDown); }
1026 
1027                       }
1028                       
1029 
1030                       // exclude owner and uniswap
1031                       if(sender != owner() && sender != uniswapV2Pair) {
1032 
1033                         // dont apply cooldown to other excluded addresses
1034                         if (!_isExcluded[sender]) { require(block.timestamp >= timestamp[sender], "Cooldown"); }
1035 
1036                       }
1037               
1038              }
1039 
1040             // is the token balance of this contract address over the min number of
1041             // tokens that we need to initiate a swap?
1042             // also, don't get caught in a circular team event.
1043             // also, don't swap if sender is uniswap pair.
1044             uint256 contractTokenBalance = balanceOf(address(this));
1045             
1046             if(contractTokenBalance >= _maxTxAmount)
1047             {
1048                 contractTokenBalance = _maxTxAmount;
1049             }
1050             
1051             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForteam;
1052             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1053                 // We need to swap the current tokens to ETH and send to the team wallet
1054                 swapTokensForEth(contractTokenBalance);
1055                 
1056                 uint256 contractETHBalance = address(this).balance;
1057                 if(contractETHBalance > 0) {
1058                     sendETHToteam(address(this).balance);
1059                 }
1060             }
1061             
1062             //indicates if fee should be deducted from transfer
1063             bool takeFee = true;
1064             
1065             //if any account belongs to _isExcludedFromFee account then remove the fee
1066             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1067                 takeFee = false;
1068             }
1069             
1070             //transfer amount, it will take tax and team fee
1071             _tokenTransfer(sender,recipient,amount,takeFee);
1072         }
1073 
1074         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1075             // generate the uniswap pair path of token -> weth
1076             address[] memory path = new address[](2);
1077             path[0] = address(this);
1078             path[1] = uniswapV2Router.WETH();
1079 
1080             _approve(address(this), address(uniswapV2Router), tokenAmount);
1081 
1082             // make the swap
1083             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1084                 tokenAmount,
1085                 0, // accept any amount of ETH
1086                 path,
1087                 address(this),
1088                 block.timestamp
1089             );
1090         }
1091         
1092         function sendETHToteam(uint256 amount) private {
1093             _teamWalletAddress.transfer(amount.div(2));
1094             _marketingWalletAddress.transfer(amount.div(2));
1095         }
1096         
1097         // We are exposing these functions to be able to manual swap and send
1098         // in case the token is highly valued and 5M becomes too much
1099         function manualSwap() external onlyOwner() {
1100             uint256 contractBalance = balanceOf(address(this));
1101             swapTokensForEth(contractBalance);
1102         }
1103         
1104         function manualSend() external onlyOwner() {
1105             uint256 contractETHBalance = address(this).balance;
1106             sendETHToteam(contractETHBalance);
1107         }
1108 
1109         function setSwapEnabled(bool enabled) external onlyOwner(){
1110             swapEnabled = enabled;
1111         }
1112         
1113         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1114             if(!takeFee)
1115                 removeAllFee();
1116 
1117             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1118                 _transferFromExcluded(sender, recipient, amount);
1119             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1120                 _transferToExcluded(sender, recipient, amount);
1121             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1122                 _transferStandard(sender, recipient, amount);
1123             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1124                 _transferBothExcluded(sender, recipient, amount);
1125             } else {
1126                 _transferStandard(sender, recipient, amount);
1127             }
1128 
1129             if(!takeFee)
1130                 restoreAllFee();
1131         }
1132 
1133         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1134             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1135             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1136             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1137             _taketeam(tteam); 
1138             _reflectFee(rFee, tFee);
1139             emit Transfer(sender, recipient, tTransferAmount);
1140         }
1141 
1142         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1143             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1144             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1145             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1146             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1147             _taketeam(tteam);           
1148             _reflectFee(rFee, tFee);
1149             emit Transfer(sender, recipient, tTransferAmount);
1150         }
1151 
1152         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1153             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1154             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1155             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1156             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1157             _taketeam(tteam);   
1158             _reflectFee(rFee, tFee);
1159             emit Transfer(sender, recipient, tTransferAmount);
1160         }
1161 
1162         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1163             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1164             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1165             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1166             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1167             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1168             _taketeam(tteam);         
1169             _reflectFee(rFee, tFee);
1170             emit Transfer(sender, recipient, tTransferAmount);
1171         }
1172 
1173         function _taketeam(uint256 tteam) private {
1174             uint256 currentRate =  _getRate();
1175             uint256 rteam = tteam.mul(currentRate);
1176             _rOwned[address(this)] = _rOwned[address(this)].add(rteam);
1177             if(_isExcluded[address(this)])
1178                 _tOwned[address(this)] = _tOwned[address(this)].add(tteam);
1179         }
1180 
1181         function _reflectFee(uint256 rFee, uint256 tFee) private {
1182             _rTotal = _rTotal.sub(rFee);
1183             _tFeeTotal = _tFeeTotal.add(tFee);
1184         }
1185 
1186          //to recieve ETH from uniswapV2Router when swaping
1187         receive() external payable {}
1188 
1189         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1190             (uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getTValues(tAmount, _taxFee, _teamFee);
1191             uint256 currentRate =  _getRate();
1192             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1193             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tteam);
1194         }
1195 
1196         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1197             uint256 tFee = tAmount.mul(taxFee).div(100);
1198             uint256 tteam = tAmount.mul(teamFee).div(100);
1199             uint256 tTransferAmount = tAmount.sub(tFee).sub(tteam);
1200             return (tTransferAmount, tFee, tteam);
1201         }
1202 
1203         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1204             uint256 rAmount = tAmount.mul(currentRate);
1205             uint256 rFee = tFee.mul(currentRate);
1206             uint256 rTransferAmount = rAmount.sub(rFee);
1207             return (rAmount, rTransferAmount, rFee);
1208         }
1209 
1210         function _getRate() private view returns(uint256) {
1211             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1212             return rSupply.div(tSupply);
1213         }
1214 
1215         function _getCurrentSupply() private view returns(uint256, uint256) {
1216             uint256 rSupply = _rTotal;
1217             uint256 tSupply = _tTotal;      
1218             for (uint256 i = 0; i < _excluded.length; i++) {
1219                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1220                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1221                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1222             }
1223             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1224             return (rSupply, tSupply);
1225         }
1226         
1227         function _getTaxFee() private view returns(uint256) {
1228             return _taxFee;
1229         }
1230 
1231         function _getMaxTxAmount() private view returns(uint256) {
1232             return _maxTxAmount;
1233         }
1234 
1235         function _getETHBalance() public view returns(uint256 balance) {
1236             return address(this).balance;
1237         }
1238         
1239         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1240             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1241             _taxFee = taxFee;
1242         }
1243 
1244         function _setteamFee(uint256 teamFee) external onlyOwner() {
1245             require(teamFee >= 1 && teamFee <= 11, 'teamFee should be in 1 - 11');
1246             _teamFee = teamFee;
1247         }
1248         
1249         function _setteamWallet(address payable teamWalletAddress) external onlyOwner() {
1250             _teamWalletAddress = teamWalletAddress;
1251         }
1252         
1253          function _setmarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1254             _marketingWalletAddress = marketingWalletAddress;
1255         }
1256         
1257          function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
1258              tradingEnabled = _tradingEnabled;
1259          }
1260          
1261          function ToggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
1262              cooldownEnabled = _cooldownEnabled;
1263          }
1264          
1265           function setCoolDown(uint256 CoolDown) external onlyOwner() {
1266             _CoolDown = (CoolDown * 1 seconds);
1267             }    
1268         
1269         
1270     }