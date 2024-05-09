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
417         function geUnlockTime() public view returns (uint256) {
418             return _lockTime;
419         }
420 
421         //Locks the contract for owner for the amount of time provided
422         function lock(uint256 time) public virtual onlyOwner {
423             _previousOwner = _owner;
424             _owner = address(0);
425             _lockTime = now + time;
426             emit OwnershipTransferred(_owner, address(0));
427         }
428         
429         //Unlocks the contract for owner when _lockTime is exceeds
430         function unlock() public virtual {
431             require(_previousOwner == msg.sender, "You don't have permission to unlock");
432             require(now > _lockTime , "Contract is locked until 7 days");
433             emit OwnershipTransferred(_owner, _previousOwner);
434             _owner = _previousOwner;
435         }
436     }  
437 
438     interface IUniswapV2Factory {
439         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
440 
441         function feeTo() external view returns (address);
442         function feeToSetter() external view returns (address);
443 
444         function getPair(address tokenA, address tokenB) external view returns (address pair);
445         function allPairs(uint) external view returns (address pair);
446         function allPairsLength() external view returns (uint);
447 
448         function createPair(address tokenA, address tokenB) external returns (address pair);
449 
450         function setFeeTo(address) external;
451         function setFeeToSetter(address) external;
452     } 
453 
454     interface IUniswapV2Pair {
455         event Approval(address indexed owner, address indexed spender, uint value);
456         event Transfer(address indexed from, address indexed to, uint value);
457 
458         function name() external pure returns (string memory);
459         function symbol() external pure returns (string memory);
460         function decimals() external pure returns (uint8);
461         function totalSupply() external view returns (uint);
462         function balanceOf(address owner) external view returns (uint);
463         function allowance(address owner, address spender) external view returns (uint);
464 
465         function approve(address spender, uint value) external returns (bool);
466         function transfer(address to, uint value) external returns (bool);
467         function transferFrom(address from, address to, uint value) external returns (bool);
468 
469         function DOMAIN_SEPARATOR() external view returns (bytes32);
470         function PERMIT_TYPEHASH() external pure returns (bytes32);
471         function nonces(address owner) external view returns (uint);
472 
473         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
474 
475         event Mint(address indexed sender, uint amount0, uint amount1);
476         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
477         event Swap(
478             address indexed sender,
479             uint amount0In,
480             uint amount1In,
481             uint amount0Out,
482             uint amount1Out,
483             address indexed to
484         );
485         event Sync(uint112 reserve0, uint112 reserve1);
486 
487         function MINIMUM_LIQUIDITY() external pure returns (uint);
488         function factory() external view returns (address);
489         function token0() external view returns (address);
490         function token1() external view returns (address);
491         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
492         function price0CumulativeLast() external view returns (uint);
493         function price1CumulativeLast() external view returns (uint);
494         function kLast() external view returns (uint);
495 
496         function mint(address to) external returns (uint liquidity);
497         function burn(address to) external returns (uint amount0, uint amount1);
498         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
499         function skim(address to) external;
500         function sync() external;
501 
502         function initialize(address, address) external;
503     }
504 
505     interface IUniswapV2Router01 {
506         function factory() external pure returns (address);
507         function WETH() external pure returns (address);
508 
509         function addLiquidity(
510             address tokenA,
511             address tokenB,
512             uint amountADesired,
513             uint amountBDesired,
514             uint amountAMin,
515             uint amountBMin,
516             address to,
517             uint deadline
518         ) external returns (uint amountA, uint amountB, uint liquidity);
519         function addLiquidityETH(
520             address token,
521             uint amountTokenDesired,
522             uint amountTokenMin,
523             uint amountETHMin,
524             address to,
525             uint deadline
526         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
527         function removeLiquidity(
528             address tokenA,
529             address tokenB,
530             uint liquidity,
531             uint amountAMin,
532             uint amountBMin,
533             address to,
534             uint deadline
535         ) external returns (uint amountA, uint amountB);
536         function removeLiquidityETH(
537             address token,
538             uint liquidity,
539             uint amountTokenMin,
540             uint amountETHMin,
541             address to,
542             uint deadline
543         ) external returns (uint amountToken, uint amountETH);
544         function removeLiquidityWithPermit(
545             address tokenA,
546             address tokenB,
547             uint liquidity,
548             uint amountAMin,
549             uint amountBMin,
550             address to,
551             uint deadline,
552             bool approveMax, uint8 v, bytes32 r, bytes32 s
553         ) external returns (uint amountA, uint amountB);
554         function removeLiquidityETHWithPermit(
555             address token,
556             uint liquidity,
557             uint amountTokenMin,
558             uint amountETHMin,
559             address to,
560             uint deadline,
561             bool approveMax, uint8 v, bytes32 r, bytes32 s
562         ) external returns (uint amountToken, uint amountETH);
563         function swapExactTokensForTokens(
564             uint amountIn,
565             uint amountOutMin,
566             address[] calldata path,
567             address to,
568             uint deadline
569         ) external returns (uint[] memory amounts);
570         function swapTokensForExactTokens(
571             uint amountOut,
572             uint amountInMax,
573             address[] calldata path,
574             address to,
575             uint deadline
576         ) external returns (uint[] memory amounts);
577         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
578             external
579             payable
580             returns (uint[] memory amounts);
581         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
582             external
583             returns (uint[] memory amounts);
584         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
585             external
586             returns (uint[] memory amounts);
587         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
588             external
589             payable
590             returns (uint[] memory amounts);
591 
592         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
593         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
594         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
595         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
596         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
597     }
598 
599     interface IUniswapV2Router02 is IUniswapV2Router01 {
600         function removeLiquidityETHSupportingFeeOnTransferTokens(
601             address token,
602             uint liquidity,
603             uint amountTokenMin,
604             uint amountETHMin,
605             address to,
606             uint deadline
607         ) external returns (uint amountETH);
608         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
609             address token,
610             uint liquidity,
611             uint amountTokenMin,
612             uint amountETHMin,
613             address to,
614             uint deadline,
615             bool approveMax, uint8 v, bytes32 r, bytes32 s
616         ) external returns (uint amountETH);
617 
618         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
619             uint amountIn,
620             uint amountOutMin,
621             address[] calldata path,
622             address to,
623             uint deadline
624         ) external;
625         function swapExactETHForTokensSupportingFeeOnTransferTokens(
626             uint amountOutMin,
627             address[] calldata path,
628             address to,
629             uint deadline
630         ) external payable;
631         function swapExactTokensForETHSupportingFeeOnTransferTokens(
632             uint amountIn,
633             uint amountOutMin,
634             address[] calldata path,
635             address to,
636             uint deadline
637         ) external;
638     }
639 
640     // Contract implementation
641     contract BlackKishu is Context, IERC20, Ownable {
642         using SafeMath for uint256;
643         using Address for address;
644 
645         mapping (address => uint256) private _rOwned;
646         mapping (address => uint256) private _tOwned;
647         mapping (address => mapping (address => uint256)) private _allowances;
648 
649         mapping (address => bool) private _isExcludedFromFee;
650 
651         mapping (address => bool) private _isExcluded;
652         address[] private _excluded;
653     
654         uint256 private constant MAX = ~uint256(0);
655         uint256 private _tTotal = 1000000000000 * 10**9;
656         uint256 private _rTotal = (MAX - (MAX % _tTotal));
657         uint256 private _tFeeTotal;
658 
659         string private _name = 'Black Kishu Inu';
660         string private _symbol = 'BISHU';
661         uint8 private _decimals = 9;
662         
663         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
664         // Charity wallet address is null but the method to set the address is exposed
665         uint256 private _taxFee = 2; 
666         uint256 private _charityFee = 1;
667         uint256 private _previousTaxFee = _taxFee;
668         uint256 private _previousCharityFee = _charityFee;
669 
670         address payable public _charityWalletAddress;
671         address payable public _marketingWalletAddress;
672         
673         IUniswapV2Router02 public immutable uniswapV2Router;
674         address public immutable uniswapV2Pair;
675 
676         bool inSwap = false;
677         bool public swapEnabled = true;
678 
679         uint256 private _maxTxAmount = 100000000000000 * 10**9;
680         // We will set a minimum amount of tokens to be swaped => 5M
681         uint256 private _numOfTokensToExchangeForCharity = 5 * 10**3 * 10**9;
682 
683         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
684         event SwapEnabledUpdated(bool enabled);
685 
686         modifier lockTheSwap {
687             inSwap = true;
688             _;
689             inSwap = false;
690         }
691 
692         constructor (address payable charityWalletAddress, address payable marketingWalletAddress) public {
693             _charityWalletAddress = charityWalletAddress;
694             _marketingWalletAddress = marketingWalletAddress;
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
912             _charityWalletAddress.transfer(amount.div(2));
913             _marketingWalletAddress.transfer(amount.div(2));
914         }
915         
916         // We are exposing these functions to be able to manual swap and send
917         // in case the token is highly valued and 5M becomes too much
918         function manualSwap() external onlyOwner() {
919             uint256 contractBalance = balanceOf(address(this));
920             swapTokensForEth(contractBalance);
921         }
922         
923         function manualSend() external onlyOwner() {
924             uint256 contractETHBalance = address(this).balance;
925             sendETHToCharity(contractETHBalance);
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
953             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
954             _rOwned[sender] = _rOwned[sender].sub(rAmount);
955             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
956             _takeCharity(tCharity); 
957             _reflectFee(rFee, tFee);
958             emit Transfer(sender, recipient, tTransferAmount);
959         }
960 
961         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
962             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
963             _rOwned[sender] = _rOwned[sender].sub(rAmount);
964             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
965             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
966             _takeCharity(tCharity);           
967             _reflectFee(rFee, tFee);
968             emit Transfer(sender, recipient, tTransferAmount);
969         }
970 
971         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
972             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
973             _tOwned[sender] = _tOwned[sender].sub(tAmount);
974             _rOwned[sender] = _rOwned[sender].sub(rAmount);
975             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
976             _takeCharity(tCharity);   
977             _reflectFee(rFee, tFee);
978             emit Transfer(sender, recipient, tTransferAmount);
979         }
980 
981         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
982             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
983             _tOwned[sender] = _tOwned[sender].sub(tAmount);
984             _rOwned[sender] = _rOwned[sender].sub(rAmount);
985             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
986             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
987             _takeCharity(tCharity);         
988             _reflectFee(rFee, tFee);
989             emit Transfer(sender, recipient, tTransferAmount);
990         }
991 
992         function _takeCharity(uint256 tCharity) private {
993             uint256 currentRate =  _getRate();
994             uint256 rCharity = tCharity.mul(currentRate);
995             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
996             if(_isExcluded[address(this)])
997                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
998         }
999 
1000         function _reflectFee(uint256 rFee, uint256 tFee) private {
1001             _rTotal = _rTotal.sub(rFee);
1002             _tFeeTotal = _tFeeTotal.add(tFee);
1003         }
1004 
1005          //to recieve ETH from uniswapV2Router when swaping
1006         receive() external payable {}
1007 
1008         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1009             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1010             uint256 currentRate =  _getRate();
1011             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1012             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1013         }
1014 
1015         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1016             uint256 tFee = tAmount.mul(taxFee).div(100);
1017             uint256 tCharity = tAmount.mul(charityFee).div(100);
1018             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1019             return (tTransferAmount, tFee, tCharity);
1020         }
1021 
1022         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1023             uint256 rAmount = tAmount.mul(currentRate);
1024             uint256 rFee = tFee.mul(currentRate);
1025             uint256 rTransferAmount = rAmount.sub(rFee);
1026             return (rAmount, rTransferAmount, rFee);
1027         }
1028 
1029         function _getRate() private view returns(uint256) {
1030             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1031             return rSupply.div(tSupply);
1032         }
1033 
1034         function _getCurrentSupply() private view returns(uint256, uint256) {
1035             uint256 rSupply = _rTotal;
1036             uint256 tSupply = _tTotal;      
1037             for (uint256 i = 0; i < _excluded.length; i++) {
1038                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1039                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1040                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1041             }
1042             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1043             return (rSupply, tSupply);
1044         }
1045         
1046         function _getTaxFee() private view returns(uint256) {
1047             return _taxFee;
1048         }
1049 
1050         function _getMaxTxAmount() private view returns(uint256) {
1051             return _maxTxAmount;
1052         }
1053 
1054         function _getETHBalance() public view returns(uint256 balance) {
1055             return address(this).balance;
1056         }
1057         
1058         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1059             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1060             _taxFee = taxFee;
1061         }
1062 
1063         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1064             require(charityFee >= 1 && charityFee <= 11, 'charityFee should be in 1 - 11');
1065             _charityFee = charityFee;
1066         }
1067         
1068         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1069             _charityWalletAddress = charityWalletAddress;
1070         }
1071         
1072         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1073             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1074             _maxTxAmount = maxTxAmount;
1075         }
1076     }