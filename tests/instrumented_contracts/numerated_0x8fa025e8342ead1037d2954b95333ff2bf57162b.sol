1 /**
2 🚀🐕🚀🐕🚀🐕
3 https://t.me/ShibaMaxToken
4 
5 https://www.shibamax.net/
6 
7 https://twitter.com/ShibaMaxToken
8 🚀🐕🚀🐕🚀🐕
9 */
10 
11 //SPDX-License-Identifier: GPL-3.0-or-later
12 pragma solidity ^0.6.12;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 interface IERC20 {
26     /**
27     * @dev Returns the amount of tokens in existence.
28     */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32     * @dev Returns the amount of tokens owned by `account`.
33     */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37     * @dev Moves `amount` tokens from the caller's account to `recipient`.
38     *
39     * Returns a boolean value indicating whether the operation succeeded.
40     *
41     * Emits a {Transfer} event.
42     */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46     * @dev Returns the remaining number of tokens that `spender` will be
47     * allowed to spend on behalf of `owner` through {transferFrom}. This is
48     * zero by default.
49     *
50     * This value changes when {approve} or {transferFrom} are called.
51     */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56     *
57     * Returns a boolean value indicating whether the operation succeeded.
58     *
59     * IMPORTANT: Beware that changing an allowance with this method brings the risk
60     * that someone may use both the old and the new allowance by unfortunate
61     * transaction ordering. One possible solution to mitigate this race
62     * condition is to first reduce the spender's allowance to 0 and set the
63     * desired value afterwards:
64     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65     *
66     * Emits an {Approval} event.
67     */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71     * @dev Moves `amount` tokens from `sender` to `recipient` using the
72     * allowance mechanism. `amount` is then deducted from the caller's
73     * allowance.
74     *
75     * Returns a boolean value indicating whether the operation succeeded.
76     *
77     * Emits a {Transfer} event.
78     */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82     * @dev Emitted when `value` tokens are moved from one account (`from`) to
83     * another (`to`).
84     *
85     * Note that `value` may be zero.
86     */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91     * a call to {approve}. `value` is the new allowance.
92     */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 library SafeMath {
97     /**
98     * @dev Returns the addition of two unsigned integers, reverting on
99     * overflow.
100     *
101     * Counterpart to Solidity's `+` operator.
102     *
103     * Requirements:
104     *
105     * - Addition cannot overflow.
106     */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115     * @dev Returns the subtraction of two unsigned integers, reverting on
116     * overflow (when the result is negative).
117     *
118     * Counterpart to Solidity's `-` operator.
119     *
120     * Requirements:
121     *
122     * - Subtraction cannot overflow.
123     */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130     * overflow (when the result is negative).
131     *
132     * Counterpart to Solidity's `-` operator.
133     *
134     * Requirements:
135     *
136     * - Subtraction cannot overflow.
137     */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146     * @dev Returns the multiplication of two unsigned integers, reverting on
147     * overflow.
148     *
149     * Counterpart to Solidity's `*` operator.
150     *
151     * Requirements:
152     *
153     * - Multiplication cannot overflow.
154     */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170     * @dev Returns the integer division of two unsigned integers. Reverts on
171     * division by zero. The result is rounded towards zero.
172     *
173     * Counterpart to Solidity's `/` operator. Note: this function uses a
174     * `revert` opcode (which leaves remaining gas untouched) while Solidity
175     * uses an invalid opcode to revert (consuming all remaining gas).
176     *
177     * Requirements:
178     *
179     * - The divisor cannot be zero.
180     */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187     * division by zero. The result is rounded towards zero.
188     *
189     * Counterpart to Solidity's `/` operator. Note: this function uses a
190     * `revert` opcode (which leaves remaining gas untouched) while Solidity
191     * uses an invalid opcode to revert (consuming all remaining gas).
192     *
193     * Requirements:
194     *
195     * - The divisor cannot be zero.
196     */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207     * Reverts when dividing by zero.
208     *
209     * Counterpart to Solidity's `%` operator. This function uses a `revert`
210     * opcode (which leaves remaining gas untouched) while Solidity uses an
211     * invalid opcode to revert (consuming all remaining gas).
212     *
213     * Requirements:
214     *
215     * - The divisor cannot be zero.
216     */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223     * Reverts with custom message when dividing by zero.
224     *
225     * Counterpart to Solidity's `%` operator. This function uses a `revert`
226     * opcode (which leaves remaining gas untouched) while Solidity uses an
227     * invalid opcode to revert (consuming all remaining gas).
228     *
229     * Requirements:
230     *
231     * - The divisor cannot be zero.
232     */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 library Address {
240     /**
241     * @dev Returns true if `account` is a contract.
242     *
243     * [IMPORTANT]
244     * ====
245     * It is unsafe to assume that an address for which this function returns
246     * false is an externally-owned account (EOA) and not a contract.
247     *
248     * Among others, `isContract` will return false for the following
249     * types of addresses:
250     *
251     *  - an externally-owned account
252     *  - a contract in construction
253     *  - an address where a contract will be created
254     *  - an address where a contract lived, but was destroyed
255     * ====
256     */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270     * `recipient`, forwarding all available gas and reverting on errors.
271     *
272     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273     * of certain opcodes, possibly making contracts go over the 2300 gas limit
274     * imposed by `transfer`, making them unable to receive funds via
275     * `transfer`. {sendValue} removes this limitation.
276     *
277     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278     *
279     * IMPORTANT: because control is transferred to `recipient`, care must be
280     * taken to not create reentrancy vulnerabilities. Consider using
281     * {ReentrancyGuard} or the
282     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283     */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293     * @dev Performs a Solidity function call using a low level `call`. A
294     * plain`call` is an unsafe replacement for a function call: use this
295     * function instead.
296     *
297     * If `target` reverts with a revert reason, it is bubbled up by this
298     * function (like regular Solidity function calls).
299     *
300     * Returns the raw returned data. To convert to the expected return value,
301     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302     *
303     * Requirements:
304     *
305     * - `target` must be a contract.
306     * - calling `target` with `data` must not revert.
307     *
308     * _Available since v3.1._
309     */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311         return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316     * `errorMessage` as a fallback revert reason when `target` reverts.
317     *
318     * _Available since v3.1._
319     */
320     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         return _functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326     * but also transferring `value` wei to `target`.
327     *
328     * Requirements:
329     *
330     * - the calling contract must have an ETH balance of at least `value`.
331     * - the called Solidity function must be `payable`.
332     *
333     * _Available since v3.1._
334     */
335     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341     * with `errorMessage` as a fallback revert reason when `target` reverts.
342     *
343     * _Available since v3.1._
344     */
345     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         return _functionCallWithValue(target, data, value, errorMessage);
348     }
349 
350     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 // solhint-disable-next-line no-inline-assembly
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 contract Ownable is Context {
375     address private _owner;
376     address private _previousOwner;
377     uint256 private _lockTime;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382     * @dev Initializes the contract setting the deployer as the initial owner.
383     */
384     constructor () internal {
385         address msgSender = _msgSender();
386         _owner = msgSender;
387         emit OwnershipTransferred(address(0), msgSender);
388     }
389 
390     /**
391     * @dev Returns the address of the current owner.
392     */
393     function owner() public view returns (address) {
394         return _owner;
395     }
396 
397     /**
398     * @dev Throws if called by any account other than the owner.
399     */
400     modifier onlyOwner() {
401         require(_owner == _msgSender(), "Ownable: caller is not the owner");
402         _;
403     }
404 
405     /**
406     * @dev Leaves the contract without owner. It will not be possible to call
407     * `onlyOwner` functions anymore. Can only be called by the current owner.
408     *
409     * NOTE: Renouncing ownership will leave the contract without an owner,
410     * thereby removing any functionality that is only available to the owner.
411     */
412     function renounceOwnership() public virtual onlyOwner {
413         emit OwnershipTransferred(_owner, address(0));
414         _owner = address(0);
415     }
416 
417     /**
418     * @dev Transfers ownership of the contract to a new account (`newOwner`).
419     * Can only be called by the current owner.
420     */
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(newOwner != address(0), "Ownable: new owner is the zero address");
423         emit OwnershipTransferred(_owner, newOwner);
424         _owner = newOwner;
425     }
426     
427 }
428 
429 interface IUniswapV2Factory {
430     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
431 
432     function feeTo() external view returns (address);
433     function feeToSetter() external view returns (address);
434 
435     function getPair(address tokenA, address tokenB) external view returns (address pair);
436     function allPairs(uint) external view returns (address pair);
437     function allPairsLength() external view returns (uint);
438 
439     function createPair(address tokenA, address tokenB) external returns (address pair);
440 
441     function setFeeTo(address) external;
442     function setFeeToSetter(address) external;
443 }
444 
445 interface IUniswapV2Pair {
446     event Approval(address indexed owner, address indexed spender, uint value);
447     event Transfer(address indexed from, address indexed to, uint value);
448 
449     function name() external pure returns (string memory);
450     function symbol() external pure returns (string memory);
451     function decimals() external pure returns (uint8);
452     function totalSupply() external view returns (uint);
453     function balanceOf(address owner) external view returns (uint);
454     function allowance(address owner, address spender) external view returns (uint);
455 
456     function approve(address spender, uint value) external returns (bool);
457     function transfer(address to, uint value) external returns (bool);
458     function transferFrom(address from, address to, uint value) external returns (bool);
459 
460     function DOMAIN_SEPARATOR() external view returns (bytes32);
461     function PERMIT_TYPEHASH() external pure returns (bytes32);
462     function nonces(address owner) external view returns (uint);
463 
464     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
465 
466     event Mint(address indexed sender, uint amount0, uint amount1);
467     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
468     event Swap(
469         address indexed sender,
470         uint amount0In,
471         uint amount1In,
472         uint amount0Out,
473         uint amount1Out,
474         address indexed to
475     );
476     event Sync(uint112 reserve0, uint112 reserve1);
477 
478     function MINIMUM_LIQUIDITY() external pure returns (uint);
479     function factory() external view returns (address);
480     function token0() external view returns (address);
481     function token1() external view returns (address);
482     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
483     function price0CumulativeLast() external view returns (uint);
484     function price1CumulativeLast() external view returns (uint);
485     function kLast() external view returns (uint);
486 
487     function mint(address to) external returns (uint liquidity);
488     function burn(address to) external returns (uint amount0, uint amount1);
489     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
490     function skim(address to) external;
491     function sync() external;
492 
493     function initialize(address, address) external;
494 }
495 
496 interface IUniswapV2Router01 {
497     function factory() external pure returns (address);
498     function WETH() external pure returns (address);
499 
500     function addLiquidity(
501         address tokenA,
502         address tokenB,
503         uint amountADesired,
504         uint amountBDesired,
505         uint amountAMin,
506         uint amountBMin,
507         address to,
508         uint deadline
509     ) external returns (uint amountA, uint amountB, uint liquidity);
510     function addLiquidityETH(
511         address token,
512         uint amountTokenDesired,
513         uint amountTokenMin,
514         uint amountETHMin,
515         address to,
516         uint deadline
517     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
518     function removeLiquidity(
519         address tokenA,
520         address tokenB,
521         uint liquidity,
522         uint amountAMin,
523         uint amountBMin,
524         address to,
525         uint deadline
526     ) external returns (uint amountA, uint amountB);
527     function removeLiquidityETH(
528         address token,
529         uint liquidity,
530         uint amountTokenMin,
531         uint amountETHMin,
532         address to,
533         uint deadline
534     ) external returns (uint amountToken, uint amountETH);
535     function removeLiquidityWithPermit(
536         address tokenA,
537         address tokenB,
538         uint liquidity,
539         uint amountAMin,
540         uint amountBMin,
541         address to,
542         uint deadline,
543         bool approveMax, uint8 v, bytes32 r, bytes32 s
544     ) external returns (uint amountA, uint amountB);
545     function removeLiquidityETHWithPermit(
546         address token,
547         uint liquidity,
548         uint amountTokenMin,
549         uint amountETHMin,
550         address to,
551         uint deadline,
552         bool approveMax, uint8 v, bytes32 r, bytes32 s
553     ) external returns (uint amountToken, uint amountETH);
554     function swapExactTokensForTokens(
555         uint amountIn,
556         uint amountOutMin,
557         address[] calldata path,
558         address to,
559         uint deadline
560     ) external returns (uint[] memory amounts);
561     function swapTokensForExactTokens(
562         uint amountOut,
563         uint amountInMax,
564         address[] calldata path,
565         address to,
566         uint deadline
567     ) external returns (uint[] memory amounts);
568     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
569     external
570     payable
571     returns (uint[] memory amounts);
572     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
573     external
574     returns (uint[] memory amounts);
575     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
576     external
577     returns (uint[] memory amounts);
578     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
579     external
580     payable
581     returns (uint[] memory amounts);
582 
583     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
584     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
585     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
586     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
587     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
588 }
589 
590 interface IUniswapV2Router02 is IUniswapV2Router01 {
591     function removeLiquidityETHSupportingFeeOnTransferTokens(
592         address token,
593         uint liquidity,
594         uint amountTokenMin,
595         uint amountETHMin,
596         address to,
597         uint deadline
598     ) external returns (uint amountETH);
599     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
600         address token,
601         uint liquidity,
602         uint amountTokenMin,
603         uint amountETHMin,
604         address to,
605         uint deadline,
606         bool approveMax, uint8 v, bytes32 r, bytes32 s
607     ) external returns (uint amountETH);
608 
609     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
610         uint amountIn,
611         uint amountOutMin,
612         address[] calldata path,
613         address to,
614         uint deadline
615     ) external;
616     function swapExactETHForTokensSupportingFeeOnTransferTokens(
617         uint amountOutMin,
618         address[] calldata path,
619         address to,
620         uint deadline
621     ) external payable;
622     function swapExactTokensForETHSupportingFeeOnTransferTokens(
623         uint amountIn,
624         uint amountOutMin,
625         address[] calldata path,
626         address to,
627         uint deadline
628     ) external;
629 }
630 
631 // Contract implementation
632 contract ShibaMax is Context, IERC20, Ownable {
633     using SafeMath for uint256;
634     using Address for address;
635 
636     mapping (address => uint256) private _rOwned;
637     mapping (address => uint256) private _tOwned;
638     mapping (address => mapping (address => uint256)) private _allowances;
639 
640     mapping (address => bool) private _isExcludedFromFee;
641 
642     mapping (address => bool) private _isExcluded; // excluded from reward
643     address[] private _excluded;
644     mapping (address => bool) private _isBlackListedBot;
645     address[] private _blackListedBots;
646 
647     uint256 private constant MAX = ~uint256(0);
648 
649     uint256 private _tTotal = 100_000_000_000_000 * 10**9;
650     uint256 private _rTotal = (MAX - (MAX % _tTotal));
651     uint256 private _tFeeTotal;
652 
653     string private _name = 'ShibaMax';
654     string private _symbol = 'SMAX';
655     uint8 private _decimals = 9;
656 
657     uint256 private _taxFee = 8; // 4% reflection fee for every holder and 4% burn for the dead address
658     uint256 private _marketingFee = 0; // no marketing function
659     uint256 private _liquidityFee = 2; // 2% into liquidity
660 
661     uint256 private _previousTaxFee = _taxFee;
662     uint256 private _previousMarketingFee = _marketingFee;
663     uint256 private _previousLiquidityFee = _liquidityFee;
664 
665     address payable private _marketingWalletAddress = payable(0x3Ae55FA22d1CAF3f09D59A2576065C42f1B1EB30);
666 
667     IUniswapV2Router02 public immutable uniswapV2Router;
668     address public immutable uniswapV2Pair;
669 
670     bool inSwapAndLiquify = false;
671     bool public swapAndLiquifyEnabled = true;
672 
673     uint256 private _maxTxAmount = _tTotal;
674     // We will set a minimum amount of tokens to be swapped
675     uint256 private _numTokensSellToAddToLiquidity = 1000000000 * 10**9;
676 
677     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
678     event SwapAndLiquifyEnabledUpdated(bool enabled);
679     event SwapAndLiquify(
680         uint256 tokensSwapped,
681         uint256 ethReceived,
682         uint256 tokensIntoLiqudity
683     );
684 
685     modifier lockTheSwap {
686         inSwapAndLiquify = true;
687         _;
688         inSwapAndLiquify = false;
689     }
690 
691     constructor () public {
692         _rOwned[_msgSender()] = _rTotal;
693 
694         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
695         // Create a uniswap pair for this new token
696         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
697         .createPair(address(this), _uniswapV2Router.WETH());
698 
699         // set the rest of the contract variables
700         uniswapV2Router = _uniswapV2Router;
701 
702         // Exclude owner and this contract from fee
703         _isExcludedFromFee[owner()] = true;
704         _isExcludedFromFee[address(this)] = true;
705         _isExcludedFromFee[_marketingWalletAddress] = true;
706 
707         // BLACKLIST
708         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
709         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
710 
711         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
712         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
713 
714         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
715         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
716 
717         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
718         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
719 
720         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
721         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
722 
723         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
724         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
725 
726         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
727         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
728 
729         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
730         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
731 
732         emit Transfer(address(0), _msgSender(), _tTotal);
733     }
734 
735     function name() public view returns (string memory) {
736         return _name;
737     }
738 
739     function symbol() public view returns (string memory) {
740         return _symbol;
741     }
742 
743     function decimals() public view returns (uint8) {
744         return _decimals;
745     }
746 
747     function totalSupply() public view override returns (uint256) {
748         return _tTotal;
749     }
750 
751     function balanceOf(address account) public view override returns (uint256) {
752         if (_isExcluded[account]) return _tOwned[account];
753         return tokenFromReflection(_rOwned[account]);
754     }
755 
756     function transfer(address recipient, uint256 amount) public override returns (bool) {
757         _transfer(_msgSender(), recipient, amount);
758         return true;
759     }
760 
761     function allowance(address owner, address spender) public view override returns (uint256) {
762         return _allowances[owner][spender];
763     }
764 
765     function approve(address spender, uint256 amount) public override returns (bool) {
766         _approve(_msgSender(), spender, amount);
767         return true;
768     }
769 
770     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
771         _transfer(sender, recipient, amount);
772         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
773         return true;
774     }
775 
776     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
777         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
778         return true;
779     }
780 
781     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
782         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
783         return true;
784     }
785 
786     function isExcludedFromReward(address account) public view returns (bool) {
787         return _isExcluded[account];
788     }
789 
790     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
791         _isExcludedFromFee[account] = excluded;
792     }
793 
794     function totalFees() public view returns (uint256) {
795         return _tFeeTotal;
796     }
797 
798     function deliver(uint256 tAmount) public {
799         address sender = _msgSender();
800         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
801         (uint256 rAmount,,,,,) = _getValues(tAmount);
802         _rOwned[sender] = _rOwned[sender].sub(rAmount);
803         _rTotal = _rTotal.sub(rAmount);
804         _tFeeTotal = _tFeeTotal.add(tAmount);
805     }
806 
807     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
808         require(tAmount <= _tTotal, "Amount must be less than supply");
809         if (!deductTransferFee) {
810             (uint256 rAmount,,,,,) = _getValues(tAmount);
811             return rAmount;
812         } else {
813             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
814             return rTransferAmount;
815         }
816     }
817 
818     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
819         require(rAmount <= _rTotal, "Amount must be less than total reflections");
820         uint256 currentRate =  _getRate();
821         return rAmount.div(currentRate);
822     }
823 
824     function excludeFromReward(address account) external onlyOwner() {
825         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
826         require(!_isExcluded[account], "Account is already excluded");
827         if(_rOwned[account] > 0) {
828             _tOwned[account] = tokenFromReflection(_rOwned[account]);
829         }
830         _isExcluded[account] = true;
831         _excluded.push(account);
832     }
833 
834     function includeInReward(address account) external onlyOwner() {
835         require(_isExcluded[account], "Account is already excluded");
836         for (uint256 i = 0; i < _excluded.length; i++) {
837             if (_excluded[i] == account) {
838                 _excluded[i] = _excluded[_excluded.length - 1];
839                 _tOwned[account] = 0;
840                 _isExcluded[account] = false;
841                 _excluded.pop();
842                 break;
843             }
844         }
845     }
846 
847     function addBotToBlackList(address account) external onlyOwner() {
848         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
849         require(!_isBlackListedBot[account], "Account is already blacklisted");
850         _isBlackListedBot[account] = true;
851         _blackListedBots.push(account);
852     }
853 
854     function removeBotFromBlackList(address account) external onlyOwner() {
855         require(_isBlackListedBot[account], "Account is not blacklisted");
856         for (uint256 i = 0; i < _blackListedBots.length; i++) {
857             if (_blackListedBots[i] == account) {
858                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
859                 _isBlackListedBot[account] = false;
860                 _blackListedBots.pop();
861                 break;
862             }
863         }
864     }
865 
866     function removeAllFee() private {
867         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
868 
869         _previousTaxFee = _taxFee;
870         _previousMarketingFee = _marketingFee;
871         _previousLiquidityFee = _liquidityFee;
872 
873         _taxFee = 0;
874         _marketingFee = 0;
875         _liquidityFee = 0;
876     }
877 
878     function restoreAllFee() private {
879         _taxFee = _previousTaxFee;
880         _marketingFee = _previousMarketingFee;
881         _liquidityFee = _previousLiquidityFee;
882     }
883 
884     function isExcludedFromFee(address account) public view returns(bool) {
885         return _isExcludedFromFee[account];
886     }
887 
888     function _approve(address owner, address spender, uint256 amount) private {
889         require(owner != address(0), "ERC20: approve from the zero address");
890         require(spender != address(0), "ERC20: approve to the zero address");
891 
892         _allowances[owner][spender] = amount;
893         emit Approval(owner, spender, amount);
894     }
895 
896     function _transfer(address sender, address recipient, uint256 amount) private {
897         require(sender != address(0), "ERC20: transfer from the zero address");
898         require(recipient != address(0), "ERC20: transfer to the zero address");
899         require(amount > 0, "Transfer amount must be greater than zero");
900         require(!_isBlackListedBot[sender], "You have no power here!");
901         require(!_isBlackListedBot[recipient], "You have no power here!");
902         require(!_isBlackListedBot[tx.origin], "You have no power here!");
903 
904         if(sender != owner() && recipient != owner()) {
905             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
906             // sorry about that, but sniper bots nowadays are buying multiple times, hope I have something more robust to prevent them to nuke the launch :-(
907             require(balanceOf(recipient).add(amount) <= _maxTxAmount, "Already bought maxTxAmount, wait till check off");
908         }
909 
910         // is the token balance of this contract address over the min number of
911         // tokens that we need to initiate a swap + liquidity lock?
912         // also, don't get caught in a circular liquidity event.
913         // also, don't swap & liquify if sender is uniswap pair.
914         uint256 contractTokenBalance = balanceOf(address(this));
915 
916         if(contractTokenBalance >= _maxTxAmount)
917         {
918             contractTokenBalance = _maxTxAmount;
919         }
920 
921         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
922         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
923             contractTokenBalance = _numTokensSellToAddToLiquidity;
924             //add liquidity
925             swapAndLiquify(contractTokenBalance);
926         }
927 
928         //indicates if fee should be deducted from transfer
929         bool takeFee = true;
930 
931         //if any account belongs to _isExcludedFromFee account then remove the fee
932         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
933             takeFee = false;
934         }
935 
936         //transfer amount, it will take tax and charity fee
937         _tokenTransfer(sender, recipient, amount, takeFee);
938     }
939 
940     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
941         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
942         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
943 
944         // split the contract balance into halves
945         uint256 half = toLiquify.div(2);
946         uint256 otherHalf = toLiquify.sub(half);
947 
948         // capture the contract's current ETH balance.
949         // this is so that we can capture exactly the amount of ETH that the
950         // swap creates, and not make the liquidity event include any ETH that
951         // has been manually sent to the contract
952         uint256 initialBalance = address(this).balance;
953 
954         // swap tokens for ETH
955         uint256 toSwapForEth = half.add(toMarketing);
956         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
957 
958         // how much ETH did we just swap into?
959         uint256 fromSwap = address(this).balance.sub(initialBalance);
960         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
961 
962         // add liquidity to uniswap
963         addLiquidity(otherHalf, newBalance);
964 
965         emit SwapAndLiquify(half, newBalance, otherHalf);
966 
967         sendETHToMarketing(fromSwap.sub(newBalance));
968     }
969 
970     function swapTokensForEth(uint256 tokenAmount) private {
971         // generate the uniswap pair path of token -> weth
972         address[] memory path = new address[](2);
973         path[0] = address(this);
974         path[1] = uniswapV2Router.WETH();
975 
976         _approve(address(this), address(uniswapV2Router), tokenAmount);
977 
978         // make the swap
979         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
980             tokenAmount,
981             0, // accept any amount of ETH
982             path,
983             address(this),
984             block.timestamp
985         );
986     }
987 
988     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
989         // approve token transfer to cover all possible scenarios
990         _approve(address(this), address(uniswapV2Router), tokenAmount);
991 
992         // add the liquidity
993         uniswapV2Router.addLiquidityETH{value: ethAmount}(
994             address(this),
995             tokenAmount,
996             0, // slippage is unavoidable
997             0, // slippage is unavoidable
998             owner(),
999             block.timestamp
1000         );
1001     }
1002 
1003     function sendETHToMarketing(uint256 amount) private {
1004         _marketingWalletAddress.transfer(amount);
1005     }
1006 
1007     // We are exposing these functions to be able to manual swap and send
1008     // in case the token is highly valued and 5M becomes too much
1009     function manualSwap() external onlyOwner() {
1010         uint256 contractBalance = balanceOf(address(this));
1011         swapTokensForEth(contractBalance);
1012     }
1013 
1014     function manualSend() public onlyOwner() {
1015         uint256 contractETHBalance = address(this).balance;
1016         sendETHToMarketing(contractETHBalance);
1017     }
1018 
1019     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1020         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1021     }
1022 
1023     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1024         if(!takeFee)
1025             removeAllFee();
1026 
1027         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1028             _transferFromExcluded(sender, recipient, amount);
1029         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1030             _transferToExcluded(sender, recipient, amount);
1031         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1032             _transferStandard(sender, recipient, amount);
1033         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1034             _transferBothExcluded(sender, recipient, amount);
1035         } else {
1036             _transferStandard(sender, recipient, amount);
1037         }
1038 
1039         if(!takeFee)
1040             restoreAllFee();
1041     }
1042 
1043     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1044         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1045         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1046         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1047         _takeMarketingLiquidity(tMarketingLiquidity);
1048         _reflectFee(rFee, tFee);
1049         emit Transfer(sender, recipient, tTransferAmount);
1050     }
1051 
1052     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1053         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1054         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1055         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1056         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1057         _takeMarketingLiquidity(tMarketingLiquidity);
1058         _reflectFee(rFee, tFee);
1059         emit Transfer(sender, recipient, tTransferAmount);
1060     }
1061 
1062     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1063         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1064         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1065         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1066         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1067         _takeMarketingLiquidity(tMarketingLiquidity);
1068         _reflectFee(rFee, tFee);
1069         emit Transfer(sender, recipient, tTransferAmount);
1070     }
1071 
1072     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1073         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1074         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1075         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1076         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1077         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1078         _takeMarketingLiquidity(tMarketingLiquidity);
1079         _reflectFee(rFee, tFee);
1080         emit Transfer(sender, recipient, tTransferAmount);
1081     }
1082 
1083     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1084         uint256 currentRate = _getRate();
1085         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1086         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1087         if(_isExcluded[address(this)])
1088             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1089     }
1090 
1091     function _reflectFee(uint256 rFee, uint256 tFee) private {
1092         _rTotal = _rTotal.sub(rFee);
1093         _tFeeTotal = _tFeeTotal.add(tFee);
1094     }
1095 
1096     //to recieve ETH from uniswapV2Router when swapping
1097     receive() external payable {}
1098 
1099     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1100         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1101         uint256 currentRate = _getRate();
1102         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1103         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1104     }
1105 
1106     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1107         uint256 tFee = tAmount.mul(taxFee).div(100);
1108         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1109         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1110         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1111     }
1112 
1113     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1114         uint256 rAmount = tAmount.mul(currentRate);
1115         uint256 rFee = tFee.mul(currentRate);
1116         uint256 rTransferAmount = rAmount.sub(rFee);
1117         return (rAmount, rTransferAmount, rFee);
1118     }
1119 
1120     function _getRate() private view returns(uint256) {
1121         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1122         return rSupply.div(tSupply);
1123     }
1124 
1125     function _getCurrentSupply() private view returns(uint256, uint256) {
1126         uint256 rSupply = _rTotal;
1127         uint256 tSupply = _tTotal;
1128         for (uint256 i = 0; i < _excluded.length; i++) {
1129             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1130             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1131             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1132         }
1133         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1134         return (rSupply, tSupply);
1135     }
1136 
1137     function _getTaxFee() private view returns(uint256) {
1138         return _taxFee;
1139     }
1140 
1141     function _getMaxTxAmount() private view returns(uint256) {
1142         return _maxTxAmount;
1143     }
1144 
1145     function _getETHBalance() public view returns(uint256 balance) {
1146         return address(this).balance;
1147     }
1148 
1149     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1150         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1151         _taxFee = taxFee;
1152     }
1153 
1154     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1155         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1156         _marketingFee = marketingFee;
1157     }
1158 
1159     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1160         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1161         _liquidityFee = liquidityFee;
1162     }
1163 
1164     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1165         require(numTokensSellToAddToLiquidity >= 10**9 , 'numTokensSellToAddToLiquidity should be greater than total 1e9');
1166         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1167     }
1168 
1169     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1170         require(maxTxAmount >= 10**9 , 'maxTxAmount should be greater than total 1e9');
1171         _maxTxAmount = maxTxAmount;
1172     }
1173 
1174     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1175         _approve(address(this), owner(), tokenAmount);
1176         _transfer(address(this), owner(), tokenAmount);
1177     }
1178 }