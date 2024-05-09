1 /*
2    
3                
4               /\___/\ ((
5               \`@_@'/  ))
6               {_:Y:.}_//
7 --------------{_}^-'{_}-------------------- 
8  _____   ___   __  __   ___  _   _  _   _ 
9 |_   _| / _ \ |  \/  | |_ _|| \ | || | | | 
10   | |  | | | || |\/| |  | | |  \| || | | |
11   | |  | |_| || |  | |  | | | |\  || |_| |
12   |_|   \___/ |_|  |_| |___||_| \_| \___/ 
13                                           
14 https://www.tominu.xyz
15 https://t.me/tominutoken
16 
17 --------------------------------------------
18 
19 */
20 
21 
22 // SPDX-License-Identifier: Unlicensed
23 
24 pragma solidity ^0.6.12;
25 
26     abstract contract Context {
27         function _msgSender() internal view virtual returns (address payable) {
28             return msg.sender;
29         }
30 
31         function _msgData() internal view virtual returns (bytes memory) {
32             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33             return msg.data;
34         }
35     }
36 
37     interface IERC20 {
38         /**
39         * @dev Returns the amount of tokens in existence.
40         */
41         function totalSupply() external view returns (uint256);
42 
43         /**
44         * @dev Returns the amount of tokens owned by `account`.
45         */
46         function balanceOf(address account) external view returns (uint256);
47 
48         /**
49         * @dev Moves `amount` tokens from the caller's account to `recipient`.
50         *
51         * Returns a boolean value indicating whether the operation succeeded.
52         *
53         * Emits a {Transfer} event.
54         */
55         function transfer(address recipient, uint256 amount) external returns (bool);
56 
57         /**
58         * @dev Returns the remaining number of tokens that `spender` will be
59         * allowed to spend on behalf of `owner` through {transferFrom}. This is
60         * zero by default.
61         *
62         * This value changes when {approve} or {transferFrom} are called.
63         */
64         function allowance(address owner, address spender) external view returns (uint256);
65 
66         /**
67         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68         *
69         * Returns a boolean value indicating whether the operation succeeded.
70         *
71         * IMPORTANT: Beware that changing an allowance with this method brings the risk
72         * that someone may use both the old and the new allowance by unfortunate
73         * transaction ordering. One possible solution to mitigate this race
74         * condition is to first reduce the spender's allowance to 0 and set the
75         * desired value afterwards:
76         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77         *
78         * Emits an {Approval} event.
79         */
80         function approve(address spender, uint256 amount) external returns (bool);
81 
82         /**
83         * @dev Moves `amount` tokens from `sender` to `recipient` using the
84         * allowance mechanism. `amount` is then deducted from the caller's
85         * allowance.
86         *
87         * Returns a boolean value indicating whether the operation succeeded.
88         *
89         * Emits a {Transfer} event.
90         */
91         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93         /**
94         * @dev Emitted when `value` tokens are moved from one account (`from`) to
95         * another (`to`).
96         *
97         * Note that `value` may be zero.
98         */
99         event Transfer(address indexed from, address indexed to, uint256 value);
100 
101         /**
102         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103         * a call to {approve}. `value` is the new allowance.
104         */
105         event Approval(address indexed owner, address indexed spender, uint256 value);
106     }
107 
108     library SafeMath {
109         /**
110         * @dev Returns the addition of two unsigned integers, reverting on
111         * overflow.
112         *
113         * Counterpart to Solidity's `+` operator.
114         *
115         * Requirements:
116         *
117         * - Addition cannot overflow.
118         */
119         function add(uint256 a, uint256 b) internal pure returns (uint256) {
120             uint256 c = a + b;
121             require(c >= a, "SafeMath: addition overflow");
122 
123             return c;
124         }
125 
126         /**
127         * @dev Returns the subtraction of two unsigned integers, reverting on
128         * overflow (when the result is negative).
129         *
130         * Counterpart to Solidity's `-` operator.
131         *
132         * Requirements:
133         *
134         * - Subtraction cannot overflow.
135         */
136         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137             return sub(a, b, "SafeMath: subtraction overflow");
138         }
139 
140         /**
141         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
142         * overflow (when the result is negative).
143         *
144         * Counterpart to Solidity's `-` operator.
145         *
146         * Requirements:
147         *
148         * - Subtraction cannot overflow.
149         */
150         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
151             require(b <= a, errorMessage);
152             uint256 c = a - b;
153 
154             return c;
155         }
156 
157         /**
158         * @dev Returns the multiplication of two unsigned integers, reverting on
159         * overflow.
160         *
161         * Counterpart to Solidity's `*` operator.
162         *
163         * Requirements:
164         *
165         * - Multiplication cannot overflow.
166         */
167         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169             // benefit is lost if 'b' is also tested.
170             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171             if (a == 0) {
172                 return 0;
173             }
174 
175             uint256 c = a * b;
176             require(c / a == b, "SafeMath: multiplication overflow");
177 
178             return c;
179         }
180 
181         /**
182         * @dev Returns the integer division of two unsigned integers. Reverts on
183         * division by zero. The result is rounded towards zero.
184         *
185         * Counterpart to Solidity's `/` operator. Note: this function uses a
186         * `revert` opcode (which leaves remaining gas untouched) while Solidity
187         * uses an invalid opcode to revert (consuming all remaining gas).
188         *
189         * Requirements:
190         *
191         * - The divisor cannot be zero.
192         */
193         function div(uint256 a, uint256 b) internal pure returns (uint256) {
194             return div(a, b, "SafeMath: division by zero");
195         }
196 
197         /**
198         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
199         * division by zero. The result is rounded towards zero.
200         *
201         * Counterpart to Solidity's `/` operator. Note: this function uses a
202         * `revert` opcode (which leaves remaining gas untouched) while Solidity
203         * uses an invalid opcode to revert (consuming all remaining gas).
204         *
205         * Requirements:
206         *
207         * - The divisor cannot be zero.
208         */
209         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210             require(b > 0, errorMessage);
211             uint256 c = a / b;
212             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214             return c;
215         }
216 
217         /**
218         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219         * Reverts when dividing by zero.
220         *
221         * Counterpart to Solidity's `%` operator. This function uses a `revert`
222         * opcode (which leaves remaining gas untouched) while Solidity uses an
223         * invalid opcode to revert (consuming all remaining gas).
224         *
225         * Requirements:
226         *
227         * - The divisor cannot be zero.
228         */
229         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
230             return mod(a, b, "SafeMath: modulo by zero");
231         }
232 
233         /**
234         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235         * Reverts with custom message when dividing by zero.
236         *
237         * Counterpart to Solidity's `%` operator. This function uses a `revert`
238         * opcode (which leaves remaining gas untouched) while Solidity uses an
239         * invalid opcode to revert (consuming all remaining gas).
240         *
241         * Requirements:
242         *
243         * - The divisor cannot be zero.
244         */
245         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246             require(b != 0, errorMessage);
247             return a % b;
248         }
249     }
250 
251     library Address {
252         /**
253         * @dev Returns true if `account` is a contract.
254         *
255         * [IMPORTANT]
256         * ====
257         * It is unsafe to assume that an address for which this function returns
258         * false is an externally-owned account (EOA) and not a contract.
259         *
260         * Among others, `isContract` will return false for the following
261         * types of addresses:
262         *
263         *  - an externally-owned account
264         *  - a contract in construction
265         *  - an address where a contract will be created
266         *  - an address where a contract lived, but was destroyed
267         * ====
268         */
269         function isContract(address account) internal view returns (bool) {
270             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
271             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
272             // for accounts without code, i.e. `keccak256('')`
273             bytes32 codehash;
274             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
275             // solhint-disable-next-line no-inline-assembly
276             assembly { codehash := extcodehash(account) }
277             return (codehash != accountHash && codehash != 0x0);
278         }
279 
280         /**
281         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
282         * `recipient`, forwarding all available gas and reverting on errors.
283         *
284         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
285         * of certain opcodes, possibly making contracts go over the 2300 gas limit
286         * imposed by `transfer`, making them unable to receive funds via
287         * `transfer`. {sendValue} removes this limitation.
288         *
289         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
290         *
291         * IMPORTANT: because control is transferred to `recipient`, care must be
292         * taken to not create reentrancy vulnerabilities. Consider using
293         * {ReentrancyGuard} or the
294         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
295         */
296         function sendValue(address payable recipient, uint256 amount) internal {
297             require(address(this).balance >= amount, "Address: insufficient balance");
298 
299             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
300             (bool success, ) = recipient.call{ value: amount }("");
301             require(success, "Address: unable to send value, recipient may have reverted");
302         }
303 
304         /**
305         * @dev Performs a Solidity function call using a low level `call`. A
306         * plain`call` is an unsafe replacement for a function call: use this
307         * function instead.
308         *
309         * If `target` reverts with a revert reason, it is bubbled up by this
310         * function (like regular Solidity function calls).
311         *
312         * Returns the raw returned data. To convert to the expected return value,
313         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
314         *
315         * Requirements:
316         *
317         * - `target` must be a contract.
318         * - calling `target` with `data` must not revert.
319         *
320         * _Available since v3.1._
321         */
322         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323         return functionCall(target, data, "Address: low-level call failed");
324         }
325 
326         /**
327         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328         * `errorMessage` as a fallback revert reason when `target` reverts.
329         *
330         * _Available since v3.1._
331         */
332         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333             return _functionCallWithValue(target, data, 0, errorMessage);
334         }
335 
336         /**
337         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338         * but also transferring `value` wei to `target`.
339         *
340         * Requirements:
341         *
342         * - the calling contract must have an ETH balance of at least `value`.
343         * - the called Solidity function must be `payable`.
344         *
345         * _Available since v3.1._
346         */
347         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349         }
350 
351         /**
352         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353         * with `errorMessage` as a fallback revert reason when `target` reverts.
354         *
355         * _Available since v3.1._
356         */
357         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358             require(address(this).balance >= value, "Address: insufficient balance for call");
359             return _functionCallWithValue(target, data, value, errorMessage);
360         }
361 
362         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363             require(isContract(target), "Address: call to non-contract");
364 
365             // solhint-disable-next-line avoid-low-level-calls
366             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367             if (success) {
368                 return returndata;
369             } else {
370                 // Look for revert reason and bubble it up if present
371                 if (returndata.length > 0) {
372                     // The easiest way to bubble the revert reason is using memory via assembly
373 
374                     // solhint-disable-next-line no-inline-assembly
375                     assembly {
376                         let returndata_size := mload(returndata)
377                         revert(add(32, returndata), returndata_size)
378                     }
379                 } else {
380                     revert(errorMessage);
381                 }
382             }
383         }
384     }
385 
386     contract Ownable is Context {
387         address private _owner;
388         address private _previousOwner;
389         uint256 private _lockTime;
390 
391         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
392 
393         /**
394         * @dev Initializes the contract setting the deployer as the initial owner.
395         */
396         constructor () internal {
397             address msgSender = _msgSender();
398             _owner = msgSender;
399             emit OwnershipTransferred(address(0), msgSender);
400         }
401 
402         /**
403         * @dev Returns the address of the current owner.
404         */
405         function owner() public view returns (address) {
406             return _owner;
407         }
408 
409         /**
410         * @dev Throws if called by any account other than the owner.
411         */
412         modifier onlyOwner() {
413             require(_owner == _msgSender(), "Ownable: caller is not the owner");
414             _;
415         }
416 
417         /**
418         * @dev Leaves the contract without owner. It will not be possible to call
419         * `onlyOwner` functions anymore. Can only be called by the current owner.
420         *
421         * NOTE: Renouncing ownership will leave the contract without an owner,
422         * thereby removing any functionality that is only available to the owner.
423         */
424         function renounceOwnership() public virtual onlyOwner {
425             emit OwnershipTransferred(_owner, address(0));
426             _owner = address(0);
427         }
428 
429         /**
430         * @dev Transfers ownership of the contract to a new account (`newOwner`).
431         * Can only be called by the current owner.
432         */
433         function transferOwnership(address newOwner) public virtual onlyOwner {
434             require(newOwner != address(0), "Ownable: new owner is the zero address");
435             emit OwnershipTransferred(_owner, newOwner);
436             _owner = newOwner;
437         }
438 
439         function geUnlockTime() public view returns (uint256) {
440             return _lockTime;
441         }
442 
443         //Locks the contract for owner for the amount of time provided
444         function lock(uint256 time) public virtual onlyOwner {
445             _previousOwner = _owner;
446             _owner = address(0);
447             _lockTime = now + time;
448             emit OwnershipTransferred(_owner, address(0));
449         }
450         
451         //Unlocks the contract for owner when _lockTime is exceeds
452         function unlock() public virtual {
453             require(_previousOwner == msg.sender, "You don't have permission to unlock");
454             require(now > _lockTime , "Contract is locked until 7 days");
455             emit OwnershipTransferred(_owner, _previousOwner);
456             _owner = _previousOwner;
457         }
458     }  
459 
460     interface IUniswapV2Factory {
461         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
462 
463         function feeTo() external view returns (address);
464         function feeToSetter() external view returns (address);
465 
466         function getPair(address tokenA, address tokenB) external view returns (address pair);
467         function allPairs(uint) external view returns (address pair);
468         function allPairsLength() external view returns (uint);
469 
470         function createPair(address tokenA, address tokenB) external returns (address pair);
471 
472         function setFeeTo(address) external;
473         function setFeeToSetter(address) external;
474     } 
475 
476     interface IUniswapV2Pair {
477         event Approval(address indexed owner, address indexed spender, uint value);
478         event Transfer(address indexed from, address indexed to, uint value);
479 
480         function name() external pure returns (string memory);
481         function symbol() external pure returns (string memory);
482         function decimals() external pure returns (uint8);
483         function totalSupply() external view returns (uint);
484         function balanceOf(address owner) external view returns (uint);
485         function allowance(address owner, address spender) external view returns (uint);
486 
487         function approve(address spender, uint value) external returns (bool);
488         function transfer(address to, uint value) external returns (bool);
489         function transferFrom(address from, address to, uint value) external returns (bool);
490 
491         function DOMAIN_SEPARATOR() external view returns (bytes32);
492         function PERMIT_TYPEHASH() external pure returns (bytes32);
493         function nonces(address owner) external view returns (uint);
494 
495         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
496 
497         event Mint(address indexed sender, uint amount0, uint amount1);
498         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
499         event Swap(
500             address indexed sender,
501             uint amount0In,
502             uint amount1In,
503             uint amount0Out,
504             uint amount1Out,
505             address indexed to
506         );
507         event Sync(uint112 reserve0, uint112 reserve1);
508 
509         function MINIMUM_LIQUIDITY() external pure returns (uint);
510         function factory() external view returns (address);
511         function token0() external view returns (address);
512         function token1() external view returns (address);
513         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
514         function price0CumulativeLast() external view returns (uint);
515         function price1CumulativeLast() external view returns (uint);
516         function kLast() external view returns (uint);
517 
518         function mint(address to) external returns (uint liquidity);
519         function burn(address to) external returns (uint amount0, uint amount1);
520         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
521         function skim(address to) external;
522         function sync() external;
523 
524         function initialize(address, address) external;
525     }
526 
527     interface IUniswapV2Router01 {
528         function factory() external pure returns (address);
529         function WETH() external pure returns (address);
530 
531         function addLiquidity(
532             address tokenA,
533             address tokenB,
534             uint amountADesired,
535             uint amountBDesired,
536             uint amountAMin,
537             uint amountBMin,
538             address to,
539             uint deadline
540         ) external returns (uint amountA, uint amountB, uint liquidity);
541         function addLiquidityETH(
542             address token,
543             uint amountTokenDesired,
544             uint amountTokenMin,
545             uint amountETHMin,
546             address to,
547             uint deadline
548         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
549         function removeLiquidity(
550             address tokenA,
551             address tokenB,
552             uint liquidity,
553             uint amountAMin,
554             uint amountBMin,
555             address to,
556             uint deadline
557         ) external returns (uint amountA, uint amountB);
558         function removeLiquidityETH(
559             address token,
560             uint liquidity,
561             uint amountTokenMin,
562             uint amountETHMin,
563             address to,
564             uint deadline
565         ) external returns (uint amountToken, uint amountETH);
566         function removeLiquidityWithPermit(
567             address tokenA,
568             address tokenB,
569             uint liquidity,
570             uint amountAMin,
571             uint amountBMin,
572             address to,
573             uint deadline,
574             bool approveMax, uint8 v, bytes32 r, bytes32 s
575         ) external returns (uint amountA, uint amountB);
576         function removeLiquidityETHWithPermit(
577             address token,
578             uint liquidity,
579             uint amountTokenMin,
580             uint amountETHMin,
581             address to,
582             uint deadline,
583             bool approveMax, uint8 v, bytes32 r, bytes32 s
584         ) external returns (uint amountToken, uint amountETH);
585         function swapExactTokensForTokens(
586             uint amountIn,
587             uint amountOutMin,
588             address[] calldata path,
589             address to,
590             uint deadline
591         ) external returns (uint[] memory amounts);
592         function swapTokensForExactTokens(
593             uint amountOut,
594             uint amountInMax,
595             address[] calldata path,
596             address to,
597             uint deadline
598         ) external returns (uint[] memory amounts);
599         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
600             external
601             payable
602             returns (uint[] memory amounts);
603         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
604             external
605             returns (uint[] memory amounts);
606         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
607             external
608             returns (uint[] memory amounts);
609         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
610             external
611             payable
612             returns (uint[] memory amounts);
613 
614         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
615         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
616         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
617         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
618         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
619     }
620 
621     interface IUniswapV2Router02 is IUniswapV2Router01 {
622         function removeLiquidityETHSupportingFeeOnTransferTokens(
623             address token,
624             uint liquidity,
625             uint amountTokenMin,
626             uint amountETHMin,
627             address to,
628             uint deadline
629         ) external returns (uint amountETH);
630         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
631             address token,
632             uint liquidity,
633             uint amountTokenMin,
634             uint amountETHMin,
635             address to,
636             uint deadline,
637             bool approveMax, uint8 v, bytes32 r, bytes32 s
638         ) external returns (uint amountETH);
639 
640         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
641             uint amountIn,
642             uint amountOutMin,
643             address[] calldata path,
644             address to,
645             uint deadline
646         ) external;
647         function swapExactETHForTokensSupportingFeeOnTransferTokens(
648             uint amountOutMin,
649             address[] calldata path,
650             address to,
651             uint deadline
652         ) external payable;
653         function swapExactTokensForETHSupportingFeeOnTransferTokens(
654             uint amountIn,
655             uint amountOutMin,
656             address[] calldata path,
657             address to,
658             uint deadline
659         ) external;
660     }
661 
662     // Contract implementation
663     contract TomInu is Context, IERC20, Ownable {
664         using SafeMath for uint256;
665         using Address for address;
666 
667         mapping (address => uint256) private _rOwned;
668         mapping (address => uint256) private _tOwned;
669         mapping (address => mapping (address => uint256)) private _allowances;
670         mapping (address => uint256) public timestamp;
671 
672         mapping (address => bool) private _isExcludedFromFee;
673     
674         mapping (address => bool) private _isExcluded;
675         address[] private _excluded;
676         mapping (address => bool) private _isBlackListedBot;
677         address[] private _blackListedBots;
678     
679         uint256 private constant MAX = ~uint256(0);
680         uint256 private _tTotal = 1733820000000000000000;  //1,000,000,000,000
681         uint256 private _rTotal = (MAX - (MAX % _tTotal));
682         uint256 private _tFeeTotal;
683         uint256 public _CoolDown = 15 seconds;
684 
685         string private _name = 'Tom Inu';
686         string private _symbol = 'TINU';
687         uint8 private _decimals = 9;
688         
689         // Tax and team fees will start at 0 so we don't have a big impact when deploying 
690         uint256 private _taxFee = 0; 
691         uint256 private _teamFee = 0;
692         uint256 private _previousTaxFee = _taxFee;
693         uint256 private _previousteamFee = _teamFee;
694 
695         address payable public _teamWalletAddress;
696         address payable public _marketingWalletAddress;
697         
698         IUniswapV2Router02 public immutable uniswapV2Router;
699         address public immutable uniswapV2Pair;
700 
701         bool inSwap = false;
702         bool public swapEnabled = true;
703         bool public tradingEnabled = false;
704         bool public cooldownEnabled = true;
705 
706         uint256 public _maxTxAmount = _tTotal; 
707         //no max tx limit at deploy
708         uint256 private _numOfTokensToExchangeForteam = 5000000000000000;
709 
710         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
711         event SwapEnabledUpdated(bool enabled);
712 
713         modifier lockTheSwap {
714             inSwap = true;
715             _;
716             inSwap = false;
717         }
718 
719         constructor (address payable teamWalletAddress, address payable marketingWalletAddress) public {
720             _teamWalletAddress = teamWalletAddress;
721             _marketingWalletAddress = marketingWalletAddress;
722             _rOwned[_msgSender()] = _rTotal;
723 
724             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
725             // Create a uniswap pair for this new token
726             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
727                 .createPair(address(this), _uniswapV2Router.WETH());
728 
729             // set the rest of the contract variables
730             uniswapV2Router = _uniswapV2Router;
731 
732             // Exclude owner and this contract from fee
733             _isExcludedFromFee[owner()] = true;
734             _isExcludedFromFee[address(this)] = true;
735             
736             _isBlackListedBot[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
737             _blackListedBots.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
738             
739             _isBlackListedBot[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
740             _blackListedBots.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
741             
742             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
743             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
744             
745             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
746             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
747     
748             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
749             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
750     
751             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
752             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
753     
754             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
755             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
756     
757             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
758             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
759     
760             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
761             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
762     
763             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
764             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
765     
766             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
767             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
768             
769             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
770             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
771             
772             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
773             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
774             
775             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
776             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
777             
778             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
779             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
780 
781             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
782             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
783             
784             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
785             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
786             
787             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
788             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
789             
790             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
791             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
792             
793             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
794             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
795             
796             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
797             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
798             
799             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
800             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
801             
802             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
803             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
804             
805             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
806             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
807             
808             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
809             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
810             
811             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
812             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
813             
814             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
815             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
816 
817             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
818             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
819             
820             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
821             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
822             
823             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
824             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
825 
826             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
827             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
828 
829             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
830             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
831 
832             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
833             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
834             
835             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
836             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
837             
838             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
839             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
840             
841             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
842             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
843             
844             
845             emit Transfer(address(0), _msgSender(), _tTotal);
846         }
847 
848         function name() public view returns (string memory) {
849             return _name;
850         }
851 
852         function symbol() public view returns (string memory) {
853             return _symbol;
854         }
855 
856         function decimals() public view returns (uint8) {
857             return _decimals;
858         }
859 
860         function totalSupply() public view override returns (uint256) {
861             return _tTotal;
862         }
863 
864         function balanceOf(address account) public view override returns (uint256) {
865             if (_isExcluded[account]) return _tOwned[account];
866             return tokenFromReflection(_rOwned[account]);
867         }
868 
869         function transfer(address recipient, uint256 amount) public override returns (bool) {
870             _transfer(_msgSender(), recipient, amount);
871             return true;
872         }
873 
874         function allowance(address owner, address spender) public view override returns (uint256) {
875             return _allowances[owner][spender];
876         }
877 
878         function approve(address spender, uint256 amount) public override returns (bool) {
879             _approve(_msgSender(), spender, amount);
880             return true;
881         }
882 
883         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
884             _transfer(sender, recipient, amount);
885             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
886             return true;
887         }
888 
889         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
890             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
891             return true;
892         }
893 
894         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
895             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
896             return true;
897         }
898 
899         function isExcluded(address account) public view returns (bool) {
900             return _isExcluded[account];
901         }
902         
903         function isBlackListed(address account) public view returns (bool) {
904             return _isBlackListedBot[account];
905         }
906 
907         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
908             _isExcludedFromFee[account] = excluded;
909         }
910 
911         function totalFees() public view returns (uint256) {
912             return _tFeeTotal;
913         }
914 
915         function deliver(uint256 tAmount) public {
916             address sender = _msgSender();
917             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
918             (uint256 rAmount,,,,,) = _getValues(tAmount);
919             _rOwned[sender] = _rOwned[sender].sub(rAmount);
920             _rTotal = _rTotal.sub(rAmount);
921             _tFeeTotal = _tFeeTotal.add(tAmount);
922         }
923 
924         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
925             require(tAmount <= _tTotal, "Amount must be less than supply");
926             if (!deductTransferFee) {
927                 (uint256 rAmount,,,,,) = _getValues(tAmount);
928                 return rAmount;
929             } else {
930                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
931                 return rTransferAmount;
932             }
933         }
934 
935         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
936             require(rAmount <= _rTotal, "Amount must be less than total reflections");
937             uint256 currentRate =  _getRate();
938             return rAmount.div(currentRate);
939         }
940 
941         function excludeAccount(address account) external onlyOwner() {
942             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
943             require(!_isExcluded[account], "Account is already excluded");
944             if(_rOwned[account] > 0) {
945                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
946             }
947             _isExcluded[account] = true;
948             _excluded.push(account);
949         }
950 
951         function includeAccount(address account) external onlyOwner() {
952             require(_isExcluded[account], "Account is already excluded");
953             for (uint256 i = 0; i < _excluded.length; i++) {
954                 if (_excluded[i] == account) {
955                     _excluded[i] = _excluded[_excluded.length - 1];
956                     _tOwned[account] = 0;
957                     _isExcluded[account] = false;
958                     _excluded.pop();
959                     break;
960                 }
961             }
962         }
963         
964         function addBotToBlackList(address account) external onlyOwner() {
965             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
966             require(!_isBlackListedBot[account], "Account is already blacklisted");
967             _isBlackListedBot[account] = true;
968             _blackListedBots.push(account);
969         }
970     
971         function removeBotFromBlackList(address account) external onlyOwner() {
972             require(_isBlackListedBot[account], "Account is not blacklisted");
973             for (uint256 i = 0; i < _blackListedBots.length; i++) {
974                 if (_blackListedBots[i] == account) {
975                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
976                     _isBlackListedBot[account] = false;
977                     _blackListedBots.pop();
978                     break;
979                 }
980             }
981         }
982 
983         function removeAllFee() private {
984             if(_taxFee == 0 && _teamFee == 0) return;
985             
986             _previousTaxFee = _taxFee;
987             _previousteamFee = _teamFee;
988             
989             _taxFee = 0;
990             _teamFee = 0;
991         }
992     
993         function restoreAllFee() private {
994             _taxFee = _previousTaxFee;
995             _teamFee = _previousteamFee;
996         }
997     
998         function isExcludedFromFee(address account) public view returns(bool) {
999             return _isExcludedFromFee[account];
1000         }
1001         
1002             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1003         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1004             10**2
1005         );
1006         }
1007 
1008         function _approve(address owner, address spender, uint256 amount) private {
1009             require(owner != address(0), "ERC20: approve from the zero address");
1010             require(spender != address(0), "ERC20: approve to the zero address");
1011 
1012             _allowances[owner][spender] = amount;
1013             emit Approval(owner, spender, amount);
1014         }
1015 
1016         function _transfer(address sender, address recipient, uint256 amount) private {
1017             require(sender != address(0), "ERC20: transfer from the zero address");
1018             require(recipient != address(0), "ERC20: transfer to the zero address");
1019             require(amount > 0, "Transfer amount must be greater than zero");
1020             require(!_isBlackListedBot[recipient], "You have no power here!");
1021             require(!_isBlackListedBot[sender], "You have no power here!");
1022             
1023             if(sender != owner() && recipient != owner()) {
1024                     
1025                     require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1026                 
1027                     //you can't trade this on a dex until trading enabled
1028                     if (sender == uniswapV2Pair || recipient == uniswapV2Pair) { require(tradingEnabled, "Trading is not enabled yet");}
1029               
1030             }
1031             
1032             
1033              //cooldown logic starts
1034              
1035              if(cooldownEnabled) {
1036               
1037               //perform all cooldown checks below only if enabled
1038               
1039                       if (sender == uniswapV2Pair ) {
1040                         
1041                         //they just bought add cooldown    
1042                         if (!_isExcluded[recipient]) { timestamp[recipient] = block.timestamp.add(_CoolDown); }
1043 
1044                       }
1045                       
1046 
1047                       // exclude owner and uniswap
1048                       if(sender != owner() && sender != uniswapV2Pair) {
1049 
1050                         // dont apply cooldown to other excluded addresses
1051                         if (!_isExcluded[sender]) { require(block.timestamp >= timestamp[sender], "Cooldown"); }
1052 
1053                       }
1054               
1055              }
1056 
1057             // is the token balance of this contract address over the min number of
1058             // tokens that we need to initiate a swap?
1059             // also, don't get caught in a circular team event.
1060             // also, don't swap if sender is uniswap pair.
1061             uint256 contractTokenBalance = balanceOf(address(this));
1062             
1063             if(contractTokenBalance >= _maxTxAmount)
1064             {
1065                 contractTokenBalance = _maxTxAmount;
1066             }
1067             
1068             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForteam;
1069             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1070                 // We need to swap the current tokens to ETH and send to the team wallet
1071                 swapTokensForEth(contractTokenBalance);
1072                 
1073                 uint256 contractETHBalance = address(this).balance;
1074                 if(contractETHBalance > 0) {
1075                     sendETHToteam(address(this).balance);
1076                 }
1077             }
1078             
1079             //indicates if fee should be deducted from transfer
1080             bool takeFee = true;
1081             
1082             //if any account belongs to _isExcludedFromFee account then remove the fee
1083             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1084                 takeFee = false;
1085             }
1086             
1087             //transfer amount, it will take tax and team fee
1088             _tokenTransfer(sender,recipient,amount,takeFee);
1089         }
1090 
1091         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1092             // generate the uniswap pair path of token -> weth
1093             address[] memory path = new address[](2);
1094             path[0] = address(this);
1095             path[1] = uniswapV2Router.WETH();
1096 
1097             _approve(address(this), address(uniswapV2Router), tokenAmount);
1098 
1099             // make the swap
1100             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1101                 tokenAmount,
1102                 0, // accept any amount of ETH
1103                 path,
1104                 address(this),
1105                 block.timestamp
1106             );
1107         }
1108         
1109         function sendETHToteam(uint256 amount) private {
1110             _teamWalletAddress.transfer(amount.div(2));
1111             _marketingWalletAddress.transfer(amount.div(2));
1112         }
1113         
1114         // We are exposing these functions to be able to manual swap and send
1115         // in case the token is highly valued and 5M becomes too much
1116         function manualSwap() external onlyOwner() {
1117             uint256 contractBalance = balanceOf(address(this));
1118             swapTokensForEth(contractBalance);
1119         }
1120         
1121         function manualSend() external onlyOwner() {
1122             uint256 contractETHBalance = address(this).balance;
1123             sendETHToteam(contractETHBalance);
1124         }
1125 
1126         function setSwapEnabled(bool enabled) external onlyOwner(){
1127             swapEnabled = enabled;
1128         }
1129         
1130         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1131             if(!takeFee)
1132                 removeAllFee();
1133 
1134             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1135                 _transferFromExcluded(sender, recipient, amount);
1136             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1137                 _transferToExcluded(sender, recipient, amount);
1138             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1139                 _transferStandard(sender, recipient, amount);
1140             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1141                 _transferBothExcluded(sender, recipient, amount);
1142             } else {
1143                 _transferStandard(sender, recipient, amount);
1144             }
1145 
1146             if(!takeFee)
1147                 restoreAllFee();
1148         }
1149 
1150         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1151             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1152             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1153             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1154             _taketeam(tteam); 
1155             _reflectFee(rFee, tFee);
1156             emit Transfer(sender, recipient, tTransferAmount);
1157         }
1158 
1159         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1160             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1161             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1162             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1163             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1164             _taketeam(tteam);           
1165             _reflectFee(rFee, tFee);
1166             emit Transfer(sender, recipient, tTransferAmount);
1167         }
1168 
1169         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1170             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1171             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1172             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1173             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1174             _taketeam(tteam);   
1175             _reflectFee(rFee, tFee);
1176             emit Transfer(sender, recipient, tTransferAmount);
1177         }
1178 
1179         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1180             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getValues(tAmount);
1181             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1182             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1183             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1184             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1185             _taketeam(tteam);         
1186             _reflectFee(rFee, tFee);
1187             emit Transfer(sender, recipient, tTransferAmount);
1188         }
1189 
1190         function _taketeam(uint256 tteam) private {
1191             uint256 currentRate =  _getRate();
1192             uint256 rteam = tteam.mul(currentRate);
1193             _rOwned[address(this)] = _rOwned[address(this)].add(rteam);
1194             if(_isExcluded[address(this)])
1195                 _tOwned[address(this)] = _tOwned[address(this)].add(tteam);
1196         }
1197 
1198         function _reflectFee(uint256 rFee, uint256 tFee) private {
1199             _rTotal = _rTotal.sub(rFee);
1200             _tFeeTotal = _tFeeTotal.add(tFee);
1201         }
1202 
1203          //to recieve ETH from uniswapV2Router when swaping
1204         receive() external payable {}
1205 
1206         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1207             (uint256 tTransferAmount, uint256 tFee, uint256 tteam) = _getTValues(tAmount, _taxFee, _teamFee);
1208             uint256 currentRate =  _getRate();
1209             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1210             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tteam);
1211         }
1212 
1213         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1214             uint256 tFee = tAmount.mul(taxFee).div(100);
1215             uint256 tteam = tAmount.mul(teamFee).div(100);
1216             uint256 tTransferAmount = tAmount.sub(tFee).sub(tteam);
1217             return (tTransferAmount, tFee, tteam);
1218         }
1219 
1220         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1221             uint256 rAmount = tAmount.mul(currentRate);
1222             uint256 rFee = tFee.mul(currentRate);
1223             uint256 rTransferAmount = rAmount.sub(rFee);
1224             return (rAmount, rTransferAmount, rFee);
1225         }
1226 
1227         function _getRate() private view returns(uint256) {
1228             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1229             return rSupply.div(tSupply);
1230         }
1231 
1232         function _getCurrentSupply() private view returns(uint256, uint256) {
1233             uint256 rSupply = _rTotal;
1234             uint256 tSupply = _tTotal;      
1235             for (uint256 i = 0; i < _excluded.length; i++) {
1236                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1237                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1238                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1239             }
1240             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1241             return (rSupply, tSupply);
1242         }
1243         
1244         function _getTaxFee() private view returns(uint256) {
1245             return _taxFee;
1246         }
1247 
1248         function _getMaxTxAmount() private view returns(uint256) {
1249             return _maxTxAmount;
1250         }
1251 
1252         function _getETHBalance() public view returns(uint256 balance) {
1253             return address(this).balance;
1254         }
1255         
1256         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1257             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1258             _taxFee = taxFee;
1259         }
1260 
1261         function _setteamFee(uint256 teamFee) external onlyOwner() {
1262             require(teamFee >= 1 && teamFee <= 11, 'teamFee should be in 1 - 11');
1263             _teamFee = teamFee;
1264         }
1265         
1266         function _setteamWallet(address payable teamWalletAddress) external onlyOwner() {
1267             _teamWalletAddress = teamWalletAddress;
1268         }
1269         
1270          function _setmarketingWallet(address payable marketingWalletAddress) external onlyOwner() {
1271             _marketingWalletAddress = marketingWalletAddress;
1272         }
1273         
1274          function LetTradingBegin(bool _tradingEnabled) external onlyOwner() {
1275              tradingEnabled = _tradingEnabled;
1276          }
1277          
1278          function ToggleCoolDown(bool _cooldownEnabled) external onlyOwner() {
1279              cooldownEnabled = _cooldownEnabled;
1280          }
1281          
1282           function setCoolDown(uint256 CoolDown) external onlyOwner() {
1283             _CoolDown = (CoolDown * 1 seconds);
1284             }    
1285         
1286         
1287     }