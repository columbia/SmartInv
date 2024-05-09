1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 
5 
6     abstract contract Context {
7         function _msgSender() internal view virtual returns (address payable) {
8             return msg.sender;
9         }
10 
11         function _msgData() internal view virtual returns (bytes memory) {
12             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13             return msg.data;
14         }
15     }
16 
17     interface IERC20 {
18         /**
19         * @dev Returns the amount of tokens in existence.
20         */
21         function totalSupply() external view returns (uint256);
22 
23         /**
24         * @dev Returns the amount of tokens owned by `account`.
25         */
26         function balanceOf(address account) external view returns (uint256);
27 
28         /**
29         * @dev Moves `amount` tokens from the caller's account to `recipient`.
30         *
31         * Returns a boolean value indicating whether the operation succeeded.
32         *
33         * Emits a {Transfer} event.
34         */
35         function transfer(address recipient, uint256 amount) external returns (bool);
36 
37         /**
38         * @dev Returns the remaining number of tokens that `spender` will be
39         * allowed to spend on behalf of `owner` through {transferFrom}. This is
40         * zero by default.
41         *
42         * This value changes when {approve} or {transferFrom} are called.
43         */
44         function allowance(address owner, address spender) external view returns (uint256);
45 
46         /**
47         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48         *
49         * Returns a boolean value indicating whether the operation succeeded.
50         *
51         * IMPORTANT: Beware that changing an allowance with this method brings the risk
52         * that someone may use both the old and the new allowance by unfortunate
53         * transaction ordering. One possible solution to mitigate this race
54         * condition is to first reduce the spender's allowance to 0 and set the
55         * desired value afterwards:
56         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57         *
58         * Emits an {Approval} event.
59         */
60         function approve(address spender, uint256 amount) external returns (bool);
61 
62         /**
63         * @dev Moves `amount` tokens from `sender` to `recipient` using the
64         * allowance mechanism. `amount` is then deducted from the caller's
65         * allowance.
66         *
67         * Returns a boolean value indicating whether the operation succeeded.
68         *
69         * Emits a {Transfer} event.
70         */
71         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73         /**
74         * @dev Emitted when `value` tokens are moved from one account (`from`) to
75         * another (`to`).
76         *
77         * Note that `value` may be zero.
78         */
79         event Transfer(address indexed from, address indexed to, uint256 value);
80 
81         /**
82         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83         * a call to {approve}. `value` is the new allowance.
84         */
85         event Approval(address indexed owner, address indexed spender, uint256 value);
86     }
87 
88     library SafeMath {
89         /**
90         * @dev Returns the addition of two unsigned integers, reverting on
91         * overflow.
92         *
93         * Counterpart to Solidity's `+` operator.
94         *
95         * Requirements:
96         *
97         * - Addition cannot overflow.
98         */
99         function add(uint256 a, uint256 b) internal pure returns (uint256) {
100             uint256 c = a + b;
101             require(c >= a, "SafeMath: addition overflow");
102 
103             return c;
104         }
105 
106         /**
107         * @dev Returns the subtraction of two unsigned integers, reverting on
108         * overflow (when the result is negative).
109         *
110         * Counterpart to Solidity's `-` operator.
111         *
112         * Requirements:
113         *
114         * - Subtraction cannot overflow.
115         */
116         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117             return sub(a, b, "SafeMath: subtraction overflow");
118         }
119 
120         /**
121         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122         * overflow (when the result is negative).
123         *
124         * Counterpart to Solidity's `-` operator.
125         *
126         * Requirements:
127         *
128         * - Subtraction cannot overflow.
129         */
130         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131             require(b <= a, errorMessage);
132             uint256 c = a - b;
133 
134             return c;
135         }
136 
137         /**
138         * @dev Returns the multiplication of two unsigned integers, reverting on
139         * overflow.
140         *
141         * Counterpart to Solidity's `*` operator.
142         *
143         * Requirements:
144         *
145         * - Multiplication cannot overflow.
146         */
147         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149             // benefit is lost if 'b' is also tested.
150             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151             if (a == 0) {
152                 return 0;
153             }
154 
155             uint256 c = a * b;
156             require(c / a == b, "SafeMath: multiplication overflow");
157 
158             return c;
159         }
160 
161         /**
162         * @dev Returns the integer division of two unsigned integers. Reverts on
163         * division by zero. The result is rounded towards zero.
164         *
165         * Counterpart to Solidity's `/` operator. Note: this function uses a
166         * `revert` opcode (which leaves remaining gas untouched) while Solidity
167         * uses an invalid opcode to revert (consuming all remaining gas).
168         *
169         * Requirements:
170         *
171         * - The divisor cannot be zero.
172         */
173         function div(uint256 a, uint256 b) internal pure returns (uint256) {
174             return div(a, b, "SafeMath: division by zero");
175         }
176 
177         /**
178         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
179         * division by zero. The result is rounded towards zero.
180         *
181         * Counterpart to Solidity's `/` operator. Note: this function uses a
182         * `revert` opcode (which leaves remaining gas untouched) while Solidity
183         * uses an invalid opcode to revert (consuming all remaining gas).
184         *
185         * Requirements:
186         *
187         * - The divisor cannot be zero.
188         */
189         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190             require(b > 0, errorMessage);
191             uint256 c = a / b;
192             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194             return c;
195         }
196 
197         /**
198         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199         * Reverts when dividing by zero.
200         *
201         * Counterpart to Solidity's `%` operator. This function uses a `revert`
202         * opcode (which leaves remaining gas untouched) while Solidity uses an
203         * invalid opcode to revert (consuming all remaining gas).
204         *
205         * Requirements:
206         *
207         * - The divisor cannot be zero.
208         */
209         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210             return mod(a, b, "SafeMath: modulo by zero");
211         }
212 
213         /**
214         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215         * Reverts with custom message when dividing by zero.
216         *
217         * Counterpart to Solidity's `%` operator. This function uses a `revert`
218         * opcode (which leaves remaining gas untouched) while Solidity uses an
219         * invalid opcode to revert (consuming all remaining gas).
220         *
221         * Requirements:
222         *
223         * - The divisor cannot be zero.
224         */
225         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226             require(b != 0, errorMessage);
227             return a % b;
228         }
229     }
230 
231     library Address {
232         /**
233         * @dev Returns true if `account` is a contract.
234         *
235         * [IMPORTANT]
236         * ====
237         * It is unsafe to assume that an address for which this function returns
238         * false is an externally-owned account (EOA) and not a contract.
239         *
240         * Among others, `isContract` will return false for the following
241         * types of addresses:
242         *
243         *  - an externally-owned account
244         *  - a contract in construction
245         *  - an address where a contract will be created
246         *  - an address where a contract lived, but was destroyed
247         * ====
248         */
249         function isContract(address account) internal view returns (bool) {
250             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
251             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
252             // for accounts without code, i.e. `keccak256('')`
253             bytes32 codehash;
254             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
255             // solhint-disable-next-line no-inline-assembly
256             assembly { codehash := extcodehash(account) }
257             return (codehash != accountHash && codehash != 0x0);
258         }
259 
260         /**
261         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262         * `recipient`, forwarding all available gas and reverting on errors.
263         *
264         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265         * of certain opcodes, possibly making contracts go over the 2300 gas limit
266         * imposed by `transfer`, making them unable to receive funds via
267         * `transfer`. {sendValue} removes this limitation.
268         *
269         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270         *
271         * IMPORTANT: because control is transferred to `recipient`, care must be
272         * taken to not create reentrancy vulnerabilities. Consider using
273         * {ReentrancyGuard} or the
274         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275         */
276         function sendValue(address payable recipient, uint256 amount) internal {
277             require(address(this).balance >= amount, "Address: insufficient balance");
278 
279             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
280             (bool success, ) = recipient.call{ value: amount }("");
281             require(success, "Address: unable to send value, recipient may have reverted");
282         }
283 
284         /**
285         * @dev Performs a Solidity function call using a low level `call`. A
286         * plain`call` is an unsafe replacement for a function call: use this
287         * function instead.
288         *
289         * If `target` reverts with a revert reason, it is bubbled up by this
290         * function (like regular Solidity function calls).
291         *
292         * Returns the raw returned data. To convert to the expected return value,
293         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294         *
295         * Requirements:
296         *
297         * - `target` must be a contract.
298         * - calling `target` with `data` must not revert.
299         *
300         * _Available since v3.1._
301         */
302         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionCall(target, data, "Address: low-level call failed");
304         }
305 
306         /**
307         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308         * `errorMessage` as a fallback revert reason when `target` reverts.
309         *
310         * _Available since v3.1._
311         */
312         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
313             return _functionCallWithValue(target, data, 0, errorMessage);
314         }
315 
316         /**
317         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318         * but also transferring `value` wei to `target`.
319         *
320         * Requirements:
321         *
322         * - the calling contract must have an ETH balance of at least `value`.
323         * - the called Solidity function must be `payable`.
324         *
325         * _Available since v3.1._
326         */
327         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
328             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329         }
330 
331         /**
332         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333         * with `errorMessage` as a fallback revert reason when `target` reverts.
334         *
335         * _Available since v3.1._
336         */
337         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
338             require(address(this).balance >= value, "Address: insufficient balance for call");
339             return _functionCallWithValue(target, data, value, errorMessage);
340         }
341 
342         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
343             require(isContract(target), "Address: call to non-contract");
344 
345             // solhint-disable-next-line avoid-low-level-calls
346             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
347             if (success) {
348                 return returndata;
349             } else {
350                 // Look for revert reason and bubble it up if present
351                 if (returndata.length > 0) {
352                     // The easiest way to bubble the revert reason is using memory via assembly
353 
354                     // solhint-disable-next-line no-inline-assembly
355                     assembly {
356                         let returndata_size := mload(returndata)
357                         revert(add(32, returndata), returndata_size)
358                     }
359                 } else {
360                     revert(errorMessage);
361                 }
362             }
363         }
364     }
365 
366     contract Ownable is Context {
367         address private _owner;
368         address private _previousOwner;
369         uint256 private _lockTime;
370 
371         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
372 
373         /**
374         * @dev Initializes the contract setting the deployer as the initial owner.
375         */
376         constructor () internal {
377             address msgSender = _msgSender();
378             _owner = msgSender;
379             emit OwnershipTransferred(address(0), msgSender);
380         }
381 
382         /**
383         * @dev Returns the address of the current owner.
384         */
385         function owner() public view returns (address) {
386             return _owner;
387         }
388 
389         /**
390         * @dev Throws if called by any account other than the owner.
391         */
392         modifier onlyOwner() {
393             require(_owner == _msgSender(), "Ownable: caller is not the owner");
394             _;
395         }
396 
397         /**
398         * @dev Leaves the contract without owner. It will not be possible to call
399         * `onlyOwner` functions anymore. Can only be called by the current owner.
400         *
401         * NOTE: Renouncing ownership will leave the contract without an owner,
402         * thereby removing any functionality that is only available to the owner.
403         */
404         function renounceOwnership() public virtual onlyOwner {
405             emit OwnershipTransferred(_owner, address(0));
406             _owner = address(0);
407         }
408 
409         /**
410         * @dev Transfers ownership of the contract to a new account (`newOwner`).
411         * Can only be called by the current owner.
412         */
413         function transferOwnership(address newOwner) public virtual onlyOwner {
414             require(newOwner != address(0), "Ownable: new owner is the zero address");
415             emit OwnershipTransferred(_owner, newOwner);
416             _owner = newOwner;
417         }
418 
419         function geUnlockTime() public view returns (uint256) {
420             return _lockTime;
421         }
422 
423         //Locks the contract for owner for the amount of time provided
424         function lock(uint256 time) public virtual onlyOwner {
425             _previousOwner = _owner;
426             _owner = address(0);
427             _lockTime = now + time;
428             emit OwnershipTransferred(_owner, address(0));
429         }
430         
431         //Unlocks the contract for owner when _lockTime is exceeds
432         function unlock() public virtual {
433             require(_previousOwner == msg.sender, "You don't have permission to unlock");
434             require(now > _lockTime , "Contract is locked until 7 days");
435             emit OwnershipTransferred(_owner, _previousOwner);
436             _owner = _previousOwner;
437         }
438     }  
439 
440     interface IUniswapV2Factory {
441         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
442 
443         function feeTo() external view returns (address);
444         function feeToSetter() external view returns (address);
445 
446         function getPair(address tokenA, address tokenB) external view returns (address pair);
447         function allPairs(uint) external view returns (address pair);
448         function allPairsLength() external view returns (uint);
449 
450         function createPair(address tokenA, address tokenB) external returns (address pair);
451 
452         function setFeeTo(address) external;
453         function setFeeToSetter(address) external;
454     } 
455 
456     interface IUniswapV2Pair {
457         event Approval(address indexed owner, address indexed spender, uint value);
458         event Transfer(address indexed from, address indexed to, uint value);
459 
460         function name() external pure returns (string memory);
461         function symbol() external pure returns (string memory);
462         function decimals() external pure returns (uint8);
463         function totalSupply() external view returns (uint);
464         function balanceOf(address owner) external view returns (uint);
465         function allowance(address owner, address spender) external view returns (uint);
466 
467         function approve(address spender, uint value) external returns (bool);
468         function transfer(address to, uint value) external returns (bool);
469         function transferFrom(address from, address to, uint value) external returns (bool);
470 
471         function DOMAIN_SEPARATOR() external view returns (bytes32);
472         function PERMIT_TYPEHASH() external pure returns (bytes32);
473         function nonces(address owner) external view returns (uint);
474 
475         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
476 
477         event Mint(address indexed sender, uint amount0, uint amount1);
478         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
479         event Swap(
480             address indexed sender,
481             uint amount0In,
482             uint amount1In,
483             uint amount0Out,
484             uint amount1Out,
485             address indexed to
486         );
487         event Sync(uint112 reserve0, uint112 reserve1);
488 
489         function MINIMUM_LIQUIDITY() external pure returns (uint);
490         function factory() external view returns (address);
491         function token0() external view returns (address);
492         function token1() external view returns (address);
493         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
494         function price0CumulativeLast() external view returns (uint);
495         function price1CumulativeLast() external view returns (uint);
496         function kLast() external view returns (uint);
497 
498         function mint(address to) external returns (uint liquidity);
499         function burn(address to) external returns (uint amount0, uint amount1);
500         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
501         function skim(address to) external;
502         function sync() external;
503 
504         function initialize(address, address) external;
505     }
506 
507     interface IUniswapV2Router01 {
508         function factory() external pure returns (address);
509         function WETH() external pure returns (address);
510 
511         function addLiquidity(
512             address tokenA,
513             address tokenB,
514             uint amountADesired,
515             uint amountBDesired,
516             uint amountAMin,
517             uint amountBMin,
518             address to,
519             uint deadline
520         ) external returns (uint amountA, uint amountB, uint liquidity);
521         function addLiquidityETH(
522             address token,
523             uint amountTokenDesired,
524             uint amountTokenMin,
525             uint amountETHMin,
526             address to,
527             uint deadline
528         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
529         function removeLiquidity(
530             address tokenA,
531             address tokenB,
532             uint liquidity,
533             uint amountAMin,
534             uint amountBMin,
535             address to,
536             uint deadline
537         ) external returns (uint amountA, uint amountB);
538         function removeLiquidityETH(
539             address token,
540             uint liquidity,
541             uint amountTokenMin,
542             uint amountETHMin,
543             address to,
544             uint deadline
545         ) external returns (uint amountToken, uint amountETH);
546         function removeLiquidityWithPermit(
547             address tokenA,
548             address tokenB,
549             uint liquidity,
550             uint amountAMin,
551             uint amountBMin,
552             address to,
553             uint deadline,
554             bool approveMax, uint8 v, bytes32 r, bytes32 s
555         ) external returns (uint amountA, uint amountB);
556         function removeLiquidityETHWithPermit(
557             address token,
558             uint liquidity,
559             uint amountTokenMin,
560             uint amountETHMin,
561             address to,
562             uint deadline,
563             bool approveMax, uint8 v, bytes32 r, bytes32 s
564         ) external returns (uint amountToken, uint amountETH);
565         function swapExactTokensForTokens(
566             uint amountIn,
567             uint amountOutMin,
568             address[] calldata path,
569             address to,
570             uint deadline
571         ) external returns (uint[] memory amounts);
572         function swapTokensForExactTokens(
573             uint amountOut,
574             uint amountInMax,
575             address[] calldata path,
576             address to,
577             uint deadline
578         ) external returns (uint[] memory amounts);
579         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
580             external
581             payable
582             returns (uint[] memory amounts);
583         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
584             external
585             returns (uint[] memory amounts);
586         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
587             external
588             returns (uint[] memory amounts);
589         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
590             external
591             payable
592             returns (uint[] memory amounts);
593 
594         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
595         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
596         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
597         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
598         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
599     }
600 
601     interface IUniswapV2Router02 is IUniswapV2Router01 {
602         function removeLiquidityETHSupportingFeeOnTransferTokens(
603             address token,
604             uint liquidity,
605             uint amountTokenMin,
606             uint amountETHMin,
607             address to,
608             uint deadline
609         ) external returns (uint amountETH);
610         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
611             address token,
612             uint liquidity,
613             uint amountTokenMin,
614             uint amountETHMin,
615             address to,
616             uint deadline,
617             bool approveMax, uint8 v, bytes32 r, bytes32 s
618         ) external returns (uint amountETH);
619 
620         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
621             uint amountIn,
622             uint amountOutMin,
623             address[] calldata path,
624             address to,
625             uint deadline
626         ) external;
627         function swapExactETHForTokensSupportingFeeOnTransferTokens(
628             uint amountOutMin,
629             address[] calldata path,
630             address to,
631             uint deadline
632         ) external payable;
633         function swapExactTokensForETHSupportingFeeOnTransferTokens(
634             uint amountIn,
635             uint amountOutMin,
636             address[] calldata path,
637             address to,
638             uint deadline
639         ) external;
640     }
641 
642     // Contract implementation
643     contract DarthDoge is Context, IERC20, Ownable {
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
657         uint256 private _tTotal = 10000000 * 10**9;
658         uint256 private _rTotal = (MAX - (MAX % _tTotal));
659         uint256 private _tFeeTotal;
660 
661         string private _name = 'Darth Doge';
662         string private _symbol = 'DDOGE';
663         uint8 private _decimals = 9;
664         
665         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
666         // Charity wallet address is null but the method to set the address is exposed
667         uint256 private _taxFee = 10; 
668         uint256 private _charityFee = 10;
669         uint256 private _previousTaxFee = _taxFee;
670         uint256 private _previousCharityFee = _charityFee;
671 
672         address payable public _charityWalletAddress;
673         address payable public _marketingWalletAddress;
674         
675         IUniswapV2Router02 public immutable uniswapV2Router;
676         address public immutable uniswapV2Pair;
677 
678         bool inSwap = false;
679         bool public swapEnabled = true;
680 
681         uint256 private _maxTxAmount = 100000000000000e9;
682         // We will set a minimum amount of tokens to be swaped => 5M
683         uint256 private _numOfTokensToExchangeForCharity = 5 * 10**3 * 10**9;
684 
685         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
686         event SwapEnabledUpdated(bool enabled);
687 
688         modifier lockTheSwap {
689             inSwap = true;
690             _;
691             inSwap = false;
692         }
693 
694         constructor (address payable charityWalletAddress, address payable marketingWalletAddress) public {
695             _charityWalletAddress = charityWalletAddress;
696             _marketingWalletAddress = marketingWalletAddress;
697             _rOwned[_msgSender()] = _rTotal;
698 
699             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
700             // Create a uniswap pair for this new token
701             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
702                 .createPair(address(this), _uniswapV2Router.WETH());
703 
704             // set the rest of the contract variables
705             uniswapV2Router = _uniswapV2Router;
706 
707             // Exclude owner and this contract from fee
708             _isExcludedFromFee[owner()] = true;
709             _isExcludedFromFee[address(this)] = true;
710 
711             emit Transfer(address(0), _msgSender(), _tTotal);
712         }
713 
714         function name() public view returns (string memory) {
715             return _name;
716         }
717 
718         function symbol() public view returns (string memory) {
719             return _symbol;
720         }
721 
722         function decimals() public view returns (uint8) {
723             return _decimals;
724         }
725 
726         function totalSupply() public view override returns (uint256) {
727             return _tTotal;
728         }
729 
730         function balanceOf(address account) public view override returns (uint256) {
731             if (_isExcluded[account]) return _tOwned[account];
732             return tokenFromReflection(_rOwned[account]);
733         }
734 
735         function transfer(address recipient, uint256 amount) public override returns (bool) {
736             _transfer(_msgSender(), recipient, amount);
737             return true;
738         }
739 
740         function allowance(address owner, address spender) public view override returns (uint256) {
741             return _allowances[owner][spender];
742         }
743 
744         function approve(address spender, uint256 amount) public override returns (bool) {
745             _approve(_msgSender(), spender, amount);
746             return true;
747         }
748 
749         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
750             _transfer(sender, recipient, amount);
751             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
752             return true;
753         }
754 
755         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
756             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
757             return true;
758         }
759 
760         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
761             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
762             return true;
763         }
764 
765         function isExcluded(address account) public view returns (bool) {
766             return _isExcluded[account];
767         }
768 
769         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
770             _isExcludedFromFee[account] = excluded;
771         }
772 
773         function totalFees() public view returns (uint256) {
774             return _tFeeTotal;
775         }
776 
777         function deliver(uint256 tAmount) public {
778             address sender = _msgSender();
779             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
780             (uint256 rAmount,,,,,) = _getValues(tAmount);
781             _rOwned[sender] = _rOwned[sender].sub(rAmount);
782             _rTotal = _rTotal.sub(rAmount);
783             _tFeeTotal = _tFeeTotal.add(tAmount);
784         }
785 
786         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
787             require(tAmount <= _tTotal, "Amount must be less than supply");
788             if (!deductTransferFee) {
789                 (uint256 rAmount,,,,,) = _getValues(tAmount);
790                 return rAmount;
791             } else {
792                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
793                 return rTransferAmount;
794             }
795         }
796 
797         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
798             require(rAmount <= _rTotal, "Amount must be less than total reflections");
799             uint256 currentRate =  _getRate();
800             return rAmount.div(currentRate);
801         }
802 
803         function excludeAccount(address account) external onlyOwner() {
804             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
805             require(!_isExcluded[account], "Account is already excluded");
806             if(_rOwned[account] > 0) {
807                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
808             }
809             _isExcluded[account] = true;
810             _excluded.push(account);
811         }
812 
813         function includeAccount(address account) external onlyOwner() {
814             require(_isExcluded[account], "Account is already excluded");
815             for (uint256 i = 0; i < _excluded.length; i++) {
816                 if (_excluded[i] == account) {
817                     _excluded[i] = _excluded[_excluded.length - 1];
818                     _tOwned[account] = 0;
819                     _isExcluded[account] = false;
820                     _excluded.pop();
821                     break;
822                 }
823             }
824         }
825 
826         function removeAllFee() private {
827             if(_taxFee == 0 && _charityFee == 0) return;
828             
829             _previousTaxFee = _taxFee;
830             _previousCharityFee = _charityFee;
831             
832             _taxFee = 0;
833             _charityFee = 0;
834         }
835     
836         function restoreAllFee() private {
837             _taxFee = _previousTaxFee;
838             _charityFee = _previousCharityFee;
839         }
840     
841         function isExcludedFromFee(address account) public view returns(bool) {
842             return _isExcludedFromFee[account];
843         }
844 
845         function _approve(address owner, address spender, uint256 amount) private {
846             require(owner != address(0), "ERC20: approve from the zero address");
847             require(spender != address(0), "ERC20: approve to the zero address");
848 
849             _allowances[owner][spender] = amount;
850             emit Approval(owner, spender, amount);
851         }
852 
853         function _transfer(address sender, address recipient, uint256 amount) private {
854             require(sender != address(0), "ERC20: transfer from the zero address");
855             require(recipient != address(0), "ERC20: transfer to the zero address");
856             require(amount > 0, "Transfer amount must be greater than zero");
857             
858             if(sender != owner() && recipient != owner())
859                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
860 
861             // is the token balance of this contract address over the min number of
862             // tokens that we need to initiate a swap?
863             // also, don't get caught in a circular charity event.
864             // also, don't swap if sender is uniswap pair.
865             uint256 contractTokenBalance = balanceOf(address(this));
866             
867             if(contractTokenBalance >= _maxTxAmount)
868             {
869                 contractTokenBalance = _maxTxAmount;
870             }
871             
872             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;
873             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
874                 // We need to swap the current tokens to ETH and send to the charity wallet
875                 swapTokensForEth(contractTokenBalance);
876                 
877                 uint256 contractETHBalance = address(this).balance;
878                 if(contractETHBalance > 0) {
879                     sendETHToCharity(address(this).balance);
880                 }
881             }
882             
883             //indicates if fee should be deducted from transfer
884             bool takeFee = true;
885             
886             //if any account belongs to _isExcludedFromFee account then remove the fee
887             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
888                 takeFee = false;
889             }
890             
891             //transfer amount, it will take tax and charity fee
892             _tokenTransfer(sender,recipient,amount,takeFee);
893         }
894 
895         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
896             // generate the uniswap pair path of token -> weth
897             address[] memory path = new address[](2);
898             path[0] = address(this);
899             path[1] = uniswapV2Router.WETH();
900 
901             _approve(address(this), address(uniswapV2Router), tokenAmount);
902 
903             // make the swap
904             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
905                 tokenAmount,
906                 0, // accept any amount of ETH
907                 path,
908                 address(this),
909                 block.timestamp
910             );
911         }
912         
913         function sendETHToCharity(uint256 amount) private {
914             _charityWalletAddress.transfer(amount.div(2));
915             _marketingWalletAddress.transfer(amount.div(2));
916         }
917         
918         // We are exposing these functions to be able to manual swap and send
919         // in case the token is highly valued and 5M becomes too much
920         function manualSwap() external onlyOwner() {
921             uint256 contractBalance = balanceOf(address(this));
922             swapTokensForEth(contractBalance);
923         }
924         
925         function manualSend() external onlyOwner() {
926             uint256 contractETHBalance = address(this).balance;
927             sendETHToCharity(contractETHBalance);
928         }
929 
930         function setSwapEnabled(bool enabled) external onlyOwner(){
931             swapEnabled = enabled;
932         }
933         
934         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
935             if(!takeFee)
936                 removeAllFee();
937 
938             if (_isExcluded[sender] && !_isExcluded[recipient]) {
939                 _transferFromExcluded(sender, recipient, amount);
940             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
941                 _transferToExcluded(sender, recipient, amount);
942             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
943                 _transferStandard(sender, recipient, amount);
944             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
945                 _transferBothExcluded(sender, recipient, amount);
946             } else {
947                 _transferStandard(sender, recipient, amount);
948             }
949 
950             if(!takeFee)
951                 restoreAllFee();
952         }
953 
954         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
955             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
956             _rOwned[sender] = _rOwned[sender].sub(rAmount);
957             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
958             _takeCharity(tCharity); 
959             _reflectFee(rFee, tFee);
960             emit Transfer(sender, recipient, tTransferAmount);
961         }
962 
963         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
964             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
965             _rOwned[sender] = _rOwned[sender].sub(rAmount);
966             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
967             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
968             _takeCharity(tCharity);           
969             _reflectFee(rFee, tFee);
970             emit Transfer(sender, recipient, tTransferAmount);
971         }
972 
973         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
974             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
975             _tOwned[sender] = _tOwned[sender].sub(tAmount);
976             _rOwned[sender] = _rOwned[sender].sub(rAmount);
977             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
978             _takeCharity(tCharity);   
979             _reflectFee(rFee, tFee);
980             emit Transfer(sender, recipient, tTransferAmount);
981         }
982 
983         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
984             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
985             _tOwned[sender] = _tOwned[sender].sub(tAmount);
986             _rOwned[sender] = _rOwned[sender].sub(rAmount);
987             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
988             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
989             _takeCharity(tCharity);         
990             _reflectFee(rFee, tFee);
991             emit Transfer(sender, recipient, tTransferAmount);
992         }
993 
994         function _takeCharity(uint256 tCharity) private {
995             uint256 currentRate =  _getRate();
996             uint256 rCharity = tCharity.mul(currentRate);
997             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
998             if(_isExcluded[address(this)])
999                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1000         }
1001 
1002         function _reflectFee(uint256 rFee, uint256 tFee) private {
1003             _rTotal = _rTotal.sub(rFee);
1004             _tFeeTotal = _tFeeTotal.add(tFee);
1005         }
1006 
1007          //to recieve ETH from uniswapV2Router when swaping
1008         receive() external payable {}
1009 
1010         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1011             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1012             uint256 currentRate =  _getRate();
1013             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1014             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1015         }
1016 
1017         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1018             uint256 tFee = tAmount.mul(taxFee).div(100);
1019             uint256 tCharity = tAmount.mul(charityFee).div(100);
1020             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1021             return (tTransferAmount, tFee, tCharity);
1022         }
1023 
1024         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1025             uint256 rAmount = tAmount.mul(currentRate);
1026             uint256 rFee = tFee.mul(currentRate);
1027             uint256 rTransferAmount = rAmount.sub(rFee);
1028             return (rAmount, rTransferAmount, rFee);
1029         }
1030 
1031         function _getRate() private view returns(uint256) {
1032             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1033             return rSupply.div(tSupply);
1034         }
1035 
1036         function _getCurrentSupply() private view returns(uint256, uint256) {
1037             uint256 rSupply = _rTotal;
1038             uint256 tSupply = _tTotal;      
1039             for (uint256 i = 0; i < _excluded.length; i++) {
1040                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1041                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1042                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1043             }
1044             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1045             return (rSupply, tSupply);
1046         }
1047         
1048         function _getTaxFee() private view returns(uint256) {
1049             return _taxFee;
1050         }
1051 
1052         function _getMaxTxAmount() private view returns(uint256) {
1053             return _maxTxAmount;
1054         }
1055 
1056         function _getETHBalance() public view returns(uint256 balance) {
1057             return address(this).balance;
1058         }
1059         
1060         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1061             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1062             _taxFee = taxFee;
1063         }
1064 
1065         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1066             require(charityFee >= 1 && charityFee <= 11, 'charityFee should be in 1 - 11');
1067             _charityFee = charityFee;
1068         }
1069         
1070         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1071             _charityWalletAddress = charityWalletAddress;
1072         }
1073         
1074         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1075             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1076             _maxTxAmount = maxTxAmount;
1077         }
1078     }