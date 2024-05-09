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
625     contract PittysToken is Context, IERC20, Ownable {
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
645         string private constant _name = 'Pittys';
646         string private constant _symbol = 'PITTYS';
647         uint8 private constant _decimals = 18;
648 
649         uint256 private _returnFee = 0;
650         uint256 private _taxFee = 10;
651         uint256 private _previousReturnFee = _returnFee;
652         uint256 private _previousTaxFee = _taxFee;
653 
654         address payable public _devWalletAddress;
655         address payable public _marketingWalletAddress;
656         address payable public _rescueWalletAddress;
657 
658         IUniswapV2Router02 public immutable uniswapV2Router;
659         address public immutable uniswapV2Pair;
660 
661         bool inSwap = false;
662         bool public swapEnabled = true;
663 
664         uint256 private _maxTxAmount = 5000000 * 10**18;
665         uint256 private constant _numOfTokensToExchangeForTax = 5000 * 10**18;
666         uint256 private _maxWalletSize = 15000000 * 10**18;
667 
668         event botAddedToBlacklist(address account);
669         event botRemovedFromBlacklist(address account);
670 
671         // event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
672         // event SwapEnabledUpdated(bool enabled);
673 
674         modifier lockTheSwap {
675             inSwap = true;
676             _;
677             inSwap = false;
678         }
679 
680         constructor (address payable devWalletAddress, address payable marketingWalletAddress, address payable rescueWalletAddress) public {
681             _devWalletAddress = devWalletAddress;
682             _marketingWalletAddress = marketingWalletAddress;
683             _rescueWalletAddress = rescueWalletAddress;
684 
685             _rOwned[_msgSender()] = _rTotal;
686 
687             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
688             // Create a uniswap pair for this new token
689             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
690                 .createPair(address(this), _uniswapV2Router.WETH());
691 
692             // set the rest of the contract variables
693             uniswapV2Router = _uniswapV2Router;
694 
695             // Exclude owner and this contract from fee
696             _isExcludedFromFee[owner()] = true;
697             _isExcludedFromFee[address(this)] = true;
698 
699             emit Transfer(address(0), _msgSender(), _tTotal);
700         }
701 
702         function name() public pure returns (string memory) {
703             return _name;
704         }
705 
706         function symbol() public pure returns (string memory) {
707             return _symbol;
708         }
709 
710         function decimals() public pure returns (uint8) {
711             return _decimals;
712         }
713 
714         function totalSupply() public view override returns (uint256) {
715             return _tTotal;
716         }
717 
718         function balanceOf(address account) public view override returns (uint256) {
719             if (_isExcluded[account]) return _tOwned[account];
720             return tokenFromReflection(_rOwned[account]);
721         }
722 
723         function transfer(address recipient, uint256 amount) public override returns (bool) {
724             _transfer(_msgSender(), recipient, amount);
725             return true;
726         }
727 
728         function allowance(address owner, address spender) public view override returns (uint256) {
729             return _allowances[owner][spender];
730         }
731 
732         function approve(address spender, uint256 amount) public override returns (bool) {
733             _approve(_msgSender(), spender, amount);
734             return true;
735         }
736 
737         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
738             _transfer(sender, recipient, amount);
739             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
740             return true;
741         }
742 
743         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
744             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
745             return true;
746         }
747 
748         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
749             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
750             return true;
751         }
752 
753         function isExcluded(address account) public view returns (bool) {
754             return _isExcluded[account];
755         }
756 
757         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
758             _isExcludedFromFee[account] = excluded;
759         }
760 
761         function totalFees() public view returns (uint256) {
762             return _tFeeTotal;
763         }
764 
765         function deliver(uint256 tAmount) public {
766             address sender = _msgSender();
767             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
768             (uint256 rAmount,,,,,) = _getValues(tAmount);
769             _rOwned[sender] = _rOwned[sender].sub(rAmount);
770             _rTotal = _rTotal.sub(rAmount);
771             _tFeeTotal = _tFeeTotal.add(tAmount);
772         }
773 
774         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
775             require(tAmount <= _tTotal, "Amount must be less than supply");
776             if (!deductTransferFee) {
777                 (uint256 rAmount,,,,,) = _getValues(tAmount);
778                 return rAmount;
779             } else {
780                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
781                 return rTransferAmount;
782             }
783         }
784 
785         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
786             require(rAmount <= _rTotal, "Amount must be less than total reflections");
787             uint256 currentRate =  _getRate();
788             return rAmount.div(currentRate);
789         }
790 
791         function addBotToBlacklist (address account) external onlyOwner() {
792            require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We cannot blacklist UniSwap router');
793            require (!_isBlackListedBot[account], 'Account is already blacklisted');
794            _isBlackListedBot[account] = true;
795            _blackListedBots.push(account);
796         }
797 
798         function removeBotFromBlacklist(address account) external onlyOwner() {
799           require (_isBlackListedBot[account], 'Account is not blacklisted');
800           for (uint256 i = 0; i < _blackListedBots.length; i++) {
801                  if (_blackListedBots[i] == account) {
802                      _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
803                      _isBlackListedBot[account] = false;
804                      _blackListedBots.pop();
805                      break;
806                  }
807            }
808        }
809 
810         function excludeAccount(address account) external onlyOwner() {
811             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
812             require(!_isExcluded[account], "Account is already excluded");
813             if(_rOwned[account] > 0) {
814                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
815             }
816             _isExcluded[account] = true;
817             _excluded.push(account);
818         }
819 
820         function includeAccount(address account) external onlyOwner() {
821             require(_isExcluded[account], "Account is not excluded");
822             for (uint256 i = 0; i < _excluded.length; i++) {
823                 if (_excluded[i] == account) {
824                     _excluded[i] = _excluded[_excluded.length - 1];
825                     _tOwned[account] = 0;
826                     _isExcluded[account] = false;
827                     _excluded.pop();
828                     break;
829                 }
830             }
831         }
832 
833         function removeAllFee() private {
834             if(_returnFee == 0 && _taxFee == 0) return;
835 
836             _previousReturnFee = _returnFee;
837             _previousTaxFee = _taxFee;
838 
839             _returnFee = 0;
840             _taxFee = 0;
841         }
842 
843         function restoreAllFee() private {
844             _returnFee = _previousReturnFee;
845             _taxFee = _previousTaxFee;
846         }
847 
848         function isExcludedFromFee(address account) public view returns(bool) {
849             return _isExcludedFromFee[account];
850         }
851 
852         function _approve(address owner, address spender, uint256 amount) private {
853             require(owner != address(0), "ERC20: approve from the zero address");
854             require(spender != address(0), "ERC20: approve to the zero address");
855 
856             _allowances[owner][spender] = amount;
857             emit Approval(owner, spender, amount);
858         }
859 
860         function _transfer(address sender, address recipient, uint256 amount) private {
861             require(sender != address(0), "ERC20: transfer from the zero address");
862             require(recipient != address(0), "ERC20: transfer to the zero address");
863             require(amount > 0, "Transfer amount must be greater than zero");
864             require(!_isBlackListedBot[sender], "You are blacklisted");
865             require(!_isBlackListedBot[msg.sender], "You are blacklisted");
866             require(!_isBlackListedBot[tx.origin], "You are blacklisted");
867             if(sender != owner() && recipient != owner()) {
868                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
869             }
870             if(sender != owner() && recipient != owner() && recipient != uniswapV2Pair && recipient != address(0xdead)) {
871                 uint256 tokenBalanceRecipient = balanceOf(recipient);
872                 require(tokenBalanceRecipient + amount <= _maxWalletSize, "Recipient exceeds max wallet size.");
873             }
874             // is the token balance of this contract address over the min number of
875             // tokens that we need to initiate a swap?
876             // also, don't get caught in a circular tax event.
877             // also, don't swap if sender is uniswap pair.
878             uint256 contractTokenBalance = balanceOf(address(this));
879 
880             if(contractTokenBalance >= _maxTxAmount)
881             {
882                 contractTokenBalance = _maxTxAmount;
883             }
884 
885             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTax;
886             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
887                 // Swap tokens for ETH and send to resepctive wallets
888                 swapTokensForEth(contractTokenBalance);
889 
890                 uint256 contractETHBalance = address(this).balance;
891                 if(contractETHBalance > 0) {
892                     sendETHToTax(address(this).balance);
893                 }
894             }
895 
896             //indicates if fee should be deducted from transfer
897             bool takeFee = true;
898 
899             //if any account belongs to _isExcludedFromFee account then remove the fee
900             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
901                 takeFee = false;
902             }
903 
904             //transfer amount, it will take return and tax fee
905             _tokenTransfer(sender,recipient,amount,takeFee);
906         }
907 
908         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
909             // generate the uniswap pair path of token -> weth
910             address[] memory path = new address[](2);
911             path[0] = address(this);
912             path[1] = uniswapV2Router.WETH();
913 
914             _approve(address(this), address(uniswapV2Router), tokenAmount);
915 
916             // make the swap
917             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
918                 tokenAmount,
919                 0, // accept any amount of ETH
920                 path,
921                 address(this),
922                 block.timestamp
923             );
924         }
925 
926         function sendETHToTax(uint256 amount) private {
927             _devWalletAddress.transfer(amount.div(5));
928             _marketingWalletAddress.transfer(amount.div(10).mul(3));
929             _rescueWalletAddress.transfer(amount.div(2));
930         }
931 
932         function manualSwap() external onlyOwner() {
933             uint256 contractBalance = balanceOf(address(this));
934             swapTokensForEth(contractBalance);
935         }
936 
937         function manualSend() external onlyOwner() {
938             uint256 contractETHBalance = address(this).balance;
939             sendETHToTax(contractETHBalance);
940         }
941 
942         function setSwapEnabled(bool enabled) external onlyOwner(){
943             swapEnabled = enabled;
944         }
945 
946         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
947             if(!takeFee)
948                 removeAllFee();
949 
950             if (_isExcluded[sender] && !_isExcluded[recipient]) {
951                 _transferFromExcluded(sender, recipient, amount);
952             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
953                 _transferToExcluded(sender, recipient, amount);
954             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
955                 _transferStandard(sender, recipient, amount);
956             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
957                 _transferBothExcluded(sender, recipient, amount);
958             } else {
959                 _transferStandard(sender, recipient, amount);
960             }
961 
962             if(!takeFee)
963                 restoreAllFee();
964         }
965 
966         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
967             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTax) = _getValues(tAmount);
968             _rOwned[sender] = _rOwned[sender].sub(rAmount);
969             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
970             _takeTax(tTax);
971             _reflectFee(rFee, tFee);
972             emit Transfer(sender, recipient, tTransferAmount);
973         }
974 
975         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
976             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTax) = _getValues(tAmount);
977             _rOwned[sender] = _rOwned[sender].sub(rAmount);
978             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
979             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
980             _takeTax(tTax);
981             _reflectFee(rFee, tFee);
982             emit Transfer(sender, recipient, tTransferAmount);
983         }
984 
985         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
986             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTax) = _getValues(tAmount);
987             _tOwned[sender] = _tOwned[sender].sub(tAmount);
988             _rOwned[sender] = _rOwned[sender].sub(rAmount);
989             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
990             _takeTax(tTax);
991             _reflectFee(rFee, tFee);
992             emit Transfer(sender, recipient, tTransferAmount);
993         }
994 
995         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
996             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTax) = _getValues(tAmount);
997             _tOwned[sender] = _tOwned[sender].sub(tAmount);
998             _rOwned[sender] = _rOwned[sender].sub(rAmount);
999             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1000             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1001             _takeTax(tTax);
1002             _reflectFee(rFee, tFee);
1003             emit Transfer(sender, recipient, tTransferAmount);
1004         }
1005 
1006         function _takeTax(uint256 tTax) private {
1007             uint256 currentRate =  _getRate();
1008             uint256 rTax = tTax.mul(currentRate);
1009             _rOwned[address(this)] = _rOwned[address(this)].add(rTax);
1010             if(_isExcluded[address(this)])
1011                 _tOwned[address(this)] = _tOwned[address(this)].add(tTax);
1012         }
1013 
1014         function _reflectFee(uint256 rFee, uint256 tFee) private {
1015             _rTotal = _rTotal.sub(rFee);
1016             _tFeeTotal = _tFeeTotal.add(tFee);
1017         }
1018 
1019          //to recieve ETH from uniswapV2Router when swaping
1020         receive() external payable {}
1021 
1022         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1023         (uint256 tTransferAmount, uint256 tFee, uint256 tTax) = _getTValues(tAmount, _returnFee, _taxFee);
1024         uint256 currentRate = _getRate();
1025         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTax, currentRate);
1026         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTax);
1027     }
1028 
1029         function _getTValues(uint256 tAmount, uint256 returnFee, uint256 taxFee) private pure returns (uint256, uint256, uint256) {
1030             uint256 tFee = tAmount.mul(returnFee).div(100);
1031             uint256 tTax = tAmount.mul(taxFee).div(100);
1032             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTax);
1033             return (tTransferAmount, tFee, tTax);
1034         }
1035 
1036         function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTax, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1037             uint256 rAmount = tAmount.mul(currentRate);
1038             uint256 rFee = tFee.mul(currentRate);
1039             uint256 rTax = tTax.mul(currentRate);
1040             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTax);
1041             return (rAmount, rTransferAmount, rFee);
1042         }
1043 
1044         function _getRate() private view returns(uint256) {
1045             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1046             return rSupply.div(tSupply);
1047         }
1048 
1049         function _getCurrentSupply() private view returns(uint256, uint256) {
1050             uint256 rSupply = _rTotal;
1051             uint256 tSupply = _tTotal;
1052             for (uint256 i = 0; i < _excluded.length; i++) {
1053                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1054                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1055                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1056             }
1057             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1058             return (rSupply, tSupply);
1059         }
1060 
1061         function _getReturnFee() public view returns(uint256) {
1062             return _returnFee;
1063         }
1064 
1065         function _getTaxFee() public view returns (uint256) {
1066           return _taxFee;
1067         }
1068 
1069         function _getMaxTxAmount() public view returns(uint256) {
1070             return _maxTxAmount;
1071         }
1072 
1073         function _getETHBalance() public view returns(uint256 balance) {
1074             return address(this).balance;
1075         }
1076 
1077         function _setReturnFee(uint256 returnFee) external onlyOwner() {
1078             require(returnFee >= 1 && returnFee <= 25, 'returnFee should be in 1 - 25');
1079             _returnFee = returnFee;
1080         }
1081 
1082         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1083             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1084             _taxFee = taxFee;
1085         }
1086 
1087         function _setDevWallet(address payable devWalletAddress) external onlyOwner() {
1088             _devWalletAddress = devWalletAddress;
1089         }
1090 
1091         function _setMarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1092             _marketingWalletAddress = marketingWalletAddress;
1093         }
1094 
1095         function _setRescueWallet(address payable rescueWalletAddress) external onlyOwner() {
1096             _rescueWalletAddress = rescueWalletAddress;
1097         }
1098 
1099         
1100       
1101 
1102         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1103             _maxTxAmount = maxTxAmount;
1104         }
1105 
1106         function _setMaxWalletSize (uint256 maxWalletSize) external onlyOwner() {
1107           _maxWalletSize = maxWalletSize;
1108         }
1109     }