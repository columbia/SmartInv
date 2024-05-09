1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-16
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-04-23
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.6.12;
11 
12     abstract contract Context {
13         function _msgSender() internal view virtual returns (address payable) {
14             return msg.sender;
15         }
16 
17         function _msgData() internal view virtual returns (bytes memory) {
18             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19             return msg.data;
20         }
21     }
22 
23     interface IERC20 {
24         /**
25         * @dev Returns the amount of tokens in existence.
26         */
27         function totalSupply() external view returns (uint256);
28 
29         /**
30         * @dev Returns the amount of tokens owned by `account`.
31         */
32         function balanceOf(address account) external view returns (uint256);
33 
34         /**
35         * @dev Moves `amount` tokens from the caller's account to `recipient`.
36         *
37         * Returns a boolean value indicating whether the operation succeeded.
38         *
39         * Emits a {Transfer} event.
40         */
41         function transfer(address recipient, uint256 amount) external returns (bool);
42 
43         /**
44         * @dev Returns the remaining number of tokens that `spender` will be
45         * allowed to spend on behalf of `owner` through {transferFrom}. This is
46         * zero by default.
47         *
48         * This value changes when {approve} or {transferFrom} are called.
49         */
50         function allowance(address owner, address spender) external view returns (uint256);
51 
52         /**
53         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54         *
55         * Returns a boolean value indicating whether the operation succeeded.
56         *
57         * IMPORTANT: Beware that changing an allowance with this method brings the risk
58         * that someone may use both the old and the new allowance by unfortunate
59         * transaction ordering. One possible solution to mitigate this race
60         * condition is to first reduce the spender's allowance to 0 and set the
61         * desired value afterwards:
62         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63         *
64         * Emits an {Approval} event.
65         */
66         function approve(address spender, uint256 amount) external returns (bool);
67 
68         /**
69         * @dev Moves `amount` tokens from `sender` to `recipient` using the
70         * allowance mechanism. `amount` is then deducted from the caller's
71         * allowance.
72         *
73         * Returns a boolean value indicating whether the operation succeeded.
74         *
75         * Emits a {Transfer} event.
76         */
77         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79         /**
80         * @dev Emitted when `value` tokens are moved from one account (`from`) to
81         * another (`to`).
82         *
83         * Note that `value` may be zero.
84         */
85         event Transfer(address indexed from, address indexed to, uint256 value);
86 
87         /**
88         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89         * a call to {approve}. `value` is the new allowance.
90         */
91         event Approval(address indexed owner, address indexed spender, uint256 value);
92     }
93 
94     library SafeMath {
95         /**
96         * @dev Returns the addition of two unsigned integers, reverting on
97         * overflow.
98         *
99         * Counterpart to Solidity's `+` operator.
100         *
101         * Requirements:
102         *
103         * - Addition cannot overflow.
104         */
105         function add(uint256 a, uint256 b) internal pure returns (uint256) {
106             uint256 c = a + b;
107             require(c >= a, "SafeMath: addition overflow");
108 
109             return c;
110         }
111 
112         /**
113         * @dev Returns the subtraction of two unsigned integers, reverting on
114         * overflow (when the result is negative).
115         *
116         * Counterpart to Solidity's `-` operator.
117         *
118         * Requirements:
119         *
120         * - Subtraction cannot overflow.
121         */
122         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123             return sub(a, b, "SafeMath: subtraction overflow");
124         }
125 
126         /**
127         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
128         * overflow (when the result is negative).
129         *
130         * Counterpart to Solidity's `-` operator.
131         *
132         * Requirements:
133         *
134         * - Subtraction cannot overflow.
135         */
136         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137             require(b <= a, errorMessage);
138             uint256 c = a - b;
139 
140             return c;
141         }
142 
143         /**
144         * @dev Returns the multiplication of two unsigned integers, reverting on
145         * overflow.
146         *
147         * Counterpart to Solidity's `*` operator.
148         *
149         * Requirements:
150         *
151         * - Multiplication cannot overflow.
152         */
153         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
154             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
155             // benefit is lost if 'b' is also tested.
156             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
157             if (a == 0) {
158                 return 0;
159             }
160 
161             uint256 c = a * b;
162             require(c / a == b, "SafeMath: multiplication overflow");
163 
164             return c;
165         }
166 
167         /**
168         * @dev Returns the integer division of two unsigned integers. Reverts on
169         * division by zero. The result is rounded towards zero.
170         *
171         * Counterpart to Solidity's `/` operator. Note: this function uses a
172         * `revert` opcode (which leaves remaining gas untouched) while Solidity
173         * uses an invalid opcode to revert (consuming all remaining gas).
174         *
175         * Requirements:
176         *
177         * - The divisor cannot be zero.
178         */
179         function div(uint256 a, uint256 b) internal pure returns (uint256) {
180             return div(a, b, "SafeMath: division by zero");
181         }
182 
183         /**
184         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
185         * division by zero. The result is rounded towards zero.
186         *
187         * Counterpart to Solidity's `/` operator. Note: this function uses a
188         * `revert` opcode (which leaves remaining gas untouched) while Solidity
189         * uses an invalid opcode to revert (consuming all remaining gas).
190         *
191         * Requirements:
192         *
193         * - The divisor cannot be zero.
194         */
195         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196             require(b > 0, errorMessage);
197             uint256 c = a / b;
198             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
199 
200             return c;
201         }
202 
203         /**
204         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205         * Reverts when dividing by zero.
206         *
207         * Counterpart to Solidity's `%` operator. This function uses a `revert`
208         * opcode (which leaves remaining gas untouched) while Solidity uses an
209         * invalid opcode to revert (consuming all remaining gas).
210         *
211         * Requirements:
212         *
213         * - The divisor cannot be zero.
214         */
215         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
216             return mod(a, b, "SafeMath: modulo by zero");
217         }
218 
219         /**
220         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221         * Reverts with custom message when dividing by zero.
222         *
223         * Counterpart to Solidity's `%` operator. This function uses a `revert`
224         * opcode (which leaves remaining gas untouched) while Solidity uses an
225         * invalid opcode to revert (consuming all remaining gas).
226         *
227         * Requirements:
228         *
229         * - The divisor cannot be zero.
230         */
231         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232             require(b != 0, errorMessage);
233             return a % b;
234         }
235     }
236 
237     library Address {
238         /**
239         * @dev Returns true if `account` is a contract.
240         *
241         * [IMPORTANT]
242         * ====
243         * It is unsafe to assume that an address for which this function returns
244         * false is an externally-owned account (EOA) and not a contract.
245         *
246         * Among others, `isContract` will return false for the following
247         * types of addresses:
248         *
249         *  - an externally-owned account
250         *  - a contract in construction
251         *  - an address where a contract will be created
252         *  - an address where a contract lived, but was destroyed
253         * ====
254         */
255         function isContract(address account) internal view returns (bool) {
256             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
257             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
258             // for accounts without code, i.e. `keccak256('')`
259             bytes32 codehash;
260             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
261             // solhint-disable-next-line no-inline-assembly
262             assembly { codehash := extcodehash(account) }
263             return (codehash != accountHash && codehash != 0x0);
264         }
265 
266         /**
267         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268         * `recipient`, forwarding all available gas and reverting on errors.
269         *
270         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271         * of certain opcodes, possibly making contracts go over the 2300 gas limit
272         * imposed by `transfer`, making them unable to receive funds via
273         * `transfer`. {sendValue} removes this limitation.
274         *
275         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276         *
277         * IMPORTANT: because control is transferred to `recipient`, care must be
278         * taken to not create reentrancy vulnerabilities. Consider using
279         * {ReentrancyGuard} or the
280         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281         */
282         function sendValue(address payable recipient, uint256 amount) internal {
283             require(address(this).balance >= amount, "Address: insufficient balance");
284 
285             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
286             (bool success, ) = recipient.call{ value: amount }("");
287             require(success, "Address: unable to send value, recipient may have reverted");
288         }
289 
290         /**
291         * @dev Performs a Solidity function call using a low level `call`. A
292         * plain`call` is an unsafe replacement for a function call: use this
293         * function instead.
294         *
295         * If `target` reverts with a revert reason, it is bubbled up by this
296         * function (like regular Solidity function calls).
297         *
298         * Returns the raw returned data. To convert to the expected return value,
299         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300         *
301         * Requirements:
302         *
303         * - `target` must be a contract.
304         * - calling `target` with `data` must not revert.
305         *
306         * _Available since v3.1._
307         */
308         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310         }
311 
312         /**
313         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314         * `errorMessage` as a fallback revert reason when `target` reverts.
315         *
316         * _Available since v3.1._
317         */
318         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
319             return _functionCallWithValue(target, data, 0, errorMessage);
320         }
321 
322         /**
323         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324         * but also transferring `value` wei to `target`.
325         *
326         * Requirements:
327         *
328         * - the calling contract must have an ETH balance of at least `value`.
329         * - the called Solidity function must be `payable`.
330         *
331         * _Available since v3.1._
332         */
333         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
334             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
335         }
336 
337         /**
338         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
339         * with `errorMessage` as a fallback revert reason when `target` reverts.
340         *
341         * _Available since v3.1._
342         */
343         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
344             require(address(this).balance >= value, "Address: insufficient balance for call");
345             return _functionCallWithValue(target, data, value, errorMessage);
346         }
347 
348         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
349             require(isContract(target), "Address: call to non-contract");
350 
351             // solhint-disable-next-line avoid-low-level-calls
352             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
353             if (success) {
354                 return returndata;
355             } else {
356                 // Look for revert reason and bubble it up if present
357                 if (returndata.length > 0) {
358                     // The easiest way to bubble the revert reason is using memory via assembly
359 
360                     // solhint-disable-next-line no-inline-assembly
361                     assembly {
362                         let returndata_size := mload(returndata)
363                         revert(add(32, returndata), returndata_size)
364                     }
365                 } else {
366                     revert(errorMessage);
367                 }
368             }
369         }
370     }
371 
372     contract Ownable is Context {
373         address private _owner;
374         address private _previousOwner;
375         uint256 private _lockTime;
376 
377         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379         /**
380         * @dev Initializes the contract setting the deployer as the initial owner.
381         */
382         constructor () internal {
383             address msgSender = _msgSender();
384             _owner = msgSender;
385             emit OwnershipTransferred(address(0), msgSender);
386         }
387 
388         /**
389         * @dev Returns the address of the current owner.
390         */
391         function owner() public view returns (address) {
392             return _owner;
393         }
394 
395         /**
396         * @dev Throws if called by any account other than the owner.
397         */
398         modifier onlyOwner() {
399             require(_owner == _msgSender(), "Ownable: caller is not the owner");
400             _;
401         }
402 
403         /**
404         * @dev Leaves the contract without owner. It will not be possible to call
405         * `onlyOwner` functions anymore. Can only be called by the current owner.
406         *
407         * NOTE: Renouncing ownership will leave the contract without an owner,
408         * thereby removing any functionality that is only available to the owner.
409         */
410         function renounceOwnership() public virtual onlyOwner {
411             emit OwnershipTransferred(_owner, address(0));
412             _owner = address(0);
413         }
414 
415         /**
416         * @dev Transfers ownership of the contract to a new account (`newOwner`).
417         * Can only be called by the current owner.
418         */
419         function transferOwnership(address newOwner) public virtual onlyOwner {
420             require(newOwner != address(0), "Ownable: new owner is the zero address");
421             emit OwnershipTransferred(_owner, newOwner);
422             _owner = newOwner;
423         }
424 
425         function geUnlockTime() public view returns (uint256) {
426             return _lockTime;
427         }
428 
429         //Locks the contract for owner for the amount of time provided
430         function lock(uint256 time) public virtual onlyOwner {
431             _previousOwner = _owner;
432             _owner = address(0);
433             _lockTime = now + time;
434             emit OwnershipTransferred(_owner, address(0));
435         }
436         
437         //Unlocks the contract for owner when _lockTime is exceeds
438         function unlock() public virtual {
439             require(_previousOwner == msg.sender, "You don't have permission to unlock");
440             require(now > _lockTime , "Contract is locked until 7 days");
441             emit OwnershipTransferred(_owner, _previousOwner);
442             _owner = _previousOwner;
443         }
444     }  
445 
446     interface IUniswapV2Factory {
447         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
448 
449         function feeTo() external view returns (address);
450         function feeToSetter() external view returns (address);
451 
452         function getPair(address tokenA, address tokenB) external view returns (address pair);
453         function allPairs(uint) external view returns (address pair);
454         function allPairsLength() external view returns (uint);
455 
456         function createPair(address tokenA, address tokenB) external returns (address pair);
457 
458         function setFeeTo(address) external;
459         function setFeeToSetter(address) external;
460     } 
461 
462     interface IUniswapV2Pair {
463         event Approval(address indexed owner, address indexed spender, uint value);
464         event Transfer(address indexed from, address indexed to, uint value);
465 
466         function name() external pure returns (string memory);
467         function symbol() external pure returns (string memory);
468         function decimals() external pure returns (uint8);
469         function totalSupply() external view returns (uint);
470         function balanceOf(address owner) external view returns (uint);
471         function allowance(address owner, address spender) external view returns (uint);
472 
473         function approve(address spender, uint value) external returns (bool);
474         function transfer(address to, uint value) external returns (bool);
475         function transferFrom(address from, address to, uint value) external returns (bool);
476 
477         function DOMAIN_SEPARATOR() external view returns (bytes32);
478         function PERMIT_TYPEHASH() external pure returns (bytes32);
479         function nonces(address owner) external view returns (uint);
480 
481         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
482 
483         event Mint(address indexed sender, uint amount0, uint amount1);
484         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
485         event Swap(
486             address indexed sender,
487             uint amount0In,
488             uint amount1In,
489             uint amount0Out,
490             uint amount1Out,
491             address indexed to
492         );
493         event Sync(uint112 reserve0, uint112 reserve1);
494 
495         function MINIMUM_LIQUIDITY() external pure returns (uint);
496         function factory() external view returns (address);
497         function token0() external view returns (address);
498         function token1() external view returns (address);
499         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
500         function price0CumulativeLast() external view returns (uint);
501         function price1CumulativeLast() external view returns (uint);
502         function kLast() external view returns (uint);
503 
504         function mint(address to) external returns (uint liquidity);
505         function burn(address to) external returns (uint amount0, uint amount1);
506         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
507         function skim(address to) external;
508         function sync() external;
509 
510         function initialize(address, address) external;
511     }
512 
513     interface IUniswapV2Router01 {
514         function factory() external pure returns (address);
515         function WETH() external pure returns (address);
516 
517         function addLiquidity(
518             address tokenA,
519             address tokenB,
520             uint amountADesired,
521             uint amountBDesired,
522             uint amountAMin,
523             uint amountBMin,
524             address to,
525             uint deadline
526         ) external returns (uint amountA, uint amountB, uint liquidity);
527         function addLiquidityETH(
528             address token,
529             uint amountTokenDesired,
530             uint amountTokenMin,
531             uint amountETHMin,
532             address to,
533             uint deadline
534         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
535         function removeLiquidity(
536             address tokenA,
537             address tokenB,
538             uint liquidity,
539             uint amountAMin,
540             uint amountBMin,
541             address to,
542             uint deadline
543         ) external returns (uint amountA, uint amountB);
544         function removeLiquidityETH(
545             address token,
546             uint liquidity,
547             uint amountTokenMin,
548             uint amountETHMin,
549             address to,
550             uint deadline
551         ) external returns (uint amountToken, uint amountETH);
552         function removeLiquidityWithPermit(
553             address tokenA,
554             address tokenB,
555             uint liquidity,
556             uint amountAMin,
557             uint amountBMin,
558             address to,
559             uint deadline,
560             bool approveMax, uint8 v, bytes32 r, bytes32 s
561         ) external returns (uint amountA, uint amountB);
562         function removeLiquidityETHWithPermit(
563             address token,
564             uint liquidity,
565             uint amountTokenMin,
566             uint amountETHMin,
567             address to,
568             uint deadline,
569             bool approveMax, uint8 v, bytes32 r, bytes32 s
570         ) external returns (uint amountToken, uint amountETH);
571         function swapExactTokensForTokens(
572             uint amountIn,
573             uint amountOutMin,
574             address[] calldata path,
575             address to,
576             uint deadline
577         ) external returns (uint[] memory amounts);
578         function swapTokensForExactTokens(
579             uint amountOut,
580             uint amountInMax,
581             address[] calldata path,
582             address to,
583             uint deadline
584         ) external returns (uint[] memory amounts);
585         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
586             external
587             payable
588             returns (uint[] memory amounts);
589         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
590             external
591             returns (uint[] memory amounts);
592         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
593             external
594             returns (uint[] memory amounts);
595         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
596             external
597             payable
598             returns (uint[] memory amounts);
599 
600         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
601         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
602         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
603         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
604         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
605     }
606 
607     interface IUniswapV2Router02 is IUniswapV2Router01 {
608         function removeLiquidityETHSupportingFeeOnTransferTokens(
609             address token,
610             uint liquidity,
611             uint amountTokenMin,
612             uint amountETHMin,
613             address to,
614             uint deadline
615         ) external returns (uint amountETH);
616         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
617             address token,
618             uint liquidity,
619             uint amountTokenMin,
620             uint amountETHMin,
621             address to,
622             uint deadline,
623             bool approveMax, uint8 v, bytes32 r, bytes32 s
624         ) external returns (uint amountETH);
625 
626         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
627             uint amountIn,
628             uint amountOutMin,
629             address[] calldata path,
630             address to,
631             uint deadline
632         ) external;
633         function swapExactETHForTokensSupportingFeeOnTransferTokens(
634             uint amountOutMin,
635             address[] calldata path,
636             address to,
637             uint deadline
638         ) external payable;
639         function swapExactTokensForETHSupportingFeeOnTransferTokens(
640             uint amountIn,
641             uint amountOutMin,
642             address[] calldata path,
643             address to,
644             uint deadline
645         ) external;
646     }
647 
648     // Contract implementation
649     contract WolfyToken is Context, IERC20, Ownable {
650         using SafeMath for uint256;
651         using Address for address;
652 
653         mapping (address => uint256) private _rOwned;
654         mapping (address => uint256) private _tOwned;
655         mapping (address => mapping (address => uint256)) private _allowances;
656 
657         mapping (address => bool) private _isExcludedFromFee;
658     
659         mapping (address => bool) private _isExcluded;
660         address[] private _excluded;
661         mapping (address => bool) private _isBlackListedBot;
662         address[] private _blackListedBots;
663     
664         uint256 private constant MAX = ~uint256(0);
665         uint256 private _tTotal = 1000000000000000000000;  //1,000,000,000,000
666         uint256 private _rTotal = (MAX - (MAX % _tTotal));
667         uint256 private _tFeeTotal;
668 
669         string private _name = 'Wolfy Token';
670         string private _symbol = 'WOLFY';
671         uint8 private _decimals = 9;
672         
673         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
674         // Charity wallet address is null but the method to set the address is exposed
675         uint256 private _taxFee = 10; 
676         uint256 private _charityFee = 10;
677         uint256 private _previousTaxFee = _taxFee;
678         uint256 private _previousCharityFee = _charityFee;
679 
680         address payable public _charityWalletAddress;
681         address payable public _marketingWalletAddress;
682         
683         IUniswapV2Router02 public immutable uniswapV2Router;
684         address public immutable uniswapV2Pair;
685 
686         bool inSwap = false;
687         bool public swapEnabled = true;
688 
689         uint256 public _maxTxAmount = _tTotal; //no max tx limit rn 
690         uint256 private _numOfTokensToExchangeForCharity = 5000000000000000;
691 
692         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
693         event SwapEnabledUpdated(bool enabled);
694 
695         modifier lockTheSwap {
696             inSwap = true;
697             _;
698             inSwap = false;
699         }
700 
701         constructor (address payable charityWalletAddress, address payable marketingWalletAddress) public {
702             _charityWalletAddress = charityWalletAddress;
703             _marketingWalletAddress = marketingWalletAddress;
704             _rOwned[_msgSender()] = _rTotal;
705 
706             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
707             // Create a uniswap pair for this new token
708             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
709                 .createPair(address(this), _uniswapV2Router.WETH());
710 
711             // set the rest of the contract variables
712             uniswapV2Router = _uniswapV2Router;
713 
714             // Exclude owner and this contract from fee
715             _isExcludedFromFee[owner()] = true;
716             _isExcludedFromFee[address(this)] = true;
717             
718             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
719             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
720     
721             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
722             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
723     
724             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
725             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
726     
727             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
728             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
729     
730             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
731             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
732     
733             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
734             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
735     
736             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
737             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
738     
739             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
740             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
741             
742             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
743             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
744             
745             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
746             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
747             
748             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
749             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
750             
751             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
752             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
753 
754             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
755             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
756             
757             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
758             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
759             
760             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
761             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
762             
763             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
764             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
765             
766             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
767             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
768             
769             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
770             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
771             
772             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
773             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
774             
775             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
776             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
777             
778             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
779             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
780             
781             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
782             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
783             
784             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
785             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
786             
787             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
788             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
789 
790             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
791             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
792             
793             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
794             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
795             
796             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
797             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
798 
799             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
800             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
801 
802             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
803             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
804 
805             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
806             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
807             
808             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
809             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
810             
811             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
812             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
813             
814             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
815             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
816             
817             
818             emit Transfer(address(0), _msgSender(), _tTotal);
819         }
820 
821         function name() public view returns (string memory) {
822             return _name;
823         }
824 
825         function symbol() public view returns (string memory) {
826             return _symbol;
827         }
828 
829         function decimals() public view returns (uint8) {
830             return _decimals;
831         }
832 
833         function totalSupply() public view override returns (uint256) {
834             return _tTotal;
835         }
836 
837         function balanceOf(address account) public view override returns (uint256) {
838             if (_isExcluded[account]) return _tOwned[account];
839             return tokenFromReflection(_rOwned[account]);
840         }
841 
842         function transfer(address recipient, uint256 amount) public override returns (bool) {
843             _transfer(_msgSender(), recipient, amount);
844             return true;
845         }
846 
847         function allowance(address owner, address spender) public view override returns (uint256) {
848             return _allowances[owner][spender];
849         }
850 
851         function approve(address spender, uint256 amount) public override returns (bool) {
852             _approve(_msgSender(), spender, amount);
853             return true;
854         }
855 
856         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
857             _transfer(sender, recipient, amount);
858             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
859             return true;
860         }
861 
862         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
863             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
864             return true;
865         }
866 
867         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
868             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
869             return true;
870         }
871 
872         function isExcluded(address account) public view returns (bool) {
873             return _isExcluded[account];
874         }
875         
876         function isBlackListed(address account) public view returns (bool) {
877             return _isBlackListedBot[account];
878         }
879 
880         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
881             _isExcludedFromFee[account] = excluded;
882         }
883 
884         function totalFees() public view returns (uint256) {
885             return _tFeeTotal;
886         }
887 
888         function deliver(uint256 tAmount) public {
889             address sender = _msgSender();
890             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
891             (uint256 rAmount,,,,,) = _getValues(tAmount);
892             _rOwned[sender] = _rOwned[sender].sub(rAmount);
893             _rTotal = _rTotal.sub(rAmount);
894             _tFeeTotal = _tFeeTotal.add(tAmount);
895         }
896 
897         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
898             require(tAmount <= _tTotal, "Amount must be less than supply");
899             if (!deductTransferFee) {
900                 (uint256 rAmount,,,,,) = _getValues(tAmount);
901                 return rAmount;
902             } else {
903                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
904                 return rTransferAmount;
905             }
906         }
907 
908         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
909             require(rAmount <= _rTotal, "Amount must be less than total reflections");
910             uint256 currentRate =  _getRate();
911             return rAmount.div(currentRate);
912         }
913 
914         function excludeAccount(address account) external onlyOwner() {
915             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
916             require(!_isExcluded[account], "Account is already excluded");
917             if(_rOwned[account] > 0) {
918                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
919             }
920             _isExcluded[account] = true;
921             _excluded.push(account);
922         }
923 
924         function includeAccount(address account) external onlyOwner() {
925             require(_isExcluded[account], "Account is already excluded");
926             for (uint256 i = 0; i < _excluded.length; i++) {
927                 if (_excluded[i] == account) {
928                     _excluded[i] = _excluded[_excluded.length - 1];
929                     _tOwned[account] = 0;
930                     _isExcluded[account] = false;
931                     _excluded.pop();
932                     break;
933                 }
934             }
935         }
936         
937         function addBotToBlackList(address account) external onlyOwner() {
938             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
939             require(!_isBlackListedBot[account], "Account is already blacklisted");
940             _isBlackListedBot[account] = true;
941             _blackListedBots.push(account);
942         }
943     
944         function removeBotFromBlackList(address account) external onlyOwner() {
945             require(_isBlackListedBot[account], "Account is not blacklisted");
946             for (uint256 i = 0; i < _blackListedBots.length; i++) {
947                 if (_blackListedBots[i] == account) {
948                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
949                     _isBlackListedBot[account] = false;
950                     _blackListedBots.pop();
951                     break;
952                 }
953             }
954         }
955 
956         function removeAllFee() private {
957             if(_taxFee == 0 && _charityFee == 0) return;
958             
959             _previousTaxFee = _taxFee;
960             _previousCharityFee = _charityFee;
961             
962             _taxFee = 0;
963             _charityFee = 0;
964         }
965     
966         function restoreAllFee() private {
967             _taxFee = _previousTaxFee;
968             _charityFee = _previousCharityFee;
969         }
970     
971         function isExcludedFromFee(address account) public view returns(bool) {
972             return _isExcludedFromFee[account];
973         }
974         
975             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
976         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
977             10**2
978         );
979         }
980 
981         function _approve(address owner, address spender, uint256 amount) private {
982             require(owner != address(0), "ERC20: approve from the zero address");
983             require(spender != address(0), "ERC20: approve to the zero address");
984 
985             _allowances[owner][spender] = amount;
986             emit Approval(owner, spender, amount);
987         }
988 
989         function _transfer(address sender, address recipient, uint256 amount) private {
990             require(sender != address(0), "ERC20: transfer from the zero address");
991             require(recipient != address(0), "ERC20: transfer to the zero address");
992             require(amount > 0, "Transfer amount must be greater than zero");
993             require(!_isBlackListedBot[recipient], "You have no power here!");
994             require(!_isBlackListedBot[msg.sender], "You have no power here!");
995             
996             if(sender != owner() && recipient != owner())
997                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
998 
999             // is the token balance of this contract address over the min number of
1000             // tokens that we need to initiate a swap?
1001             // also, don't get caught in a circular charity event.
1002             // also, don't swap if sender is uniswap pair.
1003             uint256 contractTokenBalance = balanceOf(address(this));
1004             
1005             if(contractTokenBalance >= _maxTxAmount)
1006             {
1007                 contractTokenBalance = _maxTxAmount;
1008             }
1009             
1010             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;
1011             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1012                 // We need to swap the current tokens to ETH and send to the charity wallet
1013                 swapTokensForEth(contractTokenBalance);
1014                 
1015                 uint256 contractETHBalance = address(this).balance;
1016                 if(contractETHBalance > 0) {
1017                     sendETHToCharity(address(this).balance);
1018                 }
1019             }
1020             
1021             //indicates if fee should be deducted from transfer
1022             bool takeFee = true;
1023             
1024             //if any account belongs to _isExcludedFromFee account then remove the fee
1025             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1026                 takeFee = false;
1027             }
1028             
1029             //transfer amount, it will take tax and charity fee
1030             _tokenTransfer(sender,recipient,amount,takeFee);
1031         }
1032 
1033         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1034             // generate the uniswap pair path of token -> weth
1035             address[] memory path = new address[](2);
1036             path[0] = address(this);
1037             path[1] = uniswapV2Router.WETH();
1038 
1039             _approve(address(this), address(uniswapV2Router), tokenAmount);
1040 
1041             // make the swap
1042             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1043                 tokenAmount,
1044                 0, // accept any amount of ETH
1045                 path,
1046                 address(this),
1047                 block.timestamp
1048             );
1049         }
1050         
1051         function sendETHToCharity(uint256 amount) private {
1052             _charityWalletAddress.transfer(amount.div(2));
1053             _marketingWalletAddress.transfer(amount.div(2));
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
1065             sendETHToCharity(contractETHBalance);
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
1096             _takeCharity(tCharity); 
1097             _reflectFee(rFee, tFee);
1098             emit Transfer(sender, recipient, tTransferAmount);
1099         }
1100 
1101         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1102             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1103             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1104             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1105             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1106             _takeCharity(tCharity);           
1107             _reflectFee(rFee, tFee);
1108             emit Transfer(sender, recipient, tTransferAmount);
1109         }
1110 
1111         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1112             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1113             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1114             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1115             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1116             _takeCharity(tCharity);   
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
1127             _takeCharity(tCharity);         
1128             _reflectFee(rFee, tFee);
1129             emit Transfer(sender, recipient, tTransferAmount);
1130         }
1131 
1132         function _takeCharity(uint256 tCharity) private {
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
1149             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1150             uint256 currentRate =  _getRate();
1151             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1152             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1153         }
1154 
1155         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1156             uint256 tFee = tAmount.mul(taxFee).div(100);
1157             uint256 tCharity = tAmount.mul(charityFee).div(100);
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
1203         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1204             require(charityFee >= 1 && charityFee <= 11, 'charityFee should be in 1 - 11');
1205             _charityFee = charityFee;
1206         }
1207         
1208         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1209             _charityWalletAddress = charityWalletAddress;
1210         }
1211         
1212         
1213     }