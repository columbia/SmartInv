1 /**
2 
3 /$$$$$$$            /$$                       /$$$$$$$                      /$$
4 | $$__  $$          | $$                      | $$__  $$                    | $$
5 | $$  \ $$  /$$$$$$ | $$$$$$$  /$$   /$$      | $$  \ $$ /$$   /$$ /$$$$$$$ | $$   /$$  /$$$$$$$
6 | $$$$$$$  |____  $$| $$__  $$| $$  | $$      | $$$$$$$/| $$  | $$| $$__  $$| $$  /$$/ /$$_____/
7 | $$__  $$  /$$$$$$$| $$  \ $$| $$  | $$      | $$____/ | $$  | $$| $$  \ $$| $$$$$$/ |  $$$$$$
8 | $$  \ $$ /$$__  $$| $$  | $$| $$  | $$      | $$      | $$  | $$| $$  | $$| $$_  $$  \____  $$
9 | $$$$$$$/|  $$$$$$$| $$$$$$$/|  $$$$$$$      | $$      |  $$$$$$/| $$  | $$| $$ \  $$ /$$$$$$$/
10 |_______/  \_______/|_______/  \____  $$      |__/       \______/ |__/  |__/|__/  \__/|_______/
11                               /$$  | $$
12                              |  $$$$$$/
13                               \______/
14 */
15 
16 pragma solidity ^0.6.12;
17 
18     abstract contract Context {
19         function _msgSender() internal view virtual returns (address payable) {
20             return msg.sender;
21         }
22 
23         function _msgData() internal view virtual returns (bytes memory) {
24             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25             return msg.data;
26         }
27     }
28 
29     interface IERC20 {
30         /**
31         * @dev Returns the amount of tokens in existence.
32         */
33         function totalSupply() external view returns (uint256);
34 
35         /**
36         * @dev Returns the amount of tokens owned by `account`.
37         */
38         function balanceOf(address account) external view returns (uint256);
39 
40         /**
41         * @dev Moves `amount` tokens from the caller's account to `recipient`.
42         *
43         * Returns a boolean value indicating whether the operation succeeded.
44         *
45         * Emits a {Transfer} event.
46         */
47         function transfer(address recipient, uint256 amount) external returns (bool);
48 
49         /**
50         * @dev Returns the remaining number of tokens that `spender` will be
51         * allowed to spend on behalf of `owner` through {transferFrom}. This is
52         * zero by default.
53         *
54         * This value changes when {approve} or {transferFrom} are called.
55         */
56         function allowance(address owner, address spender) external view returns (uint256);
57 
58         /**
59         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60         *
61         * Returns a boolean value indicating whether the operation succeeded.
62         *
63         * IMPORTANT: Beware that changing an allowance with this method brings the risk
64         * that someone may use both the old and the new allowance by unfortunate
65         * transaction ordering. One possible solution to mitigate this race
66         * condition is to first reduce the spender's allowance to 0 and set the
67         * desired value afterwards:
68         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69         *
70         * Emits an {Approval} event.
71         */
72         function approve(address spender, uint256 amount) external returns (bool);
73 
74         /**
75         * @dev Moves `amount` tokens from `sender` to `recipient` using the
76         * allowance mechanism. `amount` is then deducted from the caller's
77         * allowance.
78         *
79         * Returns a boolean value indicating whether the operation succeeded.
80         *
81         * Emits a {Transfer} event.
82         */
83         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85         /**
86         * @dev Emitted when `value` tokens are moved from one account (`from`) to
87         * another (`to`).
88         *
89         * Note that `value` may be zero.
90         */
91         event Transfer(address indexed from, address indexed to, uint256 value);
92 
93         /**
94         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95         * a call to {approve}. `value` is the new allowance.
96         */
97         event Approval(address indexed owner, address indexed spender, uint256 value);
98     }
99 
100     library SafeMath {
101         /**
102         * @dev Returns the addition of two unsigned integers, reverting on
103         * overflow.
104         *
105         * Counterpart to Solidity's `+` operator.
106         *
107         * Requirements:
108         *
109         * - Addition cannot overflow.
110         */
111         function add(uint256 a, uint256 b) internal pure returns (uint256) {
112             uint256 c = a + b;
113             require(c >= a, "SafeMath: addition overflow");
114 
115             return c;
116         }
117 
118         /**
119         * @dev Returns the subtraction of two unsigned integers, reverting on
120         * overflow (when the result is negative).
121         *
122         * Counterpart to Solidity's `-` operator.
123         *
124         * Requirements:
125         *
126         * - Subtraction cannot overflow.
127         */
128         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129             return sub(a, b, "SafeMath: subtraction overflow");
130         }
131 
132         /**
133         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134         * overflow (when the result is negative).
135         *
136         * Counterpart to Solidity's `-` operator.
137         *
138         * Requirements:
139         *
140         * - Subtraction cannot overflow.
141         */
142         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143             require(b <= a, errorMessage);
144             uint256 c = a - b;
145 
146             return c;
147         }
148 
149         /**
150         * @dev Returns the multiplication of two unsigned integers, reverting on
151         * overflow.
152         *
153         * Counterpart to Solidity's `*` operator.
154         *
155         * Requirements:
156         *
157         * - Multiplication cannot overflow.
158         */
159         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161             // benefit is lost if 'b' is also tested.
162             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163             if (a == 0) {
164                 return 0;
165             }
166 
167             uint256 c = a * b;
168             require(c / a == b, "SafeMath: multiplication overflow");
169 
170             return c;
171         }
172 
173         /**
174         * @dev Returns the integer division of two unsigned integers. Reverts on
175         * division by zero. The result is rounded towards zero.
176         *
177         * Counterpart to Solidity's `/` operator. Note: this function uses a
178         * `revert` opcode (which leaves remaining gas untouched) while Solidity
179         * uses an invalid opcode to revert (consuming all remaining gas).
180         *
181         * Requirements:
182         *
183         * - The divisor cannot be zero.
184         */
185         function div(uint256 a, uint256 b) internal pure returns (uint256) {
186             return div(a, b, "SafeMath: division by zero");
187         }
188 
189         /**
190         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191         * division by zero. The result is rounded towards zero.
192         *
193         * Counterpart to Solidity's `/` operator. Note: this function uses a
194         * `revert` opcode (which leaves remaining gas untouched) while Solidity
195         * uses an invalid opcode to revert (consuming all remaining gas).
196         *
197         * Requirements:
198         *
199         * - The divisor cannot be zero.
200         */
201         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202             require(b > 0, errorMessage);
203             uint256 c = a / b;
204             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206             return c;
207         }
208 
209         /**
210         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211         * Reverts when dividing by zero.
212         *
213         * Counterpart to Solidity's `%` operator. This function uses a `revert`
214         * opcode (which leaves remaining gas untouched) while Solidity uses an
215         * invalid opcode to revert (consuming all remaining gas).
216         *
217         * Requirements:
218         *
219         * - The divisor cannot be zero.
220         */
221         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222             return mod(a, b, "SafeMath: modulo by zero");
223         }
224 
225         /**
226         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227         * Reverts with custom message when dividing by zero.
228         *
229         * Counterpart to Solidity's `%` operator. This function uses a `revert`
230         * opcode (which leaves remaining gas untouched) while Solidity uses an
231         * invalid opcode to revert (consuming all remaining gas).
232         *
233         * Requirements:
234         *
235         * - The divisor cannot be zero.
236         */
237         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238             require(b != 0, errorMessage);
239             return a % b;
240         }
241     }
242 
243     library Address {
244         /**
245         * @dev Returns true if `account` is a contract.
246         *
247         * [IMPORTANT]
248         * ====
249         * It is unsafe to assume that an address for which this function returns
250         * false is an externally-owned account (EOA) and not a contract.
251         *
252         * Among others, `isContract` will return false for the following
253         * types of addresses:
254         *
255         *  - an externally-owned account
256         *  - a contract in construction
257         *  - an address where a contract will be created
258         *  - an address where a contract lived, but was destroyed
259         * ====
260         */
261         function isContract(address account) internal view returns (bool) {
262             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264             // for accounts without code, i.e. `keccak256('')`
265             bytes32 codehash;
266             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
267             // solhint-disable-next-line no-inline-assembly
268             assembly { codehash := extcodehash(account) }
269             return (codehash != accountHash && codehash != 0x0);
270         }
271 
272         /**
273         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274         * `recipient`, forwarding all available gas and reverting on errors.
275         *
276         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277         * of certain opcodes, possibly making contracts go over the 2300 gas limit
278         * imposed by `transfer`, making them unable to receive funds via
279         * `transfer`. {sendValue} removes this limitation.
280         *
281         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282         *
283         * IMPORTANT: because control is transferred to `recipient`, care must be
284         * taken to not create reentrancy vulnerabilities. Consider using
285         * {ReentrancyGuard} or the
286         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287         */
288         function sendValue(address payable recipient, uint256 amount) internal {
289             require(address(this).balance >= amount, "Address: insufficient balance");
290 
291             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
292             (bool success, ) = recipient.call{ value: amount }("");
293             require(success, "Address: unable to send value, recipient may have reverted");
294         }
295 
296         /**
297         * @dev Performs a Solidity function call using a low level `call`. A
298         * plain`call` is an unsafe replacement for a function call: use this
299         * function instead.
300         *
301         * If `target` reverts with a revert reason, it is bubbled up by this
302         * function (like regular Solidity function calls).
303         *
304         * Returns the raw returned data. To convert to the expected return value,
305         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
306         *
307         * Requirements:
308         *
309         * - `target` must be a contract.
310         * - calling `target` with `data` must not revert.
311         *
312         * _Available since v3.1._
313         */
314         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionCall(target, data, "Address: low-level call failed");
316         }
317 
318         /**
319         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
320         * `errorMessage` as a fallback revert reason when `target` reverts.
321         *
322         * _Available since v3.1._
323         */
324         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
325             return _functionCallWithValue(target, data, 0, errorMessage);
326         }
327 
328         /**
329         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330         * but also transferring `value` wei to `target`.
331         *
332         * Requirements:
333         *
334         * - the calling contract must have an ETH balance of at least `value`.
335         * - the called Solidity function must be `payable`.
336         *
337         * _Available since v3.1._
338         */
339         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
340             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341         }
342 
343         /**
344         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345         * with `errorMessage` as a fallback revert reason when `target` reverts.
346         *
347         * _Available since v3.1._
348         */
349         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
350             require(address(this).balance >= value, "Address: insufficient balance for call");
351             return _functionCallWithValue(target, data, value, errorMessage);
352         }
353 
354         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
355             require(isContract(target), "Address: call to non-contract");
356 
357             // solhint-disable-next-line avoid-low-level-calls
358             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
359             if (success) {
360                 return returndata;
361             } else {
362                 // Look for revert reason and bubble it up if present
363                 if (returndata.length > 0) {
364                     // The easiest way to bubble the revert reason is using memory via assembly
365 
366                     // solhint-disable-next-line no-inline-assembly
367                     assembly {
368                         let returndata_size := mload(returndata)
369                         revert(add(32, returndata), returndata_size)
370                     }
371                 } else {
372                     revert(errorMessage);
373                 }
374             }
375         }
376     }
377 
378     contract Ownable is Context {
379         address private _owner;
380         address private _previousOwner;
381         uint256 private _lockTime;
382 
383         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
384 
385         /**
386         * @dev Initializes the contract setting the deployer as the initial owner.
387         */
388         constructor () internal {
389             address msgSender = _msgSender();
390             _owner = msgSender;
391             emit OwnershipTransferred(address(0), msgSender);
392         }
393 
394         /**
395         * @dev Returns the address of the current owner.
396         */
397         function owner() public view returns (address) {
398             return _owner;
399         }
400 
401         /**
402         * @dev Throws if called by any account other than the owner.
403         */
404         modifier onlyOwner() {
405             require(_owner == _msgSender(), "Ownable: caller is not the owner");
406             _;
407         }
408 
409         /**
410         * @dev Leaves the contract without owner. It will not be possible to call
411         * `onlyOwner` functions anymore. Can only be called by the current owner.
412         *
413         * NOTE: Renouncing ownership will leave the contract without an owner,
414         * thereby removing any functionality that is only available to the owner.
415         */
416         function renounceOwnership() public virtual onlyOwner {
417             emit OwnershipTransferred(_owner, address(0));
418             _owner = address(0);
419         }
420 
421         /**
422         * @dev Transfers ownership of the contract to a new account (`newOwner`).
423         * Can only be called by the current owner.
424         */
425         function transferOwnership(address newOwner) public virtual onlyOwner {
426             require(newOwner != address(0), "Ownable: new owner is the zero address");
427             emit OwnershipTransferred(_owner, newOwner);
428             _owner = newOwner;
429         }
430 
431         function geUnlockTime() public view returns (uint256) {
432             return _lockTime;
433         }
434 
435         //Locks the contract for owner for the amount of time provided
436         function lock(uint256 time) public virtual onlyOwner {
437             _previousOwner = _owner;
438             _owner = address(0);
439             _lockTime = now + time;
440             emit OwnershipTransferred(_owner, address(0));
441         }
442 
443         //Unlocks the contract for owner when _lockTime is exceeds
444         function unlock() public virtual {
445             require(_previousOwner == msg.sender, "You don't have permission to unlock");
446             require(now > _lockTime , "Contract is locked until 7 days");
447             emit OwnershipTransferred(_owner, _previousOwner);
448             _owner = _previousOwner;
449         }
450     }
451 
452     interface IUniswapV2Factory {
453         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
454 
455         function feeTo() external view returns (address);
456         function feeToSetter() external view returns (address);
457 
458         function getPair(address tokenA, address tokenB) external view returns (address pair);
459         function allPairs(uint) external view returns (address pair);
460         function allPairsLength() external view returns (uint);
461 
462         function createPair(address tokenA, address tokenB) external returns (address pair);
463 
464         function setFeeTo(address) external;
465         function setFeeToSetter(address) external;
466     }
467 
468     interface IUniswapV2Pair {
469         event Approval(address indexed owner, address indexed spender, uint value);
470         event Transfer(address indexed from, address indexed to, uint value);
471 
472         function name() external pure returns (string memory);
473         function symbol() external pure returns (string memory);
474         function decimals() external pure returns (uint8);
475         function totalSupply() external view returns (uint);
476         function balanceOf(address owner) external view returns (uint);
477         function allowance(address owner, address spender) external view returns (uint);
478 
479         function approve(address spender, uint value) external returns (bool);
480         function transfer(address to, uint value) external returns (bool);
481         function transferFrom(address from, address to, uint value) external returns (bool);
482 
483         function DOMAIN_SEPARATOR() external view returns (bytes32);
484         function PERMIT_TYPEHASH() external pure returns (bytes32);
485         function nonces(address owner) external view returns (uint);
486 
487         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
488 
489         event Mint(address indexed sender, uint amount0, uint amount1);
490         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
491         event Swap(
492             address indexed sender,
493             uint amount0In,
494             uint amount1In,
495             uint amount0Out,
496             uint amount1Out,
497             address indexed to
498         );
499         event Sync(uint112 reserve0, uint112 reserve1);
500 
501         function MINIMUM_LIQUIDITY() external pure returns (uint);
502         function factory() external view returns (address);
503         function token0() external view returns (address);
504         function token1() external view returns (address);
505         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
506         function price0CumulativeLast() external view returns (uint);
507         function price1CumulativeLast() external view returns (uint);
508         function kLast() external view returns (uint);
509 
510         function mint(address to) external returns (uint liquidity);
511         function burn(address to) external returns (uint amount0, uint amount1);
512         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
513         function skim(address to) external;
514         function sync() external;
515 
516         function initialize(address, address) external;
517     }
518 
519     interface IUniswapV2Router01 {
520         function factory() external pure returns (address);
521         function WETH() external pure returns (address);
522 
523         function addLiquidity(
524             address tokenA,
525             address tokenB,
526             uint amountADesired,
527             uint amountBDesired,
528             uint amountAMin,
529             uint amountBMin,
530             address to,
531             uint deadline
532         ) external returns (uint amountA, uint amountB, uint liquidity);
533         function addLiquidityETH(
534             address token,
535             uint amountTokenDesired,
536             uint amountTokenMin,
537             uint amountETHMin,
538             address to,
539             uint deadline
540         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
541         function removeLiquidity(
542             address tokenA,
543             address tokenB,
544             uint liquidity,
545             uint amountAMin,
546             uint amountBMin,
547             address to,
548             uint deadline
549         ) external returns (uint amountA, uint amountB);
550         function removeLiquidityETH(
551             address token,
552             uint liquidity,
553             uint amountTokenMin,
554             uint amountETHMin,
555             address to,
556             uint deadline
557         ) external returns (uint amountToken, uint amountETH);
558         function removeLiquidityWithPermit(
559             address tokenA,
560             address tokenB,
561             uint liquidity,
562             uint amountAMin,
563             uint amountBMin,
564             address to,
565             uint deadline,
566             bool approveMax, uint8 v, bytes32 r, bytes32 s
567         ) external returns (uint amountA, uint amountB);
568         function removeLiquidityETHWithPermit(
569             address token,
570             uint liquidity,
571             uint amountTokenMin,
572             uint amountETHMin,
573             address to,
574             uint deadline,
575             bool approveMax, uint8 v, bytes32 r, bytes32 s
576         ) external returns (uint amountToken, uint amountETH);
577         function swapExactTokensForTokens(
578             uint amountIn,
579             uint amountOutMin,
580             address[] calldata path,
581             address to,
582             uint deadline
583         ) external returns (uint[] memory amounts);
584         function swapTokensForExactTokens(
585             uint amountOut,
586             uint amountInMax,
587             address[] calldata path,
588             address to,
589             uint deadline
590         ) external returns (uint[] memory amounts);
591         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
592             external
593             payable
594             returns (uint[] memory amounts);
595         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
596             external
597             returns (uint[] memory amounts);
598         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
599             external
600             returns (uint[] memory amounts);
601         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
602             external
603             payable
604             returns (uint[] memory amounts);
605 
606         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
607         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
608         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
609         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
610         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
611     }
612 
613     interface IUniswapV2Router02 is IUniswapV2Router01 {
614         function removeLiquidityETHSupportingFeeOnTransferTokens(
615             address token,
616             uint liquidity,
617             uint amountTokenMin,
618             uint amountETHMin,
619             address to,
620             uint deadline
621         ) external returns (uint amountETH);
622         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
623             address token,
624             uint liquidity,
625             uint amountTokenMin,
626             uint amountETHMin,
627             address to,
628             uint deadline,
629             bool approveMax, uint8 v, bytes32 r, bytes32 s
630         ) external returns (uint amountETH);
631 
632         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
633             uint amountIn,
634             uint amountOutMin,
635             address[] calldata path,
636             address to,
637             uint deadline
638         ) external;
639         function swapExactETHForTokensSupportingFeeOnTransferTokens(
640             uint amountOutMin,
641             address[] calldata path,
642             address to,
643             uint deadline
644         ) external payable;
645         function swapExactTokensForETHSupportingFeeOnTransferTokens(
646             uint amountIn,
647             uint amountOutMin,
648             address[] calldata path,
649             address to,
650             uint deadline
651         ) external;
652     }
653 
654     // Contract implementation
655     contract BabyPunks is Context, IERC20, Ownable {
656         using SafeMath for uint256;
657         using Address for address;
658 
659         mapping (address => uint256) private _rOwned;
660         mapping (address => uint256) private _tOwned;
661         mapping (address => mapping (address => uint256)) private _allowances;
662 
663         mapping (address => bool) private _isExcludedFromFee;
664 
665         mapping (address => bool) private _isExcluded;
666         address[] private _excluded;
667         mapping (address => bool) private _isBlackListedBot;
668         address[] private _blackListedBots;
669 
670         event ExcludeFromFee(address indexed account, bool isExcluded);
671 
672 event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
673 
674         uint256 private constant MAX = ~uint256(0);
675         uint256 private _tTotal = 10000 * 10**18;  //10,000
676         uint256 private _rTotal = (MAX - (MAX % _tTotal));
677         uint256 private _tFeeTotal;
678 
679         string private _name = 'BabyPunks';
680         string private _symbol = 'BPUNKS';
681         uint8 private _decimals = 18;
682 
683         // Tax and Punk fees will start at 0 so we don't have a big impact when deploying to Uniswap
684         // Punk wallet address is null but the method to set the address is exposed
685         uint256 public _taxFee = 1;
686         uint256 private _PunkFee = 30;
687         uint256 private _previousTaxFee = _taxFee;
688         uint256 private _previousPunkFee = _PunkFee;
689 
690         address payable public _PunkWalletAddress;
691         address payable public _marketingWalletAddress;
692 
693         IUniswapV2Router02 public immutable uniswapV2Router;
694         address public immutable uniswapV2Pair;
695 
696         bool inSwap = false;
697         bool public swapEnabled = true;
698 
699         uint256 public _maxTxAmount = 200 * 10**18; //no max tx limit rn
700 
701         uint256 private _numOfTokensToExchangeForPunk = 5 * 10**15;
702 
703         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
704         event SwapEnabledUpdated(bool enabled);
705 
706         modifier lockTheSwap {
707             inSwap = true;
708             _;
709             inSwap = false;
710         }
711 
712         constructor (address payable PunkWalletAddress, address payable marketingWalletAddress) public {
713             _PunkWalletAddress = PunkWalletAddress;
714             _marketingWalletAddress = marketingWalletAddress;
715             _rOwned[_msgSender()] = _rTotal;
716 
717             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
718             // Create a uniswap pair for this new token
719             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
720                 .createPair(address(this), _uniswapV2Router.WETH());
721 
722             // set the rest of the contract variables
723             uniswapV2Router = _uniswapV2Router;
724 
725             // Exclude owner and this contract from fee
726             _isExcludedFromFee[owner()] = true;
727             _isExcludedFromFee[address(this)] = true;
728             _isExcludedFromFee[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)] = true;
729 
730 
731 
732 
733             emit Transfer(address(0), _msgSender(), _tTotal);
734         }
735 
736         function name() public view returns (string memory) {
737             return _name;
738         }
739 
740         function symbol() public view returns (string memory) {
741             return _symbol;
742         }
743 
744         function decimals() public view returns (uint8) {
745             return _decimals;
746         }
747 
748         function totalSupply() public view override returns (uint256) {
749             return _tTotal;
750         }
751 
752         function balanceOf(address account) public view override returns (uint256) {
753             if (_isExcluded[account]) return _tOwned[account];
754             return tokenFromReflection(_rOwned[account]);
755         }
756 
757         function transfer(address recipient, uint256 amount) public override returns (bool) {
758             _transfer(_msgSender(), recipient, amount);
759             return true;
760         }
761 
762         function allowance(address owner, address spender) public view override returns (uint256) {
763             return _allowances[owner][spender];
764         }
765 
766         function approve(address spender, uint256 amount) public override returns (bool) {
767             _approve(_msgSender(), spender, amount);
768             return true;
769         }
770 
771         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
772             _transfer(sender, recipient, amount);
773             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
774             return true;
775         }
776 
777         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
778             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
779             return true;
780         }
781 
782         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
783             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
784             return true;
785         }
786 
787         function isExcluded(address account) public view returns (bool) {
788             return _isExcluded[account];
789         }
790 
791         function isBlackListed(address account) public view returns (bool) {
792             return _isBlackListedBot[account];
793         }
794 
795         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
796             _isExcludedFromFee[account] = excluded;
797         }
798 
799         function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
800 
801     for(uint256 i = 0; i < accounts.length; i++) {
802 
803         _isExcludedFromFee[accounts[i]] = excluded;
804 
805     }
806 
807             emit ExcludeMultipleAccountsFromFees(accounts, excluded);
808 
809     }
810 
811 
812         function totalFees() public view returns (uint256) {
813             return _tFeeTotal;
814         }
815 
816         function deliver(uint256 tAmount) public {
817             address sender = _msgSender();
818             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
819             (uint256 rAmount,,,,,) = _getValues(tAmount);
820             _rOwned[sender] = _rOwned[sender].sub(rAmount);
821             _rTotal = _rTotal.sub(rAmount);
822             _tFeeTotal = _tFeeTotal.add(tAmount);
823         }
824 
825         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
826             require(tAmount <= _tTotal, "Amount must be less than supply");
827             if (!deductTransferFee) {
828                 (uint256 rAmount,,,,,) = _getValues(tAmount);
829                 return rAmount;
830             } else {
831                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
832                 return rTransferAmount;
833             }
834         }
835 
836         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
837             require(rAmount <= _rTotal, "Amount must be less than total reflections");
838             uint256 currentRate =  _getRate();
839             return rAmount.div(currentRate);
840         }
841 
842         function excludeAccount(address account) external onlyOwner() {
843             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
844             require(!_isExcluded[account], "Account is already excluded");
845             if(_rOwned[account] > 0) {
846                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
847             }
848             _isExcluded[account] = true;
849             _excluded.push(account);
850         }
851 
852         function includeAccount(address account) external onlyOwner() {
853             require(_isExcluded[account], "Account is already excluded");
854             for (uint256 i = 0; i < _excluded.length; i++) {
855                 if (_excluded[i] == account) {
856                     _excluded[i] = _excluded[_excluded.length - 1];
857                     _tOwned[account] = 0;
858                     _isExcluded[account] = false;
859                     _excluded.pop();
860                     break;
861                 }
862             }
863         }
864 
865         function addBotToBlackList(address account) external onlyOwner() {
866             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
867             require(!_isBlackListedBot[account], "Account is already blacklisted");
868             _isBlackListedBot[account] = true;
869             _blackListedBots.push(account);
870         }
871 
872         function removeBotFromBlackList(address account) external onlyOwner() {
873             require(_isBlackListedBot[account], "Account is not blacklisted");
874             for (uint256 i = 0; i < _blackListedBots.length; i++) {
875                 if (_blackListedBots[i] == account) {
876                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
877                     _isBlackListedBot[account] = false;
878                     _blackListedBots.pop();
879                     break;
880                 }
881             }
882         }
883 
884         function removeAllFee() private {
885             if(_taxFee == 0 && _PunkFee == 0) return;
886 
887             _previousTaxFee = _taxFee;
888             _previousPunkFee = _PunkFee;
889 
890             _taxFee = 0;
891             _PunkFee = 0;
892         }
893 
894         function restoreAllFee() private {
895             _taxFee = _previousTaxFee;
896             _PunkFee = _previousPunkFee;
897         }
898 
899         function isExcludedFromFee(address account) public view returns(bool) {
900             return _isExcludedFromFee[account];
901         }
902 
903             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
904         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
905             10**2
906         );
907         }
908 
909              function setNumofTokensForExchange(uint256 numOfTokensToExchangeForPunk) external onlyOwner() {
910         _numOfTokensToExchangeForPunk = numOfTokensToExchangeForPunk;
911         }
912 
913         function _approve(address owner, address spender, uint256 amount) private {
914             require(owner != address(0), "ERC20: approve from the zero address");
915             require(spender != address(0), "ERC20: approve to the zero address");
916 
917             _allowances[owner][spender] = amount;
918             emit Approval(owner, spender, amount);
919         }
920 
921         function _transfer(address sender, address recipient, uint256 amount) private {
922             require(sender != address(0), "ERC20: transfer from the zero address");
923             require(recipient != address(0), "ERC20: transfer to the zero address");
924             require(amount > 0, "Transfer amount must be greater than zero");
925             require(!_isBlackListedBot[sender], "You have no power here!");
926             require(!_isBlackListedBot[msg.sender], "You have no power here!");
927 
928             if(sender != owner() && recipient != owner())
929                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
930 
931             // is the token balance of this contract address over the min number of
932             // tokens that we need to initiate a swap?
933             // also, don't get caught in a circular Punk event.
934             // also, don't swap if sender is uniswap pair.
935             uint256 contractTokenBalance = balanceOf(address(this));
936 
937             if(contractTokenBalance >= _maxTxAmount)
938             {
939                 contractTokenBalance = _maxTxAmount;
940             }
941 
942             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForPunk;
943             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
944                 // We need to swap the current tokens to ETH and send to the Punk wallet
945                 swapTokensForEth(contractTokenBalance);
946 
947                 uint256 contractETHBalance = address(this).balance;
948                 if(contractETHBalance > 0) {
949                     sendETHToPunk(address(this).balance);
950                 }
951             }
952 
953             //indicates if fee should be deducted from transfer
954             bool takeFee = true;
955 
956             //if any account belongs to _isExcludedFromFee account then remove the fee
957             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
958                 takeFee = false;
959             }
960 
961             //transfer amount, it will take tax and Punk fee
962             _tokenTransfer(sender,recipient,amount,takeFee);
963         }
964 
965         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
966             // generate the uniswap pair path of token -> weth
967             address[] memory path = new address[](2);
968             path[0] = address(this);
969             path[1] = uniswapV2Router.WETH();
970 
971             _approve(address(this), address(uniswapV2Router), tokenAmount);
972 
973             // make the swap
974             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
975                 tokenAmount,
976                 0, // accept any amount of ETH
977                 path,
978                 address(this),
979                 block.timestamp
980             );
981         }
982 
983         function sendETHToPunk(uint256 amount) private {
984             _PunkWalletAddress.transfer(amount.div(2));
985             _marketingWalletAddress.transfer(amount.div(2));
986         }
987 
988         // We are exposing these functions to be able to manual swap and send
989         // in case the token is highly valued and 5M becomes too much
990         function manualSwap() external onlyOwner() {
991             uint256 contractBalance = balanceOf(address(this));
992             swapTokensForEth(contractBalance);
993         }
994 
995         function manualSend() external onlyOwner() {
996             uint256 contractETHBalance = address(this).balance;
997             sendETHToPunk(contractETHBalance);
998         }
999 
1000         function setSwapEnabled(bool enabled) external onlyOwner(){
1001             swapEnabled = enabled;
1002         }
1003 
1004         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1005             if(!takeFee)
1006                 removeAllFee();
1007 
1008             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1009                 _transferFromExcluded(sender, recipient, amount);
1010             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1011                 _transferToExcluded(sender, recipient, amount);
1012             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1013                 _transferStandard(sender, recipient, amount);
1014             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1015                 _transferBothExcluded(sender, recipient, amount);
1016             } else {
1017                 _transferStandard(sender, recipient, amount);
1018             }
1019 
1020             if(!takeFee)
1021                 restoreAllFee();
1022         }
1023 
1024         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1025             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tPunk) = _getValues(tAmount);
1026             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1027             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1028             _takePunk(tPunk);
1029             _reflectFee(rFee, tFee);
1030             emit Transfer(sender, recipient, tTransferAmount);
1031         }
1032 
1033         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1034             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tPunk) = _getValues(tAmount);
1035             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1036             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1037             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1038             _takePunk(tPunk);
1039             _reflectFee(rFee, tFee);
1040             emit Transfer(sender, recipient, tTransferAmount);
1041         }
1042 
1043         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1044             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tPunk) = _getValues(tAmount);
1045             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1046             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1047             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1048             _takePunk(tPunk);
1049             _reflectFee(rFee, tFee);
1050             emit Transfer(sender, recipient, tTransferAmount);
1051         }
1052 
1053         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1054             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tPunk) = _getValues(tAmount);
1055             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1056             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1057             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1058             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1059             _takePunk(tPunk);
1060             _reflectFee(rFee, tFee);
1061             emit Transfer(sender, recipient, tTransferAmount);
1062         }
1063 
1064         function _takePunk(uint256 tPunk) private {
1065             uint256 currentRate =  _getRate();
1066             uint256 rPunk = tPunk.mul(currentRate);
1067             _rOwned[address(this)] = _rOwned[address(this)].add(rPunk);
1068             if(_isExcluded[address(this)])
1069                 _tOwned[address(this)] = _tOwned[address(this)].add(tPunk);
1070         }
1071 
1072           function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1073         return _amount.mul(_taxFee).div(
1074             10**2
1075         );
1076     }
1077 
1078     function calculatePunkFee(uint256 _amount) private view returns (uint256) {
1079         return _amount.mul(_PunkFee).div(
1080             10**2
1081         );
1082     }
1083 
1084         function _reflectFee(uint256 rFee, uint256 tFee) private {
1085             _rTotal = _rTotal.sub(rFee);
1086             _tFeeTotal = _tFeeTotal.add(tFee);
1087         }
1088 
1089          //to recieve ETH from uniswapV2Router when swaping
1090         receive() external payable {}
1091 
1092         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1093             (uint256 tTransferAmount, uint256 tFee, uint256 tPunk) = _getTValues(tAmount);
1094             uint256 currentRate =  _getRate();
1095             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tPunk, currentRate);
1096             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tPunk);
1097         }
1098 
1099         function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1100             uint256 tFee = calculateTaxFee(tAmount);
1101             uint256 tPunk = calculatePunkFee(tAmount);
1102             uint256 tTransferAmount = tAmount.sub(tFee).sub(tPunk);
1103             return (tTransferAmount, tFee, tPunk);
1104         }
1105 
1106         function _getRValues(uint256 tAmount, uint256 tFee,uint256 tPunk, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1107             uint256 rAmount = tAmount.mul(currentRate);
1108             uint256 rFee = tFee.mul(currentRate);
1109                uint256 rPunk = tPunk.mul(currentRate);
1110             uint256 rTransferAmount = rAmount.sub(rFee).sub(rPunk);
1111             return (rAmount, rTransferAmount, rFee);
1112         }
1113 
1114         function _getRate() private view returns(uint256) {
1115             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1116             return rSupply.div(tSupply);
1117         }
1118 
1119         function _getCurrentSupply() private view returns(uint256, uint256) {
1120             uint256 rSupply = _rTotal;
1121             uint256 tSupply = _tTotal;
1122             for (uint256 i = 0; i < _excluded.length; i++) {
1123                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1124                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1125                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1126             }
1127             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1128             return (rSupply, tSupply);
1129         }
1130 
1131         function _getTaxFee() private view returns(uint256) {
1132             return _taxFee;
1133         }
1134 
1135         function _getMaxTxAmount() private view returns(uint256) {
1136             return _maxTxAmount;
1137         }
1138 
1139         function _getETHBalance() public view returns(uint256 balance) {
1140             return address(this).balance;
1141         }
1142 
1143         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1144             require(taxFee >= 0 && taxFee <= 100, 'taxFee should be in 1 - 10');
1145             _taxFee = taxFee.div(10);
1146         }
1147 
1148         function _setPunkFee(uint256 PunkFee) external onlyOwner() {
1149             require(PunkFee >= 0 && PunkFee <= 40, 'PunkFee should be in 1 - 40');
1150             _PunkFee = PunkFee;
1151         }
1152 
1153         function _setPunkWallet(address payable PunkWalletAddress) external onlyOwner() {
1154             _PunkWalletAddress = PunkWalletAddress;
1155         }
1156 
1157 
1158     }