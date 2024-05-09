1 /*
2                     .  ,
3                         (\;/)
4                        oo   \//,        _
5                      ,/_;~      \,     / '
6                      "'    (  (   \    !
7                           //  \   |__.'
8                          '~  '~----''
9 ███╗   ███╗██╗   ██╗███████╗██╗  ██╗██████╗  █████╗ ████████╗
10 ████╗ ████║██║   ██║██╔════╝██║ ██╔╝██╔══██╗██╔══██╗╚══██╔══╝
11 ██╔████╔██║██║   ██║███████╗█████╔╝ ██████╔╝███████║   ██║   
12 ██║╚██╔╝██║██║   ██║╚════██║██╔═██╗ ██╔══██╗██╔══██║   ██║   
13 ██║ ╚═╝ ██║╚██████╔╝███████║██║  ██╗██║  ██║██║  ██║   ██║   
14 ╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
15                                                              
16 Website: https://www.muskrat.fund/
17 Telegram: https://t.me/musk_rat
18 
19 */
20 
21 // SPDX-License-Identifier: Unlicensed
22 pragma solidity ^0.6.12;
23 
24     abstract contract Context {
25         function _msgSender() internal view virtual returns (address payable) {
26             return msg.sender;
27         }
28 
29         function _msgData() internal view virtual returns (bytes memory) {
30             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31             return msg.data;
32         }
33     }
34 
35     interface IERC20 {
36         /**
37         * @dev Returns the amount of tokens in existence.
38         */
39         function totalSupply() external view returns (uint256);
40 
41         /**
42         * @dev Returns the amount of tokens owned by `account`.
43         */
44         function balanceOf(address account) external view returns (uint256);
45 
46         /**
47         * @dev Moves `amount` tokens from the caller's account to `recipient`.
48         *
49         * Returns a boolean value indicating whether the operation succeeded.
50         *
51         * Emits a {Transfer} event.
52         */
53         function transfer(address recipient, uint256 amount) external returns (bool);
54 
55         /**
56         * @dev Returns the remaining number of tokens that `spender` will be
57         * allowed to spend on behalf of `owner` through {transferFrom}. This is
58         * zero by default.
59         *
60         * This value changes when {approve} or {transferFrom} are called.
61         */
62         function allowance(address owner, address spender) external view returns (uint256);
63 
64         /**
65         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66         *
67         * Returns a boolean value indicating whether the operation succeeded.
68         *
69         * IMPORTANT: Beware that changing an allowance with this method brings the risk
70         * that someone may use both the old and the new allowance by unfortunate
71         * transaction ordering. One possible solution to mitigate this race
72         * condition is to first reduce the spender's allowance to 0 and set the
73         * desired value afterwards:
74         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75         *
76         * Emits an {Approval} event.
77         */
78         function approve(address spender, uint256 amount) external returns (bool);
79 
80         /**
81         * @dev Moves `amount` tokens from `sender` to `recipient` using the
82         * allowance mechanism. `amount` is then deducted from the caller's
83         * allowance.
84         *
85         * Returns a boolean value indicating whether the operation succeeded.
86         *
87         * Emits a {Transfer} event.
88         */
89         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91         /**
92         * @dev Emitted when `value` tokens are moved from one account (`from`) to
93         * another (`to`).
94         *
95         * Note that `value` may be zero.
96         */
97         event Transfer(address indexed from, address indexed to, uint256 value);
98 
99         /**
100         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101         * a call to {approve}. `value` is the new allowance.
102         */
103         event Approval(address indexed owner, address indexed spender, uint256 value);
104     }
105 
106     library SafeMath {
107         /**
108         * @dev Returns the addition of two unsigned integers, reverting on
109         * overflow.
110         *
111         * Counterpart to Solidity's `+` operator.
112         *
113         * Requirements:
114         *
115         * - Addition cannot overflow.
116         */
117         function add(uint256 a, uint256 b) internal pure returns (uint256) {
118             uint256 c = a + b;
119             require(c >= a, "SafeMath: addition overflow");
120 
121             return c;
122         }
123 
124         /**
125         * @dev Returns the subtraction of two unsigned integers, reverting on
126         * overflow (when the result is negative).
127         *
128         * Counterpart to Solidity's `-` operator.
129         *
130         * Requirements:
131         *
132         * - Subtraction cannot overflow.
133         */
134         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135             return sub(a, b, "SafeMath: subtraction overflow");
136         }
137 
138         /**
139         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140         * overflow (when the result is negative).
141         *
142         * Counterpart to Solidity's `-` operator.
143         *
144         * Requirements:
145         *
146         * - Subtraction cannot overflow.
147         */
148         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149             require(b <= a, errorMessage);
150             uint256 c = a - b;
151 
152             return c;
153         }
154 
155         /**
156         * @dev Returns the multiplication of two unsigned integers, reverting on
157         * overflow.
158         *
159         * Counterpart to Solidity's `*` operator.
160         *
161         * Requirements:
162         *
163         * - Multiplication cannot overflow.
164         */
165         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167             // benefit is lost if 'b' is also tested.
168             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169             if (a == 0) {
170                 return 0;
171             }
172 
173             uint256 c = a * b;
174             require(c / a == b, "SafeMath: multiplication overflow");
175 
176             return c;
177         }
178 
179         /**
180         * @dev Returns the integer division of two unsigned integers. Reverts on
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
191         function div(uint256 a, uint256 b) internal pure returns (uint256) {
192             return div(a, b, "SafeMath: division by zero");
193         }
194 
195         /**
196         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197         * division by zero. The result is rounded towards zero.
198         *
199         * Counterpart to Solidity's `/` operator. Note: this function uses a
200         * `revert` opcode (which leaves remaining gas untouched) while Solidity
201         * uses an invalid opcode to revert (consuming all remaining gas).
202         *
203         * Requirements:
204         *
205         * - The divisor cannot be zero.
206         */
207         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208             require(b > 0, errorMessage);
209             uint256 c = a / b;
210             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212             return c;
213         }
214 
215         /**
216         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217         * Reverts when dividing by zero.
218         *
219         * Counterpart to Solidity's `%` operator. This function uses a `revert`
220         * opcode (which leaves remaining gas untouched) while Solidity uses an
221         * invalid opcode to revert (consuming all remaining gas).
222         *
223         * Requirements:
224         *
225         * - The divisor cannot be zero.
226         */
227         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228             return mod(a, b, "SafeMath: modulo by zero");
229         }
230 
231         /**
232         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233         * Reverts with custom message when dividing by zero.
234         *
235         * Counterpart to Solidity's `%` operator. This function uses a `revert`
236         * opcode (which leaves remaining gas untouched) while Solidity uses an
237         * invalid opcode to revert (consuming all remaining gas).
238         *
239         * Requirements:
240         *
241         * - The divisor cannot be zero.
242         */
243         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244             require(b != 0, errorMessage);
245             return a % b;
246         }
247     }
248 
249     library Address {
250         /**
251         * @dev Returns true if `account` is a contract.
252         *
253         * [IMPORTANT]
254         * ====
255         * It is unsafe to assume that an address for which this function returns
256         * false is an externally-owned account (EOA) and not a contract.
257         *
258         * Among others, `isContract` will return false for the following
259         * types of addresses:
260         *
261         *  - an externally-owned account
262         *  - a contract in construction
263         *  - an address where a contract will be created
264         *  - an address where a contract lived, but was destroyed
265         * ====
266         */
267         function isContract(address account) internal view returns (bool) {
268             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270             // for accounts without code, i.e. `keccak256('')`
271             bytes32 codehash;
272             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273             // solhint-disable-next-line no-inline-assembly
274             assembly { codehash := extcodehash(account) }
275             return (codehash != accountHash && codehash != 0x0);
276         }
277 
278         /**
279         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280         * `recipient`, forwarding all available gas and reverting on errors.
281         *
282         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283         * of certain opcodes, possibly making contracts go over the 2300 gas limit
284         * imposed by `transfer`, making them unable to receive funds via
285         * `transfer`. {sendValue} removes this limitation.
286         *
287         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288         *
289         * IMPORTANT: because control is transferred to `recipient`, care must be
290         * taken to not create reentrancy vulnerabilities. Consider using
291         * {ReentrancyGuard} or the
292         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293         */
294         function sendValue(address payable recipient, uint256 amount) internal {
295             require(address(this).balance >= amount, "Address: insufficient balance");
296 
297             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298             (bool success, ) = recipient.call{ value: amount }("");
299             require(success, "Address: unable to send value, recipient may have reverted");
300         }
301 
302         /**
303         * @dev Performs a Solidity function call using a low level `call`. A
304         * plain`call` is an unsafe replacement for a function call: use this
305         * function instead.
306         *
307         * If `target` reverts with a revert reason, it is bubbled up by this
308         * function (like regular Solidity function calls).
309         *
310         * Returns the raw returned data. To convert to the expected return value,
311         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312         *
313         * Requirements:
314         *
315         * - `target` must be a contract.
316         * - calling `target` with `data` must not revert.
317         *
318         * _Available since v3.1._
319         */
320         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322         }
323 
324         /**
325         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326         * `errorMessage` as a fallback revert reason when `target` reverts.
327         *
328         * _Available since v3.1._
329         */
330         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331             return _functionCallWithValue(target, data, 0, errorMessage);
332         }
333 
334         /**
335         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336         * but also transferring `value` wei to `target`.
337         *
338         * Requirements:
339         *
340         * - the calling contract must have an ETH balance of at least `value`.
341         * - the called Solidity function must be `payable`.
342         *
343         * _Available since v3.1._
344         */
345         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347         }
348 
349         /**
350         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351         * with `errorMessage` as a fallback revert reason when `target` reverts.
352         *
353         * _Available since v3.1._
354         */
355         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356             require(address(this).balance >= value, "Address: insufficient balance for call");
357             return _functionCallWithValue(target, data, value, errorMessage);
358         }
359 
360         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361             require(isContract(target), "Address: call to non-contract");
362 
363             // solhint-disable-next-line avoid-low-level-calls
364             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365             if (success) {
366                 return returndata;
367             } else {
368                 // Look for revert reason and bubble it up if present
369                 if (returndata.length > 0) {
370                     // The easiest way to bubble the revert reason is using memory via assembly
371 
372                     // solhint-disable-next-line no-inline-assembly
373                     assembly {
374                         let returndata_size := mload(returndata)
375                         revert(add(32, returndata), returndata_size)
376                     }
377                 } else {
378                     revert(errorMessage);
379                 }
380             }
381         }
382     }
383 
384     contract Ownable is Context {
385         address private _owner;
386         address private _previousOwner;
387         uint256 private _lockTime;
388 
389         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391         /**
392         * @dev Initializes the contract setting the deployer as the initial owner.
393         */
394         constructor () internal {
395             address msgSender = _msgSender();
396             _owner = msgSender;
397             emit OwnershipTransferred(address(0), msgSender);
398         }
399 
400         /**
401         * @dev Returns the address of the current owner.
402         */
403         function owner() public view returns (address) {
404             return _owner;
405         }
406 
407         /**
408         * @dev Throws if called by any account other than the owner.
409         */
410         modifier onlyOwner() {
411             require(_owner == _msgSender(), "Ownable: caller is not the owner");
412             _;
413         }
414 
415         /**
416         * @dev Leaves the contract without owner. It will not be possible to call
417         * `onlyOwner` functions anymore. Can only be called by the current owner.
418         *
419         * NOTE: Renouncing ownership will leave the contract without an owner,
420         * thereby removing any functionality that is only available to the owner.
421         */
422         function renounceOwnership() public virtual onlyOwner {
423             emit OwnershipTransferred(_owner, address(0));
424             _owner = address(0);
425         }
426 
427         /**
428         * @dev Transfers ownership of the contract to a new account (`newOwner`).
429         * Can only be called by the current owner.
430         */
431         function transferOwnership(address newOwner) public virtual onlyOwner {
432             require(newOwner != address(0), "Ownable: new owner is the zero address");
433             emit OwnershipTransferred(_owner, newOwner);
434             _owner = newOwner;
435         }
436 
437         function geUnlockTime() public view returns (uint256) {
438             return _lockTime;
439         }
440 
441         //Locks the contract for owner for the amount of time provided
442         function lock(uint256 time) public virtual onlyOwner {
443             _previousOwner = _owner;
444             _owner = address(0);
445             _lockTime = now + time;
446             emit OwnershipTransferred(_owner, address(0));
447         }
448 
449         //Unlocks the contract for owner when _lockTime is exceeds
450         function unlock() public virtual {
451             require(_previousOwner == msg.sender, "You don't have permission to unlock");
452             require(now > _lockTime , "Contract is locked until 7 days");
453             emit OwnershipTransferred(_owner, _previousOwner);
454             _owner = _previousOwner;
455         }
456     }
457 
458     interface IUniswapV2Factory {
459         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
460 
461         function feeTo() external view returns (address);
462         function feeToSetter() external view returns (address);
463 
464         function getPair(address tokenA, address tokenB) external view returns (address pair);
465         function allPairs(uint) external view returns (address pair);
466         function allPairsLength() external view returns (uint);
467 
468         function createPair(address tokenA, address tokenB) external returns (address pair);
469 
470         function setFeeTo(address) external;
471         function setFeeToSetter(address) external;
472     }
473 
474     interface IUniswapV2Pair {
475         event Approval(address indexed owner, address indexed spender, uint value);
476         event Transfer(address indexed from, address indexed to, uint value);
477 
478         function name() external pure returns (string memory);
479         function symbol() external pure returns (string memory);
480         function decimals() external pure returns (uint8);
481         function totalSupply() external view returns (uint);
482         function balanceOf(address owner) external view returns (uint);
483         function allowance(address owner, address spender) external view returns (uint);
484 
485         function approve(address spender, uint value) external returns (bool);
486         function transfer(address to, uint value) external returns (bool);
487         function transferFrom(address from, address to, uint value) external returns (bool);
488 
489         function DOMAIN_SEPARATOR() external view returns (bytes32);
490         function PERMIT_TYPEHASH() external pure returns (bytes32);
491         function nonces(address owner) external view returns (uint);
492 
493         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
494 
495         event Mint(address indexed sender, uint amount0, uint amount1);
496         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
497         event Swap(
498             address indexed sender,
499             uint amount0In,
500             uint amount1In,
501             uint amount0Out,
502             uint amount1Out,
503             address indexed to
504         );
505         event Sync(uint112 reserve0, uint112 reserve1);
506 
507         function MINIMUM_LIQUIDITY() external pure returns (uint);
508         function factory() external view returns (address);
509         function token0() external view returns (address);
510         function token1() external view returns (address);
511         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
512         function price0CumulativeLast() external view returns (uint);
513         function price1CumulativeLast() external view returns (uint);
514         function kLast() external view returns (uint);
515 
516         function mint(address to) external returns (uint liquidity);
517         function burn(address to) external returns (uint amount0, uint amount1);
518         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
519         function skim(address to) external;
520         function sync() external;
521 
522         function initialize(address, address) external;
523     }
524 
525     interface IUniswapV2Router01 {
526         function factory() external pure returns (address);
527         function WETH() external pure returns (address);
528 
529         function addLiquidity(
530             address tokenA,
531             address tokenB,
532             uint amountADesired,
533             uint amountBDesired,
534             uint amountAMin,
535             uint amountBMin,
536             address to,
537             uint deadline
538         ) external returns (uint amountA, uint amountB, uint liquidity);
539         function addLiquidityETH(
540             address token,
541             uint amountTokenDesired,
542             uint amountTokenMin,
543             uint amountETHMin,
544             address to,
545             uint deadline
546         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
547         function removeLiquidity(
548             address tokenA,
549             address tokenB,
550             uint liquidity,
551             uint amountAMin,
552             uint amountBMin,
553             address to,
554             uint deadline
555         ) external returns (uint amountA, uint amountB);
556         function removeLiquidityETH(
557             address token,
558             uint liquidity,
559             uint amountTokenMin,
560             uint amountETHMin,
561             address to,
562             uint deadline
563         ) external returns (uint amountToken, uint amountETH);
564         function removeLiquidityWithPermit(
565             address tokenA,
566             address tokenB,
567             uint liquidity,
568             uint amountAMin,
569             uint amountBMin,
570             address to,
571             uint deadline,
572             bool approveMax, uint8 v, bytes32 r, bytes32 s
573         ) external returns (uint amountA, uint amountB);
574         function removeLiquidityETHWithPermit(
575             address token,
576             uint liquidity,
577             uint amountTokenMin,
578             uint amountETHMin,
579             address to,
580             uint deadline,
581             bool approveMax, uint8 v, bytes32 r, bytes32 s
582         ) external returns (uint amountToken, uint amountETH);
583         function swapExactTokensForTokens(
584             uint amountIn,
585             uint amountOutMin,
586             address[] calldata path,
587             address to,
588             uint deadline
589         ) external returns (uint[] memory amounts);
590         function swapTokensForExactTokens(
591             uint amountOut,
592             uint amountInMax,
593             address[] calldata path,
594             address to,
595             uint deadline
596         ) external returns (uint[] memory amounts);
597         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
598             external
599             payable
600             returns (uint[] memory amounts);
601         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
602             external
603             returns (uint[] memory amounts);
604         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
605             external
606             returns (uint[] memory amounts);
607         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
608             external
609             payable
610             returns (uint[] memory amounts);
611 
612         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
613         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
614         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
615         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
616         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
617     }
618 
619     interface IUniswapV2Router02 is IUniswapV2Router01 {
620         function removeLiquidityETHSupportingFeeOnTransferTokens(
621             address token,
622             uint liquidity,
623             uint amountTokenMin,
624             uint amountETHMin,
625             address to,
626             uint deadline
627         ) external returns (uint amountETH);
628         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
629             address token,
630             uint liquidity,
631             uint amountTokenMin,
632             uint amountETHMin,
633             address to,
634             uint deadline,
635             bool approveMax, uint8 v, bytes32 r, bytes32 s
636         ) external returns (uint amountETH);
637 
638         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
639             uint amountIn,
640             uint amountOutMin,
641             address[] calldata path,
642             address to,
643             uint deadline
644         ) external;
645         function swapExactETHForTokensSupportingFeeOnTransferTokens(
646             uint amountOutMin,
647             address[] calldata path,
648             address to,
649             uint deadline
650         ) external payable;
651         function swapExactTokensForETHSupportingFeeOnTransferTokens(
652             uint amountIn,
653             uint amountOutMin,
654             address[] calldata path,
655             address to,
656             uint deadline
657         ) external;
658     }
659 
660     // Contract implementation
661     contract MuskRat is Context, IERC20, Ownable {
662         using SafeMath for uint256;
663         using Address for address;
664 
665         mapping (address => uint256) private _rOwned;
666         mapping (address => uint256) private _tOwned;
667         mapping (address => mapping (address => uint256)) private _allowances;
668         mapping (address => uint256) public timestamp;
669         mapping (address => bool) private _isExcludedFromFee;
670 
671         mapping (address => bool) private _isExcluded;
672         address[] private _excluded;
673         mapping (address => bool) private _isBlackListedBot;
674         address[] private _blackListedBots;
675 
676         uint256 private constant MAX = ~uint256(0);
677         uint256 private _tTotal = 1000000000000000000000;  //1,000,000,000,000
678         uint256 private _rTotal = (MAX - (MAX % _tTotal));
679         uint256 private _tFeeTotal;
680 
681         string private _name = 'MuskRat';
682         string private _symbol = 'MKRAT';
683         uint8 private _decimals = 9;
684 
685         uint256 private _taxFee = 0;
686         uint256 private _devFee = 0;
687         uint256 private _previousTaxFee = _taxFee;
688         uint256 private _previousDevFee = _devFee;
689 
690         address payable public _DevWalletAddress;
691         address payable public _marketingWalletAddress;
692         address payable public _LotteryAddress;
693 
694         IUniswapV2Router02 public immutable uniswapV2Router;
695         address public immutable uniswapV2Pair;
696 
697         bool inSwap = false;
698         bool public swapEnabled = true;
699 
700         uint256 public _MaxSellPercentage = 25;
701         uint256 public _PercentOfMaxTx = 10;
702         uint256 public _SellTimeDelay = 120 minutes;
703         uint256 public _maxTxAmount = 1000000000000000000; //0.1% at start
704         bool public tradingEnabled = false;
705         uint256 private _numOfTokensToExchangeForFee = 5000000000000000;
706 
707         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
708         event SwapEnabledUpdated(bool enabled);
709 
710         modifier lockTheSwap {
711             inSwap = true;
712             _;
713             inSwap = false;
714         }
715 
716         constructor (address payable DevWalletAddress, address payable marketingWalletAddress, address payable LotteryWalletAddress) public {
717             _DevWalletAddress = DevWalletAddress;
718             _marketingWalletAddress = marketingWalletAddress;
719             _LotteryAddress = LotteryWalletAddress;
720             _rOwned[_msgSender()] = _rTotal;
721 
722             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
723             // Create a uniswap pair for this new token
724             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
725                 .createPair(address(this), _uniswapV2Router.WETH());
726 
727             // set the rest of the contract variables
728             uniswapV2Router = _uniswapV2Router;
729 
730             // Exclude owner and this contract from fee
731             _isExcludedFromFee[owner()] = true;
732             
733             _isExcludedFromFee[_DevWalletAddress] = true;
734             _isExcludedFromFee[_marketingWalletAddress] = true;
735             _isExcludedFromFee[_LotteryAddress] = true;
736             
737             _isExcludedFromFee[address(this)] = true;
738 
739             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
740             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
741 
742 
743 
744             emit Transfer(address(0), _msgSender(), _tTotal);
745         }
746 
747         function name() public view returns (string memory) {
748             return _name;
749         }
750 
751         function symbol() public view returns (string memory) {
752             return _symbol;
753         }
754 
755         function decimals() public view returns (uint8) {
756             return _decimals;
757         }
758 
759         function totalSupply() public view override returns (uint256) {
760             return _tTotal;
761         }
762 
763         function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
764              tradingEnabled = _tradingEnabled;
765          }
766 
767          function getSwapPercent(uint part, uint whole) public pure returns(uint percent) {
768              uint numerator = part * 1000;
769              require(numerator > part); // overflow. 
770              uint temp = numerator / whole + 5; // proper rounding up
771              return temp / 10;
772          }
773 
774 
775 
776       function NextSellTime(address _key) public view returns (uint) {
777              return timestamp[_key];
778 
779       }
780 
781         function balanceOf(address account) public view override returns (uint256) {
782             if (_isExcluded[account]) return _tOwned[account];
783             return tokenFromReflection(_rOwned[account]);
784         }
785 
786         function transfer(address recipient, uint256 amount) public override returns (bool) {
787             _transfer(_msgSender(), recipient, amount);
788             return true;
789         }
790 
791         function allowance(address owner, address spender) public view override returns (uint256) {
792             return _allowances[owner][spender];
793         }
794 
795         function approve(address spender, uint256 amount) public override returns (bool) {
796             _approve(_msgSender(), spender, amount);
797             return true;
798         }
799 
800         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
801             _transfer(sender, recipient, amount);
802             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
803             return true;
804         }
805 
806         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
807             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
808             return true;
809         }
810 
811         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
812             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
813             return true;
814         }
815 
816         function isExcluded(address account) public view returns (bool) {
817             return _isExcluded[account];
818         }
819 
820         function isBlackListed(address account) public view returns (bool) {
821             return _isBlackListedBot[account];
822         }
823 
824         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
825             _isExcludedFromFee[account] = excluded;
826         }
827 
828         function totalFees() public view returns (uint256) {
829             return _tFeeTotal;
830         }
831 
832         function deliver(uint256 tAmount) public {
833             address sender = _msgSender();
834             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
835             (uint256 rAmount,,,,,) = _getValues(tAmount);
836             _rOwned[sender] = _rOwned[sender].sub(rAmount);
837             _rTotal = _rTotal.sub(rAmount);
838             _tFeeTotal = _tFeeTotal.add(tAmount);
839         }
840 
841         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
842             require(tAmount <= _tTotal, "Amount must be less than supply");
843             if (!deductTransferFee) {
844                 (uint256 rAmount,,,,,) = _getValues(tAmount);
845                 return rAmount;
846             } else {
847                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
848                 return rTransferAmount;
849             }
850         }
851 
852         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
853             require(rAmount <= _rTotal, "Amount must be less than total reflections");
854             uint256 currentRate =  _getRate();
855             return rAmount.div(currentRate);
856         }
857 
858         function excludeAccount(address account) external onlyOwner() {
859             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
860             require(!_isExcluded[account], "Account is already excluded");
861             if(_rOwned[account] > 0) {
862                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
863             }
864             _isExcluded[account] = true;
865             _excluded.push(account);
866         }
867 
868         function includeAccount(address account) external onlyOwner() {
869             require(_isExcluded[account], "Account is already excluded");
870             for (uint256 i = 0; i < _excluded.length; i++) {
871                 if (_excluded[i] == account) {
872                     _excluded[i] = _excluded[_excluded.length - 1];
873                     _tOwned[account] = 0;
874                     _isExcluded[account] = false;
875                     _excluded.pop();
876                     break;
877                 }
878             }
879         }
880 
881         function addBotToBlackList(address account) external onlyOwner() {
882             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
883             require(!_isBlackListedBot[account], "Account is already blacklisted");
884             _isBlackListedBot[account] = true;
885             _blackListedBots.push(account);
886         }
887 
888         function removeBotFromBlackList(address account) external onlyOwner() {
889             require(_isBlackListedBot[account], "Account is not blacklisted");
890             for (uint256 i = 0; i < _blackListedBots.length; i++) {
891                 if (_blackListedBots[i] == account) {
892                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
893                     _isBlackListedBot[account] = false;
894                     _blackListedBots.pop();
895                     break;
896                 }
897             }
898         }
899 
900         function removeAllFee() private {
901             if(_taxFee == 0 && _devFee == 0) return;
902 
903             _previousTaxFee = _taxFee;
904             _previousDevFee = _devFee;
905 
906             _taxFee = 0;
907             _devFee = 0;
908         }
909 
910         function restoreAllFee() private {
911             _taxFee = _previousTaxFee;
912             _devFee = _previousDevFee;
913         }
914 
915         function isExcludedFromFee(address account) public view returns(bool) {
916             return _isExcludedFromFee[account];
917         }
918 
919             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
920         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
921             10**2
922         );
923         }
924 
925         function setMaxSellPercent(uint256 maxSellPercent) external onlyOwner() {
926             _MaxSellPercentage = maxSellPercent;
927             }
928             
929          function setPercentOfMaxTx(uint256 PercentOfMaxTx) external onlyOwner() {
930             _PercentOfMaxTx = PercentOfMaxTx;
931             }
932             
933             
934          
935          function setSellTimeDelay(uint256 SellTimeDelay) external onlyOwner() {
936             _SellTimeDelay = (SellTimeDelay * 1 minutes);
937             }    
938 
939         
940    
941    
942         function _approve(address owner, address spender, uint256 amount) private {
943             require(owner != address(0), "ERC20: approve from the zero address");
944             require(spender != address(0), "ERC20: approve to the zero address");
945 
946             _allowances[owner][spender] = amount;
947             emit Approval(owner, spender, amount);
948         }
949 
950         function _transfer(address sender, address recipient, uint256 amount) private {
951             require(sender != address(0), "ERC20: transfer from the zero address");
952             require(recipient != address(0), "ERC20: transfer to the zero address");
953             require(amount > 0, "Transfer amount must be greater than zero");
954             require(!_isBlackListedBot[recipient], "You are dead to me");
955             require(!_isBlackListedBot[msg.sender], "You are dead to me");
956 
957             if(sender != owner() && recipient != owner())
958             {
959                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
960 
961               //you can't trade this on a dex until trading enabled, just be patient we're probably still in presale
962               if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled yet");}
963 
964                 
965             }    
966 
967                 // exclude owner and uniswap
968               if(sender != owner() && sender != uniswapV2Pair) {
969 
970 
971                   // dont apply below rules to excluded addresses like presale contracts etc
972 
973 
974                   if (!_isExcluded[sender]) {
975 
976                     //don't apply rules to lottery address
977                     if (recipient != _LotteryAddress) {     
978                          
979                           // lets check last sell was more than 90 mins ago
980                           require(block.timestamp >= timestamp[sender], "Everyone is vested!");
981 
982                           // lets check here for more than 25% balance per swap - but first check they don't hold a very small amount we could just let through
983                           if (getSwapPercent(balanceOf(sender),_maxTxAmount) > _PercentOfMaxTx ){
984 
985                               //now we know user has higher than 10% of max tx allowed, otherwise we can just let them swap as amount is tiny
986                               require(getSwapPercent(amount, balanceOf(sender)) <= _MaxSellPercentage, "You cannot trade more than MaxSell per swap");
987                           }
988 
989                           //add a 90 minute timestamp to current block until next swap
990                           timestamp[sender] = block.timestamp.add(_SellTimeDelay);
991                           
992                     }      
993 
994                   }
995 
996               }
997 
998             // is the token balance of this contract address over the min number of
999             // tokens that we need to initiate a swap?
1000             // also, don't get caught in a circular charity event.
1001             // also, don't swap if sender is uniswap pair.
1002             uint256 contractTokenBalance = balanceOf(address(this));
1003 
1004             if(contractTokenBalance >= _maxTxAmount)
1005             {
1006                 contractTokenBalance = _maxTxAmount;
1007             }
1008 
1009             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForFee;
1010             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1011                 // We need to swap the current tokens to ETH and send to the fees wallet
1012                 swapTokensForEth(contractTokenBalance);
1013 
1014                 uint256 contractETHBalance = address(this).balance;
1015                 if(contractETHBalance > 0) {
1016                     sendETHToFees(address(this).balance);
1017                 }
1018             }
1019 
1020             //indicates if fee should be deducted from transfer
1021             bool takeFee = true;
1022 
1023             //if any account belongs to _isExcludedFromFee account then remove the fee
1024             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1025                 takeFee = false;
1026             }
1027 
1028             //transfer amount, it will take tax and charity fee
1029             _tokenTransfer(sender,recipient,amount,takeFee);
1030         }
1031 
1032         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1033             // generate the uniswap pair path of token -> weth
1034             address[] memory path = new address[](2);
1035             path[0] = address(this);
1036             path[1] = uniswapV2Router.WETH();
1037 
1038             _approve(address(this), address(uniswapV2Router), tokenAmount);
1039 
1040             // make the swap
1041             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1042                 tokenAmount,
1043                 0, // accept any amount of ETH
1044                 path,
1045                 address(this),
1046                 block.timestamp
1047             );
1048         }
1049 
1050         function sendETHToFees(uint256 amount) private {
1051             _DevWalletAddress.transfer(amount.div(3));
1052             _marketingWalletAddress.transfer(amount.div(3));
1053             _LotteryAddress.send(amount.div(3));
1054         }
1055 
1056         // We are exposing these functions to be able to manual swap and send
1057         // in case the token is highly valued and 5M becomes too much
1058         function manualSwap() external onlyOwner() {
1059             uint256 contractBalance = balanceOf(address(this));
1060             swapTokensForEth(contractBalance);
1061         }
1062 
1063         function manualSend() external onlyOwner() {
1064             uint256 contractETHBalance = address(this).balance;
1065             sendETHToFees(contractETHBalance);
1066         }
1067 
1068         function setSwapEnabled(bool enabled) external onlyOwner(){
1069             swapEnabled = enabled;
1070         }
1071 
1072         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1073             if(!takeFee)
1074                 removeAllFee();
1075 
1076             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1077                 _transferFromExcluded(sender, recipient, amount);
1078             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1079                 _transferToExcluded(sender, recipient, amount);
1080             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1081                 _transferStandard(sender, recipient, amount);
1082             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1083                 _transferBothExcluded(sender, recipient, amount);
1084             } else {
1085                 _transferStandard(sender, recipient, amount);
1086             }
1087 
1088             if(!takeFee)
1089                 restoreAllFee();
1090         }
1091 
1092         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1093             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1094             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1095             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1096             _takeFee(tCharity);
1097             _reflectFee(rFee, tFee);
1098             emit Transfer(sender, recipient, tTransferAmount);
1099         }
1100 
1101         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1102             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1103             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1104             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1105             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1106             _takeFee(tCharity);
1107             _reflectFee(rFee, tFee);
1108             emit Transfer(sender, recipient, tTransferAmount);
1109         }
1110 
1111         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1112             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1113             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1114             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1115             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1116             _takeFee(tCharity);
1117             _reflectFee(rFee, tFee);
1118             emit Transfer(sender, recipient, tTransferAmount);
1119         }
1120 
1121         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1122             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1123             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1124             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1125             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1126             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1127             _takeFee(tCharity);
1128             _reflectFee(rFee, tFee);
1129             emit Transfer(sender, recipient, tTransferAmount);
1130         }
1131 
1132         function _takeFee(uint256 tCharity) private {
1133             uint256 currentRate =  _getRate();
1134             uint256 rCharity = tCharity.mul(currentRate);
1135             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1136             if(_isExcluded[address(this)])
1137                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1138         }
1139 
1140         function _reflectFee(uint256 rFee, uint256 tFee) private {
1141             _rTotal = _rTotal.sub(rFee);
1142             _tFeeTotal = _tFeeTotal.add(tFee);
1143         }
1144 
1145          //to recieve ETH from uniswapV2Router when swaping
1146         receive() external payable {}
1147 
1148         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1149             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _devFee);
1150             uint256 currentRate =  _getRate();
1151             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1152             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1153         }
1154 
1155         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 devFee) private pure returns (uint256, uint256, uint256) {
1156             uint256 tFee = tAmount.mul(taxFee).div(100);
1157             uint256 tCharity = tAmount.mul(devFee).div(100);
1158             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1159             return (tTransferAmount, tFee, tCharity);
1160         }
1161 
1162         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1163             uint256 rAmount = tAmount.mul(currentRate);
1164             uint256 rFee = tFee.mul(currentRate);
1165             uint256 rTransferAmount = rAmount.sub(rFee);
1166             return (rAmount, rTransferAmount, rFee);
1167         }
1168 
1169         function _getRate() private view returns(uint256) {
1170             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1171             return rSupply.div(tSupply);
1172         }
1173 
1174         function _getCurrentSupply() private view returns(uint256, uint256) {
1175             uint256 rSupply = _rTotal;
1176             uint256 tSupply = _tTotal;
1177             for (uint256 i = 0; i < _excluded.length; i++) {
1178                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1179                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1180                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1181             }
1182             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1183             return (rSupply, tSupply);
1184         }
1185 
1186         function _getTaxFee() private view returns(uint256) {
1187             return _taxFee;
1188         }
1189 
1190         function _getMaxTxAmount() private view returns(uint256) {
1191             return _maxTxAmount;
1192         }
1193 
1194         function _getETHBalance() public view returns(uint256 balance) {
1195             return address(this).balance;
1196         }
1197 
1198         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1199             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1200             _taxFee = taxFee;
1201         }
1202 
1203         function _setDevFee(uint256 devFee) external onlyOwner() {
1204             require(devFee >= 1 && devFee <= 11, 'devFee should be in 1 - 11');
1205             _devFee = devFee;
1206         }
1207 
1208         function _setDevWallet(address payable DevWalletAddress) external onlyOwner() {
1209             _DevWalletAddress = DevWalletAddress;
1210         }
1211         
1212          function _setLotteryWallet(address payable LotteryWalletAddress) external onlyOwner() {
1213             _LotteryAddress = LotteryWalletAddress;
1214         }
1215         
1216         function _setMarketingWallet(address payable MarketingWalletAddress) external onlyOwner() {
1217             _marketingWalletAddress = MarketingWalletAddress;
1218         }
1219         
1220          function _setNumFeeTokens(uint256 NumTokens) external onlyOwner() {
1221             _numOfTokensToExchangeForFee = NumTokens;
1222         }
1223 
1224     }