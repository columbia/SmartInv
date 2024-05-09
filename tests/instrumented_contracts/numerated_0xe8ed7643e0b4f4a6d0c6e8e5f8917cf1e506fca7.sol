1 // File: erc-20.sol
2 
3 /**
4 
5 https://twitter.com/OpaqueSyndicate
6 
7 */
8 
9 pragma solidity ^0.6.12;
10 
11     abstract contract Context {
12         function _msgSender() internal view virtual returns (address payable) {
13             return msg.sender;
14         }
15 
16         function _msgData() internal view virtual returns (bytes memory) {
17             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18             return msg.data;
19         }
20     }
21 
22     interface IERC20 {
23         /**
24         * @dev Returns the amount of tokens in existence.
25         */
26         function totalSupply() external view returns (uint256);
27 
28         /**
29         * @dev Returns the amount of tokens owned by `account`.
30         */
31         function balanceOf(address account) external view returns (uint256);
32 
33         /**
34         * @dev Moves `amount` tokens from the caller's account to `recipient`.
35         *
36         * Returns a boolean value indicating whether the operation succeeded.
37         *
38         * Emits a {Transfer} event.
39         */
40         function transfer(address recipient, uint256 amount) external returns (bool);
41 
42         /**
43         * @dev Returns the remaining number of tokens that `spender` will be
44         * allowed to spend on behalf of `owner` through {transferFrom}. This is
45         * zero by default.
46         *
47         * This value changes when {approve} or {transferFrom} are called.
48         */
49         function allowance(address owner, address spender) external view returns (uint256);
50 
51         /**
52         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53         *
54         * Returns a boolean value indicating whether the operation succeeded.
55         *
56         * IMPORTANT: Beware that changing an allowance with this method brings the risk
57         * that someone may use both the old and the new allowance by unfortunate
58         * transaction ordering. One possible solution to mitigate this race
59         * condition is to first reduce the spender's allowance to 0 and set the
60         * desired value afterwards:
61         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62         *
63         * Emits an {Approval} event.
64         */
65         function approve(address spender, uint256 amount) external returns (bool);
66 
67         /**
68         * @dev Moves `amount` tokens from `sender` to `recipient` using the
69         * allowance mechanism. `amount` is then deducted from the caller's
70         * allowance.
71         *
72         * Returns a boolean value indicating whether the operation succeeded.
73         *
74         * Emits a {Transfer} event.
75         */
76         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78         /**
79         * @dev Emitted when `value` tokens are moved from one account (`from`) to
80         * another (`to`).
81         *
82         * Note that `value` may be zero.
83         */
84         event Transfer(address indexed from, address indexed to, uint256 value);
85 
86         /**
87         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88         * a call to {approve}. `value` is the new allowance.
89         */
90         event Approval(address indexed owner, address indexed spender, uint256 value);
91     }
92 
93     library SafeMath {
94         /**
95         * @dev Returns the addition of two unsigned integers, reverting on
96         * overflow.
97         *
98         * Counterpart to Solidity's `+` operator.
99         *
100         * Requirements:
101         *
102         * - Addition cannot overflow.
103         */
104         function add(uint256 a, uint256 b) internal pure returns (uint256) {
105             uint256 c = a + b;
106             require(c >= a, "SafeMath: addition overflow");
107 
108             return c;
109         }
110 
111         /**
112         * @dev Returns the subtraction of two unsigned integers, reverting on
113         * overflow (when the result is negative).
114         *
115         * Counterpart to Solidity's `-` operator.
116         *
117         * Requirements:
118         *
119         * - Subtraction cannot overflow.
120         */
121         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122             return sub(a, b, "SafeMath: subtraction overflow");
123         }
124 
125         /**
126         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127         * overflow (when the result is negative).
128         *
129         * Counterpart to Solidity's `-` operator.
130         *
131         * Requirements:
132         *
133         * - Subtraction cannot overflow.
134         */
135         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136             require(b <= a, errorMessage);
137             uint256 c = a - b;
138 
139             return c;
140         }
141 
142         /**
143         * @dev Returns the multiplication of two unsigned integers, reverting on
144         * overflow.
145         *
146         * Counterpart to Solidity's `*` operator.
147         *
148         * Requirements:
149         *
150         * - Multiplication cannot overflow.
151         */
152         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154             // benefit is lost if 'b' is also tested.
155             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156             if (a == 0) {
157                 return 0;
158             }
159 
160             uint256 c = a * b;
161             require(c / a == b, "SafeMath: multiplication overflow");
162 
163             return c;
164         }
165 
166         /**
167         * @dev Returns the integer division of two unsigned integers. Reverts on
168         * division by zero. The result is rounded towards zero.
169         *
170         * Counterpart to Solidity's `/` operator. Note: this function uses a
171         * `revert` opcode (which leaves remaining gas untouched) while Solidity
172         * uses an invalid opcode to revert (consuming all remaining gas).
173         *
174         * Requirements:
175         *
176         * - The divisor cannot be zero.
177         */
178         function div(uint256 a, uint256 b) internal pure returns (uint256) {
179             return div(a, b, "SafeMath: division by zero");
180         }
181 
182         /**
183         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
184         * division by zero. The result is rounded towards zero.
185         *
186         * Counterpart to Solidity's `/` operator. Note: this function uses a
187         * `revert` opcode (which leaves remaining gas untouched) while Solidity
188         * uses an invalid opcode to revert (consuming all remaining gas).
189         *
190         * Requirements:
191         *
192         * - The divisor cannot be zero.
193         */
194         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195             require(b > 0, errorMessage);
196             uint256 c = a / b;
197             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199             return c;
200         }
201 
202         /**
203         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204         * Reverts when dividing by zero.
205         *
206         * Counterpart to Solidity's `%` operator. This function uses a `revert`
207         * opcode (which leaves remaining gas untouched) while Solidity uses an
208         * invalid opcode to revert (consuming all remaining gas).
209         *
210         * Requirements:
211         *
212         * - The divisor cannot be zero.
213         */
214         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215             return mod(a, b, "SafeMath: modulo by zero");
216         }
217 
218         /**
219         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220         * Reverts with custom message when dividing by zero.
221         *
222         * Counterpart to Solidity's `%` operator. This function uses a `revert`
223         * opcode (which leaves remaining gas untouched) while Solidity uses an
224         * invalid opcode to revert (consuming all remaining gas).
225         *
226         * Requirements:
227         *
228         * - The divisor cannot be zero.
229         */
230         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231             require(b != 0, errorMessage);
232             return a % b;
233         }
234     }
235 
236     library Address {
237         /**
238         * @dev Returns true if `account` is a contract.
239         *
240         * [IMPORTANT]
241         * ====
242         * It is unsafe to assume that an address for which this function returns
243         * false is an externally-owned account (EOA) and not a contract.
244         *
245         * Among others, `isContract` will return false for the following
246         * types of addresses:
247         *
248         *  - an externally-owned account
249         *  - a contract in construction
250         *  - an address where a contract will be created
251         *  - an address where a contract lived, but was destroyed
252         * ====
253         */
254         function isContract(address account) internal view returns (bool) {
255             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
256             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
257             // for accounts without code, i.e. `keccak256('')`
258             bytes32 codehash;
259             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
260             // solhint-disable-next-line no-inline-assembly
261             assembly { codehash := extcodehash(account) }
262             return (codehash != accountHash && codehash != 0x0);
263         }
264 
265         /**
266         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267         * `recipient`, forwarding all available gas and reverting on errors.
268         *
269         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270         * of certain opcodes, possibly making contracts go over the 2300 gas limit
271         * imposed by `transfer`, making them unable to receive funds via
272         * `transfer`. {sendValue} removes this limitation.
273         *
274         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275         *
276         * IMPORTANT: because control is transferred to `recipient`, care must be
277         * taken to not create reentrancy vulnerabilities. Consider using
278         * {ReentrancyGuard} or the
279         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280         */
281         function sendValue(address payable recipient, uint256 amount) internal {
282             require(address(this).balance >= amount, "Address: insufficient balance");
283 
284             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285             (bool success, ) = recipient.call{ value: amount }("");
286             require(success, "Address: unable to send value, recipient may have reverted");
287         }
288 
289         /**
290         * @dev Performs a Solidity function call using a low level `call`. A
291         * plain`call` is an unsafe replacement for a function call: use this
292         * function instead.
293         *
294         * If `target` reverts with a revert reason, it is bubbled up by this
295         * function (like regular Solidity function calls).
296         *
297         * Returns the raw returned data. To convert to the expected return value,
298         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299         *
300         * Requirements:
301         *
302         * - `target` must be a contract.
303         * - calling `target` with `data` must not revert.
304         *
305         * _Available since v3.1._
306         */
307         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, "Address: low-level call failed");
309         }
310 
311         /**
312         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313         * `errorMessage` as a fallback revert reason when `target` reverts.
314         *
315         * _Available since v3.1._
316         */
317         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
318             return _functionCallWithValue(target, data, 0, errorMessage);
319         }
320 
321         /**
322         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323         * but also transferring `value` wei to `target`.
324         *
325         * Requirements:
326         *
327         * - the calling contract must have an ETH balance of at least `value`.
328         * - the called Solidity function must be `payable`.
329         *
330         * _Available since v3.1._
331         */
332         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
333             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334         }
335 
336         /**
337         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338         * with `errorMessage` as a fallback revert reason when `target` reverts.
339         *
340         * _Available since v3.1._
341         */
342         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
343             require(address(this).balance >= value, "Address: insufficient balance for call");
344             return _functionCallWithValue(target, data, value, errorMessage);
345         }
346 
347         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
348             require(isContract(target), "Address: call to non-contract");
349 
350             // solhint-disable-next-line avoid-low-level-calls
351             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
352             if (success) {
353                 return returndata;
354             } else {
355                 // Look for revert reason and bubble it up if present
356                 if (returndata.length > 0) {
357                     // The easiest way to bubble the revert reason is using memory via assembly
358 
359                     // solhint-disable-next-line no-inline-assembly
360                     assembly {
361                         let returndata_size := mload(returndata)
362                         revert(add(32, returndata), returndata_size)
363                     }
364                 } else {
365                     revert(errorMessage);
366                 }
367             }
368         }
369     }
370 
371     contract Ownable is Context {
372         address private _owner;
373         address private _previousOwner;
374         uint256 private _lockTime;
375 
376         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
377 
378         /**
379         * @dev Initializes the contract setting the deployer as the initial owner.
380         */
381         constructor () internal {
382             address msgSender = _msgSender();
383             _owner = msgSender;
384             emit OwnershipTransferred(address(0), msgSender);
385         }
386 
387         /**
388         * @dev Returns the address of the current owner.
389         */
390         function owner() public view returns (address) {
391             return _owner;
392         }
393 
394         /**
395         * @dev Throws if called by any account other than the owner.
396         */
397         modifier onlyOwner() {
398             require(_owner == _msgSender(), "Ownable: caller is not the owner");
399             _;
400         }
401 
402         /**
403         * @dev Leaves the contract without owner. It will not be possible to call
404         * `onlyOwner` functions anymore. Can only be called by the current owner.
405         *
406         * NOTE: Renouncing ownership will leave the contract without an owner,
407         * thereby removing any functionality that is only available to the owner.
408         */
409         function renounceOwnership() public virtual onlyOwner {
410             emit OwnershipTransferred(_owner, address(0));
411             _owner = address(0);
412         }
413 
414         /**
415         * @dev Transfers ownership of the contract to a new account (`newOwner`).
416         * Can only be called by the current owner.
417         */
418         function transferOwnership(address newOwner) public virtual onlyOwner {
419             require(newOwner != address(0), "Ownable: new owner is the zero address");
420             emit OwnershipTransferred(_owner, newOwner);
421             _owner = newOwner;
422         }
423 
424         function geUnlockTime() public view returns (uint256) {
425             return _lockTime;
426         }
427 
428         //Locks the contract for owner for the amount of time provided
429         function lock(uint256 time) public virtual onlyOwner {
430             _previousOwner = _owner;
431             _owner = address(0);
432             _lockTime = now + time;
433             emit OwnershipTransferred(_owner, address(0));
434         }
435         
436         //Unlocks the contract for owner when _lockTime is exceeds
437         function unlock() public virtual {
438             require(_previousOwner == msg.sender, "You don't have permission to unlock");
439             require(now > _lockTime , "Contract is locked until 7 days");
440             emit OwnershipTransferred(_owner, _previousOwner);
441             _owner = _previousOwner;
442         }
443     }  
444 
445     interface IUniswapV2Factory {
446         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
447 
448         function feeTo() external view returns (address);
449         function feeToSetter() external view returns (address);
450 
451         function getPair(address tokenA, address tokenB) external view returns (address pair);
452         function allPairs(uint) external view returns (address pair);
453         function allPairsLength() external view returns (uint);
454 
455         function createPair(address tokenA, address tokenB) external returns (address pair);
456 
457         function setFeeTo(address) external;
458         function setFeeToSetter(address) external;
459     } 
460 
461     interface IUniswapV2Pair {
462         event Approval(address indexed owner, address indexed spender, uint value);
463         event Transfer(address indexed from, address indexed to, uint value);
464 
465         function name() external pure returns (string memory);
466         function symbol() external pure returns (string memory);
467         function decimals() external pure returns (uint8);
468         function totalSupply() external view returns (uint);
469         function balanceOf(address owner) external view returns (uint);
470         function allowance(address owner, address spender) external view returns (uint);
471 
472         function approve(address spender, uint value) external returns (bool);
473         function transfer(address to, uint value) external returns (bool);
474         function transferFrom(address from, address to, uint value) external returns (bool);
475 
476         function DOMAIN_SEPARATOR() external view returns (bytes32);
477         function PERMIT_TYPEHASH() external pure returns (bytes32);
478         function nonces(address owner) external view returns (uint);
479 
480         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
481 
482         event Mint(address indexed sender, uint amount0, uint amount1);
483         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
484         event Swap(
485             address indexed sender,
486             uint amount0In,
487             uint amount1In,
488             uint amount0Out,
489             uint amount1Out,
490             address indexed to
491         );
492         event Sync(uint112 reserve0, uint112 reserve1);
493 
494         function MINIMUM_LIQUIDITY() external pure returns (uint);
495         function factory() external view returns (address);
496         function token0() external view returns (address);
497         function token1() external view returns (address);
498         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
499         function price0CumulativeLast() external view returns (uint);
500         function price1CumulativeLast() external view returns (uint);
501         function kLast() external view returns (uint);
502 
503         function mint(address to) external returns (uint liquidity);
504         function burn(address to) external returns (uint amount0, uint amount1);
505         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
506         function skim(address to) external;
507         function sync() external;
508 
509         function initialize(address, address) external;
510     }
511 
512     interface IUniswapV2Router01 {
513         function factory() external pure returns (address);
514         function WETH() external pure returns (address);
515 
516         function addLiquidity(
517             address tokenA,
518             address tokenB,
519             uint amountADesired,
520             uint amountBDesired,
521             uint amountAMin,
522             uint amountBMin,
523             address to,
524             uint deadline
525         ) external returns (uint amountA, uint amountB, uint liquidity);
526         function addLiquidityETH(
527             address token,
528             uint amountTokenDesired,
529             uint amountTokenMin,
530             uint amountETHMin,
531             address to,
532             uint deadline
533         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
534         function removeLiquidity(
535             address tokenA,
536             address tokenB,
537             uint liquidity,
538             uint amountAMin,
539             uint amountBMin,
540             address to,
541             uint deadline
542         ) external returns (uint amountA, uint amountB);
543         function removeLiquidityETH(
544             address token,
545             uint liquidity,
546             uint amountTokenMin,
547             uint amountETHMin,
548             address to,
549             uint deadline
550         ) external returns (uint amountToken, uint amountETH);
551         function removeLiquidityWithPermit(
552             address tokenA,
553             address tokenB,
554             uint liquidity,
555             uint amountAMin,
556             uint amountBMin,
557             address to,
558             uint deadline,
559             bool approveMax, uint8 v, bytes32 r, bytes32 s
560         ) external returns (uint amountA, uint amountB);
561         function removeLiquidityETHWithPermit(
562             address token,
563             uint liquidity,
564             uint amountTokenMin,
565             uint amountETHMin,
566             address to,
567             uint deadline,
568             bool approveMax, uint8 v, bytes32 r, bytes32 s
569         ) external returns (uint amountToken, uint amountETH);
570         function swapExactTokensForTokens(
571             uint amountIn,
572             uint amountOutMin,
573             address[] calldata path,
574             address to,
575             uint deadline
576         ) external returns (uint[] memory amounts);
577         function swapTokensForExactTokens(
578             uint amountOut,
579             uint amountInMax,
580             address[] calldata path,
581             address to,
582             uint deadline
583         ) external returns (uint[] memory amounts);
584         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
585             external
586             payable
587             returns (uint[] memory amounts);
588         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
589             external
590             returns (uint[] memory amounts);
591         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
592             external
593             returns (uint[] memory amounts);
594         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
595             external
596             payable
597             returns (uint[] memory amounts);
598 
599         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
600         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
601         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
602         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
603         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
604     }
605 
606     interface IUniswapV2Router02 is IUniswapV2Router01 {
607         function removeLiquidityETHSupportingFeeOnTransferTokens(
608             address token,
609             uint liquidity,
610             uint amountTokenMin,
611             uint amountETHMin,
612             address to,
613             uint deadline
614         ) external returns (uint amountETH);
615         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
616             address token,
617             uint liquidity,
618             uint amountTokenMin,
619             uint amountETHMin,
620             address to,
621             uint deadline,
622             bool approveMax, uint8 v, bytes32 r, bytes32 s
623         ) external returns (uint amountETH);
624 
625         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
626             uint amountIn,
627             uint amountOutMin,
628             address[] calldata path,
629             address to,
630             uint deadline
631         ) external;
632         function swapExactETHForTokensSupportingFeeOnTransferTokens(
633             uint amountOutMin,
634             address[] calldata path,
635             address to,
636             uint deadline
637         ) external payable;
638         function swapExactTokensForETHSupportingFeeOnTransferTokens(
639             uint amountIn,
640             uint amountOutMin,
641             address[] calldata path,
642             address to,
643             uint deadline
644         ) external;
645     }
646 
647     // Contract implementation
648     contract OpaqueDAO is Context, IERC20, Ownable {
649         using SafeMath for uint256;
650         using Address for address;
651 
652         mapping (address => bool) public _isBlacklisted;
653         
654 
655         mapping (address => uint256) private _rOwned;
656         mapping (address => uint256) private _tOwned;
657         mapping (address => mapping (address => uint256)) private _allowances;
658         mapping (address => bool) private _isExcludedFromFee;
659 
660         mapping (address => bool) private _isExcluded;
661         address[] private _excluded;
662     
663         uint256 private constant MAX = ~uint256(0);
664         uint256 private _tTotal = 7000000000* 10**9;
665         uint256 private _rTotal = (MAX - (MAX % _tTotal));
666         uint256 private _tFeeTotal;
667 
668         string private _name = 'Opaque DAO';
669         string private _symbol = 'ODAO';
670         uint8 private _decimals = 9;
671         
672         uint256 public _liquidityFee = 0;
673         uint256 private _taxFee = 0; 
674         uint256 private _MarketingFee = 15;
675         uint256 private _previousTaxFee = _taxFee;
676         uint256 private _previousMarketingFee = _MarketingFee;
677 
678         address payable private _MarketingWalletAddress;
679         
680         IUniswapV2Router02 public immutable uniswapV2Router;
681         address public immutable uniswapV2Pair;
682 
683         bool inSwap = false;
684         bool public swapEnabled = true;
685 
686         uint256 private _maxTxAmount = 7000000000e9;
687         uint256 private _numOfTokensToExchangeForMarketing = 5 * 10**3 * 10**9;
688 
689         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
690         event SwapEnabledUpdated(bool enabled);
691 
692         modifier lockTheSwap {
693             inSwap = true;
694             _;
695             inSwap = false;
696         }
697 
698         constructor (address payable MarketingWalletAddress) public {
699             _MarketingWalletAddress = MarketingWalletAddress;
700             _rOwned[_msgSender()] = _rTotal;
701 
702             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
703             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
704                 .createPair(address(this), _uniswapV2Router.WETH());
705 
706             uniswapV2Router = _uniswapV2Router;
707 
708             _isExcludedFromFee[owner()] = true;
709             _isExcludedFromFee[address(this)] = true;
710             _isExcludedFromFee[_MarketingWalletAddress] = true;
711        
712 
713             emit Transfer(address(0), _msgSender(), _tTotal);
714         }
715 
716         function name() public view returns (string memory) {
717             return _name;
718         }
719 
720         function symbol() public view returns (string memory) {
721             return _symbol;
722         }
723 
724         function decimals() public view returns (uint8) {
725             return _decimals;
726         }
727 
728         function totalSupply() public view override returns (uint256) {
729             return _tTotal;
730         }
731 
732         function balanceOf(address account) public view override returns (uint256) {
733             if (_isExcluded[account]) return _tOwned[account];
734             return tokenFromReflection(_rOwned[account]);
735         }
736 
737         function transfer(address recipient, uint256 amount) public override returns (bool) {
738         _transfer(_msgSender(), recipient, amount);
739         return true;
740         }
741 
742         function allowance(address owner, address spender) public view override returns (uint256) {
743             return _allowances[owner][spender];
744         }
745 
746         function approve(address spender, uint256 amount) public override returns (bool) {
747             _approve(_msgSender(), spender, amount);
748             return true;
749         }
750 
751         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
752             _transfer(sender, recipient, amount);
753             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
754             return true;
755         }
756 
757         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
758             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
759             return true;
760         }
761 
762         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
763             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
764             return true;
765         }
766 
767         function isExcluded(address account) public view returns (bool) {
768             return _isExcluded[account];
769         }
770 
771         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
772             _isExcludedFromFee[account] = excluded;
773         }
774 
775         function totalFees() public view returns (uint256) {
776             return _tFeeTotal;
777         }
778 
779         function deliver(uint256 tAmount) public {
780             address sender = _msgSender();
781             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
782             (uint256 rAmount,,,,,) = _getValues(tAmount);
783             _rOwned[sender] = _rOwned[sender].sub(rAmount);
784             _rTotal = _rTotal.sub(rAmount);
785             _tFeeTotal = _tFeeTotal.add(tAmount);
786         }
787 
788         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
789             require(tAmount <= _tTotal, "Amount must be less than supply");
790             if (!deductTransferFee) {
791                 (uint256 rAmount,,,,,) = _getValues(tAmount);
792                 return rAmount;
793             } else {
794                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
795                 return rTransferAmount;
796             }
797         }
798 
799         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
800             require(rAmount <= _rTotal, "Amount must be less than total reflections");
801             uint256 currentRate =  _getRate();
802             return rAmount.div(currentRate);
803         }
804 
805         function excludeAccount(address account) external onlyOwner() {
806             require(account != 0x316CE6f83b20F183756413Ba9c374C6af012f1cA, 'We can not exclude Uniswap router.');
807             require(!_isExcluded[account], "Account is already excluded");
808             if(_rOwned[account] > 0) {
809                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
810             }
811             _isExcluded[account] = true;
812             _excluded.push(account);
813         }
814 
815         function includeAccount(address account) external onlyOwner() {
816             require(_isExcluded[account], "Account is already excluded");
817             for (uint256 i = 0; i < _excluded.length; i++) {
818                 if (_excluded[i] == account) {
819                     _excluded[i] = _excluded[_excluded.length - 1];
820                     _tOwned[account] = 0;
821                     _isExcluded[account] = false;
822                     _excluded.pop();
823                     break;
824                 }
825             }
826         }
827 
828         function removeAllFee() private {
829             if(_taxFee == 0 && _MarketingFee == 0) return;
830             
831             _previousTaxFee = _taxFee;
832             _previousMarketingFee = _MarketingFee;
833             
834             _taxFee = 0;
835             _MarketingFee = 0;
836         }
837     
838         function restoreAllFee() private {
839             _taxFee = _previousTaxFee;
840             _MarketingFee = _previousMarketingFee;
841         }
842     
843         function isExcludedFromFee(address account) public view returns(bool) {
844             return _isExcludedFromFee[account];
845         }
846 
847         function _approve(address owner, address spender, uint256 amount) private {
848             require(owner != address(0), "ERC20: approve from the zero address");
849             require(spender != address(0), "ERC20: approve to the zero address");
850 
851             _allowances[owner][spender] = amount;
852             emit Approval(owner, spender, amount);
853         }
854 
855         function _transfer(address sender, address recipient, uint256 amount) private {
856             require(!_isBlacklisted[sender] && !_isBlacklisted[recipient], "This address is blacklisted");
857             require(sender != address(0), "ERC20: transfer from the zero address");
858             require(recipient != address(0), "ERC20: transfer to the zero address");
859             require(amount > 0, "Transfer amount must be greater than zero");
860             
861             if(sender != owner() && recipient != owner())
862                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
863 
864            
865             uint256 contractTokenBalance = balanceOf(address(this));
866             
867             if(contractTokenBalance >= _maxTxAmount)
868             {
869                 contractTokenBalance = _maxTxAmount;
870             }
871             
872             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForMarketing;
873             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
874                
875                 swapTokensForEth(contractTokenBalance);
876                 
877                 uint256 contractETHBalance = address(this).balance;
878                 if(contractETHBalance > 0) {
879                     sendETHToMarketing(address(this).balance);
880                 }
881             }
882             
883         
884             bool takeFee = true;
885             
886       
887             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
888                 takeFee = false;
889             }
890             
891       
892             _tokenTransfer(sender,recipient,amount,takeFee);
893         }
894 
895         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
896          
897             address[] memory path = new address[](2);
898             path[0] = address(this);
899             path[1] = uniswapV2Router.WETH();
900 
901             _approve(address(this), address(uniswapV2Router), tokenAmount);
902 
903          
904             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
905                 tokenAmount,
906                 0, 
907                 path,
908                 address(this),
909                 block.timestamp
910             );
911         }
912         
913         function sendETHToMarketing(uint256 amount) private {
914             _MarketingWalletAddress.transfer(amount.mul(3).div(8));
915           
916         }
917         
918         function manualSwap() external onlyOwner() {
919             uint256 contractBalance = balanceOf(address(this));
920             swapTokensForEth(contractBalance);
921         }
922         
923         function manualSend() external onlyOwner() {
924             uint256 contractETHBalance = address(this).balance;
925             sendETHToMarketing(contractETHBalance);
926         }
927 
928         function setSwapEnabled(bool enabled) external onlyOwner(){
929             swapEnabled = enabled;
930         }
931         
932         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
933             if(!takeFee)
934                 removeAllFee();
935 
936             if (_isExcluded[sender] && !_isExcluded[recipient]) {
937                 _transferFromExcluded(sender, recipient, amount);
938             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
939                 _transferToExcluded(sender, recipient, amount);
940             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
941                 _transferStandard(sender, recipient, amount);
942             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
943                 _transferBothExcluded(sender, recipient, amount);
944             } else {
945                 _transferStandard(sender, recipient, amount);
946             }
947 
948             if(!takeFee)
949                 restoreAllFee();
950         }
951 
952         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
953             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
954             _rOwned[sender] = _rOwned[sender].sub(rAmount);
955             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
956             _takeMarketing(tMarketing); 
957             _reflectFee(rFee, tFee);
958             emit Transfer(sender, recipient, tTransferAmount);
959         }
960 
961         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
962             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
963             _rOwned[sender] = _rOwned[sender].sub(rAmount);
964             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
965             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
966             _takeMarketing(tMarketing);           
967             _reflectFee(rFee, tFee);
968             emit Transfer(sender, recipient, tTransferAmount);
969         }
970 
971         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
972             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
973             _tOwned[sender] = _tOwned[sender].sub(tAmount);
974             _rOwned[sender] = _rOwned[sender].sub(rAmount);
975             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
976             _takeMarketing(tMarketing);   
977             _reflectFee(rFee, tFee);
978             emit Transfer(sender, recipient, tTransferAmount);
979         }
980 
981         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
982             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
983             _tOwned[sender] = _tOwned[sender].sub(tAmount);
984             _rOwned[sender] = _rOwned[sender].sub(rAmount);
985             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
986             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
987             _takeMarketing(tMarketing);         
988             _reflectFee(rFee, tFee);
989             emit Transfer(sender, recipient, tTransferAmount);
990         }
991 
992         function _takeMarketing(uint256 tMarketing) private {
993             uint256 currentRate =  _getRate();
994             uint256 rMarketing = tMarketing.mul(currentRate);
995             _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
996             if(_isExcluded[address(this)])
997                 _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
998         }
999 
1000         function _reflectFee(uint256 rFee, uint256 tFee) private {
1001             _rTotal = _rTotal.sub(rFee);
1002             _tFeeTotal = _tFeeTotal.add(tFee);
1003         }
1004 
1005         receive() external payable {}
1006 
1007         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1008             (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount, _taxFee, _MarketingFee);
1009             uint256 currentRate =  _getRate();
1010             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1011             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
1012         }
1013 
1014         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 MarketingFee) private pure returns (uint256, uint256, uint256) {
1015             uint256 tFee = tAmount.mul(taxFee).div(100);
1016             uint256 tMarketing = tAmount.mul(MarketingFee).div(100);
1017             uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
1018             return (tTransferAmount, tFee, tMarketing);
1019         }
1020 
1021         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1022             uint256 rAmount = tAmount.mul(currentRate);
1023             uint256 rFee = tFee.mul(currentRate);
1024             uint256 rTransferAmount = rAmount.sub(rFee);
1025             return (rAmount, rTransferAmount, rFee);
1026         }
1027 
1028         function _getRate() private view returns(uint256) {
1029             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1030             return rSupply.div(tSupply);
1031         }
1032 
1033         function _getCurrentSupply() private view returns(uint256, uint256) {
1034             uint256 rSupply = _rTotal;
1035             uint256 tSupply = _tTotal;      
1036             for (uint256 i = 0; i < _excluded.length; i++) {
1037                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1038                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1039                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1040             }
1041             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1042             return (rSupply, tSupply);
1043         }
1044         
1045         function _getTaxFee() private view returns(uint256) {
1046             return _taxFee;
1047         }
1048 
1049         function _getMaxTxAmount() public view returns(uint256) {
1050             return _maxTxAmount;
1051         }
1052 
1053         function _getETHBalance() public view returns(uint256 balance) {
1054             return address(this).balance;
1055         }
1056         
1057         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1058             require(taxFee >= 0 && taxFee <= 99, 'taxFee should be in 0 - 99');
1059             _taxFee = taxFee;
1060         }
1061 
1062         function _setMarketingFee(uint256 MarketingFee) external onlyOwner() {
1063             require(MarketingFee >= 1 && MarketingFee <= 50, 'MarketingFee should be in 1 - 50');
1064             _MarketingFee = MarketingFee;
1065         }
1066         
1067         function _setMarketingWallet(address payable MarketingWalletAddress) external onlyOwner() {
1068             _MarketingWalletAddress = MarketingWalletAddress;
1069       
1070         }
1071         
1072         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1073             _maxTxAmount = maxTxAmount;
1074         }
1075 
1076 	    //removeFromBlackList
1077         function removeFromBlackList(address account) external onlyOwner{
1078         _isBlacklisted[account] = false;
1079         }
1080 
1081          //adding multiple address to the blacklist - used to manually block known bots and scammers
1082         function addToBlackList(address[] calldata  addresses) external onlyOwner {
1083         for(uint256 i; i < addresses.length; ++i) {
1084             _isBlacklisted[addresses[i]] = true;
1085             }
1086         }
1087    
1088     }