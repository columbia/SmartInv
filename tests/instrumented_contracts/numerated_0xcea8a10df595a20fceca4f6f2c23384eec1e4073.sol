1 /*
2            _____                    _____          
3          /\    \                  /\    \         
4         /::\    \                /::\    \        
5        /::::\    \              /::::\    \       
6       /::::::\    \            /::::::\    \      
7      /:::/\:::\    \          /:::/\:::\    \     
8     /:::/  \:::\    \        /:::/  \:::\    \    
9    /:::/    \:::\    \      /:::/    \:::\    \   
10   /:::/    / \:::\    \    /:::/    / \:::\    \  
11  /:::/    /   \:::\ ___\  /:::/    /   \:::\ ___\ 
12 /:::/____/  ___\:::|    |/:::/____/  ___\:::|    |
13 \:::\    \ /\  /:::|____|\:::\    \ /\  /:::|____|
14  \:::\    /::\ \::/    /  \:::\    /::\ \::/    / 
15   \:::\   \:::\ \/____/    \:::\   \:::\ \/____/  
16    \:::\   \:::\____\       \:::\   \:::\____\    
17     \:::\  /:::/    /        \:::\  /:::/    /    
18      \:::\/:::/    /          \:::\/:::/    /     
19       \::::::/    /            \::::::/    /      
20        \::::/    /              \::::/    /       
21         \::/____/                \::/____/        
22                                                   
23  Telegram
24  https://t.me/GoodGameETH
25  
26  Website
27  https://goodgametoken.io/
28  
29  
30 */
31 
32 // SPDX-License-Identifier: Unlicensed
33 
34 pragma solidity ^0.6.12;
35 
36     abstract contract Context {
37         function _msgSender() internal view virtual returns (address payable) {
38             return msg.sender;
39         }
40 
41         function _msgData() internal view virtual returns (bytes memory) {
42             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43             return msg.data;
44         }
45     }
46 
47     interface IERC20 {
48         /**
49         * @dev Returns the amount of tokens in existence.
50         */
51         function totalSupply() external view returns (uint256);
52 
53         /**
54         * @dev Returns the amount of tokens owned by `account`.
55         */
56         function balanceOf(address account) external view returns (uint256);
57 
58         /**
59         * @dev Moves `amount` tokens from the caller's account to `recipient`.
60         *
61         * Returns a boolean value indicating whether the operation succeeded.
62         *
63         * Emits a {Transfer} event.
64         */
65         function transfer(address recipient, uint256 amount) external returns (bool);
66 
67         /**
68         * @dev Returns the remaining number of tokens that `spender` will be
69         * allowed to spend on behalf of `owner` through {transferFrom}. This is
70         * zero by default.
71         *
72         * This value changes when {approve} or {transferFrom} are called.
73         */
74         function allowance(address owner, address spender) external view returns (uint256);
75 
76         /**
77         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78         *
79         * Returns a boolean value indicating whether the operation succeeded.
80         *
81         * IMPORTANT: Beware that changing an allowance with this method brings the risk
82         * that someone may use both the old and the new allowance by unfortunate
83         * transaction ordering. One possible solution to mitigate this race
84         * condition is to first reduce the spender's allowance to 0 and set the
85         * desired value afterwards:
86         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87         *
88         * Emits an {Approval} event.
89         */
90         function approve(address spender, uint256 amount) external returns (bool);
91 
92         /**
93         * @dev Moves `amount` tokens from `sender` to `recipient` using the
94         * allowance mechanism. `amount` is then deducted from the caller's
95         * allowance.
96         *
97         * Returns a boolean value indicating whether the operation succeeded.
98         *
99         * Emits a {Transfer} event.
100         */
101         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102 
103         /**
104         * @dev Emitted when `value` tokens are moved from one account (`from`) to
105         * another (`to`).
106         *
107         * Note that `value` may be zero.
108         */
109         event Transfer(address indexed from, address indexed to, uint256 value);
110 
111         /**
112         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113         * a call to {approve}. `value` is the new allowance.
114         */
115         event Approval(address indexed owner, address indexed spender, uint256 value);
116     }
117 
118     library SafeMath {
119         /**
120         * @dev Returns the addition of two unsigned integers, reverting on
121         * overflow.
122         *
123         * Counterpart to Solidity's `+` operator.
124         *
125         * Requirements:
126         *
127         * - Addition cannot overflow.
128         */
129         function add(uint256 a, uint256 b) internal pure returns (uint256) {
130             uint256 c = a + b;
131             require(c >= a, "SafeMath: addition overflow");
132 
133             return c;
134         }
135 
136         /**
137         * @dev Returns the subtraction of two unsigned integers, reverting on
138         * overflow (when the result is negative).
139         *
140         * Counterpart to Solidity's `-` operator.
141         *
142         * Requirements:
143         *
144         * - Subtraction cannot overflow.
145         */
146         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147             return sub(a, b, "SafeMath: subtraction overflow");
148         }
149 
150         /**
151         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152         * overflow (when the result is negative).
153         *
154         * Counterpart to Solidity's `-` operator.
155         *
156         * Requirements:
157         *
158         * - Subtraction cannot overflow.
159         */
160         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161             require(b <= a, errorMessage);
162             uint256 c = a - b;
163 
164             return c;
165         }
166 
167         /**
168         * @dev Returns the multiplication of two unsigned integers, reverting on
169         * overflow.
170         *
171         * Counterpart to Solidity's `*` operator.
172         *
173         * Requirements:
174         *
175         * - Multiplication cannot overflow.
176         */
177         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179             // benefit is lost if 'b' is also tested.
180             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181             if (a == 0) {
182                 return 0;
183             }
184 
185             uint256 c = a * b;
186             require(c / a == b, "SafeMath: multiplication overflow");
187 
188             return c;
189         }
190 
191         /**
192         * @dev Returns the integer division of two unsigned integers. Reverts on
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
203         function div(uint256 a, uint256 b) internal pure returns (uint256) {
204             return div(a, b, "SafeMath: division by zero");
205         }
206 
207         /**
208         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209         * division by zero. The result is rounded towards zero.
210         *
211         * Counterpart to Solidity's `/` operator. Note: this function uses a
212         * `revert` opcode (which leaves remaining gas untouched) while Solidity
213         * uses an invalid opcode to revert (consuming all remaining gas).
214         *
215         * Requirements:
216         *
217         * - The divisor cannot be zero.
218         */
219         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220             require(b > 0, errorMessage);
221             uint256 c = a / b;
222             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224             return c;
225         }
226 
227         /**
228         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229         * Reverts when dividing by zero.
230         *
231         * Counterpart to Solidity's `%` operator. This function uses a `revert`
232         * opcode (which leaves remaining gas untouched) while Solidity uses an
233         * invalid opcode to revert (consuming all remaining gas).
234         *
235         * Requirements:
236         *
237         * - The divisor cannot be zero.
238         */
239         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240             return mod(a, b, "SafeMath: modulo by zero");
241         }
242 
243         /**
244         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245         * Reverts with custom message when dividing by zero.
246         *
247         * Counterpart to Solidity's `%` operator. This function uses a `revert`
248         * opcode (which leaves remaining gas untouched) while Solidity uses an
249         * invalid opcode to revert (consuming all remaining gas).
250         *
251         * Requirements:
252         *
253         * - The divisor cannot be zero.
254         */
255         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256             require(b != 0, errorMessage);
257             return a % b;
258         }
259     }
260 
261     library Address {
262         /**
263         * @dev Returns true if `account` is a contract.
264         *
265         * [IMPORTANT]
266         * ====
267         * It is unsafe to assume that an address for which this function returns
268         * false is an externally-owned account (EOA) and not a contract.
269         *
270         * Among others, `isContract` will return false for the following
271         * types of addresses:
272         *
273         *  - an externally-owned account
274         *  - a contract in construction
275         *  - an address where a contract will be created
276         *  - an address where a contract lived, but was destroyed
277         * ====
278         */
279         function isContract(address account) internal view returns (bool) {
280             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
281             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
282             // for accounts without code, i.e. `keccak256('')`
283             bytes32 codehash;
284             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
285             // solhint-disable-next-line no-inline-assembly
286             assembly { codehash := extcodehash(account) }
287             return (codehash != accountHash && codehash != 0x0);
288         }
289 
290         /**
291         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292         * `recipient`, forwarding all available gas and reverting on errors.
293         *
294         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295         * of certain opcodes, possibly making contracts go over the 2300 gas limit
296         * imposed by `transfer`, making them unable to receive funds via
297         * `transfer`. {sendValue} removes this limitation.
298         *
299         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300         *
301         * IMPORTANT: because control is transferred to `recipient`, care must be
302         * taken to not create reentrancy vulnerabilities. Consider using
303         * {ReentrancyGuard} or the
304         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305         */
306         function sendValue(address payable recipient, uint256 amount) internal {
307             require(address(this).balance >= amount, "Address: insufficient balance");
308 
309             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
310             (bool success, ) = recipient.call{ value: amount }("");
311             require(success, "Address: unable to send value, recipient may have reverted");
312         }
313 
314         /**
315         * @dev Performs a Solidity function call using a low level `call`. A
316         * plain`call` is an unsafe replacement for a function call: use this
317         * function instead.
318         *
319         * If `target` reverts with a revert reason, it is bubbled up by this
320         * function (like regular Solidity function calls).
321         *
322         * Returns the raw returned data. To convert to the expected return value,
323         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324         *
325         * Requirements:
326         *
327         * - `target` must be a contract.
328         * - calling `target` with `data` must not revert.
329         *
330         * _Available since v3.1._
331         */
332         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334         }
335 
336         /**
337         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338         * `errorMessage` as a fallback revert reason when `target` reverts.
339         *
340         * _Available since v3.1._
341         */
342         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
343             return _functionCallWithValue(target, data, 0, errorMessage);
344         }
345 
346         /**
347         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348         * but also transferring `value` wei to `target`.
349         *
350         * Requirements:
351         *
352         * - the calling contract must have an ETH balance of at least `value`.
353         * - the called Solidity function must be `payable`.
354         *
355         * _Available since v3.1._
356         */
357         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
358             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359         }
360 
361         /**
362         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363         * with `errorMessage` as a fallback revert reason when `target` reverts.
364         *
365         * _Available since v3.1._
366         */
367         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
368             require(address(this).balance >= value, "Address: insufficient balance for call");
369             return _functionCallWithValue(target, data, value, errorMessage);
370         }
371 
372         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
373             require(isContract(target), "Address: call to non-contract");
374 
375             // solhint-disable-next-line avoid-low-level-calls
376             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
377             if (success) {
378                 return returndata;
379             } else {
380                 // Look for revert reason and bubble it up if present
381                 if (returndata.length > 0) {
382                     // The easiest way to bubble the revert reason is using memory via assembly
383 
384                     // solhint-disable-next-line no-inline-assembly
385                     assembly {
386                         let returndata_size := mload(returndata)
387                         revert(add(32, returndata), returndata_size)
388                     }
389                 } else {
390                     revert(errorMessage);
391                 }
392             }
393         }
394     }
395 
396     contract Ownable is Context {
397         address private _owner;
398         address private _previousOwner;
399         uint256 private _lockTime;
400 
401         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403         /**
404         * @dev Initializes the contract setting the deployer as the initial owner.
405         */
406         constructor () internal {
407             address msgSender = _msgSender();
408             _owner = msgSender;
409             emit OwnershipTransferred(address(0), msgSender);
410         }
411 
412         /**
413         * @dev Returns the address of the current owner.
414         */
415         function owner() public view returns (address) {
416             return _owner;
417         }
418 
419         /**
420         * @dev Throws if called by any account other than the owner.
421         */
422         modifier onlyOwner() {
423             require(_owner == _msgSender(), "Ownable: caller is not the owner");
424             _;
425         }
426 
427         /**
428         * @dev Leaves the contract without owner. It will not be possible to call
429         * `onlyOwner` functions anymore. Can only be called by the current owner.
430         *
431         * NOTE: Renouncing ownership will leave the contract without an owner,
432         * thereby removing any functionality that is only available to the owner.
433         */
434         function renounceOwnership() public virtual onlyOwner {
435             emit OwnershipTransferred(_owner, address(0));
436             _owner = address(0);
437         }
438 
439         /**
440         * @dev Transfers ownership of the contract to a new account (`newOwner`).
441         * Can only be called by the current owner.
442         */
443         function transferOwnership(address newOwner) public virtual onlyOwner {
444             require(newOwner != address(0), "Ownable: new owner is the zero address");
445             emit OwnershipTransferred(_owner, newOwner);
446             _owner = newOwner;
447         }
448 
449         function getUnlockTime() public view returns (uint256) {
450             return _lockTime;
451         }
452 
453     }
454 
455     interface IUniswapV2Factory {
456         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
457 
458         function feeTo() external view returns (address);
459         function feeToSetter() external view returns (address);
460 
461         function getPair(address tokenA, address tokenB) external view returns (address pair);
462         function allPairs(uint) external view returns (address pair);
463         function allPairsLength() external view returns (uint);
464 
465         function createPair(address tokenA, address tokenB) external returns (address pair);
466 
467         function setFeeTo(address) external;
468         function setFeeToSetter(address) external;
469     }
470 
471     interface IUniswapV2Pair {
472         event Approval(address indexed owner, address indexed spender, uint value);
473         event Transfer(address indexed from, address indexed to, uint value);
474 
475         function name() external pure returns (string memory);
476         function symbol() external pure returns (string memory);
477         function decimals() external pure returns (uint8);
478         function totalSupply() external view returns (uint);
479         function balanceOf(address owner) external view returns (uint);
480         function allowance(address owner, address spender) external view returns (uint);
481 
482         function approve(address spender, uint value) external returns (bool);
483         function transfer(address to, uint value) external returns (bool);
484         function transferFrom(address from, address to, uint value) external returns (bool);
485 
486         function DOMAIN_SEPARATOR() external view returns (bytes32);
487         function PERMIT_TYPEHASH() external pure returns (bytes32);
488         function nonces(address owner) external view returns (uint);
489 
490         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
491 
492         event Mint(address indexed sender, uint amount0, uint amount1);
493         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
494         event Swap(
495             address indexed sender,
496             uint amount0In,
497             uint amount1In,
498             uint amount0Out,
499             uint amount1Out,
500             address indexed to
501         );
502         event Sync(uint112 reserve0, uint112 reserve1);
503 
504         function MINIMUM_LIQUIDITY() external pure returns (uint);
505         function factory() external view returns (address);
506         function token0() external view returns (address);
507         function token1() external view returns (address);
508         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
509         function price0CumulativeLast() external view returns (uint);
510         function price1CumulativeLast() external view returns (uint);
511         function kLast() external view returns (uint);
512 
513         function mint(address to) external returns (uint liquidity);
514         function burn(address to) external returns (uint amount0, uint amount1);
515         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
516         function skim(address to) external;
517         function sync() external;
518 
519         function initialize(address, address) external;
520     }
521 
522     interface IUniswapV2Router01 {
523         function factory() external pure returns (address);
524         function WETH() external pure returns (address);
525 
526         function addLiquidity(
527             address tokenA,
528             address tokenB,
529             uint amountADesired,
530             uint amountBDesired,
531             uint amountAMin,
532             uint amountBMin,
533             address to,
534             uint deadline
535         ) external returns (uint amountA, uint amountB, uint liquidity);
536         function addLiquidityETH(
537             address token,
538             uint amountTokenDesired,
539             uint amountTokenMin,
540             uint amountETHMin,
541             address to,
542             uint deadline
543         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
544         function removeLiquidity(
545             address tokenA,
546             address tokenB,
547             uint liquidity,
548             uint amountAMin,
549             uint amountBMin,
550             address to,
551             uint deadline
552         ) external returns (uint amountA, uint amountB);
553         function removeLiquidityETH(
554             address token,
555             uint liquidity,
556             uint amountTokenMin,
557             uint amountETHMin,
558             address to,
559             uint deadline
560         ) external returns (uint amountToken, uint amountETH);
561         function removeLiquidityWithPermit(
562             address tokenA,
563             address tokenB,
564             uint liquidity,
565             uint amountAMin,
566             uint amountBMin,
567             address to,
568             uint deadline,
569             bool approveMax, uint8 v, bytes32 r, bytes32 s
570         ) external returns (uint amountA, uint amountB);
571         function removeLiquidityETHWithPermit(
572             address token,
573             uint liquidity,
574             uint amountTokenMin,
575             uint amountETHMin,
576             address to,
577             uint deadline,
578             bool approveMax, uint8 v, bytes32 r, bytes32 s
579         ) external returns (uint amountToken, uint amountETH);
580         function swapExactTokensForTokens(
581             uint amountIn,
582             uint amountOutMin,
583             address[] calldata path,
584             address to,
585             uint deadline
586         ) external returns (uint[] memory amounts);
587         function swapTokensForExactTokens(
588             uint amountOut,
589             uint amountInMax,
590             address[] calldata path,
591             address to,
592             uint deadline
593         ) external returns (uint[] memory amounts);
594         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
595             external
596             payable
597             returns (uint[] memory amounts);
598         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
599             external
600             returns (uint[] memory amounts);
601         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
602             external
603             returns (uint[] memory amounts);
604         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
605             external
606             payable
607             returns (uint[] memory amounts);
608 
609         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
610         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
611         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
612         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
613         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
614     }
615 
616     interface IUniswapV2Router02 is IUniswapV2Router01 {
617         function removeLiquidityETHSupportingFeeOnTransferTokens(
618             address token,
619             uint liquidity,
620             uint amountTokenMin,
621             uint amountETHMin,
622             address to,
623             uint deadline
624         ) external returns (uint amountETH);
625         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
626             address token,
627             uint liquidity,
628             uint amountTokenMin,
629             uint amountETHMin,
630             address to,
631             uint deadline,
632             bool approveMax, uint8 v, bytes32 r, bytes32 s
633         ) external returns (uint amountETH);
634 
635         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
636             uint amountIn,
637             uint amountOutMin,
638             address[] calldata path,
639             address to,
640             uint deadline
641         ) external;
642         function swapExactETHForTokensSupportingFeeOnTransferTokens(
643             uint amountOutMin,
644             address[] calldata path,
645             address to,
646             uint deadline
647         ) external payable;
648         function swapExactTokensForETHSupportingFeeOnTransferTokens(
649             uint amountIn,
650             uint amountOutMin,
651             address[] calldata path,
652             address to,
653             uint deadline
654         ) external;
655     }
656 
657     contract GG is Context, IERC20, Ownable {
658         using SafeMath for uint256;
659         using Address for address;
660 
661         mapping (address => uint256) private _rOwned;
662         mapping (address => uint256) private _tOwned;
663         mapping (address => mapping (address => uint256)) private _allowances;
664 
665         mapping (address => bool) private _isExcludedFromFee;
666 
667         mapping (address => bool) private _isExcluded;
668         address[] private _excluded;
669         mapping (address => bool) private _isBlackListedBot;
670         address[] private _blackListedBots;
671 
672         uint256 private constant MAX = ~uint256(0);
673         uint256 private constant _tTotal = 1000000000 * 10**18;
674         uint256 private _rTotal = (MAX - (MAX % _tTotal));
675         uint256 private _tFeeTotal;
676 
677         string private constant _name = 'Good Game ';
678         string private constant _symbol = 'GG';
679         uint8 private constant _decimals = 18;
680 
681         uint256 private _taxFee = 1;
682         uint256 private _teamFee = 10;
683         uint256 private _previousTaxFee = _taxFee;
684         uint256 private _previousTeamFee = _teamFee;
685 
686         address payable public _devWalletAddress;
687         address payable public _marketingWalletAddress;
688 
689 
690         IUniswapV2Router02 public immutable uniswapV2Router;
691         address public immutable uniswapV2Pair;
692 
693         bool inSwap = false;
694         bool public swapEnabled = true;
695 
696         uint256 private _maxTxAmount = 20000000 * 10**18;
697         uint256 private constant _numOfTokensToExchangeForTeam = 7000 * 10**18;
698         uint256 private _maxWalletSize = 20000000 * 10**18;
699 
700         event botAddedToBlacklist(address account);
701         event botRemovedFromBlacklist(address account);
702 
703         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
704         // event SwapEnabledUpdated(bool enabled);
705 
706         modifier lockTheSwap {
707             inSwap = true;
708             _;
709             inSwap = false;
710         }
711 
712         constructor (address payable devWalletAddress, address payable marketingWalletAddress) public {
713             _devWalletAddress = devWalletAddress;
714             _marketingWalletAddress = marketingWalletAddress;
715 
716             _rOwned[_msgSender()] = _rTotal;
717 
718             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
719             // Create a uniswap pair for this new token
720             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
721                 .createPair(address(this), _uniswapV2Router.WETH());
722 
723             // set the rest of the contract variables
724             uniswapV2Router = _uniswapV2Router;
725 
726             // Exclude owner and this contract from fee
727             _isExcludedFromFee[owner()] = true;
728             _isExcludedFromFee[address(this)] = true;
729 
730             emit Transfer(address(0), _msgSender(), _tTotal);
731         }
732 
733         function name() public pure returns (string memory) {
734             return _name;
735         }
736 
737         function symbol() public pure returns (string memory) {
738             return _symbol;
739         }
740 
741         function decimals() public pure returns (uint8) {
742             return _decimals;
743         }
744 
745         function totalSupply() public view override returns (uint256) {
746             return _tTotal;
747         }
748 
749         function balanceOf(address account) public view override returns (uint256) {
750             if (_isExcluded[account]) return _tOwned[account];
751             return tokenFromReflection(_rOwned[account]);
752         }
753 
754         function transfer(address recipient, uint256 amount) public override returns (bool) {
755             _transfer(_msgSender(), recipient, amount);
756             return true;
757         }
758 
759         function allowance(address owner, address spender) public view override returns (uint256) {
760             return _allowances[owner][spender];
761         }
762 
763         function approve(address spender, uint256 amount) public override returns (bool) {
764             _approve(_msgSender(), spender, amount);
765             return true;
766         }
767 
768         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
769             _transfer(sender, recipient, amount);
770             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
771             return true;
772         }
773 
774         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
775             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
776             return true;
777         }
778 
779         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
780             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
781             return true;
782         }
783 
784         function isExcluded(address account) public view returns (bool) {
785             return _isExcluded[account];
786         }
787 
788         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
789             _isExcludedFromFee[account] = excluded;
790         }
791 
792         function totalFees() public view returns (uint256) {
793             return _tFeeTotal;
794         }
795 
796         function deliver(uint256 tAmount) public {
797             address sender = _msgSender();
798             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
799             (uint256 rAmount,,,,,) = _getValues(tAmount);
800             _rOwned[sender] = _rOwned[sender].sub(rAmount);
801             _rTotal = _rTotal.sub(rAmount);
802             _tFeeTotal = _tFeeTotal.add(tAmount);
803         }
804 
805         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
806             require(tAmount <= _tTotal, "Amount must be less than supply");
807             if (!deductTransferFee) {
808                 (uint256 rAmount,,,,,) = _getValues(tAmount);
809                 return rAmount;
810             } else {
811                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
812                 return rTransferAmount;
813             }
814         }
815 
816         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
817             require(rAmount <= _rTotal, "Amount must be less than total reflections");
818             uint256 currentRate =  _getRate();
819             return rAmount.div(currentRate);
820         }
821 
822         function addBotToBlacklist (address account) external onlyOwner() {
823            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
824            require (!_isBlackListedBot[account], 'Account is already blacklisted');
825            _isBlackListedBot[account] = true;
826            _blackListedBots.push(account);
827         }
828 
829         function removeBotFromBlacklist(address account) external onlyOwner() {
830           require (_isBlackListedBot[account], 'Account is not blacklisted');
831           for (uint256 i = 0; i < _blackListedBots.length; i++) {
832                  if (_blackListedBots[i] == account) {
833                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
834                      _isBlackListedBot[account] = false;
835                      _blackListedBots.pop();
836                      break;
837                  }
838            }
839        }
840 
841         function excludeAccount(address account) external onlyOwner() {
842             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
843             require(!_isExcluded[account], "Account is already excluded");
844             if(_rOwned[account] > 0) {
845                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
846             }
847             _isExcluded[account] = true;
848             _excluded.push(account);
849         }
850 
851         function includeAccount(address account) external onlyOwner() {
852             require(_isExcluded[account], "Account is not excluded");
853             for (uint256 i = 0; i < _excluded.length; i++) {
854                 if (_excluded[i] == account) {
855                     _excluded[i] = _excluded[_excluded.length - 1];
856                     _tOwned[account] = 0;
857                     _isExcluded[account] = false;
858                     _excluded.pop();
859                     break;
860                 }
861             }
862         }
863 
864         function removeAllFee() private {
865             if(_taxFee == 0 && _teamFee == 0) return;
866 
867             _previousTaxFee = _taxFee;
868             _previousTeamFee = _teamFee;
869 
870             _taxFee = 0;
871             _teamFee = 0;
872         }
873 
874         function restoreAllFee() private {
875             _taxFee = _previousTaxFee;
876             _teamFee = _previousTeamFee;
877         }
878 
879         function isExcludedFromFee(address account) public view returns(bool) {
880             return _isExcludedFromFee[account];
881         }
882 
883         function _approve(address owner, address spender, uint256 amount) private {
884             require(owner != address(0), "ERC20: approve from the zero address");
885             require(spender != address(0), "ERC20: approve to the zero address");
886 
887             _allowances[owner][spender] = amount;
888             emit Approval(owner, spender, amount);
889         }
890 
891         function _transfer(address sender, address recipient, uint256 amount) private {
892             require(sender != address(0), "ERC20: transfer from the zero address");
893             require(recipient != address(0), "ERC20: transfer to the zero address");
894             require(amount > 0, "Transfer amount must be greater than zero");
895             require(!_isBlackListedBot[sender], "You are blacklisted");
896             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
897             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
898             if(sender != owner() && recipient != owner()) {
899                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
900             }
901             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
902                 uint256 tokenBalanceRecipient = balanceOf(recipient);
903                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
904             }
905             // is the token balance of this contract address over the min number of
906             // tokens that we need to initiate a swap?
907             // also, don't get caught in a circular team event.
908             // also, don't swap if sender is uniswap pair.
909             uint256 contractTokenBalance = balanceOf(address(this));
910 
911             if(contractTokenBalance >= _maxTxAmount)
912             {
913                 contractTokenBalance = _maxTxAmount;
914             }
915 
916             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
917             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
918                 // Swap tokens for ETH and send to resepctive wallets
919                 swapTokensForEth(contractTokenBalance);
920 
921                 uint256 contractETHBalance = address(this).balance;
922                 if(contractETHBalance > 0) {
923                     sendETHToTeam(address(this).balance);
924                 }
925             }
926 
927             //indicates if fee should be deducted from transfer
928             bool takeFee = true;
929 
930             //if any account belongs to _isExcludedFromFee account then remove the fee
931             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
932                 takeFee = false;
933             }
934 
935             //transfer amount, it will take tax and team fee
936             _tokenTransfer(sender,recipient,amount,takeFee);
937         }
938 
939         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
940             // generate the uniswap pair path of token -> weth
941             address[] memory path = new address[](2);
942             path[0] = address(this);
943             path[1] = uniswapV2Router.WETH();
944 
945             _approve(address(this), address(uniswapV2Router), tokenAmount);
946 
947             // make the swap
948             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
949                 tokenAmount,
950                 0, // accept any amount of ETH
951                 path,
952                 address(this),
953                 block.timestamp
954             );
955         }
956 
957         function sendETHToTeam(uint256 amount) private {
958             _devWalletAddress.transfer(amount.div(5));
959             _marketingWalletAddress.transfer(amount.div(10).mul(8));
960         }
961 
962         function manualSwap() external onlyOwner() {
963             uint256 contractBalance = balanceOf(address(this));
964             swapTokensForEth(contractBalance);
965         }
966 
967         function manualSend() external onlyOwner() {
968             uint256 contractETHBalance = address(this).balance;
969             sendETHToTeam(contractETHBalance);
970         }
971 
972         function setSwapEnabled(bool enabled) external onlyOwner(){
973             swapEnabled = enabled;
974         }
975 
976         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
977             if(!takeFee)
978                 removeAllFee();
979 
980             if (_isExcluded[sender] && !_isExcluded[recipient]) {
981                 _transferFromExcluded(sender, recipient, amount);
982             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
983                 _transferToExcluded(sender, recipient, amount);
984             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
985                 _transferStandard(sender, recipient, amount);
986             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
987                 _transferBothExcluded(sender, recipient, amount);
988             } else {
989                 _transferStandard(sender, recipient, amount);
990             }
991 
992             if(!takeFee)
993                 restoreAllFee();
994         }
995 
996         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
997             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
998             _rOwned[sender] = _rOwned[sender].sub(rAmount);
999             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1000             _takeTeam(tTeam);
1001             _reflectFee(rFee, tFee);
1002             emit Transfer(sender, recipient, tTransferAmount);
1003         }
1004 
1005         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1006             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1007             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1008             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1009             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1010             _takeTeam(tTeam);
1011             _reflectFee(rFee, tFee);
1012             emit Transfer(sender, recipient, tTransferAmount);
1013         }
1014 
1015         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1016             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1017             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1018             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1019             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1020             _takeTeam(tTeam);
1021             _reflectFee(rFee, tFee);
1022             emit Transfer(sender, recipient, tTransferAmount);
1023         }
1024 
1025         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1026             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1027             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1028             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1029             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1030             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1031             _takeTeam(tTeam);
1032             _reflectFee(rFee, tFee);
1033             emit Transfer(sender, recipient, tTransferAmount);
1034         }
1035 
1036         function _takeTeam(uint256 tTeam) private {
1037             uint256 currentRate =  _getRate();
1038             uint256 rTeam = tTeam.mul(currentRate);
1039             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1040             if(_isExcluded[address(this)])
1041                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1042         }
1043 
1044         function _reflectFee(uint256 rFee, uint256 tFee) private {
1045             _rTotal = _rTotal.sub(rFee);
1046             _tFeeTotal = _tFeeTotal.add(tFee);
1047         }
1048 
1049          //to recieve ETH from uniswapV2Router when swaping
1050         receive() external payable {}
1051 
1052         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1053         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1054         uint256 currentRate = _getRate();
1055         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1056         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1057     }
1058 
1059         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1060             uint256 tFee = tAmount.mul(taxFee).div(100);
1061             uint256 tTeam = tAmount.mul(teamFee).div(100);
1062             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1063             return (tTransferAmount, tFee, tTeam);
1064         }
1065 
1066         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1067             uint256 rAmount = tAmount.mul(currentRate);
1068             uint256 rFee = tFee.mul(currentRate);
1069             uint256 rTeam = tTeam.mul(currentRate);
1070             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1071             return (rAmount, rTransferAmount, rFee);
1072         }
1073 
1074         function _getRate() private view returns(uint256) {
1075             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1076             return rSupply.div(tSupply);
1077         }
1078 
1079         function _getCurrentSupply() private view returns(uint256, uint256) {
1080             uint256 rSupply = _rTotal;
1081             uint256 tSupply = _tTotal;
1082             for (uint256 i = 0; i < _excluded.length; i++) {
1083                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1084                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1085                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1086             }
1087             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1088             return (rSupply, tSupply);
1089         }
1090 
1091         function _getTaxFee() public view returns(uint256) {
1092             return _taxFee;
1093         }
1094 
1095         function _getTeamFee() public view returns (uint256) {
1096           return _teamFee;
1097         }
1098 
1099         function _getMaxTxAmount() public view returns(uint256) {
1100             return _maxTxAmount;
1101         }
1102 
1103         function _getETHBalance() public view returns(uint256 balance) {
1104             return address(this).balance;
1105         }
1106 
1107         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1108             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1109             _taxFee = taxFee;
1110         }
1111 
1112         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1113             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1114             _teamFee = teamFee;
1115         }
1116 
1117         function _setDevWallet(address payable devWalletAddress) external onlyOwner() {
1118             _devWalletAddress = devWalletAddress;
1119         }
1120 
1121         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1122             _marketingWalletAddress = marketingWalletAddress;
1123         }
1124 
1125         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1126             _maxTxAmount = maxTxAmount;
1127         }
1128 
1129         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1130           _maxWalletSize = maxWalletSize;
1131         }
1132     }