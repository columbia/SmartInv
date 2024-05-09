1 pragma solidity ^0.6.12;
2 
3 // SPDX-License-Identifier: Unlicensed
4 
5 abstract contract Context {
6         function _msgSender() internal view virtual returns (address payable) {
7             return msg.sender;
8         }
9 
10         function _msgData() internal view virtual returns (bytes memory) {
11             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12             return msg.data;
13         }
14     }
15 
16     interface IERC20 {
17         /**
18         * @dev Returns the amount of tokens in existence.
19         */
20         function totalSupply() external view returns (uint256);
21 
22         /**
23         * @dev Returns the amount of tokens owned by `account`.
24         */
25         function balanceOf(address account) external view returns (uint256);
26 
27         /**
28         * @dev Moves `amount` tokens from the caller's account to `recipient`.
29         *
30         * Returns a boolean value indicating whether the operation succeeded.
31         *
32         * Emits a {Transfer} event.
33         */
34         function transfer(address recipient, uint256 amount) external returns (bool);
35 
36         /**
37         * @dev Returns the remaining number of tokens that `spender` will be
38         * allowed to spend on behalf of `owner` through {transferFrom}. This is
39         * zero by default.
40         *
41         * This value changes when {approve} or {transferFrom} are called.
42         */
43         function allowance(address owner, address spender) external view returns (uint256);
44 
45         /**
46         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47         *
48         * Returns a boolean value indicating whether the operation succeeded.
49         *
50         * IMPORTANT: Beware that changing an allowance with this method brings the risk
51         * that someone may use both the old and the new allowance by unfortunate
52         * transaction ordering. One possible solution to mitigate this race
53         * condition is to first reduce the spender's allowance to 0 and set the
54         * desired value afterwards:
55         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56         *
57         * Emits an {Approval} event.
58         */
59         function approve(address spender, uint256 amount) external returns (bool);
60 
61         /**
62         * @dev Moves `amount` tokens from `sender` to `recipient` using the
63         * allowance mechanism. `amount` is then deducted from the caller's
64         * allowance.
65         *
66         * Returns a boolean value indicating whether the operation succeeded.
67         *
68         * Emits a {Transfer} event.
69         */
70         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72         /**
73         * @dev Emitted when `value` tokens are moved from one account (`from`) to
74         * another (`to`).
75         *
76         * Note that `value` may be zero.
77         */
78         event Transfer(address indexed from, address indexed to, uint256 value);
79 
80         /**
81         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82         * a call to {approve}. `value` is the new allowance.
83         */
84         event Approval(address indexed owner, address indexed spender, uint256 value);
85     }
86 
87     library SafeMath {
88         /**
89         * @dev Returns the addition of two unsigned integers, reverting on
90         * overflow.
91         *
92         * Counterpart to Solidity's `+` operator.
93         *
94         * Requirements:
95         *
96         * - Addition cannot overflow.
97         */
98         function add(uint256 a, uint256 b) internal pure returns (uint256) {
99             uint256 c = a + b;
100             require(c >= a, "SafeMath: addition overflow");
101 
102             return c;
103         }
104 
105         /**
106         * @dev Returns the subtraction of two unsigned integers, reverting on
107         * overflow (when the result is negative).
108         *
109         * Counterpart to Solidity's `-` operator.
110         *
111         * Requirements:
112         *
113         * - Subtraction cannot overflow.
114         */
115         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116             return sub(a, b, "SafeMath: subtraction overflow");
117         }
118 
119         /**
120         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121         * overflow (when the result is negative).
122         *
123         * Counterpart to Solidity's `-` operator.
124         *
125         * Requirements:
126         *
127         * - Subtraction cannot overflow.
128         */
129         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130             require(b <= a, errorMessage);
131             uint256 c = a - b;
132 
133             return c;
134         }
135 
136         /**
137         * @dev Returns the multiplication of two unsigned integers, reverting on
138         * overflow.
139         *
140         * Counterpart to Solidity's `*` operator.
141         *
142         * Requirements:
143         *
144         * - Multiplication cannot overflow.
145         */
146         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148             // benefit is lost if 'b' is also tested.
149             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150             if (a == 0) {
151                 return 0;
152             }
153 
154             uint256 c = a * b;
155             require(c / a == b, "SafeMath: multiplication overflow");
156 
157             return c;
158         }
159 
160         /**
161         * @dev Returns the integer division of two unsigned integers. Reverts on
162         * division by zero. The result is rounded towards zero.
163         *
164         * Counterpart to Solidity's `/` operator. Note: this function uses a
165         * `revert` opcode (which leaves remaining gas untouched) while Solidity
166         * uses an invalid opcode to revert (consuming all remaining gas).
167         *
168         * Requirements:
169         *
170         * - The divisor cannot be zero.
171         */
172         function div(uint256 a, uint256 b) internal pure returns (uint256) {
173             return div(a, b, "SafeMath: division by zero");
174         }
175 
176         /**
177         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178         * division by zero. The result is rounded towards zero.
179         *
180         * Counterpart to Solidity's `/` operator. Note: this function uses a
181         * `revert` opcode (which leaves remaining gas untouched) while Solidity
182         * uses an invalid opcode to revert (consuming all remaining gas).
183         *
184         * Requirements:
185         *
186         * - The divisor cannot be zero.
187         */
188         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189             require(b > 0, errorMessage);
190             uint256 c = a / b;
191             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193             return c;
194         }
195 
196         /**
197         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198         * Reverts when dividing by zero.
199         *
200         * Counterpart to Solidity's `%` operator. This function uses a `revert`
201         * opcode (which leaves remaining gas untouched) while Solidity uses an
202         * invalid opcode to revert (consuming all remaining gas).
203         *
204         * Requirements:
205         *
206         * - The divisor cannot be zero.
207         */
208         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209             return mod(a, b, "SafeMath: modulo by zero");
210         }
211 
212         /**
213         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214         * Reverts with custom message when dividing by zero.
215         *
216         * Counterpart to Solidity's `%` operator. This function uses a `revert`
217         * opcode (which leaves remaining gas untouched) while Solidity uses an
218         * invalid opcode to revert (consuming all remaining gas).
219         *
220         * Requirements:
221         *
222         * - The divisor cannot be zero.
223         */
224         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225             require(b != 0, errorMessage);
226             return a % b;
227         }
228     }
229 
230     library Address {
231         /**
232         * @dev Returns true if `account` is a contract.
233         *
234         * [IMPORTANT]
235         * ====
236         * It is unsafe to assume that an address for which this function returns
237         * false is an externally-owned account (EOA) and not a contract.
238         *
239         * Among others, `isContract` will return false for the following
240         * types of addresses:
241         *
242         *  - an externally-owned account
243         *  - a contract in construction
244         *  - an address where a contract will be created
245         *  - an address where a contract lived, but was destroyed
246         * ====
247         */
248         function isContract(address account) internal view returns (bool) {
249             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
250             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
251             // for accounts without code, i.e. `keccak256('')`
252             bytes32 codehash;
253             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
254             // solhint-disable-next-line no-inline-assembly
255             assembly { codehash := extcodehash(account) }
256             return (codehash != accountHash && codehash != 0x0);
257         }
258 
259         /**
260         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261         * `recipient`, forwarding all available gas and reverting on errors.
262         *
263         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264         * of certain opcodes, possibly making contracts go over the 2300 gas limit
265         * imposed by `transfer`, making them unable to receive funds via
266         * `transfer`. {sendValue} removes this limitation.
267         *
268         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269         *
270         * IMPORTANT: because control is transferred to `recipient`, care must be
271         * taken to not create reentrancy vulnerabilities. Consider using
272         * {ReentrancyGuard} or the
273         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274         */
275         function sendValue(address payable recipient, uint256 amount) internal {
276             require(address(this).balance >= amount, "Address: insufficient balance");
277 
278             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
279             (bool success, ) = recipient.call{ value: amount }("");
280             require(success, "Address: unable to send value, recipient may have reverted");
281         }
282 
283         /**
284         * @dev Performs a Solidity function call using a low level `call`. A
285         * plain`call` is an unsafe replacement for a function call: use this
286         * function instead.
287         *
288         * If `target` reverts with a revert reason, it is bubbled up by this
289         * function (like regular Solidity function calls).
290         *
291         * Returns the raw returned data. To convert to the expected return value,
292         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293         *
294         * Requirements:
295         *
296         * - `target` must be a contract.
297         * - calling `target` with `data` must not revert.
298         *
299         * _Available since v3.1._
300         */
301         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302         return functionCall(target, data, "Address: low-level call failed");
303         }
304 
305         /**
306         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307         * `errorMessage` as a fallback revert reason when `target` reverts.
308         *
309         * _Available since v3.1._
310         */
311         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
312             return _functionCallWithValue(target, data, 0, errorMessage);
313         }
314 
315         /**
316         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317         * but also transferring `value` wei to `target`.
318         *
319         * Requirements:
320         *
321         * - the calling contract must have an ETH balance of at least `value`.
322         * - the called Solidity function must be `payable`.
323         *
324         * _Available since v3.1._
325         */
326         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
327             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328         }
329 
330         /**
331         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332         * with `errorMessage` as a fallback revert reason when `target` reverts.
333         *
334         * _Available since v3.1._
335         */
336         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
337             require(address(this).balance >= value, "Address: insufficient balance for call");
338             return _functionCallWithValue(target, data, value, errorMessage);
339         }
340 
341         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
342             require(isContract(target), "Address: call to non-contract");
343 
344             // solhint-disable-next-line avoid-low-level-calls
345             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
346             if (success) {
347                 return returndata;
348             } else {
349                 // Look for revert reason and bubble it up if present
350                 if (returndata.length > 0) {
351                     // The easiest way to bubble the revert reason is using memory via assembly
352 
353                     // solhint-disable-next-line no-inline-assembly
354                     assembly {
355                         let returndata_size := mload(returndata)
356                         revert(add(32, returndata), returndata_size)
357                     }
358                 } else {
359                     revert(errorMessage);
360                 }
361             }
362         }
363     }
364 
365     contract Ownable is Context {
366         address private _owner;
367         address private _previousOwner;
368         uint256 private _lockTime;
369 
370         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
371 
372         /**
373         * @dev Initializes the contract setting the deployer as the initial owner.
374         */
375         constructor () internal {
376             address msgSender = _msgSender();
377             _owner = msgSender;
378             emit OwnershipTransferred(address(0), msgSender);
379         }
380 
381         /**
382         * @dev Returns the address of the current owner.
383         */
384         function owner() public view returns (address) {
385             return _owner;
386         }
387 
388         /**
389         * @dev Throws if called by any account other than the owner.
390         */
391         modifier onlyOwner() {
392             require(_owner == _msgSender(), "Ownable: caller is not the owner");
393             _;
394         }
395 
396         /**
397         * @dev Leaves the contract without owner. It will not be possible to call
398         * `onlyOwner` functions anymore. Can only be called by the current owner.
399         *
400         * NOTE: Renouncing ownership will leave the contract without an owner,
401         * thereby removing any functionality that is only available to the owner.
402         */
403         function renounceOwnership() public virtual onlyOwner {
404             emit OwnershipTransferred(_owner, address(0));
405             _owner = address(0);
406         }
407 
408         /**
409         * @dev Transfers ownership of the contract to a new account (`newOwner`).
410         * Can only be called by the current owner.
411         */
412         function transferOwnership(address newOwner) public virtual onlyOwner {
413             require(newOwner != address(0), "Ownable: new owner is the zero address");
414             emit OwnershipTransferred(_owner, newOwner);
415             _owner = newOwner;
416         }
417 
418         function geUnlockTime() public view returns (uint256) {
419             return _lockTime;
420         }
421 
422         //Locks the contract for owner for the amount of time provided
423         function lock(uint256 time) public virtual onlyOwner {
424             _previousOwner = _owner;
425             _owner = address(0);
426             _lockTime = now + time;
427             emit OwnershipTransferred(_owner, address(0));
428         }
429         
430         //Unlocks the contract for owner when _lockTime is exceeds
431         function unlock() public virtual {
432             require(_previousOwner == msg.sender, "You don't have permission to unlock");
433             require(now > _lockTime , "Contract is locked until 7 days");
434             emit OwnershipTransferred(_owner, _previousOwner);
435             _owner = _previousOwner;
436         }
437     }  
438 
439     interface IUniswapV2Factory {
440         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
441 
442         function feeTo() external view returns (address);
443         function feeToSetter() external view returns (address);
444 
445         function getPair(address tokenA, address tokenB) external view returns (address pair);
446         function allPairs(uint) external view returns (address pair);
447         function allPairsLength() external view returns (uint);
448 
449         function createPair(address tokenA, address tokenB) external returns (address pair);
450 
451         function setFeeTo(address) external;
452         function setFeeToSetter(address) external;
453     } 
454 
455     interface IUniswapV2Pair {
456         event Approval(address indexed owner, address indexed spender, uint value);
457         event Transfer(address indexed from, address indexed to, uint value);
458 
459         function name() external pure returns (string memory);
460         function symbol() external pure returns (string memory);
461         function decimals() external pure returns (uint8);
462         function totalSupply() external view returns (uint);
463         function balanceOf(address owner) external view returns (uint);
464         function allowance(address owner, address spender) external view returns (uint);
465 
466         function approve(address spender, uint value) external returns (bool);
467         function transfer(address to, uint value) external returns (bool);
468         function transferFrom(address from, address to, uint value) external returns (bool);
469 
470         function DOMAIN_SEPARATOR() external view returns (bytes32);
471         function PERMIT_TYPEHASH() external pure returns (bytes32);
472         function nonces(address owner) external view returns (uint);
473 
474         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
475 
476         event Mint(address indexed sender, uint amount0, uint amount1);
477         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
478         event Swap(
479             address indexed sender,
480             uint amount0In,
481             uint amount1In,
482             uint amount0Out,
483             uint amount1Out,
484             address indexed to
485         );
486         event Sync(uint112 reserve0, uint112 reserve1);
487 
488         function MINIMUM_LIQUIDITY() external pure returns (uint);
489         function factory() external view returns (address);
490         function token0() external view returns (address);
491         function token1() external view returns (address);
492         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
493         function price0CumulativeLast() external view returns (uint);
494         function price1CumulativeLast() external view returns (uint);
495         function kLast() external view returns (uint);
496 
497         function mint(address to) external returns (uint liquidity);
498         function burn(address to) external returns (uint amount0, uint amount1);
499         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
500         function skim(address to) external;
501         function sync() external;
502 
503         function initialize(address, address) external;
504     }
505 
506     interface IUniswapV2Router01 {
507         function factory() external pure returns (address);
508         function WETH() external pure returns (address);
509 
510         function addLiquidity(
511             address tokenA,
512             address tokenB,
513             uint amountADesired,
514             uint amountBDesired,
515             uint amountAMin,
516             uint amountBMin,
517             address to,
518             uint deadline
519         ) external returns (uint amountA, uint amountB, uint liquidity);
520         function addLiquidityETH(
521             address token,
522             uint amountTokenDesired,
523             uint amountTokenMin,
524             uint amountETHMin,
525             address to,
526             uint deadline
527         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
528         function removeLiquidity(
529             address tokenA,
530             address tokenB,
531             uint liquidity,
532             uint amountAMin,
533             uint amountBMin,
534             address to,
535             uint deadline
536         ) external returns (uint amountA, uint amountB);
537         function removeLiquidityETH(
538             address token,
539             uint liquidity,
540             uint amountTokenMin,
541             uint amountETHMin,
542             address to,
543             uint deadline
544         ) external returns (uint amountToken, uint amountETH);
545         function removeLiquidityWithPermit(
546             address tokenA,
547             address tokenB,
548             uint liquidity,
549             uint amountAMin,
550             uint amountBMin,
551             address to,
552             uint deadline,
553             bool approveMax, uint8 v, bytes32 r, bytes32 s
554         ) external returns (uint amountA, uint amountB);
555         function removeLiquidityETHWithPermit(
556             address token,
557             uint liquidity,
558             uint amountTokenMin,
559             uint amountETHMin,
560             address to,
561             uint deadline,
562             bool approveMax, uint8 v, bytes32 r, bytes32 s
563         ) external returns (uint amountToken, uint amountETH);
564         function swapExactTokensForTokens(
565             uint amountIn,
566             uint amountOutMin,
567             address[] calldata path,
568             address to,
569             uint deadline
570         ) external returns (uint[] memory amounts);
571         function swapTokensForExactTokens(
572             uint amountOut,
573             uint amountInMax,
574             address[] calldata path,
575             address to,
576             uint deadline
577         ) external returns (uint[] memory amounts);
578         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
579             external
580             payable
581             returns (uint[] memory amounts);
582         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
583             external
584             returns (uint[] memory amounts);
585         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
586             external
587             returns (uint[] memory amounts);
588         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
589             external
590             payable
591             returns (uint[] memory amounts);
592 
593         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
594         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
595         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
596         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
597         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
598     }
599 
600     interface IUniswapV2Router02 is IUniswapV2Router01 {
601         function removeLiquidityETHSupportingFeeOnTransferTokens(
602             address token,
603             uint liquidity,
604             uint amountTokenMin,
605             uint amountETHMin,
606             address to,
607             uint deadline
608         ) external returns (uint amountETH);
609         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
610             address token,
611             uint liquidity,
612             uint amountTokenMin,
613             uint amountETHMin,
614             address to,
615             uint deadline,
616             bool approveMax, uint8 v, bytes32 r, bytes32 s
617         ) external returns (uint amountETH);
618 
619         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
620             uint amountIn,
621             uint amountOutMin,
622             address[] calldata path,
623             address to,
624             uint deadline
625         ) external;
626         function swapExactETHForTokensSupportingFeeOnTransferTokens(
627             uint amountOutMin,
628             address[] calldata path,
629             address to,
630             uint deadline
631         ) external payable;
632         function swapExactTokensForETHSupportingFeeOnTransferTokens(
633             uint amountIn,
634             uint amountOutMin,
635             address[] calldata path,
636             address to,
637             uint deadline
638         ) external;
639     }
640 
641     // Contract implementarion
642     
643     contract SOCIETY_OF_GALACTIC_EXPLORATION is Context, IERC20, Ownable {
644         using SafeMath for uint256;
645         using Address for address;
646 
647         mapping (address => uint256) private _rOwned;
648         mapping (address => uint256) private _tOwned;
649         mapping (address => mapping (address => uint256)) private _allowances;
650 
651         mapping (address => bool) private _isExcludedFromFee;
652 
653         mapping (address => bool) private _isExcluded;
654         address[] private _excluded;
655     
656         uint256 private constant MAX = ~uint256(0);
657         uint256 private _tTotal = 100000000000000 * 10**9;
658         uint256 private _rTotal = (MAX - (MAX % _tTotal));
659         uint256 private _tFeeTotal;
660 
661         string private _name = 'SOCIETY OF GALACTIC EXPLORATION';
662         string private _symbol = 'SOGE';
663         uint8 private _decimals = 9;
664         
665         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
666         // Charity wallet address is null but the method to set the address is exposed
667         uint256 private _taxFee = 2; 
668         uint256 private _charityFee = 2;
669         uint256 private _previousTaxFee = _taxFee;
670         uint256 private _previousCharityFee = _charityFee;
671 
672         address payable public _charityWalletAddress;
673 
674         IUniswapV2Router02 public immutable uniswapV2Router;
675         address public immutable uniswapV2Pair;
676 
677         bool inSwap = false;
678         bool public swapEnabled = true;
679 
680         uint256 private _maxTxAmount = 100000000000000e9;
681         // We will set a minimum amount of tokens to be swaped => 5M
682         uint256 private _numOfTokensToExchangeForCharity = 2 * 10**6 * 10**9;
683 
684         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
685         event SwapEnabledUpdated(bool enabled);
686 
687         modifier lockTheSwap {
688             inSwap = true;
689             _;
690             inSwap = false;
691         }
692 
693         constructor (address payable charityWalletAddress) public {
694             _charityWalletAddress = charityWalletAddress;
695             _rOwned[_msgSender()] = _rTotal;
696 
697             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
698             // Create a uniswap pair for this new token
699             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
700                 .createPair(address(this), _uniswapV2Router.WETH());
701 
702             // set the rest of the contract variables
703             uniswapV2Router = _uniswapV2Router;
704 
705             // Exclude owner and this contract from fee
706             _isExcludedFromFee[owner()] = true;
707             _isExcludedFromFee[address(this)] = true;
708 
709             emit Transfer(address(0), _msgSender(), _tTotal);
710         }
711 
712         function name() public view returns (string memory) {
713             return _name;
714         }
715 
716         function symbol() public view returns (string memory) {
717             return _symbol;
718         }
719 
720         function decimals() public view returns (uint8) {
721             return _decimals;
722         }
723 
724         function totalSupply() public view override returns (uint256) {
725             return _tTotal;
726         }
727 
728         function balanceOf(address account) public view override returns (uint256) {
729             if (_isExcluded[account]) return _tOwned[account];
730             return tokenFromReflection(_rOwned[account]);
731         }
732 
733         function transfer(address recipient, uint256 amount) public override returns (bool) {
734             _transfer(_msgSender(), recipient, amount);
735             return true;
736         }
737 
738         function allowance(address owner, address spender) public view override returns (uint256) {
739             return _allowances[owner][spender];
740         }
741 
742         function approve(address spender, uint256 amount) public override returns (bool) {
743             _approve(_msgSender(), spender, amount);
744             return true;
745         }
746 
747         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
748             _transfer(sender, recipient, amount);
749             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
750             return true;
751         }
752 
753         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
754             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
755             return true;
756         }
757 
758         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
759             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
760             return true;
761         }
762 
763         function isExcluded(address account) public view returns (bool) {
764             return _isExcluded[account];
765         }
766 
767         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
768             _isExcludedFromFee[account] = excluded;
769         }
770 
771         function totalFees() public view returns (uint256) {
772             return _tFeeTotal;
773         }
774 
775         function deliver(uint256 tAmount) public {
776             address sender = _msgSender();
777             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
778             (uint256 rAmount,,,,,) = _getValues(tAmount);
779             _rOwned[sender] = _rOwned[sender].sub(rAmount);
780             _rTotal = _rTotal.sub(rAmount);
781             _tFeeTotal = _tFeeTotal.add(tAmount);
782         }
783 
784         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
785             require(tAmount <= _tTotal, "Amount must be less than supply");
786             if (!deductTransferFee) {
787                 (uint256 rAmount,,,,,) = _getValues(tAmount);
788                 return rAmount;
789             } else {
790                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
791                 return rTransferAmount;
792             }
793         }
794 
795         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
796             require(rAmount <= _rTotal, "Amount must be less than total reflections");
797             uint256 currentRate =  _getRate();
798             return rAmount.div(currentRate);
799         }
800 
801         function excludeAccount(address account) external onlyOwner() {
802             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
803             require(!_isExcluded[account], "Account is already excluded");
804             if(_rOwned[account] > 0) {
805                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
806             }
807             _isExcluded[account] = true;
808             _excluded.push(account);
809         }
810 
811         function includeAccount(address account) external onlyOwner() {
812             require(_isExcluded[account], "Account is already excluded");
813             for (uint256 i = 0; i < _excluded.length; i++) {
814                 if (_excluded[i] == account) {
815                     _excluded[i] = _excluded[_excluded.length - 1];
816                     _tOwned[account] = 0;
817                     _isExcluded[account] = false;
818                     _excluded.pop();
819                     break;
820                 }
821             }
822         }
823 
824         function removeAllFee() private {
825             if(_taxFee == 0 && _charityFee == 0) return;
826             
827             _previousTaxFee = _taxFee;
828             _previousCharityFee = _charityFee;
829             
830             _taxFee = 0;
831             _charityFee = 0;
832         }
833     
834         function restoreAllFee() private {
835             _taxFee = _previousTaxFee;
836             _charityFee = _previousCharityFee;
837         }
838     
839         function isExcludedFromFee(address account) public view returns(bool) {
840             return _isExcludedFromFee[account];
841         }
842 
843         function _approve(address owner, address spender, uint256 amount) private {
844             require(owner != address(0), "ERC20: approve from the zero address");
845             require(spender != address(0), "ERC20: approve to the zero address");
846 
847             _allowances[owner][spender] = amount;
848             emit Approval(owner, spender, amount);
849         }
850 
851         function _transfer(address sender, address recipient, uint256 amount) private {
852             require(sender != address(0), "ERC20: transfer from the zero address");
853             require(recipient != address(0), "ERC20: transfer to the zero address");
854             require(amount > 0, "Transfer amount must be greater than zero");
855             
856             if(sender != owner() && recipient != owner())
857                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
858 
859             // is the token balance of this contract address over the min number of
860             // tokens that we need to initiate a swap?
861             // also, don't get caught in a circular charity event.
862             // also, don't swap if sender is uniswap pair.
863             uint256 contractTokenBalance = balanceOf(address(this));
864             
865             if(contractTokenBalance >= _maxTxAmount)
866             {
867                 contractTokenBalance = _maxTxAmount;
868             }
869             
870             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;
871             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
872                 // We need to swap the current tokens to ETH and send to the charity wallet
873                 swapTokensForEth(contractTokenBalance);
874                 
875                 uint256 contractETHBalance = address(this).balance;
876                 if(contractETHBalance > 0) {
877                     sendETHToCharity(address(this).balance);
878                 }
879             }
880             
881             //indicates if fee should be deducted from transfer
882             bool takeFee = true;
883             
884             //if any account belongs to _isExcludedFromFee account then remove the fee
885             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
886                 takeFee = false;
887             }
888             
889             //transfer amount, it will take tax and charity fee
890             _tokenTransfer(sender,recipient,amount,takeFee);
891         }
892 
893         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
894             // generate the uniswap pair path of token -> weth
895             address[] memory path = new address[](2);
896             path[0] = address(this);
897             path[1] = uniswapV2Router.WETH();
898 
899             _approve(address(this), address(uniswapV2Router), tokenAmount);
900 
901             // make the swap
902             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
903                 tokenAmount,
904                 0, // accept any amount of ETH
905                 path,
906                 address(this),
907                 block.timestamp
908             );
909         }
910         
911         function sendETHToCharity(uint256 amount) private {
912             _charityWalletAddress.transfer(amount);
913         }
914         
915         // We are exposing these functions to be able to manual swap and send
916         // in case the token is highly valued and 5M becomes too much
917         function manualSwap() external onlyOwner() {
918             uint256 contractBalance = balanceOf(address(this));
919             swapTokensForEth(contractBalance);
920         }
921         
922         function manualSend() external onlyOwner() {
923             uint256 contractETHBalance = address(this).balance;
924             sendETHToCharity(contractETHBalance);
925         }
926 
927         function setSwapEnabled(bool enabled) external onlyOwner(){
928             swapEnabled = enabled;
929         }
930         
931         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
932             if(!takeFee)
933                 removeAllFee();
934 
935             if (_isExcluded[sender] && !_isExcluded[recipient]) {
936                 _transferFromExcluded(sender, recipient, amount);
937             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
938                 _transferToExcluded(sender, recipient, amount);
939             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
940                 _transferStandard(sender, recipient, amount);
941             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
942                 _transferBothExcluded(sender, recipient, amount);
943             } else {
944                 _transferStandard(sender, recipient, amount);
945             }
946 
947             if(!takeFee)
948                 restoreAllFee();
949         }
950 
951         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
952             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
953             _rOwned[sender] = _rOwned[sender].sub(rAmount);
954             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
955             _takeCharity(tCharity); 
956             _reflectFee(rFee, tFee);
957             emit Transfer(sender, recipient, tTransferAmount);
958         }
959 
960         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
961             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
962             _rOwned[sender] = _rOwned[sender].sub(rAmount);
963             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
964             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
965             _takeCharity(tCharity);           
966             _reflectFee(rFee, tFee);
967             emit Transfer(sender, recipient, tTransferAmount);
968         }
969 
970         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
971             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
972             _tOwned[sender] = _tOwned[sender].sub(tAmount);
973             _rOwned[sender] = _rOwned[sender].sub(rAmount);
974             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
975             _takeCharity(tCharity);   
976             _reflectFee(rFee, tFee);
977             emit Transfer(sender, recipient, tTransferAmount);
978         }
979 
980         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
981             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
982             _tOwned[sender] = _tOwned[sender].sub(tAmount);
983             _rOwned[sender] = _rOwned[sender].sub(rAmount);
984             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
985             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
986             _takeCharity(tCharity);         
987             _reflectFee(rFee, tFee);
988             emit Transfer(sender, recipient, tTransferAmount);
989         }
990 
991         function _takeCharity(uint256 tCharity) private {
992             uint256 currentRate =  _getRate();
993             uint256 rCharity = tCharity.mul(currentRate);
994             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
995             if(_isExcluded[address(this)])
996                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
997         }
998 
999         function _reflectFee(uint256 rFee, uint256 tFee) private {
1000             _rTotal = _rTotal.sub(rFee);
1001             _tFeeTotal = _tFeeTotal.add(tFee);
1002         }
1003 
1004          //to recieve ETH from uniswapV2Router when swaping
1005         receive() external payable {}
1006 
1007         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1008             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1009             uint256 currentRate =  _getRate();
1010             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1011             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1012         }
1013 
1014         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1015             uint256 tFee = tAmount.mul(taxFee).div(100);
1016             uint256 tCharity = tAmount.mul(charityFee).div(100);
1017             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1018             return (tTransferAmount, tFee, tCharity);
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
1049         function _getMaxTxAmount() private view returns(uint256) {
1050             return _maxTxAmount;
1051         }
1052 
1053         function _getETHBalance() public view returns(uint256 balance) {
1054             return address(this).balance;
1055         }
1056         
1057         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1058             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1059             _taxFee = taxFee;
1060         }
1061 
1062         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1063             require(charityFee >= 1 && charityFee <= 5, 'charityFee should be in 1 - 5');
1064             _charityFee = charityFee;
1065         }
1066         
1067         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1068             _charityWalletAddress = charityWalletAddress;
1069         }
1070         
1071         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1072             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1073             _maxTxAmount = maxTxAmount;
1074         }
1075     }