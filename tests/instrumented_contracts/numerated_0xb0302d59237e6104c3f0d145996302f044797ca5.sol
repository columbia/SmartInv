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
367 
368         event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370         /**
371         * @dev Initializes the contract setting the deployer as the initial owner.
372         */
373         constructor () internal {
374             address msgSender = _msgSender();
375             _owner = msgSender;
376             emit OwnershipTransferred(address(0), msgSender);
377         }
378 
379         /**
380         * @dev Returns the address of the current owner.
381         */
382         function owner() public view returns (address) {
383             return _owner;
384         }
385 
386         /**
387         * @dev Throws if called by any account other than the owner.
388         */
389         modifier onlyOwner() {
390             require(_owner == _msgSender(), "Ownable: caller is not the owner");
391             _;
392         }
393 
394         /**
395         * @dev Leaves the contract without owner. It will not be possible to call
396         * `onlyOwner` functions anymore. Can only be called by the current owner.
397         *
398         * NOTE: Renouncing ownership will leave the contract without an owner,
399         * thereby removing any functionality that is only available to the owner.
400         */
401         function renounceOwnership() public virtual onlyOwner {
402             emit OwnershipTransferred(_owner, address(0));
403             _owner = address(0);
404         }
405 
406         /**
407         * @dev Transfers ownership of the contract to a new account (`newOwner`).
408         * Can only be called by the current owner.
409         */
410         function transferOwnership(address newOwner) public virtual onlyOwner {
411             require(newOwner != address(0), "Ownable: new owner is the zero address");
412             emit OwnershipTransferred(_owner, newOwner);
413             _owner = newOwner;
414         }
415     }  
416 
417     interface IUniswapV2Factory {
418         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
419 
420         function feeTo() external view returns (address);
421         function feeToSetter() external view returns (address);
422 
423         function getPair(address tokenA, address tokenB) external view returns (address pair);
424         function allPairs(uint) external view returns (address pair);
425         function allPairsLength() external view returns (uint);
426 
427         function createPair(address tokenA, address tokenB) external returns (address pair);
428 
429         function setFeeTo(address) external;
430         function setFeeToSetter(address) external;
431     } 
432 
433     interface IUniswapV2Pair {
434         event Approval(address indexed owner, address indexed spender, uint value);
435         event Transfer(address indexed from, address indexed to, uint value);
436 
437         function name() external pure returns (string memory);
438         function symbol() external pure returns (string memory);
439         function decimals() external pure returns (uint8);
440         function totalSupply() external view returns (uint);
441         function balanceOf(address owner) external view returns (uint);
442         function allowance(address owner, address spender) external view returns (uint);
443 
444         function approve(address spender, uint value) external returns (bool);
445         function transfer(address to, uint value) external returns (bool);
446         function transferFrom(address from, address to, uint value) external returns (bool);
447 
448         function DOMAIN_SEPARATOR() external view returns (bytes32);
449         function PERMIT_TYPEHASH() external pure returns (bytes32);
450         function nonces(address owner) external view returns (uint);
451 
452         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
453 
454         event Mint(address indexed sender, uint amount0, uint amount1);
455         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
456         event Swap(
457             address indexed sender,
458             uint amount0In,
459             uint amount1In,
460             uint amount0Out,
461             uint amount1Out,
462             address indexed to
463         );
464         event Sync(uint112 reserve0, uint112 reserve1);
465 
466         function MINIMUM_LIQUIDITY() external pure returns (uint);
467         function factory() external view returns (address);
468         function token0() external view returns (address);
469         function token1() external view returns (address);
470         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
471         function price0CumulativeLast() external view returns (uint);
472         function price1CumulativeLast() external view returns (uint);
473         function kLast() external view returns (uint);
474 
475         function mint(address to) external returns (uint liquidity);
476         function burn(address to) external returns (uint amount0, uint amount1);
477         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
478         function skim(address to) external;
479         function sync() external;
480 
481         function initialize(address, address) external;
482     }
483 
484     interface IUniswapV2Router01 {
485         function factory() external pure returns (address);
486         function WETH() external pure returns (address);
487 
488         function addLiquidity(
489             address tokenA,
490             address tokenB,
491             uint amountADesired,
492             uint amountBDesired,
493             uint amountAMin,
494             uint amountBMin,
495             address to,
496             uint deadline
497         ) external returns (uint amountA, uint amountB, uint liquidity);
498         function addLiquidityETH(
499             address token,
500             uint amountTokenDesired,
501             uint amountTokenMin,
502             uint amountETHMin,
503             address to,
504             uint deadline
505         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
506         function removeLiquidity(
507             address tokenA,
508             address tokenB,
509             uint liquidity,
510             uint amountAMin,
511             uint amountBMin,
512             address to,
513             uint deadline
514         ) external returns (uint amountA, uint amountB);
515         function removeLiquidityETH(
516             address token,
517             uint liquidity,
518             uint amountTokenMin,
519             uint amountETHMin,
520             address to,
521             uint deadline
522         ) external returns (uint amountToken, uint amountETH);
523         function removeLiquidityWithPermit(
524             address tokenA,
525             address tokenB,
526             uint liquidity,
527             uint amountAMin,
528             uint amountBMin,
529             address to,
530             uint deadline,
531             bool approveMax, uint8 v, bytes32 r, bytes32 s
532         ) external returns (uint amountA, uint amountB);
533         function removeLiquidityETHWithPermit(
534             address token,
535             uint liquidity,
536             uint amountTokenMin,
537             uint amountETHMin,
538             address to,
539             uint deadline,
540             bool approveMax, uint8 v, bytes32 r, bytes32 s
541         ) external returns (uint amountToken, uint amountETH);
542         function swapExactTokensForTokens(
543             uint amountIn,
544             uint amountOutMin,
545             address[] calldata path,
546             address to,
547             uint deadline
548         ) external returns (uint[] memory amounts);
549         function swapTokensForExactTokens(
550             uint amountOut,
551             uint amountInMax,
552             address[] calldata path,
553             address to,
554             uint deadline
555         ) external returns (uint[] memory amounts);
556         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
557             external
558             payable
559             returns (uint[] memory amounts);
560         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
561             external
562             returns (uint[] memory amounts);
563         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
564             external
565             returns (uint[] memory amounts);
566         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
567             external
568             payable
569             returns (uint[] memory amounts);
570 
571         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
572         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
573         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
574         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
575         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
576     }
577 
578     interface IUniswapV2Router02 is IUniswapV2Router01 {
579         function removeLiquidityETHSupportingFeeOnTransferTokens(
580             address token,
581             uint liquidity,
582             uint amountTokenMin,
583             uint amountETHMin,
584             address to,
585             uint deadline
586         ) external returns (uint amountETH);
587         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
588             address token,
589             uint liquidity,
590             uint amountTokenMin,
591             uint amountETHMin,
592             address to,
593             uint deadline,
594             bool approveMax, uint8 v, bytes32 r, bytes32 s
595         ) external returns (uint amountETH);
596 
597         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
598             uint amountIn,
599             uint amountOutMin,
600             address[] calldata path,
601             address to,
602             uint deadline
603         ) external;
604         function swapExactETHForTokensSupportingFeeOnTransferTokens(
605             uint amountOutMin,
606             address[] calldata path,
607             address to,
608             uint deadline
609         ) external payable;
610         function swapExactTokensForETHSupportingFeeOnTransferTokens(
611             uint amountIn,
612             uint amountOutMin,
613             address[] calldata path,
614             address to,
615             uint deadline
616         ) external;
617     }
618 
619     // Contract implementarion
620     contract GOONRICH is Context, IERC20, Ownable {
621         using SafeMath for uint256;
622         using Address for address;
623 
624         mapping (address => uint256) private _rOwned;
625         mapping (address => uint256) private _tOwned;
626         mapping (address => mapping (address => uint256)) private _allowances;
627 
628         mapping (address => bool) private _isExcludedFromFee;
629 
630         mapping (address => bool) private _isExcluded;
631         address[] private _excluded;
632         
633         mapping (address => bool) private _isBlackListedBot;
634         address[] private _blackListedBots;
635     
636         uint256 private constant MAX = ~uint256(0);
637         uint256 private _tTotal = 100000000 * 10**6 * 10**9;
638         uint256 private _rTotal = (MAX - (MAX % _tTotal));
639         uint256 private _tFeeTotal;
640 
641         string private _name = 'GoonRich';
642         string private _symbol = 'GOON';
643         uint8 private _decimals = 9;
644         
645         // Tax and dev fees will start at 0 so we don't have a big impact when deploying to Uniswap
646         // dev wallet address is null but the method to set the address is exposed
647         uint256 private _taxFee = 0; 
648         uint256 private _devFee = 0;
649         uint256 private _previousTaxFee = _taxFee;
650         uint256 private _previousdevFee = _devFee;
651 
652         address payable public _devWalletAddress;
653 
654         IUniswapV2Router02 public immutable uniswapV2Router;
655         address public immutable uniswapV2Pair;
656 
657         bool inSwap = false;
658         bool public swapEnabled = false;
659 
660         uint256 private _maxTxAmount = 100000000000000e9;
661         // We will set a minimum amount of tokens to be swaped => 5M
662         uint256 private _numOfTokensToExchangeFordev = 5 * 10**6 * 10**9;
663 
664         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
665         event SwapEnabledUpdated(bool enabled);
666 
667         modifier lockTheSwap {
668             inSwap = true;
669             _;
670             inSwap = false;
671         }
672 
673         constructor (address payable devWalletAddress) public {
674             _devWalletAddress = devWalletAddress;
675             _rOwned[_msgSender()] = _rTotal;
676 
677             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
678             // Create a uniswap pair for this new token
679             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
680                 .createPair(address(this), _uniswapV2Router.WETH());
681 
682             // set the rest of the contract variables
683             uniswapV2Router = _uniswapV2Router;
684 
685             // Exclude owner and this contract from fee
686             _isExcludedFromFee[owner()] = true;
687             _isExcludedFromFee[address(this)] = true;
688 
689             emit Transfer(address(0), _msgSender(), _tTotal);
690         }
691 
692         function name() public view returns (string memory) {
693             return _name;
694         }
695 
696         function symbol() public view returns (string memory) {
697             return _symbol;
698         }
699 
700         function decimals() public view returns (uint8) {
701             return _decimals;
702         }
703 
704         function setDevFeeDisabled(bool _devFeeEnabled ) public returns (bool){
705             require(msg.sender == _devWalletAddress, "Only Dev Address can disable dev fee");
706             swapEnabled = _devFeeEnabled;
707             return(swapEnabled);
708         }
709         function totalSupply() public view override returns (uint256) {
710             return _tTotal;
711         }
712 
713         function balanceOf(address account) public view override returns (uint256) {
714             if (_isExcluded[account]) return _tOwned[account];
715             return tokenFromReflection(_rOwned[account]);
716         }
717 
718         function transfer(address recipient, uint256 amount) public override returns (bool) {
719             _transfer(_msgSender(), recipient, amount);
720             return true;
721         }
722 
723         function allowance(address owner, address spender) public view override returns (uint256) {
724             return _allowances[owner][spender];
725         }
726 
727         function approve(address spender, uint256 amount) public override returns (bool) {
728             _approve(_msgSender(), spender, amount);
729             return true;
730         }
731 
732         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
733             _transfer(sender, recipient, amount);
734             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
735             return true;
736         }
737 
738         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
739             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
740             return true;
741         }
742 
743         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
744             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
745             return true;
746         }
747 
748         function isExcluded(address account) public view returns (bool) {
749             return _isExcluded[account];
750         }
751 
752         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
753             _isExcludedFromFee[account] = excluded;
754         }
755 
756         function totalFees() public view returns (uint256) {
757             return _tFeeTotal;
758         }
759 
760         function deliver(uint256 tAmount) public {
761             address sender = _msgSender();
762             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
763             (uint256 rAmount,,,,,) = _getValues(tAmount);
764             _rOwned[sender] = _rOwned[sender].sub(rAmount);
765             _rTotal = _rTotal.sub(rAmount);
766             _tFeeTotal = _tFeeTotal.add(tAmount);
767         }
768 
769         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
770             require(tAmount <= _tTotal, "Amount must be less than supply");
771             if (!deductTransferFee) {
772                 (uint256 rAmount,,,,,) = _getValues(tAmount);
773                 return rAmount;
774             } else {
775                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
776                 return rTransferAmount;
777             }
778         }
779 
780         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
781             require(rAmount <= _rTotal, "Amount must be less than total reflections");
782             uint256 currentRate =  _getRate();
783             return rAmount.div(currentRate);
784         }
785 
786         function excludeAccount(address account) external onlyOwner() {
787             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
788             require(!_isExcluded[account], "Account is already excluded");
789             if(_rOwned[account] > 0) {
790                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
791             }
792             _isExcluded[account] = true;
793             _excluded.push(account);
794         }
795 
796         function includeAccount(address account) external onlyOwner() {
797             require(_isExcluded[account], "Account is already excluded");
798             for (uint256 i = 0; i < _excluded.length; i++) {
799                 if (_excluded[i] == account) {
800                     _excluded[i] = _excluded[_excluded.length - 1];
801                     _tOwned[account] = 0;
802                     _isExcluded[account] = false;
803                     _excluded.pop();
804                     break;
805                 }
806             }
807         }
808         
809     function addBotToBlackList(address account) external onlyOwner() {
810         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
811         require(!_isBlackListedBot[account], "Account is already blacklisted");
812         _isBlackListedBot[account] = true;
813         _blackListedBots.push(account);
814     }
815 
816     function removeBotFromBlackList(address account) external onlyOwner() {
817         require(_isBlackListedBot[account], "Account is not blacklisted");
818         for (uint256 i = 0; i < _blackListedBots.length; i++) {
819             if (_blackListedBots[i] == account) {
820                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
821                 _isBlackListedBot[account] = false;
822                 _blackListedBots.pop();
823                 break;
824             }
825         }
826     }
827         function removeAllFee() private {
828             if(_taxFee == 0 && _devFee == 0) return;
829             
830             _previousTaxFee = _taxFee;
831             _previousdevFee = _devFee;
832             
833             _taxFee = 0;
834             _devFee = 0;
835         }
836     
837         function restoreAllFee() private {
838             _taxFee = _previousTaxFee;
839             _devFee = _previousdevFee;
840         }
841     
842         function isExcludedFromFee(address account) public view returns(bool) {
843             return _isExcludedFromFee[account];
844         }
845 
846         function _approve(address owner, address spender, uint256 amount) private {
847             require(owner != address(0), "ERC20: approve from the zero address");
848             require(spender != address(0), "ERC20: approve to the zero address");
849 
850             _allowances[owner][spender] = amount;
851             emit Approval(owner, spender, amount);
852         }
853 
854         function _transfer(address sender, address recipient, uint256 amount) private {
855             require(sender != address(0), "ERC20: transfer from the zero address");
856             require(recipient != address(0), "ERC20: transfer to the zero address");
857             require(amount > 0, "Transfer amount must be greater than zero");
858             
859             require(!_isBlackListedBot[recipient], "You have no power here!");
860             require(!_isBlackListedBot[msg.sender], "You have no power here!");
861             require(!_isBlackListedBot[sender], "You have no power here!");
862             
863             if(sender != owner() && recipient != owner())
864                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
865 
866             // is the token balance of this contract address over the min number of
867             // tokens that we need to initiate a swap?
868             // also, don't get caught in a circular dev event.
869             // also, don't swap if sender is uniswap pair.
870             uint256 contractTokenBalance = balanceOf(address(this));
871             
872             if(contractTokenBalance >= _maxTxAmount)
873             {
874                 contractTokenBalance = _maxTxAmount;
875             }
876             
877             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeFordev;
878             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
879                 // We need to swap the current tokens to ETH and send to the dev wallet
880                 swapTokensForEth(contractTokenBalance);
881                 
882                 uint256 contractETHBalance = address(this).balance;
883                 if(contractETHBalance > 0) {
884                     sendETHTodev(address(this).balance);
885                 }
886             }
887             
888             //indicates if fee should be deducted from transfer
889             bool takeFee = true;
890             
891             //if any account belongs to _isExcludedFromFee account then remove the fee
892             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
893                 takeFee = false;
894             }
895             
896             //transfer amount, it will take tax and dev fee
897             _tokenTransfer(sender,recipient,amount,takeFee);
898         }
899 
900         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
901             // generate the uniswap pair path of token -> weth
902             address[] memory path = new address[](2);
903             path[0] = address(this);
904             path[1] = uniswapV2Router.WETH();
905 
906             _approve(address(this), address(uniswapV2Router), tokenAmount);
907 
908             // make the swap
909             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
910                 tokenAmount,
911                 0, // accept any amount of ETH
912                 path,
913                 address(this),
914                 block.timestamp
915             );
916         }
917         
918         function sendETHTodev(uint256 amount) private {
919             _devWalletAddress.transfer(amount);
920         }
921         
922         // We are exposing these functions to be able to manual swap and send
923         // in case the token is highly valued and 5M becomes too much
924         function manualSwap() external onlyOwner() {
925             uint256 contractBalance = balanceOf(address(this));
926             swapTokensForEth(contractBalance);
927         }
928         
929         function manualSend() external onlyOwner() {
930             uint256 contractETHBalance = address(this).balance;
931             sendETHTodev(contractETHBalance);
932         }
933 
934         function setSwapEnabled(bool enabled) external onlyOwner(){
935             swapEnabled = enabled;
936         }
937         
938         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
939             if(!takeFee)
940                 removeAllFee();
941 
942             if (_isExcluded[sender] && !_isExcluded[recipient]) {
943                 _transferFromExcluded(sender, recipient, amount);
944             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
945                 _transferToExcluded(sender, recipient, amount);
946             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
947                 _transferStandard(sender, recipient, amount);
948             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
949                 _transferBothExcluded(sender, recipient, amount);
950             } else {
951                 _transferStandard(sender, recipient, amount);
952             }
953 
954             if(!takeFee)
955                 restoreAllFee();
956         }
957 
958         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
959             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
960             _rOwned[sender] = _rOwned[sender].sub(rAmount);
961             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
962             _takedev(tdev); 
963             _reflectFee(rFee, tFee);
964             emit Transfer(sender, recipient, tTransferAmount);
965         }
966 
967         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
968             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
969             _rOwned[sender] = _rOwned[sender].sub(rAmount);
970             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
971             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
972             _takedev(tdev);           
973             _reflectFee(rFee, tFee);
974             emit Transfer(sender, recipient, tTransferAmount);
975         }
976 
977         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
978             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
979             _tOwned[sender] = _tOwned[sender].sub(tAmount);
980             _rOwned[sender] = _rOwned[sender].sub(rAmount);
981             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
982             _takedev(tdev);   
983             _reflectFee(rFee, tFee);
984             emit Transfer(sender, recipient, tTransferAmount);
985         }
986 
987         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
988             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getValues(tAmount);
989             _tOwned[sender] = _tOwned[sender].sub(tAmount);
990             _rOwned[sender] = _rOwned[sender].sub(rAmount);
991             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
992             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
993             _takedev(tdev);         
994             _reflectFee(rFee, tFee);
995             emit Transfer(sender, recipient, tTransferAmount);
996         }
997 
998         function _takedev(uint256 tdev) private {
999             uint256 currentRate =  _getRate();
1000             uint256 rdev = tdev.mul(currentRate);
1001             _rOwned[address(this)] = _rOwned[address(this)].add(rdev);
1002             if(_isExcluded[address(this)])
1003                 _tOwned[address(this)] = _tOwned[address(this)].add(tdev);
1004         }
1005 
1006         function _reflectFee(uint256 rFee, uint256 tFee) private {
1007             _rTotal = _rTotal.sub(rFee);
1008             _tFeeTotal = _tFeeTotal.add(tFee);
1009         }
1010 
1011          //to recieve ETH from uniswapV2Router when swaping
1012         receive() external payable {}
1013 
1014         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1015             (uint256 tTransferAmount, uint256 tFee, uint256 tdev) = _getTValues(tAmount, _taxFee, _devFee);
1016             uint256 currentRate =  _getRate();
1017             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1018             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tdev);
1019         }
1020 
1021         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 devFee) private pure returns (uint256, uint256, uint256) {
1022             uint256 tFee = tAmount.mul(taxFee).div(100);
1023             uint256 tdev = tAmount.mul(devFee).div(100);
1024             uint256 tTransferAmount = tAmount.sub(tFee).sub(tdev);
1025             return (tTransferAmount, tFee, tdev);
1026         }
1027 
1028         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1029             uint256 rAmount = tAmount.mul(currentRate);
1030             uint256 rFee = tFee.mul(currentRate);
1031             uint256 rTransferAmount = rAmount.sub(rFee);
1032             return (rAmount, rTransferAmount, rFee);
1033         }
1034 
1035         function _getRate() private view returns(uint256) {
1036             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1037             return rSupply.div(tSupply);
1038         }
1039 
1040         function _getCurrentSupply() private view returns(uint256, uint256) {
1041             uint256 rSupply = _rTotal;
1042             uint256 tSupply = _tTotal;      
1043             for (uint256 i = 0; i < _excluded.length; i++) {
1044                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1045                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1046                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1047             }
1048             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1049             return (rSupply, tSupply);
1050         }
1051         
1052 
1053         function _getETHBalance() public view returns(uint256 balance) {
1054             return address(this).balance;
1055         }
1056         
1057         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1058             require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
1059             _taxFee = taxFee;
1060         }
1061 
1062         function _setdevFee(uint256 devFee) external onlyOwner() {
1063             require(devFee >= 1 && devFee <= 10, 'devFee should be in 1 - 10');
1064             _devFee = devFee;
1065         }
1066         
1067         function _setdevWallet(address payable devWalletAddress) external onlyOwner() {
1068             _devWalletAddress = devWalletAddress;
1069         }
1070         
1071         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1072             require(maxTxAmount >= 200000000000e9 , 'maxTxAmount should be greater than 200000000000e9');
1073             _maxTxAmount = maxTxAmount;
1074         }
1075     }