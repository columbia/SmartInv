1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-12
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.6.12;
7 
8     abstract contract Context {
9         function _msgSender() internal view virtual returns (address payable) {
10             return msg.sender;
11         }
12 
13         function _msgData() internal view virtual returns (bytes memory) {
14             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
15             return msg.data;
16         }
17     }
18 
19     interface IERC20 {
20         /**
21         * @dev Returns the amount of tokens in existence.
22         */
23         function totalSupply() external view returns (uint256);
24 
25         /**
26         * @dev Returns the amount of tokens owned by `account`.
27         */
28         function balanceOf(address account) external view returns (uint256);
29 
30         /**
31         * @dev Moves `amount` tokens from the caller's account to `recipient`.
32         *
33         * Returns a boolean value indicating whether the operation succeeded.
34         *
35         * Emits a {Transfer} event.
36         */
37         function transfer(address recipient, uint256 amount) external returns (bool);
38 
39         /**
40         * @dev Returns the remaining number of tokens that `spender` will be
41         * allowed to spend on behalf of `owner` through {transferFrom}. This is
42         * zero by default.
43         *
44         * This value changes when {approve} or {transferFrom} are called.
45         */
46         function allowance(address owner, address spender) external view returns (uint256);
47 
48         /**
49         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50         *
51         * Returns a boolean value indicating whether the operation succeeded.
52         *
53         * IMPORTANT: Beware that changing an allowance with this method brings the risk
54         * that someone may use both the old and the new allowance by unfortunate
55         * transaction ordering. One possible solution to mitigate this race
56         * condition is to first reduce the spender's allowance to 0 and set the
57         * desired value afterwards:
58         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59         *
60         * Emits an {Approval} event.
61         */
62         function approve(address spender, uint256 amount) external returns (bool);
63 
64         /**
65         * @dev Moves `amount` tokens from `sender` to `recipient` using the
66         * allowance mechanism. `amount` is then deducted from the caller's
67         * allowance.
68         *
69         * Returns a boolean value indicating whether the operation succeeded.
70         *
71         * Emits a {Transfer} event.
72         */
73         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75         /**
76         * @dev Emitted when `value` tokens are moved from one account (`from`) to
77         * another (`to`).
78         *
79         * Note that `value` may be zero.
80         */
81         event Transfer(address indexed from, address indexed to, uint256 value);
82 
83         /**
84         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85         * a call to {approve}. `value` is the new allowance.
86         */
87         event Approval(address indexed owner, address indexed spender, uint256 value);
88     }
89 
90     library SafeMath {
91         /**
92         * @dev Returns the addition of two unsigned integers, reverting on
93         * overflow.
94         *
95         * Counterpart to Solidity's `+` operator.
96         *
97         * Requirements:
98         *
99         * - Addition cannot overflow.
100         */
101         function add(uint256 a, uint256 b) internal pure returns (uint256) {
102             uint256 c = a + b;
103             require(c >= a, "SafeMath: addition overflow");
104 
105             return c;
106         }
107 
108         /**
109         * @dev Returns the subtraction of two unsigned integers, reverting on
110         * overflow (when the result is negative).
111         *
112         * Counterpart to Solidity's `-` operator.
113         *
114         * Requirements:
115         *
116         * - Subtraction cannot overflow.
117         */
118         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119             return sub(a, b, "SafeMath: subtraction overflow");
120         }
121 
122         /**
123         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124         * overflow (when the result is negative).
125         *
126         * Counterpart to Solidity's `-` operator.
127         *
128         * Requirements:
129         *
130         * - Subtraction cannot overflow.
131         */
132         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133             require(b <= a, errorMessage);
134             uint256 c = a - b;
135 
136             return c;
137         }
138 
139         /**
140         * @dev Returns the multiplication of two unsigned integers, reverting on
141         * overflow.
142         *
143         * Counterpart to Solidity's `*` operator.
144         *
145         * Requirements:
146         *
147         * - Multiplication cannot overflow.
148         */
149         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
151             // benefit is lost if 'b' is also tested.
152             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
153             if (a == 0) {
154                 return 0;
155             }
156 
157             uint256 c = a * b;
158             require(c / a == b, "SafeMath: multiplication overflow");
159 
160             return c;
161         }
162 
163         /**
164         * @dev Returns the integer division of two unsigned integers. Reverts on
165         * division by zero. The result is rounded towards zero.
166         *
167         * Counterpart to Solidity's `/` operator. Note: this function uses a
168         * `revert` opcode (which leaves remaining gas untouched) while Solidity
169         * uses an invalid opcode to revert (consuming all remaining gas).
170         *
171         * Requirements:
172         *
173         * - The divisor cannot be zero.
174         */
175         function div(uint256 a, uint256 b) internal pure returns (uint256) {
176             return div(a, b, "SafeMath: division by zero");
177         }
178 
179         /**
180         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
181         * division by zero. The result is rounded towards zero.
182         *
183         * Counterpart to Solidity's `/` operator. Note: this function uses a
184         * `revert` opcode (which leaves remaining gas untouched) while Solidity
185         * uses an invalid opcode to revert (consuming all remaining gas).
186         *
187         * Requirements:
188         *
189         * - The divisor cannot be zero.
190         */
191         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192             require(b > 0, errorMessage);
193             uint256 c = a / b;
194             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
195 
196             return c;
197         }
198 
199         /**
200         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201         * Reverts when dividing by zero.
202         *
203         * Counterpart to Solidity's `%` operator. This function uses a `revert`
204         * opcode (which leaves remaining gas untouched) while Solidity uses an
205         * invalid opcode to revert (consuming all remaining gas).
206         *
207         * Requirements:
208         *
209         * - The divisor cannot be zero.
210         */
211         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
212             return mod(a, b, "SafeMath: modulo by zero");
213         }
214 
215         /**
216         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217         * Reverts with custom message when dividing by zero.
218         *
219         * Counterpart to Solidity's `%` operator. This function uses a `revert`
220         * opcode (which leaves remaining gas untouched) while Solidity uses an
221         * invalid opcode to revert (consuming all remaining gas).
222         *
223         * Requirements:
224         *
225         * - The divisor cannot be zero.
226         */
227         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228             require(b != 0, errorMessage);
229             return a % b;
230         }
231     }
232 
233     library Address {
234         /**
235         * @dev Returns true if `account` is a contract.
236         *
237         * [IMPORTANT]
238         * ====
239         * It is unsafe to assume that an address for which this function returns
240         * false is an externally-owned account (EOA) and not a contract.
241         *
242         * Among others, `isContract` will return false for the following
243         * types of addresses:
244         *
245         *  - an externally-owned account
246         *  - a contract in construction
247         *  - an address where a contract will be created
248         *  - an address where a contract lived, but was destroyed
249         * ====
250         */
251         function isContract(address account) internal view returns (bool) {
252             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
253             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
254             // for accounts without code, i.e. `keccak256('')`
255             bytes32 codehash;
256             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
257             // solhint-disable-next-line no-inline-assembly
258             assembly { codehash := extcodehash(account) }
259             return (codehash != accountHash && codehash != 0x0);
260         }
261 
262         /**
263         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264         * `recipient`, forwarding all available gas and reverting on errors.
265         *
266         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267         * of certain opcodes, possibly making contracts go over the 2300 gas limit
268         * imposed by `transfer`, making them unable to receive funds via
269         * `transfer`. {sendValue} removes this limitation.
270         *
271         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272         *
273         * IMPORTANT: because control is transferred to `recipient`, care must be
274         * taken to not create reentrancy vulnerabilities. Consider using
275         * {ReentrancyGuard} or the
276         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277         */
278         function sendValue(address payable recipient, uint256 amount) internal {
279             require(address(this).balance >= amount, "Address: insufficient balance");
280 
281             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
282             (bool success, ) = recipient.call{ value: amount }("");
283             require(success, "Address: unable to send value, recipient may have reverted");
284         }
285 
286         /**
287         * @dev Performs a Solidity function call using a low level `call`. A
288         * plain`call` is an unsafe replacement for a function call: use this
289         * function instead.
290         *
291         * If `target` reverts with a revert reason, it is bubbled up by this
292         * function (like regular Solidity function calls).
293         *
294         * Returns the raw returned data. To convert to the expected return value,
295         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
296         *
297         * Requirements:
298         *
299         * - `target` must be a contract.
300         * - calling `target` with `data` must not revert.
301         *
302         * _Available since v3.1._
303         */
304         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
305         return functionCall(target, data, "Address: low-level call failed");
306         }
307 
308         /**
309         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
310         * `errorMessage` as a fallback revert reason when `target` reverts.
311         *
312         * _Available since v3.1._
313         */
314         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
315             return _functionCallWithValue(target, data, 0, errorMessage);
316         }
317 
318         /**
319         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320         * but also transferring `value` wei to `target`.
321         *
322         * Requirements:
323         *
324         * - the calling contract must have an ETH balance of at least `value`.
325         * - the called Solidity function must be `payable`.
326         *
327         * _Available since v3.1._
328         */
329         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
330             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
331         }
332 
333         /**
334         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
335         * with `errorMessage` as a fallback revert reason when `target` reverts.
336         *
337         * _Available since v3.1._
338         */
339         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
340             require(address(this).balance >= value, "Address: insufficient balance for call");
341             return _functionCallWithValue(target, data, value, errorMessage);
342         }
343 
344         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
345             require(isContract(target), "Address: call to non-contract");
346 
347             // solhint-disable-next-line avoid-low-level-calls
348             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
349             if (success) {
350                 return returndata;
351             } else {
352                 // Look for revert reason and bubble it up if present
353                 if (returndata.length > 0) {
354                     // The easiest way to bubble the revert reason is using memory via assembly
355 
356                     // solhint-disable-next-line no-inline-assembly
357                     assembly {
358                         let returndata_size := mload(returndata)
359                         revert(add(32, returndata), returndata_size)
360                     }
361                 } else {
362                     revert(errorMessage);
363                 }
364             }
365         }
366     }
367 
368     contract Ownable is Context {
369         address private _owner;
370         address private _previousOwner;
371         uint256 private _lockTime;
372 
373         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375         /**
376         * @dev Initializes the contract setting the deployer as the initial owner.
377         */
378         constructor () internal {
379             address msgSender = _msgSender();
380             _owner = msgSender;
381             emit OwnershipTransferred(address(0), msgSender);
382         }
383 
384         /**
385         * @dev Returns the address of the current owner.
386         */
387         function owner() public view returns (address) {
388             return _owner;
389         }
390 
391         /**
392         * @dev Throws if called by any account other than the owner.
393         */
394         modifier onlyOwner() {
395             require(_owner == _msgSender(), "Ownable: caller is not the owner");
396             _;
397         }
398 
399         /**
400         * @dev Leaves the contract without owner. It will not be possible to call
401         * `onlyOwner` functions anymore. Can only be called by the current owner.
402         *
403         * NOTE: Renouncing ownership will leave the contract without an owner,
404         * thereby removing any functionality that is only available to the owner.
405         */
406         function renounceOwnership() public virtual onlyOwner {
407             emit OwnershipTransferred(_owner, address(0));
408             _owner = address(0);
409         }
410 
411         /**
412         * @dev Transfers ownership of the contract to a new account (`newOwner`).
413         * Can only be called by the current owner.
414         */
415         function transferOwnership(address newOwner) public virtual onlyOwner {
416             require(newOwner != address(0), "Ownable: new owner is the zero address");
417             emit OwnershipTransferred(_owner, newOwner);
418             _owner = newOwner;
419         }
420 
421         function geUnlockTime() public view returns (uint256) {
422             return _lockTime;
423         }
424 
425         //Locks the contract for owner for the amount of time provided
426         function lock(uint256 time) public virtual onlyOwner {
427             _previousOwner = _owner;
428             _owner = address(0);
429             _lockTime = now + time;
430             emit OwnershipTransferred(_owner, address(0));
431         }
432         
433         //Unlocks the contract for owner when _lockTime is exceeds
434         function unlock() public virtual {
435             require(_previousOwner == msg.sender, "You don't have permission to unlock");
436             require(now > _lockTime , "Contract is locked until 7 days");
437             emit OwnershipTransferred(_owner, _previousOwner);
438             _owner = _previousOwner;
439         }
440     }  
441 
442     interface IUniswapV2Factory {
443         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
444 
445         function feeTo() external view returns (address);
446         function feeToSetter() external view returns (address);
447 
448         function getPair(address tokenA, address tokenB) external view returns (address pair);
449         function allPairs(uint) external view returns (address pair);
450         function allPairsLength() external view returns (uint);
451 
452         function createPair(address tokenA, address tokenB) external returns (address pair);
453 
454         function setFeeTo(address) external;
455         function setFeeToSetter(address) external;
456     } 
457 
458     interface IUniswapV2Pair {
459         event Approval(address indexed owner, address indexed spender, uint value);
460         event Transfer(address indexed from, address indexed to, uint value);
461 
462         function name() external pure returns (string memory);
463         function symbol() external pure returns (string memory);
464         function decimals() external pure returns (uint8);
465         function totalSupply() external view returns (uint);
466         function balanceOf(address owner) external view returns (uint);
467         function allowance(address owner, address spender) external view returns (uint);
468 
469         function approve(address spender, uint value) external returns (bool);
470         function transfer(address to, uint value) external returns (bool);
471         function transferFrom(address from, address to, uint value) external returns (bool);
472 
473         function DOMAIN_SEPARATOR() external view returns (bytes32);
474         function PERMIT_TYPEHASH() external pure returns (bytes32);
475         function nonces(address owner) external view returns (uint);
476 
477         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
478 
479         event Mint(address indexed sender, uint amount0, uint amount1);
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
500         function mint(address to) external returns (uint liquidity);
501         function burn(address to) external returns (uint amount0, uint amount1);
502         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
503         function skim(address to) external;
504         function sync() external;
505 
506         function initialize(address, address) external;
507     }
508 
509     interface IUniswapV2Router01 {
510         function factory() external pure returns (address);
511         function WETH() external pure returns (address);
512 
513         function addLiquidity(
514             address tokenA,
515             address tokenB,
516             uint amountADesired,
517             uint amountBDesired,
518             uint amountAMin,
519             uint amountBMin,
520             address to,
521             uint deadline
522         ) external returns (uint amountA, uint amountB, uint liquidity);
523         function addLiquidityETH(
524             address token,
525             uint amountTokenDesired,
526             uint amountTokenMin,
527             uint amountETHMin,
528             address to,
529             uint deadline
530         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
531         function removeLiquidity(
532             address tokenA,
533             address tokenB,
534             uint liquidity,
535             uint amountAMin,
536             uint amountBMin,
537             address to,
538             uint deadline
539         ) external returns (uint amountA, uint amountB);
540         function removeLiquidityETH(
541             address token,
542             uint liquidity,
543             uint amountTokenMin,
544             uint amountETHMin,
545             address to,
546             uint deadline
547         ) external returns (uint amountToken, uint amountETH);
548         function removeLiquidityWithPermit(
549             address tokenA,
550             address tokenB,
551             uint liquidity,
552             uint amountAMin,
553             uint amountBMin,
554             address to,
555             uint deadline,
556             bool approveMax, uint8 v, bytes32 r, bytes32 s
557         ) external returns (uint amountA, uint amountB);
558         function removeLiquidityETHWithPermit(
559             address token,
560             uint liquidity,
561             uint amountTokenMin,
562             uint amountETHMin,
563             address to,
564             uint deadline,
565             bool approveMax, uint8 v, bytes32 r, bytes32 s
566         ) external returns (uint amountToken, uint amountETH);
567         function swapExactTokensForTokens(
568             uint amountIn,
569             uint amountOutMin,
570             address[] calldata path,
571             address to,
572             uint deadline
573         ) external returns (uint[] memory amounts);
574         function swapTokensForExactTokens(
575             uint amountOut,
576             uint amountInMax,
577             address[] calldata path,
578             address to,
579             uint deadline
580         ) external returns (uint[] memory amounts);
581         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
582             external
583             payable
584             returns (uint[] memory amounts);
585         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
586             external
587             returns (uint[] memory amounts);
588         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
589             external
590             returns (uint[] memory amounts);
591         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
592             external
593             payable
594             returns (uint[] memory amounts);
595 
596         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
597         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
598         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
599         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
600         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
601     }
602 
603     interface IUniswapV2Router02 is IUniswapV2Router01 {
604         function removeLiquidityETHSupportingFeeOnTransferTokens(
605             address token,
606             uint liquidity,
607             uint amountTokenMin,
608             uint amountETHMin,
609             address to,
610             uint deadline
611         ) external returns (uint amountETH);
612         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
613             address token,
614             uint liquidity,
615             uint amountTokenMin,
616             uint amountETHMin,
617             address to,
618             uint deadline,
619             bool approveMax, uint8 v, bytes32 r, bytes32 s
620         ) external returns (uint amountETH);
621 
622         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
623             uint amountIn,
624             uint amountOutMin,
625             address[] calldata path,
626             address to,
627             uint deadline
628         ) external;
629         function swapExactETHForTokensSupportingFeeOnTransferTokens(
630             uint amountOutMin,
631             address[] calldata path,
632             address to,
633             uint deadline
634         ) external payable;
635         function swapExactTokensForETHSupportingFeeOnTransferTokens(
636             uint amountIn,
637             uint amountOutMin,
638             address[] calldata path,
639             address to,
640             uint deadline
641         ) external;
642     }
643 
644     // Contract implementarion
645     contract MUNCH is Context, IERC20, Ownable {
646         using SafeMath for uint256;
647         using Address for address;
648 
649         mapping (address => uint256) private _rOwned;
650         mapping (address => uint256) private _tOwned;
651         mapping (address => mapping (address => uint256)) private _allowances;
652 
653         mapping (address => bool) private _isExcludedFromFee;
654 
655         mapping (address => bool) private _isExcluded;
656         address[] private _excluded;
657     
658         uint256 private constant MAX = ~uint256(0);
659         uint256 private _tTotal = 100000000 * 10**6 * 10**9;
660         uint256 private _rTotal = (MAX - (MAX % _tTotal));
661         uint256 private _tFeeTotal;
662 
663         string private _name = 'MUNCH Token';
664         string private _symbol = 'MUNCH';
665         uint8 private _decimals = 9;
666         
667         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
668         // Charity wallet address is null but the method to set the address is exposed
669         uint256 private _taxFee = 5; 
670         uint256 private _charityFee = 5;
671         uint256 private _previousTaxFee = _taxFee;
672         uint256 private _previousCharityFee = _charityFee;
673 
674         address payable public _charityWalletAddress;
675 
676         IUniswapV2Router02 public immutable uniswapV2Router;
677         address public immutable uniswapV2Pair;
678 
679         bool inSwap = false;
680         bool public swapEnabled = true;
681 
682         uint256 private _maxTxAmount = 100000000000000e9;
683         // We will set a minimum amount of tokens to be swaped => 5M
684         uint256 private _numOfTokensToExchangeForCharity = 5 * 10**6 * 10**9;
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
695         constructor (address payable charityWalletAddress) public {
696             _charityWalletAddress = charityWalletAddress;
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
914             _charityWalletAddress.transfer(amount);
915         }
916         
917         // We are exposing these functions to be able to manual swap and send
918         // in case the token is highly valued and 5M becomes too much
919         function manualSwap() external onlyOwner() {
920             uint256 contractBalance = balanceOf(address(this));
921             swapTokensForEth(contractBalance);
922         }
923         
924         function manualSend() external onlyOwner() {
925             uint256 contractETHBalance = address(this).balance;
926             sendETHToCharity(contractETHBalance);
927         }
928 
929         function setSwapEnabled(bool enabled) external onlyOwner(){
930             swapEnabled = enabled;
931         }
932         
933         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
934             if(!takeFee)
935                 removeAllFee();
936 
937             if (_isExcluded[sender] && !_isExcluded[recipient]) {
938                 _transferFromExcluded(sender, recipient, amount);
939             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
940                 _transferToExcluded(sender, recipient, amount);
941             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
942                 _transferStandard(sender, recipient, amount);
943             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
944                 _transferBothExcluded(sender, recipient, amount);
945             } else {
946                 _transferStandard(sender, recipient, amount);
947             }
948 
949             if(!takeFee)
950                 restoreAllFee();
951         }
952 
953         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
954             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
955             _rOwned[sender] = _rOwned[sender].sub(rAmount);
956             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
957             _takeCharity(tCharity); 
958             _reflectFee(rFee, tFee);
959             emit Transfer(sender, recipient, tTransferAmount);
960         }
961 
962         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
963             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
964             _rOwned[sender] = _rOwned[sender].sub(rAmount);
965             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
966             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
967             _takeCharity(tCharity);           
968             _reflectFee(rFee, tFee);
969             emit Transfer(sender, recipient, tTransferAmount);
970         }
971 
972         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
973             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
974             _tOwned[sender] = _tOwned[sender].sub(tAmount);
975             _rOwned[sender] = _rOwned[sender].sub(rAmount);
976             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
977             _takeCharity(tCharity);   
978             _reflectFee(rFee, tFee);
979             emit Transfer(sender, recipient, tTransferAmount);
980         }
981 
982         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
983             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
984             _tOwned[sender] = _tOwned[sender].sub(tAmount);
985             _rOwned[sender] = _rOwned[sender].sub(rAmount);
986             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
987             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
988             _takeCharity(tCharity);         
989             _reflectFee(rFee, tFee);
990             emit Transfer(sender, recipient, tTransferAmount);
991         }
992 
993         function _takeCharity(uint256 tCharity) private {
994             uint256 currentRate =  _getRate();
995             uint256 rCharity = tCharity.mul(currentRate);
996             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
997             if(_isExcluded[address(this)])
998                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
999         }
1000 
1001         function _reflectFee(uint256 rFee, uint256 tFee) private {
1002             _rTotal = _rTotal.sub(rFee);
1003             _tFeeTotal = _tFeeTotal.add(tFee);
1004         }
1005 
1006          //to recieve ETH from uniswapV2Router when swaping
1007         receive() external payable {}
1008 
1009         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1010             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1011             uint256 currentRate =  _getRate();
1012             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1013             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1014         }
1015 
1016         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1017             uint256 tFee = tAmount.mul(taxFee).div(100);
1018             uint256 tCharity = tAmount.mul(charityFee).div(100);
1019             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1020             return (tTransferAmount, tFee, tCharity);
1021         }
1022 
1023         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1024             uint256 rAmount = tAmount.mul(currentRate);
1025             uint256 rFee = tFee.mul(currentRate);
1026             uint256 rTransferAmount = rAmount.sub(rFee);
1027             return (rAmount, rTransferAmount, rFee);
1028         }
1029 
1030         function _getRate() private view returns(uint256) {
1031             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1032             return rSupply.div(tSupply);
1033         }
1034 
1035         function _getCurrentSupply() private view returns(uint256, uint256) {
1036             uint256 rSupply = _rTotal;
1037             uint256 tSupply = _tTotal;      
1038             for (uint256 i = 0; i < _excluded.length; i++) {
1039                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1040                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1041                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1042             }
1043             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1044             return (rSupply, tSupply);
1045         }
1046         
1047         function _getTaxFee() private view returns(uint256) {
1048             return _taxFee;
1049         }
1050 
1051         function _getMaxTxAmount() private view returns(uint256) {
1052             return _maxTxAmount;
1053         }
1054 
1055         function _getETHBalance() public view returns(uint256 balance) {
1056             return address(this).balance;
1057         }
1058         
1059         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1060             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1061             _taxFee = taxFee;
1062         }
1063 
1064         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1065             require(charityFee >= 1 && charityFee <= 5, 'charityFee should be in 1 - 5');
1066             _charityFee = charityFee;
1067         }
1068         
1069         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1070             _charityWalletAddress = charityWalletAddress;
1071         }
1072         
1073         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1074             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1075             _maxTxAmount = maxTxAmount;
1076         }
1077     }