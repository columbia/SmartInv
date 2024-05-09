1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4     abstract contract Context {
5         function _msgSender() internal view virtual returns (address payable) {
6             return msg.sender;
7         }
8 
9         function _msgData() internal view virtual returns (bytes memory) {
10             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11             return msg.data;
12         }
13     }
14 
15     interface IERC20 {
16         /**
17         * @dev Returns the amount of tokens in existence.
18         */
19         function totalSupply() external view returns (uint256);
20 
21         /**
22         * @dev Returns the amount of tokens owned by `account`.
23         */
24         function balanceOf(address account) external view returns (uint256);
25 
26         /**
27         * @dev Moves `amount` tokens from the caller's account to `recipient`.
28         *
29         * Returns a boolean value indicating whether the operation succeeded.
30         *
31         * Emits a {Transfer} event.
32         */
33         function transfer(address recipient, uint256 amount) external returns (bool);
34 
35         /**
36         * @dev Returns the remaining number of tokens that `spender` will be
37         * allowed to spend on behalf of `owner` through {transferFrom}. This is
38         * zero by default.
39         *
40         * This value changes when {approve} or {transferFrom} are called.
41         */
42         function allowance(address owner, address spender) external view returns (uint256);
43 
44         /**
45         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46         *
47         * Returns a boolean value indicating whether the operation succeeded.
48         *
49         * IMPORTANT: Beware that changing an allowance with this method brings the risk
50         * that someone may use both the old and the new allowance by unfortunate
51         * transaction ordering. One possible solution to mitigate this race
52         * condition is to first reduce the spender's allowance to 0 and set the
53         * desired value afterwards:
54         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55         *
56         * Emits an {Approval} event.
57         */
58         function approve(address spender, uint256 amount) external returns (bool);
59 
60         /**
61         * @dev Moves `amount` tokens from `sender` to `recipient` using the
62         * allowance mechanism. `amount` is then deducted from the caller's
63         * allowance.
64         *
65         * Returns a boolean value indicating whether the operation succeeded.
66         *
67         * Emits a {Transfer} event.
68         */
69         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71         /**
72         * @dev Emitted when `value` tokens are moved from one account (`from`) to
73         * another (`to`).
74         *
75         * Note that `value` may be zero.
76         */
77         event Transfer(address indexed from, address indexed to, uint256 value);
78 
79         /**
80         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81         * a call to {approve}. `value` is the new allowance.
82         */
83         event Approval(address indexed owner, address indexed spender, uint256 value);
84     }
85 
86     library SafeMath {
87         /**
88         * @dev Returns the addition of two unsigned integers, reverting on
89         * overflow.
90         *
91         * Counterpart to Solidity's `+` operator.
92         *
93         * Requirements:
94         *
95         * - Addition cannot overflow.
96         */
97         function add(uint256 a, uint256 b) internal pure returns (uint256) {
98             uint256 c = a + b;
99             require(c >= a, "SafeMath: addition overflow");
100 
101             return c;
102         }
103 
104         /**
105         * @dev Returns the subtraction of two unsigned integers, reverting on
106         * overflow (when the result is negative).
107         *
108         * Counterpart to Solidity's `-` operator.
109         *
110         * Requirements:
111         *
112         * - Subtraction cannot overflow.
113         */
114         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115             return sub(a, b, "SafeMath: subtraction overflow");
116         }
117 
118         /**
119         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120         * overflow (when the result is negative).
121         *
122         * Counterpart to Solidity's `-` operator.
123         *
124         * Requirements:
125         *
126         * - Subtraction cannot overflow.
127         */
128         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129             require(b <= a, errorMessage);
130             uint256 c = a - b;
131 
132             return c;
133         }
134 
135         /**
136         * @dev Returns the multiplication of two unsigned integers, reverting on
137         * overflow.
138         *
139         * Counterpart to Solidity's `*` operator.
140         *
141         * Requirements:
142         *
143         * - Multiplication cannot overflow.
144         */
145         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147             // benefit is lost if 'b' is also tested.
148             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149             if (a == 0) {
150                 return 0;
151             }
152 
153             uint256 c = a * b;
154             require(c / a == b, "SafeMath: multiplication overflow");
155 
156             return c;
157         }
158 
159         /**
160         * @dev Returns the integer division of two unsigned integers. Reverts on
161         * division by zero. The result is rounded towards zero.
162         *
163         * Counterpart to Solidity's `/` operator. Note: this function uses a
164         * `revert` opcode (which leaves remaining gas untouched) while Solidity
165         * uses an invalid opcode to revert (consuming all remaining gas).
166         *
167         * Requirements:
168         *
169         * - The divisor cannot be zero.
170         */
171         function div(uint256 a, uint256 b) internal pure returns (uint256) {
172             return div(a, b, "SafeMath: division by zero");
173         }
174 
175         /**
176         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
187         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188             require(b > 0, errorMessage);
189             uint256 c = a / b;
190             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192             return c;
193         }
194 
195         /**
196         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197         * Reverts when dividing by zero.
198         *
199         * Counterpart to Solidity's `%` operator. This function uses a `revert`
200         * opcode (which leaves remaining gas untouched) while Solidity uses an
201         * invalid opcode to revert (consuming all remaining gas).
202         *
203         * Requirements:
204         *
205         * - The divisor cannot be zero.
206         */
207         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208             return mod(a, b, "SafeMath: modulo by zero");
209         }
210 
211         /**
212         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213         * Reverts with custom message when dividing by zero.
214         *
215         * Counterpart to Solidity's `%` operator. This function uses a `revert`
216         * opcode (which leaves remaining gas untouched) while Solidity uses an
217         * invalid opcode to revert (consuming all remaining gas).
218         *
219         * Requirements:
220         *
221         * - The divisor cannot be zero.
222         */
223         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224             require(b != 0, errorMessage);
225             return a % b;
226         }
227     }
228 
229     library Address {
230         /**
231         * @dev Returns true if `account` is a contract.
232         *
233         * [IMPORTANT]
234         * ====
235         * It is unsafe to assume that an address for which this function returns
236         * false is an externally-owned account (EOA) and not a contract.
237         *
238         * Among others, `isContract` will return false for the following
239         * types of addresses:
240         *
241         *  - an externally-owned account
242         *  - a contract in construction
243         *  - an address where a contract will be created
244         *  - an address where a contract lived, but was destroyed
245         * ====
246         */
247         function isContract(address account) internal view returns (bool) {
248             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
249             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
250             // for accounts without code, i.e. `keccak256('')`
251             bytes32 codehash;
252             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
253             // solhint-disable-next-line no-inline-assembly
254             assembly { codehash := extcodehash(account) }
255             return (codehash != accountHash && codehash != 0x0);
256         }
257 
258         /**
259         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260         * `recipient`, forwarding all available gas and reverting on errors.
261         *
262         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263         * of certain opcodes, possibly making contracts go over the 2300 gas limit
264         * imposed by `transfer`, making them unable to receive funds via
265         * `transfer`. {sendValue} removes this limitation.
266         *
267         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268         *
269         * IMPORTANT: because control is transferred to `recipient`, care must be
270         * taken to not create reentrancy vulnerabilities. Consider using
271         * {ReentrancyGuard} or the
272         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273         */
274         function sendValue(address payable recipient, uint256 amount) internal {
275             require(address(this).balance >= amount, "Address: insufficient balance");
276 
277             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
278             (bool success, ) = recipient.call{ value: amount }("");
279             require(success, "Address: unable to send value, recipient may have reverted");
280         }
281 
282         /**
283         * @dev Performs a Solidity function call using a low level `call`. A
284         * plain`call` is an unsafe replacement for a function call: use this
285         * function instead.
286         *
287         * If `target` reverts with a revert reason, it is bubbled up by this
288         * function (like regular Solidity function calls).
289         *
290         * Returns the raw returned data. To convert to the expected return value,
291         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
292         *
293         * Requirements:
294         *
295         * - `target` must be a contract.
296         * - calling `target` with `data` must not revert.
297         *
298         * _Available since v3.1._
299         */
300         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionCall(target, data, "Address: low-level call failed");
302         }
303 
304         /**
305         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
306         * `errorMessage` as a fallback revert reason when `target` reverts.
307         *
308         * _Available since v3.1._
309         */
310         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311             return _functionCallWithValue(target, data, 0, errorMessage);
312         }
313 
314         /**
315         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316         * but also transferring `value` wei to `target`.
317         *
318         * Requirements:
319         *
320         * - the calling contract must have an ETH balance of at least `value`.
321         * - the called Solidity function must be `payable`.
322         *
323         * _Available since v3.1._
324         */
325         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
326             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327         }
328 
329         /**
330         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331         * with `errorMessage` as a fallback revert reason when `target` reverts.
332         *
333         * _Available since v3.1._
334         */
335         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
336             require(address(this).balance >= value, "Address: insufficient balance for call");
337             return _functionCallWithValue(target, data, value, errorMessage);
338         }
339 
340         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
341             require(isContract(target), "Address: call to non-contract");
342 
343             // solhint-disable-next-line avoid-low-level-calls
344             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
345             if (success) {
346                 return returndata;
347             } else {
348                 // Look for revert reason and bubble it up if present
349                 if (returndata.length > 0) {
350                     // The easiest way to bubble the revert reason is using memory via assembly
351 
352                     // solhint-disable-next-line no-inline-assembly
353                     assembly {
354                         let returndata_size := mload(returndata)
355                         revert(add(32, returndata), returndata_size)
356                     }
357                 } else {
358                     revert(errorMessage);
359                 }
360             }
361         }
362     }
363 
364     contract Ownable is Context {
365         address private _owner;
366         address private _previousOwner;
367         uint256 private _lockTime;
368 
369         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371         /**
372         * @dev Initializes the contract setting the deployer as the initial owner.
373         */
374         constructor () internal {
375             address msgSender = _msgSender();
376             _owner = msgSender;
377             emit OwnershipTransferred(address(0), msgSender);
378         }
379 
380         /**
381         * @dev Returns the address of the current owner.
382         */
383         function owner() public view returns (address) {
384             return _owner;
385         }
386 
387         /**
388         * @dev Throws if called by any account other than the owner.
389         */
390         modifier onlyOwner() {
391             require(_owner == _msgSender(), "Ownable: caller is not the owner");
392             _;
393         }
394 
395         /**
396         * @dev Leaves the contract without owner. It will not be possible to call
397         * `onlyOwner` functions anymore. Can only be called by the current owner.
398         *
399         * NOTE: Renouncing ownership will leave the contract without an owner,
400         * thereby removing any functionality that is only available to the owner.
401         */
402         function renounceOwnership() public virtual onlyOwner {
403             emit OwnershipTransferred(_owner, address(0));
404             _owner = address(0);
405         }
406 
407         /**
408         * @dev Transfers ownership of the contract to a new account (`newOwner`).
409         * Can only be called by the current owner.
410         */
411         function transferOwnership(address newOwner) public virtual onlyOwner {
412             require(newOwner != address(0), "Ownable: new owner is the zero address");
413             emit OwnershipTransferred(_owner, newOwner);
414             _owner = newOwner;
415         }
416 
417         function getUnlockTime() public view returns (uint256) {
418             return _lockTime;
419         }
420 
421     }
422 
423     interface IUniswapV2Factory {
424         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
425 
426         function feeTo() external view returns (address);
427         function feeToSetter() external view returns (address);
428 
429         function getPair(address tokenA, address tokenB) external view returns (address pair);
430         function allPairs(uint) external view returns (address pair);
431         function allPairsLength() external view returns (uint);
432 
433         function createPair(address tokenA, address tokenB) external returns (address pair);
434 
435         function setFeeTo(address) external;
436         function setFeeToSetter(address) external;
437     }
438 
439     interface IUniswapV2Pair {
440         event Approval(address indexed owner, address indexed spender, uint value);
441         event Transfer(address indexed from, address indexed to, uint value);
442 
443         function name() external pure returns (string memory);
444         function symbol() external pure returns (string memory);
445         function decimals() external pure returns (uint8);
446         function totalSupply() external view returns (uint);
447         function balanceOf(address owner) external view returns (uint);
448         function allowance(address owner, address spender) external view returns (uint);
449 
450         function approve(address spender, uint value) external returns (bool);
451         function transfer(address to, uint value) external returns (bool);
452         function transferFrom(address from, address to, uint value) external returns (bool);
453 
454         function DOMAIN_SEPARATOR() external view returns (bytes32);
455         function PERMIT_TYPEHASH() external pure returns (bytes32);
456         function nonces(address owner) external view returns (uint);
457 
458         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
459 
460         event Mint(address indexed sender, uint amount0, uint amount1);
461         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
462         event Swap(
463             address indexed sender,
464             uint amount0In,
465             uint amount1In,
466             uint amount0Out,
467             uint amount1Out,
468             address indexed to
469         );
470         event Sync(uint112 reserve0, uint112 reserve1);
471 
472         function MINIMUM_LIQUIDITY() external pure returns (uint);
473         function factory() external view returns (address);
474         function token0() external view returns (address);
475         function token1() external view returns (address);
476         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
477         function price0CumulativeLast() external view returns (uint);
478         function price1CumulativeLast() external view returns (uint);
479         function kLast() external view returns (uint);
480 
481         function mint(address to) external returns (uint liquidity);
482         function burn(address to) external returns (uint amount0, uint amount1);
483         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
484         function skim(address to) external;
485         function sync() external;
486 
487         function initialize(address, address) external;
488     }
489 
490     interface IUniswapV2Router01 {
491         function factory() external pure returns (address);
492         function WETH() external pure returns (address);
493 
494         function addLiquidity(
495             address tokenA,
496             address tokenB,
497             uint amountADesired,
498             uint amountBDesired,
499             uint amountAMin,
500             uint amountBMin,
501             address to,
502             uint deadline
503         ) external returns (uint amountA, uint amountB, uint liquidity);
504         function addLiquidityETH(
505             address token,
506             uint amountTokenDesired,
507             uint amountTokenMin,
508             uint amountETHMin,
509             address to,
510             uint deadline
511         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
512         function removeLiquidity(
513             address tokenA,
514             address tokenB,
515             uint liquidity,
516             uint amountAMin,
517             uint amountBMin,
518             address to,
519             uint deadline
520         ) external returns (uint amountA, uint amountB);
521         function removeLiquidityETH(
522             address token,
523             uint liquidity,
524             uint amountTokenMin,
525             uint amountETHMin,
526             address to,
527             uint deadline
528         ) external returns (uint amountToken, uint amountETH);
529         function removeLiquidityWithPermit(
530             address tokenA,
531             address tokenB,
532             uint liquidity,
533             uint amountAMin,
534             uint amountBMin,
535             address to,
536             uint deadline,
537             bool approveMax, uint8 v, bytes32 r, bytes32 s
538         ) external returns (uint amountA, uint amountB);
539         function removeLiquidityETHWithPermit(
540             address token,
541             uint liquidity,
542             uint amountTokenMin,
543             uint amountETHMin,
544             address to,
545             uint deadline,
546             bool approveMax, uint8 v, bytes32 r, bytes32 s
547         ) external returns (uint amountToken, uint amountETH);
548         function swapExactTokensForTokens(
549             uint amountIn,
550             uint amountOutMin,
551             address[] calldata path,
552             address to,
553             uint deadline
554         ) external returns (uint[] memory amounts);
555         function swapTokensForExactTokens(
556             uint amountOut,
557             uint amountInMax,
558             address[] calldata path,
559             address to,
560             uint deadline
561         ) external returns (uint[] memory amounts);
562         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
563             external
564             payable
565             returns (uint[] memory amounts);
566         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
567             external
568             returns (uint[] memory amounts);
569         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
570             external
571             returns (uint[] memory amounts);
572         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
573             external
574             payable
575             returns (uint[] memory amounts);
576 
577         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
578         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
579         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
580         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
581         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
582     }
583 
584     interface IUniswapV2Router02 is IUniswapV2Router01 {
585         function removeLiquidityETHSupportingFeeOnTransferTokens(
586             address token,
587             uint liquidity,
588             uint amountTokenMin,
589             uint amountETHMin,
590             address to,
591             uint deadline
592         ) external returns (uint amountETH);
593         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
594             address token,
595             uint liquidity,
596             uint amountTokenMin,
597             uint amountETHMin,
598             address to,
599             uint deadline,
600             bool approveMax, uint8 v, bytes32 r, bytes32 s
601         ) external returns (uint amountETH);
602 
603         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
604             uint amountIn,
605             uint amountOutMin,
606             address[] calldata path,
607             address to,
608             uint deadline
609         ) external;
610         function swapExactETHForTokensSupportingFeeOnTransferTokens(
611             uint amountOutMin,
612             address[] calldata path,
613             address to,
614             uint deadline
615         ) external payable;
616         function swapExactTokensForETHSupportingFeeOnTransferTokens(
617             uint amountIn,
618             uint amountOutMin,
619             address[] calldata path,
620             address to,
621             uint deadline
622         ) external;
623     }
624 
625     contract BoostToken is Context, IERC20, Ownable {
626         using SafeMath for uint256;
627         using Address for address;
628 
629         mapping (address => uint256) private _rOwned;
630         mapping (address => uint256) private _tOwned;
631         mapping (address => mapping (address => uint256)) private _allowances;
632 
633         mapping (address => bool) private _isExcludedFromFee;
634 
635         mapping (address => bool) private _isExcluded;
636         address[] private _excluded;
637         mapping (address => bool) private _isBlackListedBot;
638         address[] private _blackListedBots;
639 
640         uint256 private constant MAX = ~uint256(0);
641         uint256 private constant _tTotal = 1000000000 * 10**18;
642         uint256 private _rTotal = (MAX - (MAX % _tTotal));
643         uint256 private _tFeeTotal;
644 
645         string private constant _name = 'Boost';
646         string private constant _symbol = 'BOOST';
647         uint8 private constant _decimals = 18;
648 
649         uint256 private _taxFee = 2;
650         uint256 private _teamFee = 9;
651         uint256 private _previousTaxFee = _taxFee;
652         uint256 private _previousTeamFee = _teamFee;
653 
654         address payable public _devWalletAddress;
655         address payable public _marketingWalletAddress;
656         address payable public _dipWalletAddress;
657         address payable public _marketingWalletAddress2;
658 
659         IUniswapV2Router02 public immutable uniswapV2Router;
660         address public immutable uniswapV2Pair;
661 
662         bool inSwap = false;
663         bool public swapEnabled = true;
664 
665         uint256 private _maxTxAmount = 5000000 * 10**18;
666         uint256 private constant _numOfTokensToExchangeForTeam = 5000 * 10**18;
667         uint256 private _maxWalletSize = 9500000 * 10**18;
668 
669         event botAddedToBlacklist(address account);
670         event botRemovedFromBlacklist(address account);
671 
672         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
673         // event SwapEnabledUpdated(bool enabled);
674 
675         modifier lockTheSwap {
676             inSwap = true;
677             _;
678             inSwap = false;
679         }
680 
681         constructor (address payable devWalletAddress, address payable marketingWalletAddress, address payable dipWalletAddress, address payable marketingWalletAddress2) public {
682             _devWalletAddress = devWalletAddress;
683             _marketingWalletAddress = marketingWalletAddress;
684             _dipWalletAddress = dipWalletAddress;
685             _marketingWalletAddress2 = marketingWalletAddress2;
686 
687             _rOwned[_msgSender()] = _rTotal;
688 
689             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
690             // Create a uniswap pair for this new token
691             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
692                 .createPair(address(this), _uniswapV2Router.WETH());
693 
694             // set the rest of the contract variables
695             uniswapV2Router = _uniswapV2Router;
696 
697             // Exclude owner and this contract from fee
698             _isExcludedFromFee[owner()] = true;
699             _isExcludedFromFee[address(this)] = true;
700 
701             emit Transfer(address(0), _msgSender(), _tTotal);
702         }
703 
704         function name() public pure returns (string memory) {
705             return _name;
706         }
707 
708         function symbol() public pure returns (string memory) {
709             return _symbol;
710         }
711 
712         function decimals() public pure returns (uint8) {
713             return _decimals;
714         }
715 
716         function totalSupply() public view override returns (uint256) {
717             return _tTotal;
718         }
719 
720         function balanceOf(address account) public view override returns (uint256) {
721             if (_isExcluded[account]) return _tOwned[account];
722             return tokenFromReflection(_rOwned[account]);
723         }
724 
725         function transfer(address recipient, uint256 amount) public override returns (bool) {
726             _transfer(_msgSender(), recipient, amount);
727             return true;
728         }
729 
730         function allowance(address owner, address spender) public view override returns (uint256) {
731             return _allowances[owner][spender];
732         }
733 
734         function approve(address spender, uint256 amount) public override returns (bool) {
735             _approve(_msgSender(), spender, amount);
736             return true;
737         }
738 
739         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
740             _transfer(sender, recipient, amount);
741             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
742             return true;
743         }
744 
745         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
746             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
747             return true;
748         }
749 
750         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
751             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
752             return true;
753         }
754 
755         function isExcluded(address account) public view returns (bool) {
756             return _isExcluded[account];
757         }
758 
759         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
760             _isExcludedFromFee[account] = excluded;
761         }
762 
763         function totalFees() public view returns (uint256) {
764             return _tFeeTotal;
765         }
766 
767         function deliver(uint256 tAmount) public {
768             address sender = _msgSender();
769             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
770             (uint256 rAmount,,,,,) = _getValues(tAmount);
771             _rOwned[sender] = _rOwned[sender].sub(rAmount);
772             _rTotal = _rTotal.sub(rAmount);
773             _tFeeTotal = _tFeeTotal.add(tAmount);
774         }
775 
776         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
777             require(tAmount <= _tTotal, "Amount must be less than supply");
778             if (!deductTransferFee) {
779                 (uint256 rAmount,,,,,) = _getValues(tAmount);
780                 return rAmount;
781             } else {
782                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
783                 return rTransferAmount;
784             }
785         }
786 
787         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
788             require(rAmount <= _rTotal, "Amount must be less than total reflections");
789             uint256 currentRate =  _getRate();
790             return rAmount.div(currentRate);
791         }
792 
793         function addBotToBlacklist (address account) external onlyOwner() {
794            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
795            require (!_isBlackListedBot[account], 'Account is already blacklisted');
796            _isBlackListedBot[account] = true;
797            _blackListedBots.push(account);
798         }
799 
800         function removeBotFromBlacklist(address account) external onlyOwner() {
801           require (_isBlackListedBot[account], 'Account is not blacklisted');
802           for (uint256 i = 0; i < _blackListedBots.length; i++) {
803                  if (_blackListedBots[i] == account) {
804                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
805                      _isBlackListedBot[account] = false;
806                      _blackListedBots.pop();
807                      break;
808                  }
809            }
810        }
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
823             require(_isExcluded[account], "Account is not excluded");
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
866             require(!_isBlackListedBot[sender], "You are blacklisted");
867             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
868             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
869             if(sender != owner() && recipient != owner()) {
870                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
871             }
872             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
873                 uint256 tokenBalanceRecipient = balanceOf(recipient);
874                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
875             }
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
889                 // Swap tokens for ETH and send to resepctive wallets
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
929             _devWalletAddress.transfer(amount.div(4));
930             _marketingWalletAddress.transfer(amount.div(12).mul(5));
931             _dipWalletAddress.transfer(amount.div(9).mul(2));
932             _marketingWalletAddress2.transfer(amount.div(9));
933         }
934 
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
1026         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1027         uint256 currentRate = _getRate();
1028         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
1029         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1030     }
1031 
1032         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1033             uint256 tFee = tAmount.mul(taxFee).div(100);
1034             uint256 tTeam = tAmount.mul(teamFee).div(100);
1035             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1036             return (tTransferAmount, tFee, tTeam);
1037         }
1038 
1039         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1040             uint256 rAmount = tAmount.mul(currentRate);
1041             uint256 rFee = tFee.mul(currentRate);
1042             uint256 rTeam = tTeam.mul(currentRate);
1043             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1044             return (rAmount, rTransferAmount, rFee);
1045         }
1046 
1047         function _getRate() private view returns(uint256) {
1048             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1049             return rSupply.div(tSupply);
1050         }
1051 
1052         function _getCurrentSupply() private view returns(uint256, uint256) {
1053             uint256 rSupply = _rTotal;
1054             uint256 tSupply = _tTotal;
1055             for (uint256 i = 0; i < _excluded.length; i++) {
1056                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1057                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1058                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1059             }
1060             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1061             return (rSupply, tSupply);
1062         }
1063 
1064         function _getTaxFee() public view returns(uint256) {
1065             return _taxFee;
1066         }
1067 
1068         function _getTeamFee() public view returns (uint256) {
1069           return _teamFee;
1070         }
1071 
1072         function _getMaxTxAmount() public view returns(uint256) {
1073             return _maxTxAmount;
1074         }
1075 
1076         function _getETHBalance() public view returns(uint256 balance) {
1077             return address(this).balance;
1078         }
1079 
1080         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1081             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1082             _taxFee = taxFee;
1083         }
1084 
1085         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1086             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1087             _teamFee = teamFee;
1088         }
1089 
1090         function _setDevWallet(address payable devWalletAddress) external onlyOwner() {
1091             _devWalletAddress = devWalletAddress;
1092         }
1093 
1094         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1095             _marketingWalletAddress = marketingWalletAddress;
1096         }
1097 
1098         function _setMarketingWallet2(address payable marketingWalletAddress2) external onlyOwner() {
1099             _marketingWalletAddress2 = marketingWalletAddress2;
1100         }
1101 
1102         function _setDipWallet(address payable dipWalletAddress) external onlyOwner() {
1103             _dipWalletAddress = dipWalletAddress;
1104         }
1105 
1106         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1107             _maxTxAmount = maxTxAmount;
1108         }
1109 
1110         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1111           _maxWalletSize = maxWalletSize;
1112         }
1113     }