1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-03
3 */
4 
5 /**
6  *Androttweiler was born. The taxes are 12% in Total 3% goes for Marketing, 7% are Dev Fees and 2% for RFI Rewards
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
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
425         function geUnlockTime() public view returns (uint256) {
426             return _lockTime;
427         }
428 
429         //Locks the contract for owner for the amount of time provided
430         function lock(uint256 time) public virtual onlyOwner {
431             _previousOwner = _owner;
432             _owner = address(0);
433             _lockTime = now + time;
434             emit OwnershipTransferred(_owner, address(0));
435         }
436         
437         //Unlocks the contract for owner when _lockTime is exceeds
438         function unlock() public virtual {
439             require(_previousOwner == msg.sender, "You don't have permission to unlock");
440             require(now > _lockTime , "Contract is locked until 7 days");
441             emit OwnershipTransferred(_owner, _previousOwner);
442             _owner = _previousOwner;
443         }
444     }  
445 
446     interface IUniswapV2Factory {
447         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
448 
449         function feeTo() external view returns (address);
450         function feeToSetter() external view returns (address);
451 
452         function getPair(address tokenA, address tokenB) external view returns (address pair);
453         function allPairs(uint) external view returns (address pair);
454         function allPairsLength() external view returns (uint);
455 
456         function createPair(address tokenA, address tokenB) external returns (address pair);
457 
458         function setFeeTo(address) external;
459         function setFeeToSetter(address) external;
460     } 
461 
462     interface IUniswapV2Pair {
463         event Approval(address indexed owner, address indexed spender, uint value);
464         event Transfer(address indexed from, address indexed to, uint value);
465 
466         function name() external pure returns (string memory);
467         function symbol() external pure returns (string memory);
468         function decimals() external pure returns (uint8);
469         function totalSupply() external view returns (uint);
470         function balanceOf(address owner) external view returns (uint);
471         function allowance(address owner, address spender) external view returns (uint);
472 
473         function approve(address spender, uint value) external returns (bool);
474         function transfer(address to, uint value) external returns (bool);
475         function transferFrom(address from, address to, uint value) external returns (bool);
476 
477         function DOMAIN_SEPARATOR() external view returns (bytes32);
478         function PERMIT_TYPEHASH() external pure returns (bytes32);
479         function nonces(address owner) external view returns (uint);
480 
481         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
482 
483         event Mint(address indexed sender, uint amount0, uint amount1);
484         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
485         event Swap(
486             address indexed sender,
487             uint amount0In,
488             uint amount1In,
489             uint amount0Out,
490             uint amount1Out,
491             address indexed to
492         );
493         event Sync(uint112 reserve0, uint112 reserve1);
494 
495         function MINIMUM_LIQUIDITY() external pure returns (uint);
496         function factory() external view returns (address);
497         function token0() external view returns (address);
498         function token1() external view returns (address);
499         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
500         function price0CumulativeLast() external view returns (uint);
501         function price1CumulativeLast() external view returns (uint);
502         function kLast() external view returns (uint);
503 
504         function mint(address to) external returns (uint liquidity);
505         function burn(address to) external returns (uint amount0, uint amount1);
506         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
507         function skim(address to) external;
508         function sync() external;
509 
510         function initialize(address, address) external;
511     }
512 
513     interface IUniswapV2Router01 {
514         function factory() external pure returns (address);
515         function WETH() external pure returns (address);
516 
517         function addLiquidity(
518             address tokenA,
519             address tokenB,
520             uint amountADesired,
521             uint amountBDesired,
522             uint amountAMin,
523             uint amountBMin,
524             address to,
525             uint deadline
526         ) external returns (uint amountA, uint amountB, uint liquidity);
527         function addLiquidityETH(
528             address token,
529             uint amountTokenDesired,
530             uint amountTokenMin,
531             uint amountETHMin,
532             address to,
533             uint deadline
534         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
535         function removeLiquidity(
536             address tokenA,
537             address tokenB,
538             uint liquidity,
539             uint amountAMin,
540             uint amountBMin,
541             address to,
542             uint deadline
543         ) external returns (uint amountA, uint amountB);
544         function removeLiquidityETH(
545             address token,
546             uint liquidity,
547             uint amountTokenMin,
548             uint amountETHMin,
549             address to,
550             uint deadline
551         ) external returns (uint amountToken, uint amountETH);
552         function removeLiquidityWithPermit(
553             address tokenA,
554             address tokenB,
555             uint liquidity,
556             uint amountAMin,
557             uint amountBMin,
558             address to,
559             uint deadline,
560             bool approveMax, uint8 v, bytes32 r, bytes32 s
561         ) external returns (uint amountA, uint amountB);
562         function removeLiquidityETHWithPermit(
563             address token,
564             uint liquidity,
565             uint amountTokenMin,
566             uint amountETHMin,
567             address to,
568             uint deadline,
569             bool approveMax, uint8 v, bytes32 r, bytes32 s
570         ) external returns (uint amountToken, uint amountETH);
571         function swapExactTokensForTokens(
572             uint amountIn,
573             uint amountOutMin,
574             address[] calldata path,
575             address to,
576             uint deadline
577         ) external returns (uint[] memory amounts);
578         function swapTokensForExactTokens(
579             uint amountOut,
580             uint amountInMax,
581             address[] calldata path,
582             address to,
583             uint deadline
584         ) external returns (uint[] memory amounts);
585         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
586             external
587             payable
588             returns (uint[] memory amounts);
589         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
590             external
591             returns (uint[] memory amounts);
592         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
593             external
594             returns (uint[] memory amounts);
595         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
596             external
597             payable
598             returns (uint[] memory amounts);
599 
600         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
601         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
602         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
603         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
604         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
605     }
606 
607     interface IUniswapV2Router02 is IUniswapV2Router01 {
608         function removeLiquidityETHSupportingFeeOnTransferTokens(
609             address token,
610             uint liquidity,
611             uint amountTokenMin,
612             uint amountETHMin,
613             address to,
614             uint deadline
615         ) external returns (uint amountETH);
616         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
617             address token,
618             uint liquidity,
619             uint amountTokenMin,
620             uint amountETHMin,
621             address to,
622             uint deadline,
623             bool approveMax, uint8 v, bytes32 r, bytes32 s
624         ) external returns (uint amountETH);
625 
626         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
627             uint amountIn,
628             uint amountOutMin,
629             address[] calldata path,
630             address to,
631             uint deadline
632         ) external;
633         function swapExactETHForTokensSupportingFeeOnTransferTokens(
634             uint amountOutMin,
635             address[] calldata path,
636             address to,
637             uint deadline
638         ) external payable;
639         function swapExactTokensForETHSupportingFeeOnTransferTokens(
640             uint amountIn,
641             uint amountOutMin,
642             address[] calldata path,
643             address to,
644             uint deadline
645         ) external;
646     }
647 
648     // Contract implementation
649     contract ANDROTTWEILER is Context, IERC20, Ownable {
650         using SafeMath for uint256;
651         using Address for address;
652 
653         mapping (address => uint256) private _rOwned;
654         mapping (address => uint256) private _tOwned;
655         mapping (address => mapping (address => uint256)) private _allowances;
656 
657         mapping (address => bool) private _isExcludedFromFee;
658 
659         mapping (address => bool) private _isExcluded;
660         address[] private _excluded;
661     
662         uint256 private constant MAX = ~uint256(0);
663         uint256 private _tTotal = 1000000000000 * 10**9;
664         uint256 private _rTotal = (MAX - (MAX % _tTotal));
665         uint256 private _tFeeTotal;
666 
667         string private _name = 'ANDROTTWEILER';
668         string private _symbol = 'ANDROTTWEILER';
669         uint8 private _decimals = 9;
670         
671         // Tax and team fees will start at 0 so we don't have a big impact when deploying to Uniswap
672         // Team wallet address is null but the method to set the address is exposed
673         uint256 private _taxFee = 10; 
674         uint256 private _teamFee = 10;
675         uint256 private _previousTaxFee = _taxFee;
676         uint256 private _previousTeamFee = _teamFee;
677 
678         address payable public _teamWalletAddress;
679         address payable public _marketingWalletAddress;
680         
681         IUniswapV2Router02 public immutable uniswapV2Router;
682         address public immutable uniswapV2Pair;
683 
684         bool inSwap = false;
685         bool public swapEnabled = true;
686 
687         uint256 private _maxTxAmount = 100000000000000e9;
688         // We will set a minimum amount of tokens to be swaped => 5M
689         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
690 
691         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
692         event SwapEnabledUpdated(bool enabled);
693 
694         modifier lockTheSwap {
695             inSwap = true;
696             _;
697             inSwap = false;
698         }
699 
700         constructor (address payable teamWalletAddress, address payable marketingWalletAddress) public {
701             _teamWalletAddress = teamWalletAddress;
702             _marketingWalletAddress = marketingWalletAddress;
703             _rOwned[_msgSender()] = _rTotal;
704 
705             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
706             // Create a uniswap pair for this new token
707             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
708                 .createPair(address(this), _uniswapV2Router.WETH());
709 
710             // set the rest of the contract variables
711             uniswapV2Router = _uniswapV2Router;
712 
713             // Exclude owner and this contract from fee
714             _isExcludedFromFee[owner()] = true;
715             _isExcludedFromFee[address(this)] = true;
716 
717             emit Transfer(address(0), _msgSender(), _tTotal);
718         }
719 
720         function name() public view returns (string memory) {
721             return _name;
722         }
723 
724         function symbol() public view returns (string memory) {
725             return _symbol;
726         }
727 
728         function decimals() public view returns (uint8) {
729             return _decimals;
730         }
731 
732         function totalSupply() public view override returns (uint256) {
733             return _tTotal;
734         }
735 
736         function balanceOf(address account) public view override returns (uint256) {
737             if (_isExcluded[account]) return _tOwned[account];
738             return tokenFromReflection(_rOwned[account]);
739         }
740 
741         function transfer(address recipient, uint256 amount) public override returns (bool) {
742             _transfer(_msgSender(), recipient, amount);
743             return true;
744         }
745 
746         function allowance(address owner, address spender) public view override returns (uint256) {
747             return _allowances[owner][spender];
748         }
749 
750         function approve(address spender, uint256 amount) public override returns (bool) {
751             _approve(_msgSender(), spender, amount);
752             return true;
753         }
754 
755         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
756             _transfer(sender, recipient, amount);
757             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
758             return true;
759         }
760 
761         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
762             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
763             return true;
764         }
765 
766         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
767             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
768             return true;
769         }
770 
771         function isExcluded(address account) public view returns (bool) {
772             return _isExcluded[account];
773         }
774 
775         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
776             _isExcludedFromFee[account] = excluded;
777         }
778 
779         function totalFees() public view returns (uint256) {
780             return _tFeeTotal;
781         }
782 
783         function deliver(uint256 tAmount) public {
784             address sender = _msgSender();
785             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
786             (uint256 rAmount,,,,,) = _getValues(tAmount);
787             _rOwned[sender] = _rOwned[sender].sub(rAmount);
788             _rTotal = _rTotal.sub(rAmount);
789             _tFeeTotal = _tFeeTotal.add(tAmount);
790         }
791 
792         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
793             require(tAmount <= _tTotal, "Amount must be less than supply");
794             if (!deductTransferFee) {
795                 (uint256 rAmount,,,,,) = _getValues(tAmount);
796                 return rAmount;
797             } else {
798                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
799                 return rTransferAmount;
800             }
801         }
802 
803         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
804             require(rAmount <= _rTotal, "Amount must be less than total reflections");
805             uint256 currentRate =  _getRate();
806             return rAmount.div(currentRate);
807         }
808 
809         function excludeAccount(address account) external onlyOwner() {
810             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
811             require(!_isExcluded[account], "Account is already excluded");
812             if(_rOwned[account] > 0) {
813                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
814             }
815             _isExcluded[account] = true;
816             _excluded.push(account);
817         }
818 
819         function includeAccount(address account) external onlyOwner() {
820             require(_isExcluded[account], "Account is already excluded");
821             for (uint256 i = 0; i < _excluded.length; i++) {
822                 if (_excluded[i] == account) {
823                     _excluded[i] = _excluded[_excluded.length - 1];
824                     _tOwned[account] = 0;
825                     _isExcluded[account] = false;
826                     _excluded.pop();
827                     break;
828                 }
829             }
830         }
831 
832         function removeAllFee() private {
833             if(_taxFee == 0 && _teamFee == 0) return;
834             
835             _previousTaxFee = _taxFee;
836             _previousTeamFee = _teamFee;
837             
838             _taxFee = 0;
839             _teamFee = 0;
840         }
841     
842         function restoreAllFee() private {
843             _taxFee = _previousTaxFee;
844             _teamFee = _previousTeamFee;
845         }
846     
847         function isExcludedFromFee(address account) public view returns(bool) {
848             return _isExcludedFromFee[account];
849         }
850 
851         function _approve(address owner, address spender, uint256 amount) private {
852             require(owner != address(0), "ERC20: approve from the zero address");
853             require(spender != address(0), "ERC20: approve to the zero address");
854 
855             _allowances[owner][spender] = amount;
856             emit Approval(owner, spender, amount);
857         }
858 
859         function _transfer(address sender, address recipient, uint256 amount) private {
860             require(sender != address(0), "ERC20: transfer from the zero address");
861             require(recipient != address(0), "ERC20: transfer to the zero address");
862             require(amount > 0, "Transfer amount must be greater than zero");
863             
864             if(sender != owner() && recipient != owner())
865                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
866 
867             // is the token balance of this contract address over the min number of
868             // tokens that we need to initiate a swap?
869             // also, don't get caught in a circular team event.
870             // also, don't swap if sender is uniswap pair.
871             uint256 contractTokenBalance = balanceOf(address(this));
872             
873             if(contractTokenBalance >= _maxTxAmount)
874             {
875                 contractTokenBalance = _maxTxAmount;
876             }
877             
878             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
879             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
880                 // We need to swap the current tokens to ETH and send to the team wallet
881                 swapTokensForEth(contractTokenBalance);
882                 
883                 uint256 contractETHBalance = address(this).balance;
884                 if(contractETHBalance > 0) {
885                     sendETHToTeam(address(this).balance);
886                 }
887             }
888             
889             //indicates if fee should be deducted from transfer
890             bool takeFee = true;
891             
892             //if any account belongs to _isExcludedFromFee account then remove the fee
893             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
894                 takeFee = false;
895             }
896             
897             //transfer amount, it will take tax and team fee
898             _tokenTransfer(sender,recipient,amount,takeFee);
899         }
900 
901         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
902             // generate the uniswap pair path of token -> weth
903             address[] memory path = new address[](2);
904             path[0] = address(this);
905             path[1] = uniswapV2Router.WETH();
906 
907             _approve(address(this), address(uniswapV2Router), tokenAmount);
908 
909             // make the swap
910             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
911                 tokenAmount,
912                 0, // accept any amount of ETH
913                 path,
914                 address(this),
915                 block.timestamp
916             );
917         }
918         
919         function sendETHToTeam(uint256 amount) private {
920             _teamWalletAddress.transfer(amount.div(2));
921             _marketingWalletAddress.transfer(amount.div(2));
922         }
923         
924         // We are exposing these functions to be able to manual swap and send
925         // in case the token is highly valued and 5M becomes too much
926         function manualSwap() external onlyOwner() {
927             uint256 contractBalance = balanceOf(address(this));
928             swapTokensForEth(contractBalance);
929         }
930         
931         function manualSend() external onlyOwner() {
932             uint256 contractETHBalance = address(this).balance;
933             sendETHToTeam(contractETHBalance);
934         }
935 
936         function setSwapEnabled(bool enabled) external onlyOwner(){
937             swapEnabled = enabled;
938         }
939         
940         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
941             if(!takeFee)
942                 removeAllFee();
943 
944             if (_isExcluded[sender] && !_isExcluded[recipient]) {
945                 _transferFromExcluded(sender, recipient, amount);
946             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
947                 _transferToExcluded(sender, recipient, amount);
948             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
949                 _transferStandard(sender, recipient, amount);
950             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
951                 _transferBothExcluded(sender, recipient, amount);
952             } else {
953                 _transferStandard(sender, recipient, amount);
954             }
955 
956             if(!takeFee)
957                 restoreAllFee();
958         }
959 
960         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
961             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
962             _rOwned[sender] = _rOwned[sender].sub(rAmount);
963             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
964             _takeTeam(tTeam); 
965             _reflectFee(rFee, tFee);
966             emit Transfer(sender, recipient, tTransferAmount);
967         }
968 
969         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
970             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
971             _rOwned[sender] = _rOwned[sender].sub(rAmount);
972             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
973             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
974             _takeTeam(tTeam);           
975             _reflectFee(rFee, tFee);
976             emit Transfer(sender, recipient, tTransferAmount);
977         }
978 
979         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
980             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
981             _tOwned[sender] = _tOwned[sender].sub(tAmount);
982             _rOwned[sender] = _rOwned[sender].sub(rAmount);
983             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
984             _takeTeam(tTeam);   
985             _reflectFee(rFee, tFee);
986             emit Transfer(sender, recipient, tTransferAmount);
987         }
988 
989         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
990             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
991             _tOwned[sender] = _tOwned[sender].sub(tAmount);
992             _rOwned[sender] = _rOwned[sender].sub(rAmount);
993             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
994             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
995             _takeTeam(tTeam);         
996             _reflectFee(rFee, tFee);
997             emit Transfer(sender, recipient, tTransferAmount);
998         }
999 
1000         function _takeTeam(uint256 tTeam) private {
1001             uint256 currentRate =  _getRate();
1002             uint256 rTeam = tTeam.mul(currentRate);
1003             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1004             if(_isExcluded[address(this)])
1005                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1006         }
1007 
1008         function _reflectFee(uint256 rFee, uint256 tFee) private {
1009             _rTotal = _rTotal.sub(rFee);
1010             _tFeeTotal = _tFeeTotal.add(tFee);
1011         }
1012 
1013          //to recieve ETH from uniswapV2Router when swaping
1014         receive() external payable {}
1015 
1016         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1017             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1018             uint256 currentRate =  _getRate();
1019             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1020             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1021         }
1022 
1023         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1024             uint256 tFee = tAmount.mul(taxFee).div(100);
1025             uint256 tTeam = tAmount.mul(teamFee).div(100);
1026             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1027             return (tTransferAmount, tFee, tTeam);
1028         }
1029 
1030         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1031             uint256 rAmount = tAmount.mul(currentRate);
1032             uint256 rFee = tFee.mul(currentRate);
1033             uint256 rTransferAmount = rAmount.sub(rFee);
1034             return (rAmount, rTransferAmount, rFee);
1035         }
1036 
1037         function _getRate() private view returns(uint256) {
1038             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1039             return rSupply.div(tSupply);
1040         }
1041 
1042         function _getCurrentSupply() private view returns(uint256, uint256) {
1043             uint256 rSupply = _rTotal;
1044             uint256 tSupply = _tTotal;      
1045             for (uint256 i = 0; i < _excluded.length; i++) {
1046                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1047                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1048                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1049             }
1050             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1051             return (rSupply, tSupply);
1052         }
1053         
1054         function _getTaxFee() private view returns(uint256) {
1055             return _taxFee;
1056         }
1057 
1058         function _getMaxTxAmount() private view returns(uint256) {
1059             return _maxTxAmount;
1060         }
1061 
1062         function _getETHBalance() public view returns(uint256 balance) {
1063             return address(this).balance;
1064         }
1065         
1066         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1067             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1068             _taxFee = taxFee;
1069         }
1070 
1071         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1072             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1073             _teamFee = teamFee;
1074         }
1075         
1076         function _setTeamWallet(address payable teamWalletAddress) external onlyOwner() {
1077             _teamWalletAddress = teamWalletAddress;
1078         }
1079         
1080         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1081             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1082             _maxTxAmount = maxTxAmount;
1083         }
1084     }