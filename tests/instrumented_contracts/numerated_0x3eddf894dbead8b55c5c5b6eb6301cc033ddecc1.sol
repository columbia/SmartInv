1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-12
3 */
4 
5 /**
6 
7  * 
8  * 
9  * 
10                                     *
11                                    ***
12                                  *******
13                                **********
14                              *************
15                            *****************
16                           ********************
17                         ***********************
18                        *********EULTRA**********
19                       ***************************
20                         ************************
21                          *********************
22                       *    *****************     *
23                        **   **************     **
24                         ***     *******     ****
25                          ****     ***      ****
26                           *****    *     *****
27                            ******      ******
28                             ****************
29                              **************
30                               ************
31                                **********
32                                 ********
33                                  ******
34                                   ****
35                                    **
36                                    **
37 */
38 
39 //SPDX-License-Identifier: GPL-3.0-or-later
40 pragma solidity ^0.6.12;
41 
42 abstract contract Context {
43     function _msgSender() internal view virtual returns (address payable) {
44         return msg.sender;
45     }
46 
47     function _msgData() internal view virtual returns (bytes memory) {
48         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
49         return msg.data;
50     }
51 }
52 
53 interface IERC20 {
54     /**
55     * @dev Returns the amount of tokens in existence.
56     */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60     * @dev Returns the amount of tokens owned by `account`.
61     */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65     * @dev Moves `amount` tokens from the caller's account to `recipient`.
66     *
67     * Returns a boolean value indicating whether the operation succeeded.
68     *
69     * Emits a {Transfer} event.
70     */
71     function transfer(address recipient, uint256 amount) external returns (bool);
72 
73     /**
74     * @dev Returns the remaining number of tokens that `spender` will be
75     * allowed to spend on behalf of `owner` through {transferFrom}. This is
76     * zero by default.
77     *
78     * This value changes when {approve} or {transferFrom} are called.
79     */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84     *
85     * Returns a boolean value indicating whether the operation succeeded.
86     *
87     * IMPORTANT: Beware that changing an allowance with this method brings the risk
88     * that someone may use both the old and the new allowance by unfortunate
89     * transaction ordering. One possible solution to mitigate this race
90     * condition is to first reduce the spender's allowance to 0 and set the
91     * desired value afterwards:
92     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93     *
94     * Emits an {Approval} event.
95     */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99     * @dev Moves `amount` tokens from `sender` to `recipient` using the
100     * allowance mechanism. `amount` is then deducted from the caller's
101     * allowance.
102     *
103     * Returns a boolean value indicating whether the operation succeeded.
104     *
105     * Emits a {Transfer} event.
106     */
107     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
108 
109     /**
110     * @dev Emitted when `value` tokens are moved from one account (`from`) to
111     * another (`to`).
112     *
113     * Note that `value` may be zero.
114     */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119     * a call to {approve}. `value` is the new allowance.
120     */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 library SafeMath {
125     /**
126     * @dev Returns the addition of two unsigned integers, reverting on
127     * overflow.
128     *
129     * Counterpart to Solidity's `+` operator.
130     *
131     * Requirements:
132     *
133     * - Addition cannot overflow.
134     */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143     * @dev Returns the subtraction of two unsigned integers, reverting on
144     * overflow (when the result is negative).
145     *
146     * Counterpart to Solidity's `-` operator.
147     *
148     * Requirements:
149     *
150     * - Subtraction cannot overflow.
151     */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158     * overflow (when the result is negative).
159     *
160     * Counterpart to Solidity's `-` operator.
161     *
162     * Requirements:
163     *
164     * - Subtraction cannot overflow.
165     */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174     * @dev Returns the multiplication of two unsigned integers, reverting on
175     * overflow.
176     *
177     * Counterpart to Solidity's `*` operator.
178     *
179     * Requirements:
180     *
181     * - Multiplication cannot overflow.
182     */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198     * @dev Returns the integer division of two unsigned integers. Reverts on
199     * division by zero. The result is rounded towards zero.
200     *
201     * Counterpart to Solidity's `/` operator. Note: this function uses a
202     * `revert` opcode (which leaves remaining gas untouched) while Solidity
203     * uses an invalid opcode to revert (consuming all remaining gas).
204     *
205     * Requirements:
206     *
207     * - The divisor cannot be zero.
208     */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215     * division by zero. The result is rounded towards zero.
216     *
217     * Counterpart to Solidity's `/` operator. Note: this function uses a
218     * `revert` opcode (which leaves remaining gas untouched) while Solidity
219     * uses an invalid opcode to revert (consuming all remaining gas).
220     *
221     * Requirements:
222     *
223     * - The divisor cannot be zero.
224     */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235     * Reverts when dividing by zero.
236     *
237     * Counterpart to Solidity's `%` operator. This function uses a `revert`
238     * opcode (which leaves remaining gas untouched) while Solidity uses an
239     * invalid opcode to revert (consuming all remaining gas).
240     *
241     * Requirements:
242     *
243     * - The divisor cannot be zero.
244     */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251     * Reverts with custom message when dividing by zero.
252     *
253     * Counterpart to Solidity's `%` operator. This function uses a `revert`
254     * opcode (which leaves remaining gas untouched) while Solidity uses an
255     * invalid opcode to revert (consuming all remaining gas).
256     *
257     * Requirements:
258     *
259     * - The divisor cannot be zero.
260     */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 library Address {
268     /**
269     * @dev Returns true if `account` is a contract.
270     *
271     * [IMPORTANT]
272     * ====
273     * It is unsafe to assume that an address for which this function returns
274     * false is an externally-owned account (EOA) and not a contract.
275     *
276     * Among others, `isContract` will return false for the following
277     * types of addresses:
278     *
279     *  - an externally-owned account
280     *  - a contract in construction
281     *  - an address where a contract will be created
282     *  - an address where a contract lived, but was destroyed
283     * ====
284     */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298     * `recipient`, forwarding all available gas and reverting on errors.
299     *
300     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301     * of certain opcodes, possibly making contracts go over the 2300 gas limit
302     * imposed by `transfer`, making them unable to receive funds via
303     * `transfer`. {sendValue} removes this limitation.
304     *
305     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306     *
307     * IMPORTANT: because control is transferred to `recipient`, care must be
308     * taken to not create reentrancy vulnerabilities. Consider using
309     * {ReentrancyGuard} or the
310     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311     */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321     * @dev Performs a Solidity function call using a low level `call`. A
322     * plain`call` is an unsafe replacement for a function call: use this
323     * function instead.
324     *
325     * If `target` reverts with a revert reason, it is bubbled up by this
326     * function (like regular Solidity function calls).
327     *
328     * Returns the raw returned data. To convert to the expected return value,
329     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330     *
331     * Requirements:
332     *
333     * - `target` must be a contract.
334     * - calling `target` with `data` must not revert.
335     *
336     * _Available since v3.1._
337     */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339         return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344     * `errorMessage` as a fallback revert reason when `target` reverts.
345     *
346     * _Available since v3.1._
347     */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354     * but also transferring `value` wei to `target`.
355     *
356     * Requirements:
357     *
358     * - the calling contract must have an ETH balance of at least `value`.
359     * - the called Solidity function must be `payable`.
360     *
361     * _Available since v3.1._
362     */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369     * with `errorMessage` as a fallback revert reason when `target` reverts.
370     *
371     * _Available since v3.1._
372     */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 contract Ownable is Context {
403     address private _owner;
404     address private _previousOwner;
405     uint256 private _lockTime;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     /**
410     * @dev Initializes the contract setting the deployer as the initial owner.
411     */
412     constructor () internal {
413         address msgSender = _msgSender();
414         _owner = msgSender;
415         emit OwnershipTransferred(address(0), msgSender);
416     }
417 
418     /**
419     * @dev Returns the address of the current owner.
420     */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426     * @dev Throws if called by any account other than the owner.
427     */
428     modifier onlyOwner() {
429         require(_owner == _msgSender(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433     /**
434     * @dev Leaves the contract without owner. It will not be possible to call
435     * `onlyOwner` functions anymore. Can only be called by the current owner.
436     *
437     * NOTE: Renouncing ownership will leave the contract without an owner,
438     * thereby removing any functionality that is only available to the owner.
439     */
440     function renounceOwnership() public virtual onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446     * @dev Transfers ownership of the contract to a new account (`newOwner`).
447     * Can only be called by the current owner.
448     */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454     
455 }
456 
457 interface IUniswapV2Factory {
458     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
459 
460     function feeTo() external view returns (address);
461     function feeToSetter() external view returns (address);
462 
463     function getPair(address tokenA, address tokenB) external view returns (address pair);
464     function allPairs(uint) external view returns (address pair);
465     function allPairsLength() external view returns (uint);
466 
467     function createPair(address tokenA, address tokenB) external returns (address pair);
468 
469     function setFeeTo(address) external;
470     function setFeeToSetter(address) external;
471 }
472 
473 interface IUniswapV2Pair {
474     event Approval(address indexed owner, address indexed spender, uint value);
475     event Transfer(address indexed from, address indexed to, uint value);
476 
477     function name() external pure returns (string memory);
478     function symbol() external pure returns (string memory);
479     function decimals() external pure returns (uint8);
480     function totalSupply() external view returns (uint);
481     function balanceOf(address owner) external view returns (uint);
482     function allowance(address owner, address spender) external view returns (uint);
483 
484     function approve(address spender, uint value) external returns (bool);
485     function transfer(address to, uint value) external returns (bool);
486     function transferFrom(address from, address to, uint value) external returns (bool);
487 
488     function DOMAIN_SEPARATOR() external view returns (bytes32);
489     function PERMIT_TYPEHASH() external pure returns (bytes32);
490     function nonces(address owner) external view returns (uint);
491 
492     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
493 
494     event Mint(address indexed sender, uint amount0, uint amount1);
495     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
496     event Swap(
497         address indexed sender,
498         uint amount0In,
499         uint amount1In,
500         uint amount0Out,
501         uint amount1Out,
502         address indexed to
503     );
504     event Sync(uint112 reserve0, uint112 reserve1);
505 
506     function MINIMUM_LIQUIDITY() external pure returns (uint);
507     function factory() external view returns (address);
508     function token0() external view returns (address);
509     function token1() external view returns (address);
510     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
511     function price0CumulativeLast() external view returns (uint);
512     function price1CumulativeLast() external view returns (uint);
513     function kLast() external view returns (uint);
514 
515     function mint(address to) external returns (uint liquidity);
516     function burn(address to) external returns (uint amount0, uint amount1);
517     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
518     function skim(address to) external;
519     function sync() external;
520 
521     function initialize(address, address) external;
522 }
523 
524 interface IUniswapV2Router01 {
525     function factory() external pure returns (address);
526     function WETH() external pure returns (address);
527 
528     function addLiquidity(
529         address tokenA,
530         address tokenB,
531         uint amountADesired,
532         uint amountBDesired,
533         uint amountAMin,
534         uint amountBMin,
535         address to,
536         uint deadline
537     ) external returns (uint amountA, uint amountB, uint liquidity);
538     function addLiquidityETH(
539         address token,
540         uint amountTokenDesired,
541         uint amountTokenMin,
542         uint amountETHMin,
543         address to,
544         uint deadline
545     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
546     function removeLiquidity(
547         address tokenA,
548         address tokenB,
549         uint liquidity,
550         uint amountAMin,
551         uint amountBMin,
552         address to,
553         uint deadline
554     ) external returns (uint amountA, uint amountB);
555     function removeLiquidityETH(
556         address token,
557         uint liquidity,
558         uint amountTokenMin,
559         uint amountETHMin,
560         address to,
561         uint deadline
562     ) external returns (uint amountToken, uint amountETH);
563     function removeLiquidityWithPermit(
564         address tokenA,
565         address tokenB,
566         uint liquidity,
567         uint amountAMin,
568         uint amountBMin,
569         address to,
570         uint deadline,
571         bool approveMax, uint8 v, bytes32 r, bytes32 s
572     ) external returns (uint amountA, uint amountB);
573     function removeLiquidityETHWithPermit(
574         address token,
575         uint liquidity,
576         uint amountTokenMin,
577         uint amountETHMin,
578         address to,
579         uint deadline,
580         bool approveMax, uint8 v, bytes32 r, bytes32 s
581     ) external returns (uint amountToken, uint amountETH);
582     function swapExactTokensForTokens(
583         uint amountIn,
584         uint amountOutMin,
585         address[] calldata path,
586         address to,
587         uint deadline
588     ) external returns (uint[] memory amounts);
589     function swapTokensForExactTokens(
590         uint amountOut,
591         uint amountInMax,
592         address[] calldata path,
593         address to,
594         uint deadline
595     ) external returns (uint[] memory amounts);
596     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
597     external
598     payable
599     returns (uint[] memory amounts);
600     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
601     external
602     returns (uint[] memory amounts);
603     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
604     external
605     returns (uint[] memory amounts);
606     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
607     external
608     payable
609     returns (uint[] memory amounts);
610 
611     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
612     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
613     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
614     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
615     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
616 }
617 
618 interface IUniswapV2Router02 is IUniswapV2Router01 {
619     function removeLiquidityETHSupportingFeeOnTransferTokens(
620         address token,
621         uint liquidity,
622         uint amountTokenMin,
623         uint amountETHMin,
624         address to,
625         uint deadline
626     ) external returns (uint amountETH);
627     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
628         address token,
629         uint liquidity,
630         uint amountTokenMin,
631         uint amountETHMin,
632         address to,
633         uint deadline,
634         bool approveMax, uint8 v, bytes32 r, bytes32 s
635     ) external returns (uint amountETH);
636 
637     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
638         uint amountIn,
639         uint amountOutMin,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external;
644     function swapExactETHForTokensSupportingFeeOnTransferTokens(
645         uint amountOutMin,
646         address[] calldata path,
647         address to,
648         uint deadline
649     ) external payable;
650     function swapExactTokensForETHSupportingFeeOnTransferTokens(
651         uint amountIn,
652         uint amountOutMin,
653         address[] calldata path,
654         address to,
655         uint deadline
656     ) external;
657 }
658 
659 // Contract implementation
660 contract EthereumUltra is Context, IERC20, Ownable {
661     using SafeMath for uint256;
662     using Address for address;
663 
664     mapping (address => uint256) private _rOwned;
665     mapping (address => uint256) private _tOwned;
666     mapping (address => mapping (address => uint256)) private _allowances;
667 
668     mapping (address => bool) private _isExcludedFromFee;
669 
670     mapping (address => bool) private _isExcluded; // excluded from reward
671     address[] private _excluded;
672     mapping (address => bool) private _isBlackListedBot;
673     address[] private _blackListedBots;
674 
675     uint256 private constant MAX = ~uint256(0);
676 
677     uint256 private _tTotal = 100_000_000_000_000 * 10**12;
678     uint256 private _rTotal = (MAX - (MAX % _tTotal));
679     uint256 private _tFeeTotal;
680 
681     string private _name = 'EthereumUltra';
682     string private _symbol = 'EULTRA';
683     uint8 private _decimals = 9;
684 
685     uint256 private _taxFee = 5; // 5% reflection fee for every holder
686     uint256 private _marketingFee = 2; // 2% marketing
687     uint256 private _liquidityFee = 4; // 4% into liquidity
688 
689     uint256 private _previousTaxFee = _taxFee;
690     uint256 private _previousMarketingFee = _marketingFee;
691     uint256 private _previousLiquidityFee = _liquidityFee;
692 
693     address payable private _marketingWalletAddress = payable(0x5eEf183ADe3A55370962ba004eb7e64EC17d3E15);
694 
695     IUniswapV2Router02 public immutable uniswapV2Router;
696     address public immutable uniswapV2Pair;
697 
698     bool inSwapAndLiquify = false;
699     bool public swapAndLiquifyEnabled = true;
700 
701     uint256 private _maxTxAmount = _tTotal;
702     // We will set a minimum amount of tokens to be swapped
703     uint256 private _numTokensSellToAddToLiquidity = 1000000000 * 10**12;
704 
705     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
706     event SwapAndLiquifyEnabledUpdated(bool enabled);
707     event SwapAndLiquify(
708         uint256 tokensSwapped,
709         uint256 ethReceived,
710         uint256 tokensIntoLiqudity
711     );
712 
713     modifier lockTheSwap {
714         inSwapAndLiquify = true;
715         _;
716         inSwapAndLiquify = false;
717     }
718 
719     constructor () public {
720         _rOwned[_msgSender()] = _rTotal;
721 
722         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
723         // Create a uniswap pair for this new token
724         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
725         .createPair(address(this), _uniswapV2Router.WETH());
726 
727         // set the rest of the contract variables
728         uniswapV2Router = _uniswapV2Router;
729 
730         // Exclude owner and this contract from fee
731         _isExcludedFromFee[owner()] = true;
732         _isExcludedFromFee[address(this)] = true;
733         _isExcludedFromFee[_marketingWalletAddress] = true;
734 
735         // BLACKLIST
736         _isBlackListedBot[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
737         _blackListedBots.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
738 
739         _isBlackListedBot[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
740         _blackListedBots.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
741 
742         _isBlackListedBot[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
743         _blackListedBots.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
744 
745         _isBlackListedBot[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
746         _blackListedBots.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
747 
748         _isBlackListedBot[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
749         _blackListedBots.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
750 
751         _isBlackListedBot[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
752         _blackListedBots.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
753 
754         _isBlackListedBot[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
755         _blackListedBots.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
756 
757         _isBlackListedBot[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
758         _blackListedBots.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
759 
760         emit Transfer(address(0), _msgSender(), _tTotal);
761     }
762 
763     function name() public view returns (string memory) {
764         return _name;
765     }
766 
767     function symbol() public view returns (string memory) {
768         return _symbol;
769     }
770 
771     function decimals() public view returns (uint8) {
772         return _decimals;
773     }
774 
775     function totalSupply() public view override returns (uint256) {
776         return _tTotal;
777     }
778 
779     function balanceOf(address account) public view override returns (uint256) {
780         if (_isExcluded[account]) return _tOwned[account];
781         return tokenFromReflection(_rOwned[account]);
782     }
783 
784     function transfer(address recipient, uint256 amount) public override returns (bool) {
785         _transfer(_msgSender(), recipient, amount);
786         return true;
787     }
788 
789     function allowance(address owner, address spender) public view override returns (uint256) {
790         return _allowances[owner][spender];
791     }
792 
793     function approve(address spender, uint256 amount) public override returns (bool) {
794         _approve(_msgSender(), spender, amount);
795         return true;
796     }
797 
798     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
799         _transfer(sender, recipient, amount);
800         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
801         return true;
802     }
803 
804     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
805         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
806         return true;
807     }
808 
809     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
811         return true;
812     }
813 
814     function isExcludedFromReward(address account) public view returns (bool) {
815         return _isExcluded[account];
816     }
817 
818     function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
819         _isExcludedFromFee[account] = excluded;
820     }
821 
822     function totalFees() public view returns (uint256) {
823         return _tFeeTotal;
824     }
825 
826     function deliver(uint256 tAmount) public {
827         address sender = _msgSender();
828         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
829         (uint256 rAmount,,,,,) = _getValues(tAmount);
830         _rOwned[sender] = _rOwned[sender].sub(rAmount);
831         _rTotal = _rTotal.sub(rAmount);
832         _tFeeTotal = _tFeeTotal.add(tAmount);
833     }
834 
835     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
836         require(tAmount <= _tTotal, "Amount must be less than supply");
837         if (!deductTransferFee) {
838             (uint256 rAmount,,,,,) = _getValues(tAmount);
839             return rAmount;
840         } else {
841             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
842             return rTransferAmount;
843         }
844     }
845 
846     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
847         require(rAmount <= _rTotal, "Amount must be less than total reflections");
848         uint256 currentRate =  _getRate();
849         return rAmount.div(currentRate);
850     }
851 
852     function excludeFromReward(address account) external onlyOwner() {
853         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
854         require(!_isExcluded[account], "Account is already excluded");
855         if(_rOwned[account] > 0) {
856             _tOwned[account] = tokenFromReflection(_rOwned[account]);
857         }
858         _isExcluded[account] = true;
859         _excluded.push(account);
860     }
861 
862     function includeInReward(address account) external onlyOwner() {
863         require(_isExcluded[account], "Account is already excluded");
864         for (uint256 i = 0; i < _excluded.length; i++) {
865             if (_excluded[i] == account) {
866                 _excluded[i] = _excluded[_excluded.length - 1];
867                 _tOwned[account] = 0;
868                 _isExcluded[account] = false;
869                 _excluded.pop();
870                 break;
871             }
872         }
873     }
874 
875     function addBotToBlackList(address account) external onlyOwner() {
876         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
877         require(!_isBlackListedBot[account], "Account is already blacklisted");
878         _isBlackListedBot[account] = true;
879         _blackListedBots.push(account);
880     }
881 
882     function removeBotFromBlackList(address account) external onlyOwner() {
883         require(_isBlackListedBot[account], "Account is not blacklisted");
884         for (uint256 i = 0; i < _blackListedBots.length; i++) {
885             if (_blackListedBots[i] == account) {
886                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
887                 _isBlackListedBot[account] = false;
888                 _blackListedBots.pop();
889                 break;
890             }
891         }
892     }
893 
894     function removeAllFee() private {
895         if(_taxFee == 0 && _marketingFee == 0 && _liquidityFee == 0) return;
896 
897         _previousTaxFee = _taxFee;
898         _previousMarketingFee = _marketingFee;
899         _previousLiquidityFee = _liquidityFee;
900 
901         _taxFee = 0;
902         _marketingFee = 0;
903         _liquidityFee = 0;
904     }
905 
906     function restoreAllFee() private {
907         _taxFee = _previousTaxFee;
908         _marketingFee = _previousMarketingFee;
909         _liquidityFee = _previousLiquidityFee;
910     }
911 
912     function isExcludedFromFee(address account) public view returns(bool) {
913         return _isExcludedFromFee[account];
914     }
915 
916     function _approve(address owner, address spender, uint256 amount) private {
917         require(owner != address(0), "ERC20: approve from the zero address");
918         require(spender != address(0), "ERC20: approve to the zero address");
919 
920         _allowances[owner][spender] = amount;
921         emit Approval(owner, spender, amount);
922     }
923 
924     function _transfer(address sender, address recipient, uint256 amount) private {
925         require(sender != address(0), "ERC20: transfer from the zero address");
926         require(recipient != address(0), "ERC20: transfer to the zero address");
927         require(amount > 0, "Transfer amount must be greater than zero");
928         require(!_isBlackListedBot[sender], "You have no power here!");
929         require(!_isBlackListedBot[recipient], "You have no power here!");
930         require(!_isBlackListedBot[tx.origin], "You have no power here!");
931 
932         if(sender != owner() && recipient != owner()) {
933             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
934             // sorry about that, but sniper bots nowadays are buying multiple times, hope I have something more robust to prevent them to nuke the launch :-(
935             require(balanceOf(recipient).add(amount) <= _maxTxAmount, "Already bought maxTxAmount, wait till check off");
936         }
937 
938         // is the token balance of this contract address over the min number of
939         // tokens that we need to initiate a swap + liquidity lock?
940         // also, don't get caught in a circular liquidity event.
941         // also, don't swap & liquify if sender is uniswap pair.
942         uint256 contractTokenBalance = balanceOf(address(this));
943 
944         if(contractTokenBalance >= _maxTxAmount)
945         {
946             contractTokenBalance = _maxTxAmount;
947         }
948 
949         bool overMinTokenBalance = contractTokenBalance >= _numTokensSellToAddToLiquidity;
950         if (!inSwapAndLiquify && swapAndLiquifyEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
951             contractTokenBalance = _numTokensSellToAddToLiquidity;
952             //add liquidity
953             swapAndLiquify(contractTokenBalance);
954         }
955 
956         //indicates if fee should be deducted from transfer
957         bool takeFee = true;
958 
959         //if any account belongs to _isExcludedFromFee account then remove the fee
960         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
961             takeFee = false;
962         }
963 
964         //transfer amount, it will take tax and charity fee
965         _tokenTransfer(sender, recipient, amount, takeFee);
966     }
967 
968     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
969         uint256 toMarketing = contractTokenBalance.mul(_marketingFee).div(_marketingFee.add(_liquidityFee));
970         uint256 toLiquify = contractTokenBalance.sub(toMarketing);
971 
972         // split the contract balance into halves
973         uint256 half = toLiquify.div(2);
974         uint256 otherHalf = toLiquify.sub(half);
975 
976         // capture the contract's current ETH balance.
977         // this is so that we can capture exactly the amount of ETH that the
978         // swap creates, and not make the liquidity event include any ETH that
979         // has been manually sent to the contract
980         uint256 initialBalance = address(this).balance;
981 
982         // swap tokens for ETH
983         uint256 toSwapForEth = half.add(toMarketing);
984         swapTokensForEth(toSwapForEth); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
985 
986         // how much ETH did we just swap into?
987         uint256 fromSwap = address(this).balance.sub(initialBalance);
988         uint256 newBalance = fromSwap.mul(half).div(toSwapForEth);
989 
990         // add liquidity to uniswap
991         addLiquidity(otherHalf, newBalance);
992 
993         emit SwapAndLiquify(half, newBalance, otherHalf);
994 
995         sendETHToMarketing(fromSwap.sub(newBalance));
996     }
997 
998     function swapTokensForEth(uint256 tokenAmount) private {
999         // generate the uniswap pair path of token -> weth
1000         address[] memory path = new address[](2);
1001         path[0] = address(this);
1002         path[1] = uniswapV2Router.WETH();
1003 
1004         _approve(address(this), address(uniswapV2Router), tokenAmount);
1005 
1006         // make the swap
1007         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1008             tokenAmount,
1009             0, // accept any amount of ETH
1010             path,
1011             address(this),
1012             block.timestamp
1013         );
1014     }
1015 
1016     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1017         // approve token transfer to cover all possible scenarios
1018         _approve(address(this), address(uniswapV2Router), tokenAmount);
1019 
1020         // add the liquidity
1021         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1022             address(this),
1023             tokenAmount,
1024             0, // slippage is unavoidable
1025             0, // slippage is unavoidable
1026             owner(),
1027             block.timestamp
1028         );
1029     }
1030 
1031     function sendETHToMarketing(uint256 amount) private {
1032         _marketingWalletAddress.transfer(amount);
1033     }
1034 
1035     // We are exposing these functions to be able to manual swap and send
1036     // in case the token is highly valued and 5M becomes too much
1037     function manualSwap() external onlyOwner() {
1038         uint256 contractBalance = balanceOf(address(this));
1039         swapTokensForEth(contractBalance);
1040     }
1041 
1042     function manualSend() public onlyOwner() {
1043         uint256 contractETHBalance = address(this).balance;
1044         sendETHToMarketing(contractETHBalance);
1045     }
1046 
1047     function setSwapAndLiquifyEnabled(bool _swapAndLiquifyEnabled) external onlyOwner(){
1048         swapAndLiquifyEnabled = _swapAndLiquifyEnabled;
1049     }
1050 
1051     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1052         if(!takeFee)
1053             removeAllFee();
1054 
1055         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1056             _transferFromExcluded(sender, recipient, amount);
1057         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1058             _transferToExcluded(sender, recipient, amount);
1059         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1060             _transferStandard(sender, recipient, amount);
1061         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1062             _transferBothExcluded(sender, recipient, amount);
1063         } else {
1064             _transferStandard(sender, recipient, amount);
1065         }
1066 
1067         if(!takeFee)
1068             restoreAllFee();
1069     }
1070 
1071     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1072         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1073         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1074         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1075         _takeMarketingLiquidity(tMarketingLiquidity);
1076         _reflectFee(rFee, tFee);
1077         emit Transfer(sender, recipient, tTransferAmount);
1078     }
1079 
1080     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1081         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1082         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1083         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1084         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1085         _takeMarketingLiquidity(tMarketingLiquidity);
1086         _reflectFee(rFee, tFee);
1087         emit Transfer(sender, recipient, tTransferAmount);
1088     }
1089 
1090     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1091         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1092         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1093         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1094         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1095         _takeMarketingLiquidity(tMarketingLiquidity);
1096         _reflectFee(rFee, tFee);
1097         emit Transfer(sender, recipient, tTransferAmount);
1098     }
1099 
1100     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1101         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidity) = _getValues(tAmount);
1102         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1103         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1104         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1105         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1106         _takeMarketingLiquidity(tMarketingLiquidity);
1107         _reflectFee(rFee, tFee);
1108         emit Transfer(sender, recipient, tTransferAmount);
1109     }
1110 
1111     function _takeMarketingLiquidity(uint256 tMarketingLiquidity) private {
1112         uint256 currentRate = _getRate();
1113         uint256 rMarketingLiquidity = tMarketingLiquidity.mul(currentRate);
1114         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketingLiquidity);
1115         if(_isExcluded[address(this)])
1116             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketingLiquidity);
1117     }
1118 
1119     function _reflectFee(uint256 rFee, uint256 tFee) private {
1120         _rTotal = _rTotal.sub(rFee);
1121         _tFeeTotal = _tFeeTotal.add(tFee);
1122     }
1123 
1124     //to recieve ETH from uniswapV2Router when swapping
1125     receive() external payable {}
1126 
1127     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1128         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketingLiquidityFee) = _getTValues(tAmount, _taxFee, _marketingFee.add(_liquidityFee));
1129         uint256 currentRate = _getRate();
1130         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1131         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketingLiquidityFee);
1132     }
1133 
1134     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 marketingLiquidityFee) private pure returns (uint256, uint256, uint256) {
1135         uint256 tFee = tAmount.mul(taxFee).div(100);
1136         uint256 tMarketingLiquidityFee = tAmount.mul(marketingLiquidityFee).div(100);
1137         uint256 tTransferAmount = tAmount.sub(tFee).sub(marketingLiquidityFee);
1138         return (tTransferAmount, tFee, tMarketingLiquidityFee);
1139     }
1140 
1141     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1142         uint256 rAmount = tAmount.mul(currentRate);
1143         uint256 rFee = tFee.mul(currentRate);
1144         uint256 rTransferAmount = rAmount.sub(rFee);
1145         return (rAmount, rTransferAmount, rFee);
1146     }
1147 
1148     function _getRate() private view returns(uint256) {
1149         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1150         return rSupply.div(tSupply);
1151     }
1152 
1153     function _getCurrentSupply() private view returns(uint256, uint256) {
1154         uint256 rSupply = _rTotal;
1155         uint256 tSupply = _tTotal;
1156         for (uint256 i = 0; i < _excluded.length; i++) {
1157             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1158             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1159             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1160         }
1161         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1162         return (rSupply, tSupply);
1163     }
1164 
1165     function _getTaxFee() private view returns(uint256) {
1166         return _taxFee;
1167     }
1168 
1169     function _getMaxTxAmount() private view returns(uint256) {
1170         return _maxTxAmount;
1171     }
1172 
1173     function _getETHBalance() public view returns(uint256 balance) {
1174         return address(this).balance;
1175     }
1176 
1177     function _setTaxFee(uint256 taxFee) external onlyOwner() {
1178         require(taxFee >= 1 && taxFee <= 49, 'taxFee should be in 1 - 49');
1179         _taxFee = taxFee;
1180     }
1181 
1182     function _setMarketingFee(uint256 marketingFee) external onlyOwner() {
1183         require(marketingFee >= 1 && marketingFee <= 49, 'marketingFee should be in 1 - 11');
1184         _marketingFee = marketingFee;
1185     }
1186 
1187     function _setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
1188         require(liquidityFee >= 1 && liquidityFee <= 49, 'liquidityFee should be in 1 - 11');
1189         _liquidityFee = liquidityFee;
1190     }
1191 
1192     function _setNumTokensSellToAddToLiquidity(uint256 numTokensSellToAddToLiquidity) external onlyOwner() {
1193         require(numTokensSellToAddToLiquidity >= 10**12 , 'numTokensSellToAddToLiquidity should be greater than total 1e12');
1194         _numTokensSellToAddToLiquidity = numTokensSellToAddToLiquidity;
1195     }
1196 
1197     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1198         require(maxTxAmount >= 10**12 , 'maxTxAmount should be greater than total 1e12');
1199         _maxTxAmount = maxTxAmount;
1200     }
1201 
1202     function recoverTokens(uint256 tokenAmount) public virtual onlyOwner() {
1203         _approve(address(this), owner(), tokenAmount);
1204         _transfer(address(this), owner(), tokenAmount);
1205     }
1206 }