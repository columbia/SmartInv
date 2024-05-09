1 /**
2  *https://michaeldogson.digital/
3  * https://t.me/MichaelDogSon
4 
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity ^0.6.12;
9 
10     abstract contract Context {
11         function _msgSender() internal view virtual returns (address payable) {
12             return msg.sender;
13         }
14 
15         function _msgData() internal view virtual returns (bytes memory) {
16             this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17             return msg.data;
18         }
19     }
20 
21     interface IERC20 {
22         /**
23         * @dev Returns the amount of tokens in existence.
24         */
25         function totalSupply() external view returns (uint256);
26 
27         /**
28         * @dev Returns the amount of tokens owned by `account`.
29         */
30         function balanceOf(address account) external view returns (uint256);
31 
32         /**
33         * @dev Moves `amount` tokens from the caller's account to `recipient`.
34         *
35         * Returns a boolean value indicating whether the operation succeeded.
36         *
37         * Emits a {Transfer} event.
38         */
39         function transfer(address recipient, uint256 amount) external returns (bool);
40 
41         /**
42         * @dev Returns the remaining number of tokens that `spender` will be
43         * allowed to spend on behalf of `owner` through {transferFrom}. This is
44         * zero by default.
45         *
46         * This value changes when {approve} or {transferFrom} are called.
47         */
48         function allowance(address owner, address spender) external view returns (uint256);
49 
50         /**
51         * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52         *
53         * Returns a boolean value indicating whether the operation succeeded.
54         *
55         * IMPORTANT: Beware that changing an allowance with this method brings the risk
56         * that someone may use both the old and the new allowance by unfortunate
57         * transaction ordering. One possible solution to mitigate this race
58         * condition is to first reduce the spender's allowance to 0 and set the
59         * desired value afterwards:
60         * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61         *
62         * Emits an {Approval} event.
63         */
64         function approve(address spender, uint256 amount) external returns (bool);
65 
66         /**
67         * @dev Moves `amount` tokens from `sender` to `recipient` using the
68         * allowance mechanism. `amount` is then deducted from the caller's
69         * allowance.
70         *
71         * Returns a boolean value indicating whether the operation succeeded.
72         *
73         * Emits a {Transfer} event.
74         */
75         function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77         /**
78         * @dev Emitted when `value` tokens are moved from one account (`from`) to
79         * another (`to`).
80         *
81         * Note that `value` may be zero.
82         */
83         event Transfer(address indexed from, address indexed to, uint256 value);
84 
85         /**
86         * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87         * a call to {approve}. `value` is the new allowance.
88         */
89         event Approval(address indexed owner, address indexed spender, uint256 value);
90     }
91 
92     library SafeMath {
93         /**
94         * @dev Returns the addition of two unsigned integers, reverting on
95         * overflow.
96         *
97         * Counterpart to Solidity's `+` operator.
98         *
99         * Requirements:
100         *
101         * - Addition cannot overflow.
102         */
103         function add(uint256 a, uint256 b) internal pure returns (uint256) {
104             uint256 c = a + b;
105             require(c >= a, "SafeMath: addition overflow");
106 
107             return c;
108         }
109 
110         /**
111         * @dev Returns the subtraction of two unsigned integers, reverting on
112         * overflow (when the result is negative).
113         *
114         * Counterpart to Solidity's `-` operator.
115         *
116         * Requirements:
117         *
118         * - Subtraction cannot overflow.
119         */
120         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121             return sub(a, b, "SafeMath: subtraction overflow");
122         }
123 
124         /**
125         * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126         * overflow (when the result is negative).
127         *
128         * Counterpart to Solidity's `-` operator.
129         *
130         * Requirements:
131         *
132         * - Subtraction cannot overflow.
133         */
134         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135             require(b <= a, errorMessage);
136             uint256 c = a - b;
137 
138             return c;
139         }
140 
141         /**
142         * @dev Returns the multiplication of two unsigned integers, reverting on
143         * overflow.
144         *
145         * Counterpart to Solidity's `*` operator.
146         *
147         * Requirements:
148         *
149         * - Multiplication cannot overflow.
150         */
151         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153             // benefit is lost if 'b' is also tested.
154             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155             if (a == 0) {
156                 return 0;
157             }
158 
159             uint256 c = a * b;
160             require(c / a == b, "SafeMath: multiplication overflow");
161 
162             return c;
163         }
164 
165         /**
166         * @dev Returns the integer division of two unsigned integers. Reverts on
167         * division by zero. The result is rounded towards zero.
168         *
169         * Counterpart to Solidity's `/` operator. Note: this function uses a
170         * `revert` opcode (which leaves remaining gas untouched) while Solidity
171         * uses an invalid opcode to revert (consuming all remaining gas).
172         *
173         * Requirements:
174         *
175         * - The divisor cannot be zero.
176         */
177         function div(uint256 a, uint256 b) internal pure returns (uint256) {
178             return div(a, b, "SafeMath: division by zero");
179         }
180 
181         /**
182         * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
193         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194             require(b > 0, errorMessage);
195             uint256 c = a / b;
196             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198             return c;
199         }
200 
201         /**
202         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203         * Reverts when dividing by zero.
204         *
205         * Counterpart to Solidity's `%` operator. This function uses a `revert`
206         * opcode (which leaves remaining gas untouched) while Solidity uses an
207         * invalid opcode to revert (consuming all remaining gas).
208         *
209         * Requirements:
210         *
211         * - The divisor cannot be zero.
212         */
213         function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214             return mod(a, b, "SafeMath: modulo by zero");
215         }
216 
217         /**
218         * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219         * Reverts with custom message when dividing by zero.
220         *
221         * Counterpart to Solidity's `%` operator. This function uses a `revert`
222         * opcode (which leaves remaining gas untouched) while Solidity uses an
223         * invalid opcode to revert (consuming all remaining gas).
224         *
225         * Requirements:
226         *
227         * - The divisor cannot be zero.
228         */
229         function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230             require(b != 0, errorMessage);
231             return a % b;
232         }
233     }
234 
235     library Address {
236         /**
237         * @dev Returns true if `account` is a contract.
238         *
239         * [IMPORTANT]
240         * ====
241         * It is unsafe to assume that an address for which this function returns
242         * false is an externally-owned account (EOA) and not a contract.
243         *
244         * Among others, `isContract` will return false for the following
245         * types of addresses:
246         *
247         *  - an externally-owned account
248         *  - a contract in construction
249         *  - an address where a contract will be created
250         *  - an address where a contract lived, but was destroyed
251         * ====
252         */
253         function isContract(address account) internal view returns (bool) {
254             // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
255             // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
256             // for accounts without code, i.e. `keccak256('')`
257             bytes32 codehash;
258             bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
259             // solhint-disable-next-line no-inline-assembly
260             assembly { codehash := extcodehash(account) }
261             return (codehash != accountHash && codehash != 0x0);
262         }
263 
264         /**
265         * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
266         * `recipient`, forwarding all available gas and reverting on errors.
267         *
268         * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
269         * of certain opcodes, possibly making contracts go over the 2300 gas limit
270         * imposed by `transfer`, making them unable to receive funds via
271         * `transfer`. {sendValue} removes this limitation.
272         *
273         * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
274         *
275         * IMPORTANT: because control is transferred to `recipient`, care must be
276         * taken to not create reentrancy vulnerabilities. Consider using
277         * {ReentrancyGuard} or the
278         * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
279         */
280         function sendValue(address payable recipient, uint256 amount) internal {
281             require(address(this).balance >= amount, "Address: insufficient balance");
282 
283             // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
284             (bool success, ) = recipient.call{ value: amount }("");
285             require(success, "Address: unable to send value, recipient may have reverted");
286         }
287 
288         /**
289         * @dev Performs a Solidity function call using a low level `call`. A
290         * plain`call` is an unsafe replacement for a function call: use this
291         * function instead.
292         *
293         * If `target` reverts with a revert reason, it is bubbled up by this
294         * function (like regular Solidity function calls).
295         *
296         * Returns the raw returned data. To convert to the expected return value,
297         * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298         *
299         * Requirements:
300         *
301         * - `target` must be a contract.
302         * - calling `target` with `data` must not revert.
303         *
304         * _Available since v3.1._
305         */
306         function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCall(target, data, "Address: low-level call failed");
308         }
309 
310         /**
311         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312         * `errorMessage` as a fallback revert reason when `target` reverts.
313         *
314         * _Available since v3.1._
315         */
316         function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
317             return _functionCallWithValue(target, data, 0, errorMessage);
318         }
319 
320         /**
321         * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322         * but also transferring `value` wei to `target`.
323         *
324         * Requirements:
325         *
326         * - the calling contract must have an ETH balance of at least `value`.
327         * - the called Solidity function must be `payable`.
328         *
329         * _Available since v3.1._
330         */
331         function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
332             return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
333         }
334 
335         /**
336         * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
337         * with `errorMessage` as a fallback revert reason when `target` reverts.
338         *
339         * _Available since v3.1._
340         */
341         function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
342             require(address(this).balance >= value, "Address: insufficient balance for call");
343             return _functionCallWithValue(target, data, value, errorMessage);
344         }
345 
346         function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
347             require(isContract(target), "Address: call to non-contract");
348 
349             // solhint-disable-next-line avoid-low-level-calls
350             (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
351             if (success) {
352                 return returndata;
353             } else {
354                 // Look for revert reason and bubble it up if present
355                 if (returndata.length > 0) {
356                     // The easiest way to bubble the revert reason is using memory via assembly
357 
358                     // solhint-disable-next-line no-inline-assembly
359                     assembly {
360                         let returndata_size := mload(returndata)
361                         revert(add(32, returndata), returndata_size)
362                     }
363                 } else {
364                     revert(errorMessage);
365                 }
366             }
367         }
368     }
369 
370     contract Ownable is Context {
371         address private _owner;
372         address private _previousOwner;
373         uint256 private _lockTime;
374 
375         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377         /**
378         * @dev Initializes the contract setting the deployer as the initial owner.
379         */
380         constructor () internal {
381             address msgSender = _msgSender();
382             _owner = msgSender;
383             emit OwnershipTransferred(address(0), msgSender);
384         }
385 
386         /**
387         * @dev Returns the address of the current owner.
388         */
389         function owner() public view returns (address) {
390             return _owner;
391         }
392 
393         /**
394         * @dev Throws if called by any account other than the owner.
395         */
396         modifier onlyOwner() {
397             require(_owner == _msgSender(), "Ownable: caller is not the owner");
398             _;
399         }
400 
401         /**
402         * @dev Leaves the contract without owner. It will not be possible to call
403         * `onlyOwner` functions anymore. Can only be called by the current owner.
404         *
405         * NOTE: Renouncing ownership will leave the contract without an owner,
406         * thereby removing any functionality that is only available to the owner.
407         */
408         function renounceOwnership() public virtual onlyOwner {
409             emit OwnershipTransferred(_owner, address(0));
410             _owner = address(0);
411         }
412 
413         /**
414         * @dev Transfers ownership of the contract to a new account (`newOwner`).
415         * Can only be called by the current owner.
416         */
417         function transferOwnership(address newOwner) public virtual onlyOwner {
418             require(newOwner != address(0), "Ownable: new owner is the zero address");
419             emit OwnershipTransferred(_owner, newOwner);
420             _owner = newOwner;
421         }
422 
423         function geUnlockTime() public view returns (uint256) {
424             return _lockTime;
425         }
426 
427         //Locks the contract for owner for the amount of time provided
428         function lock(uint256 time) public virtual onlyOwner {
429             _previousOwner = _owner;
430             _owner = address(0);
431             _lockTime = now + time;
432             emit OwnershipTransferred(_owner, address(0));
433         }
434         
435         //Unlocks the contract for owner when _lockTime is exceeds
436         function unlock() public virtual {
437             require(_previousOwner == msg.sender, "You don't have permission to unlock");
438             require(now > _lockTime , "Contract is locked until 7 days");
439             emit OwnershipTransferred(_owner, _previousOwner);
440             _owner = _previousOwner;
441         }
442     }  
443 
444     interface IUniswapV2Factory {
445         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
446 
447         function feeTo() external view returns (address);
448         function feeToSetter() external view returns (address);
449 
450         function getPair(address tokenA, address tokenB) external view returns (address pair);
451         function allPairs(uint) external view returns (address pair);
452         function allPairsLength() external view returns (uint);
453 
454         function createPair(address tokenA, address tokenB) external returns (address pair);
455 
456         function setFeeTo(address) external;
457         function setFeeToSetter(address) external;
458     } 
459 
460     interface IUniswapV2Pair {
461         event Approval(address indexed owner, address indexed spender, uint value);
462         event Transfer(address indexed from, address indexed to, uint value);
463 
464         function name() external pure returns (string memory);
465         function symbol() external pure returns (string memory);
466         function decimals() external pure returns (uint8);
467         function totalSupply() external view returns (uint);
468         function balanceOf(address owner) external view returns (uint);
469         function allowance(address owner, address spender) external view returns (uint);
470 
471         function approve(address spender, uint value) external returns (bool);
472         function transfer(address to, uint value) external returns (bool);
473         function transferFrom(address from, address to, uint value) external returns (bool);
474 
475         function DOMAIN_SEPARATOR() external view returns (bytes32);
476         function PERMIT_TYPEHASH() external pure returns (bytes32);
477         function nonces(address owner) external view returns (uint);
478 
479         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
480 
481         event Mint(address indexed sender, uint amount0, uint amount1);
482         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
483         event Swap(
484             address indexed sender,
485             uint amount0In,
486             uint amount1In,
487             uint amount0Out,
488             uint amount1Out,
489             address indexed to
490         );
491         event Sync(uint112 reserve0, uint112 reserve1);
492 
493         function MINIMUM_LIQUIDITY() external pure returns (uint);
494         function factory() external view returns (address);
495         function token0() external view returns (address);
496         function token1() external view returns (address);
497         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
498         function price0CumulativeLast() external view returns (uint);
499         function price1CumulativeLast() external view returns (uint);
500         function kLast() external view returns (uint);
501 
502         function mint(address to) external returns (uint liquidity);
503         function burn(address to) external returns (uint amount0, uint amount1);
504         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
505         function skim(address to) external;
506         function sync() external;
507 
508         function initialize(address, address) external;
509     }
510 
511     interface IUniswapV2Router01 {
512         function factory() external pure returns (address);
513         function WETH() external pure returns (address);
514 
515         function addLiquidity(
516             address tokenA,
517             address tokenB,
518             uint amountADesired,
519             uint amountBDesired,
520             uint amountAMin,
521             uint amountBMin,
522             address to,
523             uint deadline
524         ) external returns (uint amountA, uint amountB, uint liquidity);
525         function addLiquidityETH(
526             address token,
527             uint amountTokenDesired,
528             uint amountTokenMin,
529             uint amountETHMin,
530             address to,
531             uint deadline
532         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
533         function removeLiquidity(
534             address tokenA,
535             address tokenB,
536             uint liquidity,
537             uint amountAMin,
538             uint amountBMin,
539             address to,
540             uint deadline
541         ) external returns (uint amountA, uint amountB);
542         function removeLiquidityETH(
543             address token,
544             uint liquidity,
545             uint amountTokenMin,
546             uint amountETHMin,
547             address to,
548             uint deadline
549         ) external returns (uint amountToken, uint amountETH);
550         function removeLiquidityWithPermit(
551             address tokenA,
552             address tokenB,
553             uint liquidity,
554             uint amountAMin,
555             uint amountBMin,
556             address to,
557             uint deadline,
558             bool approveMax, uint8 v, bytes32 r, bytes32 s
559         ) external returns (uint amountA, uint amountB);
560         function removeLiquidityETHWithPermit(
561             address token,
562             uint liquidity,
563             uint amountTokenMin,
564             uint amountETHMin,
565             address to,
566             uint deadline,
567             bool approveMax, uint8 v, bytes32 r, bytes32 s
568         ) external returns (uint amountToken, uint amountETH);
569         function swapExactTokensForTokens(
570             uint amountIn,
571             uint amountOutMin,
572             address[] calldata path,
573             address to,
574             uint deadline
575         ) external returns (uint[] memory amounts);
576         function swapTokensForExactTokens(
577             uint amountOut,
578             uint amountInMax,
579             address[] calldata path,
580             address to,
581             uint deadline
582         ) external returns (uint[] memory amounts);
583         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
584             external
585             payable
586             returns (uint[] memory amounts);
587         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
588             external
589             returns (uint[] memory amounts);
590         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
591             external
592             returns (uint[] memory amounts);
593         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
594             external
595             payable
596             returns (uint[] memory amounts);
597 
598         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
599         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
600         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
601         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
602         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
603     }
604 
605     interface IUniswapV2Router02 is IUniswapV2Router01 {
606         function removeLiquidityETHSupportingFeeOnTransferTokens(
607             address token,
608             uint liquidity,
609             uint amountTokenMin,
610             uint amountETHMin,
611             address to,
612             uint deadline
613         ) external returns (uint amountETH);
614         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
615             address token,
616             uint liquidity,
617             uint amountTokenMin,
618             uint amountETHMin,
619             address to,
620             uint deadline,
621             bool approveMax, uint8 v, bytes32 r, bytes32 s
622         ) external returns (uint amountETH);
623 
624         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
625             uint amountIn,
626             uint amountOutMin,
627             address[] calldata path,
628             address to,
629             uint deadline
630         ) external;
631         function swapExactETHForTokensSupportingFeeOnTransferTokens(
632             uint amountOutMin,
633             address[] calldata path,
634             address to,
635             uint deadline
636         ) external payable;
637         function swapExactTokensForETHSupportingFeeOnTransferTokens(
638             uint amountIn,
639             uint amountOutMin,
640             address[] calldata path,
641             address to,
642             uint deadline
643         ) external;
644     }
645 
646     // Contract implementation
647     contract MDSToken is Context, IERC20, Ownable {
648         using SafeMath for uint256;
649         using Address for address;
650 
651         mapping (address => uint256) private _rOwned;
652         mapping (address => uint256) private _tOwned;
653         mapping (address => mapping (address => uint256)) private _allowances;
654 
655         mapping (address => bool) private _isExcludedFromFee;
656     
657         mapping (address => bool) private _isExcluded;
658         address[] private _excluded;
659         mapping (address => bool) private _isBlackListedBot;
660         address[] private _blackListedBots;
661     
662         uint256 private constant MAX = ~uint256(0);
663         uint256 private _tTotal = 1000000000000000000000;  //1,000,000,000,000
664         uint256 private _rTotal = (MAX - (MAX % _tTotal));
665         uint256 private _tFeeTotal;
666 
667         string private _name = 'MichaelDogSon';
668         string private _symbol = 'MDS🕺🏻🐶';
669         uint8 private _decimals = 9;
670         
671         // Tax and charity fees will start at 0 so we don't have a big impact when deploying to Uniswap
672         // Charity wallet address is null but the method to set the address is exposed
673         uint256 private _taxFee = 12; 
674         uint256 private _charityFee = 12;
675         uint256 private _previousTaxFee = _taxFee;
676         uint256 private _previousCharityFee = _charityFee;
677 
678         address payable public _charityWalletAddress;
679         address payable public _marketingWalletAddress;
680         
681         IUniswapV2Router02 public immutable uniswapV2Router;
682         address public immutable uniswapV2Pair;
683 
684         bool inSwap = false;
685         bool public swapEnabled = true;
686 
687         uint256 public _maxTxAmount = _tTotal; //no max tx limit rn 
688         uint256 private _numOfTokensToExchangeForCharity = 5000000000000000;
689 
690         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
691         event SwapEnabledUpdated(bool enabled);
692 
693         modifier lockTheSwap {
694             inSwap = true;
695             _;
696             inSwap = false;
697         }
698 
699         constructor (address payable charityWalletAddress, address payable marketingWalletAddress) public {
700             _charityWalletAddress = charityWalletAddress;
701             _marketingWalletAddress = marketingWalletAddress;
702             _rOwned[_msgSender()] = _rTotal;
703 
704             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
705             // Create a uniswap pair for this new token
706             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
707                 .createPair(address(this), _uniswapV2Router.WETH());
708 
709             // set the rest of the contract variables
710             uniswapV2Router = _uniswapV2Router;
711 
712             // Exclude owner and this contract from fee
713             _isExcludedFromFee[owner()] = true;
714             _isExcludedFromFee[address(this)] = true;
715             
716             _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
717             _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
718     
719             _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
720             _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
721     
722             _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
723             _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
724     
725             _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
726             _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
727     
728             _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
729             _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
730     
731             _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
732             _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
733     
734             _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
735             _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
736     
737             _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
738             _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
739             
740             _isBlackListedBot[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
741             _blackListedBots.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
742             
743             _isBlackListedBot[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
744             _blackListedBots.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
745             
746             _isBlackListedBot[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
747             _blackListedBots.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
748             
749             _isBlackListedBot[address(0x000000000000084e91743124a982076C59f10084)] = true;
750             _blackListedBots.push(address(0x000000000000084e91743124a982076C59f10084));
751 
752             _isBlackListedBot[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
753             _blackListedBots.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
754             
755             _isBlackListedBot[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
756             _blackListedBots.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
757             
758             _isBlackListedBot[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
759             _blackListedBots.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
760             
761             _isBlackListedBot[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
762             _blackListedBots.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
763             
764             _isBlackListedBot[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
765             _blackListedBots.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
766             
767             _isBlackListedBot[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
768             _blackListedBots.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
769             
770             _isBlackListedBot[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
771             _blackListedBots.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
772             
773             _isBlackListedBot[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
774             _blackListedBots.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
775             
776             _isBlackListedBot[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
777             _blackListedBots.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
778             
779             _isBlackListedBot[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
780             _blackListedBots.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
781             
782             _isBlackListedBot[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
783             _blackListedBots.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
784             
785             _isBlackListedBot[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
786             _blackListedBots.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
787 
788             _isBlackListedBot[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
789             _blackListedBots.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
790             
791             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
792             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
793             
794             _isBlackListedBot[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
795             _blackListedBots.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
796 
797             _isBlackListedBot[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
798             _blackListedBots.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
799 
800             _isBlackListedBot[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
801             _blackListedBots.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
802 
803             _isBlackListedBot[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
804             _blackListedBots.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
805             
806             _isBlackListedBot[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
807             _blackListedBots.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
808             
809             _isBlackListedBot[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
810             _blackListedBots.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
811             
812             _isBlackListedBot[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
813             _blackListedBots.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
814             
815             
816             emit Transfer(address(0), _msgSender(), _tTotal);
817         }
818 
819         function name() public view returns (string memory) {
820             return _name;
821         }
822 
823         function symbol() public view returns (string memory) {
824             return _symbol;
825         }
826 
827         function decimals() public view returns (uint8) {
828             return _decimals;
829         }
830 
831         function totalSupply() public view override returns (uint256) {
832             return _tTotal;
833         }
834 
835         function balanceOf(address account) public view override returns (uint256) {
836             if (_isExcluded[account]) return _tOwned[account];
837             return tokenFromReflection(_rOwned[account]);
838         }
839 
840         function transfer(address recipient, uint256 amount) public override returns (bool) {
841             _transfer(_msgSender(), recipient, amount);
842             return true;
843         }
844 
845         function allowance(address owner, address spender) public view override returns (uint256) {
846             return _allowances[owner][spender];
847         }
848 
849         function approve(address spender, uint256 amount) public override returns (bool) {
850             _approve(_msgSender(), spender, amount);
851             return true;
852         }
853 
854         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
855             _transfer(sender, recipient, amount);
856             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
857             return true;
858         }
859 
860         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
861             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
862             return true;
863         }
864 
865         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
866             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
867             return true;
868         }
869 
870         function isExcluded(address account) public view returns (bool) {
871             return _isExcluded[account];
872         }
873         
874         function isBlackListed(address account) public view returns (bool) {
875             return _isBlackListedBot[account];
876         }
877 
878         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
879             _isExcludedFromFee[account] = excluded;
880         }
881 
882         function totalFees() public view returns (uint256) {
883             return _tFeeTotal;
884         }
885 
886         function deliver(uint256 tAmount) public {
887             address sender = _msgSender();
888             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
889             (uint256 rAmount,,,,,) = _getValues(tAmount);
890             _rOwned[sender] = _rOwned[sender].sub(rAmount);
891             _rTotal = _rTotal.sub(rAmount);
892             _tFeeTotal = _tFeeTotal.add(tAmount);
893         }
894 
895         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
896             require(tAmount <= _tTotal, "Amount must be less than supply");
897             if (!deductTransferFee) {
898                 (uint256 rAmount,,,,,) = _getValues(tAmount);
899                 return rAmount;
900             } else {
901                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
902                 return rTransferAmount;
903             }
904         }
905 
906         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
907             require(rAmount <= _rTotal, "Amount must be less than total reflections");
908             uint256 currentRate =  _getRate();
909             return rAmount.div(currentRate);
910         }
911 
912         function excludeAccount(address account) external onlyOwner() {
913             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
914             require(!_isExcluded[account], "Account is already excluded");
915             if(_rOwned[account] > 0) {
916                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
917             }
918             _isExcluded[account] = true;
919             _excluded.push(account);
920         }
921 
922         function includeAccount(address account) external onlyOwner() {
923             require(_isExcluded[account], "Account is already excluded");
924             for (uint256 i = 0; i < _excluded.length; i++) {
925                 if (_excluded[i] == account) {
926                     _excluded[i] = _excluded[_excluded.length - 1];
927                     _tOwned[account] = 0;
928                     _isExcluded[account] = false;
929                     _excluded.pop();
930                     break;
931                 }
932             }
933         }
934         
935         function addBotToBlackList(address account) external onlyOwner() {
936             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
937             require(!_isBlackListedBot[account], "Account is already blacklisted");
938             _isBlackListedBot[account] = true;
939             _blackListedBots.push(account);
940         }
941     
942         function removeBotFromBlackList(address account) external onlyOwner() {
943             require(_isBlackListedBot[account], "Account is not blacklisted");
944             for (uint256 i = 0; i < _blackListedBots.length; i++) {
945                 if (_blackListedBots[i] == account) {
946                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
947                     _isBlackListedBot[account] = false;
948                     _blackListedBots.pop();
949                     break;
950                 }
951             }
952         }
953 
954         function removeAllFee() private {
955             if(_taxFee == 0 && _charityFee == 0) return;
956             
957             _previousTaxFee = _taxFee;
958             _previousCharityFee = _charityFee;
959             
960             _taxFee = 0;
961             _charityFee = 0;
962         }
963     
964         function restoreAllFee() private {
965             _taxFee = _previousTaxFee;
966             _charityFee = _previousCharityFee;
967         }
968     
969         function isExcludedFromFee(address account) public view returns(bool) {
970             return _isExcludedFromFee[account];
971         }
972         
973             function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
974         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
975             10**2
976         );
977         }
978 
979         function _approve(address owner, address spender, uint256 amount) private {
980             require(owner != address(0), "ERC20: approve from the zero address");
981             require(spender != address(0), "ERC20: approve to the zero address");
982 
983             _allowances[owner][spender] = amount;
984             emit Approval(owner, spender, amount);
985         }
986 
987         function _transfer(address sender, address recipient, uint256 amount) private {
988             require(sender != address(0), "ERC20: transfer from the zero address");
989             require(recipient != address(0), "ERC20: transfer to the zero address");
990             require(amount > 0, "Transfer amount must be greater than zero");
991             require(!_isBlackListedBot[recipient], "You have no power here!");
992             require(!_isBlackListedBot[msg.sender], "You have no power here!");
993             
994             if(sender != owner() && recipient != owner())
995                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
996 
997             // is the token balance of this contract address over the min number of
998             // tokens that we need to initiate a swap?
999             // also, don't get caught in a circular charity event.
1000             // also, don't swap if sender is uniswap pair.
1001             uint256 contractTokenBalance = balanceOf(address(this));
1002             
1003             if(contractTokenBalance >= _maxTxAmount)
1004             {
1005                 contractTokenBalance = _maxTxAmount;
1006             }
1007             
1008             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForCharity;
1009             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1010                 // We need to swap the current tokens to ETH and send to the charity wallet
1011                 swapTokensForEth(contractTokenBalance);
1012                 
1013                 uint256 contractETHBalance = address(this).balance;
1014                 if(contractETHBalance > 0) {
1015                     sendETHToCharity(address(this).balance);
1016                 }
1017             }
1018             
1019             //indicates if fee should be deducted from transfer
1020             bool takeFee = true;
1021             
1022             //if any account belongs to _isExcludedFromFee account then remove the fee
1023             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1024                 takeFee = false;
1025             }
1026             
1027             //transfer amount, it will take tax and charity fee
1028             _tokenTransfer(sender,recipient,amount,takeFee);
1029         }
1030 
1031         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1032             // generate the uniswap pair path of token -> weth
1033             address[] memory path = new address[](2);
1034             path[0] = address(this);
1035             path[1] = uniswapV2Router.WETH();
1036 
1037             _approve(address(this), address(uniswapV2Router), tokenAmount);
1038 
1039             // make the swap
1040             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1041                 tokenAmount,
1042                 0, // accept any amount of ETH
1043                 path,
1044                 address(this),
1045                 block.timestamp
1046             );
1047         }
1048         
1049         function sendETHToCharity(uint256 amount) private {
1050             _charityWalletAddress.transfer(amount.div(2));
1051             _marketingWalletAddress.transfer(amount.div(2));
1052         }
1053         
1054         // We are exposing these functions to be able to manual swap and send
1055         // in case the token is highly valued and 5M becomes too much
1056         function manualSwap() external onlyOwner() {
1057             uint256 contractBalance = balanceOf(address(this));
1058             swapTokensForEth(contractBalance);
1059         }
1060         
1061         function manualSend() external onlyOwner() {
1062             uint256 contractETHBalance = address(this).balance;
1063             sendETHToCharity(contractETHBalance);
1064         }
1065 
1066         function setSwapEnabled(bool enabled) external onlyOwner(){
1067             swapEnabled = enabled;
1068         }
1069         
1070         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1071             if(!takeFee)
1072                 removeAllFee();
1073 
1074             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1075                 _transferFromExcluded(sender, recipient, amount);
1076             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1077                 _transferToExcluded(sender, recipient, amount);
1078             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1079                 _transferStandard(sender, recipient, amount);
1080             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1081                 _transferBothExcluded(sender, recipient, amount);
1082             } else {
1083                 _transferStandard(sender, recipient, amount);
1084             }
1085 
1086             if(!takeFee)
1087                 restoreAllFee();
1088         }
1089 
1090         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1091             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1092             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1093             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1094             _takeCharity(tCharity); 
1095             _reflectFee(rFee, tFee);
1096             emit Transfer(sender, recipient, tTransferAmount);
1097         }
1098 
1099         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1100             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1101             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1102             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1103             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
1104             _takeCharity(tCharity);           
1105             _reflectFee(rFee, tFee);
1106             emit Transfer(sender, recipient, tTransferAmount);
1107         }
1108 
1109         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1110             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1111             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1112             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1113             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
1114             _takeCharity(tCharity);   
1115             _reflectFee(rFee, tFee);
1116             emit Transfer(sender, recipient, tTransferAmount);
1117         }
1118 
1119         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1120             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getValues(tAmount);
1121             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1122             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1123             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1124             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1125             _takeCharity(tCharity);         
1126             _reflectFee(rFee, tFee);
1127             emit Transfer(sender, recipient, tTransferAmount);
1128         }
1129 
1130         function _takeCharity(uint256 tCharity) private {
1131             uint256 currentRate =  _getRate();
1132             uint256 rCharity = tCharity.mul(currentRate);
1133             _rOwned[address(this)] = _rOwned[address(this)].add(rCharity);
1134             if(_isExcluded[address(this)])
1135                 _tOwned[address(this)] = _tOwned[address(this)].add(tCharity);
1136         }
1137 
1138         function _reflectFee(uint256 rFee, uint256 tFee) private {
1139             _rTotal = _rTotal.sub(rFee);
1140             _tFeeTotal = _tFeeTotal.add(tFee);
1141         }
1142 
1143          //to recieve ETH from uniswapV2Router when swaping
1144         receive() external payable {}
1145 
1146         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1147             (uint256 tTransferAmount, uint256 tFee, uint256 tCharity) = _getTValues(tAmount, _taxFee, _charityFee);
1148             uint256 currentRate =  _getRate();
1149             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1150             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tCharity);
1151         }
1152 
1153         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
1154             uint256 tFee = tAmount.mul(taxFee).div(100);
1155             uint256 tCharity = tAmount.mul(charityFee).div(100);
1156             uint256 tTransferAmount = tAmount.sub(tFee).sub(tCharity);
1157             return (tTransferAmount, tFee, tCharity);
1158         }
1159 
1160         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1161             uint256 rAmount = tAmount.mul(currentRate);
1162             uint256 rFee = tFee.mul(currentRate);
1163             uint256 rTransferAmount = rAmount.sub(rFee);
1164             return (rAmount, rTransferAmount, rFee);
1165         }
1166 
1167         function _getRate() private view returns(uint256) {
1168             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1169             return rSupply.div(tSupply);
1170         }
1171 
1172         function _getCurrentSupply() private view returns(uint256, uint256) {
1173             uint256 rSupply = _rTotal;
1174             uint256 tSupply = _tTotal;      
1175             for (uint256 i = 0; i < _excluded.length; i++) {
1176                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1177                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1178                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1179             }
1180             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1181             return (rSupply, tSupply);
1182         }
1183         
1184         function _getTaxFee() private view returns(uint256) {
1185             return _taxFee;
1186         }
1187 
1188         function _getMaxTxAmount() private view returns(uint256) {
1189             return _maxTxAmount;
1190         }
1191 
1192         function _getETHBalance() public view returns(uint256 balance) {
1193             return address(this).balance;
1194         }
1195         
1196         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1197             require(taxFee >= 1 && taxFee <= 12, 'taxFee should be in 1 - 12');
1198             _taxFee = taxFee;
1199         }
1200 
1201         function _setCharityFee(uint256 charityFee) external onlyOwner() {
1202             require(charityFee >= 1 && charityFee <= 12, 'charityFee should be in 1 - 12');
1203             _charityFee = charityFee;
1204         }
1205         
1206         function _setCharityWallet(address payable charityWalletAddress) external onlyOwner() {
1207             _charityWalletAddress = charityWalletAddress;
1208         }
1209         
1210         
1211     }