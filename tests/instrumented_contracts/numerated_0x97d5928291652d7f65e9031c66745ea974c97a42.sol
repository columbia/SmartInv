1 /**
2  
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
644     // Contract implementation
645     contract COOKIE is Context, IERC20, Ownable {
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
657         mapping (address => bool) private _isBlackListedBot;
658         address[] private _blackListedBots;
659     
660         uint256 private constant MAX = ~uint256(0);
661         uint256 private _tTotal = 1000000000000000000000;  //1,000,000,000,000
662         uint256 private _rTotal = (MAX - (MAX % _tTotal));
663         uint256 private _tFeeTotal;
664 
665         string private _name = 'COOKIE';
666         string private _symbol = 'COOKIE';
667         uint8 private _decimals = 9;
668         
669         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
670         // Charity wallet address is null but the method to set the address is exposed
671         uint256 private _taxFee = 10; 
672         uint256 private _charityFee = 10;
673         uint256 private _previousTaxFee = _taxFee;
674         uint256 private _previousCharityFee = _charityFee;
675 
676         address payable public _charityWalletAddress;
677         address payable public _marketingWalletAddress;
678         
679         IUniswapV2Router02 public immutable uniswapV2Router;
680         address public immutable uniswapV2Pair;
681 
682         bool inSwap = false;
683         bool public swapEnabled = true;
684 
685         uint256 public _maxTxAmount = _tTotal; //no max tx limit rn 
686         uint256 private _numOfTokensToExchangeForCharity = 5000000000000000;
687 
688         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
689         event SwapEnabledUpdated(bool enabled);
690 
691         modifier lockTheSwap {
692             inSwap = true;
693             _;
694             inSwap = false;
695         }
696 
697         constructor (address payable charityWalletAddress, address payable marketingWalletAddress) public {
698             _charityWalletAddress = charityWalletAddress;
699             _marketingWalletAddress = marketingWalletAddress;
700             _rOwned[_msgSender()] = _rTotal;
701 
702             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
703             // Create a uniswap pair for this new token
704             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
705                 .createPair(address(this), _uniswapV2Router.WETH());
706 
707             // set the rest of the contract variables
708             uniswapV2Router = _uniswapV2Router;
709 
710             // Exclude owner and this contract from fee
711             _isExcludedFromFee[owner()] = true;
712             _isExcludedFromFee[address(this)] = true;
713             
714             
715             
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
775         function isBlackListed(address account) public view returns (bool) {
776             return _isBlackListedBot[account];
777         }
778 
779         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
780             _isExcludedFromFee[account] = excluded;
781         }
782 
783         function totalFees() public view returns (uint256) {
784             return _tFeeTotal;
785         }
786 
787         function deliver(uint256 tAmount) public {
788             address sender = _msgSender();
789             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
790             (uint256 rAmount,,,,,) = _getValues(tAmount);
791             _rOwned[sender] = _rOwned[sender].sub(rAmount);
792             _rTotal = _rTotal.sub(rAmount);
793             _tFeeTotal = _tFeeTotal.add(tAmount);
794         }
795 
796         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
797             require(tAmount <= _tTotal, "Amount must be less than supply");
798             if (!deductTransferFee) {
799                 (uint256 rAmount,,,,,) = _getValues(tAmount);
800                 return rAmount;
801             } else {
802                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
803                 return rTransferAmount;
804             }
805         }
806 
807         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
808             require(rAmount <= _rTotal, "Amount must be less than total reflections");
809             uint256 currentRate =  _getRate();
810             return rAmount.div(currentRate);
811         }
812 
813         function excludeAccount(address account) external onlyOwner() {
814             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
815             require(!_isExcluded[account], "Account is already excluded");
816             if(_rOwned[account] > 0) {
817                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
818             }
819             _isExcluded[account] = true;
820             _excluded.push(account);
821         }
822 
823         function includeAccount(address account) external onlyOwner() {
824             require(_isExcluded[account], "Account is already excluded");
825             for (uint256 i = 0; i < _excluded.length; i++) {
826                 if (_excluded[i] == account) {
827                     _excluded[i] = _excluded[_excluded.length - 1];
828                     _tOwned[account] = 0;
829                     _isExcluded[account] = false;
830                     _excluded.pop();
831                     break;
832                 }
833             }
834         }
835         
836         function addBotToBlackList(address account) external onlyOwner() {
837             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
838             require(!_isBlackListedBot[account], "Account is already blacklisted");
839             _isBlackListedBot[account] = true;
840             _blackListedBots.push(account);
841         }
842     
843         function removeBotFromBlackList(address account) external onlyOwner() {
844             require(_isBlackListedBot[account], "Account is not blacklisted");
845             for (uint256 i = 0; i < _blackListedBots.length; i++) {
846                 if (_blackListedBots[i] == account) {
847                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
848                     _isBlackListedBot[account] = false;
849                     _blackListedBots.pop();
850                     break;
851                 }
852             }
853         }
854 
855         function removeAllFee() private {
856             if(_taxFee == 0 && _charityFee == 0) return;
857             
858             _previousTaxFee = _taxFee;
859             _previousCharityFee = _charityFee;
860             
861             _taxFee = 0;
862             _charityFee = 0;
863         }
864     
865         function restoreAllFee() private {
866             _taxFee = _previousTaxFee;
867             _charityFee = _previousCharityFee;
868         }
869     
870         function isExcludedFromFee(address account) public view returns(bool) {
871             return _isExcludedFromFee[account];
872         }
873         
874             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
875         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
876             10**2
877         );
878         }
879 
880         function _approve(address owner, address spender, uint256 amount) private {
881             require(owner != address(0), "ERC20: approve from the zero address");
882             require(spender != address(0), "ERC20: approve to the zero address");
883 
884             _allowances[owner][spender] = amount;
885             emit Approval(owner, spender, amount);
886         }
887 
888         function _transfer(address sender, address recipient, uint256 amount) private {
889             require(sender != address(0), "ERC20: transfer from the zero address");
890             require(recipient != address(0), "ERC20: transfer to the zero address");
891             require(amount > 0, "Transfer amount must be greater than zero");
892             require(!_isBlackListedBot[recipient], "You have no power here!");
893             require(!_isBlackListedBot[msg.sender], "You have no power here!");
894             
895             if(sender != owner() && recipient != owner())
896                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
897 
898             // is the token balance of this contract address over the min number of
899             // tokens that we need to initiate a swap?
900             // also, don't get caught in a circular charity event.
901             // also, don't swap if sender is uniswap pair.
902             uint256 contractTokenBalance = balanceOf(address(this));
903             
904             if(contractTokenBalance >= _maxTxAmount)
905             {
906                 contractTokenBalance = _maxTxAmount;
907             }
908             
909             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;
910             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
911                 // We need to swap the current tokens to ETH and send to the charity wallet
912                 swapTokensForEth(contractTokenBalance);
913                 
914                 uint256 contractETHBalance = address(this).balance;
915                 if(contractETHBalance > 0) {
916                     sendETHToCharity(address(this).balance);
917                 }
918             }
919             
920             //indicates if fee should be deducted from transfer
921             bool takeFee = true;
922             
923             //if any account belongs to _isExcludedFromFee account then remove the fee
924             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
925                 takeFee = false;
926             }
927             
928             //transfer amount, it will take tax and charity fee
929             _tokenTransfer(sender,recipient,amount,takeFee);
930         }
931 
932         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
933             // generate the uniswap pair path of token -> weth
934             address[] memory path = new address[](2);
935             path[0] = address(this);
936             path[1] = uniswapV2Router.WETH();
937 
938             _approve(address(this), address(uniswapV2Router), tokenAmount);
939 
940             // make the swap
941             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
942                 tokenAmount,
943                 0, // accept any amount of ETH
944                 path,
945                 address(this),
946                 block.timestamp
947             );
948         }
949         
950         function sendETHToCharity(uint256 amount) private {
951             _charityWalletAddress.transfer(amount.div(2));
952             _marketingWalletAddress.transfer(amount.div(2));
953         }
954         
955         // We are exposing these functions to be able to manual swap and send
956         // in case the token is highly valued and 5M becomes too much
957         function manualSwap() external onlyOwner() {
958             uint256 contractBalance = balanceOf(address(this));
959             swapTokensForEth(contractBalance);
960         }
961         
962         function manualSend() external onlyOwner() {
963             uint256 contractETHBalance = address(this).balance;
964             sendETHToCharity(contractETHBalance);
965         }
966 
967         function setSwapEnabled(bool enabled) external onlyOwner(){
968             swapEnabled = enabled;
969         }
970         
971         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
972             if(!takeFee)
973                 removeAllFee();
974 
975             if (_isExcluded[sender] && !_isExcluded[recipient]) {
976                 _transferFromExcluded(sender, recipient, amount);
977             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
978                 _transferToExcluded(sender, recipient, amount);
979             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
980                 _transferStandard(sender, recipient, amount);
981             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
982                 _transferBothExcluded(sender, recipient, amount);
983             } else {
984                 _transferStandard(sender, recipient, amount);
985             }
986 
987             if(!takeFee)
988                 restoreAllFee();
989         }
990 
991         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
992             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
993             _rOwned[sender] = _rOwned[sender].sub(rAmount);
994             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
995             _takeCharity(tCharity); 
996             _reflectFee(rFee, tFee);
997             emit Transfer(sender, recipient, tTransferAmount);
998         }
999 
1000         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1001             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1002             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1003             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1004             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1005             _takeCharity(tCharity);           
1006             _reflectFee(rFee, tFee);
1007             emit Transfer(sender, recipient, tTransferAmount);
1008         }
1009 
1010         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1011             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1012             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1013             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1014             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1015             _takeCharity(tCharity);   
1016             _reflectFee(rFee, tFee);
1017             emit Transfer(sender, recipient, tTransferAmount);
1018         }
1019 
1020         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1021             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1022             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1023             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1024             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1025             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1026             _takeCharity(tCharity);         
1027             _reflectFee(rFee, tFee);
1028             emit Transfer(sender, recipient, tTransferAmount);
1029         }
1030 
1031         function _takeCharity(uint256 tCharity) private {
1032             uint256 currentRate =  _getRate();
1033             uint256 rCharity = tCharity.mul(currentRate);
1034             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1035             if(_isExcluded[address(this)])
1036                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1037         }
1038 
1039         function _reflectFee(uint256 rFee, uint256 tFee) private {
1040             _rTotal = _rTotal.sub(rFee);
1041             _tFeeTotal = _tFeeTotal.add(tFee);
1042         }
1043 
1044          //to recieve ETH from uniswapV2Router when swaping
1045         receive() external payable {}
1046 
1047         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1048             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1049             uint256 currentRate =  _getRate();
1050             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1051             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1052         }
1053 
1054         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1055             uint256 tFee = tAmount.mul(taxFee).div(100);
1056             uint256 tCharity = tAmount.mul(charityFee).div(100);
1057             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1058             return (tTransferAmount, tFee, tCharity);
1059         }
1060 
1061         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1062             uint256 rAmount = tAmount.mul(currentRate);
1063             uint256 rFee = tFee.mul(currentRate);
1064             uint256 rTransferAmount = rAmount.sub(rFee);
1065             return (rAmount, rTransferAmount, rFee);
1066         }
1067 
1068         function _getRate() private view returns(uint256) {
1069             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1070             return rSupply.div(tSupply);
1071         }
1072 
1073         function _getCurrentSupply() private view returns(uint256, uint256) {
1074             uint256 rSupply = _rTotal;
1075             uint256 tSupply = _tTotal;      
1076             for (uint256 i = 0; i < _excluded.length; i++) {
1077                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1078                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1079                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1080             }
1081             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1082             return (rSupply, tSupply);
1083         }
1084         
1085         function _getTaxFee() private view returns(uint256) {
1086             return _taxFee;
1087         }
1088 
1089         function _getMaxTxAmount() private view returns(uint256) {
1090             return _maxTxAmount;
1091         }
1092 
1093         function _getETHBalance() public view returns(uint256 balance) {
1094             return address(this).balance;
1095         }
1096         
1097         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1098             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1099             _taxFee = taxFee;
1100         }
1101 
1102         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1103             require(charityFee >= 1 && charityFee <= 11, 'charityFee should be in 1 - 11');
1104             _charityFee = charityFee;
1105         }
1106         
1107         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1108             _charityWalletAddress = charityWalletAddress;
1109         }
1110         
1111         
1112     }