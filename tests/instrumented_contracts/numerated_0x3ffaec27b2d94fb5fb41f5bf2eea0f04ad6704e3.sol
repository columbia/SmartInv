1 /**
2  *Submitted for verification at Etherscan.io on 02/08/2021
3  *https://t.me/RagnarInu
4 */
5 
6 // SPDX-License-Identifier: Unlicensed
7 pragma solidity ^0.6.12;
8 
9     abstract contract Context {
10         function _msgSender() internal view virtual returns (address payable) {
11             return msg.sender;
12         }
13 
14         function _msgData() internal view virtual returns (bytes memory) {
15             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16             return msg.data;
17         }
18     }
19 
20     interface IERC20 {
21         /**
22         * @dev Returns the amount of tokens in existence.
23         */
24         function totalSupply() external view returns (uint256);
25 
26         /**
27         * @dev Returns the amount of tokens owned by `account`.
28         */
29         function balanceOf(address account) external view returns (uint256);
30 
31         /**
32         * @dev Moves `amount` tokens from the caller's account to `recipient`.
33         *
34         * Returns a boolean value indicating whether the operation succeeded.
35         *
36         * Emits a {Transfer} event.
37         */
38         function transfer(address recipient, uint256 amount) external returns (bool);
39 
40         /**
41         * @dev Returns the remaining number of tokens that `spender` will be
42         * allowed to spend on behalf of `owner` through {transferFrom}. This is
43         * zero by default.
44         *
45         * This value changes when {approve} or {transferFrom} are called.
46         */
47         function allowance(address owner, address spender) external view returns (uint256);
48 
49         /**
50         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51         *
52         * Returns a boolean value indicating whether the operation succeeded.
53         *
54         * IMPORTANT: Beware that changing an allowance with this method brings the risk
55         * that someone may use both the old and the new allowance by unfortunate
56         * transaction ordering. One possible solution to mitigate this race
57         * condition is to first reduce the spender's allowance to 0 and set the
58         * desired value afterwards:
59         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60         *
61         * Emits an {Approval} event.
62         */
63         function approve(address spender, uint256 amount) external returns (bool);
64 
65         /**
66         * @dev Moves `amount` tokens from `sender` to `recipient` using the
67         * allowance mechanism. `amount` is then deducted from the caller's
68         * allowance.
69         *
70         * Returns a boolean value indicating whether the operation succeeded.
71         *
72         * Emits a {Transfer} event.
73         */
74         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76         /**
77         * @dev Emitted when `value` tokens are moved from one account (`from`) to
78         * another (`to`).
79         *
80         * Note that `value` may be zero.
81         */
82         event Transfer(address indexed from, address indexed to, uint256 value);
83 
84         /**
85         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86         * a call to {approve}. `value` is the new allowance.
87         */
88         event Approval(address indexed owner, address indexed spender, uint256 value);
89     }
90 
91     library SafeMath {
92         /**
93         * @dev Returns the addition of two unsigned integers, reverting on
94         * overflow.
95         *
96         * Counterpart to Solidity's `+` operator.
97         *
98         * Requirements:
99         *
100         * - Addition cannot overflow.
101         */
102         function add(uint256 a, uint256 b) internal pure returns (uint256) {
103             uint256 c = a + b;
104             require(c >= a, "SafeMath: addition overflow");
105 
106             return c;
107         }
108 
109         /**
110         * @dev Returns the subtraction of two unsigned integers, reverting on
111         * overflow (when the result is negative).
112         *
113         * Counterpart to Solidity's `-` operator.
114         *
115         * Requirements:
116         *
117         * - Subtraction cannot overflow.
118         */
119         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120             return sub(a, b, "SafeMath: subtraction overflow");
121         }
122 
123         /**
124         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125         * overflow (when the result is negative).
126         *
127         * Counterpart to Solidity's `-` operator.
128         *
129         * Requirements:
130         *
131         * - Subtraction cannot overflow.
132         */
133         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134             require(b <= a, errorMessage);
135             uint256 c = a - b;
136 
137             return c;
138         }
139 
140         /**
141         * @dev Returns the multiplication of two unsigned integers, reverting on
142         * overflow.
143         *
144         * Counterpart to Solidity's `*` operator.
145         *
146         * Requirements:
147         *
148         * - Multiplication cannot overflow.
149         */
150         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152             // benefit is lost if 'b' is also tested.
153             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154             if (a == 0) {
155                 return 0;
156             }
157 
158             uint256 c = a * b;
159             require(c / a == b, "SafeMath: multiplication overflow");
160 
161             return c;
162         }
163 
164         /**
165         * @dev Returns the integer division of two unsigned integers. Reverts on
166         * division by zero. The result is rounded towards zero.
167         *
168         * Counterpart to Solidity's `/` operator. Note: this function uses a
169         * `revert` opcode (which leaves remaining gas untouched) while Solidity
170         * uses an invalid opcode to revert (consuming all remaining gas).
171         *
172         * Requirements:
173         *
174         * - The divisor cannot be zero.
175         */
176         function div(uint256 a, uint256 b) internal pure returns (uint256) {
177             return div(a, b, "SafeMath: division by zero");
178         }
179 
180         /**
181         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
192         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193             require(b > 0, errorMessage);
194             uint256 c = a / b;
195             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197             return c;
198         }
199 
200         /**
201         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202         * Reverts when dividing by zero.
203         *
204         * Counterpart to Solidity's `%` operator. This function uses a `revert`
205         * opcode (which leaves remaining gas untouched) while Solidity uses an
206         * invalid opcode to revert (consuming all remaining gas).
207         *
208         * Requirements:
209         *
210         * - The divisor cannot be zero.
211         */
212         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213             return mod(a, b, "SafeMath: modulo by zero");
214         }
215 
216         /**
217         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218         * Reverts with custom message when dividing by zero.
219         *
220         * Counterpart to Solidity's `%` operator. This function uses a `revert`
221         * opcode (which leaves remaining gas untouched) while Solidity uses an
222         * invalid opcode to revert (consuming all remaining gas).
223         *
224         * Requirements:
225         *
226         * - The divisor cannot be zero.
227         */
228         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229             require(b != 0, errorMessage);
230             return a % b;
231         }
232     }
233 
234     library Address {
235         /**
236         * @dev Returns true if `account` is a contract.
237         *
238         * [IMPORTANT]
239         * ====
240         * It is unsafe to assume that an address for which this function returns
241         * false is an externally-owned account (EOA) and not a contract.
242         *
243         * Among others, `isContract` will return false for the following
244         * types of addresses:
245         *
246         *  - an externally-owned account
247         *  - a contract in construction
248         *  - an address where a contract will be created
249         *  - an address where a contract lived, but was destroyed
250         * ====
251         */
252         function isContract(address account) internal view returns (bool) {
253             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
254             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
255             // for accounts without code, i.e. `keccak256('')`
256             bytes32 codehash;
257             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
258             // solhint-disable-next-line no-inline-assembly
259             assembly { codehash := extcodehash(account) }
260             return (codehash != accountHash && codehash != 0x0);
261         }
262 
263         /**
264         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
265         * `recipient`, forwarding all available gas and reverting on errors.
266         *
267         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
268         * of certain opcodes, possibly making contracts go over the 2300 gas limit
269         * imposed by `transfer`, making them unable to receive funds via
270         * `transfer`. {sendValue} removes this limitation.
271         *
272         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
273         *
274         * IMPORTANT: because control is transferred to `recipient`, care must be
275         * taken to not create reentrancy vulnerabilities. Consider using
276         * {ReentrancyGuard} or the
277         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
278         */
279         function sendValue(address payable recipient, uint256 amount) internal {
280             require(address(this).balance >= amount, "Address: insufficient balance");
281 
282             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
283             (bool success, ) = recipient.call{ value: amount }("");
284             require(success, "Address: unable to send value, recipient may have reverted");
285         }
286 
287         /**
288         * @dev Performs a Solidity function call using a low level `call`. A
289         * plain`call` is an unsafe replacement for a function call: use this
290         * function instead.
291         *
292         * If `target` reverts with a revert reason, it is bubbled up by this
293         * function (like regular Solidity function calls).
294         *
295         * Returns the raw returned data. To convert to the expected return value,
296         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
297         *
298         * Requirements:
299         *
300         * - `target` must be a contract.
301         * - calling `target` with `data` must not revert.
302         *
303         * _Available since v3.1._
304         */
305         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
306         return functionCall(target, data, "Address: low-level call failed");
307         }
308 
309         /**
310         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
311         * `errorMessage` as a fallback revert reason when `target` reverts.
312         *
313         * _Available since v3.1._
314         */
315         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
316             return _functionCallWithValue(target, data, 0, errorMessage);
317         }
318 
319         /**
320         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321         * but also transferring `value` wei to `target`.
322         *
323         * Requirements:
324         *
325         * - the calling contract must have an ETH balance of at least `value`.
326         * - the called Solidity function must be `payable`.
327         *
328         * _Available since v3.1._
329         */
330         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
331             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
332         }
333 
334         /**
335         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
336         * with `errorMessage` as a fallback revert reason when `target` reverts.
337         *
338         * _Available since v3.1._
339         */
340         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
341             require(address(this).balance >= value, "Address: insufficient balance for call");
342             return _functionCallWithValue(target, data, value, errorMessage);
343         }
344 
345         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
346             require(isContract(target), "Address: call to non-contract");
347 
348             // solhint-disable-next-line avoid-low-level-calls
349             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
350             if (success) {
351                 return returndata;
352             } else {
353                 // Look for revert reason and bubble it up if present
354                 if (returndata.length > 0) {
355                     // The easiest way to bubble the revert reason is using memory via assembly
356 
357                     // solhint-disable-next-line no-inline-assembly
358                     assembly {
359                         let returndata_size := mload(returndata)
360                         revert(add(32, returndata), returndata_size)
361                     }
362                 } else {
363                     revert(errorMessage);
364                 }
365             }
366         }
367     }
368 
369     contract Ownable is Context {
370         address private _owner;
371         address private _previousOwner;
372         uint256 private _lockTime;
373 
374         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376         /**
377         * @dev Initializes the contract setting the deployer as the initial owner.
378         */
379         constructor () internal {
380             address msgSender = _msgSender();
381             _owner = msgSender;
382             emit OwnershipTransferred(address(0), msgSender);
383         }
384 
385         /**
386         * @dev Returns the address of the current owner.
387         */
388         function owner() public view returns (address) {
389             return _owner;
390         }
391 
392         /**
393         * @dev Throws if called by any account other than the owner.
394         */
395         modifier onlyOwner() {
396             require(_owner == _msgSender(), "Ownable: caller is not the owner");
397             _;
398         }
399 
400         /**
401         * @dev Leaves the contract without owner. It will not be possible to call
402         * `onlyOwner` functions anymore. Can only be called by the current owner.
403         *
404         * NOTE: Renouncing ownership will leave the contract without an owner,
405         * thereby removing any functionality that is only available to the owner.
406         */
407         function renounceOwnership() public virtual onlyOwner {
408             emit OwnershipTransferred(_owner, address(0));
409             _owner = address(0);
410         }
411 
412         /**
413         * @dev Transfers ownership of the contract to a new account (`newOwner`).
414         * Can only be called by the current owner.
415         */
416         function transferOwnership(address newOwner) public virtual onlyOwner {
417             require(newOwner != address(0), "Ownable: new owner is the zero address");
418             emit OwnershipTransferred(_owner, newOwner);
419             _owner = newOwner;
420         }
421 
422         function geUnlockTime() public view returns (uint256) {
423             return _lockTime;
424         }
425 
426         //Locks the contract for owner for the amount of time provided
427         function lock(uint256 time) public virtual onlyOwner {
428             _previousOwner = _owner;
429             _owner = address(0);
430             _lockTime = now + time;
431             emit OwnershipTransferred(_owner, address(0));
432         }
433         
434         //Unlocks the contract for owner when _lockTime is exceeds
435         function unlock() public virtual {
436             require(_previousOwner == msg.sender, "You don't have permission to unlock");
437             require(now > _lockTime , "Contract is locked until 7 days");
438             emit OwnershipTransferred(_owner, _previousOwner);
439             _owner = _previousOwner;
440         }
441     }  
442 
443     interface IUniswapV2Factory {
444         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
445 
446         function feeTo() external view returns (address);
447         function feeToSetter() external view returns (address);
448 
449         function getPair(address tokenA, address tokenB) external view returns (address pair);
450         function allPairs(uint) external view returns (address pair);
451         function allPairsLength() external view returns (uint);
452 
453         function createPair(address tokenA, address tokenB) external returns (address pair);
454 
455         function setFeeTo(address) external;
456         function setFeeToSetter(address) external;
457     } 
458 
459     interface IUniswapV2Pair {
460         event Approval(address indexed owner, address indexed spender, uint value);
461         event Transfer(address indexed from, address indexed to, uint value);
462 
463         function name() external pure returns (string memory);
464         function symbol() external pure returns (string memory);
465         function decimals() external pure returns (uint8);
466         function totalSupply() external view returns (uint);
467         function balanceOf(address owner) external view returns (uint);
468         function allowance(address owner, address spender) external view returns (uint);
469 
470         function approve(address spender, uint value) external returns (bool);
471         function transfer(address to, uint value) external returns (bool);
472         function transferFrom(address from, address to, uint value) external returns (bool);
473 
474         function DOMAIN_SEPARATOR() external view returns (bytes32);
475         function PERMIT_TYPEHASH() external pure returns (bytes32);
476         function nonces(address owner) external view returns (uint);
477 
478         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
479 
480         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
481         event Swap(
482             address indexed sender,
483             uint amount0In,
484             uint amount1In,
485             uint amount0Out,
486             uint amount1Out,
487             address indexed to
488         );
489         event Sync(uint112 reserve0, uint112 reserve1);
490 
491         function MINIMUM_LIQUIDITY() external pure returns (uint);
492         function factory() external view returns (address);
493         function token0() external view returns (address);
494         function token1() external view returns (address);
495         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
496         function price0CumulativeLast() external view returns (uint);
497         function price1CumulativeLast() external view returns (uint);
498         function kLast() external view returns (uint);
499 
500         function burn(address to) external returns (uint amount0, uint amount1);
501         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
502         function skim(address to) external;
503         function sync() external;
504 
505         function initialize(address, address) external;
506     }
507 
508     interface IUniswapV2Router01 {
509         function factory() external pure returns (address);
510         function WETH() external pure returns (address);
511 
512         function addLiquidity(
513             address tokenA,
514             address tokenB,
515             uint amountADesired,
516             uint amountBDesired,
517             uint amountAMin,
518             uint amountBMin,
519             address to,
520             uint deadline
521         ) external returns (uint amountA, uint amountB, uint liquidity);
522         function addLiquidityETH(
523             address token,
524             uint amountTokenDesired,
525             uint amountTokenMin,
526             uint amountETHMin,
527             address to,
528             uint deadline
529         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
530         function removeLiquidity(
531             address tokenA,
532             address tokenB,
533             uint liquidity,
534             uint amountAMin,
535             uint amountBMin,
536             address to,
537             uint deadline
538         ) external returns (uint amountA, uint amountB);
539         function removeLiquidityETH(
540             address token,
541             uint liquidity,
542             uint amountTokenMin,
543             uint amountETHMin,
544             address to,
545             uint deadline
546         ) external returns (uint amountToken, uint amountETH);
547         function removeLiquidityWithPermit(
548             address tokenA,
549             address tokenB,
550             uint liquidity,
551             uint amountAMin,
552             uint amountBMin,
553             address to,
554             uint deadline,
555             bool approveMax, uint8 v, bytes32 r, bytes32 s
556         ) external returns (uint amountA, uint amountB);
557         function removeLiquidityETHWithPermit(
558             address token,
559             uint liquidity,
560             uint amountTokenMin,
561             uint amountETHMin,
562             address to,
563             uint deadline,
564             bool approveMax, uint8 v, bytes32 r, bytes32 s
565         ) external returns (uint amountToken, uint amountETH);
566         function swapExactTokensForTokens(
567             uint amountIn,
568             uint amountOutMin,
569             address[] calldata path,
570             address to,
571             uint deadline
572         ) external returns (uint[] memory amounts);
573         function swapTokensForExactTokens(
574             uint amountOut,
575             uint amountInMax,
576             address[] calldata path,
577             address to,
578             uint deadline
579         ) external returns (uint[] memory amounts);
580         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
581             external
582             payable
583             returns (uint[] memory amounts);
584         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
585             external
586             returns (uint[] memory amounts);
587         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
588             external
589             returns (uint[] memory amounts);
590         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
591             external
592             payable
593             returns (uint[] memory amounts);
594 
595         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
596         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
597         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
598         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
599         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
600     }
601 
602     interface IUniswapV2Router02 is IUniswapV2Router01 {
603         function removeLiquidityETHSupportingFeeOnTransferTokens(
604             address token,
605             uint liquidity,
606             uint amountTokenMin,
607             uint amountETHMin,
608             address to,
609             uint deadline
610         ) external returns (uint amountETH);
611         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
612             address token,
613             uint liquidity,
614             uint amountTokenMin,
615             uint amountETHMin,
616             address to,
617             uint deadline,
618             bool approveMax, uint8 v, bytes32 r, bytes32 s
619         ) external returns (uint amountETH);
620 
621         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
622             uint amountIn,
623             uint amountOutMin,
624             address[] calldata path,
625             address to,
626             uint deadline
627         ) external;
628         function swapExactETHForTokensSupportingFeeOnTransferTokens(
629             uint amountOutMin,
630             address[] calldata path,
631             address to,
632             uint deadline
633         ) external payable;
634         function swapExactTokensForETHSupportingFeeOnTransferTokens(
635             uint amountIn,
636             uint amountOutMin,
637             address[] calldata path,
638             address to,
639             uint deadline
640         ) external;
641     }
642 
643     // Contract implementation
644     contract FlokiPup is Context, IERC20, Ownable {
645         using SafeMath for uint256;
646         using Address for address;
647 
648         mapping (address => uint256) private _rOwned;
649         mapping (address => uint256) private _tOwned;
650         mapping (address => mapping (address => uint256)) private _allowances;
651 
652         mapping (address => bool) private _isExcludedFromFee;
653 
654         mapping (address => bool) private _isExcluded;
655         address[] private _excluded;
656     
657         uint256 private constant MAX = ~uint256(0);
658         uint256 private _tTotal = 1000000000000 * 10**9;
659         uint256 private _rTotal = (MAX - (MAX % _tTotal));
660         uint256 private _tFeeTotal;
661 
662         string private _name = 'Floki Pup';
663         string private _symbol = 'FLOKIPUP';
664         uint8 private _decimals = 9;
665         
666         // Tax and team fees will start at 0 so we don't have a big impact when deploying to Uniswap
667         // Team wallet address is null but the method to set the address is exposed
668         uint256 private _taxFee = 10; 
669         uint256 private _teamFee = 10;
670         uint256 private _previousTaxFee = _taxFee;
671         uint256 private _previousTeamFee = _teamFee;
672 
673         address payable public _teamWalletAddress;
674         address payable public _developerWalletAddress;
675         
676         IUniswapV2Router02 public immutable uniswapV2Router;
677         address public immutable uniswapV2Pair;
678 
679         bool inSwap = false;
680         bool public swapEnabled = true;
681 
682         uint256 private _maxTxAmount = 100000000000000e9;
683         // We will set a minimum amount of tokens to be swaped => 5M
684         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
685 
686         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
687         event SwapEnabledUpdated(bool enabled);
688 
689         modifier lockTheSwap {
690             inSwap = true;
691             _;
692             inSwap = false;
693         }
694 
695         constructor (address payable teamWalletAddress, address payable developerWalletAddress) public {
696             _teamWalletAddress = teamWalletAddress;
697             _developerWalletAddress = developerWalletAddress;
698             _rOwned[_msgSender()] = _rTotal;
699 
700             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
701             // Create a uniswap pair for this new token
702             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
703                 .createPair(address(this), _uniswapV2Router.WETH());
704 
705             // set the rest of the contract variables
706             uniswapV2Router = _uniswapV2Router;
707 
708             // Exclude owner and this contract from fee
709             _isExcludedFromFee[owner()] = true;
710             _isExcludedFromFee[address(this)] = true;
711 
712             emit Transfer(address(0), _msgSender(), _tTotal);
713         }
714 
715         function name() public view returns (string memory) {
716             return _name;
717         }
718 
719         function symbol() public view returns (string memory) {
720             return _symbol;
721         }
722 
723         function decimals() public view returns (uint8) {
724             return _decimals;
725         }
726 
727         function totalSupply() public view override returns (uint256) {
728             return _tTotal;
729         }
730 
731         function balanceOf(address account) public view override returns (uint256) {
732             if (_isExcluded[account]) return _tOwned[account];
733             return tokenFromReflection(_rOwned[account]);
734         }
735 
736         function transfer(address recipient, uint256 amount) public override returns (bool) {
737             _transfer(_msgSender(), recipient, amount);
738             return true;
739         }
740 
741         function allowance(address owner, address spender) public view override returns (uint256) {
742             return _allowances[owner][spender];
743         }
744 
745         function approve(address spender, uint256 amount) public override returns (bool) {
746             _approve(_msgSender(), spender, amount);
747             return true;
748         }
749 
750         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
751             _transfer(sender, recipient, amount);
752             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
753             return true;
754         }
755 
756         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
757             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
758             return true;
759         }
760 
761         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
762             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
763             return true;
764         }
765 
766         function isExcluded(address account) public view returns (bool) {
767             return _isExcluded[account];
768         }
769 
770         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
771             _isExcludedFromFee[account] = excluded;
772         }
773 
774         function totalFees() public view returns (uint256) {
775             return _tFeeTotal;
776         }
777 
778         function deliver(uint256 tAmount) public {
779             address sender = _msgSender();
780             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
781             (uint256 rAmount,,,,,) = _getValues(tAmount);
782             _rOwned[sender] = _rOwned[sender].sub(rAmount);
783             _rTotal = _rTotal.sub(rAmount);
784             _tFeeTotal = _tFeeTotal.add(tAmount);
785         }
786 
787         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
788             require(tAmount <= _tTotal, "Amount must be less than supply");
789             if (!deductTransferFee) {
790                 (uint256 rAmount,,,,,) = _getValues(tAmount);
791                 return rAmount;
792             } else {
793                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
794                 return rTransferAmount;
795             }
796         }
797 
798         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
799             require(rAmount <= _rTotal, "Amount must be less than total reflections");
800             uint256 currentRate =  _getRate();
801             return rAmount.div(currentRate);
802         }
803 
804         function excludeAccount(address account) external onlyOwner() {
805             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
806             require(!_isExcluded[account], "Account is already excluded");
807             if(_rOwned[account] > 0) {
808                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
809             }
810             _isExcluded[account] = true;
811             _excluded.push(account);
812         }
813 
814         function includeAccount(address account) external onlyOwner() {
815             require(_isExcluded[account], "Account is already excluded");
816             for (uint256 i = 0; i < _excluded.length; i++) {
817                 if (_excluded[i] == account) {
818                     _excluded[i] = _excluded[_excluded.length - 1];
819                     _tOwned[account] = 0;
820                     _isExcluded[account] = false;
821                     _excluded.pop();
822                     break;
823                 }
824             }
825         }
826 
827         function removeAllFee() private {
828             if(_taxFee == 0 && _teamFee == 0) return;
829             
830             _previousTaxFee = _taxFee;
831             _previousTeamFee = _teamFee;
832             
833             _taxFee = 0;
834             _teamFee = 0;
835         }
836     
837         function restoreAllFee() private {
838             _taxFee = _previousTaxFee;
839             _teamFee = _previousTeamFee;
840         }
841     
842         function isExcludedFromFee(address account) public view returns(bool) {
843             return _isExcludedFromFee[account];
844         }
845 
846         function _approve(address owner, address spender, uint256 amount) private {
847             require(owner != address(0), "ERC20: approve from the zero address");
848             require(spender != address(0), "ERC20: approve to the zero address");
849 
850             _allowances[owner][spender] = amount;
851             emit Approval(owner, spender, amount);
852         }
853 
854         function _transfer(address sender, address recipient, uint256 amount) private {
855             require(sender != address(0), "ERC20: transfer from the zero address");
856             require(recipient != address(0), "ERC20: transfer to the zero address");
857             require(amount > 0, "Transfer amount must be greater than zero");
858             
859             if(sender != owner() && recipient != owner())
860                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
861 
862             // is the token balance of this contract address over the min number of
863             // tokens that we need to initiate a swap?
864             // also, don't get caught in a circular team event.
865             // also, don't swap if sender is uniswap pair.
866             uint256 contractTokenBalance = balanceOf(address(this));
867             
868             if(contractTokenBalance >= _maxTxAmount)
869             {
870                 contractTokenBalance = _maxTxAmount;
871             }
872             
873             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
874             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
875                 // We need to swap the current tokens to ETH and send to the team wallet
876                 swapTokensForEth(contractTokenBalance);
877                 
878                 uint256 contractETHBalance = address(this).balance;
879                 if(contractETHBalance > 0) {
880                     sendETHToTeam(address(this).balance);
881                 }
882             }
883             
884             //indicates if fee should be deducted from transfer
885             bool takeFee = true;
886             
887             //if any account belongs to _isExcludedFromFee account then remove the fee
888             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
889                 takeFee = false;
890             }
891             
892             //transfer amount, it will take tax and team fee
893             _tokenTransfer(sender,recipient,amount,takeFee);
894         }
895 
896         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
897             // generate the uniswap pair path of token -> weth
898             address[] memory path = new address[](2);
899             path[0] = address(this);
900             path[1] = uniswapV2Router.WETH();
901 
902             _approve(address(this), address(uniswapV2Router), tokenAmount);
903 
904             // make the swap
905             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
906                 tokenAmount,
907                 0, // accept any amount of ETH
908                 path,
909                 address(this),
910                 block.timestamp
911             );
912         }
913         
914         function sendETHToTeam(uint256 amount) private {
915             _teamWalletAddress.transfer(amount.div(2));
916             _developerWalletAddress.transfer(amount.div(2));
917         }
918         
919         // We are exposing these functions to be able to manual swap and send
920         // in case the token is highly valued and 5M becomes too much
921         function manualSwap() external onlyOwner() {
922             uint256 contractBalance = balanceOf(address(this));
923             swapTokensForEth(contractBalance);
924         }
925         
926         function manualSend() external onlyOwner() {
927             uint256 contractETHBalance = address(this).balance;
928             sendETHToTeam(contractETHBalance);
929         }
930 
931         function setSwapEnabled(bool enabled) external onlyOwner(){
932             swapEnabled = enabled;
933         }
934         
935         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
936             if(!takeFee)
937                 removeAllFee();
938 
939             if (_isExcluded[sender] && !_isExcluded[recipient]) {
940                 _transferFromExcluded(sender, recipient, amount);
941             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
942                 _transferToExcluded(sender, recipient, amount);
943             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
944                 _transferStandard(sender, recipient, amount);
945             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
946                 _transferBothExcluded(sender, recipient, amount);
947             } else {
948                 _transferStandard(sender, recipient, amount);
949             }
950 
951             if(!takeFee)
952                 restoreAllFee();
953         }
954 
955         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
956             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
957             _rOwned[sender] = _rOwned[sender].sub(rAmount);
958             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
959             _takeTeam(tTeam); 
960             _reflectFee(rFee, tFee);
961             emit Transfer(sender, recipient, tTransferAmount);
962         }
963 
964         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
965             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
966             _rOwned[sender] = _rOwned[sender].sub(rAmount);
967             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
968             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
969             _takeTeam(tTeam);           
970             _reflectFee(rFee, tFee);
971             emit Transfer(sender, recipient, tTransferAmount);
972         }
973 
974         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
975             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
976             _tOwned[sender] = _tOwned[sender].sub(tAmount);
977             _rOwned[sender] = _rOwned[sender].sub(rAmount);
978             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
979             _takeTeam(tTeam);   
980             _reflectFee(rFee, tFee);
981             emit Transfer(sender, recipient, tTransferAmount);
982         }
983 
984         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
985             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
986             _tOwned[sender] = _tOwned[sender].sub(tAmount);
987             _rOwned[sender] = _rOwned[sender].sub(rAmount);
988             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
989             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
990             _takeTeam(tTeam);         
991             _reflectFee(rFee, tFee);
992             emit Transfer(sender, recipient, tTransferAmount);
993         }
994 
995         function _takeTeam(uint256 tTeam) private {
996             uint256 currentRate =  _getRate();
997             uint256 rTeam = tTeam.mul(currentRate);
998             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
999             if(_isExcluded[address(this)])
1000                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1001         }
1002 
1003         function _reflectFee(uint256 rFee, uint256 tFee) private {
1004             _rTotal = _rTotal.sub(rFee);
1005             _tFeeTotal = _tFeeTotal.add(tFee);
1006         }
1007 
1008          //to recieve ETH from uniswapV2Router when swaping
1009         receive() external payable {}
1010 
1011         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1012             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1013             uint256 currentRate =  _getRate();
1014             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1015             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1016         }
1017 
1018         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1019             uint256 tFee = tAmount.mul(taxFee).div(100);
1020             uint256 tTeam = tAmount.mul(teamFee).div(100);
1021             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1022             return (tTransferAmount, tFee, tTeam);
1023         }
1024 
1025         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1026             uint256 rAmount = tAmount.mul(currentRate);
1027             uint256 rFee = tFee.mul(currentRate);
1028             uint256 rTransferAmount = rAmount.sub(rFee);
1029             return (rAmount, rTransferAmount, rFee);
1030         }
1031 
1032         function _getRate() private view returns(uint256) {
1033             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1034             return rSupply.div(tSupply);
1035         }
1036 
1037         function _getCurrentSupply() private view returns(uint256, uint256) {
1038             uint256 rSupply = _rTotal;
1039             uint256 tSupply = _tTotal;      
1040             for (uint256 i = 0; i < _excluded.length; i++) {
1041                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1042                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1043                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1044             }
1045             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1046             return (rSupply, tSupply);
1047         }
1048         
1049         function _getTaxFee() private view returns(uint256) {
1050             return _taxFee;
1051         }
1052 
1053         function _getMaxTxAmount() private view returns(uint256) {
1054             return _maxTxAmount;
1055         }
1056 
1057         function _getETHBalance() public view returns(uint256 balance) {
1058             return address(this).balance;
1059         }
1060         
1061         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1062             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1063             _taxFee = taxFee;
1064         }
1065 
1066         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1067             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1068             _teamFee = teamFee;
1069         }
1070         
1071         function _setTeamWallet(address payable teamWalletAddress) external onlyOwner() {
1072             _teamWalletAddress = teamWalletAddress;
1073         }
1074         
1075         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1076             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1077             _maxTxAmount = maxTxAmount;
1078         }
1079     }