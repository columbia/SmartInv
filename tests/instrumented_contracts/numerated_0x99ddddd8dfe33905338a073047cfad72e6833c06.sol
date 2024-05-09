1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-23
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
645     contract SnowInu is Context, IERC20, Ownable {
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
665         string private _name = 'Snow Inu';
666         string private _symbol = 'SINU';
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
714             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
715             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
716             
717             _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
718             _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
719             
720             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
721             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
722             
723             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
724             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
725     
726             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
727             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
728     
729             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
730             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
731     
732             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
733             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
734     
735             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
736             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
737     
738             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
739             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
740     
741             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
742             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
743     
744             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
745             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
746             
747             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
748             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
749             
750             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
751             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
752             
753             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
754             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
755             
756             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
757             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
758 
759             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
760             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
761             
762             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
763             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
764             
765             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
766             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
767             
768             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
769             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
770             
771             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
772             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
773             
774             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
775             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
776             
777             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
778             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
779             
780             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
781             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
782             
783             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
784             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
785             
786             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
787             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
788             
789             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
790             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
791             
792             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
793             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
794 
795             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
796             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
797             
798             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
799             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
800             
801             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
802             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
803 
804             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
805             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
806 
807             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
808             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
809 
810             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
811             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
812             
813             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
814             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
815             
816             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
817             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
818             
819             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
820             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
821             
822             
823             emit Transfer(address(0), _msgSender(), _tTotal);
824         }
825 
826         function name() public view returns (string memory) {
827             return _name;
828         }
829 
830         function symbol() public view returns (string memory) {
831             return _symbol;
832         }
833 
834         function decimals() public view returns (uint8) {
835             return _decimals;
836         }
837 
838         function totalSupply() public view override returns (uint256) {
839             return _tTotal;
840         }
841 
842         function balanceOf(address account) public view override returns (uint256) {
843             if (_isExcluded[account]) return _tOwned[account];
844             return tokenFromReflection(_rOwned[account]);
845         }
846 
847         function transfer(address recipient, uint256 amount) public override returns (bool) {
848             _transfer(_msgSender(), recipient, amount);
849             return true;
850         }
851 
852         function allowance(address owner, address spender) public view override returns (uint256) {
853             return _allowances[owner][spender];
854         }
855 
856         function approve(address spender, uint256 amount) public override returns (bool) {
857             _approve(_msgSender(), spender, amount);
858             return true;
859         }
860 
861         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
862             _transfer(sender, recipient, amount);
863             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
864             return true;
865         }
866 
867         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
868             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
869             return true;
870         }
871 
872         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
873             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
874             return true;
875         }
876 
877         function isExcluded(address account) public view returns (bool) {
878             return _isExcluded[account];
879         }
880         
881         function isBlackListed(address account) public view returns (bool) {
882             return _isBlackListedBot[account];
883         }
884 
885         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
886             _isExcludedFromFee[account] = excluded;
887         }
888 
889         function totalFees() public view returns (uint256) {
890             return _tFeeTotal;
891         }
892 
893         function deliver(uint256 tAmount) public {
894             address sender = _msgSender();
895             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
896             (uint256 rAmount,,,,,) = _getValues(tAmount);
897             _rOwned[sender] = _rOwned[sender].sub(rAmount);
898             _rTotal = _rTotal.sub(rAmount);
899             _tFeeTotal = _tFeeTotal.add(tAmount);
900         }
901 
902         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
903             require(tAmount <= _tTotal, "Amount must be less than supply");
904             if (!deductTransferFee) {
905                 (uint256 rAmount,,,,,) = _getValues(tAmount);
906                 return rAmount;
907             } else {
908                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
909                 return rTransferAmount;
910             }
911         }
912 
913         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
914             require(rAmount <= _rTotal, "Amount must be less than total reflections");
915             uint256 currentRate =  _getRate();
916             return rAmount.div(currentRate);
917         }
918 
919         function excludeAccount(address account) external onlyOwner() {
920             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
921             require(!_isExcluded[account], "Account is already excluded");
922             if(_rOwned[account] > 0) {
923                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
924             }
925             _isExcluded[account] = true;
926             _excluded.push(account);
927         }
928 
929         function includeAccount(address account) external onlyOwner() {
930             require(_isExcluded[account], "Account is already excluded");
931             for (uint256 i = 0; i < _excluded.length; i++) {
932                 if (_excluded[i] == account) {
933                     _excluded[i] = _excluded[_excluded.length - 1];
934                     _tOwned[account] = 0;
935                     _isExcluded[account] = false;
936                     _excluded.pop();
937                     break;
938                 }
939             }
940         }
941         
942         function addBotToBlackList(address account) external onlyOwner() {
943             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
944             require(!_isBlackListedBot[account], "Account is already blacklisted");
945             _isBlackListedBot[account] = true;
946             _blackListedBots.push(account);
947         }
948     
949         function removeBotFromBlackList(address account) external onlyOwner() {
950             require(_isBlackListedBot[account], "Account is not blacklisted");
951             for (uint256 i = 0; i < _blackListedBots.length; i++) {
952                 if (_blackListedBots[i] == account) {
953                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
954                     _isBlackListedBot[account] = false;
955                     _blackListedBots.pop();
956                     break;
957                 }
958             }
959         }
960 
961         function removeAllFee() private {
962             if(_taxFee == 0 && _charityFee == 0) return;
963             
964             _previousTaxFee = _taxFee;
965             _previousCharityFee = _charityFee;
966             
967             _taxFee = 0;
968             _charityFee = 0;
969         }
970     
971         function restoreAllFee() private {
972             _taxFee = _previousTaxFee;
973             _charityFee = _previousCharityFee;
974         }
975     
976         function isExcludedFromFee(address account) public view returns(bool) {
977             return _isExcludedFromFee[account];
978         }
979         
980             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
981         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
982             10**2
983         );
984         }
985 
986         function _approve(address owner, address spender, uint256 amount) private {
987             require(owner != address(0), "ERC20: approve from the zero address");
988             require(spender != address(0), "ERC20: approve to the zero address");
989 
990             _allowances[owner][spender] = amount;
991             emit Approval(owner, spender, amount);
992         }
993 
994         function _transfer(address sender, address recipient, uint256 amount) private {
995             require(sender != address(0), "ERC20: transfer from the zero address");
996             require(recipient != address(0), "ERC20: transfer to the zero address");
997             require(amount > 0, "Transfer amount must be greater than zero");
998             require(!_isBlackListedBot[recipient], "You have no power here!");
999             require(!_isBlackListedBot[msg.sender], "You have no power here!");
1000             
1001             if(sender != owner() && recipient != owner())
1002                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1003 
1004             // is the token balance of this contract address over the min number of
1005             // tokens that we need to initiate a swap?
1006             // also, don't get caught in a circular charity event.
1007             // also, don't swap if sender is uniswap pair.
1008             uint256 contractTokenBalance = balanceOf(address(this));
1009             
1010             if(contractTokenBalance >= _maxTxAmount)
1011             {
1012                 contractTokenBalance = _maxTxAmount;
1013             }
1014             
1015             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;
1016             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1017                 // We need to swap the current tokens to ETH and send to the charity wallet
1018                 swapTokensForEth(contractTokenBalance);
1019                 
1020                 uint256 contractETHBalance = address(this).balance;
1021                 if(contractETHBalance > 0) {
1022                     sendETHToCharity(address(this).balance);
1023                 }
1024             }
1025             
1026             //indicates if fee should be deducted from transfer
1027             bool takeFee = true;
1028             
1029             //if any account belongs to _isExcludedFromFee account then remove the fee
1030             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1031                 takeFee = false;
1032             }
1033             
1034             //transfer amount, it will take tax and charity fee
1035             _tokenTransfer(sender,recipient,amount,takeFee);
1036         }
1037 
1038         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1039             // generate the uniswap pair path of token -> weth
1040             address[] memory path = new address[](2);
1041             path[0] = address(this);
1042             path[1] = uniswapV2Router.WETH();
1043 
1044             _approve(address(this), address(uniswapV2Router), tokenAmount);
1045 
1046             // make the swap
1047             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1048                 tokenAmount,
1049                 0, // accept any amount of ETH
1050                 path,
1051                 address(this),
1052                 block.timestamp
1053             );
1054         }
1055         
1056         function sendETHToCharity(uint256 amount) private {
1057             _charityWalletAddress.transfer(amount.div(2));
1058             _marketingWalletAddress.transfer(amount.div(2));
1059         }
1060         
1061         // We are exposing these functions to be able to manual swap and send
1062         // in case the token is highly valued and 5M becomes too much
1063         function manualSwap() external onlyOwner() {
1064             uint256 contractBalance = balanceOf(address(this));
1065             swapTokensForEth(contractBalance);
1066         }
1067         
1068         function manualSend() external onlyOwner() {
1069             uint256 contractETHBalance = address(this).balance;
1070             sendETHToCharity(contractETHBalance);
1071         }
1072 
1073         function setSwapEnabled(bool enabled) external onlyOwner(){
1074             swapEnabled = enabled;
1075         }
1076         
1077         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1078             if(!takeFee)
1079                 removeAllFee();
1080 
1081             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1082                 _transferFromExcluded(sender, recipient, amount);
1083             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1084                 _transferToExcluded(sender, recipient, amount);
1085             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1086                 _transferStandard(sender, recipient, amount);
1087             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1088                 _transferBothExcluded(sender, recipient, amount);
1089             } else {
1090                 _transferStandard(sender, recipient, amount);
1091             }
1092 
1093             if(!takeFee)
1094                 restoreAllFee();
1095         }
1096 
1097         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1098             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1099             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1100             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1101             _takeCharity(tCharity); 
1102             _reflectFee(rFee, tFee);
1103             emit Transfer(sender, recipient, tTransferAmount);
1104         }
1105 
1106         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1107             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1108             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1109             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1110             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1111             _takeCharity(tCharity);           
1112             _reflectFee(rFee, tFee);
1113             emit Transfer(sender, recipient, tTransferAmount);
1114         }
1115 
1116         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1117             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1118             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1119             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1120             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1121             _takeCharity(tCharity);   
1122             _reflectFee(rFee, tFee);
1123             emit Transfer(sender, recipient, tTransferAmount);
1124         }
1125 
1126         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1127             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1128             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1129             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1130             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1131             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1132             _takeCharity(tCharity);         
1133             _reflectFee(rFee, tFee);
1134             emit Transfer(sender, recipient, tTransferAmount);
1135         }
1136 
1137         function _takeCharity(uint256 tCharity) private {
1138             uint256 currentRate =  _getRate();
1139             uint256 rCharity = tCharity.mul(currentRate);
1140             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1141             if(_isExcluded[address(this)])
1142                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1143         }
1144 
1145         function _reflectFee(uint256 rFee, uint256 tFee) private {
1146             _rTotal = _rTotal.sub(rFee);
1147             _tFeeTotal = _tFeeTotal.add(tFee);
1148         }
1149 
1150          //to recieve ETH from uniswapV2Router when swaping
1151         receive() external payable {}
1152 
1153         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1154             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1155             uint256 currentRate =  _getRate();
1156             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1157             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1158         }
1159 
1160         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1161             uint256 tFee = tAmount.mul(taxFee).div(100);
1162             uint256 tCharity = tAmount.mul(charityFee).div(100);
1163             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1164             return (tTransferAmount, tFee, tCharity);
1165         }
1166 
1167         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1168             uint256 rAmount = tAmount.mul(currentRate);
1169             uint256 rFee = tFee.mul(currentRate);
1170             uint256 rTransferAmount = rAmount.sub(rFee);
1171             return (rAmount, rTransferAmount, rFee);
1172         }
1173 
1174         function _getRate() private view returns(uint256) {
1175             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1176             return rSupply.div(tSupply);
1177         }
1178 
1179         function _getCurrentSupply() private view returns(uint256, uint256) {
1180             uint256 rSupply = _rTotal;
1181             uint256 tSupply = _tTotal;      
1182             for (uint256 i = 0; i < _excluded.length; i++) {
1183                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1184                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1185                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1186             }
1187             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1188             return (rSupply, tSupply);
1189         }
1190         
1191         function _getTaxFee() private view returns(uint256) {
1192             return _taxFee;
1193         }
1194 
1195         function _getMaxTxAmount() private view returns(uint256) {
1196             return _maxTxAmount;
1197         }
1198 
1199         function _getETHBalance() public view returns(uint256 balance) {
1200             return address(this).balance;
1201         }
1202         
1203         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1204             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1205             _taxFee = taxFee;
1206         }
1207 
1208         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1209             require(charityFee >= 1 && charityFee <= 11, 'charityFee should be in 1 - 11');
1210             _charityFee = charityFee;
1211         }
1212         
1213         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1214             _charityWalletAddress = charityWalletAddress;
1215         }
1216         
1217         
1218     }